--Valid Format
SELECT 
	'Valid format' as [rule],
	COUNT(CASE WHEN TRY_CAST(marketing as INT) = 1 OR TRY_CAST(marketing as INT) = 0 THEN 1 END) as valid,
	COUNT(CASE WHEN TRY_CAST(marketing as INT) = 1 OR TRY_CAST(marketing as INT) = 0 THEN NULL ELSE 1 END) as invalid 
FROM contact
UNION ALL

--Email present for Verified Contact Rule
SELECT 
	'Email present for verified contact' as [rule],
	COUNT(CASE WHEN (TRY_CAST(marketing as INT) = 1 AND email IS NOT NULL) THEN 1 END) as valid,
	COUNT(CASE WHEN (TRY_CAST(marketing as INT) = 1 AND email IS NULL) THEN 1 END) as invalid 

FROM contact
