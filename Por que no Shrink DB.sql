--<Creamos Una Base de Datos de Prueba>
USE MASTER
CREATE DATABASE dbPorQueNoEncoger
GO
USE dbPorQueNoEncoger
--</>

--<Creamos una primera tabla de pruebas para rellenar datos al principio del archivo de datos>
--Usamos un char(8000) para que ocupe bastante espacio
CREATE TABLE Test1 (campo1 INT IDENTITY, campo2 CHAR(8000) DEFAULT REPLICATE('-', 8000))

-- rellenamos la primera tabla de prueba con 1000 registros (Aprox 8Mb)
INSERT INTO Test1 DEFAULT VALUES
GO 1000 --Esto es para que repita 1000 veces la sentencia insert

SELECT * FROM Test1 
--</>

--<Creamos una segunda tabla, identica a la primera pero con un índice>
CREATE TABLE Test2 (campo1 INT IDENTITY, campo2 CHAR(8000) DEFAULT REPLICATE('-', 8000))

--Creamos un indice de tipo CLUSTERED (Agrupado)
CREATE CLUSTERED INDEX IDX2_test2_Campo1 ON test2 (campo1)

-- rellenamos la segunda tabla de prueba con 1000 registros (Aprox 8Mb)
INSERT INTO Test2 DEFAULT VALUES
GO 1000 --Esto es para que repita 1000 veces la sentencia insert

SELECT * FROM Test2
--</>

--Verificamos las estadísticas físicas del índice usando la funcion sys.dm_db_index_physical_stats
SELECT avg_fragmentation_in_percent FROM sys.dm_db_index_physical_stats (
    DB_ID (), OBJECT_ID ('Test2'), 1, Null, Null)
    
--Eliminamos la primera tabla para dejar espacio libre al inicio del archivo de datos
DROP TABLE Test1

--Probamos con Truncate Only - No se fragmenta el indice pero no se encoge la BD
DBCC SHRINKFILE ('dbPorQueNoEncoger', TRUNCATEONLY)

--Encogemos el archivo de datos
DBCC SHRINKFILE ('dbPorQueNoEncoger')


--Verificamos las estadísticas físicas del índice usando la funcion sys.dm_db_index_physical_stats
SELECT avg_fragmentation_in_percent FROM sys.dm_db_index_physical_stats (
    DB_ID (), OBJECT_ID ('Test2'), 1, Null, Null)

--Reorganizacmos el Indice
ALTER INDEX IDX2_test2_Campo1 ON Test2 REORGANIZE

--Verificamos las estadísticas físicas del índice usando la funcion sys.dm_db_index_physical_stats
SELECT avg_fragmentation_in_percent FROM sys.dm_db_index_physical_stats (
    DB_ID (), OBJECT_ID ('Test2'), 1, Null, Null)

USE MASTER 
DROP DATABASE dbPorQueNoEncoger
