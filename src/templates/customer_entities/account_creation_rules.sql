--SQL has date time, so simply TRY_CAST for date time format, will return nulls if not working, we are very lucky
--handling dates is painful
--Date time format
SELECT 
	'Date time format' as [rule],
	COUNT(TRY_CAST(account_creation as datetime)) as valid,
	COUNT(CASE WHEN TRY_CAST(account_creation as datetime) IS NULL THEN 1 END) as invalid	
FROM customer
UNION ALL
--account created from 2015 onwards
SELECT 
	'Between 2015 and Current Date' as [rule],
	COUNT(CASE WHEN TRY_CAST(account_creation as datetime) >='2015'  AND TRY_CAST(account_creation AS datetime) <= GETDATE() 
               THEN 1 END) as valid,
	COUNT(CASE WHEN TRY_CAST(account_creation as datetime) <'2015' OR   TRY_CAST(account_creation AS datetime) > GETDATE() 
               THEN 1 END) as invalid
FROM customer

