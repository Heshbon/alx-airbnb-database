-- User booking counts
SELECT 
    u.user_id,
    u.name,
    u.email,
    COUNT(b.booking_id) as total_bookings
FROM 
    users u
    LEFT JOIN bookings b ON u.user_id = b.user_id
GROUP BY 
    u.user_id, u.name, u.email
ORDER BY 
    total_bookings DESC;

-- Property rankings
WITH property_bookings AS (
    SELECT 
        p.property_id,
        p.title,
        COUNT(b.booking_id) as total_bookings
    FROM 
        properties p
        LEFT JOIN bookings b ON p.property_id = b.property_id
    GROUP BY 
        p.property_id, p.title
)
SELECT 
    property_id,
    title,
    total_bookings,
    ROW_NUMBER() OVER (ORDER BY total_bookings DESC) as row_num,
    RANK() OVER (ORDER BY total_bookings DESC) as ranking
FROM 
    property_bookings
ORDER BY 
    total_bookings DESC;