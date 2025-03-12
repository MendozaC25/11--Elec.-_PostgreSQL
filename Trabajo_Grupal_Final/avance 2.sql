--1. Querys de verificación de carga de Datos

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

-- 2. Consultas y Análisis Básicos

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

-- ===============================
-- 3. Consultas Avanzadas
-- ===============================

-- JOIN Avanzado con más columnas relevantes
SELECT DISTINCT 
    hr.country AS Country, 
    hr.year AS Year, 
    ROUND(hr.happiness_score::NUMERIC, 2) AS Happiness_Score, 
    ROUND(hr.gdp_per_capita::NUMERIC, 2) AS GDP_Per_Capita, 
    ROUND(md.net_migration::NUMERIC, 2) AS Net_Migration
FROM happiness_report AS hr
INNER JOIN migration_data AS md 
    ON hr.country = md.country 
    AND hr.year = md.year
WHERE hr.happiness_score IS NOT NULL 
AND md.net_migration IS NOT NULL
ORDER BY hr.country ASC, hr.year ASC;


-- Agregación con GROUP BY y HAVING, redondeando el promedio de felicidad a 2 decimales
SELECT year, 
       COUNT(*) AS total_paises, 
       ROUND(AVG(happiness_score)::NUMERIC, 2) AS promedio_felicidad
FROM happiness_report
GROUP BY year
HAVING COUNT(*) > 10 AND AVG(happiness_score) > 5;


-- Agregación Condicional con CASE WHEN, redondeo y eliminación de duplicados
SELECT DISTINCT ON (hr.country, hr.year) 
       hr.country, 
       hr.year, 
       ROUND(hr.happiness_score::NUMERIC, 2) AS happiness_score, 
       md.net_migration,
       CASE 
           WHEN hr.happiness_score >= 7 THEN 'Muy Alta'
           WHEN hr.happiness_score BETWEEN 5 AND 6.9 THEN 'Media'
           ELSE 'Baja'
       END AS categoria_felicidad,
       CASE 
           WHEN md.net_migration > 50000 THEN 'Alto Flujo Migratorio'
           WHEN md.net_migration BETWEEN 0 AND 50000 THEN 'Moderado'
           ELSE 'Negativo'
       END AS categoria_migracion
FROM happiness_report hr
INNER JOIN migration_data md 
    ON hr.country = md.country 
    AND hr.year = md.year
ORDER BY hr.country ASC, hr.year ASC;



-- Uso de RANK() para ranking de felicidad por año
WITH ranking_felicidad AS (
    SELECT country,
           year,
           ROUND(happiness_score::NUMERIC, 3) AS happiness_score,
           DENSE_RANK() OVER (PARTITION BY year ORDER BY happiness_score DESC) AS rank
    FROM happiness_report
)
SELECT DISTINCT country, year, happiness_score, rank
FROM ranking_felicidad
WHERE rank <= 5
ORDER BY year, rank;

-- Uso de LAG() para analizar la evolución de la felicidad
SELECT DISTINCT 
       country, 
       year, 
       ROUND(happiness_score::NUMERIC, 3) AS happiness_score, 
       
       -- Puntaje de felicidad del año anterior
       ROUND(LAG(happiness_score) OVER (PARTITION BY country ORDER BY year)::NUMERIC, 3) AS happiness_prev_year,
       
       -- Variación absoluta con respecto al año anterior
       ROUND((happiness_score - LAG(happiness_score) OVER (PARTITION BY country ORDER BY year))::NUMERIC, 3) AS variation_absolute,
       
       -- Variación porcentual con respecto al año anterior
       ROUND(((happiness_score - LAG(happiness_score) OVER (PARTITION BY country ORDER BY year)) / 
              NULLIF(LAG(happiness_score) OVER (PARTITION BY country ORDER BY year), 0))::NUMERIC * 100, 3) AS variation_percentage
       
FROM happiness_report
ORDER BY country, year;




-- Ranking de países con mayor felicidad promedio (2015-2019)
SELECT country, 
       ROUND(AVG(happiness_score)::NUMERIC, 3) AS avg_happiness_score
FROM happiness_report
WHERE year BETWEEN 2015 AND 2019
GROUP BY country
ORDER BY avg_happiness_score DESC;

-- Ranking de países con mayor migración promedio positiva (2015-2019)
SELECT md.country, 
       ROUND(AVG(md.net_migration)::NUMERIC, 3) AS avg_net_migration
FROM migration_data md
WHERE md.year BETWEEN 2015 AND 2019
AND md.country IN (
    SELECT country FROM happiness_report
    INTERSECT
    SELECT country FROM migration_data
)
GROUP BY md.country
HAVING AVG(md.net_migration) > 0
ORDER BY avg_net_migration DESC;


-- Ranking de países con menor migración promedio (2015-2019)
SELECT md.country, 
       ROUND(AVG(ABS(md.net_migration))::NUMERIC, 3) AS avg_abs_net_migration
FROM migration_data md
WHERE md.year BETWEEN 2015 AND 2019
AND md.country IN (
    SELECT country FROM happiness_report
    INTERSECT
    SELECT country FROM migration_data
)
GROUP BY md.country
ORDER BY avg_abs_net_migration ASC;

-- Relación entre PIB per cápita y migración neta

SELECT hr.country, 
       ROUND(AVG(hr.gdp_per_capita)::NUMERIC, 3) AS avg_gdp_per_capita, 
       ROUND(AVG(md.net_migration)::NUMERIC, 3) AS avg_net_migration
FROM happiness_report hr
INNER JOIN migration_data md 
    ON hr.country = md.country 
    AND hr.year = md.year
WHERE hr.year BETWEEN 2015 AND 2019
AND md.year BETWEEN 2015 AND 2019
AND hr.country IN (
    SELECT country FROM happiness_report
    INTERSECT
    SELECT country FROM migration_data
)
GROUP BY hr.country
ORDER BY avg_gdp_per_capita DESC;

-- Relación entre PIB per cápita y migración neta

SELECT hr.country, 
       ROUND(AVG(hr.corruption_perception)::NUMERIC, 3) AS avg_corruption_perception, 
       ROUND(AVG(hr.happiness_score)::NUMERIC, 3) AS avg_happiness_score
FROM happiness_report hr
INNER JOIN migration_data md 
    ON hr.country = md.country 
    AND hr.year = md.year
WHERE hr.year BETWEEN 2015 AND 2019
AND md.year BETWEEN 2015 AND 2019
AND hr.country IN (
    SELECT country FROM happiness_report
    INTERSECT
    SELECT country FROM migration_data
)
GROUP BY hr.country
ORDER BY avg_corruption_perception ASC;
