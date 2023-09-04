--Dataset: Estimated food scrap yield per week of Vermont businesses and institutions
--Source: https://catalog.data.gov/dataset/food-scrap-generators-caa50

--How many unique businesses and institutions are in the dataset?
SELECT 
COUNT(DISTINCT "FSGName") as unique_businesses
FROM Food_Scrap_Generators
--5870

--How many of each type of institution are in the dataset?
SELECT
"TYPE1" AS business_type,
COUNT(*) AS num_businesses
FROM Food_Scrap_Generators
WHERE business_type != ''
GROUP BY business_type
ORDER BY num_businesses DESC
--Food establishments make up the majority of institutions in the dataset at 5594 businesses.

--What is the average amount of food scraps produced per week for a business or institution?
SELECT
AVG("TonsPerWeek")
FROM Food_Scrap_Generators
--The average is 0.46 tons per week

--What is the minimum amount of food scraps produced per week for a business or institution?
SELECT
MIN("TonsPerWeek")
FROM Food_Scrap_Generators
--The minimum is 0 tons per week

--How does the amount of food scraps produced per week vary between types of institutions?
SELECT 
"TonsPerWeek", 
"TYPE1" AS business_type
FROM Food_Scrap_Generators
WHERE business_type != ''
GROUP BY "TYPE1"
ORDER BY "TonsPerWeek" DESC
--Food manufacturers produce the most food scraps at 0.6 tons per week, followed by correctional facilities at 0.5 tons per week.

--How does the amount of food scraps produced per week vary between subtypes of institutions?
SELECT 
"TonsPerWeek", 
"TYPE2" AS business_subtype
FROM Food_Scrap_Generators
GROUP BY business_subtype
ORDER BY "TonsPerWeek" DESC
--Lodging produces the most food scraps at 3.15 tons per week, followed by cafeterias at 2.63 tons per week.

--What is the number of businesses and institutions per county?
SELECT
COUNT("FSGName") AS num_businesses,
"County"
FROM Food_Scrap_Generators
WHERE "County" != ''
GROUP BY "County"
ORDER BY num_businesses DESC
-- some counties entered twice with different capitalization

--What is the name and contact information for the business that produces the most food scraps in a week?
SELECT
*
FROM Food_Scrap_Generators
WHERE "TonsPerWeek" = (
  SELECT MAX("TonsPerWeek")
  FROM Food_Scrap_Generators
  )
--Dairy manufacturer Agri-Mark Cabot produces over 288 tons of food scraps per week.

--What is the aggregate amount of food scraps produced per week by county?
SELECT
"TonsPerWeek",
UPPER("County") AS county
FROM Food_Scrap_Generators
GROUP BY county
ORDER BY "TonsPerWeek" DESC

--What is the aggregate amount of food scraps produced per week by town?
SELECT
"TonsPerWeek",
UPPER("Town") AS town
FROM Food_Scrap_Generators
GROUP BY town
ORDER BY "TonsPerWeek" DESC

--What is the top generator of food scraps by weight per week, in every business type category?
SELECT
tons_scraps,
business_name,
business_type
FROM
(SELECT
"TonsPerWeek" as tons_scraps,
"FSGName" AS business_name,
"Type1" AS business_type,
RANK () OVER(PARTITION BY "Type1" ORDER BY "TonsPerWeek" DESC) as fsg_rank
FROM Food_Scrap_Generators) as sub
WHERE fsg_rank = 1 AND business_type != ''
ORDER BY tons_scraps DESC

--What is the top generator of food scraps by weight per week, in every business subtype category?
SELECT
tons_scraps,
business_name,
business_subtype
FROM
(SELECT
"TonsPerWeek" as tons_scraps,
"FSGName" AS business_name,
"Type2" AS business_subtype,
RANK () OVER(PARTITION BY "Type2" ORDER BY "TonsPerWeek" DESC) as fsg_rank
FROM Food_Scrap_Generators) as sub
WHERE fsg_rank = 1 AND business_subtype != ''
ORDER BY tons_scraps DESC

--What is the top generator of food scraps by weight per week, in every county?
SELECT
tons_scraps,
business_name,
county
FROM
(SELECT
"TonsPerWeek" as tons_scraps,
"FSGName" AS business_name,
"County" AS county,
RANK () OVER(PARTITION BY "County" ORDER BY "TonsPerWeek" DESC) as fsg_rank
FROM Food_Scrap_Generators) as sub
WHERE fsg_rank = 1 AND "County" != '' AND tons_scraps != ''
ORDER BY tons_scraps DESC

--What is the total amount of food scraps generated per week by Family Dollar stores?
SELECT
SUM("TonsPerWeek") as tons_per_week
FROM Food_Scrap_Generators
WHERE "FSGName" LIKE "%FAMILY DOLLAR%"
--10.08 tons

--What is the total amount of food scraps generated per week by Subway?
SELECT
SUM("TonsPerWeek") as tons_per_week
FROM Food_Scrap_Generators
WHERE "FSGName" LIKE "%SUBWAY%"
--12.668 tons

--What is the estimated total of food scraps generated per year per business type?
SELECT
"Type1" AS business_type,
"TonsPerWeek"*52 AS tons_per_year
FROM Food_Scrap_Generators
WHERE business_type != ''
GROUP BY business_type
ORDER by tons_per_year DESC
--Foods manufacturers produce an estimated 31 tons of food scraps per year in Vermont

