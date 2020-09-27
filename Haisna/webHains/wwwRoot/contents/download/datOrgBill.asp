<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'        請求書明細抽出 (Ver0.0.1)
'        AUTHER  : S.D.JANG
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/bill_print.inc"           -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<!-- #include virtual = "/webHains/includes/editOrgGrp_PList.inc"     -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim strMode            '印刷モード
Dim vntMessage        '通知メッセージ

'-------------------------------------------------------------------------------
' 固有宣言部
'-------------------------------------------------------------------------------
'引数値
Dim lngStrCloseYear         '開始締め年
Dim lngStrCloseMonth        '開始締め月
Dim lngStrCloseDay          '開始締め日
Dim lngEndCloseYear         '終了締め年
Dim lngEndCloseMonth        '終了締め月
Dim lngEndCloseDay          '終了締め日
Dim strOrgCd1               '負担元団体コード１
Dim strOrgCd2               '負担元団体コード２
Dim strBillNo               '請求書番号

'作業用変数
Dim strOrgName              '団体名称
Dim strStrCloseDate         '開始締め年月日
Dim strEndCloseDate         '終了締め年月日

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'共通引数値の取得
strMode = Request("mode")

'帳票出力処理制御
vntMessage = PrintControl(strMode)

'-------------------------------------------------------------------------------
'
' 機能　　 : URL引数値の取得
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub GetQueryString()

    Dim objOrganization    '団体情報アクセス用

    '開始締め年月日
    lngStrCloseYear  = CLng("0" & Request("strCloseYear"))
    lngStrCloseMonth = CLng("0" & Request("strCloseMonth"))
    lngStrCloseDay   = CLng("0" & Request("strCloseDay"))
    lngStrCloseYear  = IIf(lngStrCloseYear  <> 0, lngStrCloseYear,  Year(Date))
    lngStrCloseMonth = IIf(lngStrCloseMonth <> 0, lngStrCloseMonth, Month(Date))
    lngStrCloseDay   = IIf(lngStrCloseDay   <> 0, lngStrCloseDay,   Day(Date))
    strStrCloseDate  = lngStrCloseYear & "/" & lngStrCloseMonth & "/" & lngStrCloseDay

    '終了締め年月日
    lngEndCloseYear  = CLng("0" & Request("endCloseYear"))
    lngEndCloseMonth = CLng("0" & Request("endCloseMonth"))
    lngEndCloseDay   = CLng("0" & Request("endCloseDay"))
    lngEndCloseYear  = IIf(lngEndCloseYear  <> 0, lngEndCloseYear,  Year(Date))
    lngEndCloseMonth = IIf(lngEndCloseMonth <> 0, lngEndCloseMonth, Month(Date))
    lngEndCloseDay   = IIf(lngEndCloseDay   <> 0, lngEndCloseDay,   Day(Date))
    strEndCloseDate  = lngEndCloseYear & "/" & lngEndCloseMonth & "/" & lngEndCloseDay

    '請求書番号
    strBillNo = Request("billNo")

    '団体
    strOrgCd1       = Request("orgCd1")
    strOrgCd2       = Request("orgCd2")

    If strOrgCd1 = "" Or strOrgCd2 = "" Then
        Exit Sub
    End If

    '団体名称読み込み
    Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
    objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2, , , strOrgName

End Sub
'-------------------------------------------------------------------------------
'
' 機能　　 : 引数値の妥当性チェックを行う
'
' 引数　　 :
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CheckValue()

    Dim objCommon        '共通クラス
    Dim vntArrMessage    'エラーメッセージの集合

    Set objCommon = Server.CreateObject("HainsCommon.Common")

    With objCommon

        If Not IsDate(strStrCloseDate) Then
            .AppendArray vntArrMessage, "開始締め日の入力形式が正しくありません。"
        End If

        If Not IsDate(strEndCloseDate) Then
            .AppendArray vntArrMessage, "終了締め日の入力形式が正しくありません。"
        End If

        .AppendArray vntArrMessage, .CheckNumeric("請求書番号", strBillNo, 14)

    End With

    '戻り値の編集
    If IsArray(vntArrMessage) Then
        CheckValue = vntArrMessage
    End If

End Function
'-------------------------------------------------------------------------------
'
' 機能　　 : 帳票ドキュメントファイル作成処理
'
' 引数　　 :
'
' 戻り値　 : 印刷ログ情報のシーケンス値
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function Print()

    Dim objOrgBill              '請求明細情報出力用COMコンポーネント

    Dim dtmStrCslDate           '開始締め日
    Dim dtmEndCslDate           '終了締め日
    Dim strParaOrgCd1           '団体コード１
    Dim strParaOrgCd2           '団体コード２

    Dim Ret                     '関数戻り値

    'オブジェクトのインスタンス作成
    Set objOrgBill = Server.CreateObject("HainsAbsenceOrgBill.AbsenceOrgBill")

    dtmStrCslDate = CDate(strStrCloseDate)
    dtmEndCslDate = CDate(strEndCloseDate)
    strParaOrgCd1 = strOrgCd1
    strParaOrgCd2 = strOrgCd2

    '情報漏えい対策用ログ書き出し
    Call putPrivacyInfoLog("PH106", "データ抽出 請求書明細情報抽出（三井物産フォーマット）よりファイル出力を行った")

    '請求明細情報ドキュメントファイル作成処理
    Ret = objOrgBill.PrintAbsenceOrgBill(Session("USERID"), dtmStrCslDate, dtmEndCslDate, strBillNo, strParaOrgCd1, strParaOrgCd2)

    Print = Ret

End Function

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>請求書明細抽出（三井物産健保向け）</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--

// 団体検索ガイド表示
function showGuideOrg() {

    with ( document.entryForm ) {
        orgGuide_showGuideOrg( orgCd1, orgCd2, 'orgName' );
    }

}

// 団体のクリア
function clearOrgInfo() {

    with ( document.entryForm ) {
        orgGuide_clearOrgInfo( orgCd1, orgCd2, 'orgName' );
    }

}

// submit時の処理
function submitForm() {

    document.entryForm.submit();

}

// ガイド画面を閉じる
function closeWindow() {

    calGuide_closeGuideCalendar();
    orgGuide_closeGuideOrg();

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.datatab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
    <BLOCKQUOTE>

    <INPUT TYPE="hidden" NAME="mode" VALUE="0">

    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">■</SPAN><FONT COLOR="#000000">請求書明細抽出（三井物産健保フォーマット）</FONT></B></TD>
        </TR>
    </TABLE>
<%
    'エラーメッセージ表示
    Call EditMessage(vntMessage, MESSAGETYPE_WARNING)
%>
    <BR>
    <INPUT TYPE="hidden" NAME="orgCd1"       VALUE="<%= strOrgCd1 %>">
    <INPUT TYPE="hidden" NAME="orgCd2"       VALUE="<%= strOrgCd2 %>">

    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD></TD>
            <TD>
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
                    <TR>
                        <TD><FONT COLOR="#ff0000">■</FONT></TD>
                        <TD WIDTH="90" NOWRAP>締め日</TD>
                        <TD>：</TD>
                        <TD><A HREF="javascript:calGuide_showGuideCalendar('strCloseYear', 'strCloseMonth', 'strCloseDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
                        <TD><%= EditNumberList("strCloseYear", YEARRANGE_MIN, YEARRANGE_MAX, lngStrCloseYear, False) %></TD>
                        <TD>年</TD>
                        <TD><%= EditNumberList("strCloseMonth", 1, 12, lngStrCloseMonth, False) %></TD>
                        <TD>月</TD>
                        <TD><%= EditNumberList("strCloseDay", 1, 31, lngStrCloseDay, False) %></TD>
                        <TD>日</TD>
                        <TD>～</TD>
                        <TD><A HREF="javascript:calGuide_showGuideCalendar('endCloseYear', 'endCloseMonth', 'endCloseDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
                        <TD><%= EditNumberList("endCloseYear", YEARRANGE_MIN, YEARRANGE_MAX, lngEndCloseYear, False) %></TD>
                        <TD>年</TD>
                        <TD><%= EditNumberList("endCloseMonth", 1, 12, lngEndCloseMonth, False) %></TD>
                        <TD>月</TD>
                        <TD><%= EditNumberList("endCloseDay", 1, 31, lngEndCloseDay, False) %></TD>
                        <TD>日</TD>
                    </TR>
                </TABLE>
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
                    <TR>
                        <TD>□</TD>
                        <TD WIDTH="90" NOWRAP>請求書番号</TD>
                        <TD>：</TD>
                        <TD><INPUT TYPE="text" NAME="billNo" SIZE="20" MAXLENGTH="14" VALUE="<%= strBillNo %>"></TD>
                        <TD><FONT COLOR="#999999">※請求書番号を指定した場合、締め日範囲は無視されます。</FONT></TD>
                    </TR>
                </TABLE>

                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
                    <TR>
                        <TD>□</TD>
                        <TD WIDTH="90" NOWRAP>負担元団体</TD>
                        <TD>：</TD>
                        <TD><A HREF="javascript:showGuideOrg()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
                        <TD><A HREF="javascript:clearOrgInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
                        <TD NOWRAP><SPAN ID="orgName"><% = strOrgName %></SPAN></TD>
                    </TR>
                </TABLE>

            </TD>
        </TR>
    </TABLE>

    <BR><BR>

    <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
        <A HREF="javascript:submitForm()"><IMG SRC="/webHains/images/DataSelect.gif"></A>
    <%  end if  %>

    </BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>

</BODY>
</HTML>