DROP TABLE IF EXISTS customer_budget_range_rules

CREATE TABLE customer_budget_range_rules(
    [rule] NVARCHAR(50),
    valid_count INT,
    invalid_count INT
);

-- Insert the aggregated data into the new table
INSERT INTO customer_budget_range_rules ([rule], valid_count, invalid_count)

--Starts with a currency symbol
SELECT 
    'Starts with Currency Symbol' AS [rule],
    COUNT(CASE WHEN PATINDEX('[$€£¥₹][0-9]%', budget) = 1 THEN 1 END) AS valid,
    COUNT(CASE WHEN PATINDEX('[$€£¥₹][0-9]%', budget) != 1 THEN 1 END) AS invalid
FROM customer
UNION

--Optional Budget Format
SELECT 
    'Valid Budget Range Format' AS [rule],
    COUNT(CASE 
        WHEN PATINDEX('^[0-9]+-[0-9]%', budget) = 1 
             AND CAST(SUBSTRING(budget, 1, CHARINDEX('-', budget) - 1) AS INT) < 
                 CAST(SUBSTRING(budget, CHARINDEX('-', budget) + 1, LEN(budget)) AS INT) 
        THEN 1 
    END) AS valid,
    COUNT(CASE 
        WHEN PATINDEX('^[0-9]+-[0-9]%', budget) != 1 
             OR CAST(SUBSTRING(budget, 1, CHARINDEX('-', budget) - 1) AS INT) >= 
                 CAST(SUBSTRING(budget, CHARINDEX('-', budget) + 1, LEN(budget)) AS INT) 
        THEN 1 
    END) AS invalid
FROM customer;