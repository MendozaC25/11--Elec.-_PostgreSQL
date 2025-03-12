-- ====================================
-- Historia: El Caso TechCorp
-- En TechCorp, se desea conocer la evolución de los salarios de los empleados.
-- Creamos dos tablas: "employees" para la información de los empleados
-- y "salaries" para el historial salarial. Con este script, se muestran ejemplos
-- de subconsultas no correlacionadas y correlacionadas explicadas paso a paso.
-- ====================================

-- Paso 1: Crear la base de datos (si aún no existe)
DROP DATABASE IF EXISTS bd_work;
CREATE DATABASE bd_work;

-- Conéctate a bd_work en tu cliente de PostgreSQL (ej.: \c bd_work en psql)

-- Paso 2: Eliminar tablas si existen (para reiniciar el entorno de prueba)
DROP TABLE IF EXISTS salaries;
DROP TABLE IF EXISTS employees;

-- Paso 3: Crear la tabla "employees"
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    age INT
);

-- Paso 4: Crear la tabla "salaries"
CREATE TABLE salaries (
    salary_id SERIAL PRIMARY KEY,
    employee_id INT,
    salary NUMERIC(10,2),
    effective_date DATE,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- Paso 5: Insertar datos en "employees"
INSERT INTO employees (name, department, age)
VALUES
    ('John Doe', 'Sales', 30),
    ('Jane Smith', 'Marketing', 28),
    ('Alice Johnson', 'IT', 35),
    ('Bob Brown', 'Sales', 40),
    ('Charlie Green', 'HR', 25),
    ('Diana Prince', 'IT', 32),
    ('Evan White', 'Marketing', 29),
    ('Fiona Black', 'Sales', 38),
    ('George Harris', 'HR', 45),
    ('Hannah Lee', 'IT', 27),
    ('Ian Scott', 'Marketing', 31),
    ('Julia Adams', 'Sales', 26),
    ('Kevin Turner', 'HR', 50),
    ('Laura Wilson', 'IT', 34),
    ('Michael Clark', 'Marketing', 33),
    ('Nina Brown', 'Sales', 29),
    ('Oscar King', 'HR', 41),
    ('Paula Young', 'IT', 36),
    ('Quentin Hall', 'Marketing', 27),
    ('Rachel Green', 'Sales', 28);

-- Paso 6: Insertar datos en "salaries"
-- Se insertan múltiples registros por empleado para simular actualizaciones salariales.
INSERT INTO salaries (employee_id, salary, effective_date)
VALUES
    (1, 3000, '2023-01-01'),
    (1, 3200, '2023-06-01'),
    (1, 3400, '2024-01-01'),
    (2, 3100, '2023-01-01'),
    (2, 3300, '2023-06-01'),
    (2, 3500, '2024-01-01'),
    (3, 4000, '2023-01-01'),
    (3, 4200, '2023-06-01'),
    (3, 4400, '2024-01-01'),
    (4, 2800, '2023-01-01'),
    (4, 3000, '2023-06-01'),
    (4, 3200, '2024-01-01'),
    (5, 2600, '2023-01-01'),
    (5, 2800, '2023-06-01'),
    (5, 3000, '2024-01-01'),
    (6, 3900, '2023-01-01'),
    (6, 4100, '2023-06-01'),
    (6, 4300, '2024-01-01'),
    (7, 3200, '2023-01-01'),
    (7, 3400, '2023-06-01'),
    (7, 3600, '2024-01-01'),
    (8, 3100, '2023-01-01'),
    (8, 3300, '2023-06-01'),
    (8, 3500, '2024-01-01'),
    (9, 2700, '2023-01-01'),
    (9, 2900, '2023-06-01'),
    (9, 3100, '2024-01-01'),
    (10, 3800, '2023-01-01'),
    (10, 4000, '2023-06-01'),
    (10, 4200, '2024-01-01'),
    (11, 3300, '2023-01-01'),
    (11, 3500, '2023-06-01'),
    (11, 3700, '2024-01-01'),
    (12, 2900, '2023-01-01'),
    (12, 3100, '2023-06-01'),
    (12, 3300, '2024-01-01'),
    (13, 2500, '2023-01-01'),
    (13, 2700, '2023-06-01'),
    (13, 2900, '2024-01-01'),
    (14, 4100, '2023-01-01'),
    (14, 4300, '2023-06-01'),
    (14, 4500, '2024-01-01'),
    (15, 3400, '2023-01-01'),
    (15, 3600, '2023-06-01'),
    (15, 3800, '2024-01-01'),
    (16, 3000, '2023-01-01'),
    (16, 3200, '2023-06-01'),
    (16, 3400, '2024-01-01'),
    (17, 2800, '2023-01-01'),
    (17, 3000, '2023-06-01'),
    (17, 3200, '2024-01-01'),
    (18, 4000, '2023-01-01'),
    (18, 4200, '2023-06-01'),
    (18, 4400, '2024-01-01'),
    (19, 3500, '2023-01-01'),
    (19, 3700, '2023-06-01'),
    (19, 3900, '2024-01-01'),
    (20, 3100, '2023-01-01'),
    (20, 3300, '2023-06-01'),
    (20, 3500, '2024-01-01');
-----------------------------
-- Ejemplos de Subconsultas NO Correlacionadas
-----------------------------
-- 1. Mostrar a cada empleado junto con el salario promedio de la empresa.
SELECT 
    e.name, 
    e.department, 
    s.salary AS employee_salary,
    (SELECT AVG(salary) FROM salaries) AS avg_salary
FROM employees e
JOIN salaries s ON e.employee_id = s.employee_id;

-- 2. Mostrar empleados con un salario mayor al salario promedio de la empresa.
SELECT 
    e.name, 
    e.department, 
    s.salary
FROM employees e
JOIN salaries s ON e.employee_id = s.employee_id
WHERE s.salary > (SELECT AVG(salary) FROM salaries);

-- 3. Mostrar a cada empleado junto con el salario máximo registrado en la empresa.
SELECT 
    e.name, 
    e.department, 
    s.salary AS employee_salary,
    (SELECT MAX(salary) FROM salaries) AS max_salary
FROM employees e
JOIN salaries s ON e.employee_id = s.employee_id;


-----------------------------
-- Ejemplos de Subconsultas CORRELACIONADAS 
-----------------------------
/*
Las subconsultas correlacionadas se ejecutan para cada fila de la consulta externa.
Aquí queremos, por ejemplo, identificar a aquellos empleados cuyo salario actual
(la última actualización registrada) es mayor que el promedio de salarios en su departamento.

Paso A: Para cada empleado, determinamos su salario actual:
  - Se utiliza una subconsulta para obtener la fecha más reciente (MAX(effective_date))
    para ese empleado en la tabla "salaries".

Paso B: Calculamos el promedio de salarios en el departamento del empleado:
  - Se utiliza otra subconsulta (más simple) que, sin depender de la fila actual, obtiene
    el promedio de todos los salarios de empleados que pertenecen al mismo departamento.
*/

-- Ejemplo Correlacionado 1: Empleados con salario actual mayor que el promedio de su departamento.
SELECT e.name, e.department, s.salary AS current_salary
FROM employees e
JOIN salaries s ON e.employee_id = s.employee_id
WHERE s.effective_date = (
    -- Paso A: Encontrar la fecha más reciente para el empleado actual
    SELECT MAX(eff.effective_date)
    FROM salaries eff
    WHERE eff.employee_id = e.employee_id
)
AND s.salary > (
    -- Paso B: Calcular el promedio de salarios para el departamento del empleado
    SELECT AVG(sal.salary)
    FROM salaries sal
    JOIN employees emp ON sal.employee_id = emp.employee_id
    WHERE emp.department = e.department
);

-----------------------------
-- Ejemplo Correlacionado 2: Listar el salario actual y el salario máximo en el departamento.
-----------------------------
/*
En este ejemplo, para cada empleado se muestra:
  - Su salario actual (el registro con la fecha más reciente)
  - El salario máximo de su departamento, obtenido mediante una subconsulta no anidada excesivamente.
*/
SELECT 
    e.name, 
    e.department, 
    s.salary AS current_salary,
    (
        SELECT MAX(sal.salary)
        FROM salaries sal
        JOIN employees emp ON sal.employee_id = emp.employee_id
        WHERE emp.department = e.department
    ) AS max_department_salary
FROM employees e
JOIN salaries s ON e.employee_id = s.employee_id
WHERE s.effective_date = (
    SELECT MAX(eff.effective_date)
    FROM salaries eff
    WHERE eff.employee_id = e.employee_id
);
