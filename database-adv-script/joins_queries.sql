-- Retrieves all bookings with their users
SELECT 
    b.booking_id,
    b.checkin_date,
    b.checkout_date,
    u.user_id,
    u.name,
    u.email
FROM 
    bookings b
INNER JOIN 
    users u ON b.user_id = u.user_id
ORDER BY 
    b.checkin_date DESC;
    
    
-- Retrieves all properties and their reviews
SELECT 
    p.property_id,
    p.title,
    p.description,
    r.review_id,
    r.rating,
    r.comment,
    r.created_at
FROM 
    properties p
LEFT JOIN 
    reviews r ON p.property_id = r.property_id
ORDER BY 
    p.property_id;
    
-- Retrieves all users and all bookings
SELECT 
    u.user_id,
    u.name,
    u.email,
    b.booking_id,
    b.checkin_date,
    b.checkout_date,
    b.status
FROM 
    users u
FULL OUTER JOIN 
    bookings b ON u.user_id = b.user_id
ORDER BY 
    COALESCE(u.user_id, b.user_id);