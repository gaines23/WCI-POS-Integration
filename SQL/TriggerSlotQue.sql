CREATE TABLE ScanGarm(
	AccountNumber VARCHAR(MAX) NULL        -- Phone Number in ADC
	, Phone VARCHAR(10) NULL 
	, Pin_Number VARCHAR(6) NULL
	, GarmentNumber VARCHAR(MAX)
	, TicketNumber VARCHAR(MAX) NULL
	, OriginalTicketNumber VARCHAR(MAX) NULL
	, TicketSplitNumber VARCHAR(MAX) NULL
	, GarmentDescription VARCHAR(MAX) NULL
	, TransactionDate DATE NULL
	, TransactionTime TIME(0) NULL
	, SlotNum1 INT NULL -- VD
	, SlotNum2 INT NULL -- VD
	, SlotNum3 INT NULL -- VD
	, SlotNum4 INT NULL -- VD
	, SlotNum5 INT NULL -- VD
	, SlotNum6 INT NULL -- VD
	, SlotNum7 INT NULL -- VD
	, SlotNum8 INT NULL -- VD
	, SlotNum9 INT NULL -- VD
	, SlotNum10 INT NULL -- VD
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


CREATE TRIGGER ScanGarmTickets
ON TicketCreate
AFTER INSERT
AS
BEGIN
	SELECT AccountNumber
where fulldate = Current_timestamp

END;



CREATE VIEW TotalTickets   -- total tickets on an account
AS
SELECT
	sc.Accountnumber
	, COUNT(DISTINCT(sc.TicketNumber)) AS TotalTickets
FROM
	ScanGarm AS sc
	GROUP BY accountNumber;





CREATE TRIGGER SlotQue
On ScanGarm
AFTER INSERT, UPDATE
AS
BEGIN

	SELECT
		CASE 
			WHEN SlotNum1 = 0 Then
			SET sc.SlotNum1 = i.SlotNum

			WHEN SlotNum2 = 0 THEN
			SET SlotNum2 = i.SlotNum

			WHEN SlotNum3 = 0 THEN
			SET SlotNum3 = i.SlotNum

			WHEN SlotNum4 = 0 THEN
			SET SlotNum4 = i.SlotNum

	FROM Inserted AS i
		JOIN ScanGarm as sc ON i.Accountnumber = sc.AccountNumber

END




/* add Fulll date stamp too scan garm tooo have a check for ticket create */ 

