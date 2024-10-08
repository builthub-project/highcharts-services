SELECT 
name, topic_type, msrvalue, msrunit, ROUND(tuc::numeric, 2), pop_nuts_name, pop_nuts_level, CAST(pop_msrvalue AS int), CAST(cntr_pop_msrvalue AS int), CAST(pop_year AS int)
FROM "public"."dashboard_energy_tuc_002" 
WHERE
name=$P{COUNTRY} and pop_nuts_level=1