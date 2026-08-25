-- =====================================================================
-- item_distribution_by_date_range.sql
--
-- Purpose:
--   Ad hoc / on-demand query for "how many of [material] did we give
--   out between [date] and [date], and to whom / which program?" This
--   is the query most often run for one-off requests, since program
--   materials are frequently tracked independent of a specific
--   program (see the LEFT JOIN to programs) — a common reporting need
--   in program administration.
--
-- Parameters (replace the literals below):
--   :start_date   - first day of range (inclusive)
--   :end_date     - last day of range (inclusive)
--   :material_name_filter - set to a specific material name, or
--                            remove the filter line entirely to see
--                            all materials in the date range
--
-- In SQL Server this would be a stored procedure:
--   CREATE PROCEDURE dbo.usp_ItemDistributionByDateRange
--       @StartDate DATE, @EndDate DATE, @MaterialName NVARCHAR(100) = NULL
--   AS ... WHERE d.distribution_date BETWEEN @StartDate AND @EndDate
--       AND (@MaterialName IS NULL OR m.material_name = @MaterialName)
--
-- Output columns:
--   distribution_date, material_name, participant_name, organization,
--   program_name, quantity
-- =====================================================================

SELECT
    d.distribution_date,
    m.material_name,
    p.first_name || ' ' || p.last_name          AS participant_name,
    p.organization,
    COALESCE(pr.program_name, 'Not tied to a program') AS program_name,
    d.quantity
FROM material_distributions d
JOIN materials m      ON m.material_id = d.material_id
JOIN participants p   ON p.participant_id = d.participant_id
LEFT JOIN programs pr ON pr.program_id = d.program_id
WHERE d.distribution_date BETWEEN '2025-08-01' AND '2026-01-31'  -- <-- :start_date / :end_date
  AND m.material_name = 'Equipment Loan Kit'                     -- <-- :material_name_filter (remove to see all)
ORDER BY d.distribution_date;
