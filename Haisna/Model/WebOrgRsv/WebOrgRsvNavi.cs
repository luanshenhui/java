using System;
using System.Collections.Generic;

namespace Hainsi.Entity.Model.WebOrgRsv
{
    /// <summary>
    /// コメント情報モデル
    /// </summary>
    public class WebOrgRsvNavi
    {
        /// <summary>
        /// 受診年月日
        /// </summary>
        public DateTime CslDate { get; set; }

        /// <summary>
        /// webNo
        /// </summary>
        public int WebNo { get; set; }

        /// <summary>
        /// 更新者
        /// </summary>
        public string UpdUser { get; set; }

        /// <summary>
        /// コースコード
        /// </summary>
        public string CsCd { get; set; }

        /// <summary>
        /// 予約群コード
        /// </summary>
        public int RsvGrpCd { get; set; }

        /// <summary>
        /// 団体コード１
        /// </summary>
        public string PerId { get; set; }

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
        /// 性別
        /// </summary>
        public int Gender { get; set; }

        /// <summary>
        /// 生年月日
        /// </summary>
        public DateTime Birth { get; set; }

        /// <summary>
        /// 団体コード1
        /// </summary>
        public string OrgCd1 { get; set; }

        /// <summary>
        /// 団体コード2
        /// </summary>
        public string OrgCd2 { get; set; }

        /// <summary>
        /// 受診時年齢
        /// </summary>
        public int Age { get; set; }

        /// <summary>
        /// 受診区分コード
        /// </summary>
        public string CslDivCd { get; set; }

        /// <summary>
        /// 契約パターンコード
        /// </summary>
        public int CtrPtCd { get; set; }

        /// <summary>
        /// ローマ字名
        /// </summary>
        public string RomeName { get; set; }

        /// <summary>
        /// 国籍コード
        /// </summary>
        public string NationCd { get; set; }
        /// <summary>
        /// 住所区分
        /// </summary>
        public int[] AddrDiv { get; set; }
        /// <summary>
        /// 郵便番号
        /// </summary>
        public String[] ZipCd { get; set; }
        /// <summary>
        /// 都道府県コード
        /// </summary>
        public String[] PrefCd { get; set; }
        /// <summary>
        /// 市区町村名
        /// </summary>
        public String[] CityName { get; set; }
        /// <summary>
        /// 住所１
        /// </summary>
        public String[] Address1 { get; set; }
        /// <summary>
        /// 住所２
        /// </summary>
        public String[] Address2 { get; set; }
        /// <summary>
        /// 電話番号1
        /// </summary>
        public String[] Tel1 { get; set; }
        /// <summary>
        /// 携帯番号
        /// </summary>
        public String[] Phone { get; set; }
        /// <summary>
        /// e-Mail
        /// </summary>
        public String[] Email { get; set; }
        /// <summary>
        /// 予約状況
        /// </summary>
        public int RsvStatus { get; set; }
        /// <summary>
        /// 保存時印刷
        /// </summary>
        public int? PrtOnSave { get; set; }
        /// <summary>
        /// 確認はがき宛先
        /// </summary>
        public int? CardAddrDiv { get; set; }
        /// <summary>
        /// 確認はがき英文出力
        /// </summary>
        public int? CardOutEng { get; set; }
        /// <summary>
        /// 一式書式宛先
        /// </summary>
        public int? FormAddrDiv { get; set; }
        /// <summary>
        /// 一式書式英文出力
        /// </summary>
        public int? FormOutEng { get; set; }
        /// <summary>
        /// 成績書宛先
        /// </summary>
        public int? ReportAddrDiv { get; set; }
        /// <summary>
        /// 成績書英文出力
        /// </summary>
        public int? ReportOutEng { get; set; }
        /// <summary>
        /// ボランティア
        /// </summary>
        public int? Volunteer { get; set; }
        /// <summary>
        /// ボランティア名
        /// </summary>
        public string VolunteerName { get; set; }
        /// <summary>
        /// 利用券回収
        /// </summary>
        public int? CollectTicket { get; set; }
        /// <summary>
        /// 診察券発行
        /// </summary>
        public int? IssueCslTicket { get; set; }
        /// <summary>
        /// 請求書出力
        /// </summary>
        public int? BillPrint { get; set; }
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
        /// オプションコード
        /// </summary>
        public string OptCd { get; set; }
        /// <summary>
        /// オプション枝番
        /// </summary>
        public string OptBranchNo { get; set; }
        /// <summary>
        /// 強制登録フラグ
        /// </summary>
        public int IgnoreFlg { get; set; }

    }
}
