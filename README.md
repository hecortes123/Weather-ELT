# Weather Forecasting ELT Pipeline

This project ingests weather data from the Open-Meteo API, loads it into BigQuery, transforms it with dbt, and prepares it for visualization in Looker.

## Structure
- `ingestion/`: Python scripts for data ingestion and loading to BigQuery
- `dbt_project/`: dbt project for data transformation
- `looker/`: Looker setup and LookML files

## Setup
1. Configure your Google Cloud and BigQuery credentials
2. Install Python dependencies (see `ingestion/`)
3. Set up and run dbt transformations (see `dbt_project/`)
4. Connect Looker to your BigQuery dataset

---

Replace placeholders and add your credentials/configuration as needed.