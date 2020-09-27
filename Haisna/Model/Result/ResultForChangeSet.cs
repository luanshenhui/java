using System.Collections.Generic;

namespace Hainsi.Entity.Model.Result
{
    /// <summary>
    /// 検査結果情報モデル
    /// </summary>
    public class ResultForChangeSet
    {
        /// <summary>
        /// 結果コメントグループコード
        /// </summary>
        public List<string> GrpCd { get; set; }

        /// <summary>
        /// 結果コメントコード
        /// </summary>
        public List<string> RslCmtCd { get; set; }
    }
}
