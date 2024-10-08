SELECT DISTINCT pop_nuts_name 
FROM "public"."dashboard_energy_tuc_002" 
WHERE name=$P{COUNTRY} and pop_nuts_level=$P{NUTS_LVL}
ORDER BY pop_nuts_name