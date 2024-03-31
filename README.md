# Analytics engineering with dbt

Template repository for the projects and environment of the course: Analytics engineering with dbt

> Please note that this sets some environment variables so if you create some new terminals please load them again.

# W1 SQL questions

1) Number of users: 130 

``` sql 
SELECT count(*)
from dev_db.dbt_abellamlihhotmailcom.stg_users
```

2) On average, how many orders do we receive per hour? : 7.52

```sql
SELECT COUNT(order_id) / (DATEDIFF(HOUR, MIN(created_at), MAX(created_at)) + 1) AS avg_orders_per_hour
FROM dev_db.dbt_abellamlihhotmailcom.stg_orders
```

3) On average, how long does an order take from being placed to being delivered?
```sql
SELECT AVG(DATEDIFF(MINUTE, created_at, delivered_at)) AS avg_delivery_time_minutes
FROM dev_db.dbt_abellamlihhotmailcom.stg_orders
WHERE delivered_at IS NOT NULL;
```

4) How many users have only made one purchase? Two purchases? Three+ purchases?
- 1: 25
- 2: 28
- 3+: 71 

```sql
SELECT 
    CASE 
        WHEN num_purchases = 1 THEN 'One purchase'
        WHEN num_purchases = 2 THEN 'Two purchases'
        ELSE 'Three or more purchases'
    END AS purchase_category,
    COUNT(user_id) AS num_users
FROM (
    SELECT 
        user_id,
        COUNT(order_id) AS num_purchases
    FROM dev_db.dbt_abellamlihhotmailcom.stg_orders
    GROUP BY user_id
) AS user_purchases
GROUP BY 
    CASE 
        WHEN num_purchases = 1 THEN 'One purchase'
        WHEN num_purchases = 2 THEN 'Two purchases'
        ELSE 'Three or more purchases'
    END;
```

5) On average, how many unique sessions do we have per hour? ~10

```sql 
SELECT 
    COUNT(DISTINCT session_id) / (DATEDIFF(HOUR, MIN(created_at), MAX(created_at)) + 1) AS avg_sessions_per_hour
FROM 
    DEV_DB.DBT_ABELLAMLIHHOTMAILCOM.STG_EVENTS;
```

## License
GPL-3.0
