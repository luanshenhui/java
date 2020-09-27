using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hainsi.Entity.Model.WorkStation
{
    /// <summary>
    /// 更新用管理端末情報モデル
    /// </summary>
    public class RegisterWorkStation
    {
        /// <summary>
        /// IPアドレス
        /// </summary>
        public string IpAddress { get; set; }

        /// <summary>
        /// 端末名
        /// </summary>
        public string WkstnName { get; set; }

        /// <summary>
        /// グループコード
        /// </summary>
        public string GrpCd { get; set; }

        /// <summary>
        /// 進捗分類コード
        /// </summary>
        public string ProgressCd { get; set; }

        /// <summary>
        /// 印刷ボタン表示
        /// </summary>
        public string IsPrintButton { get; set; }
    }
}
