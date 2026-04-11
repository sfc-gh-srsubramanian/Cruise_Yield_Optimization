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

**ML** -- 1 feature table, 3 SQL UDFs
- `PRICING_FEATURES`: 17-column feature-engineered table (1M rows) for model training.
- `PREDICT_CONVERSION_PROB(FLOAT, VARCHAR, VARCHAR, FLOAT, FLOAT) -> FLOAT`: Booking conversion probability (0.05-0.95) factoring price sensitivity, loyalty tier, cabin class, offered price, and seasonality.
- `GET_OPTIMAL_PRICE_RECOMMENDATION(...) -> OBJECT`: Returns optimal price, predicted onboard spend, expected total value, conversion probability, and confidence score.
- `RUN_PRICING_SCENARIO_SIMPLE(FLOAT, FLOAT, NUMBER) -> OBJECT`: What-if analysis returning scenario revenue, volume impact, and recommendation text.

**CLEAN_ROOM** -- 1 synthetic view
- `V_AIRLINE_DEMAND`: GENERATOR-based view producing 91-day rolling airline demand signals (price index, demand score, seat availability, anomaly detection) using deterministic HASH-based randomization.

### Semantic Views

The GUEST_360 Cortex Analyst semantic view is the most complex, spanning 5 tables with 4 relationships, facts with synonyms, and dimensions across guest, booking, flight, service, and feedback domains. All semantic views include `WITH EXTENSION (CA=...)` JSON for Cortex Analyst integration.

### Deployment

```bash
./deploy.sh [CONNECTION_NAME]   # Deploys all 11 SQL files in order
./clean.sh [CONNECTION_NAME]    # Drops database + warehouse
```

Requires Snowflake account with ACCOUNTADMIN role and SnowCLI (`snow`) installed. Single Medium warehouse (`CRUISE_ANALYTICS_WH`) handles all workloads.
