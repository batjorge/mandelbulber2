/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2017 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * spherical fold Parab, coded by mclarekin
 * @reference
 * http://www.fractalforums.com/amazing-box-amazing-surf-and-variations/smooth-spherical-fold/msg101051/#new
 */

/* ### This file has been autogenerated. Remove this line, to prevent override. ### */

#ifndef DOUBLE_PRECISION
void TransfSphericalFoldParabIteration(
	float4 *z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	float m = 1.0f;
	float rr;
	// spherical fold
	if (fractal->transformCommon.functionEnabledSFalse
			&& aux->i >= fractal->transformCommon.startIterationsS
			&& aux->i < fractal->transformCommon.stopIterationsS)
	{
		rr = dot(*z, *z);
		float tempM = rr + fractal->transformCommon.offsetB0;
		m = fractal->transformCommon.maxMinR2factor;
		// if (r2 < 1e-21f) r2 = 1e-21f;
		if (rr < fractal->transformCommon.minR2p25)
		{
			if (fractal->transformCommon.functionEnabledAyFalse && m > tempM) m = tempM + (tempM - m);
			*z *= m;
			aux->DE *= m;
			aux->r_dz *= m;
			aux->color += fractal->mandelbox.color.factorSp1;
		}
		else if (rr < fractal->transformCommon.maxR2d1)
		{

			float m = native_divide(fractal->transformCommon.maxR2d1, rr);
			if (fractal->transformCommon.functionEnabledAyFalse && m > tempM) m = tempM + (tempM - m);
			*z *= m;
			aux->DE *= m;
			aux->r_dz *= m;
			aux->color += fractal->mandelbox.color.factorSp2;
		}
	}
	if (aux->i >= fractal->transformCommon.startIterations
			&& aux->i < fractal->transformCommon.stopIterations)
	{
		rr = dot(*z, *z);
		*z += fractal->mandelbox.offset;
		*z *= fractal->transformCommon.scale;
		aux->DE = mad(aux->DE, fabs(fractal->transformCommon.scale), 1.0f);
		float maxScale = fractal->transformCommon.scale4;
		float midPoint = (maxScale - 1.0f) * 0.5f;
		rr += fractal->transformCommon.offset0;
		float maxR2 = fractal->transformCommon.scale1;
		float halfMax = maxR2 * 0.5f;
		float factor = native_divide(midPoint, (halfMax * halfMax));
		// float m = 1.0f;

		float tempM = rr + fractal->transformCommon.offsetA0;
		if (rr < halfMax)
		{
			m = mad(-factor, (rr * rr), maxScale);
			m = mad(factor, (maxR2 - rr) * (maxR2 - rr), 1.0f);
			if (fractal->transformCommon.functionEnabledAxFalse && m > tempM) m = tempM + (tempM - m);
			*z *= m;
			aux->DE *= m;
			aux->r_dz *= m;
		}
		else if (rr < maxR2)
		{
			m = mad(factor, (maxR2 - rr) * (maxR2 - rr), 1.0f);
			if (fractal->transformCommon.functionEnabledAxFalse && m > tempM) m = tempM + (tempM - m);
			*z *= m;
			aux->DE *= m;
			aux->r_dz *= m;
		}
	}
	*z -= fractal->mandelbox.offset;
	if (aux->i >= fractal->transformCommon.startIterationsA
			&& aux->i < fractal->transformCommon.stopIterationsA)
	{
		aux->actualScale = mad((fabs(aux->actualScale) - 1.0f), fractal->mandelboxVary4D.scaleVary,
			fractal->transformCommon.scaleA1);
		*z *= aux->actualScale;
		aux->DE = mad(aux->DE, fabs(aux->actualScale), 1.0f);
		aux->r_dz *= fabs(aux->actualScale);
	}
}
#else
void TransfSphericalFoldParabIteration(
	double4 *z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	double m = 1.0;
	double rr;
	// spherical fold
	if (fractal->transformCommon.functionEnabledSFalse
			&& aux->i >= fractal->transformCommon.startIterationsS
			&& aux->i < fractal->transformCommon.stopIterationsS)
	{
		rr = dot(*z, *z);
		double tempM = rr + fractal->transformCommon.offsetB0;
		m = fractal->transformCommon.maxMinR2factor;
		// if (r2 < 1e-21) r2 = 1e-21;
		if (rr < fractal->transformCommon.minR2p25)
		{
			if (fractal->transformCommon.functionEnabledAyFalse && m > tempM) m = tempM + (tempM - m);
			*z *= m;
			aux->DE *= m;
			aux->r_dz *= m;
			aux->color += fractal->mandelbox.color.factorSp1;
		}
		else if (rr < fractal->transformCommon.maxR2d1)
		{

			double m = native_divide(fractal->transformCommon.maxR2d1, rr);
			if (fractal->transformCommon.functionEnabledAyFalse && m > tempM) m = tempM + (tempM - m);
			*z *= m;
			aux->DE *= m;
			aux->r_dz *= m;
			aux->color += fractal->mandelbox.color.factorSp2;
		}
	}
	if (aux->i >= fractal->transformCommon.startIterations
			&& aux->i < fractal->transformCommon.stopIterations)
	{
		rr = dot(*z, *z);
		*z += fractal->mandelbox.offset;
		*z *= fractal->transformCommon.scale;
		aux->DE = aux->DE * fabs(fractal->transformCommon.scale) + 1.0;
		double maxScale = fractal->transformCommon.scale4;
		double midPoint = (maxScale - 1.0) * 0.5;
		rr += fractal->transformCommon.offset0;
		double maxR2 = fractal->transformCommon.scale1;
		double halfMax = maxR2 * 0.5;
		double factor = native_divide(midPoint, (halfMax * halfMax));
		// double m = 1.0;

		double tempM = rr + fractal->transformCommon.offsetA0;
		if (rr < halfMax)
		{
			m = mad(-factor, (rr * rr), maxScale);
			m = 1.0 + (maxR2 - rr) * (maxR2 - rr) * factor;
			if (fractal->transformCommon.functionEnabledAxFalse && m > tempM) m = tempM + (tempM - m);
			*z *= m;
			aux->DE *= m;
			aux->r_dz *= m;
		}
		else if (rr < maxR2)
		{
			m = 1.0 + (maxR2 - rr) * (maxR2 - rr) * factor;
			if (fractal->transformCommon.functionEnabledAxFalse && m > tempM) m = tempM + (tempM - m);
			*z *= m;
			aux->DE *= m;
			aux->r_dz *= m;
		}
	}
	*z -= fractal->mandelbox.offset;
	if (aux->i >= fractal->transformCommon.startIterationsA
			&& aux->i < fractal->transformCommon.stopIterationsA)
	{
		aux->actualScale = mad((fabs(aux->actualScale) - 1.0), fractal->mandelboxVary4D.scaleVary,
			fractal->transformCommon.scaleA1);
		*z *= aux->actualScale;
		aux->DE = aux->DE * fabs(aux->actualScale) + 1.0;
		aux->r_dz *= fabs(aux->actualScale);
	}
}
#endif
