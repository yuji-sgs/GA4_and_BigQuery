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
