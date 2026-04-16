# agents/planner.py

from rag.retriever import SchemaRetriever


class PlannerAgent:
    """
    Understands user intent and retrieves relevant schema context.
    """

    def __init__(self):
        self.retriever = SchemaRetriever()

    def run(self, user_question: str) -> dict:
        context = self.retriever.fetch_schema_context(user_question)

        return {
            "question": user_question,
            "schema_context": context
        }