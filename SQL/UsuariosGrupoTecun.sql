USE GrupoTecun1;
GO

-- 1. Crear el login en el servidor
CREATE LOGIN Dylan 
WITH PASSWORD = 'Admin2026!';

-- 2. Crear el usuario en la base de datos y darle permisos de propietario


CREATE USER Dylan FOR LOGIN Dylan;
EXEC sp_addrolemember 'db_owner', 'Dylan';
GO



-- 1. Crear el login en el servidor
CREATE LOGIN Mishel 
WITH PASSWORD = 'Lectura2026!';

-- 2. Crear el usuario en la base de datos y darle permiso de lectura


CREATE USER Mishel FOR LOGIN Mishel;
EXEC sp_addrolemember 'db_datareader', 'Mishel';
GO

SELECT name AS Usuario, type_desc 
FROM sys.database_principals 
WHERE name IN ('Dylan', 'Mishel');




-- Rol Administrador (control total sobre todas las tablas)
CREATE ROLE Rol_Administrador;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO Rol_Administrador;
GRANT EXECUTE TO Rol_Administrador;  -- Procedimientos

-- Rol Vendedor (gestiona ventas, clientes, alquileres)
CREATE ROLE Rol_Vendedor;
GRANT SELECT, INSERT, UPDATE ON Venta TO Rol_Vendedor;
GRANT SELECT, INSERT, UPDATE ON Detalle_Venta TO Rol_Vendedor;
GRANT SELECT, INSERT, UPDATE ON Alquiler TO Rol_Vendedor;
GRANT SELECT, INSERT, UPDATE ON Cliente TO Rol_Vendedor;
GRANT SELECT ON Producto TO Rol_Vendedor;
GRANT SELECT ON FormaPago TO Rol_Vendedor;

-- Rol Mecánico (gestiona mantenimientos y vehículos)
CREATE ROLE Rol_Mecanico;
GRANT SELECT, INSERT, UPDATE ON Mantenimiento TO Rol_Mecanico;
GRANT SELECT, INSERT, UPDATE ON Detalle_Mantenimiento TO Rol_Mecanico;
GRANT SELECT ON Vehiculo TO Rol_Mecanico;
GRANT SELECT ON Producto TO Rol_Mecanico;

-- Rol Lector (solo lectura en toda la base de datos)
CREATE ROLE Rol_Lector;
GRANT SELECT ON SCHEMA::dbo TO Rol_Lector;
GO


-- CREACIÓN DE USUARIOS Y ASIGNACIÓN DE ROLES


-- 1. Dylan (Administrador) - ya existía, se añade al rol
ALTER ROLE Rol_Administrador ADD MEMBER Dylan;

-- 2. Mishel (Lector) - ya existía, se añade al rol
ALTER ROLE Rol_Lector ADD MEMBER Mishel;

-- 3. Karla (Vendedora)
CREATE LOGIN Karla WITH PASSWORD = 'Ventas2026!';
CREATE USER Karla FOR LOGIN Karla;
ALTER ROLE Rol_Vendedor ADD MEMBER Karla;

-- 4. Byron (Mecánico)
CREATE LOGIN Byron WITH PASSWORD = 'Taller2026!';
CREATE USER Byron FOR LOGIN Byron;
ALTER ROLE Rol_Mecanico ADD MEMBER Byron;
GO

-- Verificar asignaciones
SELECT 
    u.name AS Usuario,
    r.name AS Rol
FROM sys.database_principals u
JOIN sys.database_role_members rm ON u.principal_id = rm.member_principal_id
JOIN sys.database_principals r ON rm.role_principal_id = r.principal_id
WHERE u.name IN ('Dylan', 'Mishel', 'Karla', 'Byron');