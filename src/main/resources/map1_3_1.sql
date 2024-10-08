SELECT
sub0.place, sum(main.total_calibrated_energy_consumption_mwhperyear) as "Total energy consumption", sum(main.adjusted_reduction_potential_mwhperyear) as "Total reduction potential", sub0.geom as geomwkt
FROM
"public"."dashboard_be_reel" as main

LEFT JOIN(
    SELECT
    place_code, place, geomwkt as geom
    FROM
    "public"."dashboard_be_reel_gis"
    WHERE
    place_type='district'
)
as sub0 on main.district_code = sub0.place_code

WHERE
municipality='Harelbeke'
GROUP BY sub0.place, geomwkt
ORDER BY "Total energy consumption"