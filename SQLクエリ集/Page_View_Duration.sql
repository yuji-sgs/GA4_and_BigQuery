/*
特定の記事のページ滞在時間を集計（ページビューごと）
*/

with pageviews as (
  select
    user_pseudo_id,
    timestamp_micros(event_timestamp) as event_timestamp,
    lead(timestamp_micros(event_timestamp)) over (partition by user_pseudo_id order by event_timestamp) as next_event_timestamp,
    (select value.string_value from unnest(event_params) where key = 'page_location') as page_location
  from
    `ga4-bigquery-pj-392206.analytics_342165491.events_*`
  where
    event_name = 'page_view'
    and _table_suffix between '20231101' and '20231130'
)
select
  user_pseudo_id,
  page_location,
  timestamp_diff(next_event_timestamp, event_timestamp, second) as stay_duration
from
  pageviews
where
  page_location = 'https:/〇〇.com/〇〇/'
  and next_event_timestamp is not null
  and timestamp_diff(next_event_timestamp, event_timestamp, second) <= 1800 -- 1800秒より上の値は極端なケースとして除外
