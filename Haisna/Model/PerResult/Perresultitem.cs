using System.Collections.Generic;

namespace Hainsi.Entity.Model.PerResult
{
    /// <summary>
    /// 検査結果項目情報モデル
    /// </summary>
    public class PerResultItem
    {
        /// <summary>
        /// 検査日
        /// </summary>
        public string IspDate { get; set; }

        /// <summary>
        /// サフィックス
        /// </summary>
        public string Suffix { get; set; }

        /// <summary>
        /// 検査結果
        /// </summary>
        public string Result { get; set; }

        /// <summary>
        /// 検査項目コード
        /// </summary>
        public string ItemCd { get; set; }

        /// <summary>
        /// 更新区分
        /// </summary>
        public string UpdDiv { get; set; }

    }
}
