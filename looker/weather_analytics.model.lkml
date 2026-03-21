connection: "weather_forecast" # El nombre que configuraste en Admin > Connections

include: "/views/*.view.lkml"                # Incluye todas las vistas de tu carpeta
include: "/*.dashboard.lkml"                 # Incluye todos los dashboard de tu carpeta

explore: weather_forecast {
  label: "Pronóstico del Clima Ibagué"
  description: "Datos transformados de clima desde BigQuery"
}