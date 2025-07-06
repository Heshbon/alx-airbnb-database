-- Finds properties with average rating > 4.0
SELECT 
    p.property_id,
    p.title,
    p.description,
    AVG(r.rating) as average_rating
FROM 
    properties p
    LEFT JOIN reviews r ON p.property_id = r.property_id
GROUP BY 
    p.property_id, p.title, p.description
HAVING 
    AVG(r.rating) > 4.0
ORDER BY 
    average_rating DESC;

-- Find users with more than 3 bookings (correlated subquery)
SELECT 
    u.user_id,
    u.name,
    u.email,
    (SELECT COUNT(*) 
     FROM bookings b 
     WHERE b.user_id = u.user_id) as booking_count
FROM 
    users u
WHERE 
    (SELECT COUNT(*) 
     FROM bookings b 
     WHERE b.user_id = u.user_id) > 3
ORDER BY 
    booking_count DESC;