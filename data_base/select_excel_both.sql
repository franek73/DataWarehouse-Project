USE Kolejnictwo
------T1 and T2

--Companies
SELECT 
    C.ID, C.Company, 
    COUNT(T.ID) AS TransportCount
FROM 
    Contract C 
LEFT JOIN 
    Transport T 
ON 
    C.ID = T.ContractID
GROUP BY 
    C.ID, C.Company
ORDER BY 
    C.ID;

--Companies transports
SELECT  
	CAST(MIN(StartDate) AS DATE) AS FirstTransport,
	CAST(MAX(EndDate) AS DATE) AS LastTransport
FROM
	Transport
GROUP BY
	ContractID
ORDER BY 
	ContractID



--Transports
SELECT
	ID,
	CAST(StartDate AS DATE) AS PlannedStart,
	Cast(EndDate AS DATE) AS PlannedEnd
FROM
	Transport
ORDER BY
	ID
	