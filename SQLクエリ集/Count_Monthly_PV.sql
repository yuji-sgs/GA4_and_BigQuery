/*
期間を指定して月ごとのページビュー数を集計
*/

select
  date_trunc(parse_date("%Y%m%d", event_date), month) as month,
  countif(event_name = 'page_view') as pv
from
  `ga4-bigquery-pj-392206.analytics_342165491.events_*`
group by
  month
order by
  month
