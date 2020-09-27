using System.Collections.Generic;

namespace Hainsi.Entity.Model.Result
{
    /// <summary>
    /// 検査結果情報モデル
    /// </summary>
    public class ResultDetail
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
        /// 検査結果値
        /// </summary>
        public List<string> Result { get; set; }

        /// <summary>
        /// 結果コメントコード1
        /// </summary>
        public List<string> RslCmtCd1 { get; set; }

        /// <summary>
        /// 結果コメントコード2
        /// </summary>
        public List<string> RslCmtCd2 { get; set; }
    }
}
