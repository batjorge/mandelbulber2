/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2017 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * benesi T3
 * @reference
 * http://www.fractalforums.com/new-theories-and-research/
 * do-m3d-formula-have-to-be-distance-estimation-formulas/

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the function "TransfBenesiT3Iteration" in the file fractal_formulas.cpp
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 TransfBenesiT3Iteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	Q_UNUSED(aux);

	REAL tempXZ = mad(z.x, SQRT_2_3, -z.z * SQRT_1_3);
	z = (REAL4){
		(tempXZ - z.y) * SQRT_1_2, (tempXZ + z.y) * SQRT_1_2, z.x * SQRT_1_3 + z.z * SQRT_2_3, z.w};

	REAL4 tempV2 = z;
	tempV2.x = (z.y + z.z);
	tempV2.y = (z.x + z.z); // switching
	tempV2.z = (z.x + z.y);
	z = (fabs(tempV2 - fractal->transformCommon.additionConstant222))
			* fractal->transformCommon.scale3D222;

	REAL avgScale = native_divide(length(z), length(tempV2));
	if (fractal->analyticDE.enabled)
	{
		aux->DE = mad(aux->DE * avgScale, fractal->analyticDE.scale1, fractal->analyticDE.offset1);
	}

	if (fractal->transformCommon.rotationEnabled)
	{
		z = Matrix33MulFloat4(fractal->transformCommon.rotationMatrix, z);
	}

	tempXZ = (z.y + z.x) * SQRT_1_2;
	z = (REAL4){z.z * SQRT_1_3 + tempXZ * SQRT_2_3, (z.y - z.x) * SQRT_1_2,
		z.z * SQRT_2_3 - tempXZ * SQRT_1_3, z.w};
	return z;
}