using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hainsi.Common.Table
{
	public static class Grp_p
	{
		public static ColumnDefinition Grpcd { get; } = new ColumnDefinition(column: "GRP_P.GRPCD", figure1: 5, figure2: 1, type: "VARCHAR2", name: "グループコード");
		public static ColumnDefinition Grpname { get; } = new ColumnDefinition(column: "GRP_P.GRPNAME", figure1: 20, type: "VARCHAR2", name: "グループ名");
	}

    public static class Org
    {
        public static ColumnDefinition Orgcd1 { get; } = new ColumnDefinition(column: "ORG.ORGCD1", figure1: 5, type: "VARCHAR2", name: "団体コード１", isRequired: true);
        public static ColumnDefinition Orgcd2 { get; } = new ColumnDefinition(column: "ORG.ORGCD2", figure1: 5, type: "VARCHAR2", name: "団体コード２", isRequired: true);
        public static ColumnDefinition Delflg { get; } = new ColumnDefinition(column: "ORG.DELFLG", figure1: 1, type: "NUMBER", name: "削除フラグ", isRequired: true);
        public static ColumnDefinition Orgkname { get; } = new ColumnDefinition(column: "ORG.ORGKNAME", figure1: 80, type: "VARCHAR2", name: "団体カナ名称", isRequired: true);
        public static ColumnDefinition Orgname { get; } = new ColumnDefinition(column: "ORG.ORGNAME", figure1: 50, type: "VARCHAR2", name: "団体名称", isRequired: true);
        public static ColumnDefinition Orgsname { get; } = new ColumnDefinition(column: "ORG.ORGSNAME", figure1: 20, type: "VARCHAR2", name: "団体略称", isRequired: true);
        public static ColumnDefinition Orgename { get; } = new ColumnDefinition(column: "ORG.ORGENAME", figure1: 50, type: "VARCHAR2", name: "英語名称");
        public static ColumnDefinition Orgbillname { get; } = new ColumnDefinition(column: "ORG.ORGBILLNAME", figure1: 60, type: "VARCHAR2", name: "請求書用名称");
        public static ColumnDefinition Orgdivcd { get; } = new ColumnDefinition(column: "ORG.ORGDIVCD", figure1: 12, type: "VARCHAR2", name: "団体種別コード");
        public static ColumnDefinition Bank { get; } = new ColumnDefinition(column: "ORG.BANK", figure1: 20, type: "VARCHAR2", name: "銀行名");
        public static ColumnDefinition Branch { get; } = new ColumnDefinition(column: "ORG.BRANCH", figure1: 20, type: "VARCHAR2", name: "支店名");
        public static ColumnDefinition Accountkind { get; } = new ColumnDefinition(column: "ORG.ACCOUNTKIND", figure1: 1, type: "NUMBER", name: "口座種別");
        public static ColumnDefinition Accountno { get; } = new ColumnDefinition(column: "ORG.ACCOUNTNO", figure1: 10, type: "NUMBER", name: "口座番号");
        public static ColumnDefinition Numemp { get; } = new ColumnDefinition(column: "ORG.NUMEMP", figure1: 6, type: "NUMBER", name: "社員数");
        public static ColumnDefinition Avgage { get; } = new ColumnDefinition(column: "ORG.AVGAGE", figure1: 3, type: "NUMBER", name: "平均年齢");
        public static ColumnDefinition Visitdate { get; } = new ColumnDefinition(column: "ORG.VISITDATE", figure1: 2, type: "NUMBER", name: "定期訪問予定日");
        public static ColumnDefinition Presents { get; } = new ColumnDefinition(column: "ORG.PRESENTS", figure1: 1, type: "NUMBER", name: "年始・中元・歳暮");
        public static ColumnDefinition Directmail { get; } = new ColumnDefinition(column: "ORG.DIRECTMAIL", figure1: 1, type: "NUMBER", name: "ＤＭ");
        public static ColumnDefinition Sendmethod { get; } = new ColumnDefinition(column: "ORG.SENDMETHOD", figure1: 1, type: "NUMBER", name: "送付方法");
        public static ColumnDefinition Postcard { get; } = new ColumnDefinition(column: "ORG.POSTCARD", figure1: 1, type: "NUMBER", name: "確認はがき");
        public static ColumnDefinition Packagesend { get; } = new ColumnDefinition(column: "ORG.PACKAGESEND", figure1: 1, type: "NUMBER", name: "一括送付案内");
        public static ColumnDefinition Ticket { get; } = new ColumnDefinition(column: "ORG.TICKET", figure1: 1, type: "NUMBER", name: "利用券");
        public static ColumnDefinition Ticketdiv { get; } = new ColumnDefinition(column: "ORG.TICKETDIV", figure1: 1, type: "NUMBER", name: "利用券区分");
        public static ColumnDefinition Ticketaddbill { get; } = new ColumnDefinition(column: "ORG.TICKETADDBILL", figure1: 1, type: "NUMBER", name: "利用券請求書添付");
        public static ColumnDefinition Ticketcentercall { get; } = new ColumnDefinition(column: "ORG.TICKETCENTERCALL", figure1: 1, type: "NUMBER", name: "利用券センターより連絡");
        public static ColumnDefinition Ticketpercall { get; } = new ColumnDefinition(column: "ORG.TICKETPERCALL", figure1: 1, type: "NUMBER", name: "利用券本人より連絡");
        public static ColumnDefinition Ctrptdate { get; } = new ColumnDefinition(column: "ORG.CTRPTDATE", figure1: 10, type: "DATE", name: "契約日付");
        public static ColumnDefinition Noprintletter { get; } = new ColumnDefinition(column: "ORG.NOPRINTLETTER", figure1: 1, type: "NUMBER", name: "一年目はがき非出力フラグ");
        public static ColumnDefinition Inscheck { get; } = new ColumnDefinition(column: "ORG.INSCHECK", figure1: 1, type: "NUMBER", name: "保険証予約時確認");
        public static ColumnDefinition Insbring { get; } = new ColumnDefinition(column: "ORG.INSBRING", figure1: 1, type: "NUMBER", name: "保険証当日持参");
        public static ColumnDefinition Insreport { get; } = new ColumnDefinition(column: "ORG.INSREPORT", figure1: 1, type: "NUMBER", name: "保険証成績書出力");
        public static ColumnDefinition Billaddress { get; } = new ColumnDefinition(column: "ORG.BILLADDRESS", figure1: 1, type: "NUMBER", name: "請求書適用住所");
        public static ColumnDefinition Billcsldiv { get; } = new ColumnDefinition(column: "ORG.BILLCSLDIV", figure1: 1, type: "NUMBER", name: "請求書本人家族区分出力");
        public static ColumnDefinition Billins { get; } = new ColumnDefinition(column: "ORG.BILLINS", figure1: 1, type: "NUMBER", name: "請求書保険証情報出力");
        public static ColumnDefinition Billempno { get; } = new ColumnDefinition(column: "ORG.BILLEMPNO", figure1: 1, type: "NUMBER", name: "請求書社員番号出力");
        public static ColumnDefinition Billage { get; } = new ColumnDefinition(column: "ORG.BILLAGE", figure1: 1, type: "NUMBER", name: "請求書年齢出力");
        public static ColumnDefinition Billreport { get; } = new ColumnDefinition(column: "ORG.BILLREPORT", figure1: 1, type: "NUMBER", name: "請求書成績書添付");
        public static ColumnDefinition Billspecial { get; } = new ColumnDefinition(column: "ORG.BILLSPECIAL", figure1: 1, type: "NUMBER", name: "特定健診レポート");
        public static ColumnDefinition Billfd { get; } = new ColumnDefinition(column: "ORG.BILLFD", figure1: 1, type: "NUMBER", name: "FD添付");
        public static ColumnDefinition Reptcsldiv { get; } = new ColumnDefinition(column: "ORG.REPTCSLDIV", figure1: 1, type: "NUMBER", name: "成績書本人家族区分出力");
        public static ColumnDefinition Sendcomment { get; } = new ColumnDefinition(column: "ORG.SENDCOMMENT", figure1: 200, type: "VARCHAR2", name: "送付案内コメント");
        public static ColumnDefinition Sendecomment { get; } = new ColumnDefinition(column: "ORG.SENDECOMMENT", figure1: 400, type: "VARCHAR2", name: "英語送付案内コメント");
        public static ColumnDefinition Spare1 { get; } = new ColumnDefinition(column: "ORG.SPARE1", figure1: 12, type: "VARCHAR2", name: "予備１");
        public static ColumnDefinition Spare2 { get; } = new ColumnDefinition(column: "ORG.SPARE2", figure1: 12, type: "VARCHAR2", name: "予備２");
        public static ColumnDefinition Spare3 { get; } = new ColumnDefinition(column: "ORG.SPARE3", figure1: 12, type: "VARCHAR2", name: "予備３");
        public static ColumnDefinition Dmdcomment { get; } = new ColumnDefinition(column: "ORG.DMDCOMMENT", figure1: 200, type: "VARCHAR2", name: "請求関連コメント");
    }

    public static class Orgaddr
    {
        public static ColumnDefinition Addrdiv { get; } = new ColumnDefinition(column: "ORGADDR.ADDRDIV", figure1: 1, type: "NUMBER", name: "住所区分", isRequired: true);
        public static ColumnDefinition Orgname { get; } = new ColumnDefinition(column: "ORGADDR.ORGNAME", figure1: 50, type: "VARCHAR2", name: "漢字名称");
        public static ColumnDefinition Zipcd { get; } = new ColumnDefinition(column: "ORGADDR.ZIPCD", figure1: 7, type: "VARCHAR2", name: "郵便番号");
        public static ColumnDefinition Prefcd { get; } = new ColumnDefinition(column: "ORGADDR.PREFCD", figure1: 2, type: "VARCHAR2", name: "都道府県コード");
        public static ColumnDefinition Cityname { get; } = new ColumnDefinition(column: "ORGADDR.CITYNAME", figure1: 50, type: "VARCHAR2", name: "市区町村名");
        public static ColumnDefinition Address1 { get; } = new ColumnDefinition(column: "ORGADDR.ADDRESS1", figure1: 60, type: "VARCHAR2", name: "住所１");
        public static ColumnDefinition Address2 { get; } = new ColumnDefinition(column: "ORGADDR.ADDRESS2", figure1: 60, type: "VARCHAR2", name: "住所２");
        public static ColumnDefinition Directtel { get; } = new ColumnDefinition(column: "ORGADDR.DIRECTTEL", figure1: 15, type: "VARCHAR2", name: "電話番号直通");
        public static ColumnDefinition Tel { get; } = new ColumnDefinition(column: "ORGADDR.TEL", figure1: 15, type: "VARCHAR2", name: "電話番号代表");
        public static ColumnDefinition Extension { get; } = new ColumnDefinition(column: "ORGADDR.EXTENSION", figure1: 10, type: "VARCHAR2", name: "内線");
        public static ColumnDefinition Fax { get; } = new ColumnDefinition(column: "ORGADDR.FAX", figure1: 15, type: "VARCHAR2", name: "ＦＡＸ");
        public static ColumnDefinition Email { get; } = new ColumnDefinition(column: "ORGADDR.EMAIL", figure1: 40, type: "VARCHAR2", name: "e-Mail");
        public static ColumnDefinition Url { get; } = new ColumnDefinition(column: "ORGADDR.URL", figure1: 50, type: "VARCHAR2", name: "URL");
        public static ColumnDefinition Chargepost { get; } = new ColumnDefinition(column: "ORGADDR.CHARGEPOST", figure1: 50, type: "VARCHAR2", name: "担当部署");
        public static ColumnDefinition Chargename { get; } = new ColumnDefinition(column: "ORGADDR.CHARGENAME", figure1: 20, type: "VARCHAR2", name: "担当者名");
        public static ColumnDefinition Chargekname { get; } = new ColumnDefinition(column: "ORGADDR.CHARGEKNAME", figure1: 30, type: "VARCHAR2", name: "担当者カナ名");
        public static ColumnDefinition Chargeemail { get; } = new ColumnDefinition(column: "ORGADDR.CHARGEEMAIL", figure1: 40, type: "VARCHAR2", name: "担当者e-Mail");
    }

    public static class Workstation
    {
        public static ColumnDefinition Ipaddress { get; } = new ColumnDefinition(column: "WORKSTATION.IPADDRESS", figure1: 15, type: "VARCHAR2", name: "ＩＰアドレス", isRequired: true);
        public static ColumnDefinition Wkstnname { get; } = new ColumnDefinition(column: "WORKSTATION.WKSTNNAME", figure1: 30, type: "VARCHAR2", name: "端末名", isRequired: true);
        public static ColumnDefinition Grpcd { get; } = new ColumnDefinition(column: "WORKSTATION.GRPCD", figure1: 5, type: "VARCHAR2", name: "グループコード");
        public static ColumnDefinition Progresscd { get; } = new ColumnDefinition(column: "WORKSTATION.PROGRESSCD", figure1: 3, type: "VARCHAR2", name: "進捗分類コード");
        public static ColumnDefinition Isprintbutton { get; } = new ColumnDefinition(column: "WORKSTATION.ISPRINTBUTTON", figure1: 1, figure2: 0, type: "NUMBER", name: "印刷ボタン表示");
    }
}
