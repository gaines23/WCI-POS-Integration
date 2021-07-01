using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace ADC_Pos_Integration
{
    class ChangeLog
    {
        public static class Logger
        {
            public static void POSLog(string message)
            {

                string Message = String.Format("{0} {1} {2}", message, DateTime.Now.ToString(), Environment.NewLine);
                File.AppendAllText(AppDomain.CurrentDomain.BaseDirectory + "PosChangeLog.txt", Message);
            }

            public static void WCLog(string message)
            {
                string Message = String.Format("{0} {1} {2}", message, DateTime.Now.ToString(), Environment.NewLine);
                File.AppendAllText(AppDomain.CurrentDomain.BaseDirectory + "WcChangeLog.txt", Message);
            }
        }
    }
}

