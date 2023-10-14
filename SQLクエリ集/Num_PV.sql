/*
期間を指定して1日ごとのページビュー数を集計
*/

select
  date(timestamp_micros(event_timestamp), 'Asia/Tokyo') as `日付`,
  count(1) as `ページビュー数`
from
  `ga4-bigquery-pj-392206.analytics_342165491.events_*`
where
  _table_suffix between '20230801'
  and '20230831'
  and event_name = 'page_view'
group by 1
order by 1
