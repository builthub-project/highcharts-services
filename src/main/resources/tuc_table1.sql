SELECT 
name as "Country", topic_type as "Consumption type", msrvalue as "Value", msrunit as "Unit", ROUND(tuc::numeric, 2) as "TUC", pop_nuts_name as "Place", pop_nuts_level as "NUTS level", CAST(pop_msrvalue AS int) as "Population", CAST(cntr_pop_msrvalue AS int) as "Country population", CAST(pop_year AS int) as "Year"
FROM "public"."dashboard_energy_tuc_002" 
WHERE
name=$P{COUNTRY} and pop_nuts_level=$P{NUTS} and topic_type=$P{TOPIC} and pop_nuts_name IN ($P{REGION}) and pop_year IN ($P{YEAR})