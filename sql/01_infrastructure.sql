-- =============================================================================
-- Cruise Yield Optimization - Infrastructure Setup
-- Layer: Infrastructure
-- Description: Database, schemas, and warehouse creation
-- =============================================================================

USE ROLE ACCOUNTADMIN;

-- Create warehouse
CREATE OR REPLACE WAREHOUSE CRUISE_ANALYTICS_WH
WITH
    WAREHOUSE_TYPE = 'STANDARD'
    WAREHOUSE_SIZE = 'Medium'
    MAX_CLUSTER_COUNT = 1
    MIN_CLUSTER_COUNT = 1
    SCALING_POLICY = STANDARD
    AUTO_SUSPEND = 300
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = FALSE
    COMMENT = 'Warehouse for Cruise yield analytics'
    ENABLE_QUERY_ACCELERATION = FALSE
    QUERY_ACCELERATION_MAX_SCALE_FACTOR = 8
    MAX_CONCURRENCY_LEVEL = 8
    STATEMENT_QUEUED_TIMEOUT_IN_SECONDS = 0
    STATEMENT_TIMEOUT_IN_SECONDS = 172800;

-- Create database
CREATE OR REPLACE DATABASE CRUISE_YIELD_OPTIMIZATION;

-- Create schemas
CREATE OR REPLACE SCHEMA CRUISE_YIELD_OPTIMIZATION.RAW
    COMMENT = 'Bronze layer - raw ingested data';

CREATE OR REPLACE SCHEMA CRUISE_YIELD_OPTIMIZATION.CURATED
    COMMENT = 'Silver layer - cleansed and enriched data';

CREATE OR REPLACE SCHEMA CRUISE_YIELD_OPTIMIZATION.ANALYTICS
    COMMENT = 'Gold layer - aggregated metrics and views';

CREATE OR REPLACE SCHEMA CRUISE_YIELD_OPTIMIZATION.ML
    COMMENT = 'Machine learning features, models, and predictions';

CREATE OR REPLACE SCHEMA CRUISE_YIELD_OPTIMIZATION.AGENTS
    COMMENT = 'Cortex Agent definitions';

CREATE OR REPLACE SCHEMA CRUISE_YIELD_OPTIMIZATION.SEARCH
    COMMENT = 'Cortex Search services';

CREATE OR REPLACE SCHEMA CRUISE_YIELD_OPTIMIZATION.CLEAN_ROOM
    COMMENT = 'Partner data sharing and clean room';

CREATE OR REPLACE SCHEMA CRUISE_YIELD_OPTIMIZATION.SCENARIOS
    COMMENT = 'What-if analysis workspace';

USE WAREHOUSE CRUISE_ANALYTICS_WH;
