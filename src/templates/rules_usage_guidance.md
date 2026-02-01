# Data Quality Rules Usage guidance

This document provides comprehensive guidance on the application of Data Quality (DQ) rules to ensure consistency and accuracy when implementing data and business rules via SQL. It categorises various types of rules, accompanied by a library of examples demonstrating rule applications across different data fields.

These examples illustrate general approaches for applying rules to fields using SQL, emphasising the definition of valid and invalid values according to specific rules. This guidance focuses on identifying conformity to individual rules rather than determining a record’s overall validity.

When implementing DQ rules, first define the rule clearly, then calculate the counts for both compliant (valid) and non-compliant (invalid) instances. The next phase involves identifying records that do not meet these rules, enabling effective retrieval and actionable follow-up based on the findings.

## Validation Rule Types

1. **Mandatory (completeness)**
2. **Uniqueness**
3. **Positive numbers**
4. **Numeric**
5. **Alphabetical Characters**
6. **Include Certain Characters**
7. **Minimum and Maximum Length**
8. **Predefined List**
9. **Budget Range Rules**
10. **Date Format**
11. **Date Range Rules**

These categories outline the types of data validation rules commonly applied through SQL for data quality assurance.

The queries produce 3 columns

- **Rule** – a brief description of the rule  
- **Valid Count** – the count of records that follow this rule  
- **Invalid Count** – the count of records that do not follow this rule

### Table produced

| rule | valid | invalid |
| :---- | :---- | :---- |
| Mandatory | 4975 | 274 |

Later, we combine all our rules to produce a table for all the data quality rules being applied to a single attribute

There is a rules repository that shows all of these being applied to different tables.

**General Types of Data Quality Rules**

### 1. **Mandatory** 

This rule checks that the field is populated. 
Most important is to identify records that are not populated.

```sql
SELECT 
    'Mandatory' AS [rule],
    COUNT(CASE WHEN company_id IS NOT NULL THEN 1 END) AS valid,
    COUNT(CASE WHEN company_id IS NULL THEN 1 END) AS invalid
FROM contact;
```
### 2. **Uniqueness**

This query groups the different values in a field and counts the number of occurrences. It then does a count of the fields depending on the number of occurrences i.e. if it appears more than once it will have a cnt \> 1 and therefore is not unique and will be counted through the CASE WHEN.

```sql
WITH cnts AS (
  SELECT contact_id, COUNT(*) AS cnt
  FROM contact
  GROUP BY contact_id
)
SELECT
  'Uniqueness' AS rule,
  SUM(CASE WHEN cnt = 1 THEN 1 ELSE 0 END) AS valid,
  SUM(CASE WHEN cnt > 1 THEN 1 ELSE 0 END) AS invalid
FROM cnts;

```

3. **Positive**

This is for a numeric field and makes sure the values are all positive and counts which are and which are not.

```sql
SELECT 
	'Must be positive' as [rule],
	COUNT(CASE WHEN contact_id > 0 THEN contact_id END) as valid,
	COUNT(CASE WHEN contact_id <=0 THEN contact_id END) as invalid
FROM contact
```

4. **Numeric**

Provides a count of the records that are numeric values. It does this by using TRY\_CAST, which will cast it as an integer if it is only numeric and will return null otherwise.

![][image4]

5. **Alphabetical Characters Only**

For this code we need to check whether it has only alphabetical characters which is a little tricky with if your SQL does not allow Regex. SQL server provides pattern and character index options which allow you to look for occurrences of the specified characters. It is similar to regex, but returns values for when it occurs.

Instead we look for when there are occurrences outside of our specified values. If there is such an occurrence it will return the first value where it happens which must be greater than 0\. Using this logic we can find the count of records where it is greater than 0 for invalid, otherwise it is valid

![][image5]

6. **Include certain characters**

This follows the same logic as above (5. Alphabetical Characters Only), just need to specify what your set is with all the allowable characters.

![][image6]

7. Minimum and Maximum length

This uses the length function in SQL to identify the length of a string. This returns a number, and you can compare it to the length you are interested in. Simply look at the values that are that length or longer and the values that are operationally the opposite of that.

![][image7]

Similar for maximum length but the signs are changed.

![][image8]

8. **Predefined List**

This compares values to a predefined list of values. This can be done through a join clause and see where the values are null i.e. they could not be joined. This needs to be done in our case as you cannot include an aggregate function on expressions containing an aggregate or  subquery (you cannot do an aggregate function inside of a CASE WHEN).

Be careful when joining as you may run into trouble as values can be duplicated, leading to an inaccurate count.

In some cases you may be interested in the total count, but in the example below we have used DISTINCT as we are only interested if there is not a join.

![][image9]

Another solution would require you to do this from a predefined table (e.g. reference table). You will need to check if the values are in that table. This can be performed using a nested query. This works better for when you have duplicate values in an attribute.

![][image10]

9. **Date Format**

This uses TRY\_CAST as a date in SQL server to see if it is in the correct format. This is because it will convert strings that are in the correct format into datetime fields. If it is not correct it will not and produce a null. You can then use a count of the non-null values.

![][image11]

10. **Date Range Rules**

This requires it to be in a datetime format to begin, as we need it that way to be able to accurately do comparators with dates. If it is able to be transformed we can then use operations to compare it with date values. In our rule we wanted it to be after 2015 but before the current date.

![][image12]

**Creating a DQ Table**

To create a simple data quality rules valid/invalid table you can create a new table in SQL and insert the results from your queries into it.

This can be achieved nicely in SQL and then your results can be shared to a dashboarding tool of your choice.

In the example below we are creating a DQ rules table for first name in the contact table. 

![][image13]

We can combine this with a query for producing the counts for our first name rules

![][image14]

This produces a table that looks like this.

| rule | valid | invalid |
| :---- | :---- | :---- |
| Mandatory | 4975 | 274 |
| Name allowable characters | 4945 | 30 |
| First name length \<=50 | 4975 | 0 |

We can then use INSERT INTO to put the values into the table.

This creates a permanent table in your database that you can refer to for the results from your data quality rules.
