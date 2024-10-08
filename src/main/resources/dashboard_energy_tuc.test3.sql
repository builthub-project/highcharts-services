select pop_nuts_name, round(sum(tuc)::numeric, 3)
from "public"."dashboard_energy_tuc_001"
where pop_nuts_level = $P{POP_NUTS_LEVEL}
and nuts_code = $P{COUNTRY}
and feature = 'Total Final Energy Consumption'
group by pop_nuts_name
order by pop_nuts_name
