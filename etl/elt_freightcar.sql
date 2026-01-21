USE Kolejnictwo_Hurtownia
GO

IF OBJECT_ID('vETLFreightCarData') IS NOT NULL 
    DROP VIEW vETLFreightCarData;
GO

CREATE VIEW vETLFreightCarData
AS
SELECT DISTINCT
    SerialNumber,
	CargoGroup
FROM Kolejnictwo.dbo.Freight_Car;
GO

MERGE INTO Freight_Car_DT AS FT
USING vETLFreightCarData AS FD
ON FT.SerialNumber = FD.SerialNumber
	AND FT.CargoGroup = FD.CargoGroup
WHEN NOT MATCHED THEN
    INSERT (SerialNumber, CargoGroup)
    VALUES (FD.SerialNumber, FD.CargoGroup)
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;
GO

DROP VIEW vETLFreightCarData;