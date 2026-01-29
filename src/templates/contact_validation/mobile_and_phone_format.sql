SELECT 
    'Mobile Number Format' AS [rule],
    COUNT(CASE WHEN mobile LIKE '+[0-9]%' THEN 1 END) AS valid,
    COUNT(CASE WHEN  mobile NOT LIKE '+[0-9]%' THEN 1 END) AS invalid
FROM contact
UNION ALL
SELECT 
    'Phone Number Format' AS [rule],
    COUNT(CASE WHEN phone LIKE '+[0-9]%' THEN 1 END) AS valid,
    COUNT(CASE WHEN  phone NOT LIKE '+[0-9]%' THEN 1 END) AS invalid
FROM contact
