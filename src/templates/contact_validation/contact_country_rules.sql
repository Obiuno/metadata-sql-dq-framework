DROP TABLE IF EXISTS contact_country_rules

CREATE TABLE contact_country_rules(
    [rule] NVARCHAR(50),
    valid_count INT,
    invalid_count INT
);

-- Insert the aggregated data into the new table
INSERT INTO contact_country_rules ([rule], valid_count, invalid_count)

--Country in country list
SELECT 
    'Country in country list' AS [rule],
    COUNT(CASE WHEN country_check = 'Valid' THEN 1 END) AS valid,
    COUNT(CASE WHEN country_check = 'Invalid' THEN 1 END) AS invalid
FROM (
    SELECT 
        country,
        CASE 
            WHEN country IN (SELECT [name] FROM country_list) THEN 'Valid'
            ELSE 'Invalid'
        END AS country_check
    FROM contact
) AS country_validation