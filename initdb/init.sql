-- Example: create a test role/db for CI
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'app_test') THEN
    CREATE ROLE app_test LOGIN PASSWORD 'test_pw';
  END IF;
END$$;

CREATE DATABASE app_test OWNER app_test;
-- Enable an extension example (uncomment if you need it):
-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
