using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using System.Text;

namespace ConnMeasuringEquipments
{
    /// <summary>
    /// 肺機能エージェント
    /// </summary>
    class HaikinouAgent : AbstractExternalDevice
    {

        // 受信データ長
        private readonly Int32 ReceiveDataLength;

        // 受信データ固定長定義List
        private readonly List<FixedLengthModel> FixedLengthDefine;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        public HaikinouAgent()
        {

            // ボーレート
            BaudRate = 9600;
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
            ReceiveDataLength = 92;

            // 受信データの固定長定義を行う（列名をレングスを順番に指定）
            // ( 通信フォーマットはTX-Fを採用 )
            FixedLengthDefine = new List<FixedLengthModel>
            {
                // 列名, データ長、サーバ送信の要不要、を定義する
                // ★注意！:以下は現行VB6のレイアウト。仕様書とあっていない。要確認！！！
                new FixedLengthModel ( "filler1",       27, false),
                new FixedLengthModel ( "fvc",            5, true ),     // 努力性肺活量
                new FixedLengthModel ( "filler2",        5, false),
                new FixedLengthModel ( "fev1",           5, true ),     // 1秒量
                new FixedLengthModel ( "per_fev1",       6, true ),     // 1秒率
                new FixedLengthModel ( "filler3",       10, false),
                new FixedLengthModel ( "mvv",            5, true ),     // MVV
                new FixedLengthModel ( "filler4",       19, false),
                new FixedLengthModel ( "jin_per_vc",     1, true ),     // 肺活量(%予測値）
                new FixedLengthModel ( "jin_per_fev1",   1, true ),     // jin_per_fev1

                // ★注意！:以下は現行最新仕様書のレイアウト。VB6とあっていない。要確認！！！
                //new FixedLengthModel ( "filler1",       27, false),
                //new FixedLengthModel ( "fvc",            5, true ),     // 努力性肺活量
                //new FixedLengthModel ( "per_fvc",        5, false ),
                //new FixedLengthModel ( "fev1",           5, true ),     // 1秒量
                //new FixedLengthModel ( "fev1_per_g",     6, true ),     // 1秒率
                //new FixedLengthModel ( "kougaiindex",    5, false),
                //new FixedLengthModel ( "mmf",            5, false),
                //new FixedLengthModel ( "pef",            5, false),     // なぜかこれをmvvとしてとってる
                //new FixedLengthModel ( "v25",            5, false),
                //new FixedLengthModel ( "v25ht",          4, false),
                //new FixedLengthModel ( "mvv",            5, true ),     // MVV
                //new FixedLengthModel ( "kankibunrui",    1, false),
                //new FixedLengthModel ( "jin_per_vc",     1, true ),     // 肺活量(%予測値）
                //new FixedLengthModel ( "jin_fev1_per",   1, true ),     // じん肺FEV1.0%
                //new FixedLengthModel ( "jin_v25ht",      1, false),
                //new FixedLengthModel ( "per_fvc1",       5, false ),
                //new FixedLengthModel ( "pfev1_per_g",    5, false ),

            };

            // 最初のアクションはこちらから属性情報を計測器に送信する
            Status = SendAttributeToDevice;

        }

        /// <summary>
        /// 属性情報取得
        /// </summary>
        /// <returns>属性固定長レコード</returns>
        public override string GetAttributeData()
        {

            // パラメタコレクションを渡し、固定長レコード作成モデル作成
            HaikinouZokuseiModel[] data = {new HaikinouZokuseiModel(base.paramCollection),};
            // 固定長レコード作成モデルから固定長レコード作成
            return FixedTextFileAttribute.GetFixedDataRecord(data);

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

            //// 先頭バイトがACKの場合
            //if (bufferData[0] == ACK)
            //{

            //    DebugLog("ACKを受信。今回受信サイズ=" + bufferData.Length);

            //    // 受信バッファをクリアする
            //    PooledBufferData = new byte[0];

            //    // ステータスを"計測器からの応答待ち"に変更
            //    Status = WaitResponse;

            //    // 処理を抜ける
            //    return true;

            //}

            //　今回受信バッファデータを貯めていたバッファと結合する
            PooledBufferData = PooledBufferData.Concat(bufferData).ToArray();

            // プールしているバッファデータとの結合後データ長が、規定レコード長に達していない場合、処理を抜ける
            if (PooledBufferData.Length < ReceiveDataLength)
            {
                DebugLog("データ待ち... 今回受信サイズ=" + bufferData.Length + " 総受信サイズ=" + PooledBufferData.Length);
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
