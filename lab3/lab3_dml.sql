SET search_path TO public;

TRUNCATE Security_check, Baggage_check, Baggage, Boarding_pass, Booking_flight, Booking, Flights, Passengers, Airport, Airline CASCADE;



-- 1. Airline
INSERT INTO Airline (airline_id, airline_code, airline_name, airline_country, created_at, updated_at)
SELECT 
    i,
    'A' || i,
    'Airline ' || i,
    CASE WHEN i % 2 = 0 THEN 'Kazakhstan' ELSE 'France' END,
    NOW(),
    NOW()
FROM generate_series(1, 200) AS i;

-- 2. Airport
INSERT INTO Airport (airport_id, airport_name, country, state, city, created_at, updated_at)
SELECT 
    i,
    'Airport ' || i,
    'Country ' || i,
    CASE WHEN i = 4 OR i = 5 THEN NULL ELSE 'State ' || i END,
    CASE 
        WHEN i = 1 THEN 'Astana'
        WHEN i = 2 THEN 'London'
        WHEN i = 3 THEN 'Tokyo'
        WHEN i = 4 THEN 'Mlawe'
        WHEN i = 5 THEN 'Kepuh'
        ELSE 'City ' || i
    END,
    NOW(),
    NOW()
FROM generate_series(1, 200) AS i;

-- 3. Passengers
INSERT INTO Passengers (passenger_id, first_name, last_name, date_of_birth, gender, country_of_citizenship, country_of_residence, passport_number, created_at, updated_at)
SELECT 
    i,
    'Name' || i,
    'Surname' || i,
    '2000-01-01'::DATE,
    'Male',
    'Kazakhstan',
    'Kazakhstan',
    'P100' || i,
    NOW(),
    NOW()
FROM generate_series(1, 200) AS i;

-- 4. Flights
INSERT INTO Flights (flight_id, sch_departure_time, sch_arrival_time, departing_airport_id, arriving_airport_id, departing_gate, arriving_gate, airline_id, act_departure_time, act_arrival_time, created_at, updated_at)
SELECT 
    i,
    CASE WHEN i <= 20 THEN '2024-05-10 10:00:00'::TIMESTAMP ELSE '2025-05-10 10:00:00'::TIMESTAMP END,
    CASE WHEN i <= 20 THEN '2024-05-10 15:00:00'::TIMESTAMP ELSE '2025-05-10 15:00:00'::TIMESTAMP END,
    1,
    2,
    'Gate A',
    'Gate B',
    i,
    NOW(),
    NOW(),
    NOW(),
    NOW()
FROM generate_series(1, 200) AS i;

-- 5. Booking
INSERT INTO Booking (booking_id, flight_id, passenger_id, booking_platform, created_at, updated_at, status, ticket_price)
SELECT 
    i,
    i,
    i,
    'Web',
    NOW(),
    NOW(),
    'Confirmed',
    CASE WHEN i <= 20 THEN 5000 ELSE 15000 END
FROM generate_series(1, 200) AS i;

-- 6. Booking_flight
INSERT INTO Booking_flight (booking_flight_id, booking_id, flight_id, created_at, updated_at)
SELECT i, i, i, NOW(), NOW()
FROM generate_series(1, 200) AS i;

-- 7. Baggage
INSERT INTO Baggage (baggage_id, weight_in_kg, created_at, updated_at, booking_id)
SELECT i, 20.5, NOW(), NOW(), i
FROM generate_series(1, 200) AS i;

-- 8. Boarding_pass
INSERT INTO Boarding_pass (boarding_pass_id, booking_id, seat, boarding_time, created_at, updated_at)
SELECT i, i, '12A', NOW(), NOW(), NOW()
FROM generate_series(1, 200) AS i;

-- 9. Baggage_check
INSERT INTO Baggage_check (baggage_check_id, check_result, created_at, updated_at, booking_id, passenger_id)
SELECT 
    i,
    'Not checked',
    CASE 
        WHEN i <= 10 THEN '2024-03-15 12:00:00'::TIMESTAMP 
        WHEN i <= 20 THEN '2023-01-01 12:00:00'::TIMESTAMP 
        ELSE NOW() 
    END,
    NOW(),
    i,
    i
FROM generate_series(1, 200) AS i;

-- 10. Security_check
INSERT INTO Security_check (security_check_id, check_result, created_at, updated_at, passenger_id)
SELECT i, 'Passed', NOW(), NOW(), i
FROM generate_series(1, 200) AS i;




-- Task 2: 
INSERT INTO Airline (airline_id, airline_code, airline_name, airline_country, created_at, updated_at)
VALUES (201, 'KAZ', 'KazAir', 'Kazakhstan', NOW(), NOW());

SELECT * FROM Airline WHERE airline_name = 'KazAir';

-- Task 3:
UPDATE Airline
SET airline_country = 'Turkey'
WHERE airline_name = 'KazAir';

SELECT * FROM Airline WHERE airline_name = 'KazAir';

-- Task 4: 
INSERT INTO Airline (airline_id, airline_code, airline_name, airline_country, created_at, updated_at)
VALUES 
    (202, 'EASY', 'AirEasy', 'France', NOW(), NOW()),
    (203, 'HIGH', 'FlyHigh', 'Brazil', NOW(), NOW()),
    (204, 'FLY', 'FlyFly', 'Poland', NOW(), NOW());

SELECT * FROM Airline WHERE airline_id IN (202, 203, 204);

-- Task 5: 
DELETE FROM Baggage_check WHERE booking_id IN (SELECT booking_id FROM Booking WHERE flight_id IN (SELECT flight_id FROM Flights WHERE EXTRACT(YEAR FROM sch_arrival_time) = 2024));
DELETE FROM Baggage WHERE booking_id IN (SELECT booking_id FROM Booking WHERE flight_id IN (SELECT flight_id FROM Flights WHERE EXTRACT(YEAR FROM sch_arrival_time) = 2024));
DELETE FROM Boarding_pass WHERE booking_id IN (SELECT booking_id FROM Booking WHERE flight_id IN (SELECT flight_id FROM Flights WHERE EXTRACT(YEAR FROM sch_arrival_time) = 2024));
DELETE FROM Booking_flight WHERE flight_id IN (SELECT flight_id FROM Flights WHERE EXTRACT(YEAR FROM sch_arrival_time) = 2024);
DELETE FROM Booking WHERE flight_id IN (SELECT flight_id FROM Flights WHERE EXTRACT(YEAR FROM sch_arrival_time) = 2024);
DELETE FROM Flights WHERE EXTRACT(YEAR FROM sch_arrival_time) = 2024;

SELECT * FROM Flights WHERE EXTRACT(YEAR FROM sch_arrival_time) = 2024;

-- Task 6: 
UPDATE Booking
SET ticket_price = ticket_price * 1.15;

SELECT ticket_price FROM Booking LIMIT 5;

-- Task 7: 
DELETE FROM Baggage_check WHERE booking_id IN (SELECT booking_id FROM Booking WHERE ticket_price < 10000);
DELETE FROM Baggage WHERE booking_id IN (SELECT booking_id FROM Booking WHERE ticket_price < 10000);
DELETE FROM Boarding_pass WHERE booking_id IN (SELECT booking_id FROM Booking WHERE ticket_price < 10000);
DELETE FROM Booking_flight WHERE booking_id IN (SELECT booking_id FROM Booking WHERE ticket_price < 10000);
DELETE FROM Booking WHERE ticket_price < 10000;

SELECT * FROM Booking WHERE ticket_price < 10000;

-- Task 8: 
UPDATE Airline
SET airline_code = 'UNK'
WHERE airline_code IS NULL;

-- Task 9: 
DELETE FROM Baggage_check 
WHERE created_at < '2023-06-01' AND check_result = 'Not checked';

-- Task 10: 
DELETE FROM Airport 
WHERE state IS NULL AND (city = 'Mlawe' OR city = 'Kepuh');

-- Task 11: 
INSERT INTO Baggage_check (baggage_check_id, check_result, created_at, updated_at, booking_id, passenger_id)
VALUES (300, 'Not checked', NOW(), NOW(), 21, 21)
RETURNING baggage_check_id, created_at;

-- Task 12: 
UPDATE Airline 
SET airline_country = UPPER(airline_country);

SELECT airline_country FROM Airline LIMIT 5;

-- Task 13: 
UPDATE Airline
SET airline_name = 'Global Airways',
    airline_country = 'United Kingdom',
    updated_at = NOW()
WHERE airline_id = 5;

SELECT * FROM Airline WHERE airline_id = 5;

-- Task 14: 
UPDATE Airport
SET state = 'Capital District'
WHERE city IN ('Astana', 'London', 'Tokyo');

SELECT * FROM Airport WHERE city IN ('Astana', 'London', 'Tokyo');

-- Task 15: 
UPDATE Baggage_check
SET check_result = 'Checked'
WHERE check_result = 'Not checked' 
  AND created_at >= '2024-03-01' 
  AND created_at < '2024-04-01';

SELECT * FROM Baggage_check WHERE check_result = 'Checked' LIMIT 5;