/*
ページごとの流入回数、直帰数、直帰率を集計
*/

with predata as (
  select
    event_timestamp,
    user_pseudo_id,
    (select value.int_value from unnest(event_params) where key = 'ga_session_id') as session_id,
    (select value.string_value from unnest(event_params) where key = 'page_location') as page_location
  from
    `ga4-bigquery-pj-392206.analytics_342165491.events_*`
  where
    _table_suffix between '20230708' and '20231006'
    and event_name = 'page_view'
),
predata2 as (
  select
    page_location,
    case
      when row_number() over(partition by session_id order by event_timestamp) = 1 then 1 else 0
    end as entrance,
    case
      when row_number() over(partition by user_pseudo_id, session_id order by event_timestamp desc) = 1 then 1 else 0
    end as exit,
    case
      when count(1) over(partition by session_id) = 1 then 1 else 0
    end as bounce
  from predata
)
select
    page_location,
    sum(entrance) as landing,
    sum(bounce) as bounce,
    -- 直帰率の計算（直帰数 / 流入回数 * 100）
    case
      when sum(entrance) > 0 then round((sum(bounce) / sum(entrance)) * 100, 2)
      else 0
    end as bounce_rate
from
    predata2
group by
    page_location
order by
    landing desc;
