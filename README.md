AskSQL-AI 🚀

AskSQL-AI is an intelligent pipeline that converts natural language questions into optimized SQL queries using a multi-agent architecture.

🧠 Architecture Overview

The system processes each query through multiple intelligent agents:

Planner Agent
    Understands the question
    Retrieves relevant schema context using RAG
SQL Generator Agent
    Converts structured context into SQL
SQL Validator Agent
    Ensures correctness and consistency
SQL Optimizer Agent
    Improves query efficiency

📁 Project Structure
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

⚙️ Setup Instructions
1. Clone the Repository
git clone https://github.com/your-username/AskSQL-AI.git
cd AskSQL-AI
2. Create Virtual Environment
python3 -m venv venv
source venv/bin/activate
3. Install Dependencies
pip install -r requirements.txt

▶️ How to Run
Step 1: Add Questions

Edit:
input/questions.txt

Example:
Get all employees
Find total revenue by department

Step 2: Run the Pipeline
python main.py

📤 Output
Results are stored in the output/ folder
File name format: results_<timestamp>.json
Example Output:
[
    {
        "question": "Get all employees",
        "sql": "SELECT * FROM employees;",
        "status": "success"
    }
]s

🔍 Key Components
🔹 RAG (Retrieval-Augmented Generation)
Uses chroma_db to store embeddings
Retrieves relevant schema context before SQL generation
🔹 Prompting
SQL generation is guided by:
prompts/sql_prompt.txt
🔹 Schema Awareness
Database structure defined in:
schema/company_schema.sql

✨ Features
Multi-agent modular design
Retrieval-augmented SQL generation
Automatic validation and optimization
Clean SQL formatting
Batch processing of queries

🛠️ Future Enhancements
Execute SQL against live database
Add support for multiple schemas
Improve error handling and logging
Build a web UI
Add support for different SQL dialects

⚠️ Notes
Ensure chroma_db is properly initialized before running
Update prompts and schema for your use case