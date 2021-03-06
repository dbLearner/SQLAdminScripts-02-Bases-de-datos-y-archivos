ALTER procedure [dbo].[usp_create_snapshot](@databasename sysname
                                    , @SQLInstance varchar(10) = 'MSSQL.1'
                                    , @debug bit = 0
                                    , @verbose bit = 1) as
/*
    Name            usp_create_snapshot
    author            Wilfred van Dijk (www.wilfredvandijk.nl)
    Description        Creates a snapshot of given database
    Parameters        @databasename
                    @SQLInstance
                    @debug
                    @verbose
    Returns            null - ok
                    1 - Snapshot not supported

    Date            20080422
    Author            WvDijk
    Comments        initial release

    Date            20080515
    Author            WvDijk
    Comments        fixed backslash issue

    Date            20080519
    Author            WvDijk
    Comments        fixed multifile issue

*/
begin
    declare @SQLCmd nvarchar(max)
    declare @RegPath varchar(512)
    declare @DataPath varchar(256)
    declare @LogicalName sysname
    declare @ss_stamp char(12)
    Declare @SS_DB sysname

/*
    Snapshots are only supported on Enterprise editions
*/
    if CAST(serverproperty('Edition') AS VARCHAR) not like 'Enterprise%'
        begin
            if @verbose = 1
                raiserror('This SQL Server edition does not support snapshots',10,1)
            return 1
        end
/*
    Get default datapath from registry
*/
    Set        @RegPath = 'SOFTWARE\Microsoft\Microsoft SQL Server\' + @SQLInstance + '\MSSQLServer'
    EXEC    master..xp_regread 'HKEY_LOCAL_MACHINE', @RegPath, 'DefaultData', @value=@DataPath OUTPUT
/*
    Timestamp is in format YYYYMMSSHHMI
*/
    set        @ss_stamp = LEFT(REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR,GETDATE(),120),'-',''),':',''),' ',''),12)
    set        @ss_db = @databasename + '_ss_' + @ss_stamp
/*
    Make sure database exists ...
*/
    if not exists(select 'yes' from master.sys.databases where name = @databasename and source_database_id is null)
        begin
            raiserror('Specified database (%s) not found.',16,1,@databasename)
            return 1
        end

    Declare c_logicalname cursor for
        select    name
        from    master.sys.master_files
        where    database_id = DB_ID(@Databasename)
        and        type_desc = 'ROWS'

    open    c_logicalname
    fetch    next
    from    c_logicalname
    into    @logicalname

    set        @SQLCmd = 'CREATE DATABASE '+ @ss_db + ' On '+ char(13)
    set        @SQLCmd = @SQLCmd + '(name = '+ @logicalname +', filename = '''+ @datapath + '\' + @logicalname + '.ss'')'+ char(13)

    fetch    next
    from    c_logicalname
    into    @logicalname

    while    @@fetch_status = 0
        begin
            set        @SQLCmd = @SQLCmd + ',(name = '+ @logicalname +', filename = '''+ @datapath + '\' + @logicalname + '.ss'')'+ char(13)
            fetch    next
            from    c_logicalname
            into    @logicalname
        end

    close    c_logicalname
    deallocate c_logicalname

    set        @SQLCmd = @SQLCmd + 'AS SNAPSHOT OF ' + @Databasename

    if @verbose = 1
        begin
            print '- Source database : ' + @Databasename
            print '- Creating snapshot : ' + @ss_db
            print '- Snapshot is located in ' + char(39) + @Datapath + char(39)
        end

    if @debug = 1
        print    char(13) + @SQLCmd + char(13)
    else
        exec    (@SQLCmd)

end