-- YYYY-MM-DD
date(timestamp_micros(event_timestamp), 'Asia/Tokyo') as jst_time

-- YYYY-MM-DD HH:MM:SS
format_timestamp('%Y-%m-%d %H:%M:%S', timestamp_micros(event_timestamp), 'Asia/Tokyo') as jst_time
