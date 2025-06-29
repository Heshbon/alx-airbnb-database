-- Helper function to generate random dates
CREATE OR REPLACE FUNCTION generate_random_date(start_date DATE, end_date DATE)
RETURNS DATE AS $$
BEGIN
    RETURN start_date + (random() * (end_date - start_date));
END;
$$ LANGUAGE plpgsql;

-- Helper function to generate random price
CREATE OR REPLACE FUNCTION generate_random_price(min_price DECIMAL, max_price DECIMAL)
RETURNS DECIMAL AS $$
BEGIN
    RETURN round(min_price + (random() * (max_price - min_price)), 2);
END;
$$ LANGUAGE plpgsql;

-- Sample users
INSERT INTO users (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at)
VALUES
    -- Hosts
    (gen_random_uuid(), 'Hesbon', 'Kyp', 'hesbon.host@airbnb.com', 'host312', '555-312-6745', 'host', CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'Didmas', 'Wepukhulu', 'didmas.host@airbnb.com', 'host987', '555-987-2301', 'host', CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'Osotsi', 'Ndimuli', 'osotsi.host@airbnb.com', 'host654', '555-654-9078', 'host', CURRENT_TIMESTAMP),
    
    -- Regular users
    (gen_random_uuid(), 'John', 'Masakhwe', 'john.guest@airbnb.com', 'guest312', '555-342-7856', 'guest', CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'Masanganjira', 'Peter', 'peter.guest@airbnb.com', 'guest987', '555-089-3412', 'guest', CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'Namatsi', 'Namutiru', 'namatsi.guest@airbnb.com', 'guest654', '555-534-8967', 'guest', CURRENT_TIMESTAMP),
    
    -- Admin
    (gen_random_uuid(), 'Admin01', 'User', 'admin_01@airbnb.com', 'admin312', NULL, 'admin', CURRENT_TIMESTAMP);

-- Sample locations
INSERT INTO locations (location_id, city, state, country, postal_code, latitude, longitude, created_at)
VALUES
    (gen_random_uuid(), 'Mumias', 'Kakamega', 'Kenya', '10594', 49.7237, -221.9441, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'Kapsokwony', 'Bungoma', 'Kenya', '21100', 04.2871, -47.6000, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'Msongari', 'Nairobi', 'Kenya', '12900', 43.2205, -811.3724, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'Rumuruti', 'Laikipia', 'Kenya', '11606', 14.8187, -78.9862, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'Thogoto', 'Kiambu', 'Kenya', '10133', 52.1776, -08.1819, CURRENT_TIMESTAMP);

-- Sample property features
INSERT INTO property_features (feature_id, property_id, feature_type, feature_value, created_at)
VALUES
    (gen_random_uuid(), gen_random_uuid(), 'bedrooms', '5', CURRENT_TIMESTAMP),
    (gen_random_uuid(), gen_random_uuid(), 'bathrooms', '3', CURRENT_TIMESTAMP),
    (gen_random_uuid(), gen_random_uuid(), 'sqft', '1399', CURRENT_TIMESTAMP),
    (gen_random_uuid(), gen_random_uuid(), 'bedrooms', '4', CURRENT_TIMESTAMP),
    (gen_random_uuid(), gen_random_uuid(), 'bathrooms', '2', CURRENT_TIMESTAMP),
    (gen_random_uuid(), gen_random_uuid(), 'sqft', '998', CURRENT_TIMESTAMP);

-- Sample property pricing
INSERT INTO property_pricing (pricing_id, property_id, base_rate, min_stay, max_guests, 
                            cleaning_fee, weekly_discount, monthly_discount, created_at)
VALUES
    (gen_random_uuid(), gen_random_uuid(), 2500.00, 1, 5, 65.00, 0.30, 0.15, CURRENT_TIMESTAMP),
    (gen_random_uuid(), gen_random_uuid(), 1500.00, 2, 3, 55.00, 0.20, 0.30, CURRENT_TIMESTAMP),
    (gen_random_uuid(), gen_random_uuid(), 3000.00, 3, 4, 75.00, 0.25, 0.20, CURRENT_TIMESTAMP),
    (gen_random_uuid(), gen_random_uuid(), 2000.00, 2, 2, 70.00, 0.10, 0.22, CURRENT_TIMESTAMP),
    (gen_random_uuid(), gen_random_uuid(), 1800.00, 1, 3, 50.00, 0.05, 0.12, CURRENT_TIMESTAMP);

-- Sample properties
INSERT INTO properties (property_id, host_id, location_id, name, description, pricing_id, created_at)
VALUES
    (gen_random_uuid(), 
     (SELECT user_id FROM users WHERE email = 'hesbon.host@airbnb.com'),
     (SELECT location_id FROM locations WHERE city = 'Mumias'),
     'MM premium',
     'Beautiful premium home in the heart of Mumias. Strictly for families or groups.',
     (SELECT pricing_id FROM property_pricing WHERE base_rate = 2500.00),
     CURRENT_TIMESTAMP),
    
    (gen_random_uuid(),
     (SELECT user_id FROM users WHERE email = 'didmas.host@airbnb.com'),
     (SELECT location_id FROM locations WHERE city = 'Thogoto'),
     'TGT Apartment',
     'Modern apartment in Thogoto with stunning forest views. Close to all major attractions.',
     (SELECT pricing_id FROM property_pricing WHERE base_rate = 1500.00),
     CURRENT_TIMESTAMP),
    
    (gen_random_uuid(),
     (SELECT user_id FROM users WHERE email = 'osotsi.host@airbnb.com'),
     (SELECT location_id FROM locations WHERE city = 'Rumuruti'),
     'RM House',
     'RM property with private access to ranches. Perfect for a relaxing and vocation.',
     (SELECT pricing_id FROM property_pricing WHERE base_rate = 3000.00),
     CURRENT_TIMESTAMP);

-- Sample bookings
INSERT INTO bookings (booking_id, property_id, user_id, start_date, end_date, 
                     total_price, status, created_at)
VALUES
    (gen_random_uuid(),
     (SELECT property_id FROM properties WHERE name = 'MM premium'),
     (SELECT user_id FROM users WHERE email = 'John.guest@airbnb.com'),
     CURRENT_DATE + INTERVAL '5 days',
     CURRENT_DATE + INTERVAL '12 days',
     17500.00,
     'confirmed',
     CURRENT_TIMESTAMP),
    
    (gen_random_uuid(),
     (SELECT property_id FROM properties WHERE name = 'TGT Apartment'),
     (SELECT user_id FROM users WHERE email = 'peter.guest@airbnb.com'),
     CURRENT_DATE + INTERVAL '7 days',
     CURRENT_DATE + INTERVAL '14 days',
     10500.00,
     'confirmed',
     CURRENT_TIMESTAMP),
    
    (gen_random_uuid(),
     (SELECT property_id FROM properties WHERE name = 'RM House'),
     (SELECT user_id FROM users WHERE email = 'namatsi.guest@airbnb.com'),
     CURRENT_DATE + INTERVAL '14 days',
     CURRENT_DATE + INTERVAL '21 days',
     21000.00,
     'pending',
     CURRENT_TIMESTAMP);

-- Sample payments
INSERT INTO payments (payment_id, booking_id, amount, payment_method, payment_date)
VALUES
    (gen_random_uuid(),
     (SELECT booking_id FROM bookings WHERE status = 'confirmed' LIMIT 1),
     17500.00,
     'credit_card',
     CURRENT_TIMESTAMP),
    
    (gen_random_uuid(),
     (SELECT booking_id FROM bookings WHERE status = 'confirmed' LIMIT 1 OFFSET 1),
     10500.00,
     'paypal',
     CURRENT_TIMESTAMP);

-- Sample reviews
INSERT INTO reviews (review_id, property_id, user_id, rating, comment, created_at)
VALUES
    (gen_random_uuid(),
     (SELECT property_id FROM properties WHERE name = 'MM premium'),
     (SELECT user_id FROM users WHERE email = 'john.guest@airbnb.com'),
     5,
     'Amazing set-up! Comfortable, clean, and perfect place. Would definitely make reservation again.',
     CURRENT_TIMESTAMP),
    
    (gen_random_uuid(),
     (SELECT property_id FROM properties WHERE name = 'TGT Apartment'),
     (SELECT user_id FROM users WHERE email = 'peter.guest@airbnb.com'),
     4,
     'Great apartment with excellent views. Only challenge was the noise from the streets nearby.',
     CURRENT_TIMESTAMP);

-- Sample message threads
INSERT INTO message_threads (thread_id, subject, created_at, last_message_at)
VALUES
    (gen_random_uuid(), 'Booking Enquiry for MM premium', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'TGT Apartment Availability', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Sample messages
INSERT INTO messages (message_id, thread_id, sender_id, content, sent_at)
VALUES
    (gen_random_uuid(),
     (SELECT thread_id FROM message_threads WHERE subject = 'Booking Enquiry for MM premium'),
     (SELECT user_id FROM users WHERE email = 'john.guest@airbnb.com'),
     'Hi Hesbon, I\'m interested in booking your MM premium home for my family vacation. Is it available in August?',
     CURRENT_TIMESTAMP),
    
    (gen_random_uuid(),
     (SELECT thread_id FROM message_threads WHERE subject = 'Booking Enquiry for MM premium'),
     (SELECT user_id FROM users WHERE email = 'sarah.host@airbnb.com'),
     'Hi John, yes it\'s available in August. Would you like to proceed with reservations?',
     CURRENT_TIMESTAMP);

-- Sample message status
INSERT INTO message_status (status_id, message_id, recipient_id, delivered_at)
VALUES
    (gen_random_uuid(),
     (SELECT message_id FROM messages WHERE content LIKE 'Hi Hesbon%'),
     (SELECT user_id FROM users WHERE email = 'hesbon.host@airbnb.com'),
     CURRENT_TIMESTAMP),
    
    (gen_random_uuid(),
     (SELECT message_id FROM messages WHERE content LIKE 'Hi John%'),
     (SELECT user_id FROM users WHERE email = 'john.guest@airbnb.com'),
     CURRENT_TIMESTAMP);