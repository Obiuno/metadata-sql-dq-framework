DROP TABLE IF EXISTS contact_state_rules

CREATE TABLE contact_state_rules(
    [rule] NVARCHAR(50),
    valid_count INT,
    invalid_count INT
);

-- Insert the aggregated data into the new table
INSERT INTO contact_state_rules ([rule], valid_count, invalid_count)

--City name format
SELECT 
    'City Name Format' AS [rule],
    COUNT(CASE WHEN [state] LIKE '[A-Za-z ''-]%' THEN 1 END) AS valid,
    COUNT(CASE WHEN [state] NOT LIKE '[A-Za-z ''-]%' THEN 1 END) AS invalid
FROM contact