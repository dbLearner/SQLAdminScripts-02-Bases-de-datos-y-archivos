SET NOCOUNT ON
DECLARE @NombreLogicoArchivo sysname,
        @MaxMinutos INT,
        @NuevoTamano INT

-- Indique aquí su configuración.
USE    mdFIW-- Nombre de la base de datos para el que se va a truncar el registro
-- Use sp_helpfile para identificar el nombre de archivo lógico que desea reducir.
SELECT  @NombreLogicoArchivo = 'mdFIW_Log',  
        @MaxMinutos = 10,    -- Límite de tiempo permitido para dar la vuelta al registro. 
        @NuevoTamano = 2   -- en MB

-- Configuración e inicio 
DECLARE @TamanoOriginal int
SELECT @TamanoOriginal = size -- en páginas de 8 KB 
  FROM sysfiles
  WHERE name = @NombreLogicoArchivo 
SELECT ' El tamaño original del registro de ' + db_name() + ' es ' + CONVERT(VARCHAR(30),@TamanoOriginal) + ' páginas de 8 KB ó ' + CONVERT(VARCHAR(30),(@TamanoOriginal *8/1024)) + 'MB'
  FROM sysfiles
  WHERE name = @NombreLogicoArchivo 
CREATE TABLE DummyTrans(DummyColumna char (8000) not null)


-- Dar la vuelta al registro y truncarlo. 
DECLARE @Contador   INT,
        @HoraInicio DATETIME,
        @Query  VARCHAR(255)
SELECT  @HoraInicio = GETDATE(),@Query = 'BACKUP LOG ' + db_name() + ' WITH TRUNCATE_ONLY'
-- Intentar una reducción inicial. 
DBCC SHRINKFILE (@NombreLogicoArchivo, @NuevoTamano)
EXEC (@Query)
-- Dar la vuelta al registro, si es necesario.
-- no se ha excedido el máximo tiempo establecido 
WHILE     @MaxMinutos > DATEDIFF (mi, @HoraInicio, GETDATE())
-- no se ha reducido el registro 
      AND @TamanoOriginal = (SELECT size FROM sysfiles WHERE name = @NombreLogicoArchivo)  
-- El valor pasado para el tamaño nuevo es más pequeño que el tamaño actual. 
      AND (@TamanoOriginal * 8 /1024) > @NuevoTamano  
  BEGIN -- Bucle externo. 
    SELECT @Contador = 0 
    WHILE  ((@Contador < @TamanoOriginal / 16) AND (@Contador < 50000))
    BEGIN -- Actualización 
-- Como es un campo de tipo char, inserta 8000 bytes.
     
     INSERT DummyTrans VALUES ('Llenar registro')  
        DELETE DummyTrans
        SELECT @Contador = @Contador + 1
    END   -- Actualización Probar si un truncamiento reduce de tamaño el registro. 
    EXEC (@Query)  
  END   -- Bucle externo
 
SELECT ' El tamaño final del registro de ' + db_name() + ' es de ' + CONVERT(VARCHAR(30),size) + ' páginas de 8 KB ó ' + CONVERT(VARCHAR(30),(size*8/1024)) + 'MB'
  FROM sysfiles 
  WHERE name = @NombreLogicoArchivo
DROP TABLE DummyTrans

Declare @Device VARCHAR(255), @DeviceQ VARCHAR(255), @DeviceFile VARCHAR(255) 
SELECT @Device = db_name() + ' ' + right('00'+rtrim(cast(day(getdate()) as char(2))),2) + '-' + right('00'+rtrim(cast(month(getdate()) as char(2))),2) + '-' + right(cast(year(getdate()) as char(4)), 2)
SELECT @DeviceQ = '[' + db_name() + ' ' + right('00'+rtrim(cast(day(getdate()) as char(2))),2) + '-' + right('00'+rtrim(cast(month(getdate()) as char(2))),2) + '-' + right(cast(year(getdate()) as char(4)), 2) + ']'
Select @DeviceFile = 'c:\' + @Device + '.Bak'

exec sp_addumpdevice 'DISK', @Device, @DeviceFile 

SELECT @Query = 'BACKUP DATABASE ' + db_name() + ' TO ' + @DeviceQ
EXEC (@Query)  

exec sp_dropdevice @Device

SET NOCOUNT OFF