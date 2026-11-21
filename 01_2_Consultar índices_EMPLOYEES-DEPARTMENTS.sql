-- 1.2 Consultar indices y columnas indexadas en EMPLOYEES y DEPARTMENTS
SELECT index_name, table_name, index_type, uniqueness, status
FROM user_indexes
WHERE table_name IN ('EMPLOYEES', 'DEPARTMENTS')
ORDER BY table_name, index_name;

SELECT index_name, table_name, column_name, column_position
FROM user_ind_columns
WHERE table_name IN ('EMPLOYEES', 'DEPARTMENTS')
ORDER BY table_name, index_name, column_position;