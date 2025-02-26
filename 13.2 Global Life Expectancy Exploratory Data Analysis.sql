# World Life Expectancy Project (Exploratory Data Analysis)
#Step 1 : Counts, Group by , sorting 
#Step 2 : Insights 

SELECT *
FROM world_life_expectancy
;
# Analysis 1 
# Finding Increase in the Life expectancy from 2007 to 2015 for different countries in Ascending Order 
SELECT Country, 
MIN(Lifeexpectancy), 
MAX(Lifeexpectancy),
ROUND(MAX(Lifeexpectancy) - MIN(Lifeexpectancy),1) AS Life_Increase_15_Years
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(Lifeexpectancy) <> 0 # Some countries have life expectancy = 0 , this might be due to some data quality issue
AND MAX(Lifeexpectancy) <> 0
ORDER BY Life_Increase_15_Years ASC
;

# Analysis 2
# Average Life Expectancy by Year - We see an increase in the rate of Life Expectancy
# The avg of Life expectancy has increased by 6 years in the last 15 years. 
#The 6-year rise in life expectancy over 15 years reflects healthcare advances, better living conditions, and economic growth.
# It benefits economies but challenges aging populations, requiring policies for healthcare, pensions, and workforce sustainability.

SELECT Year, ROUND(AVG(Lifeexpectancy),2)
FROM world_life_expectancy
WHERE Lifeexpectancy <> 0 # Some countries have life expectancy = 0 , this might be due to some data quality issue
AND Lifeexpectancy <> 0
GROUP BY Year
ORDER BY Year
;

SELECT * 
FROM world_life_expectancy
;
# Analysis 3
# Average Life Expectancy VS Average GDP 
# The higher the GDP , better the infrastructure and higher is the Life expectancy and vice versa is true
# This shows us a positive correlation trend 
/* Higher GDP enables better healthcare, nutrition, sanitation, and education,
improving life expectancy. 
Wealthier nations invest in medical research, infrastructure, and social services, 
reducing mortality rates. Conversely, lower GDP limits access to quality healthcare,
 leading to shorter life spans, reinforcing the correlation. */
SELECT Country, ROUND(AVG(Lifeexpectancy),1) AS Life_Exp, ROUND(AVG(GDP),1) AS GDP
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp > 0
AND GDP > 0
ORDER BY GDP DESC
;


## ANALYSIS 4: GDP COUNT VS LIFE EXPECTANCY
/*Countries with higher GDP (1326 count) have an average life expectancy of 74.2 years, while lower GDP nations (1612 count) average 64.7 years.
Economic prosperity improves healthcare, sanitation, food security, and social programs, leading to higher longevity.
In contrast, low-GDP nations face healthcare shortages, malnutrition, poor infrastructure, and unstable governance, reducing life expectancy.
*/
SELECT 
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) High_GDP_Count,
AVG(CASE WHEN GDP >= 1500 THEN Lifeexpectancy ELSE NULL END) High_GDP_Life_Expectancy,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) Low_GDP_Count,
AVG(CASE WHEN GDP <= 1500 THEN Lifeexpectancy ELSE NULL END) Low_GDP_Life_Expectancy
FROM world_life_expectancy
;

SELECT * 
FROM world_life_expectancy
;

## Analysis 5: Country Status VS AVG Life expectancy
#Developed countries have a higher life expectancy (79.2 years) due to better healthcare, 
#while developing nations lag (66.8 years) due to infrastructure and resource limitations.
SELECT Status, COUNT(DISTINCT Country), ROUND(AVG(Lifeexpectancy),1)
FROM world_life_expectancy
GROUP BY Status
;


## Analysis 6: AVG Life Expectancy VS AVG BMI 
## Higher BMI is linked to better nutrition and healthcare access, contributing to increased life expectancy. However, excessive BMI can lead to health risks, 
# impacting longevity despite the overall positive correlation observed.
SELECT Country, ROUND(AVG(Lifeexpectancy),1) AS Life_Exp, ROUND(AVG(BMI),1) AS BMI
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp > 0
AND BMI > 0
ORDER BY BMI ASC
;

## Analysis 7 : This query calculates the rolling total of Adult Mortality for 
#countries with "United" in their name over time.
# The analysis helps track cumulative mortality trends, showing how mortality rates impact life 
#expectancy across years and highlighting healthcare improvements or declines.
SELECT Country, Year, Lifeexpectancy, AdultMortality,
SUM(AdultMortality) OVER(PARTITION BY Country ORDER BY Year) AS Rolling_Total
FROM world_life_expectancy
WHERE Country LIKE '%United%'
;

/* Life expectancy and adult mortality are inversely related—higher adult mortality lowers life expectancy, while lower mortality improves it.
 Trends help identify healthcare advancements, socioeconomic factors, and public health interventions shaping longevity over time.*/


















































































