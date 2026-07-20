#!/usr/bin/env python3
"""Milestone 2B-17 content curation: 50 laws, 50 endings, 24 palace upgrades + remaps."""
from __future__ import annotations

import json
import re
from copy import deepcopy
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
LAWS_PATH = ROOT / "data/laws/laws.json"
ENDINGS_PATH = ROOT / "data/endings/endings.json"
PALACE_PATH = ROOT / "data/meta/palace_upgrades.json"
VISUAL_PATH = ROOT / "data/visual_states/country_visual_map.json"
COUNTRY_PATH = ROOT / "data/countries/ministan.json"

# Canonical 50 laws: (id, display_name, short_name, description, category, icon, visual_tags)
CANONICAL_LAWS = [
    # Economy 8
    ("window_tax", "Window Tax", "Window Tax", "Every window is taxed. Bricks are suddenly fashionable.", "economy", "🧱", ["bricked_windows"]),
    ("umbrella_tax", "Umbrella Tax", "Umbrella Tax", "Rain is free. Staying dry is a civic luxury fee.", "economy", "☂️", ["rain_bucket_protests"]),
    ("free_pizza_friday", "Free Pizza Friday", "Free Pizza", "Citizens receive free pizza every Friday. Nobody knows who pays.", "economy", "🍕", ["pizza_stalls"]),
    ("coupon_salaries", "Coupon Salaries", "Coupons", "Paychecks arrive as colorful coupons redeemable at three approved kiosks.", "economy", "🎟️", ["frozen_payroll"]),
    ("luxury_chair_tax", "Luxury Chair Levy", "Chair Levy", "Any chair more comfortable than a stool owes the treasury a soft tax.", "economy", "🪑", ["taxed_chairs"]),
    ("national_lottery_budget", "National Lottery Budget", "Lottery Budget", "Critical ministries are funded by scratch tickets and hope.", "economy", "🎫", ["national_lottery"]),
    ("coin_rounding_act", "Coin Rounding Act", "Coin Rounding", "All prices round up for the state and down for morale.", "economy", "🪙", ["treasury_tip_jar"]),
    ("emergency_cheese_bonds", "Emergency Cheese Bonds", "Cheese Bonds", "National debt is refinanced in aged cheddar certificates.", "economy", "🧀", ["debt_certificates"]),
    # Public Life 8
    ("mandatory_smiling", "Mandatory Smiling", "Smiling", "Frowning in public is now a misdemeanor.", "public_life", "😁", ["smiling_citizens"]),
    ("national_bedtime", "National Bedtime", "Bedtime", "The whole country must sleep at the same reasonable hour.", "public_life", "😴", ["curtains_drawn"]),
    ("three_day_weekend", "Three-Day Weekend", "Long Weekend", "Fridays are officially for errands, naps, and mild rebellion.", "public_life", "📅", ["civic_half_day"]),
    ("national_nap_hour", "National Nap Hour", "Nap Hour", "One sacred hour of silence. Deliveries wait. Dreams do not.", "public_life", "🛎️", ["nap_grid_cots"]),
    ("national_coffee_reserve", "Free Coffee Morning", "Coffee Morning", "The state guarantees a morning cup, quality optional.", "public_life", "☕", ["coffee_kiosks"]),
    ("compliment_quota_law", "Public Compliment Quota", "Compliments", "Citizens must praise someone daily or file a compliment waiver.", "public_life", "💬", ["compliment_meters"]),
    ("universal_birthday", "Universal Birthday", "Universal Birthday", "Everyone shares one national birthday cake and one shared candle budget.", "public_life", "🎂", ["birthday_banners"]),
    ("queue_etiquette_law", "Official Queue Etiquette", "Queue Etiquette", "Line-cutting is treason-adjacent. Numbered tickets are sacred.", "public_life", "🔢", ["numbered_queues"]),
    # Order / Military 6
    ("tank_traffic_control", "Tank Traffic Control", "Tank Traffic", "Tanks direct traffic at every major intersection.", "order_military", "🪖", ["traffic_tanks"]),
    ("mandatory_marching", "Mandatory Marching", "Marching", "Citizens practice ceremonial marching between errands.", "order_military", "🥁", ["parade_columns"]),
    ("pigeon_air_force", "Pigeon Air Force", "Pigeon AF", "Messenger pigeons receive ranks, hats, and a tiny air base.", "order_military", "🕊️", ["pigeon_mail_coops"]),
    ("palace_curfew_act", "Palace Curfew", "Curfew", "After dark, the palace gates negotiate with everyone.", "order_military", "🚪", ["palace_curfew_gates"]),
    ("border_parade_act", "Border Parade Act", "Border Parade", "Borders are secured primarily by synchronized marching bands.", "order_military", "🎖️", ["border_parade"]),
    ("emergency_salute_law", "Emergency Salute Protocol", "Salute Protocol", "A noon salute is mandatory, even if you are holding soup.", "order_military", "🫡", ["loyal_salute_plaza"]),
    # Media 6
    ("ministry_of_memes", "Ministry of Memes", "Memes", "Official humor is centralized, stamped, and slightly delayed.", "media", "📱", ["catchphrase_billboards"]),
    ("weather_optimism_act", "Weather Optimism Act", "Weather Optimism", "Forecasts may only use cheerful cloud vocabulary.", "media", "☀️", ["sunny_bulletin_boards"]),
    ("mandatory_applause", "Mandatory Applause", "Applause", "Speeches pause until the clap quota is met.", "media", "👏", ["statistics_parade_floats"]),
    ("one_headline_policy", "One Headline Policy", "One Headline", "The nation gets one approved headline per day. Choose wisely.", "media", "📰", ["single_headline_boards"]),
    ("public_rumor_license", "Public Rumor License", "Rumor License", "Gossip requires a permit, a stamp, and a plausible deniability clause.", "media", "🤫", ["rumor_license_kiosks"]),
    ("national_reality_show", "National Reality Show", "Reality Show", "Governance is filmed live with audience voting between naps.", "media", "📺", ["variety_hour_stage"]),
    # Science 6
    ("artificial_sun_program", "Artificial Sun Program", "Artificial Sun", "A backup sun is under construction behind the ministry.", "science", "🔆", ["labcoat_streetlights"]),
    ("robot_civil_service", "Robot Civil Service", "Robot Clerks", "Filing robots stamp forms faster than regret.", "science", "🤖", ["scooter_prototype_fleet"]),
    ("antigravity_transit", "Anti-Gravity Transit", "Antigravity", "Buses float. Sometimes on purpose.", "science", "🚌", ["palace_buses"]),
    ("moon_replacement_research", "Moon Replacement Research", "Moon Research", "Scientists study whether a spare moon would improve weekends.", "science", "🌙", ["cloud_shape_lab"]),
    ("clone_holiday", "Clone Holiday", "Clone Day", "One day a year, clones handle your appointments and your guilt.", "science", "🧬", ["clinic_maybe_tent"]),
    ("ai_cabinet_pilot", "AI Cabinet Pilot", "AI Cabinet", "An experimental AI sits in cabinet and refuses to blink.", "science", "🖥️", ["toaster_filing_cabinets"]),
    # Business 5
    ("privatize_air", "Privatize Air", "Privatize Air", "Breathing zones are leased to the highest polite bidder.", "business", "💨", ["privatized_garden"]),
    ("corporate_capital_naming", "Corporate Capital Naming", "Capital Naming", "Squares, bridges, and benches now have sponsor surnames.", "business", "🏷️", ["sponsored_square_signs"]),
    ("sponsored_potholes_act", "Sponsored Potholes", "Sponsored Potholes", "Each pothole displays a logo until it is filled, which is never.", "business", "🕳️", ["sponsored_potholes"]),
    ("rent_a_ministry", "Rent-a-Ministry", "Rent-a-Ministry", "Ministries can be leased for corporate retreats and mild policy.", "business", "🏢", ["service_tier_kiosks"]),
    ("palace_subscription_plan", "Palace Subscription Plan", "Palace Sub", "Citizens unlock palace rooms via monthly loyalty tiers.", "business", "🔑", ["palace_tour_rooms"]),
    # Bureaucracy 5
    ("form_request_form_act", "Form Request Form Act", "Form Forms", "To request a form, first complete the form that requests forms.", "bureaucracy", "📄", ["ministry_of_forms"]),
    ("ministry_of_waiting", "Ministry of Waiting", "Waiting", "Waiting is now an official service with numbered chairs.", "bureaucracy", "⏳", ["numbered_queues"]),
    ("triple_stamp_requirement", "Triple Stamp Requirement", "Triple Stamp", "Nothing is real until it has three stamps and a sigh.", "bureaucracy", "📮", ["cabinet_briefing_stack"]),
    ("complaint_permit_act", "Permit for Complaints", "Complaint Permit", "You may complain only after purchasing permission to complain.", "bureaucracy", "🗣️", ["complaint_permit_desk"]),
    ("national_filing_week", "National Filing Week", "Filing Week", "One week where every drawer must confess its contents.", "bureaucracy", "🗂️", ["ministry_of_forms"]),
    # Cats / Animals 6
    ("cat_voting_rights", "Cat Voting Rights", "Cat Voting", "Cats may vote. Turnout depends on napping schedules.", "cats_animals", "🐱", ["cats_in_square"]),
    ("fish_market_subsidy_act", "Fish Subsidy", "Fish Subsidy", "The state subsidizes fish so diplomacy tastes better.", "cats_animals", "🐟", ["fish_treaty"]),
    ("antivacuum_act", "Anti-Vacuum Act", "Anti-Vacuum", "Vacuum cleaners are restricted near official nap zones.", "cats_animals", "🚫", ["plaza_cat_baskets"]),
    ("cat_parliament_seats", "Cat Parliament Seats", "Cat Seats", "Reserved cushions in parliament for feline observers.", "cats_animals", "🪑", ["plaza_cat_baskets"]),
    ("mouse_protection_law", "National Mouse Protection", "Mouse Protection", "Mice receive permits, tiny hats, and occasional amnesty.", "cats_animals", "🐭", ["mouse_permit_booths"]),
    ("official_nap_zones", "Official Nap Zones", "Nap Zones", "Designated civic cushions where ambition must whisper.", "cats_animals", "🛏️", ["nap_grid_cots"]),
]

CANONICAL_IDS = {row[0] for row in CANONICAL_LAWS}

# Remap cut / alias laws → canonical
LAW_REMAP = {
    "luxury_chair_levy": "luxury_chair_tax",
    "free_coffee_morning": "national_coffee_reserve",
    "public_compliment_quota": "compliment_quota_law",
    "official_queue_etiquette": "queue_etiquette_law",
    "palace_curfew": "palace_curfew_act",
    "emergency_salute_protocol": "emergency_salute_law",
    "anti_gravity_transit": "antigravity_transit",
    "sponsored_potholes": "sponsored_potholes_act",
    "permit_for_complaints": "complaint_permit_act",
    "fish_subsidy": "fish_market_subsidy_act",
    "anti_vacuum_act": "antivacuum_act",
    "national_mouse_protection": "mouse_protection_law",
    "fish_emergency_reserve": "fish_market_subsidy_act",
    "official_palace_pet_act": "cat_voting_rights",
    "cat_cushion_charter": "official_nap_zones",
    "cat_lobby_registry": "cat_parliament_seats",
    "no_weekends": "three_day_weekend",
    "fake_smile_standard": "mandatory_smiling",
    "national_smile_day_act": "mandatory_smiling",
    "national_clock_law": "national_bedtime",
    "emergency_broadcast_priority": "one_headline_policy",
    "festival_stimulus_act": "free_pizza_friday",
    "permanent_festival_act": "free_pizza_friday",
    "palace_public_tour_act": "palace_subscription_plan",
    "soup_line_permit": "free_pizza_friday",
    "block_captain_charter": "queue_etiquette_law",
    "civic_half_day_act": "three_day_weekend",
    "emergency_martial_law": "palace_curfew_act",
    "rival_parade_response_act": "border_parade_act",
    "ceremonial_tank_florist_act": "tank_traffic_control",
    "traffic_flag_corps_act": "tank_traffic_control",
    "camouflage_uniform_act": "mandatory_marching",
    "military_route_priority_act": "tank_traffic_control",
    "traffic_checkpoint_act": "tank_traffic_control",
    "temporary_parade_pause": "border_parade_act",
    "flag_traffic_law": "tank_traffic_control",
    "national_happiness_index": "mandatory_applause",
    "weather_censorship_act": "weather_optimism_act",
    "catchphrase_registry_act": "ministry_of_memes",
    "controlled_audit_broadcast": "one_headline_policy",
    "scientific_experiment_permit": "artificial_sun_program",
    "predictive_toaster_act": "ai_cabinet_pilot",
    "labcoat_lighting_act": "artificial_sun_program",
    "national_trial_oversight_act": "clone_holiday",
    "capital_square_naming_act": "corporate_capital_naming",
    "citizen_service_subscription_act": "palace_subscription_plan",
    "palace_tour_act": "palace_subscription_plan",
    "anthem_sponsor_act": "privatize_air",
    "bench_subscription_act": "palace_subscription_plan",
    "palace_gift_shop_act": "palace_subscription_plan",
    "elite_seating_protocol": "luxury_chair_tax",
    "prestige_fountain_act": "sponsored_potholes_act",
    "title_lottery_edict": "national_lottery_budget",
    "cabinet_briefing_protocol": "form_request_form_act",
    "contradictory_signage_law": "triple_stamp_requirement",
    "emergency_efficiency_act": "ministry_of_waiting",
    "notarized_apology_act": "complaint_permit_act",
    "administrative_reform_act": "form_request_form_act",
    "form_sovereignty_act": "form_request_form_act",
    "emergency_stamp_tax": "triple_stamp_requirement",
    "emergency_queue_charter": "ministry_of_waiting",
    "cabinet_nameplate_act": "national_filing_week",
    "quiet_hours_charter": "national_filing_week",
    "fish_currency_act": "coin_rounding_act",
    "emergency_austerity_act": "coupon_salaries",
    "public_service_sunset_act": "privatize_air",
    "emergency_price_board_act": "coin_rounding_act",
    "barter_license_act": "coin_rounding_act",
    "cheese_substitute_act": "emergency_cheese_bonds",
    "bank_handshake_clause": "emergency_cheese_bonds",
    "scent_mask_act": "sponsored_potholes_act",
}

# Contradiction pairs (law A blocks decisions requiring B and vice versa via blocked_laws patches)
CONTRADICTIONS = [
    ("free_pizza_friday", "coupon_salaries"),
    ("mandatory_smiling", "national_bedtime"),
    ("three_day_weekend", "national_filing_week"),
    ("national_nap_hour", "mandatory_marching"),
    ("tank_traffic_control", "antigravity_transit"),
    ("pigeon_air_force", "privatize_air"),
    ("palace_curfew_act", "palace_subscription_plan"),
    ("weather_optimism_act", "public_rumor_license"),
    ("one_headline_policy", "national_reality_show"),
    ("artificial_sun_program", "moon_replacement_research"),
    ("robot_civil_service", "form_request_form_act"),
    ("cat_voting_rights", "mouse_protection_law"),
    ("antivacuum_act", "official_nap_zones"),  # actually synergistic - use different pair
    ("complaint_permit_act", "ministry_of_memes"),
    ("window_tax", "corporate_capital_naming"),
    ("umbrella_tax", "weather_optimism_act"),
]

# Fix last contradictory pair to something real
CONTRADICTIONS[-3] = ("antivacuum_act", "privatize_air")

# Decisions that should gain law gates for interaction density (id -> patch)
# Applied as soft any_laws additions if decision exists.
INTERACTION_SEEDS: dict[str, dict] = {
    # Ensure each canonical law appears in ≥2 decision requirement lists
}


def remap_law_id(lid: str) -> str:
    if lid in CANONICAL_IDS:
        return lid
    if lid in LAW_REMAP:
        return LAW_REMAP[lid]
    # fallback: keep if somehow canonical
    return LAW_REMAP.get(lid, lid)


def rewrite_law_refs_in_obj(obj):
    """Recursively remap law id strings in known law-array keys."""
    if isinstance(obj, list):
        return [rewrite_law_refs_in_obj(x) for x in obj]
    if not isinstance(obj, dict):
        return obj
    out = {}
    for k, v in obj.items():
        if k in ("add_laws", "remove_laws", "all_laws", "any_laws", "blocked_laws") and isinstance(v, list):
            remapped = []
            seen = set()
            for lid in v:
                nl = remap_law_id(str(lid))
                if nl in CANONICAL_IDS and nl not in seen:
                    remapped.append(nl)
                    seen.add(nl)
            out[k] = remapped
        else:
            out[k] = rewrite_law_refs_in_obj(v)
    return out


def load_decisions() -> tuple[list[dict], list[Path]]:
    country = json.loads(COUNTRY_PATH.read_text())
    decisions = []
    paths = []
    for f in country.get("decision_files", []):
        rel = f.replace("res://", "")
        p = ROOT / rel
        if not p.exists():
            p = ROOT / "data/decisions" / Path(f).name
        if not p.exists():
            print("MISSING decision file", f)
            continue
        data = json.loads(p.read_text())
        paths.append(p)
        if isinstance(data, list):
            for d in data:
                d["_file"] = str(p)
                decisions.append(d)
        elif isinstance(data, dict) and "decisions" in data:
            for d in data["decisions"]:
                d["_file"] = str(p)
                decisions.append(d)
    return decisions, paths


def write_decisions_by_file(decisions: list[dict]) -> None:
    by_file: dict[str, list] = {}
    for d in decisions:
        f = d.pop("_file", None)
        if not f:
            continue
        by_file.setdefault(f, []).append(d)
    for f, items in by_file.items():
        Path(f).write_text(json.dumps(items, indent=2, ensure_ascii=False) + "\n")


def ensure_visual_tags(visual: dict) -> dict:
    extras = {
        "civic_half_day": "🏖️",
        "cat_parliament_cushions": "🐱",
        "universal_birthday_cake": "🎂",
        "official_nap_cushions": "🛏️",
    }
    for k, v in extras.items():
        visual.setdefault(k, v)
    # Fix universal_birthday and official_nap_zones tags if needed
    return visual


def build_laws() -> list[dict]:
    laws = []
    for row in CANONICAL_LAWS:
        lid, name, short, desc, cat, icon, tags = row
        # tweak tags for new laws
        if lid == "universal_birthday":
            tags = ["birthday_banners"]
        if lid == "cat_parliament_seats":
            tags = ["plaza_cat_baskets"]
        if lid == "official_nap_zones":
            tags = ["nap_grid_cots"]
        if lid == "three_day_weekend":
            tags = ["civic_half_day"] if False else ["broom_brigades"]
        laws.append({
            "id": lid,
            "display_name": name,
            "short_name": short,
            "description": desc,
            "category": cat,
            "placeholder_icon": icon,
            "visual_tags": tags,
            "icon_key": f"law_{lid}",
        })
    return laws


def patch_decision_interactions(decisions: list[dict]) -> None:
    """Ensure every law unlocks/blocks ≥2 decisions; add contradictions; delayed flags via existing cards."""
    # Index decisions by id
    by_id = {d["id"]: d for d in decisions if "id" in d}

    # Seed gates: map law -> list of decision ids to add any_laws
    # Prefer decisions that already add the law or thematically match
    law_to_adders: dict[str, list[str]] = {lid: [] for lid in CANONICAL_IDS}
    for d in decisions:
        did = d.get("id", "")
        for opt in d.get("options") or []:
            if not isinstance(opt, dict):
                continue
            for lid in opt.get("add_laws") or []:
                if lid in law_to_adders:
                    law_to_adders[lid].append(did)

    # Find candidate follow-up decisions (same advisor / tags) to gate on law
    # Strategy: for each law, find 2 decisions that don't already require it and add any_laws
    for d in decisions:
        req = d.setdefault("requirements", {})
        if not isinstance(req, dict):
            d["requirements"] = {}
            req = d["requirements"]

    # Build list of decisions with soft stage that can take law gates
    soft_targets = [d for d in decisions if d.get("card_type") in (None, "standard", "standalone", "follow_up", "arc", "crisis", "recovery", "endgame") or True]

    # Count current gates
    def gate_count(lid: str) -> int:
        n = 0
        for d in decisions:
            req = d.get("requirements") or {}
            if lid in (req.get("all_laws") or []) or lid in (req.get("any_laws") or []) or lid in (req.get("blocked_laws") or []):
                n += 1
        return n

    # For each law with <2 gates, attach to decisions that add it or nearby themed ones
    themed_keywords = {
        "window_tax": ["window", "tax", "brick"],
        "umbrella_tax": ["umbrella", "rain"],
        "free_pizza_friday": ["pizza", "festival", "food"],
        "coupon_salaries": ["salary", "coupon", "wage", "austerity"],
        "luxury_chair_tax": ["chair", "seat", "elite"],
        "national_lottery_budget": ["lottery", "ticket"],
        "coin_rounding_act": ["coin", "price", "barter", "currency"],
        "emergency_cheese_bonds": ["cheese", "bond", "debt"],
        "mandatory_smiling": ["smile", "happy"],
        "national_bedtime": ["bedtime", "sleep", "clock"],
        "three_day_weekend": ["weekend", "half_day", "friday"],
        "national_nap_hour": ["nap"],
        "national_coffee_reserve": ["coffee"],
        "compliment_quota_law": ["compliment"],
        "universal_birthday": ["birthday"],
        "queue_etiquette_law": ["queue", "line"],
        "tank_traffic_control": ["tank", "traffic"],
        "mandatory_marching": ["march"],
        "pigeon_air_force": ["pigeon"],
        "palace_curfew_act": ["curfew"],
        "border_parade_act": ["parade", "border"],
        "emergency_salute_law": ["salute"],
        "ministry_of_memes": ["meme", "catchphrase"],
        "weather_optimism_act": ["weather", "forecast"],
        "mandatory_applause": ["applause", "happiness_index"],
        "one_headline_policy": ["headline", "broadcast"],
        "public_rumor_license": ["rumor"],
        "national_reality_show": ["reality", "show"],
        "artificial_sun_program": ["sun", "labcoat", "light"],
        "robot_civil_service": ["robot"],
        "antigravity_transit": ["antigravity", "transit", "bus"],
        "moon_replacement_research": ["moon"],
        "clone_holiday": ["clone"],
        "ai_cabinet_pilot": ["ai_cabinet", "toaster", "ai "],
        "privatize_air": ["privatize", "air", "sponsor"],
        "corporate_capital_naming": ["naming", "capital_square", "sponsor"],
        "sponsored_potholes_act": ["pothole"],
        "rent_a_ministry": ["rent", "ministry"],
        "palace_subscription_plan": ["subscription", "palace_tour", "gift_shop"],
        "form_request_form_act": ["form", "briefing"],
        "ministry_of_waiting": ["waiting", "queue"],
        "triple_stamp_requirement": ["stamp", "signage"],
        "complaint_permit_act": ["complaint"],
        "national_filing_week": ["filing", "nameplate"],
        "cat_voting_rights": ["cat", "whiskers", "pet"],
        "fish_market_subsidy_act": ["fish"],
        "antivacuum_act": ["vacuum"],
        "cat_parliament_seats": ["parliament", "cat"],
        "mouse_protection_law": ["mouse"],
        "official_nap_zones": ["nap", "cushion"],
    }

    for lid in CANONICAL_IDS:
        while gate_count(lid) < 2:
            # Prefer decisions that add this law - gate a different follow-up
            candidates = []
            keys = themed_keywords.get(lid, [lid.replace("_", " ")])
            for d in decisions:
                did = d.get("id", "")
                req = d.get("requirements") or {}
                if lid in (req.get("all_laws") or []) or lid in (req.get("any_laws") or []):
                    continue
                blob = (did + " " + str(d.get("proposal", "")) + " " + str(d.get("tags", []))).lower()
                if any(k.lower() in blob for k in keys):
                    candidates.append(d)
            # Also use adders' "neighbors" - any decision with used_decisions pointing? Skip.
            if not candidates:
                # pick any decision that adds the law and add blocked/any to a recovery/endgame card
                for d in decisions:
                    req = d.get("requirements") or {}
                    if lid in (req.get("all_laws") or []) or lid in (req.get("any_laws") or []):
                        continue
                    # skip onboarding day 1-3 strictly?
                    if int((req or {}).get("maximum_day", 999) or 999) <= 3:
                        continue
                    candidates.append(d)
                    if len(candidates) >= 5:
                        break
            if not candidates:
                print("WARN: cannot gate law", lid)
                break
            target = candidates[0]
            req = target.setdefault("requirements", {})
            any_laws = list(req.get("any_laws") or [])
            if lid not in any_laws:
                any_laws.append(lid)
            req["any_laws"] = any_laws
            # If still stuck in loop because same candidate, force progress by also trying all_laws on second
            if gate_count(lid) < 2 and len(candidates) > 1:
                target2 = candidates[1]
                req2 = target2.setdefault("requirements", {})
                any2 = list(req2.get("any_laws") or [])
                if lid not in any2:
                    any2.append(lid)
                req2["any_laws"] = any2

    # Apply contradictions: for each pair, ensure some decision requiring A is blocked by B
    for a, b in CONTRADICTIONS:
        # Find a decision that requires a via any/all and add blocked_laws b
        patched = False
        for d in decisions:
            req = d.get("requirements") or {}
            laws = (req.get("all_laws") or []) + (req.get("any_laws") or [])
            if a in laws:
                blocked = list(req.get("blocked_laws") or [])
                if b not in blocked:
                    blocked.append(b)
                req["blocked_laws"] = blocked
                d["requirements"] = req
                patched = True
                break
        if not patched:
            # create synthetic gate on an endgame civic card if present
            for prefer in ("endgame_civic_stack_verdict", "endgame_boom_olga_ceasefire", "contradictory_signage_act"):
                if prefer in by_id:
                    d = by_id[prefer]
                    req = d.setdefault("requirements", {})
                    any_l = list(req.get("any_laws") or [])
                    if a not in any_l:
                        any_l.append(a)
                    req["any_laws"] = any_l
                    blocked = list(req.get("blocked_laws") or [])
                    if b not in blocked:
                        blocked.append(b)
                    req["blocked_laws"] = blocked
                    patched = True
                    break

    # Ensure new laws have add_laws somewhere: attach to thematically related option if never added
    add_counts = {lid: 0 for lid in CANONICAL_IDS}
    for d in decisions:
        for opt in d.get("options") or []:
            if isinstance(opt, dict):
                for lid in opt.get("add_laws") or []:
                    if lid in add_counts:
                        add_counts[lid] += 1

    # Hook new laws onto existing decisions
    new_hooks = {
        "universal_birthday": "national_biscuit_ipo",  # fallback search
        "cat_parliament_seats": "public_cat_baskets",
        "official_nap_zones": "national_nap_hour",
    }
    # Search by keyword for birthday / cat parliament / nap zones
    for lid, hint in [
        ("universal_birthday", "birthday"),
        ("cat_parliament_seats", "cat"),
        ("official_nap_zones", "nap"),
    ]:
        if add_counts.get(lid, 0) > 0:
            continue
        for d in decisions:
            blob = (d.get("id", "") + str(d.get("proposal", ""))).lower()
            if hint not in blob:
                continue
            opts = d.get("options") or []
            if not opts or not isinstance(opts[0], dict):
                continue
            adds = list(opts[0].get("add_laws") or [])
            if lid not in adds:
                adds.append(lid)
            opts[0]["add_laws"] = adds
            add_counts[lid] += 1
            break
        # If still not added, attach to a safe standalone
        if add_counts.get(lid, 0) == 0:
            for d in decisions:
                if d.get("id") in ("working_palace_tours", "public_cat_baskets", "national_nap_hour", "queue_priority_auction", "official_palace_pet"):
                    opts = d.get("options") or []
                    if opts and isinstance(opts[0], dict):
                        adds = list(opts[0].get("add_laws") or [])
                        if lid not in adds:
                            adds.append(lid)
                        opts[0]["add_laws"] = adds
                        add_counts[lid] += 1
                        break



def build_endings(old_endings: list[dict]) -> tuple[list[dict], dict]:
    """Curate to 50 collectible endings with rarity distribution 12/18/14/6."""
    by_id = {e["id"]: e for e in old_endings}

    rejected = {
        "survived_the_prototype": "Rejected from collectible 50 — survival runtime only.",
        "content_exhausted": "Rejected from collectible 50 — fallback only.",
        "nation_in_darkness": "Deferred — crisis explicit trigger; weak archive setup.",
        "everyone_moves_next_door": "Rejected PRD secret — no narrative setup.",
        "the_accidental_libertarian": "Rejected PRD ruler-identity ending — identity not authored.",
        "the_parade_philosopher": "Rejected PRD candidate — overlaps tank/parade endings.",
        "the_minister_of_everything": "Rejected PRD candidate — overlaps bureaucratic endings.",
        "economic_miracle": "Rejected PRD candidate — overlaps country_somehow_works.",
        "luna_news_immortal": "Rejected PRD advisor ending — covered by media endings.",
        "doctor_maybe_definitely": "Deferred PRD advisor ending — covered by scientific_golden_age.",
        "the_chaotic_reformer_ending": "Deferred with ruler identity gap.",
        "the_sponsored_supreme_leader": "Deferred — covered by corporate_ministan.",
        "the_bureaucratic_oracle": "Deferred — covered by spreadsheet/clerk endings.",
        "the_last_honest_propagandist": "Rejected — overlaps Luna/broadcast paths.",
        "the_peoples_favorite_problem": "Deferred PRD identity ending.",
    }

    common = [
        "bankrupt_leader", "revolution", "chaos_country", "elite_coup",
        "beloved_retirement", "country_somehow_works", "peaceful_accidental_democracy",
        "general_remains_loyal", "olga_sends_you_home", "clerk_zero_closes_file",
        "penny_balances_final_budget", "profit_buys_retirement",
    ]
    uncommon = [
        "spreadsheet_state", "austerity_without_citizens", "nation_becomes_broadcast",
        "olga_peoples_cabinet", "palace_hears_the_street", "experimental_republic",
        "experiment_leaves", "corporate_ministan", "country_is_acquired",
        "purrfect_transfer", "government_by_form", "final_stamp",
        "happiness_reaches_100_percent", "tanks_direct_everything", "general_becomes_mascot",
        "hyperinflation_millionaires", "great_cheese_settlement", "eternal_national_festival",
    ]
    rare = [
        "general_boom_coup", "scientific_golden_age", "ai_accepts_resignation",
        "moon_new_owner", "democracy_by_administrative_error", "palace_beautiful_empty",
        "renovation_reveals_truth", "smiling_tyrant_soft_exit", "smallest_superpower",
        "traffic_system_achieves_peace", "day_everyone_stopped_believing",
        "eternal_smile_state", "competent_successor", "whiskers_boxes_truce",
    ]
    secret = [
        "toaster_elected_president", "wrong_map_republic", "palace_micronation",
        "forms_become_citizens", "cat_republic", "accidental_moon_replacement",
    ]

    assert len(common) == 12 and len(uncommon) == 18 and len(rare) == 14 and len(secret) == 6
    all_ids = common + uncommon + rare + secret
    assert len(all_ids) == 50 and len(set(all_ids)) == 50

    rarity_map = {}
    for group, rarity in ((common, "common"), (uncommon, "uncommon"), (rare, "rare"), (secret, "secret")):
        for eid in group:
            rarity_map[eid] = rarity

    default_hints = {
        "bankrupt_leader": "Empty the treasury and meet your creditors.",
        "revolution": "Let happiness collapse completely.",
        "chaos_country": "Let order fall to zero.",
        "elite_coup": "Lose the loyalty of the elite.",
        "beloved_retirement": "Earn a gentle farewell after a long, kind rule.",
        "country_somehow_works": "Keep every plate spinning until the credits.",
        "peaceful_accidental_democracy": "Misplace power so politely that democracy appears.",
        "general_remains_loyal": "Keep General Boom proudly on your side.",
        "olga_sends_you_home": "Let Auntie Olga decide you need a nap at home.",
        "clerk_zero_closes_file": "Allow Clerk Zero to file you under Closed.",
        "penny_balances_final_budget": "Help Minister Penny balance the impossible ledger.",
        "profit_buys_retirement": "Accept Sir Profit's luxurious exit package.",
        "toaster_elected_president": "Listen when kitchen appliances demand suffrage.",
        "wrong_map_republic": "Follow the ambassador's map one border too far.",
        "palace_micronation": "Shrink the country until only the palace remains.",
        "forms_become_citizens": "Grant paperwork the rights of people.",
        "cat_republic": "Hand the constitution to the cats.",
        "accidental_moon_replacement": "Replace the moon by accident and keep a straight face.",
    }

    new_endings = []
    for eid, rarity in rarity_map.items():
        if eid not in by_id:
            raise SystemExit(f"Missing ending id in data: {eid}")
        e = deepcopy(by_id[eid])
        e = rewrite_law_refs_in_obj(e)
        e["rarity"] = rarity
        e["subtitle"] = e.get("subtitle") or e.get("title", eid)
        e["archive_hint"] = default_hints.get(eid, f"Discover a path to '{e.get('title', eid)}'.")
        e["illustration_key"] = e.get("illustration_key") or f"ending_{eid}"
        e["collectible"] = True
        e["newspaper_headline"] = e.get("newspaper_headline") or e.get("title")
        new_endings.append(e)

    # Runtime system endings (not in collectible 50)
    for eid in ("survived_the_prototype", "content_exhausted", "nation_in_darkness"):
        if eid in by_id:
            e = deepcopy(by_id[eid])
            e["collectible"] = False
            e["archive_hint"] = "System or deferred ending — outside the collectible archive quota."
            e["illustration_key"] = e.get("illustration_key") or f"ending_{eid}"
            e["subtitle"] = e.get("title", eid)
            new_endings.append(e)

    meta = {
        "rejected": rejected,
        "rarity_counts": {"common": 12, "uncommon": 18, "rare": 14, "secret": 6},
        "common": common,
        "uncommon": uncommon,
        "rare": rare,
        "secret": secret,
    }
    return new_endings, meta


def build_palace() -> list[dict]:
    upgrades = [
        # Throne room 6
        ("gold_desk", "Gold Desk", "A desk so shiny that ministers forget their talking points.", "throne_room", 5, {}, "🪑",
         {"type": "visual_palace_state", "ids": ["palace_gold_desk"]}),
        ("velvet_throne", "Velvet Throne", "Slightly taller than necessary. Excellent for dramatic pauses.", "throne_room", 12, {"minimum_total_runs": 2}, "👑",
         {"type": "visual_palace_state", "ids": ["palace_velvet_throne"]}),
        ("audience_carpet", "Audience Carpet", "Citizens wipe their feet before complaining.", "throne_room", 18, {"minimum_endings_unlocked": 1}, "🟥",
         {"type": "archive_hint", "ids": ["throne_carpet_hint"]}),
        ("portrait_wall", "Portrait Wall", "Every past mood has a painting. Most look surprised.", "throne_room", 25, {"minimum_endings_unlocked": 3}, "🖼️",
         {"type": "cosmetic_ending_variant", "ids": ["portrait_frame_variant"]}),
        ("ceremonial_gavel", "Ceremonial Gavel", "Ends meetings and occasionally tables.", "throne_room", 35, {"minimum_total_runs": 5}, "🔨",
         {"type": "decision_eligibility", "ids": ["endgame_legacy_statue"]}),
        ("echo_balcony", "Echo Balcony", "Your speeches arrive twice for emphasis.", "throne_room", 45, {"minimum_medals": 20}, "🏛️",
         {"type": "visual_palace_state", "ids": ["palace_echo_balcony"]}),
        # Propaganda 4
        ("propaganda_studio", "Propaganda Studio", "Broadcast to three loyal citizens and one confused cat.", "propaganda_room", 10, {"minimum_endings_unlocked": 2}, "📺",
         {"type": "decision_eligibility", "ids": ["endgame_climax_smiling_tyrant"]}),
        ("cue_card_printer", "Cue Card Printer", "Never forget which slogan is currently mandatory.", "propaganda_room", 22, {"minimum_endings_unlocked": 4}, "🖨️",
         {"type": "content_pool", "ids": ["propaganda_soft_pool"]}),
        ("applause_track", "Applause Track", "A polite clap on demand. Volume is a policy choice.", "propaganda_room", 30, {"minimum_total_runs": 4}, "👏",
         {"type": "visual_palace_state", "ids": ["palace_applause_booth"]}),
        ("headline_carousel", "Headline Carousel", "Rotate yesterday's news until it feels new.", "propaganda_room", 40, {"minimum_endings_unlocked": 6}, "🗞️",
         {"type": "archive_hint", "ids": ["headline_carousel_hint"]}),
        # Bunker 4
        ("emergency_bunker", "Emergency Bunker", "Hide with dignity and a snack reserve.", "emergency_bunker", 15, {"minimum_total_runs": 3}, "🚪",
         {"type": "starting_modifier", "ids": ["bunker_snack_morale"]}),
        ("map_table", "Crisis Map Table", "Tiny flags mark tiny problems with huge pins.", "emergency_bunker", 28, {"minimum_total_runs": 5}, "🗺️",
         {"type": "decision_eligibility", "ids": ["endgame_boom_olga_ceasefire"]}),
        ("sealed_archive", "Sealed Archive Drawer", "Contains secrets, crumbs, and one unused apology.", "emergency_bunker", 38, {"minimum_endings_unlocked": 5}, "🗄️",
         {"type": "archive_hint", "ids": ["sealed_archive_hint"]}),
        ("red_phone", "Mostly Red Phone", "Connects to everyone who is already in the bunker.", "emergency_bunker", 50, {"minimum_medals": 30}, "☎️",
         {"type": "cosmetic_ending_variant", "ids": ["bunker_ending_frame"]}),
        # Office 4
        ("triple_intray", "Triple In-Tray", "Incoming, ongoing, and eternally pending.", "office_bureaucracy", 8, {}, "📥",
         {"type": "visual_palace_state", "ids": ["palace_intray"]}),
        ("stamp_museum", "Stamp Museum", "A gallery of approvals that changed nothing.", "office_bureaucracy", 20, {"minimum_endings_unlocked": 2}, "🔏",
         {"type": "decision_eligibility", "ids": ["endgame_secret_forms_awaken"]}),
        ("quiet_hours_lamp", "Quiet Hours Lamp", "Dims ambition by fifteen percent.", "office_bureaucracy", 32, {"minimum_total_runs": 6}, "💡",
         {"type": "starting_modifier", "ids": ["quiet_start_order"]}),
        ("form_fountain", "Form Fountain", "Decorative paperwork that occasionally files itself.", "office_bureaucracy", 48, {"minimum_endings_unlocked": 8}, "⛲",
         {"type": "content_pool", "ids": ["bureaucracy_soft_pool"]}),
        # Science 3
        ("prototype_shelf", "Prototype Shelf", "Holds inventions that almost worked and one that meows.", "science_laboratory", 16, {"minimum_total_runs": 3}, "⚗️",
         {"type": "decision_eligibility", "ids": ["endgame_scientific_golden_age"]}),
        ("moon_whiteboard", "Moon Whiteboard", "Equations, doodles, and a suspicious crater sketch.", "science_laboratory", 34, {"minimum_endings_unlocked": 4}, "📝",
         {"type": "archive_hint", "ids": ["moon_whiteboard_hint"]}),
        ("ai_coffee_bot", "AI Coffee Bot", "Predicts your caffeine needs with unsettling accuracy.", "science_laboratory", 55, {"minimum_medals": 25}, "🤖",
         {"type": "decision_eligibility", "ids": ["endgame_secret_toaster_election"]}),
        # Cat 3
        ("cushion_throne", "Cushion Throne Annex", "A second throne, lower, warmer, and politically influential.", "cat_related", 14, {"minimum_endings_unlocked": 1}, "🛏️",
         {"type": "decision_eligibility", "ids": ["endgame_climax_cat_servant"]}),
        ("fish_dispenser", "Diplomatic Fish Dispenser", "Treats for treaties. Refill weekly.", "cat_related", 26, {"minimum_total_runs": 4}, "🐟",
         {"type": "visual_palace_state", "ids": ["palace_fish_dispenser"]}),
        ("nap_observatory", "Nap Observatory", "Monitor national yawn density from the palace roof.", "cat_related", 42, {"minimum_endings_unlocked": 7}, "🔭",
         {"type": "cosmetic_ending_variant", "ids": ["nap_ending_frame"]}),
    ]

    # Fix moon_whiteboard icon
    result = []
    for row in upgrades:
        uid, name, desc, cat, cost, req, icon, unlock = row
        entry = {
            "id": uid,
            "display_name": name,
            "description": desc,
            "category": cat,
            "medal_cost": cost,
            "requirements": req,
            "placeholder_icon": icon,
            "visual_key": f"palace_{uid}",
        }
        if unlock:
            entry["content_unlock"] = unlock
        result.append(entry)
    assert len(result) == 24, len(result)
    return result


def apply_palace_gates(decisions: list[dict], palace: list[dict]) -> None:
    """Gate decision_eligibility unlocks behind required_palace_upgrades."""
    by_id = {d["id"]: d for d in decisions if "id" in d}
    for up in palace:
        unlock = up.get("content_unlock") or {}
        if unlock.get("type") != "decision_eligibility":
            continue
        for did in unlock.get("ids") or []:
            if did not in by_id:
                print("WARN palace gate missing decision", did)
                continue
            req = by_id[did].setdefault("requirements", {})
            needed = list(req.get("required_palace_upgrades") or [])
            if up["id"] not in needed:
                needed.append(up["id"])
            req["required_palace_upgrades"] = needed


def main():
    print("Building laws...")
    laws = build_laws()
    LAWS_PATH.write_text(json.dumps(laws, indent=2, ensure_ascii=False) + "\n")

    print("Loading decisions...")
    decisions, _paths = load_decisions()
    print(" decisions", len(decisions))

    print("Remapping law refs in decisions...")
    for i, d in enumerate(decisions):
        f = d.get("_file")
        decisions[i] = rewrite_law_refs_in_obj(d)
        if f:
            decisions[i]["_file"] = f

    print("Patching interactions...")
    patch_decision_interactions(decisions)

    print("Building endings...")
    old_endings = json.loads(ENDINGS_PATH.read_text())
    endings, ending_meta = build_endings(old_endings)
    ENDINGS_PATH.write_text(json.dumps(endings, indent=2, ensure_ascii=False) + "\n")

    # Remap ending trigger refs if any merged (none currently)
    for d in decisions:
        for opt in d.get("options") or []:
            if isinstance(opt, dict) and "trigger_ending" in opt:
                te = str(opt["trigger_ending"])
                if te == "cat_republic":
                    pass  # kept as secret
                if te == "accidental_moon_replacement":
                    pass

    print("Building palace...")
    palace = build_palace()
    apply_palace_gates(decisions, palace)
    PALACE_PATH.write_text(json.dumps(palace, indent=2, ensure_ascii=False) + "\n")

    print("Writing decisions...")
    write_decisions_by_file(decisions)

    print("Updating visual map...")
    visual = json.loads(VISUAL_PATH.read_text())
    visual = ensure_visual_tags(visual)
    for law in laws:
        for tag in law.get("visual_tags") or []:
            visual.setdefault(tag, law.get("placeholder_icon", "🏛️"))
    for up in palace:
        visual.setdefault(up["visual_key"], up.get("placeholder_icon", "🏛️"))
    VISUAL_PATH.write_text(json.dumps(visual, indent=2, ensure_ascii=False) + "\n")

    # Verify law gate counts
    from collections import defaultdict
    gates = defaultdict(int)
    adds = defaultdict(int)
    for d in decisions:
        req = d.get("requirements") or {}
        for lid in (req.get("all_laws") or []) + (req.get("any_laws") or []) + (req.get("blocked_laws") or []):
            gates[lid] += 1
        for opt in d.get("options") or []:
            if isinstance(opt, dict):
                for lid in opt.get("add_laws") or []:
                    adds[lid] += 1

    thin = [lid for lid in CANONICAL_IDS if gates[lid] < 2]
    never = [lid for lid in CANONICAL_IDS if adds[lid] < 1]
    print("Thin gates (<2):", len(thin), thin)
    print("Never added:", never)
    print("Ending rarity:", ending_meta["rarity_counts"])
    print("Laws:", len(laws), "Endings collectible:", sum(1 for e in endings if e.get("collectible", True)), "Palace:", len(palace))

    meta_path = ROOT / "docs/content/drafts/2B-17_curation_meta.json"
    meta_path.write_text(json.dumps({
        "ending_meta": ending_meta,
        "thin_gates": thin,
        "never_added": never,
        "law_remap": LAW_REMAP,
        "contradictions": CONTRADICTIONS,
    }, indent=2) + "\n")
    print("Wrote", meta_path)


if __name__ == "__main__":
    main()
