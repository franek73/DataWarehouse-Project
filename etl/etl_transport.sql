USE Kolejnictwo_Hurtownia
GO

IF OBJECT_ID('dbo.DelayTemp') IS NOT NULL DROP TABLE dbo.DelayTemp;
CREATE TABLE dbo.DelayTemp(
	ID int, 
	RealStartDate DATETIME,
	RealEndDate DATETIME,
	Delay INT,
	DelayReason VARCHAR(30));
GO

BULK INSERT dbo.DelayTemp
    FROM 'C:\Users\franc\Desktop\SEMESTR 5\Hurtownie danych\etl\transports.csv'
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
	)

If (OBJECT_ID('vETLData') is not null) Drop view vETLData;
go
CREATE VIEW vETLData
AS
SELECT
Transport_ID = TT.ID,
TotalWeight = SUM(LT1.Weight),
TotalCapacity = SUM(FCT.Capacity),
TotalCars = COUNT(DISTINCT FCT.SerialNumber)

FROM Kolejnictwo.dbo.Transport AS TT 
JOIN Kolejnictwo.dbo.Load AS LT1 ON LT1.TransportID = TT.ID
JOIN Kolejnictwo.dbo.Locomotive AS LT0 ON LT0.SerialNumber = TT.LocomotiveSN
JOIN Kolejnictwo.dbo.Freight_Car_Assignment AS FCAT ON TT.ID = FCAT.TransportID
JOIN Kolejnictwo.dbo.Freight_Car AS FCT ON FCAT.SerialNumber = FCT.SerialNumber
GROUP BY TT.ID
GO

SELECT TOP 100 * FROM vETLData;

IF OBJECT_ID('dbo.ETLData') IS NOT NULL
    DROP TABLE dbo.ETLData;
GO

CREATE TABLE dbo.ETLData (
    Transport_ID INT PRIMARY KEY,
    TotalWeight FLOAT,
    TotalCapacity FLOAT,
	TotalCars INT
);
GO

MERGE dbo.ETLData AS target
USING vETLData AS source
ON target.Transport_ID = source.Transport_ID
WHEN MATCHED THEN
    UPDATE SET
        target.TotalWeight = source.TotalWeight,
        target.TotalCapacity = source.TotalCapacity,
		target.TotalCars = source.TotalCars
WHEN NOT MATCHED BY TARGET THEN
    INSERT (Transport_ID, TotalWeight, TotalCapacity, TotalCars)
    VALUES (source.Transport_ID, source.TotalWeight, source.TotalCapacity, source.TotalCars);
GO

SELECT TOP 100 * FROM ETLData;

If (OBJECT_ID('vETLTransport') is not null) Drop view vETLTransport;
go
CREATE VIEW vETLTransport
AS
SELECT
	ID_Contract = CT.ID_Contract,
	ID_Locomotive = LT.ID_Locomotive,
	ID_StartStation = ST1.ID_Station,
	ID_EndStation = ST2.ID_Station,
	ID_StartDate = DT1.ID_Date,
	ID_EndDate = DT2.ID_Date,
	LocomotivePower = LT0.TowingCapacity,
	TotalWeight = DAT.TotalWeight,
	TotalCapacity = DAT.TotalCapacity,
	LocomotiveUsage = DAT.TotalCars / LT0.TowingCapacity,
	FreightCarsUsage = DAT.TotalWeight / DAT.TotalCapacity,
	Delay = DT0.Delay

		
FROM Kolejnictwo.dbo.Transport AS TT
JOIN dbo.Contract_DT_SCD2 AS CT ON TT.ContractID = CT.ID_Contract
JOIN dbo.Locomotive_DT AS LT ON TT.LocomotiveSN = LT.SerialNumber
JOIN dbo.Station_DT AS ST1 ON TT.StartStation = ST1.Name
JOIN dbo.Station_DT AS ST2 ON TT.EndStation = ST2.Name
JOIN Date_DT AS DT1 
ON CAST(TT.StartDate AS DATE) = CAST(
    CAST(DT1.Year AS VARCHAR(4)) + '-' +
    RIGHT('00' + CAST(DT1.MonthNumber AS VARCHAR(2)), 2) + '-' +
    RIGHT('00' + CAST(DT1.Day AS VARCHAR(2)), 2) AS DATE)
JOIN Date_DT AS DT2 
ON CAST(TT.EndDate AS DATE) = CAST(
    CAST(DT2.Year AS VARCHAR(4)) + '-' +
    RIGHT('00' + CAST(DT2.MonthNumber AS VARCHAR(2)), 2) + '-' +
    RIGHT('00' + CAST(DT2.Day AS VARCHAR(2)), 2) AS DATE)
JOIN Kolejnictwo.dbo.Locomotive AS LT0 ON LT.SerialNumber = LT0.SerialNumber
JOIN dbo.DelayTemp AS DT0 ON TT.ID = DT0.ID
JOIN dbo.ETLData AS DAT ON TT.ID = DAT.Transport_ID
GO

IF OBJECT_ID('dbo.ETLTransport', 'U') IS NOT NULL DROP TABLE dbo.ETLTransport;
GO

CREATE TABLE dbo.ETLTransport (
    ID_Contract INT NOT NULL,
    ID_Locomotive INT NOT NULL,
    ID_StartStation INT NOT NULL,
    ID_EndStation INT NOT NULL,
    ID_StartDate INT NOT NULL,
    ID_EndDate INT NOT NULL,
    LocomotivePower FLOAT NOT NULL,
    TotalWeight FLOAT NOT NULL,
    TotalCapacity FLOAT NOT NULL,
    LocomotiveUsage FLOAT NOT NULL,
    FreightCarsUsage FLOAT NOT NULL,
    Delay INT NOT NULL
);
GO

INSERT INTO dbo.ETLTransport (
    ID_Contract,
    ID_Locomotive,
    ID_StartStation,
    ID_EndStation,
    ID_StartDate,
    ID_EndDate,
    LocomotivePower,
    TotalWeight,
    TotalCapacity,
    LocomotiveUsage,
    FreightCarsUsage,
    Delay
)
SELECT
    ID_Contract,
    ID_Locomotive,
    ID_StartStation,
    ID_EndStation,
    ID_StartDate,
    ID_EndDate,
    LocomotivePower,
    TotalWeight,
    TotalCapacity,
    LocomotiveUsage,
    FreightCarsUsage,
    Delay
FROM vETLTransport;
GO



If (OBJECT_ID('vETLHelper') is not null) Drop view vETLHelper;
go
CREATE VIEW vETLHelper
AS
SELECT TT.*,
	ID_Junk = JT.ID_Junk

FROM ETLTransport AS TT
JOIN dbo.Junk_DT AS JT ON 
JT.FreightCarsUsageRange = CASE 
                    WHEN TT.FreightCarsUsage <= 0.25 THEN 'Bad'
                    WHEN TT.FreightCarsUsage <= 0.50 THEN 'Medium'
                    WHEN TT.FreightCarsUsage <= 0.75 THEN 'Good'
                    ELSE 'Great'
                END AND
JT.LocomotiveUsageRange = CASE 
                    WHEN TT.LocomotiveUsage <= 0.25 THEN 'Bad'
                    WHEN TT.LocomotiveUsage <= 0.50 THEN 'Medium'
                    WHEN TT.LocomotiveUsage  <= 0.75 THEN 'Good'
                    ELSE 'Great'
                END AND
JT.IsDelay = CASE
                    WHEN TT.Delay = 0 THEN '0'
                    ELSE '1'
                END AND
JT.DelayRange = CASE
                    WHEN TT.Delay = 0 THEN 'Zero'
                    WHEN TT.Delay = 1 THEN 'One'
                    ELSE 'More'
                END
GO

MERGE INTO Transport_FT AS TT
USING vETLHelper AS TD
    ON 	
        TT.ID_Contract = TD.ID_Contract
        AND TT.ID_Locomotive = TD.ID_Locomotive
        AND TT.ID_StartStation = TD.ID_StartStation
        AND TT.ID_EndStation = TD.ID_EndStation
        AND TT.ID_StartDate = TD.ID_StartDate
        AND TT.ID_EndDate = TD.ID_EndDate
        AND TT.ID_Junk = TD.ID_Junk
WHEN NOT MATCHED
    THEN
        INSERT (
             ID_Contract,
			 ID_Locomotive,
			 ID_StartStation,
			 ID_EndStation,
			 ID_StartDate,
			 ID_EndDate,
			 ID_Junk,
             Delay
            , LocomotivePower
            , TotalCapacity
            , TotalWeight
            , LocomotiveUsage
            , FreightCarsUsage
        )
        VALUES (
              TD.ID_Contract
            , TD.ID_Locomotive
            , TD.ID_StartStation
            , TD.ID_EndStation
            , TD.ID_StartDate
            , TD.ID_EndDate
            , TD.ID_Junk
            , TD.Delay
            , TD.LocomotivePower
            , TD.TotalCapacity
            , TD.TotalWeight
            , TD.LocomotiveUsage
            , TD.FreightCarsUsage
        );

DROP VIEW vETLHelper;

SELECT COUNT(*) FROM Transport_FT;