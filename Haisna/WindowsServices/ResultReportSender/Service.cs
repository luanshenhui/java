using Fujitsu.Hainsi.WindowServices.Common;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.ServiceProcess;
using System.Text;

namespace Fujitsu.Hainsi.WindowServices.ResultReportSender
{
    public partial class Service : ServiceBase
    {
        /// <summary>電文応答コードの種別</summary>
        private enum Response
        {
            Ok,
            Retry,
            Skip,
            Down,
            Else
        }

        /// <summary>エンコーディング</summary>
        private readonly Encoding enc = Encoding.GetEncoding("shift_jis");

        public Service()
        {
            InitializeComponent();
        }

        protected override void OnStart(string[] args)
        {
            timer.Start();

            timer.Enabled = true;
        }

        protected override void OnStop()
        {
            timer.Enabled = false;

            timer.Stop();
        }

        private void timer_Elapsed(object sender, System.Timers.ElapsedEventArgs e)
        {
            List<dynamic> orderJnls = new OrderJnl().Select();

            if (orderJnls.Count <= 0)
            {
                return;
            }

            int numberOfProcess = JudgeNumberOfProcess(orderJnls);
            int count = 0;

            var distination = new Distination()
            {
                ServerAddress = ConfigurationManager.AppSettings["ServerAddress"],
                ServerPort = int.Parse(ConfigurationManager.AppSettings["ServerPort"]),
                TimeOut = int.Parse(ConfigurationManager.AppSettings["TimeOut"])
            };

            var client = new Sender(distination, ActionByResponse);

            foreach (var orderJnl in orderJnls)
            {
                count++;
                if (count > numberOfProcess)
                {
                    break;
                }

                var messageMaker = new MessageMaker();
                byte[] message = messageMaker.Make(orderJnl.RSVNO);
                    
                client.Send(message);
            }
        }

        /// <summary>
        /// レポート作成数を返す
        /// </summary>
        /// <param name="orderJnls"></param>
        /// <returns></returns>
        private int JudgeNumberOfProcess(List<dynamic> orderJnls)
        {
            int maxCount;
            int.TryParse(ConfigurationManager.AppSettings["MaxSendReportCount"], out maxCount);

            int count = orderJnls.Count;

            if (maxCount > 0 && count < maxCount || maxCount <= 0)
            {
                return count;
            }

            return maxCount;

        }

        /// <summary>
        /// ファイルを読み込み、送信用のバイト列に変換する
        /// </summary>
        /// <returns>送信用バイト列</returns>
        //private byte[] MakeByteStream()
        //{
        //    var messageMaker = new MessageMaker();
        //    List<byte[]> reports = messageMaker.Make();

        //    byte[] message = default(byte[]);
        //    foreach (var report in reports)
        //    {
        //        message = message.Concat(report).ToArray();
        //    }

        //    return message;
        //}

        private void ActionByResponse(byte[] response)
        {
            //MessageBox.Show(Encoding.UTF8.GetString(response));
        }
    }
}
