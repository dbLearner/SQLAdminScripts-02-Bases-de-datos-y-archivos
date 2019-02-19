USE master
GO

--Tabla temporal para contener los resultados de la consulta
IF EXISTS (select * from tempdb.sys.tables WHERE name like '#DatabaseFiles%')
  DROP TABLE #DatabaseFiles

CREATE TABLE #DatabaseFiles(
	bdID smallint NULL,
	bd nvarchar(128) NULL,
	ArchivoId int NOT NULL,
	TipoArchivo nvarchar(60) NULL,
	NombreArchivo sysname NOT NULL,
	Unidad nvarchar(2) NULL,
	ArchivoFisico nvarchar(260) NOT NULL,
	TamañoMB numeric(17, 6) NULL,
	EspacioLibreMB numeric(18, 6) NULL,
	PctLibre numeric(38, 16) NULL,
	TamañoMaximoMB varchar(30) NULL,
	CrecimientoEnPct bit NOT NULL,
	CrecimientoMB varchar(31) NULL
) 
GO

--consulta utilizando sp_MSforeachdb para iterar por todas las bases de datos
EXEC sp_MSforeachdb
@command1='use ?;
INSERT INTO #DatabaseFiles (bdID,bd,ArchivoId,TipoArchivo,NombreArchivo,Unidad,ArchivoFisico,
             TamañoMB,EspacioLibreMB,PctLibre,TamañoMaximoMB,CrecimientoEnPct,
             CrecimientoMB)
SELECT 
  DB_ID()						AS BaseDatosID,
  DB_NAME()		AS BaseDatos,
  file_id, 
  type_desc					AS TipoArchivo, 
  name						AS NombreArchivo, 
  LEFT(physical_name,2)		AS Unidad, 
  physical_name				AS ArchivoFisico, 
  --size, 
  size/128.0	AS TamañoMB, 
  size/128.0 - CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT)/128.0 AS EspacioLibreMB, 
  ((size/128.0 - CAST(FILEPROPERTY(name, ''SpaceUsed'') AS INT)/128.0)/(size/128.0))*100 AS PctLibre,
  CASE max_size 
    WHEN -1 THEN ''Ilimitado''
    ELSE CAST(ROUND((max_size*8.)/1024.00,0) AS VARCHAR(30))
  END TamañoMaximoMB, 
  is_percent_growth			AS EsCrecimientoEnPorcentaje,
  CASE is_percent_growth
    WHEN 1 THEN RTRIM(CAST(growth AS VARCHAR(30)))+''%''
    ELSE CAST(ROUND((growth*8.)/1024.00,0) AS VARCHAR(30))
  END CrecimientoMB 
FROM sys.database_files'
GO

--Consulta final
SELECT bdID,bd,ArchivoId,TipoArchivo,NombreArchivo,Unidad,ArchivoFisico,
             TamañoMB,EspacioLibreMB,PctLibre,TamañoMaximoMB,CrecimientoEnPct,
             CrecimientoMB
FROM #DatabaseFiles
GO
