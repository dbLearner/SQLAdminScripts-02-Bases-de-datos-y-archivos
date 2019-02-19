--<CREACION DE ESQUEMAS>
CREATE LOGIN aLopez 
WITH PASSWORD = '123',
DEFAULT_DATABASE  = Personal
GO

USE Personal
GO
CREATE USER aLopez FROM LOGIN aLopez
GO

CREATE SCHEMA Marketing AUTHORIZATION aLopez
GO
--</>

--<PERMISOS SOBRE ESQUEMAS>
GRANT SELECT ON SCHEMA::Marketing TO aLopez
GO
ALTER AUTHORIZATION ON SCHEMA::Marketing TO dbo
GO
--</>

--<OBJETOS SOBRE ESQUEMAS>
CREATE SCHEMA Ventas
GO
CREATE TABLE Ventas.Cliente (IdCliente INT, NombreCliente VARCHAR(20))
GO
CREATE TABLE Marketing.Cliente (IdCliente INT, NombreCliente VARCHAR(20))
GO
--</>

--<MOVER OBJETOS ENTRE ESQUEMAS>
CREATE TABLE Marketing.Vendedor (Idvendedor INT, NombreVendedor VARCHAR(20))
GO
ALTER SCHEMA VENTAS TRANSFER Marketing.Vendedor
GO
--</>
