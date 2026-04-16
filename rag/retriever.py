# rag/retriever.py

from langchain_huggingface import HuggingFaceEmbeddings
from langchain_chroma import Chroma


class SchemaRetriever:
    def __init__(self):
        # Must match ingest.py model
        self.embeddings = HuggingFaceEmbeddings(
            model_name="BAAI/bge-base-en-v1.5",
            encode_kwargs={"normalize_embeddings": True}
        )

        self.db = Chroma(
            persist_directory="chroma_db",
            embedding_function=self.embeddings
        )

        self.retriever = self.db.as_retriever(
            search_type="similarity",
            search_kwargs={"k": 5}
        )

    def fetch_schema_context(self, user_question: str) -> str:
        """
        Retrieve top relevant schema chunks for user query.
        Example:
        'top 10 performers last 3 months'
        """

        docs = self.retriever.invoke(user_question)

        if not docs:
            return ""

        context = "\n\n".join(doc.page_content for doc in docs)
        return context


if __name__ == "__main__":
    retriever = SchemaRetriever()

    while True:
        query = input("\nAskSQL Query > ")

        if query.lower() in ["exit", "quit"]:
            break

        result = retriever.fetch_schema_context(query)

        print("\n==============================")
        print("Retrieved Schema Context:")
        print("==============================\n")
        print(result)