-- =====================================================================
-- annual_distribution_summary.sql
--
-- Purpose:
--   Year-over-year totals for material distribution: total units
--   distributed and estimated cost per material, per calendar year.
--   Used for annual reporting and budget justification — how much of
--   a given material was distributed in a year and what it cost.
--
-- Parameters:
--   None required to run as-is (covers all years in the data).
--   To restrict to a single year, add a WHERE clause on
--   strftime('%Y', d.distribution_date) = '2025'.
--
-- Output columns:
--   distribution_year, material_name, category, total_units,
--   estimated_cost
-- =====================================================================

SELECT
    strftime('%Y', d.distribution_date)         AS distribution_year,
    m.material_name,
    m.category,
    SUM(d.quantity)                               AS total_units,
    ROUND(SUM(d.quantity) * m.unit_cost, 2)       AS estimated_cost
FROM material_distributions d
JOIN materials m ON m.material_id = d.material_id
GROUP BY strftime('%Y', d.distribution_date), m.material_name, m.category, m.unit_cost
ORDER BY distribution_year, total_units DESC;

-- SQL Server equivalent for the year bucket:
--   YEAR(d.distribution_date)
-- PostgreSQL equivalent:
--   EXTRACT(YEAR FROM d.distribution_date)
