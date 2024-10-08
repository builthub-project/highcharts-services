select pop_year
from "public"."dashboard_energy_tuc_001"
where pop_nuts_level = $P{POP_NUTS_LEVEL}
group by pop_year
order by pop_year DESC
