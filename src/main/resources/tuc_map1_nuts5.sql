SELECT DISTINCT
main.pop_nuts_name as "Name", ROUND(sum(main.tuc)::numeric, 2) as "TUC", ROUND(sub0."Average"::numeric, 2), sub1.geomwkt
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

left join(
    SELECT
    lau_name, geomwkt
    FROM "public"."lau" 
    WHERE
    lau_name IN ($P{REGION})
)
as sub1 on main.pop_nuts_name=sub1.lau_name

WHERE
name=$P{COUNTRY} and pop_nuts_level=$P{NUTS} and topic_type=$P{TOPIC} and pop_nuts_name IN ($P{REGION}) and pop_year IN ($P{YEAR})
GROUP BY main.pop_nuts_name, sub0."Average", sub1.geomwkt
ORDER BY main.pop_nuts_name