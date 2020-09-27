using System;

namespace Hainsi.Entity.Model.Contract
{

    /// <summary>
    /// 契約パターンオプション情報モデル
    /// </summary>
    public class ContractOption
    {
        /// <summary>
        /// オプションコード
        /// </summary>
        public string OptCd { get; set; }

        /// <summary>
        /// オプション枝番
        /// </summary>
        public string OptBranchNo { get; set; }

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
        /// セットカラー
        /// </summary>
        public string SetColor { get; set; }

        /// <summary>
        /// セット分類コード
        /// </summary>
        public string SetClassCd { get; set; }

        /// <summary>
        /// 予約枠コード
        /// </summary>
        public string RsvFraCd { get; set; }

        /// <summary>
        /// 受診区分コード
        /// </summary>
        public string CslDivCd { get; set; }

        /// <summary>
        /// 受診可能性別
        /// </summary>
        public string Gender { get; set; }

        /// <summary>
        /// 前回値参照用月数
        /// </summary>
        public string LastRefMonth { get; set; }

        /// <summary>
        /// 前回値参照用コースコード
        /// </summary>
        public string LastRefCsCd { get; set; }

        /// <summary>
        /// 限度額設定除外
        /// </summary>
        public string ExceptLimit { get; set; }

        /// <summary>
        /// オプショングループ・追加条件
        /// </summary>
        public string AddCondition { get; set; }

        /// <summary>
        /// オプショングループ・予約枠
        /// </summary>
        public string HideRsvFra { get; set; }

        /// <summary>
        /// オプショングループ・予約
        /// </summary>
        public string HideRsv { get; set; }

        /// <summary>
        /// オプショングループ・受付
        /// </summary>
        public string HideRpt { get; set; }

        /// <summary>
        /// オプショングループ・問診
        /// </summary>
        public string HideQuestion { get; set; }
    }
}
