/*
特定のユーザーの行動を把握
*/

select
  event_name,
  user_pseudo_id,
  REPLACE(FORMAT_TIMESTAMP('%Y-%m-%d %H:%M:%S', TIMESTAMP_MICROS(event_timestamp), 'Asia/Tokyo'), 'T', ' ') AS jst_time,
  event_params
from
  `ga4-bigquery-pj-392206.analytics_342165491.events_*`
where
  _table_suffix between '20240201' and '20240225'
  and user_pseudo_id = 'user_id'
order by
  jst_time
