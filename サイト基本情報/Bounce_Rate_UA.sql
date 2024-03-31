/*
サイト全体の直帰率を集計（UA指標）
*/


with predata as (
  select
    event_timestamp,
    user_pseudo_id,
    (select value.int_value from unnest(event_params) where key = 'ga_session_id') as session_id
  from
    `ga4-bigquery-pj-392206.analytics_342165491.events_*`
  where
    _table_suffix between '20240201' and '20240229'
    and event_name = 'page_view'
),
predata2 as (
  select
    case
      when row_number() over(partition by session_id order by event_timestamp) = 1 then 1 else 0
    end as entrance,
    case
      when count(1) over(partition by session_id) = 1 then 1 else 0
    end as bounce
  from predata
)
select
    sum(entrance) as `流入回数`,
    sum(bounce) as `直帰数`,
    -- 直帰率の計算（直帰数 / 流入回数 * 100）
    case
      when sum(entrance) > 0 then round((sum(bounce) / sum(entrance)) * 100, 2)
      else 0
    end as `サイト全体の直帰率`
from
    predata2;
