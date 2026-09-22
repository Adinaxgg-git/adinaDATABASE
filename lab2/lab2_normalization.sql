CREATE SCHEMA IF NOT EXISTS lab2_normalization;
SET search_path TO lab2_normalization;

-- 3NF tables
CREATE TABLE passengers (
    passenger_passport_number VARCHAR(20) PRIMARY KEY,
    passenger_full_name VARCHAR(100) NOT NULL
);

CREATE TABLE airports (
    airport_name VARCHAR(50) PRIMARY KEY,
    city VARCHAR(50) NOT NULL
);

CREATE TABLE airlines (
    airline_name VARCHAR(50) PRIMARY KEY
);

CREATE TABLE flights (
    flight_number VARCHAR(20) PRIMARY KEY,
    departure_airport_name VARCHAR(50) NOT NULL,
    arrival_airport_name VARCHAR(50) NOT NULL,
    airline_name VARCHAR(50) NOT NULL,
    CONSTRAINT fk_flights_departure_airport
        FOREIGN KEY (departure_airport_name) REFERENCES airports(airport_name),
    CONSTRAINT fk_flights_arrival_airport
        FOREIGN KEY (arrival_airport_name) REFERENCES airports(airport_name),
    CONSTRAINT fk_flights_airline
        FOREIGN KEY (airline_name) REFERENCES airlines(airline_name)
);

CREATE TABLE bookings (
    booking_id INT PRIMARY KEY,
    flight_number VARCHAR(20) NOT NULL,
    ticket_price DECIMAL(7,2) NOT NULL,
    CONSTRAINT fk_bookings_flight
        FOREIGN KEY (flight_number) REFERENCES flights(flight_number)
);

CREATE TABLE booking_passengers (
    booking_id INT NOT NULL,
    passenger_passport_number VARCHAR(20) NOT NULL,
    seat_number VARCHAR(10) NOT NULL,
    CONSTRAINT pk_booking_passengers
        PRIMARY KEY (booking_id, passenger_passport_number),
    CONSTRAINT fk_booking_passengers_booking
        FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    CONSTRAINT fk_booking_passengers_passenger
        FOREIGN KEY (passenger_passport_number)
        REFERENCES passengers(passenger_passport_number),
    CONSTRAINT uq_booking_passengers_seat
        UNIQUE (booking_id, seat_number)
);

-- The following data is split from a denormalized booking-receipt dataset.
-- Booking 1001 demonstrates the original repeating group: seats 12A and 12B.

INSERT INTO passengers (passenger_passport_number, passenger_full_name) VALUES
    ('N123456', 'John Doe'),
    ('N234567', 'Jane Smith'),
    ('N345678', 'Alex Brown'),
    ('N456789', 'Emily Davis'),
    ('N567890', 'Michael Wilson'),
    ('N678901', 'Sarah Miller');

INSERT INTO airports (airport_name, city) VALUES
    ('JFK International', 'New York'),
    ('Heathrow', 'London'),
    ('Tokyo Haneda', 'Tokyo'),
    ('Charles de Gaulle', 'Paris'),
    ('Dubai International', 'Dubai');

INSERT INTO airlines (airline_name) VALUES
    ('Delta Air Lines'),
    ('British Airways'),
    ('Japan Airlines'),
    ('Air France'),
    ('Emirates');

INSERT INTO flights
    (flight_number, departure_airport_name, arrival_airport_name, airline_name)
VALUES
    ('DL101', 'JFK International', 'Heathrow', 'Delta Air Lines'),
    ('BA202', 'Heathrow', 'Tokyo Haneda', 'British Airways'),
    ('JL303', 'Tokyo Haneda', 'Charles de Gaulle', 'Japan Airlines'),
    ('AF404', 'Charles de Gaulle', 'Dubai International', 'Air France'),
    ('EK505', 'Dubai International', 'JFK International', 'Emirates');

INSERT INTO bookings (booking_id, flight_number, ticket_price) VALUES
    (1001, 'DL101', 900.00),
    (1002, 'BA202', 600.00),
    (1003, 'JL303', 750.00),
    (1004, 'AF404', 520.00),
    (1005, 'EK505', 890.00);

INSERT INTO booking_passengers
    (booking_id, passenger_passport_number, seat_number)
VALUES
    (1001, 'N123456', '12A'),
    (1001, 'N234567', '12B'),
    (1002, 'N345678', '14C'),
    (1003, 'N456789', '02F'),
    (1004, 'N567890', '18D'),
    (1005, 'N678901', '01A');

-- Queries to run for screenshots after executing the script.
SELECT * FROM passengers ORDER BY passenger_passport_number;
SELECT * FROM airports ORDER BY airport_name;
SELECT * FROM airlines ORDER BY airline_name;
SELECT * FROM flights ORDER BY flight_number;
SELECT * FROM bookings ORDER BY booking_id;
SELECT * FROM booking_passengers ORDER BY booking_id, seat_number;
