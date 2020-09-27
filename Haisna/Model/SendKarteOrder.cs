using System;
using System.Collections.Generic;

namespace Hainsi.Entity.Model.SendKarteOrder
{
    /// <summary>
    /// 送信オーダ情報モデル
    /// </summary>
    public class SendKarteOrder
    {
 
        /// <summary>
        /// 予約番号
        /// </summary>
        public int RsvNo { get; set; }

        /// <summary>
        /// 個人ID
        /// </summary>
        public string PerId { get; set; }

        /// <summary>
        /// 受診日
        /// </summary>
        public DateTime CslDate { get; set; }

        /// <summary>
        /// 当日ID
        /// </summary>
        public int DayID { get; set; }

        /// <summary>
        /// 氏名
        /// </summary>
        public string PerName { get; set; }

        /// <summary>
        /// 生年月日
        /// </summary>
        public DateTime Birth { get; set; }

        /// <summary>
        /// 性別
        /// </summary>
        public int Gender { get; set; }

        /// <summary>
        /// 受診時年齢
        /// </summary>
        public Single Age { get; set; }

        /// <summary>
        /// コースコード
        /// </summary>
        public string Cscd { get; set; }

        /// <summary>
        /// 文書種別
        /// </summary>
        public string DocCode { get; set; }

        /// <summary>
        /// 文書枝番
        /// </summary>
        public string DocSeq { get; set; }

        /// <summary>
        /// オーダ名称
        /// </summary>
        public string DocName { get; set; }

        /// <summary>
        /// 文書タイトル
        /// </summary>
        public string DocTitle { get; set; }

        /// <summary>
        /// ルートタグ
        /// </summary>
        public string RootTag { get; set; }

        /// <summary>
        /// 受診時間（開始）
        /// </summary>
        public string CslTime { get; set; }

        /// <summary>
        /// 予約枠数
        /// </summary>
        public string RsvCnt { get; set; }

        /// <summary>
        /// 予約グループコード
        /// </summary>
        public string RsvGrpCode { get; set; }

        /// <summary>
        /// 予約グループサフィックス
        /// </summary>
        public string RsvGrpSfx { get; set; }

        /// <summary>
        /// オーダ番号
        /// </summary>
        public int OrderNo { get; set; }

        /// <summary>
        /// 発生日時
        /// </summary>
        public DateTime CreateDate { get; set; }

        /// <summary>
        /// 版数
        /// </summary>
        public int OrderSeq { get; set; }

        /// <summary>
        /// オーダタイプ
        /// </summary>
        public int OrderType { get; set; }

        /// <summary>
        /// 送信オーダ項目情報
        /// </summary>
        public List<SendKarteOrderItem> Item { get; set; }

        /// <summary>
        /// 更新前送信済みオーダ項目情報
        /// </summary>
        public List<SendKarteOrderItem> Bef_Item { get; set; }

        /// <summary>
        /// 送信オーダ項目情報モデル
        /// </summary>
        public class SendKarteOrderItem
        {
            /// <summary>
            /// 項目コード
            /// </summary>
            public string ItemCode { get; set; }

            /// <summary>
            /// 項目属性
            /// </summary>
            public string ItemAttr { get; set; }

            /// <summary>
            /// 項目名称
            /// </summary>
            public string ItemName { get; set; }

            /// <summary>
            /// 数量
            /// </summary>
            public string Num { get; set; }

            /// <summary>
            /// 極量指示フラグ
            /// </summary>
            public string Kflg { get; set; }

            /// <summary>
            /// 選択単位フラグ
            /// </summary>
            public string UnitSelFlg { get; set; }

            /// <summary>
            /// 選択単位コード
            /// </summary>
            public string UnitCode { get; set; }

            /// <summary>
            /// 選択単位名称
            /// </summary>
            public string UnitName { get; set; }

            /// <summary>
            /// 単位換算量
            /// </summary>
            public string Conv { get; set; }

            /// <summary>
            /// タグINDEX
            /// </summary>
            public string TagIndex { get; set; }

            /// <summary>
            /// タグ名称
            /// </summary>
            public string TagName { get; set; }

            /// <summary>
            /// TOOL開放固定領域２
            /// </summary>
            public string Tool2 { get; set; }

            /// <summary>
            /// セットフラグ（True:外部項目コードが重複した場合はまとめる）
            /// </summary>
            public bool SetFlg { get; set; }

            /// <summary>
            /// セットグループコード（同一グループ毎にまとめる）
            /// </summary>
            public string SetGrpCd { get; set; }

            /// <summary>
            /// 結果編集情報　※病理への送信などに使用
            /// </summary>
            public string EditInfo { get; set; }

            /// <summary>
            /// 送信フラグ
            /// </summary>
            /// <remarks>（True:送信する）</remarks>
            public bool SendFlg { get; set; }

        }
    }

    /// <summary>
    /// 更新オーダーテーブル情報モデル
    /// </summary>
    public class UpdateOrderTbl
    {
        /// <summary>
        /// 予約番号
        /// </summary>
        public int RsvNo { get; set; }

        /// <summary>
        /// オーダ日付
        /// </summary>
        public DateTime OrderDate { get; set; }

        /// <summary>
        /// オーダ種別
        /// </summary>
        public string OrderDiv { get; set; }

    }

}
