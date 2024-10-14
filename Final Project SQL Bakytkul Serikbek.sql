USE Final_Project_SQL;



create table Customers
(
	ID_client INT PRIMARY KEY,
    Total_amount INT,
    Gender	VARCHAR (30),
    Age	INT NULL,
    Count_city INT,
	Response_communcation INT,
	Communication_3month INT,
	Tenure INT
);

DROP TABLE IF EXISTS Customers;

DROP TABLE IF EXISTS Transactions;

CREATE TABLE Transactions
(
	Data_new DATE,
    ID_check INT,
    ID_client INT,
    Count_products DECIMAL (10, 2),
    Sum_payment DECIMAL(10, 3), 
    FOREIGN KEY (ID_client) REFERENCES Customers(ID_client)
);


