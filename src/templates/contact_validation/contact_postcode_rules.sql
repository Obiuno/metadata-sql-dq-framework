DROP TABLE IF EXISTS contact_postcode_rules

CREATE TABLE contact_postcode_rules(
    [rule] NVARCHAR(50),
    valid_count INT,
    invalid_count INT
);

-- Insert the aggregated data into the new table
INSERT INTO contact_postcode_rules ([rule], valid_count, invalid_count)

--Format Rule
SELECT 
    'Post Code Format' AS [rule],
    COUNT(CASE WHEN format_check = 'Valid' THEN 1 END) AS valid,
    COUNT(CASE WHEN format_check = 'Invalid' THEN 1 END) AS invalid
FROM (
    SELECT 
        postcode,
        CASE 
            WHEN len(postcode)=5 AND TRY_CAST(postcode as INT) IS NOT NULL THEN 'Valid'
            ELSE 'Invalid'
        END AS format_check
    FROM contact
) AS format_validation
UNION

--Mandatory Rule
SELECT 
	'Postcode present for verified contact' as [rule],
	COUNT(CASE WHEN mandatory_check = 'Valid' THEN 1 END) as valid,
	COUNT(CASE WHEN mandatory_check = 'Invalid' THEN 1 END) as invalid 
FROM (
	SELECT
		postcode,
		CASE 
			 WHEN len(postcode)=5 AND TRY_CAST(postcode as INT) IS NOT NULL AND street_address IS NOT NULL THEN 'Valid'
			 ELSE 'Invalid'
		END AS mandatory_check
	FROM contact
	) as mandatory_validation