

SELECT * FROM ScanGarm WHERE TicketNumber = 1115;
SELECT * FROM TicketSplit
SELECT * FROM GarmentLoaded
SELECT * FROM GarmentUnloaded



INSERT INTO GarmentLoaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES ('GarmentLoaded', 11111, 555, 01234, 2222222, 12123223, '10/30/2019', '18:12:10');
INSERT INTO GarmentLoaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES ('GarmentLoaded', 222222, 444, 01235, 2222221, 98734567, '10/18/2019', '06:12:59');
INSERT INTO GarmentLoaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES ('GarmentLoaded', 333333, 333, 01233, 2222223, 09876543, '10/17/2019', '07:13:54');
INSERT INTO GarmentLoaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES ('GarmentLoaded', 444444, 222, 01236, 2222225, 23456789, '10/10/2019', '10:11:12');
INSERT INTO GarmentLoaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES ('GarmentLoaded', 555555, 111, 01239, 2222227, 12345678, '8/10/2019', '17:15:24');



INSERT INTO GarmentUnloaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES ('GarmentUnloaded', 111111, 555, 11234, 2222222, 66666666, '10/14/2019', '18:12:10');
INSERT INTO GarmentUnloaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES ('GarmentUnloaded', 222222, 444, 11235, 2222221, 77777777, '10/18/2019', '06:12:59');
INSERT INTO GarmentUnloaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES ('GarmentUnloaded', 333333, 333, 11233, 2222223, 88888888, '10/17/2019', '07:13:54');
INSERT INTO GarmentUnloaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES ('GarmentUnloaded', 444444, 222, 11236, 2222225, 11223344, '10/18/2019', '10:11:12');
INSERT INTO GarmentUnloaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES ('GarmentUnloaded', 555555, 111, 11239, 2222227, 22331155, '8/10/2019', '17:15:24');


INSERT INTO TicketSplit(TransactionType, AccountNumber, TicketNumber, GarmentNumber, TicketMessage, TransactionDate, TransactionTime)
VALUES ('TicketSplit', 111199, 545, 21294, 'with ticket 112663', '12/10/2019', '18:12:10');
INSERT INTO TicketSplit(TransactionType, AccountNumber, TicketNumber, GarmentNumber, TicketMessage, TransactionDate, TransactionTime)
VALUES ('TicketSplit', 112111, 525, 21213, 'with 36622', '10/1/2019', '18:12:10');
INSERT INTO TicketSplit(TransactionType, AccountNumber, TicketNumber, GarmentNumber, TicketMessage, TransactionDate, TransactionTime)
VALUES ('TicketSplit', 111111, 555, 21234, 'with 11111', '10/10/2019', '18:12:10');
INSERT INTO TicketSplit(TransactionType, AccountNumber, TicketNumber, GarmentNumber, TicketMessage, TransactionDate, TransactionTime)
VALUES ('TicketSplit', 222222, 444, 21235, 'with ticket 2222', '3/8/2019', '06:12:59');
INSERT INTO TicketSplit(TransactionType, AccountNumber, TicketNumber, GarmentNumber, TicketMessage, TransactionDate, TransactionTime)
VALUES ('TicketSplit', 333333, 333, 21233, 'with ticket 2222', '4/25/2019', '07:13:54');
INSERT INTO TicketSplit(TransactionType, AccountNumber, TicketNumber, GarmentNumber, TicketMessage, TransactionDate, TransactionTime)
VALUES ('TicketSplit', 444444, 222, 21236, 'with ticket 11122', '5/18/2019', '10:11:12');
INSERT INTO TicketSplit(TransactionType, AccountNumber, TicketNumber, GarmentNumber, TicketMessage, TransactionDate, TransactionTime)
VALUES ('TicketSplit', 555555, 111, 21239, 'with tiket 222000', '8/10/2019', '17:15:24');



INSERT INTO TicketComplete(TransactionType, AccountNumber, TicketNumber, GarmentNumber, TransactionDate, TransactionTime)
VALUES ('TicketComplete', 111111, 555, 31234, '10/10/2019', '18:12:10');

INSERT INTO TicketComplete(TransactionType, AccountNumber, TicketNumber, GarmentNumber, TransactionDate, TransactionTime)
VALUES ('TicketComplete', 222222, 444, 31235, '10/18/2019', '06:12:59');

INSERT INTO TicketComplete(TransactionType, AccountNumber, TicketNumber, GarmentNumber, TransactionDate, TransactionTime)
VALUES ('TicketComplete', 333333, 13, 31233, '10/17/2019', '07:13:54');

INSERT INTO TicketComplete(TransactionType, AccountNumber, TicketNumber, GarmentNumber, TransactionDate, TransactionTime)
VALUES ('TicketComplete', 444444, 12, 31236, '10/18/2019', '10:11:12');

INSERT INTO TicketComplete(TransactionType, AccountNumber, TicketNumber, GarmentNumber, TransactionDate, TransactionTime)
VALUES ('TicketComplete', 555555, 11, 31239, '12/12/2019', '17:15:24');


UPDATE ScanGarm
SET TicketSplitChoice = 2
WHERE TicketSplitChoice IS NULL


DELETE FROM Ticketcomplete WHERE TicketNumber = 13;


INSERT INTO TicketComplete(TransactionType, AccountNumber, TicketNumber, GarmentNumber, TransactionDate, TransactionTime)
VALUES ('TicketComplete', 435555, 2311, 43539, '12/12/2019', '17:15:24');

INSERT INTO TicketComplete(TransactionType, AccountNumber, TicketNumber, GarmentNumber, TransactionDate, TransactionTime)
VALUES ('TicketComplete', 4333555, 2451, 2020202, '12/12/2019', '17:15:24');

INSERT INTO TicketComplete(TransactionType, AccountNumber, TicketNumber, GarmentNumber, TransactionDate, TransactionTime)
VALUES ('TicketComplete', 12125, 43651, 0090202, '12/12/2019', '17:15:24');


INSERT INTO GarmentCreate(GarmCusAcctID, TicketNumber, GarmentNumber, TransactionDate, TransactionTime)
VALUES (435555, 2311, 43539, '12/12/2019', '12:15:24');

INSERT INTO GarmentCreate(GarmCusAcctID, TicketNumber, GarmentNumber, TransactionDate, TransactionTime)
VALUES (4333555, 2451, 2020202, '12/12/2019', '12:15:24');

INSERT INTO GarmentCreate(GarmCusAcctID, TicketNumber, GarmentNumber, TransactionDate, TransactionTime)
VALUES (12125, 43651, 0090202, '12/12/2019', '12:15:24');

INSERT INTO GarmentCreate(TransactionType, GarmCusAcctID, TicketNumber, GarmentNumber, TransactionDate, TransactionTime)
VALUES ('GarmentCreate', 111111, 555, 31234, '12/12/2019', '18:12:10');

INSERT INTO GarmentCreate(TransactionType, GarmCusAcctID, TicketNumber, GarmentNumber, TransactionDate, TransactionTime)
VALUES ('GarmentCreate', 222222, 444, 31235, '12/12/2019', '06:12:59');

INSERT INTO GarmentCreate(TransactionType, GarmCusAcctID, TicketNumber, GarmentNumber, TransactionDate, TransactionTime)
VALUES ('GarmentCreate', 333333, 333, 31233, '12/12/2019', '07:13:54');

INSERT INTO GarmentCreate(TransactionType, GarmCusAcctID, TicketNumber, GarmentNumber, TransactionDate, TransactionTime)
VALUES ('GarmentCreate', 444444, 222, 31236, '12/12/2019', '10:11:12');

INSERT INTO GarmentCreate(TransactionType, GarmCusAcctID, TicketNumber, GarmentNumber, TransactionDate, TransactionTime)
VALUES ('GarmentCreate', 555555, 111, 31239, '12/12/2019', '17:15:24');


SELECT * FROM ScanGarm WHERE TotalOnTicket = 3;
SELECT * FROM TicketCreate Where TicketNumber = 'A1122';


/* SELECT and DELETE STATEMENTS

++SELECT * FROM GarmentCreate;
SELECT * FROM TicketCreate;
SELECT * FROM CustomerCreate WHERE Phone = '6665840';
SELECT * FROM ScanGarm WHERE TicketNumber = '182'
SELECT * FROM GarmentLoaded;
SELECT * FROM GarmentUnloaded;
SELECT * FROM CombinedTables;
SELECT * FROM CusTicGarmHistory
SELECT * FROM TicketComplete;
SELECT * FROM Inventory;
SELECT * FROM History;

SELECT * FROM TicketReissue;
SELECT * FROM TicketSplit;
DELETE FROM TicketSplit;


DELETE FROM SCANGARM WHERE ACCOUNTNUMBER = 0
UPDATE ScanGarm
SET TicketSplitChoice = 3
WHERE TicketNumber = 1115;

SELECT * FROM ScanGarm;
SELECT * FROM ScanGarm WHERE TicketNumber = 182;
SELECT * FROM GarmentLoaded;
SELECT * FROM GarmentUnloaded;

USE POS_Test;

Select Count(AccountNumber) from scangarm WHERE AccountNumber = Phone group by ticketnumber;
SELECT Dist(TicketNumber) FROM ScanGarm Where AccountNumber = Phone

DELETE FROM TicketComplete;
DELETE FROM GarmentLoaded;
DELETE FROM GarmentUnloaded;
DELETE FROM CombinedTables;
DELETE FROM ScanGarm;
DELETE FROM CusTicGarmHistory;
DELETE FROM GarmentCreate;
DELETE FROM TicketCreate;
DELETE FROM CustomerCreate;
DELETE FROM TicketTable;
DELETE FROM Inventory;
DELETE FROM History;
DELETE FROM ScanHistory;

*/