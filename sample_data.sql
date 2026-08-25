-- =====================================================================
-- sample_data.sql
-- All data below is synthetic and created for demonstration purposes
-- only. It models a generic training/outreach program office and does
-- not represent any real organization's records.
--
-- Covers Jan 2025 - Feb 2026 so monthly/annual queries return
-- meaningful, non-trivial results.
-- =====================================================================

-- ---------------------------------------------------------------------
-- programs
-- ---------------------------------------------------------------------
INSERT INTO programs (program_id, program_name, category, start_date, end_date) VALUES
(1, 'Equipment Safety Training',       'Safety Training', '2025-01-15', '2025-12-15'),
(2, 'Annual Compliance Refresher',     'Safety Training', '2025-02-01', NULL),
(3, 'Community Outreach Program',      'Outreach',         '2025-03-10', '2025-11-30'),
(4, 'Instructor Training Series',      'Safety Training', '2025-05-01', '2026-04-30'),
(5, 'Professional Development Workshop','Workshop',        '2025-08-01', '2025-08-31'),
(6, 'Resource Distribution Program',   'Distribution',     '2026-01-05', '2026-02-15');

-- ---------------------------------------------------------------------
-- participants
-- ---------------------------------------------------------------------
INSERT INTO participants (participant_id, first_name, last_name, organization, email, signup_date) VALUES
(1,  'Maria',   'Alvarez',  'Lakeside School District',       'malvarez@example.org',      '2025-01-10'),
(2,  'James',   'Cooper',   'Westfield Public Works',         'jcooper@example.org',       '2025-01-12'),
(3,  'Priya',   'Nair',     'Central Facilities Management',  'pnair@example.org',         '2025-01-20'),
(4,  'Tomas',   'Reyes',    'Bridgeview School District',     'treyes@example.org',        '2025-02-02'),
(5,  'Angela',  'Kim',      'Westfield Public Works',         'akim@example.org',          '2025-02-05'),
(6,  'David',   'Nguyen',   'Lakeside School District',       'dnguyen@example.org',       '2025-02-14'),
(7,  'Sara',    'Ibrahim',  'Independent',                     'sibrahim@example.org',      '2025-03-01'),
(8,  'Kevin',   'O''Brien', 'Bridgeview School District',     'kobrien@example.org',       '2025-03-15'),
(9,  'Lena',    'Fischer',  'Central Facilities Management',  'lfischer@example.org',      '2025-04-02'),
(10, 'Marcus',  'Bell',     'Westfield Public Works',         'mbell@example.org',         '2025-04-20'),
(11, 'Nadia',   'Petrova',  'Independent',                     'npetrova@example.org',      '2025-05-05'),
(12, 'Hassan',  'Ali',      'Lakeside School District',       'hali@example.org',          '2025-05-18'),
(13, 'Ruth',    'Johnson',  'Bridgeview School District',     'rjohnson@example.org',      '2025-06-01'),
(14, 'Chen',    'Wei',      'Central Facilities Management',  'cwei@example.org',          '2025-07-10'),
(15, 'Olivia',  'Turner',   'Westfield Public Works',         'oturner@example.org',       '2025-08-02'),
(16, 'Samuel',  'Osei',     'Independent',                     'sosei@example.org',         '2025-08-15'),
(17, 'Grace',   'Park',     'Lakeside School District',       'gpark@example.org',         '2025-09-10'),
(18, 'Liam',    'Murphy',   'Bridgeview School District',     'lmurphy@example.org',       '2025-10-05'),
(19, 'Fatima',  'Siddiqui', 'Central Facilities Management',  'fsiddiqui@example.org',     '2025-11-12'),
(20, 'Eric',    'Larsson',  'Westfield Public Works',         'elarsson@example.org',      '2026-01-08');

-- ---------------------------------------------------------------------
-- materials
-- ---------------------------------------------------------------------
INSERT INTO materials (material_id, material_name, category, unit_cost) VALUES
(1, 'Training Manual',           'Printed',   5.75),
(2, 'Equipment Loan Kit',        'Equipment', 22.00),
(3, 'Workshop Kit',              'Equipment', 18.50),
(4, 'Participant Handbook',      'Printed',   8.00),
(5, 'Safety Checklist',          'Printed',   1.75),
(6, 'Resource Binder',           'Printed',   4.25),
(7, 'Reference Guide',           'Printed',   6.50),
(8, 'Printed Certificate Packet','Printed',   3.00);

-- ---------------------------------------------------------------------
-- enrollments
-- ---------------------------------------------------------------------
INSERT INTO enrollments (enrollment_id, program_id, participant_id, enrollment_date, completion_status, completion_date) VALUES
(1,  1, 1,  '2025-01-16', 'Completed',  '2025-03-01'),
(2,  1, 2,  '2025-01-16', 'Completed',  '2025-03-01'),
(3,  1, 6,  '2025-02-20', 'Completed',  '2025-04-10'),
(4,  1, 10, '2025-04-22', 'In Progress', NULL),
(5,  2, 3,  '2025-02-03', 'Completed',  '2025-02-20'),
(6,  2, 9,  '2025-04-05', 'Completed',  '2025-04-25'),
(7,  2, 14, '2025-07-12', 'Completed',  '2025-07-30'),
(8,  2, 19, '2025-11-15', 'In Progress', NULL),
(9,  3, 7,  '2025-03-05', 'Completed',  '2025-03-20'),
(10, 3, 11, '2025-05-06', 'Completed',  '2025-05-22'),
(11, 3, 16, '2025-08-16', 'Withdrawn',  NULL),
(12, 4, 4,  '2025-05-02', 'Completed',  '2025-06-01'),
(13, 4, 8,  '2025-05-02', 'Completed',  '2025-06-01'),
(14, 4, 13, '2025-06-03', 'Completed',  '2025-07-01'),
(15, 4, 18, '2025-10-08', 'In Progress', NULL),
(16, 5, 1,  '2025-08-01', 'Completed',  '2025-08-31'),
(17, 5, 4,  '2025-08-01', 'Completed',  '2025-08-31'),
(18, 5, 12, '2025-08-02', 'Completed',  '2025-08-31'),
(19, 5, 17, '2025-08-05', 'Completed',  '2025-08-31'),
(20, 6, 15, '2026-01-06', 'Completed',  '2026-01-20'),
(21, 6, 20, '2026-01-09', 'In Progress', NULL);

-- ---------------------------------------------------------------------
-- material_distributions
-- ---------------------------------------------------------------------
INSERT INTO material_distributions (distribution_id, material_id, participant_id, program_id, distribution_date, quantity) VALUES
(1,  1, 1,  1, '2025-01-16', 1),
(2,  1, 2,  1, '2025-01-16', 1),
(3,  1, 6,  1, '2025-02-20', 1),
(4,  1, 10, 1, '2025-04-22', 1),
(5,  5, 1,  1, '2025-01-16', 1),
(6,  5, 2,  1, '2025-01-16', 1),
(7,  7, 3,  2, '2025-02-03', 1),
(8,  7, 9,  2, '2025-04-05', 1),
(9,  7, 14, 2, '2025-07-12', 1),
(10, 2, 7,  3, '2025-03-05', 15),
(11, 3, 7,  3, '2025-03-05', 10),
(12, 2, 11, 3, '2025-05-06', 20),
(13, 3, 11, 3, '2025-05-06', 12),
(14, 4, 4,  4, '2025-05-02', 1),
(15, 4, 8,  4, '2025-05-02', 1),
(16, 4, 13, 4, '2025-06-03', 1),
(17, 6, 1,  5, '2025-08-01', 3),
(18, 6, 4,  5, '2025-08-01', 3),
(19, 2, 12, 5, '2025-08-02', 25),
(20, 2, 17, 5, '2025-08-05', 30),
(21, 8, 15, 6, '2026-01-06', 1),
(22, 8, 20, 6, '2026-01-09', 1),
(23, 8, 5,  NULL, '2026-01-15', 2),
(24, 1, 16, NULL, '2025-09-01', 5),
(25, 3, 19, 2, '2025-11-15', 1);

-- ---------------------------------------------------------------------
-- program_activities
-- ---------------------------------------------------------------------
INSERT INTO program_activities (activity_id, program_id, activity_type, activity_date, notes) VALUES
(1,  1, 'Training Session', '2025-01-16', 'Initial cohort session, 12 attendees'),
(2,  1, 'Training Session', '2025-02-20', 'Second cohort session'),
(3,  1, 'Site Visit',       '2025-03-10', 'Follow-up compliance check'),
(4,  2, 'Training Session', '2025-02-03', 'Certification session, group A'),
(5,  2, 'Training Session', '2025-04-05', 'Certification session, group B'),
(6,  2, 'Video Review',     '2025-06-15', 'Reviewed training video content for updates'),
(7,  3, 'Site Visit',       '2025-03-05', 'Outreach event at community center'),
(8,  3, 'Webinar',          '2025-05-06', 'Virtual outreach session for community partners'),
(9,  4, 'Training Session', '2025-05-02', 'Instructor training, spring cohort'),
(10, 4, 'Training Session', '2025-06-03', 'Instructor training, summer cohort'),
(11, 5, 'Site Visit',       '2025-08-01', 'Resource kit installation review'),
(12, 5, 'Training Session', '2025-08-02', 'Workshop session for partner organization staff'),
(13, 6, 'Site Visit',       '2026-01-06', 'Resource kit distribution event'),
(14, 6, 'Site Visit',       '2026-01-09', 'Resource kit distribution event, second site'),
(15, 4, 'Webinar',          '2026-02-10', 'Remote session for instructors unable to attend in person');
