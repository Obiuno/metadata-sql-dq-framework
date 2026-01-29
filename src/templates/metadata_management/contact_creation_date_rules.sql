DROP TABLE IF EXISTS contact_creation_date_rules

CREATE TABLE contact_creation_date_rules(
    [rule] NVARCHAR(50),
    valid_count INT,
    invalid_count INT
);

-- Insert the aggregated data into the new table
INSERT INTO contact_creation_date_rules ([rule], valid_count, invalid_count)

--Date time format
SELECT 
	'Date time format' as [rule],
	COUNT(TRY_CAST(creation_date as datetime)) as valid,
	COUNT(CASE WHEN TRY_CAST(creation_date as datetime) IS NULL THEN 1 END) as invalid	
FROM contact
UNION

--Year range rule
SELECT 
	'2015 onwards and before current date' as [rule],
	COUNT(CASE WHEN TRY_CAST(creation_date as datetime) >='2015' AND TRY_CAST(creation_date as datetime) <=GETDATE() THEN 1 END) as valid,
	COUNT(CASE WHEN TRY_CAST(creation_date as datetime) <'2015' OR TRY_CAST(creation_date as datetime) > GETDATE() THEN 1 END) as invalid
FROM contact
