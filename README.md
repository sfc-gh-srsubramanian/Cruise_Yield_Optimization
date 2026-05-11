# Cruise Yield Optimization

End-to-end yield optimization solution for the cruise industry built on Snowflake,
featuring medallion architecture (RAW -> CURATED -> ANALYTICS -> ML -> CLEAN_ROOM),
semantic views with Cortex Analyst, real Snowflake ML models (Classification, Forecast,
Anomaly Detection), Cortex Agents, and synthetic data generation.

## Available Profiles

| Profile | Database | Warehouse | Agent Prefix | Data Identity |
|---------|----------|-----------|-------------|---------------|
| `cruise` | `CRUISE_YIELD_OPTIMIZATION` | `CRUISE_ANALYTICS_WH` | `CRUISE_` | Blended (generic) |
| `royal_caribbean` | `RCL_YIELD_OPTIMIZATION` | `RCL_ANALYTICS_WH` | `RCL_` | Royal Caribbean |
| `norwegian` | `NCL_YIELD_OPTIMIZATION` | `NCL_ANALYTICS_WH` | `NCL_` | Norwegian Cruise Line |
| `carnival` | `CCL_YIELD_OPTIMIZATION` | `CCL_ANALYTICS_WH` | `CCL_` | Carnival Cruise Line |
| `holland_america` | `HAL_YIELD_OPTIMIZATION` | `HAL_ANALYTICS_WH` | `HAL_` | Holland America Line |
| `princess` | `PCL_YIELD_OPTIMIZATION` | `PCL_ANALYTICS_WH` | `PCL_` | Princess Cruises |

## Quick Start

```bash
# Deploy a profile (generates SQL from templates + deploys to Snowflake)
./deploy.sh cruise                      # Generic cruise, default connection
./deploy.sh royal_caribbean SS_CURSOR   # RCL profile, specific connection
./deploy.sh norwegian default           # NCL profile, default connection

# Generate a new cruise line config via Cortex AI
python3 generate_config.py disney       # Auto-generates config/disney.json

# Teardown a profile
./clean.sh cruise [connection]
./clean.sh royal_caribbean [connection]
./clean.sh norwegian [connection]
```

## How It Works

```
config/<profile>.json     -- Cruise-line-specific data (ships, ports, loyalty, etc.)
        |
        v
generate.py <profile>    -- Renders templates with config values
        |
        v
generated/<profile>/sql/  -- Profile-specific SQL files (14 scripts)
        |
        v
deploy.sh <profile>       -- Deploys to Snowflake via snow sql
```

## Architecture

| Layer | Schema | Contents |
|-------|--------|----------|
| Bronze | RAW | 8 base tables (Sailings, Guests, Bookings, Spending, etc.) |
| Silver | CURATED | Guest 360 view, Guest Bookings, Flights, Services, Feedback |
| Gold | ANALYTICS | Sailing Yield, Pricing Performance, Semantic Views |
| ML | ML | Feature tables, 3 trained ML models, 3 inference UDFs |
| Clean Room | CLEAN_ROOM | Airline Demand view for partner intelligence |

## Machine Learning Models

All models are trained using **real Snowflake ML Functions** — no mock heuristics.

| Model | Type | Training Data | Purpose |
|-------|------|---------------|---------|
| `CONVERSION_CLASSIFIER` | `SNOWFLAKE.ML.CLASSIFICATION` | 1M pricing events (PRICING_FEATURES) | Predicts booking conversion probability per guest/cabin/price |
| `REVENUE_FORECAST` | `SNOWFLAKE.ML.FORECAST` | Weekly revenue time-series by region | Projects future revenue trends for scenario planning |
| `PRICING_ANOMALY_DETECTOR` | `SNOWFLAKE.ML.ANOMALY_DETECTION` | Weekly conversion rates by cabin class | Identifies unusual pricing patterns and volatility |

### Inference UDFs

| Function | Returns | Description |
|----------|---------|-------------|
| `PREDICT_CONVERSION_PROB(sensitivity, tier, cabin, price, season)` | FLOAT | Real ML prediction of booking conversion probability |
| `GET_OPTIMAL_PRICE_RECOMMENDATION(sensitivity, tier, cabin, spend, season)` | OBJECT | Evaluates 8 price points via the classifier, returns optimal price maximizing expected revenue |
| `RUN_PRICING_SCENARIO(pct_change, cabin_class, weeks)` | OBJECT | Uses Forecast model for revenue projection + anomaly detection for risk assessment |

## Cortex Agents (per profile)

| Agent | Description |
|-------|-------------|
| `<PREFIX>_YIELD_ANALYST` | Fleet yield, occupancy, revenue by ship/region |
| `<PREFIX>_GUEST_INTEL` | Guest profiles, loyalty tiers, lifetime value |
| `<PREFIX>_PRICING_COPILOT` | Conversion funnels, price trends, recommendations |
| `<PREFIX>_PARTNER_INSIGHTS` | Airline demand signals, flight pricing |
| `<PREFIX>_YIELD_OPTIMIZATION_AGENT` | Unified agent across all data sources |

## Data Volume (per profile)

| Table | Rows |
|-------|------|
| SAILINGS | 5,000 |
| GUESTS | 500,000 |
| BOOKINGS | 2,000,000 |
| ONBOARD_SPENDING | 2,000,000 |
| PRECRUISE_PURCHASES | 1,000,000 |
| PRICING_EVENTS | 1,000,000 |
| PARTNER_SIGNALS | 100,000 |
| GUEST_FEEDBACK | 500,000 |
| GUEST_FLIGHTS | 300,000 |
| GUEST_SERVICES | 390,000 |
| PRICING_FEATURES | 1,000,000 |
| **Total** | **~8.8M** |

## Deployment Steps (14 scripts)

| # | Script | Description |
|---|--------|-------------|
| 01 | `infrastructure.sql` | Database, schemas, warehouse |
| 02 | `raw_tables.sql` | Bronze layer table definitions |
| 03 | `curated_tables.sql` | Silver layer tables |
| 04 | `curated_views.sql` | Guest 360, enriched views |
| 05 | `analytics_views.sql` | Yield and pricing performance views |
| 06 | `clean_room_views.sql` | Airline demand partner view |
| 07 | `ml_objects.sql` | ML feature/staging table definitions |
| 08 | `semantic_views_basic.sql` | Basic semantic views |
| 09 | `semantic_views_ca.sql` | Cortex Analyst semantic views |
| 10 | `analytics_functions.sql` | Cortex Analyst query helper |
| 11 | `load_data.sql` | Synthetic data generation (8.8M rows) |
| 12 | `agents.sql` | 5 Cortex Agent definitions |
| 13 | `register_si.sql` | Snowflake Intelligence registration |
| 14 | `ml_training.sql` | **Train 3 ML models + create inference UDFs** |

## Adding a New Cruise Line

1. Run `python3 generate_config.py <name>` — auto-generates config via Cortex AI
2. Or copy `config/cruise.json` to `config/<new_profile>.json` and edit manually
3. Deploy: `./deploy.sh <new_profile> [connection]`
