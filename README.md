# COVID-19-Vaccination-Database-Project
Relational database design and analysis of global COVID-19 vaccination data using SQLite, ER modeling, SQL queries, and data visualization

# COVID-19 Vaccination Database Project

## Overview

This project is a practical implementation of database concepts using a publicly available dataset on global COVID-19 vaccinations. The dataset tracks vaccine rollout across multiple countries, including doses administered, vaccine types, and demographic breakdowns.

The aim is to design and build a normalized relational database to store and analyze vaccination data, reinforcing key course learning outcomes such as conceptual data modeling, normalization, SQL querying, and data visualization.

## Dataset

The dataset is sourced from [Our World in Data COVID-19 Vaccinations](https://github.com/owid/covid-19-data/tree/master/public/data/vaccinations), which provides global vaccination data in CSV format. For this project, the following files were used:

- `locations.csv` — Country and vaccine type information  
- `us_state_vaccinations.csv` — US state-level vaccination history  
- `vaccinations-by-age-group.csv` — Vaccination data by age group per country  
- `vaccinations-by-manufacturer.csv` — Vaccination data by vaccine manufacturer  
- `vaccinations.csv` — Country-level vaccination observations by date  
- Daily vaccination data for China, India, US, and Ireland (separate CSV files)

## Project Tasks

### Part A: Understanding the Data
- Reviewed and analyzed the dataset structure and contents.

### Part B: Database Design
- Developed an Entity-Relationship Diagram (ERD) using Lucidchart with UML notation.
- Transformed the ERD into a normalized relational schema, ensuring 3NF compliance.
- Documented normalization decisions and challenges in `Model.pdf`.

### Part C: Database Implementation
- Created SQL scripts (`Database.sql`) to define tables and constraints in SQLite.
- Formatted and imported the CSV data into the SQLite database file (`Vaccinations.db`).

### Part D: Data Retrieval and Visualization
- Wrote SQL queries (`Queries.sql`) addressing specific analytical requirements, such as:
  - Tracking vaccine administration growth over time
  - Comparing country performance to global averages
  - Analyzing vaccine type market shares
  - Reporting on vaccination speed across countries
- Captured query results and visualized them using tools such as Excel and Google Charts.
- Compiled query snapshots and visualizations in `Queries.pdf`.

## Tools and Technologies

- SQLite Studio — Database creation and querying  
- Lucidchart — ER Diagram design  
- Excel — Data cleaning and CSV formatting  
- Google Charts / Excel — Data visualization  
- SQL — Data definition and manipulation  

## How to Use

1. Clone this repository  
2. Open `Database.sql` in SQLite Studio and execute to create the schema  
3. Import the prepared CSV files into the database to populate tables  
4. Run the SQL queries from `Queries.sql` to generate results  
5. Refer to `Queries.pdf` for visualized insights  

## Learning Outcomes

- Applying data normalization principles to real-world data  
- Designing robust relational schemas from complex datasets  
- Performing advanced SQL queries involving joins, aggregations, and window functions  
- Translating query results into meaningful visualizations  
- Understanding global COVID-19 vaccination trends through data  

## License

This project is intended for academic and personal learning purposes only.

---


