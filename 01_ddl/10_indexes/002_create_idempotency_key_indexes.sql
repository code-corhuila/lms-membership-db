-- Every foreign-key column has its index — rules/2-anexos/A-db-postgres.md, rule 3.
CREATE INDEX idx_idempotency_key_student_id ON membership.idempotency_key (student_id);
