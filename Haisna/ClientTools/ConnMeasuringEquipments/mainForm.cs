using System;
using System.Collections.Specialized;
using System.Drawing;
using System.IO.Ports;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Windows.Forms;
using Newtonsoft.Json;
using System.Collections.Generic;

namespace ConnMeasuringEquipments
{
    public partial class MainForm : Form
    {

        // 対象計測器
        private string Device { get; }
        // トークン
        private string Token { get; }
        // トランザクションID
        private string TransID { get;}
        // 予約番号
        private string RsvNo { get;}
        // URL
        private string Url { get; }
        // ポート番号
        private string PortName = "";
        // 計測器オブジェクト
        private AbstractExternalDevice TargetDevice;

        // コレクションに分割された起動時パラメタ
        NameValueCollection paramCollection = null;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="queryparams">起動時パラメタ</param>
        public MainForm(string queryparams = "")
        {
            // コンポーネントの初期化
            InitializeComponent();

            // 起動時引数をコレクションに変換
            paramCollection = Utility.ParseQueryString(queryparams);

            // 指定された計測器名で共通オブジェクトをインスタンス化
            Device = paramCollection["dev"];
            switch (Device)
            {
                // 血圧
                case "ketsuatsu" :
                    TargetDevice = new KetsuatsuAgent();
                    break;
                // 眼圧
                case "ganatsu":
                    TargetDevice = new GanatsuAgent();
                    break;
                // 身体計測機
                case "shintai":
                    TargetDevice = new ShintaiAgent();
                    break;
                // 肺機能
                case "haikinou":
                    TargetDevice = new HaikinouAgent();
                    break;
                // 心電図
                case "shindenzu":
                    TargetDevice = new ShindenzuAgent();
                    break;
                // 聴力
                case "choryoku":
                    TargetDevice = new ChoryokuAgent();
                    break;
                // 骨密度
                case "kotsumitsudo":
                    TargetDevice = new KotsumitsudoAgent();
                    break;

                default:
                    // 計測器設定が正しく設定されていないならアプリケーション強制終了
                    MessageBox.Show("存在しない計測器を指定されました。(dev=" + Device + ")" + Environment.NewLine + "起動時引数を確認してください。" ,
                                                        "処理の中断",
                                                        MessageBoxButtons.OK,
                                                        MessageBoxIcon.Error);
                    // ログ出力は計測器オブジェクトのスーパークラスで実装されているため、ここではロギングしない（また、まずここでエラーになることはありえない）
                    this.Close();
                    return;

            }


            // 呼び出し元テキストボックスをエージェントにわたす（画面ログ出力用）
            TargetDevice.logTextBox = logTextBox;
            TargetDevice.UpdateTextBox = RcvDataToTextBox;

            // エージェントに起動時パラメタをセット
            TargetDevice.paramCollection = paramCollection;

            Token = paramCollection["token"];
            TransID = paramCollection["transid"];
            RsvNo = paramCollection["rsvno"];
            Url = paramCollection["url"];
            PortName = paramCollection["portno"];

            // デバッグモードを設定
            if (paramCollection["debug"] == "on")
            {
                TargetDevice.DebugMode = true;
            }

        }

        /// <summary>
        /// 起動時引数の妥当性チェック
        /// </summary>
        /// <returns>true:不正な引数が存在する</returns>
        private bool ExistsINvalidParameter()
        {

            bool isError = false;

            while(true)
            {

                // トークンが空白ならエラー
                if (Token == "")
                {
                    TargetDevice.Log("Error", "トークンが空白です。起動時引数を確認してください。");
                    isError = true;
                }

                // 聴力以外の計測器は、トランザクションIDが空白ならエラー
                if ((Device != "choryoku") && (TransID == ""))
                {
                    TargetDevice.Log("Error", "トランザクションIDが空白です。起動時引数を確認してください。");
                    isError = true;
                }

                // 聴力以外の計測器は、予約番号が空白 or 数字でないならエラー（聴力は起動時に特定できないので必然的にnullになる）
                if ((Device != "choryoku") && (!int.TryParse(RsvNo, out int tmp)))
                {
                    TargetDevice.Log("Error", "予約番号が正しくありません。(rsvno=" + RsvNo + ")　起動時引数を確認してください。");
                    isError = true;
                }
                break;
            }

            return isError;
        }

        /// <summary>
        /// メインフォーム　ロード
        /// </summary>
        /// <param name="sender">sender</param>
        /// <param name="e">イベント</param>
        private void MainForm_Load(object sender, EventArgs e)
        {

            // ※ログ出力とテキストボックスログを共通化した為ヴァリデーション等はForm_loadに実行
            // ※コンストラクタではFormが初期化されていない為、テキストボックス出力のデリゲートが失敗する

            // 起動時パラメタをログ出力する
            String execParamString = "Execute Parameters = ";
            foreach (String keyName in paramCollection.AllKeys)
            {
                string value = paramCollection[keyName];
                // デバッグモードでない、かつtokenの場合、値は*でマスクする。
                if ((keyName == "token") && (TargetDevice.DebugMode == false))
                {
                    value = "********";
                }
                execParamString += keyName + ": " + value + ", ";
            }

            // ログ開始区切り文字と起動時パラメタをログ出力
            string repeatedString = new string('=', 100);
            TargetDevice.Log("Info", repeatedString);
            TargetDevice.Log("Info", "Start! - " + execParamString);

            // 起動時パラメタは画面にも出力
            //            logTextBox.Text += execParamString + Environment.NewLine;

            // 起動時引数の妥当性をチェックする
            if (ExistsINvalidParameter())
            {
                string errMsg = "起動時引数が正しくありません。ログを確認してください。" + Environment.NewLine +
                                "path=" + TargetDevice.GetLogFileName();
                MessageBox.Show(errMsg, "処理の中断", MessageBoxButtons.OK, MessageBoxIcon.Error);
                TargetDevice.Log("Error", errMsg);
                this.Close();
                return;
            }

            // フォームサイズ初期化
            this.Size = new System.Drawing.Size(233, 221);

            // ディスプレイ右下に自身を配置する
            int left = Screen.PrimaryScreen.WorkingArea.Width - Width;
            int top = Screen.PrimaryScreen.WorkingArea.Height - Height;
            DesktopBounds = new Rectangle(left, top, Width, Height);

            // 各計測機エージェント毎に設定されたポートセッティングを行う
            // シリアルポート.
            mainSerialPort.PortName = PortName;
            // ボーレート.
            mainSerialPort.BaudRate = TargetDevice.BaudRate;
            // データビット.
            mainSerialPort.DataBits = TargetDevice.DataBits;
            // パリティビット.
            mainSerialPort.Parity = TargetDevice.Parity;
            // ストップビット.
            mainSerialPort.StopBits = TargetDevice.StopBits;
            // フロー制御.
            mainSerialPort.Handshake = TargetDevice.Handshake;
            // 文字コード.
            mainSerialPort.Encoding = TargetDevice.Encoding;

            // ポートセッティングをログ出力する
            String portSetting = "COMPort Setting = ";
            portSetting += "PortName: " + mainSerialPort.PortName + ", ";
            portSetting += "BaudRate: " + mainSerialPort.BaudRate + ", ";
            portSetting += "DataBits: " + mainSerialPort.DataBits + ", ";
            portSetting += "Parity: " + Enum.GetName(typeof(Parity), mainSerialPort.Parity) + ", ";
            portSetting += "StopBits: " + Enum.GetName(typeof(StopBits), mainSerialPort.StopBits) + ", ";
            portSetting += "Handshake: " + Enum.GetName(typeof(Handshake), mainSerialPort.Handshake) + ", ";
            portSetting += "Encoding: " + mainSerialPort.Encoding + ", ";

            // ログファイルのフルpathをログ出力する
            TargetDevice.Log("Info", "Logging File= " + TargetDevice.GetLogFileName());

            // 画面に予約番号を出力する
            labelRsvno.Text = "予約番号:" + RsvNo;

            try
            {
                // シリアルポートをオープンする.
                mainSerialPort.Open();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "処理の中断", MessageBoxButtons.OK, MessageBoxIcon.Error);
                this.Close();
                return;

            }

            // ポートオープン直後のAgentのステータスをチェックする
            CheckAgentState();

        }

        /// <summary>
        /// シリアルポートのデータ受信検知
        /// </summary>
        /// <param name="sender">sender</param>
        /// <param name="e">イベント</param>
        private void MainSerialPort_DataReceived(object sender, System.IO.Ports.SerialDataReceivedEventArgs e)
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
                    // 注: System.Threading.Thread.Sleepや重い処理を受信Loop内に絶対書かないこと！データロストします！
                    Array.Resize(ref buffer, buffer.Length + mainSerialPort.BytesToRead);
                    bytesRead = mainSerialPort.Read(buffer, 0, mainSerialPort.BytesToRead);

                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                TargetDevice.Log("Error", ex.Message);
            }

            // 受信したデータを計測機エージェントに渡す
            if (TargetDevice.EditRecievedData(buffer))
            {
                // 計測器エージェントのステータスをチェックして応じた処理を行う
                CheckAgentState();

            } else
            {

                String errMsg = "受信バッファ編集処理において異常を検知しました。処理を終了します。";
                MessageBox.Show(errMsg, "処理の中断", MessageBoxButtons.OK, MessageBoxIcon.Error);
                TargetDevice.Log("Error", errMsg);
                this.Close();
                return;

            }

        }

        /// <summary>
        /// 計測器エージェントのステータスをチェックして応じた処理を行う
        /// </summary>
        private void CheckAgentState()
        {

            // 計測器からの応答待ち=1
            if (TargetDevice.Status == AbstractExternalDevice.WaitResponse)
            {
                // 応答待ちの場合何もしない
                return;
            }

            // 計測器にデータ送信=2
            if (TargetDevice.Status == AbstractExternalDevice.ResponceToDevice)
            {
                // エージェントで用意された電文を送信
                SendDataToSerialPort(TargetDevice.ResponceData);

                // エージェントのステータスを計測器送信待ちに変更
                TargetDevice.Status = AbstractExternalDevice.WaitResponse;
            }

            // サーバに結果送信後、処理終了=3
            if (TargetDevice.Status == AbstractExternalDevice.SendResultToServer)
            {

                // エージェントで用意された検査結果配列を送信
                foreach (Dictionary<string, string> data in TargetDevice.ResultDataSets)
                {
                    SendDataToServer(data);
                }

                // 受信検査結果をサーバに投げる

                // アプリケーション終了にステータス変更
                TargetDevice.Status = AbstractExternalDevice.ExitApplication;

            }

            // 計測器にACK送信後、サーバに結果送信、処理終了=3
            if (TargetDevice.Status == AbstractExternalDevice.AckAndSendResultToServer)
            {

                // エージェントで用意された電文を送信
                SendDataToSerialPort(TargetDevice.ResponceData);

                // エージェントで用意された検査結果配列を送信
                foreach (Dictionary<string, string> data in TargetDevice.ResultDataSets)
                {
                    SendDataToServer(data);
                }

                // アプリケーション終了にステータス変更
                TargetDevice.Status = AbstractExternalDevice.ExitApplication;

            }

            // 計測器に属性情報送信=5
            if (TargetDevice.Status == AbstractExternalDevice.SendAttributeToDevice)
            {

                string attrData = TargetDevice.GetAttributeData();

                // エージェントで用意された電文を送信
                SendDataToSerialPort(System.Text.Encoding.ASCII.GetBytes(attrData));

                // エージェントのステータスを計測器送信待ちに変更
                TargetDevice.Status = AbstractExternalDevice.WaitResponse;

            }

            // 計測器に属性情報送信後、即終了=6
            if (TargetDevice.Status == AbstractExternalDevice.SendAttributeToDeviceAndExit)
            {

                string attrData = TargetDevice.GetAttributeData();

                // エージェントで用意された電文を送信
                SendDataToSerialPort(System.Text.Encoding.ASCII.GetBytes(attrData));

                // アプリケーション終了にステータス変更
                TargetDevice.Status = AbstractExternalDevice.ExitApplication;

            }

            // サーバに結果送信後、wait=7
            if (TargetDevice.Status == AbstractExternalDevice.SendResultToServerWaitResponse)
            {

                // エージェントで用意された検査結果配列を送信
                foreach (Dictionary<string, string> data in TargetDevice.ResultDataSets)
                {
                    SendDataToServer(data);
                }

                // 計測器応答待ちにステータス変更
                TargetDevice.Status = AbstractExternalDevice.WaitResponse;

            }

            // アプリケーション終了=99
            if (TargetDevice.Status == AbstractExternalDevice.ExitApplication)
            {

                // 当アプリケーションを終了する
                Application.Exit();
                return;

            }


        }

        private void RcvDataToTextBox(string data)
        {
            //! 受信データをテキストボックスの最後に追記する.
            if (data != null)
            {
                logTextBox.AppendText(data + Environment.NewLine);
            }
        }

        /// <summary>
        /// シリアルポートに電文を送信する
        /// </summary>
        /// <param name="data">送信するデータのByte配列</param>
        private void SendDataToSerialPort(byte[] data)
        {

            // byte配列のデータを指定エンコードで文字列に変換
            string senddata = TargetDevice.Encoding.GetString(data);

            TargetDevice.DebugLog("シリアルポートに電文を送信します。data=" + senddata);

            try
            {
                // シリアルポートからデータを送信する.
                mainSerialPort.Write(senddata);

            }
            catch (Exception ex)
            {
                string errMsg = "シリアルポート送信処理に失敗しました。" + "data=" + senddata + " msg=" + ex.Message;
                MessageBox.Show(errMsg, "処理の中断", MessageBoxButtons.OK, MessageBoxIcon.Error);
                TargetDevice.Log("Error", errMsg);
                this.Close();
                return;
            }
        }

        /// <summary>
        /// POSTデータ作成
        /// </summary>
        /// <returns>POSTデータ</returns>
        private HttpContent BuildQueryParam()
        {

            var postDataBuilder = new QueryParamBuilder();

            postDataBuilder
                .Add("rsvno", RsvNo)
                .Add("transid", TransID)
                .Add("device", Device)
                .Add("results", JsonConvert.SerializeObject(TargetDevice.ResultDataSets));

            return postDataBuilder.Build();
        }


        /// <summary>
        /// 計測結果データをサーバに送信する
        /// </summary>
        private void SendDataToServer(Dictionary<string, string> data)
        {

            // 検査結果ディクショナリの内容をテキストボックス及びログに出力
            string resultjson = "Result JSON=" + JsonConvert.SerializeObject(data);
            TargetDevice.Log("Info", resultjson);

            // POSTするパラメータ設定
            HttpContent postParams = BuildQueryParam();

            try
            {

                // POSTするAPIをコールする
                var postTask = Task.Run(() => PostDataToAPI(postParams));
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

                DialogResult result = MessageBox.Show("送信に失敗したため再送します。よろしいですか。", "送信失敗", MessageBoxButtons.YesNo);
                if (result == DialogResult.Yes)
                {
                    SendDataToServer(data);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                TargetDevice.Log("Error", ex.Message);
            }
        }

        /// <summary>
        /// 計測器検査結果データAPIに値をPOSTする
        /// </summary>
        /// <returns>HTTPレスポンス</returns>
        private async Task<HttpResponseMessage> PostDataToAPI(HttpContent content)
        {
            using (var client = new HttpClient())
            {
                // URLセット
                client.BaseAddress = new Uri(this.Url);
                // トークンセット
                client.DefaultRequestHeaders.Add("Authorization", "Bearer " + Token);
                HttpResponseMessage responseMessage = null;

                try
                {
                    // POSTリクエスト発行
                    responseMessage = await client.PostAsync("/api/v1/externaldeviceresults/" + TransID, content);
                    // HttpステータスがCreatedもしくはUnauthorized以外なら想定されていないエラーとして扱う。
                    if (responseMessage.StatusCode != HttpStatusCode.Created &&
                        responseMessage.StatusCode != HttpStatusCode.Unauthorized)
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
                    TargetDevice.Log("Error", responseMessage.ReasonPhrase);
                }
                return responseMessage;
            }
        }

        /// <summary>
        /// API送信テストボタン（release時は使用しません）
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void TestSendButton_Click(object sender, EventArgs e)
        {
            var data = new Dictionary<string, string>()
            {
                { "high", "120" },
                { "low", "75" },
                { "pulse", "60" },
            };

            var postDataBuilder = new QueryParamBuilder();

            postDataBuilder
                .Add("rsvno", "1")
                .Add("transid", "120")
                .Add("device", Device)
                .Add("results", JsonConvert.SerializeObject(data));

            try
            {
                // POSTするAPIをコールする
                var postTask = Task.Run(() => PostDataToAPI(postDataBuilder.Build()));
                postTask.Wait();

                // ステータスコードが201なら終了
                if (postTask.Result.StatusCode == HttpStatusCode.Created)
                {
                    return;
                }

                if (postTask.Result.StatusCode == HttpStatusCode.Unauthorized)
                {
                    MessageBox.Show("認証に失敗しました。", "認証失敗", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }

                DialogResult result = MessageBox.Show("送信に失敗したため再送します。よろしいですか。", "送信失敗", MessageBoxButtons.YesNo);
                if (result == DialogResult.Yes)
                {
                    SendDataToServer(data);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                TargetDevice.Log("Error", ex.Message);
            }
        }
    }
}
