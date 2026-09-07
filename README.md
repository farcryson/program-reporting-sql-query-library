# Program Reporting SQL Query Library

Small SQL project I built to practice reporting queries on a relational database.

The database models a basic training/outreach office that runs programs, enrolls participants, distributes materials, and tracks program activities.

## Tables

* `programs` - programs offered by the office
* `participants` - people participating in programs
* `enrollments` - connects participants to programs and tracks completion
* `materials` - materials or kits that can be distributed
* `material_distributions` - tracks who received materials and when
* `program_activities` - activities such as training sessions, webinars, and site visits

## Queries

The `queries/` folder includes:

* `monthly_program_report.sql` - monthly enrollment and completion totals
* `annual_distribution_summary.sql` - yearly material distribution totals and estimated cost
* `item_distribution_by_date_range.sql` - distributions for a selected material/date range
* `program_activity_summary.sql` - activity counts by program
* `data_quality_checks.sql` - basic checks for inconsistent records

## Running the project

The project uses SQLite.

```bash
sqlite3 program_reporting.db < schema.sql
sqlite3 program_reporting.db < sample_data.sql
```

Then a query can be run with:

```bash
sqlite3 -header -column program_reporting.db < queries/monthly_program_report.sql
```

All data in the project is synthetic.

## Why I built it

I wanted more practice working with SQL beyond individual coding problems, especially joins, grouping, date filtering, aggregate functions, and reporting across multiple related tables.

I used a program-office scenario because it gave me realistic examples of questions like:

* How many participants enrolled in each program?
* How many completed the program?
* How many materials were distributed during a date range?
* What activities were recorded for each program?
* Are there obvious inconsistencies in the data?

## SQL Server

The project currently runs on SQLite. If I moved it to SQL Server, I would mainly need to update some SQLite-specific functions such as `strftime()` and string concatenation, and I could parameterize reporting queries using T-SQL variables or stored procedures.
