USE master
GO

CREATE DATABASE	prueba
GO

USE prueba
sp_helpfile	

USE master
GO

ALTER DATABASE	prueba
MODIFY FILE (NAME = 'prueba', SIZE = 100MB)

DBCC SHRINKDATABASE 
( 'Prueba', 10)

USE prueba
DBCC SHRINKFILE 
('prueba', 50, TRUNCATEONLY)
WITH NO_INFOMSGS