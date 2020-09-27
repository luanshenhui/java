using System.Runtime.InteropServices;
using System.ComponentModel.DataAnnotations;

namespace Fujitsu.Hainsi.WindowServices.PersonalAttributeListener
{
    [StructLayout(LayoutKind.Sequential, Pack = 1)]
    class PersonalData
    {
        /// <summary>連番</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 5)]
        private char[] seq;
        [Display(Name = "連番")]
        [RequiredChars, NumericChars]
        public char[] Seq { get { return seq; } }

        /// <summary>システムコード</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 1)]
        private char[] systemCode;
        [Display(Name = "ｼｽﾃﾑｺｰﾄﾞ")]
        [RequiredChars, ContainsChars(new[] { "H" })]
        public char[] SystemCode { get { return systemCode; } }

        /// <summary>電文種別</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 2)]
        private char[] telegramType;
        [Display(Name = "電文種別")]
        [FilledChars, ContainsChars(new[] { "KJ", "KI", "KK", "K3", "" })]
        public char[] TelegramType { get { return telegramType; } }

        /// <summary>継続フラグ</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 1)]
        private char[] continueFlag;
        [Display(Name = "継続フラグ")]
        [FilledChars, ContainsChars(new[] { "C", "E", "" })]
        public char[] ContinueFlag { get { return continueFlag; } }

        /// <summary>宛先コード</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 1)]
        private char[] distCode;
        [Display(Name = "宛先コード")]
        [FilledChars, ContainsChars(new[] { "H", "E", "L", "C", "T", "" })]
        public char[] DistCode { get { return distCode; } }

        /// <summary>発信元コード</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 1)]
        private char[] sourceCode;
        [Display(Name = "発信元コード")]
        [FilledChars, ContainsChars(new[] { "H", "F", "T", "" })]
        public char[] SourceCode { get { return sourceCode; } }

        /// <summary>処理日</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
        private char[] processingDate;
        [Display(Name = "処理日")]
        [FilledChars, NumericChars]
        public char[] ProcessingDate { get { return processingDate; } }

        /// <summary>処理時間</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 6)]
        private char[] processingTime;
        [Display(Name = "処理時間")]
        [FilledChars, NumericChars]
        public char[] ProcessingTime { get { return processingTime; } }

        /// <summary>端末名</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
        private char[] terminalName;
        [Display(Name = "端末名")]
        [FilledChars]
        public char[] TerminalName { get { return terminalName; } }

        /// <summary>利用者番号</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
        private char[] userId;
        [Display(Name = "利用者番号")]
        [FilledChars]
        public char[] UserId { get { return userId; } }

        /// <summary>処理区分</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 2)]
        private char[] processingCateTag;
        [Display(Name = "処理区分")]
        [RequiredChars, ContainsChars(new[] { "01", "02", "03", "" })]
        public char[] ProcessingCateTag { get { return processingCateTag; } }

        /// <summary>応答種別</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 2)]
        private char[] responseCate;
        [Display(Name = "応答種別")]
        [FilledChars, ContainsChars(new[] { "OK", "N1", "N2", "N3", "" })]
        public char[] ResponseCate { get { return responseCate; } }

        /// <summary>電文長</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 5)]
        private char[] telegramLength;
        [Display(Name = "電文長")]
        [RequiredChars, NumericChars]
        public char[] TelegramLength { get { return telegramLength; } }

        /// <summary>改行コード</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 1)]
        private char[] linefeedCode;
        [Display(Name = "改行コード")]
        [FilledChars, ContainsChars(new[] { "" })]
        public char[] LinefeedCode { get { return linefeedCode; } }

        /// <summary>空白</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 13)]
        private char[] filler;
        [Display(Name = "空白")]
        [FilledChars, ContainsChars(new[] { "" })]
        public char[] Filler { get { return filler; } }

        /// <summary>患者番号</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 10)]
        private char[] patientId;
        [Display(Name = "患者番号")]
        [RequiredChars, NumericChars]
        public char[] PatientId { get { return patientId; } }

        /// <summary>カナ全角氏名</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 80)]
        private char[] kanaName;
        [Display(Name = "カナ全角氏名")]
        [RequiredChars]
        public char[] KanaName { get { return kanaName; } }

        /// <summary>日本語氏名</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 40)]
        private char[] name;
        [Display(Name = "日本語氏名")]
        [FilledChars]
        public char[] Name { get { return name; } }

        /// <summary>性別</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 1)]
        private char[] sex;
        [Display(Name = "性別")]
        [RequiredChars, NumericChars, ContainsChars(new[] { "1", "2" })]
        public char[] Sex { get { return sex; } }

        /// <summary>生年月日</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
        private char[] birth;
        [Display(Name = "生年月日")]
        [RequiredChars, NumericChars]
        public char[] Birth { get { return birth; } }

        /// <summary>優待区分</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 2)]
        private char[] yutai;
        [Display(Name = "優待区分")]
        [FilledChars]
        public char[] Yutai { get { return yutai; } }

        /// <summary>ビタミン算定区分</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 1)]
        private char[] vitamin;
        [Display(Name = "ビタミン算定区分")]
        [FilledChars, NumericChars, ContainsChars(new[] { "0", "1" })]
        public char[] Vitamin { get { return vitamin; } }

        /// <summary>都道府県コード</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 2)]
        private char[] prefecturesCode;
        [Display(Name = "都道府県コード")]
        [FilledChars]
        public char[] PrefecturesCode { get { return prefecturesCode; } }

        /// <summary>市コード</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 3)]
        private char[] cityCode;
        [Display(Name = "市コード")]
        [FilledChars]
        public char[] CityCode { get { return cityCode; } }

        /// <summary>町コード</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 3)]
        private char[] townCode;
        [Display(Name = "町コード")]
        [FilledChars]
        public char[] TownCode { get { return townCode; } }

        /// <summary>字コード</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 2)]
        private char[] azaCode;
        [Display(Name = "字コード")]
        [FilledChars]
        public char[] AzaCode { get { return azaCode; } }

        /// <summary>小字コード</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 3)]
        private char[] koazaCode;
        [Display(Name = "小字コード")]
        [FilledChars, ContainsChars(new[] { "" })]
        public char[] KoazaCode { get { return koazaCode; } }

        /// <summary>チェックコード</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 1)]
        private char[] checkCode;
        [Display(Name = "チェックコード")]
        [FilledChars]
        public char[] CheckCode { get { return checkCode; } }

        /// <summary>住所コード部分の日本語名称</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 40)]
        private char[] jAddressCode;
        [Display(Name = "住所コード部分の日本語名称")]
        [FilledChars]
        public char[] JAddressCode { get { return jAddressCode; } }

        /// <summary>詳細住所１</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 60)]
        private char[] addressDetail1;
        [Display(Name = "詳細住所１")]
        [FilledChars]
        public char[] AddressDetail1 { get { return addressDetail1; } }

        /// <summary>詳細住所２</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 60)]
        private char[] addressDetail2;
        [Display(Name = "詳細住所２")]
        [FilledChars]
        public char[] AddressDetail2 { get { return addressDetail2; } }

        /// <summary>郵便番号</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 3)]
        private char[] zipCode1;
        [Display(Name = "郵便番号")]
        [FilledChars]
        public char[] ZipCode1 { get { return zipCode1; } }

        /// <summary>郵便番号</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 4)]
        private char[] zipCode2;
        [Display(Name = "郵便番号")]
        [FilledChars]
        public char[] ZipCode2 { get { return zipCode2; } }

        /// <summary>電話番号</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 15)]
        private char[] tel;
        [Display(Name = "電話番号")]
        [FilledChars]
        public char[] Tel { get { return tel; } }

        /// <summary>連絡先電話番号</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 15)]
        private char[] contactTel;
        [Display(Name = "連絡先電話番号")]
        [FilledChars]
        public char[] ContactTel { get { return contactTel; } }

        /// <summary>勤務先電話番号</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 15)]
        private char[] corporateTel;
        [Display(Name = "勤務先電話番号")]
        [FilledChars]
        public char[] CorporateTel { get { return corporateTel; } }

        /// <summary>勤務先内線電話番号</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 6)]
        private char[] corporateTelExtension;
        [Display(Name = "勤務先内線電話番号")]
        [FilledChars]
        public char[] CorporateTelExtension { get { return corporateTelExtension; } }

        /// <summary>勤務先日本語名称</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 30)]
        private char[] corporateJName;
        [Display(Name = "勤務先日本語名称")]
        [FilledChars]
        public char[] CorporateJName { get { return corporateJName; } }

        /// <summary>保険確認日</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
        private char[] insuranceCheckDate;
        [Display(Name = "保険確認日")]
        [FilledChars]
        public char[] InsuranceCheckDate { get { return insuranceCheckDate; } }

        /// <summary>予備</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 47)]
        private char[] kjFiller;
        [Display(Name = "予備")]
        [FilledChars, ContainsChars(new[] { "" })]
        public char[] KjFiller { get { return kjFiller; } }

        /// <summary>国籍区分</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 3)]
        private char[] nationality;
        [Display(Name = "国籍区分")]
        [FilledChars, NumericChars]
        public char[] Nationality { get { return nationality; } }

        /// <summary>保険パターン個数</summary>
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 2)]
        public char[] numberOfInsurance;
        [Display(Name = "保険パターン個数")]
        [FilledChars, NumericChars]
        public char[] NumberOfInsurance { get { return numberOfInsurance; } }
    }
}
