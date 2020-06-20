/*

sysadmDB: Usuário de sistema
sysadmDBMaster : Usuário de Sistema (Grant 100%)

*/


CREATE DATABASE IF NOT EXISTS ctbsDB_homol CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE USER 'sysadmDBHomol'@'%' IDENTIFIED BY '#MonedHO';
--GRANT CREATE, ALTER, INDEX, LOCK TABLES, REFERENCES, UPDATE, DELETE, DROP, SELECT, INSERT ON `ctbsDB_homol`.* TO 'sysadmDBHomol'@'%';

--Acesso 100%
GRANT ALL PRIVILEGES ON ctbsDB_homol.* TO sysadmDBHomol@'%' WITH GRANT OPTION;
GRANT ALTER ROUTINE,CREATE ROUTINE, EXECUTE ON * TO sysadmDBHomol@'%';

FLUSH PRIVILEGES;