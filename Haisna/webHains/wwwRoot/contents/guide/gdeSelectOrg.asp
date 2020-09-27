<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'        団体検索ガイド(親画面への団体情報編集) (Ver0.0.1)
'        AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objOrganization    '団体情報アクセス用

'引数値
Dim strOrgCd1        '団体コード１
Dim strOrgCd2        '団体コード２
Dim lngAddrDiv       '住所区分

'団体情報
Dim strOrgName       '団体名称
Dim strOrgSName      '略称
Dim strOrgKName      '団体カナ名称
Dim strBillCslDiv    '請求書本人家族区分出力

'団体住所情報
Dim strZipCd         '郵便番号
Dim strPrefCd        '都道府県コード
Dim strCityName      '市区町村名
Dim strAddress1      '住所１
Dim strAddress2      '住所２
Dim strDirectTel     '電話番号１
Dim strTel           '電話番号２
Dim strExtension     '内線１
Dim strFax           'ＦＡＸ
Dim strEMail         'e-Mail
Dim strUrl           'URL

'## 2004.01.29 Add By T.Takagi@FSIT 項目追加
Dim strReptCslDiv    '成績書本人家族区分出力
'## 2004.01.29 Add End

'### 2016.09.19 張 送付案内コメント表示追加 STR ###
Dim strSendComment   '送付案内コメント
'### 2016.09.19 張 送付案内コメント表示追加 END ###


'## 2013.12.24 Add By 張 項目追加
Dim strBillAge    ' 団体名称ハイライト表示区分
Dim strBillSpecial  ' 団体名称ハイライト表示区分
Dim strHighLight    ' 団体名称ハイライト表示区分
'## 2013.12.24 Add End

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

'引数値の取得
strOrgCd1  = Request("orgCd1")
strOrgCd2  = Request("orgCd2")
lngAddrDiv = CLng("0" & Request("addrDiv"))

'団体情報読み込み
'## 2004.01.29 Mod By T.Takagi@FSIT 項目追加
'objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2, , strOrgKName, strOrgName, , strOrgSName, , , , , , , , , , , , , , , , , , , , , , strBillCslDiv

'## 団体名称ハイライト表示区分(highLight)追加 2013.12.24 張
'objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2, , strOrgKName, strOrgName, , strOrgSName, , , , , , , , , , , , , , , , , , , , , , strBillCslDiv, , , , , , , , , , , , , , , , , , , , , , strReptCslDiv

'### 2016.09.19 張 送付案内コメント表示追加 STR ###
'objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2, , strOrgKName, strOrgName, , strOrgSName, , , , , , , , , , , , , , , , , , , , , , strBillCslDiv, , , , , , , , , , , , , , , , , , , , , , ,strReptCslDiv,strBillSpecial,strBillAge,strHighLight
objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2, , strOrgKName, strOrgName, , strOrgSName, , , , , , , , , , , , , , , , , , , , , , strBillCslDiv, , , , , strSendComment, , , , , , , , , , , , , , , , , ,strReptCslDiv,strBillSpecial,strBillAge,strHighLight
'### 2016.09.19 張 送付案内コメント表示追加 END ###
'## 2004.01.29 Mod End

'団体住所情報読み込み
objOrganization.SelectOrgAddr strOrgCd1, strOrgCd2, lngAddrDiv, strZipCd, strPrefCd, strCityName, strAddress1, strAddress2, strDirectTel, strTel, strExtension, strFax, strEMail, strUrl

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>団体の検索</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// 団体コード・名称のセット
function selectOrg() {

    // 呼び元ウィンドウが存在する場合
    /** 取得データ確認の為              **/
    /**************************************
    alert('<%= strOrgSName %>');
    alert('<%= strReptCslDiv %>');
    alert('<%= strBillSpecial %>');
    alert('<%= strBillAge %>');
    alert('<%= strHighLight %>');
    **************************************/

    if ( opener != null ) {

        // 親画面の団体編集関数呼び出し
        if ( opener.orgGuide_setOrgInfo ) {
            opener.orgGuide_setOrgInfo(
                '<%= Replace(strOrgCd1,   "'", "\'") %>',
                '<%= Replace(strOrgCd2,   "'", "\'") %>',
                '<%= Replace(strOrgName,  "'", "\'") %>',
                '<%= Replace(strOrgSName, "'", "\'") %>',
                '<%= Replace(strOrgKName, "'", "\'") %>',
                '',
                '<%= Replace(strZipCd,      "'", "\'") %>',
                '<%= Replace(strPrefCd,     "'", "\'") %>',
                '<%= Replace(strCityName,   "'", "\'") %>',
                '<%= Replace(strAddress1,   "'", "\'") %>',
                '<%= Replace(strAddress2,   "'", "\'") %>',
                '<%= Replace(strDirectTel,  "'", "\'") %>',
                '<%= Replace(strTel,        "'", "\'") %>',
                '<%= Replace(strExtension,  "'", "\'") %>',
                '<%= Replace(strFax,        "'", "\'") %>',
                '<%= Replace(strEMail,      "'", "\'") %>',
                '<%= Replace(strUrl,        "'", "\'") %>',
                '<%= Replace(strBillCslDiv, "'", "\'") %>'
// ## 2004.01.29 Add By T.Takagi@FSIT 項目追加
                ,'<%= Replace(strReptCslDiv, "'", "\'") %>'
// ## 2004.01.29 Add End
// ## 団体名称ハイライト表示区分(highLight)追加 2013.12.24 張 Start
                ,'<%= Replace(strHighLight, "'", "\'") %>'
// ## 団体名称ハイライト表示区分(highLight)追加 2013.12.24 張 End
                ,'<%= Replace(Replace(strSendComment, vbCrLf, ""), "'", "\'") %>'

            );
        }

        // 親画面の関数呼び出し
        if ( opener.orgGuide_CalledFunction != null ) {
            opener.orgGuide_CalledFunction();
        }

        opener.winGuideOrg = null;
    }

    // 自画面を閉じる
    close();
}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
    body { margin: 10px 0 0 0; }
</style>
</HEAD>
<BODY ONLOAD="JavaScript:selectOrg()">
</BODY>
</HTML>
