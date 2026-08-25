-- =====================================================================
-- program_activity_summary.sql
--
-- Purpose:
--   Count of logged activities (training sessions, site visits,
--   webinars, video reviews) per program and activity type, plus the
--   date of the most recent activity. Useful for spotting programs
--   that have gone quiet and need a check-in, as well as routine
--   reporting on program engagement.
--
-- Parameters:
--   None required. To scope to active programs only, uncomment the
--   WHERE clause on p.end_date.
--
-- Output columns:
--   program_name, activity_type, activity_count, most_recent_activity
-- =====================================================================

SELECT
    p.program_name,
    a.activity_type,
    COUNT(a.activity_id)          AS activity_count,
    MAX(a.activity_date)          AS most_recent_activity
FROM program_activities a
JOIN programs p ON p.program_id = a.program_id
-- WHERE p.end_date IS NULL OR p.end_date >= DATE('now')   -- uncomment for active programs only
GROUP BY p.program_name, a.activity_type
ORDER BY p.program_name, activity_count DESC;
