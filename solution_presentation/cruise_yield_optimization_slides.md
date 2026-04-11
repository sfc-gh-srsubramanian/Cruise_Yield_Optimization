# Cruise Yield Optimization - Executive Presentation

## Slide Deck: Situation -> Complication -> Resolution

---

## Slide 1: Title

**Cruise Yield Optimization**
*Turning Pricing Guesswork into Revenue Precision with Snowflake*

Audience: Revenue Management Leadership, CIO/CTO, VP Analytics
Prepared by: Snowflake Solutions Engineering

---

## Slide 2: The cruise industry has recovered -- but yield management has not kept pace

The global cruise market reached 31.7M passengers in 2023 (CLIA), surpassing pre-pandemic levels. Fleet capacity is expanding. Demand is strong.

Yet net yield per available passenger cruise day -- the metric that determines fleet profitability -- varies by **$340-$620 between top and bottom performing ships in the same fleet**. The difference is not the ship, the itinerary, or the market. It is how pricing decisions are made.

- 68% of revenue managers still use spreadsheet-based pricing models
- Average pricing update cycle: 3-5 days
- Guest lifetime value data is disconnected from pricing decisions

*Visual: Yield variance chart across fleet*

---

## Slide 3: Revenue teams make pricing decisions with partial data -- and it costs $2.8B industry-wide

**The three data gaps killing yield performance:**

1. **Guest Intelligence Gap**: Guest profiles, loyalty, spending, and feedback live in 4-6 systems. A $50K lifetime-value Diamond member gets the same price as a first-time budget cruiser.

2. **Yield Fragmentation Gap**: Net yield requires cabin + onboard + pre-cruise revenue. Most operators see one stream at a time, never the true picture.

3. **Demand Signal Gap**: Airline pricing signals predict cruise demand 2-3 weeks ahead, but these signals are disconnected from pricing workflows.

*Visual: Problem impact -- three metric cards showing $2.8B, 68%, 15-22%*

---

## Slide 4: Unified yield management delivers $50-80M annually for mid-sized fleets

**Four measurable value drivers:**

| Driver | Impact | Source |
|--------|--------|--------|
| Net yield per APCD | +2.5-4% | Integrated yield across all revenue streams |
| Booking conversion | +12-18% | ML-driven price optimization per guest segment |
| Onboard revenue | +8-15% | Guest 360 targeted upsell strategies |
| Analytics speed | 80% faster | Natural language querying replaces analyst sprints |

A 1% improvement in net yield per APCD = **$50-80M annually** for a mid-sized fleet.

*Visual: ROI value diagram with central value circle and four drivers*

---

## Slide 5: Cruise Yield Optimization unifies every revenue signal on a single Snowflake platform

**Solution overview:**

A four-layer medallion architecture within a single Snowflake database:

- **Ingest**: 8 source tables, 8.8M+ rows of operational data (bookings, spending, guests, feedback, partner signals)
- **Curate**: Guest 360 unified profile with value segmentation, enriched booking views
- **Analyze**: Net yield per APCD, pricing conversion analytics, 8 semantic views
- **Predict**: ML UDFs for conversion probability, optimal pricing, and what-if scenarios

No external infrastructure. No data movement. Everything runs where the data lives.

*Visual: Architecture diagram -- left-to-right data flow*

---

## Slide 6: The data journey -- from fragmented sources to pricing intelligence

**Step 1 - Ingest**: Sailings, guests, bookings, onboard spending, pre-cruise purchases, pricing events, partner signals, and guest feedback land in the RAW bronze layer.

**Step 2 - Curate**: GUEST_360 view joins guest profiles with booking history, spending patterns, and service usage. Six value segments (High-Value Low-Sensitivity through Budget-Focused) drive differentiated pricing.

**Step 3 - Analyze**: V_SAILING_YIELD computes net yield per APCD across all revenue streams. V_PRICING_PERFORMANCE tracks conversion rates by ship, cabin, region.

**Step 4 - Predict & Act**: PREDICT_CONVERSION_PROB scores each guest-cabin-price combination. GET_OPTIMAL_PRICE_RECOMMENDATION returns the right price for the right guest. Revenue managers query via natural language through Cortex Analyst.

*Visual: Architecture diagram with step callouts*

---

## Slide 7: Revenue managers ask questions in plain English -- Cortex Analyst delivers answers in seconds

**18 verified queries across four domains:**

| Domain | Example Questions |
|--------|-------------------|
| Yield Analytics | "What is the net yield by region?" / "Which ships have the highest net yield?" |
| Pricing Analytics | "What is the conversion rate by cabin class?" / "Show pricing trends by month" |
| Guest 360 | "Which loyalty tier has the highest lifetime value?" / "Show upcoming sailings by guest segment" |
| Partner Signals | "Are there unusual airline pricing signals?" / "What is the weekly price trend by port?" |

No SQL required. No analyst bottleneck. Answers in seconds, not days.

*Visual: Screenshot of natural language query -> instant results*

---

## Slide 8: Industry leaders validate the unified yield approach

- **McKinsey (2023)**: Personalized pricing captures 10-15% more revenue than uniform rates in travel
- **Deloitte (2024)**: Cruise lines with integrated revenue management outperform peers by 3-5% on net yield
- **Bain (2023)**: ML-driven dynamic pricing improves conversion 12-18% in travel and hospitality
- **Phocuswright (2024)**: Partner signal integration improves booking forecast accuracy by 8-12%
- **CLIA**: $340-$620 yield variance per passenger day between top and bottom fleet performers

The data is clear: unified yield management is the highest-leverage investment in cruise revenue.

---

## Slide 9: Deployment is measured in weeks, not quarters

**What you get:**
- Single Snowflake database with complete medallion architecture
- 8.8M+ rows of operational data flowing through 4 layers
- 3 ML UDFs for pricing intelligence (conversion prediction, optimal price, scenario analysis)
- 8 semantic views with Cortex Analyst for natural language access
- Clean room integration for airline partner signals
- One-command deployment (`./deploy.sh`)

**What you need:**
- Snowflake account with ACCOUNTADMIN
- SnowCLI installed
- One Medium warehouse

**Value realization timeline:**
- Week 1-2: Deploy infrastructure and data pipeline
- Week 3-4: Validate yield analytics and guest segmentation
- Week 5-8: Activate pricing ML and Cortex Analyst access

---

## Slide 10: Next Steps

**Start with a Yield Assessment:**

1. Deploy the solution in your Snowflake environment (single command)
2. Connect your booking and guest data sources
3. Validate yield calculations against current reporting
4. Pilot ML-driven pricing on 2-3 itineraries
5. Measure conversion and yield improvement over 90 days

**The question is not whether unified yield management works. It is how much revenue you are leaving on the table today.**

Contact your Snowflake account team to schedule a hands-on walkthrough.
