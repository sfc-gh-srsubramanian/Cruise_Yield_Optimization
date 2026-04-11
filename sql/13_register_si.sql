-- =============================================================================
-- Cruise Yield Optimization - Register Agents with Snowflake Intelligence
-- Layer: Snowflake Intelligence
-- Description: Creates the SI object (if not exists) and registers all 5
--              Cortex Agents so they appear in Snowflake Intelligence AI
-- =============================================================================

-- Create the account-level Snowflake Intelligence object if it doesn't exist
CREATE SNOWFLAKE INTELLIGENCE IF NOT EXISTS SNOWFLAKE_INTELLIGENCE_OBJECT_DEFAULT;

-- ---------------------------------------------------------------------------
-- Register each agent with Snowflake Intelligence
-- Using ALTER ... ADD AGENT (idempotent - safe to re-run)
-- ---------------------------------------------------------------------------

-- 1. Yield Analyst
ALTER SNOWFLAKE INTELLIGENCE SNOWFLAKE_INTELLIGENCE_OBJECT_DEFAULT
    ADD AGENT CRUISE_YIELD_OPTIMIZATION.AGENTS.RCL_YIELD_ANALYST;

-- 2. Guest Intel
ALTER SNOWFLAKE INTELLIGENCE SNOWFLAKE_INTELLIGENCE_OBJECT_DEFAULT
    ADD AGENT CRUISE_YIELD_OPTIMIZATION.AGENTS.RCL_GUEST_INTEL;

-- 3. Pricing Copilot
ALTER SNOWFLAKE INTELLIGENCE SNOWFLAKE_INTELLIGENCE_OBJECT_DEFAULT
    ADD AGENT CRUISE_YIELD_OPTIMIZATION.AGENTS.RCL_PRICING_COPILOT;

-- 4. Partner Insights
ALTER SNOWFLAKE INTELLIGENCE SNOWFLAKE_INTELLIGENCE_OBJECT_DEFAULT
    ADD AGENT CRUISE_YIELD_OPTIMIZATION.AGENTS.RCL_PARTNER_INSIGHTS;

-- 5. Unified Yield Optimization Agent
ALTER SNOWFLAKE INTELLIGENCE SNOWFLAKE_INTELLIGENCE_OBJECT_DEFAULT
    ADD AGENT CRUISE_YIELD_OPTIMIZATION.AGENTS.RCL_YIELD_OPTIMIZATION_AGENT;

-- Grant usage to ACCOUNTADMIN (ensures visibility)
GRANT USAGE ON SNOWFLAKE INTELLIGENCE SNOWFLAKE_INTELLIGENCE_OBJECT_DEFAULT TO ROLE ACCOUNTADMIN;
