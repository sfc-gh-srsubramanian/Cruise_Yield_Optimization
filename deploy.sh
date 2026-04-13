#!/bin/bash
# =============================================================================
# Cruise Yield Optimization - Unified Deployment Script
# Description: Generates SQL from a profile config and deploys to Snowflake
# Usage: ./deploy.sh <profile> [connection]
#   profile:    Any cruise line name (e.g. cruise, royal_caribbean, norwegian, carnival, disney)
#              Existing profiles use config/<profile>.json. New profiles are auto-generated via Cortex AI.
#   connection: Snowflake connection name (default: "default")
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- Validate arguments ---
if [ -z "$1" ]; then
    echo "Usage: ./deploy.sh <profile> [connection]"
    echo ""
    echo "Available profiles:"
    for f in "$SCRIPT_DIR"/config/*.json; do
        basename "$f" .json
    done | sed 's/^/  - /'
    echo ""
    echo "Examples:"
    echo "  ./deploy.sh cruise              # Generic cruise, default connection"
    echo "  ./deploy.sh royal_caribbean     # RCL profile, default connection"
    echo "  ./deploy.sh norwegian SS_CURSOR # NCL profile, specific connection"
    echo "  ./deploy.sh carnival            # Auto-generates Carnival config via AI"
    echo "  ./deploy.sh disney              # Auto-generates Disney config via AI"
    exit 1
fi

PROFILE="$1"
CONNECTION="${2:-default}"
CONFIG_FILE="$SCRIPT_DIR/config/${PROFILE}.json"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Profile '$PROFILE' not found. Auto-generating config using Cortex AI..."
    echo ""
    python3 "$SCRIPT_DIR/generate_config.py" "$PROFILE" "$CONNECTION"
    if [ $? -ne 0 ]; then
        echo ""
        echo "Config generation failed. You can create config/${PROFILE}.json manually"
        echo "using config/cruise.json as a template."
        exit 1
    fi
    echo ""
fi

# --- Step 1: Generate SQL from templates ---
echo "=============================================="
echo "  Step 1: Generating SQL for profile '$PROFILE'"
echo "=============================================="
echo ""

python3 "$SCRIPT_DIR/generate.py" "$PROFILE"
if [ $? -ne 0 ]; then
    echo "Generation failed. Aborting deployment."
    exit 1
fi

# --- Step 2: Deploy generated SQL ---
SQL_DIR="$SCRIPT_DIR/generated/$PROFILE/sql"

echo ""
echo "=============================================="
echo "  Step 2: Deploying to Snowflake"
echo "  Profile:    $PROFILE"
echo "  Connection: $CONNECTION"
echo "=============================================="

# Ordered list of SQL files (dependency order matters)
SQL_FILES=(
    "01_infrastructure.sql"
    "02_raw_tables.sql"
    "03_curated_tables.sql"
    "04_curated_views.sql"
    "05_analytics_views.sql"
    "06_clean_room_views.sql"
    "07_ml_objects.sql"
    "08_semantic_views_basic.sql"
    "09_semantic_views_ca.sql"
    "10_analytics_functions.sql"
    "11_load_data.sql"
    "12_agents.sql"
    "13_register_si.sql"
)

for sql_file in "${SQL_FILES[@]}"; do
    echo ""
    echo "--- Executing: $sql_file ---"
    if snow sql -f "$SQL_DIR/$sql_file" --connection "$CONNECTION"; then
        echo "    [OK] $sql_file"
    else
        echo "    [FAIL] $sql_file"
        echo "Deployment stopped. Fix the error above and re-run."
        exit 1
    fi
done

echo ""
echo "=============================================="
echo "  Deployment Complete!"
echo "=============================================="
echo ""
echo "Profile '$PROFILE' deployed successfully."
echo "  - Generated SQL in: generated/$PROFILE/sql/"
echo "  - Connection used:  $CONNECTION"
echo ""
echo "To teardown: ./clean.sh $PROFILE [$CONNECTION]"
