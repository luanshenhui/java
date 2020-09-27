using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hainsi.Entity.Model.Consultation
{
    /// <summary>
    /// お連れ様情報テーブルを更新モデル
    /// </summary>
    public class UpdateFriendsModel
    {
        /// <summary>
        /// 受診日
        /// </summary>
        public DateTime CslDate { get; set; }
        /// <summary>
        /// お連れ様SEQ
        /// </summary>
        public int Seq { get; set; }
        /// <summary>
        /// 予約番号
        /// </summary>
        public int[] RsvNo { get; set; }
        /// <summary>
        /// 面接同時受診1
        /// </summary>
        public int?[] SameGrp1 { get; set; }
        /// <summary>
        /// 面接同時受診2
        /// </summary>
        public int?[] SameGrp2 { get; set; }
        /// <summary>
        /// 面接同時受診3
        /// </summary>
        public int?[] SameGrp3 { get; set; }
        /// <summary>
        /// 個人ID
        /// </summary>
        public string[] PerId { get; set; }
        /// <summary>
        /// 同伴者個人ID
        /// </summary>
        public string[] CompPerId { get; set; }
    }
}
