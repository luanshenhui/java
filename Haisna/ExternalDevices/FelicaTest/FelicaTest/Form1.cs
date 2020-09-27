using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using PCSC;

namespace FelicaTest
{
    public partial class Form1 : Form
    {
        private IReadOnlyCollection<byte> PcscRead { get; }
        private IReadOnlyCollection<byte> PcscWrite { get; }
        private IReadOnlyCollection<byte> SWSuccess { get; }

        private IContextFactory Factory { get; }
        private SCardMonitor Monitor { get; }

        /// <summary>
        /// コンストラクタ
        /// </summary>
        public Form1()
        {
            PcscRead = Array.AsReadOnly(new byte[] { 0xFF, 0xB0, 0x00, 0x00, 0x00 });
            PcscWrite = Array.AsReadOnly(new byte[] { 0xFF, 0xD6, 0x00, 0x00, 0x10 });
            SWSuccess = Array.AsReadOnly(new byte[] { 0x90, 0x00 });

            Factory = ContextFactory.Instance;
                        
            Monitor = new SCardMonitor(Factory, SCardScope.System);

            Monitor.Initialized += ShowCardValue;
            Monitor.CardInserted += ShowCardValue;
            
            InitializeComponent();

            ChangeButtonStatus();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            WriteValueTextBox.Mask = "0000000000000000";
            WriteValueTextBox.ValidatingType = typeof(int);
        }

        /// <summary>
        /// カードリーダーの存在確認
        /// </summary>
        /// <param name="readerNames">カードリーダーリスト</param>
        /// <returns></returns>
        private bool NoReaderFound(ICollection<string> readerNames)
        {
            return readerNames == null || readerNames.Count < 1;
        }

        /// <summary>
        /// カードリーダー名称を取得する
        /// </summary>
        /// <returns>カードリーダー名称</returns>
        private string[] GetReaderNames()
        {
            using (var context = Factory.Establish(SCardScope.System))
            {
                return GetReaderNames(context);
            }
        }

        /// <summary>
        /// カードリーダー名称を取得する
        /// </summary>
        /// <param name="context">コンテキスト</param>
        /// <returns>カードリーダー名称</returns>
        private string[] GetReaderNames(ISCardContext context)
        {
            return context.GetReaders();
        }
        
        /// <summary>
        /// カードを読み取る
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ShowCardValue(object sender, CardStatusEventArgs e)
        {
            ShowCardValue();
        }

        /// <summary>
        /// 値をテキストボックスに表示する
        /// </summary>
        private void ShowCardValue()
        {
            ShowCardValue(ReadSCard());
        }

        /// <summary>
        /// 値をテキストボックスに表示する
        /// </summary>
        /// <param name="value">表示する値</param>
        private void ShowCardValue(byte[] value)
        {
            if(InvokeRequired)
            {
                Invoke(new Action<byte[]>(ShowCardValue), new[] { value });
                return;
            }

            CardValueTextBox.Text = Encoding.UTF8.GetString(value);
            CardBytesTextBox.Text = BitConverter.ToString(value);
        }

        /// <summary>
        /// Felicaのデータを読み込む
        /// </summary>
        /// <returns>Felicaのデータ</returns>
        private byte[] ReadSCard()
        {
            byte[] receiveBuffer = new byte[0];

            if(Transmit(PcscRead.ToArray(), ref receiveBuffer) == SCardError.Success)
            {
                if(! IsSuccess(receiveBuffer))
                {
                    return new byte[0];
                }

                receiveBuffer = receiveBuffer.Take(receiveBuffer.Length - 2).ToArray();
            }
            
            return receiveBuffer;
        }

        /// <summary>
        /// カードリーダーにコマンドを送信する
        /// </summary>
        /// <param name="sendBuffer">送信コマンド</param>
        /// <param name="receiveBuffer">受信コード</param>
        /// <returns>エラーステータス</returns>
        private SCardError Transmit(byte[] sendBuffer, ref byte[] receiveBuffer)
        {
            using (var context = Factory.Establish(SCardScope.System))
            {
                string[] readerNames = GetReaderNames(context);

                var reader = new SCardReader(context);

                foreach (var readerName in readerNames)
                {
                    SCardError err = reader.Connect(readerName, SCardShareMode.Shared, SCardProtocol.Any);
                    if (err == SCardError.Success)
                    {
                        receiveBuffer = new byte[18];
                        return reader.Transmit(sendBuffer, ref receiveBuffer);
                    }
                }

                return SCardError.NotReady;
            }
        }

        /// <summary>
        /// スタートボタンクリックイベント
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void StartButton_Click(object sender, EventArgs e)
        {
            var readerNames = GetReaderNames();

            if (NoReaderFound(readerNames))
            {
                MessageBox.Show("カードリーダーを認識できませんでした", "エラー", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            // モニタリングスタート
            Monitor.Start(readerNames);

            ChangeButtonStatus();
        }

        /// <summary>
        /// 受信データのステータスワードからコマンドが成功したかどうかをチェックする
        /// </summary>
        /// <param name="receivedValue">受信データ</param>
        /// <returns></returns>
        private bool IsSuccess(ICollection<byte> receivedValue)
        {
            if(receivedValue == null || receivedValue.Count < 2)
            {
                return false;
            }
            
            // 最後の2バイトをチェック
            return receivedValue.Skip(receivedValue.Count - 2).Take(2).ToArray().SequenceEqual(SWSuccess.ToArray());
        }

        /// <summary>
        /// ストップボタンクリックイベント
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void StopButton_Click(object sender, EventArgs e)
        {
            Monitor.Cancel();
            ChangeButtonStatus();
        }

        /// <summary>
        /// 読み込みボタンクリックイベント
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ReadButton_Click(object sender, EventArgs e)
        {
            ShowCardValue();
        }

        /// <summary>
        /// モニター状態に応じてボタンの状態を変更する
        /// </summary>
        private void ChangeButtonStatus()
        {
            StartButton.Enabled = ! Monitor.Monitoring;
            StopButton.Enabled = Monitor.Monitoring;
        }

        /// <summary>
        /// カードに値を書き込む
        /// </summary>
        /// <param name="value">書き込む値</param>
        /// <returns></returns>
        private bool WriteToCard(ICollection<byte> value)
        {
            if(value == null || value.Count > 16)
            {
                return false;
            }

            // 16バイトにする
            var formedValue = new byte[16];
            value.CopyTo(formedValue, 0);

            byte[] sendBuffer = PcscWrite.ToArray().Concat(formedValue).ToArray();

            var receive = new byte[2];
            var err = Transmit(sendBuffer, ref receive);

            return (err == SCardError.Success) && (IsSuccess(receive));
        }

        /// <summary>
        /// 書き込み処理
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void WriteButton_Click(object sender, EventArgs e)
        {
            var value = Encoding.UTF8.GetBytes(WriteValueTextBox.Text);

            if (WriteToCard(value))
            {
                MessageBox.Show("値を書き込みました");
                return;
            }

            MessageBox.Show("値を書き込めませんでした");
        }
    }
}
