using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hainsi.Entity.Model.Consultation
{
    /// <summary>
    /// 受診付属情報
    /// </summary>
    public class ConsultDetailModel
    {
        /// <summary>
        /// 予約状況
        /// </summary>
        public string RsvStatus { get; set; }

        /// <summary>
        /// 保存時印刷
        /// </summary>
        public string PrtOnSave { get; set; }

        /// <summary>
        /// 確認はがき宛先
        /// </summary>
        public string CardAddrDiv { get; set; }

        /// <summary>
        /// 確認はがき英文出力
        /// </summary>
        public string CardOutEng { get; set; }

        /// <summary>
        /// 一式書式宛先
        /// </summary>
        public string FormAddrDiv { get; set; }

        /// <summary>
        /// 一式書式英文出力
        /// </summary>
        public string FormOutEng { get; set; }

        /// <summary>
        /// 成績書宛先
        /// </summary>
        public string ReportAddrDiv { get; set; }

        /// <summary>
        /// 成績書英文出力
        /// </summary>
        public string ReportOurEng { get; set; }

        /// <summary>
        /// ボランティア
        /// </summary>
        public string Volunteer { get; set; }

        /// <summary>
        /// ボランティア名
        /// </summary>
        public string VolunteerName { get; set; }

        /// <summary>
        /// 利用券回収
        /// </summary>
        public string CollectTicket { get; set; }

        /// <summary>
        /// 診察券発行
        /// </summary>
        public string IssueCslTicket { get; set; }

        /// <summary>
        /// 請求書出力
        /// </summary>
        public string BillPrint { get; set; }

        /// <summary>
        /// 保険証記号
        /// </summary>
        public string IsrSign { get; set; }

        /// <summary>
        /// 保険証番号
        /// </summary>
        public string IsrNo { get; set; }

        /// <summary>
        /// 保険者番号
        /// </summary>
        public string IsrManNo { get; set; }

        /// <summary>
        /// 社員番号
        /// </summary>
        public string EmpNo { get; set; }

        /// <summary>
        /// 紹介者
        /// </summary>
        public string Introductor { get; set; }

        /// <summary>
        /// 予約確認メール送信先
        /// </summary>
        public string SendMailDiv { get; set; }
    }
}
