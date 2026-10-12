--TASK 1 Add a CHECK constraint to passenger table to provide that passengers must be at least 10 years old. 
ALTER TABLE passengers
ADD CONSTRAINT check_passengers_min_age
CHECK (date_of_birth<=(CURRENT_DATE - INTERVAL '10 years'):: date);

--TASK 2 Add a CHECK constraint to accept values in  booking price not more than 50000tg and less than 0tg. 
ALTER TABLE booking
ADD CONSTRAINT check_booking_price
CHECK (price>=0 AND price<=500000);

--TASK 3 Add a CHECK constraint to accept  the luggage weight between 1 and 23 kg. 
ALTER TABLE baggage
ADD CONSTRAINT check_baggage_weight
CHECK (weight_in_kg BETWEEN 1 AND 23)
NOT VALID;

--TASK 4 Add a CHECK constraint to ensure that all  values in airport_name must have at least 10 characters.
ALTER TABLE airport
ADD CONSTRAINT check_airport_name
CHECK (char_length(airport_name)>=10);

--TASK 5 Add UNIQUE constraint to some columns in each table in database.  
ALTER TABLE passengers
ADD CONSTRAINT uq_passengers_passport
UNIQUE (passport_number);

ALTER TABLE airline
ADD CONSTRAINT uq_airline_code
UNIQUE (airline_code);

ALTER TABLE flights
ADD CONSTRAINT uq_flight_id
UNIQUE (flight_id);

-- TASK 6 Add a CHECK constraint to ensure that male passengers must be at least 18 years old and female passengers must be 19 years old. 
ALTER TABLE passengers
ADD CONSTRAINT check_genger_and_age
CHECK (
(LOWER(gender)='male' AND date_of_birth<=(CURRENT_DATE-INTERVAL '18 years'):: date)
OR
(LOWER(gender)='female' AND date_of_birth<=(CURRENT_DATE-INTERVAL '19 years'):: date)
)
NOT VALID;

--TASK 7 Add a CHECK constraint to add rule as follow (use column country_of_citizenship):  
--Passengers from Kazakhstan must be at least 18 years old. 
--Passengers from France must be at least 17 years old. 
--Passengers from other countries must be at least 19 years old.
ALTER TABLE passengers
ADD CONSTRAINT check_citizenship
CHECK (
(LOWER(country_of_citizenship)='kazakhstan' AND date_of_birth<=(CURRENT_DATE-INTERVAL '18 years'):: date)
OR
(LOWER(country_of_citizenship)='france' AND date_of_birth<=(CURRENT_DATE-INTERVAL '17 years'):: date)
OR
(LOWER(country_of_citizenship) NOT IN ('kazakhstan','france') AND date_of_birth<=(CURRENT_DATE-INTERVAL '19 years'):: date)
)
NOT VALID;

--TASK 8 Add a ticket_discount column to table booking and a CHECK constraint to apply some discount based on ticket price and created time:  
--the constraint applies a 5% discount for tickets created after 2024-01-01, 
--and 10% discount for tickets created before 2024-01-01. 
ALTER TABLE booking
ADD COLUMN ticket_discount NUMERIC(4,2);
ALTER TABLE booking
ADD CONSTRAINT check_ticket_discount
CHECK ((created_at > '2024-01-01' AND ticket_discount = 0.05) OR (created_at <= '2024-01-01' AND ticket_discount = 0.10))
NOT VALID;

--TASK 9 Modify the booking table so that the booking status column has a default value of 'Confirmed'. Then insert a new booking without specifying booking status. 
ALTER TABLE booking
ALTER COLUMN status SET DEFAULT 'Confirmed';
INSERT INTO booking (booking_id, passenger_id, price, created_at)
VALUES (1002, 5, 20000, '2026-06-01');
SELECT * FROM booking WHERE booking_id = 1002;

--TASK 10 Modify the appropriate date column in the database so that when a new record is inserted, the date is automatically set to the current date. 
ALTER TABLE booking
ALTER COLUMN created_at SET DEFAULT CURRENT_DATE;
INSERT INTO booking (booking_id, passenger_id, price)
VALUES (1000, 6, 15000);
SELECT * FROM booking WHERE booking_id = 1000;

