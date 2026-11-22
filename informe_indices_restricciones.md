# Trabajo: Índices y restricciones en Oracle

* **Estudiante:** Anyi Cristina Ruano Adrada
* **Asignatura:** Base de Datos Avanzados
* **Profesor:** Deivis Eduard Ramírez Martínez
* **Fecha:** 23 de noviembre de 2026
* **Institución / Contacto:** Fundación Universitaria Internacional de la Rioja · Base de Datos Avanzados · `cristina1adrada@gmail.com`

---

## Resumen

Este informe muestra la realización de la actividad práctica sobre índices, restricciones, transacciones y archivos de Redo en Oracle, desarrollada en **Oracle FreeSQL (26ai)** sobre `My Schema` con las tablas `DEPARTMENTS`, `DEPARTMENTS2` y `EMPLOYEES`[cite: 1]. El trabajo se organiza en tres bloques: la consulta de índices y el ciclo de desactivación, violación y reactivación de restricciones; la duplicación de `DEPARTMENTS` en `DEPARTMENTS2`, el comportamiento de las transacciones al cerrar sesión, la ejecución de un bloque anónimo PL/SQL y el uso de `ROLLBACK` / `SAVEPOINT`; y el estudio de los *Redo Log Files* y los modos `NOARCHIVELOG` y `ARCHIVELOG`. Asimismo, se apuntan las incidencias surgidas durante la práctica —como la traducción automática del navegador, la conexión previa de la sesión y el error `ORA-00942` al consultar vistas `V$` sin privilegios administrativos en el entorno en la nube— junto con la estructura de los archivos `.sql` .[cite: 1].

---

## I. INTRODUCCIÓN

La integridad de los datos, el rendimiento en las consultas y la recuperabilidad ante fallos son base esencial en la administración de bases de datos relacionales en Oracle. A través de esta actividad se abordan de forma práctica cómo actúan los índices y las restricciones sobre las tablas, cómo se gestionan los cambios dentro de una sesión y una transacción, y qué papel cumplen los archivos de Redo en el funcionamiento interno del motor.

La práctica se adaptó al entorno en la nube **Oracle FreeSQL (26ai)** [1], desarrollando las instrucciones desde la hoja SQL y examinando los resultados en sus paneles de salida. Este documento reúne el paso a paso de cada tarea, la explicación de qué ocurre y a qué se debe en cada caso, los percances resueltos durante el proceso y la organización de los scripts `.sql` entregados[cite: 1].

---

## II. ÍNDICES Y RESTRICCIONES

### A. Inicio de sesión y verificación de tablas.

* **Tarea:** Iniciar sesión en el entorno y verificar el usuario activo y las tablas `EMPLOYEES` y `DEPARTMENTS`.
* **Qué ocurre y a qué se debe:** Al conectar la sesión en FreeSQL (26ai) [1], se faculta el espacio de trabajo del usuario (`My Schema`) [4], donde se hallan las tablas del ejercicio.

### B. Consulta de índices disponibles.

* **Tarea:** Consultar los índices existentes sobre `EMPLOYEES` y `DEPARTMENTS` (`USER_INDEXES` y `USER_IND_COLUMNS`) [1][2].
* **Qué ocurre y a qué se debe:** Se listan los índices asociados a ambas tablas (como los generados automáticamente al definir claves primarias o restricciones `UNIQUE` [3], además de índices secundarios), sus columnas y su estado (`VALID`). Oracle usa estos índices para aligerar búsquedas y comprobar unicidad.

### C. Desactivación de restricciones.

* **Tarea:** Consultar las restricciones de `EMPLOYEES` y `DEPARTMENTS` (`USER_CONSTRAINTS`) y desactivarlas (`ALTER TABLE ... DISABLE CONSTRAINT ...`, empleando `CASCADE` si una clave primaria/única es referenciada por una clave foránea) [1][2].
* **Qué ocurre y a qué se debe:** El estado de las restricciones pasa a `DISABLED`. Oracle suspende la comprobación automática de integridad al insertar, actualizar o borrar filas mientras permanezcan deshabilitadas.

### D. Inserción de tuplas que incumplen restricciones.

* **Tarea:** Insertar registros en `DEPARTMENTS` y `EMPLOYEES` que violen reglas previamente establecidas (por ejemplo, claves duplicadas, referencias inexistentes o valores inválidos).
* **Qué ocurre y a qué se debe:** Oracle acepta e inserta las filas sin lanzar error de restricción porque la validación de dichas reglas está desactivada.

### E. Reactivación de restricciones.

* **Tarea:** Volver a habilitar las restricciones (`ALTER TABLE ... ENABLE CONSTRAINT ...`) [2].
* **Qué ocurre y a qué se debe:** Si existen filas que infringen la restricción, Oracle rechaza la activación (con errores como `ORA-02299`, `ORA-02298` o `ORA-02293`) [5] hasta que se eliminen o corrijan los registros inválidos. Al limpiar los datos inválidos y volver a ejecutar `ENABLE`, las restricciones quedan activas y validadas.

---

## III. DEPARTMENTS2, SESIONES Y TRANSACCIONES

### A. Creación de DEPARTMENTS2.

* **Tarea:** Crear un duplicado de `DEPARTMENTS` llamado `DEPARTMENTS2` mediante `CREATE TABLE departments2 AS SELECT * FROM departments;`.
* **Qué ocurre y a qué se debe:** Se crea `DEPARTMENTS2` con las columnas y datos actuales de `DEPARTMENTS`, pero no se copian automáticamente todas las restricciones ni los índices originales. Al ser una sentencia DDL, Oracle ejecuta un `COMMIT` implícito [3][4].

### B. Inserción de tres tuplas en DEPARTMENTS2.

* **Tarea:** Insertar tres filas nuevas en `DEPARTMENTS2` mediante sentencias `INSERT`.
* **Qué ocurre y a qué se debe:** Las tuplas quedan registradas dentro de la transacción activa de la sesión (y en el espacio de *Undo*), pero no se consolidan de forma permanente hasta ejecutar `COMMIT` (salvo que el cliente/entorno tenga `AUTOCOMMIT` activo).

### C. Cierre de sesión.

* **Tarea:** Cerrar la sesión en FreeSQL.
* **Qué ocurre y a qué se debe:** Finaliza la sesión actual. En Oracle, al cerrar una sesión sin `COMMIT` previo (y sin autocommit), la base de datos realiza un `ROLLBACK` automático de las modificaciones DML no confirmadas para mantener la consistencia de los datos [2][3][4].

### D. Consulta de DEPARTMENTS2.

* **Tarea:** Consultar el contenido de `DEPARTMENTS2` (`SELECT * FROM departments2 ORDER BY department_id;`).
* **Qué ocurre y a qué se debe:** Se presentan las filas fijadas en `DEPARTMENTS2`. Si las tres inclusiones no se confirmaron antes de cerrar sesión, no aparecen en el resultado [2][3][4].

### E. Bloque anónimo con comienzo y finalización de transacción.

* **Tarea:** Ejecutar un bloque anónimo PL/SQL (`BEGIN ... END;`) sobre `DEPARTMENTS2` que exponga inicio y fin de transacción, ejecute operaciones DML, confirme con `COMMIT` (y maneje errores con `ROLLBACK` en `EXCEPTION`).
* **Qué ocurre y a qué se debe:** El bloque PL/SQL ejecuta las sentencias como unidad, envía los mensajes de inicio y fin a `DBMS_OUTPUT` (**DBMS Output**) y ratifica los cambios con `COMMIT` (o los revierte si ocurre una excepción).


### F. Cómo deshacer una transacción en Oracle (ROLLBACK) y ejemplo práctico.

* **Explicación:** En Oracle, una transacción DML no confirmada se deshace con `ROLLBACK` (revierte todos los cambios desde el inicio de la transacción o el último `COMMIT`). Con `SAVEPOINT` y `ROLLBACK TO SAVEPOINT nombre_punto` se deshacen solo las operaciones posteriores a ese punto intermedio.
* **Ejemplo práctico:** Se inserta una fila de prueba, se crea un `SAVEPOINT`, se elimina esa fila y luego se ejecuta `ROLLBACK TO SAVEPOINT`, recuperando el estado previo al borrado sin perder lo anterior de la transacción.

---

## IV. ARCHIVOS DE REDO Y MODOS DE FUNCIONAMIENTO.

### A. Qué son los archivos de Redo:

Los **Redo Log Files** (ficheros de rehacer) registran de forma secuencial todos los cambios ejecutados en los bloques de datos de la base de datos. Son fundamentales para la recuperación ante fallos de instancia o pérdidas de disco, permitiendo reaplicar cambios no volcados a los *datafiles* [1][5].

### B. Modos de funcionamiento

* **`NOARCHIVELOG`:** Cuando un grupo de Redo Log se llena y ya se completó el *checkpoint*, Oracle admite sobrescribirlo. Es más sencillo de administrar, pero no permite respaldos en caliente ni recuperación completa hasta un punto en el tiempo ante pérdida de *datafiles*.
* **`ARCHIVELOG`:** Antes de sobrescribir un grupo de Redo Log lleno, su contenido se copia a archivos de Redo archivados (*Archived Redo Logs*). Esto habilita las copias de seguridad en caliente y recuperación completa ante fallos de disco.

### C. Ejemplo práctico y percance ORA-00942 en FreeSQL.

* **Consulta de ejemplo:** `SELECT log_mode FROM v$database;` y `SELECT group#, sequence#, bytes, members, status, archived FROM v$log;`.
* **Percance encontrado:** Al ejecutar estas consultas en FreeSQL, Oracle entregó `ORA-00942: table or view "SYS"."V_$DATABASE" does not exist`. Esto ocurre porque las vistas `V$` corresponden a `SYS` y requieren privilegios administrativos; en un entorno gratuito compartido en la nube (`My Schema`), el usuario no tiene permisos para consultar estas vistas internas del sistema.

---

## V. CONCLUSIÓN

La realización de esta actividad permitió comprobar de forma práctica cómo interactúan las restricciones, los índices, las transacciones y los archivos de Redo para mantener la integridad, coherencia y recuperabilidad de una base de datos en Oracle [1][2][3][4][5].

Desactivar y reactivar restricciones demostró que Oracle impide validar reglas si existen datos que las infringen, mientras que los índices agilizan búsquedas y control de unicidad a costa de mantenimiento adicional ante cambios [1][2][3][4][5].

Asimismo, trabajar con `DEPARTMENTS2`, cierres de sesión, bloques anónimos PL/SQL, `COMMIT`, `SAVEPOINT` y `ROLLBACK` manifestó cómo se controla el ciclo de vida de las transacciones para evitar cambios parciales o no deseados [1][2][3][4][5].

Finalmente, el análisis de los *Redo Log Files* y los modos `NOARCHIVELOG` y `ARCHIVELOG` —junto con la adaptación a Oracle FreeSQL y la resolución de percances como la traducción automática, la conexión de sesión y el error `ORA-00942` por falta de privilegios administrativos sobre vistas `V$`— reforzó la importancia de comprender tanto la teoría del motor como las limitaciones reales de cada entorno [1][2][3][4][5].

---

## VI. NOTA ÉTICA Y DECLARACIÓN SOBRE EL USO DE INTELIGENCIA ARTIFICIAL

Se declara que este trabajo académico ha contado con la asistencia del modelo de inteligencia artificial Gemini (versión 3 Flash, desarrollada por Google LLC) bajo las siguientes pautas éticas:

* Manejado para estructurar y maquetar el contenido bajo el formato estándar IEEE / Markdown técnico.
* Usado para tutoría metodológica asistida, indagación conceptual y consulta técnica asistida.

El control conceptual, las propuestas de diseño, la revisión técnica y la validez de los argumentos presentados en este informe son responsabilidad directa y exclusiva del autor.

---

## VII. REFERENCIAS

* [1] Oracle. (s. f.). *Oracle FreeSQL* [Aplicación web]. Recuperado el 22 de noviembre de 2026, de https://freesql.com/
* [2] Oracle. (s. f.). *Oracle Database SQL Language Reference: ALTER TABLE, CREATE TABLE, COMMIT, ROLLBACK, SAVEPOINT*. Oracle Help Center.
* [3] Oracle. (s. f.). *Oracle Database PL/SQL Language Reference: Anonymous Blocks*. Oracle Help Center.
* [4] Oracle. (s. f.). *Oracle Database Concepts: Schema Objects (Indexes and Integrity Constraints), Data Concurrency and Consistency, and Managing the Redo Log*. Oracle Help Center.
* [5] Oracle. (s. f.). *Oracle Database Error Messages Reference: ORA-00942, ORA-02293, ORA-02298, ORA-02299*. Oracle Help Center.
