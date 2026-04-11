-- =============================================================================
-- Cruise Yield Optimization - Synthetic Data Generation
-- Description: Generates synthetic data for all tables using GENERATOR-based
--              INSERT statements. Data patterns match production-like distributions.
-- Dependencies: Must run after 01_infrastructure.sql through 03_curated_tables.sql
-- =============================================================================

-- ============================================================
-- 1. SAILINGS (5,000 rows)
-- ============================================================
USE SCHEMA CRUISE_YIELD_OPTIMIZATION.RAW;

INSERT INTO SAILINGS (
    SAILING_ID, SHIP_NAME, SHIP_CLASS, CAPACITY, ITINERARY_REGION,
    DEPARTURE_PORT, DURATION_NIGHTS, SAILING_DATE, SEASON_MULTIPLIER,
    BASE_OCCUPANCY_TARGET
)
WITH ship_data AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY seq4()) as rn,
        seq4() as idx
    FROM TABLE(GENERATOR(ROWCOUNT => 5000))
),
ships AS (
    SELECT
        rn,
        ARRAY_CONSTRUCT(
            'Harmony of the Seas','Symphony of the Seas','Wonder of the Seas','Oasis of the Seas','Allure of the Seas','Odyssey of the Seas','Anthem of the Seas','Ovation of the Seas','Navigator of the Seas','Independence of the Seas'
        ) as ship_names,
        ARRAY_CONSTRUCT('Oasis','Oasis','Oasis','Oasis','Oasis','Quantum','Quantum','Quantum','Voyager','Freedom') as ship_classes,
        ARRAY_CONSTRUCT(6780,6680,6988,6780,6780,4180,4180,4180,3114,3634) as capacities,
        ARRAY_CONSTRUCT(
            'Caribbean','Alaska','Europe','Mexico','Bahamas','Bermuda'
        ) as regions,
        ARRAY_CONSTRUCT(
            'Miami','Fort Lauderdale','Tampa','Orlando','New York','Boston','Los Angeles','San Diego','Seattle','Vancouver','Barcelona','Rome','Southampton','San Juan','Galveston','Baltimore'
        ) as ports,
        ARRAY_CONSTRUCT(3,4,5,7,10,14) as durations
    FROM ship_data
)
SELECT
    'S' || LPAD(rn::VARCHAR, 5, '0') as SAILING_ID,
    ship_names[ABS(HASH(rn)) % 10]::VARCHAR as SHIP_NAME,
    ship_classes[ABS(HASH(rn)) % 10]::VARCHAR as SHIP_CLASS,
    capacities[ABS(HASH(rn)) % 10]::NUMBER as CAPACITY,
    regions[ABS(HASH(rn * 7)) % 6]::VARCHAR as ITINERARY_REGION,
    ports[ABS(HASH(rn * 13)) % 16]::VARCHAR as DEPARTURE_PORT,
    durations[ABS(HASH(rn * 19)) % 6]::NUMBER as DURATION_NIGHTS,
    DATEADD('day', UNIFORM(0, 730, RANDOM(42) + rn), '2025-01-01'::DATE) as SAILING_DATE,
    ROUND(1.00 + UNIFORM(0, 40, RANDOM(43) + rn) / 100.0, 2) as SEASON_MULTIPLIER,
    ROUND(0.95 + UNIFORM(0, 10, RANDOM(44) + rn) / 100.0, 2) as BASE_OCCUPANCY_TARGET
FROM ships;

-- ============================================================
-- 2. GUESTS (500,000 rows)
-- ============================================================
INSERT INTO GUESTS (
    GUEST_ID, FIRST_NAME, LAST_NAME, EMAIL, LOYALTY_TIER,
    LOYALTY_POINTS, PAST_CRUISES, LIFETIME_VALUE, AVG_ONBOARD_SPEND,
    PRICE_SENSITIVITY, PREFERRED_CABIN_CLASS, PREFERRED_REGION,
    GUEST_SEGMENT, MEMBER_SINCE
)
WITH guest_data AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY seq4()) - 1 as rn
    FROM TABLE(GENERATOR(ROWCOUNT => 500000))
),
lookup AS (
    SELECT
        rn,
        ARRAY_CONSTRUCT(
            'James','John','Robert','Michael','William','David','Richard',
            'Joseph','Thomas','Charles','Mary','Patricia','Jennifer','Linda',
            'Barbara','Elizabeth','Susan','Jessica','Sarah','Karen'
        ) as first_names,
        ARRAY_CONSTRUCT(
            'Smith','Johnson','Williams','Brown','Jones','Garcia','Miller',
            'Davis','Rodriguez','Martinez'
        ) as last_names,
        ARRAY_CONSTRUCT('Blue','Gold','Platinum','Diamond','Diamond+') as tiers,
        ARRAY_CONSTRUCT('Interior','Ocean View','Balcony','Suite','Grand Suite') as cabins,
        ARRAY_CONSTRUCT('Caribbean','Alaska','Europe','Mexico','Bahamas','Bermuda') as regions,
        ARRAY_CONSTRUCT(
            'Budget Cruiser','Mainstream','Premium Seeker','Luxury Enthusiast','Adventure Seeker','Family Focused','Spa Enthusiast','Casino Patron','Wine Aficionado','Foodie'
        ) as segments
    FROM guest_data
)
SELECT
    'G' || LPAD(rn::VARCHAR, 7, '0') as GUEST_ID,
    first_names[ABS(HASH(rn)) % 20]::VARCHAR as FIRST_NAME,
    last_names[ABS(HASH(rn * 3)) % 10]::VARCHAR as LAST_NAME,
    LOWER(first_names[ABS(HASH(rn)) % 20]::VARCHAR) || '.' ||
        LOWER(last_names[ABS(HASH(rn * 3)) % 10]::VARCHAR) ||
        rn::VARCHAR || '@email.com' as EMAIL,
    tiers[ABS(HASH(rn * 5)) % 5]::VARCHAR as LOYALTY_TIER,
    CASE
        WHEN tiers[ABS(HASH(rn * 5)) % 5]::VARCHAR = tiers[0]::VARCHAR THEN UNIFORM(0, 100000, RANDOM(50) + rn)
        WHEN tiers[ABS(HASH(rn * 5)) % 5]::VARCHAR = tiers[1]::VARCHAR THEN UNIFORM(50000, 300000, RANDOM(51) + rn)
        WHEN tiers[ABS(HASH(rn * 5)) % 5]::VARCHAR = tiers[2]::VARCHAR THEN UNIFORM(100000, 600000, RANDOM(52) + rn)
        WHEN tiers[ABS(HASH(rn * 5)) % 5]::VARCHAR = tiers[3]::VARCHAR THEN UNIFORM(200000, 900000, RANDOM(53) + rn)
        ELSE UNIFORM(500000, 1400000, RANDOM(54) + rn)
    END as LOYALTY_POINTS,
    CASE
        WHEN tiers[ABS(HASH(rn * 5)) % 5]::VARCHAR = tiers[0]::VARCHAR THEN UNIFORM(0, 3, RANDOM(55) + rn)
        WHEN tiers[ABS(HASH(rn * 5)) % 5]::VARCHAR = tiers[1]::VARCHAR THEN UNIFORM(2, 7, RANDOM(56) + rn)
        WHEN tiers[ABS(HASH(rn * 5)) % 5]::VARCHAR = tiers[2]::VARCHAR THEN UNIFORM(4, 12, RANDOM(57) + rn)
        WHEN tiers[ABS(HASH(rn * 5)) % 5]::VARCHAR = tiers[3]::VARCHAR THEN UNIFORM(6, 18, RANDOM(58) + rn)
        ELSE UNIFORM(10, 23, RANDOM(59) + rn)
    END as PAST_CRUISES,
    ROUND(UNIFORM(0, 13165000, RANDOM(60) + rn) / 100.0, 2) as LIFETIME_VALUE,
    ROUND(50 + UNIFORM(0, 276500, RANDOM(61) + rn) / 100.0, 2) as AVG_ONBOARD_SPEND,
    ROUND(0.10 + UNIFORM(0, 85, RANDOM(62) + rn) / 100.0, 2) as PRICE_SENSITIVITY,
    cabins[ABS(HASH(rn * 11)) % 5]::VARCHAR as PREFERRED_CABIN_CLASS,
    regions[ABS(HASH(rn * 17)) % 6]::VARCHAR as PREFERRED_REGION,
    segments[ABS(HASH(rn * 23)) % 10]::VARCHAR as GUEST_SEGMENT,
    DATEADD('day', UNIFORM(0, 3620, RANDOM(63) + rn), '2016-02-21'::DATE) as MEMBER_SINCE
FROM lookup;

-- ============================================================
-- 3. BOOKINGS (2,000,000 rows)
-- ============================================================
INSERT INTO BOOKINGS (
    BOOKING_ID, GUEST_ID, SAILING_ID, BOOKING_DATE, SAILING_DATE,
    CABIN_CLASS, NUM_GUESTS, BASE_PRICE, OFFERED_PRICE,
    TOTAL_CABIN_REVENUE, BOOKING_STATUS, DAYS_BEFORE_SAILING,
    BOOKING_CHANNEL, PROMO_CODE_USED
)
WITH booking_data AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY seq4()) - 1 as rn
    FROM TABLE(GENERATOR(ROWCOUNT => 2000000))
),
lookup AS (
    SELECT
        rn,
        ARRAY_CONSTRUCT('Interior','Ocean View','Balcony','Suite','Grand Suite') as cabins,
        ARRAY_CONSTRUCT(800,1100,1400,2200,4500) as base_prices,
        ARRAY_CONSTRUCT('Confirmed','Cancelled','Abandoned') as statuses,
        ARRAY_CONSTRUCT('Website','Mobile App','Travel Agent','Phone') as channels
    FROM booking_data
)
SELECT
    'B' || LPAD(rn::VARCHAR, 7, '0') as BOOKING_ID,
    'G' || LPAD(UNIFORM(0, 499999, RANDOM(70) + rn)::VARCHAR, 7, '0') as GUEST_ID,
    'S' || LPAD(LPAD((UNIFORM(1, 5000, RANDOM(71) + rn))::VARCHAR, 5, '0'), 5, '0') as SAILING_ID,
    DATEADD('day', UNIFORM(0, 1094, RANDOM(72) + rn), '2024-01-02'::DATE) as BOOKING_DATE,
    DATEADD('day', UNIFORM(0, 730, RANDOM(73) + rn), '2025-01-01'::DATE) as SAILING_DATE,
    cabins[ABS(HASH(rn * 7)) % 5]::VARCHAR as CABIN_CLASS,
    UNIFORM(1, 4, RANDOM(74) + rn) as NUM_GUESTS,
    base_prices[ABS(HASH(rn * 7)) % 5]::NUMBER as BASE_PRICE,
    ROUND(base_prices[ABS(HASH(rn * 7)) % 5]::NUMBER * (0.85 + UNIFORM(0, 90, RANDOM(75) + rn) / 100.0), 2) as OFFERED_PRICE,
    CASE statuses[ABS(HASH(rn * 11)) % 3]::VARCHAR
        WHEN 'Confirmed' THEN ROUND(
            base_prices[ABS(HASH(rn * 7)) % 5]::NUMBER *
            (0.85 + UNIFORM(0, 90, RANDOM(75) + rn) / 100.0) *
            UNIFORM(1, 4, RANDOM(74) + rn), 2)
        ELSE 0.00
    END as TOTAL_CABIN_REVENUE,
    statuses[ABS(HASH(rn * 11)) % 3]::VARCHAR as BOOKING_STATUS,
    UNIFORM(1, 365, RANDOM(76) + rn) as DAYS_BEFORE_SAILING,
    channels[ABS(HASH(rn * 13)) % 4]::VARCHAR as BOOKING_CHANNEL,
    IFF(UNIFORM(1, 100, RANDOM(77) + rn) <= 30, TRUE, FALSE) as PROMO_CODE_USED
FROM lookup;

-- ============================================================
-- 4. ONBOARD_SPENDING (2,000,000 rows)
-- ============================================================
INSERT INTO ONBOARD_SPENDING (
    TRANSACTION_ID, BOOKING_ID, GUEST_ID, SAILING_ID,
    TRANSACTION_DATE, CATEGORY, AMOUNT, VENUE
)
WITH spend_data AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY seq4()) as rn
    FROM TABLE(GENERATOR(ROWCOUNT => 2000000))
),
lookup AS (
    SELECT
        rn,
        ARRAY_CONSTRUCT(
            'Spa','Dining','Casino','Shore Excursions','Shopping','Beverage Package','Internet','Photo'
        ) as categories,
        ARRAY_CONSTRUCT(
            'Spa Venue 1','Spa Venue 2','Spa Venue 3','Dining Venue 1','Dining Venue 2','Dining Venue 3','Casino Venue 1','Casino Venue 2','Casino Venue 3','Shore Venue 1','Shore Venue 2','Shore Venue 3','Shopping Venue 1','Shopping Venue 2','Shopping Venue 3','Beverage Venue 1','Beverage Venue 2','Beverage Venue 3','Internet Venue 1','Internet Venue 2','Internet Venue 3','Photo Venue 1','Photo Venue 2','Photo Venue 3'
        ) as venues
    FROM spend_data
)
SELECT
    'T' || LPAD(rn::VARCHAR, 8, '0') as TRANSACTION_ID,
    'B' || LPAD(UNIFORM(0, 1999999, RANDOM(80) + rn)::VARCHAR, 7, '0') as BOOKING_ID,
    'G' || LPAD(UNIFORM(0, 499999, RANDOM(81) + rn)::VARCHAR, 7, '0') as GUEST_ID,
    'S' || LPAD((UNIFORM(1, 5000, RANDOM(82) + rn))::VARCHAR, 5, '0') as SAILING_ID,
    DATEADD('day', UNIFORM(0, 735, RANDOM(83) + rn), '2025-01-01'::DATE) as TRANSACTION_DATE,
    categories[ABS(HASH(rn * 7)) % 8]::VARCHAR as CATEGORY,
    ROUND(5.00 + UNIFORM(0, 110100, RANDOM(84) + rn) / 100.0, 2) as AMOUNT,
    venues[ABS(HASH(rn * 13)) % 24]::VARCHAR as VENUE
FROM lookup;

-- ============================================================
-- 5. PRECRUISE_PURCHASES (1,000,000 rows)
-- ============================================================
INSERT INTO PRECRUISE_PURCHASES (
    PURCHASE_ID, BOOKING_ID, GUEST_ID, SAILING_ID,
    PURCHASE_DATE, PACKAGE_NAME, PACKAGE_CATEGORY, PRICE, QUANTITY
)
WITH purchase_data AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY seq4()) as rn
    FROM TABLE(GENERATOR(ROWCOUNT => 1000000))
),
lookup AS (
    SELECT
        rn,
        ARRAY_CONSTRUCT(
            'Deluxe Beverage Package','Classic Beverage Package','Refreshment Package','Unlimited Dining Package','3-Night Dining Package','Shore Excursion Bundle','WiFi Package - Basic','WiFi Package - Premium','Photo Package','Spa Package'
        ) as packages,
        ARRAY_CONSTRUCT(
            'Deluxe','Classic','Refreshment','Unlimited','3-Night','Shore','WiFi','WiFi','Photo','Spa'
        ) as pkg_categories
    FROM purchase_data
)
SELECT
    'P' || LPAD(rn::VARCHAR, 7, '0') as PURCHASE_ID,
    'B' || LPAD(UNIFORM(0, 1999999, RANDOM(90) + rn)::VARCHAR, 7, '0') as BOOKING_ID,
    'G' || LPAD(UNIFORM(0, 499999, RANDOM(91) + rn)::VARCHAR, 7, '0') as GUEST_ID,
    'S' || LPAD((UNIFORM(1, 5000, RANDOM(92) + rn))::VARCHAR, 5, '0') as SAILING_ID,
    DATEADD('day', UNIFORM(0, 1094, RANDOM(93) + rn), '2024-01-02'::DATE) as PURCHASE_DATE,
    packages[ABS(HASH(rn * 7)) % 10]::VARCHAR as PACKAGE_NAME,
    pkg_categories[ABS(HASH(rn * 7)) % 10]::VARCHAR as PACKAGE_CATEGORY,
    ROUND(15.30 + UNIFORM(0, 159458, RANDOM(94) + rn) / 100.0, 2) as PRICE,
    UNIFORM(1, 4, RANDOM(95) + rn) as QUANTITY
FROM lookup;

-- ============================================================
-- 6. PRICING_EVENTS (1,000,000 rows)
-- ============================================================
INSERT INTO PRICING_EVENTS (
    EVENT_ID, GUEST_ID, SAILING_ID, CABIN_CLASS, EVENT_DATE,
    OFFERED_PRICE, CONVERTED, SESSION_ID, DEVICE_TYPE,
    TIME_ON_PAGE_SECONDS
)
WITH event_data AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY seq4()) as rn
    FROM TABLE(GENERATOR(ROWCOUNT => 1000000))
),
lookup AS (
    SELECT
        rn,
        ARRAY_CONSTRUCT('Interior','Ocean View','Balcony','Suite','Grand Suite') as cabins,
        ARRAY_CONSTRUCT(800,1100,1400,2200,4500) as base_prices,
        ARRAY_CONSTRUCT('Desktop','Mobile','Tablet') as devices
    FROM event_data
)
SELECT
    'E' || LPAD(rn::VARCHAR, 7, '0') as EVENT_ID,
    'G' || LPAD(UNIFORM(0, 499999, RANDOM(100) + rn)::VARCHAR, 7, '0') as GUEST_ID,
    'S' || LPAD((UNIFORM(1, 5000, RANDOM(101) + rn))::VARCHAR, 5, '0') as SAILING_ID,
    cabins[ABS(HASH(rn * 7)) % 5]::VARCHAR as CABIN_CLASS,
    DATEADD('day', UNIFORM(0, 800, RANDOM(102) + rn), '2024-11-01'::DATE) as EVENT_DATE,
    ROUND(base_prices[ABS(HASH(rn * 7)) % 5]::NUMBER * (0.85 + UNIFORM(0, 90, RANDOM(103) + rn) / 100.0), 2) as OFFERED_PRICE,
    IFF(UNIFORM(1, 100, RANDOM(104) + rn) <= 25, TRUE, FALSE) as CONVERTED,
    'SESS' || UNIFORM(100000, 999999, RANDOM(105) + rn)::VARCHAR as SESSION_ID,
    devices[ABS(HASH(rn * 11)) % 3]::VARCHAR as DEVICE_TYPE,
    UNIFORM(10, 600, RANDOM(106) + rn) as TIME_ON_PAGE_SECONDS
FROM lookup;

-- ============================================================
-- 7. PARTNER_SIGNALS (100,000 rows)
-- ============================================================
INSERT INTO PARTNER_SIGNALS (
    SIGNAL_ID, SIGNAL_DATE, DEPARTURE_PORT, AIRPORT_CODE,
    SIGNAL_TYPE, PRICE_INDEX, DEMAND_SCORE, CAPACITY_UTILIZATION,
    AVG_FARE, IS_ANOMALY, ANOMALY_DESCRIPTION
)
WITH signal_data AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY seq4()) as rn
    FROM TABLE(GENERATOR(ROWCOUNT => 100000))
),
lookup AS (
    SELECT
        rn,
        ARRAY_CONSTRUCT(
            'Miami','Fort Lauderdale','Tampa','Orlando','New York','Boston','Los Angeles','San Diego','Seattle','Vancouver','Barcelona','Rome','Southampton','San Juan','Galveston','Baltimore'
        ) as ports,
        ARRAY_CONSTRUCT(
            'MIA','FLL','TPA','MCO','JFK','BOS','LAX','SAN','SEA','YVR','BCN','FCO','LHR','SJU','IAH','BWI'
        ) as airports
    FROM signal_data
)
SELECT
    'SIG' || LPAD(rn::VARCHAR, 6, '0') as SIGNAL_ID,
    DATEADD('day', UNIFORM(0, 730, RANDOM(110) + rn), '2025-01-01'::DATE) as SIGNAL_DATE,
    ports[ABS(HASH(rn * 7)) % 16]::VARCHAR as DEPARTURE_PORT,
    airports[ABS(HASH(rn * 7)) % 16]::VARCHAR as AIRPORT_CODE,
    'Airline Pricing' as SIGNAL_TYPE,
    ROUND(76.6 + UNIFORM(0, 11080, RANDOM(111) + rn) / 100.0, 1) as PRICE_INDEX,
    ROUND(0.10 + UNIFORM(0, 90, RANDOM(112) + rn) / 100.0, 2) as DEMAND_SCORE,
    ROUND(0.40 + UNIFORM(0, 58, RANDOM(113) + rn) / 100.0, 2) as CAPACITY_UTILIZATION,
    ROUND(17.11 + UNIFORM(0, 90359, RANDOM(114) + rn) / 100.0, 2) as AVG_FARE,
    IFF(UNIFORM(1, 100, RANDOM(115) + rn) <= 5, TRUE, FALSE) as IS_ANOMALY,
    CASE
        WHEN UNIFORM(1, 100, RANDOM(115) + rn) <= 5 THEN 'Anomalous pricing detected - investigate'
        ELSE 'None'
    END as ANOMALY_DESCRIPTION
FROM lookup;

-- ============================================================
-- 8. GUEST_FEEDBACK (500,000 rows)
-- ============================================================
INSERT INTO GUEST_FEEDBACK (
    FEEDBACK_ID, GUEST_ID, BOOKING_ID, SAILING_ID, SHIP_NAME,
    FEEDBACK_DATE, OVERALL_RATING, CATEGORY, SUBCATEGORY, RATING,
    SENTIMENT, FEEDBACK_TEXT, MENTIONED_AMENITIES,
    MENTIONED_EXCURSIONS, WOULD_RECOMMEND
)
WITH fb_data AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY seq4()) as rn
    FROM TABLE(GENERATOR(ROWCOUNT => 500000))
),
lookup AS (
    SELECT
        rn,
        ARRAY_CONSTRUCT(
            'Harmony of the Seas','Symphony of the Seas','Wonder of the Seas','Oasis of the Seas','Allure of the Seas','Odyssey of the Seas','Anthem of the Seas','Ovation of the Seas','Navigator of the Seas','Independence of the Seas'
        ) as ships,
        ARRAY_CONSTRUCT('Dining','Entertainment','Service','Amenities','Excursions','Accommodations') as categories,
        ARRAY_CONSTRUCT(
            'Buffet','Specialty Restaurant','Main Dining Room','Room Service','Bar Service','Wait Staff','Shows','Live Music','Nightclub','Movies','Guest Services','Concierge','Cabin Steward','Shore Excursion Desk','Pool Area','Fitness Center','Spa','Sports Deck','Casino','Suite Lounge','Beach Excursion','City Walking Tour','Cultural Tour','Snorkeling/Diving','Adventure Activity','Cabin Size','Cabin Cleanliness','Balcony','Bathroom','Bed Comfort'
        ) as subcategories,
        ARRAY_CONSTRUCT('Positive','Neutral','Negative') as sentiments,
        ARRAY_CONSTRUCT(
            'FlowRider','Perfect Storm Slides','North Star Observation','Suite Lounge','Private Pool','Bionic Bar','Rock Climbing Wall','Ultimate Abyss','CocoCay Beach Club','Thermal Suite','Wonderland Restaurant','Vitality Spa','Coastal Kitchen','Chef''s Table','Royal Theater VIP'
        ) as amenities,
        ARRAY_CONSTRUCT(
            'Perfect Day CocoCay','Cozumel Snorkeling Adventure','Jamaica Dunn''s River Falls','Grand Cayman Stingray City','Alaska Glacier Trek','Juneau Whale Watching','Barcelona Gothic Quarter','Santorini Wine Tour','Rome Colosseum Tour','St. Thomas Catamaran Sail','Ketchikan Lumberjack Show','Belize Cave Tubing','Aruba Jeep Adventure','Labadee Dragon Zipline','Roatan Zipline & Beach','Curacao Beach Hopping','Costa Maya Mayan Ruins'
        ) as excursions,
        ARRAY_CONSTRUCT(
            ' was fantastic - exactly what we hoped for.',' exceeded all expectations. Highly recommend!',
            ' needs improvement. Not up to standard.',' was disappointing compared to previous cruises.',
            '. Average experience. Room for improvement.'
        ) as feedback_templates
    FROM fb_data
)
SELECT
    'FB' || LPAD(rn::VARCHAR, 7, '0') as FEEDBACK_ID,
    'G' || LPAD(UNIFORM(0, 499999, RANDOM(120) + rn)::VARCHAR, 7, '0') as GUEST_ID,
    'B' || LPAD(UNIFORM(0, 1999999, RANDOM(121) + rn)::VARCHAR, 7, '0') as BOOKING_ID,
    'S' || LPAD((UNIFORM(1, 5000, RANDOM(122) + rn))::VARCHAR, 5, '0') as SAILING_ID,
    ships[ABS(HASH(rn * 7)) % 10]::VARCHAR as SHIP_NAME,
    DATEADD('day', UNIFORM(0, 700, RANDOM(123) + rn), '2025-01-01'::DATE) as FEEDBACK_DATE,
    UNIFORM(1, 5, RANDOM(124) + rn) as OVERALL_RATING,
    categories[ABS(HASH(rn * 11)) % 6]::VARCHAR as CATEGORY,
    subcategories[ABS(HASH(rn * 13)) % 30]::VARCHAR as SUBCATEGORY,
    UNIFORM(1, 5, RANDOM(125) + rn) as RATING,
    sentiments[
        CASE
            WHEN UNIFORM(1, 5, RANDOM(125) + rn) >= 4 THEN 0
            WHEN UNIFORM(1, 5, RANDOM(125) + rn) = 3 THEN 1
            ELSE 2
        END
    ]::VARCHAR as SENTIMENT,
    CASE
        WHEN UNIFORM(1, 5, RANDOM(125) + rn) >= 4
            THEN subcategories[ABS(HASH(rn * 13)) % 30]::VARCHAR || feedback_templates[UNIFORM(0, 1, RANDOM(126) + rn)]::VARCHAR
        WHEN UNIFORM(1, 5, RANDOM(125) + rn) = 3
            THEN 'Average experience with ' || subcategories[ABS(HASH(rn * 13)) % 30]::VARCHAR || '. Room for improvement.'
        ELSE
            'The ' || subcategories[ABS(HASH(rn * 13)) % 30]::VARCHAR || feedback_templates[UNIFORM(2, 3, RANDOM(126) + rn)]::VARCHAR
    END as FEEDBACK_TEXT,
    CASE
        WHEN UNIFORM(1, 100, RANDOM(127) + rn) <= 30
            THEN amenities[ABS(HASH(rn)) % 15]::VARCHAR || ', ' || amenities[ABS(HASH(rn * 3)) % 15]::VARCHAR
        WHEN UNIFORM(1, 100, RANDOM(127) + rn) <= 50
            THEN amenities[ABS(HASH(rn * 5)) % 15]::VARCHAR
        ELSE NULL
    END as MENTIONED_AMENITIES,
    CASE
        WHEN UNIFORM(1, 100, RANDOM(128) + rn) <= 20
            THEN excursions[ABS(HASH(rn)) % 17]::VARCHAR || ', ' || excursions[ABS(HASH(rn * 3)) % 17]::VARCHAR
        WHEN UNIFORM(1, 100, RANDOM(128) + rn) <= 40
            THEN excursions[ABS(HASH(rn * 5)) % 17]::VARCHAR
        ELSE NULL
    END as MENTIONED_EXCURSIONS,
    IFF(UNIFORM(1, 5, RANDOM(124) + rn) >= 3, TRUE, FALSE) as WOULD_RECOMMEND
FROM lookup;

-- ============================================================
-- 9. GUEST_FLIGHTS (300,000 rows) - CURATED schema
-- ============================================================
USE SCHEMA CRUISE_YIELD_OPTIMIZATION.CURATED;

INSERT INTO GUEST_FLIGHTS (
    FLIGHT_ID, GUEST_360_ID, BOOKING_ID, AIRLINE, FLIGHT_NUMBER,
    ORIGIN_AIRPORT, ORIGIN_CITY, DESTINATION_AIRPORT, DESTINATION_CITY,
    FLIGHT_DATE, FLIGHT_TYPE, TICKET_PRICE, BOOKING_SOURCE
)
WITH flight_data AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY seq4()) as rn
    FROM TABLE(GENERATOR(ROWCOUNT => 300000))
),
lookup AS (
    SELECT
        rn,
        ARRAY_CONSTRUCT(
            'American Airlines','Delta Air Lines','United Airlines','Southwest Airlines','JetBlue Airways','Alaska Airlines','Spirit Airlines','Frontier Airlines'
        ) as airlines,
        ARRAY_CONSTRUCT('AA','DL','UA','WN','B6','AS','NK','F9') as airline_codes,
        ARRAY_CONSTRUCT(
            'JFK','LAX','ORD','ATL','DFW','SFO','SEA','BOS','DEN','PHX','DTW','MSP'
        ) as origin_airports,
        ARRAY_CONSTRUCT(
            'New York','Los Angeles','Chicago','Atlanta','Dallas','San Francisco','Seattle','Boston','Denver','Phoenix','Detroit','Minneapolis'
        ) as origin_cities,
        ARRAY_CONSTRUCT('MIA','FLL','TPA','MCO','SEA','LAX','SJU','GAL') as dest_airports,
        ARRAY_CONSTRUCT(
            'Miami','Fort Lauderdale','Tampa','Orlando','Seattle','Los Angeles','San Juan','Galveston'
        ) as dest_cities,
        ARRAY_CONSTRUCT('INDEPENDENT','CRUISE_LINE','PACKAGE') as sources
    FROM flight_data
)
SELECT
    'FLT-' || (200000 + rn)::VARCHAR as FLIGHT_ID,
    'G' || LPAD(UNIFORM(0, 499999, RANDOM(130) + rn)::VARCHAR, 7, '0') as GUEST_360_ID,
    'B' || LPAD(UNIFORM(0, 1999999, RANDOM(131) + rn)::VARCHAR, 7, '0') as BOOKING_ID,
    airlines[ABS(HASH(rn * 7)) % 8]::VARCHAR as AIRLINE,
    airline_codes[ABS(HASH(rn * 7)) % 8]::VARCHAR ||
        UNIFORM(1000, 9999, RANDOM(132) + rn)::VARCHAR as FLIGHT_NUMBER,
    origin_airports[ABS(HASH(rn * 11)) % 12]::VARCHAR as ORIGIN_AIRPORT,
    origin_cities[ABS(HASH(rn * 11)) % 12]::VARCHAR as ORIGIN_CITY,
    dest_airports[ABS(HASH(rn * 13)) % 8]::VARCHAR as DESTINATION_AIRPORT,
    dest_cities[ABS(HASH(rn * 13)) % 8]::VARCHAR as DESTINATION_CITY,
    DATEADD('day', UNIFORM(0, 730, RANDOM(133) + rn), '2024-12-29'::DATE) as FLIGHT_DATE,
    'INBOUND' as FLIGHT_TYPE,
    ROUND(112 + UNIFORM(0, 38200, RANDOM(134) + rn) / 100.0, 2) as TICKET_PRICE,
    sources[ABS(HASH(rn * 17)) % 3]::VARCHAR as BOOKING_SOURCE
FROM lookup;

-- ============================================================
-- 10. GUEST_SERVICES (~390,000 rows) - CURATED schema
-- ============================================================
INSERT INTO GUEST_SERVICES (
    SERVICE_ID, GUEST_360_ID, SERVICE_DATE, SERVICE_CATEGORY,
    SERVICE_NAME, AMOUNT, SAILING_ID, PURCHASE_CHANNEL
)
WITH svc_data AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY seq4()) as rn
    FROM TABLE(GENERATOR(ROWCOUNT => 390000))
),
lookup AS (
    SELECT
        rn,
        ARRAY_CONSTRUCT(
            'SPA','EXCURSIONS','SPECIALTY_DINING','BEVERAGE_PACKAGE','CASINO','INTERNET','PHOTOS','SHORE_ACTIVITIES'
        ) as categories,
        -- Service names mapped to categories (index-aligned groups)
        ARRAY_CONSTRUCT(
            'Couples Massage','Deep Tissue Massage','Hot Stone Massage','Facial Treatment','Snorkeling Tour','Scuba Diving','City Walking Tour','Helicopter Tour','Chops Grille','Giovannis Table','Izumi','Wonderland','Deluxe Beverage Package','Refreshment Package','Classic Soda Package','Slots','Poker','Blackjack','Surf & Stream Package','Surf Package','Digital Photo Package','Ultimate Photo Package','ATV Adventure','Zip Line Adventure','Parasailing','Jet Ski Rental'
        ) as service_names,
        ARRAY_CONSTRUCT('ONBOARD','MOBILE_APP','PRE-CRUISE') as channels
    FROM svc_data
)
SELECT
    'SVC-' || (50000 + rn)::VARCHAR as SERVICE_ID,
    'G' || LPAD(UNIFORM(0, 499999, RANDOM(140) + rn)::VARCHAR, 7, '0') as GUEST_360_ID,
    DATEADD('day', UNIFORM(0, 365, RANDOM(141) + rn), '2025-02-18'::DATE) as SERVICE_DATE,
    categories[ABS(HASH(rn * 7)) % 8]::VARCHAR as SERVICE_CATEGORY,
    service_names[ABS(HASH(rn * 11)) % 26]::VARCHAR as SERVICE_NAME,
    ROUND(12.00 + UNIFORM(0, 40799, RANDOM(142) + rn) / 100.0, 2) as AMOUNT,
    'SAI-' || LPAD((UNIFORM(1, 5000, RANDOM(143) + rn))::VARCHAR, 6, '0') as SAILING_ID,
    channels[ABS(HASH(rn * 13)) % 3]::VARCHAR as PURCHASE_CHANNEL
FROM lookup;

-- ============================================================
-- 11. PRICING_FEATURES (1,000,000 rows) - ML schema
-- ============================================================
USE SCHEMA CRUISE_YIELD_OPTIMIZATION.ML;

INSERT INTO PRICING_FEATURES (
    EVENT_ID, GUEST_ID, SAILING_ID, CABIN_CLASS, OFFERED_PRICE,
    CONVERTED, LOYALTY_TIER, LOYALTY_TIER_NUM, PRICE_SENSITIVITY,
    PAST_CRUISES, LIFETIME_VALUE, AVG_ONBOARD_SPEND, SEASON_MULTIPLIER,
    DURATION_NIGHTS, ITINERARY_REGION, BASE_PRICE, PRICE_RATIO
)
WITH pf_data AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY seq4()) as rn
    FROM TABLE(GENERATOR(ROWCOUNT => 1000000))
),
lookup AS (
    SELECT
        rn,
        ARRAY_CONSTRUCT('Interior','Ocean View','Balcony','Suite','Grand Suite') as cabins,
        ARRAY_CONSTRUCT(800,1100,1400,2200,4500) as base_prices,
        ARRAY_CONSTRUCT('Blue','Gold','Platinum','Diamond','Diamond+') as tiers,
        ARRAY_CONSTRUCT(1,2,3,4,5) as tier_nums,
        ARRAY_CONSTRUCT('Caribbean','Alaska','Europe','Mexico','Bahamas','Bermuda') as regions,
        ARRAY_CONSTRUCT(3,4,5,7,10,14) as durations
    FROM pf_data
)
SELECT
    'E' || LPAD(rn::VARCHAR, 7, '0') as EVENT_ID,
    'G' || LPAD(UNIFORM(0, 499999, RANDOM(150) + rn)::VARCHAR, 7, '0') as GUEST_ID,
    'S' || LPAD((UNIFORM(1, 5000, RANDOM(151) + rn))::VARCHAR, 5, '0') as SAILING_ID,
    cabins[ABS(HASH(rn * 7)) % 5]::VARCHAR as CABIN_CLASS,
    ROUND(base_prices[ABS(HASH(rn * 7)) % 5]::NUMBER * (0.85 + UNIFORM(0, 90, RANDOM(152) + rn) / 100.0), 2) as OFFERED_PRICE,
    IFF(UNIFORM(1, 100, RANDOM(153) + rn) <= 25, 1, 0) as CONVERTED,
    tiers[ABS(HASH(rn * 11)) % 5]::VARCHAR as LOYALTY_TIER,
    tier_nums[ABS(HASH(rn * 11)) % 5]::NUMBER as LOYALTY_TIER_NUM,
    ROUND(0.10 + UNIFORM(0, 85, RANDOM(154) + rn) / 100.0, 2) as PRICE_SENSITIVITY,
    UNIFORM(0, 23, RANDOM(155) + rn) as PAST_CRUISES,
    ROUND(UNIFORM(0, 13165000, RANDOM(156) + rn) / 100.0, 2) as LIFETIME_VALUE,
    ROUND(50 + UNIFORM(0, 276500, RANDOM(157) + rn) / 100.0, 2) as AVG_ONBOARD_SPEND,
    ROUND(1.00 + UNIFORM(0, 40, RANDOM(158) + rn) / 100.0, 2) as SEASON_MULTIPLIER,
    durations[ABS(HASH(rn * 17)) % 6]::NUMBER as DURATION_NIGHTS,
    regions[ABS(HASH(rn * 19)) % 6]::VARCHAR as ITINERARY_REGION,
    base_prices[ABS(HASH(rn * 7)) % 5]::NUMBER as BASE_PRICE,
    ROUND(
        (base_prices[ABS(HASH(rn * 7)) % 5]::NUMBER * (0.85 + UNIFORM(0, 90, RANDOM(152) + rn) / 100.0)) /
        NULLIF(base_prices[ABS(HASH(rn * 7)) % 5]::NUMBER, 0), 8
    ) as PRICE_RATIO
FROM lookup;
