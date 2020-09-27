using System;
using System.Collections.Specialized;

namespace ConnMeasuringEquipments
{
    /// <summary>
    /// 心電図個人属性情報固定長フォーマット
    /// </summary>
    [FixedTextFile(Encode = "Shift_JIS")]
    class ShindenzuZokuseiModel
    {

        /// <summary>
        /// STX
        /// </summary>
        [Fixed(ByteLength = 1, PadChar = '0', PadType = EPadType.After)]
        public string Stx { set; get; }

        /// <summary>
        /// val1
        /// </summary>
        [Fixed(ByteLength = 1, PadChar = '0', PadType = EPadType.After)]
        public string Val1 { set; get; }

        /// <summary>
        /// val2
        /// </summary>
        [Fixed(ByteLength = 1, PadChar = ' ', PadType = EPadType.After)]
        public string Val2 { set; get; }

        /// <summary>
        /// val3
        /// </summary>
        [Fixed(ByteLength = 1, PadChar = ' ', PadType = EPadType.After)]
        public string Val3 { set; get; }

        /// <summary>
        /// val4
        /// </summary>
        [Fixed(ByteLength = 1, PadChar = ' ', PadType = EPadType.After)]
        public string Val4 { set; get; }

        /// <summary>
        /// 患者番号1
        /// </summary>
        [Fixed(ByteLength = 12, PadChar = ' ', PadType = EPadType.After)]
        public string Perid1 { set; get; }

        /// <summary>
        /// 患者番号2
        /// </summary>
        [Fixed(ByteLength = 12, PadChar = ' ', PadType = EPadType.After)]
        public string Perid2 { set; get; }

        /// <summary>
        /// 名前
        /// </summary>
        [Fixed(ByteLength = 20, PadChar = ' ', PadType = EPadType.After)]
        public string Name { set; get; }

        /// <summary>
        /// 性別
        /// </summary>
        [Fixed(ByteLength = 1, PadChar = '　', PadType = EPadType.After)]
        public string Sex { set; get; }

        /// <summary>
        /// 生年月日
        /// </summary>
        [Fixed(ByteLength = 8, PadChar = ' ', PadType = EPadType.After)]
        public string Birthday { set; get; }

        /// <summary>
        /// 年齢
        /// </summary>
        [Fixed(ByteLength = 3, PadChar = ' ', PadType = EPadType.After)]
        public string Age { set; get; }

        /// <summary>
        /// val5
        /// </summary>
        [Fixed(ByteLength = 1, PadChar = '0', PadType = EPadType.After)]
        public string Val5 { set; get; }

        /// <summary>
        /// val6
        /// </summary>
        [Fixed(ByteLength = 1, PadChar = '0', PadType = EPadType.After)]
        public string Val6 { set; get; }

        /// <summary>
        /// 身長
        /// </summary>
        [Fixed(ByteLength = 3, PadChar = ' ', PadType = EPadType.After)]
        public string Height { set; get; }

        /// <summary>
        /// val7
        /// </summary>
        [Fixed(ByteLength = 1, PadChar = '1', PadType = EPadType.After)]
        public string Val7 { set; get; }

        /// <summary>
        /// 体重
        /// </summary>
        [Fixed(ByteLength = 3, PadChar = ' ', PadType = EPadType.After)]
        public string Weight { set; get; }

        /// <summary>
        /// val8
        /// </summary>
        [Fixed(ByteLength = 1, PadChar = '1', PadType = EPadType.After)]
        public string Val8 { set; get; }

        /// <summary>
        /// val8
        /// </summary>
        [Fixed(ByteLength = 221, PadChar = ' ', PadType = EPadType.After)]
        public string Val9 { set; get; }

        /// <summary>
        /// オーダー番号
        /// </summary>
        [Fixed(ByteLength = 20, PadChar = ' ', PadType = EPadType.After)]
        public string OrderNo { set; get; }

        /// <summary>
        /// val9
        /// </summary>
        [Fixed(ByteLength = 22, PadChar = ' ', PadType = EPadType.After)]
        public string val9 { set; get; }

        /// <summary>
        /// val10
        /// </summary>
        [Fixed(ByteLength = 1, PadChar = 'A', PadType = EPadType.After)]
        public string val10 { set; get; }

        /// <summary>
        /// val11
        /// </summary>
        [Fixed(ByteLength = 1, PadChar = 'a', PadType = EPadType.After)]
        public string val11 { set; get; }

        /// <summary>
        /// val12
        /// </summary>
        [Fixed(ByteLength = 66, PadChar = ' ', PadType = EPadType.After)]
        public string val12 { set; get; }

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="paramCollection">パラメタコレクション</param>
        public ShindenzuZokuseiModel(NameValueCollection paramCollection)
        {

            // val*系の列については、固定リテラル＋レングス埋めで問題ないためあえて値をセットしない

            Stx = ((char)2).ToString();
            //Val1 = paramCollection["Val1"];       
            //Val2 = paramCollection["Val2"];
            //Val3 = paramCollection["Val3"];
            //Val4 = paramCollection["Val4"];
            Perid1 = paramCollection["Perid"];
            Perid2 = paramCollection["Perid"];
            Name = paramCollection["Name"];
            Sex = paramCollection["Sex"];
            Birthday = paramCollection["Birthday"];
            Age = paramCollection["Age"];
            //Val5 = paramCollection["Val5"];
            //Val6 = paramCollection["Val6"];
            Height = paramCollection["Height"];
            //Val7 = paramCollection["Val7"];
            Weight = paramCollection["Weight"];
            //Val8 = paramCollection["Val8"];
            //Val9 = paramCollection["Val9"];
            OrderNo = paramCollection["OrderNo"];
            //val9 = paramCollection["val9"];
            //val10 = paramCollection["val10"];
            //val11 = paramCollection["val11"];
            //val12 = paramCollection["val12"];

        }

    }
}
