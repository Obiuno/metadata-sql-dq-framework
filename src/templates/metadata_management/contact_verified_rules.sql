--Valid Format
SELECT 
	'Valid format' as [rule],
	COUNT(CASE WHEN TRY_CAST(verified as INT) = 1 OR TRY_CAST(verified as INT) = 0 THEN 1 END) as valid,
	COUNT(CASE WHEN TRY_CAST(verified as INT) = 1 OR TRY_CAST(verified as INT) = 0 THEN NULL ELSE 1 END) as invalid 
FROM contact
UNION ALL

--Email present for Verified Contact Rule
--If a contact claims to be verified (1), they MUST have an email address.
SELECT 
	'Email present for verified contact' as [rule],
	COUNT(CASE WHEN (TRY_CAST(verified as INT) = 1 AND email IS NOT NULL) THEN 1 END) as valid,
	COUNT(CASE WHEN (TRY_CAST(verified as INT) = 1 AND email IS NULL) THEN 1 END) as invalid 
FROM contact
UNION ALL

--BR - Email is Verified
SELECT 
	'Email verified' as [rule],
	COUNT(CASE WHEN TRY_CAST(verified as INT) =1 THEN 1 END) valid,
	COUNT(CASE WHEN TRY_CAST(verified as INT) != 1 THEN 1 END) invalid
FROM contact

