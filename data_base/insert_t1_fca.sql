USE Kolejnictwo;

BULK INSERT Freight_Car_Assignment
FROM 'C:\Users\franc\Desktop\SEMESTR 5\Hurtownie danych\data_base\freight_car_assignment_1.txt'
WITH (
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2 
);