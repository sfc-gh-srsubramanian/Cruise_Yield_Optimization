-- =============================================================================
-- Cruise Yield Optimization - Analytics Functions
-- Layer: Analytics (Gold)
-- Description: Cortex Analyst query helper function
-- =============================================================================

USE SCHEMA CRUISE_YIELD_OPTIMIZATION.ANALYTICS;

-- ---------------------------------------------------------------------------
-- CORTEX_ANALYST_QUERY: Table function to query semantic views via Cortex
-- Inputs: question (text), semantic_view_name (fully qualified name)
-- Returns: TABLE with response_type and response_content columns
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION CORTEX_ANALYST_QUERY(
    QUESTION VARCHAR,
    SEMANTIC_VIEW_NAME VARCHAR
)
RETURNS TABLE (RESPONSE_TYPE VARCHAR, RESPONSE_CONTENT VARCHAR)
LANGUAGE SQL
AS '
    SELECT 
        value:type::VARCHAR as response_type,
        CASE 
            WHEN value:type = ''sql'' THEN value:statement::VARCHAR
            WHEN value:type = ''text'' THEN value:text::VARCHAR
            ELSE value::VARCHAR
        END as response_content
    FROM TABLE(FLATTEN(
        SNOWFLAKE.CORTEX.COMPLETE(
            ''llama3.1-70b'',
            CONCAT(
                ''You are a SQL expert. Given the semantic view '', semantic_view_name,
                '', generate a Snowflake SQL query to answer: '', question,
                ''. Return ONLY the SQL query, nothing else.''
            )
        )
    ))
';
