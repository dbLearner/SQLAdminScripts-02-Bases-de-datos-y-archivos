--select * from sys.database_files
select db_name(),
    name,
    cast((size/128.0) as int) as TotalSpaceInMB,
    cast((cast(fileproperty(name, 'SpaceUsed') as int)/128.0) as int) as UsedSpaceInMB,
    cast((size/128.0 - cast(fileproperty(name, 'SpaceUsed') AS int)/128.0) as int) as FreeSpaceInMB
from
    sys.database_files
GO


DBCC SHOWFILESTATS
select (8000*64)/1024, (3093*64)/1024, (8000*64)/1024 - (3093*64)/1024

select * from sys.dm_io_virtual_file_stats(db_id('mdCompras'),1)

select * from sys.fn_virtualfilestats(db_id('mdCompras'),1)
