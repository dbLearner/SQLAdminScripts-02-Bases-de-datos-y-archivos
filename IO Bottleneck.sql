select *
from sys.dm_os_wait_stats  
where wait_type like 'PAGEIOLATCH%'
order by wait_type asc

select database_id, 
       file_id, 
       io_stall,
       io_pending_ms_ticks,
       scheduler_address 
from sys.dm_io_virtual_file_stats(NULL, NULL) iovfs,
     sys.dm_io_pending_io_requests as iopior
where iovfs.file_handle = iopior.io_handle