namespace Hainsi.Entity.Model.Follow
{
    /// <summary>
    /// 挿入用フォローアップ情報モデル
    /// </summary>
    public class UpdateFollow_Info
    {
        /// <summary>
        /// 予約番号
        /// </summary>
        public string RsvNo { get; set; }

        /// <summary>
        /// 判定分類コード
        /// </summary>
        public string JudClassCd { get; set; }

        /// <summary>
        /// 二次検査実施区分
        /// </summary>
        public string SecEquipDiv { get; set; }

        /// <summary>
        /// 更新者
        /// </summary>
        public string UpdUser { get; set; }

        /// <summary>
        /// 判定コード
        /// </summary>
        public string JudCd { get; set; }

        /// <summary>
        /// ステータス
        /// </summary>
        public string StatusCd { get; set; }

        /// <summary>
        /// 病医院名
        /// </summary>
        public string SecEquipName { get; set; }

        /// <summary>
        /// 診療科
        /// </summary>
        public string SecEquipCourse { get; set; }

        /// <summary>
        /// 担当医師
        /// </summary>
        public string SecDoctor { get; set; }

        /// <summary>
        /// 病医院住所
        /// </summary>
        public string SecEquipAddr { get; set; }

        /// <summary>
        /// 病医院電話番号
        /// </summary>
        public string SecEquipTel { get; set; }

        /// <summary>
        /// 二次検査予定日
        /// </summary>
        public string SecPlanDate { get; set; }

        /// <summary>
        /// 二次検査予約項目 US
        /// </summary>
        public string RsvTestUS { get; set; }

        /// <summary>
        /// 二次検査予約項目 CT
        /// </summary>
        public string RsvTestCT { get; set; }

        /// <summary>
        /// 二次検査予約項目 MRI
        /// </summary>
        public string RsvTestMRI { get; set; }

        /// <summary>
        /// 二次検査予約項目 BF
        /// </summary>
        public string RsvTestBF { get; set; }

        /// <summary>
        /// 二次検査予約項目 GF
        /// </summary>
        public string RsvTestGF { get; set; }

        /// <summary>
        /// 二次検査予約項目 CF
        /// </summary>
        public string RsvTestCF { get; set; }

        /// <summary>
        /// 二次検査予約項目 注腸
        /// </summary>
        public string RsvTestEM { get; set; }

        /// <summary>
        /// 二次検査予約項目 腫瘍マーカー
        /// </summary>
        public string RsvTestTM { get; set; }

        /// <summary>
        /// 二次検査予約項目 その他
        /// </summary>
        public string RsvTestEtc { get; set; }

        /// <summary>
        /// 二次検査予約項目 その他コメント
        /// </summary>
        public string RsvTestRemark { get; set; }

        /// <summary>
        /// 二次検査予約項目 リファー
        /// </summary>
        public string RsvTestRefer { get; set; }

        /// <summary>
        /// 二次検査予約項目 リファー
        /// </summary>
        public string RsvTestReferText { get; set; }

        /// <summary>
        /// 備考
        /// </summary>
        public string SecRemark { get; set; }
    }
}
