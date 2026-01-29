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


