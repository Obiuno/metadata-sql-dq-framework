CREATE TABLE company_name_rules (
    [rule] NVARCHAR(50),
    valid_count INT,
    invalid_count INT
);

-- Insert the aggregated data into the new table
INSERT INTO company_name_rules ([rule], valid_count, invalid_count)

-- All chacters allowed, redundant rule as it will always accept everything
-- Name leng >= 2
SELECT 
	'Name length >= 2' as [rule],
	COUNT(CASE WHEN LEN(company_name) >= 2 THEN company_name END) valid,
	COUNT(CASE WHEN LEN(company_name) < 2 THEN company_name END) invalid
FROM customer
UNION

-- Name len <=100
SELECT 
	'Name length >=100' as [rule],
	COUNT(CASE WHEN LEN(company_name) <= 100 THEN company_name END) valid,
	COUNT(CASE WHEN LEN(company_name) > 100 THEN company_name END) invalid
FROM customer