using System.Threading;


namespace ADC_Pos_Integration
{
    static class Program
    {
        public static void Main(string[] args)
        {

#if true
            Service1 s = new Service1();
            s.OnDebug();

            Thread.Sleep(Timeout.Infinite);

#else
            ServiceBase[] ServicesToRun;
            ServicesToRun = new ServiceBase[]
            {
                new Service1()
            };
            ServiceBase.Run(ServicesToRun);

#endif



        }

    }
}
