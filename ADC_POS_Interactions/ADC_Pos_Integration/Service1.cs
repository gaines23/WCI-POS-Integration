using System.ServiceProcess;

namespace ADC_Pos_Integration
{
    public partial class Service1 : ServiceBase
    {
        public Service1()
        {
            InitializeComponent();
        }

        public void OnDebug()
        {
            OnStart(null);
        }

        protected override void OnStart(string[] args)
        {
            _ = new FileWatcher();
            _ = new SQLtoPOS();
        }

        protected override void OnStop()
        {

        }
    }
}
