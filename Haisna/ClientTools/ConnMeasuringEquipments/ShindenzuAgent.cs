using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using System.Text;

namespace ConnMeasuringEquipments
{
    /// <summary>
    /// 心電図エージェント
    /// </summary>
    class ShindenzuAgent : AbstractExternalDevice
    {

        /// <summary>
        /// コンストラクタ
        /// </summary>
        public ShindenzuAgent()
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

            // 属性送信完了後、即終了
            Status = SendAttributeToDeviceAndExit;

        }

        /// <summary>
        /// 属性情報取得
        /// </summary>
        /// <returns>属性固定長レコード</returns>
        public override string GetAttributeData()
        {

            // パラメタコレクションを渡し、固定長レコード作成モデル作成
            ShindenzuZokuseiModel[] data = { new ShindenzuZokuseiModel(base.paramCollection), };
            // 固定長レコード作成モデルから固定長レコード(CheckSumまで)作成
            string workData =  FixedTextFileAttribute.GetFixedDataRecord(data);
            // 作成した固定長レコードからチェックサム取得
            string checksum = GetCheckSum(workData);
            // 固定長レコード + チェックサム　+ ETXを返す
            return workData + checksum + ((char)3).ToString();

        }

        /// <summary>
        /// チェックサムの計算
        /// </summary>
        /// <param name="targetStr">計算対象の文字列</param>
        /// <returns>チェックサム値</returns>
        private string GetCheckSum(string targetStr)
        {

            // 引数をバイト配列に変換
            byte[] workByte = new byte[0];
            workByte = System.Text.Encoding.ASCII.GetBytes(targetStr);

            // 全文字数分計算
            long sum = 0;
            for (int i = 0; i < workByte.Length; i++)
            {
                sum += long.Parse(workByte[i].ToString());
            }
            return sum.ToString();
        }

        /// <summary>
        /// 受信データの編集
        /// </summary>
        /// <param name="bufferData">今回受信したシリアルポートデータ</param>
        /// <returns>true:正常終了</returns>
        public override Boolean EditRecievedData(byte[] bufferData)
        {
            // 心電図からのデータ送信はない
            return true;

        }
    }
}
