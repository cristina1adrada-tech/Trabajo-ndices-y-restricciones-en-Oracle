-- 1.3.a Consultar restricciones existentes
SELECT constraint_name, constraint_type, table_name, status, r_constraint_name
FROM user_constraints
WHERE table_name IN ('EMPLOYEES', 'DEPARTMENTS')
ORDER BY table_name, constraint_type, constraint_name;