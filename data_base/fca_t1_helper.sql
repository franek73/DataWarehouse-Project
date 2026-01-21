use Kolejnictwo;

--T1
SELECT t.ID, c.CargoGroup
FROM Transport t
LEFT JOIN Load l
ON l.TransportID = t.ID
LEFT JOIN Cargo c
ON l.CargoName = c.Name
WHERE t.EndDate < '2024-01-01'
ORDER BY t.ID