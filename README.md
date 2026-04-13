# Cruise Yield Optimization

End-to-end yield optimization solution for the cruise industry built on Snowflake,
featuring medallion architecture (RAW -> CURATED -> ANALYTICS -> ML -> CLEAN_ROOM),
semantic views with Cortex Analyst, ML pricing UDFs, Cortex Agents, and synthetic data generation.

## Available Profiles

| Profile | Database | Warehouse | Agent Prefix | Data Identity |
|---------|----------|-----------|-------------|---------------|
| `cruise` | `CRUISE_YIELD_OPTIMIZATION` | `CRUISE_ANALYTICS_WH` | `CRUISE_` | Blended (generic) |
| `royal_caribbean` | `RCL_YIELD_OPTIMIZATION` | `RCL_ANALYTICS_WH` | `RCL_` | Royal Caribbean |
| `norwegian` | `NCL_YIELD_OPTIMIZATION` | `NCL_ANALYTICS_WH` | `NCL_` | Norwegian Cruise Line |

## Quick Start

```bash
# Deploy a profile (generates SQL from templates + deploys to Snowflake)
./deploy.sh cruise                      # Generic cruise, default connection
./deploy.sh royal_caribbean SS_CURSOR   # RCL profile, specific connection
./deploy.sh norwegian default           # NCL profile, default connection

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
generated/<profile>/sql/  -- Profile-specific SQL files
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
| ML | ML | Pricing Features table, 3 ML UDFs |
| Clean Room | CLEAN_ROOM | Airline Demand view for partner intelligence |

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

## Adding a New Cruise Line

1. Copy `config/cruise.json` to `config/<new_profile>.json`
2. Edit the JSON with cruise-line-specific ships, ports, loyalty tiers, etc.
3. Deploy: `./deploy.sh <new_profile> [connection]`
