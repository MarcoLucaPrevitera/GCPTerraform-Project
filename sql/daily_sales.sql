-- Daily sales analysis

SELECT
    date,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(total_amount), 2) AS daily_revenue
FROM
    `<insert-project-id>.restaurant_analytics.orders`
GROUP BY
    date
ORDER BY
    date;
