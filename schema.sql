DROP TABLE IF EXISTS material_distributions;
DROP TABLE IF EXISTS program_activities;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS materials;
DROP TABLE IF EXISTS participants;
DROP TABLE IF EXISTS programs;

-- programs: the courses / workshops / campaigns the office runs

CREATE TABLE programs (
    program_id      INTEGER PRIMARY KEY,
    program_name    TEXT NOT NULL,
    category        TEXT NOT NULL,      
    start_date      DATE NOT NULL,
    end_date        DATE                
);


-- participants: people who enroll in programs / receive materials

CREATE TABLE participants (
    participant_id  INTEGER PRIMARY KEY,
    first_name      TEXT NOT NULL,
    last_name       TEXT NOT NULL,
    organization     TEXT,               
    email           TEXT,
    signup_date     DATE NOT NULL
);


-- materials: items the office distributes (handbooks, kits, etc.)

CREATE TABLE materials (
    material_id     INTEGER PRIMARY KEY,
    material_name   TEXT NOT NULL,
    category        TEXT NOT NULL,      
    unit_cost       DECIMAL(8,2) NOT NULL DEFAULT 0
);


-- enrollments: participant <-> program (many-to-many with attributes)

CREATE TABLE enrollments (
    enrollment_id      INTEGER PRIMARY KEY,
    program_id         INTEGER NOT NULL REFERENCES programs(program_id),
    participant_id     INTEGER NOT NULL REFERENCES participants(participant_id),
    enrollment_date    DATE NOT NULL,
    completion_status  TEXT NOT NULL DEFAULT 'In Progress',  
    completion_date    DATE
);


-- material_distributions: materials handed out to participants,

CREATE TABLE material_distributions (
    distribution_id     INTEGER PRIMARY KEY,
    material_id          INTEGER NOT NULL REFERENCES materials(material_id),
    participant_id        INTEGER NOT NULL REFERENCES participants(participant_id),
    program_id            INTEGER REFERENCES programs(program_id),  
    distribution_date     DATE NOT NULL,
    quantity               INTEGER NOT NULL DEFAULT 1
);


-- program_activities: logged events/sessions under a program

CREATE TABLE program_activities (
    activity_id     INTEGER PRIMARY KEY,
    program_id      INTEGER NOT NULL REFERENCES programs(program_id),
    activity_type   TEXT NOT NULL,   
    activity_date   DATE NOT NULL,
    notes           TEXT
);

CREATE INDEX idx_enrollments_program ON enrollments(program_id);
CREATE INDEX idx_enrollments_participant ON enrollments(participant_id);
CREATE INDEX idx_distributions_material ON material_distributions(material_id);
CREATE INDEX idx_distributions_date ON material_distributions(distribution_date);
CREATE INDEX idx_activities_program ON program_activities(program_id);
