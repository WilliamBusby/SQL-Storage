CREATE PROCEDURE [dbo].[GenerateDates](
	@StartDate DATE,
	@EndDate DATE
)
AS

WITH e1(n) AS (
	SELECT 1 FROM (VALUES (1), (1), (1), (1), (1), (1), (1), (1), (1), (1)) n (N) -- 10
),
e2(n) AS (
	SELECT 1 FROM e1 CROSS JOIN (SELECT 1 FROM e1) n (N) -- 100
), 
e3(n) AS (
	SELECT 1 FROM e2 CROSS JOIN (SELECT 1 FROM e2) n (N) -- 10,000
), 
e4(n) as (
	SELECT 1 FROM e3 CROSS JOIN (SELECT 4 FROM e3) n (N) -- 40,000 (could be up to 100,000,000)
),
d([date]) AS ( 
	SELECT TOP (DATEDIFF(DAY, @StartDate, @EndDate)) -- 365 for dates
		d = DATEADD(DAY, ROW_NUMBER() OVER (ORDER BY n) - 1, @StartDate) -- This adds a day for each row from the start date (starting at 0)
	FROM e4
)
SELECT [date] FROM [d]
;
GO

DROP TABLE IF EXISTS #DateTable;
GO
CREATE TABLE #DateTable ([Date] DATE);
GO

INSERT #DateTable EXEC dbo.GenerateDates '1988-01-01', '2024-07-29';
SELECT * FROM #DateTable
GO

DROP TABLE IF EXISTS #DateTable;
GO
