# queries/loading_queries.py

import pandas as pd
from sqlalchemy import text


##1. Querys de verificación de carga de Datos


def show_happiness_report(engine):
    """
    Muestra todos los registros de la tabla happiness_report.
    """
    query = "SELECT * FROM happiness_report;"
    return pd.read_sql(query, engine)

def show_migration_data(engine):
    """
    Muestra todos los registros de la tabla migration_data.
    """
    query = "SELECT * FROM migration_data;"
    return pd.read_sql(query, engine)

def insert_happiness_report_record(engine):
    """
    Inserta un registro de prueba en la tabla happiness_report.
    """
    query = text("""
        INSERT INTO happiness_report (country, year, happiness_score, gdp_per_capita, social_support, 
                                      healthy_life_expectancy, freedom_to_make_choices, corruption_perception, generosity)
        VALUES ('Testlandia', 2019, 5.5, 1.2, 0.9, 0.8, 0.6, 0.2, 0.3);
    """)
    with engine.begin() as connection:
        connection.execute(query)

def show_inserted_record(engine):
    """
    Muestra el registro insertado en happiness_report para Testlandia en el año 2019.
    """
    query = """
        SELECT * FROM happiness_report
        WHERE country = 'Testlandia' AND year = 2019;
    """
    return pd.read_sql(query, engine)

def update_happiness_report_record(engine):
    """
    Actualiza el score de felicidad del registro de Testlandia en el año 2019.
    """
    query = text("""
        UPDATE happiness_report
        SET happiness_score = 7.5
        WHERE country = 'Testlandia' AND year = 2019;
    """)
    with engine.begin() as connection:
        connection.execute(query)

def show_updated_record(engine):
    """
    Muestra el registro actualizado para Testlandia en el año 2019.
    """
    query = """
        SELECT * FROM happiness_report
        WHERE country = 'Testlandia' AND year = 2019;
    """
    return pd.read_sql(query, engine)

def delete_happiness_report_record(engine):
    """
    Elimina el registro de Testlandia en el año 2019 de la tabla happiness_report.
    """
    query = text("""
        DELETE FROM happiness_report
        WHERE country = 'Testlandia' AND year = 2019;
    """)
    with engine.begin() as connection:
        connection.execute(query)

def show_deleted_record(engine):
    """
    Verifica que el registro de Testlandia en el año 2019 ha sido eliminado de la tabla happiness_report.
    """
    query = """
        SELECT * FROM happiness_report
        WHERE country = 'Testlandia' AND year = 2019;
    """
    return pd.read_sql(query, engine)
