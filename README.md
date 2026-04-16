# 🚀 AskSQL-AI (Natural Language → SQL with RAG + Agents)

---

## 📌 Overview

AskSQL-AI is a **multi-agent, Retrieval-Augmented Generation (RAG) system** that converts natural language questions into **validated and optimized SQL queries**.

It combines:

* 🧠 Multi-agent pipeline (Planner → Generator → Validator → Optimizer)
* 🔍 Retrieval-Augmented Generation (RAG) for schema understanding
* 🤖 LLM-based SQL generation
* ⚡ Query validation and optimization

---

## 🧠 What is RAG?

**RAG = Retrieval + Generation**

Instead of blindly generating SQL, the system:

1. Retrieves relevant schema context
2. Injects it into the prompt
3. Generates accurate SQL

This significantly improves correctness and reduces hallucinations.

---

## 🏗️ Architecture (Agent Pipeline)

### 🔹 Step 1: Planner Agent

* Understands the question
* Retrieves relevant schema context using RAG

### 🔹 Step 2: SQL Generator Agent

* Converts structured context into SQL

### 🔹 Step 3: SQL Validator Agent

* Ensures correctness and logical consistency

### 🔹 Step 4: SQL Optimizer Agent

* Improves query performance and readability

---

## 📂 Project Structure

```bash
AskSQL-AI/
├── agents/
│   ├── planner.py
│   ├── generator.py
│   ├── validator.py
│   └── optimizer.py
│
├── rag/
│   ├── ingest.py
│   └── retriever.py
│
├── schema/
│   └── company_schema.sql
│
├── prompts/
│   └── sql_prompt.txt
│
├── input/
│   └── questions.txt
│
├── output/              # Generated results
├── chroma_db/           # Vector DB (auto-generated)
│
├── main.py              # Entry point
├── requirements.txt
└── README.md
```

---

## ⚙️ Installation

### 1. Clone Repository

```bash
git clone https://github.com/your-username/asksql-ai.git
cd asksql-ai
```

### 2. Setup Virtual Environment

```bash
python3 -m venv venv
source venv/bin/activate
```

### 3. Install Dependencies

```bash
pip install -r requirements.txt
```

---

## ▶️ How to Run

### Step 1: Add Questions

Edit:

```bash
input/questions.txt
```

Example:

```text
Get all employees
Find total revenue by department
```

---

### Step 2: Run Pipeline

```bash
python main.py
```

---

## 📤 Output

* Stored in `output/` directory
* Format: `results_<timestamp>.json`

### Example:

```json
[
  {
    "question": "Get all employees",
    "sql": "SELECT * FROM employees;",
    "status": "success"
  }
]
```

---

## 🔍 Key Components

### 🔹 RAG Layer

* Uses `chroma_db` for vector storage
* Retrieves schema-relevant context

### 🔹 Prompt Engineering

* Controlled via:

```bash
prompts/sql_prompt.txt
```

### 🔹 Schema Awareness

* Defined in:

```bash
schema/company_schema.sql
```

---

## ✨ Features

* Multi-agent modular architecture
* Retrieval-augmented SQL generation
* Automatic SQL validation
* Query optimization layer
* Clean SQL formatting
* Batch query processing

---

## 🧪 Limitations

* No execution-based SQL validation
* Dependent on schema quality
* Limited multi-database support

---

## 🎯 Future Improvements

* ✅ Execute SQL against real database
* ✅ Add support for multiple schemas
* ✅ Improve logging and error handling
* ✅ Build UI (Streamlit / Web App)
* ✅ Add evaluation metrics for SQL correctness

---

## 🧠 Tech Stack

* Python
* LLM APIs
* ChromaDB (Vector DB)
* Prompt Engineering
* RAG Architecture

---

## 🏁 Summary

This project demonstrates:

* Practical RAG system design
* Multi-agent AI architecture
* Real-world NL → SQL pipeline
* Modular and scalable design

---

## ⭐ If You Like This Project

Give it a ⭐ on GitHub!

---

## 📬 Contact

Open to feedback, improvements, and collaboration 🚀
