/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * Box Tiling 4d

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_transf_box_tiling4d.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 TransfBoxTilingV3Iteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL4 size = fractal->transformCommon.offset2222;

	if (!fractal->transformCommon.functionEnabledFalse)
	{
		if (fractal->transformCommon.functionEnabledx && size.x != 0.0f)
		{
			if (fractal->transformCommon.functionEnabledCxFalse) z.x = fabs(z.x);
			z.x -= fractal->transformCommon.offset0000.x;
			z.x -= round(z.x / size.x) * size.x;
		}
		if (fractal->transformCommon.functionEnabledyFalse && size.y != 0.0f)
		{
			if (fractal->transformCommon.functionEnabledCyFalse) z.y = fabs(z.y);
			z.y -= fractal->transformCommon.offset0000.y;
			z.y -= round(z.y / size.y) * size.y;
		}
		if (fractal->transformCommon.functionEnabledzFalse && size.z != 0.0f)
		{
			if (fractal->transformCommon.functionEnabledCzFalse) z.z = fabs(z.z);
			z.z -= fractal->transformCommon.offset0000.z;
			z.z -= round(z.z / size.z) * size.z;
		}
		if (fractal->transformCommon.functionEnabledwFalse && size.w != 0.0f)
		{
			if (fractal->transformCommon.functionEnabledCwFalse) z.w = fabs(z.w);
			z.w -= fractal->transformCommon.offset0000.w;
			z.w -= round(z.w / size.w) * size.w;
		}
	}
	else
	{
		REAL4 repeatPos = fractal->transformCommon.offsetA1111;
		REAL4 repeatNeg = fractal->transformCommon.offsetB1111;

		if (fractal->transformCommon.functionEnabledx && z.x < (repeatPos.x + 0.5) * size.x
				&& z.x > (repeatNeg.x + 0.5) * -size.x && size.x != 0.0f)
		{
			if (fractal->transformCommon.functionEnabledCxFalse) z.x = fabs(z.x);
			z.x -= fractal->transformCommon.offset0000.x;
			z.x -= round(z.x / size.x) * size.x;
		}
		if (fractal->transformCommon.functionEnabledyFalse && z.y < (repeatPos.y + 0.5) * size.y
				&& z.y > (repeatNeg.y + 0.5) * -size.y && size.y != 0.0f)
		{
			if (fractal->transformCommon.functionEnabledCyFalse) z.y = fabs(z.y);
			z.y -= fractal->transformCommon.offset0000.y;
			z.y -= round(z.y / size.y) * size.y;
		}
		if (fractal->transformCommon.functionEnabledzFalse && z.z < (repeatPos.z + 0.5) * size.z
				&& z.z > (repeatNeg.z + 0.5) * -size.z && size.z != 0.0f)
		{
			if (fractal->transformCommon.functionEnabledCzFalse) z.z = fabs(z.z);
			z.z -= fractal->transformCommon.offset0000.z;
			z.z -= round(z.z / size.z) * size.z;
		}
		if (fractal->transformCommon.functionEnabledwFalse && z.w < (repeatPos.w + 0.5) * size.w
				&& z.w > (repeatNeg.w + 0.5) * -size.w && size.w != 0.0f)
		{
			if (fractal->transformCommon.functionEnabledCwFalse) z.w = fabs(z.w);
			z.w -= fractal->transformCommon.offset0000.w;
			z.w -= round(z.w / size.w) * size.w;
		}
	}

	if (fractal->analyticDE.enabled)
	{
		if (!fractal->analyticDE.enabledFalse)
			aux->DE = aux->DE * fractal->analyticDE.scale1 + fractal->analyticDE.offset0;
		else
		{
			aux->DE = aux->DE * length(z) * fractal->analyticDE.scale1 + fractal->analyticDE.offset0;
		}
	}

	if (fractal->transformCommon.addCpixelEnabledFalse)
		aux->const_c = z;
	return z;
}
