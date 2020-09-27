using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using System.Text;

namespace ConnMeasuringEquipments
{
    /// <summary>
    /// 聴力計エージェント
    /// </summary>
    class ChoryokuAgent : AbstractExternalDevice
    {

        // 受信データ長（1～3部屋同時受診の可能性があるため、3種類存在）
        readonly int ReceiveDataLength = 53;

        // 聴力の部屋数
        readonly int ChoryokuRoomCount = 3;

        // 受信データ固定長定義List
        private readonly List<FixedLengthModel> FixedLengthDefine;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        public ChoryokuAgent()
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

            // 受信データの固定長定義を行う（列名をレングスを順番に指定）
            FixedLengthDefine = new List<FixedLengthModel>
            {
                // 列名, データ長、サーバ送信の要不要、を定義する
                new FixedLengthModel ( "sp",         1, false ),
                new FixedLengthModel ( "stx",        1, false ),
                new FixedLengthModel ( "machineno",  1, true ),
                new FixedLengthModel ( "kensano",    1, false ),
                new FixedLengthModel ( "slash1",     1, false ),
                new FixedLengthModel ( "sp1",        1, false ),
                new FixedLengthModel ( "sp2",        1, false ),
                new FixedLengthModel ( "id",         8, false ),
                new FixedLengthModel ( "slash2",     1, false ),
                new FixedLengthModel ( "yyyymmdd",   8, false ),
                new FixedLengthModel ( "sp3",        1, false ),
                new FixedLengthModel ( "sp4",        1, false ),
                new FixedLengthModel ( "slash3",     1, false ),
                new FixedLengthModel ( "slash4",     1, false ),
                new FixedLengthModel ( "500hz",      5, true ),
                new FixedLengthModel ( "1000hz",     5, true ),
                new FixedLengthModel ( "2000hz",     5, true ),
                new FixedLengthModel ( "4000hz",     5, true ),
                new FixedLengthModel ( "slash5",     1, false ),
                new FixedLengthModel ( "cr",         1, false ),
                new FixedLengthModel ( "lf",         1, false ),
                new FixedLengthModel ( "bcc",        1, false ),
                new FixedLengthModel ( "etx",        1, false ),

            };

        }

        /// <summary>
        /// 属性情報の取得（※張力では属性情報の送信はないため、nullを返す）
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

            //　今回受信バッファデータを、貯めていたバッファと結合する
            PooledBufferData = PooledBufferData.Concat(bufferData).ToArray();

            // 想定されるレコード長の配列作成（規定レコード数×部屋数分）
            int[] defineRecLength = new int[ChoryokuRoomCount];
            for (int　i = 0; i < ChoryokuRoomCount; i++)
            {
                defineRecLength[i] = ReceiveDataLength * (i + 1);
            }

            // 想定レコードレングスに完全合致しているものを探す
            int targetRecCount = Array.IndexOf(defineRecLength, PooledBufferData.Length);

            // プールしているバッファデータとの結合後データ長が、想定レコード長に合致していない場合、処理を抜ける
            // ※完全合致していない＝計測器からの送信途中だから
            if (targetRecCount < 0)
            {

                DebugLog("【データ待ち】今回受信サイズ=" + bufferData.Length + " 総受信サイズ=" + PooledBufferData.Length);
                // ステータスを計測機レスポンス待ちに変更
                Status = WaitResponse;
                return true;

            }

            // この処理で想定レコードレングス×部屋数になっている
            DebugLog("規定サイズ(" + PooledBufferData.Length + "byte)受信完了。" + "結果部屋数=" + (targetRecCount + 1));

            ResultDataSets = new Dictionary<string, string>[(targetRecCount + 1)];

            // 送信済み部屋数分Loopする
            for (int i = 0; i < targetRecCount + 1; i++)
            {

                // 受信データをエンコード
                string txtbuffer = this.Encoding.GetString(PooledBufferData);
                string curretRec = txtbuffer.Substring((ReceiveDataLength * i), ReceiveDataLength);
                DebugLog("部屋LoopCounter=" + (i + 1) + " 今回処理対象データ=" + curretRec);

                // 検査結果ディクショナリの配列初期化
                ResultDataSets[i] = new Dictionary<string, string>();

                int pos = 0;

                // 固定長定義で設定された通りにデータを分割する
                foreach (FixedLengthModel item in FixedLengthDefine)
                {
                    //　検査結果として設定されているもののみDictonaryに追加する
                    if (item.IsResultData)
                    {
                        ResultDataSets[i].Add(item.Name, curretRec.Substring(pos, item.Length));
                    }
                    pos += item.Length;
                }


            }

            // 結果の配列化が完了したのでバッファをクリアする。
            PooledBufferData = new byte[0];

            // ステータスをサーバにデータ送信してwaitに変更
            Status = SendResultToServerWaitResponse;
            return true;

        }
    }
}
