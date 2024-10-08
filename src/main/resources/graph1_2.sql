SELECT 
sub1.place as "District", ROUND(((sum(main.adjusted_reduction_potential_mwhperyear)/sum(main.surface*main.accommodations))*1000)::numeric, 3) as "Reduction potential (kWh/yr/m2)", CAST((sum(main.total_adjusted_energy_consumption_mwhperyear)*100)/sub0.ec AS int) as "Total energy consumption (% from Total)", CAST((sum(main.adjusted_reduction_potential_mwhperyear)*100)/sub0.rp AS int) as "Reduction potential (% from Total)", CAST(sum(main.total_adjusted_energy_consumption_mwhperyear) AS int) as "Total energy consumption", CAST(sum(main.adjusted_reduction_potential_mwhperyear) AS int) as "Reduction Potential", sum(COALESCE(main.accommodations, 0)) as "Households"
FROM
"public"."dashboard_be_reel" as main

left join(
SELECT
sum(COALESCE(total_adjusted_energy_consumption_mwhperyear, 0)) as ec, sum(COALESCE(adjusted_reduction_potential_mwhperyear, 0)) as rp
FROM
"public"."dashboard_be_reel"
)
as sub0 on 1=1

left join(
SELECT
    place_code, place, geomwkt as geom
    FROM
    "public"."dashboard_be_reel_gis"
    WHERE
    place_type='district'
)
as sub1 on main.district_code = sub1.place_code

WHERE
municipality='Harelbeke'
GROUP BY sub1.place, sub0.ec, sub0.rp