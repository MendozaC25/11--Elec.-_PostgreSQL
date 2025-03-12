# queries/basic_analysis_queries.py

import pandas as pd
from sqlalchemy import text

##2. Consultas y Análisis Básicos

def filter_happiness_and_gdp(engine):
    """
    Uso de Filtros y Condicionales:
    Selecciona country, year, happiness_score y gdp_per_capita para registros donde
    happiness_score > 6 y gdp_per_capita > 1.0.
    """
    query = """
        SELECT country, year, happiness_score, gdp_per_capita
        FROM happiness_report
        WHERE happiness_score > 6 AND gdp_per_capita > 1.0;
    """
    return pd.read_sql(query, engine)

def happiness_category_case(engine):
    """
    Ejemplo de CASE WHEN para generar columnas condicionales:
    Clasifica la felicidad como 'Alto', 'Medio' o 'Bajo' según el happiness_score.
    """
    query = """
        SELECT country, year, happiness_score,
               CASE 
                   WHEN happiness_score >= 7 THEN 'Alto'
                   WHEN happiness_score BETWEEN 5 AND 6.9 THEN 'Medio'
                   ELSE 'Bajo'
               END AS categoria_felicidad
        FROM happiness_report;
    """
    return pd.read_sql(query, engine)

def join_happiness_migration(engine):
    """
    Integración de Joins:
    INNER JOIN entre happiness_report y migration_data para mostrar country, year,
    happiness_score y net_migration.
    """
    query = """
        SELECT hr.country, hr.year, hr.happiness_score, md.net_migration
        FROM happiness_report hr
        INNER JOIN migration_data md ON hr.country = md.country AND hr.year = md.year;
    """
    return pd.read_sql(query, engine)

def max_happiness_country_2019(engine):
    """
    Subconsulta:
    Obtiene el país con el mayor happiness_score en el año 2019.
    """
    query = """
        SELECT country, happiness_score
        FROM happiness_report
        WHERE happiness_score = (
            SELECT MAX(happiness_score) FROM happiness_report WHERE year = 2019
        );
    """
    return pd.read_sql(query, engine)

def average_happiness_by_year(engine):
    """
    Funciones de Agrupamiento:
    Calcula el promedio de happiness_score por año y filtra aquellos años con promedio > 5.
    """
    query = """
        SELECT year, AVG(happiness_score) AS promedio_felicidad
        FROM happiness_report
        GROUP BY year
        HAVING AVG(happiness_score) > 5;
    """
    return pd.read_sql(query, engine)

def happiness_window_average(engine):
    """
    Funciones de Agregación con Ventana:
    Calcula el promedio anual de happiness_score usando la función OVER PARTITION BY year.
    """
    query = """
        SELECT country, year, happiness_score,
               AVG(happiness_score) OVER (PARTITION BY year) AS promedio_anual
        FROM happiness_report;
    """
    return pd.read_sql(query, engine)
