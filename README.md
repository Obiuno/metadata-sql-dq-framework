# Metadata SQL Data Quality Framework

A comprehensive SQL-based data quality framework for automated profiling 
Includes example rules for validation across customer, contact, and metadata domains.

## Overview

This framework provides production-ready SQL templates and stored procedures for data quality validation. Built for SQL Server but adaptable to other SQL databases.

**Use it to:**
- Profile any table automatically (completeness, uniqueness, ranges)
- Validate data against 11+ rule types
- Monitor data quality across migrations
- Implement standardised DQ checks

## Quick Start

### Automated Profiling

**Returns per column:**
- Completeness (% non-null)
- Uniqueness (distinct count)
- Duplicate count
- Min/Max values
- Total records

### Validation Rules

Run pre-built validation templates:

```sql
-- Email format validation
SELECT 
    'Email Format' AS [rule],
    COUNT(CASE WHEN email LIKE '%_@__%.__%' THEN 1 END) AS valid,
    COUNT(CASE WHEN email NOT LIKE '%_@__%.__%' THEN 1 END) AS invalid
FROM contact;
```

**Standardised output:**
```
Rule              | Valid Count | Invalid Count
------------------|-------------|---------------
Email Format      | 4850        | 150
```

## Components

### 1. Automated Profiling (`src/dq_metrics_global.sql`)

**Dynamic stored procedure** that is table agnostic and can profile any table:

```sql
CREATE OR ALTER PROCEDURE obiunoojji.GetDataQualityMetrics1
    @TableName NVARCHAR(128)
AS
BEGIN
    -- Returns data quality metrics for all columns
    -- Completeness, Uniqueness, Duplicates, Min/Max, Total Count
END
```

**Key Features:**
- ✅ Dynamic SQL with QUOTENAME (SQL injection protection)
- ✅ Cursor-based column iteration
- ✅ Global temp table for results
- ✅ Works with any table schema
- ✅ Production-grade error handling

**Usage:**
```sql
-- Profile customer table
EXEC obiunoojji.GetDataQualityMetrics1 @TableName = 'customer'

-- Profile any table in your database
EXEC obiunoojji.GetDataQualityMetrics1 @TableName = 'orders'
```

### 2. Validation Rule Templates (`src/templates/`)

**16+ ready-to-use validation rules** organized by domain:

#### Contact Validation (`src/templates/contact_validation/`)
- **Email format** - Basic pattern matching (contains @, domain, extension)
- **Phone/mobile formats** - International format validation (starts with +)
- **Address completeness** - Street, city, state, postcode, country presence
- **Postcode format** - 5-digit numeric validation
- **City/state format** - Alphabetical with spaces/hyphens allowed
- **Country validation** - Against reference list

#### Customer Entities (`src/templates/customer_entities/`)
- **Company name length** - Min 2, max 100 characters
- **Account creation date** - Datetime format, range 2015-current
- **Budget range validation** - Currency symbols, min < max format
- **Industry validation** - Against predefined list
- **Business type validation** - Against reference table

#### Metadata Management (`src/templates/metadata_management/`)
- **Creation date validation** - Datetime format, date ranges
- **Boolean flags** - Verified, marketing (0/1 validation)
- **Cross-field rules** - Verified contact must have email

### 3. Rule Types (11+ Patterns)

The framework covers these validation categories:

1. **Mandatory (Completeness)** - Field is populated
2. **Uniqueness** - No duplicate values
3. **Positive Numbers** - Numeric values > 0
4. **Numeric** - Values are numeric type
5. **Alphabetical Characters** - Only letters allowed
6. **Include Certain Characters** - Specific character sets
7. **Min/Max Length** - String length constraints
8. **Predefined List** - Values in reference table
9. **Budget Range Rules** - Currency, format, feasibility
10. **Date Format** - Valid datetime strings
11. **Date Range Rules** - Dates within specified bounds

### 4. Standardized Output

All rules follow a consistent format:

```sql
SELECT 
    'Rule Name' AS [rule],
    COUNT(CASE WHEN [condition] THEN 1 END) AS valid,
    COUNT(CASE WHEN NOT [condition] THEN 1 END) AS invalid
FROM table_name
```

**Benefits:**
- Easy to combine rules (UNION ALL)
- Consistent reporting structure
- Dashboard-ready output
- Aggregatable metrics

## Key Features

### Production-Grade SQL
- **SQL injection protection** - Uses QUOTENAME for identifiers
- **Dynamic SQL** - Works with any schema
- **Cursor-based iteration** - Handles variable column counts
- **TRY_CAST validation** - Safe type checking
- **Reference table joins** - Predefined list validation

### Advanced Patterns
- **PATINDEX for pattern matching** - Character validation without regex
- **Nested subqueries** - Complex validation logic
- **CASE WHEN aggregation** - Valid/invalid counting
- **Cross-field validation** - Business rule enforcement
- **Temporal logic** - Date range validation with GETDATE()

### Reusable Templates
- **Domain-organised** - Contact, customer, metadata separation
- **Adaptable patterns** - Easy to modify for your schema
- **Copy-paste ready** - Change table/column names and run
- **Well-commented** - Explains validation logic

## Use Cases

### Data Migration Validation
```sql
-- Profile source data before migration
EXEC obiunoojji.GetDataQualityMetrics1 @TableName = 'legacy_customers'

-- Run validation rules
-- Compare completeness/uniqueness metrics
-- Identify data quality issues pre-migration
```

### Pipeline Quality Checks
```sql
-- Validate data at each pipeline stage
-- Stage 1: Source validation
-- Stage 2: Transformation validation  
-- Stage 3: Load validation

-- Track quality metrics across stages
```

### Data Warehouse Profiling
```sql
-- Profile dimension tables
EXEC obiunoojji.GetDataQualityMetrics1 @TableName = 'dim_customer'

-- Profile fact tables
EXEC obiunoojji.GetDataQualityMetrics1 @TableName = 'fact_sales'

-- Understand data distributions
-- Identify completeness issues
```

### Compliance Reporting
```sql
-- Run all validation rules
-- Aggregate valid/invalid counts
-- Generate DQ scorecards
-- Track quality trends over time
```

## Installation

### Prerequisites
- SQL Server 2016+ (for TRY_CAST, JSON functions)
- Database with CREATE PROCEDURE permissions
- Optional: Reference tables for list validation

### Setup

1. **Create the profiling procedure:**
```sql
-- Run dq_metrics_global.sql
-- Creates: obiunoojji.GetDataQualityMetrics1
```

2. **Adapt validation templates:**
```sql
-- Copy templates from src/templates/
-- Modify table/column names for your schema
-- Run templates as needed
```

3. **Optional: Create reference tables:**
```sql
-- For list validation rules
CREATE TABLE country_list ([name] NVARCHAR(100))
CREATE TABLE industry_list (industry NVARCHAR(100))
CREATE TABLE business_type (business_type NVARCHAR(100))

-- Populate with valid values
```

## Example: Complete DQ Check

```sql
-- 1. Profile the table
EXEC obiunoojji.GetDataQualityMetrics1 @TableName = 'contact'

-- 2. Run validation rules
-- Email format
SELECT 'Email Format' AS [rule],
    COUNT(CASE WHEN email LIKE '%_@__%.__%' THEN 1 END) AS valid,
    COUNT(CASE WHEN email NOT LIKE '%_@__%.__%' THEN 1 END) AS invalid
FROM contact
UNION ALL

-- Phone format
SELECT 'Phone Number Format' AS [rule],
    COUNT(CASE WHEN phone LIKE '+[0-9]%' THEN 1 END) AS valid,
    COUNT(CASE WHEN phone NOT LIKE '+[0-9]%' THEN 1 END) AS invalid
FROM contact
UNION ALL

-- Mandatory email for verified contacts
SELECT 'Email present for verified contact' AS [rule],
    COUNT(CASE WHEN (verified = 1 AND email IS NOT NULL) THEN 1 END) AS valid,
    COUNT(CASE WHEN (verified = 1 AND email IS NULL) THEN 1 END) AS invalid
FROM contact;

-- 3. Export to dashboard
-- Results table ready for Power BI, Tableau, etc.
```

## Creating a DQ Results Table

Store validation results persistently:

```sql
-- Create results table
DROP TABLE IF EXISTS contact_dq_rules;

CREATE TABLE contact_dq_rules(
    [rule] NVARCHAR(50),
    valid_count INT,
    invalid_count INT
);

-- Insert validation results
INSERT INTO contact_dq_rules ([rule], valid_count, invalid_count)

SELECT 'Email Format' AS [rule],
    COUNT(CASE WHEN email LIKE '%_@__%.__%' THEN 1 END) AS valid,
    COUNT(CASE WHEN email NOT LIKE '%_@__%.__%' THEN 1 END) AS invalid
FROM contact
UNION ALL
-- ... additional rules ...

-- Query anytime
SELECT * FROM contact_dq_rules;
```

## Documentation

### Rule Repository Usage Guide
Comprehensive guidance on applying DQ rules is available in the repository. Covers:
- How to adapt templates to your schema
- Pattern explanations (PATINDEX, TRY_CAST, etc.)
- Join-based vs nested query validation
- Creating custom rules
- Combining rules into reports

### Rule Categories Reference

**Format Validation:**
- Email, phone, address patterns
- Date/datetime formats
- Custom pattern matching

**Range Validation:**
- Numeric bounds
- Date ranges
- Length constraints

**List Validation:**
- Reference table checks
- Predefined value sets
- Industry/category validation

**Business Rules:**
- Cross-field validation
- Conditional requirements
- Temporal logic

## Advanced Usage

### Batch Profiling

```sql
-- Profile multiple tables
DECLARE @tables TABLE (table_name NVARCHAR(128))
INSERT INTO @tables VALUES ('customer'), ('contact'), ('history')

DECLARE @table NVARCHAR(128)
DECLARE table_cursor CURSOR FOR SELECT table_name FROM @tables

OPEN table_cursor
FETCH NEXT FROM table_cursor INTO @table

WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC obiunoojji.GetDataQualityMetrics1 @TableName = @table
    FETCH NEXT FROM table_cursor INTO @table
END

CLOSE table_cursor
DEALLOCATE table_cursor
```

### Custom Rule Development

```sql
-- Template for new rules
SELECT 
    '[Your Rule Name]' AS [rule],
    COUNT(CASE WHEN [your_condition] THEN 1 END) AS valid,
    COUNT(CASE WHEN NOT [your_condition] THEN 1 END) AS invalid
FROM [your_table];

-- Add to existing rule suite with UNION ALL
```

## Integration

### Power BI Dashboard
```sql
-- Create view for Power BI
CREATE VIEW vw_dq_metrics AS
-- Combine all validation results
-- Power BI connects to this view
-- Auto-refresh on schedule
```

## Why This Framework?

### Built for Real Data Quality Work
- Developed across financial services, retail, and FMCG migrations
- Battle-tested on customer, contact, and transaction data
- Handles real-world complexity (nulls, duplicates, format issues)

### Production-Grade Patterns
- SQL injection protection (QUOTENAME)
- Dynamic schema adaptation
- Reusable template approach
- Standardised output format

### Framework Philosophy
- **Templates over tools** - Copy, adapt, run
- **SQL-native** - No external dependencies
- **Database-agnostic patterns** - Adaptable to PostgreSQL, MySQL
- **Observable quality** - Metrics drive decisions

## Related Projects

This framework works alongside:
- **[DQ Synthetic Data](https://github.com/Obiuno/dq-synthetic-data)** - Generate test data with controlled errors to validate this framework
- **[ContractGen](https://github.com/Obiuno/contractgen)** - Define data contracts for schema validation

### Example Workflow: End-to-End DQ Testing

1. **Define schemas** (ContractGen) - YAML data contracts
2. **Generate test data** (DQ Synthetic Data) - Controlled error injection
3. **Validate quality** (this framework) - SQL rule validation
4. **Verify** errors are caught correctly
5. **Deploy** to production with confidence

## Roadmap

### Current (v1.0)
- ✅ Automated profiling procedure
- ✅ 16+ validation rule templates
- ✅ Contact/customer/metadata domains
- ✅ Production-grade SQL patterns

### Future
- [ ] PostgreSQL/MySQL adaptations
- [ ] Stored procedure versions of templates
- [ ] Master orchestration procedure (run all rules)
- [ ] dbt test integration
- [ ] Great Expectations mappings

## Status

**v1.0 - Production Ready**

Built from experience across multiple data quality initiatives in financial services and retail. Actively maintained.

## Contributing

Feedback and contributions welcome:
- Rule template improvements
- Additional validation patterns
- Database platform adaptations
- Integration examples

## License

MIT

---

**v1.0.0** - Production-ready SQL data quality framework
Built for automated profiling and validation across domains.
