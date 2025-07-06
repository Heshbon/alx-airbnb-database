# Index Performance Analysis

This document tracks the performance impact of indexes on the ALX Airbnb Database Module.

---

## Before Indexes

```sql
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
AND p.price BETWEEN 1500 AND 300
AND p.availability_date > '2025-07-05'
ORDER BY p.price ASC;