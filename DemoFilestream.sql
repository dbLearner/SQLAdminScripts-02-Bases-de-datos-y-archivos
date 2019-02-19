--COnfigurar FileStream en Configuratron Manager
EXEC sp_configure filestream_access_level, 2;
GO
RECONFIGURE;
GO

CREATE DATABASE [DemoFS]
GO

ALTER DATABASE DemoFS 
ADD FILEGROUP FileStreamGroup1 CONTAINS FILESTREAM;
GO

ALTER DATABASE DemoFS ADD FILE ( 
NAME = FSGroup1File, 
FILENAME = 'C:\FILESTREAM\Demo')
TO FILEGROUP FileStreamGroup1;
GO

USE DemoFS
GO

CREATE TABLE DemoFS (
DemoID int IDENTITY(1,1) NOT NULL, 
DemoFileStream varbinary(max) FILESTREAM NULL, 
FSGUID UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL UNIQUE DEFAULT NEWID()
) ON [PRIMARY]
FILESTREAM_ON FileStreamGroup1
GO

Insert into DemoFS (DemoFileStream )
SELECT * FROM 
OPENROWSET(BULK N'C:\Temp\TJTA Plata.zip' ,SINGLE_BLOB) AS Document

Select * from DemoFS 