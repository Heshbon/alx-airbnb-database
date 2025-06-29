-- The users Table
CREATE TABLE users (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    role ENUM('guest', 'host', 'admin') NOT NULL DEFAULT 'guest',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Ptoperties table
CREATE TABLE properties (
    property_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    host_id UUID REFERENCES users(user_id),
    location_id UUID REFERENCES locations(location_id),
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    pricing_id UUID REFERENCES property_pricing(pricing_id),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Booking table
CREATE TABLE bookings (
    booking_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID REFERENCES properties(property_id),
    user_id UUID REFERENCES users(user_id),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (end_date > start_date)
);

-- Payments table
CREATE TABLE payments (
    payment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    booking_id UUID REFERENCES bookings(booking_id),
    amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('credit_card', 'paypal', 'stripe') NOT NULL,
    payment_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(booking_id)
);

CREATE TABLE reviews (
    review_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID REFERENCES properties(property_id),
    user_id UUID REFERENCES users(user_id),
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(property_id, user_id)
);

-- Supporting tables
CREATE TABLE locations (
    location_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20),
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE property_features (
    feature_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID REFERENCES properties(property_id),
    feature_type VARCHAR(50) NOT NULL,
    feature_value VARCHAR(200) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE property_pricing (
    pricing_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID REFERENCES properties(property_id),
    base_rate DECIMAL(10,2) NOT NULL,
    min_stay INTEGER NOT NULL DEFAULT 1,
    max_guests INTEGER NOT NULL,
    cleaning_fee DECIMAL(10,2),
    weekly_discount DECIMAL(4,2),
    monthly_discount DECIMAL(4,2),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE message_threads (
    thread_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    subject VARCHAR(200),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_message_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE messages (
    message_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    thread_id UUID REFERENCES message_threads(thread_id),
    sender_id UUID REFERENCES users(user_id),
    content TEXT NOT NULL,
    sent_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE message_status (
    status_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    message_id UUID REFERENCES messages(message_id),
    recipient_id UUID REFERENCES users(user_id),
    read_at TIMESTAMP,
    delivered_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_properties_host_id ON properties(host_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);
CREATE INDEX idx_payments_booking_id ON payments(booking_id);
CREATE INDEX idx_reviews_property_id ON reviews(property_id);

CREATE INDEX idx_bookings_status_date ON bookings(status, start_date);
CREATE INDEX idx_messages_thread_sender ON messages(thread_id, sender_id);
CREATE INDEX idx_message_status_recipient ON message_status(recipient_id, read_at);

-- Unique constraints
ALTER TABLE users ADD CONSTRAINT uc_users_email UNIQUE(email);
ALTER TABLE properties ADD CONSTRAINT uc_properties_host_location UNIQUE(host_id, location_id);
ALTER TABLE reviews ADD CONSTRAINT uc_reviews_user_property UNIQUE(user_id, property_id);