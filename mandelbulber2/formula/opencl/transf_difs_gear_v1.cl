/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * TransfDifsCylinderIteration  fragmentarium code, mdifs by knighty (jan 2012)
 * and http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_transf_difs_cylinder.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 TransfDIFSGearV1Iteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	if (fractal->transformCommon.rotation2EnabledFalse
			&& aux->i >= fractal->transformCommon.startIterationsX
			&& aux->i < fractal->transformCommon.stopIterations1)
	{
		z = Matrix33MulFloat4(fractal->transformCommon.rotationMatrix, z);
	}

	REAL angle = M_PI_2x_F / (fractal->transformCommon.int16);
	REAL sector = round(atan2(z.x , z.y) / angle) + (fractal->transformCommon.intA * 1.0f);
	REAL4 zc = z;
	REAL an = sector * angle;
	REAL sinan = sin(an);
	REAL cosan = cos(an);
	REAL temp = zc.x;

	zc.x = zc.x * cosan - zc.y * sinan;
	zc.y = temp * sinan + zc.y * cosan;
	zc.y -= fractal->transformCommon.offset1;
	zc.z -= fractal->transformCommon.offset0;

	REAL widthX = fractal->transformCommon.offset01;
	REAL lengthY = fractal->transformCommon.offset02;
	REAL heightZ = fractal->transformCommon.offset05;

	// chevron
	if (fractal->transformCommon.functionEnabledFalse)
		 zc.x -= fractal->transformCommon.scale0 * fabs(zc.y);

	// curve
	if (fractal->transformCommon.functionEnabledAFalse)
	{
		REAL absZZ = zc.z * zc.z * fractal->transformCommon.scaleA0;
		widthX += absZZ;
		lengthY += absZZ;
	}

	// pyramid
	if (fractal->transformCommon.functionEnabledBFalse)
	{
		REAL subZ = fractal->transformCommon.scaleB0 * zc.z;
		widthX -= subZ;
		lengthY -= subZ;
	}

	// star
	if (fractal->transformCommon.functionEnabledCFalse)
				widthX -= (fractal->transformCommon.scaleC0 * zc.y);

	if (fractal->transformCommon.functionEnabledDFalse)
				zc.x -= fractal->transformCommon.scale05 * zc.y;

	zc.x = fabs(zc.x) - widthX;
	zc.y = fabs(zc.y) - lengthY;
	zc.z = fabs(zc.z) - heightZ;

	if (fractal->transformCommon.functionEnabledEFalse)
				zc.x *= -fractal->transformCommon.scaleE1 * zc.y;

	if (fractal->transformCommon.functionEnabledFFalse)
				zc.x += fractal->transformCommon.scaleF1 * zc.y;


	zc.x = max(zc.x, 0.0);
	zc.y = max(zc.y, 0.0);
	zc.z = max(zc.z, 0.0);
	REAL zcd = length(zc);


		REAL sdTor = fabs(sqrt(z.x * z.x + z.y *z.y) - fractal->transformCommon.offsetA1
				+ fractal->transformCommon.offsetR0)
				- fractal->transformCommon.offsetR0;
		sdTor = max(sdTor , fabs(z.z) - fractal->transformCommon.offsetA05);

		REAL d = min(zcd, sdTor) - fractal->transformCommon.offset0005;

	aux->dist = min(aux->dist, d / (aux->DE + 1.0));
	return z;
}
