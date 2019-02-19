--Mover Tempdb
USE tempdb

EXEC sys.sp_helpfile

ALTER DATABASE tempdb
MODIFY FILE (NAME='tempdev', FILENAME='D:\SQLTemp\tempdb.mdf');

ALTER DATABASE tempdb
MODIFY FILE (NAME='tempdev1', FILENAME='D:\SQLTemp\tempdev1.ndf');

ALTER DATABASE tempdb
MODIFY FILE (NAME='tempdev2', FILENAME='D:\SQLTemp\tempdev2.ndf');

ALTER DATABASE tempdb
MODIFY FILE (NAME='tempdev3', FILENAME='D:\SQLTemp\tempdev3.ndf');

ALTER DATABASE tempdb
MODIFY FILE (NAME='templog', FILENAME='D:\SQLTemp\templog.ldf');
