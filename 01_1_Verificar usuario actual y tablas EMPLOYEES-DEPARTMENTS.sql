-- 1.1 Verificar usuario actual y tablas EMPLOYEES / DEPARTMENTS
SELECT USER AS usuario_actual FROM dual;

SELECT table_name
FROM user_tables
WHERE table_name IN ('EMPLOYEES', 'DEPARTMENTS')
ORDER BY table_name;