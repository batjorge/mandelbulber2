/**
 * Mandelbulber v2, a 3D fractal generator       ,=#MKNmMMKmmßMNWy,
 *                                             ,B" ]L,,p%%%,,,§;, "K
 * Copyright (C) 2017-18 Mandelbulber Team     §R-==%w["'~5]m%=L.=~5N
 *                                        ,=mm=§M ]=4 yJKA"/-Nsaj  "Bw,==,,
 * This file is part of Mandelbulber.    §R.r= jw",M  Km .mM  FW ",§=ß., ,TN
 *                                     ,4R =%["w[N=7]J '"5=],""]]M,w,-; T=]M
 * Mandelbulber is free software:     §R.ß~-Q/M=,=5"v"]=Qf,'§"M= =,M.§ Rz]M"Kw
 * you can redistribute it and/or     §w "xDY.J ' -"m=====WeC=\ ""%""y=%"]"" §
 * modify it under the terms of the    "§M=M =D=4"N #"%==A%p M§ M6  R' #"=~.4M
 * GNU General Public License as        §W =, ][T"]C  §  § '§ e===~ U  !§[Z ]N
 * published by the                    4M",,Jm=,"=e~  §  §  j]]""N  BmM"py=ßM
 * Free Software Foundation,          ]§ T,M=& 'YmMMpM9MMM%=w=,,=MT]M m§;'§,
 * either version 3 of the License,    TWw [.j"5=~N[=§%=%W,T ]R,"=="Y[LFT ]N
 * or (at your option)                   TW=,-#"%=;[  =Q:["V""  ],,M.m == ]N
 * any later version.                      J§"mr"] ,=,," =="""J]= M"M"]==ß"
 *                                          §= "=C=4 §"eM "=B:m|4"]#F,§~
 * Mandelbulber is distributed in            "9w=,,]w em%wJ '"~" ,=,,ß"
 * the hope that it will be useful,                 . "K=  ,=RMMMßM"""
 * but WITHOUT ANY WARRANTY;                            .'''
 * without even the implied warranty
 * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *
 * See the GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License
 * along with Mandelbulber. If not, see <http://www.gnu.org/licenses/>.
 *
 * ###########################################################################
 *
 * Authors: Krzysztof Marczak (buddhi1980@gmail.com), Robert Pancoast (RobertPancoast77@gmail.com)
 *
 *  Created on: 3 maj 2017
 *      Author: krzysztof
 */

#include "opencl_engine.h"

#include <iostream>
#include <sstream>

#include "error_message.hpp"
#include "opencl_hardware.h"
#include "parameters.hpp"
#include "system.hpp"

cOpenClEngine::cOpenClEngine(cOpenClHardware *_hardware) : QObject(_hardware), hardware(_hardware)
{
#ifdef USE_OPENCL
	programsLoaded = false;
	readyForRendering = false;
	kernelCreated = false;
	locked = false;
	useBuildCache = true;
	useFastRelaxedMath = false;

	clKernels.append(QSharedPointer<cl::Kernel>());
	clQueues.append(QSharedPointer<cl::CommandQueue>());
	outputBuffers.append(listOfBuffers());
	inputAndOutputBuffers.append(listOfBuffers());

#endif

	connect(this, SIGNAL(showErrorMessage(QString, cErrorMessage::enumMessageType, QWidget *)),
		gErrorMessage, SLOT(slotShowMessage(QString, cErrorMessage::enumMessageType, QWidget *)));
}

cOpenClEngine::~cOpenClEngine()
{
#ifdef USE_OPENCL
#endif
}

#ifdef USE_OPENCL

bool cOpenClEngine::checkErr(cl_int err, QString functionName)
{
	if (err != CL_SUCCESS)
	{
		qCritical() << "OpenCl ERROR: " << functionName << " (" << err << ")";
		return false;
	}
	else
		return true;
}

bool cOpenClEngine::Build(const QByteArray &programString, QString *errorText)
{
	if (hardware->getClDevices(0).size() > 0 && hardware->getEnabledDevices().size() > 0)
	{
		// calculating hash code of the program
		QCryptographicHash hashCryptProgram(QCryptographicHash::Md4);
		hashCryptProgram.addData(programString);
		QByteArray hashProgram = hashCryptProgram.result();

		// calculating hash code of build parameters
		QCryptographicHash hashCryptBuildParams(QCryptographicHash::Md4);
		hashCryptBuildParams.addData(definesCollector.toLocal8Bit());
		QByteArray hashBuildParams = hashCryptBuildParams.result();

		definesCollector += " -DCODEHASH=" + QString(hashProgram.toHex());

		if (!useBuildCache) DeleteKernelCache();

		// if program is different than in previous run
		if (!(hashProgram == lastProgramHash && hashBuildParams == lastBuildParametersHash
					&& useBuildCache))
		{
			lastBuildParametersHash = hashBuildParams;
			lastProgramHash = hashProgram;

			// collecting all parts of program
			cl::Program::Sources sources;
			sources.emplace_back(programString.constData(), size_t(programString.length()));

			// creating cl::Program
			cl_int err;

			// Creates a program from source strings and Context.
			// Context initialized with support for multiple devices.
			// Therefore cl::Program initialized with device vector
			// Does not compile or link the program.

			clPrograms.clear();
			for (int d = 0; d < hardware->getEnabledDevices().size(); d++)
			{
				clPrograms.append(
					QSharedPointer<cl::Program>(new cl::Program(*hardware->getContext(d), sources, &err)));
			}

			if (checkErr(err, "cl::Program()"))
			{
				std::string buildParams =
					"-w -cl-single-precision-constant -cl-denorms-are-zero -cl-mad-enable";

				if (useFastRelaxedMath) buildParams += " -cl-fast-relaxed-math";

				buildParams.append(" -DOPENCL_KERNEL_CODE");

				buildParams += definesCollector.toUtf8().constData();

				WriteLogString("Build parameters", buildParams.c_str(), 2);

				// cl::Program::Build (compiles and links) a multi-device program executable
				// compiles and links for multiple devices simultaneously

				for (int d = 0; d < hardware->getEnabledDevices().size(); d++)
				{
					err = clPrograms[d]->build(hardware->getClDevices(d), buildParams.c_str());
				}

				if (checkErr(err, "program->build()"))
				{
					WriteLog("OpenCl kernel program successfully compiled", 2);
					return true;
				}
				else
				{
					std::stringstream errorMessageStream;
					for (int d = 0; d < hardware->getEnabledDevices().size(); d++)
					{
						errorMessageStream << "Device #" << d << "\nOpenCL Build log:\n"
															 << clPrograms[d]->getBuildInfo<CL_PROGRAM_BUILD_LOG>(
																		*hardware->getEnabledDevices().at(d))
															 << std::endl;
					}
					std::string buildLogText = errorMessageStream.str();

					*errorText = QString::fromStdString(errorMessageStream.str());

					std::cerr << buildLogText;

					emit showErrorMessage(
						QObject::tr("Error during compilation of OpenCL program\n") + errorText->left(500),
						cErrorMessage::errorMessage, nullptr);

					lastBuildParametersHash.clear();
					lastProgramHash.clear();

					return false;
				}
			}
			else
			{
				emit showErrorMessage(
					QObject::tr("OpenCL %1 cannot be created!").arg(QObject::tr("program")),
					cErrorMessage::errorMessage, nullptr);
				return false;
			}
		}
		else
		{
			WriteLog("Re-compile is not needed", 2);
			return true;
		}
	}
	else
	{
		emit showErrorMessage(QObject::tr("No devices to use for OpenCL! Check program preferences."),
			cErrorMessage::errorMessage, nullptr);
		return false;
	}
}

bool cOpenClEngine::CreateKernel4Program(const cParameterContainer *params)
{
	if (programsLoaded)
	{
		optimalJob.jobSizeMultiplier = params->Get<int>("opencl_job_size_multiplier");

		// TODO: kernel
		if (CreateKernels())
		{
			InitOptimalJob(params);
			return true;
		}
	}
	return false;
}

bool cOpenClEngine::CreateKernels()
{
	cl_int err;
	clKernels.clear();
	bool wasNoError = true;

	for (int d = 0; d < hardware->getEnabledDevices().size(); d++)
	{
		clKernels.append(QSharedPointer<cl::Kernel>(
			new cl::Kernel(*clPrograms[d].data(), GetKernelName().toLatin1().constData(), &err)));

		if (!checkErr(err, QString("Device #%1: cl::Kernel()").arg(d))) wasNoError = false;
	}

	if (wasNoError)
	{
		size_t workGroupSize = 0;

		// sets values for optimalJob
		// TODO: support multiple devices
		// TODO: create a optimalJob per device
		// iterate through getEnabledDevices
		// kernel->getWorkGroupInfo  workGroupSize

		for (int d = 0; d < hardware->getEnabledDevices().size(); d++)
		{
			clKernels[d]->getWorkGroupInfo(
				*hardware->getEnabledDevices().at(d), CL_KERNEL_WORK_GROUP_SIZE, &workGroupSize);

			WriteLogInt("Get info for device", d, 2);
			WriteLogSizeT("CL_KERNEL_WORK_GROUP_SIZE", workGroupSize, 2);

			size_t workGroupSizeOptimalMultiplier = 0;

			// TODO: support multiple devices
			// kernel->getWorkGroupInfo  workGroupSizeOptimalMultiplier
			clKernels[d]->getWorkGroupInfo(*hardware->getEnabledDevices().at(d),
				CL_KERNEL_PREFERRED_WORK_GROUP_SIZE_MULTIPLE, &workGroupSizeOptimalMultiplier);
			WriteLogSizeT(
				"CL_KERNEL_PREFERRED_WORK_GROUP_SIZE_MULTIPLE", workGroupSizeOptimalMultiplier, 2);

			if (d == 0)
			{
				optimalJob.workGroupSize = workGroupSize;
				optimalJob.workGroupSizeOptimalMultiplier =
					workGroupSizeOptimalMultiplier * optimalJob.jobSizeMultiplier;
			}
			else
			{
				optimalJob.workGroupSize = min(qint64(workGroupSize), optimalJob.workGroupSize);
				optimalJob.workGroupSizeOptimalMultiplier =
					max(qint64(workGroupSizeOptimalMultiplier * optimalJob.jobSizeMultiplier),
						optimalJob.workGroupSizeOptimalMultiplier);
				;
			}
		}

		kernelCreated = true;
		return true;
	}
	else
	{
		emit showErrorMessage(QObject::tr("OpenCL %1 cannot be created!").arg(QObject::tr("kernel")),
			cErrorMessage::errorMessage, nullptr);
		kernelCreated = false;
	}
	return false;
}

void cOpenClEngine::InitOptimalJob(const cParameterContainer *params)
{
	size_t width = params->Get<int>("image_width");
	size_t height = params->Get<int>("image_height");
	size_t memoryLimitByUser = params->Get<int>("opencl_memory_limit") * 1024 * 1024;
	size_t pixelCnt = width * height;

	// TODO: support multi-GPU
	// TODO: create a optimalJob per device
	// iterate through getSelectedDevicesInformation
	// requires deviceInfo.maxMemAllocSize for each device
	// for now, we use the same optimal job for all GPU
	// we will enable multi-gpu, but require the exact same gpu model
	// *this requires update*
	cOpenClDevice::sDeviceInformation deviceInfo = hardware->getSelectedDevicesInformation().at(0);

	optimalJob.stepSize = optimalJob.workGroupSize * optimalJob.workGroupSizeOptimalMultiplier;

	int exp = log(sqrt(optimalJob.stepSize + 1)) / log(2);

	optimalJob.stepSizeX = pow(2, exp);
	optimalJob.stepSizeY = optimalJob.stepSize / optimalJob.stepSizeX;

	//	optimalJob.stepSizeX = 1;
	//	optimalJob.stepSizeY = 1;

	optimalJob.workGroupSizeMultiplier = optimalJob.workGroupSizeOptimalMultiplier;
	optimalJob.lastProcessingTime = 1.0;

	size_t maxAllocMemSize = deviceInfo.maxMemAllocSize;
	size_t memSize = memoryLimitByUser;
	if (maxAllocMemSize > 0 && maxAllocMemSize * 0.75 < memoryLimitByUser)
	{
		memSize = maxAllocMemSize * 0.75;
	}
	if (optimalJob.sizeOfPixel != 0)
	{
		optimalJob.jobSizeLimit = memSize / optimalJob.sizeOfPixel;
	}
	else
	{
		optimalJob.jobSizeLimit = pixelCnt;
	}

	WriteLogSizeT("cOpenClEngine::InitOptimalJob(): stepSize", optimalJob.stepSize, 2);
	WriteLogSizeT("cOpenClEngine::InitOptimalJob(): stepSizeX", optimalJob.stepSizeX, 2);
	WriteLogSizeT("cOpenClEngine::InitOptimalJob(): stepSizeY", optimalJob.stepSizeY, 2);
}

bool cOpenClEngine::CreateCommandQueue()
{
	if (hardware->ContextCreated())
	{
		cl_int err;
		bool wasNoError = true;
		// TODO: support multiple devices
		// TODO: create a separate queue per device
		// iterate through getEnabledDevices
		clQueues.clear();

		for (int d = 0; d < hardware->getEnabledDevices().size(); d++)
		{
			clQueues.append(
				QSharedPointer<cl::CommandQueue>(new cl::CommandQueue(*hardware->getContext(d),
					*hardware->getEnabledDevices().at(d), CL_QUEUE_OUT_OF_ORDER_EXEC_MODE_ENABLE, &err)));

			if (!checkErr(err, QString("Device #%1: cl::CommandQueue()").arg(d))) wasNoError = false;
		}

		if (wasNoError)
		{
			readyForRendering = true;
			return true;
		}
		else
		{
			emit showErrorMessage(
				QObject::tr("OpenCL %1 cannot be created!").arg(QObject::tr("command queue")),
				cErrorMessage::errorMessage, nullptr);
			readyForRendering = false;
			return false;
		}
	}
	return false;
}

void cOpenClEngine::UpdateOptimalJobStart(size_t pixelsLeft)
{
	optimalJob.timer.restart();
	optimalJob.timer.start();
	double processingCycleTime = optimalJob.optimalProcessingCycle;

	optimalJob.workGroupSizeMultiplier *= processingCycleTime / optimalJob.lastProcessingTime;

	qint64 maxWorkGroupSizeMultiplier = pixelsLeft / optimalJob.workGroupSize;

	if (optimalJob.workGroupSizeMultiplier > maxWorkGroupSizeMultiplier)
		optimalJob.workGroupSizeMultiplier = maxWorkGroupSizeMultiplier;

	if (optimalJob.workGroupSizeMultiplier * optimalJob.workGroupSize > optimalJob.jobSizeLimit)
		optimalJob.workGroupSizeMultiplier = optimalJob.jobSizeLimit / optimalJob.workGroupSize;

	if (optimalJob.workGroupSizeMultiplier < optimalJob.workGroupSizeOptimalMultiplier)
		optimalJob.workGroupSizeMultiplier = optimalJob.workGroupSizeOptimalMultiplier;

	optimalJob.stepSize = optimalJob.workGroupSizeMultiplier * optimalJob.workGroupSize;

	//	qDebug() << "lastProcessingTime" << optimalJob.lastProcessingTime;
	//	qDebug() << "stepSize:" << optimalJob.stepSize;
}

void cOpenClEngine::Reset()
{
	lastBuildParametersHash.clear();
	lastProgramHash.clear();
	definesCollector.clear();
}

void cOpenClEngine::UpdateOptimalJobEnd()
{
	optimalJob.lastProcessingTime = optimalJob.timer.nsecsElapsed() / 1e9;
}

void cOpenClEngine::Lock()
{
	locked = true;
	lock.lock();
}

void cOpenClEngine::Unlock()
{

	lock.unlock();

	locked = false;
}

void cOpenClEngine::DeleteKernelCache()
{
// Delete NVIDIA driver build cache
#ifdef _WIN32
	QDir dir(QDir::homePath() + "/AppData/Roaming/NVIDIA/ComputeCache/");
#else
	QDir dir(QDir::homePath() + "/.nv/ComputeCache/");
#endif
	if (dir.exists()) dir.removeRecursively();
	if (!dir.exists()) QDir().mkdir(dir.absolutePath());
}

bool cOpenClEngine::PreAllocateBuffers(const cParameterContainer *params)
{
	ReleaseMemory();
	RegisterInputOutputBuffers(params);

	cl_int err;

	if (hardware->ContextCreated())
	{

		for (int d = 0; d < inputAndOutputBuffers.size(); d++)
		{
			for (auto &inputAndOutputBuffer : inputAndOutputBuffers[d])
			{
				inputAndOutputBuffer.ptr.reset(
					new char[inputAndOutputBuffer.size()], sClInputOutputBuffer::Deleter);
				inputAndOutputBuffer.clPtr.reset(
					new cl::Buffer(*hardware->getContext(d), CL_MEM_READ_WRITE | CL_MEM_COPY_HOST_PTR,
						inputAndOutputBuffer.size(), inputAndOutputBuffer.ptr.data(), &err));
				if (!checkErr(err, "new cl::Buffer(...) for " + inputAndOutputBuffer.name))
				{
					emit showErrorMessage(
						QObject::tr("OpenCL %1 cannot be created!").arg(inputAndOutputBuffer.name),
						cErrorMessage::errorMessage, nullptr);
					return false;
				}
			}
		}

		for (int d = 0; d < outputBuffers.size(); d++)
		{
			for (auto &outputBuffer : outputBuffers[d])
			{
				outputBuffer.ptr.reset(new char[outputBuffer.size()], sClInputOutputBuffer::Deleter);
				outputBuffer.clPtr.reset(
					new cl::Buffer(*hardware->getContext(d), CL_MEM_WRITE_ONLY | CL_MEM_USE_HOST_PTR,
						outputBuffer.size(), outputBuffer.ptr.data(), &err));
				if (!checkErr(err, "new cl::Buffer(...) for " + outputBuffer.name))
				{
					emit showErrorMessage(QObject::tr("OpenCL %1 cannot be created!").arg(outputBuffer.name),
						cErrorMessage::errorMessage, nullptr);
					return false;
				}
			}
		}

		for (int d = 0; d < inputBuffers.size(); d++)
		{
			for (auto &inputBuffer : inputBuffers[d])
			{
				inputBuffer.ptr.reset(new char[inputBuffer.size()], sClInputOutputBuffer::Deleter);
				inputBuffer.clPtr.reset(
					new cl::Buffer(*hardware->getContext(d), CL_MEM_READ_ONLY | CL_MEM_USE_HOST_PTR,
						inputBuffer.size(), inputBuffer.ptr.data(), &err));
				if (!checkErr(err, "new cl::Buffer(...) for " + inputBuffer.name))
				{
					emit showErrorMessage(QObject::tr("OpenCL %1 cannot be created!").arg(inputBuffer.name),
						cErrorMessage::errorMessage, nullptr);
					return false;
				}
			}
		}
	}
	else
	{
		emit showErrorMessage(
			QObject::tr("OpenCL context is not ready"), cErrorMessage::errorMessage, nullptr);
		return false;
	}

	return true;
}

void cOpenClEngine::ReleaseMemory()
{
	for (int i = 0; i < outputBuffers.size(); i++)
	{
		for (auto &outputBuffer : outputBuffers[i])
		{
			outputBuffer.ptr.reset();
			outputBuffer.clPtr.reset();
		}
		outputBuffers[i].clear();
	}

	for (auto &inputBuffer : inputBuffers)
	{
		inputBuffer[0].ptr.reset();
		inputBuffer[0].clPtr.reset();
	}
	inputBuffers.clear();

	for (int i = 0; i < inputAndOutputBuffers.size(); i++)
	{
		for (auto &inputAndOutputBuffer : inputAndOutputBuffers[i])
		{
			inputAndOutputBuffer.ptr.reset();
			inputAndOutputBuffer.clPtr.reset();
		}
		inputAndOutputBuffers[i].clear();
	}
}

bool cOpenClEngine::WriteBuffersToQueue()
{
	for (int d = 0; d < hardware->getEnabledDevices().size(); d++)
	{
		for (auto &inputBuffer : inputBuffers)
		{
			cl_int err = clQueues[d]->enqueueWriteBuffer(
				*inputBuffer[d].clPtr, CL_TRUE, 0, inputBuffer.size(), inputBuffer[d].ptr.data());
			if (!checkErr(err, "CommandQueue::enqueueWriteBuffer(...) for " + inputBuffer[d].name))
			{
				emit showErrorMessage(
					QObject::tr("Cannot enqueue writing OpenCL %1").arg(inputBuffer[d].name),
					cErrorMessage::errorMessage, nullptr);
				return false;
			}
		}

		int err = clQueues[d]->finish();
		if (!checkErr(err, "CommandQueue::finish() - write buffers"))
		{
			emit showErrorMessage(
				QObject::tr("Cannot finish writing OpenCL buffers"), cErrorMessage::errorMessage, nullptr);
			return false;
		}
	}

	for (int d = 0; d < inputAndOutputBuffers.size(); d++)
	{
		for (auto &inputAndOutputBuffer : inputAndOutputBuffers[d])
		{
			cl_int err = clQueues[d]->enqueueWriteBuffer(*inputAndOutputBuffer.clPtr, CL_TRUE, 0,
				inputAndOutputBuffer.size(), inputAndOutputBuffer.ptr.data());
			if (!checkErr(err, "CommandQueue::enqueueWriteBuffer(...) for " + inputAndOutputBuffer.name))
			{
				emit showErrorMessage(
					QObject::tr("Cannot enqueue writing OpenCL %1").arg(inputAndOutputBuffer.name),
					cErrorMessage::errorMessage, nullptr);
				return false;
			}
		}
		int err = clQueues[d]->finish();
		if (!checkErr(err, "CommandQueue::finish() - write buffers"))
		{
			emit showErrorMessage(
				QObject::tr("Cannot finish writing OpenCL buffers"), cErrorMessage::errorMessage, nullptr);
			return false;
		}
	}
	return true;
}

bool cOpenClEngine::ReadBuffersFromQueue(int deviceIndex)
{
	qDebug() << "readStart" << deviceIndex;
	for (auto &outputBuffer : outputBuffers[deviceIndex])
	{
		cl_int err = clQueues[deviceIndex]->enqueueReadBuffer(
			*outputBuffer.clPtr, CL_FALSE, 0, outputBuffer.size(), outputBuffer.ptr.data());
		if (!checkErr(err, "CommandQueue::enqueueReadBuffer() for " + outputBuffer.name))
		{
			emit showErrorMessage(
				QObject::tr("Cannot enqueue reading OpenCL buffers %1").arg(outputBuffer.name),
				cErrorMessage::errorMessage, nullptr);
			return false;
		}
	}

	if (deviceIndex < inputAndOutputBuffers.size())
	{
		for (auto &inputAndOutputBuffer : inputAndOutputBuffers[deviceIndex])
		{
			cl_int err = clQueues[deviceIndex]->enqueueReadBuffer(*inputAndOutputBuffer.clPtr, CL_FALSE,
				0, inputAndOutputBuffer.size(), inputAndOutputBuffer.ptr.data());
			if (!checkErr(err, "CommandQueue::enqueueReadBuffer() for " + inputAndOutputBuffer.name))
			{
				emit showErrorMessage(
					QObject::tr("Cannot enqueue reading OpenCL buffers %1").arg(inputAndOutputBuffer.name),
					cErrorMessage::errorMessage, nullptr);
				return false;
			}
		}
	}
	qDebug() << "readEnd" << deviceIndex;

	int err = clQueues[deviceIndex]->finish();
	if (!checkErr(err, "CommandQueue::finish() - read buffers"))
	{
		emit showErrorMessage(QObject::tr("Cannot finish reading OpenCL output buffers"),
			cErrorMessage::errorMessage, nullptr);
		return false;
	}
	qDebug() << "readFinished" << deviceIndex;
	return true;
}

bool cOpenClEngine::AssignParametersToKernel(int deviceIndex)
{
	int argIterator = 0;
	for (auto &inputBuffer : inputBuffers)
	{
		int err = clKernels[deviceIndex]->setArg(argIterator++, *inputBuffer[deviceIndex].clPtr);
		if (!checkErr(err, "kernel->setArg(" + QString::number(argIterator) + ") for "
												 + inputBuffer[deviceIndex].name))
		{
			emit showErrorMessage(
				QObject::tr("Cannot set OpenCL argument for %1").arg(inputBuffer[deviceIndex].name),
				cErrorMessage::errorMessage, nullptr);
			return false;
		}
	}
	for (auto &outputBuffer : outputBuffers[deviceIndex])
	{
		int err = clKernels[deviceIndex]->setArg(argIterator++, *outputBuffer.clPtr);
		if (!checkErr(
					err, "kernel->setArg(" + QString::number(argIterator) + ") for " + outputBuffer.name))
		{
			emit showErrorMessage(QObject::tr("Cannot set OpenCL argument for %1").arg(outputBuffer.name),
				cErrorMessage::errorMessage, nullptr);
			return false;
		}
	}
	if (deviceIndex < inputAndOutputBuffers.size())
	{
		for (auto &inputAndOutputBuffer : inputAndOutputBuffers[deviceIndex])
		{
			int err = clKernels[deviceIndex]->setArg(argIterator++, *inputAndOutputBuffer.clPtr);
			if (!checkErr(err, "kernel->setArg(" + QString::number(argIterator) + ") for "
													 + inputAndOutputBuffer.name))
			{
				emit showErrorMessage(
					QObject::tr("Cannot set OpenCL argument for %1").arg(inputAndOutputBuffer.name),
					cErrorMessage::errorMessage, nullptr);
				return false;
			}
		}
	}
	return AssignParametersToKernelAdditional(argIterator, deviceIndex);
}

#endif
