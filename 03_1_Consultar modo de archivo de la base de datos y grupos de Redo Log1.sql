-- 3.1 Consultar modo de archivo de la base de datos y grupos de Redo Log
GRANT SELECT ON SYS.V_$DATABASE TO <cristina1adrada@gmail.com>;
SELECT group#, sequence#, bytes, members, status, archived FROM v$log;