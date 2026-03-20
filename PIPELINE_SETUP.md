# Configuración del Pipeline Automático

## 📋 Resumen

El pipeline se ejecuta automáticamente todos los días a las **00:00 hrs hora Bogotá** usando **GitHub Actions**.

**Flujo:**
```
Dato → extraction.py (Obtiene datos de API) → BigQuery
     ↓
     dbt run (Transforma datos) → BigQuery
     ↓
     Looker (Visualiza datos)
```

---

## 🔐 Paso 1: Configurar Secrets en GitHub

Los secrets almacenan credenciales de forma segura en GitHub.

### Instrucciones:

1. Ve a tu repositorio en GitHub
2. Haz clic en **Settings** (Configuración)
3. En el menú lateral, ve a **Secrets and variables → Actions**
4. Haz clic en **New repository secret**

### Crea estos 3 secrets:

#### Secret 1: `GCP_CREDENTIALS`
- **Tipo**: JSON de Google Cloud
- **Valor**: Contenido completo del archivo `ibague-weather-68be5c322770.json`
- **Pasos**:
  1. Abre el archivo JSON con credenciales
  2. Copia TODO el contenido (asegúrate de copiar desde `{` hasta `}`)
  3. Pégalo en el valor del secret

```json
{
  "type": "service_account",
  "project_id": "ibague-weather",
  ...
}
```

#### Secret 2: `GCP_PROJECT_ID`
- **Valor**: `ibague-weather`

#### Secret 3: `GCP_DATASET`
- **Valor**: `weather_data`

---

## ⏰ Paso 2: Verificar Programación

El archivo `.github/workflows/weather-elt-pipeline.yml` contiene:

```yaml
on:
  schedule:
    - cron: '0 5 * * *'  # Todos los días a las 00:00 hrs Bogotá (05:00 UTC)
```

**Cambiar horario:**
- `0 5 * * *` = 00:00 Bogotá (UTC-5)
- `0 6 * * *` = 01:00 Bogotá
- `0 10 * * *` = 05:00 Bogotá

---

## 🧪 Paso 3: Probar el Pipeline

### Opción A: Ejecución manual desde GitHub
1. Ve a **Actions** en tu repositorio
2. Selecciona **Weather ELT Pipeline**
3. Haz clic en **Run workflow**

### Opción B: Ejecutar localmente
```bash
python ingestion/extraction.py
cd dbt_project
dbt run
```

---

## 📊 Verificar Resultados

### En BigQuery:
```sql
SELECT COUNT(*) FROM `ibague-weather.weather_data.weather_forecast`;
```

### En GitHub Actions:
1. Ve a la pestaña **Actions**
2. Haz clic en el workflow más reciente
3. Verifica que todos los pasos estén en ✅ verde

---

## 🐛 Solucionar Problemas

| Problema | Solución |
|----------|----------|
| "JSONDecodeError en credenciales" | Verifica que el JSON en `GCP_CREDENTIALS` sea válido (sin saltos de línea) |
| "Authentication failed" | Revisa que el archivo JSON tenga permisos de BigQuery |
| "dbt: command not found" | El workflow instala dbt automáticamente; verifica logs |
| "Table not found" | Asegúrate que `extraction.py` corra primero (está configurado así) |

---

## 📝 Archivos Modificados

- ✅ `.github/workflows/weather-elt-pipeline.yml` - Workflow de GitHub Actions
- ✅ `dbt_project/profiles.yml` - Configuración de conexión dbt
- ✅ `dbt_project/dbt_project.yml` - Configuración del proyecto dbt
- ✅ `ingestion/requirements.txt` - Agregado dbt-bigquery

---

## 🎯 Próximos Pasos

1. Configura los 3 secrets en GitHub
2. Haz push de los cambios al repositorio
3. Ve a **Actions** y verifica que el workflow esté activado
4. (Opcional) Ejecuta manualmente para probar
5. El pipeline se ejecutará automáticamente todos los días a las 00:00 hrs Bogotá
