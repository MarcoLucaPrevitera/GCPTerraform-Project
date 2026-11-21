-- Sales analysis by product

SELECT
    product,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(total_amount), 2) AS revenue
FROM
    `<insert-project-id>.restaurant_analytics.orders`
GROUP BY
    product
ORDER BY
    revenue DESC;
