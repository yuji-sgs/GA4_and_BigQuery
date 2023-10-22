/*
サイト内検索キーワードを取得
*/

select
    (select value.string_value from unnest(event_params) where event_name = 'view_search_results' and key = 'search_term') as search_term,
    countif(event_name = 'view_search_results') as searches
from
    `ga4-bigquery-pj-392206.analytics_342165491.events_*`
where
    _table_suffix between '20230708' and '20230916'
group by 
    search_term
order by 
    searches desc
