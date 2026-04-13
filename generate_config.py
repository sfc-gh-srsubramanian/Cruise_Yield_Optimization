#!/usr/bin/env python3
"""
Cruise Yield Optimization - AI-Powered Config Generator

Generates a cruise line config JSON using Snowflake Cortex AI.
Given just a cruise line name, produces a complete config with
real ship names, loyalty programs, ports, amenities, etc.

Usage:
    python generate_config.py <profile_name> [connection]
    python generate_config.py carnival
    python generate_config.py disney SS_CURSOR
"""

import json
import os
import re
import subprocess
import sys

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
CONFIG_DIR = os.path.join(BASE_DIR, "config")

# Fields the LLM should NOT generate - we derive these automatically
DERIVED_FIELDS = {
    "profile_name", "database_name", "warehouse_name", "warehouse_comment",
    "solution_title", "agent_prefix",
    "loyalty_tier_high_sensitivity_threshold", "loyalty_tier_mid_sensitivity_threshold",
    "feedback_templates_positive", "feedback_templates_neutral", "feedback_templates_negative",
    "feedback_categories", "feedback_subcategories",
    "onboard_spending_categories", "onboard_spending_venues",
    "precruise_categories", "service_categories",
    "airlines", "airline_codes",
    "origin_airports", "origin_cities",
}

# These stay the same across all cruise lines
STATIC_VALUES = {
    "loyalty_tier_high_sensitivity_threshold": 0.4,
    "loyalty_tier_mid_sensitivity_threshold": 0.5,
    "feedback_categories": ["Dining", "Entertainment", "Service", "Amenities", "Excursions", "Accommodations"],
    "feedback_subcategories": [
        "Buffet", "Specialty Restaurant", "Main Dining Room", "Room Service",
        "Bar Service", "Wait Staff", "Shows", "Live Music", "Nightclub", "Movies",
        "Guest Services", "Concierge", "Cabin Steward", "Shore Excursion Desk",
        "Pool Area", "Fitness Center", "Spa", "Sports Deck", "Casino", "Suite Lounge",
        "Beach Excursion", "City Walking Tour", "Cultural Tour", "Snorkeling/Diving",
        "Adventure Activity", "Cabin Size", "Cabin Cleanliness", "Balcony",
        "Bathroom", "Bed Comfort"
    ],
    "feedback_templates_positive": [
        " was fantastic - exactly what we hoped for.",
        " exceeded all expectations. Highly recommend!"
    ],
    "feedback_templates_neutral": [
        ". Average experience. Room for improvement."
    ],
    "feedback_templates_negative": [
        " needs improvement. Not up to standard.",
        " was disappointing compared to previous cruises."
    ],
    "onboard_spending_categories": [
        "Spa", "Dining", "Casino", "Shore Excursions", "Shopping",
        "Beverage Package", "Internet", "Photo"
    ],
    "service_categories": [
        "SPA", "EXCURSIONS", "SPECIALTY_DINING", "BEVERAGE_PACKAGE",
        "CASINO", "INTERNET", "PHOTOS", "SHORE_ACTIVITIES"
    ],
    "airlines": [
        "American Airlines", "Delta Air Lines", "United Airlines",
        "Southwest Airlines", "JetBlue Airways", "Alaska Airlines",
        "Spirit Airlines", "Frontier Airlines"
    ],
    "airline_codes": ["AA", "DL", "UA", "WN", "B6", "AS", "NK", "F9"],
    "origin_airports": ["JFK", "LAX", "ORD", "ATL", "DFW", "SFO", "SEA", "BOS", "DEN", "PHX", "DTW", "MSP"],
    "origin_cities": [
        "New York", "Los Angeles", "Chicago", "Atlanta", "Dallas",
        "San Francisco", "Seattle", "Boston", "Denver", "Phoenix", "Detroit", "Minneapolis"
    ],
}


def build_prompt(profile_name):
    """Build the LLM prompt for generating cruise line config."""
    return f"""You are a cruise industry data expert. Generate a JSON configuration for "{profile_name}" cruise line.

Return ONLY valid JSON (no markdown, no explanation, no code fences). The JSON must have EXACTLY these fields:

{{
  "cruise_line": "<Full official name, e.g. Carnival Cruise Line>",
  "cruise_line_short": "<Standard 2-4 letter abbreviation, e.g. CCL>",
  "sample_ship_1": "<Most popular/flagship ship name>",
  "sample_ship_2": "<Second most popular ship name>",
  "sample_ship_class_1": "<Class of sample_ship_1>",
  "sample_tier_top": "<Highest loyalty tier name>",
  "sample_cabin_mid": "<Middle cabin category name>",
  "sample_cabin_top": "<Top cabin category name>",
  "loyalty_program": "<Official loyalty program name>",
  "loyalty_tiers": ["<tier1_lowest>", "<tier2>", "<tier3>", "<tier4>", "<tier5_highest>"],
  "loyalty_tier_high": ["<highest_tier>", "<second_highest>"],
  "loyalty_tier_mid": ["<middle_tier>", "<lower_middle>"],
  "ships": [
    {{"name": "<real ship name>", "class": "<ship class>", "capacity": <integer>}},
    ... exactly 10 ships with real names, classes, and approximate passenger capacities
  ],
  "cabin_classes": ["<lowest>", "<next>", "<mid>", "<upper>", "<top>"],
  "base_prices": [<price1>, <price2>, <price3>, <price4>, <price5>],
  "regions": ["<region1>", "<region2>", "<region3>", "<region4>", "<region5>", "<region6>"],
  "ports": [
    {{"port": "<city>", "airport": "<IATA code>"}},
    ... exactly 16 ports where this cruise line actually operates from, with correct IATA airport codes
  ],
  "amenities": ["<amenity1>", ... exactly 15 signature amenities/features of this cruise line],
  "excursions": ["<excursion1>", ... exactly 17 typical shore excursions],
  "dining_venues": ["<venue1>", "<venue2>", "<venue3>", "<venue4>"],
  "onboard_spending_venues": [
    "<venue1>", ... exactly 24 onboard venue names (3 per spending category: Spa, Dining, Casino, Shore, Shopping, Beverage, Internet, Photo)
  ],
  "precruise_packages": ["<pkg1>", ... exactly 10 pre-cruise purchase packages],
  "precruise_categories": ["<cat1>", ... exactly 10 short category labels matching precruise_packages order],
  "service_names": ["<svc1>", ... exactly 26 specific service/activity names offered onboard],
  "guest_segments": ["Budget Cruiser", "Mainstream", "Premium Seeker", "Luxury Enthusiast", "Adventure Seeker", "Family Focused", "Spa Enthusiast", "Casino Patron", "Wine Aficionado", "Foodie"],
  "flight_dest_airports": ["<code1>", ... exactly 8 IATA codes for ports that receive fly-cruise guests],
  "flight_dest_cities": ["<city1>", ... exactly 8 city names matching flight_dest_airports order]
}}

CRITICAL RULES:
- Use REAL ship names, loyalty program names, and amenities for this cruise line
- base_prices must be 5 integers in ascending order (cheapest to most expensive cabin)
- cabin_classes must have exactly 5 entries, base_prices must have exactly 5 entries
- loyalty_tiers must have exactly 5 entries from lowest to highest
- ships must have exactly 10 entries with real names
- ports must have exactly 16 entries with correct IATA airport codes
- guest_segments must be exactly the 10 values shown above (do not change these)
- All array lengths must match exactly as specified
- Return ONLY the JSON object, nothing else"""


def call_cortex(prompt, connection="default"):
    """Call Snowflake Cortex COMPLETE via snow sql."""
    # Escape single quotes in prompt for SQL
    escaped_prompt = prompt.replace("'", "''")

    sql = f"SELECT SNOWFLAKE.CORTEX.COMPLETE('llama3.1-70b', '{escaped_prompt}') as result;"

    snow_path = "/Library/Frameworks/Python.framework/Versions/3.11/bin/snow"
    cmd = [snow_path, "sql", "-q", sql, "--connection", connection, "--format", "JSON"]

    try:
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=120)
        if result.returncode != 0:
            print(f"Error calling Cortex: {result.stderr}")
            return None

        # Parse the JSON output from snow sql
        output = json.loads(result.stdout)
        if output and len(output) > 0:
            return output[0].get("RESULT", "")
        return None
    except subprocess.TimeoutExpired:
        print("Error: Cortex call timed out after 120 seconds")
        return None
    except json.JSONDecodeError:
        # Try to extract from non-JSON output
        print(f"Warning: Could not parse snow sql JSON output, trying raw parse")
        return result.stdout


def extract_json(raw_text):
    """Extract JSON object from LLM response (handles markdown fences, preamble, etc.)."""
    if not raw_text:
        return None

    text = raw_text.strip()

    # Remove markdown code fences if present
    text = re.sub(r'^```(?:json)?\s*\n?', '', text)
    text = re.sub(r'\n?```\s*$', '', text)
    text = text.strip()

    # Try direct parse
    try:
        return json.loads(text)
    except json.JSONDecodeError:
        pass

    # Try to find JSON object in the text
    match = re.search(r'\{[\s\S]*\}', text)
    if match:
        try:
            return json.loads(match.group())
        except json.JSONDecodeError:
            pass

    return None


def fix_array_length(config, field, expected_len):
    """Pad or trim an array to the expected length. Returns True if fixable."""
    if field not in config or not isinstance(config[field], list):
        return False
    arr = config[field]
    if len(arr) == expected_len:
        return True
    if len(arr) == 0:
        return False
    # Trim if too long
    if len(arr) > expected_len:
        config[field] = arr[:expected_len]
        return True
    # Pad if short (repeat last elements)
    while len(config[field]) < expected_len:
        idx = len(config[field]) % len(arr)
        item = arr[idx]
        if isinstance(item, str):
            suffix = f" {len(config[field]) + 1}"
            config[field].append(item + suffix)
        else:
            config[field].append(item)
    return True


def validate_and_fix_config(config):
    """Validate LLM-generated config. Auto-fix minor length mismatches. Return errors for unfixable issues."""
    errors = []

    # Required string fields
    str_fields = ["cruise_line", "cruise_line_short", "sample_ship_1", "sample_ship_2",
                  "sample_ship_class_1", "sample_tier_top", "sample_cabin_mid",
                  "sample_cabin_top", "loyalty_program"]
    for f in str_fields:
        if f not in config or not isinstance(config[f], str) or not config[f].strip():
            errors.append(f"Missing or empty string field: {f}")

    # Required arrays with target lengths (auto-fixable)
    array_lengths = {
        "loyalty_tiers": 5,
        "loyalty_tier_high": 2,
        "loyalty_tier_mid": 2,
        "cabin_classes": 5,
        "base_prices": 5,
        "regions": 6,
        "amenities": 15,
        "excursions": 17,
        "dining_venues": 4,
        "onboard_spending_venues": 24,
        "precruise_packages": 10,
        "precruise_categories": 10,
        "service_names": 26,
        "guest_segments": 10,
        "flight_dest_airports": 8,
        "flight_dest_cities": 8,
    }
    for field, expected_len in array_lengths.items():
        if field not in config:
            errors.append(f"Missing array field: {field}")
        elif not isinstance(config[field], list):
            errors.append(f"Field {field} should be array, got {type(config[field])}")
        elif len(config[field]) != expected_len:
            actual = len(config[field])
            if fix_array_length(config, field, expected_len):
                print(f"    Auto-fixed {field}: {actual} -> {expected_len} items")
            else:
                errors.append(f"Field {field}: expected {expected_len} items, got {actual} (unfixable)")

    # Ships: target 10, each with name/class/capacity
    if "ships" not in config:
        errors.append("Missing ships array")
    elif not isinstance(config["ships"], list):
        errors.append("ships should be an array")
    else:
        # Fix ship structure first
        valid_ships = []
        for ship in config["ships"]:
            if isinstance(ship, dict) and all(k in ship for k in ("name", "class", "capacity")):
                valid_ships.append(ship)
        config["ships"] = valid_ships
        # Pad or trim to 10
        if len(config["ships"]) == 0:
            errors.append("No valid ships found")
        elif len(config["ships"]) != 10:
            actual = len(config["ships"])
            if len(config["ships"]) > 10:
                config["ships"] = config["ships"][:10]
            else:
                while len(config["ships"]) < 10:
                    template = config["ships"][len(config["ships"]) % actual]
                    config["ships"].append({
                        "name": template["name"] + f" {len(config['ships']) + 1}",
                        "class": template["class"],
                        "capacity": template["capacity"]
                    })
            print(f"    Auto-fixed ships: {actual} -> 10 items")

    # Ports: target 16, each with port/airport
    if "ports" not in config:
        errors.append("Missing ports array")
    elif not isinstance(config["ports"], list):
        errors.append("ports should be an array")
    else:
        valid_ports = []
        for port in config["ports"]:
            if isinstance(port, dict) and all(k in port for k in ("port", "airport")):
                valid_ports.append(port)
        config["ports"] = valid_ports
        if len(config["ports"]) == 0:
            errors.append("No valid ports found")
        elif len(config["ports"]) != 16:
            actual = len(config["ports"])
            if len(config["ports"]) > 16:
                config["ports"] = config["ports"][:16]
            else:
                # Pad with generic US cruise ports
                filler_ports = [
                    {"port": "Baltimore", "airport": "BWI"},
                    {"port": "San Diego", "airport": "SAN"},
                    {"port": "Honolulu", "airport": "HNL"},
                    {"port": "Charleston", "airport": "CHS"},
                    {"port": "Mobile", "airport": "MOB"},
                    {"port": "Norfolk", "airport": "ORF"},
                    {"port": "Portland", "airport": "PDX"},
                    {"port": "Savannah", "airport": "SAV"},
                ]
                existing_ports = {p["port"] for p in config["ports"]}
                for fp in filler_ports:
                    if len(config["ports"]) >= 16:
                        break
                    if fp["port"] not in existing_ports:
                        config["ports"].append(fp)
            print(f"    Auto-fixed ports: {actual} -> {len(config['ports'])} items")

    # base_prices should be ascending numbers
    if "base_prices" in config and isinstance(config["base_prices"], list):
        prices = config["base_prices"]
        if all(isinstance(p, (int, float)) for p in prices):
            if prices != sorted(prices):
                config["base_prices"] = sorted(prices)
                print(f"    Auto-fixed base_prices: sorted ascending")

    return errors


def build_derived_fields(config, profile_name):
    """Add computed/derived fields to the config."""
    short = config.get("cruise_line_short", profile_name.upper())

    config["profile_name"] = profile_name
    config["database_name"] = f"{short}_YIELD_OPTIMIZATION"
    config["warehouse_name"] = f"{short}_ANALYTICS_WH"
    config["warehouse_comment"] = f"Warehouse for {short} yield analytics"
    config["solution_title"] = f"{short} Yield Optimization"
    config["agent_prefix"] = short

    # Merge static values
    for key, value in STATIC_VALUES.items():
        config[key] = value

    # Ensure base_prices are integers
    if "base_prices" in config:
        config["base_prices"] = [int(p) for p in config["base_prices"]]

    # Ensure ship capacities are integers
    if "ships" in config:
        for ship in config["ships"]:
            if "capacity" in ship:
                ship["capacity"] = int(ship["capacity"])

    return config


def generate_config(profile_name, connection="default"):
    """Generate a cruise line config using Cortex AI."""
    output_path = os.path.join(CONFIG_DIR, f"{profile_name}.json")

    if os.path.exists(output_path):
        print(f"Config already exists: {output_path}")
        return True

    print(f"Generating config for '{profile_name}' using Snowflake Cortex AI...")
    print()

    prompt = build_prompt(profile_name)
    max_retries = 2

    for attempt in range(1, max_retries + 1):
        print(f"  Attempt {attempt}/{max_retries}: Calling Cortex COMPLETE...")

        raw_response = call_cortex(prompt, connection)
        if not raw_response:
            print(f"  No response from Cortex.")
            continue

        config = extract_json(raw_response)
        if not config:
            print(f"  Could not parse JSON from response.")
            if attempt < max_retries:
                print(f"  Retrying...")
            continue

        # Validate
        errors = validate_and_fix_config(config)
        if errors:
            print(f"  Validation errors ({len(errors)}):")
            for e in errors[:5]:
                print(f"    - {e}")
            if attempt < max_retries:
                print(f"  Retrying...")
            continue

        # Add derived fields
        config = build_derived_fields(config, profile_name)

        # Write config
        os.makedirs(CONFIG_DIR, exist_ok=True)
        with open(output_path, "w") as f:
            json.dump(config, f, indent=2)
            f.write("\n")

        print()
        print(f"  Config generated successfully!")
        print(f"  Cruise line:     {config['cruise_line']}")
        print(f"  Short code:      {config['cruise_line_short']}")
        print(f"  Database:        {config['database_name']}")
        print(f"  Loyalty program: {config['loyalty_program']}")
        print(f"  Ships:           {', '.join(s['name'] for s in config['ships'][:3])}...")
        print(f"  Saved to:        {output_path}")
        return True

    print()
    print(f"Failed to generate valid config after {max_retries} attempts.")
    print(f"You can create config/{profile_name}.json manually using config/cruise.json as a template.")
    return False


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python generate_config.py <profile_name> [connection]")
        print()
        print("Examples:")
        print("  python generate_config.py carnival")
        print("  python generate_config.py disney SS_CURSOR")
        print("  python generate_config.py msc")
        sys.exit(1)

    profile = sys.argv[1]
    conn = sys.argv[2] if len(sys.argv) > 2 else "default"

    success = generate_config(profile, conn)
    sys.exit(0 if success else 1)
