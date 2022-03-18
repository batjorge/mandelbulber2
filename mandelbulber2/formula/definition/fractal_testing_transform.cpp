﻿/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.         ______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,      / ____/ __    __
 *                                        \><||i|=>>%)     / /   __/ /___/ /_
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    / /__ /_  __/_  __/
 * The project is licensed under GPLv3,   -<>>=|><|||`    \____/ /_/   /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * Based on a DarkBeam fold formula adapted by Knighty
 * MandalayBox  Fragmentarium /Examples/ Knighty Collection
 */

#include "all_fractal_definitions.h"

cFractalTestingTransform::cFractalTestingTransform() : cAbstractFractal()
{
	nameInComboBox = "Testing Transform";
	internalName = "testing_transform";
	internalID = fractal::testingTransform;
	DEType = analyticDEType;
	DEFunctionType = withoutDEFunction;
	cpixelAddition = cpixelDisabledByDefault;
	defaultBailout = 100.0;
	DEAnalyticFunction = analyticFunctionNone;
	coloringFunction = coloringFunctionDefault;
}

void cFractalTestingTransform::FormulaCode(CVector4 &z, const sFractal *fractal, sExtendedAux &aux)
{
	if (fractal->transformCommon.functionEnabledDFalse
			&& aux.i >= fractal->transformCommon.startIterationsD
			&& aux.i < fractal->transformCommon.stopIterationsD1)
	{
		if (fractal->transformCommon.functionEnabledAx) z.x = fabs(z.x);
		if (fractal->transformCommon.functionEnabledAy) z.y = fabs(z.y);
		if (fractal->transformCommon.functionEnabledAzFalse) z.z = fabs(z.z);
	}

	if (fractal->transformCommon.rotationEnabledFalse
			&& aux.i >= fractal->transformCommon.startIterationsR
			&& aux.i < fractal->transformCommon.stopIterationsR1)
	{
		z = fractal->transformCommon.rotationMatrix.RotateVector(z);
	}

	z += fractal->transformCommon.offset000;
	z *= fractal->transformCommon.scale1;
	aux.DE *= fractal->transformCommon.scale1;

	// flip x,z and x = -x
	CVector4 zc = z;
	double u = pow(zc.x, fractal->transformCommon.int2); // try 2,3,4
	double r = u * zc.x + zc.y * zc.y + zc.z * zc.z + fractal->transformCommon.offsetB0;
	r = (r < 0.0f) ? 0.0f : sqrt(r);
	double t = u + fractal->transformCommon.offsetC0;
	t = (t < 0.0f) ? 0.0f : sqrt(t);
	t = r - t;


	if (aux.i >= fractal->transformCommon.startIterationsG
			&& aux.i < fractal->transformCommon.stopIterationsG)
		aux.dist = min(aux.dist, t);
	else
		aux.dist = t;

	double limit = fractal->transformCommon.offset0;
	if (limit > 0.0f) aux.dist = min(aux.dist, fabs(z.x) - limit);

	aux.dist = max (aux.dist, fabs(z.z) - fractal->transformCommon.offsetA0);
	aux.dist *= fractal->transformCommon.scaleA1;


	//	z += fractal->transformCommon.offsetA000;

	if (fractal->transformCommon.functionEnabledZcFalse
			&& aux.i >= fractal->transformCommon.startIterationsZc
			&& aux.i < fractal->transformCommon.stopIterationsZc)
		z = zc;



	if (fractal->analyticDE.enabledFalse)
		aux.DE = aux.DE * fractal->analyticDE.scale1 + fractal->analyticDE.offset1;
}
