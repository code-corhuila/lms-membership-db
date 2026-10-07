GRANT USAGE ON SCHEMA membership TO membership_reader, membership_writer;

GRANT SELECT ON membership.student TO membership_reader;
GRANT SELECT, INSERT, UPDATE ON membership.student TO membership_writer;
