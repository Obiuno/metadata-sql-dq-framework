--Email address format
--Please note that  a more sophisticated regular expression (in a programming language or advanced SQL engine that supports regex) would be ideal.
SELECT 
    'Email Format' AS [rule],
    COUNT(CASE WHEN email LIKE '%_@__%.__%' THEN 1 END) AS valid,
    COUNT(CASE WHEN email NOT LIKE '%_@__%.__%' THEN 1 END) AS invalid

FROM contact;
