SELECT DISTINCT
sub0.place
FROM
"public"."dashboard_be_reel" as main
left join(
    SELECT
    DISTINCT place_code, place
    FROM
    "public"."dashboard_be_reel_gis"
    WHERE
    place_type='district'
)
as sub0 on main.district_code=sub0.place_code
WHERE
municipality='Harelbeke'
ORDER BY sub0.place