# T-SQL Data Quality Framework & Python Chaos Engine

## 🚀 The Vision
Most Data Quality (DQ) tools are black boxes. This project is a **transparent, metadata-driven validation engine** built in T-SQL. 

To prove the framework's resilience, I developed an integrated **Python Chaos Engine** that generates synthetic relational data and intentionally "poisons" it. 
This ensures the SQL logic isn't just checking boxes—it’s surviving a simulated worst-case ETL scenario.

---

## 🏗️ Architecture: The "Daisy-Chain" Strategy
One of the core challenges was maintaining **Referential Integrity** while injecting chaos. I solved this by decoupling the generation process into a three-stage pipeline:

1. **Entity Anchoring:** Building a valid relational shell (Customers → Contacts → History) using procedural lists to ensure foreign key consistency.
2. **The "Golden Record" Save:** Storing a pristine version of the data for comparative analysis.
3. **Vectorised Chaos:** Casting the data into Pandas DataFrames to perform "Non-Destructive Mutations". This allows for targeted error injection without breaking the underlying database joins.

## 🧪 The Chaos Engine (Python Features)
The `dq_fake_data.ipynb` notebook isn't just a generator; it also acts as the stress test for the DQ suite by using:

- **Mathematical Scaling:** Using `log10` and `floor` logic to maintain consistent significant figures across financial values (from $50K to $5M).
- **Type Poisoning:** Injecting strings into numeric fields to test the resilience of T-SQL `TRY_CAST` logic.
- **Structural Fuzzing:** Randomised string truncation and column-swapping to simulate mapping failures in production pipelines.

## Error Types

When creating errors, I focused on "Error Primatives" that create multiple types of data quality rule and business rule failures.
This made it easier to maintain and easier for the SQL layer to catch without needing 500 lines of complex regex and overfitting.

Data quality dimensions considered and examples of what affects them

| Data Quality Dimension | Error Generators (Primitives and Tricks) |
| -------- | -------- |
| Accuracy |Column Swapping: Swapping First_Name and Last_Name creates inaccurate data that is still technically "valid" strings | 
| Completeness | Null Injection: Randomly dropping values in mandatory fields like Email or Customer_ID |
| Timeliness | Implicit Date Ranges: Using generation parameters that include "Stale" records (e.g., 5-year-old dates) to trigger freshness flags |
| Validity | Type Poisoning & Truncation: Forcing TRY_CAST failures and regex-pattern breaches (e.g., truncated emails) |
| Uniqueness| Random Duplication: Clones existing rows |
| Precision | Numeric Scaling: Using the log10 math to strip decimals or shift significant figures via floor division (/ 10) |
| Conformity | List Exclusion: Using a broader "Business Type" list in Python than allowed in the SQL metadata |



