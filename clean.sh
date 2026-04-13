#!/bin/bash
# =============================================================================
# Cruise Yield Optimization - Unified Teardown Script
# Description: Drops all solution objects for a given profile
# Usage: ./clean.sh <profile> [connection]
#   profile:    Any cruise line name that has been deployed (must have config/<profile>.json)
#   connection: Snowflake connection name (default: "default")
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- Validate arguments ---
if [ -z "$1" ]; then
    echo "Usage: ./clean.sh <profile> [connection]"
    echo ""
    echo "Available profiles:"
    for f in "$SCRIPT_DIR"/config/*.json; do
        basename "$f" .json
    done | sed 's/^/  - /'
    exit 1
fi

PROFILE="$1"
CONNECTION="${2:-default}"
CONFIG_FILE="$SCRIPT_DIR/config/${PROFILE}.json"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Profile '$PROFILE' not found at $CONFIG_FILE"
    echo "Only deployed profiles (with an existing config) can be cleaned."
    echo ""
    echo "Available profiles:"
    for f in "$SCRIPT_DIR"/config/*.json; do
        basename "$f" .json
    done | sed 's/^/  - /'
    exit 1
fi

# Extract database and warehouse names from config
DATABASE=$(python3 -c "import json; print(json.load(open('$CONFIG_FILE'))['database_name'])")
WAREHOUSE=$(python3 -c "import json; print(json.load(open('$CONFIG_FILE'))['warehouse_name'])")

echo "=============================================="
echo "  Cruise Yield Optimization - Teardown"
echo "  Profile:    $PROFILE"
echo "  Connection: $CONNECTION"
echo "=============================================="
echo ""
echo "WARNING: This will permanently drop:"
echo "  - Database:  $DATABASE (all schemas, tables, views, functions)"
echo "  - Warehouse: $WAREHOUSE"
echo ""
read -p "Are you sure? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo "Teardown cancelled."
    exit 0
fi

echo ""
echo "--- Dropping database ---"
snow sql -q "DROP DATABASE IF EXISTS $DATABASE;" --connection "$CONNECTION"

echo "--- Dropping warehouse ---"
snow sql -q "DROP WAREHOUSE IF EXISTS $WAREHOUSE;" --connection "$CONNECTION"

echo ""
echo "=============================================="
echo "  Teardown Complete ($PROFILE)"
echo "=============================================="
