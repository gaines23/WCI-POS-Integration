SELECT Phone, GarmentNumber, TicketNumber, SlotNum, SlotNum_1, SlotNum_2, SlotNum_3, SlotNum_4 FROM ScanGarm WHERE Phone = 6191111111	AND SlotNum IS NOT NULL
SELECT Phone, GarmentNumber, TicketNumber, SlotNum, SlotNum_1, SlotNum_2, SlotNum_3, SlotNum_4 FROM ScanGarm WHERE Phone = 6191111115	AND SlotNum IS NOT NULL
SELECT Phone, GarmentNumber, TicketNumber, SlotNum, SlotNum_1, SlotNum_2, SlotNum_3, SlotNum_4 FROM ScanGarm WHERE Phone = 6191111116	AND SlotNum IS NOT NULL
SELECT Phone, GarmentNumber, TicketNumber, SlotNum, SlotNum_1, SlotNum_2, SlotNum_3, SlotNum_4 FROM ScanGarm WHERE Phone = 6191111118	AND SlotNum IS NOT NULL


SELECT * FROM GarmentLoaded


SELECT * FROM Inventory WHERE GarmentNumber = 966185

CREATE TRIGGER UpdateSlotNumberInv
ON Inventory
AFTER INSERT
AS
BEGIN
	UPDATE ScanGarm
	SET
		SlotNum = i.SlotNumber
	FROM
		Inventory AS i JOIN ScanGarm AS sg ON i.GarmentNumber = sg.GarmentNumber
END

DROP TRIGGER UpdateSlotNumberInv

SELECT * FROM ScanGarm

INSERT INTO GarmentLoaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES ('GarmentLoaded',6191111111, 182, 966198, 155, '' ,'10/30/2021', '18:12:10');
INSERT INTO GarmentLoaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES ('GarmentLoaded',6191111115, 80, 966189, 13, '' ,'10/30/2021', '18:12:10');
INSERT INTO GarmentLoaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES ('GarmentLoaded',6191111115, 80, 966190, 244, '' ,'10/30/2021', '18:12:10');


INSERT INTO GarmentLoaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES ('GarmentLoaded',6191111116, 163, 966187, 233, '' ,'10/30/2021', '18:12:10');
INSERT INTO GarmentLoaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES ('GarmentLoaded',6191111116, 163, 966181, 111, '' ,'10/30/2021', '18:12:10');
INSERT INTO GarmentLoaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES ('GarmentLoaded',6191111116, 163, 966123, 34, '' ,'10/30/2021', '18:12:10');

INSERT INTO GarmentLoaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES ('GarmentLoaded',6191111118, 169, 156456, 45, '' ,'10/30/2021', '18:12:10');
INSERT INTO GarmentLoaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES ('GarmentLoaded',6191111118, 169, 169654, 90, '' ,'10/30/2021', '18:12:10');
INSERT INTO GarmentLoaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES ('GarmentLoaded',6191111118, 169, 135486, 177, '' ,'10/30/2021', '18:12:10');
INSERT INTO GarmentLoaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES ('GarmentLoaded',6191111118, 169, 966688, 288, '' ,'10/30/2021', '18:12:10');




INSERT INTO GarmentLoaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES ('GarmentLoaded',6191111111, 182, 966202, 12, '' ,'10/30/2021', '18:12:10');

INSERT INTO GarmentLoaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES ('GarmentLoaded',6191111111, 182, 966201, 1, '' ,'10/30/2021', '18:12:10');

INSERT INTO GarmentLoaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES ('GarmentLoaded',6191111111, 182, 966200, 23, '' ,'10/30/2021', '18:12:10');











INSERT INTO GarmentLoaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES ('GarmentLoaded',6191111111, 182, 966199, 14, '' ,'10/30/2021', '18:12:10');
INSERT INTO GarmentLoaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES ('GarmentLoaded',6191111111, 182, 966197, 14, '' ,'10/30/2021', '18:12:10');







INSERT INTO GarmentLoaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES ('GarmentLoaded',6191111115, 80, 966189, 56, '' ,'10/30/2021', '18:12:10');
INSERT INTO GarmentLoaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES ('GarmentLoaded',6191111115, 80, 966190, 87, '' ,'10/30/2021', '18:12:10');
INSERT INTO GarmentLoaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES ('GarmentLoaded',6191111117, 164, 966185, 34, '' ,'10/30/2021', '18:12:10');
INSERT INTO GarmentLoaded(TransactionType, AccountNumber, TicketNumber, GarmentNumber, SlotNumber, RFID_BARCODE, TransactionDate, TransactionTime)
VALUES ('GarmentLoaded',6191111117, 164, 966186, 21, '' ,'10/30/2021', '18:12:10');