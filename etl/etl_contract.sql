USE Kolejnictwo_Hurtownia
GO

IF OBJECT_ID('dbo.ContractTemp') IS NOT NULL DROP TABLE dbo.ContractTemp;
CREATE TABLE dbo.ContractTemp(
	ID INT, 
	Company VARCHAR(40), 
	TotalTranportCount INT,
	SignDate DATETIME,
	ExpirationDate DATETIME);
GO

BULK INSERT dbo.ContractTemp
    FROM 'C:\Users\franc\Desktop\SEMESTR 5\Hurtownie danych\etl\contracts.csv'
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
	)

IF OBJECT_ID('vETLContractData') IS NOT NULL 
    DROP VIEW vETLContractData;
GO

CREATE VIEW dbo.vETLContractData AS
SELECT  
    Company, 
    RIGHT('0' + CAST(MONTH(SignDate) AS VARCHAR(2)), 2) AS SignMonth,
    CAST(YEAR(SignDate) AS VARCHAR(4)) AS SignYear,
    RIGHT('0' + CAST(MONTH(ExpirationDate) AS VARCHAR(2)), 2) AS ExpirationMonth,
    CAST(YEAR(ExpirationDate) AS VARCHAR(4)) AS ExpirationYear,
    CASE 
        WHEN DATEDIFF(MONTH, SignDate, ExpirationDate) <= 3 THEN 'Short'
        WHEN DATEDIFF(MONTH, SignDate, ExpirationDate) BETWEEN 4 AND 6 THEN 'Normal'
        WHEN DATEDIFF(MONTH, SignDate, ExpirationDate) BETWEEN 8 AND 12 THEN 'Long'
        ELSE 'Extra long'
    END AS ContractLength
FROM dbo.ContractTemp;
GO

MERGE INTO Contract_DT_SCD2 as CT
	USING vETLContractData as CD
		ON CT.Company = CD.Company
		AND CT.SignMonth = CD.SignMonth
		AND CT.SignYear = CD.SignYear
		AND CT.ExpirationMonth = CD.ExpirationMonth
		AND CT.ExpirationYear = CD.ExpirationYear
		AND CT.ContractLength = CD.ContractLength			
		WHEN Not Matched
				THEN
					INSERT Values (
					CD.Company,
					CD.SignMonth,
					CD.SignYear,
					CD.ExpirationMonth,
					CD.ExpirationYear,
					CD.ContractLength);
GO

DROP VIEW vETLContractData;