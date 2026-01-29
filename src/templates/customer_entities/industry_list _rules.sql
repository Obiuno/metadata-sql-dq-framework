DROP TABLE IF EXISTS customer_industry_list_rules

CREATE TABLE customer_industry_list_rules(
    [rule] NVARCHAR(50),
    valid_count INT,
    invalid_count INT
);

-- Insert the aggregated data into the new table
INSERT INTO customer_industry_list_rules ([rule], valid_count, invalid_count)

--Industry in industry list
SELECT 
    'Values in industry list' AS [rule],
    COUNT(CASE WHEN industry_check = 'Valid' THEN 1 END) AS valid,
    COUNT(CASE WHEN industry_check = 'Invalid' THEN 1 END) AS invalid
FROM (
    SELECT 
        industry,
        CASE 
            WHEN industry IN (SELECT industry FROM industry_list) THEN 'Valid'
            ELSE 'Invalid'
        END AS industry_check
    FROM customer
) AS industry_validation;

