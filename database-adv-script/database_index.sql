-- Users table
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_users_created_at ON users(created_at);

-- Bookings table
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);
CREATE INDEX idx_bookings_checkin_date ON bookings(checkin_date);
CREATE INDEX idx_bookings_checkout_date ON bookings(checkout_date);
CREATE INDEX idx_bookings_status ON bookings(status);

-- Properties table
CREATE INDEX idx_properties_location_id ON properties(location_id);
CREATE INDEX idx_properties_price ON properties(price);
CREATE INDEX idx_properties_availability_date ON properties(availability_date);
CREATE INDEX idx_properties_status ON properties(status);

-- Frequent queries composite
CREATE INDEX idx_bookings_user_checkin ON bookings(user_id, checkin_date);
CREATE INDEX idx_properties_location_price ON properties(location_id, price);