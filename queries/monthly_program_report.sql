-- =====================================================================
-- monthly_program_report.sql
--
-- Purpose:
--   Monthly summary of enrollment activity per program: how many
--   participants enrolled that month, how many of those enrollments
--   have since been marked "Completed", and a running completion rate.
--   A common reporting need in program administration — "what
--   happened in program X this month?" — without writing a new query
--   each time.
--
-- Parameters (edit the WHERE clause below, or promote to a stored
--   procedure with @start_date / @end_date parameters in SQL Server):
--   - start_date: first day of the reporting window (inclusive)
--   - end_date:   last day of the reporting window (inclusive)
--
-- Output columns:
--   program_name, enrollment_month, enrollments, completions,
--   completion_rate_pct
--
-- Example use: monthly report for Q1 2025 (Jan 1 - Mar 31, 2025)
-- =====================================================================

SELECT
    p.program_name,
    strftime('%Y-%m', e.enrollment_date)                         AS enrollment_month,
    COUNT(e.enrollment_id)                                        AS enrollments,
    SUM(CASE WHEN e.completion_status = 'Completed' THEN 1 ELSE 0 END) AS completions,
    ROUND(
        100.0 * SUM(CASE WHEN e.completion_status = 'Completed' THEN 1 ELSE 0 END)
        / COUNT(e.enrollment_id), 1
    )                                                              AS completion_rate_pct
FROM enrollments e
JOIN programs p ON p.program_id = e.program_id
WHERE e.enrollment_date BETWEEN '2025-01-01' AND '2025-03-31'   -- <-- edit reporting window here
GROUP BY p.program_name, strftime('%Y-%m', e.enrollment_date)
ORDER BY enrollment_month, p.program_name;

-- SQL Server equivalent for the month bucket:
--   FORMAT(e.enrollment_date, 'yyyy-MM')
-- PostgreSQL equivalent:
--   TO_CHAR(e.enrollment_date, 'YYYY-MM')
