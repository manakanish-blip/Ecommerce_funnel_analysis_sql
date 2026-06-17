create database E_Commerce_analytics;
use E_Commerce_analytics;

-- Create Users Table
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    signup_date DATE,
    device_type VARCHAR(20),
    country VARCHAR(50)
);

-- Create Activity Logs Table
CREATE TABLE activity_logs (
    log_id INT PRIMARY KEY,
    user_id INT,
    event_name VARCHAR(50),
    event_timestamp TIMESTAMP,
    revenue_generated DECIMAL(10,2),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Insert Users
INSERT INTO users VALUES 
(1, '2026-05-01', 'iOS', 'India'),
(2, '2026-05-01', 'Android', 'India'),
(3, '2026-05-02', 'iOS', 'USA'),
(4, '2026-05-03', 'Android', 'USA'),
(5, '2026-05-04', 'iOS', 'UK');

-- Insert Funnel Activity Logs
INSERT INTO activity_logs VALUES 
-- User 1: Successful full journey
(101, 1, 'homepage_view', '2026-05-01 10:00:00', 0.00),
(102, 1, 'product_click', '2026-05-01 10:05:00', 0.00),
(103, 1, 'add_to_cart', '2026-05-01 10:12:00', 0.00),
(104, 1, 'purchase', '2026-05-01 10:20:00', 1500.00),

-- User 2: Drops off after product click
(105, 2, 'homepage_view', '2026-05-01 11:00:00', 0.00),
(106, 2, 'product_click', '2026-05-01 11:04:00', 0.00),

-- User 3: Drops off after adding to cart (Cart Abandonment)
(107, 3, 'homepage_view', '2026-05-02 14:00:00', 0.00),
(108, 3, 'product_click', '2026-05-02 14:08:00', 0.00),
(109, 3, 'add_to_cart', '2026-05-02 14:15:00', 0.00),

-- User 4: Successful full journey
(110, 4, 'homepage_view', '2026-05-03 09:00:00', 0.00),
(111, 4, 'product_click', '2026-05-03 09:03:00', 0.00),
(112, 4, 'add_to_cart', '2026-05-03 09:11:00', 0.00),
(113, 4, 'purchase', '2026-05-03 09:15:00', 2200.00),

-- User 5: Drops off immediately at home page (Bounce)
(114, 5, 'homepage_view', '2026-05-04 16:00:00', 0.00);

-- MILE STONE 1:- calculating how many unique users reach each milestone stage of our app experience 
SELECT 
    COUNT(DISTINCT CASE WHEN event_name = 'homepage_view' THEN user_id END) AS unique_homepage_visitors,
    COUNT(DISTINCT CASE WHEN event_name = 'product_click' THEN user_id END) AS unique_clicks,
    COUNT(DISTINCT CASE WHEN event_name = 'add_to_cart' THEN user_id END) AS unique_cart_adds,
    COUNT(DISTINCT CASE WHEN event_name = 'purchase' THEN user_id END) AS unique_buyers
FROM activity_logs;

-- insights:We started with 5 users but only 2 purchased.We have a 40% total conversion rate

-- MILE STONE 2:- CALCULATING THE CONVERSION NUMBER BY device_type
SELECT 
    u.device_type,
    COUNT(DISTINCT u.user_id) AS total_users,
    COUNT(DISTINCT CASE WHEN a.event_name = 'add_to_cart' THEN u.user_id END) AS added_to_cart,
    COUNT(DISTINCT CASE WHEN a.event_name = 'purchase' THEN u.user_id END) AS purchased,
    ROUND(
        (COUNT(DISTINCT CASE WHEN a.event_name = 'purchase' THEN u.user_id END) * 100.0) / 
        COUNT(DISTINCT u.user_id), 2
    ) AS conversion_percentage
FROM users u
LEFT JOIN activity_logs a ON u.user_id = a.user_id
GROUP BY u.device_type;

-- MILE STONE 3:- IDENTIFYING HIGH-VALUE LOST REVENUE
WITH cart_abandoners AS (
    SELECT user_id 
    FROM activity_logs 
    WHERE event_name = 'add_to_cart'
      AND user_id NOT IN (SELECT user_id FROM activity_logs WHERE event_name = 'purchase')
)
SELECT 
    u.user_id,
    u.country,
    u.device_type,
    -- Estimate lost revenue based on average item cost of active buyers
    (SELECT ROUND(AVG(revenue_generated), 2) FROM activity_logs WHERE event_name = 'purchase') AS estimated_lost_revenue
FROM users u
INNER JOIN cart_abandoners ca ON u.user_id = ca.user_id;





