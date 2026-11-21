-- Top selling products

SELECT
    product,
    SUM(quantity) AS units_sold,
    ROUND(SUM(total_amount), 2) AS revenue
FROM
    `<insert-project-id>.restaurant_analytics.orders`
GROUP BY
    product
ORDER BY
    units_sold DESC;
