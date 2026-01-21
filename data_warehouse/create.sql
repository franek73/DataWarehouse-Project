USE Kolejnictwo_Hurtownia;

CREATE TABLE Locomotive_DT (
  ID_Locomotive INT NOT NULL IDENTITY UNIQUE,
  SerialNumber VARCHAR(10) NOT NULL,
  Type VARCHAR(10) NOT NULL CHECK (Type IN ('Electric','Diesel','Hybrid')),
  Model VARCHAR(40) NOT NULL,
  IsCurrent BIT NOT NULL,
  PRIMARY KEY (ID_Locomotive)
);

CREATE TABLE Date_DT (
  ID_Date INT NOT NULL IDENTITY UNIQUE,
  Day VARCHAR(2) NOT NULL CHECK (Day BETWEEN '01' AND '31'),
  Year VARCHAR(4) NOT NULL CHECK (Year BETWEEN '1900' AND '2100'),
  Month VARCHAR(10) NOT NULL CHECK (Month IN ('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December')),
  MonthNumber INT NOT NULL CHECK (MonthNumber BETWEEN 1 AND 12),
  DayOfWeek VARCHAR(10) NOT NULL CHECK (DayOfWeek IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')),
  DayOfWeekNumber INT NOT NULL CHECK (DayOfWeekNumber BETWEEN 1 AND 7),
  Season VARCHAR(10) NOT NULL CHECK (Season IN ('Spring', 'Summer', 'Fall', 'Winter')),
  WorkingDay BIT NOT NULL,
  PRIMARY KEY (ID_Date)
);

CREATE TABLE Station_DT (
  ID_Station int NOT NULL IDENTITY UNIQUE,
  Name VARCHAR(100) NOT NULL,
  PRIMARY KEY (ID_Station)
);

CREATE TABLE Contract_DT_SCD2 (
  ID_Contract int NOT NULL IDENTITY UNIQUE,
  Company VARCHAR(40) NOT NULL,
  SignMonth VARCHAR(2) NOT NULL CHECK (SignMonth BETWEEN '01' AND '12'),
  SignYear VARCHAR(4) NOT NULL CHECK (SignYear BETWEEN '1900' AND '2100'),
  ExpirationMonth VARCHAR(2) NOT NULL CHECK (ExpirationMonth BETWEEN '01' AND '12'),
  ExpirationYear VARCHAR(4) NOT NULL CHECK (ExpirationYear BETWEEN '1900' AND '2100'),
  ContractLength VARCHAR(10) NOT NULL CHECK (ContractLength IN ('Short', 'Normal', 'Long', 'Extra long')),
  PRIMARY KEY (ID_Contract)
);

CREATE TABLE Junk_DT (
  ID_Junk int NOT NULL IDENTITY UNIQUE,
  IsDelay BIT NOT NULL,
  DelayRange VARCHAR(20) NOT NULL CHECK (DelayRange IN ('Zero','One', 'More')),
  LocomotiveUsageRange VARCHAR(20) NOT NULL CHECK (LocomotiveUsageRange IN ('Bad', 'Medium', 'Good', 'Great')),
  FreightCarsUsageRange VARCHAR(120) NOT NULL CHECK (FreightCarsUsageRange IN ('Bad', 'Medium', 'Good', 'Great')),
  PRIMARY KEY (ID_Junk),
  CONSTRAINT J_IDLF UNIQUE (IsDelay, DelayRange, LocomotiveUsageRange, FreightCarsUsageRange)
);

CREATE TABLE Transport_FT (
  ID_Transport int NOT NULL IDENTITY UNIQUE,
  ID_Contract int NOT NULL,
  ID_Locomotive int NOT NULL,
  ID_StartStation int NOT NULL,
  ID_EndStation int NOT NULL,
  ID_StartDate int NOT NULL,
  ID_EndDate int NOT NULL,
  ID_Junk int NOT NULL,
  Delay INT NOT NULL,
  LocomotivePower INT NOT NULL,
  TotalCapacity INT NOT NULL,
  TotalWeight INT NOT NULL,
  LocomotiveUsage FLOAT NOT NULL,
  FreightCarsUsage FLOAT NOT NULL,
  PRIMARY KEY (ID_Transport),
  FOREIGN KEY (ID_EndDate) REFERENCES Date_DT(ID_Date),
  FOREIGN KEY (ID_Locomotive) REFERENCES Locomotive_DT(ID_Locomotive),
  FOREIGN KEY (ID_EndStation) REFERENCES Station_DT(ID_Station),
  FOREIGN KEY (ID_StartStation) REFERENCES Station_DT(ID_Station),
  FOREIGN KEY (ID_StartDate) REFERENCES Date_DT(ID_Date),
  FOREIGN KEY (ID_Contract) REFERENCES Contract_DT_SCD2(ID_Contract),
  FOREIGN KEY (ID_Junk) REFERENCES Junk_DT(ID_Junk)
);

CREATE TABLE Freight_Car_DT (
  ID_FreightCar int NOT NULL IDENTITY UNIQUE,
  SerialNumber VARCHAR(20) NOT NULL,
  CargoGroup VARCHAR(30) NOT NULL CHECK (CargoGroup in (
  'Raw Minerals', 
  'Agricultural', 'Automobiles', 
  'Intermodal Containers', 'Oil', 
  'Chemicals', 'Building Materials', 
  'Food', 'Forestry', 
  'Machinery', 'Metals',
  'Cement', 'Goods', 
  'Livestock', 'Electronics')),
  PRIMARY KEY (ID_FreightCar)
);

CREATE TABLE Freight_Car_Assignment_FT (
  ID_Transport int NOT NULL,
  ID_FreightCar int NOT NULL,
  FOREIGN KEY (ID_Transport) REFERENCES Transport_FT(ID_Transport),
  FOREIGN KEY (ID_FreightCar) REFERENCES Freight_Car_DT(ID_FreightCar),
  PRIMARY KEY (ID_Transport, ID_FreightCar)
);