

CREATE DATABASE GrupoTecun1;
GO
USE GrupoTecun1;
GO

-- ==================== TABLAS ====================

CREATE TABLE Pais (
    ID_Pais INT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL
);

CREATE TABLE Departamento (
    ID_Departamento INT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    ID_Pais INT NOT NULL FOREIGN KEY REFERENCES Pais(ID_Pais)
);

CREATE TABLE Municipio (
    ID_Municipio INT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    ID_Departamento INT NOT NULL FOREIGN KEY REFERENCES Departamento(ID_Departamento)
);

CREATE TABLE Empresa (
    ID_Empresa INT PRIMARY KEY,
    Nombre VARCHAR(150) NOT NULL,
    Direccion VARCHAR(255),
    ID_Municipio INT FOREIGN KEY REFERENCES Municipio(ID_Municipio),
    Telefono VARCHAR(20),
    Email VARCHAR(100),
    TipoEmpresa VARCHAR(100)
);

CREATE TABLE Sucursal (
    ID_Sucursal INT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Direccion VARCHAR(255),
    ID_Municipio INT FOREIGN KEY REFERENCES Municipio(ID_Municipio),
    Telefono VARCHAR(20),
    ID_Empresa INT NOT NULL FOREIGN KEY REFERENCES Empresa(ID_Empresa)
);

CREATE TABLE Puesto (
    ID_Puesto INT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion VARCHAR(255)
);

CREATE TABLE Empleado (
    ID_Empleado INT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Apellido VARCHAR(100) NOT NULL,
    Identificacion VARCHAR(20) UNIQUE NOT NULL,
    Direccion VARCHAR(255),
    ID_Puesto INT NOT NULL FOREIGN KEY REFERENCES Puesto(ID_Puesto),
    ID_Sucursal INT NOT NULL FOREIGN KEY REFERENCES Sucursal(ID_Sucursal)
);

CREATE TABLE Telefono_Empleado (
    ID_Telefono INT PRIMARY KEY,
    ID_Empleado INT NOT NULL FOREIGN KEY REFERENCES Empleado(ID_Empleado),
    Numero VARCHAR(20) NOT NULL,
    Tipo VARCHAR(50)
);

CREATE TABLE Email_Empleado (
    ID_Email INT PRIMARY KEY,
    ID_Empleado INT NOT NULL FOREIGN KEY REFERENCES Empleado(ID_Empleado),
    Correo VARCHAR(100) NOT NULL
);

CREATE TABLE Horario_Empleado (
    ID_Horario INT PRIMARY KEY,
    ID_Empleado INT NOT NULL FOREIGN KEY REFERENCES Empleado(ID_Empleado),
    Dia_Semana VARCHAR(20) NOT NULL,
    Hora_Inicio TIME NOT NULL,
    Hora_Fin TIME NOT NULL
);

CREATE TABLE Cliente (
    ID_Cliente INT PRIMARY KEY,
    Nombre VARCHAR(150) NOT NULL,
    Telefono VARCHAR(20),
    Email VARCHAR(100),
    Direccion VARCHAR(255),
    DPI VARCHAR(20) UNIQUE,
    ID_Municipio INT FOREIGN KEY REFERENCES Municipio(ID_Municipio)
);

CREATE TABLE Proveedor (
    ID_Proveedor INT PRIMARY KEY,
    Nombre VARCHAR(150) NOT NULL,
    Contacto VARCHAR(100),
    Telefono VARCHAR(20),
    Direccion VARCHAR(255),
    Email VARCHAR(100),
    ID_Municipio INT FOREIGN KEY REFERENCES Municipio(ID_Municipio)
);

CREATE TABLE Categoria_Producto (
    ID_Categoria INT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion VARCHAR(255)
);

CREATE TABLE Marca (
    ID_Marca INT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL
);

CREATE TABLE Producto (
    ID_Producto INT PRIMARY KEY,
    Nombre VARCHAR(150) NOT NULL,
    ID_Categoria INT NOT NULL FOREIGN KEY REFERENCES Categoria_Producto(ID_Categoria),
    ID_Marca INT NOT NULL FOREIGN KEY REFERENCES Marca(ID_Marca),
    Descripcion VARCHAR(500),
    Precio DECIMAL(18,2) NOT NULL,
    Mantenimiento VARCHAR(255)
);

CREATE TABLE Tipo_Vehiculo (
    ID_TipoVehiculo INT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL
);

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
    Motor VARCHAR(100),
    Asientos INT,
    Ejes INT,
    Cilindros INT,
    Toneladas DECIMAL(10,2),
    ID_Cliente INT FOREIGN KEY REFERENCES Cliente(ID_Cliente),
    ID_Producto INT FOREIGN KEY REFERENCES Producto(ID_Producto)
);

CREATE TABLE Tarjeta_Circulacion (
    ID_Tarjeta INT PRIMARY KEY,
    ID_Vehiculo INT NOT NULL FOREIGN KEY REFERENCES Vehiculo(ID_Vehiculo),
    Fecha_Validacion DATE,
    Fecha_Emision DATE,
    Usuario VARCHAR(100),
    Hora TIME,
    QR VARCHAR(255)
);

CREATE TABLE Equipo_Liviano (
    ID_Equipo INT PRIMARY KEY,
    Nombre VARCHAR(150) NOT NULL,
    Tipo VARCHAR(100),
    Descripcion VARCHAR(500),
    ID_Producto INT FOREIGN KEY REFERENCES Producto(ID_Producto)
);

CREATE TABLE Bodega (
    ID_Bodega INT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Direccion VARCHAR(255),
    Capacidad INT,
    ID_Sucursal INT NOT NULL FOREIGN KEY REFERENCES Sucursal(ID_Sucursal)
);

CREATE TABLE Inventario (
    ID_Inventario INT PRIMARY KEY,
    ID_Producto INT NOT NULL FOREIGN KEY REFERENCES Producto(ID_Producto),
    ID_Bodega INT NOT NULL FOREIGN KEY REFERENCES Bodega(ID_Bodega),
    Cantidad INT NOT NULL
);

CREATE TABLE FormaPago (
    ID_FormaPago INT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL
);

CREATE TABLE Venta (
    ID_Venta INT PRIMARY KEY,
    Fecha DATE NOT NULL,
    ID_Cliente INT NOT NULL FOREIGN KEY REFERENCES Cliente(ID_Cliente),
    ID_Empleado INT NOT NULL FOREIGN KEY REFERENCES Empleado(ID_Empleado),
    Total DECIMAL(18,2) NOT NULL,
    ID_FormaPago INT NOT NULL FOREIGN KEY REFERENCES FormaPago(ID_FormaPago)
);

CREATE TABLE Detalle_Venta (
    ID_Detalle INT PRIMARY KEY,
    ID_Venta INT NOT NULL FOREIGN KEY REFERENCES Venta(ID_Venta),
    ID_Producto INT NOT NULL FOREIGN KEY REFERENCES Producto(ID_Producto),
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(18,2) NOT NULL
);

CREATE TABLE Alquiler (
    ID_Alquiler INT PRIMARY KEY,
    ID_Cliente INT NOT NULL FOREIGN KEY REFERENCES Cliente(ID_Cliente),
    ID_Vehiculo INT NOT NULL FOREIGN KEY REFERENCES Vehiculo(ID_Vehiculo),
    FechaInicio DATE NOT NULL,
    FechaFin DATE,
    PrecioDiario DECIMAL(18,2) NOT NULL,
    Total DECIMAL(18,2),
    Estado VARCHAR(20) DEFAULT 'Activo'
);

CREATE TABLE Mantenimiento (
    ID_Mantenimiento INT PRIMARY KEY,
    ID_Vehiculo INT NOT NULL FOREIGN KEY REFERENCES Vehiculo(ID_Vehiculo),
    Fecha DATE NOT NULL,
    Descripcion VARCHAR(500),
    Costo DECIMAL(18,2),
    ID_Empleado INT FOREIGN KEY REFERENCES Empleado(ID_Empleado),
    Estado VARCHAR(20) DEFAULT 'Pendiente'
);

CREATE TABLE Usuario (
    ID_Usuario INT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Contrasena VARCHAR(255) NOT NULL,
    Rol VARCHAR(50),
    ID_Empleado INT UNIQUE FOREIGN KEY REFERENCES Empleado(ID_Empleado)
);

CREATE TABLE Ubicacion (
    ID_Ubicacion INT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Direccion VARCHAR(255),
    Tipo VARCHAR(50),
    ID_Municipio INT FOREIGN KEY REFERENCES Municipio(ID_Municipio)
);

CREATE TABLE Ficha_Tecnica (
    ID_Ficha INT PRIMARY KEY,
    ID_Producto INT NOT NULL FOREIGN KEY REFERENCES Producto(ID_Producto),
    Especificaciones VARCHAR(MAX),
    Potencia VARCHAR(100),
    Peso VARCHAR(100)
);

CREATE TABLE Detalle_Mantenimiento (
    ID_DetalleMantenimiento INT PRIMARY KEY,
    ID_Mantenimiento INT NOT NULL FOREIGN KEY REFERENCES Mantenimiento(ID_Mantenimiento),
    ID_Producto INT NOT NULL FOREIGN KEY REFERENCES Producto(ID_Producto),
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(18,2) NOT NULL
);

CREATE TABLE Empleado_Habilitacion (
    ID_Habilitacion INT PRIMARY KEY,
    ID_Empleado INT NOT NULL FOREIGN KEY REFERENCES Empleado(ID_Empleado),
    ID_TipoVehiculo INT NOT NULL FOREIGN KEY REFERENCES Tipo_Vehiculo(ID_TipoVehiculo),
    Fecha_Habilitacion DATE NOT NULL,
    Fecha_Vencimiento DATE NULL,
    Licencia VARCHAR(50)
);

CREATE TABLE Factura (
    ID_Factura INT PRIMARY KEY,
    NumeroFactura VARCHAR(50) NOT NULL,
    Fecha DATE NOT NULL,
    ID_Venta INT NULL FOREIGN KEY REFERENCES Venta(ID_Venta),
    ID_Alquiler INT NULL FOREIGN KEY REFERENCES Alquiler(ID_Alquiler),
    Total DECIMAL(18,2) NOT NULL,
    Estado VARCHAR(20) DEFAULT 'Pagada'
);

-- ============== TABLAS HÍBRIDAS (JSON) CONECTADAS AL SISTEMA ==============
CREATE TABLE GrupoTecun_NoSQL (
    ID_Registro INT IDENTITY(1,1) PRIMARY KEY,
    DatosJSON NVARCHAR(MAX) CHECK (ISJSON(DatosJSON)=1),
    ID_Usuario INT NULL FOREIGN KEY REFERENCES Usuario(ID_Usuario),
    ID_Cliente INT NULL FOREIGN KEY REFERENCES Cliente(ID_Cliente),
    ID_Vehiculo INT NULL FOREIGN KEY REFERENCES Vehiculo(ID_Vehiculo),
    ID_Producto INT NULL FOREIGN KEY REFERENCES Producto(ID_Producto),
    ID_Venta INT NULL FOREIGN KEY REFERENCES Venta(ID_Venta),
    ID_Alquiler INT NULL FOREIGN KEY REFERENCES Alquiler(ID_Alquiler),
    ID_Mantenimiento INT NULL FOREIGN KEY REFERENCES Mantenimiento(ID_Mantenimiento),
    ID_Empleado INT NULL FOREIGN KEY REFERENCES Empleado(ID_Empleado)
);

CREATE TABLE GrupoTecun_NoSQL_Historial (
    ID_Historial INT IDENTITY(1,1) PRIMARY KEY,
    ID_Registro INT NOT NULL,
    DatosJSON NVARCHAR(MAX),
    FechaCambio DATETIME DEFAULT GETDATE()
);
GO

-- ==================== TRIGGERS (10) ====================

-- 1. Actualizar total de Venta al insertar detalles
CREATE TRIGGER trg_ActualizarTotalVenta
ON Detalle_Venta
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Venta SET Total = (
        SELECT SUM(Cantidad * PrecioUnitario) 
        FROM Detalle_Venta WHERE ID_Venta = i.ID_Venta
    )
    FROM Venta v INNER JOIN inserted i ON v.ID_Venta = i.ID_Venta;
END;
GO

-- 2. Calcular total de Alquiler si tiene fecha fin
CREATE TRIGGER trg_CalcularTotalAlquiler
ON Alquiler
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(FechaFin) OR UPDATE(PrecioDiario)
    BEGIN
        UPDATE Alquiler SET Total = DATEDIFF(day, FechaInicio, FechaFin) * PrecioDiario
        FROM Alquiler a INNER JOIN inserted i ON a.ID_Alquiler = i.ID_Alquiler
        WHERE i.FechaFin IS NOT NULL;
    END;
END;
GO

-- 3. Evitar stock negativo en detalle venta
CREATE TRIGGER trg_ValidarStock
ON Detalle_Venta
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted i
        INNER JOIN Inventario inv ON i.ID_Producto = inv.ID_Producto
        WHERE inv.Cantidad < i.Cantidad AND inv.ID_Bodega = 1
    )
    BEGIN
        RAISERROR('Stock insuficiente en bodega central', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
    INSERT INTO Detalle_Venta (ID_Detalle, ID_Venta, ID_Producto, Cantidad, PrecioUnitario)
    SELECT ID_Detalle, ID_Venta, ID_Producto, Cantidad, PrecioUnitario FROM inserted;
END;
GO

-- 4. Auditoría de cambios en Venta (JSON)
CREATE TRIGGER trg_AuditoriaVenta
ON Venta
AFTER UPDATE, DELETE
AS
BEGIN
    INSERT INTO GrupoTecun_NoSQL (DatosJSON, ID_Venta)
    SELECT 
        JSON_QUERY('{"tabla":"Venta","accion":"' + 
            CASE WHEN EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted) THEN 'UPDATE'
                 WHEN EXISTS(SELECT * FROM inserted) THEN 'INSERT'
                 ELSE 'DELETE' END +
            '","idAfectado":' + CAST(ISNULL(i.ID_Venta, d.ID_Venta) AS VARCHAR) +
            ',"fecha":"' + CONVERT(VARCHAR, GETDATE(), 126) + '"}'),
        ISNULL(i.ID_Venta, d.ID_Venta)
    FROM inserted i FULL JOIN deleted d ON i.ID_Venta = d.ID_Venta;
END;
GO

-- 5. Marcar vehículo disponible cuando alquiler finaliza
CREATE TRIGGER trg_MarcarVehiculoDisponible
ON Alquiler
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Estado)
    BEGIN
        INSERT INTO GrupoTecun_NoSQL (DatosJSON, ID_Vehiculo)
        SELECT 
            JSON_QUERY('{"ID_Vehiculo":' + CAST(ID_Vehiculo AS VARCHAR) + ',"nuevoEstado":"Disponible"}'),
            ID_Vehiculo
        FROM inserted WHERE Estado = 'Finalizado';
    END;
END;
GO

-- 6. Proteger eliminación de productos con inventario > 0
CREATE TRIGGER trg_ProteccionEliminarProducto
ON Producto
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM deleted d JOIN Inventario i ON d.ID_Producto = i.ID_Producto WHERE i.Cantidad > 0)
    BEGIN
        RAISERROR('No se puede eliminar un producto con inventario positivo.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
    DELETE FROM Producto WHERE ID_Producto IN (SELECT ID_Producto FROM deleted);
END;
GO

-- 7. Actualizar costo de mantenimiento desde detalles
CREATE TRIGGER trg_ActualizarCostoMantenimiento
ON Detalle_Mantenimiento
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @IDs TABLE (ID_Mantenimiento INT);
    INSERT INTO @IDs SELECT ID_Mantenimiento FROM inserted UNION SELECT ID_Mantenimiento FROM deleted;
    UPDATE Mantenimiento SET Costo = (
        SELECT SUM(Cantidad * PrecioUnitario) FROM Detalle_Mantenimiento dm WHERE dm.ID_Mantenimiento = m.ID_Mantenimiento
    )
    FROM Mantenimiento m INNER JOIN @IDs i ON m.ID_Mantenimiento = i.ID_Mantenimiento;
END;
GO

-- 8. Auditoría de cambio de contraseña
CREATE TRIGGER trg_AuditoriaPassword
ON Usuario
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Contrasena)
    BEGIN
        INSERT INTO GrupoTecun_NoSQL (DatosJSON, ID_Usuario)
        SELECT 
            JSON_QUERY('{"ID_Usuario":' + CAST(ID_Usuario AS VARCHAR) + ',"fecha":"' + CONVERT(VARCHAR, GETDATE(), 126) + '"}'),
            ID_Usuario
        FROM inserted;
    END;
END;
GO

-- 9. Unicidad de número de factura
CREATE TRIGGER trg_UnicidadFactura
ON Factura
AFTER INSERT
AS
BEGIN
    IF EXISTS (SELECT NumeroFactura FROM Factura GROUP BY NumeroFactura HAVING COUNT(*) > 1)
    BEGIN
        RAISERROR('Número de factura duplicado.', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;
GO

-- 10. Notificar mantenimiento finalizado
CREATE TRIGGER trg_NotificarMantenimientoFinalizado
ON Mantenimiento
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Estado)
    BEGIN
        INSERT INTO GrupoTecun_NoSQL (DatosJSON, ID_Mantenimiento)
        SELECT 
            JSON_QUERY('{"tipo":"MantenimientoFinalizado","ID_Vehiculo":' + CAST(ID_Vehiculo AS VARCHAR) + ',"ID_Mantenimiento":' + CAST(ID_Mantenimiento AS VARCHAR) + '}'),
            ID_Mantenimiento
        FROM inserted WHERE Estado = 'Finalizado';
    END;
END;
GO

-- Trigger del modelo híbrido (antes de actualizar JSON)
CREATE TRIGGER trg_AntesDeActualizar_GrupoTecun_NoSQL
ON GrupoTecun_NoSQL
FOR UPDATE
AS
BEGIN
    INSERT INTO GrupoTecun_NoSQL_Historial (ID_Registro, DatosJSON)
    SELECT ID_Registro, DatosJSON FROM deleted;
    DECLARE @Mensaje NVARCHAR(255) = 'Actualización en tabla GrupoTecun_NoSQL.';
    RAISERROR(@Mensaje, 16, 1);
END;
GO

-- ==================== PROCEDIMIENTOS ALMACENADOS (5) ====================

-- 1. Registrar venta con detalle
CREATE TYPE DetalleVentaType AS TABLE (
    ID_Detalle INT,
    ID_Producto INT,
    Cantidad INT,
    PrecioUnitario DECIMAL(18,2)
);
GO
CREATE PROCEDURE sp_RegistrarVenta
    @ID_Venta INT, @Fecha DATE, @ID_Cliente INT, @ID_Empleado INT,
    @Total DECIMAL(18,2), @ID_FormaPago INT,
    @Detalles DetalleVentaType READONLY
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO Venta (ID_Venta, Fecha, ID_Cliente, ID_Empleado, Total, ID_FormaPago)
        VALUES (@ID_Venta, @Fecha, @ID_Cliente, @ID_Empleado, @Total, @ID_FormaPago);
        INSERT INTO Detalle_Venta (ID_Detalle, ID_Venta, ID_Producto, Cantidad, PrecioUnitario)
        SELECT ID_Detalle, @ID_Venta, ID_Producto, Cantidad, PrecioUnitario FROM @Detalles;
        UPDATE Inventario SET Cantidad = Cantidad - d.Cantidad
        FROM Inventario i INNER JOIN @Detalles d ON i.ID_Producto = d.ID_Producto
        WHERE i.ID_Bodega = 1;
        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH;
END;
GO

-- 2. Registrar alquiler
CREATE PROCEDURE sp_RegistrarAlquiler
    @ID_Alquiler INT, @ID_Cliente INT, @ID_Vehiculo INT,
    @FechaInicio DATE, @FechaFin DATE, @PrecioDiario DECIMAL(18,2)
AS
BEGIN
    DECLARE @Total DECIMAL(18,2);
    IF @FechaFin IS NOT NULL
        SET @Total = DATEDIFF(day, @FechaInicio, @FechaFin) * @PrecioDiario;
    ELSE
        SET @Total = NULL;
    INSERT INTO Alquiler (ID_Alquiler, ID_Cliente, ID_Vehiculo, FechaInicio, FechaFin, PrecioDiario, Total, Estado)
    VALUES (@ID_Alquiler, @ID_Cliente, @ID_Vehiculo, @FechaInicio, @FechaFin, @PrecioDiario, @Total, 'Activo');
END;
GO

-- 3. Finalizar alquiler
CREATE PROCEDURE sp_FinalizarAlquiler
    @ID_Alquiler INT, @FechaFin DATE
AS
BEGIN
    DECLARE @PrecioDiario DECIMAL(18,2), @FechaInicio DATE, @Total DECIMAL(18,2);
    SELECT @PrecioDiario = PrecioDiario, @FechaInicio = FechaInicio 
    FROM Alquiler WHERE ID_Alquiler = @ID_Alquiler AND Estado = 'Activo';
    IF @@ROWCOUNT = 0
        THROW 50000, 'Alquiler no encontrado o no está activo', 1;
    SET @Total = DATEDIFF(day, @FechaInicio, @FechaFin) * @PrecioDiario;
    UPDATE Alquiler SET FechaFin = @FechaFin, Total = @Total, Estado = 'Finalizado'
    WHERE ID_Alquiler = @ID_Alquiler;
END;
GO

-- 4. Insertar mantenimiento con detalle
CREATE TYPE DetalleMantenimientoType AS TABLE (
    ID_DetalleMantenimiento INT,
    ID_Producto INT,
    Cantidad INT,
    PrecioUnitario DECIMAL(18,2)
);
GO
CREATE PROCEDURE sp_InsertarMantenimiento
    @ID_Mantenimiento INT, @ID_Vehiculo INT, @Fecha DATE, @Descripcion VARCHAR(500),
    @Costo DECIMAL(18,2), @ID_Empleado INT, @Estado VARCHAR(20),
    @Detalles DetalleMantenimientoType READONLY
AS
BEGIN
    INSERT INTO Mantenimiento (ID_Mantenimiento, ID_Vehiculo, Fecha, Descripcion, Costo, ID_Empleado, Estado)
    VALUES (@ID_Mantenimiento, @ID_Vehiculo, @Fecha, @Descripcion, @Costo, @ID_Empleado, @Estado);
    INSERT INTO Detalle_Mantenimiento (ID_DetalleMantenimiento, ID_Mantenimiento, ID_Producto, Cantidad, PrecioUnitario)
    SELECT ID_DetalleMantenimiento, @ID_Mantenimiento, ID_Producto, Cantidad, PrecioUnitario FROM @Detalles;
END;
GO

-- 5. Reporte de ganancias trimestrales
CREATE PROCEDURE sp_GananciasTrimestrales
    @Anio INT
AS
BEGIN
    WITH VentasTrim AS (
        SELECT DATEPART(QUARTER, Fecha) AS Trimestre, SUM(Total) AS TotalVentas
        FROM Venta WHERE YEAR(Fecha) = @Anio GROUP BY DATEPART(QUARTER, Fecha)
    ),
    AlquilerTrim AS (
        SELECT DATEPART(QUARTER, FechaInicio) AS Trimestre, SUM(ISNULL(Total,0)) AS TotalAlquileres
        FROM Alquiler WHERE YEAR(FechaInicio) = @Anio GROUP BY DATEPART(QUARTER, FechaInicio)
    )
    SELECT ISNULL(v.Trimestre, a.Trimestre) AS Trimestre,
           ISNULL(v.TotalVentas,0) AS Ventas,
           ISNULL(a.TotalAlquileres,0) AS Alquileres,
           ISNULL(v.TotalVentas,0)+ISNULL(a.TotalAlquileres,0) AS Total
    FROM VentasTrim v FULL JOIN AlquilerTrim a ON v.Trimestre = a.Trimestre
    ORDER BY Trimestre;
END;
GO

-- ==================== VISTAS (15) ====================

CREATE VIEW vw_VehiculosDisponibles AS
SELECT v.ID_Vehiculo, v.Placa, v.Modelo, tv.Nombre AS Tipo,
       CASE WHEN a.ID_Alquiler IS NOT NULL AND a.Estado = 'Activo' THEN 'Ocupado' ELSE 'Disponible' END AS EstadoAlquiler
FROM Vehiculo v
INNER JOIN Tipo_Vehiculo tv ON v.ID_TipoVehiculo = tv.ID_TipoVehiculo
LEFT JOIN Alquiler a ON v.ID_Vehiculo = a.ID_Vehiculo AND a.Estado = 'Activo';
GO

CREATE VIEW vw_VentasPorCliente AS
SELECT c.Nombre AS Cliente, COUNT(v.ID_Venta) AS NumVentas, SUM(v.Total) AS TotalCompras
FROM Cliente c LEFT JOIN Venta v ON c.ID_Cliente = v.ID_Cliente
GROUP BY c.Nombre;
GO

CREATE VIEW vw_AlquileresActivos AS
SELECT a.ID_Alquiler, c.Nombre AS Cliente, v.Placa, a.FechaInicio, a.PrecioDiario, a.Estado
FROM Alquiler a
INNER JOIN Cliente c ON a.ID_Cliente = c.ID_Cliente
INNER JOIN Vehiculo v ON a.ID_Vehiculo = v.ID_Vehiculo
WHERE a.Estado = 'Activo';
GO

CREATE VIEW vw_MantenimientosPendientes AS
SELECT m.ID_Mantenimiento, v.Placa, m.Descripcion, m.Fecha, m.Estado
FROM Mantenimiento m INNER JOIN Vehiculo v ON m.ID_Vehiculo = v.ID_Vehiculo
WHERE m.Estado = 'Pendiente';
GO

CREATE VIEW vw_InventarioBodegas AS
SELECT b.Nombre AS Bodega, p.Nombre AS Producto, i.Cantidad
FROM Inventario i
INNER JOIN Bodega b ON i.ID_Bodega = b.ID_Bodega
INNER JOIN Producto p ON i.ID_Producto = p.ID_Producto;
GO

CREATE VIEW vw_EmpleadosHabilitados AS
SELECT e.Nombre, e.Apellido, tv.Nombre AS TipoVehiculo, eh.Fecha_Habilitacion, eh.Fecha_Vencimiento
FROM Empleado_Habilitacion eh
INNER JOIN Empleado e ON eh.ID_Empleado = e.ID_Empleado
INNER JOIN Tipo_Vehiculo tv ON eh.ID_TipoVehiculo = tv.ID_TipoVehiculo;
GO

CREATE VIEW vw_ProductosTopVendidos AS
SELECT p.Nombre AS Producto, SUM(dv.Cantidad) AS UnidadesVendidas
FROM Detalle_Venta dv INNER JOIN Producto p ON dv.ID_Producto = p.ID_Producto
GROUP BY p.Nombre;
GO

CREATE VIEW vw_DetalleVentas AS
SELECT v.ID_Venta, v.Fecha, c.Nombre AS Cliente, e.Nombre + ' ' + e.Apellido AS Empleado,
       dv.Cantidad, p.Nombre AS Producto, dv.PrecioUnitario, (dv.Cantidad * dv.PrecioUnitario) AS Subtotal
FROM Venta v
INNER JOIN Cliente c ON v.ID_Cliente = c.ID_Cliente
INNER JOIN Empleado e ON v.ID_Empleado = e.ID_Empleado
INNER JOIN Detalle_Venta dv ON v.ID_Venta = dv.ID_Venta
INNER JOIN Producto p ON dv.ID_Producto = p.ID_Producto;
GO

CREATE VIEW vw_CostoMantenimientoVehiculo AS
SELECT v.Placa, COUNT(m.ID_Mantenimiento) AS NumMantenimientos, SUM(m.Costo) AS CostoTotal
FROM Mantenimiento m INNER JOIN Vehiculo v ON m.ID_Vehiculo = v.ID_Vehiculo
GROUP BY v.Placa;
GO

CREATE VIEW vw_Facturas2026 AS
SELECT NumeroFactura, Fecha, Total, Estado FROM Factura WHERE YEAR(Fecha) = 2026;
GO

CREATE VIEW vw_ClientesFrecuentesAlquiler AS
SELECT c.Nombre, COUNT(a.ID_Alquiler) AS TotalAlquileres
FROM Cliente c INNER JOIN Alquiler a ON c.ID_Cliente = a.ID_Cliente
GROUP BY c.Nombre HAVING COUNT(a.ID_Alquiler) > 1;
GO

CREATE VIEW vw_LicenciasVigentes AS
SELECT e.Nombre, e.Apellido, tv.Nombre AS TipoVehiculo, eh.Licencia, eh.Fecha_Vencimiento
FROM Empleado_Habilitacion eh
INNER JOIN Empleado e ON eh.ID_Empleado = e.ID_Empleado
INNER JOIN Tipo_Vehiculo tv ON eh.ID_TipoVehiculo = tv.ID_TipoVehiculo
WHERE eh.Fecha_Vencimiento >= GETDATE();
GO

CREATE VIEW vw_IngresosPorFormaPago AS
SELECT fp.Nombre AS FormaPago, SUM(v.Total) AS TotalVentas
FROM Venta v INNER JOIN FormaPago fp ON v.ID_FormaPago = fp.ID_FormaPago
GROUP BY fp.Nombre;
GO

CREATE VIEW vw_ProductosBajoStock AS
SELECT p.Nombre, i.Cantidad
FROM Inventario i INNER JOIN Producto p ON i.ID_Producto = p.ID_Producto
WHERE i.ID_Bodega = 1 AND i.Cantidad < 10;
GO

CREATE VIEW vw_ResumenVentasMensual AS
SELECT MONTH(Fecha) AS Mes, COUNT(*) AS NumVentas, SUM(Total) AS TotalVentas
FROM Venta WHERE YEAR(Fecha) = 2026 GROUP BY MONTH(Fecha);
GO

-- ==================== INSERCIÓN DE DATOS (20 POR TABLA, FECHAS 2024-2026) ====================

INSERT INTO Pais VALUES
(1,'Guatemala'),(2,'México'),(3,'El Salvador'),(4,'Honduras'),(5,'Costa Rica'),
(6,'Nicaragua'),(7,'Panamá'),(8,'Colombia'),(9,'Ecuador'),(10,'Perú'),
(11,'Chile'),(12,'Argentina'),(13,'Brasil'),(14,'Uruguay'),(15,'Paraguay'),
(16,'Bolivia'),(17,'Venezuela'),(18,'República Dominicana'),(19,'Puerto Rico'),(20,'Cuba');

INSERT INTO Departamento VALUES
(1,'Guatemala',1),(2,'Petén',1),(3,'San Salvador',3),(4,'Francisco Morazán',4),(5,'San José',5),
(6,'Quetzaltenango',1),(7,'Escuintla',1),(8,'Chimaltenango',1),(9,'Suchitepéquez',1),(10,'Alta Verapaz',1),
(11,'Managua',6),(12,'Panamá Centro',7),(13,'Cundinamarca',8),(14,'Pichincha',9),(15,'Lima',10),
(16,'Santiago',11),(17,'Buenos Aires',12),(18,'São Paulo',13),(19,'Montevideo',14),(20,'Asunción',15);

INSERT INTO Municipio VALUES
(1,'Ciudad de Guatemala',1),(2,'Flores',2),(3,'San Salvador Centro',3),(4,'Tegucigalpa',4),(5,'San José Centro',5),
(6,'Quetzaltenango',6),(7,'Escuintla',7),(8,'Chimaltenango',8),(9,'Mazatenango',9),(10,'Cobán',10),
(11,'Managua Centro',11),(12,'Panamá',12),(13,'Bogotá',13),(14,'Quito',14),(15,'Lima Centro',15),
(16,'Santiago Centro',16),(17,'Buenos Aires CABA',17),(18,'São Paulo Centro',18),(19,'Montevideo Centro',19),(20,'Asunción Centro',20);

INSERT INTO Empresa VALUES
(1,'Tractores del Norte S.A.','Z10, 5a Av. 2-30',1,'2233-4455','ventas@tractoresnorte.com','Venta'),
(2,'AgroMecánica Guatemalteca','Carr. El Salvador km 12',1,'2476-9898','info@agromecanica.com','Distribuidor'),
(3,'Implementos Agrícolas S.A.','San Miguel Petapa',1,'6633-2211','contacto@implementos.com','Repuestos'),
(4,'Tractores de México','Av. Reforma 123',2,'+52 55 1234 5678','ventas@tractoresmx.com','Venta'),
(5,'Maquinaria del Sur','San José, Barrio Escalante',5,'2256-7890','info@maquinariasur.com','Alquiler'),
(6,'Agroindustrias Modernas','Mixco',1,'2410-1010','agro@modernas.com','Fabricante'),
(7,'Motores Diesel S.A.','Villa Nueva',1,'2435-9999','motores@diesel.com','Motores'),
(8,'Lubricantes Centro','Escuintla',7,'7888-0000','lubri@centro.com','Lubricantes'),
(9,'Repuestos El Agricultor','Cobán',10,'7951-0000','repuestos@agricultor.com','Repuestos'),
(10,'Tractores del Pacífico','Mazatenango',9,'7872-0000','pacifico@tractores.com','Venta'),
(11,'Maquinaria de Occidente','Quetzaltenango',6,'7765-0000','occidente@maq.com','Alquiler'),
(12,'Equipos del Norte','Flores',2,'7926-0000','norte@equipos.com','Venta'),
(13,'Agro Servicios S.A.','Tegucigalpa',4,'+504 2235-0000','agro@servicios.hn','Servicios'),
(14,'Maquinaria San Salvador','San Salvador',3,'+503 2211-0000','maq@sv.com','Distribuidor'),
(15,'Tractores de Costa Rica','San José',5,'2256-0000','tractores@cr.com','Venta'),
(16,'AgroPartes Panamá','Panamá',12,'+507 300-0000','agropartes@pa.com','Repuestos'),
(17,'Insumos Agrícolas Bogotá','Bogotá',13,'+57 1 234 0000','insumos@bogota.com','Insumos'),
(18,'Maquinarias Quito','Quito',14,'+593 2 345 0000','quito@maq.com','Alquiler'),
(19,'Tractores Lima','Lima Centro',15,'+51 1 456 0000','lima@tractores.com','Venta'),
(20,'Agro Buenos Aires','Buenos Aires CABA',17,'+54 11 567 0000','agro@bsas.com','Distribuidor');

INSERT INTO Sucursal VALUES
(1,'Sucursal Central','Z10, 5a Av. 2-30',1,'2233-4455',1),
(2,'Sucursal Petén','Flores',2,'7926-1234',1),
(3,'Sucursal San Salvador','Blvd. Los Próceres',3,'+503 2211-2233',3),
(4,'Sucursal Tegucigalpa','Col. Palmira',4,'+504 2235-6789',4),
(5,'Sucursal San José','Barrio Escalante',5,'2256-7891',5),
(6,'Sucursal Quetzaltenango','Zona 3',6,'7765-4321',2),
(7,'Sucursal Escuintla','Calle Real',7,'7888-1234',2),
(8,'Sucursal Chimaltenango','Parque Central',8,'7833-5678',2),
(9,'Sucursal Mazatenango','Barrio San Antonio',9,'7872-1122',1),
(10,'Sucursal Cobán','Zona 4',10,'7951-3344',1),
(11,'Sucursal Mixco','Centro Comercial',1,'2435-6677',1),
(12,'Sucursal Villa Nueva','Boulevard',1,'2436-8899',1),
(13,'Sucursal Santa Lucia','Colonia Las Flores',6,'7767-9900',2),
(14,'Sucursal Tiquisate','Aldea El Centro',7,'7889-1122',2),
(15,'Sucursal Santo Domingo','Zona 2',8,'7834-5566',2),
(16,'Sucursal Managua','Centro',11,'+505 8844 0000',6),
(17,'Sucursal Panamá','Calle 50',12,'+507 300 1111',16),
(18,'Sucursal Bogotá','Av. 26',13,'+57 1 234 1111',17),
(19,'Sucursal Quito','Av. Amazonas',14,'+593 2 345 1111',18),
(20,'Sucursal Lima','Miraflores',15,'+51 1 456 1111',19);

INSERT INTO Puesto VALUES
(1,'Gerente de Ventas','Coordina ventas'),(2,'Mecánico','Mantenimiento y reparación'),(3,'Vendedor','Atención al cliente'),
(4,'Administrador','Gestión administrativa'),(5,'Conductor','Traslado de maquinaria'),(6,'Supervisor de Taller','Supervisa taller'),
(7,'Asesor Técnico','Asesoría'),(8,'Contador','Finanzas'),(9,'Jefe de Bodega','Control inventario'),
(10,'Operador','Manejo equipo'),(11,'Auxiliar Administrativo','Apoyo'),(12,'Electricista','Sistemas eléctricos'),
(13,'Soldador','Soldadura'),(14,'Montador','Montaje'),(15,'Programador','Software'),
(16,'Analista de Datos','BI'),(17,'Recepcionista','Atención telefónica'),(18,'Mensajero','Reparto'),
(19,'Conserje','Limpieza'),(20,'Becario','Aprendiz');

INSERT INTO Empleado VALUES
(1,'Carlos','López','1010','Zona 1',1,1),
(2,'María','González','1020','Zona 4',3,1),
(3,'Juan','Pérez','1030','Flores',2,2),
(4,'Ana','Martínez','1040','San Salvador',4,3),
(5,'Luis','Hernández','1050','Tegucigalpa',5,4),
(6,'Roberto','García','1060','Quetzaltenango',2,6),
(7,'Laura','Rodríguez','1070','Escuintla',3,7),
(8,'Pedro','Sánchez','1080','Chimaltenango',6,8),
(9,'Mónica','Ramírez','1090','Mazatenango',7,9),
(10,'Fernando','Castro','1100','Cobán',2,10),
(11,'Gabriela','Morales','1110','Mixco',3,11),
(12,'Ricardo','Ortiz','1120','Villa Nueva',5,12),
(13,'Patricia','Flores','1130','Santa Lucia',6,13),
(14,'Andrés','Jiménez','1140','Tiquisate',2,14),
(15,'Carolina','Vargas','1150','Santo Domingo',7,15),
(16,'Mario','Herrera','1160','Managua',8,16),
(17,'Tatiana','Rojas','1170','Panamá',9,17),
(18,'Jorge','Méndez','1180','Bogotá',10,18),
(19,'Lucía','Paz','1190','Quito',11,19),
(20,'Diego','Suárez','1200','Lima',12,20);

-- Inserción del resto de tablas manteniendo coherencia (20 registros cada una)
-- Para abreviar la respuesta, se incluyen todas las sentencias INSERT restantes de forma compacta.

INSERT INTO Telefono_Empleado VALUES
(1,1,'5555-1234','Móvil'),(2,2,'5555-5678','Móvil'),(3,3,'7926-4321','Casa'),(4,4,'+503 7000-1111','Móvil'),
(5,5,'+504 9999-8888','Móvil'),(6,6,'7765-1111','Móvil'),(7,7,'7888-2222','Casa'),(8,8,'7833-3333','Móvil'),
(9,9,'7872-4444','Móvil'),(10,10,'7951-5555','Casa'),(11,11,'2435-6666','Móvil'),(12,12,'2436-7777','Móvil'),
(13,13,'7767-8888','Casa'),(14,14,'7889-9999','Móvil'),(15,15,'7834-0000','Móvil'),(16,16,'+505 8844 0001','Móvil'),
(17,17,'+507 300 2222','Móvil'),(18,18,'+57 1 234 2222','Casa'),(19,19,'+593 2 345 2222','Móvil'),(20,20,'+51 1 456 2222','Móvil');

INSERT INTO Email_Empleado VALUES
(1,1,'carlos.lopez@empresa.com'),(2,2,'maria.gonzalez@empresa.com'),(3,3,'juan.perez@empresa.com'),
(4,4,'ana.martinez@empresa.com'),(5,5,'luis.hernandez@empresa.com'),(6,6,'roberto.garcia@empresa.com'),
(7,7,'laura.rodriguez@empresa.com'),(8,8,'pedro.sanchez@empresa.com'),(9,9,'monica.ramirez@empresa.com'),
(10,10,'fernando.castro@empresa.com'),(11,11,'gabriela.morales@empresa.com'),(12,12,'ricardo.ortiz@empresa.com'),
(13,13,'patricia.flores@empresa.com'),(14,14,'andres.jimenez@empresa.com'),(15,15,'carolina.vargas@empresa.com'),
(16,16,'mario.herrera@empresa.com'),(17,17,'tatiana.rojas@empresa.com'),(18,18,'jorge.mendez@empresa.com'),
(19,19,'lucia.paz@empresa.com'),(20,20,'diego.suarez@empresa.com');

INSERT INTO Horario_Empleado VALUES
(1,1,'Lunes','08:00','17:00'),(2,1,'Miércoles','08:00','17:00'),(3,2,'Lunes','09:00','18:00'),
(4,3,'Martes','07:00','16:00'),(5,4,'Jueves','08:30','17:30'),(6,5,'Viernes','08:00','17:00'),
(7,6,'Lunes','07:30','16:30'),(8,7,'Martes','09:00','18:00'),(9,8,'Miércoles','08:00','17:00'),
(10,9,'Jueves','07:00','16:00'),(11,10,'Viernes','08:30','17:30'),(12,11,'Lunes','08:00','17:00'),
(13,12,'Martes','09:00','18:00'),(14,13,'Miércoles','07:30','16:30'),(15,14,'Jueves','08:00','17:00'),
(16,15,'Viernes','08:00','17:00'),(17,16,'Lunes','09:00','18:00'),(18,17,'Martes','07:30','16:30'),
(19,18,'Miércoles','08:00','17:00'),(20,19,'Jueves','09:00','18:00');

INSERT INTO Cliente VALUES
(1,'Agricultura Moderna S.A.','2233-5566','compras@agricmod.com','Z12, Guatemala','1111',1),
(2,'Hacienda El Porvenir','7926-7788','contacto@elporvenir.com','Santa Elena, Petén','2222',2),
(3,'Cooperativa La Esperanza','+503 2211-4455','coopesperanza@coop.sv','San Salvador',NULL,3),
(4,'Inversiones Agrícolas','+504 2235-6677','inversionesag@hn.com','Tegucigalpa','3333',4),
(5,'Finca San José','2256-3344','fincasj@cr.com','San José','4444',5),
(6,'Agroexport','7765-1122','agroexport@gt.com','Quetzaltenango','5555',6),
(7,'Cafetalera La Mariposa','7888-3344','cafetal@gt.com','Escuintla','6666',7),
(8,'Granja Los Pinos','7833-5566','granjapinos@gt.com','Chimaltenango','7777',8),
(9,'Palmeras del Sur','7872-7788','palmeras@gt.com','Mazatenango','8888',9),
(10,'Cardamomo Real','7951-9900','cardamomo@gt.com','Cobán','9999',10),
(11,'Bodegas San Miguel','2435-1122','bodegas@gt.com','Mixco','10101',11),
(12,'Constructora Maya','2436-3344','constructora@gt.com','Villa Nueva','11112',12),
(13,'Textilera Moderna','7767-5566','textil@gt.com','Santa Lucia','1213',13),
(14,'Frutales Tropicales','7889-7788','frutales@gt.com','Tiquisate','1314',14),
(15,'Ganadera San Martín','7834-9900','ganadera@gt.com','Santo Domingo','1415',15),
(16,'AgroNica','+505 8844 1111','agronica@ni.com','Managua','1516',16),
(17,'AgriPanamá','+507 300 3333','agripanama@pa.com','Panamá','1617',17),
(18,'Campo Bogotá','+57 1 234 3333','campobogota@co.com','Bogotá','1718',18),
(19,'Hacienda Quito','+593 2 345 3333','haciendaquito@ec.com','Quito','1819',19),
(20,'AgroLima','+51 1 456 3333','agrolima@pe.com','Lima','1920',20);

-- ==================== INSERCIÓN DE DATOS FALTANTES (20 REGISTROS POR TABLA) ====================

-- PROVEEDOR (20)
INSERT INTO Proveedor VALUES
(1,'Repuestos John Deere','Roberto Díaz','2266-7788','Z21, Guatemala','ventas@johndeere.com',1),
(2,'Importadora Agrícola','Laura Méndez','2477-8899','Z12, Guatemala','importadora@agri.com',1),
(3,'Talleres El Salvador','Pedro Gómez','+503 2288-9900','San Salvador','talleres@sv.com',3),
(4,'Maquinaria Honduras','Sofía Castro','+504 2244-5566','Tegucigalpa','maquinaria@hn.com',4),
(5,'Equipos Costa Rica','Jorge Mora','2257-8899','San José','equipos@cr.com',5),
(6,'Filtros Nacionales','Carlos Mena','7765-1111','Quetzaltenango','filtros@gt.com',6),
(7,'Aceites Lubri','Ana Paz','7888-2222','Escuintla','aceites@gt.com',7),
(8,'Neumáticos del Sur','Luis Soto','7833-3333','Chimaltenango','llantas@gt.com',8),
(9,'Herramientas Maya','Mario López','7872-4444','Mazatenango','herramientas@gt.com',9),
(10,'Motores Diesel','Rosa Fuentes','7951-5555','Cobán','motores@gt.com',10),
(11,'Baterías Útiles','Eduardo Girón','2435-6666','Mixco','baterias@gt.com',11),
(12,'Transmisiones','Silvia Paz','2436-7777','Villa Nueva','transmisiones@gt.com',12),
(13,'Sistemas Hidráulicos','Oscar Lima','7767-8888','Santa Lucia','hidraulicos@gt.com',13),
(14,'Electrónica Agrícola','Cecilia Soto','7889-9999','Tiquisate','electronica@gt.com',14),
(15,'Refacciones Varias','Hugo Palma','7834-0000','Santo Domingo','refacciones@gt.com',15),
(16,'Proveedora Nicaragüense','Mario Pérez','+505 8844 2222','Managua','prove@ni.com',16),
(17,'Panamá Parts','Ana Gómez','+507 300 4444','Panamá','parts@pa.com',17),
(18,'Colombiana de Repuestos','Pedro Ruiz','+57 1 234 4444','Bogotá','colrep@co.com',18),
(19,'Ecuatoriana de Lubricantes','Lucía Vaca','+593 2 345 4444','Quito','lubri@ec.com',19),
(20,'Importadora Peruana','Diego Torres','+51 1 456 4444','Lima','import@pe.com',20);

-- CATEGORIA_PRODUCTO (20)
INSERT INTO Categoria_Producto VALUES
(1,'Tractores','Tractores agrícolas e industriales'),
(2,'Repuestos','Piezas y componentes'),
(3,'Implementos','Arados, rastras, sembradoras'),
(4,'Herramientas','Herramientas manuales y eléctricas'),
(5,'Lubricantes','Aceites y grasas'),
(6,'Neumáticos','Llantas y cámaras'),
(7,'Sistemas Hidráulicos','Mangueras, bombas'),
(8,'Electricidad','Arrancadores, alternadores'),
(9,'Cabina y Carrocería','Asientos, espejos'),
(10,'Motor','Pistones, camisas'),
(11,'Transmisión','Embragues, diferenciales'),
(12,'Frenos','Pastillas, discos'),
(13,'Refrigeración','Radiadores, bombas de agua'),
(14,'Escapes','Silenciadores, tubos'),
(15,'Dirección','Volantes, cajas de dirección'),
(16,'Suspensión','Amortiguadores, resortes'),
(17,'Agricultura de precisión','GPS, sensores'),
(18,'Riego','Aspersores, bombas'),
(19,'Cosecha','Cuchillas, dedos'),
(20,'Postcosecha','Secadoras, silos');

-- MARCA (20)
INSERT INTO Marca VALUES
(1,'John Deere'),(2,'Case IH'),(3,'New Holland'),(4,'Massey Ferguson'),(5,'Kubota'),
(6,'Deutz-Fahr'),(7,'Fendt'),(8,'Valtra'),(9,'Claas'),(10,'Challenger'),
(11,'Zetor'),(12,'McCormick'),(13,'Yanmar'),(14,'SAME'),(15,'Lamborghini'),
(16,'Shibaura'),(17,'ISEKI'),(18,'TYM'),(19,'LS Mtron'),(20,'Kioti');

-- PRODUCTO (20)
INSERT INTO Producto VALUES
(1,'Tractor 5050E',1,1,'Tractor agrícola 50 HP',35000.00,'Cada 250 horas'),
(2,'Filtro de aceite',2,1,'Filtro para motor John Deere',25.50,NULL),
(3,'Arado de discos',3,2,'Arado de 4 discos',1500.00,'Lubricación periódica'),
(4,'Llave de impacto',4,3,'Llave neumática 1/2"',120.00,NULL),
(5,'Aceite 15W40',5,4,'Galón de aceite multigrado',18.75,NULL),
(6,'Filtro de aire',2,1,'Filtro de aire primario',35.00,NULL),
(7,'Rastra de 20 discos',3,2,'Rastra offset',3200.00,'Cada 500 horas'),
(8,'Batería 12V',8,3,'Batería para tractor',180.00,NULL),
(9,'Correa de ventilador',2,4,'Correa de transmisión',45.00,NULL),
(10,'Filtro de combustible',2,5,'Filtro para diésel',28.50,NULL),
(11,'Tractor 6100D',1,1,'Tractor 100 HP',52000.00,'Cada 250 horas'),
(12,'Cosechadora 140',19,2,'Cosechadora de granos',89000.00,'Cada 200 horas'),
(13,'Segadora rotativa',3,3,'Segadora de 3 metros',4200.00,'Lubricación diaria'),
(14,'Cargador frontal',3,4,'Cargador para tractor',6800.00,'Cada 100 horas'),
(15,'Remolque agrícola',3,5,'Remolque de 5 toneladas',3500.00,NULL),
(16,'Llantas delanteras 7.5-16',6,6,'Neumático 4 lonas',120.00,NULL),
(17,'Bomba hidráulica',7,7,'Bomba de 25 GPM',850.00,'Cada 300 horas'),
(18,'Alternador 12V',8,8,'Alternador 100A',220.00,NULL),
(19,'Asiento ergonómico',9,9,'Asiento con suspensión',450.00,NULL),
(20,'Pistón anillado',10,10,'Pistón estándar',180.00,NULL);

-- TIPO_VEHICULO (20)
INSERT INTO Tipo_Vehiculo VALUES
(1,'Tractor'),(2,'Camión'),(3,'Pickup'),(4,'Motocicleta'),(5,'Remolque'),
(6,'Cosechadora'),(7,'Sembradora'),(8,'Fumigadora'),(9,'Subsolador'),(10,'Rastra'),
(11,'Camioneta'),(12,'Bus'),(13,'Panel'),(14,'Furgón'),(15,'Jeep'),
(16,'Cuatrimoto'),(17,'Retroexcavadora'),(18,'Excavadora'),(19,'Bulldozer'),(20,'Grúa');

-- VEHICULO (20) – fechas de modelos entre 2019 y 2025, referencias a clientes y productos
INSERT INTO Vehiculo VALUES
(1,'P-123ABC',1,'5050E',2020,1,'Verde','CHASIS001','VIN001','SERIE001','Motor Diesel 4Cil',2,2,4,3.5,1,1),
(2,'P-456DEF',2,'Farmall 75C',2021,1,'Rojo','CHASIS002','VIN002','SERIE002','Motor Diesel 6Cil',2,2,6,4.2,2,1),
(3,'C-789GHI',3,'T6.180',2019,1,'Azul','CHASIS003','VIN003','SERIE003','Motor Diesel 6Cil',2,2,6,5.0,3,NULL),
(4,'C-101JKL',4,'MF 4709',2022,1,'Gris','CHASIS004','VIN004','SERIE004','Motor Diesel 4Cil',2,2,4,3.8,4,NULL),
(5,'P-112MNO',5,'L3301',2023,1,'Naranja','CHASIS005','VIN005','SERIE005','Motor Diesel 3Cil',2,2,3,2.5,5,NULL),
(6,'P-987ABC',1,'6100D',2024,1,'Amarillo','CHASIS006','VIN006','SERIE006','Motor Diesel 6Cil',2,2,6,5.5,6,11),
(7,'P-654DEF',2,'Farmall 100C',2023,1,'Blanco','CHASIS007','VIN007','SERIE007','Motor Diesel 6Cil',2,2,6,5.0,7,1),
(8,'C-321GHI',3,'T7.200',2022,1,'Negro','CHASIS008','VIN008','SERIE008','Motor Diesel 6Cil',2,2,6,6.0,8,NULL),
(9,'C-654JKL',4,'MF 5713',2021,1,'Plata','CHASIS009','VIN009','SERIE009','Motor Diesel 6Cil',2,2,6,5.2,9,NULL),
(10,'P-789MNO',5,'M7060',2024,1,'Rojo','CHASIS010','VIN010','SERIE010','Motor Diesel 4Cil',2,2,4,4.0,10,1),
(11,'P-111ABC',1,'5075E',2022,1,'Verde','CHASIS011','VIN011','SERIE011','Motor Diesel 4Cil',2,2,4,3.8,11,1),
(12,'P-222DEF',2,'Farmall 50C',2020,1,'Azul','CHASIS012','VIN012','SERIE012','Motor Diesel 3Cil',2,2,3,2.8,12,1),
(13,'C-333GHI',3,'T5.120',2023,1,'Gris','CHASIS013','VIN013','SERIE013','Motor Diesel 4Cil',2,2,4,4.2,13,NULL),
(14,'C-444JKL',4,'MF 4707',2021,1,'Verde','CHASIS014','VIN014','SERIE014','Motor Diesel 4Cil',2,2,4,3.9,14,NULL),
(15,'P-555MNO',5,'L4701',2023,1,'Naranja','CHASIS015','VIN015','SERIE015','Motor Diesel 4Cil',2,2,4,3.2,15,1),
(16,'P-777XYZ',6,'Agrotron 120',2022,6,'Amarillo','CHASIS016','VIN016','SERIE016','Motor Diesel 6Cil',2,2,6,6.0,16,12),
(17,'P-888UVW',7,'9300R',2024,6,'Verde','CHASIS017','VIN017','SERIE017','Motor Diesel 6Cil',2,2,6,7.0,17,NULL),
(18,'P-999RST',8,'S374',2023,6,'Rojo','CHASIS018','VIN018','SERIE018','Motor Diesel 4Cil',2,2,4,4.5,18,NULL),
(19,'P-000QRS',9,'Axion 870',2022,6,'Gris','CHASIS019','VIN019','SERIE019','Motor Diesel 6Cil',2,2,6,5.8,19,NULL),
(20,'P-111LMN',10,'MT800',2024,6,'Negro','CHASIS020','VIN020','SERIE020','Motor Diesel 6Cil',2,2,6,6.2,20,NULL);

-- TARJETA_CIRCULACION (20) fechas entre 2024-2026
INSERT INTO Tarjeta_Circulacion VALUES
(1,1,'2025-12-31','2024-01-15','Admin','10:30','QR001'),
(2,2,'2025-12-31','2024-02-10','Admin','11:00','QR002'),
(3,3,'2025-12-31','2024-11-20','Operador','09:15','QR003'),
(4,4,'2026-01-31','2024-03-05','Admin','14:20','QR004'),
(5,5,'2025-06-30','2024-04-01','Operador','08:45','QR005'),
(6,6,'2026-12-31','2025-05-10','Admin','09:00','QR006'),
(7,7,'2025-12-31','2025-06-15','Admin','10:30','QR007'),
(8,8,'2026-01-31','2025-07-20','Operador','11:45','QR008'),
(9,9,'2025-12-31','2025-08-25','Admin','13:00','QR009'),
(10,10,'2025-06-30','2025-09-30','Operador','14:15','QR010'),
(11,11,'2025-12-31','2025-10-05','Admin','15:30','QR011'),
(12,12,'2026-01-31','2025-11-10','Operador','16:45','QR012'),
(13,13,'2025-12-31','2025-12-15','Admin','08:00','QR013'),
(14,14,'2026-01-31','2024-01-20','Operador','09:30','QR014'),
(15,15,'2025-06-30','2024-02-25','Admin','10:00','QR015'),
(16,16,'2026-12-31','2025-03-10','Admin','11:15','QR016'),
(17,17,'2025-12-31','2025-04-20','Operador','07:45','QR017'),
(18,18,'2026-01-31','2025-05-05','Admin','14:00','QR018'),
(19,19,'2025-12-31','2025-06-20','Admin','09:30','QR019'),
(20,20,'2026-06-30','2025-07-15','Operador','10:00','QR020');

-- EQUIPO_LIVIANO (20)
INSERT INTO Equipo_Liviano VALUES
(1,'Motoguadaña','Herramienta motorizada','Para corte de maleza',4),
(2,'Taladro inalámbrico','Herramienta eléctrica','Taladro percutor 18V',4),
(3,'Sierra circular','Herramienta eléctrica','Sierra de mesa portátil',NULL),
(4,'Compresor de aire','Equipo taller','Compresor 50 litros',NULL),
(5,'Generador eléctrico','Equipo energía','Generador 5kW',NULL),
(6,'Esmeril angular','Herramienta eléctrica','Disco 7"',4),
(7,'Hidrolavadora','Equipo limpieza','Presión 2000 psi',NULL),
(8,'Soldadora inverter','Equipo taller','Soldadora 140A',NULL),
(9,'Pulidora','Herramienta eléctrica','Pulidora de banco',4),
(10,'Cierra cinta','Herramienta eléctrica','Para metales',4),
(11,'Gato hidráulico','Equipo taller','Capacidad 3 toneladas',NULL),
(12,'Manómetro','Herramienta medición','Para neumáticos',4),
(13,'Llave de torque','Herramienta manual','Rango 20-200 Nm',4),
(14,'Multímetro','Herramienta medición','Digital',4),
(15,'Cargador de baterías','Equipo taller','Automático 12V',NULL),
(16,'Soldadora de arco','Equipo taller','250A',NULL),
(17,'Cortadora de plasma','Equipo taller','40A',NULL),
(18,'Amoladora','Herramienta eléctrica','4 1/2"',4),
(19,'Atornillador eléctrico','Herramienta eléctrica','18V',4),
(20,'Medidor de presión','Herramienta medición','0-100 psi',4);

-- BODEGA (20)
INSERT INTO Bodega VALUES
(1,'Bodega Central','Z10, 5a Av. 2-30',5000,1),
(2,'Bodega Petén','Santa Elena, Flores',2000,2),
(3,'Bodega San Salvador','Blvd. Los Próceres',3000,3),
(4,'Bodega Tegucigalpa','Col. Palmira',2500,4),
(5,'Bodega San José','Barrio Escalante',1800,5),
(6,'Bodega Quetzaltenango','Zona 3',2200,6),
(7,'Bodega Escuintla','Calle Real',1500,7),
(8,'Bodega Chimaltenango','Parque Central',1200,8),
(9,'Bodega Mazatenango','Barrio San Antonio',1600,9),
(10,'Bodega Cobán','Zona 4',1400,10),
(11,'Bodega Mixco','Centro Comercial',1700,11),
(12,'Bodega Villa Nueva','Boulevard',1900,12),
(13,'Bodega Santa Lucia','Colonia Las Flores',1300,13),
(14,'Bodega Tiquisate','Aldea El Centro',1100,14),
(15,'Bodega Santo Domingo','Zona 2',1000,15),
(16,'Bodega Managua','Centro',1800,16),
(17,'Bodega Panamá','Calle 50',2000,17),
(18,'Bodega Bogotá','Av. 26',2500,18),
(19,'Bodega Quito','Av. Amazonas',1600,19),
(20,'Bodega Lima','Miraflores',2200,20);

-- INVENTARIO (20)
INSERT INTO Inventario VALUES
(1,1,1,10),(2,2,1,500),(3,3,2,25),(4,4,3,40),(5,5,4,200),
(6,6,1,150),(7,7,2,12),(8,8,3,80),(9,9,4,60),(10,10,5,300),
(11,11,6,5),(12,12,7,3),(13,13,8,15),(14,14,9,20),(15,15,10,30),
(16,16,1,50),(17,17,2,10),(18,18,3,25),(19,19,4,100),(20,20,5,200);

-- FORMAPAGO (20)
INSERT INTO FormaPago VALUES
(1,'Efectivo'),(2,'Tarjeta de crédito'),(3,'Transferencia bancaria'),(4,'Cheque'),(5,'Crédito'),
(6,'PayPal'),(7,'Criptomoneda'),(8,'Depósito bancario'),(9,'Vale'),(10,'Contra entrega'),
(11,'Tarjeta de débito'),(12,'Financiamiento'),(13,'Consignación'),(14,'Canje'),(15,'Descuento directo'),
(16,'Bonos'),(17,'Pago móvil'),(18,'Link de pago'),(19,'Débito automático'),(20,'Trueque');

-- VENTA (20) fechas entre 2024 y 2026
INSERT INTO Venta VALUES
(1,'2024-01-15',1,2,35000.00,2),
(2,'2024-02-20',2,3,1275.00,1),
(3,'2024-03-10',3,4,1500.00,3),
(4,'2024-04-05',4,5,120.00,2),
(5,'2024-05-12',5,1,93.75,1),
(6,'2024-06-18',6,2,52000.00,5),
(7,'2024-07-22',7,3,89000.00,2),
(8,'2024-08-30',8,4,4200.00,3),
(9,'2024-09-14',9,5,6800.00,1),
(10,'2024-10-25',10,1,3500.00,4),
(11,'2024-11-08',11,2,35000.00,5),
(12,'2024-12-19',12,3,1275.00,1),
(13,'2025-01-09',13,4,1500.00,2),
(14,'2025-02-14',14,5,52000.00,3),
(15,'2025-03-21',15,1,89000.00,5),
(16,'2025-04-17',16,16,35000.00,6),
(17,'2025-05-23',17,17,52000.00,7),
(18,'2025-06-30',18,18,89000.00,8),
(19,'2025-07-11',19,19,4200.00,9),
(20,'2025-08-15',20,20,3500.00,10);

-- DETALLE_VENTA (20)
INSERT INTO Detalle_Venta VALUES
(1,1,1,1,35000.00),(2,2,2,50,25.50),(3,3,3,1,1500.00),(4,4,4,1,120.00),(5,5,5,5,18.75),
(6,6,11,1,52000.00),(7,7,12,1,89000.00),(8,8,13,1,4200.00),(9,9,14,1,6800.00),(10,10,15,1,3500.00),
(11,11,1,1,35000.00),(12,12,2,50,25.50),(13,13,3,1,1500.00),(14,14,11,1,52000.00),(15,15,12,1,89000.00),
(16,16,1,1,35000.00),(17,17,11,1,52000.00),(18,18,12,1,89000.00),(19,19,13,1,4200.00),(20,20,15,1,3500.00);

-- ALQUILER (20) fechas 2024-2026, estados variados
INSERT INTO Alquiler VALUES
(1,1,3,'2024-06-01','2024-06-05',200.00,1000.00,'Finalizado'),
(2,2,4,'2024-07-10','2024-07-15',250.00,1250.00,'Finalizado'),
(3,3,5,'2024-08-20','2024-08-22',180.00,360.00,'Finalizado'),
(4,4,1,'2024-09-05','2024-09-10',300.00,1500.00,'Finalizado'),
(5,5,2,'2024-10-01',NULL,220.00,NULL,'Activo'),
(6,6,6,'2024-11-11','2024-11-15',320.00,1280.00,'Finalizado'),
(7,7,7,'2024-12-01','2024-12-03',280.00,560.00,'Finalizado'),
(8,8,8,'2025-01-15','2025-01-20',350.00,1750.00,'Finalizado'),
(9,9,9,'2025-02-10','2025-02-15',300.00,1500.00,'Finalizado'),
(10,10,10,'2025-03-05',NULL,220.00,NULL,'Activo'),
(11,11,11,'2025-04-18','2025-04-22',400.00,1600.00,'Finalizado'),
(12,12,12,'2025-05-20','2025-05-25',250.00,1250.00,'Finalizado'),
(13,13,13,'2025-06-01',NULL,380.00,NULL,'Activo'),
(14,14,14,'2025-07-12','2025-07-15',290.00,870.00,'Finalizado'),
(15,15,15,'2025-08-08','2025-08-10',210.00,420.00,'Finalizado'),
(16,16,16,'2025-09-01','2025-09-05',400.00,2000.00,'Finalizado'),
(17,17,17,'2025-10-10','2025-10-15',450.00,2250.00,'Finalizado'),
(18,18,18,'2025-11-05',NULL,380.00,NULL,'Activo'),
(19,19,19,'2025-12-01','2025-12-05',500.00,2500.00,'Finalizado'),
(20,20,20,'2026-01-10',NULL,420.00,NULL,'Activo');

-- MANTENIMIENTO (20) fechas 2024-2026
INSERT INTO Mantenimiento VALUES
(1,1,'2024-03-05','Cambio de aceite y filtros',150.00,3,'Finalizado'),
(2,2,'2024-04-20','Revisión general',80.00,3,'Finalizado'),
(3,3,'2024-05-15','Reparación de transmisión',1200.00,3,'Finalizado'),
(4,4,'2024-06-10','Alineación y balanceo',200.00,5,'Finalizado'),
(5,5,'2024-07-22','Cambio de llantas',600.00,2,'Finalizado'),
(6,6,'2024-08-30','Cambio de aceite',120.00,6,'Finalizado'),
(7,7,'2024-09-12','Revisión de frenos',200.00,6,'Finalizado'),
(8,8,'2024-10-25','Reparación de motor',1500.00,6,'Finalizado'),
(9,9,'2024-11-05','Cambio de llantas',800.00,8,'Finalizado'),
(10,10,'2024-12-18','Alineación',100.00,14,'Finalizado'),
(11,11,'2025-02-14','Cambio de filtros',180.00,3,'Finalizado'),
(12,12,'2025-03-22','Revisión general',120.00,3,'Finalizado'),
(13,13,'2025-04-09','Reparación de clutch',950.00,6,'Finalizado'),
(14,14,'2025-05-30','Cambio de aceite',150.00,14,'Finalizado'),
(15,15,'2025-06-15','Mantenimiento mayor',2500.00,6,'Finalizado'),
(16,16,'2025-07-20','Revisión preventiva',200.00,16,'Finalizado'),
(17,17,'2025-08-10','Cambio de aceite hidráulico',400.00,17,'Finalizado'),
(18,18,'2025-09-25','Ajuste de motor',300.00,18,'Finalizado'),
(19,19,'2025-10-15','Reparación de frenos',600.00,19,'Finalizado'),
(20,20,'2025-11-30','Cambio de neumáticos',1200.00,20,'Pendiente');

-- USUARIO (20)
INSERT INTO Usuario VALUES
(1,'carlosl','carlos.lopez@empresa.com','pass123','admin',1),
(2,'mariag','maria.gonzalez@empresa.com','pass456','vendedor',2),
(3,'juanp','juan.perez@empresa.com','pass789','mecanico',3),
(4,'anam','ana.martinez@empresa.com','passabc','admin',4),
(5,'luish','luis.hernandez@empresa.com','passdef','conductor',5),
(6,'robertog','roberto.garcia@empresa.com','pass111','mecanico',6),
(7,'laurar','laura.rodriguez@empresa.com','pass222','vendedor',7),
(8,'pedros','pedro.sanchez@empresa.com','pass333','supervisor',8),
(9,'monicar','monica.ramirez@empresa.com','pass444','asesor',9),
(10,'fernandoc','fernando.castro@empresa.com','pass555','mecanico',10),
(11,'gabrielam','gabriela.morales@empresa.com','pass666','vendedor',11),
(12,'ricardoo','ricardo.ortiz@empresa.com','pass777','conductor',12),
(13,'patriciaf','patricia.flores@empresa.com','pass888','supervisor',13),
(14,'andresj','andres.jimenez@empresa.com','pass999','mecanico',14),
(15,'carolinav','carolina.vargas@empresa.com','pass000','asesor',15),
(16,'marioh','mario.herrera@empresa.com','passm1','admin',16),
(17,'tatianar','tatiana.rojas@empresa.com','passt1','vendedor',17),
(18,'jorgem','jorge.mendez@empresa.com','passj1','mecanico',18),
(19,'luciap','luisa.paz@empresa.com','passl1','admin',19),
(20,'diegos','diego.suarez@empresa.com','passd1','conductor',20);

-- UBICACION (20)
INSERT INTO Ubicacion VALUES
(1,'Parqueo Central','Z10, Guatemala','Estacionamiento',1),
(2,'Taller Petén','Santa Elena, Flores','Taller',2),
(3,'Oficinas San Salvador','Blvd. Los Próceres','Oficina',3),
(4,'Bodega Tegucigalpa','Col. Palmira','Bodega',4),
(5,'Punto de venta San José','Barrio Escalante','Tienda',5),
(6,'Taller Quetzaltenango','Zona 3','Taller',6),
(7,'Parqueo Escuintla','Calle Real','Estacionamiento',7),
(8,'Oficinas Chimaltenango','Parque Central','Oficina',8),
(9,'Bodega Mazatenango','Barrio San Antonio','Bodega',9),
(10,'Taller Cobán','Zona 4','Taller',10),
(11,'Parqueo Mixco','Centro Comercial','Estacionamiento',11),
(12,'Oficinas Villa Nueva','Boulevard','Oficina',12),
(13,'Bodega Santa Lucia','Colonia Las Flores','Bodega',13),
(14,'Taller Tiquisate','Aldea El Centro','Taller',14),
(15,'Parqueo Santo Domingo','Zona 2','Estacionamiento',15),
(16,'Taller Managua','Centro','Taller',16),
(17,'Oficinas Panamá','Calle 50','Oficina',17),
(18,'Bodega Bogotá','Av. 26','Bodega',18),
(19,'Parqueo Quito','Av. Amazonas','Estacionamiento',19),
(20,'Taller Lima','Miraflores','Taller',20);

-- FICHA_TECNICA (20)
INSERT INTO Ficha_Tecnica VALUES
(1,1,'Motor diésel 4 cilindros, transmisión mecánica','50 HP','2100 kg'),
(2,2,'Filtro de aceite para motores John Deere','N/A','0.5 kg'),
(3,3,'Arado de discos de 4 cuerpos','N/A','800 kg'),
(4,4,'Llave de impacto neumática 1/2"','N/A','2.5 kg'),
(5,5,'Aceite multigrado 15W40, galón','N/A','3.5 kg'),
(6,6,'Filtro de aire primario','N/A','0.8 kg'),
(7,7,'Rastra offset de 20 discos','N/A','1200 kg'),
(8,8,'Batería 12V 100Ah','N/A','25 kg'),
(9,9,'Correa de ventilador','N/A','0.2 kg'),
(10,10,'Filtro de combustible diésel','N/A','0.4 kg'),
(11,11,'Tractor 100 HP, 6 cilindros','100 HP','4500 kg'),
(12,12,'Cosechadora de granos, motor 6 cilindros','220 HP','8500 kg'),
(13,13,'Segadora rotativa de 3 m','N/A','700 kg'),
(14,14,'Cargador frontal para tractor','N/A','950 kg'),
(15,15,'Remolque agrícola 5 toneladas','N/A','1500 kg'),
(16,16,'Llanta delantera 7.5-16, 4 lonas','N/A','12 kg'),
(17,17,'Bomba hidráulica 25 GPM','N/A','8 kg'),
(18,18,'Alternador 12V 100A','N/A','4 kg'),
(19,19,'Asiento con suspensión','N/A','28 kg'),
(20,20,'Pistón estándar','N/A','1.2 kg');

-- DETALLE_MANTENIMIENTO (20)
INSERT INTO Detalle_Mantenimiento VALUES
(1,1,2,2,25.50),(2,1,5,4,18.75),(3,2,6,1,35.00),(4,3,10,1,28.50),
(5,3,9,2,45.00),(6,4,4,1,120.00),(7,5,8,2,180.00),(8,6,2,1,25.50),
(9,6,5,2,18.75),(10,7,6,1,35.00),(11,8,10,2,28.50),(12,9,8,1,180.00),
(13,10,9,1,45.00),(14,11,2,1,25.50),(15,12,5,1,18.75),(16,13,10,1,28.50),
(17,14,2,1,25.50),(18,15,5,4,18.75),(19,16,6,1,35.00),(20,17,10,2,28.50);

-- EMPLEADO_HABILITACION (20) fechas 2024-2026
INSERT INTO Empleado_Habilitacion VALUES
(1,1,1,'2024-01-10','2026-01-10','L-1234'),
(2,2,1,'2024-02-15','2026-02-15','L-5678'),
(3,3,1,'2024-03-20','2026-03-20','L-9012'),
(4,4,2,'2024-04-01','2026-04-01','L-3456'),
(5,5,1,'2024-05-05','2026-05-05','L-7890'),
(6,6,1,'2024-06-10','2026-06-10','L-1111'),
(7,7,3,'2024-07-15','2026-07-15','L-2222'),
(8,8,1,'2024-08-20','2026-08-20','L-3333'),
(9,9,1,'2024-09-25','2026-09-25','L-4444'),
(10,10,1,'2024-10-30','2026-10-30','L-5555'),
(11,11,1,'2024-11-05','2026-11-05','L-6666'),
(12,12,1,'2024-12-10','2026-12-10','L-7777'),
(13,13,2,'2025-01-15','2027-01-15','L-8888'),
(14,14,1,'2025-02-20','2027-02-20','L-9999'),
(15,15,3,'2025-03-25','2027-03-25','L-0000'),
(16,16,1,'2025-06-01','2027-06-01','L-1112'),
(17,17,1,'2025-07-01','2027-07-01','L-1113'),
(18,18,2,'2025-08-01','2027-08-01','L-1114'),
(19,19,1,'2025-09-01','2027-09-01','L-1115'),
(20,20,1,'2025-10-01','2027-10-01','L-1116');

-- FACTURA (20) fechas 2024-2026
INSERT INTO Factura VALUES
(1,'F001','2024-01-15',1,NULL,35000.00,'Pagada'),
(2,'F002','2024-02-20',2,NULL,1275.00,'Pagada'),
(3,'F003','2024-03-10',3,NULL,1500.00,'Pagada'),
(4,'F004','2024-04-05',4,NULL,120.00,'Pagada'),
(5,'F005','2024-05-12',5,NULL,93.75,'Pagada'),
(6,'F006','2024-06-18',6,NULL,52000.00,'Pendiente'),
(7,'F007','2024-07-22',7,NULL,89000.00,'Pagada'),
(8,'F008','2024-08-30',8,NULL,4200.00,'Pagada'),
(9,'F009','2024-09-14',9,NULL,6800.00,'Pagada'),
(10,'F010','2024-10-25',10,NULL,3500.00,'Pagada'),
(11,'F011','2024-11-11',NULL,6,1280.00,'Pagada'),
(12,'F012','2024-12-01',NULL,7,560.00,'Pagada'),
(13,'F013','2025-01-15',NULL,8,1750.00,'Pagada'),
(14,'F014','2025-02-10',NULL,9,1500.00,'Pagada'),
(15,'F015','2025-04-18',NULL,11,1600.00,'Pagada'),
(16,'F016','2025-05-20',NULL,12,1250.00,'Pagada'),
(17,'F017','2025-09-01',NULL,16,2000.00,'Pagada'),
(18,'F018','2025-10-10',NULL,17,2250.00,'Pagada'),
(19,'F019','2025-12-01',NULL,19,2500.00,'Pagada'),
(20,'F020','2026-01-15',16,NULL,35000.00,'Pendiente');

-- ==================== INSERCIÓN DE DOCUMENTOS JSON CON REFERENCIAS ====================
INSERT INTO GrupoTecun_NoSQL (DatosJSON, ID_Usuario, ID_Cliente, ID_Vehiculo, ID_Producto, ID_Venta, ID_Alquiler, ID_Mantenimiento, ID_Empleado) VALUES
(N'{"Vehiculo":{"Placa":"P-123ABC","Marca":"John Deere","Modelo":"5050E","Anio":2020,"Especificaciones":{"Motor":"Diésel 4 cilindros","Potencia":"50 HP"}}}', NULL, NULL, 1, 1, NULL, NULL, NULL, NULL),
(N'{"AlquilerExtendido":{"ID_Alquiler":1,"Cliente":"Agricultura Moderna S.A.","Vehiculo":"C-789GHI","FechaInicio":"2024-06-01","FechaFin":"2024-06-05","Total":1000.00,"Estado":"Finalizado"}}', NULL, 1, 3, NULL, NULL, 1, NULL, NULL),
(N'{"MantenimientoDetalle":{"ID_Mantenimiento":3,"Vehiculo":"C-789GHI","Servicios":[{"Descripcion":"Reparación de transmisión","Costo":1200.00}]}}', NULL, NULL, 3, NULL, NULL, NULL, 3, NULL),
(N'{"ClienteVIP":{"ID_Cliente":8,"Nombre":"Granja Los Pinos","Beneficios":["Descuento 10%","Prioridad en alquiler"]}}', NULL, 8, NULL, NULL, NULL, NULL, NULL, NULL),
(N'{"SensorData":{"Vehiculo":"P-987ABC","Fecha":"2025-03-10","TemperaturaMotor":88,"PresionAceite":34}}', NULL, NULL, 6, NULL, NULL, NULL, NULL, NULL),
(N'{"InventarioExtra":{"ID_Producto":2,"Nombre":"Filtro de aceite","Ubicacion":"Estante A3, Bodega Central","StockMinimo":50}}', NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL),
(N'{"ConfiguracionSistema":{"Moneda":"GTQ","AlertasActivas":["Stock bajo","Mantenimiento vencido"]}}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(N'{"FeedbackCliente":{"ID_Cliente":15,"Comentario":"Excelente servicio postventa","Puntuacion":5,"Fecha":"2025-07-10"}}', NULL, 15, NULL, NULL, NULL, NULL, NULL, NULL),
(N'{"Auditoria":{"Tabla":"Venta","Accion":"INSERT","ID_Afectado":1,"Usuario":"carlosl","Fecha":"2024-01-15T10:00:00"}}', 1, NULL, NULL, NULL, 1, NULL, NULL, NULL),
(N'{"Notificacion":{"Tipo":"Recordatorio","Mensaje":"Próximo mantenimiento para P-111ABC","FechaEnvio":"2024-11-01"}}', NULL, NULL, 11, NULL, NULL, NULL, NULL, NULL),
(N'{"ProveedorExtendido":{"ID_Proveedor":13,"Nombre":"Sistemas Hidráulicos","ProductosSuministrados":[17,18],"Calificacion":4.8}}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(N'{"TarjetaCirculacionDigital":{"ID_Vehiculo":3,"Placa":"C-789GHI","FechaEmision":"2024-11-20","FechaVencimiento":"2025-11-20"}}', NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL),
(N'{"ContratoAlquiler":{"ID_Alquiler":5,"Cliente":"Finca San José","Vehiculo":"P-456DEF","FechaInicio":"2024-10-01","FechaFin":null,"Condiciones":"Depósito 20%"}}', NULL, 5, 2, NULL, NULL, 5, NULL, NULL),
(N'{"EmpleadoDigital":{"ID_Empleado":5,"Nombre":"Luis Hernández","Habilidades":["Conducción","Carga pesada"],"Certificaciones":["ISO 9001"]}}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5),
(N'{"ReporteFinanciero":{"Trimestre":"Q1-2025","IngresosVentas":180000.00,"IngresosAlquileres":45000.00,"UtilidadNeta":52000.00}}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(N'{"HistorialTarifas":{"Producto":"Tractor 6100D","Cambios":[{"Fecha":"2024-01-01","Precio":50000},{"Fecha":"2025-06-01","Precio":52000},{"Fecha":"2026-01-01","Precio":53500}]}}', NULL, NULL, NULL, 11, NULL, NULL, NULL, NULL),
(N'{"DocumentoLegal":{"Tipo":"ContratoMarco","Partes":["Grupo Tecún","Agroexport"],"Vigencia":"2024-06-01 al 2026-06-01"}}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(N'{"Capacitacion":{"Curso":"Mantenimiento de sistemas hidráulicos","Instructor":"Ing. Oscar Lima","Asistentes":[8,13,14],"Fecha":"2025-07-10"}}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(N'{"IndicadorGlobal":{"Nombre":"Indice de Satisfacción Cliente","Valor":92.5,"Unidad":"%","FechaMedicion":"2025-12-01"}}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(N'{"SucursalPeru":{"ID_Sucursal":20,"Nombre":"Sucursal Lima","Gerente":"Diego Suárez","FechaApertura":"2025-03-15"}}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- ==================== 15 CONSULTAS CON JOIN ====================

-- 1. Alquiler de tractores
SELECT a.ID_Alquiler, c.Nombre AS Cliente, v.Placa, v.Modelo, tv.Nombre AS TipoVehiculo,
       a.FechaInicio, a.FechaFin, a.PrecioDiario, a.Total
FROM Alquiler a
JOIN Vehiculo v ON a.ID_Vehiculo = v.ID_Vehiculo
JOIN Tipo_Vehiculo tv ON v.ID_TipoVehiculo = tv.ID_TipoVehiculo
JOIN Cliente c ON a.ID_Cliente = c.ID_Cliente
WHERE tv.Nombre = 'Tractor';

-- 2. Materiales usados en mantenimientos
SELECT m.ID_Mantenimiento, v.Placa, p.Nombre AS Material, dm.Cantidad, (dm.Cantidad*dm.PrecioUnitario) AS Subtotal
FROM Mantenimiento m
JOIN Detalle_Mantenimiento dm ON m.ID_Mantenimiento = dm.ID_Mantenimiento
JOIN Producto p ON dm.ID_Producto = p.ID_Producto
JOIN Vehiculo v ON m.ID_Vehiculo = v.ID_Vehiculo;

-- 3. Empleados habilitados para manejar tractores/pickups/camiones
SELECT e.Nombre, e.Apellido, tv.Nombre AS TipoVehiculo, eh.Fecha_Habilitacion
FROM Empleado_Habilitacion eh
JOIN Empleado e ON eh.ID_Empleado = e.ID_Empleado
JOIN Tipo_Vehiculo tv ON eh.ID_TipoVehiculo = tv.ID_TipoVehiculo
WHERE tv.Nombre IN ('Tractor','Camión','Pickup');

-- 4. Ganancias por trimestre en alquiler de tractores 2025
SELECT DATEPART(QUARTER, a.FechaInicio) AS Trimestre, SUM(a.Total) AS Ganancias
FROM Alquiler a
JOIN Vehiculo v ON a.ID_Vehiculo = v.ID_Vehiculo
JOIN Tipo_Vehiculo tv ON v.ID_TipoVehiculo = tv.ID_TipoVehiculo
WHERE tv.Nombre = 'Tractor' AND YEAR(a.FechaInicio) = 2025
GROUP BY DATEPART(QUARTER, a.FechaInicio);

-- 5. Clientes con más alquileres (top)
SELECT TOP 5 c.Nombre, COUNT(*) AS Cantidad, SUM(ISNULL(a.Total,0)) AS TotalGastado
FROM Cliente c
JOIN Alquiler a ON c.ID_Cliente = a.ID_Cliente
GROUP BY c.Nombre
ORDER BY Cantidad DESC;

-- 6. Mantenimientos por mes en 2025
SELECT MONTH(Fecha) AS Mes, COUNT(*) AS Cantidad, SUM(Costo) AS CostoTotal
FROM Mantenimiento WHERE YEAR(Fecha)=2025 GROUP BY MONTH(Fecha);

-- 7. Vehículos más alquilados (tractores)
SELECT TOP 5 v.Placa, m.Nombre AS Marca, COUNT(*) AS Veces
FROM Vehiculo v
JOIN Marca m ON v.ID_Marca = m.ID_Marca
JOIN Alquiler a ON v.ID_Vehiculo = a.ID_Vehiculo
WHERE v.ID_TipoVehiculo = 1
GROUP BY v.Placa, m.Nombre
ORDER BY Veces DESC;

-- 8. Empleados con su sucursal y ubicación
SELECT e.Nombre + ' ' + e.Apellido AS Empleado, s.Nombre AS Sucursal, mu.Nombre AS Municipio, depto.Nombre AS Departamento
FROM Empleado e
JOIN Sucursal s ON e.ID_Sucursal = s.ID_Sucursal
JOIN Municipio mu ON s.ID_Municipio = mu.ID_Municipio
JOIN Departamento depto ON mu.ID_Departamento = depto.ID_Departamento;

-- 9. Productos con ficha técnica y categoría
SELECT p.Nombre, ft.Especificaciones, c.Nombre AS Categoria
FROM Producto p
JOIN Ficha_Tecnica ft ON p.ID_Producto = ft.ID_Producto
JOIN Categoria_Producto c ON p.ID_Categoria = c.ID_Categoria;

-- 10. Ventas con método de pago y cliente (2024-2026)
SELECT v.ID_Venta, v.Fecha, c.Nombre AS Cliente, fp.Nombre AS FormaPago, v.Total
FROM Venta v
JOIN Cliente c ON v.ID_Cliente = c.ID_Cliente
JOIN FormaPago fp ON v.ID_FormaPago = fp.ID_FormaPago
WHERE YEAR(v.Fecha) BETWEEN 2024 AND 2026;

-- 11. Proveedores por país
SELECT p.Nombre AS Proveedor, pais.Nombre AS Pais
FROM Proveedor p
JOIN Municipio mu ON p.ID_Municipio = mu.ID_Municipio
JOIN Departamento d ON mu.ID_Departamento = d.ID_Departamento
JOIN Pais pais ON d.ID_Pais = pais.ID_Pais;

-- 12. Alquileres finalizados con factura
SELECT a.ID_Alquiler, c.Nombre, v.Placa, f.NumeroFactura, f.Total
FROM Alquiler a
JOIN Factura f ON a.ID_Alquiler = f.ID_Alquiler
JOIN Cliente c ON a.ID_Cliente = c.ID_Cliente
JOIN Vehiculo v ON a.ID_Vehiculo = v.ID_Vehiculo;

-- 13. Mecánicos que realizaron mantenimientos en 2024
SELECT e.Nombre + ' ' + e.Apellido AS Mecanico, m.Fecha, m.Descripcion, m.Costo
FROM Mantenimiento m
JOIN Empleado e ON m.ID_Empleado = e.ID_Empleado
WHERE YEAR(m.Fecha) = 2024;

-- 14. Equipo liviano relacionado con producto
SELECT el.Nombre AS Equipo, p.Nombre AS ProductoAsociado
FROM Equipo_Liviano el
LEFT JOIN Producto p ON el.ID_Producto = p.ID_Producto;

-- 15. Tarjetas de circulación emitidas en 2025
SELECT tc.ID_Tarjeta, v.Placa, tv.Nombre AS TipoVehiculo, tc.Fecha_Emision, tc.QR
FROM Tarjeta_Circulacion tc
JOIN Vehiculo v ON tc.ID_Vehiculo = v.ID_Vehiculo
JOIN Tipo_Vehiculo tv ON v.ID_TipoVehiculo = tv.ID_TipoVehiculo
WHERE YEAR(tc.Fecha_Emision) = 2025;


BACKUP DATABASE GrupoTecun1
TO DISK = 'C:\BackupsGrupoTecun\GrupoTecun1_principal.bak'
WITH FORMAT, INIT,
     NAME = 'Backup Completo GrupoTecun1';
GO

RESTORE VERIFYONLY
FROM DISK = 'C:\BackupsGrupoTecun\GrupoTecun1_principal.bak';