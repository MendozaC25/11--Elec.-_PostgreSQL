-- ====================================
-- PostgreSQL - Script 1
-- Autor: Yoseph Ayala
-- Fecha: 22/01/2025
-- ====================================

-- ====================================
-- DROP: Eliminar objetos si existen
-- ====================================
-- Eliminar la base de datos (debe ejecutarse en una sesión diferente, fuera de esta base de datos)
-- DROP DATABASE IF EXISTS EscuelaDB;

-- Para recrear el esquema, primero elimina las tablas en orden de dependencias
DROP TABLE IF EXISTS Alumnos.Inscripciones;
DROP TABLE IF EXISTS Academico.Cursos;
DROP TABLE IF EXISTS Academico.Profesores;
DROP TABLE IF EXISTS Alumnos.Estudiantes;

-- Eliminar esquemas
DROP SCHEMA IF EXISTS Alumnos CASCADE;
DROP SCHEMA IF EXISTS Academico CASCADE;

-- ====================================
-- Crear base de datos y esquemas
-- ====================================
-- Crear base de datos EscuelaDB
CREATE DATABASE EscuelaDB;

-- Crear esquemas
CREATE SCHEMA Alumnos;
CREATE SCHEMA Academico;

-- ====================================
-- Crear tablas dentro de los esquemas
-- ====================================
-- Tabla Estudiantes
CREATE TABLE Alumnos.Estudiantes (
    ID SERIAL PRIMARY KEY,
    Nombre VARCHAR(50),
    Apellido VARCHAR(50),
    Edad INT,
    Email VARCHAR(100) UNIQUE
);

-- Tabla Profesores
CREATE TABLE Academico.Profesores (
    ID SERIAL PRIMARY KEY,
    Nombre VARCHAR(50),
    Apellido VARCHAR(50),
    Especialidad VARCHAR(100),
    Email VARCHAR(100) UNIQUE
);

-- Tabla Cursos
CREATE TABLE Academico.Cursos (
    ID SERIAL PRIMARY KEY,
    Nombre VARCHAR(100),
    Descripcion TEXT,
    FechaInicio DATE,
    FechaFin DATE,
    ProfesorID INT REFERENCES Academico.Profesores(ID)
);

-- Tabla Inscripciones
CREATE TABLE Alumnos.Inscripciones (
    ID SERIAL PRIMARY KEY,
    EstudianteID INT REFERENCES Alumnos.Estudiantes(ID),
    CursoID INT REFERENCES Academico.Cursos(ID),
    FechaInscripcion DATE,
    Estado VARCHAR(50)
);

-- ====================================
-- Insertar datos en las tablas
-- ====================================
-- Estudiantes
INSERT INTO Alumnos.Estudiantes (Nombre, Apellido, Edad, Email)
VALUES
('Ana', 'Perez', 22, 'ana.perez@example.com'),
('Juan', 'Gonzalez', 24, 'juan.gonzalez@example.com');

-- Profesores
INSERT INTO Academico.Profesores (Nombre, Apellido, Especialidad, Email)
VALUES
('Carlos', 'Lopez', 'Matemáticas', 'carlos.lopez@example.com'),
('María', 'Martinez', 'Historia', 'maria.martinez@example.com');

-- Cursos
INSERT INTO Academico.Cursos (Nombre, Descripcion, FechaInicio, FechaFin, ProfesorID)
VALUES
('Matemáticas Básicas', 'Curso de introducción a las matemáticas', '2025-01-20', '2025-05-20', 1),
('Historia Universal', 'Curso sobre la historia universal', '2025-01-20', '2025-05-20', 2);

-- Inscripciones
INSERT INTO Alumnos.Inscripciones (EstudianteID, CursoID, FechaInscripcion, Estado)
VALUES
(1, 1, '2025-01-18', 'Inscrito'),
(2, 2, '2025-01-19', 'Inscrito');

-- ====================================
-- Consultas básicas
-- ====================================
SELECT * FROM Alumnos.Estudiantes;
SELECT * FROM Academico.Profesores;
SELECT * FROM Academico.Cursos;
SELECT * FROM Alumnos.Inscripciones;

-- ====================================
-- ALTER: Modificar tablas existentes
-- ====================================
-- Agregar una columna de teléfono a la tabla Estudiantes
ALTER TABLE Alumnos.Estudiantes
ADD COLUMN Telefono VARCHAR(15);

-- Modificar la longitud de la columna Nombre en la tabla Profesores
ALTER TABLE Academico.Profesores
ALTER COLUMN Nombre TYPE VARCHAR(100);

-- Cambiar el tipo de la columna Estado en la tabla Inscripciones
ALTER TABLE Alumnos.Inscripciones
ALTER COLUMN Estado TYPE TEXT;

-- Renombrar una columna en la tabla Cursos
ALTER TABLE Academico.Cursos
RENAME COLUMN Descripcion TO Detalles;

-- ====================================
-- Consultas después de las modificaciones
-- ====================================
SELECT * FROM Alumnos.Estudiantes;
SELECT * FROM Academico.Profesores;
SELECT * FROM Academico.Cursos;
SELECT * FROM Alumnos.Inscripciones;

-- ====================================
-- DROP ejemplos para pruebas
-- ====================================
-- Eliminar la tabla Inscripciones
DROP TABLE IF EXISTS Alumnos.Inscripciones;

-- Eliminar la tabla Cursos
DROP TABLE IF EXISTS Academico.Cursos;

-- Eliminar la tabla Profesores
DROP TABLE IF EXISTS Academico.Profesores;

-- Eliminar la tabla Estudiantes
DROP TABLE IF EXISTS Alumnos.Estudiantes;

-- Eliminar esquemas
DROP SCHEMA IF EXISTS Alumnos CASCADE;
DROP SCHEMA IF EXISTS Academico CASCADE;
