--Obtener objetos modificados desde una fecha
USE AdventureWorks
GO

SELECT name AS object_name,
SCHEMA_NAME(schema_id) AS schema_name,
type_desc,
create_date,
modify_date
FROM sys.objects
WHERE YEAR(modify_date) > 2008
ORDER BY modify_date
GO

--Estadísticas físicas de indices
USE AdventureWorks
GO

SELECT a.index_id as [Index ID], name as [Index Name],
avg_fragmentation_in_percent as Fragmentation
FROM sys.dm_db_index_physical_stats (DB_ID(N'AdventureWorks'),
OBJECT_ID('HumanResources.Employee'),NULL, NULL, NULL) AS a
JOIN sys.indexes AS b ON a.object_id = b.object_id AND a.index_id =
b.index_id
ORDER BY Fragmentation DESC
GO

--Estadísticas de uso de indices
SELECT o.name AS object_name, i.name AS index_name, 
               i.type_desc, u.user_seeks, u.user_scans, u.user_lookups, u.user_updates
FROM sys.indexes i
JOIN sys.objects o
ON i.object_id = o.object_id
LEFT JOIN sys.dm_db_index_usage_stats u
ON i.object_id = u.object_id
AND i.index_id = u.index_id
AND u.database_id = DB_ID()
WHERE o.type <> 'S' -- Evita la inclusion de tablas del sistema
ORDER BY (ISNULL(u.user_seeks, 0) + ISNULL(u.user_scans, 0) + ISNULL(u.user_lookups, 0) 
   + ISNULL(u.user_updates, 0)) desc, o.name, i.name
GO

--Indices faltantes
USE AdventureWorks
SELECT h.SalesOrderID, h.OrderDate, h.DueDate, h.TotalDue, 
               p.[Name] AS Product_Name, d.OrderQty, d.UnitPrice, d.LineTotal
FROM Sales.SalesOrderDetail d
JOIN Sales.SalesOrderHeader h
ON h.SalesOrderID = d.SalesOrderID
JOIN Production.Product p
ON d.ProductID = p.ProductID
WHERE h.OrderDate >= DATEADD(yy, -6, GETDATE())
AND h.TotalDue >= 20000
GO

SELECT * 
FROM sys.dm_db_missing_index_details 
WHERE database_id =DB_ID()
GO

--Monitoreo de actividad actual
SELECT  
  D.text SQLStatement, 
  A.Session_ID SPID, 
  ISNULL(B.status,A.status) Status, 
  A.login_name Login, 
  A.host_name HostName, 
  C.BlkBy,  
  DB_NAME(B.Database_ID) DBName, 
  B.command, 
  ISNULL(B.cpu_time, A.cpu_time) CPUTime, 
  ISNULL((B.reads + B.writes), (A.reads + A.writes)) DiskIO,  
  A.last_request_start_time LastBatch, 
  A.program_name
  FROM    
    sys.dm_exec_sessions A    
    LEFT JOIN    sys.dm_exec_requests B    ON 
      A.session_id = B.session_id   
    LEFT JOIN       (        
      SELECT                 
        A.request_session_id SPID,
        B.blocking_session_id BlkBy
        FROM sys.dm_tran_locks as A             
         INNER JOIN sys.dm_os_waiting_tasks as B ON 
          A.lock_owner_address = B.resource_address        ) C    ON 
           A.Session_ID = C.SPID   OUTER APPLY sys.dm_exec_sql_text(sql_handle) D
GO

--Identifica bloqueos
/*INICIA BLOQUEOS*/
SELECT * FROM sys.dm_tran_locks
GO

-- iniciar transaction generando bloqueos
USE AdventureWorks
GO

BEGIN TRANSACTION
UPDATE Production.ProductCategory
SET [Name] = [Name] + ' - Bike Stuff'
GO

--View locks for current user process
SELECT * FROM sys.dm_tran_locks
WHERE request_session_id = @@spid
GO

-- Update another table - will create locks
UPDATE Production.Product
SET ListPrice = ListPrice * 1.1
GO

--View locks for current user process
SELECT * FROM sys.dm_tran_locks
WHERE request_session_id = @@spid
GO

-- rollback transaction - will release locks
ROLLBACK TRANSACTION
GO

--View locks for current user process
SELECT * FROM sys.dm_tran_locks
WHERE request_session_id = @@spid
GO
/*FIN EJEMPLO BLOQUEOS*/

--Listado de vistas dinámicas
SELECT [name], [type], type_desc
FROM sys.system_objects
WHERE NAME LIKE 'dm%'
ORDER BY [name]
GO