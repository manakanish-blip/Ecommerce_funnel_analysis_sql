# E-Commerce Product Analytics & Funnel Optimization (SQL)

## 📌 Project Overview
This project simulates a real-world product analytics task for an e-commerce platform. Using synthetic customer data and tracking logs, I constructed a relational schema to analyze the user conversion funnel, identify critical drop-off points, and pinpoint underperforming user channels to recover lost revenue.

## 🛠️ Tech Stack & Tools
- **Database Engine:** PostgreSQL / MySQL (Standard Relational SQL)
- **Concepts Used:** Joins, Subqueries, Conditional Aggregations (`CASE WHEN`), Common Table Expressions (CTEs)

## 📊 Database Schema
The analysis relies on two primary interconnected tables:
1. `users`: Contains user demographics, registration dates, and device types.
2. `activity_logs`: Contains individual user action events (`homepage_view`, `product_click`, `add_to_cart`, `purchase`) along with generated timestamps and values.

## 📈 Key Insights & Business Impact
- **Overall Conversion:** The platform has a **40% total conversion rate** from homepage view to checkout completion. 
- **Device Performance Vulnerability:** Android users convert at a healthy **50%**, while iOS users lag behind at **33.33%**. Despite higher cart addition volume on iOS, users drop off at checkout, signaling a potential payment gateway UI friction point on the iOS build.
- **Revenue Recovery Opportunity:** Identified specific target user segments who abandoned high-value shopping carts. Re-engaging these specific cohorts can recover an estimated **$1,850.00** in revenue.

## 📂 How to Run the Code
1. Execute the scripts in `1_database_setup.sql` to create the mock database environment and run the analytical reporting queries.
