# Optimization Report

## Query Analysis

```sql
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
ORDER BY 
    b.checkin_date DESC;
```

This query performs multiple joins across large tables and applies a filter and an order, making it expensive without optimization.

## Techniques applied

1. **CTE implementation**
- Enables better query optimization.
- Reduces redundant calculations.

2. **Window function usage**
- Improves performance for ranking operations.
- Reduces data processing overhead.

3. **Join optimization**
- Reduces intermediate result sets.
- Reordered joins for better performance

4. **Index Utilization**
- Improves query execution plan.
- Leveraged existing indexes on join columns.