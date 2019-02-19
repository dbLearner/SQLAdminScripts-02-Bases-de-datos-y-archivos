--<USO DE VISTAS DE CATALOGO>
USE AdventureWorks
SELECT df.[name], df.physical_name, df.[size], df.growth, f.[name]
[filegroup]
FROM sys.database_files df
JOIN sys.filegroups f
ON df.data_space_id = f.data_space_id

SELECT [name], [type], type_desc
FROM sys.system_objects
WHERE NAME LIKE 'dm%'
ORDER BY [name]
--</>

--<LISTA OBJETOS POR ANTIGUEDAD>
USE Personal
GO

SELECT name AS object_name,
SCHEMA_NAME(schema_id) AS schema_name, type_desc, create_date, modify_date
FROM sys.objects
WHERE modify_date > GETDATE() - 10
ORDER BY modify_date
GO
--</>

--<DICCIONARIO DE DATOS>
SELECT 
	O.Name Tabla, 
	P2.Value Descripción_Col,
	C.Name Columna, 
	T.Name Tipo, 
	C.Precision, 
	CASE
		WHEN C.Is_Nullable = 0 Then 'No'
		WHEN C.Is_Nullable = 1 Then 'Si'
	END PermiteNulo, 
	P1.value Descripción_Tabla
FROM sys.objects O 
 INNER JOIN sys.Columns C 
  ON O.object_id = C.object_id  
 INNER JOIN sys.Types T 
  ON C.system_type_id = T.system_type_id 
  AND C.system_type_id = T.user_type_id
 LEFT JOIN sys.extended_properties P1 
  ON C.object_id  = P1.major_id
  AND P1.minor_id = 0
LEFT JOIN sys.extended_properties P2 
  ON C.object_id  = P2.major_id
  AND C.Column_id = P2.minor_id
  AND P2.Class = 1
WHERE O.TYPE in ('U', 'V')
ORDER BY O.Name, C.Column_id
--</>

--<USO DE PROCEDIMIENTOS ALMACENADOS DEL SISTEMA>
--Ingresar Descripcion de Tabla
USE Personal
GO
EXEC sp_addextendedproperty 
@name=N'MS_Description', 
@value=N'Maestro de Vendedores' , 
@level0type=N'SCHEMA',
@level0name=N'Ventas', 
@level1type=N'TABLE',
@level1name=N'Vendedor'
GO
--Ingresar Descripción de campo
EXEC sp_addextendedproperty 
@name='MS_Description', 
@value='Identificación del vendedor' , 
@level0type='SCHEMA',
@level0name='Ventas', 
@level1type='TABLE',
@level1name='Vendedor', 
@level2type='COLUMN',
@level2name='IdVendedor'
GO

USE AdventureWorks
GO
EXEC sp_help 'Sales.Salesperson'
GO
EXEC sp_helptext 'HumanResources.uspUpdateEmployeeHireInfo'
GO

USE Personal
GO
EXEC sp_helpfilegroup
GO
EXEC sp_helpfilegroup 'PersDef'
GO
--</>