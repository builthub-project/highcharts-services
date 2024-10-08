SELECT DISTINCT sub0.name as "Country", main.nuts_code as "NUTS", main.measuredelement as "Indicator Name", main.period as "Period", main.sector as "Sector", main.btype as "Building Type", main.ttype as "Consumption Type", ROUND(main.msrvalue::Numeric, 2) as "Value", main.msrunit as "Unit"
FROM "public"."dashboard_energy" as main
RIGHT JOIN(
    SELECT nuts_code, name
    FROM "public"."nuts"
    WHERE nuts_level=0 and name IN ($P{COUNTRY})
)
AS sub0 ON sub0.nuts_code=main.nuts_code
WHERE
main.measuredelement IN ($P{INDICATOR}) and
main.sector IN ($P{SECTOR}) and
main.btype IN ($P{BTYPE}) and
main.ttype IN ($P{TTYPE}) and
main.msrunit IN ($P{UNIT}) and
main.period IN ($P{YEAR})