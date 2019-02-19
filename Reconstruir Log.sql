IF EXISTS (SELECT * FROM sys.databases WHERE name = 'DemoFS')
  DROP DATABASE [DemoFS] 

CREATE DATABASE [DemoFS] ON  PRIMARY 
( NAME = 'DemoFS_Data1', 
  FILENAME = 'C:\Data\DemoFS_Data1.mdf' , 
  SIZE = 2304KB , 
  MAXSIZE = UNLIMITED, 
  FILEGROWTH = 1024KB ),
( NAME = 'DemoFS_Data2', 
  FILENAME = 'C:\Data\DemoFS_Data2.mdf' , 
  SIZE = 2304KB , 
  MAXSIZE = UNLIMITED, 
  FILEGROWTH = 1024KB )
 LOG ON 
( NAME = 'DemoFS_log', 
  FILENAME = 'C:\DATA\DemoFS_log.LDF' , 
  SIZE = 504KB , 
  MAXSIZE = 2048GB , 
  FILEGROWTH = 10%)
GO

--***************************************************************--
-- ESTAS SENTENCIAS SOLO FUNCIONAN PARA BDs CON UN SOLO DataFile --
--***************************************************************--
--separar la base de datos del servidor
sp_detach_db 'DemoFS'
go

--Aqui tienes que ubicar fisicamente el archivo de log en el sistema de archivos y borrarlo

--adjuntar solo el archivo de datos al servidor de modo que se reconstruya el archivo de transaction log
EXEC sp_attach_single_file_db @dbname = 'DemoFS', 
   @physname = 'C:\DATA\DemoFS.mdf'
GO