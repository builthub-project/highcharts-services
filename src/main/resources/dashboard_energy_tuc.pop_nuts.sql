select pop_nuts_code, pop_nuts_name
from "public"."dashboard_energy_tuc_001"
where
pop_nuts_level = $P{POP_NUTS_LEVEL}
and nuts_code = $P{COUNTRY}
group by pop_nuts_code, pop_nuts_name
order by pop_nuts_code ASC, pop_nuts_name ASC
