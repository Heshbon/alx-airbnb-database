-- Indexes created
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_checkout_date ON bookings(checkout_date);
CREATE INDEX idx_bookings_checkin_date ON bookings(checkin_date);

CREATE INDEX idx_properties_location_id ON properties(location_id);
CREATE INDEX idx_properties_price ON properties(price);
CREATE INDEX idx_properties_availability_date ON properties(availability_date);

-- EXPLAIN ANALYZE before/after for test queries

-- User bookings by date
EXPLAIN ANALYZE
SELECT u.name, b.checkin_date, b.checkout_date
FROM users u
JOIN bookings b ON u.user_id = b.user_id
WHERE b.checkout_date > '2025-07-05'
ORDER BY b.checkin_date DESC;

-- Available properties by location
EXPLAIN ANALYZE
SELECT p.title, p.price, p.availability_date
FROM properties p
WHERE p.location_id = 1
AND p.price BETWEEN 300 AND 1500
AND p.availability_date > '2025-07-05'
ORDER BY p.price ASC;