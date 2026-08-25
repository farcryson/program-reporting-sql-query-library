# Program Reporting SQL Query Library

> All data in this project is synthetic and created for demonstration
> purposes. The schema is a practice model for a generic training or
> outreach program office and does not represent any real
> organization's records.

A small relational database and a library of reusable, documented SQL
queries for a training/outreach program office that runs programs,
enrolls participants, distributes materials, and logs program
activities.

This project was built as a practice exercise in the kind of work
involved in SQL reporting support: understanding an existing schema,
writing multi-table queries with joins/filters/aggregations, validating
results, and documenting each query well enough that someone else could
run or modify it without asking how it works.

## Why this schema

The scenario models a small outreach/training office (programs,
participants, materials handed out, and logged activities) - the kind
of setup where common reporting questions look like *"how many people
finished Program X last month"* or *"how many of a given item did we
hand out this year"*, and you'd rather answer them from a reusable
query than write a new one each time.

## Schema overview

Six tables, three of them join/fact tables tying the others together:

| Table | Purpose |
|---|---|
| `programs` | Courses, workshops, and campaigns the office runs |
| `participants` | People who enroll in programs or receive materials |
| `materials` | Items the office distributes (handbooks, kits, guides) |
| `enrollments` | Participant ↔ program, with completion status/date |
| `material_distributions` | Materials handed to a participant, optionally tied to a program |
| `program_activities` | Logged events (training sessions, site visits, webinars) under a program |

```
programs ──< enrollments >── participants
    │                              │
    │                              │
    └──< program_activities        └──< material_distributions >── materials
                                              │
                                              └── program_id (nullable — some
                                                  distributions aren't tied to
                                                  a specific program)
```

Full column-level detail is in [`schema.sql`](schema.sql).

## Loading the sample data

Tested against SQLite 3, using standard ANSI SQL so it also runs on
PostgreSQL or SQL Server with minor changes (see **Porting notes**
below).

```bash
sqlite3 program_reporting.db < schema.sql
sqlite3 program_reporting.db < sample_data.sql
```

Sample data covers January 2025 – February 2026: 6 programs,
20 participants, 8 materials, 21 enrollments, 25 distributions, and
15 logged activities — enough to make the monthly/annual queries
return real, non-trivial results.

## The queries

All queries live in [`queries/`](queries/). Each file has a header
comment describing its purpose, parameters, and output columns.

### `monthly_program_report.sql`
Enrollments and completions per program, bucketed by month, with a
completion rate. A common reporting need - "what happened this month".

```
program_name                  | enrollment_month | enrollments | completions | completion_rate_pct
Equipment Safety Training     | 2025-01           | 2           | 2           | 100.0
Annual Compliance Refresher   | 2025-02           | 1           | 1           | 100.0
Equipment Safety Training     | 2025-02           | 1           | 1           | 100.0
Community Outreach Program    | 2025-03           | 1           | 1           | 100.0
```

### `annual_distribution_summary.sql`
Total units and estimated cost distributed per material, per year.
Used for annual reporting and budget justification.

```
distribution_year | material_name              | category  | total_units | estimated_cost
2025               | Equipment Loan Kit         | Equipment | 90          | 1980.0
2025               | Workshop Kit               | Equipment | 23          | 425.5
2025               | Training Manual            | Printed   | 9           | 51.75
2025               | Resource Binder            | Printed   | 6           | 25.5
2025               | Participant Handbook       | Printed   | 3           | 24.0
2025               | Reference Guide            | Printed   | 3           | 19.5
2025               | Safety Checklist           | Printed   | 2           | 3.5
2026               | Printed Certificate Packet | Printed   | 4           | 12.0
```

### `item_distribution_by_date_range.sql`
Parameterized (edit the literal `start_date` / `end_date` / material
filter at the top of the WHERE clause, or promote to a stored
procedure - a T-SQL version is sketched in the file). The query most
often run for one-off requests.

Example: Equipment Loan Kits distributed Aug 2025 - Jan 2026:

```
distribution_date | material_name       | participant_name | organization             | program_name                        | quantity
2025-08-02         | Equipment Loan Kit  | Hassan Ali        | Lakeside School District | Professional Development Workshop   | 25
2025-08-05         | Equipment Loan Kit  | Grace Park        | Lakeside School District | Professional Development Workshop   | 30
```

### `program_activity_summary.sql`
Count of logged activities per program and activity type, with the
most recent activity date - useful for spotting programs that have
gone quiet.

```
program_name                    | activity_type     | activity_count | most_recent_activity
Equipment Safety Training       | Training Session  | 2               | 2025-02-20
Instructor Training Series      | Training Session  | 2               | 2025-06-03
Instructor Training Series      | Webinar           | 1               | 2026-02-10
...
```

### `data_quality_checks.sql`
Five validation checks in one query (missing completion dates,
inconsistent status/date pairs, non-positive quantities, duplicate
participant emails, and distributions logged outside their program's
active date range), run before trusting a period's numbers.

Running it against the sample data actually catches two real
inconsistencies I'd introduced by mistake - two material distributions
dated five days *before* their program's official start date:

```
issue_type                                | record_id | detail
Distribution date outside program range   | 10        | program=Community Outreach Program, distributed=2025-03-05
Distribution date outside program range   | 11        | program=Community Outreach Program, distributed=2025-03-05
```

(Left in intentionally - it's a good demonstration of what the check
is for.)

## Porting notes

Written in SQLite-flavored ANSI SQL. To run on other engines:

| SQLite | SQL Server (T-SQL) | PostgreSQL |
|---|---|---|
| `strftime('%Y-%m', col)` | `FORMAT(col, 'yyyy-MM')` | `TO_CHAR(col, 'YYYY-MM')` |
| `strftime('%Y', col)` | `YEAR(col)` | `EXTRACT(YEAR FROM col)` |
| `col1 \|\| col2` (concat) | `col1 + col2` | `col1 \|\| col2` |
| `DATE('now')` | `GETDATE()` | `CURRENT_DATE` |
| Literal params in WHERE | `@Param` in a stored proc | `$1` / named params |

## What I'd do next

- Turn `item_distribution_by_date_range.sql` into an actual stored
  procedure once running against a real SQL Server instance.
- Add a `programs` view that rolls up enrollment + distribution +
  activity counts in one place, since these are common combined
  reporting requests in program administration.
- Add a scheduled monthly export of `monthly_program_report.sql`
  results to CSV.
