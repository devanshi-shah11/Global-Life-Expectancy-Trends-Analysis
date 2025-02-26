# World Life Expectancy Project (Data Cleaning)

SELECT * 
FROM world_life_expectancy
;
# STEP 1 - REMOVE DUPLICATES 

## Combination of Country and Year should be unique
## Checking for Duplicates in Country and Year Column
SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM world_life_expectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1
;

## Unique identifier for Country,Year is the Row_id so we count the no. of row_ids > 1
SELECT *
FROM (
	SELECT Row_ID,
	CONCAT(Country, Year),
	ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) as Row_Num
	FROM world_life_expectancy
	) AS Row_table
WHERE Row_Num > 1
;

## Delete the duplicate values . Before deleting dupliate values we make sure that the Safe Mode is turned off 
## SET SQL_SAFE_UPDATES = 0;

DELETE FROM world_life_expectancy
WHERE 
	Row_ID IN (
    SELECT Row_ID
FROM (
	SELECT Row_ID,
	CONCAT(Country, Year),
	ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) as Row_Num
	FROM world_life_expectancy
	) AS Row_table
WHERE Row_Num > 1
)
;
## Step 2 : Working with NULLS
# Status COLUMN
## Status is missing for some row ids, first we check whether it is null or is it a blank
SELECT * 
FROM world_life_expectancy
WHERE Status IS NULL
;
# We cannot find any Status value which is set to NULL
# Check whether STATUS is set to BLANK 
SELECT * 
FROM world_life_expectancy
WHERE Status = ''
;
# Distinct values in Status - Developing and Developed
SELECT DISTINCT(Status)
FROM world_life_expectancy
WHERE Status <> ''
;

## Update the status of the countries where it is BLANK ('') to either Developing or Developed 
SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status = 'Developing';
# Wherever the country is Developing in that subquery list, set it up as Developing

#Method 1 - gives us an error code 
/*Error Code 1093: "You can't specify target table for update in FROM clause" occurs in
 MySQL when you try to update or delete from a table while simultaneously selecting from the 
 same table in a subquery.
 MySQL does not allow modifying a table that is also used in the FROM clause of the same query.*/
UPDATE world_life_expectancy
SET Status = 'Developing'
WHERE Country IN (SELECT DISTINCT(Country)
				FROM world_life_expectancy
				WHERE Status = 'Developing');

/* M2: This query updates the Status column in the world_life_expectancy table for rows 
where Status is currently empty (''), and another row with the same Country has a non-empty (<> '') 
Status that is 'Developing'.
*/

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing'
;

SELECT * 
FROM world_life_expectancy
WHERE Country = 'United States of America'
;
## Do the exact same process where Status = "Developed"
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed'
;

##  Lifeexpectancy COLUMN - 2 NULLS when we run the query are seen
SELECT * 
FROM world_life_expectancy
#WHERE Lifeexpectancy = ''
;

SELECT Country, Year, Lifeexpectancy
FROM world_life_expectancy
WHERE Lifeexpectancy = ''
;


## Since life expectancy is in increasing trend where we look through the data, we will average the empty life 
# expectancy column with AVG(Y1,Y3) value for the current year
SELECT t1.Country, t1.Year, t1.Lifeexpectancy,
t2.Country, t2.Year, t2.Lifeexpectancy,
t3.Country, t3.Year, t3.Lifeexpectancy,
ROUND((t2.Lifeexpectancy + t3.Lifeexpectancy)/2,1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
WHERE t1.Lifeexpectancy = ''
;

# Update the average life expectancy values we derived above
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
SET t1.Lifeexpectancy = ROUND((t2.Lifeexpectancy + t3.Lifeexpectancy)/2,1)
WHERE t1.Lifeexpectancy = ''
;

# Check life expectancy column for blanks or null values again 
SELECT *
FROM world_life_expectancy
WHERE Lifeexpectancy = ''
;

## END of Data Cleaning






