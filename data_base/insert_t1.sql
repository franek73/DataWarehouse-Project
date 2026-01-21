USE Kolejnictwo;

BULK INSERT Cargo
FROM 'C:\Users\franc\Desktop\SEMESTR 5\Hurtownie danych\data_base\cargo_1.csv'
WITH (
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2 
);



CREATE TABLE ContractTemp (
  Com varchar (40) NOT NULL,
  NIP varchar (10) NOT NULL
);

BULK INSERT ContractTemp
FROM 'C:\Users\franc\Desktop\SEMESTR 5\Hurtownie danych\data_base\contract_1.csv'
WITH (
    FIELDTERMINATOR = ';',
	ROWTERMINATOR = '\n',
	FIRSTROW = 2
);

INSERT INTO Contract(Company, NIP)
SELECT Com, NIP
FROM ContractTemp;

DROP TABLE ContractTemp;




BULK INSERT Locomotive
FROM 'C:\Users\franc\Desktop\SEMESTR 5\Hurtownie danych\data_base\locomotive_1.csv'
WITH ( 
	FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2 
);

BULK INSERT Freight_Car
FROM 'C:\Users\franc\Desktop\SEMESTR 5\Hurtownie danych\data_base\freight_car_1.csv'
WITH ( 
	FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2 
);

BULK INSERT Load
FROM 'C:\Users\franc\Desktop\SEMESTR 5\Hurtownie danych\data_base\load_1.csv'
WITH ( 
	FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2 
);


CREATE TABLE TransportTemp (
  SD datetime NOT NULL,
  ED datetime NOT NULL,
  SS varchar (40) NOT NULL,
  ES varchar (40) NOT NULL,
  CID int NOT NULL,
  LSN int NOT NULL,
);

BULK INSERT TransportTemp
FROM 'C:\Users\franc\Desktop\SEMESTR 5\Hurtownie danych\data_base\transport_1.csv'
WITH (
    FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	FIRSTROW = 2
);


INSERT INTO Transport(StartDate, EndDate, StartStation, EndStation, ContractID, LocomotiveSN)
SELECT SD, ED, SS, ES, CID, LSN
FROM TransportTemp;

DROP TABLE TransportTemp;