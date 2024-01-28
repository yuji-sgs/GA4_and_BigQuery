/*
外部リンクの遷移先取得
*/

select
  (select value.string_value from unnest(event_params) where key = 'page_location') as page_location,
  (select value.string_value from unnest(event_params) where key = 'link_url') as link_url,
  timestamp_micros(event_timestamp) + interval 9 hour as event_time_jst
from
  `ga4-bigquery-pj-392206.analytics_342165491.events_*` 
where
  event_name = 'click'
  and _table_suffix between '20240114' and '20240114'
group by
  page_location,
  link_url,
  event_time_jst
order by
  event_time_jst
