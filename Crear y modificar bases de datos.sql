USE master
GO
--<Creación de la Base de Datos dbTest>
CREATE DATABASE [dbTest] ON  PRIMARY 
( NAME = N'dbTest_data', 
  FILENAME = N'C:\dbData\dbTest_data.mdf' , 
  SIZE = 100MB , 
  MAXSIZE = UNLIMITED, 
  FILEGROWTH = 25MB )
 LOG ON 
( NAME = 'dbTest_log', 
  FILENAME = 'C:\dbData\dbTest_log.ldf' , 
  SIZE = 20MB , 
  MAXSIZE = 80MB , 
  FILEGROWTH = 15%)
COLLATE Modern_Spanish_CI_AI
GO
--</>

--<Aumentar el tamaño del archivo>
ALTER DATABASE dbTest
MODIFY FILE
(NAME = 'dbTest_data',
 SIZE = 500MB)
GO
--</>

--<Disminuir el tamaño del archivo>
Use dbTest
DBCC SHRINKFILE ('dbTest_data', 250)
GO
--</>

USE master
GO

DROP DATABASE dbTest
GO

--<Creación de la Base de Datos Personel>
CREATE DATABASE Personal
ON PRIMARY
(NAME = N'PersData1', 
 FILENAME = N'C:\dbData\PersData1.mdf',
 SIZE = 5 MB, MAXSIZE = 10 MB, 
 FILEGROWTH = 0),
 FILEGROUP PersDef DEFAULT
(NAME = N'PersData2', 
 FILENAME = N'C:\dbData\PersData2.ndf',
 SIZE = 100 MB, 
 MAXSIZE = 200 MB, 
 FILEGROWTH = 0),
(NAME = N'PersData3', 
 FILENAME = N'C:\dbData\PersData3.ndf',
 SIZE = 100 MB, 
 MAXSIZE = 200 MB, 
 FILEGROWTH = 0)
LOG ON
(NAME = N'PersLog', 
 FILENAME =N'C:\dbData\PersLog.ldf',
 SIZE = 25 MB, 
 MAXSIZE = 50 MB, 
 FILEGROWTH = 0)
GO
--</>