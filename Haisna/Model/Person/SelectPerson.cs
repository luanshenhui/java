namespace Hainsi.Entity.Model.Person
{
    /// <summary>
    /// 読み込み用個人情報モデル
    /// </summary>
    public class SelectPerson
    {
        /// <summary>
        /// 個人ID
        /// </summary>
        public string PerId { get; set; }

        /// <summary>
        /// 仮IDフラグ
        /// </summary>
        public string VidFlg { get; set; }

        /// <summary>
        /// 削除フラグ
        /// </summary>
        public string DelFlg { get; set; }

        /// <summary>
        /// 更新日時
        /// </summary>
        public string UpdDate { get; set; }

        /// <summary>
        /// 更新者
        /// </summary>
        public string UpdUser { get; set; }

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
        /// 生年月日
        /// </summary>
        public string Birth { get; set; }

        /// <summary>
        /// ローマ字名
        /// </summary>
        public string RomeName { get; set; }

        /// <summary>
        /// 性別
        /// </summary>
        public string Gender { get; set; }

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
        public string CompperId { get; set; }

        /// <summary>
        /// 受診回数
        /// </summary>
        public string CslCount { get; set; }

        /// <summary>
        /// 予備1
        /// </summary>
        public string Spare1 { get; set; }

        /// <summary>
        /// 予備2
        /// </summary>
        public string Spare2 { get; set; }

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
        /// 同伴者の姓
        /// </summary>
        public string CompLastName { get; set; }

        /// <summary>
        /// 同伴者の名
        /// </summary>
        public string CompFirstName { get; set; }

        /// <summary>
        /// 更新者名
        /// </summary>
        public string UserName { get; set; }
    }
}
