DECLARE @Query varchar(50)

DECLARE @NombreLogicoArchivo sysname
SET @NombreLogicoArchivo = 'dbfiw_log'

DECLARE @TamanoOriginal int
SELECT @TamanoOriginal = size -- en p�ginas de 8 KB 
  FROM sysfiles
  WHERE name = @NombreLogicoArchivo 

USE dbFIW

exec sp_addumpdevice 'disk', 'MiBdBak', 'c:\MiBdBak.bak'

SELECT ' El tama�o original del registro de ' + db_name() + ' es ' + CONVERT(VARCHAR(30),@TamanoOriginal) + ' p�ginas de 8 KB � ' + CONVERT(VARCHAR(30),(@TamanoOriginal *8/1024)) + 'MB'

Set @Query = 'backup database ' + db_name() + ' to MiBdBak'
Exec (@Query)

Set @Query = 'backup log ' + db_name() + ' with truncate_only'

SELECT ' El tama�o final del registro de ' + db_name() + ' es de ' + CONVERT(VARCHAR(30),size) + ' p�ginas de 8 KB � ' + CONVERT(VARCHAR(30),(size*8/1024)) + 'MB'
  FROM sysfiles
  WHERE name = @NombreLogicoArchivo 

exec sp_dropdevice 'MiBdBak'

Select 'Si el tama�o inicial y final son los mismos, ejeute el proceso avanzado'