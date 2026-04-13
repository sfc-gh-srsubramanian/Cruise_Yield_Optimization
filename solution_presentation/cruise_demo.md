# Cruise Yield Optimization - Dynamic Yield Optimization Demo

**Database:** `CRUISE_YIELD_OPTIMIZATION`
**Snowflake Intelligence:** Open Snowflake Intelligence and select any CRUISE agent

---

## Opening Narrative

> A modern cruise line operates a diverse fleet of 10 ships across multiple classes and 6 global regions, carrying millions of guests annually. Every sailing is a perishable asset -- an empty cabin on departure day is revenue lost forever. The revenue management challenge: set the right price, for the right cabin, on the right ship, for the right guest, at the right time.
>
> Today we'll show how a cruise line's revenue management team uses **Snowflake Intelligence** with purpose-built AI agents to ask natural-language questions across yield data, guest profiles, pricing funnels, and airline partner signals -- and get instant, data-driven answers they can act on.

---

## Act 1: Fleet Revenue Health (Yield Analyst)

**Agent:** `CRUISE Yield Analyst`
**Persona:** VP of Revenue Management

> "Every Monday, our revenue team needs a pulse on fleet performance. Instead of opening 5 dashboards, they open Snowflake Intelligence and ask."

### Questions to Ask

**1. Top-level yield**
```
What is the net yield by region?
```
> *Net yield = revenue per available passenger cruise day. The single most important KPI in cruise revenue management. This instantly shows which regions are generating the most value.*

**2. Flagship deep dive**
```
What is the net revenue trend for Harmony of the Seas?
```
> *Harmony is a 6,780-passenger Oasis-class ship -- one of the largest revenue generators in the fleet. Tracking its trend reveals whether the fleet's anchor is holding.*

**3. Ship class comparison**
```
Which ship class has the best yield optimization?
```
> *Compares Oasis, Quantum, Prima, Breakaway Plus, and Epic classes. Reveals whether mega-ships or smaller vessels are producing better per-passenger economics.*

**4. Spotting trouble**
```
Identify underperforming sailings with low occupancy
```
> *Flags specific sailings below target. These are the "rescue" opportunities -- sailings that need price adjustments or promotional pushes before departure.*

**5. Seasonal intelligence**
```
Show me seasonal yield patterns for European cruises
```
> *European itineraries have a short peak season. This shows whether pricing strategy is capturing the summer premium effectively.*

### Transition

> "We've identified where yield is strong and where it's soft. Now the question is: who are the guests behind these numbers?"

---

## Act 2: Guest Intelligence (Guest Intel)

**Agent:** `CRUISE Guest Intel`
**Persona:** Director of Customer Analytics

> "We maintain 360-degree profiles on every guest -- their loyalty tier, lifetime value, spending habits, preferred cabin class, booking channel, and satisfaction scores. Let's explore."

### Questions to Ask

**1. Loyalty landscape**
```
What is the distribution of guests by loyalty tier?
```
> *Maps the Loyalty Rewards pyramid: Bronze, Silver, Gold, Platinum, Diamond. The shape of this pyramid drives retention strategy.*

**2. Top-tier deep dive**
```
Analyze spending patterns for Diamond members
```
> *Diamond is the top loyalty tier. These guests have the highest lifetime value, lowest price sensitivity, and strongest brand attachment. Understanding their behavior drives VIP strategy.*

**3. Value segmentation**
```
How are guests distributed across value segments?
```
> *Shows VIP, High Value, Growing, Developing, New, and Prospect segments. The "Growing" segment is often the most actionable -- high potential guests who need the right nudge.*

**4. Cabin-loyalty link**
```
What cabin class do Diamond members prefer, and how does their conversion rate compare to other tiers?
```
> *Reveals whether Suite and Grand Suite inventory is aligned with top-tier demand. If Diamond members want Suites but conversion is low, the price may be wrong even for price-insensitive guests.*

**5. Ancillary opportunity**
```
Which guest segments have high lifetime value but low spa/excursion attach rates?
```
> *Finds high-value guests who aren't buying ancillary products. Each identified segment is a personalization opportunity -- targeted pre-cruise offers for spa packages, excursion credits, or specialty dining.*

**6. Satisfaction check**
```
Who are the top spending guests?
```
> *Lists the highest-value guests by lifetime value. In the real world, each of these would have a dedicated concierge follow-up.*

### Transition

> "We know the guests. Now let's look at whether our prices are converting."

---

## Act 3: Pricing Performance (Pricing Copilot)

**Agent:** `CRUISE Pricing Copilot`
**Persona:** Pricing Strategy Manager

> "Every price we show is an impression. Every booking is a conversion. Our Pricing Copilot analyzes this funnel across every ship, cabin class, and region."

### Questions to Ask

**1. The conversion funnel**
```
What is the conversion rate by cabin class?
```
> *The most important pricing metric. Shows impression-to-booking conversion for Interior through Grand Suite. If Balcony converts at 12% but Suite converts at 4%, there's a pricing gap.*

**2. Ship-specific recommendations**
```
Can you give me pricing recommendations for Norwegian Prima?
```
> *Breaks down Prima's pricing by cabin class with conversion rates and average prices. Generates specific recommendations: "lower by 5-10%", "competitive", or "strong -- consider premium positioning".*

**3. Price trends**
```
Show me pricing trends for Balcony cabins this quarter
```
> *Balcony is the volume cabin. Small price changes here move millions in revenue. The trend shows whether recent adjustments are working.*

**4. Finding overpriced inventory**
```
Which itineraries are overpriced based on conversion rates?
```
> *Identifies specific routes where pricing is killing conversion. These are the surgical price adjustments that have the highest ROI.*

**5. Port-level performance**
```
Compare pricing performance across departure ports
```
> *Different ports serve different markets. Miami guests may have different price sensitivity than Seattle or Honolulu guests. This reveals port-level pricing gaps.*

### Transition

> "We've mapped the pricing landscape. But there's an external signal we haven't looked at yet -- what are the airlines telling us about upcoming demand?"

---

## Act 4: Airline Partner Signals (Partner Insights)

**Agent:** `CRUISE Partner Insights`
**Persona:** Head of Strategic Partnerships & Revenue Forecasting

> "Through a secure data clean room, we receive airline demand signals -- flight search volumes, pricing trends, and capacity data for every port we operate from. This is the forward-looking indicator that tells us where demand is heading before bookings arrive."

### Questions to Ask

**1. Current market signals**
```
What are the current airline pricing signals by port?
```
> *Price index and demand score by port. A high demand score at Fort Lauderdale means guests are searching for flights there -- we should ensure our FLL departures are competitively priced.*

**2. Anomaly detection**
```
Are there any unusual airline pricing signals that could indicate demand changes?
```
> *Flags statistical anomalies in airline data. A sudden spike in Miami flight prices could mean a major event driving demand -- or a supply disruption we should respond to.*

**3. Weekly trends**
```
What is the weekly airline price trend?
```
> *Rolling view of airline pricing and demand. Rising airline prices to a port = guests are willing to pay to get there = cruise pricing can be more aggressive.*

**4. Demand ranking**
```
Which ports have the highest airline demand?
```
> *Ranks ports by demand signal. Helps prioritize where to allocate marketing spend and ship positioning.*

### Transition

> "Now for the most powerful part: asking cross-domain questions that no single dashboard could answer."

---

## Act 5: Unified Intelligence (Yield Optimization Assistant)

**Agent:** `CRUISE Yield Optimization Assistant`
**Persona:** Chief Revenue Officer

> "This agent has access to all four data sources -- yield, guests, pricing, and partner signals. It routes each question to the right tool automatically. This is how a CRO thinks."

### Questions to Ask

**1. Where to promote**
```
Based on current conversion rates and occupancy, which ships should we prioritize for promotional pricing?
```
> *The #1 revenue management question. Combines occupancy (yield data) with conversion rates (pricing data) to identify where promotional spend will have the most impact.*

**2. What-if pricing**
```
If we lowered Suite prices by 10%, which ships would benefit most based on their current conversion rates?
```
> *Simulates a pricing scenario against current performance. Ships with high traffic but low Suite conversion are the clear winners.*

**3. Market misalignment**
```
Are there any ports where airline prices are spiking but our cruise conversions are dropping?
```
> *Detects the most dangerous scenario: external demand is strong (airlines see it) but our pricing isn't capturing it. Immediate action required.*

**4. Upsell targeting**
```
How does price sensitivity vary across loyalty tiers, and which tier represents the best upsell opportunity?
```
> *Combines guest profiles (price sensitivity by tier) with pricing data. Finds the sweet spot -- the tier with money to spend that hasn't been offered the right product.*

**5. Feeder market intelligence**
```
Which origin cities have guests with the highest lifetime value?
```
> *Uses flight origin data + guest lifetime value to identify the top feeder cities. Drives media buying and airline partnership strategy.*

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

> "In this demo we showed how a cruise line uses Snowflake Intelligence to:
>
> 1. **Monitor fleet yield** in real time across 10 ships and 6 regions
> 2. **Understand guest value** through 360-degree profiles with loyalty tier data
> 3. **Optimize pricing** by analyzing conversion funnels across every cabin class
> 4. **Detect demand signals** from airline partner data through secure clean rooms
> 5. **Make cross-functional decisions** with a unified agent that spans all data sources
>
> Every question was answered in natural language, in seconds, against live Snowflake data. No dashboards to build, no SQL to write, no reports to wait for.
>
> This is **AI-powered revenue management** built entirely on Snowflake."

---

## Quick Reference

| Agent | Icon | What It Does |
|-------|------|-------------|
| CRUISE Yield Analyst | chart | Fleet yield, occupancy, revenue by ship/region |
| CRUISE Guest Intel | user | Guest profiles, loyalty tiers, lifetime value, segmentation |
| CRUISE Pricing Copilot | dollar | Conversion funnels, price trends, pricing recommendations |
| CRUISE Partner Insights | airplane | Airline demand signals, flight pricing, anomalies |
| CRUISE Yield Optimization Assistant | ship | Unified agent -- all 4 data sources, cross-domain questions |

**Database:** `CRUISE_YIELD_OPTIMIZATION`
**Ships:** Harmony of the Seas, Symphony of the Seas, Wonder of the Seas, Odyssey of the Seas, Anthem of the Seas, Norwegian Prima, Norwegian Viva, Norwegian Encore, Norwegian Bliss, Norwegian Epic
**Regions:** Caribbean, Alaska, Europe, Mexico, Bahamas, Hawaii
**Loyalty Program:** Loyalty Rewards (Bronze > Silver > Gold > Platinum > Diamond)
**Cabin Classes:** Interior, Ocean View, Balcony, Suite, Grand Suite
