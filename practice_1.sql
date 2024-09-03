--EX1:
SELECT
    NAME
FROM CITY
WHERE POPULATION > 120000 AND COUNTRYCODE = 'USA'

--EX2:
SELECT *
FROM CITY
WHERE COUNTRYCODE = 'JPN'

--EX3:
SELECT
    CITY,
    STATE
FROM STATION

--EX4:
SELECT 
    DISTINCT CITY
FROM STATION
WHERE CITY LIKE 'A%' OR CITY LIKE 'E%' OR CITY LIKE 'I%' OR CITY LIKE 'O%' OR CITY LIKE 'U%'

--EX5:
SELECT 
    DISTINCT CITY
FROM STATION
WHERE CITY LIKE '%A' OR CITY LIKE '%E' OR CITY LIKE '%I' OR CITY LIKE '%O' OR CITY LIKE '%U'

--EX6:
SELECT 
    DISTINCT CITY
FROM STATION
WHERE CITY NOT LIKE 'A%' AND CITY NOT LIKE 'E%' AND CITY NOT LIKE 'I%' AND CITY NOT LIKE 'O%' AND CITY NOT LIKE 'U%'

--EX7:
SELECT
    NAME
FROM EMPLOYEE
ORDER BY NAME

--EX8:
SELECT
    NAME
FROM EMPLOYEE
WHERE SALARY > 2000 AND MONTHS < 10
ORDER BY EMPLOYEE_ID

--EX9:
SELECT
    PRODUCT_ID
FROM PRODUCTS
WHERE LOW_FATS = 'Y' AND RECYCLABLE = 'Y'

--EX10:
SELECT
    NAME
FROM CUSTOMER
WHERE REFEREE_ID <> 2 OR REFEREE_ID IS NULL
ORDER BY NAME

--EX11:
SELECT
    NAME,
    POPULATION,
    AREA
FROM WORLD
WHERE AREA >= 3000000 OR POPULATION >= 25000000

--EX12:
SELECT
    DISTINCT AUTHOR_ID AS ID
FROM VIEWS
WHERE AUTHOR_ID = VIEWER_ID
ORDER BY AUTHOR_ID

--EX13:
SELECT 
  PART,
  ASSEMBLY_STEP
FROM parts_assembly
WHERE FINISH_DATE IS NULL

--EX14:
SELECT *
FROM lyft_drivers
WHERE yearly_salary <= 30000 or yearly_salary >= 70000

--EX15:
SELECT 
    advertising_channel
FROM uber_advertising
WHERE money_spent > 100000