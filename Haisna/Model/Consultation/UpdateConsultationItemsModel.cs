using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hainsi.Entity.Model.Consultation
{
    /// <summary>
    /// 受診時追加検査項目テーブル更新モデル
    /// </summary>
    public class UpdateConsultationItemsModel
    {
        /// <summary>
        /// 検査項目
        /// </summary>
        /// <remarks>
        /// Key:検査項目コード
        /// Value: 受診状態（1:受診 null:未受診)
        /// </remarks>
        public IDictionary<int, int?> Items { get; set; }
    }
}
