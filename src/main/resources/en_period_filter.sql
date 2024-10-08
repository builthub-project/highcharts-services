SELECT DISTINCT period
FROM "public"."dashboard_energy" 
WHERE period != ''
ORDER BY period