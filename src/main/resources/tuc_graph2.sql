SELECT name as "Country", CAST(pop_year AS int) as "Year", tuc as "TUC"
FROM "public"."dashboard_energy_tuc_002"
WHERE
name IN ($P{COUNTRY}) and pop_nuts_level=0 and topic_type=$P{TOPIC} and pop_year IN ($P{YEAR})
ORDER BY pop_year, name