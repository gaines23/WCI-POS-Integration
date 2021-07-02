using System;
using System.IO;
using System.Data.SqlClient;


// This code handles the incoming POS data from a text file. The code sorts through each 
// column of data to send to SQL for White to process on our end. 

namespace ADC_Pos_Integration
{

    public class FileWatcher : EventArgs
    {
        public string PosFile = @"C:\\POS\\";

        public FileWatcher()
        {
            FileSystemWatcher fileWatcher = new FileSystemWatcher(PosFile); // CHANGE FILE PATH

            fileWatcher.Changed += new FileSystemEventHandler(FileWatcher_Changed);
            fileWatcher.Deleted += new FileSystemEventHandler(FileWatcher_Deleted);
            fileWatcher.Renamed += new RenamedEventHandler(FileWatcher_Renamed);

            fileWatcher.EnableRaisingEvents = true;
        }

        // FileWatcher is used to sort the data into the specific tables in SQL and assigns the 
        // correct variable type to each column

        private static void FileWatcher_Changed(object sender, FileSystemEventArgs e)
        {

            ChangeLog.Logger.POSLog(String.Format("POS -- File Added: {0}, Path: {1}", e.Name, e.FullPath));

            try
            {
                using (StreamReader sr = new StreamReader("C:\\POS\\POS.txt"))// CHANGE FILE PATH
                {
                    Console.WriteLine("Reading File {0}", "POS.txt");
                    string line;
                    while ((line = sr.ReadLine()) != null)
                    {
                        string[] linePOS = line.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                        string sqlQuery = "";
                        string queryType = "";
                        switch (linePOS[0])
                        {
                            case "\"CUSTOMER_CREATE\"":

                                queryType = "INSERT";
                                sqlQuery =
                                    "INSERT INTO CustomerCreate (TransactionType, AccountNumber, Phone, LastName, FirstName, Address, Address2, City, State, ZipCode, TransactionDate, TransactionTime)" +
                                    "VALUES (@TransactionType, @AccountNumber, @Phone, @LastName, @FirstName, @Address, @Address2, @City, @State, @ZipCode, @TransactionDate, @TransactionTime)";
                                using (SqlConnection conn = new SqlConnection())
                                {
                                    conn.ConnectionString = "Data Source= GAINES-WCI\\WCI; " + // CHANGE SQL SERVER NAME (ex: LAPTOP-2I3I5GAU\\WCTEST)
                                                            "Initial Catalog=ADC;" +
                                                            "Integrated Security=True;";
                                    conn.Open();
                                    using (SqlCommand command = new SqlCommand(sqlQuery, conn))
                                    {
                                        command.Parameters.AddWithValue("@TransactionType", linePOS[0].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@AccountNumber", linePOS[1].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@Phone", linePOS[2].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@LastName", linePOS[3].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@FirstName", linePOS[4].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@Address", linePOS[5].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@Address2", linePOS[6].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@City", linePOS[7].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@State", linePOS[8].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@ZipCode", linePOS[9].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@TransactionDate", linePOS[10].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@TransactionTime", linePOS[11].Trim(' ', '"'));
                                        command.ExecuteNonQuery();
                                    }

                                }
                                break;

                            case "\"GARMENT_CREATE\"":
                                queryType = "INSERT";

                                sqlQuery =
                                    "INSERT INTO GarmentCreate(TransactionType, AccountNumber, TicketNumber, GarmentNumber, GarmDescription, ServicePrice, ServiceType, GarmType, GarmColor, GarmFabric, TransactionDate, TransactionTime) " +
                                    "VALUES (@TransactionType, @AccountNumber, @TicketNumber, @GarmentNumber, @GarmDescription, @ServicePrice, @ServiceType, @GarmType, @GarmColor, @GarmFabric, @TransactionDate, @TransactionTime)";
                                using (SqlConnection conn = new SqlConnection())
                                {
                                    conn.ConnectionString = "Data Source= GAINES-WCI\\WCI; " + // CHANGE SQL SERVER NAME (ex: LAPTOP-2I3I5GAU\\WCTEST)
                                                            "Initial Catalog=ADC;" +
                                                            "Integrated Security=True;";
                                    conn.Open();
                                    using (SqlCommand command = new SqlCommand(sqlQuery, conn))
                                    {
                                        command.Parameters.AddWithValue("@TransactionType", linePOS[0].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@AccountNumber", linePOS[1].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@TicketNumber", linePOS[2].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@GarmentNumber", linePOS[3].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@GarmDescription", linePOS[4].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@ServicePrice", linePOS[5].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@ServiceType", linePOS[6].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@GarmType", linePOS[7].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@GarmColor", linePOS[8].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@GarmFabric", linePOS[9].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@TransactionDate", linePOS[10].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@TransactionTime", linePOS[11].Trim(' ', '"'));
                                        command.ExecuteNonQuery();
                                    }
                                }

                                break;

                            case "\"TICKET_CREATE\"":
                                queryType = "INSERT";
                                sqlQuery =
                                    "INSERT INTO TicketCreate(TransactionType, AccountNumber, TicketNumber, PickupDate, PickupTime, PlantID, RouteID, StoreID, TransactionDate, TransactionTime)" +
                                    "Values (@TransactionType, @AccountNumber, @TicketNumber, @PickupDate, @PickupTime, @PlantID, @RouteID, @StoreID, @TransactionDate, @TransactionTime)";
                                using (SqlConnection conn = new SqlConnection())
                                {
                                    conn.ConnectionString = "Data Source= GAINES-WCI\\WCI; " + // CHANGE SQL SERVER NAME (ex: LAPTOP-2I3I5GAU\\WCTEST)
                                                            "Initial Catalog=ADC;" +
                                                            "Integrated Security=True;";
                                    conn.Open();
                                    using (SqlCommand command = new SqlCommand(sqlQuery, conn))
                                    {
                                        command.Parameters.AddWithValue("@TransactionType", linePOS[0].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@AccountNumber", linePOS[1].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@TicketNumber", linePOS[2].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@PickupDate", linePOS[3].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@PickupTime", linePOS[4].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@PlantID", linePOS[5].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@RouteID", linePOS[6].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@StoreID", linePOS[7].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@TransactionDate", linePOS[8].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@TransactionTime", linePOS[9].Trim(' ', '"'));
                                        command.ExecuteNonQuery();
                                    }
                                }

                                break;

                            case "\"CUSTOMER_MODIFY\"":
                                queryType = "INSERT";
                                sqlQuery =
                                    "INSERT INTO CustomerModify(TransactionType, AccountNumber, Phone, LastName, FirstName, Address, Address2, City, State, ZipCode, TransactionDate, TransactionTime)" +
                                    "Values (@TransactionType, @AccountNumber, @Phone, @LastName, @FirstName, @Address, @Address2, @City, @State, @ZipCode, @TransactionDate, @TransactionTime)";
                                using (SqlConnection conn = new SqlConnection())
                                {
                                    conn.ConnectionString = "Data Source= GAINES-WCI\\WCI; " + // CHANGE SQL SERVER NAME (ex: LAPTOP-2I3I5GAU\\WCTEST)
                                                            "Initial Catalog=ADC;" +
                                                            "Integrated Security=True;";
                                    conn.Open();
                                    using (SqlCommand command = new SqlCommand(sqlQuery, conn))
                                    {
                                        command.Parameters.AddWithValue("@TransactionType", linePOS[0].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@AccountNumber", linePOS[1].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@Phone", linePOS[2].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@LastName", linePOS[3].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@FirstName", linePOS[4].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@Address", linePOS[5].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@Address2", linePOS[6].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@City", linePOS[7].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@State", linePOS[8].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@ZipCode", linePOS[9].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@TransactionDate", linePOS[10].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@TransactionTime", linePOS[11].Trim(' ', '"'));
                                        command.ExecuteNonQuery();
                                    }
                                }

                                break;

                            case "\"TICKET_MODIFY\"":
                                queryType = "INSERT";
                                sqlQuery =
                                    "INSERT INTO TicketModify(TransactionType, AccountNumber, TicketNumber, PickupDate, PickupTime, PlantID, RouteID, StoreID, TransactionDate, TransactionTime)" +
                                    "Values (@TransactionType, @AccountNumber, @TicketNumber, @PickupDate, @PickupTime, @PlantID, @RouteID, @StoreID, @TransactionDate, @TransactionTime)";
                                using (SqlConnection conn = new SqlConnection())
                                {
                                    conn.ConnectionString = "Data Source= GAINES-WCI\\WCI; " + // CHANGE SQL SERVER NAME (ex: LAPTOP-2I3I5GAU\\WCTEST)
                                                            "Initial Catalog=ADC;" +
                                                            "Integrated Security=True;";
                                    conn.Open();
                                    using (SqlCommand command = new SqlCommand(sqlQuery, conn))
                                    {
                                        command.Parameters.AddWithValue("@TransactionType", linePOS[0].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@AccountNumber", linePOS[1].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@TicketNumber", linePOS[2].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@PickupDate", linePOS[3].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@PickupTime", linePOS[4].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@PlantID", linePOS[5].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@RouteID", linePOS[6].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@StoreID", linePOS[7].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@TransactionDate", linePOS[8].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@TransactionTime", linePOS[9].Trim(' ', '"'));
                                        command.ExecuteNonQuery();
                                    }
                                }

                                break;

                            case "\"GARMENT_MODIFY\"":
                                queryType = "INSERT";

                                sqlQuery =
                                    "INSERT INTO GarmentModify(TransactionType, AccountNumber, TicketNumber, GarmentNumber, GarmDescription, ServicePrice, ServiceType, GarmType, GarmColor, GarmFabric, TransactionDate, TransactionTime) " +
                                    "VALUES (@TransactionType, @AccountNumber, @TicketNumber, @GarmentNumber, @GarmDescription, @ServicePrice, @ServiceType, @GarmType, @GarmColor, @GarmFabric, @TransactionDate, @TransactionTime)";
                                using (SqlConnection conn = new SqlConnection())
                                {
                                    conn.ConnectionString = "Data Source= GAINES-WCI\\WCI; " + // CHANGE SQL SERVER NAME (ex: LAPTOP-2I3I5GAU\\WCTEST)
                                                            "Initial Catalog=ADC;" +
                                                            "Integrated Security=True;";
                                    conn.Open();
                                    using (SqlCommand command = new SqlCommand(sqlQuery, conn))
                                    {
                                        command.Parameters.AddWithValue("@TransactionType", linePOS[0].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@AccountNumber", linePOS[1].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@TicketNumber", linePOS[2].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@GarmentNumber", linePOS[3].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@GarmDescription", linePOS[4].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@ServicePrice", linePOS[5].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@ServiceType", linePOS[6].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@GarmType", linePOS[7].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@GarmColor", linePOS[8].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@GarmFabric", linePOS[9].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@TransactionDate", linePOS[10].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@TransactionTime", linePOS[11].Trim(' ', '"'));
                                        command.ExecuteNonQuery();
                                    }
                                }

                                break;

                            case "\"TICKET_CLOSED\"":
                                queryType = "INSERT";

                                sqlQuery =
                                    "INSERT INTO TicketClosed(TransactionType, AccountNumber, TicketNumber, TransactionDate, TransactionTime)" +
                                    "VALUES (@TransactionType, @AccountNumber, @TicketNumber, @TransactionDate, @TransactionTime)";
                                using (SqlConnection conn = new SqlConnection())
                                {
                                    conn.ConnectionString = "Data Source= GAINES-WCI\\WCI; " + // CHANGE SQL SERVER NAME (ex: LAPTOP-2I3I5GAU\\WCTEST)
                                                            "Initial Catalog=ADC;" +
                                                            "Integrated Security=True;";
                                    conn.Open();
                                    using (SqlCommand command = new SqlCommand(sqlQuery, conn))
                                    {
                                        command.Parameters.AddWithValue("@TransactionType", linePOS[0].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@AccountNumber", linePOS[1].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@TicketNumber", linePOS[2].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@TransactionDate", linePOS[3].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@TransactionTime", linePOS[4].Trim(' ', '"'));
                                        command.ExecuteNonQuery();
                                    }
                                }

                                break;

                            case "\"GARMENT_CLOSED\"":
                                queryType = "INSERT";

                                sqlQuery =
                                    "INSERT INTO GarmentClosed(TransactionType, AccountNumber, TicketNumber, GarmentNumber, TransactionDate, TransactionTime)" +
                                    "VALUES (@TransactionType, @GarmNumber, @TicketNumber, @AccountNumber, @TransactionDate, @TransactionTime)";
                                using (SqlConnection conn = new SqlConnection())
                                {
                                    conn.ConnectionString = "Data Source= GAINES-WCI\\WCI; " + // CHANGE SQL SERVER NAME (ex: LAPTOP-2I3I5GAU\\WCTEST)
                                                            "Initial Catalog=ADC;" +
                                                            "Integrated Security=True;";
                                    conn.Open();
                                    using (SqlCommand command = new SqlCommand(sqlQuery, conn))
                                    {
                                        command.Parameters.AddWithValue("@TransactionType", linePOS[0].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@GarmNumber", linePOS[1].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@TicketNumber", linePOS[2].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@AccountNumber", linePOS[3].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@TransactionDate", linePOS[4].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@TransactionTime", linePOS[5].Trim(' ', '"'));
                                        command.ExecuteNonQuery();
                                    }

                                }

                                break;

                            case "\"TICKET_DELETE\"":
                                queryType = "INSERT";

                                sqlQuery =
                                           "INSERT INTO TicketDelete(TransactionType, AccountNumber, TicketNumber)" +
                                           "VALUES(@TransactionType, @AccountNumber, @TicketNumber)";
                                using (SqlConnection conn = new SqlConnection())
                                {
                                    conn.ConnectionString = "Data Source= GAINES-WCI\\WCI; " + // CHANGE SQL SERVER NAME (ex: LAPTOP-2I3I5GAU\\WCTEST)
                                                            "Initial Catalog=ADC;" +
                                                            "Integrated Security=True;";
                                    conn.Open();
                                    using (SqlCommand command = new SqlCommand(sqlQuery, conn))
                                    {
                                        command.Parameters.AddWithValue("@TransactionType", linePOS[0].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@AccountNumber", linePOS[1].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@TicketNumber", linePOS[2].Trim(' ', '"'));
                                        command.ExecuteNonQuery();
                                    }
                                }

                                break;

                            case "\"GARMENT_DELETE\"":
                                queryType = "INSERT";

                                sqlQuery =
                                           "INSERT INTO GarmentDelete(TransactionType, AccountNumber, TicketNumber, GarmentNumber)" +
                                           "VALUES(@TransactionType, @AccountNumber, @TicketNumber, @GarmentNumber)";
                                using (SqlConnection conn = new SqlConnection())
                                {
                                    conn.ConnectionString = "Data Source= GAINES-WCI\\WCI; " + // CHANGE SQL SERVER NAME (ex: LAPTOP-2I3I5GAU\\WCTEST)
                                                            "Initial Catalog=ADC;" +
                                                            "Integrated Security=True;";
                                    conn.Open();
                                    using (SqlCommand command = new SqlCommand(sqlQuery, conn))
                                    {
                                        command.Parameters.AddWithValue("@TransactionType", linePOS[0].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@AccountNumber", linePOS[1].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@TicketNumber", linePOS[2].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@GarmentNumber", linePOS[3].Trim(' ', '"'));
                                        command.ExecuteNonQuery();
                                    }
                                }

                                break;

                            case "\"CUSTOMER_DELETE\"":
                                queryType = "INSERT";

                                sqlQuery = "INSERT INTO CustomerDelete(TransactionType, AccountNumber, TransactionDate, TransactionTime)" +
                                        "VALUES(@TransactionType, @AccountNumber, @TicketNumber, @GarmentNumber)";
                                using (SqlConnection conn = new SqlConnection())
                                {
                                    conn.ConnectionString = "Data Source= GAINES-WCI\\WCI; " + // CHANGE SQL SERVER NAME (ex: LAPTOP-2I3I5GAU\\WCTEST)
                                                            "Initial Catalog=ADC;" +
                                                            "Integrated Security=True;";
                                    conn.Open();
                                    using (SqlCommand command = new SqlCommand(sqlQuery, conn))
                                    {
                                        command.Parameters.AddWithValue("@TransactionType", linePOS[0].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@AccountNumber", linePOS[1].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@TransactionDate", linePOS[2].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@TransactionTime", linePOS[3].Trim(' ', '"'));
                                        command.ExecuteNonQuery();
                                    }

                                }

                                break;

                            case "\"TICKET_REISSUE\"":
                                queryType = "INSERT";

                                sqlQuery = "INSERT INTO TicketReissue(TransactionType, AccountNumber, OldTicketNumber, NewTicketNumber, GarmentNumber, TransactionDate, TransactionTime)" +
                                        "VALUES(@TransactionType, @AccountNumber, @OldTicketNumber, @NewTicketNumber, @GarmentNumber, @TransactionDate, @TransactionTime)";
                                using (SqlConnection conn = new SqlConnection())
                                {
                                    conn.ConnectionString = "Data Source= GAINES-WCI\\WCI; " + // CHANGE SQL SERVER NAME (ex: LAPTOP-2I3I5GAU\\WCTEST)
                                                            "Initial Catalog=ADC;" +
                                                            "Integrated Security=True;";
                                    conn.Open();
                                    using (SqlCommand command = new SqlCommand(sqlQuery, conn))
                                    {
                                        command.Parameters.AddWithValue("@TransactionType", linePOS[0].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@AccountNumber", linePOS[1].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@OldTicketNumber", linePOS[2].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@NewTicketNumber", linePOS[3].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@GarmentNumber", linePOS[4].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@TransactionDate", linePOS[5].Trim(' ', '"'));
                                        command.Parameters.AddWithValue("@TransactionTime", linePOS[6].Trim(' ', '"'));
                                        command.ExecuteNonQuery();
                                    }

                                }

                                break;

                            default:
                                Console.WriteLine("Unhandled line type: {0}", linePOS[0]);
                                break;
                        }

                        if (sqlQuery != "")
                        {
                            switch (queryType)
                            {
                                case "INSERT":
                                    for (int i = 1; i < linePOS.Length; i++)
                                    {
                                        sqlQuery += linePOS[i];
                                        if (i < linePOS.Length - 1)
                                            sqlQuery += ",";
                                        else
                                            sqlQuery += ");";
                                    }

                                    break;
                                default:
                                    Console.WriteLine("Bad query type: {0}", queryType);
                                    break;
                            }

                            Console.WriteLine(sqlQuery);

                        }
                    }

                    Console.WriteLine("Read File {0} Complete", "POS.txt");
                }
            }
            catch (Exception err)
            {
                Console.WriteLine("The file could not be read:");
                Console.WriteLine(err.Message);
            }

            // The "CopyPosFile" code below copies the text file from the POS to WC as a backup

            string fileName = "CopyPosFile";
            string sourcePath = @"C:\POS\POS.txt";
            string targetPath = @"C:\WCI\ADC\ADC_POS_Interactions\ADC_Pos_Integration\CopyPOS\"; // CHANGE FILE PATH
            string time = DateTime.Now.ToString("MM-dd-yyyy h.mm.ss tt");

            string destFile = Path.Combine(targetPath, fileName + "  " + time + ".txt");

            if (!Directory.Exists(targetPath))
            {
                Directory.CreateDirectory(targetPath);
            }

            File.Copy(sourcePath, destFile, true);
            File.SetAttributes(destFile, FileAttributes.Normal);
            ChangeLog.Logger.POSLog(String.Format("POS Copy -- File Added: {0}, Path: {1}", e.Name, e.FullPath));

        }

        private static void FileWatcher_Deleted(object sender, FileSystemEventArgs e)
        {
            ChangeLog.Logger.POSLog(String.Format("POStoWC -- File Deleted: {0}, Path: {1}", e.Name, e.FullPath));
        }

        private static void FileWatcher_Renamed(object sender, FileSystemEventArgs e)
        {
            ChangeLog.Logger.POSLog(String.Format("POStoWC -- File Renamed: {0}", e.Name));
        }

    }
}
