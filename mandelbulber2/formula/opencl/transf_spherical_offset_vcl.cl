/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2017 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * spherical radial offset Curvilinear.
 */

/* ### This file has been autogenerated. Remove this line, to prevent override. ### */

#ifndef DOUBLE_PRECISION
void TransfSphericalOffsetVCLIteration(
	float4 *z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	float para = fractal->Cpara.para00;
	float paraAdd = 0.0f;
	float paraDot = 0.0f;
	float paraAddP0 = 0.0f;
	// curvilinear mode
	if (fractal->transformCommon.functionEnabled)
	{
		if (fractal->Cpara.enabledLinear)
		{
			para = fractal->Cpara.para00; // parameter value at iter 0
			float temp0 = para;
			float tempA = fractal->Cpara.paraA0;
			float tempB = fractal->Cpara.paraB0;
			float tempC = fractal->Cpara.paraC0;
			float lengthAB = fractal->Cpara.iterB - fractal->Cpara.iterA;
			float lengthBC = fractal->Cpara.iterC - fractal->Cpara.iterB;
			float grade1 = native_divide((tempA - temp0), fractal->Cpara.iterA);
			float grade2 = native_divide((tempB - tempA), lengthAB);
			float grade3 = native_divide((tempC - tempB), lengthBC);

			// slopes
			if (aux->i < fractal->Cpara.iterA)
			{
				para = temp0 + (aux->i * grade1);
			}
			if (aux->i < fractal->Cpara.iterB && aux->i >= fractal->Cpara.iterA)
			{
				para = mad(grade2, (aux->i - fractal->Cpara.iterA), tempA);
			}
			if (aux->i >= fractal->Cpara.iterB)
			{
				para = mad(grade3, (aux->i - fractal->Cpara.iterB), tempB);
			}

			// Curvi part on "true"
			if (fractal->Cpara.enabledCurves)
			{
				// float paraAdd = 0.0f;
				float paraIt;
				if (lengthAB > 2.0f * fractal->Cpara.iterA) // stop  error, todo fix.
				{
					float curve1 = native_divide((grade2 - grade1), (4.0f * fractal->Cpara.iterA));
					float tempL = lengthAB - fractal->Cpara.iterA;
					float curve2 = native_divide((grade3 - grade2), (4.0f * tempL));
					if (aux->i < 2 * fractal->Cpara.iterA)
					{
						paraIt = tempA - fabs(tempA - aux->i);
						paraAdd = paraIt * paraIt * curve1;
					}
					if (aux->i >= 2 * fractal->Cpara.iterA && aux->i < fractal->Cpara.iterB + tempL)
					{
						paraIt = tempB - fabs(tempB * aux->i);
						paraAdd = paraIt * paraIt * curve2;
					}
				}
				para += paraAdd;
			}
		}
	}
	// Parabolic
	// float paraAddP0 = 0.0f;
	if (fractal->Cpara.enabledParabFalse)
	{ // parabolic = paraOffset + iter *slope + (iter *iter *scale)
		paraAddP0 = fractal->Cpara.parabOffset0 + (aux->i * fractal->Cpara.parabSlope)
								+ (aux->i * aux->i * 0.001f * fractal->Cpara.parabScale);
		para += paraAddP0;
	}

	// using the parameter
	// *z *= 1.0f + native_divide(para, dot(-*z, *z));

	if (fractal->transformCommon.functionEnabledFalse)
	{
		paraDot = fractal->transformCommon.offset0;
		para += paraDot;
	}

	*z *= 1.0f + native_divide(para, dot(-*z, *z));
	// post scale
	*z *= fractal->transformCommon.scale;
	aux->DE = mad(aux->DE, fabs(fractal->transformCommon.scale), 1.0f);
	aux->r_dz *= fabs(fractal->transformCommon.scale);

	aux->DE = mad(
		aux->DE, fractal->analyticDE.scale1, fractal->analyticDE.offset0); // DE tweak  or aux->DE +=
}
#else
void TransfSphericalOffsetVCLIteration(
	double4 *z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	double para = fractal->Cpara.para00;
	double paraAdd = 0.0;
	double paraDot = 0.0;
	double paraAddP0 = 0.0;
	// curvilinear mode
	if (fractal->transformCommon.functionEnabled)
	{
		if (fractal->Cpara.enabledLinear)
		{
			para = fractal->Cpara.para00; // parameter value at iter 0
			double temp0 = para;
			double tempA = fractal->Cpara.paraA0;
			double tempB = fractal->Cpara.paraB0;
			double tempC = fractal->Cpara.paraC0;
			double lengthAB = fractal->Cpara.iterB - fractal->Cpara.iterA;
			double lengthBC = fractal->Cpara.iterC - fractal->Cpara.iterB;
			double grade1 = native_divide((tempA - temp0), fractal->Cpara.iterA);
			double grade2 = native_divide((tempB - tempA), lengthAB);
			double grade3 = native_divide((tempC - tempB), lengthBC);

			// slopes
			if (aux->i < fractal->Cpara.iterA)
			{
				para = temp0 + (aux->i * grade1);
			}
			if (aux->i < fractal->Cpara.iterB && aux->i >= fractal->Cpara.iterA)
			{
				para = mad(grade2, (aux->i - fractal->Cpara.iterA), tempA);
			}
			if (aux->i >= fractal->Cpara.iterB)
			{
				para = mad(grade3, (aux->i - fractal->Cpara.iterB), tempB);
			}

			// Curvi part on "true"
			if (fractal->Cpara.enabledCurves)
			{
				// double paraAdd = 0.0;
				double paraIt;
				if (lengthAB > 2.0 * fractal->Cpara.iterA) // stop  error, todo fix.
				{
					double curve1 = native_divide((grade2 - grade1), (4.0 * fractal->Cpara.iterA));
					double tempL = lengthAB - fractal->Cpara.iterA;
					double curve2 = native_divide((grade3 - grade2), (4.0 * tempL));
					if (aux->i < 2 * fractal->Cpara.iterA)
					{
						paraIt = tempA - fabs(tempA - aux->i);
						paraAdd = paraIt * paraIt * curve1;
					}
					if (aux->i >= 2 * fractal->Cpara.iterA && aux->i < fractal->Cpara.iterB + tempL)
					{
						paraIt = tempB - fabs(tempB * aux->i);
						paraAdd = paraIt * paraIt * curve2;
					}
				}
				para += paraAdd;
			}
		}
	}
	// Parabolic
	// double paraAddP0 = 0.0;
	if (fractal->Cpara.enabledParabFalse)
	{ // parabolic = paraOffset + iter *slope + (iter *iter *scale)
		paraAddP0 = fractal->Cpara.parabOffset0 + (aux->i * fractal->Cpara.parabSlope)
								+ (aux->i * aux->i * 0.001 * fractal->Cpara.parabScale);
		para += paraAddP0;
	}

	// using the parameter
	// *z *= 1.0 + native_divide(para, dot(-*z, *z));

	if (fractal->transformCommon.functionEnabledFalse)
	{
		paraDot = fractal->transformCommon.offset0;
		para += paraDot;
	}

	*z *= 1.0 + native_divide(para, dot(-*z, *z));
	// post scale
	*z *= fractal->transformCommon.scale;
	aux->DE = aux->DE * fabs(fractal->transformCommon.scale) + 1.0;
	aux->r_dz *= fabs(fractal->transformCommon.scale);

	aux->DE = mad(
		aux->DE, fractal->analyticDE.scale1, fractal->analyticDE.offset0); // DE tweak  or aux->DE +=
}
#endif
