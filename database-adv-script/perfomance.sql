-- Complex query
EXPLAIN ANALYZE
SELECT 
    u.user_id,
    u.name,
    u.email,
    p.property_id,
    p.title,
    p.description,
    b.booking_id,
    b.checkin_date,
    b.checkout_date,
    b.total_amount,
    pm.payment_method,
    pm.transaction_id
FROM 
    users u
    JOIN bookings b ON u.user_id = b.user_id
    JOIN properties p ON b.property_id = p.property_id
    LEFT JOIN payments pm ON b.booking_id = pm.booking_id
WHERE 
    b.checkout_date > '2025-07-05'
    AND p.price > 0
ORDER BY 
    b.checkin_date DESC;

-- Optimized functions
EXPLAIN ANALYZE
WITH ranked_bookings AS (
    SELECT 
        b.booking_id,
        b.user_id,
        b.property_id,
        b.checkin_date,
        b.checkout_date,
        b.total_amount,
        ROW_NUMBER() OVER (
            PARTITION BY b.user_id 
            ORDER BY b.checkin_date DESC
        ) as booking_rank
    FROM bookings b
    WHERE b.checkout_date > '2025-07-06'
)
SELECT 
    u.user_id,
    u.name,
    u.email,
    p.property_id,
    p.title,
    p.description,
    rb.booking_id,
    rb.checkin_date,
    rb.checkout_date,
    rb.total_amount,
    pm.payment_method,
    pm.transaction_id
FROM ranked_bookings rb
JOIN users u ON rb.user_id = u.user_id
JOIN properties p ON rb.property_id = p.property_id
LEFT JOIN payments pm ON rb.booking_id = pm.booking_id
ORDER BY rb.checkin_date DESC;