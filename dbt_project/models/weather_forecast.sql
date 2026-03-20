-- Example dbt model
SELECT  
  DATETIME(wf.timestamp, 'America/Bogota') AS timestamp,
  wf.temperature_2m,
  wf.apparent_temperature,
  wc.description
FROM `ibague-weather.weather_data.weather_forecast` wf
INNER JOIN `ibague-weather.weather_data.weather_codes` wc 
  ON wf.weather_code = wc.code
WHERE DATETIME(wf.timestamp, 'America/Bogota') >= DATE_TRUNC(DATETIME(CURRENT_TIMESTAMP(), 'America/Bogota'), DAY)
