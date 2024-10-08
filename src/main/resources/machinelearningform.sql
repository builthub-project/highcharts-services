SELECT 
main.area as "Objective", main.descr as "Description", main.agg_cat as "Aggregation level / Building category", sub0.alg_name as "Algorithm", sub0.alg_desc as "Algorithm description", sub0.alg_strength as "Streangth", sub0.alg_weakness as "Weakness", main.ref as "Reference"
FROM
"public"."ml_info" as main

right join(
SELECT
    alg_name, alg_desc, alg_strength, alg_weakness, area
    FROM
    "public"."ml_alg"
    WHERE
    area IN (SELECT DISTINCT area FROM "public"."tr_dataset" WHERE tr_dataset IN ($P{DATASET}))
)
as sub0 on main.area = sub0.area