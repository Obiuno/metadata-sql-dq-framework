--City name format
SELECT 
    'City Name Format' AS [rule],
    COUNT(CASE WHEN [state] LIKE '[A-Za-z ''-]%' THEN 1 END) AS valid,
    COUNT(CASE WHEN [state] NOT LIKE '[A-Za-z ''-]%' THEN 1 END) AS invalid

FROM contact
