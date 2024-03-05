/*
前後パス分析
*/

with prep1 as (
  select
    traffic_source.source as traffic_source,
    concat(user_pseudo_id, (select value.int_value from unnest(event_params) where key = 'ga_session_id')) as sid,
    (select value.string_value from unnest(event_params) where key = 'page_location') as page_location,
    event_timestamp

  from
   `ga4-bigquery-pj-392206.analytics_342165491.events_*`
  where
    event_name = 'page_view'
    and _table_suffix between '20240301' and '20240304'
),

prep2 as (
  select
    traffic_source,
    event_timestamp,
    sid,
    lag(page_location) over(partition by sid order by event_timestamp) as prev_page,
    page_location,
    lead(page_location) over(partition by sid order by event_timestamp) as next_page
  from
    prep1
)

select
  traffic_source,
  ifnull(prev_page, '( landing... )') as prev_page,
  page_location,
  ifnull(next_page, '( exit... )') as next_page,
  count(distinct sid) as session_count
from
  prep2
where
  page_location = 'https://sgs-prog.com/'
group by
  traffic_source,
  prev_page,
  page_location,
  next_page
having
  page_location not in (prev_page, next_page)
order by
  session_count desc
;
