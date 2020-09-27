using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hainsi.Entity.Model.Contract
{
    /// <summary>
    /// 検査セットの検査項目モデル
    /// </summary>
    public class ContractOptionItemModel
    {
        /// <summary>
        /// 受診状態
        /// 1:受診 0:未受診
        /// </summary>
        public int Consults { get; set; }
        /// <summary>
        /// 検査項目コード
        /// </summary>
        public int ItemCd { get; set; }
        /// <summary>
        /// 検査項目名
        /// </summary>
        public string RequestName { get; set; }
    }
}
