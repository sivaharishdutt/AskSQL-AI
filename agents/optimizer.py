# agents/optimizer.py

class SQLOptimizerAgent:
    """
    Small post-processing optimizer.
    """

    def run(self, sql: str) -> str:

        sql = sql.replace("SELECT *", "SELECT")

        # enforce semicolon
        if not sql.strip().endswith(";"):
            sql += ";"

        return sql