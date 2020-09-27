namespace Hainsi.Entity.Model.Follow
{
    /// <summary>
    /// 挿入用フォローアップ情報モデル
    /// </summary>
    public class UpdateFollow_Rsl
    {
        /// <summary>
        /// 二次検査年月日
        /// </summary>
        public string SecCslDate { get; set; }

        /// <summary>
        /// 更新者
        /// </summary>
        public string UpdUser { get; set; }

        /// <summary>
        /// 検査方法US
        /// </summary>
        public string TestUS { get; set; }

        /// <summary>
        /// 検査方法CT
        /// </summary>
        public string TestCT { get; set; }

        /// <summary>
        /// 検査方法MRI
        /// </summary>
        public string TestMRI { get; set; }

        /// <summary>
        /// 検査方法BF
        /// </summary>
        public string TestBF { get; set; }

        /// <summary>
        /// 検査方法GF
        /// </summary>
        public string TestGF { get; set; }

        /// <summary>
        /// 検査方法CF
        /// </summary>
        public string TestCF { get; set; }

        /// <summary>
        /// 検査方法EM
        /// </summary>
        public string TestEM { get; set; }

        /// <summary>
        /// 検査方法TM
        /// </summary>
        public string TestTM { get; set; }

        /// <summary>
        /// 検査方法その他
        /// </summary>
        public string TestEtc { get; set; }

        /// <summary>
        /// 検査方法その他コメント
        /// </summary>
        public string TestRemark { get; set; }

        /// <summary>
        /// リファー
        /// </summary>
        public string TestRefer { get; set; }

        /// <summary>
        /// リファー科
        /// </summary>
        public string TestReferText { get; set; }

        /// <summary>
        /// 二次検査結果
        /// </summary>
        public string ResultDiv { get; set; }

        /// <summary>
        /// 疾患その他コメント
        /// </summary>
        public string DisRemark { get; set; }

        /// <summary>
        /// 処置不要
        /// </summary>
        public string PolWithout { get; set; }

        /// <summary>
        /// 経過観察
        /// </summary>
        public string PolFollowup { get; set; }

        /// <summary>
        /// 経過観察期間
        /// </summary>
        public string PolMonth { get; set; }

        /// <summary>
        /// １年後健診
        /// </summary>
        public string PolReExam { get; set; }

        /// <summary>
        /// 本院紹介精査
        /// </summary>
        public string PolDiagSt { get; set; }

        /// <summary>
        /// 他院紹介精査
        /// </summary>
        public string PolDiag { get; set; }

        /// <summary>
        /// 治療なしその他
        /// </summary>
        public string PolEtc1 { get; set; }

        /// <summary>
        /// 治療なしその他コメント
        /// </summary>
        public string PolRemark1 { get; set; }

        /// <summary>
        /// 外科治療
        /// </summary>
        public string PolSugery { get; set; }

        /// <summary>
        /// 内視鏡的治療
        /// </summary>
        public string PolEndoscope { get; set; }

        /// <summary>
        /// 化学療法
        /// </summary>
        public string PolChemical { get; set; }

        /// <summary>
        /// 放射線治療
        /// </summary>
        public string PolRadiation { get; set; }

        /// <summary>
        /// 本院紹介治療
        /// </summary>
        public string PolReferSt { get; set; }

        /// <summary>
        /// 他院紹介治療
        /// </summary>
        public string PolRefer { get; set; }

        /// <summary>
        /// 治療ありその他
        /// </summary>
        public string PolEtc2 { get; set; }

        /// <summary>
        /// 治療ありその他コメント
        /// </summary>
        public string PolRemark2 { get; set; }

        /// <summary>
        /// 検査項目コード
        /// </summary>
        public string[] ItemCd { get; set; }

        /// <summary>
        /// サフィックス
        /// </summary>
        public string[] Suffix { get; set; }

        /// <summary>
        /// 結果
        /// </summary>
        public string[] Result { get; set; }
    }
}
