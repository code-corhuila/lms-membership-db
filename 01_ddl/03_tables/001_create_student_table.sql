-- The Membership bounded context's aggregate root — one row per student
-- (library-docs/02-domain/entities-and-rules.md). Named "student" (singular),
-- not "students" — rules/2-anexos/A-db-postgres.md, rule 1.
--
-- document_id's uniqueness is enforced by idx_student_document_id
-- (01_ddl/10_indexes), not an inline UNIQUE here — kept with the other
-- explicitly-named constraints/indexes, per rule 4.
CREATE TABLE membership.student (
  id                UUID        PRIMARY KEY DEFAULT gen_random_uuid(),

  full_name         text        NOT NULL CHECK (char_length(full_name) BETWEEN 1 AND 200),
  document_id       text        NOT NULL CHECK (char_length(document_id) BETWEEN 1 AND 50),
  email             text        NOT NULL CHECK (char_length(email) BETWEEN 1 AND 255),
  phone             text        CHECK (phone IS NULL OR char_length(phone) <= 30),

  suspended_until   timestamptz,
  deactivated_at    timestamptz,

  created_at        timestamptz NOT NULL DEFAULT now(),
  updated_at        timestamptz NOT NULL DEFAULT now()
);
