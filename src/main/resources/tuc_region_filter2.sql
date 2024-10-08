SELECT DISTINCT pop_nuts_name 
FROM "public"."dashboard_energy_tuc_002" as main
LEFT JOIN(
    SELECT gisco_id as "nutsid"
    FROM "public"."lau" as submain
    LEFT JOIN(
        SELECT nuts_code
        FROM "public"."nuts"
        WHERE name=$P{NUTS3}
    )
    as subsub0 on submain.nuts3_code=subsub0.nuts_code
	WHERE submain.nuts3_code=subsub0.nuts_code
)
as sub0 on main.pop_nuts_code=sub0.nutsid
WHERE main.pop_nuts_code=sub0.nutsid
ORDER BY pop_nuts_name