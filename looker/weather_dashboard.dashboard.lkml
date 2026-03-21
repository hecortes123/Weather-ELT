- dashboard: pronostico_ibague
  title: "Estado del Clima - Ibagué"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Monitoreo de temperatura y condiciones climáticas"

  elements:
    # 1. KPI: Temperatura Máxima del Día
    - name: max_temp_today
      title: "Temperatura Máxima Hoy"
      model: weather_analytics  # Asegúrate que coincida con el nombre de tu archivo .model
      explore: weather_forecast
      type: single_value
      metric: weather_forecast.max_temperature
      filters:
        weather_forecast.timestamp_date: "today"
      font_size: medium
      text_color: "#ea4335" # Rojo Google

    # 2. KPI: Temperatura Promedio
    - name: avg_temp_today
      title: "Temperatura Promedio"
      model: weather_analytics
      explore: weather_forecast
      type: single_value
      metric: weather_forecast.avg_temperature
      filters:
        weather_forecast.timestamp_date: "today"
      font_size: medium

    # 3. GRÁFICO: Evolución de la Temperatura (Líneas)
    - name: temperature_evolution
      title: "Evolución de la Temperatura (Próximas Horas)"
      model: weather_analytics
      explore: weather_forecast
      type: looker_line
      dimensions: [weather_forecast.timestamp_time]
      measures: [weather_forecast.temperature_2m, weather_forecast.apparent_temperature]
      filters:
        weather_forecast.timestamp_date: "2 days" # Muestra hoy y mañana
      plot_size_by_field: false
      show_y_axis_labels: true
      show_x_axis_label: false
      legend_position: center
      series_types: {}
      x_axis_datetime_label: "%H:%M"

    # 4. TABLA: Resumen de Condiciones
    - name: weather_summary_table
      title: "Detalle de Condiciones"
      model: weather_analytics
      explore: weather_forecast
      type: looker_grid
      dimensions: [weather_forecast.timestamp_time, weather_forecast.weather_description]
      measures: [weather_forecast.temperature_2m]
      sorts: [weather_forecast.timestamp_time]
      limit: 24 # Próximas 24 observaciones