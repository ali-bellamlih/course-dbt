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

3) On average, how long does an order take from being placed to being delivered? 3.89 days ~ 4 days
```sql
SELECT AVG(DATEDIFF(day, created_at, delivered_at)) AS avg_delivery_time_minutes
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

# W2 SQL Questions

1) What is our user repeat rate? 0.8

```sql
WITH PurchaseCounts AS (
    SELECT 
        user_id,
        COUNT(order_id) AS num_purchases
    FROM 
        DEV_DB.DBT_ABELLAMLIHHOTMAILCOM.STG_ORDERS
    GROUP BY 
        user_id
)
SELECT 
    SUM(CASE WHEN num_purchases >= 2 THEN 1 ELSE 0 END) AS num_repeat_users,
    num_repeat_users / COUNT(*) AS repeat_rate
FROM 
    PurchaseCounts;
```

2) What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

Likely to purchase again: 

- Received his order in time
- Likes to buy during promos -> Check recurrency during promos to forecast buying during future promos
- Bought product that need to be bought recurrently

## License
GPL-3.0
