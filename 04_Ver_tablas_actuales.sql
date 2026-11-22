-- Ver tablas actuales
SELECT table_name
FROM user_tables
ORDER BY table_name;

-- Ver estado actual de restricciones (ENABLED / DISABLED)
SELECT constraint_name, constraint_type, table_name, status
FROM user_constraints
WHERE table_name IN ('EMPLOYEES', 'DEPARTMENTS', 'DEPARTMENTS2')
ORDER BY table_name, constraint_name;

-- Ver índices actuales
SELECT index_name, table_name, uniqueness, status
FROM user_indexes
WHERE table_name IN ('EMPLOYEES', 'DEPARTMENTS', 'DEPARTMENTS2')
ORDER BY table_name, index_name;

-- Ver contenido actual de DEPARTMENTS2
SELECT *
FROM departments2
ORDER BY department_id;