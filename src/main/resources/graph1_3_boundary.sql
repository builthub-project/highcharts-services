SELECT lau_name, area_km2, ST_AsText(ST_Boundary(geomwkt)) as geomwkt FROM "public"."gisco" WHERE cntr_code='BE' and lau_id='34013' and year=2020