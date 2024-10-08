SELECT DISTINCT sub0.name
FROM "public"."dashboard_energy" as main
LEFT JOIN(
	SELECT nuts_code,name
	FROM "public"."nuts"
	WHERE nuts_level = 0
)
as sub0 on sub0.nuts_code=main.nuts_code
ORDER BY sub0.name