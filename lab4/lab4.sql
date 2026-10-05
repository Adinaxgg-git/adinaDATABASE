-- TASK 1 Retrieve all airline names in uppercase. 
SELECT UPPER(airline_name) AS airline_name_uppercase
FROM airline;

-- TASK 2 Replace any occurrence of the word "Air" in airline names with "Aero". 
SELECT airline_name,
       REPLACE(airline_name, 'Air', 'Aero') AS modified_airline_name
FROM airline;

--TASK 3 Find all flight numbers that coordinates with both airline 1 and airline 2. 
SELECT flight_no,
       airline_id
FROM flights
WHERE airline_id IN (1, 2);

--TASK 4 Retrieve airports that contain the word "Reginal" and "Air"  in their names. 
SELECT *
FROM airport
WHERE airport_name ILIKE '%Reginal%'
  AND airport_name ILIKE '%Air%';

--TASK 5 Retrieve passenger names and format their birth dates as 'Month DD, YYYY'
SELECT first_name,
       last_name,
       TO_CHAR(date_of_birth, 'Month DD, YYYY') AS formatted_birth_date
FROM passengers

-- TASK 6 Find flight numbers that have been delayed based on the actual arrival time
SELECT flight_no
FROM flights
WHERE actual_arrival > scheduled_arrival;

-- TASK 7 Find flights that arrived late according to their actual arrival time compared to their scheduled arrival time
SELECT *
FROM flights
WHERE actual_arrival > scheduled_arrival;

-- TASK 8 Show airlines from France, Portugal or Poland created between 2023-11-01 and 2024-03-31
SELECT *
FROM airline
WHERE airline_country IN ('France', 'Portugal', 'Poland')
  AND created_at BETWEEN '2023-11-01' AND '2024-03-31';

-- TASK 9 Find top 3 overweighted baggage with more than 25 kg

SELECT *
FROM baggage
WHERE weight_in_kg > 25
ORDER BY weight_in_kg DESC
LIMIT 3;

-- TASK 10 Find the youngest passengers' full name
SELECT first_name,
       last_name,
       date_of_birth
FROM passengers
WHERE date_of_birth = (
    SELECT MAX(date_of_birth)
    FROM passengers
);

-- TASK 11 Find the cheapest booking price on each booking platform
SELECT booking_platform,
       MIN(price) AS cheapest_price
FROM booking
GROUP BY booking_platform
ORDER BY booking_platform;


-- TASK 12 Return airlines whose airline_code contains a digit
SELECT *
FROM airline
WHERE airline_code ~ '[0-9]';


-- TASK 13 List the top 5 most recently created airlines
SELECT *
FROM airline
ORDER BY created_at DESC
LIMIT 5;

-- TASK 14 Return all rows where booking_id is between 200 and 300 inclusive and check_result is not 'Checked'
SELECT *
FROM baggage_check
WHERE booking_id BETWEEN 200 AND 300
  AND check_result <> 'Checked';


-- TASK 15 Baggage checks where update_at is in the same month as created_at but occurs earlier than created_at
SELECT *
FROM baggage_check
WHERE DATE_TRUNC('month', update_at) = DATE_TRUNC('month', created_at)
  AND update_at < created_at;