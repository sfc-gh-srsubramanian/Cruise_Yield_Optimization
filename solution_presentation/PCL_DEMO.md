# Princess Cruises - Dynamic Yield Optimization Demo

**Database:** `PCL_YIELD_OPTIMIZATION`
**Snowflake Intelligence:** Open Snowflake Intelligence and select any PCL agent

---

## Opening Narrative

> Princess Cruises is the premium ocean cruise line known for pioneering MedallionClass technology -- the most personalized guest experience at sea. Operating a fleet of 10 ships across Royal and Grand classes, Princess sails from Fort Lauderdale, Los Angeles, San Francisco, Seattle, New York, and global ports including Rome, Barcelona, Athens, and Sydney, covering Alaska, the Caribbean, Europe, Mexico, the Panama Canal, and South America.
>
> Princess's guest profile is the experienced traveler who values destination immersion, culinary excellence, and seamless technology. Every sailing is a perishable asset -- an empty Balcony stateroom on departure day is revenue lost forever. The revenue management challenge: set the right price, for the right cabin, on the right ship, for the right guest, at the right time.
>
> Today we'll show how Princess's revenue management team uses **Snowflake Intelligence** with purpose-built AI agents to ask natural-language questions across yield data, guest profiles, pricing funnels, and airline partner signals -- and get instant, data-driven answers they can act on.

---

## Act 1: Fleet Revenue Health (Yield Analyst)

**Agent:** `PCL Yield Analyst`
**Persona:** VP of Revenue Management

> "Every Monday, our revenue team needs a pulse on Princess's fleet performance. Instead of opening 5 dashboards, they open Snowflake Intelligence and ask."

### Questions to Ask

**1. Top-level yield**
```
What is the net yield by region?
```
> *Net yield = revenue per available passenger cruise day. The single most important KPI in cruise revenue management. This instantly shows whether Alaska, Caribbean, Europe, Mexico, Panama Canal, or South America is generating the most value.*

**2. Flagship deep dive**
```
What is the net revenue trend for Royal Princess?
```
> *Royal Princess is the 3,560-passenger namesake of the Royal Class -- the line's most recognized ship and a floating showcase for MedallionClass technology. Tracking its trend reveals whether the flagship is delivering.*

**3. Ship class comparison**
```
Which ship class has the best yield optimization?
```
> *Compares Royal Class (5 ships, 3,560-3,660 pax) vs Grand Class (5 ships, 2,600-3,080 pax). Reveals whether the newer, larger Royal Class ships or the proven Grand Class are producing better per-passenger economics.*

**4. Spotting trouble**
```
Identify underperforming sailings with low occupancy
```
> *Flags specific sailings below target. These are the sailings that need price adjustments or promotional pushes before departure.*

**5. Seasonal intelligence**
```
Show me seasonal yield patterns for European cruises
```
> *Europe is a major Princess market with departures from Rome, Barcelona, and Athens. This shows whether pricing strategy is capturing the Mediterranean summer premium effectively.*

### Transition

> "We've identified where yield is strong and where it's soft. Now the question is: who are the guests behind these numbers?"

---

## Act 2: Guest Intelligence (Guest Intel)

**Agent:** `PCL Guest Intel`
**Persona:** Director of Customer Analytics

> "We maintain 360-degree profiles on every guest -- their Captain's Circle loyalty tier, lifetime value, spending habits, preferred cabin class, booking channel, and satisfaction scores. Let's explore."

### Questions to Ask

**1. Loyalty landscape**
```
What is the distribution of guests by loyalty tier?
```
> *Maps Princess's Captain's Circle pyramid: Gold, Ruby, Platinum, Elite, Master (only achievable after 15+ cruises). The shape of this pyramid drives retention strategy -- Ruby and Platinum members are the growth engine.*

**2. Top-tier deep dive**
```
Analyze spending patterns for Elite and Master members
```
> *Elite and Master are the top Captain's Circle tiers. These guests have the highest lifetime value, expect priority embarkation and complimentary services, and are the strongest brand advocates. Understanding their behavior drives VIP strategy.*

**3. Value segmentation**
```
How are guests distributed across value segments?
```
> *Shows Budget Cruiser, Mainstream, Premium Seeker, Luxury Enthusiast, Adventure Seeker, Family Focused, Spa Enthusiast, Casino Patron, Wine Aficionado, and Foodie segments. Princess's culinary partnerships and MedallionClass personalization make each segment highly targetable.*

**4. Cabin-loyalty link**
```
What cabin class do Elite members prefer, and how does their conversion rate compare to other tiers?
```
> *Reveals whether Suite and Mini-Suite inventory is aligned with top-tier demand. If Elite members want Mini-Suites but conversion is low, the price may need adjustment.*

**5. Ancillary opportunity**
```
Which guest segments have high lifetime value but low spa/excursion attach rates?
```
> *Finds high-value guests who aren't buying Lotus Spa treatments or shore excursions. Each identified segment is a personalization opportunity -- targeted pre-cruise offers via the MedallionClass app for spa packages, Sabatini's dining, or Crown Grill reservations.*

**6. Satisfaction check**
```
Who are the top spending guests?
```
> *Lists the highest-value guests by lifetime value. In the real world, each of these Master-tier guests would have a dedicated concierge follow-up.*

### Transition

> "We know the guests. Now let's look at whether our prices are converting."

---

## Act 3: Pricing Performance (Pricing Copilot)

**Agent:** `PCL Pricing Copilot`
**Persona:** Pricing Strategy Manager

> "Every price we show is an impression. Every booking is a conversion. Our Pricing Copilot analyzes this funnel across every ship, cabin class, and region."

### Questions to Ask

**1. The conversion funnel**
```
What is the conversion rate by cabin class?
```
> *Shows impression-to-booking conversion for Interior, Oceanview, Balcony, Mini-Suite, and Suite. Balcony is Princess's signature cabin -- if it's not converting well, that's the biggest revenue lever.*

**2. Ship-specific recommendations**
```
Can you give me pricing recommendations for Royal Princess?
```
> *Breaks down Royal Princess pricing by cabin class with conversion rates and average prices. As the namesake flagship, it should command a premium -- but is the premium converting?*

**3. Price trends**
```
Show me pricing trends for Balcony cabins this quarter
```
> *Balcony is the volume cabin for Princess. Small price changes here move millions in revenue. The trend shows whether recent adjustments are working.*

**4. Finding overpriced inventory**
```
Which itineraries are overpriced based on conversion rates?
```
> *Identifies specific routes where pricing is killing conversion. A Rome-to-Greek Isles itinerary with high impressions but low bookings is a clear signal to adjust.*

**5. Port-level performance**
```
Compare pricing performance across departure ports
```
> *Princess's global footprint means diverse markets: Los Angeles serves the West Coast, Fort Lauderdale the East Coast, and Rome/Barcelona serve European fly-cruise guests. This reveals port-level pricing gaps.*

### Transition

> "We've mapped the pricing landscape. But there's an external signal we haven't looked at yet -- what are the airlines telling us about upcoming demand?"

---

## Act 4: Airline Partner Signals (Partner Insights)

**Agent:** `PCL Partner Insights`
**Persona:** Head of Strategic Partnerships & Revenue Forecasting

> "Through a secure data clean room, we receive airline demand signals -- flight search volumes, pricing trends, and capacity data for every port Princess operates from. This is the forward-looking indicator that tells us where demand is heading before bookings arrive."

### Questions to Ask

**1. Current market signals**
```
What are the current airline pricing signals by port?
```
> *Price index and demand score by port. A high demand score at Seattle means Alaska-season guests are searching for flights -- we should ensure Sky Princess and Emerald Princess Alaska departures are competitively priced.*

**2. Anomaly detection**
```
Are there any unusual airline pricing signals that could indicate demand changes?
```
> *Flags statistical anomalies in airline data. A sudden spike in Rome flight prices could mean a major event driving Mediterranean demand -- or a supply disruption Princess should respond to.*

**3. Weekly trends**
```
What is the weekly airline price trend?
```
> *Rolling view of airline pricing and demand. Rising airline prices to Barcelona = guests are willing to pay to get to the Mediterranean = Princess can be more aggressive on European sailings.*

**4. Demand ranking**
```
Which ports have the highest airline demand?
```
> *Ranks ports by demand signal. Helps prioritize where to allocate marketing spend across Princess's global port network from Fort Lauderdale to Sydney.*

### Transition

> "Now for the most powerful part: asking cross-domain questions that no single dashboard could answer."

---

## Act 5: Unified Intelligence (Yield Optimization Assistant)

**Agent:** `PCL Yield Optimization Assistant`
**Persona:** Chief Revenue Officer

> "This agent has access to all four data sources -- yield, guests, pricing, and partner signals. It routes each question to the right tool automatically. This is how a CRO thinks."

### Questions to Ask

**1. Where to promote**
```
Based on current conversion rates and occupancy, which ships should we prioritize for promotional pricing?
```
> *The #1 revenue management question. Combines occupancy (yield data) with conversion rates (pricing data) to identify where promotional spend will have the most impact across Princess's 10-ship fleet.*

**2. What-if pricing**
```
If we lowered Suite prices by 10%, which ships would benefit most based on their current conversion rates?
```
> *Simulates a pricing scenario against current performance. Ships with high traffic but low Suite conversion are the clear winners -- could Grand Princess or Crown Princess benefit from a targeted Suite promotion?*

**3. Market misalignment**
```
Are there any ports where airline prices are spiking but our cruise conversions are dropping?
```
> *Detects the most dangerous scenario: external demand is strong but Princess's pricing isn't capturing it. If flights to Rome are surging but Royal Princess Mediterranean bookings are flat, immediate action required.*

**4. Upsell targeting**
```
How does price sensitivity vary across loyalty tiers, and which tier represents the best upsell opportunity?
```
> *Combines Captain's Circle profiles (price sensitivity by tier) with pricing data. Ruby and Platinum members are often the sweet spot -- loyal enough to value Princess, with room to upgrade from Balcony to Mini-Suite.*

**5. Feeder market intelligence**
```
Which origin cities have guests with the highest lifetime value?
```
> *Uses flight origin data + guest lifetime value to identify the top feeder cities. Are Los Angeles and New York sending Princess's highest-value guests? Drives media buying and airline partnership strategy.*

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

> "In this demo we showed how Princess Cruises uses Snowflake Intelligence to:
>
> 1. **Monitor fleet yield** in real time across 10 ships and 6 regions
> 2. **Understand guest value** through 360-degree Captain's Circle profiles with loyalty tier data
> 3. **Optimize pricing** by analyzing conversion funnels across every cabin class
> 4. **Detect demand signals** from airline partner data through secure clean rooms
> 5. **Make cross-functional decisions** with a unified agent that spans all data sources
>
> Every question was answered in natural language, in seconds, against live Snowflake data. No dashboards to build, no SQL to write, no reports to wait for.
>
> This is **AI-powered revenue management** with MedallionClass precision, built entirely on Snowflake."

---

## Quick Reference

| Agent | Icon | What It Does |
|-------|------|-------------|
| PCL Yield Analyst | chart | Fleet yield, occupancy, revenue by ship/region |
| PCL Guest Intel | user | Guest profiles, Captain's Circle tiers, lifetime value, segmentation |
| PCL Pricing Copilot | dollar | Conversion funnels, price trends, pricing recommendations |
| PCL Partner Insights | airplane | Airline demand signals, flight pricing, anomalies |
| PCL Yield Optimization Assistant | ship | Unified agent -- all 4 data sources, cross-domain questions |

**Database:** `PCL_YIELD_OPTIMIZATION`
**Ships:** Royal Princess, Majestic Princess, Regal Princess, Sky Princess, Enchanted Princess, Emerald Princess, Ruby Princess, Crown Princess, Golden Princess, Grand Princess
**Ship Classes:** Royal Class, Grand Class
**Regions:** Alaska, Caribbean, Europe, Mexico, Panama Canal, South America
**Homeports:** Fort Lauderdale, Los Angeles, San Francisco, Seattle, New York, Rome, Barcelona
**Loyalty Program:** Captain's Circle (Gold > Ruby > Platinum > Elite > Master)
**Cabin Classes:** Interior, Oceanview, Balcony, Mini-Suite, Suite
**Key Amenities:** MedallionClass / Ocean Medallion, Movies Under the Stars, The Sanctuary, Lotus Spa, Sabatini's, Crown Grill
