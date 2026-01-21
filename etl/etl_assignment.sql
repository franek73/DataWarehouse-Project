USE Kolejnictwo_Hurtownia;
GO

IF OBJECT_ID('ETLAssignment') IS NOT NULL
    DROP TABLE ETLAssignment;
GO

CREATE TABLE ETLAssignment (
    ID_Transport INT,
    ID_FreightCar INT
);
GO

INSERT INTO ETLAssignment (ID_Transport, ID_FreightCar)
SELECT
    TT.ID_Transport,
    FCT.ID_FreightCar
FROM Kolejnictwo.dbo.Freight_Car_Assignment AS FCAT
JOIN dbo.Transport_FT AS TT ON TT.ID_Transport = FCAT.TransportID
JOIN dbo.Freight_Car_DT AS FCT ON FCT.SerialNumber = FCAT.SerialNumber;
GO

MERGE INTO Freight_Car_Assignment_FT AS FT
USING ETLAssignment AS FD
    ON FT.ID_Transport = FD.ID_Transport
    AND FT.ID_FreightCar = FD.ID_FreightCar
WHEN NOT MATCHED THEN
    INSERT (ID_Transport, ID_FreightCar)
    VALUES (FD.ID_Transport, FD.ID_FreightCar);
GO

DROP TABLE ETLAssignment;
GO
