DROP TABLE IF EXISTS customer_business_type_rules

CREATE TABLE customer_business_type_rules(
    [rule] NVARCHAR(50),
    valid_count INT,
    invalid_count INT
);

-- Insert the aggregated data into the new table
INSERT INTO customer_business_type_rules ([rule], valid_count, invalid_count)

--Business in business type list
SELECT 
    'Values in industry list' AS [rule],
    COUNT(CASE WHEN business_check = 'Valid' THEN 1 END) AS valid,
    COUNT(CASE WHEN business_check = 'Invalid' THEN 1 END) AS invalid
FROM (
    SELECT 
        business_type,
        CASE 
            WHEN business_type IN (SELECT business_type FROM business_type) THEN 'Valid'
            ELSE 'Invalid'
        END AS business_check
    FROM customer
) AS business_validation