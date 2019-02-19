DBCC CHECKDB('MarketDev');
GO

DBCC CHECKDB('MarketDev') WITH NO_INFOMSGS;
GO

RESTORE DATABASE CorruptDB
FROM DISK = ??
WITH MOVE ??
     MOVE ??
GO

DBCC CHECKDB('CorruptDB') WITH NO_INFOMSGS;
GO

SELECT * FROM CorruptDB.dbo.Orders;
GO

SELECT * FROM CorruptDB.dbo.Orders WHERE OrderID = 10400;
GO

ALTER DATABASE CorruptDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

DBCC CHECKDB('CorruptDB', REPAIR_ALLOW_DATA_LOSS);
GO

ALTER DATABASE CorruptDB SET MULTI_USER WITH ROLLBACK IMMEDIATE;
GO

SELECT * FROM CorruptDB.dbo.Orders;
GO

DBCC CHECKDB('CorruptDB') WITH NO_INFOMSGS;
GO

SELECT DISTINCT OrderID 
FROM CorruptDB.dbo.[order details] AS od
WHERE NOT EXISTS (SELECT 1 
                  FROM CorruptDB.dbo.Orders AS o
                  WHERE o.orderid = od.orderid);
GO
	

DROP DATABASE CorruptDB;
GO
