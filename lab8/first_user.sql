SELECT current_user;

--16 Connect as first_user, insert and update a booking, and try to delete one. 
INSERT INTO booking (booking_id, passenger_id, price)
SELECT 501, passenger_id, 100.00
FROM passengers
ORDER BY passenger_id
LIMIT 1
RETURNING *;

UPDATE booking
SET price = 150.00
WHERE booking_id = 501;

SELECT * FROM booking
WHERE booking_id = 501;

DELETE FROM booking
WHERE booking_id = 501;