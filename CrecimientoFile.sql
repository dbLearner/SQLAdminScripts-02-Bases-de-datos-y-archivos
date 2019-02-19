use Recolsa

Select * from sysfiles

USE master
GO
ALTER DATABASE [Recolsa] MODIFY FILE ( NAME = N'Sidige_Data02', FILEGROWTH = 100MB )
GO
ALTER DATABASE [Recolsa] MODIFY FILE ( NAME = N'Sidige_Data03', FILEGROWTH = 100MB )
GO
ALTER DATABASE [Recolsa] MODIFY FILE ( NAME = N'Sidige_Data', FILEGROWTH = 100MB )
GO
ALTER DATABASE [Recolsa] MODIFY FILE ( NAME = N'Sidige_Log', MAXSIZE = 500MB , FILEGROWTH = 50MB )
GO
