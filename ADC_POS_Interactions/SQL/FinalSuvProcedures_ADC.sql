
USE master
GO

USE ADC
GO


/*
	The below code updates ScanGarm after new information is inserted
	into GarmentLoaded, GarmentUnloaded, TicketCompete, and 
	TicketSplit. 

	When a garment goes through a transaction, it will populate
	the specific fields in each transaction table first. Then
	will update ScanGarm to carry out the rest of the database actions.

*/

-- View holds the calculated ticket information of totals garms on ticket
CREATE VIEW TotalGarmsOnTicket -- tg_v
AS
SELECT
	gc.TicketNumber
	, COUNT(gc.TicketNumber) AS TotalOnTicket
FROM
	GarmentCreate AS gc
GROUP BY gc.TicketNumber;

-- View holds Totoal Incomplete garms on each ticket
CREATE VIEW TotalCompleteGarmsOnTicket --tcg
AS
SELECT
	sc.TicketNumber
	, COUNT(sc.TicketNumber) AS TotalComplete
FROM
	ScanGarm AS sc
WHERE
	sc.SlotNum IS NOT NULL
GROUP BY 
	sc.TicketNumber;

-- View counts the remaining garments on each ticket
CREATE VIEW TotalRemainingGarments --On Ticket
AS
SELECT
	sc.TicketNumber
	, COUNT(sc.TicketNumber) AS TotalRemaining
FROM
	ScanGarm AS sc
WHERE
	sc.SlotNum IS NULL
GROUP BY sc.TicketNumber;

-- View calculates the date difference between the currrent date and the date
-- the garment was placed on the convyeor
CREATE VIEW AgingTickets --agt
AS
SELECT
	GarmentNumber
	, DATEDIFF(day, sc.TransactionDate, GETDATE()) AS TotalAged
FROM
	ScanGarm AS sc;

-- View shows single row per Ticket with each Slot Que # assiciated with it
CREATE VIEW TicketSlotQues
AS
SELECT
	sc.TicketNumber
	, sc.Phone
	, CASE WHEN EXISTS(SELECT sg.TicketNumber, sg.SlotNum_1 FROM ScanGarm AS sg WHERE sg.TicketNumber = sc.TicketNumber) THEN SUM(SlotNum_1) ELSE NULL END AS SlotNum_1
	, CASE WHEN EXISTS(SELECT sg.TicketNumber, sg.SlotNum_2 FROM ScanGarm AS sg WHERE sg.TicketNumber = sc.TicketNumber) THEN SUM(SlotNum_2) ELSE NULL END AS SlotNum_2
	, CASE WHEN EXISTS(SELECT sg.TicketNumber, sg.SlotNum_3 FROM ScanGarm AS sg WHERE sg.TicketNumber = sc.TicketNumber) THEN SUM(SlotNum_3) ELSE NULL END AS SlotNum_3
	, CASE WHEN EXISTS(SELECT sg.SlotNum_4 FROM ScanGarm AS sg WHERE sg.TicketNumber = sc.TicketNumber) THEN SUM(SlotNum_4) ELSE NULL END AS SlotNum_4
	, tot.TotalOnTicket
	, sc.AccountNumber
FROM ScanGarm AS sc
JOIN TotalGarmsOnTicket AS tot ON tot.TicketNumber = sc.TicketNumber 
WHERE SlotNum IS NOT NULL 
GROUP BY sc.TicketNumber, sc.Phone, sc.AccountNumber, tot.TotalOnTicket

--- When the Customer Create table inserts information the phone number will link to the account number to help cross varify

CREATE TRIGGER CustomerAccount
ON CustomerCreate
AFTER INSERT
AS
BEGIN
	UPDATE CustomerCreate
	SET
		Phone = AccountNumber
END




-- Inserts data into ScanGarm Table
-- ScanGarm table will hold most of the important information needed
-- to query throughout both SQL and VD procedures

-- Insert Garment information first before pulling information
-- associated with specific garment from other tables

CREATE TRIGGER InsertGarmInfo_SG
ON GarmentCreate
AFTER INSERT
AS
BEGIN
	INSERT INTO ScanGarm(
		AccountNumber
		, GarmentNumber
		, GarmentDescription
		, TransactionDate
		, TransactionTime
	)
	SELECT
		i.AccountNumber
		, i.GarmentNumber
		, CONCAT(i.ServiceType, ', ', i.GarmType,', ', i.GarmColor,', ', i.GarmFabric)
		, i.TransactionDate
		, i.TransactionTime
		FROM 
		INSERTED AS i

	UPDATE ScanGarm
	SET
		Phone = cc.Phone
		--, Pin_Number = cc.Pin_number
	FROM
		CustomerCreate AS cc JOIN ScanGarm AS sc ON cc.AccountNumber = sc.AccountNumber


	SET NOCOUNT ON
	UPDATE ScanGarm
	SET
		TicketNumber = tc.TicketNumber
		, PickupDate = tc.PickupDate
		, PickupTime = tc.PickupTime
		, PlantID = tc.PlantID
		, RouteID = tc.RouteID
		, StoreID = tc.StoreID
		, TotalOnTicket = tg_v.TotalOnTicket
		, TotalComplete = COALESCE(sc.TotalComplete, 0)
		, TotalDaysAged = agt.TotalAged
	FROM
		TicketCreate AS tc JOIN ScanGarm AS sc ON tc.AccountNumber = sc.AccountNumber
		JOIN TotalGarmsOnTicket AS tg_v ON tg_v.TicketNumber = tc.TicketNumber
		JOIN AgingTickets AS agt ON sc.GarmentNumber = agt.GarmentNumber

	UPDATE ScanGarm
	SET
		TotalRemaining = tr.TotalRemaining
	FROM
		TotalRemainingGarments AS tr JOIN ScanGarm AS sc ON sc.TicketNumber = tr.TicketNumber
	WHERE
		tr.TicketNumber = sc.TicketNumber
END;

-- Creates trigger to update History, Inventory and TicketTable that are needed
-- to pull data into VD search tables
CREATE TRIGGER InsertIntoVDTables
ON GarmentCreate
AFTER INSERT
AS
BEGIN
	INSERT INTO History(
		GarmentNumber
		, AccountNumber
		, TicketNumber
	)
	SELECT
		i.GarmentNumber
		, i.AccountNumber
		, i.TicketNumber
	FROM INSERTED AS i
	
	INSERT INTO Inventory(
		GarmentNumber
		, GarmentDesc
		, CustomerID
		, TicketNumber
	)
	SELECT
		i.GarmentNumber
		, i.GarmDescription
		, i.AccountNumber
		, i.TicketNumber
	FROM
		INSERTED AS i

	INSERT INTO TicketTable(
		GarmentNumber
		, AccountNumber
		, DropoffDate
		, TicketNumber
	)
	SELECT
		i.GarmentNumber
		, i.AccountNumber
		, i.TransactionDate
		, i.TicketNumber
	FROM
		INSERTED AS i

	UPDATE TicketTable
		SET		
			PickupDate = tc.PickupDate
			, PlantID = tc.PlantID
			, RouteID = tc.RouteID
			, StoreID = tc.StoreID
		FROM
			TicketCreate AS tc JOIN TicketTable AS tt ON tc.TicketNumber = tt.TicketNumber
		WHERE
			tt.TicketNumber = tc.TicketNumber

	UPDATE TicketTable
		SET
			TotalOnTicket = tg_v.TotalOnTicket
		FROM
			TotalGarmsOnTicket AS tg_v JOIN TicketTable AS tt ON tg_v.TicketNumber = tt.TicketNumber

SET NOCOUNT ON				

	UPDATE History
		SET
		 PickupDate = tc.PickupDate
			, TotalDaysAged = agt.TotalAged
		FROM
			TicketCreate AS tc JOIN History AS h ON tc.TicketNumber = h.TicketNumber
			JOIN AgingTickets AS agt ON h.GarmentNumber = agt.GarmentNumber

	UPDATE Inventory
	SET
		 CustomerName = CONCAT(cc.FirstName, ' ', cc.LastName)
	FROM 
		CustomerCreate AS cc JOIN Inventory AS inv ON cc.AccountNumber = inv.CustomerID
	WHERE
		cc.AccountNumber = inv.CustomerID

	UPDATE Inventory
	SET
		TotalRemaining = tr.TotalRemaining
	FROM
		TotalRemainingGarments AS tr JOIN Inventory AS inv ON inv.TicketNumber = tr.TicketNumber
	WHERE
		tr.TicketNumber = inv.TicketNumber

	UPDATE Inventory
	SET
		TotalOnTicket = tg_v.TotalOnTicket
	FROM
		TotalGarmsOnTicket AS tg_v JOIN Inventory AS inv ON inv.TicketNumber = tg_v.TicketNumber
	WHERE
		tg_v.TicketNumber = inv.TicketNumber
END;

-- Trigger when Garment is Loaded onto conveyor
CREATE TRIGGER UpdateGarmentLoaded
ON GarmentLoaded
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON
	UPDATE ScanGarm
	SET
		SlotNum = i.SlotNumber
		, RFID_BARCODE = REPLACE(RTRIM(LTRIM(REPLACE(i.RFID_BARCODE,'0',' '))),' ','0')
		, GarmLoaded = CONCAT(i.TransactionDate, ' ', i.TransactionTime)
	FROM
		INSERTED AS i JOIN ScanGarm AS sc ON sc.GarmentNumber = i.GarmentNumber
	WHERE
		sc.GarmentNumber = i.GarmentNumber
	
	UPDATE ScanGarm
	SET
		TotalOnTicket = tg_v.TotalOnTicket
		, TotalComplete = tcg.TotalComplete
		, TotalRemaining = ISNULL(trg.TotalRemaining,0)
	FROM
		ScanGarm AS sc JOIN TotalGarmsOnTicket AS tg_v ON sc.TicketNumber = tg_v.TicketNumber
		LEFT OUTER JOIN TotalCompleteGarmsOnTicket AS tcg ON sc.TicketNumber = tcg.TicketNumber
		LEFT OUTER JOIN TotalRemainingGarments AS trg ON sc.TicketNumber = trg.TicketNumber

	UPDATE History
	SET
		DateLoaded = CONCAT(i.TransactionDate, ' ', i.TransactionTime)
	FROM
		INSERTED AS i JOIN History AS h ON h.GarmentNumber = i.GarmentNumber
	WHERE
		i.GarmentNumber = h.GarmentNumber

	UPDATE Inventory
	SET
		SlotNumber = i.SlotNumber
	FROM
		INSERTED AS i JOIN Inventory AS inv ON inv.GarmentNumber = i.GarmentNumber
	WHERE
		i.GarmentNumber = inv.GarmentNumber

	UPDATE Inventory
	SET
		TotalRemaining = tr.TotalRemaining
	FROM
		TotalRemainingGarments AS tr JOIN Inventory AS inv ON inv.TicketNumber = tr.TicketNumber
	WHERE
		tr.TicketNumber = inv.TicketNumber

	INSERT INTO ScanHistory(
		AccountNumber
		, GarmentNumber
		, TicketNumber
		, SlotNum
		, RFID_BARCODE
		, GarmLoaded
	)
	SELECT
		sc.AccountNumber
		, sc.GarmentNumber
		, sc.TicketNumber
		, i.SlotNumber
		, i.RFID_BARCODE
		, CONCAT(i.TransactionDate, ' ', i.TransactionTime) AS GarmLoaded
	FROM
		INSERTED AS i JOIN ScanGarm AS sc ON sc.GarmentNumber = i.GarmentNumber
END;


CREATE TRIGGER SlotAssignment
ON GarmentLoaded
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON

	UPDATE ScanGarm
	SET
		SlotNum_1 = CASE WHEN tc.TotalComplete = 1 THEN SlotNum ELSE NULL END
		, SlotNum_2 = CASE WHEN tc.TotalComplete = 2 THEN SlotNum ELSE NULL END
		, SlotNum_3 = CASE WHEN tc.TotalComplete = 3 THEN SlotNum ELSE NULL END
		, SlotNum_4 = CASE WHEN tc.TotalComplete = 4 THEN SlotNum ELSE NULL END
	FROM
		INSERTED AS i JOIN ScanGarm AS sc ON sc.GarmentNumber = i.GarmentNumber
		JOIN TotalCompleteGarmsOnTicket AS tc ON tc.TicketNumber = sc.TicketNumber
	WHERE 
		tc.TicketNumber = sc.TicketNumber
END;



/* Ticket Split Trigger Goes here
	Once criteria meets TicketSplitChoice (User_Choicel), ticket will be split
	and sent to TicketSplit table. 

	Jeff - create trigger in scheduler to send to POS immediately once info is in 
	split to send to POS for new Ticket #s
*/
CREATE TRIGGER SplitTicketMax
ON GarmentLoaded
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON

	INSERT INTO TicketSplit(
		AccountNumber
		, TicketNumber
		, GarmentNumber
		, TransactionDate
		, TransactionTime
	)
	SELECT DISTINCT
		sc.AccountNumber
		, sc.TicketNumber
		, sc.GarmentNumber
		, sc.TransactionDate
		, sc.TransactionTime
	FROM
		ScanGarm AS sc
	WHERE
		sc.TotalComplete % TicketSplitChoice = 0 AND 
		sc.TotalRemaining > 0 AND 
		sc.GarmLoaded IS NOT NULL AND
		sc.GarmUnloaded IS NULL

	UPDATE TicketSplit
		SET
			TransactionType = 'TICKET_SPLIT'
		FROM 
			TicketSplit
		WHERE
			TransactionType IS NULL
END;

-- Trigger when Garment is unloaded
-- Updates specific tables below 
CREATE TRIGGER UpdateGarmentUnloaded
ON GarmentUnloaded
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON
	UPDATE ScanGarm
	SET
		GarmUnloaded = i.TransactionDate
	FROM
		INSERTED AS i JOIN ScanGarm AS sc ON i.GarmentNumber = sc.GarmentNumber
	WHERE
		i.GarmentNumber = sc.GarmentNumber

	UPDATE History
	SET 
		DateUnloaded = CONCAT(i.TransactionDate, ' ', i.TransactionTime)
	FROM 
		INSERTED AS i JOIN History AS h ON i.GarmentNumber = h.GarmentNumber
	WHERE 
		i.GarmentNumber = h.GarmentNumber

	UPDATE ScanHistory
	SET
		GarmUnloaded = CONCAT(i.TransactionDate, ' ', i.TransactionTime)
	FROM
		INSERTED AS i JOIN ScanHistory AS sh ON i.GarmentNumber = sh.GarmentNumber
	WHERE
		i.GarmentNumber = sh.GarmentNumber

	DELETE FROM ScanGarm
	WHERE GarmUnloaded IS NOT NULL
	AND TotalRemaining = 0
END;

-- Trigger to insert info into Receipt Print after a ticket
-- is completed
CREATE TRIGGER InsertIntoReceiptPrint
ON TicketComplete
AFTER INSERT
AS
BEGIN
	INSERT INTO ReceiptPrint(
		AccountNumber
		, TicketNumber
		, GarmentNumber
		, TransactionDate
		, TransactionTime
	)
	SELECT
		i.AccountNumber
		, i.TicketNumber
		, i.GarmentNumber
		, i.TransactionDate
		, i.TransactionTime
	FROM
		INSERTED AS i JOIN ReceiptPrint AS rp ON rp.GarmentNumber = i.GarmentNumber
END;

/*

	Below are the  triggers used to Modify POS transactions sent from the POS
	to WC via text file. Each trigger is listed under its original command:
	CUSTOMER_MODIFY, TICKET_MODIFY, GARMENT_MODIFY

*/

-- Customer Modify
CREATE TRIGGER ModifyCusInfo
ON CustomerModify
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON
	UPDATE CustomerCreate
		SET
			Phone = cm.Phone
			, LastName = cm.LastName
			, FirstName = cm.FirstName
			, Address = cm.Address
			, Address2 = cm.Address2
			, City = cm.City
			, State = cm.State
			, ZipCode = cm.ZipCode
			, TransactionDate = cm.TransactionDate
			, TransactionTime = cm.TransactionTime
		FROM 
			CustomerModify AS cm JOIN CustomerCreate AS cc ON cc.AccountNumber = cm.AccountNumber

	UPDATE Inventory
		SET
			CustomerName = CONCAT(cm.FirstName, ' ', cm.LastName)
		FROM 
			CustomerModify AS cm JOIN Inventory AS i ON cm.AccountNumber = i.CustomerID
		WHERE
			cm.AccountNumber = i.CustomerID

	DELETE FROM CustomerModify

END;

-- Ticket Modify
CREATE TRIGGER ModifyTickInfo
ON TicketModify
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON
	UPDATE TicketCreate
		SET
			PickupDate = tm.PickupDate
			, PickupTime = tm.PickupTime
			, PlantID = tm.PlantID
			, RouteID = tm.RouteID
			, StoreID = tm.StoreID
			, TransactionDate = tm.TransactionDate
			, TransactionTime = tm.TransactionTime
		FROM 
			TicketModify AS tm JOIN TicketCreate AS tc ON tc.TicketNumber = tm.TicketNumber
			AND tm.AccountNumber = tc.AccountNumber

	UPDATE ScanGarm 
		SET
			PickupDate = tm.PickupDate
			, PickupTime = tm.PickupTime
			, PlantID = tm.PlantID
			, RouteID = tm.RouteID
			, StoreID = tm.StoreID
			, TransactionDate = tm.TransactionDate
			, TransactionTime = tm.TransactionTime
		FROM 
			TicketModify AS tm JOIN ScanGarm AS sc ON tm.AccountNumber = sc.AccountNumber
		WHERE
			tm.TicketNumber = sc.TicketNumber

	UPDATE History
		SET
			PickupDate = tm.PickupDate
		FROM 
			TicketModify AS tm JOIN History AS h ON tm.TicketNumber = h.TicketNumber

	UPDATE TicketTable 
		SET
			PickupDate = tm.PickupDate
			, PlantID = tm.PlantID
			, RouteID = tm.RouteID
			, StoreID = tm.StoreID
		FROM
			TicketModify AS tm JOIN TicketTable AS tt ON tm.TicketNumber = tt.TicketNumber

	DELETE FROM TicketModify
END;

--Garment Modify
CREATE TRIGGER ModifyGarmInfo
ON GarmentModify
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON
	UPDATE GarmentCreate
		SET
			GarmDescription = gm.GarmDescription
			, ServicePrice = gm.ServicePrice
			, ServiceType = gm.ServiceType
			, GarmType = gm.GarmType
			, GarmColor = gm.GarmColor
			, GarmFabric = gm.GarmFabric
			, TransactionDate = gm.TransactionDate
			, TransactionTime = gm.TransactionTime
		FROM GarmentModify AS gm JOIN GarmentCreate AS gc ON gc.GarmentNumber = gm.GarmentNumber
		AND gm.AccountNumber = gc.AccountNumber
		AND gm.TicketNumber = gc.TicketNumber

	UPDATE Inventory
		SET
			GarmentDesc = gm.GarmDescription
		FROM
			GarmentModify AS gm JOIN Inventory AS i On gm.GarmentNumber = i.GarmentNumber

	UPDATE ScanGarm
		SET
			TransactionDate = gm.TransactionDate
			, TransactionTime = gm.TransactionTime
		FROM
			GarmentModify AS gm JOIN ScanGarm AS sc ON gm.GarmentNumber = sc.GarmentNumber

	DELETE FROM GarmentModify

END;

-- Store Modify
CREATE TRIGGER ModifyStoreInfo
ON StoreModify
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON
	UPDATE StoreCreate
		SET
			StoreID = sm.StoreID
			, PhoneNumber = sm.PhoneNumber
			, Address = sm.Address
			, Address2 = sm.Address2
			, City = sm.City
			, State = sm.State
			, ZipCode = sm.ZipCode
			, TransactionTime = sm.TransactionTime
			, TransactionDate = sm.TransactionDate
		FROM
			StoreModify AS sm JOIN StoreCreate AS sc ON sm.StoreID = sc.StoreID
		WHERE
			sm.StoreID = sc.StoreID

	UPDATE ScanGarm
	SET 
		StoreID = sm.StoreID
	FROM 
		StoreModify AS sm JOIN ScanGarm AS sg ON sm.StoreID = sg.StoreID

	UPDATE TicketTable
	SET
		StoreID = sm.StoreID
	FROM
		StoreModify AS sm JOIN TicketTable AS tt ON tt.StoreID = sm.StoreID

	UPDATE TicketCreate
	SET
		StoreID = sm.StoreID
	FROM
		StoreModify AS sm JOIN TicketCreate AS tc ON tc.StoreID = sm.StoreID

	DELETE FROM StoreModify
END;

-- Route Modify
CREATE TRIGGER ModifyRouteInfo
ON RouteModify
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON
	UPDATE RouteCreate
		SET
			RouteID = rm.RouteID
			, PhoneNumber = rm.PhoneNumber
			, Address = rm.Address
			, Address2 = rm.Address2
			, City = rm.City
			, State = rm.State
			, ZipCode = rm.ZipCode
			, TransactionTime = rm.TransactionTime
			, TransactionDate = rm.TransactionDate
		FROM
			RouteModify AS rm JOIN RouteCreate AS rc ON rm.RouteID = rc.RouteID
		WHERE
			rm.RouteID = rc.RouteID

	UPDATE ScanGarm
	SET 
		RouteID = rm.RouteID
	FROM 
		RouteModify AS rm JOIN ScanGarm AS sg ON rm.RouteID = sg.RouteID

	UPDATE TicketTable
	SET
		RouteID = rm.RouteID
	FROM
		RouteModify AS rm JOIN TicketTable AS tt ON tt.RouteID = rm.RouteID

	UPDATE TicketCreate
	SET
		RouteID = rm.RouteID
	FROM
		RouteModify AS rm JOIN TicketCreate AS tc ON tc.RouteID = rm.RouteID

	DELETE FROM RouteModify 
END;



/* This is to iinsert the Pin and phone numbers into all of the columns  */

CREATE TRIGGER PhoneNumberInserts
ON CustomerCreate
AFTER INSERT, UPDATE
AS
BEGIN
	SET NOCOUNT ON
	UPDATE ScanGarm
	SET
		Phone = cc.Phone
		Pin_Number = cc.Pin_Number
	FROM
		CustomerCreate AS cc JOIN ScanGarm AS sc ON sc.Phone = cc.Phone
	Where
		sc.AccountNumber = cc.AccountNumber

	UPDATE GarmentCreate
	SET
		Phone = cc.Phone
		Pin_Number = cc.Pin_Number
	FROM
		CustomerCreate AS cc JOIN GarmentCreate AS gc ON gc.Phone = cc.Phone
	Where
		gc.AccountNumber = cc.AccountNumber

	UPDATE TicketCreate
	SET
		Phone = cc.Phone
		Pin_Number = cc.Pin_Number
	FROM
		CustomerCreate AS cc JOIN TicketCreate AS tc ON sc.Phone = cc.Phone
	Where
		tc.AccountNumber = cc.AccountNumber

	UPDATE ScanHistory
	SET
		Phone = cc.Phone
		Pin_Number = cc.Pin_Number
	FROM
		CustomerCreate AS cc JOIN ScanHistory AS sc ON sh.Phone = cc.Phone
	Where
		sh.AccountNumber = cc.AccountNumber

	END;

/*
	Below are the triggers used to delete specific information sent by the POS
	via text file

*/
CREATE TRIGGER TickDelete
ON TicketDelete
AFTER INSERT
AS
BEGIN
SET NOCOUNT ON
	DELETE tc
	FROM TicketCreate AS tc JOIN INSERTED AS td ON td.TicketNumber = tc.TicketNumber

	DELETE Inventory 
	FROM Inventory JOIN INSERTED AS i on i.TicketNumber = Inventory.TicketNumber

	DELETE ScanGarm
	FROM ScanGarm JOIN INSERTED AS i on i.TicketNumber = ScanGarm.TicketNumber

	DELETE ScanHistory
	FROM ScanHistory JOIN INSERTED AS i on i.TicketNumber = ScanHistory.TicketNumber

	DELETE History
	FROM History JOIN INSERTED AS i on i.TicketNumber = History.TicketNumber

	DELETE TicketTable
	FROM TicketTable JOIN INSERTED AS i on i.TicketNumber = TicketTable.TicketNumber
END;


CREATE TRIGGER GarmDelete
ON GarmentDelete
AFTER INSERT
AS
BEGIN
SET NOCOUNT ON
	DELETE gc
	FROM GarmentCreate AS gc JOIN GarmentDelete as gd ON gd.GarmentNumber = gc.GarmentNumber

	DELETE Inventory 
	FROM Inventory JOIN INSERTED AS i on i.GarmentNumber = Inventory.GarmentNumber

	DELETE ScanGarm
	FROM ScanGarm JOIN INSERTED AS i on i.GarmentNumber = ScanGarm.GarmentNumber

	DELETE ScanHistory
	FROM ScanHistory JOIN INSERTED AS i on i.GarmentNumber = ScanHistory.GarmentNumber

	DELETE History
	FROM History JOIN INSERTED AS i on i.GarmentNumber = History.GarmentNumber

	DELETE TicketTable
	FROM TicketTable JOIN INSERTED AS i on i.GarmentNumber = TicketTable.GarmentNumber
END;


CREATE TRIGGER DeleteStoreInfo
ON StoreDelete
AFTER INSERT
AS
BEGIN
	DELETE StoreCreate
	FROM StoreCreate AS sc JOIN INSERTED AS i ON i.StoreId = sc.StoreID

	DELETE StoreID
	FROM ScanGarm AS sg JOIN INSERTED AS i ON sg.StoreID = i.StoreID

	DELETE StoreID
	FROM TicketTable AS tt JOIN INSERTED AS i ON tt.StoreID = i.StoreID

	DELETE FROM StoreDelete
END;

CREATE TRIGGER DeleteRouteInfo
ON RouteDelete
AFTER INSERT
AS
BEGIN
	DELETE RouteCreate
	FROM RouteCreate AS rc JOIN INSERTED AS i ON i.RouteID = rc.RouteID

	DELETE RouteID
	FROM ScanGarm AS sg JOIN INSERTED AS i ON sg.RouteID = i.RouteID

	DELETE RouteID
	FROM TicketTable AS tt JOIN INSERTED AS i ON tt.RouteID = i.RouteID

	DELETE FROM RouteDelete
END;






/*
SELECT * FROM ScanGarm
WHERE GarmLoaded IS NOT NULL AND TotalComplete = TicketSplitChoice;


CREATE TRIGGER UnloadSplit
ON GarmentLoaded
AFTER INSERT, UPDATE
AS
BEGIN
		INSERT INTO GarmentUnloaded(
			AccountNumber
			, GarmentNumber
			, TicketNumber
			, TransactionDate
			, TransactionTime
			)
		SELECT DISTINCT
			sc.AccountNumber
			, sc.TicketNumber
			, sc.GarmentNumber
			, sc.TransactionDate
			, sc.TransactionTime
	FROM
			GarmentLoaded as gl
			Join GarmentUnloaded AS gu ON gl.GarmentNumber = gu.GarmentNumber
	WHERE
			GarmLoaded IS NOT NULL AND TotalComplete = TicketSplitChoice

	DELETE FROM ScanGarm
	WHERE GarmLoaded IS NOT NULL AND TotalComplete = TicketSplitChoice 

END



CREATE TRIGGER UpdateGarmLoaded
ON ScanGarm
AFTER INSERT, UPDATE
AS
BEGIN
		UPDATE GarmentLoaded
			Set
			GarmLoaded = sc.Garmloaded
			, TotalComplete = sc.TotalComplete
			, TotalOnTicket = sc.TotalOnTicket
			, TicketSplitChoice = sc.TicketSplitChoice
		FROM
			Scangarm as sc
			Join GarmentLoaded AS gl ON sc.GarmentNumber = gl.GarmentNumber

END


CREATE TRIGGER UnloadSplit
ON GarmentLoaded
AFTER INSERT, UPDATE
AS
BEGIN
		Update GarmentUnloaded
			SET
			AccountNumber = gl.AccountNumber
			, TicketNumber = gl.TicketNumber
			, GarmentNumber = gl.GarmentNumber
			, SlotNumber = gl.SlotNumber
			, RFID_BARCODE = gl.RFID_BARCODE
			, TransactionDate = gl.TransactionDate
			, TransactionTime = gl.TransactionTime
			, GarmLoaded = gl.Garmloaded
			, TotalComplete = gl.TotalComplete
			, TotalOnTicket = gl.TotalOnTicket
			, TicketSplitChoice = gl.TicketSplitChoice
	FROM
			GarmentLoaded as gl
			Join GarmentUnloaded AS gu ON gu.GarmentNumber = gl.GarmentNumber
	WHERE
			gl.GarmLoaded IS NOT NULL AND gl.TotalComplete = gl.TicketSplitChoice AND gl.TotalOnTicket < 6

	DELETE FROM ScanGarm
	WHERE GarmLoaded IS NOT NULL AND TotalComplete = TicketSplitChoice 

	DELETE FROM GarmentLoaded
	WHERE GarmLoaded IS NOT NULL AND TotalComplete = TicketSplitChoice 

END


SELECT * FROM GarmentUnloaded;

CREATE TRIGGER UnloadSplit
ON ScanGarm
AFTER INSERT, UPDATE
AS
BEGIN
		Update GarmentUnloaded
			SET
			AccountNumber = sc.AccountNumber
			, GarmentNumber = sc.GarmentNumber
			, TicketNumber = sc.TicketNumber
			, TransactionDate = sc.TransactionDate
			, TransactionTime = sc.TransactionTime
			, GarmLoaded = gu.Garmloaded
			, TotalComplete = gu.TotalComplete
			, TotalOnTicket = gu.TotalOnTicket
			, TicketSplitChoice = gu.TicketSplitChoice
	FROM
			ScanGarm as sc
			Join GarmentUnloaded AS gu ON gu.GarmentNumber = sc.GarmentNumber
	WHERE
			GarmLoaded IS NOT NULL AND TotalComplete = TicketSplitChoice

	DELETE FROM ScanGarm
	WHERE GarmLoaded IS NOT NULL AND TotalComplete = TicketSplitChoice 

END




CREATE TRIGGER ModifyRouteInfo
ON RouteModify
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON
	UPDATE RouteCreate
		SET
			RouteID = rm.RouteID
			, PhoneNumber = rm.PhoneNumber
			, Address = rm.Address
			, Address2 = rm.Address2
			, City = rm.City
			, State = rm.State
			, ZipCode = rm.ZipCode
			, TransactionTime = rm.TransactionTime
			, TransactionDate = rm.TransactionDate
		FROM
			RouteModify AS rm JOIN RouteCreate AS rc ON rm.RouteID = rc.RouteID
		WHERE
			rm.RouteID = rc.RouteID
*/