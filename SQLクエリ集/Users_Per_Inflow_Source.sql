/*
流入元ごとのユーザー数を集計
*/

select
    traffic_source.source,
    traffic_source.medium,
    traffic_source.name as campaign,
    count(distinct user_pseudo_id) as users
from
    `ga4-bigquery-pj-392206.analytics_342165491.events_*`
where
    _table_suffix between '20230801' and '20230831'
group by
    source,
    medium,
    campaign
order by
    users desc
