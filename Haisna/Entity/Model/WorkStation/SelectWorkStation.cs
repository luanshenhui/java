using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hainsi.Entity.Model.WorkStation
{
    /// <summary>
    /// 読み込み用管理端末モデル
    /// </summary>
    public class SelectWorkStation : WorkStation
    {
        /// <summary>
        /// 進捗分類名称
        /// </summary>
        public string ProgressName { get; set; }
    }
}
