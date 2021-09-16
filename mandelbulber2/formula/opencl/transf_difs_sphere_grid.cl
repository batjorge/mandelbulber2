/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2021 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * TransfDIFSSpring

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_transf_difs_spring.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 TransfDIFSSphereGridIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	// addition constant
	z += fractal->transformCommon.additionConstant000;

	z *= fractal->transformCommon.scale1;
	aux->DE *= fabs(fractal->transformCommon.scale1);

	z = Matrix33MulFloat4(fractal->transformCommon.rotationMatrix2, z);

	REAL4 zc = z;

	// swap axis
	if (fractal->transformCommon.functionEnabledSwFalse)
	{
		REAL temp = zc.x;
		zc.x = zc.z;
		zc.z = temp;
	}
	if (fractal->transformCommon.functionEnabledSFalse)
	{
		REAL temp = zc.y;
		zc.y = zc.z;
		zc.z = temp;
	}

	// polyfold
	zc.x = fabs(zc.x);
	REAL psi = M_PI / fractal->transformCommon.int8Z;
	psi = fabs(fmod(atan2(zc.x, zc.y) + psi, 2.0 * psi) - psi);
	REAL len = sqrt(zc.y * zc.y + zc.x * zc.x);
	zc.y = cos(psi) * len;
	zc.x = sin(psi) * len;

	REAL T1 = native_sqrt(zc.y * zc.y + zc.z * zc.z) - fractal->transformCommon.offsetR1;

	if (!fractal->transformCommon.functionEnabledJFalse)
		T1 = native_sqrt(T1 * T1 + zc.x * zc.x) - fractal->transformCommon.offsetp01;
	else
		T1 = max(fabs(T1), fabs(zc.x)) - fractal->transformCommon.offsetp01;

	REAL T2 = 1000.0;
	if (fractal->transformCommon.functionEnabledMFalse)
	{
		T2 = native_sqrt(zc.y * zc.y + zc.x * zc.x) - fractal->transformCommon.offsetR1;
		if (!fractal->transformCommon.functionEnabledNFalse)
			T2 = native_sqrt(T2 * T2 + zc.z * zc.z) - fractal->transformCommon.offsetAp01;
		else
			T2 = max(fabs(T2), fabs(zc.z)) - fractal->transformCommon.offsetAp01;
	}

	REAL T3 = 1000.0;
	if (fractal->transformCommon.functionEnabledOFalse)
	{
		REAL z2 = fractal->transformCommon.offset05;
		REAL z1 = fabs(zc.z) - z2;
		T3 = native_sqrt(zc.y * zc.y + zc.x * zc.x)
				 - native_sqrt(
					 fractal->transformCommon.offsetR1 * fractal->transformCommon.offsetR1 - z2 * z2);

		if (!fractal->transformCommon.functionEnabledPFalse)
			T3 = native_sqrt(T3 * T3 + z1 * z1) - fractal->transformCommon.offsetBp01;
		else
			T3 = max(fabs(T3), fabs(z1)) - fractal->transformCommon.offsetBp01;
	}

	REAL torD = min(T1, T2);

	torD = min(torD, T3);

	REAL colorDist = aux->dist; // for color

	if (!fractal->analyticDE.enabledFalse)
		aux->dist = torD / (aux->DE + fractal->analyticDE.offset1);
	else
		aux->dist = min(aux->dist, torD / (aux->DE + fractal->analyticDE.offset1));

	if (fractal->foldColor.auxColorEnabledA)
	{
		REAL colorAdd = 0.0f;
		if (colorDist != aux->dist) colorAdd += fractal->foldColor.difs1;
		if (T2 != torD && T3 != torD) colorAdd += fractal->foldColor.difs0000.x;
		if (T1 != torD && T3 != torD) colorAdd += fractal->foldColor.difs0000.y;
		if (T3 == torD) colorAdd += fractal->foldColor.difs0000.z;
		aux->color += colorAdd;
	}

	if (fractal->transformCommon.functionEnabledYFalse) z = zc;

	return z;
}
