/*
曜日別の平均セッション数を集計
*/

with predata as (
   select
    event_date,
    extract(dayofweek from parse_date('%Y%m%d', event_date)) as day_of_week,
    count(distinct concat(user_pseudo_id,  (select value.int_value from unnest(event_params) where key = 'ga_session_id'))) as session_count
  from
    `ga4-bigquery-pj-392206.analytics_342165491.events_*`
  group by event_date
  order by event_date
)

select
  case when day_of_week = 1 then '7. Sunday'
       when day_of_week = 2 then '1. Monday'
       when day_of_week = 3 then '2. Tuesday'
       when day_of_week = 4 then '3. Wednesday'
       when day_of_week = 5 then '4. Thursday'
       when day_of_week = 6 then '5. Friday'
       when day_of_week = 7 then '6. Saturday' 
  end as day_of_week,
  cast(avg(session_count) as int64) as avg_session
from
  predata
group by
  day_of_week
order by
  day_of_week
