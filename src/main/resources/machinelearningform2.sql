SELECT 
sub0.tr_dataset as "Dataset needed", main.area as "Objective", main.descr as "Description", main.agg_cat as "Aggregation level / Building category", sub0.alg_desc as "Algorithm description", sub0.alg_strength as "Streangth", sub0.alg_weakness as "Weakness", main.ref as "Reference"
FROM
"public"."ml_info" as main
right join(
    SELECT
        tr_dataset, sub00.alg_desc as "alg_desc", sub00.alg_strength as "alg_strength", sub00.alg_weakness as "alg_weakness", sub00.area as "area"
        FROM
        "public"."tr_dataset" as main2
        right join(
            SELECT
                alg_desc, alg_strength, alg_weakness, area
                FROM
                "public"."ml_alg"
                WHERE
                alg_name = $P{ALG}
        )
        as sub00 on main2.area = sub00.area
)
as sub0 on main.area = sub0.area