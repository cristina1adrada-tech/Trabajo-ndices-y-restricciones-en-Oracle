-- 2.5 Ejemplo practico de SAVEPOINT y ROLLBACK
INSERT INTO departments2 VALUES (401, 'Temporal Prueba', NULL, 1700);

SAVEPOINT sp_antes_borrar;

DELETE FROM departments2 WHERE department_id = 401;

-- Deshace solo el DELETE anterior y conserva la fila 401 previa al SAVEPOINT
ROLLBACK TO SAVEPOINT sp_antes_borrar;

-- Para deshacer toda la transaccion actual desde el ultimo COMMIT:
-- ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('ERROR EN TRANSACCION. SE EJECUTO ROLLBACK: ' || SQLERRM);
    RAISE;
END;
/