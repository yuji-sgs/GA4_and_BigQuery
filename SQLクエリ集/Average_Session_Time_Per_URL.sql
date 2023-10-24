/*
ページごとのセッション数、滞在時間、平均セッション継続時間を集計
*/

with predata as (
  select
    timestamp_micros(event_timestamp) as event_timestamp,
    concat(user_pseudo_id, cast((select value.int_value from unnest(event_params) where key = 'ga_session_id') as string)) as sid,
    (select value.string_value from unnest(event_params) where key = 'page_location') as page_location
  from                    
    `ga4-bigquery-pj-392206.analytics_342165491.events_*`
  where
    _table_suffix between '20230801' and '20230831'
),
predata2 as (
  select
    event_timestamp,
    sid,
    page_location,
    case
      when timestamp_diff(lead(event_timestamp) over(partition by sid order by event_timestamp), event_timestamp, second) > 1800 then null
      else lead(event_timestamp) over(partition by sid order by event_timestamp) end as next_hit
  from predata
)
select
  predata2.page_location,
  count(distinct predata2.sid) as sessions,
  sum(ifnull(timestamp_diff(predata2.next_hit, predata2.event_timestamp, second), 0)) as total_time,
  round(safe_divide(sum(ifnull(timestamp_diff(predata2.next_hit, predata2.event_timestamp, second), 0)), count(distinct predata2.sid)), 2) as avg_time
from 
  predata2
where 
  predata2.page_location is not null
group by 
  1
order by 
  2 desc;
