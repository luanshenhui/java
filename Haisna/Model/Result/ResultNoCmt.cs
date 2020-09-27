using System.Collections.Generic;

namespace Hainsi.Entity.Model.Result
{
    /// <summary>
    /// 検査結果テーブルを更新する(コメント更新なし)
    /// </summary>
    public class ResultNoCmt
    {
        /// <summary>
        /// 検査項目コード
        /// </summary>
        public List<string> ItemCd { get; set; }

        /// <summary>
        /// サフィックス
        /// </summary>
        public List<string> Suffix { get; set; }

        /// <summary>
        /// 検査結果
        /// </summary>
        public List<string> Rslvalue { get; set; }
    }
}
