# agents/validator.py

class SQLValidatorAgent:
    """
    Basic SQL validation layer.
    Prevents dangerous or invalid output.
    """

    BLOCKED = [
        "drop ",
        "truncate ",
        "delete ",
        "update ",
        "alter "
    ]

    def run(self, sql: str) -> str:
        low = sql.lower()

        for word in self.BLOCKED:
            if word in low:
                return "-- BLOCKED UNSAFE SQL DETECTED"

        if "select" not in low:
            return "-- INVALID SQL GENERATED"

        return sql.strip()