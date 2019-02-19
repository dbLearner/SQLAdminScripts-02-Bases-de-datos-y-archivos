USE Master
GO

-- Determine the original database status
SELECT [Name], DBID, Status
FROM master.dbo.sysdatabases 
GO

-- Enable system changes
sp_configure 'allow updates',1
GO
RECONFIGURE WITH OVERRIDE
GO

-- Update the database status
UPDATE master.dbo.sysdatabases 
SET Status = 24 
WHERE [Name] = 'YourDatabaseName'
GO

-- Disable system changes
sp_configure 'allow updates',0
GO
RECONFIGURE WITH OVERRIDE
GO

-- Determine the final database status
SELECT [Name], DBID, Status
FROM master.dbo.sysdatabases 
GO

DBCC CHECKDB
DBCC CHECKCATALOG
DBCC CHECKTABLE

Drop and Recreate Index(es) 
Update statistics 
DBCC UPDATEUSAGE 
sp_recompile 
