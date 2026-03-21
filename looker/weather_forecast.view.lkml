# LookML view for weather forecast data
view: weather_forecast {
  sql_table_name: `ibague-weather.weather_data.weather_forecast` ;;

  # DIMENSIONES (Attributes)
  
  dimension: timestamp {
    type: time
    timeframes: [time, date, week, month, year]
    sql: ${TABLE}.timestamp ;;
    description: "Timestamp of weather observation (America/Bogota timezone)"
  }

  dimension: temperature_2m {
    type: number
    sql: ${TABLE}.temperature_2m ;;
    value_format: "0.0# \"°C\""  # Esto añade el °C visualmente en Looker
  }

  dimension: apparent_temperature {
    type: number
    sql: ${TABLE}.apparent_temperature ;;
    description: "Apparent/feels-like temperature in Celsius"
    unit: "°C"
  }

  dimension: weather_description {
    type: string
    sql: ${TABLE}.description ;;
    description: "Weather condition description (e.g., Sunny, Cloudy, Rainy)"
  }

  # MEDIDAS (Aggregations)

  measure: count {
    type: count
    drill_fields: [timestamp, temperature_2m, apparent_temperature, weather_description]
    description: "Total number of weather observations"
  }

  measure: avg_temperature {
    type: average
    sql: ${TABLE}.temperature_2m ;;
    description: "Average temperature in Celsius"
    value_format: "0.0"
  }

  measure: max_temperature {
    type: max
    sql: ${TABLE}.temperature_2m ;;
    description: "Maximum temperature recorded in Celsius"
    value_format: "0.0"
  }

  measure: min_temperature {
    type: min
    sql: ${TABLE}.temperature_2m ;;
    description: "Minimum temperature recorded in Celsius"
    value_format: "0.0"
  }

  measure: avg_apparent_temperature {
    type: average
    sql: ${TABLE}.apparent_temperature ;;
    description: "Average apparent/feels-like temperature in Celsius"
    value_format: "0.0"
  }
}
