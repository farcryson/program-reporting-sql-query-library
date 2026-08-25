-- =====================================================================
-- data_quality_checks.sql
--
-- Purpose:
--   A set of validation checks to run before trusting a reporting
--   period's numbers. Surfaces inconsistent or suspicious records
--   (bad completion status/date pairs, non-positive quantities,
--   duplicate participant emails, distributions logged outside a
--   program's active date range) so they can be corrected at the
--   source instead of skewing a report.
--
-- Parameters: none. Intended to be run as-is; each SELECT below can
--   also be run individually while investigating a specific issue.
--
-- Output columns:
--   issue_type, record_id, detail
-- =====================================================================

-- 1. Enrollment marked "Completed" but has no completion_date
SELECT
    'Missing completion_date' AS issue_type,
    enrollment_id             AS record_id,
    'participant_id=' || participant_id || ', program_id=' || program_id AS detail
FROM enrollments
WHERE completion_status = 'Completed' AND completion_date IS NULL

UNION ALL

-- 2. Enrollment has a completion_date but status was never updated to "Completed"
SELECT
    'Completion date set but status not Completed',
    enrollment_id,
    'status=' || completion_status
FROM enrollments
WHERE completion_date IS NOT NULL AND completion_status <> 'Completed'

UNION ALL

-- 3. Material distribution with a non-positive quantity
SELECT
    'Non-positive distribution quantity',
    distribution_id,
    'quantity=' || quantity
FROM material_distributions
WHERE quantity <= 0

UNION ALL

-- 4. Participants sharing the same email (possible duplicate records)
SELECT
    'Duplicate participant email',
    participant_id,
    'email=' || email
FROM participants
WHERE email IN (
    SELECT email FROM participants GROUP BY email HAVING COUNT(*) > 1
)

UNION ALL

-- 5. Distribution logged outside its linked program's active date range
SELECT
    'Distribution date outside program range',
    d.distribution_id,
    'program=' || pr.program_name || ', distributed=' || d.distribution_date
FROM material_distributions d
JOIN programs pr ON pr.program_id = d.program_id
WHERE d.distribution_date < pr.start_date
   OR (pr.end_date IS NOT NULL AND d.distribution_date > pr.end_date)

ORDER BY issue_type, record_id;
