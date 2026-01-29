DROP TABLE IF EXISTS customer_city_rules

CREATE TABLE customer_city_rules(
    [rule] NVARCHAR(50),
    valid_count INT,
    invalid_count INT
);

-- Insert the aggregated data into the new table
INSERT INTO customer_city_rules ([rule], valid_count, invalid_count)

SELECT 
    'City Name Format' AS [rule],
    COUNT(CASE WHEN city LIKE '[A-Za-z ''-]%' THEN 1 END) AS valid,
    COUNT(CASE WHEN city NOT LIKE '[A-Za-z ''-]%' THEN 1 END) AS invalid
FROM contact



