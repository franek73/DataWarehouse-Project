use Kolejnictwo;

CREATE TABLE Locomotive (
  SerialNumber int NOT NULL UNIQUE,
  Type varchar(8) NOT NULL CHECK (Type IN ('Electric','Diesel','Hybrid')),
  Model varchar(40) NOT NULL,
  TowingCapacity int NOT NULL,
  PRIMARY KEY (SerialNumber)
);

CREATE TABLE Contract (
  ID int NOT NULL IDENTITY UNIQUE,
  Company varchar (40) NOT NULL,
  NIP varchar (10) NOT NULL,
  PRIMARY KEY (ID)
);

CREATE TABLE Transport (
  ID int NOT NULL IDENTITY UNIQUE,
  StartDate date NOT NULL,
  EndDate date NOT NULL,
  StartStation varchar (40) NOT NULL,
  EndStation varchar (40) NOT NULL,
  ContractID int NOT NULL,
  LocomotiveSN int NOT NULL,
  PRIMARY KEY (ID),
  FOREIGN KEY (ContractID) REFERENCES Contract(ID),
  FOREIGN KEY (LocomotiveSN) REFERENCES Locomotive(SerialNumber)
);

CREATE TABLE Cargo (
  Name varchar (30) NOT NULL UNIQUE,
  CargoGroup varchar (30) NOT NULL CHECK (CargoGroup in (
  'Raw Minerals', 
  'Agricultural', 'Automobiles', 
  'Intermodal Containers', 'Oil', 
  'Chemicals', 'Building Materials', 
  'Food', 'Forestry', 
  'Machinery', 'Metals',
  'Cement', 'Goods', 
  'Livestock', 'Electronics')),
  PRIMARY KEY (Name)
);

CREATE TABLE Load (
  CargoName varchar (30) NOT NULL,
  TransportID int NOT NULL,
  Weight int NOT NULL,
  PRIMARY KEY (CargoName, TransportID),
  FOREIGN KEY (CargoName) REFERENCES Cargo(Name),
  FOREIGN KEY (TransportID) REFERENCES Transport(ID)
);

CREATE TABLE Freight_Car (
  SerialNumber int NOT NULL UNIQUE,
  Model varchar (40) NOT NULL,
  Capacity int NOT NULL,
  CargoGroup varchar(30) NOT NULL CHECK (CargoGroup in (
  'Raw Minerals', 
  'Agricultural', 'Automobiles', 
  'Intermodal Containers', 'Oil', 
  'Chemicals', 'Building Materials', 
  'Food', 'Forestry', 
  'Machinery', 'Metals',
  'Cement', 'Goods', 
  'Livestock', 'Electronics')),
  PRIMARY KEY (SerialNumber)
);

CREATE TABLE Freight_Car_Assignment (
  TransportID int NOT NULL,
  SerialNumber int NOT NULL,
  PRIMARY KEY (SerialNumber, TransportID),
  FOREIGN KEY (SerialNumber) REFERENCES Freight_Car(SerialNumber),
  FOREIGN KEY (TransportID) REFERENCES Transport(ID)
);
