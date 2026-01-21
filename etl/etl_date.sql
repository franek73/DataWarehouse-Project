USE Kolejnictwo_Hurtownia;

DECLARE @StartDate date;
DECLARE @EndDate date;
DECLARE @DateInProcess date;

SELECT @StartDate = '2019-01-01', @EndDate = '2099-12-31';

SET @DateInProcess = @StartDate;

WHILE @DateInProcess <= @EndDate
BEGIN
    INSERT INTO [dbo].[Date_DT] 
    ( 
        [Day],
        [Year],
        [Month],
        [MonthNumber],
        [DayOfWeek],
        [DayOfWeekNumber],
        [WorkingDay],
        [Season]
    )
    VALUES ( 
        RIGHT('0' + CAST(DAY(@DateInProcess) AS VARCHAR(2)), 2),
        CAST(YEAR(@DateInProcess) AS VARCHAR(4)),
        CAST(DATENAME(MONTH, @DateInProcess) AS VARCHAR(10)),
        CAST(MONTH(@DateInProcess) AS INT),
        CAST(DATENAME(DW, @DateInProcess) AS VARCHAR(15)),
        CAST(DATEPART(DW, @DateInProcess) AS INT),
        CASE
            WHEN DATEPART(DW, @DateInProcess) = 1 THEN '0'
            ELSE '1'
        END,
        CASE
            WHEN MONTH(@DateInProcess) IN (3, 4, 5) THEN 'Spring'
            WHEN MONTH(@DateInProcess) IN (6, 7, 8) THEN 'Summer'
            WHEN MONTH(@DateInProcess) IN (9, 10, 11) THEN 'Fall'
            ELSE 'Winter'
        END
    );

    SET @DateInProcess = DATEADD(DAY, 1, @DateInProcess);
END
