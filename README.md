# Toronto Rental Market Analysis

## Project Overview

This project analyzes Toronto rental market trends from 2021 to 2025 using data from CMHC.

The goal is to examine changes in average two-bedroom rent, vacancy rates, turnover rates, and rent growth, and to present the results in an interactive Power BI dashboard.

## Tools Used

- Python
- Pandas
- MySQL
- SQL
- Power BI
- Excel

## Data Source

Data source: Canada Mortgage and Housing Corporation (CMHC) Rental Market Survey.

The analysis focuses on Toronto CMA from 2021 to 2025.

## Data Cleaning

Python and Pandas were used to:

- Extract Toronto CMA data from annual CMHC Excel files
- Clean column names and data types
- Convert rent values into numeric format
- Combine 2021–2025 data into one dataset
- Export the cleaned data to CSV

## SQL Analysis

MySQL was used to analyze:

- Annual rent trends
- Year-over-year rent increases
- Vacancy rate changes
- Reported rent growth
- Calculated rent growth
- Relationship between vacancy rate changes and rent growth

SQL techniques used include:

- CTEs
- Window functions
- LAG()
- ORDER BY

## Key Findings

- Average two-bedroom rent increased from $1,679 in 2021 to $2,046 in 2025.
- 2023 recorded the largest annual rent increase, at $182.
- Rent growth slowed sharply in 2024, with only a $13 increase in average two-bedroom rent.
- The vacancy rate decreased from 4.6% in 2021 to 1.4% in 2023, then increased to 3.0% in 2025.
- Turnover rate declined from 14.4% in 2021 to 6.4% in 2024 before rising to 8.7% in 2025.
- Vacancy rate changes and rent growth showed a moderate negative correlation over the available period.

## Power BI Dashboard

The dashboard contains two pages:

### Page 1 — Toronto Rental Market Overview

- Average 2-Bedroom Rent
- Reported Rent Growth
- Vacancy Rate
- Turnover Rate
- Average 2-Bedroom Rent Trend
- Vacancy Rate vs Rent Growth

### Page 2 — Detailed Analysis

- Year-over-Year Rent Increase
- Turnover Rate Trend
- Key Insights

## Project Files

- `toronto_rental_clean.py` — data cleaning process
- `toronto_rental_2021_2025.csv` — cleaned dataset
- `analysis.sql` — SQL analysis
- `rental_analysis.pbix` — Power BI dashboard