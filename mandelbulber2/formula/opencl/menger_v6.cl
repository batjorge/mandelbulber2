/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2021 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * MengerV6Iteration
 * #info Created by blepfo 2020-05-28
 * https://www.shadertoy.com/view/wsjfzd

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_menger_v3.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 MengerV6Iteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL t;

	if (fractal->transformCommon.functionEnabledAFalse
			&& aux->i >= fractal->transformCommon.startIterationsA
			&& aux->i < fractal->transformCommon.stopIterationsA)
	{
		z += fractal->transformCommon.additionConstant000;

		if (fractal->transformCommon.functionEnabledAx) z.x = fabs(z.x) + fractal->transformCommon.offset000.x;
		if (fractal->transformCommon.functionEnabledAy) z.y = fabs(z.y) + fractal->transformCommon.offset000.y;
		if (fractal->transformCommon.functionEnabledAz) z.z = fabs(z.z) + fractal->transformCommon.offset000.z;

		if (fractal->transformCommon.functionEnabledx)
			z.x = fractal->transformCommon.offsetA000.x - fabs(fractal->transformCommon.offsetA000.x - z.x);
		if (fractal->transformCommon.functionEnabledy)
			z.y = fractal->transformCommon.offsetA000.y - fabs(fractal->transformCommon.offsetA000.y - z.y);
		if (fractal->transformCommon.functionEnabledz)
			z.z = fractal->transformCommon.offsetA000.z - fabs(fractal->transformCommon.offsetA000.z - z.z);
	}

	// folds
	if (fractal->transformCommon.functionEnabledFalse)
	{
		// polyfold
		if (fractal->transformCommon.functionEnabledPFalse)
		{
			z.y = fabs(z.y);
			REAL psi = M_PI_F / fractal->transformCommon.int6;
			psi = fabs(fmod(atan2(z.y, z.x) + psi, 2.0f * psi) - psi);
			t = native_sqrt(z.x * z.x + z.y * z.y);
			z.x = native_cos(psi) * t;
			z.y = native_sin(psi) * t;
		}
		// abs offsets
		if (fractal->transformCommon.functionEnabledCFalse)
		{
			t = fractal->transformCommon.offsetC0;
			if (z.x < t) z.x = fabs(z.x - t) + t;
		}
		if (fractal->transformCommon.functionEnabledDFalse)
		{
			REAL t = fractal->transformCommon.offsetD0;
			if (z.y < t) z.y = fabs(z.y - t) + t;
		}
	}

	if (aux->i >= fractal->transformCommon.startIterations
			&& aux->i < fractal->transformCommon.stopIterations1)
	{
		REAL4 n;

		z.y *= fractal->transformCommon.scaleA1;
		z *= 0.5f;

		for (int k = 0; k < fractal->transformCommon.int8X; k++)
		{
			z *= fractal->transformCommon.scale3;
			aux->DE *= fractal->transformCommon.scale3;
			REAL4 Offset1 = fractal->transformCommon.offset222;
			z.y = z.y - (2.0f * max(z.y, 0.0f)) + Offset1.y;
			z.x = -(z.x - (2.0f * max(z.x, 0.0f)) + Offset1.x);

			t = fractal->transformCommon.cosA;
			n = (REAL4){t * fractal->transformCommon.sinB, fractal->transformCommon.sinA, t * fractal->transformCommon.cosB, 0.0f};

			t = length(n);
			if (t == 0.0f) t = 1e-21f;
			n /= t;
			t = dot(z, n) * 2.0f;
			z -= max(t, 0.0f) * n;

			z.z += Offset1.z;

			t = cos(fractal->transformCommon.angle45 * M_PI_180_F);
			n = (REAL4){t * fractal->transformCommon.sinC, sin(-fractal->transformCommon.angle45 * M_PI_180_F), t * fractal->transformCommon.cosC, 0.0f};
			t = length(n);
			if (t == 0.0f) t = 1e-21f;
			n /= t;
			t = dot(z, n) * 2.0f;
			z -= max(t, 0.0f) * n;
			t = max((z.x + z.y), 0.0f);
			z.y = z.y - t;
			z.x = z.x - t + fractal->transformCommon.offset2;
			z.x = z.x - (2.0f * max(z.x, 0.0f)) + fractal->transformCommon.offsetA1;
			z.x = z.x - (2.0f * max(z.x, 0.0f)) + fractal->transformCommon.offsetT1;

			t = max((z.x + z.y), 0.0f);
			z.x -= t;
			z.y -= t;

			// rotation
			if (fractal->transformCommon.functionEnabledRFalse
					&& k >= fractal->transformCommon.startIterationsR
					&& k < fractal->transformCommon.stopIterationsR)
			{
				z = Matrix33MulFloat4(fractal->transformCommon.rotationMatrix2, z);
			}
		}

		REAL4 edgeDist = fabs(z) - (REAL4){1.0f, 1.0f, 1.0f, 0.0f};
		edgeDist.x = max(edgeDist.x, 0.0f);
		edgeDist.y = max(edgeDist.y, 0.0f);
		edgeDist.z = max(edgeDist.z, 0.0f);
		t = length(edgeDist); // + min(max(edgeDist.x, max(edgeDist.y, edgeDist.z)));

		t /= aux->DE;

		REAL colDist = aux->dist;
		if (!fractal->analyticDE.enabledFalse)
			aux->dist = t;
		else
			aux->dist = min(aux->dist, t);

		if (fractal->foldColor.auxColorEnabledFalse)
		{
			REAL colorAdd = 0.0f;
			if (colDist != aux->dist) colorAdd = fractal->foldColor.difs0000.x;
			//if (t <= e) colorAdd = fractal->foldColor.difs0000.y;

			aux->color += colorAdd;
		}
	}

	return z;
}
