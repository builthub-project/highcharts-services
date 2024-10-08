SELECT 
main.pop_nuts_name as "Country", ROUND(sum(main.tuc)::numeric, 2) as "TUC", ROUND(sub0."Average"::numeric, 2) as "Average"
FROM "public"."dashboard_energy_tuc_002" as main

left join(
    SELECT
    avg(subsub0."TUC") as "Average"
    FROM "public"."dashboard_energy_tuc_002" 
    left join(
        SELECT
        sum(tuc) as "TUC"
        FROM "public"."dashboard_energy_tuc_002" 
        WHERE
        name=$P{COUNTRY} and pop_nuts_level=$P{NUTS} and topic_type=$P{TOPIC} and pop_nuts_name IN ($P{REGION}) and pop_year IN ($P{YEAR})
        GROUP BY pop_nuts_name
    )
    as subsub0 on 1=1
    WHERE
    name=$P{COUNTRY} and pop_nuts_level=$P{NUTS} and topic_type=$P{TOPIC} and pop_nuts_name IN ($P{REGION}) and pop_year IN ($P{YEAR})
)
as sub0 on 1=1

WHERE
name=$P{COUNTRY} and pop_nuts_level=$P{NUTS} and topic_type=$P{TOPIC} and pop_nuts_name IN ($P{REGION}) and pop_year IN ($P{YEAR})
GROUP BY main.pop_nuts_name, sub0."Average"
ORDER BY main.pop_nuts_name