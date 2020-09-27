using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using System.Text;

namespace ConnMeasuringEquipments
{
    /// <summary>
    /// 身体計測計エージェント
    /// </summary>
    class ShintaiAgent : AbstractExternalDevice
    {

        // 受信データ長
        private readonly Int32 ReceiveDataLength;

        // 受信データ固定長定義List
        private readonly List<FixedLengthModel> FixedLengthDefine;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        public ShintaiAgent()
        {

            // ボーレート
            BaudRate = 4800;
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
            ReceiveDataLength = 115;

            // 受信データの固定長定義を行う（列名をレングスを順番に指定）
            FixedLengthDefine = new List<FixedLengthModel>
            {
                // 列名, データ長、サーバ送信の要不要、を定義する
                new FixedLengthModel ( "yymmdd"           , 11, false ),
                new FixedLengthModel ( "delimiter1"       ,  1, false ),
                new FixedLengthModel ( "hhmm"             ,  7, false ),
                new FixedLengthModel ( "delimiter2"       ,  1, false ),
                new FixedLengthModel ( "se_no"            , 12, false ),
                new FixedLengthModel ( "delimiter4"       ,  1, false ),
                new FixedLengthModel ( "taikei"           ,  1, false ),
                new FixedLengthModel ( "delimiter5"       ,  1, false ),
                new FixedLengthModel ( "gender"           ,  1, false ),
                new FixedLengthModel ( "delimiter6"       ,  1, false ),
                new FixedLengthModel ( "age"              ,  2, false ),
                new FixedLengthModel ( "delimiter7"       ,  1, false ),
                new FixedLengthModel ( "height"           ,  7, true ),     // 身長
                new FixedLengthModel ( "delimiter8"       ,  1, false ),
                new FixedLengthModel ( "weight"           ,  7, true ),     // 体重
                new FixedLengthModel ( "delimiter9"       ,  1, false ),
                new FixedLengthModel ( "impedance"        ,  4, false ),
                new FixedLengthModel ( "delimiter10"      ,  1, false ),
                new FixedLengthModel ( "fat_rate"         ,  4, true ),     // 体脂肪率
                new FixedLengthModel ( "delimiter11"      ,  1, false ),
                new FixedLengthModel ( "fat_weight1"      ,  7, false ),
                new FixedLengthModel ( "delimiter12"      ,  1, false ),
                new FixedLengthModel ( "fat_weight2"      ,  7, false ),
                new FixedLengthModel ( "delimiter13"      ,  1, false ),
                new FixedLengthModel ( "water_weight"     ,  7, false ),
                new FixedLengthModel ( "delimiter14"      ,  1, false ),
                new FixedLengthModel ( "bmi"              ,  4, true ),     // BMI
                new FixedLengthModel ( "delimiter15"      ,  1, false ),
                new FixedLengthModel ( "ave_weight"       ,  7, true ),     // 標準体重
                new FixedLengthModel ( "delimiter16"      ,  1, false ),
                new FixedLengthModel ( "fatness"          ,  5, true ),     // 肥満度
                new FixedLengthModel ( "delimiter17"      ,  1, false ),
                new FixedLengthModel ( "basal_metabolism" ,  4, false ),
                new FixedLengthModel ( "crlf"             ,  2, false ),

            };

        }

        /// <summary>
        /// 属性情報の取得（※身体計測機では属性情報の送信はないため、nullを返す）
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
                DebugLog("【データ待ち】今回受信サイズ=" + bufferData.Length + " 総受信サイズ=" + PooledBufferData.Length);
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
