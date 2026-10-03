-- Backs internal/adapter/out/idempotency's durable adapter in lms-membership-api
-- (rules/2-anexos/A-db-postgres.md's own idempotency_key example, and
-- rules/2-anexos/C-api-hexagonal.md numeral 5.3.8). The key IS the primary
-- key — a lookup by key is exactly how the -api checks "have I seen this
-- intent before".
CREATE TABLE membership.idempotency_key (
  key         text        PRIMARY KEY CHECK (char_length(key) BETWEEN 8 AND 128),
  student_id  UUID        NOT NULL,
  created_at  timestamptz NOT NULL DEFAULT now()
);
