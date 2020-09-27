using System.Collections.Generic;
namespace Hainsi.Entity.Model.Result
{
    /// <summary>
    /// 検査結果情報モデル
    /// </summary>
    public class ResultRecAll
    {
        /// <summary>
        /// 検査項目コード
        /// </summary>
        public List<long> RsvNo { get; set; }
        /// <summary>
        /// サフィックス
        /// </summary>
        public string AllResultClear { get; set; }

        /// <summary>
        /// 検査結果値
        /// </summary>
        public List<ResultRec> ResultItems { get; set; }

 
    }
}
