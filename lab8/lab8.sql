--1 Create a view to show details of all flights that are departing on a specific date. 
SELECT *
FROM flights
LIMIT 5;

CREATE VIEW flights_on_specific_date AS
SELECT *
FROM flights
WHERE scheduled_departure::DATE = '2023-09-04';

SELECT *
FROM flights_on_specific_date;

--2 Create a view that shows bookings for flights scheduled to depart within the next week. 
CREATE OR REPLACE VIEW bookings_next_week AS
SELECT b.booking_id,
b.price,
b.passenger_id,
f.flight_id,
f.flight_no,
f.scheduled_departure,
f.scheduled_arrival,
f.departure_airport_id,
f.arrival_airport_id,
f.airline_id,
f.status
FROM booking b
JOIN booking_flight bf ON b.booking_id = bf.booking_id
JOIN flights f ON bf.flight_id = f.flight_id
WHERE f.scheduled_departure >= CURRENT_TIMESTAMP
AND f.scheduled_departure < CURRENT_TIMESTAMP + INTERVAL '7 days';

--3 Create a view to show the top 5 most popular flight routes based on the number of bookings.
CREATE VIEW top_5_popular_routes AS
SELECT departure.airport_name AS departure_airport,
arrival.airport_name AS arrival_airport,
COUNT(bf.booking_id) AS total_bookings
FROM booking_flight bf
JOIN flights f ON bf.flight_id = f.flight_id
JOIN airport departure ON f.departure_airport_id = departure.airport_id
JOIN airport arrival ON f.arrival_airport_id = arrival.airport_id
GROUP BY departure.airport_name,
arrival.airport_name
ORDER BY total_bookings DESC
LIMIT 5;

--4 Create a view that lists all flights for a specific airline.
CREATE VIEW flights_for_specific_airline AS
SELECT f.*,
a.airline_name
FROM flights f
JOIN airline a ON f.airline_id = a.airline_id
WHERE a.airline_id = 1;

--5 Modify the view created in task 4 to show only flights departing within the next 7 days for a specific airline. 
CREATE OR REPLACE VIEW airline_flights AS
SELECT f.flight_id,
f.flight_no,
f.scheduled_departure,
f.scheduled_arrival,
f.departure_airport_id,
f.arrival_airport_id,
f.status,
a.airline_name
FROM flights f
JOIN airline a ON f.airline_id = a.airline_id
WHERE a.airline_name = 'Air Astana' AND f.scheduled_departure >= CURRENT_TIMESTAMP
AND f.scheduled_departure < CURRENT_TIMESTAMP + INTERVAL '7 days';

--6 Create a view to show flights that are delayed by more than 24 hours. 
CREATE OR REPLACE VIEW delayed_flights AS
SELECT flight_id,
flight_no,
scheduled_departure,
actual_departure,
status,
actual_departure - scheduled_departure AS delay_days
FROM flights
WHERE actual_departure IS NOT NULL
AND actual_departure - scheduled_departure > 1;

--7 Create a view in which you can display the full name and country of origin of passengers who made bookings on Leffler-Thompson platform. Then show the list of those passengers. 
SELECT table_name,column_name,data_type
FROM information_schema.columns
WHERE table_schema = 'public'
ORDER BY table_name, ordinal_position;

--8 Create a view that shows top 10 most visited countries. 
CREATE OR REPLACE VIEW top_10_visited_countries AS
SELECT a.country,COUNT(*) AS visits
FROM booking_flight bf
JOIN flights f ON bf.flight_id = f.flight_id
JOIN airport a ON f.arrival_airport_id = a.airport_id
GROUP BY a.country
ORDER BY visits DESC
LIMIT 10;

--9 Update any of the created views by adding new information in the view table. Show results. 
CREATE OR REPLACE VIEW top_10_visited_countries AS
SELECT a.country,COUNT(*) AS visits,COUNT(DISTINCT a.airport_id) AS airport_count
FROM booking_flight bf
JOIN flights f ON bf.flight_id = f.flight_id
JOIN airport a ON f.arrival_airport_id = a.airport_id
GROUP BY a.country
ORDER BY visits DESC
LIMIT 10;

--10 Drop all existing views.  
DROP VIEW IF EXISTS
flights_on_specific_date,
bookings_next_week,
top_5_popular_routes,
flights_for_specific_airline,
airline_flights,
delayed_flights,
top_10_visited_countries;

--ROLE
--11 Create the group roles flight_manager and flight_analyst, then show the list of roles. 
CREATE ROLE flight_manager;
CREATE ROLE flight_analyst;
SELECT rolname
FROM pg_roles
ORDER BY rolname;

--12 Create the users first_user and second_user and add them to the group roles. 
CREATE USER first_user WITH PASSWORD 'FirstUser123!';
CREATE USER second_user WITH PASSWORD 'SecondUser123!';

GRANT flight_manager TO first_user;
GRANT flight_analyst TO second_user;

SELECT r.rolname AS group_role,u.rolname AS username
FROM pg_auth_members m
JOIN pg_roles r ON m.roleid = r.oid
JOIN pg_roles u ON m.member = u.oid
WHERE r.rolname IN ('flight_manager', 'flight_analyst')
ORDER BY r.rolname;

SELECT rolname, rolcanlogin
FROM pg_roles
WHERE rolname IN ('flight_manager','flight_analyst','first_user','second_user')
ORDER BY rolname;

--13 Grant flight_analyst SELECT on the flights, airlines and bookings tables. 
GRANT SELECT ON TABLE flights,airline,booking TO flight_analyst;

SELECT grantee,table_name,privilege_type
FROM information_schema.role_table_grants
WHERE grantee = 'flight_analyst'
ORDER BY table_name;

--14 Grant flight_manager SELECT, INSERT and UPDATE on bookings, and SELECT on the other tables. 
GRANT SELECT, INSERT, UPDATE
ON TABLE booking
TO flight_manager;

GRANT SELECT ON ALL TABLES IN SCHEMA public TO flight_manager;

SELECT grantee,table_name,privilege_type
FROM information_schema.role_table_grants
WHERE grantee = 'flight_manager'
ORDER BY table_name, privilege_type;

--17 Grant column-level SELECT on only the full name and country columns of passengers. 
GRANT SELECT (first_name, last_name, country_of_citizenship)
ON passengers
TO flight_analyst;

--18 Revoke SELECT on bookings from flight_analyst and show that access is denied.
REVOKE SELECT ON booking FROM flight_analyst;

--19 Alter the roles: change a password, set a connection limit and rename a role. 
ALTER ROLE first_user
WITH PASSWORD '2007';

ALTER ROLE second_user
CONNECTION LIMIT 5;

ALTER ROLE flight_analyst
RENAME TO flight_analyst_new;

-- Check altered roles
SELECT rolname, rolconnlimit
FROM pg_roles
WHERE rolname IN ('first_user','second_user','flight_analyst_new');

--20Drop all created roles
REVOKE flight_manager FROM first_user;
REVOKE flight_analyst_new FROM second_user;

DROP ROLE first_user;
DROP ROLE second_user;

DROP ROLE flight_manager;
DROP ROLE flight_analyst_new;