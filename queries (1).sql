-- Project 2: Kaggle Facebook Ads SQL Analysis — queries.sql
-- Dataset: KAG_conversion_data.csv (Kaggle "Clicks Conversion Tracking", loveall)
-- 1,143 ads; Total_Conversion = enquiries, Approved_Conversion = buyers
-- Author: Sehar Gillani

-- Cleaning: import landed with columns c1..c11 and the CSV header as a data row
-- (COUNT = 1144). Rebuilt with real names/types, header row excluded.
CREATE TABLE ads2 (
  ad_id INTEGER, xyz_campaign_id INTEGER, fb_campaign_id INTEGER,
  age TEXT, gender TEXT, interest INTEGER,
  impressions INTEGER, clicks INTEGER, spent REAL,
  total_conversion INTEGER, approved_conversion INTEGER
);
INSERT INTO ads2 SELECT * FROM ads WHERE c1 != 'ad_id';
DROP TABLE ads;
ALTER TABLE ads2 RENAME TO ads;
-- Verified: SELECT COUNT(*) FROM ads;  -> 1143

-- Q1: Campaign totals + CTR
SELECT
  xyz_campaign_id,
  COUNT(*) AS ads,
  SUM(impressions) AS impressions,
  SUM(clicks) AS clicks,
  ROUND(SUM(clicks) * 100.0 / SUM(impressions), 2) AS ctr_percent,
  ROUND(SUM(spent), 2) AS spent,
  SUM(total_conversion) AS enquiries,
  SUM(approved_conversion) AS buyers
FROM ads
GROUP BY xyz_campaign_id
ORDER BY spent DESC;

-- Q2: Efficiency by campaign
SELECT
  xyz_campaign_id,
  ROUND(SUM(spent) / SUM(clicks), 2) AS cost_per_click,
  ROUND(SUM(spent) / SUM(approved_conversion), 2) AS cost_per_buyer,
  ROUND(SUM(approved_conversion) * 100.0 / SUM(clicks), 2) AS buyers_per_100_clicks
FROM ads
GROUP BY xyz_campaign_id
ORDER BY cost_per_buyer ASC;

-- Q3: Segments — cost per buyer by age x gender (all campaigns)
SELECT
  age, gender,
  SUM(clicks) AS clicks,
  SUM(approved_conversion) AS buyers,
  ROUND(SUM(spent) / SUM(approved_conversion), 2) AS cost_per_buyer
FROM ads
GROUP BY age, gender
ORDER BY cost_per_buyer ASC;

-- Q4: Diagnosis inside campaign 1178 only
SELECT
  age, gender,
  SUM(approved_conversion) AS buyers,
  ROUND(SUM(spent), 2) AS spent,
  ROUND(SUM(spent) / SUM(approved_conversion), 2) AS cost_per_buyer
FROM ads
WHERE xyz_campaign_id = 1178
GROUP BY age, gender
ORDER BY cost_per_buyer DESC;
