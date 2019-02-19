--Creación de la Base de datos de prueba
CREATE DATABASE [dbStorage] ON  PRIMARY 
( NAME = N'dbStorage', FILENAME = N'c:\dbStorage\dbStorage.mdf' , SIZE = 3072KB , FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'dbStorage_log', FILENAME = N'c:\dbStorage\dbStorage_log.ldf' , SIZE = 1024KB , FILEGROWTH = 10%)
GO

--Creación de los FileGroup
USE [master]
GO
ALTER DATABASE [dbStorage] ADD FILEGROUP [PFG01]
GO
ALTER DATABASE [dbStorage] ADD FILEGROUP [PFG02]
GO

--Creación de los DataFile
ALTER DATABASE [dbStorage] ADD FILE ( 
	NAME = N'PDF01', 
	FILENAME = N'C:\dbStorage\PDF01.ndf' , 
	SIZE = 3072KB , 
	FILEGROWTH = 1024KB ) TO FILEGROUP [PFG01]
GO
ALTER DATABASE [dbStorage] ADD FILE ( 
	NAME = N'PDF02', 
	FILENAME = N'C:\dbStorage\PDF02.ndf' , 
	SIZE = 3072KB , 
	FILEGROWTH = 1024KB ) TO FILEGROUP [PFG02]
GO

--Crea Tablas de prueba
USE [dbStorage]

CREATE TABLE Clientes (
 IdCliente INT NOT NULL, 
 NombreCliente VARCHAR(20) NOT NULL 
 ) ON PFG01
GO

CREATE TABLE Ordenes (
 IdCliente INT NOT NULL, 
 NumeroOrden INT IDENTITY NOT NULL,
 MontoOrden DECIMAL(10,2) NOT NULL DEFAULT 0
 )
GO
 
--Aqui mostrar los objetos y su ubicacion
 
--Crea Llaves e indices 
CREATE INDEX IX_Cliente_NombreCliente 
 ON Clientes(NombreCliente) 
 WITH (FILLFACTOR = 70)
 ON PFG02

ALTER TABLE Ordenes 
 ADD CONSTRAINT PK_Ordenes
 PRIMARY KEY (NumeroOrden)
 ON PFG01
 
CREATE INDEX IX_Ordenes_IdCliente_IncludeMontoOrden 
 ON Ordenes(IdCliente) INCLUDE (MontoOrden)
 WITH (FILLFACTOR = 70) 
 ON PFG02

--TABLES (HEAP, CLUSTERED INDEXES)
SELECT f.name, t.name, i.type_desc
FROM sys.objects t
 INNER JOIN sys.indexes i ON
  t.object_id = i.OBJECT_ID
  AND i.type IN (0, 1)
 INNER JOIN sys.filegroups f ON
  i.data_space_id = f.data_space_id 
WHERE t.TYPE IN ('S', 'U') --you can switch if only want user tables
ORDER BY f.name, t.name, i.type_desc
  
--NON CLUSTERED, XML  INDEXES
SELECT f.name, i.name, i.type_desc, t.name
FROM sys.tables t
 INNER JOIN sys.indexes i ON
  t.object_id = i.OBJECT_ID
  AND i.type NOT IN (0, 1)
 INNER JOIN sys.filegroups f ON
  i.data_space_id = f.data_space_id 