SELECT name as "Country", geomwkt as "Geometry"
FROM "public"."nuts"
WHERE nuts_level=0 and name IN ($P{COUNTRY})