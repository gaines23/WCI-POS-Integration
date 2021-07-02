USE SUVOAS


SELECT * FROM CustomerCreate
SELECT * FROM TicketCreate
SELECT * FROM GarmentCreate
SELECT * FROM CustomerModify
SELECT * FROM TicketModify
SELECT * FROM GarmentModify
SELECT * FROM TicketDelete
SELECT * FROM GarmentDelete
SELECT * FROM TicketClosed
SELECT * FROM GarmentClosed
SELECT * FROM History
SELECT * FROM Inventory
SELECT * FROM TicketTable

SELECT AccountNumber, GarmentNumber, TicketNumber, SlotNum, GarmLoaded, GarmUnloaded, TotalRemaining FROM ScanGarm

select * from information_schema.columns

SELECT  *  FROM ScanGarm
SELECT * FROM TicketCreate WHERE AccountNumber = 6665840
SELECT * FROM GarmentCreate WHERE AccountNumber = 6665840




WHERE AccountNumber = '6865715' ORDER BY TicketNumber DESC

SELECT * FROM GarmentLoaded

SELECT * FROM TicketSplit

SELECT* FROM GarmentUnloaded

UPDATE ScanGarm
SET TicketSplitChoice = 4
WHERE AccountNumber = '6865715'



SELECT * FROM TicketSplit

SELECT * FROM GarmentUnloaded
SELECT * FROM TicketComplete
SELECT * FROM ReceiptPrint

DELETE FROM TicketSplit
DELETE FROM TicketReissue


DELETE FROM CustomerCreate
DELETE FROM TicketCreate
DELETE FROM GarmentCreate
DELETE FROM ScanGarm
DELETE FROM CustomerModify
DELETE FROM TicketModify
DELETE FROM GarmentModify
DELETE FROM TicketDelete
DELETE FROM GarmentDelete
DELETE FROM TicketClosed
DELETE FROM GarmentClosed
DELETE FROM History
DELETE FROM ScanHistory
DELETE FROM Inventory
DELETE FROM History
DELETE FROM TicketTable
DELETE FROM ScanHistory

DELETE FROM GarmentLoaded
DELETE FROM GarmentUnloaded
DELETE FROM TicketComplete

SELECT * FROM ScanGarm
SELECT * FROM ScanHistory

SELECT * FROM History
SELECT * FROM Inventory
SELECT * FROM TicketTable 



DELETE FROM ScanGarm

SELECT * from GarmentLoaded



SELECT * FROM ScanGarm
SELECT * FROM GarmentLoaded
DELETE FROM GarmentLoaded

SELECT * FROM SideInfoPane


/*
 Inserts into VD tables for POS 
 This is more true to the process: Garm is scanned and VD
 sends information to specific table for WC to send to POS
 via text file

 Once insert is triggered, WC tables will be updated, and pos will
 receive text file

*/

SELECT * FROM ScanGarm WHERE AccountNumber = '1234'

SELECT * FROM Inventory 
-- Acct 1234
-- Garm Loaded
INSERT INTO GarmentLoaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, 
SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES('Garment_Loaded', 1234, 100011, 964964, 13, 0010001100, '2/14/2020', '10:05:00')

INSERT INTO GarmentLoaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, 
SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES('Garment_Loaded', 1234, 100011, 964965, 14, 100011, '2/14/2020', '10:05:00')

INSERT INTO GarmentLoaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, 
SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES('Garment_Loaded', 1234, 100011, 964966, 15, 100011, '2/14/2020', '10:05:00')

-- Garm Unloaded
SELECT * FROM GarmentUnloaded
DELETE FROM GarmentUnloaded

INSERT INTO GarmentUnloaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, 
SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES('Garment_Unloaded', 1234, 100011, 964964, 13, 100011, '10/25/2010', '10:05:00')

INSERT INTO GarmentUnloaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, 
SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES('Garment_Unloaded', 1234, 100011, 964965, 14, 100011, '10/25/2010', '10:05:00')

INSERT INTO GarmentUnloaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, 
SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES('Garment_Unloaded', 1234, 100011, 964966, 15, 100011, '10/25/2010', '10:05:00')


-- Acct 5678

INSERT INTO GarmentLoaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, 
SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES('Garment_Loaded', 5678, 100012, 965088, 13, 100011, '10/24/2010', '10:05:00 AM')
INSERT INTO GarmentLoaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, 
SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES('Garment_Loaded', 5678, 100012, 965089, 14, 100011, '10/24/2010', '10:05:00 AM')
INSERT INTO GarmentLoaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, 
SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES('Garment_Loaded', 5678, 100012, 965180, 15, 100011, '10/24/2010', '10:05:00 AM')

INSERT INTO GarmentLoaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, 
SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES('Garment_Loaded', 9876, 100013, 965120, 13, 100011, '10/24/2010', '10:05:00 AM')
INSERT INTO GarmentLoaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, 
SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES('Garment_Loaded', 9876, 100013, 965128, 14, 100011, '10/24/2010', '10:05:00 AM')
INSERT INTO GarmentLoaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, 
SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES('Garment_Loaded', 9876, 100013, 965129, 15, 100011, '10/24/2010', '10:05:00 AM')




SELECT * FROM GarmentLoaded
SELECT * FROM ScanHistory SELECT * FROM ScanGarm
SELECT * FROM GarmentUnloaded

DELETE FROM GarmentLoaded
DELETE FROM GarmentUnloaded


SELECT * FROM TotalRemainingGarments -- trg.TotalRemaining
SELECT * FROM TotalCompleteGarmsOnTicket -- tcg.TotalComplete
SELECT * FROM TotalGarmsOnTicket -- tg_v.TotalOnTicket
SELECT * FROM AgingTickets


