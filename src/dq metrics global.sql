CREATE OR ALTER PROCEDURE obiunoojji.GetDataQualityMetrics1
    @TableName NVARCHAR(128) -- Table name
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @SQL NVARCHAR(MAX);
    
    -- Global temporary table to hold results
    CREATE TABLE ##DataQualityMetrics (
        Attribute NVARCHAR(128),
        Completeness DECIMAL(5, 2),
        Uniqueness INT,
        DuplicateCount INT,
        MinValue NVARCHAR(255),
        MaxValue NVARCHAR(255),
		TotalCount INT
    );

    -- Cursor to loop through each column in the specified table
    DECLARE @Column NVARCHAR(128);
    
    DECLARE ColumnCursor CURSOR FOR
    SELECT COLUMN_NAME 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = @TableName;

    OPEN ColumnCursor;
    FETCH NEXT FROM ColumnCursor INTO @Column;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Dynamic SQL to calculate completeness, uniqueness, duplicate count, min and max values
        SET @SQL = '
        DECLARE @TotalCount INT;
        DECLARE @ValidCount INT;
        DECLARE @UniqueCount INT;
        DECLARE @DuplicateCount INT;
        DECLARE @MinValue NVARCHAR(255);
        DECLARE @MaxValue NVARCHAR(255);

        SELECT @TotalCount = COUNT(*),
               @ValidCount = COUNT(' + QUOTENAME(@Column) + '),
               @UniqueCount = COUNT(DISTINCT ' + QUOTENAME(@Column) + '),
               @DuplicateCount = @TotalCount - @UniqueCount,
               @MinValue = MIN(' + QUOTENAME(@Column) + '),
               @MaxValue = MAX(' + QUOTENAME(@Column) + ')
        FROM ' + QUOTENAME(@TableName) + ';

        INSERT INTO ##DataQualityMetrics (Attribute, Completeness, Uniqueness, DuplicateCount, MinValue, MaxValue, TotalCount)
        VALUES (
            ''' + @Column + ''',
            CASE WHEN @TotalCount = 0 THEN 0 ELSE CAST(@ValidCount AS DECIMAL) / CAST(@TotalCount AS DECIMAL) * 100 END,
            @UniqueCount,
            @DuplicateCount,
            @MinValue,
            @MaxValue,
			@TotalCount
        );';

        EXEC sp_executesql @SQL;

        FETCH NEXT FROM ColumnCursor INTO @Column;
    END;

    CLOSE ColumnCursor;
    DEALLOCATE ColumnCursor;

    -- Select results
    SELECT * FROM ##DataQualityMetrics;

    -- drop
    --DROP TABLE ##DataQualityMetrics;
END;
