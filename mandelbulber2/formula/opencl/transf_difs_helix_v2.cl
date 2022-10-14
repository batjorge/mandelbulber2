/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2021 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * TransfDifsCylinderV2Iteration  fragmentarium code, mdifs by knighty (jan 2012)
 * and http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_transf_difs_helix.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 TransfDIFSHelixV2Iteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL temp;
	REAL4 zc = z;

	zc *= fractal->transformCommon.scale1;
	aux->DE *= fractal->transformCommon.scale1;
	// torus
	REAL ang = atan2(zc.y, zc.x) * M_PI_2x_INV_F;

	zc.y = sqrt(zc.x * zc.x + zc.y * zc.y) - fractal->transformCommon.radius1;

	// vert helix
	if (fractal->transformCommon.functionEnabledAx)
	{
		REAL Voff = fractal->transformCommon.offsetA2;
		temp = zc.z - Voff * ang  * fractal->transformCommon.int1 + Voff * 0.5f;
		zc.z = temp - Voff * floor(temp / (Voff)) - Voff * 0.5f;
	}
	// stretch around helix
	if (fractal->transformCommon.functionEnabledAy)
	{
		if (!fractal->transformCommon.functionEnabledAyFalse)
			zc.x = fractal->transformCommon.offset1;
		else
		{
			temp = fractal->transformCommon.scaleA2 * ang + fractal->transformCommon.offset1;
			zc.x = temp - 2.0f * floor(temp * 0.5f) - 1.0f;
		}
	}
	zc.x *= fractal->transformCommon.scaleG1;
	// twist
	if (fractal->transformCommon.functionEnabledAz)
	{
		ang *= M_PI_F * fractal->transformCommon.int2;
		REAL cosA = cos(ang);
		REAL sinB = sin(ang);
		REAL a;
		REAL b;
		if (!fractal->transformCommon.functionEnabledKFalse)
		{
			if (!fractal->transformCommon.functionEnabledSwFalse)
			{
				a = zc.y;
				b = zc.z;
			}
			else
			{
				a = zc.z;
				b = zc.y;
			}
			zc.y = b * cosA + a * sinB;
			zc.z = a * cosA - b * sinB;
		}
		else
		{
			if (!fractal->transformCommon.functionEnabledSwFalse)
			{
				a = zc.x;
				b = zc.z;
			}
			else
			{
				a = zc.z;
				b = zc.x;
			}
			zc.x = b * cosA + a * sinB;
			zc.z = a * cosA - b * sinB;
		}
		if (fractal->transformCommon.functionEnabledPFalse) zc.x = zc.z;
	}

	// menger sponge
	if (fractal->transformCommon.functionEnabledAwFalse)
	{
		int Iterations = fractal->transformCommon.int16;
		for (int n = 0; n < Iterations; n++)
		{
			zc = fabs(zc);
			zc = Matrix33MulFloat4(fractal->transformCommon.rotationMatrix, zc);
			REAL col = 0.0f;
			if (zc.x < zc.y)
			{
				temp = zc.y;
				zc.y = zc.x;
				zc.x = temp;
				col += fractal->foldColor.difs0000.x;
			}
			if (zc.x < zc.z)
			{
				temp = zc.z;
				zc.z = zc.x;
				zc.x = temp;
				col += fractal->foldColor.difs0000.y;
			}
			if (zc.y < zc.z)
			{
				temp = zc.z;
				zc.z = zc.y;
				zc.y = temp;
			}
			if (n >= fractal->foldColor.startIterationsA
					&& n < fractal->foldColor.stopIterationsA)
			{
				aux->color += col;
			}

			temp = fractal->transformCommon.scale3 - 1.0f;
			REAL bz = temp * fractal->transformCommon.offsetA111.z
					+ fractal->transformCommon.offsetA0;
			zc = fractal->transformCommon.scale3 * zc
					- temp * fractal->transformCommon.offsetA111;
			aux->DE = fractal->transformCommon.scale3 * (aux->DE + fractal->transformCommon.offsetB0); //(aux->DE + 1.0f);
			if (zc.z < -0.5 * bz) zc.z += bz;
		}
	}

	if (fractal->transformCommon.functionEnabledDFalse)
	{
		temp = zc.x;
		zc.x = zc.z;
		zc.z = temp;
		if (fractal->transformCommon.angleDegC != 0.0f)
		{
			ang = fractal->transformCommon.angleDegC;
			temp = zc.y;
			REAL cosA = cos(ang);
			REAL sinB = sin(ang);
			zc.y = zc.z * cosA + zc.y * sinB;
			zc.z = temp * cosA - zc.z * sinB;
		}
	}

	if (fractal->transformCommon.functionEnabledFalse)
	{
		zc = fractal->transformCommon.offset000 - fabs(zc);
	}

	REAL4 d = fabs(zc);
	d.x = max(d.x - fractal->transformCommon.offsetA1, 0.0f);
	d.y = max(d.y - fractal->transformCommon.offset01, 0.0f);
	d.z = max(d.z - fractal->transformCommon.offsetp1, 0.0f);
	REAL rDE;
	if (fractal->transformCommon.functionEnabledBFalse) d *= d;
	if (!fractal->transformCommon.functionEnabledTFalse)
	{
		rDE = length(d);
	}
	else
	{
		rDE = max(d.x, max(d.y, d.z));
	}
	if (fractal->transformCommon.functionEnabledCFalse)
	{
		rDE = native_sqrt(d.x + d.y) - fractal->transformCommon.offset0;

		if (fractal->transformCommon.functionEnabledNFalse)
			rDE = native_sqrt(rDE * rDE + d.z);

		if (fractal->transformCommon.functionEnabledOFalse)
			rDE = native_sqrt(rDE * rDE + d.z * d.z);

		if (fractal->transformCommon.functionEnabledMFalse)
			rDE = max(fabs(rDE), fabs(zc.z));

		if (fractal->transformCommon.functionEnabledSFalse)
			rDE = max(fabs(rDE), zc.z * zc.z);

	}



	rDE -= fractal->transformCommon.offset0005;

	rDE = rDE / (aux->DE + fractal->analyticDE.offset0);

	if (fractal->transformCommon.functionEnabledJFalse) // z clip
	{
		rDE = max(
			fabs(aux->const_c.z - fractal->transformCommon.offsetE0) - fractal->transformCommon.offset2,
			rDE);
	}
	aux->dist = min(aux->dist, rDE);

	if (fractal->transformCommon.functionEnabledZcFalse
			&& aux->i >= fractal->transformCommon.startIterationsZc
			&& aux->i < fractal->transformCommon.stopIterationsZc)
		z = zc;

	if (fractal->foldColor.auxColorEnabled)
	{
		if (!fractal->transformCommon.functionEnabledGFalse)
		{
			ang = (M_PI_F - 2.0f * fabs(atan(fractal->foldColor.difs1 * zc.y / zc.z)))
					* 4.0 * M_PI_2x_INV_F;
			if (fmod(ang, 2.0f) < 1.0f) aux->color += fractal->foldColor.difs0000.z;
			else aux->color += fractal->foldColor.difs0000.w;
		}
		else
		{
			aux->color += fractal->foldColor.difs0000.z * (zc.z * zc.z);
			aux->color += fractal->foldColor.difs0000.w * (zc.y * zc.y);
		}
	}

	return z;
}
