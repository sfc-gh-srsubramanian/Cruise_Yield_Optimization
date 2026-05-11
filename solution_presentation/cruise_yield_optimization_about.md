# About Cruise Yield Optimization

## For Executives

Every cruise sailing is a perishable asset. An unsold cabin on tonight's departure generates zero revenue -- forever. Yet most cruise operators price cabins using the same spreadsheet models they used a decade ago, blind to the guest intelligence and demand signals that could unlock millions in additional yield.

Cruise Yield Optimization is a Snowflake-native solution that unifies every revenue-relevant data point -- cabin bookings, onboard spending, pre-cruise purchases, guest loyalty profiles, and airline partner demand signals -- into a single platform. Revenue managers get answers to yield questions in seconds instead of days. Pricing teams receive ML-driven recommendations that factor in each guest's price sensitivity, loyalty tier, and lifetime value. The result: 2.5-4% net yield improvement per available passenger cruise day, translating to $50-80M annually for a mid-sized fleet.

The solution requires no external infrastructure. Everything runs on Snowflake: data ingestion, transformation, machine learning inference, natural language analytics, and secure partner data sharing. Deploy in weeks, not quarters.

**Key outcomes:**
- Unified net yield per passenger cruise day across all revenue streams
- Guest 360 profiles with value segmentation for personalized pricing
- ML-driven optimal price recommendations per guest segment and cabin class
- Natural language querying for revenue managers (no SQL required)
- Secure airline partner signal integration via clean room

---

## For Technical Teams

### Architecture

The solution implements a four-layer medallion architecture within a single Snowflake database (`CRUISE_YIELD_OPTIMIZATION`):

**RAW (Bronze)** -- 8 source tables (8.8M+ rows total)
Ingests operational data: SAILINGS (5K), GUESTS (500K), BOOKINGS (2M), ONBOARD_SPENDING (2M), PRECRUISE_PURCHASES (1M), PRICING_EVENTS (1M), PARTNER_SIGNALS (100K), GUEST_FEEDBACK (500K). Internal stage (`DATA_STAGE`) supports bulk loading.

**CURATED (Silver)** -- 2 tables, 3 views
GUEST_FLIGHTS and GUEST_SERVICES tables store enriched flight and service transaction data. Three views provide analytics-ready assets:
- `GUEST_360`: 4-CTE view joining guests with booking metrics, spending aggregates, pre-cruise purchases, and service spend by category. Computes value segmentation (6 segments based on loyalty tier and price sensitivity).
- `GUEST_BOOKINGS`: Enriched booking view joining bookings with sailing metadata, adds SAILING_STATUS (UPCOMING/PAST).
- `GUEST_FEEDBACK`: Curated feedback with renamed columns for semantic clarity.

**ANALYTICS (Gold)** -- 2 analytical views, 8 semantic views, 1 table function
- `V_SAILING_YIELD`: Net yield per APCD calculation using 4 CTEs (booking_metrics, spend_metrics, precruise_metrics, occupancy_calc). Occupancy uses a 0.68 base + 2.35x passenger ratio formula. Revenue scaled by 13.0 multiplier.
- `V_PRICING_PERFORMANCE`: Conversion rates by ship, cabin class, region, and time period with price tier classification.
- 4 basic semantic views + 4 Cortex Analyst semantic views with verified queries (18 total), sample values, and onboarding questions.
- `CORTEX_ANALYST_QUERY`: Table function wrapping SNOWFLAKE.CORTEX.COMPLETE for natural language SQL generation.

**ML** -- 3 feature/staging tables, 3 trained ML models, 3 inference UDFs
- `PRICING_FEATURES`: 17-column feature-engineered table (1M rows) for model training.
- `REVENUE_TIMESERIES`: Weekly revenue aggregated by region for forecast training.
- `PRICING_TIMESERIES`: Weekly conversion rates by cabin class for anomaly detection training.
- **CONVERSION_CLASSIFIER** (`SNOWFLAKE.ML.CLASSIFICATION`): Gradient-boosted model trained on 1M pricing events. Predicts booking conversion probability (0.0-1.0) based on price sensitivity, loyalty tier, cabin class, offered price, season, and price ratio.
- **REVENUE_FORECAST** (`SNOWFLAKE.ML.FORECAST`): Time-series model trained on weekly revenue by region. Projects future revenue for what-if scenario planning.
- **PRICING_ANOMALY_DETECTOR** (`SNOWFLAKE.ML.ANOMALY_DETECTION`): Trained on weekly conversion rates by cabin class. Identifies periods of unusual pricing volatility.
- `PREDICT_CONVERSION_PROB(FLOAT, VARCHAR, VARCHAR, FLOAT, FLOAT) -> FLOAT`: Calls CONVERSION_CLASSIFIER!PREDICT for real ML inference. Returns trained model's predicted conversion probability.
- `GET_OPTIMAL_PRICE_RECOMMENDATION(...) -> OBJECT`: Evaluates 8 price points (0.8x-1.2x base) through the classification model. Returns optimal price, expected revenue per impression, conversion probability, and predicted onboard spend.
- `RUN_PRICING_SCENARIO(FLOAT, VARCHAR, NUMBER) -> OBJECT`: Uses REVENUE_FORECAST for projected revenue under price changes and historical volatility analysis for risk assessment. Returns scenario revenue, anomaly count, risk flag, and recommendation.

**CLEAN_ROOM** -- 1 synthetic view
- `V_AIRLINE_DEMAND`: GENERATOR-based view producing 91-day rolling airline demand signals (price index, demand score, seat availability, anomaly detection) using deterministic HASH-based randomization.

### Semantic Views

The GUEST_360 Cortex Analyst semantic view is the most complex, spanning 5 tables with 4 relationships, facts with synonyms, and dimensions across guest, booking, flight, service, and feedback domains. All semantic views include `WITH EXTENSION (CA=...)` JSON for Cortex Analyst integration.

### Deployment

```bash
./deploy.sh <profile> [CONNECTION_NAME]   # Deploys all 14 SQL files in order
./clean.sh <profile> [CONNECTION_NAME]    # Drops database + warehouse
```

Requires Snowflake account with ACCOUNTADMIN role and SnowCLI (`snow`) installed. Single Medium warehouse handles all workloads including ML model training.
