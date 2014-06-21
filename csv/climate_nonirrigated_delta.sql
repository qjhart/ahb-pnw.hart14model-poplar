set search_path=to_bcam,climate_change,public;

create temp table climate_nonirrigated_delta as 
with m as (
 select pid,
 (r_0_5/6711)::decimal(6,2) as fraction
-- ((r_0_5+(r_5_10/2))/6711)::decimal(6,2) as fraction
 from marginal.data
) 
select a.* 
from nonirrigated_delta a 
join m using (pid)
where fraction > 0.15;

\COPY climate_nonirrigated_delta to climate_nonirrigated_delta.csv with csv header

