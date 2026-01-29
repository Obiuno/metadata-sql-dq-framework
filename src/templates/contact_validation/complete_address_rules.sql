--Complete Address present
SELECT 
	'Complete Address' as [rule],
	COUNT(CASE WHEN street_address LIKE '[0-9]% [A-Za-z]%' AND len(postcode)=5 AND TRY_CAST(postcode as INT) IS NOT NULL AND city LIKE  THEN 1 END) as valid,
	COUNT(CASE WHEN (TRY_CAST(verified as INT) = 1 AND email IS NULL) THEN 1 END) as invalid 
FROM contact