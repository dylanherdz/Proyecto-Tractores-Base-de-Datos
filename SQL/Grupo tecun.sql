USE GrupoTecun1;
GO

DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql += 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id))
    + '.' + QUOTENAME(OBJECT_NAME(fk.parent_object_id))
    + ' DROP CONSTRAINT ' + QUOTENAME(fk.name) + ';'
FROM sys.foreign_keys fk
WHERE fk.referenced_object_id = OBJECT_ID('Vehiculo');

EXEC sp_executesql @sql;
GO

SELECT * INTO Vehiculo_Backup FROM Vehiculo;
DROP TABLE Vehiculo;
GO

CREATE TABLE Vehiculo (
    ID_Vehiculo INT PRIMARY KEY,
    Placa VARCHAR(20) UNIQUE NOT NULL,
    ID_Marca INT NOT NULL FOREIGN KEY REFERENCES Marca(ID_Marca),
    Modelo VARCHAR(100),
    Anio INT,
    ID_TipoVehiculo INT NOT NULL FOREIGN KEY REFERENCES Tipo_Vehiculo(ID_TipoVehiculo),
    Color VARCHAR(50),
    Chasis VARCHAR(50),
    VIN VARCHAR(50),
    Serie VARCHAR(50),
    ID_Cliente INT FOREIGN KEY REFERENCES Cliente(ID_Cliente),
    ID_Producto INT FOREIGN KEY REFERENCES Producto(ID_Producto)
);
GO

-- Tractores (TipoVehiculo 1)
CREATE TABLE Vehiculo_Tractor (
    ID_Vehiculo INT PRIMARY KEY FOREIGN KEY REFERENCES Vehiculo(ID_Vehiculo),
    PotenciaHP VARCHAR(20),
    Cilindros INT,
    Toneladas DECIMAL(10,2),
    Motor VARCHAR(100),
    Asientos INT DEFAULT 2,
    Ejes INT DEFAULT 2
);

-- Camiones (TipoVehiculo 2)
CREATE TABLE Vehiculo_Camion (
    ID_Vehiculo INT PRIMARY KEY FOREIGN KEY REFERENCES Vehiculo(ID_Vehiculo),
    CapacidadCarga DECIMAL(10,2),
    NumeroEjes INT,
    TipoCabina VARCHAR(50),
    LitrosMotor VARCHAR(20)
);

-- Pickups (TipoVehiculo 3)
CREATE TABLE Vehiculo_Pickup (
    ID_Vehiculo INT PRIMARY KEY FOREIGN KEY REFERENCES Vehiculo(ID_Vehiculo),
    Traccion4x4 BIT,
    CapacidadCarga DECIMAL(10,2),
    NumeroPuertas INT
);

-- Motocicletas (TipoVehiculo 4)
CREATE TABLE Vehiculo_Motocicleta (
    ID_Vehiculo INT PRIMARY KEY FOREIGN KEY REFERENCES Vehiculo(ID_Vehiculo),
    Cilindrada INT,
    TipoFreno VARCHAR(30),
    TipoArranque VARCHAR(30)
);

-- Remolques (TipoVehiculo 5) – ejemplo adicional
CREATE TABLE Vehiculo_Remolque (
    ID_Vehiculo INT PRIMARY KEY FOREIGN KEY REFERENCES Vehiculo(ID_Vehiculo),
    CapacidadCarga DECIMAL(10,2),
    NumeroEjes INT
);
GO

ALTER TABLE Alquiler ADD FOREIGN KEY (ID_Vehiculo) REFERENCES Vehiculo(ID_Vehiculo);
ALTER TABLE Mantenimiento ADD FOREIGN KEY (ID_Vehiculo) REFERENCES Vehiculo(ID_Vehiculo);
ALTER TABLE Tarjeta_Circulacion ADD FOREIGN KEY (ID_Vehiculo) REFERENCES Vehiculo(ID_Vehiculo);
-- Empleado_Habilitacion no tiene FK a Vehiculo en tu modelo
GO

-- 6a. Insertar en la tabla base
INSERT INTO Vehiculo (ID_Vehiculo, Placa, ID_Marca, Modelo, Anio, ID_TipoVehiculo, Color, Chasis, VIN, Serie, ID_Cliente, ID_Producto)
SELECT ID_Vehiculo, Placa, ID_Marca, Modelo, Anio, ID_TipoVehiculo, Color, Chasis, VIN, Serie, ID_Cliente, ID_Producto
FROM Vehiculo_Backup;

-- 6b. Distribuir en tablas derivadas según tipo
-- Tractores (TipoVehiculo = 1)
INSERT INTO Vehiculo_Tractor (ID_Vehiculo, PotenciaHP, Cilindros, Toneladas, Motor, Asientos, Ejes)
SELECT ID_Vehiculo, 
       CASE Modelo WHEN '5050E' THEN '50 HP'
                   WHEN '6100D' THEN '100 HP'
                   WHEN 'Farmall 75C' THEN '75 HP'
                   WHEN 'Farmall 100C' THEN '100 HP'
                   WHEN 'Farmall 50C' THEN '50 HP'
                   WHEN 'T5.120' THEN '120 HP'
                   WHEN 'MF 4709' THEN '90 HP'
                   WHEN 'MF 4707' THEN '70 HP'
                   WHEN 'L3301' THEN '33 HP'
                   WHEN 'L4701' THEN '47 HP'
                   WHEN 'M7060' THEN '60 HP'
                   ELSE 'Desconocida' END,
       Cilindros,
       Toneladas,
       Motor,
       Asientos,
       Ejes
FROM Vehiculo_Backup WHERE ID_TipoVehiculo = 1;



-- Nuevo tractor (ID 21)
INSERT INTO Vehiculo (ID_Vehiculo, Placa, ID_Marca, Modelo, Anio, ID_TipoVehiculo, Color, Chasis, VIN, Serie, ID_Cliente, ID_Producto)
VALUES (21, 'P-NUEVO1', 1, 'Tractor 5090EL', 2025, 1, 'Verde', 'CHASIS021', 'VIN021', 'SERIE021', 1, 1);

INSERT INTO Vehiculo_Tractor (ID_Vehiculo, PotenciaHP, Cilindros, Toneladas, Motor, Asientos, Ejes)
VALUES (21, '90 HP', 4, 4.0, 'Motor Diésel 4 tiempos', 2, 2);

-- Nuevo camión (ID 22)
INSERT INTO Vehiculo (ID_Vehiculo, Placa, ID_Marca, Modelo, Anio, ID_TipoVehiculo, Color, Chasis, VIN, Serie, ID_Cliente, ID_Producto)
VALUES (22, 'C-CAMION1', 6, 'Cargo 1515', 2024, 2, 'Blanco', 'CHASIS022', 'VIN022', 'SERIE022', NULL, NULL);

INSERT INTO Vehiculo_Camion (ID_Vehiculo, CapacidadCarga, NumeroEjes, TipoCabina, LitrosMotor)
VALUES (22, 15.0, 3, 'Cabina extendida', 'Motor 7.2L');

-- Nueva pickup (ID 23)
INSERT INTO Vehiculo (ID_Vehiculo, Placa, ID_Marca, Modelo, Anio, ID_TipoVehiculo, Color, Chasis, VIN, Serie, ID_Cliente, ID_Producto)
VALUES (23, 'P-PICKUP1', 3, 'Ranger 2025', 2025, 3, 'Rojo', 'CHASIS023', 'VIN023', 'SERIE023', 5, NULL);

INSERT INTO Vehiculo_Pickup (ID_Vehiculo, Traccion4x4, CapacidadCarga, NumeroPuertas)
VALUES (23, 1, 1.2, 4);

-- Consulta de prueba
SELECT v.Placa, v.Modelo, tv.Nombre AS Tipo, t.PotenciaHP, c.CapacidadCarga AS CargaCamion
FROM Vehiculo v
LEFT JOIN Vehiculo_Tractor t ON v.ID_Vehiculo = t.ID_Vehiculo
LEFT JOIN Vehiculo_Camion c ON v.ID_Vehiculo = c.ID_Vehiculo
LEFT JOIN Vehiculo_Pickup p ON v.ID_Vehiculo = p.ID_Vehiculo
LEFT JOIN Tipo_Vehiculo tv ON v.ID_TipoVehiculo = tv.ID_TipoVehiculo;
GO

-- Reestablecer las FK necesarias
ALTER TABLE Alquiler 
ADD FOREIGN KEY (ID_Vehiculo) REFERENCES Vehiculo(ID_Vehiculo);

ALTER TABLE Mantenimiento 
ADD FOREIGN KEY (ID_Vehiculo) REFERENCES Vehiculo(ID_Vehiculo);

ALTER TABLE Tarjeta_Circulacion 
ADD FOREIGN KEY (ID_Vehiculo) REFERENCES Vehiculo(ID_Vehiculo);

SELECT fk.name AS FK_Nombre, 
       OBJECT_NAME(fk.parent_object_id) AS Tabla_Origen,
       OBJECT_NAME(fk.referenced_object_id) AS Tabla_Destino
FROM sys.foreign_keys fk
WHERE fk.referenced_object_id = OBJECT_ID('Vehiculo');

-- Tractores (TipoVehiculo = 1)
INSERT INTO Vehiculo (ID_Vehiculo, Placa, ID_Marca, Modelo, Anio, ID_TipoVehiculo, Color, Chasis, VIN, Serie)
VALUES 
(24, 'P-TRAC24', 1, '5075E', 2024, 1, 'Verde', 'CHASIS024', 'VIN024', 'SERIE024'),
(25, 'P-TRAC25', 2, 'Farmall 90C', 2025, 1, 'Rojo', 'CHASIS025', 'VIN025', 'SERIE025'),
(26, 'P-TRAC26', 3, 'T6.160', 2024, 1, 'Azul', 'CHASIS026', 'VIN026', 'SERIE026'),
(27, 'P-TRAC27', 4, 'MF 6713', 2025, 1, 'Gris', 'CHASIS027', 'VIN027', 'SERIE027'),
(28, 'P-TRAC28', 5, 'M5-092', 2024, 1, 'Naranja', 'CHASIS028', 'VIN028', 'SERIE028');

INSERT INTO Vehiculo_Tractor (ID_Vehiculo, PotenciaHP, Cilindros, Toneladas, Motor, Asientos, Ejes)
VALUES 
(24, '75 HP', 4, 3.8, 'Motor Diésel 4 cilindros', 2, 2),
(25, '90 HP', 6, 4.5, 'Motor Diésel 6 cilindros', 2, 2),
(26, '160 HP', 6, 6.0, 'Motor Diésel 6 cilindros turbo', 2, 2),
(27, '130 HP', 6, 5.5, 'Motor Diésel 6 cilindros', 2, 2),
(28, '92 HP', 4, 3.2, 'Motor Diésel 4 cilindros', 2, 2);

-- Camiones (TipoVehiculo = 2)
INSERT INTO Vehiculo (ID_Vehiculo, Placa, ID_Marca, Modelo, Anio, ID_TipoVehiculo, Color, Chasis, VIN, Serie)
VALUES 
(29, 'C-CAM29', 6, 'Cargo 1515', 2024, 2, 'Blanco', 'CHASIS029', 'VIN029', 'SERIE029'),
(30, 'C-CAM30', 7, 'Atego 1725', 2025, 2, 'Azul', 'CHASIS030', 'VIN030', 'SERIE030'),
(31, 'C-CAM31', 8, 'TGL 12.250', 2024, 2, 'Rojo', 'CHASIS031', 'VIN031', 'SERIE031'),
(32, 'C-CAM32', 9, 'Volvo FH 540', 2025, 2, 'Negro', 'CHASIS032', 'VIN032', 'SERIE032'),
(33, 'C-CAM33', 10, 'Scania R450', 2024, 2, 'Plata', 'CHASIS033', 'VIN033', 'SERIE033');

INSERT INTO Vehiculo_Camion (ID_Vehiculo, CapacidadCarga, NumeroEjes, TipoCabina, LitrosMotor)
VALUES 
(29, 15.0, 3, 'Cabina extendida', '7.2L'),
(30, 18.5, 3, 'Cabina doble', '7.7L'),
(31, 12.0, 2, 'Cabina simple', '6.5L'),
(32, 25.0, 4, 'Cabina alta', '12.8L'),
(33, 20.0, 3, 'Cabina alta', '11.0L');

-- Pickups (TipoVehiculo = 3)
INSERT INTO Vehiculo (ID_Vehiculo, Placa, ID_Marca, Modelo, Anio, ID_TipoVehiculo, Color, Chasis, VIN, Serie)
VALUES 
(34, 'P-PICK34', 3, 'Ranger 2025', 2025, 3, 'Rojo', 'CHASIS034', 'VIN034', 'SERIE034'),
(35, 'P-PICK35', 4, 'Hilux 2024', 2024, 3, 'Blanco', 'CHASIS035', 'VIN035', 'SERIE035'),
(36, 'P-PICK36', 5, 'L200 2025', 2025, 3, 'Gris', 'CHASIS036', 'VIN036', 'SERIE036'),
(37, 'P-PICK37', 6, 'Frontier 2024', 2024, 3, 'Negro', 'CHASIS037', 'VIN037', 'SERIE037'),
(38, 'P-PICK38', 7, 'D-Max 2025', 2025, 3, 'Azul', 'CHASIS038', 'VIN038', 'SERIE038');

INSERT INTO Vehiculo_Pickup (ID_Vehiculo, Traccion4x4, CapacidadCarga, NumeroPuertas)
VALUES 
(34, 1, 1.2, 4),
(35, 1, 1.0, 4),
(36, 0, 0.9, 2),
(37, 1, 1.1, 4),
(38, 0, 0.85, 2);

-- Motocicletas (TipoVehiculo = 4)
INSERT INTO Vehiculo (ID_Vehiculo, Placa, ID_Marca, Modelo, Anio, ID_TipoVehiculo, Color, Chasis, VIN, Serie)
VALUES 
(39, 'M-MOTO39', 8, 'XRE 300', 2025, 4, 'Rojo', 'CHASIS039', 'VIN039', 'SERIE039'),
(40, 'M-MOTO40', 9, 'CRF 250', 2024, 4, 'Blanco', 'CHASIS040', 'VIN040', 'SERIE040'),
(41, 'M-MOTO41', 10, 'XTZ 150', 2025, 4, 'Azul', 'CHASIS041', 'VIN041', 'SERIE041'),
(42, 'M-MOTO42', 11, 'Gixxer 250', 2024, 4, 'Negro', 'CHASIS042', 'VIN042', 'SERIE042'),
(43, 'M-MOTO43', 12, 'CB 190', 2025, 4, 'Gris', 'CHASIS043', 'VIN043', 'SERIE043');

INSERT INTO Vehiculo_Motocicleta (ID_Vehiculo, Cilindrada, TipoFreno, TipoArranque)
VALUES 
(39, 300, 'Disco', 'Eléctrico'),
(40, 250, 'Disco', 'Patada'),
(41, 150, 'Tambor', 'Eléctrico'),
(42, 250, 'Disco', 'Eléctrico'),
(43, 190, 'Disco', 'Eléctrico');

-- Remolques (TipoVehiculo = 5)
INSERT INTO Vehiculo (ID_Vehiculo, Placa, ID_Marca, Modelo, Anio, ID_TipoVehiculo, Color, Chasis, VIN, Serie)
VALUES 
(44, 'R-REM44', 13, 'SR-5T', 2024, 5, 'Gris', 'CHASIS044', 'VIN044', 'SERIE044'),
(45, 'R-REM45', 14, 'SR-10T', 2025, 5, 'Negro', 'CHASIS045', 'VIN045', 'SERIE045'),
(46, 'R-REM46', 15, 'C-8T', 2024, 5, 'Rojo', 'CHASIS046', 'VIN046', 'SERIE046'),
(47, 'R-REM47', 16, 'C-12T', 2025, 5, 'Azul', 'CHASIS047', 'VIN047', 'SERIE047'),
(48, 'R-REM48', 17, 'P-6T', 2024, 5, 'Blanco', 'CHASIS048', 'VIN048', 'SERIE048');

INSERT INTO Vehiculo_Remolque (ID_Vehiculo, CapacidadCarga, NumeroEjes)
VALUES 
(44, 5.0, 2),
(45, 10.0, 3),
(46, 8.0, 2),
(47, 12.0, 3),
(48, 6.0, 2);

-- Tabla Bitácora (log de eventos)
CREATE TABLE Bitacora (
    ID_Bitacora BIGINT PRIMARY KEY IDENTITY(1,1),
    Fecha DATETIME NOT NULL DEFAULT GETDATE(),
    ID_Usuario INT NULL FOREIGN KEY REFERENCES Usuario(ID_Usuario),
    TipoEvento VARCHAR(50) NOT NULL,           -- 'INSERT', 'UPDATE', 'DELETE'
    Entidad VARCHAR(100) NOT NULL,             -- 'Venta', 'Alquiler', 'Vehiculo', etc.
    ID_Registro INT NOT NULL,                  -- ID del registro afectado
    Descripcion VARCHAR(500) NULL,
    DatosAnteriores NVARCHAR(MAX) NULL,         -- JSON con estado previo (para UPDATE/DELETE)
    DatosNuevos NVARCHAR(MAX) NULL,             -- JSON con estado nuevo (para INSERT/UPDATE)
    HostName VARCHAR(100) NULL,                 -- Opcional: desde dónde se realizó
    Aplicacion VARCHAR(100) NULL               -- Opcional: nombre de la app
);
GO

-- Índice para consultas frecuentes por fecha y entidad
CREATE INDEX IX_Bitacora_Fecha ON Bitacora(Fecha DESC);
CREATE INDEX IX_Bitacora_Entidad ON Bitacora(Entidad) INCLUDE (ID_Registro);


CREATE TRIGGER trg_Bitacora_Venta
ON Venta
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- INSERT
    IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO Bitacora (ID_Usuario, TipoEvento, Entidad, ID_Registro, Descripcion, DatosNuevos)
        SELECT 
            NULL,
            'INSERT', 
            'Venta', 
            i.ID_Venta,
            'Nueva venta registrada',
            (SELECT * FROM inserted FOR JSON AUTO, WITHOUT_ARRAY_WRAPPER)
        FROM inserted i;
    END

    -- UPDATE
    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO Bitacora (ID_Usuario, TipoEvento, Entidad, ID_Registro, Descripcion, DatosAnteriores, DatosNuevos)
        SELECT 
            NULL,
            'UPDATE', 
            'Venta', 
            i.ID_Venta,
            'Venta modificada',
            (SELECT * FROM deleted FOR JSON AUTO, WITHOUT_ARRAY_WRAPPER),
            (SELECT * FROM inserted FOR JSON AUTO, WITHOUT_ARRAY_WRAPPER)
        FROM inserted i
        INNER JOIN deleted d ON i.ID_Venta = d.ID_Venta;
    END

    -- DELETE
    IF NOT EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO Bitacora (ID_Usuario, TipoEvento, Entidad, ID_Registro, Descripcion, DatosAnteriores)
        SELECT 
            NULL,
            'DELETE', 
            'Venta', 
            d.ID_Venta,
            'Venta eliminada',
            (SELECT * FROM deleted FOR JSON AUTO, WITHOUT_ARRAY_WRAPPER)
        FROM deleted d;
    END
END;
GO

-- Insertar una nueva venta
INSERT INTO Venta (ID_Venta, Fecha, ID_Cliente, ID_Empleado, Total, ID_FormaPago)
VALUES (21, '2026-05-11', 3, 2, 45000.00, 2);

-- Insertar el detalle de la venta
INSERT INTO Detalle_Venta (ID_Detalle, ID_Venta, ID_Producto, Cantidad, PrecioUnitario)
VALUES (21, 21, 11, 1, 45000.00);


SELECT * FROM Bitacora;


-- METADATOS-- 

SELECT name AS Tabla 
FROM sys.tables 
ORDER BY name;

SELECT 
    name AS FK_Nombre,
    OBJECT_NAME(parent_object_id) AS Tabla_Origen,
    OBJECT_NAME(referenced_object_id) AS Tabla_Destino
FROM sys.foreign_keys;

SELECT 
    t.name AS Tabla,
    i.name AS Indice,
    i.type_desc AS Tipo
FROM sys.indexes i
INNER JOIN sys.tables t ON i.object_id = t.object_id
WHERE i.name IS NOT NULL
ORDER BY t.name;

SELECT name AS Vista 
FROM sys.views 
ORDER BY name;

SELECT name AS Procedimiento 
FROM sys.procedures 
ORDER BY name;

SELECT name AS Trigger_Nombre, OBJECT_NAME(parent_id) AS Tabla
FROM sys.triggers;



-- Agregar columna temporal VARBINARY para la contraseña cifrada
ALTER TABLE Usuario ADD Contrasena_Cifrada VARBINARY(256);
GO

-- Frase de paso secreta (debe ser resguardada fuera de la BD)
DECLARE @FraseSecreta NVARCHAR(100) = 'ClaveSecreta2026!';

-- Cifrar las contraseñas existentes
UPDATE Usuario 
SET Contrasena_Cifrada = ENCRYPTBYPASSPHRASE(@FraseSecreta, Contrasena);
GO

-- Eliminar columna original (texto plano)
ALTER TABLE Usuario DROP COLUMN Contrasena;

-- Renombrar la columna cifrada como 'Contrasena'
EXEC sp_rename 'Usuario.Contrasena_Cifrada', 'Contrasena', 'COLUMN';
GO

-- Insertar usuario de prueba con contraseña cifrada
INSERT INTO Usuario (ID_Usuario, Nombre, Email, Contrasena, Rol)
VALUES (21, 'test', 'test@tecun.com',  ENCRYPTBYPASSPHRASE('ClaveSecreta2026!', 'MiPassword123'), 'vendedor');
-- Administrador extra (ID 22)
INSERT INTO Usuario (ID_Usuario, Nombre, Email, Contrasena, Rol)
VALUES (22, 
        'dylan.admin', 
        'dylan.admin@tecun.com', 
        ENCRYPTBYPASSPHRASE('ClaveSecreta2026!', 'DyL4nAdm1n#2026'),
        'admin');

-- Vendedor (ID 23)
INSERT INTO Usuario (ID_Usuario, Nombre, Email, Contrasena, Rol)
VALUES (23, 
        'karla.ventas', 
        'karla.ventas@tecun.com', 
        ENCRYPTBYPASSPHRASE('ClaveSecreta2026!', 'VenT4sK4rl4$'),
        'vendedor');

-- Mecánico (ID 24)
INSERT INTO Usuario (ID_Usuario, Nombre, Email, Contrasena, Rol)
VALUES (24, 
        'byron.taller', 
        'byron.taller@tecun.com', 
        ENCRYPTBYPASSPHRASE('ClaveSecreta2026!', 'Byr0nM3c4n1c0!'),
        'mecanico');


SELECT * FROM Usuario WHERE ID_Usuario IN (21,22, 23, 24);

SELECT * FROM Usuario WHERE ID_Usuario IN (22, 23, 24);

-- Mostrar la contraseña descifrada
SELECT 
    ID_Usuario, 
    Nombre, 
    Email,
    CAST(DECRYPTBYPASSPHRASE('ClaveSecreta2026!', Contrasena) AS VARCHAR(255)) AS Contrasena_Descifrada
FROM Usuario 
WHERE ID_Usuario = 21;




-- 1. Verificar el máximo ID actual en Usuario
SELECT MAX(ID_Usuario) AS MaxID FROM Usuario;

-- 2. Ver todos los usuarios (incluye los que intentaste insertar)
SELECT ID_Usuario, Nombre, Email, Rol FROM Usuario;

-- 3. Verificar si existe el trigger y si está activo
SELECT name, is_disabled FROM sys.triggers WHERE name = 'trg_CifrarPassword';


CREATE OR ALTER PROCEDURE sp_RegistrarVenta
    @ID_Venta INT, @Fecha DATE, @ID_Cliente INT, @ID_Empleado INT,
    @Total DECIMAL(18,2), @ID_FormaPago INT,
    @Detalles DetalleVentaType READONLY
AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Venta (ID_Venta, Fecha, ID_Cliente, ID_Empleado, Total, ID_FormaPago)
        VALUES (@ID_Venta, @Fecha, @ID_Cliente, @ID_Empleado, @Total, @ID_FormaPago);

        INSERT INTO Detalle_Venta (ID_Detalle, ID_Venta, ID_Producto, Cantidad, PrecioUnitario)
        SELECT ID_Detalle, @ID_Venta, ID_Producto, Cantidad, PrecioUnitario
        FROM @Detalles;

        -- Actualizar inventario (bodega 1) descontando las cantidades
        UPDATE i
        SET i.Cantidad = i.Cantidad - d.Cantidad
        FROM Inventario i
        INNER JOIN @Detalles d ON i.ID_Producto = d.ID_Producto
        WHERE i.ID_Bodega = 1;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO

SELECT * FROM GrupoTecun_NoSQL 

INSERT INTO GrupoTecun_NoSQL_Historial (ID_Registro, DatosJSON)
VALUES (1, N'{"Vehiculo":{"Placa":"P-123ABC","Marca":"John Deere","Modelo":"5050E","Anio":2020,"Especificaciones":{"Motor":"Diésel 4 cilindros","Potencia":"50 HP"}}}');


BACKUP DATABASE GrupoTecun1
TO DISK = 'C:\BackupsGrupoTecun\GrupoTecun1_full.bak'
WITH FORMAT, INIT,
     NAME = 'Backup Completo GrupoTecun1';
GO

RESTORE VERIFYONLY
FROM DISK = 'C:\BackupsGrupoTecun\GrupoTecun1_full.bak';