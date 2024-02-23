create temporary function 
   get_value(params ANY TYPE,name STRING ) AS  
   ( ( 
       select 
           coalesce( 
               value.string_value 
               , cast(value.int_value as string) 
               , cast(value.float_value as string) 
               , cast(value.double_value as string) 
               ) 
       from 
           unnest(params) AS x 
       where 
           x.key = name 
   ) ); 

select 
   regexp_extract(lower(get_value(event_params, 'page_location')),r'^([^\?]+)') as page_location 
   , count(1) as pv 
from 
   `ga4-bigquery-pj-392206.analytics_342165491.events_*`
where 
   _table_suffix between '20240201' and '20240222' 
   and event_name = 'page_view' 
group by 
   page_location 
order by
   pv desc
