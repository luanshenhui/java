using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Configuration;
using System.IO.Ports;
using System.Web;
using System.Net.Http;
using System.Net;

namespace ConnectKetsuatsu
{
    public partial class mainForm : Form
    {

        // 起動時引数の数
        private int ArgsLength { get;}
        // 起動時キー
        private string ExecKey { get;}
        // 当日ID
        private string DayID { get;}
        // トークン
        private string Token { get;}

        private delegate void Delegate_RcvDataToTextBox(string data);

        // コンストラクタ
        public mainForm(int argsLength, string token = "", string execKey = "", string dayID = "")
        {
            Token = token;
            ExecKey = execKey;
            DayID = dayID;
            ArgsLength = argsLength;

            CheckExecuteParam();
            //            mainForm.BackColor = Color.FromArgb(0x49, 0x49, 0x49); ;

            InitializeComponent();
        }

        private void CheckExecuteParam()
        {

            Boolean isError = true;

            while(true)
            {

                // 起動時引数が3じゃないならエラー
                if (ArgsLength != 3)
                {
                    MessageBox.Show("起動時のコマンドライン引数が正しく設定されていません",
                                                        "処理の中断",
                                                        MessageBoxButtons.OK,
                                                        MessageBoxIcon.Error);
                    break;
                }

                //MessageBox.Show("Token=" + Token);
                //MessageBox.Show("ExecKey=" + ExecKey);
                //MessageBox.Show("DayID=" + DayID);
                //MessageBox.Show("ArgsLength=" + ArgsLength);

                int tmp;
                if(! int.TryParse(DayID, out tmp))
                {
                    MessageBox.Show("当日IDが正しくありません。(dayid=" + DayID + ")",
                                                        "処理の中断",
                                                        MessageBoxButtons.OK,
                                                        MessageBoxIcon.Error);
                    break;
                }

                //if (!int.TryParse(ExecKey, out tmp))
                //{
                //    MessageBox.Show("ExecKeyが正しくありません",
                //                                        "処理の中断",
                //                                        MessageBoxButtons.OK,
                //                                        MessageBoxIcon.Error);
                //    break;
                //}

                isError = false;
                break;
            }

            if (isError)
            {
                //アプリケーションを終了する
                this.Close();
//                Application.Exit();
            }
        }

        private void mainForm_Load(object sender, EventArgs e)
        {


            // ディスプレイ右下に自身を配置する
            int left = Screen.PrimaryScreen.WorkingArea.Width - this.Width;
            int top = Screen.PrimaryScreen.WorkingArea.Height - this.Height;
            DesktopBounds = new Rectangle(left, top, this.Width, this.Height);

            // 画面上に引数を表示
            paramDayID.Text = DayID;
            paramExecKey.Text = ExecKey;


            //???? 列挙体にないものを設定された場合のエラートラップをどうするか？

            // シリアルポート.
            mainSerialPort.PortName = ConfigurationManager.AppSettings["PortName"];
            // ボーレート.
            mainSerialPort.BaudRate = Convert.ToInt32(ConfigurationManager.AppSettings["BaudRate"]);
            // データビット.
            mainSerialPort.DataBits = Convert.ToInt32(ConfigurationManager.AppSettings["DataBits"]);
            // パリティビット.
            mainSerialPort.Parity = (Parity)Enum.ToObject(typeof(Parity), Convert.ToInt32(ConfigurationManager.AppSettings["Parity"]));
            // ストップビット.
            mainSerialPort.StopBits = (StopBits)Enum.ToObject(typeof(StopBits), Convert.ToInt32(ConfigurationManager.AppSettings["StopBits"]));
            // フロー制御.
            mainSerialPort.Handshake = (Handshake)Enum.ToObject(typeof(Handshake), Convert.ToInt32(ConfigurationManager.AppSettings["Handshake"]));
            // 文字コード.
            mainSerialPort.Encoding = Encoding.Unicode;
        
            // 画面テキストボックスに現状設定値を表示する（デバッグ用）
            logTextBox.Text += "Parity:" + Enum.GetName(typeof(Parity), mainSerialPort.Parity) + Environment.NewLine;
            logTextBox.Text += "StopBits:" + Enum.GetName(typeof(StopBits), mainSerialPort.StopBits) + Environment.NewLine;
            logTextBox.Text += "Handshake:" + Enum.GetName(typeof(Handshake), mainSerialPort.Handshake) + Environment.NewLine;

            try
            {
                
                // シリアルポートをオープンする.
                mainSerialPort.Open();

            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }

        }

        private void mainSerialPort_DataReceived(object sender, System.IO.Ports.SerialDataReceivedEventArgs e)
        {

            int bytesRead = 0;
            var buffer = new byte[0];

            try
            {

                // 受信バッファにデータがなくなるまで繰り返し読込む
                while (true)
                {
                    if (0 == mainSerialPort.BytesToRead)
                    {
                        break;
                    }

                    // byte配列を今回受信バイト数分拡張し、データ取得
                    Array.Resize(ref buffer, buffer.Length + mainSerialPort.BytesToRead);
                    bytesRead = mainSerialPort.Read(buffer, 0, mainSerialPort.BytesToRead);

                    // シリアルポートの受信バッファには、
                    // ・必要なブロックの途中から受信している。
                    // ・次のブロックの先頭部分も受信されている。
                    // 可能性があるので、ここで必要なブロックだけRead()できたことを確認する。
                    //                    if (必要なブロックが正常に読めたか確認する関数())
                    //                   {
                    //                       break;
                    //                   }


                }
            }
            catch (Exception ex)
            {
                //★適切なエラートラップは何か？
                MessageBox.Show(ex.Message);
            }

            foreach (byte b in buffer)
            {

                Console.WriteLine(Convert.ToString(b, 16));

                if (b > 13)
                {
//                    Console.WriteLine(Convert.ToString(b, 16));
//                    Console.WriteLine(Encoding.GetEncoding("Shift_JIS").GetString(b));
                }

            }

            //エンコード
            string txtbuffer = Encoding.GetEncoding("Shift_JIS").GetString(buffer);

            //! 受信したデータをテキストボックスに書き込む.
            Invoke(new Delegate_RcvDataToTextBox(RcvDataToTextBox), new Object[] { txtbuffer });

            string str = Encoding.ASCII.GetString(buffer, 0, buffer.Length);

            putKetsuatsuData(txtbuffer);

        }


        /****************************************************************************/
        /*!
		 *	@brief	受信データをテキストボックスに書き込む.
		 *
		 *	@param	[in]	data	受信した文字列.
		 *
		 *	@retval	なし.
		 */
        private void RcvDataToTextBox(string data)
        {
            //! 受信データをテキストボックスの最後に追記する.
            if (data != null)
            {
                dataTextBox.AppendText(data);
            }
        }

        private void putKetsuatsuData(string receivedData)
        {

            // 受信済みデータが妥当かどうかのバリデーション（例えば日付のあたりとかをチェックしてみる）

            // ★適切なエラートラップとは何か？

            // とった値からPOST形式に組み立てる

            // サーバに投げる

            // 一見落着でアプリケーション終了


        }

        private void cancelButton_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private Boolean interruptConnect()
        {

            //メッセージボックスを表示する
            DialogResult result = MessageBox.Show("データ受信を中断しますか？",
                                                    "処理の中断",
                                                    MessageBoxButtons.YesNo,
                                                    MessageBoxIcon.Question,
                                                    MessageBoxDefaultButton.Button2);

            if (result.Equals(DialogResult.Yes))
            {
                return true;
            }

            return false;

        }

        private void mainForm_FormClosing(object sender, FormClosingEventArgs e)
        {

            if (interruptConnect().Equals(false))
            {
                e.Cancel = true;
            }

        }

        private void label4_Click(object sender, EventArgs e)
        {

        }

        private void SendButton_Click(object sender, EventArgs e)
        {
            var values = new BloodPressureModel()
            {
                RsvNo = int.Parse(DayID),
                PostClass = "BP",
                BloodPressureH = 120.3,
                BloodPressureL = 61.1,
                Pulse = 63
            };

            SendBloodPressureData(values);
        }

        private void SendBloodPressureData(BloodPressureModel values)
        {
            // パラメータ設定
            HttpContent postParams = BuildQueryParam(values);

            try
            {
                var postTask = Task.Run(() => PostClientDeviceData(int.Parse(ExecKey), postParams));
                postTask.Wait();

                // ステータスコードが201なら終了
                if (postTask.Result.StatusCode == HttpStatusCode.Created)
                {
                    return;
                }

                if (postTask.Result.StatusCode == HttpStatusCode.Unauthorized)
                {
                    MessageBox.Show("認証に失敗しました。", "認証失敗",  MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }

                DialogResult result = MessageBox.Show("送信に失敗したため再送再送します。よろしいですか。", "送信失敗", MessageBoxButtons.YesNo);
                if (result == DialogResult.Yes)
                {
                    SendBloodPressureData(values);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        /// <summary>
        /// POSTデータ作成
        /// </summary>
        /// <param name="values">血圧データ</param>
        /// <returns>POSTデータ</returns>
        private HttpContent BuildQueryParam(BloodPressureModel values)
        {

            var postDataBuilder = new QueryParamBuilder();

            postDataBuilder
                .Add("rsvno", values.RsvNo.ToString())
                .Add("postclass", values.PostClass)
                .Add("bloodpressureh", values.BloodPressureH.ToString())
                .Add("bloodpressurel", values.BloodPressureL.ToString())
                .Add("pulse", values.Pulse.ToString());
            
            return postDataBuilder.Build();
        }

        /// <summary>
        /// POSTリクエストを送信する
        /// </summary>
        /// <returns>HTTPレスポンス</returns>
        private async Task<HttpResponseMessage> PostClientDeviceData(int execKey, HttpContent content)
        {
            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri(ConfigurationManager.AppSettings["Url"]);

                // トークンセット
                client.DefaultRequestHeaders.Add("Authorization", "Bearer " + Token);

                HttpResponseMessage responseMessage = null;
                try
                {
                    // POSTリクエスト発行
                    responseMessage = await client.PostAsync("/api/clientdevicedata/" + execKey.ToString(), content);

                    if (responseMessage.StatusCode != HttpStatusCode.Created && responseMessage.StatusCode != HttpStatusCode.Unauthorized)
                    {
                        throw new Exception(string.Format("想定外のレスポンスコードが戻されました[Code = {0}]", responseMessage.StatusCode.ToString()));
                    }
                }
                catch (Exception ex)
                {
                    if (responseMessage == null)
                    {
                        responseMessage = new HttpResponseMessage();
                    }
                    responseMessage.StatusCode = HttpStatusCode.InternalServerError;
                    responseMessage.ReasonPhrase = string.Format("RestHttpClient.SendRequest failed: {0}", ex.Message);
                }
                return responseMessage;
            }
        }
    }
}
