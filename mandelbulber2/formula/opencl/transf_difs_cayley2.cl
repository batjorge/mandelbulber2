﻿/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2022 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * transfCayley2V1 based on Cayley2IFS
 * @reference
 * http://www.fractalforums.com/mandelbulb-3d/custom-formulas-and-transforms-release-t17106/

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_transf_cayley2_v1.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 TransfDIFSCayley2Iteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL temp;
	if (fractal->transformCommon.functionEnabledFalse
			&& aux->i >= fractal->transformCommon.startIterations
			&& aux->i < fractal->transformCommon.stopIterations1)
	{
		temp = SQRT_1_2_F * (z.x - z.y);
		z.y = SQRT_1_2_F * (z.y + z.x);
		z.x = temp;
	}

	if (fractal->transformCommon.functionEnabledM)
	{
		if (fractal->transformCommon.functionEnabledAx) z.x = fabs(z.x);
		if (fractal->transformCommon.functionEnabledAy) z.y = fabs(z.y);
		if (fractal->transformCommon.functionEnabledAzFalse) z.z = fabs(z.z);
	}

	z += fractal->transformCommon.offset000;

	z *= fractal->transformCommon.scale1;
	aux->DE *= fractal->transformCommon.scale1;

	if (fractal->transformCommon.rotationEnabledFalse
			&& aux->i >= fractal->transformCommon.startIterationsR
			&& aux->i < fractal->transformCommon.stopIterationsR1)
	{
		z = Matrix33MulFloat4(fractal->transformCommon.rotationMatrix, z);
	}

	REAL4 zc = z;
	REAL mx = zc.x * zc.x;
	REAL my = zc.y * zc.y;
	REAL m = fractal->transformCommon.scaleA2 * mx * my + mx * mx + my * my;
	REAL n = m + fractal->transformCommon.scale4 * zc.x * zc.y + 1.0f;
	zc.y = 2.0f * (my - mx) / n;

	if (!fractal->transformCommon.functionEnabledBFalse)
	{
		zc.x = fractal->transformCommon.scale2 * (m - 1.0f) / n;
	}
	else
	{
		zc.x = fractal->transformCommon.scale2 * (m - 1.0f);
	}

	zc.z *= fractal->transformCommon.scaleA1;

//	REAL4 zdv = fabs(zc) - fractal->transformCommon.additionConstant000;
//	REAL zd = min(min(zdv.x, zdv.y), zdv.z);

	zc = fabs(zc) - fractal->transformCommon.offset110;

	REAL4 zcv = zc;
	zcv.x = max(zcv.x, 0.0f);
	zcv.y = max(zcv.y, 0.0f);
	zcv.z = max(zcv.z, 0.0f);
	REAL zcd = length(zcv);

	REAL dxy = sqrt(zc.x * zc.x + zc.y * zc.y) - fractal->transformCommon.radius1;
	REAL dz = fabs(zc.z) - fractal->transformCommon.offset01;
	REAL bxy = max(dxy - fractal->transformCommon.offsetA000.x,
				-fractal->transformCommon.offsetA000.y);
	REAL bz = max(dz - fractal->transformCommon.offsetA000.z, 0.0f);
	REAL mm = max(dxy, dz);
	REAL ll = sqrt(bxy * bxy + bz * bz);
	REAL zcf = min(mm, 0.0f) + ll;

	if (fractal->transformCommon.functionEnabledOFalse)
	{
		REAL4 zdv = fabs(zc) - fractal->transformCommon.additionConstant000;
		REAL zd = min(min(zdv.x, zdv.y), zdv.z);
		if (fractal->transformCommon.functionEnabledEFalse)
			zcd = max(zd, zcd) - fractal->transformCommon.offsetC0;
		if (fractal->transformCommon.functionEnabledFFalse)
			zcf = max(zd, zcf) - fractal->transformCommon.offsetD0;
	}

	zcd = zcd + (zcf - zcd) * fractal->transformCommon.scaleD1;

	zcd -= fractal->transformCommon.offsetA0;

			REAL colorDist = aux->dist;

	aux->dist = min(aux->dist, zcd / (aux->DE + fractal->analyticDE.offset1));

	if (fractal->transformCommon.functionEnabledTFalse)
	{
		REAL4 c = aux->const_c;
		REAL dst = 1.0;

		if (!fractal->transformCommon.functionEnabledSFalse)
		{
			dst = length(c) - fractal->transformCommon.offset4; // sphere
		}
		else
		{
			dst = max(fabs(c.x) - fractal->transformCommon.scale3D444.x,
					fabs(c.y) - fractal->transformCommon.scale3D444.y); // sqr
		}

		//dst = clamp(dst, 0.0, 100.0);

		dst = max(fabs(c.z) - fractal->transformCommon.scale3D444.z, dst);

		aux->dist = max(aux->dist, dst);
	}



	if (fractal->transformCommon.functionEnabledZcFalse
			&& aux->i >= fractal->transformCommon.startIterationsZc
			&& aux->i < fractal->transformCommon.stopIterationsZc)
		z = zc;



	// aux->color
	if (fractal->foldColor.auxColorEnabledAFalse
			&& aux->i >= fractal->foldColor.startIterationsA
					&& aux->i < fractal->foldColor.stopIterationsA)
	{
			REAL colorAdd = 0.0f;

		if (fractal->foldColor.auxColorEnabledFalse)
		{
			colorAdd += fractal->foldColor.difs0000.x * fabs(z.x * z.y);
			colorAdd += fractal->foldColor.difs0000.y * max(z.x, z.y);
		}
		colorAdd += fractal->foldColor.difs1;
		if (fractal->foldColor.auxColorEnabledA)
		{
			if (colorDist != aux->dist) aux->color += colorAdd;
		}
		else
			aux->color += colorAdd;
	}


	return z;
}
