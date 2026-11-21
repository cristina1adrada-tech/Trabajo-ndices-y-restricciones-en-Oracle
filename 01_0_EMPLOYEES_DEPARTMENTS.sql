SELECT table_name
FROM user_tables
WHERE table_name IN ('EMPLOYEES', 'DEPARTMENTS')
ORDER BY table_name;