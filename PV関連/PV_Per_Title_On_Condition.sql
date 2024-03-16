/*
条件を指定して記事ごとのページビューを集計（人気順）
*/

select
  (select value.string_value from unnest(event_params) where key = 'page_title') as page_title,
  count(*) as pv_count
from
  `ga4-bigquery-pj-392206.analytics_342165491.events_*`
where
  _table_suffix between '20240201' and '20240229'
  and event_name = 'page_view'
group by
  page_title
having
  page_title like '%SWELL%'
order by
  pv_count desc
