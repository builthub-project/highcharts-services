SELECT DISTINCT sector 
FROM "public"."dashboard_energy" 
WHERE sector != ''
ORDER BY sector