
-- ====================================
-- Programación en PostgreSQL para CCSS
-- Autor: Yoseph Ayala
-- Fecha: 29/01/2025
-- ====================================

-- ====================================
-- Contexto del ejercicio
-- ====================================

/*
Bienvenido a TechMart: Explorando nuestra base de datos con PostgreSQL 📊

Escenario:

TechMart, una tienda líder en productos tecnológicos, ha pedido tu ayuda como analista de datos.
Tu misión es analizar el inventario, calcular precios con impuestos,
clasificar los productos según su disponibilidad 
y realizar validaciones para asegurarte de que toda la información cumpla con los estándares.
*/

-- ====================================
-- 🏗️ Creación de Base de Datos y Tablas
-- ====================================

/*
El primer paso es crear la base de datos y las tablas donde se almacenarán los productos.
¡Vamos a construir el corazón de TechMart!
*/

-- Crear la base de datos de TechMart
DROP DATABASE IF EXISTS TechMartDB;

CREATE DATABASE TechMartDB;

-- Conectarse a la base de datos

-- Crear la tabla de productos
DROP TABLE IF EXISTS Productos;

CREATE TABLE Productos (
    ProductID SERIAL PRIMARY KEY,
    ProductName VARCHAR(50),
    UnitPrice NUMERIC(10,2),
    UnitsInStock INT,
    UnitsOnOrder INT,
	DateAdded DATE -- Fecha de alta del producto
);

-- Insertar los datos iniciales
INSERT INTO Productos (ProductName, UnitPrice, UnitsInStock, UnitsOnOrder, DateAdded)
VALUES 
    ('Laptop Pro', 1200.50, 15, 5, '2024-01-10'),
    ('Teclado Mecánico', 85.75, 50, 10, '2023-12-15'),
    ('Monitor Ultra HD', 320.00, 8, 20, '2024-01-20'),
    ('Mouse Gamer', 45.90, 100, 30, '2023-11-05'),
    ('Audífonos Inalámbricos', 65.30, 60, 15, '2025-01-25');


SELECT *
FROM Productos;


-- ====================================
-- 📊 Análisis del inventario: ¿Cómo está nuestro stock?
-- ====================================

/*
El gerente quiere saber:

¿Qué tan equilibrado está nuestro inventario?
¿Qué productos necesitan atención inmediata?

Vamos a calcular la diferencia entre las unidades en stock y las unidades en pedido,
redondear precios con impuestos y generar métricas clave.
*/

-- Exploración inicial de productos

SELECT COUNT(*)
FROM Productos;

SELECT COUNT(DISTINCT ProductName)
FROM Productos;

SELECT DISTINCT ProductName
FROM Productos;

SELECT *
FROM Productos
WHERE UnitPrice > 20;

SELECT *
FROM Productos
WHERE ProductName IN ('Laptop Pro', 'Mouse Gamer');

SELECT ProductName, UnitsInStock
FROM Productos
WHERE UnitsInStock BETWEEN 60 AND 100;


-- Análisis de inventario y precios con impuestos
SELECT 
    ProductName, 
    UnitPrice, 
    UnitsInStock, 
    UnitsOnOrder,
    ABS(UnitsInStock - UnitsOnOrder) AS StockDifference, -- Diferencia absoluta entre stock y pedidos
    ROUND(UnitPrice * 1.18, 2) AS PriceWithTax, -- Precio con 18% de impuestos
    CEIL(UnitPrice * 1.18) AS PriceWithTaxCeil, -- Precio redondeado hacia arriba
    FLOOR(UnitPrice * 1.18) AS PriceWithTaxFloor -- Precio redondeado hacia abajo
FROM Productos;

-- usar algún where;

-- ====================================
-- 🔡 Manipulación de texto: Nombrando los productos de manera uniforme
-- ====================================

/*
El equipo de marketing quiere estandarizar los nombres de los productos. Nos piden:

Convertir los nombres a mayúsculas para los catálogos.
Validar que los nombres sean descriptivos y cumplan con las reglas de longitud.
*/

-- Manipulación de texto en nombres de productos
SELECT 
    ProductName,
    UPPER(ProductName) AS UppercaseName, -- Nombre en mayúsculas
    LOWER(ProductName) AS LowercaseName, -- Nombre en minúsculas
    CHAR_LENGTH(ProductName) AS NameLength, -- Longitud del nombre del producto
    LEFT(ProductName, 8) AS ShortName -- Primeros 8 caracteres del nombre
FROM Productos;


-- ====================================
-- 🛑 Clasificación de productos: ¿Qué debemos priorizar?
-- ====================================

/*
El gerente necesita saber qué productos están en stock, cuáles tienen stock limitado, y cuáles están agotados.
Además, quiere categorizarlos como "caros" o "económicos" según su precio.
*/

-- Clasificación de productos según disponibilidad y precio
SELECT 
    ProductName, 
    UnitsInStock,
    UnitPrice,
    CASE 
        WHEN UnitsInStock > 20 THEN 'En stock' 
        WHEN UnitsInStock BETWEEN 10 AND 20 THEN 'Stock limitado' 
        ELSE 'Agotado' 
    END AS StockStatus,
    CASE 
        WHEN UnitPrice > 100 THEN 'Producto caro' 
        ELSE 'Producto económico' 
    END AS PriceCategory
FROM Productos;


-- ====================================
-- Consultas relacionadas con tiempo y fecha
-- ====================================

-- Obtener productos agregados recientemente (últimos 30 días)
SELECT 
    ProductName, 
    DateAdded,
    CURRENT_DATE - DateAdded AS DaysSinceAdded
FROM Productos
WHERE DateAdded >= CURRENT_DATE - INTERVAL '30 days';


-- ====================================
-- 🔍 Validación con expresiones regulares: ¿Cumplen los nombres el formato?
-- ====================================

/*
El equipo de calidad quiere asegurarse de que los nombres de productos cumplan con el formato: 
deben comenzar con una palabra seguida de un espacio y una descripción adicional.
*/
-- Validación de nombres usando expresiones regulares
SELECT 
    ProductName,
    CASE 
        WHEN ProductName ~* '^[A-Za-z]+ [A-Za-z]+' THEN 'Cumple formato'
        ELSE 'No cumple formato'
    END AS FormatCheck
FROM Productos;


-- Buscar productos que contienen números en su nombre
SELECT 
    ProductName
FROM Productos
WHERE ProductName ~ '[0-9]';

-- ====================================
-- Operadores de texto: LIKE, ILIKE, SIMILAR TO
-- ====================================

-- Buscar productos que comienzan con "Laptop"
SELECT 
    ProductName
FROM Productos
WHERE ProductName LIKE 'Laptop%';

-- Buscar productos cuyo nombre contiene "Gamer" (no distingue entre mayúsculas y minúsculas)
SELECT 
    ProductName
FROM Productos
WHERE ProductName ILIKE '%Gamer%';

-- Buscar productos cuyo nombre tiene un formato específico (comienza con letras, luego un espacio y más letras)
SELECT 
    ProductName
FROM Productos
WHERE ProductName SIMILAR TO '[A-Za-z]+ [A-Za-z]+';

-- ====================================
-- Operadores lógicos: IN, NOT IN, BETWEEN, IS NULL
-- ====================================

-- Buscar productos que tienen un precio específico (IN)
SELECT 
    ProductName, 
    UnitPrice
FROM Productos
WHERE UnitPrice IN (85.75, 320.00);

-- Buscar productos cuyo stock es nulo (NULL)
SELECT 
    ProductName, 
    UnitsInStock
FROM Productos
WHERE UnitsInStock IS NULL;

-- Buscar productos que fueron agregados entre dos fechas específicas
SELECT 
    ProductName, 
    DateAdded
FROM Productos
WHERE DateAdded BETWEEN '2023-12-01' AND '2024-01-01';

-- Buscar productos que tienen menos de 20 unidades en stock (NOT IN)
SELECT 
    ProductName, 
    UnitsInStock
FROM Productos
WHERE UnitsInStock NOT IN (8, 15, 50);

-- ====================================
-- 📝 Guardar resultados en tablas temporales
-- ====================================

-- Guardar los resultados de un query en una tabla
CREATE TABLE StockSummary AS
SELECT 
    ProductName, 
    UnitsInStock, 
    UnitsOnOrder, 
    ABS(UnitsInStock - UnitsOnOrder) AS StockDifference
FROM Productos;

-- Consultar la tabla temporal
SELECT * FROM StockSummary;

-- Limpiar la tabla temporal
DROP TABLE IF EXISTS StockSummary;

-- ====================================
-- Limpieza de la base de datos (Opcional)
-- ====================================

-- Eliminar la tabla Productos
-- DROP TABLE IF EXISTS Productos;

-- Eliminar la base de datos DemoDB
-- DROP DATABASE IF EXISTS DemoDB;

