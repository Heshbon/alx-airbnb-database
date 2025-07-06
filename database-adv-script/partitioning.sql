-- Partitioned bookings table
CREATE TABLE bookings (
    booking_id UUID DEFAULT uuid_generate_v4(),
    user_id INTEGER,
    property_id INTEGER,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_amount DECIMAL(10,2),
    status VARCHAR(50),
    PRIMARY KEY (booking_id, start_date)
) PARTITION BY RANGE (start_date);

-- Different date ranges partitioning
CREATE TABLE bookings_2023 PARTITION OF bookings
FOR VALUES FROM ('2024-07-05') TO ('2025-07-05')
TABLESPACE ssd_tablespace;

CREATE TABLE bookings_2024 PARTITION OF bookings
FOR VALUES FROM ('2024-07-05') TO ('2025-07-05')
TABLESPACE ssd_tablespace;

CREATE TABLE bookings_future PARTITION OF bookings
FOR VALUES FROM ('2026-07-05') TO ('2026-07-05')
TABLESPACE ssd_tablespace;

-- Indexes on each partition
CREATE INDEX idx_bookings_2023_start_date ON bookings_2023(start_date);
CREATE INDEX idx_bookings_2024_start_date ON bookings_2024(start_date);
CREATE INDEX idx_bookings_future_start_date ON bookings_future(start_date);

-- Queries test
EXPLAIN ANALYZE
SELECT * FROM bookings 
WHERE start_date >= '2023-01-01' AND start_date < '2024-01-01';

EXPLAIN ANALYZE
SELECT * FROM bookings 
WHERE start_date >= '2024-01-01' AND start_date < '2025-01-01';

-- Commands maintanance
SELECT table_name, total_bytes, used_bytes, free_bytes
FROM table_size('bookings');

SELECT schemaname, relname AS tablename,
       indexrelname AS indexname,
       idx_scan AS index_scans
FROM pg_stat_user_indexes
WHERE schemaname = 'public'
ORDER BY idx_scan DESC;