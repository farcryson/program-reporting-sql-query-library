-- =====================================================================
-- schema.sql
-- Program Reporting SQL Query Library — Training/Outreach Program
-- Reporting Database
--
-- A small relational database modeling a generic training/outreach
-- program office: it runs programs (courses/workshops), enrolls
-- participants, distributes materials (handbooks, kits, etc.), and
-- logs program activities. Built to practice writing reusable,
-- documented SQL reports over a multi-table relational schema.
--
-- Tested against SQLite 3. Written in portable ANSI SQL so it also
-- runs on PostgreSQL or SQL Server with minor changes — see the
-- "Porting notes" section at the bottom of README.md.
-- =====================================================================

DROP TABLE IF EXISTS material_distributions;
DROP TABLE IF EXISTS program_activities;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS materials;
DROP TABLE IF EXISTS participants;
DROP TABLE IF EXISTS programs;

-- ---------------------------------------------------------------------
-- programs: the courses / workshops / campaigns the office runs
-- ---------------------------------------------------------------------
CREATE TABLE programs (
    program_id      INTEGER PRIMARY KEY,
    program_name    TEXT NOT NULL,
    category        TEXT NOT NULL,      -- e.g. 'Safety Training', 'Outreach'
    start_date      DATE NOT NULL,
    end_date        DATE                -- NULL if the program is ongoing
);

-- ---------------------------------------------------------------------
-- participants: people who enroll in programs / receive materials
-- ---------------------------------------------------------------------
CREATE TABLE participants (
    participant_id  INTEGER PRIMARY KEY,
    first_name      TEXT NOT NULL,
    last_name       TEXT NOT NULL,
    organization     TEXT,               -- partner org, department, community group
    email           TEXT,
    signup_date     DATE NOT NULL
);

-- ---------------------------------------------------------------------
-- materials: items the office distributes (handbooks, kits, etc.)
-- ---------------------------------------------------------------------
CREATE TABLE materials (
    material_id     INTEGER PRIMARY KEY,
    material_name   TEXT NOT NULL,
    category        TEXT NOT NULL,      -- e.g. 'Printed', 'Equipment'
    unit_cost       DECIMAL(8,2) NOT NULL DEFAULT 0
);

-- ---------------------------------------------------------------------
-- enrollments: participant <-> program (many-to-many with attributes)
-- ---------------------------------------------------------------------
CREATE TABLE enrollments (
    enrollment_id      INTEGER PRIMARY KEY,
    program_id         INTEGER NOT NULL REFERENCES programs(program_id),
    participant_id     INTEGER NOT NULL REFERENCES participants(participant_id),
    enrollment_date    DATE NOT NULL,
    completion_status  TEXT NOT NULL DEFAULT 'In Progress',  -- 'Completed','In Progress','Withdrawn'
    completion_date    DATE
);

-- ---------------------------------------------------------------------
-- material_distributions: materials handed out to participants,
-- optionally tied to a specific program
-- ---------------------------------------------------------------------
CREATE TABLE material_distributions (
    distribution_id     INTEGER PRIMARY KEY,
    material_id          INTEGER NOT NULL REFERENCES materials(material_id),
    participant_id        INTEGER NOT NULL REFERENCES participants(participant_id),
    program_id            INTEGER REFERENCES programs(program_id),  -- nullable: some distributions aren't tied to a program
    distribution_date     DATE NOT NULL,
    quantity               INTEGER NOT NULL DEFAULT 1
);

-- ---------------------------------------------------------------------
-- program_activities: logged events/sessions under a program
-- ---------------------------------------------------------------------
CREATE TABLE program_activities (
    activity_id     INTEGER PRIMARY KEY,
    program_id      INTEGER NOT NULL REFERENCES programs(program_id),
    activity_type   TEXT NOT NULL,   -- 'Training Session','Site Visit','Webinar','Video Review'
    activity_date   DATE NOT NULL,
    notes           TEXT
);

CREATE INDEX idx_enrollments_program ON enrollments(program_id);
CREATE INDEX idx_enrollments_participant ON enrollments(participant_id);
CREATE INDEX idx_distributions_material ON material_distributions(material_id);
CREATE INDEX idx_distributions_date ON material_distributions(distribution_date);
CREATE INDEX idx_activities_program ON program_activities(program_id);
