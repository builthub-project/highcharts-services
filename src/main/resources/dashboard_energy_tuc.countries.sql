select nuts_code, name
from "public"."dashboard_energy_tuc_001"
where pop_nuts_level = '0'
group by nuts_code, name
order by name ASC
