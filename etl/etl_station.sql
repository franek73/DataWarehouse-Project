USE Kolejnictwo_Hurtownia
GO

IF OBJECT_ID('vETLStationData') IS NOT NULL 
    DROP VIEW vETLStationData;
GO

CREATE VIEW vETLStationData
AS
SELECT DISTINCT
    StartStation AS Name
FROM Kolejnictwo.dbo.Transport
UNION
SELECT DISTINCT
    EndStation AS Name
FROM Kolejnictwo.dbo.Transport;
GO

MERGE INTO Station_DT AS ST
USING vETLStationData AS SD
ON ST.Name = SD.Name
WHEN NOT MATCHED THEN
    INSERT (Name)
    VALUES (SD.Name)
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;
GO

DROP VIEW vETLStationData;