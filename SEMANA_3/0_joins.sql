-- ====================================
-- Script de Ejemplo: Joins y UNION/UNION ALL
-- ====================================

CREATE DATABASE bd_college;

-- ====================================
-- Creación de Tablas y Población de Datos
-- ====================================

-- Eliminar tablas si existen (para un entorno de prueba)
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS professors;

-- Crear tabla "students"
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT,
    email VARCHAR(100) UNIQUE
);

-- Insertar datos en "students" (30 registros)
INSERT INTO students (first_name, last_name, age, email)
VALUES 
('Alice', 'Smith', 20, 'alice.smith@example.com'),
('Bob', 'Jones', 22, 'bob.jones@example.com'),
('Carol', 'Taylor', 21, 'carol.taylor@example.com'),
('David', 'Brown', 23, 'david.brown@example.com'),
('Eva', 'Wilson', 20, 'eva.wilson@example.com'),
('Frank', 'Johnson', 24, 'frank.johnson@example.com'),
('Grace', 'Davis', 22, 'grace.davis@example.com'),
('Henry', 'Martin', 23, 'henry.martin@example.com'),
('Ivy', 'Lee', 21, 'ivy.lee@example.com'),
('Jack', 'Thompson', 24, 'jack.thompson@example.com'),
('Karen', 'White', 22, 'karen.white@example.com'),
('Leo', 'Harris', 23, 'leo.harris@example.com'),
('Maya', 'Clark', 21, 'maya.clark@example.com'),
('Noah', 'Lewis', 22, 'noah.lewis@example.com'),
('Olivia', 'Walker', 23, 'olivia.walker@example.com'),
('Paul', 'Hall', 20, 'paul.hall@example.com'),
('Queenie', 'Allen', 24, 'queenie.allen@example.com'),
('Robert', 'Young', 22, 'robert.young@example.com'),
('Sarah', 'King', 23, 'sarah.king@example.com'),
('Tom', 'Wright', 21, 'tom.wright@example.com'),
('Uma', 'Scott', 22, 'uma.scott@example.com'),
('Victor', 'Green', 23, 'victor.green@example.com'),
('Wendy', 'Adams', 20, 'wendy.adams@example.com'),
('Xavier', 'Baker', 24, 'xavier.baker@example.com'),
('Yvonne', 'Nelson', 22, 'yvonne.nelson@example.com'),
('Zachary', 'Carter', 23, 'zachary.carter@example.com'),
('Aaron', 'Mitchell', 21, 'aaron.mitchell@example.com'),
('Bella', 'Roberts', 22, 'bella.roberts@example.com'),
('Chris', 'Evans', 23, 'chris.evans@example.com'),
('Diana', 'Perez', 20, 'diana.perez@example.com');

-- Crear tabla "courses"
CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100),
    description TEXT,
    start_date DATE,
    end_date DATE
);

-- Insertar datos en "courses" (30 registros)
INSERT INTO courses (course_name, description, start_date, end_date)
VALUES
('Course 1', 'Description for Course 1', '2023-09-01', '2023-12-15'),
('Course 2', 'Description for Course 2', '2023-09-01', '2023-12-15'),
('Course 3', 'Description for Course 3', '2023-09-01', '2023-12-15'),
('Course 4', 'Description for Course 4', '2023-09-01', '2023-12-15'),
('Course 5', 'Description for Course 5', '2023-09-01', '2023-12-15'),
('Course 6', 'Description for Course 6', '2023-09-01', '2023-12-15'),
('Course 7', 'Description for Course 7', '2023-09-01', '2023-12-15'),
('Course 8', 'Description for Course 8', '2023-09-01', '2023-12-15'),
('Course 9', 'Description for Course 9', '2023-09-01', '2023-12-15'),
('Course 10', 'Description for Course 10', '2023-09-01', '2023-12-15'),
('Course 11', 'Description for Course 11', '2023-09-01', '2023-12-15'),
('Course 12', 'Description for Course 12', '2023-09-01', '2023-12-15'),
('Course 13', 'Description for Course 13', '2023-09-01', '2023-12-15'),
('Course 14', 'Description for Course 14', '2023-09-01', '2023-12-15'),
('Course 15', 'Description for Course 15', '2023-09-01', '2023-12-15'),
('Course 16', 'Description for Course 16', '2023-09-01', '2023-12-15'),
('Course 17', 'Description for Course 17', '2023-09-01', '2023-12-15'),
('Course 18', 'Description for Course 18', '2023-09-01', '2023-12-15'),
('Course 19', 'Description for Course 19', '2023-09-01', '2023-12-15'),
('Course 20', 'Description for Course 20', '2023-09-01', '2023-12-15'),
('Course 21', 'Description for Course 21', '2023-09-01', '2023-12-15'),
('Course 22', 'Description for Course 22', '2023-09-01', '2023-12-15'),
('Course 23', 'Description for Course 23', '2023-09-01', '2023-12-15'),
('Course 24', 'Description for Course 24', '2023-09-01', '2023-12-15'),
('Course 25', 'Description for Course 25', '2023-09-01', '2023-12-15'),
('Course 26', 'Description for Course 26', '2023-09-01', '2023-12-15'),
('Course 27', 'Description for Course 27', '2023-09-01', '2023-12-15'),
('Course 28', 'Description for Course 28', '2023-09-01', '2023-12-15'),
('Course 29', 'Description for Course 29', '2023-09-01', '2023-12-15'),
('Course 30', 'Description for Course 30', '2023-09-01', '2023-12-15');

-- Crear tabla "professors"
CREATE TABLE professors (
    professor_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    email VARCHAR(100) UNIQUE
);

-- Insertar datos en "professors" (10 registros)
INSERT INTO professors (first_name, last_name, department, email)
VALUES
('Emily', 'Clark', 'Mathematics', 'emily.clark@example.com'),
('Michael', 'Davis', 'History', 'michael.davis@example.com'),
('Sarah', 'Miller', 'Computer Science', 'sarah.miller@example.com'),
('David', 'Wilson', 'Physics', 'david.wilson@example.com'),
('Laura', 'Moore', 'Chemistry', 'laura.moore@example.com'),
('James', 'Taylor', 'Biology', 'james.taylor@example.com'),
('Olivia', 'Anderson', 'Literature', 'olivia.anderson@example.com'),
('Daniel', 'Thomas', 'Economics', 'daniel.thomas@example.com'),
('Sophia', 'Jackson', 'Philosophy', 'sophia.jackson@example.com'),
('Matthew', 'White', 'Art', 'matthew.white@example.com');

-- Crear tabla "enrollments"
CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- Insertar datos en "enrollments"
-- Solo 15 de 30 estudiantes se inscriben en cursos, para tener variabilidad.
INSERT INTO enrollments (student_id, course_id, enrollment_date)
VALUES
    (1, 5, '2023-08-15'),
    (3, 10, '2023-08-16'),
    (4, 7, '2023-08-17'),
    (7, 15, '2023-08-18'),
    (8, 3, '2023-08-19'),
    (10, 1, '2023-08-20'),
    (12, 20, '2023-08-21'),
    (13, 12, '2023-08-22'),
    (15, 30, '2023-08-23'),
    (16, 25, '2023-08-24'),
    (18, 8, '2023-08-25'),
    (20, 18, '2023-08-26'),
    (25, 2, '2023-08-27'),
    (27, 9, '2023-08-28'),
    (29, 14, '2023-08-29');

-----------------------------
-- Ejemplos de JOINs: Descubriendo Conexiones en la Academia
-----------------------------

-- INNER JOIN: "Solo los Comprometidos"
-- Muestra a los estudiantes que tienen inscripción y el curso en el que están inscritos.
SELECT s.first_name, s.last_name, c.course_name, e.enrollment_date
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id
INNER JOIN courses c ON e.course_id = c.course_id;

-- LEFT JOIN: "Todos los Estudiantes, Incluso los Soñadores"
-- Muestra todos los estudiantes y, si tienen inscripción, el curso asociado; si no, se muestran valores NULL para el curso.
SELECT s.first_name, s.last_name, c.course_name, e.enrollment_date
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN courses c ON e.course_id = c.course_id;

-- RIGHT JOIN: "Todos los Cursos, Incluso los Vacíos"
-- Muestra todos los cursos y, si existen inscripciones, los estudiantes inscritos; algunos cursos pueden no tener estudiantes.
SELECT c.course_name, s.first_name, s.last_name, e.enrollment_date
FROM courses c
RIGHT JOIN enrollments e ON c.course_id = e.course_id
RIGHT JOIN students s ON e.student_id = s.student_id;

-- FULL JOIN: "El Mapa Completo"
-- Combina todos los registros de estudiantes y cursos, mostrando conexiones y ausencias.
SELECT s.first_name, s.last_name, c.course_name, e.enrollment_date
FROM students s
FULL JOIN enrollments e ON s.student_id = e.student_id
FULL JOIN courses c ON e.course_id = c.course_id;

-----------------------------
-- Ejemplos de UNION y UNION ALL: Uniendo Voces de la Academia
-----------------------------

-- En este caso, combinamos los nombres de los estudiantes y de los profesores,
-- obteniendo una lista de "personas" que forman parte de la Academia.

-- UNION: "La Voz Unida"
-- Combina el primer nombre de estudiantes y el primer nombre de profesores, eliminando duplicados.
SELECT first_name AS name FROM students
UNION
SELECT first_name AS name FROM professors;

-- UNION ALL: "Todas las Voces, Sin Filtros"
-- Combina las dos listas permitiendo duplicados, mostrando cada mención.
SELECT first_name AS name FROM students
UNION ALL
SELECT first_name AS name FROM professors;



