select pop_nuts_name, pop_year, sum(tuc)
from "public"."dashboard_energy_tuc_001"
where pop_nuts_level = $P{POP_NUTS_LEVEL}
group by pop_nuts_name, pop_year
order by pop_nuts_name, pop_year
