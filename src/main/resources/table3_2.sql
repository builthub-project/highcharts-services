SELECT  DISTINCT
main.construction_period as "Period", CAST(COALESCE(sub2.closed, 0) AS int) as "Terraced", CAST(COALESCE(sub3.halfopen, 0) AS int) as "Semi-detached", CAST(COALESCE(sub4.open, 0) AS int) as "Detached", CAST(COALESCE(sub1.apartments, 0) AS int) as "Apartments", CAST(COALESCE(sub0.others, 0) AS int) as "Others", CAST(COALESCE(sub5.total, 0) AS int) as "Total"
FROM
"public"."dashboard_be_reel" as main

left join(
SELECT
construction_period, avg(COALESCE(total_adjusted_energy_consumption_mwhperyear, 0)) as others
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
construction_period, avg(COALESCE(total_adjusted_energy_consumption_mwhperyear, 0)) as apartments
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
construction_period, avg(COALESCE(total_adjusted_energy_consumption_mwhperyear, 0)) as closed
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
construction_period, avg(COALESCE(total_adjusted_energy_consumption_mwhperyear, 0)) as halfopen
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
construction_period, avg(COALESCE(total_adjusted_energy_consumption_mwhperyear, 0)) as open
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

left join(
SELECT
construction_period, avg(COALESCE(total_adjusted_energy_consumption_mwhperyear, 0)) as total
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
municipality='Harelbeke' 
GROUP BY construction_period
ORDER BY construction_period
)
as sub5 on main.construction_period=sub5.construction_period

UNION

SELECT DISTINCT
'Total' as Period, CAST(sub2.closed AS int) as Closed, CAST(sub3.halfopen AS int) as Halfopen, CAST(sub4.open AS int) as Open, CAST(sub1.apartments AS int) as Apartments, CAST(sub0.others AS int) as Others, CAST(sub5.total AS int) as Total
FROM
"public"."dashboard_be_reel" as main

left join(
SELECT
avg(COALESCE(total_adjusted_energy_consumption_mwhperyear, 0)) as others
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
avg(COALESCE(total_adjusted_energy_consumption_mwhperyear, 0)) as apartments
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
avg(COALESCE(total_adjusted_energy_consumption_mwhperyear, 0)) as closed
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
avg(COALESCE(total_adjusted_energy_consumption_mwhperyear, 0)) as halfopen
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
avg(COALESCE(total_adjusted_energy_consumption_mwhperyear, 0)) as open
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

left join(
SELECT
avg(COALESCE(total_adjusted_energy_consumption_mwhperyear, 0)) as total
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
municipality='Harelbeke'
)
as sub5 on 1=1

GROUP BY sub2.closed, sub3.halfopen, sub4.open, sub1.apartments, sub0.others, sub5.total
ORDER BY "Period"