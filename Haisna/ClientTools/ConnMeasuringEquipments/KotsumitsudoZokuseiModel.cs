using System;
using System.Collections.Specialized;

namespace ConnMeasuringEquipments
{
    /// <summary>
    /// 骨密度個人属性情報固定長フォーマット
    /// </summary>
    [FixedTextFile(Encode = "ASCII")]
    class KotsumitsudoZokuseiModel
    {

        /// <summary>
        /// STX
        /// </summary>
        [Fixed(ByteLength = 1, PadChar = '0', PadType = EPadType.After)]
        public string Stx { set; get; }

        /// <summary>
        /// 検査番号
        /// </summary>
        [Fixed(ByteLength = 20, PadChar = ' ', PadType = EPadType.After)]
        public string KensaNo { set; get; }

        /// <summary>
        /// CRLF
        /// </summary>
        [Fixed(ByteLength = 2, PadChar = ' ', PadType = EPadType.After)]
        public string Crlf1 { set; get; }

        /// <summary>
        /// 名前
        /// </summary>
        [Fixed(ByteLength = 20, PadChar = ' ', PadType = EPadType.After)]
        public string Name { set; get; }

        /// <summary>
        /// CRLF
        /// </summary>
        [Fixed(ByteLength = 2, PadChar = ' ', PadType = EPadType.After)]
        public string Crlf2 { set; get; }

        /// <summary>
        /// 性別
        /// </summary>
        [Fixed(ByteLength = 6, PadChar = '　', PadType = EPadType.After)]
        public string Sex { set; get; }

        /// <summary>
        /// CRLF
        /// </summary>
        [Fixed(ByteLength = 2, PadChar = ' ', PadType = EPadType.After)]
        public string Crlf3 { set; get; }

        /// <summary>
        /// 生年月日
        /// </summary>
        [Fixed(ByteLength = 10, PadChar = ' ', PadType = EPadType.After)]
        public string Birthday { set; get; }

        /// <summary>
        /// CRLF
        /// </summary>
        [Fixed(ByteLength = 2, PadChar = ' ', PadType = EPadType.After)]
        public string Crlf4 { set; get; }

        /// <summary>
        /// 身長
        /// </summary>
        [Fixed(ByteLength = 5, PadChar = '0', PadType = EPadType.Before)]
        public string Height { set; get; }

        /// <summary>
        /// CRLF
        /// </summary>
        [Fixed(ByteLength = 2, PadChar = ' ', PadType = EPadType.After)]
        public string Crlf5 { set; get; }

        /// <summary>
        /// 体重
        /// </summary>
        [Fixed(ByteLength = 5, PadChar = '0', PadType = EPadType.Before)]
        public string Weight { set; get; }

        /// <summary>
        /// CRLF
        /// </summary>
        [Fixed(ByteLength = 2, PadChar = ' ', PadType = EPadType.After)]
        public string Crlf6 { set; get; }

        /// <summary>
        /// コメント
        /// </summary>
        [Fixed(ByteLength = 40, PadChar = '　', PadType = EPadType.After)]
        public string Comment { set; get; }

        /// <summary>
        /// ETX
        /// </summary>
        [Fixed(ByteLength = 1, PadChar = ' ', PadType = EPadType.After)]
        public string Etx { set; get; }

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="paramCollection">パラメタコレクション</param>
        public KotsumitsudoZokuseiModel(NameValueCollection paramCollection)
        {

            // ※骨密度は各列毎にCRLFが存在する
            Stx = ((char)2).ToString();
            KensaNo = paramCollection["kensano"];
            Crlf1 = "\r\n";
            Name = paramCollection["name"];
            Crlf1 = "\r\n";
            Sex = paramCollection["sex"];
            Crlf1 = "\r\n";
            Birthday = paramCollection["birthday"];
            Crlf1 = "\r\n";
            Height = paramCollection["height"];
            Crlf1 = "\r\n";
            Weight = paramCollection["weight"];
            Crlf1 = "\r\n";
            Comment = paramCollection["comment"];
            Crlf1 = "\r\n";
            Etx = ((char)3).ToString();

        }

    }
}
