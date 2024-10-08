SELECT  DISTINCT
main.construction_period as "Period", COALESCE(sub2.closed, 0) as "Terraced", COALESCE(sub3.halfopen, 0) as "Semi-detached", COALESCE(sub4.open, 0) as "Detached", COALESCE(sub1.apartments, 0) as "Apartments", COALESCE(sub0.others, 0) as "Others", (COALESCE(sub2.closed, 0) + COALESCE(sub3.halfopen, 0) + COALESCE(sub4.open, 0) + COALESCE(sub1.apartments, 0) + COALESCE(sub0.others, 0)) as "Total"
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
    place_type='sector' and place IN ($P{SECTOR}) 
)
as subsub on submain.sector_code=subsub.place_code
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
    place_type='sector' and place IN ($P{SECTOR}) 
)
as subsub on submain.sector_code=subsub.place_code
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
    place_type='sector' and place IN ($P{SECTOR}) 
)
as subsub on submain.sector_code=subsub.place_code
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
    place_type='sector' and place IN ($P{SECTOR}) 
)
as subsub on submain.sector_code=subsub.place_code
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
    place_type='sector' and place IN ($P{SECTOR}) 
)
as subsub on submain.sector_code=subsub.place_code
WHERE
municipality='Harelbeke' and construction_form='open'
GROUP BY construction_period
ORDER BY construction_period
)
as sub4 on main.construction_period=sub4.construction_period

UNION

SELECT DISTINCT
'Total' as Period, sub2.closed as Closed, sub3.halfopen as Halfopen, sub4.open as Open, sub1.apartments as Apartments, sub0.others as Others, (sub2.closed + sub3.halfopen + sub4.open + sub1.apartments + sub0.others) as Total
FROM
"public"."dashboard_be_reel" as main

left join(
SELECT
sum(COALESCE(accommodations, 0)) as others
FROM
"public"."dashboard_be_reel" as submain
right join(
    SELECT
    place_code, place
    FROM
    "public"."dashboard_be_reel_gis"
    WHERE
    place_type='sector' and place IN ($P{SECTOR}) 
)
as subsub on submain.sector_code=subsub.place_code
WHERE
municipality='Harelbeke' and construction_form='andere'
)
as sub0 on 1=1

left join(
SELECT
sum(COALESCE(accommodations, 0)) as apartments
FROM
"public"."dashboard_be_reel" as submain
right join(
    SELECT
    place_code, place
    FROM
    "public"."dashboard_be_reel_gis"
    WHERE
    place_type='sector' and place IN ($P{SECTOR}) 
)
as subsub on submain.sector_code=subsub.place_code
WHERE
municipality='Harelbeke' and construction_form='appartement'
)
as sub1 on 1=1

left join(
SELECT
sum(COALESCE(accommodations, 0)) as closed
FROM
"public"."dashboard_be_reel" as submain
right join(
    SELECT
    place_code, place
    FROM
    "public"."dashboard_be_reel_gis"
    WHERE
    place_type='sector' and place IN ($P{SECTOR}) 
)
as subsub on submain.sector_code=subsub.place_code
WHERE
municipality='Harelbeke' and construction_form='gesloten'
)
as sub2 on 1=1

left join(
SELECT
sum(COALESCE(accommodations, 0)) as halfopen
FROM
"public"."dashboard_be_reel" as submain
right join(
    SELECT
    place_code, place
    FROM
    "public"."dashboard_be_reel_gis"
    WHERE
    place_type='sector' and place IN ($P{SECTOR}) 
)
as subsub on submain.sector_code=subsub.place_code
WHERE
municipality='Harelbeke' and construction_form='halfopen'
)
as sub3 on 1=1

left join(
SELECT
sum(COALESCE(accommodations, 0)) as open
FROM
"public"."dashboard_be_reel" as submain
right join(
    SELECT
    place_code, place
    FROM
    "public"."dashboard_be_reel_gis"
    WHERE
    place_type='sector' and place IN ($P{SECTOR}) 
)
as subsub on submain.sector_code=subsub.place_code
WHERE
municipality='Harelbeke' and construction_form='open'
)
as sub4 on 1=1

GROUP BY sub2.closed, sub3.halfopen, sub4.open, sub1.apartments, sub0.others
ORDER BY "Period"