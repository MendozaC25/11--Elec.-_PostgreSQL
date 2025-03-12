-- Mostramos las tablas cargadas desde Python
SELECT * FROM happiness_report;
SELECT * FROM migration_data;

-- Ejemplo de Insert para la tabla de felicidad
INSERT INTO happiness_report (country, year, happiness_score, gdp_per_capita, social_support, 
                              healthy_life_expectancy, freedom_to_make_choices, corruption_perception, generosity)
VALUES ('Testlandia', 2019, 5.5, 1.2, 0.9, 0.8, 0.6, 0.2, 0.3);

-- Mostramos el registro insertado
SELECT * FROM happiness_report
WHERE country = 'Testlandia' AND year = 2019;

-- Ejemplo de Update del registro
UPDATE happiness_report
SET happiness_score = 7.5
WHERE country = 'Testlandia' AND year = 2019;

-- Vemos que el registro se actualizó
SELECT * FROM happiness_report
WHERE country = 'Testlandia' AND year = 2019;

-- Ejemplo de Delete
DELETE FROM happiness_report
WHERE country = 'Testlandia' AND year = 2019;

-- Vemos que el registro se borró correctamente
SELECT * FROM happiness_report
WHERE country = 'Testlandia' AND year = 2019;

-- 2.4 Consultas y Análisis Básicos

-- Uso de Filtros y Condicionales
-- Aplicamos operadores matemáticos y de texto en consultas
SELECT country, year, happiness_score, gdp_per_capita
FROM happiness_report
WHERE happiness_score > 6 AND gdp_per_capita > 1.0;

-- Ejemplo de CASE WHEN para generar columnas condicionales
SELECT country, year, happiness_score,
       CASE 
           WHEN happiness_score >= 7 THEN 'Alto'
           WHEN happiness_score BETWEEN 5 AND 6.9 THEN 'Medio'
           ELSE 'Bajo'
       END AS categoria_felicidad
FROM happiness_report;

-- Integración de Joins y Subconsultas
-- INNER JOIN entre happiness_report y migration_data
SELECT hr.country, hr.year, hr.happiness_score, md.net_migration
FROM happiness_report hr
INNER JOIN migration_data md ON hr.country = md.country AND hr.year = md.year;

-- Subconsulta para obtener países con mayor felicidad en 2019
SELECT country, happiness_score
FROM happiness_report
WHERE happiness_score = (SELECT MAX(happiness_score) FROM happiness_report WHERE year = 2019);

-- Funciones de Agrupamiento y Agregación
-- Consulta con funciones de agrupamiento y GROUP BY
SELECT year, AVG(happiness_score) AS promedio_felicidad
FROM happiness_report
GROUP BY year
HAVING AVG(happiness_score) > 5;

-- Uso de funciones de agregación, mediante ventana con OVER
SELECT country, year, happiness_score,
       AVG(happiness_score) OVER (PARTITION BY year) AS promedio_anual
FROM happiness_report;
