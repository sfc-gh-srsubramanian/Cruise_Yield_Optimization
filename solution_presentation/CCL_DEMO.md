# Carnival Cruise Line - Dynamic Yield Optimization Demo

**Database:** `CCL_YIELD_OPTIMIZATION`
**Snowflake Intelligence:** Open Snowflake Intelligence and select any CCL agent

---

## Opening Narrative

> Carnival Cruise Line is the world's most popular cruise line, operating a fleet of 10 ships across 6 ship classes -- from the groundbreaking Excel-class Mardi Gras to the beloved Conquest-class workhorses. With homeports spanning Miami, Fort Lauderdale, Galveston, New Orleans, Tampa, and Port Canaveral, Carnival carries millions of "Fun Ship" guests annually across the Caribbean, Bahamas, Mexico, Alaska, Europe, and Panama Canal.
>
> Every sailing is a perishable asset -- an empty cabin on departure day is revenue lost forever. The revenue management challenge: set the right price, for the right cabin, on the right ship, for the right guest, at the right time.
>
> Today we'll show how Carnival's revenue management team uses **Snowflake Intelligence** with purpose-built AI agents to ask natural-language questions across yield data, guest profiles, pricing funnels, and airline partner signals -- and get instant, data-driven answers they can act on.

---

## Act 1: Fleet Revenue Health (Yield Analyst)

**Agent:** `CCL Yield Analyst`
**Persona:** VP of Revenue Management

> "Every Monday, our revenue team needs a pulse on Carnival's fleet performance. Instead of opening 5 dashboards, they open Snowflake Intelligence and ask."

### Questions to Ask

**1. Top-level yield**
```
What is the net yield by region?
```
> *Net yield = revenue per available passenger cruise day. The single most important KPI in cruise revenue management. This instantly shows whether Caribbean, Bahamas, Mexico, Alaska, Europe, or Panama Canal is generating the most value.*

**2. Flagship deep dive**
```
What is the net revenue trend for Mardi Gras?
```
> *Mardi Gras is Carnival's 5,282-passenger Excel-class flagship -- the first in North America to feature a roller coaster at sea. As the fleet's largest revenue generator, tracking its trend reveals whether the anchor is holding.*

**3. Ship class comparison**
```
Which ship class has the best yield optimization?
```
> *Compares Excel, Vista, Sunshine, and Conquest classes. Reveals whether the mega-ship Mardi Gras or the high-volume Conquest-class fleet is producing better per-passenger economics.*

**4. Spotting trouble**
```
Identify underperforming sailings with low occupancy
```
> *Flags specific sailings below target. These are the "rescue" opportunities -- sailings that need price adjustments or promotional pushes before departure.*

**5. Seasonal intelligence**
```
Show me seasonal yield patterns for Caribbean cruises
```
> *Caribbean is Carnival's bread and butter. This shows whether pricing strategy is capturing the winter premium effectively while managing the softer summer shoulder season.*

### Transition

> "We've identified where yield is strong and where it's soft. Now the question is: who are the guests behind these numbers?"

---

## Act 2: Guest Intelligence (Guest Intel)

**Agent:** `CCL Guest Intel`
**Persona:** Director of Customer Analytics

> "We maintain 360-degree profiles on every guest -- their VIFP loyalty tier, lifetime value, spending habits, preferred cabin class, booking channel, and satisfaction scores. Let's explore."

### Questions to Ask

**1. Loyalty landscape**
```
What is the distribution of guests by loyalty tier?
```
> *Maps Carnival's VIFP (Very Important Fun Person) pyramid: Blue, Red, Gold, Platinum, Diamond. The shape of this pyramid drives retention strategy -- Blue members are the largest group but Diamond members drive the most revenue per sailing.*

**2. Top-tier deep dive**
```
Analyze spending patterns for Diamond members
```
> *Diamond is the top VIFP tier. These guests have the highest lifetime value, lowest price sensitivity, and strongest brand attachment. Understanding their behavior drives VIP strategy and priority boarding perks.*

**3. Value segmentation**
```
How are guests distributed across value segments?
```
> *Shows Budget Cruiser, Mainstream, Premium Seeker, Luxury Enthusiast, Adventure Seeker, Family Focused, Spa Enthusiast, Casino Patron, Wine Aficionado, and Foodie segments. Carnival's "fun for all" positioning means each segment needs a different nudge.*

**4. Cabin-loyalty link**
```
What cabin class do Diamond members prefer, and how does their conversion rate compare to other tiers?
```
> *Reveals whether Suite and Haven inventory is aligned with top-tier demand. If Diamond members want Havens but conversion is low, the price may be wrong even for price-insensitive guests.*

**5. Ancillary opportunity**
```
Which guest segments have high lifetime value but low spa/excursion attach rates?
```
> *Finds high-value guests who aren't buying Cloud 9 Spa treatments or shore excursions. Each identified segment is a personalization opportunity -- targeted pre-cruise offers for spa packages, excursion credits, or Guy's Pig & Anchor dining.*

**6. Satisfaction check**
```
Who are the top spending guests?
```
> *Lists the highest-value guests by lifetime value. In the real world, each of these would have a dedicated concierge follow-up and priority embarkation.*

### Transition

> "We know the guests. Now let's look at whether our prices are converting."

---

## Act 3: Pricing Performance (Pricing Copilot)

**Agent:** `CCL Pricing Copilot`
**Persona:** Pricing Strategy Manager

> "Every price we show is an impression. Every booking is a conversion. Our Pricing Copilot analyzes this funnel across every ship, cabin class, and region."

### Questions to Ask

**1. The conversion funnel**
```
What is the conversion rate by cabin class?
```
> *The most important pricing metric. Shows impression-to-booking conversion for Interior, Oceanview, Balcony, Suite, and Haven. If Balcony converts at 12% but Haven converts at 3%, there's a pricing gap to investigate.*

**2. Ship-specific recommendations**
```
Can you give me pricing recommendations for Mardi Gras?
```
> *Breaks down Mardi Gras pricing by cabin class with conversion rates and average prices. Generates specific recommendations: "lower by 5-10%", "competitive", or "strong -- consider premium positioning." Excel-class commands a premium but is it converting?*

**3. Price trends**
```
Show me pricing trends for Balcony cabins this quarter
```
> *Balcony is the volume cabin for Carnival. Small price changes here move millions in revenue. The trend shows whether recent adjustments are working.*

**4. Finding overpriced inventory**
```
Which itineraries are overpriced based on conversion rates?
```
> *Identifies specific routes where pricing is killing conversion. A Galveston-to-Cozumel itinerary with high impressions but low bookings is a clear signal to adjust.*

**5. Port-level performance**
```
Compare pricing performance across departure ports
```
> *Different homeports serve different markets. Miami guests may have different price sensitivity than Galveston or New Orleans guests. This reveals port-level pricing gaps across Carnival's 6 homeports.*

### Transition

> "We've mapped the pricing landscape. But there's an external signal we haven't looked at yet -- what are the airlines telling us about upcoming demand?"

---

## Act 4: Airline Partner Signals (Partner Insights)

**Agent:** `CCL Partner Insights`
**Persona:** Head of Strategic Partnerships & Revenue Forecasting

> "Through a secure data clean room, we receive airline demand signals -- flight search volumes, pricing trends, and capacity data for every port Carnival operates from. This is the forward-looking indicator that tells us where demand is heading before bookings arrive."

### Questions to Ask

**1. Current market signals**
```
What are the current airline pricing signals by port?
```
> *Price index and demand score by port. A high demand score at Galveston means Texan guests are searching for flights -- we should ensure our Galveston departures on Carnival Vista and Carnival Freedom are competitively priced.*

**2. Anomaly detection**
```
Are there any unusual airline pricing signals that could indicate demand changes?
```
> *Flags statistical anomalies in airline data. A sudden spike in Miami flight prices could mean a major event driving demand -- or a supply disruption we should respond to.*

**3. Weekly trends**
```
What is the weekly airline price trend?
```
> *Rolling view of airline pricing and demand. Rising airline prices to Tampa = guests are willing to pay to get there = Carnival can be more aggressive on Tampa departures.*

**4. Demand ranking**
```
Which ports have the highest airline demand?
```
> *Ranks ports by demand signal. Helps prioritize where to allocate marketing spend and ship positioning across Carnival's 6 homeports.*

### Transition

> "Now for the most powerful part: asking cross-domain questions that no single dashboard could answer."

---

## Act 5: Unified Intelligence (Yield Optimization Assistant)

**Agent:** `CCL Yield Optimization Assistant`
**Persona:** Chief Revenue Officer

> "This agent has access to all four data sources -- yield, guests, pricing, and partner signals. It routes each question to the right tool automatically. This is how a CRO thinks."

### Questions to Ask

**1. Where to promote**
```
Based on current conversion rates and occupancy, which ships should we prioritize for promotional pricing?
```
> *The #1 revenue management question. Combines occupancy (yield data) with conversion rates (pricing data) to identify where promotional spend will have the most impact across Carnival's 10-ship fleet.*

**2. What-if pricing**
```
If we lowered Suite prices by 10%, which ships would benefit most based on their current conversion rates?
```
> *Simulates a pricing scenario against current performance. Ships with high traffic but low Suite conversion are the clear winners -- could Carnival Horizon or Carnival Panorama benefit from a Vista-class Suite promotion?*

**3. Market misalignment**
```
Are there any ports where airline prices are spiking but our cruise conversions are dropping?
```
> *Detects the most dangerous scenario: external demand is strong (airlines see it) but Carnival's pricing isn't capturing it. If flights to Galveston are surging but Carnival Vista bookings are flat, immediate action required.*

**4. Upsell targeting**
```
How does price sensitivity vary across loyalty tiers, and which tier represents the best upsell opportunity?
```
> *Combines VIFP guest profiles (price sensitivity by tier) with pricing data. Finds the sweet spot -- the Gold or Platinum tier with money to spend that hasn't been offered the right cabin upgrade.*

**5. Feeder market intelligence**
```
Which origin cities have guests with the highest lifetime value?
```
> *Uses flight origin data + guest lifetime value to identify the top feeder cities. Are Atlanta and Dallas sending Carnival's highest-value guests? Drives media buying and airline partnership strategy.*

**6. The pricing action item**
```
Which cabin classes are overpriced relative to their conversion performance?
```
> *The question that ends the meeting with a clear action item. Identifies exactly which cabin classes need price adjustments, right now.*

**7. Optimal pricing**
```
What is the optimal price point for Balcony cabins based on historical conversion patterns?
```
> *Uses historical conversion curves to suggest the price that maximizes revenue -- not just bookings.*

---

## Closing

> "In this demo we showed how Carnival Cruise Line uses Snowflake Intelligence to:
>
> 1. **Monitor fleet yield** in real time across 10 ships and 6 regions
> 2. **Understand guest value** through 360-degree VIFP profiles with loyalty tier data
> 3. **Optimize pricing** by analyzing conversion funnels across every cabin class
> 4. **Detect demand signals** from airline partner data through secure clean rooms
> 5. **Make cross-functional decisions** with a unified agent that spans all data sources
>
> Every question was answered in natural language, in seconds, against live Snowflake data. No dashboards to build, no SQL to write, no reports to wait for.
>
> This is **AI-powered revenue management** for the world's most popular cruise line, built entirely on Snowflake."

---

## Quick Reference

| Agent | Icon | What It Does |
|-------|------|-------------|
| CCL Yield Analyst | chart | Fleet yield, occupancy, revenue by ship/region |
| CCL Guest Intel | user | Guest profiles, VIFP loyalty tiers, lifetime value, segmentation |
| CCL Pricing Copilot | dollar | Conversion funnels, price trends, pricing recommendations |
| CCL Partner Insights | airplane | Airline demand signals, flight pricing, anomalies |
| CCL Yield Optimization Assistant | ship | Unified agent -- all 4 data sources, cross-domain questions |

**Database:** `CCL_YIELD_OPTIMIZATION`
**Ships:** Mardi Gras, Carnival Vista, Carnival Horizon, Carnival Panorama, Carnival Sunrise, Carnival Radiance, Carnival Glory, Carnival Liberty, Carnival Freedom, Carnival Valor
**Ship Classes:** Excel, Vista, Sunshine, Conquest
**Regions:** Caribbean, Bahamas, Mexico, Alaska, Europe, Panama Canal
**Homeports:** Miami, Fort Lauderdale, Galveston, New Orleans, Port Canaveral, Tampa
**Loyalty Program:** VIFP - Very Important Fun Person (Blue > Red > Gold > Platinum > Diamond)
**Cabin Classes:** Interior, Oceanview, Balcony, Suite, Haven
**Key Amenities:** Guy's Burger Joint, BlueIguana Cantina, RedFrog Pub, Cloud 9 Spa, Punchliner Comedy Club, WaterWorks
