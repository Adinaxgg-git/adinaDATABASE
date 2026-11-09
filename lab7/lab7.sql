--1 Create an index on the actual_departure column in the flights table. 
CREATE INDEX index_actual_departure
ON flights (actual_departure);

--2 Create a unique index to ensure flight_no and scheduled_departure combinations are unique. 
CREATE UNIQUE INDEX index_flight_no_scheduled_departure
ON flights (flight_no,scheduled_departure);
--не раннится 
SELECT flight_no,scheduled_departure,
COUNT(*) AS duplicate_count
FROM flights
GROUP BY flight_no, scheduled_departure
HAVING COUNT(*) > 1;

--3 Create a composite index on the departure_airport_id and arrival_airport_id columns. 
CREATE INDEX index_departure_airport_id_arrival_airport_id
ON flights (departure_airport_id,arrival_airport_id);

--4 Evaluate the difference in query performance with and without indexes. Measure performance differences. 
DROP INDEX index_departure_airport_id_arrival_airport_id;

EXPLAIN ANALYZE
SELECT *
FROM flights
WHERE departure_airport_id = 1
AND arrival_airport_id = 5;

CREATE INDEX index_departure_airport_id_arrival_airport_id
ON flights (departure_airport_id, arrival_airport_id);

EXPLAIN ANALYZE
SELECT *
FROM flights
WHERE departure_airport_id = 1
AND arrival_airport_id = 5;

--5 Use EXPLAIN ANALYZE to check index usage in a query filtering by departure_airport and arrival_airport.
EXPLAIN ANALYZE
SELECT *
FROM flights
WHERE departure_airport_id = 1
AND arrival_airport_id = 5;

--6 Create a unique index for the passport_number of the Passengers table. Check if the index was created or not. Insert into the table two new passengers. Explain in your own words what is going on in the output? 
CREATE UNIQUE INDEX index_passengers_passport_number
ON passengers (passport_number);

SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'passengers';

SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'passengers'
ORDER BY ordinal_position;

--7 Create an index for the Passengers table. Use for that first name, last name, date of birth and country of citizenship. Then, write a SQL query to find a passenger who was born in Philippines and was born in 1984 and check if the query uses indexes or not. Give the explanation of the results. 
CREATE INDEX index_passengers_details
ON passengers (first_name, last_name, date_of_birth, country_of_citizenship);

SELECT *
FROM passengers
WHERE country_of_citizenship = 'Philippines'
AND date_of_birth >= '1984-01-01'
AND date_of_birth < '1985-01-01';

EXPLAIN ANALYZE
SELECT *
FROM passengers
WHERE country_of_citizenship = 'Philippines'
AND date_of_birth >= '1984-01-01'
AND date_of_birth < '1985-01-01';

--8 Write a SQL query to list indexes for table Passengers. After delete the created indexes. 
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'passengers';

DROP INDEX IF EXISTS idx_passengers_passport_number;
DROP INDEX IF EXISTS idx_passengers_name_dob_country;

SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'passengers';

--9 Create an index on the passenger_id column of the booking table. Using EXPLAIN ANALYZE, compare the execution plan and execution time of a query that selects all bookings of one passenger (for example, passenger_id = 100) before and after creating the index. Explain what changed in the plan. 
EXPLAIN ANALYZE
SELECT *
FROM booking
WHERE passenger_id = 100;

CREATE INDEX idx_booking_passenger_id
ON booking(passenger_id);

EXPLAIN ANALYZE
SELECT *
FROM booking
WHERE passenger_id = 100;

--10 Create a composite index on the booking_flight table using the booking_id and flight_id columns. Write a query that joins booking, booking_flight and flights and returns the flight_no and price for bookings with a price greater than 9000. Check with EXPLAIN ANALYZE which indexes are used in each step of the join.
CREATE INDEX idx_booking_flight_composite
ON booking_flight(booking_id, flight_id);

SELECT f.flight_no,b.price
FROM booking b
JOIN booking_flight bf
ON b.booking_id = bf.booking_id
JOIN flights f
ON bf.flight_id = f.flight_id
WHERE b.price > 9000;

EXPLAIN ANALYZE
SELECT f.flight_no,b.price
FROM booking b
JOIN booking_flight bf
ON b.booking_id = bf.booking_id
JOIN flights f
ON bf.flight_id = f.flight_id
WHERE b.price > 9000;

--11 Create an index on the status column of the flights table. Run EXPLAIN ANALYZE for the query with status = 'Departed' and for the query with status = 'Boarding'. Compare the plans and explain, in your own words, why the optimizer may ignore the index for one of the values (hint: selectivity).
CREATE INDEX idx_flights_status
ON flights(status);

EXPLAIN ANALYZE
SELECT *
FROM flights
WHERE status = 'Departed';

EXPLAIN ANALYZE
SELECT *
FROM flights
WHERE status = 'Boarding';

--12 Create an index on the weight_in_kg column of the baggage table. Compare the plans of two range queries: weight_in_kg > 49 (a small part of the table) and weight_in_kg > 5 (almost the whole table). Explain the difference in index usage. 
CREATE INDEX idx_flights_status
ON flights(status);

EXPLAIN ANALYZE
SELECT *
FROM flights
WHERE status = 'Departed';

EXPLAIN ANALYZE
SELECT *
FROM flights
WHERE status = 'Boarding';

--13 Create an index on the airport_name column of the airport table. Check with EXPLAIN ANALYZE whether it is used by the queries LIKE 'A%' and LIKE '%Airport'. Explain why the results are different. 
CREATE INDEX idx_airport_name
ON airport(airport_name);

EXPLAIN ANALYZE
SELECT *
FROM airport
WHERE airport_name LIKE 'A%';

EXPLAIN ANALYZE
SELECT *
FROM airport
WHERE airport_name LIKE '%Airport';

--14 Create a composite index on the country and city columns of the airport table. Run three queries: filtering by country only, by city only, and by both columns. Check which of them use the index and explain the leftmost prefix rule using your results. 
CREATE INDEX idx_airport_country_city
ON airport(country, city);

EXPLAIN ANALYZE
SELECT *
FROM airport
WHERE country = 'Kazakhstan';

EXPLAIN ANALYZE
SELECT *
FROM airport
WHERE city = 'Almaty';

EXPLAIN ANALYZE
SELECT *
FROM airport
WHERE country = 'Kazakhstan'
AND city = 'Almaty';

--15 Create an expression (functional) index on the lower-case last_name of the Passengers table (LOWER(last_name)). Compare the plans of a query written as WHERE LOWER(last_name) = 'irnis' and a query written as WHERE last_name = 'Irnis'. Explain which query can use the index and why. 
CREATE INDEX idx_passengers_lower_last_name
ON passengers(LOWER(last_name));

EXPLAIN ANALYZE
SELECT *
FROM passengers
WHERE LOWER(last_name) = 'irnis';

EXPLAIN ANALYZE
SELECT *
FROM passengers
WHERE last_name = 'Irnis';

--16 Create a covering index on the booking table for the columns passenger_id and price. Write a query that returns only price for a given passenger_id and check with EXPLAIN ANALYZE whether an index-only scan (or "Using index") is used. Explain the benefit of a covering index. 
CREATE INDEX idx_booking_passenger_price
ON booking(passenger_id, price);

EXPLAIN ANALYZE
SELECT price
FROM booking
WHERE passenger_id = 100;

--17 Try to create a unique index on the airline_code column of the airline table. If an error occurs, explain what caused it and find the problematic rows with a GROUP BY ... HAVING COUNT(*) > 1 query. Then create the unique index in a way that works for the current data, or after fixing the data. 
CREATE UNIQUE INDEX idx_airline_code_unique
ON airline(airline_code);

SELECT airline_code, COUNT(*)
FROM airline
GROUP BY airline_code
HAVING COUNT(*) > 1;

SELECT *
FROM airline
WHERE airline_code IN (
SELECT airline_code
FROM airline
GROUP BY airline_code
HAVING COUNT(*) > 1)
ORDER BY airline_code;

CREATE UNIQUE INDEX idx_airline_code_unique
ON airline(airline_code);
