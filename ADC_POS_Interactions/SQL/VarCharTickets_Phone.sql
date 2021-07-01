--  Must add RFID to the all customer and garment tables due to Scanner and scan garm information.
-- Must build GUI through Visual Studio to insert the customer create information to use the POS scan in to each table.
-- Customer and Garm Create options / modifications should be able to be done using the GUI.
-- Just Click Execute or CRTL+E
USE master
GO

IF DB_ID('SUVOAS') IS NOT NULL
	DROP DATABASE SUVOASadc

CREATE DATABASE SUVOASadc
GO

USE SUVOAS
GO

/* dont use 
sp_configure 'nested_triggers', 1
GO

RECONFIGURE
GO

ALTER DATABASE SUVOAS
SET RECURSIVE_TRIGGERS ON
*/

-- Below are tables needed to send info back to 
-- POS via text file
-- SUVOAS.txt

CREATE TABLE GarmentLoaded(
	TransactionType VARCHAR(20) NOT NULL -- Garment_Loaded
	, AccountNumber INT NOT NULL
	, Phone VARCHAR(10) NULL 
	, Pin_Number VARCHAR(6) NULL
	, TicketNumber VARCHAR(15) NOT NULL
	, GarmentNumber INT NOT NULL
	, SlotNumber INT NOT NULL
	, RFID_BARCODE INT NOT NULL
	, GarmLoaded VARCHAR(MAX) NULL
	, TotalComplete INT
	, TotalOnTicket INT
	, TicketSplitChoice INT 
	, TransactionDate VARCHAR(10) 
	, TransactionTime VARCHAR(10)
	, FullDate SMALLDATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE GarmentUnloaded(
	TransactionType VARCHAR(20) NOT NULL -- Garment_Unloaded
	, AccountNumber INT NOT NULL
	, Phone VARCHAR(10) NULL 
	, Pin_Number VARCHAR(6) NULL
	, TicketNumber VARCHAR(15) NOT NULL
	, GarmentNumber INT NOT NULL
	, SlotNumber INT NOT NULL
	, RFID_BARCODE INT NOT NULL
	, GarmLoaded VARCHAR(MAX) NULL
	, TotalComplete INT
	, TotalOnTicket INT
	, TicketSplitChoice INT 
	, TransactionDate VARCHAR(10) 
	, TransactionTime VARCHAR(10)  
	, FullDate SMALLDATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE TicketComplete(
	TransactionType VARCHAR(20) NOT NULL -- Ticket_Complete
	, AccountNumber INT NOT NULL
	, Phone VARCHAR(10) NULL 
	, Pin_Number VARCHAR(6) NULL
	, TicketNumber VARCHAR(15) NOT NULL
	, GarmentNumber INT NOT NULL
	, TransactionDate VARCHAR(10) 
	, TransactionTime VARCHAR(10) 
	, FullDate SMALLDATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE ReceiptPrint(
	TransactionType VARCHAR(20) NOT NULL -- Receipt_Print
	, AccountNumber INT NOT NULL
	, Phone VARCHAR(10) NULL 
	, Pin_Number VARCHAR(6) NULL
	, TicketNumber VARCHAR(15) NOT NULL
	, GarmentNumber INT NOT NULL
	, TransactionDate VARCHAR(10)
	, TransactionTime VARCHAR(10)
	, FullDate SMALLDATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Information compiled from tables to save for WCI records as a .txt file
CREATE TABLE CombinedTables(
	TransactionType VARCHAR(20) -- Keeps Transaction Name from which ever table it came from
	, AccountNumber INT
	, Phone VARCHAR(10) NULL 
	, Pin_Number VARCHAR(6) NULL
	, TicketNumber VARCHAR(15)
	, OriginalTicketNumber INT NULL
	, TicketSplitNumber INT NULL
	, GarmentNumber INT
	, SlotNumber VARCHAR(10)
	, RFID_BARCODE INT NULL
	, TicketMessage VARCHAR(MAX)
	, TransactionDate VARCHAR(10) -- Date Loaded
	, TransactionTime VARCHAR(10) -- Time Loaded
	, SQLTransactionDate DATE  DEFAULT CURRENT_TIMESTAMP NOT NULL
	, SQLTransactionTime TIME(0) DEFAULT CURRENT_TIMESTAMP NOT NULL
	, FullDate SMALLDATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Customer Tables -- 

CREATE TABLE CustomerCreate(
	TransactionType VARCHAR(MAX)
	, AccountNumber INT NOT NULL
	, Phone VARCHAR(10) NULL 
	, Pin_Number VARCHAR(6) NULL
	, LastName VARCHAR(MAX) NOT NULL 
	, FirstName VARCHAR(MAX) NOT NULL 
	, Address VARCHAR(100) NULL
	, Address2 VARCHAR(100) NULL
	, City VARCHAR(MAX) NULL 
	, State CHAR(3) NULL 
	, ZipCode VARCHAR(MAX) NULL 
	, TransactionDate DATE NOT NULL 
	, TransactionTime TIME(0) NOT NULL
	, FullDate SMALLDATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
	);

CREATE TABLE CustomerModify(
	TransactionType VARCHAR(MAX)
	, AccountNumber INT NOT NULL
	, Phone VARCHAR(10) NULL 
	, Pin_Number VARCHAR(6) NULL
	, LastName VARCHAR(MAX) NOT NULL 
	, FirstName VARCHAR(MAX) NOT NULL 
	, Address VARCHAR(60) NULL
	, Address2 VARCHAR(60) NULL
	, City VARCHAR(MAX) NULL 
	, State CHAR(3) NULL 
	, ZipCode VARCHAR(MAX) NULL 
	, TransactionDate DATE NOT NULL 
	, TransactionTime TIME(0) NOT NULL
	);

CREATE TABLE CustomerDelete(
	AccountNumber INT
	, TransactionDate DATE
	, TransactionTime TIME(0)
);

-- Ticket Tables --

CREATE TABLE TicketCreate(
	TransactionType VARCHAR(MAX)
	, AccountNumber INT NOT NULL
	, Phone VARCHAR(10) NULL 
	, Pin_Number VARCHAR(6) NULL
	, TicketNumber VARCHAR(15) NOT NULL 
	, PickupDate DATE NULL
	, PickupTime TIME(0) NULL
	, PlantID INT NULL
	, RouteID INT NULL
	, StoreID INT NULL
	, TransactionDate DATE NOT NULL 
	, TransactionTime TIME(0) NOT NULL
	, FullDate SMALLDATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE TicketModify(
	TransactionType VARCHAR(MAX)
	, AccountNumber INT NOT NULL
	, Phone VARCHAR(10) NULL 
	, Pin_Number VARCHAR(6) NULL
	, TicketNumber VARCHAR(15) NOT NULL 
	, PickupDate DATE NULL
	, PickupTime TIME(0) NULL
	, PlantID INT NULL
	, RouteID INT NULL
	, StoreID INT NULL
	, TransactionDate DATE NOT NULL 
	, TransactionTime TIME(0) NOT NULL
	, FullDate SMALLDATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
	);

CREATE TABLE TicketDelete(
	AccountNumber INT NOT NULL
	, TicketNumber VARCHAR(15) NOT NULL
	, TransactionDate DATE
	, TransactionTime TIME(0)
);

CREATE TABLE TicketClosed(
	AccountNumber INT
	, TicketNumber VARCHAR(15)
	, TransactionDate DATE
	, TransactionTime TIME
);


-- Garment Create --

CREATE TABLE GarmentCreate(
	TransactionType VARCHAR(MAX)
	, AccountNumber INT NOT NULL 
	, Phone VARCHAR(10) NULL 
	, Pin_Number VARCHAR(6) NULL
	, TicketNumber VARCHAR(15) NOT NULL 
	, GarmentNumber INT NOT NULL 
	, GarmDescription VARCHAR(MAX) NULL
	, ServicePrice VARCHAR NULL
	, ServiceType VARCHAR(MAX) NULL
	, GarmType VARCHAR(50) NULL
	, GarmColor VARCHAR(10) NULL
	, GarmFabric VARCHAR(50) NULL
	, TransactionDate DATE NOT NULL 
	, TransactionTime TIME(0) NOT NULL 
	, FullDate SMALLDATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
	);


CREATE TABLE GarmentModify(
	TransactionType VARCHAR(MAX)
	, AccountNumber INT NOT NULL 
	, Phone VARCHAR(10) NULL 
	, Pin_Number VARCHAR(6) NULL
	, TicketNumber VARCHAR(15) NOT NULL 
	, GarmentNumber INT NOT NULL 
	, GarmDescription VARCHAR(MAX) NULL
	, ServicePrice VARCHAR NULL
	, ServiceType VARCHAR(MAX) NULL
	, GarmType VARCHAR(50) NULL
	, GarmColor VARCHAR(10) NULL
	, GarmFabric VARCHAR(50) NULL
	, TransactionDate DATE NOT NULL 
	, TransactionTime TIME(0) NOT NULL
	, FullDate SMALLDATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
	);

CREATE TABLE GarmentDelete(
	AccountNumber INT NOT NULL
	, TicketNumber VARCHAR(15) NOT NULL
	, GarmentNumber INT NOT NULL
	, TransactionDate DATE
	, TransactionTime TIME(0)
);

CREATE TABLE GarmentClosed(
	AccountNumber INT
	, TicketNumber VARCHAR(15)
	, GarmentNumber INT
	, TransactionDate DATE
	, TransactionTime TIME
	);

-- Backup info for a few days incase of lost/missing data
CREATE TABLE CusTicGarmHistory(
	TransactionType VARCHAR(MAX) NULL
	, AccountNumber INT NULL
	, Phone VARCHAR(10) NULL 
	, Pin_Number VARCHAR(6) NULL
	, TicketNumber VARCHAR(15) NULL
	, OriginalTicketNumber VARCHAR(15) NULL
	, TicketSplitNumber INT NULL
	, GarmentNumber INT NULL
	, LastName VARCHAR(MAX) NULL
	, FirstName VARCHAR(MAX) NULL
	, Address VARCHAR(MAX) NULL
	, Address2 VARCHAR(MAX) NULL
	, City VARCHAR(MAX) NULL 
	, State CHAR(3) NULL 
	, ZipCode VARCHAR(MAX) NULL 
	, PickupDate DATE NULL
	, PickupTime TIME(0) NULL
	, PlantID INT NULL
	, RouteID INT NULL
	, StoreID INT NULL
	, GarmDescription VARCHAR(MAX) NULL
	, ServicePrice VARCHAR NULL
	, ServiceType VARCHAR(MAX) NULL
	, GarmType VARCHAR(50) NULL
	, GarmColor VARCHAR(10) NULL
	, GarmFabric VARCHAR(50) NULL
	, TransactionDate DATE NULL
	, TransactionTime TIME(0) NULL
);

-- Store and Route Information (may or may not be needed from customer/pos)

CREATE TABLE StoreCreate(
	StoreID INT NOT NULL
	, PhoneNumber VARCHAR(10)
	, Address VARCHAR(60)
	, Address2 VARCHAR(20)
	, City VARCHAR(MAX) NULL 
	, State CHAR(3) NULL 
	, ZipCode VARCHAR(MAX) NULL 
	, TransactionDate DATE NOT NULL 
	, TransactionTime TIME(0) NOT NULL
);

CREATE TABLE StoreModify(
	StoreID INT NOT NULL
	, PhoneNumber VARCHAR(10)
	, Address VARCHAR(60)
	, Address2 VARCHAR(20)
	, City VARCHAR(MAX) NULL 
	, State CHAR(3) NULL 
	, ZipCode VARCHAR(MAX) NULL 
	, TransactionDate DATE NOT NULL 
	, TransactionTime TIME(0) NOT NULL
);

CREATE TABLE StoreDelete(
	StoreID INT NOT NULL
	, TransactionDate DATE NOT NULL
	, TransactionTime TIME(0) NOT NULL
);

CREATE TABLE RouteCreate(
	RouteID INT NOT NULL
	, PhoneNumber VARCHAR(10)
	, Address VARCHAR(60)
	, Address2 VARCHAR(20)
	, City VARCHAR(MAX) NULL 
	, State CHAR(3) NULL 
	, ZipCode VARCHAR(MAX) NULL 
	, TransactionDate DATE NOT NULL 
	, TransactionTime TIME(0) NOT NULL
);

CREATE TABLE RouteModify(
	RouteID INT NOT NULL
	, PhoneNumber VARCHAR(10)
	, Address VARCHAR(60)
	, Address2 VARCHAR(20)
	, City VARCHAR(MAX) NULL 
	, State CHAR(3) NULL 
	, ZipCode VARCHAR(MAX) NULL 
	, TransactionDate DATE NOT NULL 
	, TransactionTime TIME(0) NOT NULL
);

CREATE TABLE RouteDelete(
	RouteID INT NOT NULL
	, TransactionDate DATE NOT NULL
	, TransactionTime TIME(0) NOT NULL
);

-- ScanGarm holds all important information pulled
-- from POS data passed through from the text file.
-- ScanGarm will be updated constantly by VD until the ticket is complete
CREATE TABLE ScanGarm(
	AccountNumber INT NULL
	, Phone VARCHAR(10) NULL 
	, Pin_Number VARCHAR(6) NULL
	, GarmentNumber INT
	, TicketNumber VARCHAR(15) NULL
	, OriginalTicketNumber VARCHAR(15) NULL
	, TicketSplitNumber INT NULL
	, GarmentDescription VARCHAR(MAX) NULL
	, TransactionDate DATE NULL
	, TransactionTime TIME(0) NULL
	, SlotNum INT NULL -- VD
	, RFID_BARCODE INT NULL -- VD
	, GarmLoaded VARCHAR(MAX) NULL -- VD
	, GarmUnloaded VARCHAR(MAX) NULL -- VD
	, PickupDate DATE NULL
	, PickupTime TIME(0) NULL
	, PlantID INT NULL
	, RouteID INT NULL
	, StoreID INT NULL
	, TotalOnTicket INT
	, TotalComplete INT
	, TotalRemaining INT
	, TotalDaysAged INT
	, TicketSplitChoice INT -- User input in VisD to determine # to split
);

-- This will hold a backup of all info for scanned garms
-- Once "GarmUnloaded" is triggered, deletes from ScanGarm
-- And data only remains in ScanHistory for 7 days
-- or whatever timeframe is allotted
CREATE TABLE ScanHistory(
	AccountNumber INT NULL
	, GarmentNumber INT
	, TicketNumber VARCHAR(15) NULL
	, OriginalTicketNumber VARCHAR(15) NULL
	, TicketSplitNumber INT NULL
	, SlotNum INT NULL -- VD
	, RFID_BARCODE INT NULL -- VD
	, GarmLoaded VARCHAR(MAX) NULL
	, GarmUnloaded VARCHAR(MAX) NULL
	);

-- Tables Needed For Visual Designer -- 
CREATE TABLE Inventory(	
	CustomerName VARCHAR(MAX)
	, CustomerID INT
	, TicketNumber VARCHAR(15)
	, OriginalTicketNumber VARCHAR(15) NULL
	, TicketSplitNumber INT NULL
	, GarmentNumber INT
	, GarmentDesc VARCHAR(MAX)
	, SlotNumber INT
	, TotalRemaining INT
	, TotalOnTicket INT
);

-- History table info that is pulled in VD
-- History table will show data for garms/ticks
-- up to 14 days after transaction 
CREATE TABLE History(
	GarmentNumber INT
	, TicketNumber VARCHAR(15)
	, OriginalTicketNumber VARCHAR(15) NULL
	, TicketSplitNumber INT NULL
	, AccountNumber INT
	, DateLoaded VARCHAR(MAX) 
	, DateUnloaded VARCHAR(MAX) 
	, PickupDate DATE 
	, TotalDaysAged INT
);

CREATE TABLE TicketTable(
	TicketNumber VARCHAR(15)
	, GarmentNumber INT
	, TotalOnTicket INT
	, OriginalTicketNumber VARCHAR(15) NULL
	, TicketSplitNumber INT NULL
	, AccountNumber INT
	, DropoffDate DATE
	, PickupDate DATE
	, PlantID INT
	, RouteID INT
	, StoreID INT
);

----- Ticket Splitting Tables -----

CREATE TABLE TicketSplit(
	TransactionType VARCHAR(20)  -- Ticket_Split
	, AccountNumber VARCHAR(MAX) NOT NULL
	, TicketNumber VARCHAR(15) NOT NULL
	, GarmentNumber VARCHAR(MAX) NOT NULL
	, TicketSplitNumber VARCHAR(15) -- Only needed if we are the ones assigning new number
	, TicketMessage VARCHAR  NULL -- Explanation why ticket is split
	, TransactionDate VARCHAR(10) 
	, TransactionTime VARCHAR(10)
	, FullDate SMALLDATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
);


-- Table used in response to a Ticket Split transaction 
-- POS updates this table for us
-- WC then takes info and places it ito ScanGarm with newly updated ticket number 
CREATE TABLE TicketReissue(
	TransactionType VARCHAR(20)
	, AccountNumber VARCHAR(MAX)
	, OldTicketNumber VARCHAR(15)
	, NewTicketNumber VARCHAR(15)
	, GarmentNumber VARCHAR(MAX)
	, TransactionDate DATE
	, TransactionTime TIME(0)
	, FullDate SMALLDATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
);


CREATE TABLE RFIDscan(
	TransactionType VARCHAR(MAX)
	, EmployeeID VARCHAR(MAX) NULL	
	, RFID_EPC int NOT NULL
	, TransactionTime TIME(0)
	, TransactionDate DATE
	, RFIDlocation int
	, Location VARCHAR(MAX)
	);





-- For location, Upon reading the readers in each loaction will give a number value, from there the SQL DB will auto in the location and update each transfer.

/*CREATE TRIGGER ItemLocation
	ON RFIDscan
AFTER UPDATE, INSERT, DELETE
AS
BEGIN
	IF
		RFIDlocation = 0
	THEN
		Location = 'New item to be assigned.'

	ELSE IF
		RFIDlocation = 1
	THEN
		Location = 'On conveyor.'
	
	ELSE IF
		RFIDlocation = 2
	THEN
		Location = 'Employee has the garments.'

	ELSE IF
		RFIDlocation = 3
	THEN
		Location = 'Item has been dropped in the chute and is dirty.'

	ELSE IF
		RFIDlocation = 4
	THEN
		LOcation = 'Items are clean and ready to be hung."

END