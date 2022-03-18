/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2021 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * Based on a

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_testing_transform.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 TestingTransformIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	if (fractal->transformCommon.functionEnabledDFalse
			&& aux->i >= fractal->transformCommon.startIterationsD
			&& aux->i < fractal->transformCommon.stopIterationsD1)
	{
		if (fractal->transformCommon.functionEnabledAx) z.x = fabs(z.x);
		if (fractal->transformCommon.functionEnabledAy) z.y = fabs(z.y);
		if (fractal->transformCommon.functionEnabledAzFalse) z.z = fabs(z.z);
	}
	z += fractal->transformCommon.offset000;
	z *= fractal->transformCommon.scale1;
	aux->DE *= fractal->transformCommon.scale1;


	REAL4 zc = z;
	REAL u = pow(zc.x, fractal->transformCommon.int2); // try 2,3,4
	REAL r = u * zc.x + zc.y * zc.y + zc.z * zc.z + fractal->transformCommon.offsetB0;
	r = (r < 0.0f) ? 0.0f : sqrt(r);
	REAL t = u + fractal->transformCommon.offsetC0;
	t = (t < 0.0f) ? 0.0f : sqrt(t);
	t = r - t;


	if (aux->i >= fractal->transformCommon.startIterationsG
			&& aux->i < fractal->transformCommon.stopIterationsG)
		aux->dist = min(aux->dist, t);
	else
		aux->dist = t;

	REAL limit = fractal->transformCommon.offset0;

	if (limit > 0.0f) aux->dist = min(aux->dist, fabs(z.x) - limit);

	REAL limitA = fractal->transformCommon.offsetA0;
	aux->dist = max (aux->dist, fabs(z.z) - limitA);
	aux->dist *= fractal->transformCommon.scaleA1;


	//	z += fractal->transformCommon.offsetA000;

	if (fractal->transformCommon.functionEnabledZcFalse
			&& aux->i >= fractal->transformCommon.startIterationsZc
			&& aux->i < fractal->transformCommon.stopIterationsZc)
		z = zc;

	if (fractal->analyticDE.enabledFalse)
		aux->DE = aux->DE * fractal->analyticDE.scale1 + fractal->analyticDE.offset1;


	return z;
}
