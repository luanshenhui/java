namespace Hainsi.Entity.Model.Person
{
    /// <summary>
    /// 個人情報モデル
    /// </summary>
    public class Person
    {
        /// <summary>
        /// 仮IDフラグ
        /// </summary>
        public string VidFlg { get; set; }

        /// <summary>
        /// 削除フラグ
        /// </summary>
        public string DelFlg { get; set; }

        /// <summary>
        /// 姓
        /// </summary>
        public string LastName { get; set; }

        /// <summary>
        /// 名
        /// </summary>
        public string FirstName { get; set; }

        /// <summary>
        /// カナ姓
        /// </summary>
        public string LastKName { get; set; }

        /// <summary>
        /// カナ名
        /// </summary>
        public string FirstKName { get; set; }

        /// <summary>
        /// ローマ字名
        /// </summary>
        public string RomeName { get; set; }

        /// <summary>
        /// 生年月日
        /// </summary>
        public string Birth { get; set; }

        /// <summary>
        /// 性別
        /// </summary>
        public string Gender { get; set; }

        /// <summary>
        /// 更新者
        /// </summary>
        public string UpdUser { get; set; }

        /// <summary>
        /// 1年目はがき宛先
        /// </summary>
        public string PostCardAddr { get; set; }

        /// <summary>
        /// 旧姓
        /// </summary>
        public string MaidenName { get; set; }

        /// <summary>
        /// 国籍コード
        /// </summary>
        public string NationCd { get; set; }

        /// <summary>
        /// 同伴者個人ID
        /// </summary>
        public string CompPerId { get; set; }

        /// <summary>
        /// 受診回数
        /// </summary>
        public string CslCount { get; set; }

        /// <summary>
        /// 婚姻区分
        /// </summary>
        public string Marriage { get; set; }

        /// <summary>
        /// 住民番号
        /// </summary>
        public string ResidentNo { get; set; }

        /// <summary>
        /// 組合番号
        /// </summary>
        public string UnionNo { get; set; }

        /// <summary>
        /// カルテ番号
        /// </summary>
        public string Karte { get; set; }

        /// <summary>
        /// 特記事項
        /// </summary>
        public string Notes { get; set; }

        /// <summary>
        /// 医事連携ローマ字名
        /// </summary>
        public string MedRName { get; set; }

        /// <summary>
        /// 医事連携漢字氏名
        /// </summary>
        public string MedName { get; set; }

        /// <summary>
        /// 医事連携生年月日
        /// </summary>
        public string MedBirth { get; set; }

        /// <summary>
        /// 医事連携性別
        /// </summary>
        public string MedGender { get; set; }

        /// <summary>
        /// 医事連携更新日時
        /// </summary>
        public string MedUpdDate { get; set; }

        /// <summary>
        /// 医事連携国籍区分
        /// </summary>
        public string MedNationCd { get; set; }

        /// <summary>
        /// 医事連携カナ氏名
        /// </summary>
        public string MedKName { get; set; }

        /// <summary>
        /// 予備1
        /// </summary>
        public string Spare1 { get; set; }

        /// <summary>
        /// 予備2
        /// </summary>
        public string Spare2 { get; set; }

        /// <summary>
        /// 予備3
        /// </summary>
        public string Spare3 { get; set; }

        /// <summary>
        /// 予備4
        /// </summary>
        public string Spare4 { get; set; }

        /// <summary>
        /// 予備5
        /// </summary>
        public string Spare5 { get; set; }

        /// <summary>
        /// 予備6
        /// </summary>
        public string Spare6 { get; set; }

        /// <summary>
        /// 予備7
        /// </summary>
        public string Spare7 { get; set; }

        /// <summary>
        /// 個人住所情報
        /// </summary>
        public Addresses[] Addresses { get; set; }
    }
}
