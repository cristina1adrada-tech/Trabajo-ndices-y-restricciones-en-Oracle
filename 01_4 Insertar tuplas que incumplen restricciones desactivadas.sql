-- 1.4 Insertar tuplas que incumplen restricciones desactivadas
INSERT INTO departments (department_id, department_name, manager_id, location_id)
VALUES (10, 'Dept Prueba Violacion', 999999, 9999);

INSERT INTO employees (
    employee_id, first_name, last_name, email, phone_number,
    hire_date, job_id, salary, commission_pct, manager_id, department_id
)
VALUES (
    100, 'NombrePrueba', 'ApellidoPrueba', 'SKING', '000.000.0000',
    DATE '2026-01-01', 'IT_PROG', -500, NULL, 999999, 999
);