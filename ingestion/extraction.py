"""
Weather Data Ingestion Script

Author: Hector Cortes
Version: 1.0
Email: hecortes123@gmail.com
Date: March 13, 2026

Description:
    Ingest weather data from Open-Meteo API and load into BigQuery.
"""

import requests # For making HTTP requests to the Open-Meteo API
import urllib3  # For disabling SSL warnings

# Deshabilita warnings de SSL (opcional, para menos ruido)
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

from google.cloud import bigquery # For interacting with Google BigQuery
import os # For accessing environment variables (e.g., BigQuery credentials and table ID)
from dotenv import load_dotenv

load_dotenv(override=True)  # Load environment variables from .env file, overriding existing

def fetch_weather_data(latitude, longitude, hourly_params):
    url = f"https://api.open-meteo.com/v1/forecast?latitude={latitude}&longitude={longitude}&hourly={hourly_params}&timezone=America/Bogota"
    response = requests.get(url)
    if response.status_code == 200:
        print("API Open-Meteo is online y responded correctly.")
        return response.json()
    else:
        print(f"Error: API Open-Meteo isn't available. Response code: {response.status_code}")
        return None

def ensure_table_exists(client, table_id):
    from google.cloud.exceptions import NotFound
    from google.cloud import bigquery
    
    # Define schema for weather_forecast table
    schema = [
        bigquery.SchemaField("timestamp", "TIMESTAMP", mode="REQUIRED"),
        bigquery.SchemaField("temperature_2m", "FLOAT64"),
        bigquery.SchemaField("apparent_temperature", "FLOAT64"),
        bigquery.SchemaField("weather_code", "INT64"),
    ]
    
    try:
        client.get_table(table_id)
        print(f"Table {table_id} exists.")
    except NotFound:
        print(f"Table {table_id} does not exist. Creating...")
        table = bigquery.Table(table_id, schema=schema)
        client.create_table(table)
        print("Table created.")

def transform_data_to_rows(data):
    if not data or "hourly" not in data:
        return []
    
    hourly = data["hourly"]
    times = hourly.get("time", [])
    temps = hourly.get("temperature_2m", [])
    apparent_temps = hourly.get("apparent_temperature", [])
    weather_codes = hourly.get("weather_code", [])
    
    rows = []
    for i in range(len(times)):
        row = {
            "timestamp": times[i],
            "temperature_2m": temps[i] if i < len(temps) else None,
            "apparent_temperature": apparent_temps[i] if i < len(apparent_temps) else None,
            "weather_code": weather_codes[i] if i < len(weather_codes) else None,
        }
        rows.append(row)
    return rows

def load_to_bigquery(data, table_id):
    client = bigquery.Client()
    ensure_table_exists(client, table_id)
    rows = transform_data_to_rows(data)
    if rows:
        errors = client.insert_rows_json(table_id, rows)
        if errors:
            print(f"Encountered errors: {errors}")
        else:
            print("Data loaded successfully.")
    else:
        print("No data to load.")

def main():
    # Example: Ibague, Colombia
    latitude = 4.4389  
    longitude = -75.2322
    hourly_params = "temperature_2m,apparent_temperature,weather_code"
    table_id = os.environ.get("BQ_TABLE_ID", "ibague-weather.weather_data.weather_forecast")
    data = fetch_weather_data(latitude, longitude, hourly_params)
    if data:
        load_to_bigquery(data, table_id)
    else:
        print("No data fetched.")

if __name__ == "__main__":
    main()
