------  Must add RFID to the all customer and garment tables due to Scanner and scan garm information.
-- Must build GUI through Visual Studio to insert the customer create information to use the POS scan in to each table.
-- Customer and Garm Create options / modifications should be able to be done using the GUI.
-- Just Click Execute or CRTL+E
USE master
GO

IF DB_ID('ADC') IS NOT NULL
	DROP DATABASE ADC

CREATE DATABASE ADC
GO

USE ADC
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
	, AccountNumber VARCHAR(MAX) NOT NULL        -- Phone Number in ADC
	, TicketNumber VARCHAR(MAX) NOT NULL
	, GarmentNumber VARCHAR(MAX) NOT NULL
	, SlotNumber INT NOT NULL
	, RFID_BARCODE INT NOT NULL
	, TransactionDate VARCHAR(10) 
	, TransactionTime VARCHAR(10)
	, FullDate SMALLDATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
)

CREATE TABLE GarmentUnloaded(
	TransactionType VARCHAR(20) NOT NULL -- Garment_Unloaded
	, AccountNumber VARCHAR(MAX) NOT NULL     -- Phone Number in ADC
	, TicketNumber VARCHAR(MAX) NOT NULL
	, GarmentNumber VARCHAR(MAX) NOT NULL
	, SlotNumber INT NOT NULL
	, RFID_BARCODE INT NOT NULL
	, TransactionDate VARCHAR(10) 
	, TransactionTime VARCHAR(10)  
	, FullDate SMALLDATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
)

CREATE TABLE TicketComplete(
	TransactionType VARCHAR(20) NOT NULL -- Ticket_Complete
	, AccountNumber VARCHAR(MAX) NOT NULL      -- Phone Number in ADC
	, TicketNumber VARCHAR(MAX) NOT NULL
	, GarmentNumber VARCHAR(MAX) NOT NULL
	, TransactionDate VARCHAR(10) 
	, TransactionTime VARCHAR(10) 
	, FullDate SMALLDATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
)

CREATE TABLE ReceiptPrint(
	TransactionType VARCHAR(20) NOT NULL -- Receipt_Print
	, AccountNumber VARCHAR(MAX) NOT NULL       -- Phone Number in ADC
	, TicketNumber VARCHAR(MAX) NOT NULL
	, GarmentNumber VARCHAR(MAX) NOT NULL
	, TransactionDate VARCHAR(10)
	, TransactionTime VARCHAR(10)
	, FullDate SMALLDATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
)

-- Information compiled from tables to save for WCI records as a .txt file
CREATE TABLE CombinedTables(
	TransactionType VARCHAR(20) -- Keeps Transaction Name from which ever table it came from
	, AccountNumber VARCHAR(MAX)              -- Phone Number in ADC
	, TicketNumber VARCHAR(MAX)
	, OriginalTicketNumber VARCHAR(MAX) NULL
	, TicketSplitNumber VARCHAR(MAX) NULL
	, GarmentNumber VARCHAR(MAX)
	, SlotNumber VARCHAR(10)
	, RFID_BARCODE INT NULL
	, TicketMessage VARCHAR(MAX)
	, TransactionDate VARCHAR(10) -- Date Loaded
	, TransactionTime VARCHAR(10) -- Time Loaded
	, SQLTransactionDate DATE  DEFAULT CURRENT_TIMESTAMP NOT NULL
	, SQLTransactionTime TIME(0) DEFAULT CURRENT_TIMESTAMP NOT NULL
	, FullDate SMALLDATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
)

-- Customer Tables -- 

CREATE TABLE CustomerCreate(
	TransactionType VARCHAR(MAX)
	, AccountNumber VARCHAR(MAX) -- Phone Number in ADC
	, Phone VARCHAR(10) NULL 
	--, Pin_Number VARCHAR(6) NULL
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
)

CREATE TABLE CustomerModify(
	TransactionType VARCHAR(MAX)
	, AccountNumber INT NOT NULL        -- Phone Number in ADC
	, Phone VARCHAR(10) NULL
	--, Pin_Number VARCHAR(6) NULL
	, LastName VARCHAR(MAX) NOT NULL 
	, FirstName VARCHAR(MAX) NOT NULL 
	, Address VARCHAR(60) NULL
	, Address2 VARCHAR(60) NULL
	, City VARCHAR(MAX) NULL 
	, State CHAR(3) NULL 
	, ZipCode VARCHAR(MAX) NULL 
	, TransactionDate DATE NOT NULL 
	, TransactionTime TIME(0) NOT NULL
)

CREATE TABLE CustomerDelete(
	TransactionType VARCHAR(20) NOT NULL 
	, AccountNumber VARCHAR(MAX)
	, TransactionDate DATE
	, TransactionTime TIME(0)
)

-- Ticket Tables --

CREATE TABLE TicketCreate(
	TransactionType VARCHAR(MAX)
	, AccountNumber VARCHAR(MAX) NOT NULL       -- Phone Number in ADC
	, TicketNumber VARCHAR(MAX) NOT NULL 
	, PickupDate DATE NULL
	, PickupTime TIME(0) NULL
	, PlantID INT NULL
	, RouteID INT NULL
	, StoreID INT NULL
	, TransactionDate DATE NOT NULL 
	, TransactionTime TIME(0) NOT NULL
	, FullDate SMALLDATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
)

CREATE TABLE TicketModify(
	TransactionType VARCHAR(MAX)
	, AccountNumber VARCHAR(MAX) NOT NULL          -- Phone Number in ADC
	, TicketNumber VARCHAR(MAX) NOT NULL 
	, PickupDate DATE NULL
	, PickupTime TIME(0) NULL
	, PlantID INT NULL
	, RouteID INT NULL
	, StoreID INT NULL
	, TransactionDate DATE NOT NULL 
	, TransactionTime TIME(0) NOT NULL
	, FullDate SMALLDATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
)

CREATE TABLE TicketDelete(
	TransactionType VARCHAR(20) NOT NULL 
	, AccountNumber VARCHAR(MAX) NOT NULL
	, TicketNumber VARCHAR(MAX) NOT NULL
	, TransactionDate DATE
	, TransactionTime TIME(0)
)

CREATE TABLE TicketClosed(
	TransactionType VARCHAR(20) NOT NULL 
	, AccountNumber VARCHAR(MAX)
	, TicketNumber VARCHAR(MAX)
	, TransactionDate DATE
	, TransactionTime TIME
)


-- Garment Create --

CREATE TABLE GarmentCreate(
	TransactionType VARCHAR(MAX)
	, AccountNumber VARCHAR(MAX) NOT NULL       -- Phone Number in ADC
	, TicketNumber VARCHAR(MAX) NOT NULL 
	, GarmentNumber VARCHAR(MAX) NOT NULL 
	, GarmDescription VARCHAR(MAX) NULL
	, ServicePrice VARCHAR NULL
	, ServiceType VARCHAR(MAX) NULL
	, GarmType VARCHAR(50) NULL
	, GarmColor VARCHAR(10) NULL
	, GarmFabric VARCHAR(50) NULL
	, TransactionDate DATE NOT NULL 
	, TransactionTime TIME(0) NOT NULL 
	, FullDate SMALLDATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
)


CREATE TABLE GarmentModify(
	TransactionType VARCHAR(MAX)
	, AccountNumber VARCHAR(MAX) NOT NULL         -- Phone Number in ADC
	, TicketNumber VARCHAR(MAX) NOT NULL 
	, GarmentNumber VARCHAR(MAX) NOT NULL 
	, GarmDescription VARCHAR(MAX) NULL
	, ServicePrice VARCHAR NULL
	, ServiceType VARCHAR(MAX) NULL
	, GarmType VARCHAR(50) NULL
	, GarmColor VARCHAR(10) NULL
	, GarmFabric VARCHAR(50) NULL
	, TransactionDate DATE NOT NULL 
	, TransactionTime TIME(0) NOT NULL
	, FullDate SMALLDATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
)

CREATE TABLE GarmentDelete(
	TransactionType VARCHAR(20) NOT NULL 
	, AccountNumber VARCHAR(MAX) NOT NULL          -- Phone Number in ADC
	, TicketNumber VARCHAR(MAX) NOT NULL
	, GarmentNumber INT NOT NULL
	, TransactionDate DATE
	, TransactionTime TIME(0)
)

CREATE TABLE GarmentClosed(
	TransactionType VARCHAR(20) NOT NULL 
	, AccountNumber VARCHAR(MAX)
	, TicketNumber VARCHAR(MAX)
	, GarmentNumber VARCHAR(MAX)
	, TransactionDate DATE
	, TransactionTime TIME
)

-- Backup info for a few days incase of lost/missing data
CREATE TABLE CusTicGarmHistory(
	TransactionType VARCHAR(MAX) NULL
	, AccountNumber VARCHAR(MAX) NULL           -- Phone Number in ADC
	, TicketNumber VARCHAR(MAX) NULL
	, OriginalTicketNumber VARCHAR(MAX) NULL
	, TicketSplitNumber VARCHAR(MAX) NULL
	, GarmentNumber VARCHAR(MAX) NULL
	, Phone VARCHAR(12) NULL 
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



-- ScanGarm holds all important information pulled
-- from POS data passed through from the text file.
-- ScanGarm will be updated constantly by VD until the ticket is complete
CREATE TABLE ScanGarm(
	AccountNumber VARCHAR(MAX) NULL        -- Phone Number in ADC
	, Phone VARCHAR(10) NULL 
	--, Pin_Number VARCHAR(6) NULL
	, GarmentNumber VARCHAR(MAX)
	, TicketNumber VARCHAR(MAX) NULL
	, OriginalTicketNumber VARCHAR(MAX) NULL
	, TicketSplitNumber VARCHAR(MAX) NULL
	, GarmentDescription VARCHAR(MAX) NULL
	, TransactionDate DATE NULL
	, TransactionTime TIME(0) NULL
	, SlotNum INT NULL -- Original Slot #; VD
	, SlotNum_1 INT NULL -- Assigned by Trigger
	, SlotNum_2 INT NULL -- Assigned by Trigger
	, SlotNum_3 INT NULL -- Assigned by Trigger
	, SlotNum_4 INT NULL -- Assigned by Trigger
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
	, FullDate SMALLDATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
)

-- This will hold a backup of all info for scanned garms
-- Once "GarmUnloaded" is triggered, deletes from ScanGarm
-- And data only remains in ScanHistory for 7 days
-- or whatever timeframe is allotted
CREATE TABLE ScanHistory(
	AccountNumber VARCHAR(MAX) NULL
	, GarmentNumber VARCHAR(MAX)
	, TicketNumber VARCHAR(MAX) NULL
	, OriginalTicketNumber VARCHAR(MAX) NULL
	, TicketSplitNumber VARCHAR(MAX) NULL
	, SlotNum INT NULL -- VD
	, RFID_BARCODE INT NULL -- VD
	, GarmLoaded VARCHAR(MAX) NULL
	, GarmUnloaded VARCHAR(MAX) NULL
)

-- Tables Needed For Visual Designer -- 
CREATE TABLE Inventory(	
	CustomerName VARCHAR(MAX)
	, CustomerID VARCHAR(MAX)
	, TicketNumber VARCHAR(MAX)
	, OriginalTicketNumber VARCHAR(MAX) NULL
	, TicketSplitNumber VARCHAR(MAX) NULL
	, GarmentNumber VARCHAR(MAX)
	, GarmentDesc VARCHAR(MAX)
	, SlotNumber BIGINT
	, TotalRemaining INT
	, TotalOnTicket INT
)

-- History table info that is pulled in VD
-- History table will show data for garms/ticks
-- up to 14 days after transaction 
CREATE TABLE History(
	GarmentNumber VARCHAR(MAX)
	, TicketNumber VARCHAR(MAX)
	, OriginalTicketNumber VARCHAR(MAX) NULL
	, TicketSplitNumber VARCHAR(MAX) NULL
	, AccountNumber VARCHAR(MAX)
	, DateLoaded VARCHAR(MAX) 
	, DateUnloaded VARCHAR(MAX) 
	, PickupDate DATE 
	, TotalDaysAged INT
)

CREATE TABLE TicketTable(
	TicketNumber VARCHAR(MAX)
	, GarmentNumber VARCHAR(MAX)
	, TotalOnTicket VARCHAR(MAX)
	, OriginalTicketNumber VARCHAR(MAX) NULL
	, TicketSplitNumber VARCHAR(MAX) NULL
	, AccountNumber VARCHAR(MAX)
	, DropoffDate DATE
	, PickupDate DATE
	, PlantID INT
	, RouteID INT
	, StoreID INT
)


