#!/usr/bin/env python3
"""
Cruise Yield Optimization - Profile-Based SQL Generator

Reads a cruise line profile from config/<profile>.json and renders
all SQL files, shell scripts, and README from .template files.

Usage:
    python generate.py <profile_name>
    python generate.py norwegian
    python generate.py royal_caribbean
"""

import json
import os
import sys
import re

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
CONFIG_DIR = os.path.join(BASE_DIR, "config")
SQL_DIR = os.path.join(BASE_DIR, "sql")
TEMPLATES_DIR = os.path.join(BASE_DIR, "templates")


def load_config(profile_name):
    """Load a cruise line config profile."""
    config_path = os.path.join(CONFIG_DIR, f"{profile_name}.json")
    if not os.path.exists(config_path):
        available = [f.replace(".json", "") for f in os.listdir(CONFIG_DIR) if f.endswith(".json")]
        print(f"Error: Profile '{profile_name}' not found at {config_path}")
        print(f"Available profiles: {', '.join(available)}")
        sys.exit(1)
    with open(config_path, "r") as f:
        return json.load(f)


def sql_array(values, quote=True):
    """Convert a Python list to a SQL ARRAY_CONSTRUCT(...) inner string."""
    if quote:
        escaped = [v.replace("'", "''") for v in values]
        return ",".join(f"'{v}'" for v in escaped)
    else:
        return ",".join(str(v) for v in values)


def sql_array_construct(values, quote=True):
    """Full ARRAY_CONSTRUCT(...)."""
    return f"ARRAY_CONSTRUCT({sql_array(values, quote)})"


def json_array(values):
    """Convert to JSON array string for CA extensions."""
    return json.dumps(values)


def build_port_airport_case(ports):
    """Build the CASE WHEN port mapping for 06_clean_room_views."""
    lines = []
    for p in ports:
        lines.append(f"            WHEN '{p['port']}' THEN '{p['airport']}'")
    return "\n".join(lines)


def build_cabin_price_case(cabin_classes, base_prices):
    """Build CASE expression for ML UDFs mapping cabin class to base price."""
    lines = []
    for cabin, price in zip(cabin_classes, base_prices):
        lines.append(f"            WHEN ''{cabin}'' THEN {price}")
    return " ".join(lines)


def build_loyalty_tier_case(tiers):
    """Build CASE expression for ML UDFs mapping loyalty tier to multiplier."""
    # Assign multipliers from highest to lowest tier
    multipliers = [1.3, 1.2, 1.1, 1.0, 0.9]
    # If more than 5 tiers, extend with 0.8, 0.7, etc.
    while len(multipliers) < len(tiers):
        multipliers.append(round(multipliers[-1] - 0.1, 1))
    lines = []
    for tier, mult in zip(reversed(tiers), multipliers):
        lines.append(f"WHEN ''{tier}'' THEN {mult}")
    return " ".join(lines)


def build_loyalty_tier_case_optimal(tiers):
    """Build CASE for GET_OPTIMAL_PRICE_RECOMMENDATION onboard spend multiplier."""
    multipliers = [1.5, 1.3, 1.1, 1.0, 1.0]
    while len(multipliers) < len(tiers):
        multipliers.append(1.0)
    lines = []
    for tier, mult in zip(reversed(tiers), multipliers):
        lines.append(f"WHEN ''{tier}'' THEN {mult}")
    return " ".join(lines)


def build_value_segment_case(config):
    """Build the VALUE_SEGMENT CASE expression for GUEST_360 view."""
    high = config["loyalty_tier_high"]
    mid = config["loyalty_tier_mid"]
    ht = config["loyalty_tier_high_sensitivity_threshold"]
    mt = config["loyalty_tier_mid_sensitivity_threshold"]

    high_in = ", ".join(f"'{t}'" for t in high)
    mid_in = ", ".join(f"'{t}'" for t in mid)

    return f"""CASE 
        WHEN g.loyalty_tier IN ({high_in}) AND g.price_sensitivity < {ht} THEN 'High-Value Low-Sensitivity'
        WHEN g.loyalty_tier IN ({high_in}) AND g.price_sensitivity >= {ht} THEN 'High-Value Price-Conscious'
        WHEN g.loyalty_tier IN ({mid_in}) AND g.price_sensitivity < {mt} THEN 'Mid-Value Growth-Potential'
        WHEN g.loyalty_tier IN ({mid_in}) AND g.price_sensitivity >= {mt} THEN 'Mid-Value Price-Sensitive'
        WHEN g.past_cruises = 0 THEN 'New-Guest Opportunity'
        ELSE 'Budget-Focused'
    END"""


def build_replacements(config):
    """Build the full replacement dictionary from config."""
    ships = config["ships"]
    ship_names = [s["name"] for s in ships]
    ship_classes_aligned = [s["class"] for s in ships]
    capacities = [s["capacity"] for s in ships]
    ship_classes_unique = sorted(set(ship_classes_aligned))
    ports = config["ports"]
    port_names = [p["port"] for p in ports]
    airport_codes = [p["airport"] for p in ports]
    cabin_classes = config["cabin_classes"]
    base_prices = config["base_prices"]
    tiers = config["loyalty_tiers"]
    num_ships = len(ships)
    num_cabins = len(cabin_classes)
    num_tiers = len(tiers)
    num_ports = len(port_names)
    num_regions = len(config["regions"])
    num_categories = len(config["onboard_spending_categories"])
    num_venues = len(config["onboard_spending_venues"])
    num_packages = len(config["precruise_packages"])
    num_svc_categories = len(config["service_categories"])
    num_svc_names = len(config["service_names"])
    num_subcategories = len(config["feedback_subcategories"])
    num_fb_categories = len(config["feedback_categories"])
    num_airlines = len(config["airlines"])
    num_origin_airports = len(config["origin_airports"])
    num_dest_airports = len(config["flight_dest_airports"])
    num_segments = len(config["guest_segments"])
    num_amenities = len(config["amenities"])
    num_excursions = len(config["excursions"])
    num_sources = 3  # INDEPENDENT, CRUISE_LINE, PACKAGE - always 3

    # Build tier_nums aligned 1..N
    tier_nums = list(range(1, num_tiers + 1))

    r = {
        # Infrastructure
        "{{DATABASE_NAME}}": config["database_name"],
        "{{WAREHOUSE_NAME}}": config["warehouse_name"],
        "{{WAREHOUSE_COMMENT}}": config["warehouse_comment"],
        "{{SOLUTION_TITLE}}": config["solution_title"],
        "{{CRUISE_LINE}}": config["cruise_line"],
        "{{CRUISE_LINE_SHORT}}": config["cruise_line_short"],
        "{{AGENT_PREFIX}}": config["agent_prefix"],
        "{{SAMPLE_SHIP_1}}": config["sample_ship_1"],
        "{{SAMPLE_SHIP_2}}": config["sample_ship_2"],
        "{{SAMPLE_SHIP_CLASS_1}}": config["sample_ship_class_1"],
        "{{SAMPLE_TIER_TOP}}": config["sample_tier_top"],
        "{{SAMPLE_CABIN_MID}}": config["sample_cabin_mid"],
        "{{SAMPLE_CABIN_TOP}}": config["sample_cabin_top"],

        # Loyalty
        "{{LOYALTY_PROGRAM}}": config["loyalty_program"],
        "{{LOYALTY_TIERS_ARRAY}}": sql_array(tiers),
        "{{LOYALTY_TIER_NUMS_ARRAY}}": sql_array(tier_nums, quote=False),
        "{{NUM_TIERS}}": str(num_tiers),

        # Ships
        "{{SHIPS_ARRAY}}": sql_array(ship_names),
        "{{SHIP_CLASSES_ALIGNED_ARRAY}}": sql_array(ship_classes_aligned),
        "{{CAPACITIES_ARRAY}}": sql_array(capacities, quote=False),
        "{{NUM_SHIPS}}": str(num_ships),

        # Cabins & Prices
        "{{CABIN_CLASSES_ARRAY}}": sql_array(cabin_classes),
        "{{BASE_PRICES_ARRAY}}": sql_array(base_prices, quote=False),
        "{{NUM_CABINS}}": str(num_cabins),

        # Regions
        "{{REGIONS_ARRAY}}": sql_array(config["regions"]),
        "{{NUM_REGIONS}}": str(num_regions),

        # Ports
        "{{PORTS_ARRAY}}": sql_array(port_names),
        "{{AIRPORTS_ARRAY}}": sql_array(airport_codes),
        "{{PORT_AIRPORT_CASE}}": build_port_airport_case(ports),
        "{{NUM_PORTS}}": str(num_ports),

        # Amenities / Excursions / Dining
        "{{AMENITIES_ARRAY}}": sql_array(config["amenities"]),
        "{{NUM_AMENITIES}}": str(num_amenities),
        "{{EXCURSIONS_ARRAY}}": sql_array(config["excursions"]),
        "{{NUM_EXCURSIONS}}": str(num_excursions),
        "{{DINING_VENUES_ARRAY}}": sql_array(config["dining_venues"]),

        # Onboard spending
        "{{ONBOARD_CATEGORIES_ARRAY}}": sql_array(config["onboard_spending_categories"]),
        "{{ONBOARD_VENUES_ARRAY}}": sql_array(config["onboard_spending_venues"]),
        "{{NUM_CATEGORIES}}": str(num_categories),
        "{{NUM_VENUES}}": str(num_venues),

        # Precruise
        "{{PRECRUISE_PACKAGES_ARRAY}}": sql_array(config["precruise_packages"]),
        "{{PRECRUISE_CATEGORIES_ARRAY}}": sql_array(config["precruise_categories"]),
        "{{NUM_PACKAGES}}": str(num_packages),

        # Services
        "{{SERVICE_CATEGORIES_ARRAY}}": sql_array(config["service_categories"]),
        "{{SERVICE_NAMES_ARRAY}}": sql_array(config["service_names"]),
        "{{NUM_SVC_CATEGORIES}}": str(num_svc_categories),
        "{{NUM_SVC_NAMES}}": str(num_svc_names),

        # Feedback
        "{{FEEDBACK_CATEGORIES_ARRAY}}": sql_array(config["feedback_categories"]),
        "{{FEEDBACK_SUBCATEGORIES_ARRAY}}": sql_array(config["feedback_subcategories"]),
        "{{NUM_FB_CATEGORIES}}": str(num_fb_categories),
        "{{NUM_SUBCATEGORIES}}": str(num_subcategories),
        "{{FEEDBACK_TEMPLATES_POSITIVE_ARRAY}}": sql_array(config["feedback_templates_positive"]),
        "{{FEEDBACK_TEMPLATES_NEUTRAL_ARRAY}}": sql_array(config["feedback_templates_neutral"]),
        "{{FEEDBACK_TEMPLATES_NEGATIVE_ARRAY}}": sql_array(config["feedback_templates_negative"]),

        # Guest segments
        "{{GUEST_SEGMENTS_ARRAY}}": sql_array(config["guest_segments"]),
        "{{NUM_SEGMENTS}}": str(num_segments),

        # Airlines / Flights
        "{{AIRLINES_ARRAY}}": sql_array(config["airlines"]),
        "{{AIRLINE_CODES_ARRAY}}": sql_array(config["airline_codes"]),
        "{{NUM_AIRLINES}}": str(num_airlines),
        "{{ORIGIN_AIRPORTS_ARRAY}}": sql_array(config["origin_airports"]),
        "{{ORIGIN_CITIES_ARRAY}}": sql_array(config["origin_cities"]),
        "{{NUM_ORIGIN_AIRPORTS}}": str(num_origin_airports),
        "{{FLIGHT_DEST_AIRPORTS_ARRAY}}": sql_array(config["flight_dest_airports"]),
        "{{FLIGHT_DEST_CITIES_ARRAY}}": sql_array(config["flight_dest_cities"]),
        "{{NUM_DEST_AIRPORTS}}": str(num_dest_airports),

        # ML UDF CASE expressions
        "{{CABIN_PRICE_CASE}}": build_cabin_price_case(cabin_classes, base_prices),
        "{{LOYALTY_TIER_CASE}}": build_loyalty_tier_case(tiers),
        "{{LOYALTY_TIER_CASE_OPTIMAL}}": build_loyalty_tier_case_optimal(tiers),

        # GUEST_360 VALUE_SEGMENT
        "{{VALUE_SEGMENT_CASE}}": build_value_segment_case(config),

        # Semantic view sample_values (JSON)
        "{{SAMPLE_SHIPS_JSON}}": json_array(ship_names),
        "{{SAMPLE_CLASSES_JSON}}": json_array(ship_classes_unique),
        "{{SAMPLE_REGIONS_JSON}}": json_array(config["regions"]),
        "{{SAMPLE_PORTS_JSON}}": json_array(port_names[:6]),
        "{{SAMPLE_CABINS_JSON}}": json_array(cabin_classes),
        "{{SAMPLE_TIERS_JSON}}": json_array(tiers),
        "{{SAMPLE_SEGMENTS_JSON}}": json_array(config["guest_segments"][:5]),
        "{{SAMPLE_AIRPORTS_JSON}}": json_array(airport_codes[:5]),

        # Durations (same for all cruise lines)
        "{{DURATIONS_ARRAY}}": "3,4,5,7,10,14",
    }
    return r


def render_template(template_content, replacements):
    """Replace all {{PLACEHOLDER}} markers in template content."""
    result = template_content
    for key, value in replacements.items():
        result = result.replace(key, value)
    # Check for unreplaced placeholders
    remaining = re.findall(r'\{\{[A-Z_]+\}\}', result)
    if remaining:
        unique = sorted(set(remaining))
        print(f"  WARNING: Unreplaced placeholders: {', '.join(unique)}")
    return result


def generate(profile_name):
    """Generate all SQL files from templates for a given profile."""
    config = load_config(profile_name)
    replacements = build_replacements(config)

    print(f"Generating SQL for profile: {profile_name}")
    print(f"  Cruise line: {config['cruise_line']}")
    print(f"  Database:    {config['database_name']}")
    print(f"  Warehouse:   {config['warehouse_name']}")
    print()

    # Process all template files
    template_files = []
    for root, dirs, files in os.walk(TEMPLATES_DIR):
        for f in sorted(files):
            if f.endswith(".template"):
                template_files.append(os.path.join(root, f))

    if not template_files:
        print(f"Error: No template files found in {TEMPLATES_DIR}/")
        print("Run the template conversion first.")
        sys.exit(1)

    for template_path in template_files:
        # Determine output path
        rel_path = os.path.relpath(template_path, TEMPLATES_DIR)
        # Remove .template suffix
        output_rel = rel_path.replace(".template", "")
        output_path = os.path.join(BASE_DIR, output_rel)

        # Ensure output directory exists
        os.makedirs(os.path.dirname(output_path), exist_ok=True)

        with open(template_path, "r") as f:
            template_content = f.read()

        rendered = render_template(template_content, replacements)

        with open(output_path, "w") as f:
            f.write(rendered)

        print(f"  Generated: {output_rel}")

    print()
    print(f"Done. All files generated for '{config['cruise_line']}'.")
    print(f"Deploy with: ./deploy.sh <connection_name>")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python generate.py <profile_name>")
        print()
        available = []
        if os.path.exists(CONFIG_DIR):
            available = [f.replace(".json", "") for f in sorted(os.listdir(CONFIG_DIR)) if f.endswith(".json")]
        if available:
            print(f"Available profiles: {', '.join(available)}")
        sys.exit(1)
    generate(sys.argv[1])
