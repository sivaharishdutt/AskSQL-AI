# main.py

import os
import json
from datetime import datetime

from agents.planner import PlannerAgent
from agents.generator import SQLGeneratorAgent
from agents.validator import SQLValidatorAgent
from agents.optimizer import SQLOptimizerAgent


planner = PlannerAgent()
generator = SQLGeneratorAgent()
validator = SQLValidatorAgent()
optimizer = SQLOptimizerAgent()


def process_question(question):
    try:
        # Step 1: Retrieve schema context
        step1 = planner.run(question)

        # Step 2: Generate SQL
        step2 = generator.run(step1)

        # Step 3: Validate SQL
        step3 = validator.run(step2)

        # Step 4: Optimize SQL
        final_sql = optimizer.run(step3)

        # ---------------------------------
        # CLEAN SQL OUTPUT
        # Removes \n, tabs, extra spaces
        # ---------------------------------
        clean_sql = " ".join(final_sql.split())

        return {
            "question": question,
            "sql": clean_sql,
            "status": "success"
        }

    except Exception as e:
        return {
            "question": question,
            "sql": "",
            "status": "failed",
            "error": str(e)
        }


def main():
    input_file = "input/questions.txt"

    # Read all questions
    with open(input_file, "r") as f:
        questions = [line.strip() for line in f if line.strip()]

    results = []

    for q in questions:
        print(f"Processing: {q}")
        results.append(process_question(q))

    # Create output folder
    os.makedirs("output", exist_ok=True)

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    output_file = f"output/results_{timestamp}.json"

    # Save JSON output
    with open(output_file, "w") as f:
        json.dump(results, f, indent=4)

    print(f"\nSaved results to {output_file}")


if __name__ == "__main__":
    main()