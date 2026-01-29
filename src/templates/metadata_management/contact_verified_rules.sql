DROP TABLE IF EXISTS contact_verified_rules

CREATE TABLE contact_verified_rules(
    [rule] NVARCHAR(50),
    valid_count INT,
    invalid_count INT
);

-- Insert the aggregated data into the new table
INSERT INTO contact_verified_rules ([rule], valid_count, invalid_count)

--Valid Format
SELECT 
	'Valid format' as [rule],
	COUNT(CASE WHEN TRY_CAST(verified as INT) = 1 OR TRY_CAST(verified as INT) = 0 THEN 1 END) as valid,
	COUNT(CASE WHEN TRY_CAST(verified as INT) = 1 OR TRY_CAST(verified as INT) = 0 THEN NULL ELSE 1 END) as invalid 
FROM contact
UNION

--Email present for Verified Contact Rule
SELECT 
	'Email present for verified contact' as [rule],
	COUNT(CASE WHEN (TRY_CAST(verified as INT) = 1 AND email IS NOT NULL) THEN 1 END) as valid,
	COUNT(CASE WHEN (TRY_CAST(verified as INT) = 1 AND email IS NULL) THEN 1 END) as invalid 
FROM contact
UNION

--Email is Verified
SELECT 
	'Email verified' as [rule],
	COUNT(CASE WHEN TRY_CAST(verified as INT) =1 THEN 1 END) valid,
	COUNT(CASE WHEN TRY_CAST(verified as INT) != 1 THEN 1 END) invalid
FROM contact
