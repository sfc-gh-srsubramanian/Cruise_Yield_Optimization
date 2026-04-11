# Norwegian Cruise Line - Dynamic Yield Optimization Demo

**Database:** `NCL_YIELD_OPTIMIZATION`
**Snowflake Intelligence:** Open Snowflake Intelligence and select any NCL agent

---

## Opening Narrative

> Norwegian Cruise Line operates a fleet of 10 ships across 6 regions, serving hundreds of thousands of guests annually. Revenue management decisions -- pricing adjustments, promotional targeting, cabin allocation -- are complex and time-sensitive.
>
> Today we'll show how NCL's revenue management team uses **Snowflake Intelligence** with purpose-built AI agents to ask natural-language questions across yield data, guest profiles, pricing funnels, and airline partner signals -- and get instant, data-driven answers they can act on.

---

## Act 1: Revenue Pulse Check (NCL Yield Analyst)

**Agent:** `NCL Yield Analyst`
**Persona:** VP of Revenue Management, Monday morning standup

> "Let's start the way a revenue leader starts their week -- with a pulse check across the fleet."

### Questions to Ask

**1. Fleet-wide performance snapshot**
```
What is the net yield by region?
```
> *Shows yield per passenger-day across Caribbean, Alaska, Mediterranean, Northern Europe, Bermuda, and Hawaii. Sets the stage for where revenue is strong and where it's soft.*

**2. Ship-level deep dive**
```
What is the net revenue trend for Norwegian Prima?
```
> *Prima is NCL's newest flagship in the Prima class. This shows whether the new-build premium is holding up over time.*

**3. Underperformers**
```
Identify underperforming sailings with low occupancy
```
> *Surfaces sailings below target occupancy -- these are the ones that need pricing or promotional intervention.*

**4. Regional comparison**
```
Compare yield performance between Caribbean and Mediterranean regions
```
> *Head-to-head comparison of NCL's two largest markets. Drives seasonal allocation decisions.*

### Transition

> "We can see that some ships and regions are soft. But before we adjust pricing, we need to understand *who* is booking -- and who isn't."

---

## Act 2: Know Your Guest (NCL Guest Intel)

**Agent:** `NCL Guest Intel`
**Persona:** Director of Customer Intelligence

> "Let's shift to our guest data. We have 360-degree profiles on every guest -- loyalty status, lifetime value, spending habits, booking patterns, and satisfaction scores."

### Questions to Ask

**1. Loyalty tier breakdown**
```
What is the distribution of guests by loyalty tier?
```
> *Shows the Latitudes Rewards pyramid: Bronze through Ambassador. Highlights how top-tier guests drive disproportionate value.*

**2. High-value guest behavior**
```
Analyze spending patterns for Ambassador members
```
> *Ambassador is the top Latitudes tier. Shows their average onboard spend, preferred cabins, booking frequency, and lifetime value. These are the guests NCL cannot afford to lose.*

**3. Value segmentation**
```
How are guests distributed across value segments?
```
> *Shows VIP, High Value, Growing, Developing, New, and Prospect segments. Reveals where the growth opportunity is.*

**4. Upsell opportunity**
```
Which guest segments have high lifetime value but low spa/excursion attach rates?
```
> *Identifies guests who spend heavily on cabins but barely touch ancillary revenue streams -- a clear upsell opportunity for onboard merchandising.*

**5. Cabin preferences by loyalty**
```
What cabin class do Ambassador members prefer, and how does their conversion rate compare to other tiers?
```
> *Links loyalty status to cabin demand, revealing whether Haven and Suite inventory is aligned with top-tier guest preferences.*

### Transition

> "Now we know where occupancy is soft and which guest segments to target. The question becomes: are we priced right?"

---

## Act 3: Price It Right (NCL Pricing Copilot)

**Agent:** `NCL Pricing Copilot`
**Persona:** Pricing Analyst

> "Our Pricing Copilot analyzes every price impression and conversion across the fleet. It tells us not just what we charged, but whether those prices actually converted into bookings."

### Questions to Ask

**1. Conversion funnel by cabin class**
```
What is the conversion rate by cabin class?
```
> *Shows impression-to-booking conversion for Inside, Oceanview, Balcony, Mini Suite, Suite, and The Haven. Low conversion on a class = price too high or demand too low.*

**2. Ship-specific pricing**
```
Can you give me pricing recommendations for Norwegian Prima?
```
> *Breaks down Prima's pricing performance by cabin class with conversion rates and average price points. Highlights which classes need adjustment.*

**3. Pricing trends**
```
Show me pricing trends for Balcony cabins this quarter
```
> *Time-series view of mid-tier cabin pricing. Balcony is the volume driver -- pricing here affects total revenue significantly.*

**4. Overpriced inventory**
```
Which itineraries are overpriced based on conversion rates?
```
> *Identifies routes where price is suppressing demand. These are candidates for tactical promotions or flash sales.*

### Transition

> "We've found pricing gaps. But there's one more signal we can use before making decisions -- what are the airlines telling us about upcoming travel demand?"

---

## Act 4: Demand Signals from the Sky (NCL Partner Insights)

**Agent:** `NCL Partner Insights`
**Persona:** Head of Strategic Partnerships

> "Through our clean room partnership with airline data providers, we can see flight search trends and pricing signals for every port we operate from. This is the forward-looking demand indicator that gives us a 30-60 day head start."

### Questions to Ask

**1. Current signals**
```
What are the current airline pricing signals by port?
```
> *Shows price index and demand scores by departure port (Miami, New York, Seattle, LA, etc.). High demand scores = passengers are searching, and NCL should capture them.*

**2. Anomalies**
```
Are there any unusual airline pricing signals that could indicate demand changes?
```
> *Flags anomalous spikes or drops in airline pricing. A spike in flights to Miami could mean increased cruise demand; a drop to Alaska could signal softening.*

**3. Forward look**
```
What do the forward-looking airline signals show?
```
> *Weekly trend of price index and demand, giving the revenue team a preview of where bookings will flow.*

**4. Port-by-port demand**
```
Which ports have the highest airline demand?
```
> *Ranks ports by demand score. Helps decide where to deploy promotional spend and where ships should be repositioned.*

### Transition

> "Now let's bring it all together. What if we could ask one agent a cross-functional question that spans yield, guests, pricing, and partner data?"

---

## Act 5: The Power of Unified Intelligence (NCL Yield Optimization Assistant)

**Agent:** `NCL Yield Optimization Assistant`
**Persona:** Chief Revenue Officer

> "This is our unified agent. It has access to all four data sources and can route questions to the right tool automatically. This is how a CRO thinks -- across domains, not in silos."

### Questions to Ask

**1. Cross-domain pricing decision**
```
Based on current conversion rates and occupancy, which ships should we prioritize for promotional pricing?
```
> *Combines yield data (occupancy) with pricing data (conversions) to recommend where to deploy promotional spend. This is a decision that previously required pulling reports from 3 different systems.*

**2. What-if scenario**
```
If we lowered Suite prices by 10%, which ships would benefit most based on their current conversion rates?
```
> *Simulates a pricing change against current conversion data. Ships with low Suite conversion but high traffic would benefit most.*

**3. Market-airline correlation**
```
Are there any ports where airline prices are spiking but our cruise conversions are dropping?
```
> *Detects misalignment between airline demand signals and cruise pricing. If flights to Miami are expensive but our Miami departures aren't converting, we have a pricing or marketing problem.*

**4. Guest-pricing intersection**
```
How does price sensitivity vary across loyalty tiers, and which tier represents the best upsell opportunity?
```
> *Joins guest profiles (price sensitivity) with pricing performance. Finds the tier that has money to spend but hasn't been given the right offer yet.*

**5. Origin city intelligence**
```
Which origin cities have guests with the highest lifetime value?
```
> *Uses flight and guest data together to identify the feeder markets that produce NCL's most valuable guests. Drives media spend allocation.*

**6. Cabin optimization**
```
Which cabin classes are overpriced relative to their conversion performance?
```
> *The definitive pricing action item. Identifies which classes to discount and which to hold firm on.*

---

## Closing

> "In this demo we showed how Norwegian Cruise Line uses Snowflake Intelligence to:
>
> 1. **Monitor fleet yield** in real time across 10 ships and 6 regions
> 2. **Understand guest value** through 360-degree profiles with Latitudes Rewards loyalty data
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
| NCL Yield Analyst | chart | Fleet yield, occupancy, revenue by ship/region |
| NCL Guest Intel | user | Guest profiles, loyalty tiers, lifetime value, segmentation |
| NCL Pricing Copilot | dollar | Conversion funnels, price trends, pricing recommendations |
| NCL Partner Insights | airplane | Airline demand signals, flight pricing, anomalies |
| NCL Yield Optimization Assistant | ship | Unified agent -- all 4 data sources, cross-domain questions |

**Database:** `NCL_YIELD_OPTIMIZATION`
**Ships:** Norwegian Prima, Viva, Aqua, Encore, Bliss, Joy, Escape, Breakaway, Getaway, Epic
**Regions:** Caribbean, Alaska, Mediterranean, Northern Europe, Bermuda, Hawaii
**Loyalty Program:** Latitudes Rewards (Bronze > Silver > Gold > Platinum > Ambassador)
**Cabin Classes:** Inside, Oceanview, Balcony, Mini Suite, Suite, The Haven
