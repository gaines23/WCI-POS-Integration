using System;
using System.IO;

// This code below handles the SQL data processed through White Conveyors and sends
// the data back to the POS through a text file.


namespace ADC_Pos_Integration
{
    public class SQLtoPOS : EventArgs
    {

        public string WcFilePath = @"C:\\POS\\"; // CHANGE FILE PATH

        public SQLtoPOS()
        {

            FileSystemWatcher SqlFileWatcher = new FileSystemWatcher(WcFilePath);
            SqlFileWatcher.Changed += new FileSystemEventHandler(SqlFileWatcher_Changed);
            SqlFileWatcher.Deleted += new FileSystemEventHandler(SqlFileWatcher_Deleted);
            SqlFileWatcher.Renamed += new RenamedEventHandler(SqlFileWatcher_Renamed);

            SqlFileWatcher.EnableRaisingEvents = true;
        }

        private static void SqlFileWatcher_Changed(object sender, FileSystemEventArgs a)
        {
            //ChangeLog.Logger.WCLog(String.Format("WCtoPOS -- File Added: {0}, Path: {1}", a.Name, a.FullPath));

            string WcFileCopy = "CopyWCFile";
            string WcSourcePath = @"C:\POS\Print.txt"; // CHANGE FILE PATH
            string WcTargetPath = @"C:\WCI\ADC\ADC_POS_Interactions\ADC_Pos_Integration\CopyWC\"; // CHANGE FILE PATH
            string WcTime = DateTime.Now.ToString("MM-dd-yyyy h.mm.ss tt");

            string WcDestFile = Path.Combine(WcTargetPath, WcFileCopy + "  " + WcTime + ".txt");

            if (!Directory.Exists(WcTargetPath))
            {
                Directory.CreateDirectory(WcTargetPath);
            }

            File.Copy(WcSourcePath, WcDestFile, true);
            File.SetAttributes(WcDestFile, FileAttributes.Normal);

            ChangeLog.Logger.WCLog(String.Format("WCtoPOS -- File Added: {0}, Path: {1}", a.Name, a.FullPath));

        }

        private static void SqlFileWatcher_Deleted(object sender, FileSystemEventArgs a)
        {
            ChangeLog.Logger.WCLog(String.Format("WCtoPOS -- File Deleted: {0}, Path: {1}", a.Name, a.FullPath));
        }

        private static void SqlFileWatcher_Renamed(object sender, FileSystemEventArgs a)
        {
            ChangeLog.Logger.WCLog(String.Format("WCtoPOS -- File Renamed: {0}", a.Name));
        }

    }
}