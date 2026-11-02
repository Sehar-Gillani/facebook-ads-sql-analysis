# Facebook Ads SQL Analysis (Kaggle data)

Real Facebook advertising data from Kaggle ("Clicks Conversion Tracking"):
1,143 ads across 3 campaigns, analyzed in SQL (SQLite). Question: where does
the money work, and where does it leak?

## Data cleaning
The CSV import arrived with generic column names (c1–c11) and the header row
stored as data (row count 1,144 vs the expected 1,143). Rebuilt the table with
proper names/types, excluded the header row, and verified the count (1,143)
before any analysis.

## Findings
- **One campaign dominates spend:** campaign 1178 holds 95% of total spend
  ($55,662 of $58,705) and 872 of 1,079 buyers.
- **CTR looked identical (0.02%) across campaigns** — a rounding artifact:
  with ~213M total impressions, true CTRs (~0.018% vs ~0.024%) differ by a
  third but round to the same 2-decimal display.
- **Clicks cost the same everywhere** ($1.32–$1.54 CPC), but cost per buyer
  diverges 10x: campaign 916 = $6.24, 936 = $15.81, 1178 = $63.83. Buyers per
  100 clicks: 21.24 vs 9.22 vs 2.42. The largest campaign buys reach, not buyers.
  (Caveat: 916's efficiency rests on 24 buyers — promising, small sample.)
- **Segments:** cheapest buyers overall are age 40–44; most expensive, 45–49.
- **Inside campaign 1178:** both 45–49 segments top the cost table
  (women $137.76/buyer on $11,985 spend — the campaign's single biggest line;
  men $86.14). Together 45–49 consumes ~$19,049 (34% of 1178's spend) for 169
  buyers. The campaign's best segment is 30–34 men: 243 buyers at $30.77.
  Note: 40–44 is cheap account-wide but NOT inside 1178 ($67–$88) — segment
  performance is campaign-specific.

## Recommendations
1. **Demographic trimming:** exclude or heavily reduce the 45–49 bracket
   across active campaigns; redirect that budget toward 40–44, the
   lowest-cost acquisition segment. (Estimated effect inside 1178 alone:
   removing 45–49 cuts its cost per buyer from $63.83 to ~$52.)
2. **Reallocate gradually:** do not flip the budget to campaign 916 at once —
   sudden scaling can destabilize delivery and inflate CPA. Scale 1178 down
   to a maintenance level and shift 20–30% of budget to 916 to test whether
   its efficiency survives higher volume.
3. **Diagnose before closing 1178:** its high CPA is heavily driven by the
   45–49 segments; removing them may salvage the campaign's efficiency,
   especially given its efficient 30–34 core.

## Tools
SQLite (sqliteonline), Kaggle. Queries in `queries.sql`.
