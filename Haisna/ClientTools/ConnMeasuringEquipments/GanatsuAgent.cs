using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using System.Text;

namespace ConnMeasuringEquipments
{
    /// <summary>
    /// 眼圧エージェント
    /// </summary>
    class GanatsuAgent : AbstractExternalDevice
    {

        // 受信データ長
        private readonly Int32 ReceiveDataLength;

        // 受信データ固定長定義List
        private readonly List<FixedLengthModel> FixedLengthDefine;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        public GanatsuAgent()
        {

            // ボーレート
            BaudRate = 19200;
            // データビット
            DataBits = 8;
            // パリティ
            Parity = Parity.None;
            // ストップビット
            StopBits = StopBits.One;
            // ハンドシェイク
            Handshake = Handshake.None;
            // エンコーディング
            Encoding = Encoding.ASCII;

            // 受信データ長
            ReceiveDataLength = 180;

            // 受信データの固定長定義を行う（列名をレングスを順番に指定）
            // ( 通信フォーマットはTX-Fを採用 )
            FixedLengthDefine = new List<FixedLengthModel>
            {
                // 列名, データ長、サーバ送信の要不要、を定義する
                new FixedLengthModel ( "datetime",      22, false ),
                new FixedLengthModel ( "title",         22, false ),
                new FixedLengthModel ( "kanjyaid",      22, false ),
                new FixedLengthModel ( "dataname-unit", 22, false ),
                new FixedLengthModel ( "title-rl",      22, false ),

                new FixedLengthModel ( "sx1",            1, false ),
                new FixedLengthModel ( "right-1",       10, true  ),    // 右1回目
                new FixedLengthModel ( "left-1",        10, true  ),    // 左1回目
                new FixedLengthModel ( "cr1",            1, false ),

                new FixedLengthModel ( "sx2",            1, false ),
                new FixedLengthModel ( "right-2",       10, true  ),    // 右2回目
                new FixedLengthModel ( "left-2",        10, true  ),    // 左2回目
                new FixedLengthModel ( "cr2",            1, false ),

                new FixedLengthModel ( "sx3",            1, false ),
                new FixedLengthModel ( "right-3",       10, true  ),    // 右3回目
                new FixedLengthModel ( "left-3",        10, true  ),    // 左3回目
                new FixedLengthModel ( "cr3",            1, false ),

                new FixedLengthModel ( "standard",      22, false ),
                new FixedLengthModel ( "ex",             2, false ),

            };

            // 応答電文用領域を初期化し、ACK+CRを設定
            // ※眼圧ではこれ以外に応答電文が存在しないためコンストラクタで常にセット
            ResponceData = new byte[2];
            ResponceData[0] = ACK;
            ResponceData[1] = CR;

        }

        /// <summary>
        /// 属性情報の取得（※眼圧では属性情報の送信はないため、nullを返す）
        /// </summary>
        /// <returns>null</returns>
        public override string GetAttributeData()
        {
            return null;
        }

        /// <summary>
        /// 受信データの編集
        /// </summary>
        /// <param name="bufferData">今回受信したシリアルポートデータ</param>
        /// <returns>true:正常終了</returns>
        public override Boolean EditRecievedData(byte[] bufferData)
        {

            // ステータスをErrorとして処理開始
            Status = Error;

            // 先頭バイトがENQの場合（処理開始）
            if (bufferData[0] == ENQ)
            {

                DebugLog("処理開始 ENQを受信。今回受信サイズ=" + bufferData.Length);

                // 受信バッファをクリアする
                PooledBufferData = new byte[0];

                // ステータスを"計測器への電文送信"に変更
                Status = ResponceToDevice;

                // 処理を抜ける
                return true;

            }

            // 先頭バイトがEOTの場合（処理終了）
            if (bufferData[0] == EOT)
            {
                DebugLog("処理終了 EOTを受信。今回受信サイズ=" + bufferData.Length);

                // ステータスを"計測器へACK送信後、サーバにPOSTして終了"に変更
                Status = AckAndSendResultToServer;

                // 処理を抜ける
                return true;

            }

            // 先頭バイトがENQ,EOT以外の場合は受信電文のため、後続の処理を開始する。

            //　今回受信バッファデータを貯めていたバッファと結合する
            PooledBufferData = PooledBufferData.Concat(bufferData).ToArray();

            // プールしているバッファデータとの結合後データ長が、規定レコード長に達していない場合、処理を抜ける
            if (PooledBufferData.Length < ReceiveDataLength)
            {
                DebugLog ("データ待ち... 今回受信サイズ=" + bufferData.Length + " 総受信サイズ=" + PooledBufferData.Length);
                // ステータスを計測機レスポンス待ちに変更
                Status = WaitResponse;
                return true;
            }

            // 受信データをエンコード
            string txtbuffer = this.Encoding.GetString(PooledBufferData);
            DebugLog("規定サイズ(" + PooledBufferData.Length + "byte)受信完了。エンコード後のデータ=" + txtbuffer);

            // 検査結果ディクショナリの配列初期化
            ResultDataSets = new Dictionary<string, string>[1];
            ResultDataSets[0] = new Dictionary<string, string>();

            int pos = 0;

            // 固定長定義で設定された通りにデータを分割する
            foreach (FixedLengthModel item in FixedLengthDefine)
            {
                //　検査結果として設定されているもののみDictonaryに追加する
                if (item.IsResultData)
                {
                    ResultDataSets[0].Add(item.Name, txtbuffer.Substring(pos, item.Length).Trim());
                }
                pos += item.Length;
            }

            // ステータスをサーバにデータ送信に変更
            Status = SendResultToServer;
            return true;

        }
    }
}
