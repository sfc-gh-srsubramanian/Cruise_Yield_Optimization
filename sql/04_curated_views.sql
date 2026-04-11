-- =============================================================================
-- Cruise Yield Optimization - CURATED Layer Views
-- Layer: Silver (Cleansed and Enriched Data)
-- Description: Unified guest profile, booking, and feedback views
-- =============================================================================

USE SCHEMA CRUISE_YIELD_OPTIMIZATION.CURATED;

-- ---------------------------------------------------------------------------
-- GUEST_BOOKINGS: Enriched booking view joining bookings with sailing details
-- ---------------------------------------------------------------------------
CREATE OR REPLACE VIEW GUEST_BOOKINGS (
    BOOKING_ID,
    GUEST_360_ID,
    SAILING_ID,
    SHIP_NAME,
    SHIP_CLASS,
    ITINERARY_REGION,
    DEPARTURE_PORT,
    DURATION_NIGHTS,
    SAILING_DATE,
    BOOKING_DATE,
    CABIN_CLASS,
    NUM_GUESTS,
    BASE_PRICE,
    OFFERED_PRICE,
    TOTAL_CABIN_REVENUE,
    BOOKING_STATUS,
    DAYS_BEFORE_SAILING,
    BOOKING_CHANNEL,
    PROMO_CODE_USED,
    SAILING_STATUS
) AS
SELECT 
    b.BOOKING_ID,
    b.GUEST_ID AS GUEST_360_ID,
    b.SAILING_ID,
    s.SHIP_NAME,
    s.SHIP_CLASS,
    s.ITINERARY_REGION,
    s.DEPARTURE_PORT,
    s.DURATION_NIGHTS,
    b.SAILING_DATE,
    b.BOOKING_DATE,
    b.CABIN_CLASS,
    b.NUM_GUESTS,
    b.BASE_PRICE,
    b.OFFERED_PRICE,
    b.TOTAL_CABIN_REVENUE,
    b.BOOKING_STATUS,
    b.DAYS_BEFORE_SAILING,
    b.BOOKING_CHANNEL,
    b.PROMO_CODE_USED,
    CASE WHEN b.SAILING_DATE > CURRENT_DATE() THEN 'UPCOMING' ELSE 'PAST' END AS SAILING_STATUS
FROM CRUISE_YIELD_OPTIMIZATION.RAW.BOOKINGS b
JOIN CRUISE_YIELD_OPTIMIZATION.RAW.SAILINGS s ON b.SAILING_ID = s.SAILING_ID;

-- ---------------------------------------------------------------------------
-- GUEST_FEEDBACK: Curated feedback view with renamed columns
-- ---------------------------------------------------------------------------
CREATE OR REPLACE VIEW GUEST_FEEDBACK (
    FEEDBACK_ID,
    GUEST_360_ID,
    BOOKING_ID,
    SAILING_ID,
    SHIP_NAME,
    FEEDBACK_DATE,
    OVERALL_RATING,
    FEEDBACK_CATEGORY,
    FEEDBACK_SUBCATEGORY,
    CATEGORY_RATING,
    SENTIMENT,
    FEEDBACK_TEXT,
    MENTIONED_AMENITIES,
    MENTIONED_EXCURSIONS,
    WOULD_RECOMMEND
) AS
SELECT 
    f.FEEDBACK_ID,
    f.GUEST_ID AS GUEST_360_ID,
    f.BOOKING_ID,
    f.SAILING_ID,
    f.SHIP_NAME,
    f.FEEDBACK_DATE,
    f.OVERALL_RATING,
    f.CATEGORY AS FEEDBACK_CATEGORY,
    f.SUBCATEGORY AS FEEDBACK_SUBCATEGORY,
    f.RATING AS CATEGORY_RATING,
    f.SENTIMENT,
    f.FEEDBACK_TEXT,
    f.MENTIONED_AMENITIES,
    f.MENTIONED_EXCURSIONS,
    f.WOULD_RECOMMEND
FROM CRUISE_YIELD_OPTIMIZATION.RAW.GUEST_FEEDBACK f;

-- ---------------------------------------------------------------------------
-- GUEST_360: Unified guest profile with CLV, spending, and segmentation
-- ---------------------------------------------------------------------------
CREATE OR REPLACE VIEW GUEST_360 (
    GUEST_360_ID,
    FIRST_NAME,
    LAST_NAME,
    GUEST_NAME,
    EMAIL,
    LOYALTY_TIER,
    LOYALTY_POINTS,
    PAST_CRUISES,
    GUEST_SEGMENT,
    PREFERRED_CABIN_CLASS,
    PREFERRED_REGION,
    MEMBER_SINCE,
    PRICE_SENSITIVITY,
    TOTAL_BOOKINGS,
    CONFIRMED_BOOKINGS,
    TOTAL_CABIN_REVENUE,
    AVG_CABIN_PRICE,
    FIRST_BOOKING_DATE,
    LAST_BOOKING_DATE,
    TOTAL_ONBOARD_SPEND,
    ONBOARD_TRANSACTIONS,
    AVG_ONBOARD_TRANSACTION,
    TOTAL_PRECRUISE_SPEND,
    PRECRUISE_PURCHASES,
    LIFETIME_VALUE,
    HISTORICAL_AVG_ONBOARD_SPEND,
    CALCULATED_TOTAL_VALUE,
    VALUE_SEGMENT,
    DAYS_SINCE_LAST_BOOKING,
    SPA_SPEND,
    EXCURSION_SPEND,
    SPECIALTY_DINING_SPEND,
    BEVERAGE_PACKAGE_SPEND,
    CASINO_SPEND,
    INTERNET_SPEND,
    PHOTO_SPEND,
    SHORE_ACTIVITY_SPEND
) AS
WITH guest_bookings AS (
    SELECT 
        g.guest_id,
        COUNT(DISTINCT b.booking_id) as total_bookings,
        COUNT(DISTINCT CASE WHEN b.booking_status = 'Confirmed' THEN b.booking_id END) as confirmed_bookings,
        SUM(CASE WHEN b.booking_status = 'Confirmed' THEN b.total_cabin_revenue ELSE 0 END) as total_cabin_revenue,
        AVG(b.offered_price) as avg_cabin_price,
        MIN(b.booking_date) as first_booking_date,
        MAX(b.booking_date) as last_booking_date
    FROM RAW.GUESTS g
    LEFT JOIN RAW.BOOKINGS b ON g.guest_id = b.guest_id
    GROUP BY g.guest_id
),
guest_spending AS (
    SELECT 
        guest_id,
        SUM(amount) as total_onboard_spend,
        COUNT(*) as onboard_transactions,
        AVG(amount) as avg_transaction_amount
    FROM RAW.ONBOARD_SPENDING
    GROUP BY guest_id
),
guest_precruise AS (
    SELECT 
        guest_id,
        SUM(price) as total_precruise_spend,
        COUNT(*) as precruise_purchases
    FROM RAW.PRECRUISE_PURCHASES
    GROUP BY guest_id
),
guest_services_agg AS (
    SELECT 
        GUEST_360_ID,
        SUM(CASE WHEN SERVICE_CATEGORY = 'SPA' THEN AMOUNT ELSE 0 END) as spa_spend,
        SUM(CASE WHEN SERVICE_CATEGORY = 'EXCURSIONS' THEN AMOUNT ELSE 0 END) as excursion_spend,
        SUM(CASE WHEN SERVICE_CATEGORY = 'SPECIALTY_DINING' THEN AMOUNT ELSE 0 END) as specialty_dining_spend,
        SUM(CASE WHEN SERVICE_CATEGORY = 'BEVERAGE_PACKAGE' THEN AMOUNT ELSE 0 END) as beverage_package_spend,
        SUM(CASE WHEN SERVICE_CATEGORY = 'CASINO' THEN AMOUNT ELSE 0 END) as casino_spend,
        SUM(CASE WHEN SERVICE_CATEGORY = 'INTERNET' THEN AMOUNT ELSE 0 END) as internet_spend,
        SUM(CASE WHEN SERVICE_CATEGORY = 'PHOTOS' THEN AMOUNT ELSE 0 END) as photo_spend,
        SUM(CASE WHEN SERVICE_CATEGORY = 'SHORE_ACTIVITIES' THEN AMOUNT ELSE 0 END) as shore_activity_spend
    FROM CRUISE_YIELD_OPTIMIZATION.CURATED.GUEST_SERVICES
    GROUP BY GUEST_360_ID
)
SELECT 
    g.guest_id as guest_360_id,
    g.first_name,
    g.last_name,
    g.first_name || ' ' || g.last_name as guest_name,
    g.email,
    g.loyalty_tier,
    g.loyalty_points,
    g.past_cruises,
    g.guest_segment,
    g.preferred_cabin_class,
    g.preferred_region,
    g.member_since,
    g.price_sensitivity,
    
    COALESCE(gb.total_bookings, 0) as total_bookings,
    COALESCE(gb.confirmed_bookings, 0) as confirmed_bookings,
    COALESCE(gb.total_cabin_revenue, 0) as total_cabin_revenue,
    gb.avg_cabin_price,
    gb.first_booking_date,
    gb.last_booking_date,
    
    COALESCE(gs.total_onboard_spend, 0) as total_onboard_spend,
    COALESCE(gs.onboard_transactions, 0) as onboard_transactions,
    gs.avg_transaction_amount as avg_onboard_transaction,
    
    COALESCE(gp.total_precruise_spend, 0) as total_precruise_spend,
    COALESCE(gp.precruise_purchases, 0) as precruise_purchases,
    
    g.lifetime_value,
    g.avg_onboard_spend as historical_avg_onboard_spend,
    
    COALESCE(gb.total_cabin_revenue, 0) + COALESCE(gs.total_onboard_spend, 0) + COALESCE(gp.total_precruise_spend, 0) as calculated_total_value,
    
    CASE 
        WHEN g.loyalty_tier IN ('Diamond+', 'Diamond') AND g.price_sensitivity < 0.4 THEN 'High-Value Low-Sensitivity'
        WHEN g.loyalty_tier IN ('Diamond+', 'Diamond') AND g.price_sensitivity >= 0.4 THEN 'High-Value Price-Conscious'
        WHEN g.loyalty_tier IN ('Platinum', 'Gold') AND g.price_sensitivity < 0.5 THEN 'Mid-Value Growth-Potential'
        WHEN g.loyalty_tier IN ('Platinum', 'Gold') AND g.price_sensitivity >= 0.5 THEN 'Mid-Value Price-Sensitive'
        WHEN g.past_cruises = 0 THEN 'New-Guest Opportunity'
        ELSE 'Budget-Focused'
    END as value_segment,
    
    DATEDIFF('day', gb.last_booking_date, CURRENT_DATE()) as days_since_last_booking,
    
    COALESCE(gsa.spa_spend, 0) as spa_spend,
    COALESCE(gsa.excursion_spend, 0) as excursion_spend,
    COALESCE(gsa.specialty_dining_spend, 0) as specialty_dining_spend,
    COALESCE(gsa.beverage_package_spend, 0) as beverage_package_spend,
    COALESCE(gsa.casino_spend, 0) as casino_spend,
    COALESCE(gsa.internet_spend, 0) as internet_spend,
    COALESCE(gsa.photo_spend, 0) as photo_spend,
    COALESCE(gsa.shore_activity_spend, 0) as shore_activity_spend

FROM RAW.GUESTS g
LEFT JOIN guest_bookings gb ON g.guest_id = gb.guest_id
LEFT JOIN guest_spending gs ON g.guest_id = gs.guest_id
LEFT JOIN guest_precruise gp ON g.guest_id = gp.guest_id
LEFT JOIN guest_services_agg gsa ON g.guest_id = gsa.GUEST_360_ID;
