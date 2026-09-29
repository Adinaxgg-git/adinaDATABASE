CREATE SCHEMA IF NOT EXISTS lab2_normalization;
SET search_path TO lab2_normalization;

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
    FOREIGN KEY (departure_airport_name) REFERENCES airports(airport_name),
    FOREIGN KEY (arrival_airport_name) REFERENCES airports(airport_name),
    FOREIGN KEY (airline_name) REFERENCES airlines(airline_name)
);

CREATE TABLE bookings (
    booking_id INT PRIMARY KEY,
    flight_number VARCHAR(20) NOT NULL,
    ticket_price DECIMAL(7,2) NOT NULL,
    FOREIGN KEY (flight_number) REFERENCES flights(flight_number)
);

CREATE TABLE booking_passengers (
    booking_id INT NOT NULL,
    passenger_passport_number VARCHAR(20) NOT NULL,
    seat_number VARCHAR(10) NOT NULL,
    PRIMARY KEY (booking_id, passenger_passport_number),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (passenger_passport_number) REFERENCES passengers(passenger_passport_number)
);

-- Простые тестовые данные
INSERT INTO passengers VALUES ('N123456', 'John Doe'), ('N234567', 'Jane Smith'), ('N345678', 'Alex Brown'), ('N456789', 'Emily Davis'), ('N567890', 'Michael Wilson');
INSERT INTO airports VALUES ('JFK International', 'New York'), ('Heathrow', 'London'), ('Tokyo Haneda', 'Tokyo'), ('Charles de Gaulle', 'Paris'), ('Dubai International', 'Dubai');
INSERT INTO airlines VALUES ('Delta Air Lines'), ('British Airways'), ('Japan Airlines'), ('Air France'), ('Emirates');

INSERT INTO flights VALUES ('DL101', 'JFK International', 'Heathrow', 'Delta Air Lines');
INSERT INTO flights VALUES ('BA202', 'Heathrow', 'Tokyo Haneda', 'British Airways');
INSERT INTO flights VALUES ('JL303', 'Tokyo Haneda', 'Charles de Gaulle', 'Japan Airlines');
INSERT INTO flights VALUES ('AF404', 'Charles de Gaulle', 'Dubai International', 'Air France');
INSERT INTO flights VALUES ('EK505', 'Dubai International', 'JFK International', 'Emirates');

INSERT INTO bookings VALUES (1001, 'DL101', 900.00), (1002, 'BA202', 600.00), (1003, 'JL303', 750.00), (1004, 'AF404', 520.00), (1005, 'EK505', 890.00);
INSERT INTO booking_passengers VALUES (1001, 'N123456', '12A'), (1001, 'N234567', '12B'), (1002, 'N345678', '14C'), (1003, 'N456789', '02F'), (1004, 'N567890', '18D');

SELECT * FROM passengers;
SELECT * FROM airports;
SELECT * FROM airlines;
SELECT * FROM flights;
SELECT * FROM bookings;
SELECT * FROM booking_passengers;