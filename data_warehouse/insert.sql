USE Kolejnictwo_Hurtownia;

INSERT INTO Locomotive_DT (SerialNumber, Type, Model)
VALUES 
('SN1001', 'Electric', 'Model A1'),
('SN2002', 'Diesel', 'Model B2'),
('SN3003', 'Hybrid', 'Model C3');

INSERT INTO Date_DT (Day, Year, Month, MonthNumber, DayOfWeek, DayOfWeekNumber, Season, WorkingDay)
VALUES 
('01', '2023', 'January', 1, 'Monday', 1, 'Winter', 1),
('15', '2024', 'July', 7, 'Saturday', 6, 'Summer', 0),
('30', '2024', 'December', 12, 'Monday', 1, 'Winter', 1);

INSERT INTO Station_DT (Name)
VALUES 
('Warsaw Central Station'),
('Krakow Main Station'),
('Gdansk Glowny Station');

INSERT INTO Junk_DT (IsDelay, DelayRange, LocomotiveUsageRange, FreightCarsUsageRange)
VALUES 
(1, 'One', 'Medium', 'Good'),
(0, 'More', 'Great', 'Great'),
(1, 'One', 'Bad', 'Medium');

INSERT INTO Contract_DT_SCD2 (Company, SignMonth, SignYear, ExpirationMonth, ExpirationYear, ContractLength, IsCurrent)
VALUES 
('PKP Cargo', '01', '2023', '12', '2025', 'Normal', 1),
('DB Schenker', '05', '2021', '04', '2024', 'Long', 1),
('Freightliner', '08', '2022', '07', '2026', 'Short', 1);

INSERT INTO Transport_FT (ID_Contract, ID_Locomotive, ID_StartStation, ID_EndStation, ID_StartDate, ID_EndDate, ID_Junk, Delay, LocomotivePower, TotalCapacity, TotalWeight, LocomotiveUsage, FreightCarsUsage)
VALUES 
(1, 1, 1, 2, 1, 2, 1, 15, 4000, 200, 10000, 0.85, 0.75),
(2, 2, 2, 3, 2, 3, 2, 5, 3000, 150, 8000, 0.70, 0.60),
(3, 3, 1, 3, 1, 3, 3, 0, 4500, 250, 12000, 0.90, 0.80);

INSERT INTO Freight_Car_DT (SerialNumber, CargoGroup)
VALUES 
('FC1001', 'Raw Minerals'),
('FC2002', 'Agricultural'),
('FC3003', 'Oil');

INSERT INTO Freight_Car_Assignment_FT (ID_Transport, ID_FreightCar)
VALUES 
(1, 1),
(2, 2),
(3, 3);
