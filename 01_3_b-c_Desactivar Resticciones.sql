-- 1.3.b Desactivar restricciones (ajusta los nombres si tu esquema usa otros)
ALTER TABLE employees DISABLE CONSTRAINT emp_dept_fk;
ALTER TABLE employees DISABLE CONSTRAINT emp_job_fk;
ALTER TABLE employees DISABLE CONSTRAINT emp_manager_fk;
ALTER TABLE employees DISABLE CONSTRAINT emp_email_uk;
ALTER TABLE employees DISABLE CONSTRAINT emp_salary_min;
ALTER TABLE employees DISABLE CONSTRAINT emp_emp_id_pk CASCADE;

ALTER TABLE departments DISABLE CONSTRAINT dept_loc_fk;
ALTER TABLE departments DISABLE CONSTRAINT dept_mgr_fk;
ALTER TABLE departments DISABLE CONSTRAINT dept_id_pk CASCADE;

-- 1.3.c Verificar que quedaron en DISABLED
SELECT constraint_name, table_name, status
FROM user_constraints
WHERE table_name IN ('EMPLOYEES', 'DEPARTMENTS')
ORDER BY table_name, constraint_name;