-- =============================================================================
-- Cruise Yield Optimization - Basic Semantic Views
-- Layer: Analytics (Gold)
-- Description: Simple semantic views without Cortex Analyst extensions
-- =============================================================================

USE SCHEMA CRUISE_YIELD_OPTIMIZATION.ANALYTICS;

-- ---------------------------------------------------------------------------
-- YIELD_ANALYTICS_SV: Yield performance metrics for cruise sailings
-- ---------------------------------------------------------------------------
CREATE OR REPLACE SEMANTIC VIEW YIELD_ANALYTICS_SV
    TABLES (
        SAILINGS AS CRUISE_YIELD_OPTIMIZATION.ANALYTICS.V_SAILING_YIELD
    )
    DIMENSIONS (
        SAILINGS.SAILING_ID AS sailing_id,
        SAILINGS.SHIP_NAME AS ship_name,
        SAILINGS.SHIP_CLASS AS ship_class,
        SAILINGS.ITINERARY_REGION AS itinerary_region,
        SAILINGS.DEPARTURE_PORT AS departure_port,
        SAILINGS.SAILING_DATE AS sailing_date
    )
    METRICS (
        SAILINGS.NET_YIELD AS SUM(net_revenue) / NULLIF(SUM(passenger_days), 0),
        SAILINGS.OCCUPANCY_RATE AS AVG(occupancy_rate),
        SAILINGS.CABIN_REVENUE AS SUM(cabin_revenue),
        SAILINGS.ONBOARD_REVENUE AS SUM(onboard_revenue),
        SAILINGS.PRECRUISE_REVENUE AS SUM(precruise_revenue),
        SAILINGS.TOTAL_REVENUE AS SUM(net_revenue),
        SAILINGS.PASSENGER_COUNT AS SUM(booked_passengers),
        SAILINGS.SAILING_COUNT AS COUNT(DISTINCT sailing_id)
    )
    COMMENT = 'Yield performance metrics for cruise sailings';

-- ---------------------------------------------------------------------------
-- GUEST_360_SV: Unified guest profiles with CLV scoring
-- ---------------------------------------------------------------------------
CREATE OR REPLACE SEMANTIC VIEW GUEST_360_SV
    TABLES (
        GUESTS AS CRUISE_YIELD_OPTIMIZATION.CURATED.GUEST_360
    )
    DIMENSIONS (
        GUESTS.GUEST_ID AS guest_360_id,
        GUESTS.FIRST_NAME AS first_name,
        GUESTS.LAST_NAME AS last_name,
        GUESTS.GUEST_NAME AS guest_name,
        GUESTS.EMAIL AS email,
        GUESTS.LOYALTY_TIER AS loyalty_tier,
        GUESTS.VALUE_SEGMENT AS value_segment,
        GUESTS.GUEST_SEGMENT AS guest_segment,
        GUESTS.PREFERRED_CABIN_CLASS AS preferred_cabin_class,
        GUESTS.PREFERRED_REGION AS preferred_region,
        GUESTS.PRICE_SENSITIVITY AS price_sensitivity
    )
    METRICS (
        GUESTS.LIFETIME_VALUE AS SUM(lifetime_value),
        GUESTS.CALCULATED_TOTAL_VALUE AS SUM(calculated_total_value),
        GUESTS.PAST_CRUISES AS SUM(past_cruises),
        GUESTS.TOTAL_CABIN_REVENUE AS SUM(total_cabin_revenue),
        GUESTS.TOTAL_ONBOARD_SPEND AS SUM(total_onboard_spend),
        GUESTS.TOTAL_PRECRUISE_SPEND AS SUM(total_precruise_spend),
        GUESTS.AVG_CABIN_PRICE AS AVG(avg_cabin_price),
        GUESTS.GUEST_COUNT AS COUNT(DISTINCT guest_360_id),
        GUESTS.LOYALTY_POINTS AS SUM(loyalty_points)
    )
    COMMENT = 'Unified guest profiles with CLV scoring and value segmentation';

-- ---------------------------------------------------------------------------
-- PRICING_ANALYTICS_SV: Pricing performance metrics
-- ---------------------------------------------------------------------------
CREATE OR REPLACE SEMANTIC VIEW PRICING_ANALYTICS_SV
    TABLES (
        PRICING AS CRUISE_YIELD_OPTIMIZATION.ANALYTICS.V_PRICING_PERFORMANCE
    )
    DIMENSIONS (
        PRICING.CABIN_CLASS AS cabin_class,
        PRICING.EVENT_MONTH AS event_month,
        PRICING.PRICE_TIER AS price_tier
    )
    METRICS (
        PRICING.IMPRESSIONS AS SUM(impressions),
        PRICING.CONVERSIONS AS SUM(conversions),
        PRICING.AVG_OFFERED_PRICE AS AVG(avg_offered_price),
        PRICING.AVG_CONVERTED_PRICE AS AVG(avg_converted_price),
        PRICING.AVG_CONVERSION_RATE AS AVG(conversion_rate)
    )
    COMMENT = 'Pricing performance metrics for conversion optimization';

-- ---------------------------------------------------------------------------
-- PARTNER_SIGNALS_SV: Airline partner demand signals
-- ---------------------------------------------------------------------------
CREATE OR REPLACE SEMANTIC VIEW PARTNER_SIGNALS_SV
    TABLES (
        SIGNALS AS CRUISE_YIELD_OPTIMIZATION.CLEAN_ROOM.V_AIRLINE_DEMAND
    )
    DIMENSIONS (
        SIGNALS.SIGNAL_DATE AS signal_date,
        SIGNALS.DEPARTURE_PORT AS departure_port,
        SIGNALS.AIRPORT_CODE AS airport_code,
        SIGNALS.IS_ANOMALY AS is_anomaly,
        SIGNALS.ANOMALY_DESCRIPTION AS anomaly_description
    )
    METRICS (
        SIGNALS.PRICE_INDEX AS AVG(price_index),
        SIGNALS.DEMAND_SCORE AS AVG(demand_score),
        SIGNALS.AVAILABLE_SEATS AS SUM(available_seats),
        SIGNALS.SIGNAL_COUNT AS COUNT(*),
        SIGNALS.ANOMALY_COUNT AS SUM(CASE WHEN is_anomaly THEN 1 ELSE 0 END)
    )
    COMMENT = 'Airline partner demand signals from clean room';
