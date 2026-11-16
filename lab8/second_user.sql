SELECT current_user;

--15 Connect as second_user, read flights and try to delete from bookings. 
SELECT *
FROM flights
LIMIT 10;

DELETE FROM booking
WHERE booking_id = 1;