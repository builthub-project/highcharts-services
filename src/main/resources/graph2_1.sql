SELECT  DISTINCT
main.construction_period as "Period", COALESCE(sub2.closed, 0) as "Terraced", COALESCE(sub3.halfopen, 0) as "Semi-detached", COALESCE(sub4.open, 0) as "Detached", COALESCE(sub1.apartments, 0) as "Apartments", COALESCE(sub0.others, 0) as "Others"
FROM
"public"."dashboard_be_reel" as main

left join(
SELECT
construction_period, sum(COALESCE(accommodations, 0)) as others
FROM
"public"."dashboard_be_reel" as submain
right join(
    SELECT
    place_code, place
    FROM
    "public"."dashboard_be_reel_gis"
    WHERE
    place_type='district' and place IN ($P{DISTRICT}) 
)
as subsub on submain.district_code=subsub.place_code
WHERE
municipality='Harelbeke' and construction_form='andere'
GROUP BY construction_period
ORDER BY construction_period
)
as sub0 on main.construction_period=sub0.construction_period

left join(
SELECT
construction_period, sum(COALESCE(accommodations, 0)) as apartments
FROM
"public"."dashboard_be_reel" as submain
right join(
    SELECT
    place_code, place
    FROM
    "public"."dashboard_be_reel_gis"
    WHERE
    place_type='district' and place IN ($P{DISTRICT}) 
)
as subsub on submain.district_code=subsub.place_code
WHERE
municipality='Harelbeke' and construction_form='appartement'
GROUP BY construction_period
ORDER BY construction_period
)
as sub1 on main.construction_period=sub1.construction_period

left join(
SELECT
construction_period, sum(COALESCE(accommodations, 0)) as closed
FROM
"public"."dashboard_be_reel" as submain
right join(
    SELECT
    place_code, place
    FROM
    "public"."dashboard_be_reel_gis"
    WHERE
    place_type='district' and place IN ($P{DISTRICT}) 
)
as subsub on submain.district_code=subsub.place_code
WHERE
municipality='Harelbeke' and construction_form='gesloten'
GROUP BY construction_period
ORDER BY construction_period
)
as sub2 on main.construction_period=sub2.construction_period

left join(
SELECT
construction_period, sum(COALESCE(accommodations, 0)) as halfopen
FROM
"public"."dashboard_be_reel" as submain
right join(
    SELECT
    place_code, place
    FROM
    "public"."dashboard_be_reel_gis"
    WHERE
    place_type='district' and place IN ($P{DISTRICT}) 
)
as subsub on submain.district_code=subsub.place_code
WHERE
municipality='Harelbeke' and construction_form='halfopen'
GROUP BY construction_period
ORDER BY construction_period
)
as sub3 on main.construction_period=sub3.construction_period

left join(
SELECT
construction_period, sum(COALESCE(accommodations, 0)) as open
FROM
"public"."dashboard_be_reel" as submain
right join(
    SELECT
    place_code, place
    FROM
    "public"."dashboard_be_reel_gis"
    WHERE
    place_type='district' and place IN ($P{DISTRICT}) 
)
as subsub on submain.district_code=subsub.place_code
WHERE
municipality='Harelbeke' and construction_form='open'
GROUP BY construction_period
ORDER BY construction_period
)
as sub4 on main.construction_period=sub4.construction_period

ORDER BY "Period"