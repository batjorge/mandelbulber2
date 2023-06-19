/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2020 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * formula by TGlad, extras by sabine62
 * https://fractalforums.org/fractal-mathematics-and-new-theories/28/new-sphere-tree/3557/msg22100#msg22100

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_spheretree.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 SphereClusterIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL4 oldZ = z;

	REAL3 p = (REAL3){z.xyz}; // convert to vec3
//	REAL PackRatio = fractal->transformCommon.offset1;
	REAL4 ColV = (REAL4){0.0f, 0.0f, 0.0f, 0.0f};
//	REAL phi = (1.0 + sqrt(5.0)) / 2.0;
	REAL phi = (1.0 + sqrt(5.0)) / fractal->transformCommon.scale2;
	// Isocahedral geometry
	REAL3 ta0 = (REAL3){0.0, 1.0, phi};
	REAL3 ta1 = (REAL3){0.0, -1.0, phi};
	REAL3 ta2 = (REAL3){phi, 0.0, 1.0};
	REAL3 na0 = normalize(cross(ta0, ta1 - ta0));
	REAL3 na1 = normalize(cross(ta1, ta2 - ta1));
	REAL3 na2 = normalize(cross(ta2, ta0 - ta2));
	REAL mid_to_edgea = atan(phi / (1.0 + 2.0 * phi));
	REAL xxa = 1.0 / sin(mid_to_edgea);
	REAL ra = 2.0 / sqrt(-4.0 + xxa * xxa);
	REAL la = sqrt(1.0 + ra * ra);
	REAL3 mida = normalize(ta0 + ta1 + ta2);
	REAL minra = (la - ra * fractal->transformCommon.scaleC1) * fractal->transformCommon.scaleA1;

	// Dodecahedral geometry
	REAL3 tb0 = (REAL3){1.0 / phi, 0.0, phi};
	REAL3 tb1 = (REAL3){1.0, -1.0, 1.0};
	REAL3 tb2 = (REAL3){phi, -1.0 / phi, 0.0};
	REAL3 tb3 = (REAL3){phi, 1.0 / phi, 0.0};
	REAL3 tb4 = (REAL3){1.0, 1.0, 1.0};
	REAL3 nb0 = normalize(cross(tb0, tb1 - tb0));
	REAL3 nb1 = normalize(cross(tb1, tb2 - tb1));
	REAL3 nb2 = normalize(cross(tb2, tb3 - tb2));
	REAL3 nb3 = normalize(cross(tb3, tb4 - tb3));
	REAL3 nb4 = normalize(cross(tb4, tb0 - tb4));
	REAL3 dirb = normalize(tb0 + tb1 + tb2 + tb3 + tb4);
	REAL mid_to_edgeb = atan(dirb.z / dirb.x);
	REAL xxb = 1.0 / sin(mid_to_edgeb);
	REAL rb =sqrt(2.0) / sqrt(-2.0 + xxb * xxb);
	REAL lb = sqrt(1.0 + rb * rb);
	REAL3 midb = dirb;
	REAL minrb = (lb - rb * fractal->transformCommon.scaleD1) * fractal->transformCommon.scaleB1;

	REAL k = fractal->transformCommon.scale08; // PackRatio;
	REAL excess = fractal->transformCommon.offset105; // adds a skin width

	bool is_b = fractal->transformCommon.functionEnabledDFalse;
	REAL minr = 0.0;
	REAL l, r;
	REAL3 mid;
	aux->DE = 1.0 * fractal->transformCommon.scale1;
int i;
	bool recurse = true;
	for (i = 0; i < fractal->transformCommon.int8X; i++)
	{
		if (recurse)
		{
			if (length(p) > excess)
			{
			//	p = (REAL3){0.0f, 0.0f, 0.0f};

				return (length(p) - 1.0) / aux->DE;
			}
			if (is_b)
			{
				minr = minrb;
			}
			else
			{
				minr = minra;
			}
			REAL sc = minr / dot(p, p);
			p *= sc;
			aux->DE *= sc;
			recurse = false;
			ColV.z += 1.0;
		}
		if (is_b)
		{
			l = lb;
			r = rb;
			mid = midb;
			minr = minrb;
			if (dot(p, nb0) < 0.0)
				p -= 2.0 * nb0 * dot(p, nb0);
			if (dot(p, nb1) < 0.0)
				p -= 2.0 * nb1 * dot(p, nb1);
			if (dot(p, nb2) < 0.0)
				p -= 2.0 * nb2 * dot(p, nb2);
			if (dot(p, nb3) < 0.0)
				p -= 2.0 * nb3 * dot(p, nb3);
			if (dot(p, nb4) < 0.0)
				p -= 2.0 * nb4 * dot(p, nb4);

			if (dot(p, nb0) < 0.0)
				p -= 2.0 * nb0 * dot(p, nb0);
			if (dot(p, nb1) < 0.0)
				p -= 2.0 * nb1 * dot(p, nb1);
			if (dot(p, nb2) < 0.0)
				p -= 2.0 * nb2 * dot(p, nb2);
			if (dot(p, nb3) < 0.0)
				p -= 2.0 * nb3 * dot(p, nb3);
			if (dot(p, nb4) < 0.0)
				p -= 2.0 * nb4 * dot(p, nb4);
		}
		else
		{
			l = la;
			r = ra;
			mid = mida;
			minr = minra;
			if (dot(p, na0) < 0.0)
				p -= 2.0 * na0 * dot(p, na0);
			if (dot(p, na1) < 0.0)
				p -= 2.0 * na1 * dot(p, na1);
			if (dot(p, na2) < 0.0)
				p -= 2.0 * na2 * dot(p, na2);

			if (dot(p, na0) < 0.0)
				p -= 2.0 * na0 * dot(p, na0);
			if (dot(p, na1) < 0.0)
				p -= 2.0 * na1 * dot(p, na1);
			if (dot(p, na2) < 0.0)
				p -= 2.0 * na2 * dot(p, na2);

			if (dot(p, na0) < 0.0)
				p -= 2.0 * na0 * dot(p, na0);
			if (dot(p, na1) < 0.0)
				p -= 2.0 * na1 * dot(p, na1);
			if (dot(p, na2) < 0.0)
				p -= 2.0 * na2 * dot(p, na2);
		}

		REAL dist = length(p - mid * l);
		if (dist < r || i == fractal->transformCommon.int8X - 1)
		{
			ColV.x += 1.0 * (i + 1);
			p -= mid * l;
			REAL sc = r * r / dot(p, p);
			p *= sc;
			aux->DE *= sc;
			p += mid * l;

			REAL m = minr * k;
			if (length(p) < minr)
			{
				ColV.y += 1.0 * (i + 1);
				p /= m;
				aux->DE /= m;

				if (fractal->transformCommon.functionEnabledTFalse)
					is_b = !is_b;
				recurse = true;
			}
		}
		p *= fractal->transformCommon.scaleF1;
		aux->DE *= fabs(fractal->transformCommon.scaleF1);

		aux->DE = aux->DE * fractal->analyticDE.scale1 + fractal->analyticDE.offset0;
	}
	//z.xyz = p.xyz;
	z = (REAL4){p.x, p.y, p.z, z.w};

	REAL d;
	if (!fractal->transformCommon.functionEnabledSwFalse)
	{
		d = (length(p) - minr * k) / aux->DE;
	}
	else
	{
		REAL4 zc = z - fractal->transformCommon.offset000;
		d = max(max(zc.x, zc.y), zc.z);
		d = (d - minr * k) / aux->DE;
	}

	if (!fractal->transformCommon.functionEnabledXFalse)
		aux->dist = min(aux->dist, d);
	else
		aux->dist = d;

	if (fractal->analyticDE.enabledFalse) z = oldZ;

ColV.w += 1.0* aux->DE;
	// aux->color
	if (i >= fractal->foldColor.startIterationsA && i < fractal->foldColor.stopIterationsA)
	{
			aux->color += ColV.x * fractal->foldColor.difs0000.x + ColV.y * fractal->foldColor.difs0000.y
									+ ColV.z * fractal->foldColor.difs0000.z + ColV.w * fractal->foldColor.difs0000.w;
	}
	return z;
}
