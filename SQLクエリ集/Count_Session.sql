/*
日次のセッション数を集計
*/

with prep as (
  select
    event_date,
    user_pseudo_id,
    (select value.int_value from unnest(event_params) where key = 'ga_session_id') as ga_session_id
  from
    `ga4-bigquery-pj-392206.analytics_342165491.events_*`
  where
    _table_suffix between '20240101' and '20240131'
)

select
  event_date,
  count(distinct concat(user_pseudo_id, ga_session_id)) as session_count
from
  prep
group by
  event_date
order by
  event_date
;
