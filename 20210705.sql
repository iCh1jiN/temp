DECLARE @i INT,
@sum SMALLINT
SET
    @i = 1
SET
    @sum = 0
WHILE (@i <= 100) BEGIN
    SET
    @sum = @sum + @i
    SET
    @i = @i + 1
END
PRINT @sum