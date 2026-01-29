--Date time format
SELECT 
	'Date time format' as [rule],
	COUNT(TRY_CAST(creation_date as datetime)) as valid,
	COUNT(CASE WHEN TRY_CAST(creation_date as datetime) IS NULL THEN 1 END) as invalid	
FROM contact
UNION ALL

--Year range rule
SELECT 
	'2015 onwards and before current date' as [rule],
	COUNT(CASE WHEN TRY_CAST(creation_date as datetime) >='2015' AND TRY_CAST(creation_date as datetime) <=GETDATE() THEN 1 END) as valid,
	COUNT(CASE WHEN TRY_CAST(creation_date as datetime) <'2015' OR TRY_CAST(creation_date as datetime) > GETDATE() THEN 1 END) as invalid
FROM contact

