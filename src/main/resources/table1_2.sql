SELECT 
sub0.place as "District", sum(main.accommodations) as "Houses", CAST(avg(main.surface) AS int) as "Average floor area (m2)", CAST(sum(main.surface*main.accommodations) AS int) as "Total floor area (m2)", CAST(avg(main.specific_corrected_energy_consumption_kwhperm2) AS int) as "Specific energy consumption (kWh/m2)", CAST(sum(main.total_adjusted_energy_consumption_mwhperyear) AS int) as "Total adjusted energy consumption (MWh/yr)", sum(main.total_calibrated_energy_consumption_mwhperyear) as "Total calibrated energy consumption (MWh/yr)", sum(main.adjusted_reduction_potential_mwhperyear) as "Reduction potential (MWh/yr)"
FROM
"public"."dashboard_be_reel" as main

left join(
SELECT
    place_code, place, geomwkt as geom
    FROM
    "public"."dashboard_be_reel_gis"
    WHERE
    place_type='district'
)
as sub0 on main.district_code = sub0.place_code
GROUP BY sub0.place

UNION

SELECT
'Total' as district, sum(accommodations) as houses, CAST(avg(surface) AS int) as area, CAST(sum(surface*accommodations) AS int) as total_area, CAST(avg(specific_corrected_energy_consumption_kwhperm2) AS int) as specific, CAST(sum(total_adjusted_energy_consumption_mwhperyear) AS int) as total_adjusted, sum(total_calibrated_energy_consumption_mwhperyear) as total_calibrated, sum(adjusted_reduction_potential_mwhperyear) as potential_reduction
FROM
"public"."dashboard_be_reel"
WHERE
municipality='Harelbeke'