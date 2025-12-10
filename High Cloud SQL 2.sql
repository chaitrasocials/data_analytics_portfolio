use highcloud_airline;
select * from maindata;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- "1.calcuate the following fields from the Year	Month (#)	Day  fields ( First Create a Date Field from Year , Month , Day fields)" 
   -- A.Year
--    B.Monthno
--    C.Monthfullname
--    D.Quarter(Q1,Q2,Q3,Q4)
--    E. YearMonth ( YYYY-MMM)
--    F. Weekdayno
--    G.Weekdayname
--    H.FinancialMOnth
--    I. Financial Quarter --
--    
--   `Full_Date` DATE AS(STR_TO_DATE(CONCAT(`Year`,'-',`Month (#)`,'-',`Day`),'%Y-%m-%d')) STORED,
--   `Month_Full_Name` VARCHAR(20) GENERATED ALWAYS AS (MONTHNAME(Full_Date)),
--   `Quarter_No` TINYINT AS(QUARTER(Full_Date)) VIRTUAL,
--   `YearMonth` VARCHAR(7) AS(DATE_FORMAT(Full_Date,'%Y-%m')) STORED,
--   `Weekdaynumber` TINYINT AS (WEEKDAY(Full_Date)) VIRTUAL,
--   `Weekdayname` VARCHAR(10) GENERATED ALWAYS AS (DAYNAME(Full_Date)) VIRTUAL,
--   `Financial_month` INT AS (
--   CASE
-- 	WHEN MONTH(Full_Date) >= 4 THEN MONTH(Full_Date) - 3
-- 	ELSE MONTH(Full_Date) + 9
-- END
--   ) VIRTUAL,
--   `Financial_Quarter` INT AS(
--   CASE
-- 	WHEN MONTH(Full_Date) BETWEEN 4 AND 6 THEN 1
--     WHEN MONTH(Full_Date) BETWEEN 7 AND 9 THEN 2
--     WHEN MONTH(Full_Date) BETWEEN 10 AND 12 THEN 3
--     ELSE 4
-- END
--   ) VIRTUAL,
--   `Day_Type` VARCHAR(10) AS(
--   CASE
-- 	WHEN DAYOFWEEK(Full_Date) IN (1,7) THEN 'Weekend'
-- 	ELSE 'Weekday'
--     END
--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Q2: Find the load Factor percentage on a yearly , Quarterly , Monthly basis ( Transported passengers / Available seats) --
-- Yearly --

select Year,sum(`# Transported Passengers`), sum(`# Available Seats`), 
(sum(`# Transported Passengers`)/sum(`# Available Seats`)*100) as LoadFactor_Yearly 
From maindata 
Group by Year;

-- Quaterly --

select concat("Q",Quarter_No) Quarter_No,sum(`# Transported Passengers`), sum(`# Available Seats`), 
(sum(`# Transported Passengers`)/sum(`# Available Seats`)*100) as LoadFactor_Quarterly
From maindata 
Group by Quarter_No 
Order by Quarter_No;

-- Monthly --

select `Month (#)`,Month_Full_Name,sum(`# Transported Passengers`), 
sum(`# Available Seats`), (sum(`# Transported Passengers`)/sum(`# Available Seats`)*100) as LoadFactor_Monthly
From maindata 
Group by `Month (#)`,Month_Full_Name 
Order by `Month (#)`;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 3. Find the load Factor percentage on a Carrier Name basis ( Transported passengers / Available seats) --

select `Carrier Name`,sum(`# Transported Passengers`), sum(`# Available Seats`), 
(sum(`# Transported Passengers`)/sum(`# Available Seats`)*100) as LoadFactor_by_CarrierName
From maindata 
Group by `Carrier Name` 
Order by LoadFactor_by_CarrierName desc;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 4. Identify Top 10 Carrier Names based passengers preference --

select `Carrier Name`,sum(`# Transported Passengers`) as Top10_CarrierNames
From maindata 
Group by `Carrier Name` 
Order by Top10_CarrierNames desc 
LIMIT 10;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 5. Display top Routes ( from-to City) based on Number of Flights --

select `From - To City`,Count(*) AS TotalFlights
From maindata
Group by `From - To City`
Order by TotalFlights DESC
LIMIT 10;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 6. Identify the how much load factor is occupied on Weekend vs Weekdays --

select Day_Type,sum(`# Transported Passengers`), sum(`# Available Seats`), 
(sum(`# Transported Passengers`)/sum(`# Available Seats`)*100) as LoadFactor_by_DayType 
From maindata
Group by Day_Type;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 7. Identify number of flights based on Distance group --

select 
`%Distance Group ID` As DistanceGroup,
SUM(`# Departures Performed`) AS NumberofFlights 
From maindata 
Group by `%Distance Group ID`
Order by NumberOfFlights DESC;

-- Calculated by Distance --

select
    case
        When Distance <= 500 Then '0-500 km'
        When Distance Between 501 And 1000 Then '501-1000 km'
        When Distance Between 1001 And 2000 Then '1001-2000 km'
        When Distance Between 2001 And 3000 Then '2001-3000 km'
        When Distance Between 3001 And 4000 Then '3001-4000 km'
        When Distance Between 4001 And 5000 Then '4001-5000 km'
        Else '>5000 km'
    End As DistanceGroup,
  Count(*) AS NumberOfFlights
From maindata
Group by DistanceGroup
Order by NumberOfFlights DESC;






