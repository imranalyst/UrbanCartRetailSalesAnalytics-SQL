# **UrbanCart Retail Sales Analytics (SQL Project)**

## 📌 Project Overview

This project focuses on analyzing transactional data from **UrbanCart**, a multi-city online retail platform, using **SQL**. The objective of the project is to extract meaningful business insights related to customer behavior, orders, revenue, payment preferences, and product performance. A total of **25 real-world business questions** were answered to support data-driven decision-making.

---

## 🏢 Business Context

UrbanCart operates as an online retail shop serving customers across multiple cities and product categories. The management team aims to:

* Increase revenue
* Improve customer retention
* Optimize payment methods
* Identify cross-selling and bundling opportunities
* Make better inventory and marketing decisions

This analysis helps translate raw transactional data into actionable insights for business growth.

---

## 🛠 Tools & Technologies

* **SQL** (Joins, Aggregations, Subqueries, CTEs)
* **Supabase** (Database connection and querying)
* PostgreSQL-compatible SQL

---

## 🗂 Dataset Description

The analysis is based on the following tables:

| Table Name       | Description                                     |
| ---------------- | ----------------------------------------------- |
| `DimCustomers`   | Customer details (gender, city, signup date)    |
| `DimProducts`    | Product information (category, price, stock)    |
| `FactOrders`     | Order-level data (order date, status, customer) |
| `FactOrderItems` | Product-level order details (quantity)          |
| `FactPayment`    | Payment method and transaction data             |

---

## ❓ Business Questions Covered

The project answers **25 business questions**, grouped into the following sections:

1. **Customer & Order Fundamentals**
2. **Revenue & Product Performance**
3. **Customer Behavior & Segmentation**
4. **Payment & Order Flow Insights**
5. **Advanced Product & Basket Analysis**

Each question includes:

* SQL query
* Result
* Business insight

---

## 📊 Key Insights

* High repeat purchase behavior indicates strong customer engagement
* Certain cities generate higher order volumes and premium average order values
* A small set of products drives a large portion of total revenue
* Digital payments (especially Nagad) are associated with higher-value orders
* Clear cross-selling and bundling opportunities exist based on basket analysis

---

## 🎯 Key Learnings

* Writing optimized SQL queries for real-world business problems
* Working with cloud-hosted databases using Supabase
* Translating analytical results into business-focused insights
* Applying basket analysis and segmentation techniques using SQL

---

## 📁 Repository Structure

```
UrbanCart-SQL-Analytics/
│
├── queries/
│   ├── customer_analysis.sql
│   ├── revenue_analysis.sql
│   ├── payment_analysis.sql
│   └── basket_analysis.sql
│
├── UrbanCart_SQL_Business_Questions.pdf
└── README.md
```

---

## 🚀 Conclusion

This project demonstrates the practical use of SQL for end-to-end retail analytics. By combining technical querying skills with business interpretation, the analysis provides clear recommendations for improving revenue, customer retention, payment optimization, and cross-selling strategies.

---

## 📬 Contact

If you’d like to discuss this project or explore collaboration opportunities, feel free to connect with me on **LinkedIn**.

---
