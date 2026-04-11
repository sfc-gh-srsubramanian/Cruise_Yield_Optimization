-- =============================================================================
-- Cruise Yield Optimization - Cortex Agents
-- Layer: Agents
-- Description: AI agents for yield analytics, guest intelligence, pricing,
--              partner signals, and unified yield optimization
-- =============================================================================

USE SCHEMA CRUISE_YIELD_OPTIMIZATION.AGENTS;

-- ---------------------------------------------------------------------------
-- 1. YIELD ANALYST - Sailing yield metrics and revenue optimization
-- ---------------------------------------------------------------------------
CREATE OR REPLACE AGENT RCL_YIELD_ANALYST
    COMMENT = 'AI analyst for sailing yield metrics, revenue optimization, and occupancy trends'
    PROFILE = '{"display_name": "RCL Yield Analyst", "avatar": "chart"}'
    FROM SPECIFICATION $$
models:
  orchestration: auto
instructions:
  response: 'Provide clear, concise answers with key metrics highlighted. When showing trends, mention percentage changes. Format currency values appropriately.'
  orchestration: 'You are an expert yield analyst for Royal Caribbean International cruise operations. Use the yield analytics tool to answer questions about sailing performance, revenue, occupancy rates, and regional trends. Always provide data-driven insights with specific numbers.'
  sample_questions:
    - question: 'What is the overall yield performance for Q4 2024?'
    - question: 'Which region has the highest average revenue per passenger day?'
    - question: 'Show me occupancy trends for Symphony of the Seas'
    - question: 'Compare yield performance between Caribbean and Mediterranean regions'
    - question: 'What are the top 5 sailings by total revenue this month?'
    - question: 'How has average daily rate changed over the past 6 months?'
    - question: 'Which ship class has the best yield optimization?'
    - question: 'Show me the revenue breakdown by cabin class'
    - question: 'What is the average occupancy rate for Alaska itineraries?'
    - question: 'Identify underperforming sailings with low occupancy'
    - question: 'What is the net revenue trend for Harmony of the Seas?'
    - question: 'Compare weekend vs weekday sailing performance'
    - question: 'Show me seasonal yield patterns for European cruises'
    - question: 'Which departure ports generate the highest yield?'
    - question: 'What is the forecasted revenue for next quarter?'
tools:
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: yield_analytics
      description: 'Query sailing yield metrics including revenue, occupancy, and performance by ship, region, and time period'
tool_resources:
  yield_analytics:
    semantic_view: 'CRUISE_YIELD_OPTIMIZATION.ANALYTICS.YIELD_ANALYTICS'
    execution_environment:
      type: warehouse
      warehouse: 'CRUISE_ANALYTICS_WH'
    query_timeout: 60
$$;

-- ---------------------------------------------------------------------------
-- 2. GUEST INTEL - Guest intelligence and customer segmentation
-- ---------------------------------------------------------------------------
CREATE OR REPLACE AGENT RCL_GUEST_INTEL
    COMMENT = 'AI assistant for guest intelligence, loyalty insights, and customer segmentation'
    PROFILE = '{"display_name": "RCL Guest Intel", "avatar": "user"}'
    FROM SPECIFICATION $$
models:
  orchestration: auto
instructions:
  response: 'Present guest insights clearly with segment-specific recommendations. Highlight loyalty tier distributions and spending patterns.'
  orchestration: 'You are a guest intelligence specialist for Royal Caribbean International. Use the guest analytics tool to analyze customer segments, loyalty tiers, spending patterns, and booking behaviors. Provide actionable insights for marketing and personalization.'
  sample_questions:
    - question: 'What is the distribution of guests by loyalty tier?'
    - question: 'Show me the average spend by customer segment'
    - question: 'Which age group has the highest booking frequency?'
    - question: 'Analyze spending patterns for Diamond+ members'
    - question: 'What percentage of guests are repeat cruisers?'
    - question: 'Show me guest demographics for Alaska sailings'
    - question: 'Which loyalty tier has the highest onboard spending?'
    - question: 'Compare booking lead times by customer segment'
    - question: 'What is the average party size by loyalty tier?'
    - question: 'Identify high-value guests with declining engagement'
    - question: 'Show me the guest lifetime value distribution'
    - question: 'Which cabin preferences correlate with loyalty status?'
    - question: 'What are the top source markets for new guests?'
    - question: 'Analyze guest satisfaction scores by segment'
    - question: 'Which promotions drive the most loyalty upgrades?'
tools:
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: guest_360
      description: 'Query guest profiles, loyalty data, spending patterns, and customer segmentation'
tool_resources:
  guest_360:
    semantic_view: 'CRUISE_YIELD_OPTIMIZATION.ANALYTICS.GUEST_360'
    execution_environment:
      type: warehouse
      warehouse: 'CRUISE_ANALYTICS_WH'
    query_timeout: 60
$$;

-- ---------------------------------------------------------------------------
-- 3. PRICING COPILOT - Pricing analytics and optimization
-- ---------------------------------------------------------------------------
CREATE OR REPLACE AGENT RCL_PRICING_COPILOT
    COMMENT = 'AI copilot for pricing analytics, conversion rates, and competitive positioning'
    PROFILE = '{"display_name": "RCL Pricing Copilot", "avatar": "dollar"}'
    FROM SPECIFICATION $$
models:
  orchestration: auto
instructions:
  response: 'Deliver pricing insights with clear metrics on impressions, conversions, and revenue impact. Highlight opportunities for price optimization.'
  orchestration: 'You are a pricing strategy expert for Royal Caribbean International. Use the pricing analytics tool to analyze price performance, conversion rates, and pricing trends by ship, cabin class, and region. Provide recommendations for pricing optimization.'
  sample_questions:
    - question: 'Can you give me pricing recommendations for Harmony of the Seas?'
    - question: 'What is the conversion rate by cabin class?'
    - question: 'Show me pricing trends for Balcony cabins this quarter'
    - question: 'Which ships have the highest price-to-conversion ratio?'
    - question: 'Compare pricing performance across departure ports'
    - question: 'What is the average booking value for Suite cabins?'
    - question: 'Identify pricing anomalies in recent bookings'
    - question: 'Show me the impression-to-booking funnel for Harmony of the Seas'
    - question: 'Which regions have the most competitive pricing?'
    - question: 'Analyze price elasticity by cabin category'
    - question: 'What pricing adjustments improved conversion last month?'
    - question: 'Show me the revenue impact of promotional pricing'
    - question: 'Which itineraries are overpriced based on conversion rates?'
    - question: 'Compare interior vs oceanview pricing effectiveness'
    - question: 'What is the optimal price point for Caribbean cruises?'
tools:
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: pricing_analytics
      description: 'Query pricing metrics including impressions, conversions, revenue, and performance by ship, cabin class, and region'
tool_resources:
  pricing_analytics:
    semantic_view: 'CRUISE_YIELD_OPTIMIZATION.ANALYTICS.PRICING_ANALYTICS'
    execution_environment:
      type: warehouse
      warehouse: 'CRUISE_ANALYTICS_WH'
    query_timeout: 60
$$;

-- ---------------------------------------------------------------------------
-- 4. PARTNER INSIGHTS - Airline demand and partner signals
-- ---------------------------------------------------------------------------
CREATE OR REPLACE AGENT RCL_PARTNER_INSIGHTS
    COMMENT = 'AI analyst for airline partner signals, demand correlation, and partnership optimization'
    PROFILE = '{"display_name": "RCL Partner Insights", "avatar": "airplane"}'
    FROM SPECIFICATION $$
models:
  orchestration: auto
instructions:
  response: 'Present partner data insights clearly with focus on demand signals and market opportunities. Highlight correlations between airline and cruise demand.'
  orchestration: 'You are a partner analytics specialist for Royal Caribbean International. Use the partner signals tool to analyze airline booking data, flight search trends, and travel demand signals from clean room partnerships. Provide insights for demand forecasting and marketing alignment.'
  sample_questions:
    - question: 'What are the top airline routes correlating with cruise bookings?'
    - question: 'Show me flight search trends for Caribbean destinations'
    - question: 'Which airports have the highest cruise passenger throughput?'
    - question: 'Analyze airline booking patterns before cruise departures'
    - question: 'What is the overlap between airline loyalty and cruise guests?'
    - question: 'Show me partner signal strength by departure port'
    - question: 'Which airlines drive the most cruise package bookings?'
    - question: 'Compare domestic vs international flight correlations'
    - question: 'What travel demand signals indicate booking opportunities?'
    - question: 'Identify emerging markets from airline search data'
    - question: 'Show me seasonal patterns in partner airline data'
    - question: 'Which routes have increasing demand for cruise destinations?'
    - question: 'Analyze the lead time between flight and cruise bookings'
    - question: 'What partner signals predict high-yield passengers?'
    - question: 'Compare airline partner performance by region'
tools:
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: partner_signals
      description: 'Query airline partner data including flight searches, booking patterns, and travel demand signals'
tool_resources:
  partner_signals:
    semantic_view: 'CRUISE_YIELD_OPTIMIZATION.ANALYTICS.PARTNER_SIGNALS'
    execution_environment:
      type: warehouse
      warehouse: 'CRUISE_ANALYTICS_WH'
    query_timeout: 60
$$;

-- ---------------------------------------------------------------------------
-- 5. UNIFIED YIELD OPTIMIZATION AGENT - Multi-tool agent with all 4 data sources
-- ---------------------------------------------------------------------------
CREATE OR REPLACE AGENT RCL_YIELD_OPTIMIZATION_AGENT
    COMMENT = 'Unified AI assistant for RCL Dynamic Yield Optimization - covers yield analytics, guest intelligence, pricing optimization, and partner signals'
    PROFILE = '{"display_name": "RCL Yield Optimization Assistant", "avatar": "ship"}'
    FROM SPECIFICATION $$
models:
  orchestration: auto
instructions:
  response: 'Provide clear, actionable insights for cruise line revenue management. Format data with tables when appropriate. Highlight key metrics and trends. Be concise but thorough.'
  orchestration: 'You are an AI assistant for Royal Caribbean International''s Dynamic Yield Optimization platform. Route queries to the appropriate tool based on content: Use yield_analytics for occupancy, net yield, booking velocity, and revenue forecasts. Use guest_360 for customer profiles, lifetime value, loyalty, and spending patterns. Use pricing_analytics for conversion rates, price elasticity, and revenue per impression. Use partner_signals for airline data, flight pricing, and partner demand signals.'
  sample_questions:
    - question: 'What is the conversion rate by cabin class?'
    - question: 'Give me pricing recommendations for Harmony of the Seas by cabin class'
    - question: 'Which cabin classes have the lowest conversion rates and need price adjustments?'
    - question: 'Are there any unusual airline pricing signals that could indicate demand changes?'
    - question: 'What do the forward-looking airline signals show?'
    - question: 'Based on current conversion rates and occupancy, which ships should we prioritize for promotional pricing?'
    - question: 'If we lowered Suite prices by 10%, which ships would benefit most based on their current conversion rates?'
    - question: 'Are there any ports where airline prices are spiking but our cruise conversions are dropping?'
    - question: 'How does price sensitivity vary across loyalty tiers, and which tier represents the best upsell opportunity?'
    - question: 'Which guest segments have high lifetime value but low spa/excursion attach rates?'
    - question: 'What cabin class do Diamond+ members prefer, and how does their conversion rate compare to other tiers?'
    - question: 'Is there a correlation between airline ticket prices and cruise booking conversions for Miami departures?'
    - question: 'Which origin cities have guests with the highest lifetime value?'
    - question: 'Which cabin classes are overpriced relative to their conversion performance?'
    - question: 'What is the optimal price point for Balcony cabins based on historical conversion patterns?'
tools:
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: yield_analytics
      description: 'Query yield performance metrics including net yield, occupancy rates, booking velocity, and revenue forecasts for cruise sailings.'
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: guest_360
      description: 'Query guest profiles with lifetime value, spending patterns, loyalty information, and value segmentation.'
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: pricing_analytics
      description: 'Query price performance metrics including conversion rates, price elasticity, and revenue per impression.'
  - tool_spec:
      type: cortex_analyst_text_to_sql
      name: partner_signals
      description: 'Query airline and travel partner demand signals including flight pricing, capacity utilization, and anomaly detection.'
tool_resources:
  yield_analytics:
    semantic_view: 'CRUISE_YIELD_OPTIMIZATION.ANALYTICS.YIELD_ANALYTICS'
    execution_environment:
      type: warehouse
      warehouse: 'CRUISE_ANALYTICS_WH'
  guest_360:
    semantic_view: 'CRUISE_YIELD_OPTIMIZATION.ANALYTICS.GUEST_360'
    execution_environment:
      type: warehouse
      warehouse: 'CRUISE_ANALYTICS_WH'
  pricing_analytics:
    semantic_view: 'CRUISE_YIELD_OPTIMIZATION.ANALYTICS.PRICING_ANALYTICS'
    execution_environment:
      type: warehouse
      warehouse: 'CRUISE_ANALYTICS_WH'
  partner_signals:
    semantic_view: 'CRUISE_YIELD_OPTIMIZATION.ANALYTICS.PARTNER_SIGNALS'
    execution_environment:
      type: warehouse
      warehouse: 'CRUISE_ANALYTICS_WH'
$$;
