# Finanical Analytics Portfolio

This repository contains a collection of financial analytics projects built using **PostgreSQL** and **Python** to demonstrate practical skills in:

- Finanical analysis and forecasting 
- Risk assessment and monitoring 
- Variance and anomaly detection
- Revenue modeling and cohort analysis
- Data modeling, ETL, and analytics engineering 

The projects are designed to reflect **real-world analyst workflows** commonly found in FP&A, risk managementm and corporate finance teams. 

---

## Project Scope

The portfolio will include the following analytics systems: 

1. **Cash-Flow Forecasting Engine**
    Forecasts cash inflows and outflows with scenario analysis and runway calculations. 

2. **Expense Anomaly Detection**
    Identifies unusual or structurally changing expenses using statistical thresholds.

3. **Credit Risk Scoring & Monitoring**
    Scores entities based on financial health, trend deterioration, and stress scenarios. 

4. **Revenue Forecasting & Cohort Retention Analysis**
    Models customer cohorts, retention, lifetime value (LTV), and forward revenue. 

Each project builds on a **shared PostgreSQL data model** to encourage reuse, consistency, and scalable analytics. 

---

## Repository Structure 

```text
finance_analytics/
├── db/                # Database schema, seeds, and migrations
├── src/               # Python ETL, transformations, and models
│   ├── extract/
│   ├── transform/
│   ├── models/
│   └── reporting/
├── notebooks/         # Exploratory analysis and validation
├── dashboards/        # Visualizations (Streamlit / charts)
├── data/              # Raw and processed datasets (gitignored)
└── README.md

---

## Phase 0 - Data Foundation 

Phase 0 establishes a reusable analytics foundation, including:
- A normalized PostgreSQL schema
- A fully populated 'dim_date' calendar dimension 
- Core tables for transactions, expenses, revenue, and financial statements 
- Referential integrity enforced via primary and foregin keys
- Synthetic seed data to support forecasting, anomaly detection, and risk analysis 
- Validation views to confirm data correctness 

No analytical models are implemented in Phase 0 by design 

--- 

## Rebuilding the Database 

to recreate the database from scratch: 

```bash
psql -d financedatabase -f db/schema.sql 
psql -d financedatabase -f db/seed_data.sql 
psql -d financedatabase -f db/views.sql 