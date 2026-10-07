-- A new changeset, not an edit to 001_grants.sql — rule 12: an applied
-- changeset never changes once it's shipped.
GRANT SELECT, INSERT ON membership.idempotency_key TO membership_writer;
GRANT SELECT ON membership.idempotency_key TO membership_reader;
