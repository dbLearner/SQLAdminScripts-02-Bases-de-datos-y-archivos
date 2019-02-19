USE master
EXEC sp_configure 'Cross DB Ownership Chaining', '0'; RECONFIGURE WITH OVERRIDE

exec sp_dboption 'dbFIW', 'db chaining', 'true'
exec sp_dboption 'stgFIW', 'db chaining', 'true'
