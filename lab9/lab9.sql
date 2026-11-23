-- 1.	 Create a stored procedure to insert a new flight into the flights table. 
CREATE OR REPLACE PROCEDURE insert_flight(
p_flight_no VARCHAR,
p_scheduled_departure TIMESTAMP,
p_scheduled_arrival TIMESTAMP,
p_departure_airport_id INT,
p_arrival_airport_id INT,
p_airline_id INT,
p_status VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
INSERT INTO flights (
flight_no,
scheduled_departure,
scheduled_arrival,
departure_airport_id,
arrival_airport_id,
airline_id,
status)
VALUES (
p_flight_no,
p_scheduled_departure,
p_scheduled_arrival,
p_departure_airport_id,
p_arrival_airport_id,
p_airline_id,
p_status);
END;
$$;
-- 2.	Create a stored procedure to update the status of a flight. 
CREATE OR REPLACE PROCEDURE update_flight_status(
p_flight_id INT,
p_status VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
UPDATE flights
SET status = p_status
WHERE flight_id = p_flight_id;
END;
$$;
-- 3.	Create a stored procedure that returns a list of flights departing from a specific airport. 
CREATE OR REPLACE PROCEDURE flights_from_airport(
IN p_airport_id INT,
INOUT result_cursor REFCURSOR)
LANGUAGE plpgsql
AS $$
BEGIN
OPEN result_cursor FOR 
SELECT *
FROM flights
WHERE departure_airport_id = p_airport_id;
END;
$$;
-- 4.	Create a function to calculate the average delay time of flights arriving at a specific airport. 
CREATE OR REPLACE FUNCTION average_arrival_delay(
p_airport_id INT)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE avg_delay NUMERIC;
BEGIN
SELECT AVG(
EXTRACT(EPOCH FROM (actual_arrival - scheduled_arrival)) / 60
    )
    INTO avg_delay
    FROM flights
    WHERE arrival_airport_id = p_airport_id
      AND actual_arrival IS NOT NULL
      AND actual_arrival > scheduled_arrival;

    RETURN avg_delay;
END;
$$;
-- 5.	Create a stored procedure that lists all passengers for a given flight number. 
CREATE OR REPLACE PROCEDURE passengers_by_flight(
    IN p_flight_no VARCHAR,
    INOUT result_cursor REFCURSOR
)
LANGUAGE plpgsql
AS $$
BEGIN
    OPEN result_cursor FOR
    SELECT DISTINCT
        p.passenger_id,
        p.first_name,
        p.last_name
    FROM passengers p
    JOIN booking b
        ON p.passenger_id = b.passenger_id
    JOIN booking_flight bf
        ON b.booking_id = bf.booking_id
    JOIN flights f
        ON bf.flight_id = f.flight_id
    WHERE f.flight_no = p_flight_no;
END;
$$;
-- 6.	Create a stored procedure to find the passenger who has taken the greatest number of flights. 
CREATE OR REPLACE PROCEDURE most_frequent_passenger(
    INOUT result_cursor REFCURSOR
)
LANGUAGE plpgsql
AS $$
BEGIN
    OPEN result_cursor FOR
    SELECT
        p.passenger_id,
        p.first_name,
        p.last_name,
        COUNT(DISTINCT bf.flight_id) AS total_flights
    FROM passengers p
    JOIN booking b
        ON p.passenger_id = b.passenger_id
    JOIN booking_flight bf
        ON b.booking_id = bf.booking_id
    GROUP BY
        p.passenger_id,
        p.first_name,
        p.last_name
    ORDER BY total_flights DESC
    LIMIT 1;
END;
$$;
-- 7.	Create a stored procedure to find all flights that are delayed by more than 24 hours.
CREATE OR REPLACE PROCEDURE flights_delayed_24_hours(
    INOUT result_cursor REFCURSOR
)
LANGUAGE plpgsql
AS $$
BEGIN
    OPEN result_cursor FOR
    SELECT *
    FROM flights
    WHERE actual_departure IS NOT NULL
      AND actual_departure - scheduled_departure > INTERVAL '24 hours';
END;
$$;
-- 8.	Create a function that counts the number of flights for each airline. 
CREATE OR REPLACE FUNCTION flights_per_airline()
RETURNS TABLE (
    airline_id INT,
    airline_name VARCHAR,
    total_flights BIGINT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        a.airline_id,
        a.airline_name::VARCHAR,
        COUNT(f.flight_id)
    FROM airline a
    LEFT JOIN flights f
        ON a.airline_id = f.airline_id
    GROUP BY a.airline_id, a.airline_name;
END;
$$;
-- 9.	Create a stored procedure to calculate the average ticket price for a specific flight. 
CREATE OR REPLACE PROCEDURE average_ticket_price(
    IN p_flight_id INT,
    INOUT avg_price NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT AVG(b.ticket_price)
    INTO avg_price
    FROM booking b
    JOIN booking_flight bf
        ON b.booking_id = bf.booking_id
    WHERE bf.flight_id = p_flight_id;
END;
$$;
-- 10.	Create a stored procedure to find the flight with the highest ticket price. The procedure should return the flight number, the departure and arrival airports, and the ticket price for the most expensive flight.
CREATE OR REPLACE PROCEDURE most_expensive_flight(
    INOUT result_cursor REFCURSOR
)
LANGUAGE plpgsql
AS $$
BEGIN
    OPEN result_cursor FOR
    SELECT
        f.flight_no,
        a1.airport_name AS departure_airport,
        a2.airport_name AS arrival_airport,
        b.ticket_price
    FROM flights f
    JOIN booking_flight bf
        ON f.flight_id = bf.flight_id
    JOIN booking b
        ON bf.booking_id = b.booking_id
    JOIN airport a1
        ON f.departure_airport_id = a1.airport_id
    JOIN airport a2
        ON f.arrival_airport_id = a2.airport_id
    ORDER BY b.ticket_price DESC
    LIMIT 1;
END;
$$;
-- 11.	 Create a stored procedure to insert a new passenger into the passengers table. Accept first name, last name, date of birth, gender, citizenship, country of residence, and passport number. 
CREATE OR REPLACE PROCEDURE insert_passenger(
    p_first_name VARCHAR,
    p_last_name VARCHAR,
    p_date_of_birth DATE,
    p_gender VARCHAR,
    p_citizenship VARCHAR,
    p_country_of_residence VARCHAR,
    p_passport_number VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO passengers (
        first_name,
        last_name,
        date_of_birth,
        gender,
        country_of_citizenship,
        country_of_residence,
        passport_number
    )
    VALUES (
        p_first_name,
        p_last_name,
        p_date_of_birth,
        p_gender,
        p_citizenship,
        p_country_of_residence,
        p_passport_number
    );
END;
$$;
-- 12.	 Create a stored procedure to update a passenger's country of residence using passenger_id.
CREATE OR REPLACE PROCEDURE update_passenger_country(
    p_passenger_id INT,
    p_country VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE passengers
    SET country_of_residence = p_country
    WHERE passenger_id = p_passenger_id;
END;
$$;
-- 13.	Create a stored procedure to delete a booking using booking_id. Before deleting it, check whether related records exist in booking_flight, baggage, baggage_check, or boarding_pass. 
CREATE OR REPLACE PROCEDURE delete_booking(
    p_booking_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM booking_flight
        WHERE booking_id = p_booking_id
    )
    OR EXISTS (
        SELECT 1 FROM baggage
        WHERE booking_id = p_booking_id
    )
    OR EXISTS (
        SELECT 1 FROM baggage_check
        WHERE booking_id = p_booking_id
    )
    OR EXISTS (
        SELECT 1 FROM boarding_pass
        WHERE booking_id = p_booking_id
    )
    THEN
        RAISE EXCEPTION 'Booking has related records. Cannot delete.';
    ELSE
        DELETE FROM booking
        WHERE booking_id = p_booking_id;
    END IF;
END;
$$;
-- 14.	 Create a function that returns the total number of passengers from a given country of citizenship. 
CREATE OR REPLACE FUNCTION passengers_by_country(
    p_country VARCHAR
)
RETURNS BIGINT
LANGUAGE plpgsql
AS $$
DECLARE
    total BIGINT;
BEGIN
    SELECT COUNT(*)
    INTO total
    FROM passengers
    WHERE country_of_citizenship = p_country;

    RETURN total;
END;
$$;
-- 15.	 Create a function that calculates the total revenue generated by bookings for a given airline. Use booking, booking_flight, and flights tables. 
CREATE OR REPLACE FUNCTION airline_revenue(
    p_airline_id INT
)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    total_revenue NUMERIC;
BEGIN
    SELECT SUM(b.ticket_price)
    INTO total_revenue
    FROM booking b
    JOIN booking_flight bf
        ON b.booking_id = bf.booking_id
    JOIN flights f
        ON bf.flight_id = f.flight_id
    WHERE f.airline_id = p_airline_id;

    RETURN COALESCE(total_revenue, 0);
END;
$$;
-- 16.	 Create a stored procedure that displays all bookings made by a specific passenger. Include booking_id, booking date, booking status, booking platform, and price. 
CREATE OR REPLACE PROCEDURE passenger_bookings(
    IN p_passenger_id INT,
    INOUT result_cursor REFCURSOR
)
LANGUAGE plpgsql
AS $$
BEGIN
    OPEN result_cursor FOR
    SELECT
        booking_id,
        created_at AS booking_date,
        status AS booking_status,
        booking_platform,
        ticket_price AS price
    FROM booking
    WHERE passenger_id = p_passenger_id;
END;
$$;
-- 17.	Create a stored procedure that finds passengers who have booked more than a specified number of flights. Accept the minimum number of flights as an input parameter. 
CREATE OR REPLACE PROCEDURE frequent_passengers(
    IN p_min_flights INT,
    INOUT result_cursor REFCURSOR
)
LANGUAGE plpgsql
AS $$
BEGIN
    OPEN result_cursor FOR
    SELECT
        p.passenger_id,
        p.first_name,
        p.last_name,
        COUNT(DISTINCT bf.flight_id) AS total_flights
    FROM passengers p
    JOIN booking b
        ON p.passenger_id = b.passenger_id
    JOIN booking_flight bf
        ON b.booking_id = bf.booking_id
    GROUP BY
        p.passenger_id,
        p.first_name,
        p.last_name
    HAVING COUNT(DISTINCT bf.flight_id) > p_min_flights;
END;
$$;
-- 18.	 Create a function that returns the number of flights arriving at a given airport within a specified date range. 
CREATE OR REPLACE FUNCTION flights_by_date_range(
    p_airport_id INT,
    p_start_date TIMESTAMP,
    p_end_date TIMESTAMP
)
RETURNS BIGINT
LANGUAGE plpgsql
AS $$
DECLARE
    total BIGINT;
BEGIN
    SELECT COUNT(*)
    INTO total
    FROM flights
    WHERE arrival_airport_id = p_airport_id
      AND scheduled_arrival BETWEEN p_start_date AND p_end_date;

    RETURN total;
END;
$$;
-- 19.	 Create a stored procedure that updates the status of all bookings older than a specified date to a new status. Accept the date and new status as input parameters. 
CREATE OR REPLACE PROCEDURE update_old_bookings(
    p_date TIMESTAMP,
    p_new_status VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE booking
    SET status = p_new_status
    WHERE created_at < p_date;
END;
$$;
-- 20.	 Create a function that returns a passenger's full name and total number of bookings using passenger_id. Handle the case when the passenger does not exist. 
CREATE OR REPLACE FUNCTION passenger_booking_info(
    p_passenger_id INT
)
RETURNS TABLE (
    full_name TEXT,
    total_bookings BIGINT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM passengers
        WHERE passenger_id = p_passenger_id
    )
    THEN
        RETURN QUERY
        SELECT
            'Passenger not found'::TEXT,
            0::BIGINT;
    ELSE
        RETURN QUERY
        SELECT
            CONCAT(p.first_name, ' ', p.last_name),
            COUNT(b.booking_id)
        FROM passengers p
        LEFT JOIN booking b
            ON p.passenger_id = b.passenger_id
        WHERE p.passenger_id = p_passenger_id
        GROUP BY p.first_name, p.last_name;
    END IF;
END;
$$;

