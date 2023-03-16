/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2022 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * fragmentarium code, by knighty

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_transf_difs_clip_custom.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 TransfDIFSClipCustomIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
		// pre-box option
	if (fractal->transformCommon.functionEnabledAFalse)
	{
		REAL4 zc = z;
		zc += fractal->transformCommon.offsetA000;
		zc = fabs(zc) - fractal->transformCommon.additionConstant111;
		zc.x = max(zc.x, 0.0f);
		zc.y = max(zc.y, 0.0f);
		zc.z = max(zc.z, 0.0f);
		REAL zcd = length(zc) / (aux->DE + fractal->analyticDE.offset0) - fractal->transformCommon.offsetB0;
		if (!fractal->transformCommon.functionEnabledNFalse)
		{
			aux->dist =  zcd;
		}
		else
		{
			aux->dist = min(aux->dist, zcd);
		}
	}

	// transform c
	REAL4 c = aux->const_c;

	if (fractal->transformCommon.functionEnabledFalse) c = z; // hmmmmmmmmmmm


		// polyfold
	if (fractal->transformCommon.functionEnabledPFalse)
	{
		c.y = fabs(c.y);
		REAL psi = M_PI_F / fractal->transformCommon.int6;
		psi = fabs(fmod(atan2(c.y, c.x) + psi, 2.0f * psi) - psi);
		REAL len = native_sqrt(c.x * c.x + c.y * c.y);
		c.x = native_cos(psi) * len;
		c.y = native_sin(psi) * len;
	}
	if (fractal->transformCommon.functionEnabledAxFalse) c.x = fabs(c.x);
	if (fractal->transformCommon.functionEnabledAyFalse) c.y = fabs(c.y);
	if (fractal->transformCommon.functionEnabledAzFalse) c.z = fabs(c.z);
	c *= fractal->transformCommon.scale3D111;
	c += fractal->transformCommon.offset000;
	c = Matrix33MulFloat4(fractal->transformCommon.rotationMatrix, c);


	REAL dst = 1.0f;


	REAL4 f = fractal->transformCommon.constantMultiplier111;

	REAL4 g = fabs(c) - (REAL4){f.x, f.y, f.z, 0.0f};

	if (!fractal->transformCommon.functionEnabledBFalse)
	{
		dst = max(fabs(c.x) - fractal->transformCommon.constantMultiplier111.x,
			fabs(c.y) - fractal->transformCommon.constantMultiplier111.y); // sqr
	}
	else
	{
		//if (fractal->transformCommon.functionEnabledIFalse)
		//{
			dst = length(c) - fractal->transformCommon.offsetR1; // sphere
		//}

		if (fractal->transformCommon.functionEnabledCFalse)
		{
			dst = length(c) - length(g);
		}
		if (fractal->transformCommon.functionEnabledDFalse) // cyl
		{
			dst = native_sqrt(c.x * c.x + c.y * c.y) - fractal->transformCommon.offsetR1;
		}
		if (fractal->transformCommon.functionEnabledEFalse) // cone
		{
			REAL CZ = -c.z;
			if (fractal->transformCommon.functionEnabledFFalse) CZ = fabs(c.z);
			if (fractal->transformCommon.functionEnabledGFalse) CZ = c.z * c.z;
			dst = native_sqrt(c.x * c.x + c.y * c.y) - fractal->transformCommon.offsetR1 * CZ;
		}
	}

	dst = clamp(dst, 0.0f, 100.0f);
	if (!fractal->transformCommon.functionEnabledJFalse) // z clip
	{
		dst = max(fabs(c.z) - fractal->transformCommon.constantMultiplier111.z, dst);
	}

	dst = max(aux->dist, dst / (aux->DE + fractal->analyticDE.offset1));

	 if (!fractal->analyticDE.enabledFalse)
		aux->dist = dst;
	else
		aux->dist = min( dst, aux->dist);

	/*

	// tile
	if (fractal->transformCommon.functionEnabledTFalse)
	{
		zc.x -= round(zc.x / fractal->transformCommon.offset2) * fractal->transformCommon.offset2;
		zc.y -= round(zc.y / fractal->transformCommon.offsetA2) * fractal->transformCommon.offsetA2;
	}

	// rot
	if (fractal->transformCommon.functionEnabledIFalse)
	{
		REAL angle = M_PI_2x_F / (fractal->transformCommon.int16);
		REAL sector = round(atan2(zc.x, zc.y) / angle);
		REAL an = sector * angle;
		REAL sinan = native_sin(an);
		REAL cosan = native_cos(an);
		temp = zc.x;
		zc.x = zc.x * cosan - zc.y * sinan;
		zc.y = temp * sinan + zc.y * cosan;
	}

	zc.x += fractal->transformCommon.offset000.x;
	zc.y += fractal->transformCommon.offset000.y;

	if (fractal->transformCommon.functionEnabledAFalse)
	{
		if (fractal->transformCommon.functionEnabledAxFalse) zc.x = fabs(zc.x);
		if (fractal->transformCommon.functionEnabledAyFalse) zc.y = fabs(zc.y);
		if (fractal->transformCommon.functionEnabledMFalse) zc.x = fabs(z.x);
		if (fractal->transformCommon.functionEnabledNFalse) zc.y = fabs(z.y);
		zc.x -= fractal->transformCommon.offsetA000.x;
		zc.y -= fractal->transformCommon.offsetA000.y;
	}

	if (fractal->transformCommon.functionEnabledFFalse)
		zc.x = zc.x + native_sin(zc.y) * fractal->transformCommon.scale3D000.x;
	if (fractal->transformCommon.functionEnabledGFalse)
		zc.y = zc.y + native_sin(zc.x) * fractal->transformCommon.scale3D000.y;

	// plane
	REAL plD = fabs(c.z - fractal->transformCommon.offsetF0)
			- fractal->transformCommon.offsetAp01;

	// base plane
	REAL a = 1000.0f;
	if (fractal->transformCommon.functionEnabledBFalse)
	{
		a = (c.z - fractal->transformCommon.offsetA0);
		aux->DE0 = min(aux->DE0, a);
	}

	// aux->color
	if (fractal->foldColor.auxColorEnabled)
	{
		REAL addColor = 0.0f;
		if (e > d) addColor += fractal->foldColor.difs0000.x;
		if (e < d) addColor += fractal->foldColor.difs0000.y;
		if (aux->DE0 == a) addColor += fractal->foldColor.difs0000.z;

		if (!fractal->transformCommon.functionEnabledJFalse)
			aux->color = addColor;
		else
			aux->color += addColor;
	}*/
	return z;
}
