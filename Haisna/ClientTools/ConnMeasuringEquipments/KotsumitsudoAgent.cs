using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using System.Text;

namespace ConnMeasuringEquipments
{
    /// <summary>
    /// 骨密度エージェント
    /// </summary>
    class KotsumitsudoAgent : AbstractExternalDevice
    {

        // 受信データ長
        private readonly Int32 ReceiveDataLength;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        public KotsumitsudoAgent()
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
            ReceiveDataLength = 269;

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
            KotsumitsudoZokuseiModel[] data = { new KotsumitsudoZokuseiModel(base.paramCollection), };
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

            // 骨密度受信データは各項目がCRLFで区切られているため、分割して配列化
            string[] crlf = { "\r\n" };
            string[] receivedDataArray = txtbuffer.Split(crlf, StringSplitOptions.None);

            // 検査結果ディクショナリの配列初期化
            ResultDataSets = new Dictionary<string, string>[1];
            ResultDataSets[0] = new Dictionary<string, string>();

            // 必要な項目のみデータセットとしてセットする
            ResultDataSets[0].Add("zscore",     receivedDataArray[13].ToString());
            ResultDataSets[0].Add("tscore",     receivedDataArray[15].ToString());
            ResultDataSets[0].Add("judmsgno",   receivedDataArray[17].ToString());

            // ステータスをサーバにデータ送信に変更
            Status = SendResultToServer;
            return true;

        }
    }
}
