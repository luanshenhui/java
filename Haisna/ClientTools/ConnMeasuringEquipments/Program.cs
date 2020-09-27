using System;
using System.Windows.Forms;

namespace ConnMeasuringEquipments
{
    static class Program
    {
        /// <summary>
        /// アプリケーションのメイン エントリ ポイントです。
        /// </summary>
        [STAThread]
        static void Main(string[] args)
        {

            // 血圧テスト用: dev=ketsuatsu&token=tok123&transid=123&rsvno=10001&portno=COM3&url=http://localhost:8087&debug=on
            // 身体計測テスト用: dev=shintai&token=tok123&transid=124&rsvno=99887766&portno=COM3&url=http://localhost:8087&debug=on
            // 肺機能テスト用: dev=haikinou&token=tok789&transid=1235&rsvno=30003&portno=COM4&url=http://localhost:8087&debug=on&KanjyaNo=12345678&sex=2&age=49&height=179.1&weight=72.2&name="fujitsu test"
            // 心電図テスト用: dev=shindenzu&token=tok789&transid=1236&rsvno=30003&portno=COM3&url=http://localhost8087&debug=on&perid=12345678&name=HIROKIISHIHARA&sex=1&birthday=19690315&age=49&height=179&weight=72&orderno=ORD1234567890
            // 眼圧テスト用: dev=ganatsu&token=tok456&transid=1237&rsvno=20002&portno=COM3&url=http://localhost:8087&debug=on

            // 骨密度テスト用: dev=kotsumitsudo&token=tok123&transid=12345678&rsvno=99887766&portno=COM3&url=https://localhost/&debug=on&kensano=12345678901234567890&name="HIROKI ISHIHARA"&sex=dansei&birthday=1969/03/15&height=179.1&weight=075.1&comment="This is Comment0123456789001234567890012"
            // 聴力テスト用: dev=choryoku&token=tok123&portno=COM3&url=https://localhost/&debug=on

            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            var form = new MainForm(args[0]);
            if (!form.IsDisposed)
            {
                Application.Run(form);
            }
        }
    }
}
