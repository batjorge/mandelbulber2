/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2022 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * TransfDIFSBosFrameIteration  fragmentarium code, mdifs by knighty (jan 2012)
 * and http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_transf_difs_box_frame.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 TransfDIFSBoxFrameIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	// tranform z
	if (fractal->transformCommon.functionEnabledCxFalse
			&& aux->i >= fractal->transformCommon.startIterationsA
			&& aux->i < fractal->transformCommon.stopIterationsA)
	{
		z.y = fabs(z.y);
		REAL psi = M_PI_F / fractal->transformCommon.int8X;
		psi = fabs(fmod(atan2(z.y, z.x) + psi, 2.0f * psi) - psi);
		REAL len = native_sqrt(z.x * z.x + z.y * z.y);
		z.x = native_cos(psi) * len;
		z.y = native_sin(psi) * len;
	}

	if (fractal->transformCommon.functionEnabledCyFalse
			&& aux->i >= fractal->transformCommon.startIterationsB
			&& aux->i < fractal->transformCommon.stopIterationsB)
	{
		z.z = fabs(z.z);
		REAL psi = M_PI_F / fractal->transformCommon.int8Y;
		psi = fabs(fmod(atan2(z.z, z.y) + psi, 2.0f * psi) - psi);
		REAL len = native_sqrt(z.y * z.y + z.z * z.z);
		z.y = native_cos(psi) * len;
		z.z = native_sin(psi) * len;
	}

	if (fractal->transformCommon.functionEnabledCzFalse
			&& aux->i >= fractal->transformCommon.startIterationsC
			&& aux->i < fractal->transformCommon.stopIterationsC)
	{
		z.x = fabs(z.x);
		REAL psi = M_PI_F / fractal->transformCommon.int8Z;
		psi = fabs(fmod(atan2(z.x, z.z) + psi, 2.0f * psi) - psi);
		REAL len = native_sqrt(z.z * z.z + z.x * z.x);
		z.z = native_cos(psi) * len;
		z.x = native_sin(psi) * len;
	}

	if (fractal->transformCommon.functionEnabledDFalse
			&& aux->i >= fractal->transformCommon.startIterationsD
			&& aux->i < fractal->transformCommon.stopIterationsD)
	{
		z = fabs(z - fractal->transformCommon.offset000);
	}

	if (fractal->transformCommon.functionEnabledEFalse
			&& aux->i >= fractal->transformCommon.startIterationsE
			&& aux->i < fractal->transformCommon.stopIterationsE)
	{
		z = fabs(z + fractal->transformCommon.offsetA000)
				- fabs(z - fractal->transformCommon.offsetA000) - z;
	}
	if (aux->i >= fractal->transformCommon.startIterationsS
			&& aux->i < fractal->transformCommon.stopIterationsS)
	{
		z *= fractal->transformCommon.scale1;
		aux->DE *= fabs(fractal->transformCommon.scale1);
	}

	if (fractal->transformCommon.functionEnabledRFalse
			&& aux->i >= fractal->transformCommon.startIterationsR
			&& aux->i < fractal->transformCommon.stopIterationsR)
	{
		z = Matrix33MulFloat4(fractal->transformCommon.rotationMatrix, z);
	}

	REAL4 zc = z;
	zc = Matrix33MulFloat4(fractal->transformCommon.rotationMatrix2, zc);
	zc = fabs(zc) - fractal->transformCommon.offsetC111;
	REAL4 q = (REAL4){fractal->transformCommon.offsetp01, fractal->transformCommon.offsetAp01,
		fractal->transformCommon.offsetBp01, 0.0f};

	if (!fractal->transformCommon.functionEnabledSwFalse)
		q = fabs(zc + q) - q;
	else
		q = fabs(zc) - q;

	REAL4 len = zc;
	len.x = min(max(zc.x, max(q.y, q.z)), 0.0f);
	len.y = min(max(q.x, max(zc.y, q.z)), 0.0f);
	len.z = min(max(q.x, max(q.y, zc.z)), 0.0f);

	REAL4 mz = zc;
	mz.x = max(zc.x, 0.0f);
	mz.y = max(zc.y, 0.0f);
	mz.z = max(zc.z, 0.0f);

	REAL4 mq = q;
	mq.x = max(q.x, 0.0f);
	mq.y = max(q.y, 0.0f);
	mq.z = max(q.z, 0.0f);

	REAL4 tv = ((REAL4){mz.x, mq.y, mq.z, 0.0f});
	len.x += length(tv);
	tv = ((REAL4){mq.x, mz.y, mq.z, 0.0f});
	len.y += length(tv);
	tv = ((REAL4){mq.x, mq.y, mz.z, 0.0f});
	len.z += length(tv);

	REAL D = min(min(len.x, len.y), len.z) / (aux->DE + fractal->analyticDE.offset0);
	REAL colDist = aux->dist;
	if (aux->i >= fractal->transformCommon.startIterationsG
			&& aux->i < fractal->transformCommon.stopIterationsG)
		aux->dist = min(aux->dist, D);
	else
		aux->dist = D;

	if (fractal->foldColor.auxColorEnabledFalse
			&& aux->i >= fractal->foldColor.startIterationsA
			&& aux->i < fractal->foldColor.stopIterationsA)
	{
		if (colDist != aux->dist) aux->color += fractal->foldColor.difs0000.x;
	}

	if (fractal->transformCommon.functionEnabledZcFalse
			&& aux->i >= fractal->transformCommon.startIterationsZc
			&& aux->i < fractal->transformCommon.stopIterationsZc)
		z = zc;
	return z;
}
