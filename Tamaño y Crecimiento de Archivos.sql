SELECT 
    name AS [Archivo], 
    size*1.0/128 AS [Tama�o en MB],
    CASE max_size 
        WHEN 0 THEN 'Autocrecimiento Deshabilitado'
        WHEN -1 THEN 'Autocrecimiento Habilitado sin l�mite'
        ELSE 'Autocrecimiento Habilitado pero con l�mite' 
    END [Autocrecimiento],
    growth AS [Valor de Crecimiento],
    CASE
        WHEN growth = 0 THEN 'Tama�o fijo, no va a crecer'
        WHEN growth > 0 AND is_percent_growth = 0 THEN 'Valor de crecimiento en p�ginas de 8-KB'
        ELSE 'Valor de crecimiento porcentual'
    END [Tipo de Crecimiento]
FROM sys.database_files;
GO


EXEC sp_MSforeachdb
'SELECT 
    name AS [Archivo], 
    size*1.0/128 AS [Tama�o en MB],
    CASE max_size 
        WHEN 0 THEN ''Autocrecimiento Deshabilitado''
        WHEN -1 THEN ''Autocrecimiento Habilitado sin l�mite''
        ELSE ''Autocrecimiento Habilitado pero con l�mite''
    END [Autocrecimiento],
    growth AS [Valor de Crecimiento],
    CASE
        WHEN growth = 0 THEN ''Tama�o fijo, no va a crecer''
        WHEN growth > 0 AND is_percent_growth = 0 THEN ''Valor de crecimiento en p�ginas de 8-KB''
        ELSE ''Valor de crecimiento porcentual''
    END [Tipo de Crecimiento]
FROM ?.sys.database_files;'
GO
