/*
デバイスごとのユーザー数を期間を指定して集計
*/

select
    device.category,
    count(distinct user_pseudo_id) as users
from
    `ga4-bigquery-pj-392206.analytics_342165491.events_*`
where
    _table_suffix between '20230801' and '20230831' -- 日付の指定
group by
    device.category
order by
    users desc  -- ユーザー降順で並び替え
