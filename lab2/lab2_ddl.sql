DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;
SET search_path TO public;
-- 1–4. Tables, primary keys and NOT NULL constraints

CREATE TABLE Airline_info (
    airline_id INT PRIMARY KEY,
    airline_code VARCHAR(30) NOT NULL,
    airline_name VARCHAR(50) NOT NULL,
    airline_country VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    info VARCHAR(50) NOT NULL
);

CREATE TABLE Airport (
    airport_id INT PRIMARY KEY,
    airport_name VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(50) NOT NULL,
    country_of_citizenship VARCHAR(50) NOT NULL,
    country_of_residence VARCHAR(50) NOT NULL,
    passport_number VARCHAR(20) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE Baggage_check (
    baggage_check_id INT PRIMARY KEY,
    check_result VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    booking_id INT NOT NULL,
    passenger_id INT NOT NULL
);

CREATE TABLE Baggage (
    baggage_id INT PRIMARY KEY,
    weight_in_kg DECIMAL(4,2) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    booking_id INT NOT NULL
);

CREATE TABLE Boarding_pass (
    boarding_pass_id INT PRIMARY KEY,
    booking_id INT NOT NULL,
    seat VARCHAR(50) NOT NULL,
    boarding_time TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE Flights (
    flight_id INT PRIMARY KEY,
    sch_departure_time TIMESTAMP NOT NULL,
    sch_arrival_time TIMESTAMP NOT NULL,
    departing_airport_id INT NOT NULL,
    arriving_airport_id INT NOT NULL,
    departing_gate VARCHAR(50) NOT NULL,
    arriving_gate VARCHAR(50) NOT NULL,
    airline_id INT NOT NULL,
    act_departure_time TIMESTAMP NOT NULL,
    act_arrival_time TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE Booking (
    booking_id INT PRIMARY KEY,
    flight_id INT NOT NULL,
    passenger_id INT NOT NULL,
    booking_platform VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    status VARCHAR(50) NOT NULL,
    price DECIMAL(7,2) NOT NULL
);

CREATE TABLE Booking_flight (
    booking_flight_id INT PRIMARY KEY,
    booking_id INT NOT NULL,
    flight_id INT NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE Security_check (
    security_check_id INT PRIMARY KEY,
    check_result VARCHAR(20) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    passenger_id INT NOT NULL
);

-- 5. Rename Airline_info to Airline
ALTER TABLE Airline_info RENAME TO Airline;

-- 6. Rename price to ticket_price
ALTER TABLE Booking RENAME COLUMN price TO ticket_price;

-- 7. Change departing_gate type to TEXT
ALTER TABLE Flights
ALTER COLUMN departing_gate TYPE TEXT;

-- 8. Remove info column
ALTER TABLE Airline
DROP COLUMN info;

-- 9. Relationships

-- Passengers relationships
ALTER TABLE Security_check
ADD CONSTRAINT fk_security_check_passenger
FOREIGN KEY (passenger_id)
REFERENCES Passengers(passenger_id);

ALTER TABLE Booking
ADD CONSTRAINT fk_booking_passenger
FOREIGN KEY (passenger_id)
REFERENCES Passengers(passenger_id);

ALTER TABLE Baggage_check
ADD CONSTRAINT fk_baggage_check_passenger
FOREIGN KEY (passenger_id)
REFERENCES Passengers(passenger_id);

-- Booking relationships
ALTER TABLE Baggage_check
ADD CONSTRAINT fk_baggage_check_booking
FOREIGN KEY (booking_id)
REFERENCES Booking(booking_id);

ALTER TABLE Baggage
ADD CONSTRAINT fk_baggage_booking
FOREIGN KEY (booking_id)
REFERENCES Booking(booking_id);

ALTER TABLE Boarding_pass
ADD CONSTRAINT fk_boarding_pass_booking
FOREIGN KEY (booking_id)
REFERENCES Booking(booking_id);

ALTER TABLE Booking_flight
ADD CONSTRAINT fk_booking_flight_booking
FOREIGN KEY (booking_id)
REFERENCES Booking(booking_id);

-- Booking and Flights relationship
ALTER TABLE Booking
ADD CONSTRAINT fk_booking_flight
FOREIGN KEY (flight_id)
REFERENCES Flights(flight_id);

-- Booking_flight and Flights relationship
ALTER TABLE Booking_flight
ADD CONSTRAINT fk_booking_flight_flight
FOREIGN KEY (flight_id)
REFERENCES Flights(flight_id);

-- Airport and Flights relationships
ALTER TABLE Flights
ADD CONSTRAINT fk_flights_departing_airport
FOREIGN KEY (departing_airport_id)
REFERENCES Airport(airport_id);

ALTER TABLE Flights
ADD CONSTRAINT fk_flights_arriving_airport
FOREIGN KEY (arriving_airport_id)
REFERENCES Airport(airport_id);

-- Airline and Flights relationship
ALTER TABLE Flights
ADD CONSTRAINT fk_flights_airline
FOREIGN KEY (airline_id)
REFERENCES Airline(airline_id);

