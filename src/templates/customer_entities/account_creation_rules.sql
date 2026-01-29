DROP TABLE IF EXISTS account_creation_rules

CREATE TABLE account_creation_rules(
    [rule] NVARCHAR(50),
    valid_count INT,
    invalid_count INT
);

-- Insert the aggregated data into the new table
INSERT INTO account_creation_rules ([rule], valid_count, invalid_count)

--SQL has date time, so simply TRY_CAST for date time format, will return nulls if not working, we are very lucky
--Date time format
SELECT 
	'Date time format' as [rule],
	COUNT(TRY_CAST(account_creation as datetime)) as valid,
	COUNT(CASE WHEN TRY_CAST(account_creation as datetime) IS NULL THEN 1 END) as invalid	
FROM customer
UNION
--account created from 2015 onwards
SELECT 
	'Between 2015 and Current Date' as [rule],
	COUNT(CASE WHEN TRY_CAST(account_creation as datetime) >='2015'  AND TRY_CAST(account_creation AS datetime) <= GETDATE() 
               THEN 1 END) as valid,
	COUNT(CASE WHEN TRY_CAST(account_creation as datetime) <'2015' OR   TRY_CAST(account_creation AS datetime) > GETDATE() 
               THEN 1 END) as invalid
FROM customer
