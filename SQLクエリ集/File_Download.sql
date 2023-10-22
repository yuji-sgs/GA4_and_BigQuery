/*
ファイルダウンロード情報を取得
*/

select
    (select value.string_value from unnest(event_params) where event_name = 'file_download' and key = 'file_extension') as file_type,
    (select value.string_value from unnest(event_params) where event_name = 'file_download' and key = 'file_name') as file_name,　
    (select value.string_value from unnest(event_params) where event_name = 'file_download' and key = 'link_text') as link_text,
    (select value.string_value from unnest(event_params) where event_name = 'file_download' and key = 'link_url') as link_url,
    countif(event_name = 'file_download') as downloads
from
    `ga4-bigquery-pj-392206.analytics_342165491.events_*`
where
    _table_suffix between '20230708' and '20230916'
group by
    file_type,
    file_name,
    link_text,
    link_url
order by
    downloads desc
