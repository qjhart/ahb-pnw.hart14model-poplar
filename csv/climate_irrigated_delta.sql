set search_path=to_bcam,climate_change,public;

create temp table ag as 
with a as (
 select pid,
 (sum(acres_harvested)*0.404686/6711)::decimal(6,2) as fraction 
 from pixel_nass_production 
 where year=2007 
 group by pid
) 
select * from a 
where fraction is not null 
order by fraction desc;

create temp table irrigated as
select a.* 
from irrigated_delta a 
join ag using (pid)
where fraction > 0.1;

\COPY irrigated to climate_irrigated_delta.csv with csv header

