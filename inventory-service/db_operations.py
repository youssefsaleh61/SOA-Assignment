import pyodbc

class DatabaseExecutionError(Exception):
    """Custom exception for database operations. """
    pass

def execute_stored_procedure(procedure_name, params, conn_str):
    conn = pyodbc.connect(conn_str)
    cursor = conn.cursor()

    try:
        query = f"EXEC {procedure_name} " + ",".join("?" for _ in params)
        cursor.execute(query, params)
        results = []
        try:
            results.append(cursor.fetchall())
        except pyodbc.ProgrammingError:
            pass
        while cursor.nextset():
                try:
                    results.append(cursor.fetchall())
                except pyodbc.ProgrammingError:
                    pass

    except pyodbc.Error as e:
        raise DatabaseExecutionError((f"Error executing stored procedure '{procedure_name}': {e}"))

    finally:
        cursor.close()
        conn.commit()
        conn.close()

    return results