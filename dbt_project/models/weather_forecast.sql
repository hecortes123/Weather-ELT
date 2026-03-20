SELECT  
  DATETIME(wf.timestamp, '{{ var("timezone") }}') AS timestamp,
  wf.temperature_2m,
  wf.apparent_temperature,
  wc.description
FROM {{ source('weather_data', 'weather_forecast') }} wf
INNER JOIN {{ source('weather_data', 'weather_codes') }} wc 
  ON wf.weather_code = wc.code
WHERE DATETIME(wf.timestamp, '{{ var("timezone") }}') >= DATE_TRUNC(DATETIME(CURRENT_TIMESTAMP(), '{{ var("timezone") }}'), DAY)
