-- Monthly enrollment and completion summary by program
-- Edit the dates below to change the reporting period

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
