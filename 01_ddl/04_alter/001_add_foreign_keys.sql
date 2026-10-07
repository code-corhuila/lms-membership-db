ALTER TABLE membership.idempotency_key
  ADD CONSTRAINT fk_idempotency_key_student_id
  FOREIGN KEY (student_id) REFERENCES membership.student (id)
  ON DELETE CASCADE;
