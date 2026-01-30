-- Customer & Order Fundamentals
-- Question 01
Select count (distinct order_id) as TotalOrders
from public."FactOrders";

-- Question 02
Select count (distinct customer_id) as TotalCustomers
from public."FactOrders";

-- Question 03
Select c.city, count(o.order_id) as TotalOrders
From public."FactOrders" o
Join "DimCustomers" c
on o.customer_id = c.customer_id
group by c.city
order by TotalOrders Desc
Limit 1;

-- Question 04
WITH CustomerOrders AS (
    SELECT customer_id, COUNT(order_id) AS OrderCount
    FROM "FactOrders"
    GROUP BY customer_id
)
SELECT 
    ROUND(
        100.0 * SUM(CASE WHEN OrderCount > 1 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS RepeatCustomerPercentage
FROM CustomerOrders;

-- Question 05
SELECT
    DATE_TRUNC('month', order_date::date) AS OrderMonth,
    COUNT(order_id) AS TotalOrders
FROM "FactOrders"
GROUP BY DATE_TRUNC('month', order_date::date)
ORDER BY OrderMonth;

-- Revenue & Product Performance
-- Question 06
SELECT 
    SUM(foi.quantity * p.unit_price) AS TotalRevenue
FROM "FactOrderItems" foi
JOIN "DimProducts" p
    ON foi.product_id = p.product_id;

-- Question 07
SELECT 
    p.category,
    SUM(foi.quantity * p.unit_price) AS CategoryRevenue
FROM "FactOrderItems" foi
JOIN "DimProducts" p
    ON foi.product_id = p.product_id
GROUP BY p.category
ORDER BY CategoryRevenue DESC
limit 1;

-- Question 08
SELECT 
    p.product_name,
    SUM(foi.quantity * p.unit_price) AS ProductRevenue
FROM "FactOrderItems" foi
JOIN "DimProducts" p
    ON foi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY ProductRevenue DESC
LIMIT 1;

-- Question 09
WITH OrderSummary AS (
    SELECT 
        o.order_id,
        SUM(foi.quantity * p.unit_price) AS OrderValue,
        SUM(foi.quantity) AS TotalItems
    FROM "FactOrders" o
    JOIN "FactOrderItems" foi
        ON o.order_id = foi.order_id
    JOIN "DimProducts" p
        ON foi.product_id = p.product_id
    GROUP BY o.order_id
)
SELECT 
    ROUND(AVG(OrderValue), 2) AS AverageOrderValue,
    ROUND(AVG(TotalItems), 2) AS AverageBasketSize
FROM OrderSummary;

-- Question 10
SELECT 
    p.product_name,
    SUM(foi.quantity) AS TotalSold,
    p.stock
FROM "FactOrderItems" foi
JOIN "DimProducts" p
    ON foi.product_id = p.product_id
GROUP BY p.product_name, p.stock
HAVING p.stock < 200
ORDER BY TotalSold DESC;

-- Customer Behavior & Segmentation
-- Question 11
SELECT 
    c.customer_id,
    c.full_name,
    SUM(foi.quantity * p.unit_price) AS TotalRevenue
FROM "FactOrders" o
JOIN "DimCustomers" c
    ON o.customer_id = c.customer_id
JOIN "FactOrderItems" foi
    ON o.order_id = foi.order_id
JOIN "DimProducts" p
    ON foi.product_id = p.product_id
GROUP BY c.customer_id, c.full_name
ORDER BY TotalRevenue DESC
LIMIT 1;

-- Question 12
WITH OrderItemsCount AS (
    SELECT 
        order_id,
        SUM(quantity) AS TotalItems
    FROM "FactOrderItems"
    GROUP BY order_id
)
SELECT 
    ROUND(AVG(TotalItems), 2) AS AvgProductsPerOrder
FROM OrderItemsCount;

-- Question 13
SELECT
    c."Gender",
    p.category,
    SUM(foi.quantity) AS TotalQuantityPurchased
FROM "FactOrders" o
JOIN "DimCustomers" c
    ON o.customer_id = c.customer_id
JOIN "FactOrderItems" foi
    ON o.order_id = foi.order_id
JOIN "DimProducts" p
    ON foi.product_id = p.product_id
GROUP BY c."Gender", p.category
ORDER BY c."Gender", TotalQuantityPurchased DESC;

-- Question 14
WITH OrderValue AS (
    SELECT 
        o.order_id,
        c.city,
        SUM(foi.quantity * p.unit_price) AS OrderAmount
    FROM "FactOrders" o
    JOIN "DimCustomers" c
        ON o.customer_id = c.customer_id
    JOIN "FactOrderItems" foi
        ON o.order_id = foi.order_id
    JOIN "DimProducts" p
        ON foi.product_id = p.product_id
    GROUP BY o.order_id, c.city
)
SELECT 
    city,
    ROUND(AVG(OrderAmount), 2) AS AverageOrderValue
FROM OrderValue
GROUP BY city
ORDER BY AverageOrderValue DESC
Limit 1;

-- Question 15
SELECT
    CASE
        WHEN (o.order_date::date - c.created_at::date) <= 30 THEN '0–30 days'
        WHEN (o.order_date::date - c.created_at::date) <= 90 THEN '31–90 days'
        ELSE '90+ days'
    END AS CustomerAgeGroup,
    COUNT(DISTINCT o.order_id) AS TotalOrders,
    ROUND(SUM(foi.quantity * p.unit_price), 2) AS TotalRevenue
FROM "FactOrders" o
JOIN "DimCustomers" c
    ON o.customer_id = c.customer_id
JOIN "FactOrderItems" foi
    ON o.order_id = foi.order_id
JOIN "DimProducts" p
    ON foi.product_id = p.product_id
GROUP BY CustomerAgeGroup
ORDER BY CustomerAgeGroup;

-- Payment & Order Flow Insights
-- Question 16
SELECT 
    "method",
    COUNT(order_id) AS TotalOrders
FROM "FactPayment"
GROUP BY "method"
ORDER BY TotalOrders DESC;

-- Question 17
SELECT 
    p.method,
    o.status,
    COUNT(o.order_id) AS TotalOrders
FROM "FactOrders" o
JOIN "FactPayment" p
    ON o.order_id = p.order_id
GROUP BY p.method, o.status
ORDER BY p.method, TotalOrders DESC;

-- Question 18
SELECT 
    c.city,
    p.method,
    COUNT(o.order_id) AS TotalOrders
FROM "FactOrders" o
JOIN "DimCustomers" c
    ON o.customer_id = c.customer_id
JOIN "FactPayment" p
    ON o.order_id = p.order_id
GROUP BY c.city, p.method
ORDER BY c.city, TotalOrders DESC;


-- Question 19
WITH OrderValue AS (
    SELECT 
        o.order_id,
        p.method,
        SUM(foi.quantity * d.unit_price) AS OrderAmount
    FROM "FactOrders" o
    JOIN "FactPayment" p
        ON o.order_id = p.order_id
    JOIN "FactOrderItems" foi
        ON o.order_id = foi.order_id
    JOIN "DimProducts" d
        ON foi.product_id = d.product_id
    GROUP BY o.order_id, p.method
)
SELECT 
    method,
    ROUND(AVG(OrderAmount), 2) AS AvgOrderValue
FROM OrderValue
GROUP BY method
ORDER BY AvgOrderValue DESC
limit 1;

-- Question 20
WITH OrderItems AS (
    SELECT 
        o.order_id,
        p.method,
        SUM(foi.quantity) AS TotalItems
    FROM "FactOrders" o
    JOIN "FactPayment" p
        ON o.order_id = p.order_id
    JOIN "FactOrderItems" foi
        ON o.order_id = foi.order_id
    GROUP BY o.order_id, p.method
)
SELECT 
    method,
    ROUND(AVG(TotalItems), 2) AS AvgItemsPerOrder
FROM OrderItems
GROUP BY method
ORDER BY AvgItemsPerOrder DESC;

-- Advance Product & Basket Analysis
-- Question 21
SELECT
    p1.product_name AS Product1,
    p2.product_name AS Product2,
    COUNT(*) AS TimesOrderedTogether
FROM "FactOrderItems" foi1
JOIN "FactOrderItems" foi2
    ON foi1.order_id = foi2.order_id
    AND foi1.product_id < foi2.product_id
JOIN "DimProducts" p1
    ON foi1.product_id = p1.product_id
JOIN "DimProducts" p2
    ON foi2.product_id = p2.product_id
GROUP BY p1.product_name, p2.product_name
ORDER BY TimesOrderedTogether DESC
LIMIT 1;

-- Question 22
SELECT
    p1.product_name AS ProductA,
    p2.product_name AS ProductB,
    COUNT(*) AS PairFrequency
FROM "FactOrderItems" f1
JOIN "FactOrderItems" f2
    ON f1.order_id = f2.order_id
    AND f1.product_id < f2.product_id
JOIN "DimProducts" p1
    ON f1.product_id = p1.product_id
JOIN "DimProducts" p2
    ON f2.product_id = p2.product_id
GROUP BY p1.product_name, p2.product_name
ORDER BY PairFrequency DESC
LIMIT 10;

-- Question 23
WITH OrderPairs AS (
    SELECT
        o.order_id,
        p1.product_name AS ProductA,
        p2.product_name AS ProductB,
        SUM(
            (f1.quantity * p1.unit_price) +
            (f2.quantity * p2.unit_price)
        ) AS OrderValue
    FROM "FactOrders" o
    JOIN "FactOrderItems" f1
        ON o.order_id = f1.order_id
    JOIN "FactOrderItems" f2
        ON o.order_id = f2.order_id
        AND f1.product_id < f2.product_id
    JOIN "DimProducts" p1
        ON f1.product_id = p1.product_id
    JOIN "DimProducts" p2
        ON f2.product_id = p2.product_id
    GROUP BY o.order_id, p1.product_name, p2.product_name
)
SELECT
    ProductA,
    ProductB,
    ROUND(AVG(OrderValue), 2) AS AvgOrderValue
FROM OrderPairs
GROUP BY ProductA, ProductB
ORDER BY AvgOrderValue DESC
LIMIT 10;

-- Question 24
SELECT
    p1.product_name AS BundleProduct1,
    p2.product_name AS BundleProduct2,
    COUNT(*) AS BundleFrequency
FROM "FactOrderItems" f1
JOIN "FactOrderItems" f2
    ON f1.order_id = f2.order_id
    AND f1.product_id < f2.product_id
JOIN "DimProducts" p1 ON f1.product_id = p1.product_id
JOIN "DimProducts" p2 ON f2.product_id = p2.product_id
GROUP BY p1.product_name, p2.product_name
HAVING COUNT(*) > 20
ORDER BY BundleFrequency DESC;

-- Question 25
SELECT
    p.product_name,
    COUNT(DISTINCT foi.order_id) AS OrdersAppeared
FROM "FactOrderItems" foi
JOIN "DimProducts" p
    ON foi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY OrdersAppeared DESC
LIMIT 10;