using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hainsi.Entity.Model.Contract
{
    /// <summary>
    /// オプション検査情報モデル
    /// </summary>
    public class ContractOptionModel
    {
        /// <summary>
        /// オプション名
        /// </summary>
        public string OptName { get; set; }
        /// <summary>
        /// オプション略称
        /// </summary>
        public string OptSName { get; set; }
        /// <summary>
        /// コースコード
        /// </summary>
        public string CsCd { get; set; }
        /// <summary>
        /// セット分類コード
        /// </summary>
        public string SetClassCd { get; set; }
        /// <summary>
        /// 受診区分コード
        /// </summary>
        public string CslDivCd { get; set; }
        /// <summary>
        /// 受診可能性別
        /// </summary>
        public int Gender { get; set; }
        /// <summary>
        /// 前回値参照用月数
        /// </summary>
        public int LastRefMonth { get; set; }
        /// <summary>
        /// 前回値参照用コースコード
        /// </summary>
        public string LastRefCsCd { get; set; }
        /// <summary>
        /// 限度額設定除外
        /// </summary>
        public int ExceptLimit { get; set; }
        /// <summary>
        /// 追加条件
        /// </summary>
        public int AddCondition { get; set; }
        /// <summary>
        /// 予約枠画面非表示
        /// </summary>
        public int HideRsvFra { get; set; }
        /// <summary>
        /// 予約画面非表示
        /// </summary>
        public int HideRsv { get; set; }
        /// <summary>
        /// 受付画面非表示
        /// </summary>
        public int HideRpt { get; set; }
        /// <summary>
        /// 問診画面非表示
        /// </summary>
        public int HideQuestion { get; set; }
        /// <summary>
        /// 予約枠コード
        /// </summary>
        public string RsvFraCd { get; set; }
        /// <summary>
        /// セットカラー
        /// </summary>
        public string SetColor { get; set; }
    }
}
