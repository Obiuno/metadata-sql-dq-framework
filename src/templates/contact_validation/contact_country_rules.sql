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
