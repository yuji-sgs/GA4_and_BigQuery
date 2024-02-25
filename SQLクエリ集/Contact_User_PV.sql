/*
お問い合わせページに訪れたユーザーを集計
*/

with pv as (
  select
    event_name,
    user_pseudo_id,
    (select value.string_value from unnest(event_params) where key = 'page_location') as page_url,
    REPLACE(FORMAT_TIMESTAMP('%Y-%m-%d %H:%M:%S', TIMESTAMP_MICROS(event_timestamp), 'Asia/Tokyo'), 'T', ' ') AS jst_time
  from
    `ga4-bigquery-pj-392206.analytics_342165491.events_*`
  where
    _table_suffix between '20240201' and '20240215'
    and event_name = 'page_view'
)

select
  event_name,
  user_pseudo_id,
  page_url,
  jst_time
from
  pv
where
  page_url = 'https://sgs-prog.com/contact/'
order by
  jst_time
