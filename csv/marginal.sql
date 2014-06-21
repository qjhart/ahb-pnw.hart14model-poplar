set search_path=to_bcam,m3pgjs,public;

create temp table marginal as 
with m as (
 select pid,
 (r_0_5/6711)::decimal(6,2) as fraction
-- ((r_0_5+(r_5_10/2))/6711)::decimal(6,2) as fraction
 from marginal.data
) 
select a.* 
from harvest_avg a 
join m using (pid)
where fraction > 0.15 and date='2020-09-01'::date;

\COPY marginal to marginal.csv with csv header

