import os
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain_core.prompts import PromptTemplate


class SQLGeneratorAgent:
    """
    Generates SQL using LLM + retrieved schema context.
    """

    def __init__(self):
        # Initialize Gemini model
        self.llm = ChatGoogleGenerativeAI(
            model="gemini-flash-latest",
            google_api_key=os.getenv("GOOGLE_API_KEY"),
            temperature=0
        )

        # Load SQL rules prompt
        with open("prompts/sql_prompt.txt", "r") as f:
            self.rules = f.read()

        # Prompt template
        self.prompt = PromptTemplate.from_template("""
{rules}

==================================================
DATABASE SCHEMA
==================================================

{schema}

==================================================
USER REQUEST
==================================================

{question}

==================================================
OUTPUT
==================================================
Return only valid SQL query.
""")

    def run(self, planner_output: dict) -> str:
        schema = planner_output.get("schema_context", "")
        question = planner_output.get("question", "")

        final_prompt = self.prompt.format(
            rules=self.rules,
            schema=schema,
            question=question
        )

        response = self.llm.invoke(final_prompt)

        content = response.content

        # -------------------------
        # CLEAN GEMINI RESPONSE
        # -------------------------
        if isinstance(content, str):
            sql = content.strip()

        elif isinstance(content, list):
            parts = []

            for item in content:
                if isinstance(item, dict):
                    # Gemini structured part
                    if "text" in item:
                        parts.append(item["text"])
                else:
                    parts.append(str(item))

            sql = "\n".join(parts).strip()

        elif isinstance(content, dict):
            sql = content.get("text", "").strip()

        else:
            sql = str(content).strip()

        return sql