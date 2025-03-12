# queries/advanced_queries.py

import pandas as pd
from sqlalchemy import text

##3. Consultas Avanzadas

def advanced_join_happiness_migration(engine):
    """
    JOIN Avanzado con más columnas relevantes.
    Muestra country, year, happiness_score, gdp_per_capita y net_migration redondeados,
    solo registros donde ambos valores no sean nulos.
    """
    query = """
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
    """
    return pd.read_sql(query, engine)

def group_by_year_with_having(engine):
    """
    Agregación con GROUP BY y HAVING.
    Para cada año se cuenta el total de países y se calcula el promedio de la felicidad,
    filtrando años con total de países > 10 y promedio > 5.
    """
    query = """
        SELECT year, 
               COUNT(*) AS total_paises, 
               ROUND(AVG(happiness_score)::NUMERIC, 2) AS promedio_felicidad
        FROM happiness_report
        GROUP BY year
        HAVING COUNT(*) > 10 AND AVG(happiness_score) > 5;
    """
    return pd.read_sql(query, engine)

def conditional_aggregation(engine):
    """
    Agregación Condicional con CASE WHEN.
    Para cada país y año se muestra el happiness_score redondeado,
    la migración neta, una clasificación de la felicidad y migración.
    """
    query = """
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
    """
    return pd.read_sql(query, engine)

def top5_happiness_rank(engine):
    """
    Uso de RANK() para ranking de felicidad por año.
    Calcula el ranking (con DENSE_RANK) de happiness_score para cada año y
    devuelve los 5 primeros registros por año.
    """
    query = """
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
    """
    return pd.read_sql(query, engine)

def happiness_evolution(engine):
    """
    Uso de LAG() para analizar la evolución de la felicidad.
    Devuelve para cada registro el happiness_score, el puntaje del año anterior,
    la variación absoluta y el cambio porcentual respecto al año anterior.
    """
    query = """
        SELECT DISTINCT 
               country, 
               year, 
               ROUND(happiness_score::NUMERIC, 3) AS happiness_score, 
               
               ROUND(LAG(happiness_score) OVER (PARTITION BY country ORDER BY year)::NUMERIC, 3) AS happiness_prev_year,
               
               ROUND((happiness_score - LAG(happiness_score) OVER (PARTITION BY country ORDER BY year))::NUMERIC, 3) AS variation_absolute,
               
               ROUND(((happiness_score - LAG(happiness_score) OVER (PARTITION BY country ORDER BY year)) / 
                      NULLIF(LAG(happiness_score) OVER (PARTITION BY country ORDER BY year), 0))::NUMERIC * 100, 3) AS variation_percentage
               
        FROM happiness_report
        ORDER BY country, year;
    """
    return pd.read_sql(query, engine)

def ranking_avg_happiness(engine):
    """
    Ranking de países con mayor felicidad promedio (2015-2019).
    Calcula el promedio de felicidad para cada país en el período y los ordena de mayor a menor.
    """
    query = """
        SELECT country, 
               ROUND(AVG(happiness_score)::NUMERIC, 3) AS avg_happiness_score
        FROM happiness_report
        WHERE year BETWEEN 2015 AND 2019
        GROUP BY country
        ORDER BY avg_happiness_score DESC;
    """
    return pd.read_sql(query, engine)

def ranking_positive_migration(engine):
    """
    Ranking de países con mayor migración promedio positiva (2015-2019).
    Calcula el promedio de migración neta, solo considerando países que aparecen en ambos datasets,
    y filtra aquellos con promedio de migración mayor a 0.
    """
    query = """
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
    """
    return pd.read_sql(query, engine)

def ranking_lowest_migration(engine):
    """
    Ranking de países con menor migración promedio (2015-2019).
    Calcula el promedio de la migración neta en valor absoluto para cada país que se encuentre en ambos datasets.
    """
    query = """
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
    """
    return pd.read_sql(query, engine)

def relation_gdp_migration(engine):
    """
    Relación entre PIB per cápita y migración neta (2015-2019).
    Calcula el promedio del PIB per cápita y de la migración neta por país, para aquellos presentes en ambos datasets.
    """
    query = """
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
    """
    return pd.read_sql(query, engine)

def relation_corruption_happiness(engine):
    """
    Relación entre percepción de corrupción y felicidad (2015-2019).
    Calcula el promedio de percepción de corrupción y de felicidad por país, para los países presentes en ambos datasets.
    """
    query = """
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
    """
    return pd.read_sql(query, engine)
