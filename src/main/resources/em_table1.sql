SELECT DISTINCT sub0.name as "Country", main.nuts_code as "NUTS", main.sector as "Sector", main.measuredelement as "Indicator Name", main.period as "Period", ROUND(main.msrvalue::Numeric, 2) as "Value"
FROM "public"."dashboard_emissions" as main
RIGHT JOIN(
    SELECT nuts_code, name 
    FROM "public"."nuts" 
    WHERE nuts_level=0 and name IN ($P{COUNTRY})
)
as sub0 on sub0.nuts_code=main.nuts_code
WHERE
main.sector IN ($P{SECTOR}) and main.measuredelement IN ($P{INDICATOR}) and main.period IN ($P{YEAR})