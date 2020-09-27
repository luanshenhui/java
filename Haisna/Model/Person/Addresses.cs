namespace Hainsi.Entity.Model.Person
{
    /// <summary>
    /// 個人住所情報モデル
    /// </summary>
    public class Addresses
    {
        /// <summary>
        /// 住所区分
        /// </summary>
        public string AddrDiv { get; set; }

        /// <summary>
        /// 電話番号1
        /// </summary>
        public string Tel1 { get; set; }

        /// <summary>
        /// 携帯番号
        /// </summary>
        public string Phone { get; set; }

        /// <summary>
        /// 電話番号2
        /// </summary>
        public string Tel2 { get; set; }

        /// <summary>
        /// 内線
        /// </summary>
        public string Extension { get; set; }

        /// <summary>
        /// FAX
        /// </summary>
        public string Fax { get; set; }

        /// <summary>
        /// e-mail
        /// </summary>
        public string EMail { get; set; }

        /// <summary>
        /// 郵便番号
        /// </summary>
        public string ZipCd { get; set; }

        /// <summary>
        /// 都道府県コード
        /// </summary>
        public string PrefCd { get; set; }

        /// <summary>
        /// 市区町村名
        /// </summary>
        public string CityName { get; set; }

        /// <summary>
        /// 住所1
        /// </summary>
        public string Address1 { get; set; }

        /// <summary>
        /// 住所2
        /// </summary>
        public string Address2 { get; set; }
    }
}
