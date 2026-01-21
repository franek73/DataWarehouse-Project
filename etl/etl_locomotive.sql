USE Kolejnictwo_Hurtownia
GO

IF OBJECT_ID('vETLLocomotiveData') IS NOT NULL 
    DROP VIEW vETLLocomotiveData;
GO

CREATE VIEW vETLLocomotiveData
AS
SELECT DISTINCT
    SerialNumber,
	Type,
	Model
FROM Kolejnictwo.dbo.Locomotive;
GO

MERGE INTO Locomotive_DT AS LT
USING vETLLocomotiveData AS LD
ON LT.SerialNumber = LD.SerialNumber
WHEN NOT MATCHED THEN
    INSERT VALUES (LD.SerialNumber, LD.Type, LD.Model, 1)
	WHEN Matched AND (LT.Type <> LD.Type)
			THEN
				UPDATE
				SET LT.IsCurrent = 0
			WHEN Not Matched BY Source
			AND LT.SerialNumber != 'UNKNOWN'
			THEN
				UPDATE
				SET LT.IsCurrent = 0;
GO

INSERT INTO Locomotive_DT(
	 SerialNumber,
	Type,
	Model,
	IsCurrent
	)
	SELECT 
		SerialNumber,
		Type,
		Model,
		1
	FROM vETLLocomotiveData
	EXCEPT
	SELECT 
		SerialNumber,
		Type,
		Model,
		1
	FROM Locomotive_DT;


DROP VIEW vETLLocomotiveData;