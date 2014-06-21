set search_path=climate_change,public;

create temp table diff as 
with new as (
 select pid,scenario,i-483 as i,(weather[i]).* 
 from pixel_weather, generate_series(483,483+11) as i 
 where scenario='A1B'
),
cur as (
  select pid,scenario,i-123 as i,(weather[i]).* 
  from pixel_weather, generate_series(123,123+11) as i
 where scenario='A1B'
) 
select pid,scenario,
(avg((new.tmax+new.tmin)/2)-avg((cur.tmax+cur.tmin)/2))::decimal(6,2) as dtmean,
(sum(new.ppt)-sum(cur.ppt))::decimal(6,2) as dppt
from new join cur using (pid,scenario,i)
group by pid,scenario;

\COPY diff to delta_2040.csv with CSV HEADER


