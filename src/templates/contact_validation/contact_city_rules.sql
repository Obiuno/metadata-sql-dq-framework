SELECT 
    'City Name Format' AS [rule],
    COUNT(CASE WHEN city LIKE '[A-Za-z ''-]%' THEN 1 END) AS valid,
    COUNT(CASE WHEN city NOT LIKE '[A-Za-z ''-]%' THEN 1 END) AS invalid
FROM contact




