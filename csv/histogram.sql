set search_path=to_bcam,m3pgjs,public;

create temp table iy as 
with x as (
 select pid,
 sum(acres_harvested)*0.404686 as ha,
 (sum(acres_harvested)*0.404686/6711)::decimal(6,2) as fraction 
 from pixel_nass_production 
 where year=2007 
 group by pid
),
y as (
 select pid,avg(avg_irrigated_yield) as yield
 from harvest_avg
 group by pid
)
select pid,yield,ha from y join x using (pid)
where fraction is not null;

create temp table ih as 
select 
(yield/2)::integer*2  as yield, 
sum(ha)::integer as ha
from iy group by (yield/2)::integer*2 order by 1;

create temp table ny as 
with y as (
 select pid,avg(avg_nonirrigated_yield) as yield
 from harvest_avg
 group by pid
)
select pid,yield,r_0_5 as ha
from marginal.data join y using (pid)
where r_0_5 is not null;

create temp table nh as 
select 
(yield/2)::integer*2  as yield, 
sum(ha)::integer as ha
from ny group by (yield/2)::integer*2 order by 1;

create temp table histogram as
select yield,coalesce(ih.ha,0) irrigated,coalesce(nh.ha,0) as nonirrigated 
from nh full outer join ih using (yield) 
order by yield;

\COPY histogram to histogram.csv with csv header


