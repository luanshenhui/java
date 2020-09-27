using System;
using System.Collections.Specialized;

namespace ConnMeasuringEquipments
{
    /// <summary>
    /// 肺機能個人属性情報固定長フォーマット
    /// </summary>
    [FixedTextFile(Encode = "Shift_JIS")]
    public class HaikinouZokuseiModel
    {

        /// <summary>
        /// STX
        /// </summary>
        [Fixed(ByteLength = 1, PadChar = ' ', PadType = EPadType.After)]
        public string Stx { set; get; }

        /// <summary>
        /// 日付
        /// </summary>
        [Fixed(ByteLength = 6, PadChar = ' ', PadType = EPadType.After)]
        public string Yymmdd { set; get; }

        /// <summary>
        /// 患者番号
        /// </summary>
        [Fixed(ByteLength = 4, PadChar = '0', PadType = EPadType.Before)]
        public string KanjyaNo { set; get; }

        /// <summary>
        /// 性別
        /// </summary>
        [Fixed(ByteLength = 1, PadChar = ' ', PadType = EPadType.After)]
        public string Sex { set; get; }

        /// <summary>
        /// 年齢
        /// </summary>
        [Fixed(ByteLength = 3, PadChar = '0', PadType = EPadType.Before)]
        public string Age { set; get; }

        /// <summary>
        /// 身長
        /// </summary>
        [Fixed(ByteLength = 5, PadChar = '0', PadType = EPadType.Before)]
        public string Height { set; get; }

        /// <summary>
        /// 体重
        /// </summary>
        [Fixed(ByteLength = 5, PadChar = '0', PadType = EPadType.Before)]
        public string Weight { set; get; }

        /// <summary>
        /// 氏名
        /// </summary>
        [Fixed(ByteLength = 28, PadChar = ' ', PadType = EPadType.After)]
        public string Name { set; get; }

        /// <summary>
        /// Etx
        /// </summary>
        [Fixed(ByteLength = 1, PadChar = '　', PadType = EPadType.Before)]
        public string Etx { set; get; }

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="paramCollection">パラメタコレクション</param>
        public HaikinouZokuseiModel(NameValueCollection paramCollection)
        {

            // 受信したパラメタコレクションから属性電文用データをセットする

            this.Stx = ((char)2).ToString();
            // 2018年マイグレーション時要望で日付はシステム日付をセットになった
            this.Yymmdd = DateTime.Now.ToString("yyMMdd");
            this.KanjyaNo = paramCollection["kanjyaNo"];
            this.Sex = paramCollection["sex"];
            this.Age = paramCollection["age"];
            this.Height = paramCollection["height"];
            this.Weight = paramCollection["weight"];
            this.Name = paramCollection["name"];
            this.Etx = ((char)3).ToString();
        }

    }
}
