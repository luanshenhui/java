using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using System.Text;

namespace ConnMeasuringEquipments
{
    /// <summary>
    /// 血圧計エージェント
    /// </summary>
    class KetsuatsuAgent : AbstractExternalDevice
    {

        // 受信データ長
        private readonly Int32 ReceiveDataLength;

        // 受信データ固定長定義List
        private readonly List<FixedLengthModel> FixedLengthDefine;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        public KetsuatsuAgent()
        {

            // ボーレート
            BaudRate = 2400;
            // データビット
            DataBits = 7;
            // パリティ
            Parity = Parity.Even;
            // ストップビット
            StopBits = StopBits.One;
            // ハンドシェイク
            Handshake = Handshake.None;
            // エンコーディング
            Encoding = Encoding.ASCII;

            // 受信データ長
            ReceiveDataLength = 40;

            // 受信データの固定長定義を行う（列名をレングスを順番に指定）
            FixedLengthDefine = new List<FixedLengthModel>
            {
                // 列名, データ長、サーバ送信の要不要、を定義する
                new FixedLengthModel ( "filler1", 27, false ),
                new FixedLengthModel ( "high",     3, true  ),    // 血圧（高）
                new FixedLengthModel ( "sep1",     1, false ),
                new FixedLengthModel ( "low",      3, true  ),    // 血圧（低）
                new FixedLengthModel ( "sep2",     1, false ),
                new FixedLengthModel ( "pulse",    3, true  )     // 脈拍
            };

        }

        /// <summary>
        /// 属性情報の取得（※血圧では属性情報の送信はないため、nullを返す）
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

            //　今回受信バッファデータを貯めていたバッファと結合する
            PooledBufferData = PooledBufferData.Concat(bufferData).ToArray();

            // プールしているバッファデータとの結合後データ長が、規定レコード長に達していない場合、処理を抜ける
            if (PooledBufferData.Length < ReceiveDataLength)
            {
                DebugLog ("【データ待ち】今回受信サイズ=" + bufferData.Length + " 総受信サイズ=" + PooledBufferData.Length);
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
                    ResultDataSets[0].Add(item.Name, txtbuffer.Substring(pos, item.Length));
                }
                pos += item.Length;
            }

            // ステータスをサーバにデータ送信に変更
            Status = SendResultToServer;
            return true;

        }
    }
}
