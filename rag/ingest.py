# rag/ingest.py

from langchain_community.document_loaders import TextLoader
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_huggingface import HuggingFaceEmbeddings
from langchain_chroma import Chroma
import os
import shutil

def build_schema_vector_db():
    print("Loading schema file...")

    loader = TextLoader("schema/company_schema.sql", encoding="utf-8")
    docs = loader.load()

    print("Splitting schema into smart chunks...")

    splitter = RecursiveCharacterTextSplitter(
        chunk_size=1200,
        chunk_overlap=200,
        separators=[
            "\nCREATE TABLE",
            "\nCREATE INDEX",
            "\n--",
            "\n\n",
            "\n",
            " "
        ]
    )

    chunks = splitter.split_documents(docs)

    print(f"Total chunks created: {len(chunks)}")

    # Updated embedding model
    embeddings = HuggingFaceEmbeddings(
        model_name="BAAI/bge-base-en-v1.5",
        encode_kwargs={"normalize_embeddings": True}
    )

    # Remove old DB because schema changed
    if os.path.exists("chroma_db"):
        shutil.rmtree("chroma_db")

    print("Creating vector database...")

    db = Chroma.from_documents(
        documents=chunks,
        embedding=embeddings,
        persist_directory="chroma_db"
    )

    print("✅ Schema embedded successfully using BGE Base model.")
    print("📁 Vector DB stored in ./chroma_db")


if __name__ == "__main__":
    build_schema_vector_db()