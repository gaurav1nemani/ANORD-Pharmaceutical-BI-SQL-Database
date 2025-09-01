# 💊 ANORD Pharmaceutical Business Intelligence SQL Database

## 🚀 Introduction  

We are building a **centralized SQL database** for ANORD, a pharmaceutical distributor, to capture and organize all operational data: clients, branches, products, laboratories, employees, invoices, and sales transactions.  

**Why are we doing this?**  
This database allows ANORD’s leadership team to evaluate performance across clients, products, and sales representatives. By comparing sales versus last year, monitoring profitability, and identifying trends, ANORD gains the ability to:  

- 📈 Spot top and underperforming clients  
- 💊 Track product growth and declines  
- 💶 Measure profitability by client, product, and representative  
- 🧭 Support data-driven decision-making for strategy and sales optimization  

In short, this project transforms raw sales and operational data into **actionable insights for executives and managers**.  

---

## ⚙️ Setup

We designed a **relational database schema** and developed **analytical SQL views**.  
The schema defines key entities (clients, products, invoices, employees, laboratories, etc.), while the views provide dashboards to measure performance, profitability, and growth trends.  

---

## 🛠️ Setup Instructions  

1. Install [PostgreSQL](https://www.postgresql.org/) and a SQL IDE such as [DBeaver](https://dbeaver.io/).  
2. Load the **ANORD dataset** into PostgreSQL.  
   - Sample dataset: [PostgreSQL Sample Database](https://www.postgresqltutorial.com/postgresql-getting-started/postgresql-sample-database/)  
3. Open the project files in **DBeaver**:  
   - `Scripts/schema.sql` → Creates all tables.  
   - `View 1.1`, `View 1.2`, … `View 7` → SQL `CREATE VIEW` statements.  
4. Execute the scripts to generate the schema and views.  
5. Query the views to access ready-made reports.  

---

## 📊 Delivered Views  

The following views are available:  

- **View 1.x** → Customer performance analysis (best/worst vs. last year)  
- **View 2.x** → Product performance analysis (best/worst vs. last year)  
- **View 3.x** → Profitability by client-product  
- **View 4.x** → Profitability by client  
- **View 5** → Sales representatives’ performance  
- **View 6** → Discount and profitability tracking  
- **View 7** → Client-product trends and supporting insights  

---

## 👥 Contributors  

- **Paul Guillard**  
- **Mario Perez**  

Developed as part of the *Business Reporting Tools – Group Assignment 2024*.  
