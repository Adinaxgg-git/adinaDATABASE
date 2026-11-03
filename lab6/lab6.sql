--1 Write a query that displays all flights of a specific airline.  
SELECT f.flight_no, a.airline_name
FROM airline a
INNER JOIN flights f
ON a.airline_id=f.airline_id
WHERE airline_name='GYA';

--2 Compose a query to obtain a list of all flights with the names of departure airports.  
SELECT a.airport_name,f.flight_no
FROM flights f
LEFT JOIN airport a
ON f.departure_airport_id=a.airport_id;

--3 Create a query that finds all airlines that have no flights scheduled for the next month.  
SELECT a.airline_name,f.scheduled_departure 
FROM airline a
LEFT JOIN flights f
ON a.airline_id=f.airline_id
AND f.scheduled_departure>=date_trunc('month',CURRENT_DATE)+ INTERVAL '1 month'
AND f.scheduled_departure<date_trunc('month',CURRENT_DATE)+ INTERVAL '2 months'
WHERE f.scheduled_departure IS NULL;

--4 Create a query to display a list of passengers on a specific flight.  
SELECT p.first_name, p.last_name
FROM passengers p
INNER JOIN booking b
ON p.passenger_id=b.passenger_id
INNER JOIN booking_flight f
ON  b.booking_id=f.booking_id
INNER JOIN flights fl
ON fl.flight_id=f.flight_id
WHERE fl.flight_no='RU-KR';

--5 Write a query that calculates the average, total, maximum and minimum price of tickets for each flight.
SELECT f.flight_no,
AVG(b.price),
SUM(b.price),
MAX(b.price),
MIN(b.price)
FROM booking b
INNER JOIN booking_flight bf
ON bf.booking_id=b.booking_id
INNER JOIN flights f
ON bf.flight_id=f.flight_id
GROUP BY f.flight_no;

--6 Create a query that shows all flights flying to a specific country by combining flights, airports and airline, and using the condition on the country name. 
SELECT flight_no
FROM flights f
INNER JOIN airline a
ON a.airline_id=f.airline_id
INNER JOIN airport ai
ON f.airline_id=a.airline_id
WHERE a.airline_name='Brazil'
GROUP BY flight_no;

--7 Display a list of minor passengers and their arrival destination. 
SELECT first_name,last_name
FROM passengers p
INNER JOIN booking b
ON b.passenger_id=p.passenger_id
INNER JOIN booking_flight bf
ON b.booking_id = bf.booking_id
INNER JOIN flights f
ON bf.flight_id = f.flight_id
INNER JOIN airport a
ON f.arrival_airport_id = a.airport_id
WHERE date_of_birth > CURRENT_DATE - INTERVAL '18 years'

--8 Display the passenger’s full name, passport number, and the passenger’s current time of arrival at the destination.  
SELECT p.first_name,
p.last_name,
p.passport_number,
f.scheduled_arrival,
f.actual_arrival
FROM passengers p
INNER JOIN booking b
ON p.passenger_id = b.passenger_id
INNER JOIN booking_flight bf
ON b.booking_id = bf.booking_id
INNER JOIN flights f
ON bf.flight_id = f.flight_id;

--9 Print a list of flights where the airline's home country and origin country are the same. Group them by the airport country. 
SELECT country
FROM airline a
INNER JOIN flights f
ON a.airline_id=f.airline_id
INNER JOIN airport ai
ON ai.airport_id=f.departure_airport_id
WHERE a.airline_country=ai.country
GROUP BY ai.country;

--10 Write a query that lists each flight number, airline name, departure airport, and arrival airport by joining the relevant tables. 
SELECT
f.flight_no,
a.airline_name,
departure.airport_name AS departure_airport,
arrival.airport_name AS arrival_airport
--flight_no из таблицы flights
--airline_name из airline
--сосын airport_name из airport потому что сначала нужно связать departure_airport_id из flights с airport_id в airport и потом вывести airport_name
FROM flights f
INNER JOIN airline a
ON f.airline_id = a.airline_id
INNER JOIN airport departure
ON f.departure_airport_id = departure.airport_id
INNER JOIN airport arrival
ON f.arrival_airport_id = arrival.airport_id;

--11 Display all passengers who have booked tickets for flights operated by a specific airline, including the passenger's full name and flight number. 
SELECT p.first_name,p.last_name,f.flight_no
FROM passengers p
INNER JOIN booking b
ON b.passenger_id = p.passenger_id
INNER JOIN booking_flight bf
ON bf.booking_id = b.booking_id
INNER JOIN flights f
ON f.flight_id = bf.flight_id
INNER JOIN airline a
ON a.airline_id = f.airline_id
WHERE a.airline_country = 'Russia';

--12 Create a query that shows each flight's number, destination country, and number of passengers booked on that flight. Include flights with no booked passengers. 
SELECT f.flight_no,
ai.country AS destination_country,
COUNT(DISTINCT b.passenger_id) AS passenger_count
FROM flights f
LEFT JOIN airport ai
ON f.arrival_airport_id = ai.airport_id
LEFT JOIN booking_flight bf
ON f.flight_id = bf.flight_id
LEFT JOIN booking b
ON bf.booking_id = b.booking_id
GROUP BY f.flight_id,f.flight_no,ai.country;

--13 Find passengers who have not booked any tickets, using an appropriate JOIN operation. 
SELECT p.passenger_id, p.first_name, p.last_name
FROM passengers p
LEFT JOIN booking b
ON p.passenger_id = b.passenger_id
WHERE b.booking_id IS NULL;

--14 Display each airline and the total number of flights it operates, including airlines that currently have no flights. 
SELECT a.airline_name,
COUNT(f.flight_id) AS total_flights
FROM airline a
LEFT JOIN flights f
ON a.airline_id = f.airline_id
GROUP BY a.airline_id,a.airline_name;

--15 List flights departing from airports in a specified country and show the airline name, flight number, and departure airport city. 
SELECT a.airline_name,f.flight_no,
ai.city AS departure_airport_city
FROM flights f
INNER JOIN airline a
ON f.airline_id = a.airline_id
INNER JOIN airport ai
ON f.departure_airport_id = ai.airport_id
WHERE ai.country = 'Kazakhstan';