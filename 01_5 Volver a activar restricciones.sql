-- 1.5 Volver a activar restricciones
ALTER TABLE departments ENABLE CONSTRAINT dept_id_pk;
ALTER TABLE departments ENABLE CONSTRAINT dept_loc_fk;
ALTER TABLE departments ENABLE CONSTRAINT dept_mgr_fk;

ALTER TABLE employees ENABLE CONSTRAINT emp_emp_id_pk;
ALTER TABLE employees ENABLE CONSTRAINT emp_email_uk;
ALTER TABLE employees ENABLE CONSTRAINT emp_salary_min;
ALTER TABLE employees ENABLE CONSTRAINT emp_dept_fk;
ALTER TABLE employees ENABLE CONSTRAINT emp_job_fk;
ALTER TABLE employees ENABLE CONSTRAINT emp_manager_fk;