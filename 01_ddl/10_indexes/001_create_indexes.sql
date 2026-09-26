-- document_id is the business key uniqueness lives here, not an inline
-- UNIQUE on the column (rules/2-anexos/A-db-postgres.md, rule 4).
CREATE UNIQUE INDEX idx_student_document_id ON membership.student (document_id);

-- Every list query filters "not deactivated" first (HU-03 search) — a
-- partial index keeps it cheap as the table grows.
CREATE INDEX idx_student_active ON membership.student (deactivated_at) WHERE deactivated_at IS NULL;

-- HU-06's eligibility check reads suspended_until for one student at a time.
CREATE INDEX idx_student_suspended_until ON membership.student (suspended_until) WHERE suspended_until IS NOT NULL;
