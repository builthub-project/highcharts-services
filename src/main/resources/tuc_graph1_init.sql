SELECT 
main.pop_nuts_name, ROUND(sum(main.tuc)::numeric, 2) as "TUC", ROUND(sub0."Average"::numeric, 2) as "Average"
FROM "public"."dashboard_energy_tuc_002" as main

left join(
    SELECT
    avg(subsub0."TUC") as "Average"
    FROM "public"."dashboard_energy_tuc_002" 
    left join(
        SELECT
        pop_nuts_name, sum(tuc) as "TUC"
        FROM "public"."dashboard_energy_tuc_002" 
        WHERE
        name=$P{COUNTRY} and pop_nuts_level=1
        GROUP BY pop_nuts_name
    )
    as subsub0 on 1=1
    WHERE
    name=$P{COUNTRY} and pop_nuts_level=1
)
as sub0 on 1=1

WHERE
name=$P{COUNTRY} and pop_nuts_level=1
GROUP BY main.pop_nuts_name, sub0."Average"
ORDER BY main.pop_nuts_name