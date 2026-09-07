-- Look up material distributions for a selected date range
-- Change the dates/material below as needed
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
