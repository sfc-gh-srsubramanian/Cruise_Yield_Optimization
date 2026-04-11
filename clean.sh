#!/bin/bash
# =============================================================================
# Cruise Yield Optimization - Teardown Script
# Description: Drops all solution objects (database and warehouse)
# Usage: ./clean.sh [CONNECTION_NAME]
# =============================================================================

CONNECTION="${1:-default}"

echo "=============================================="
echo "  Cruise Yield Optimization - Teardown"
echo "  Connection: $CONNECTION"
echo "=============================================="
echo ""
echo "WARNING: This will permanently drop:"
echo "  - Database: CRUISE_YIELD_OPTIMIZATION (all schemas, tables, views, functions)"
echo "  - Warehouse: CRUISE_ANALYTICS_WH"
echo ""
read -p "Are you sure? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo "Teardown cancelled."
    exit 0
fi

echo ""
echo "--- Dropping database ---"
snow sql -q "DROP DATABASE IF EXISTS CRUISE_YIELD_OPTIMIZATION;" --connection "$CONNECTION"

echo "--- Dropping warehouse ---"
snow sql -q "DROP WAREHOUSE IF EXISTS CRUISE_ANALYTICS_WH;" --connection "$CONNECTION"

echo ""
echo "=============================================="
echo "  Teardown Complete"
echo "=============================================="
