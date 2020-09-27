using System.Collections.Generic;

namespace Hainsi.Entity.Model.PerResult
{
    /// <summary>
    /// 検査結果情報モデル
    /// </summary>
    public class PerResult
    {
        /// <summary>
        /// 個人ＩＤ
        /// </summary>
        public string PerId { get; set; }

        /// <summary>
        /// 検査結果情報
        /// </summary>
        public PerResultItem[] PerResultItem { get; set; }

    }
}
