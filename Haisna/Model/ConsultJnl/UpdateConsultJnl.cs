using System;

namespace Hainsi.Entity.Model.ConsultJnl
{
    /// <summary>
    /// 受診歴送信ジャーナル更新モデル
    /// </summary>
    public class UpdateConsultJnl
    {
        /// <summary>
        /// 処理日時
        /// </summary>
        public DateTime TskDate { get; set; }

        /// <summary>
        /// 予約番号
        /// </summary>
        public int RsvNo { get; set; }

        /// <summary>
        /// 更新対象送信区分
        /// </summary>
        public int UpdSendDiv { get; set; }

        /// <summary>
        /// 更新後送信区分
        /// </summary>
        public int AftSendDiv { get; set; }

        /// <summary>
        /// 削除対象送信区分
        /// </summary>
        public int DelSendDiv { get; set; }
    }
}
