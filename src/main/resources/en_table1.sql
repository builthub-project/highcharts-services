SELECT DISTINCT sub0.name as "Country", main.nuts_code as "NUTS", main.measuredelement as "Indicator Name", main.period as "Period", sub1.name as "SIEC", ROUND(main.msrvalue::Numeric, 2) as "Value", main.msrunit as "Unit"
FROM "public"."dashboard_energy" as main
RIGHT JOIN(
    SELECT nuts_code, name
    FROM "public"."nuts"
    WHERE nuts_level=0 and name IN ($P{COUNTRY})
)
as sub0 on sub0.nuts_code=main.nuts_code
LEFT JOIN(
    SELECT siec_id, name
    FROM "public"."siec"
)
as sub1 on sub1.siec_id=main.siec_id
WHERE
main.measuredelement IN ($P{INDICATOR}) and
main.msrunit IN ($P{UNIT}) and
main.period IN ($P{YEAR})