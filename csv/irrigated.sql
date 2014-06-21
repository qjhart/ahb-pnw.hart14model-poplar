set search_path=to_bcam,m3pgjs,public;

create temp table agriculture as 
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
from harvest_avg a 
join agriculture using (pid)
where fraction > 0.1 and date='2020-09-01'::date;

\COPY irrigated to irrigated.csv with csv header

