# Cruise Yield Optimization

A configurable, multi-cruise-line yield optimization framework built on Snowflake.

## Overview

End-to-end yield optimization solution built on Snowflake,
featuring medallion architecture (RAW -> CURATED -> ANALYTICS -> ML -> CLEAN_ROOM),
semantic views with Cortex Analyst, ML pricing UDFs, Cortex Agents, and synthetic data generation.

Includes config profiles for multiple cruise lines. Generate and deploy a fully branded
solution by selecting a profile.

## Architecture

| Layer | Schema | Contents |
|-------|--------|----------|
| Bronze | RAW | 8 base tables (Sailings, Guests, Bookings, Spending, etc.) |
| Silver | CURATED | Guest 360 view, Guest Bookings, Flights, Services, Feedback |
| Gold | ANALYTICS | Sailing Yield, Pricing Performance, Semantic Views |
| ML | ML | Pricing Features table, 3 ML UDFs |
| Clean Room | CLEAN_ROOM | Airline Demand view for partner intelligence |

## Quick Start

```bash
# Generate SQL files for a cruise line profile
python generate.py royal_caribbean   # or: python generate.py norwegian

# Deploy to Snowflake
./deploy.sh [CONNECTION_NAME]

# Teardown
./clean.sh [CONNECTION_NAME]
```

## Available Profiles

| Profile | Database | Loyalty Program |
|---------|----------|-----------------|
| `royal_caribbean` | CRUISE_YIELD_OPTIMIZATION | Crown & Anchor Society |
| `norwegian` | NCL_YIELD_OPTIMIZATION | Latitudes Rewards |

## Data Volume

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

## Semantic Views

- **YIELD_ANALYTICS_SV** / **YIELD_ANALYTICS** - Sailing yield metrics
- **PRICING_ANALYTICS_SV** / **PRICING_ANALYTICS** - Pricing performance
- **PARTNER_SIGNALS_SV** / **PARTNER_SIGNALS** - Airline demand signals
- **GUEST_360_SV** / **GUEST_360** - Comprehensive guest intelligence

## ML Functions

- `PREDICT_CONVERSION_PROB(cabin, price, tier, sensitivity, past_cruises)` - Conversion probability
- `GET_OPTIMAL_PRICE_RECOMMENDATION(cabin, tier, sensitivity, past_cruises, season_mult)` - Optimal pricing
- `RUN_PRICING_SCENARIO_SIMPLE(cabin, base_price, discount_pct, tier, avg_sensitivity)` - Scenario analysis
