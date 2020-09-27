<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'       労働基準監督署統計 (Ver0.0.1)
'       AUTHER  : (NSC)birukawa
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/print.inc"                -->
<!-- #include virtual = "/webHains/includes/editOrgGrp_PList.inc"     -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim strMode             '印刷モード
Dim vntMessage          '通知メッセージ

'-------------------------------------------------------------------------------
' 固有宣言部（各帳票に応じてこのセクションに変数を定義して下さい）
'-------------------------------------------------------------------------------
'COMオブジェクト
Dim objCommon                               '共通クラス
Dim objOrganization                         '団体情報アクセス用
Dim objOrgBsd                               '事業部情報アクセス用
Dim objOrgRoom                              '室部情報アクセス用
Dim objOrgPost                              '所属情報アクセス用
Dim objPerson                               '個人情報アクセス用
Dim objReport                               '帳票情報アクセス用

Dim strCsCd                                 'コースコード
Dim strCsCd1                                'コースコード
Dim strCsCd2                                'コースコード
Dim strCsCd3                                'コースコード
Dim strCsCd4                                'コースコード
Dim strCsCd5                                'コースコード
Dim strCsCd6                                'コースコード
Dim strCsCd7                                'コースコード
Dim strCsCd8                                'コースコード
Dim strCsCd9                                'コースコード
Dim strOutPutCls                            '出力対象
'パラメータ値
Dim strSCslYear, strSCslMonth, strSCslDay   '開始年月日
Dim strECslYear, strECslMonth, strECslDay   '終了年月日
Dim strDayId                                '当日ID
Dim strOrgGrpCd                             '団体グループコード
Dim strOrgCd11                              '団体コード１１
Dim strOrgCd12                              '団体コード１２
Dim strOrgCd21                              '団体コード２１
Dim strOrgCd22                              '団体コード２２
Dim strOrgCd31                              '団体コード３１
Dim strOrgCd32                              '団体コード３２
Dim strOrgCd41                              '団体コード４１
Dim strOrgCd42                              '団体コード４２
Dim strOrgCd51                              '団体コード５１
Dim strOrgCd52                              '団体コード５２
Dim strOrgCd61                              '団体コード６１
Dim strOrgCd62                              '団体コード６２
Dim strOrgCd71                              '団体コード７１
Dim strOrgCd72                              '団体コード７２
Dim strOrgCd81                              '団体コード７１
Dim strOrgCd82                              '団体コード７２
Dim strOrgCd91                              '団体コード７１
Dim strOrgCd92                              '団体コード７２
Dim strOrgCd101                             '団体コード７１
Dim strOrgCd102                             '団体コード７２
Dim strReportOutDate                        '出力日
Dim strReportCd                             '帳票コード
Dim UID                                     'ユーザID

'作業用変数
Dim strSCslDate                             '開始日
Dim strECslDate                             '終了日
Dim strOrgGrpName                           '団体グループ名称
Dim strOrgName1                             '団体１名称
Dim strOrgName2                             '団体２名称
Dim strOrgName3                             '団体３名称
Dim strOrgName4                             '団体４名称
Dim strOrgName5                             '団体５名称
Dim strOrgName6                             '団体６名称
Dim strOrgName7                             '団体７名称
Dim strOrgName8                             '団体７名称
Dim strOrgName9                             '団体７名称
Dim strOrgName10                            '団体７名称

'帳票情報
Dim strArrReportCd                          '帳票コード
Dim strArrReportName                        '帳票名
Dim strArrHistoryPrint                      '過去歴印刷
Dim lngReportCount                          'レコード数

Dim i                   'ループインデックス
Dim j                   'ループインデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objOrgBsd       = Server.CreateObject("HainsOrgBsd.OrgBsd")
Set objOrgRoom      = Server.CreateObject("HainsOrgRoom.OrgRoom")
Set objOrgPost      = Server.CreateObject("HainsOrgPost.OrgPost")
Set objPerson       = Server.CreateObject("HainsPerson.Person")

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
' 備考　　 : URLの引数値を取得する処理を記述して下さい
'
'-------------------------------------------------------------------------------
Sub GetQueryString()

'◆ 開始年月日
    If IsEmpty(Request("strCslYear")) Then
        strSCslYear   = Year(Now())             '開始年
        strSCslMonth  = Month(Now())            '開始月
        strSCslDay    = Day(Now())              '開始日
    Else
        strSCslYear   = Request("strCslYear")   '開始年
        strSCslMonth  = Request("strCslMonth")  '開始月
        strSCslDay    = Request("strCslDay")    '開始日
    End If
    strSCslDate   = strSCslYear & "/" & strSCslMonth & "/" & strSCslDay
'◆ 終了年月日
    If IsEmpty(Request("endCslYear")) Then
        strECslYear   = Year(Now())             '終了年
        strECslMonth  = Month(Now())            '開始月
        strECslDay    = Day(Now())              '開始日
    Else
        strECslYear   = Request("endCslYear")   '終了年
        strECslMonth  = Request("endCslMonth")  '開始月
        strECslDay    = Request("endCslDay")    '開始日
    End If
    strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
'◆ 開始年月日と終了年月日の大小判定と入替
'   （日付型に変換してチェックしないのは日付として誤った値であったときのエラー回避の為）
    If Right("0000" & Trim(CStr(strSCslYear)), 4) & _
       Right("00" & Trim(CStr(strSCslMonth)), 2) & _
       Right("00" & Trim(CStr(strSCslDay)), 2) _
     > Right("0000" & Trim(CStr(strECslYear)), 4) & _
       Right("00" & Trim(CStr(strECslMonth)), 2) & _
       Right("00" & Trim(CStr(strECslDay)), 2) Then
        strSCslYear   = strECslYear
        strSCslMonth  = strECslMonth
        strSCslDay    = strECslDay
        strSCslDate   = strECslDate
        strECslYear   = Request("strCslYear")   '開始年
        strECslMonth  = Request("strCslMonth")  '開始月
        strECslDay    = Request("strCslDay")    '開始日
        strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
    End If

    strOutputCls    = Request("outputCls")

'◆ 団体コード
If strOutputCls = "0" Then
    '団体１
    strOrgCd11  = Request("OrgCd11")
    strOrgCd12  = Request("OrgCd12")
    strOrgName1 = Request("OrgName1")

    '団体２
    strOrgCd21  = Request("OrgCd21")
    strOrgCd22  = Request("OrgCd22")
    strOrgName2 = Request("OrgName2")
    '団体３
    strOrgCd31  = Request("OrgCd31")
    strOrgCd32  = Request("OrgCd32")
    strOrgName3 = Request("OrgName3")
    '団体４
    strOrgCd41  = Request("OrgCd41")
    strOrgCd42  = Request("OrgCd42")
    strOrgName4 = Request("OrgName4")
    '団体５
    strOrgCd51  = Request("OrgCd51")
    strOrgCd52  = Request("OrgCd52")
    strOrgName5 = Request("OrgName5")
    '団体６
    strOrgCd61  = Request("OrgCd61")
    strOrgCd62  = Request("OrgCd62")
    strOrgName6 = Request("OrgName6")
    '団体７
    strOrgCd71  = Request("OrgCd71")
    strOrgCd72  = Request("OrgCd72")
    strOrgName7 = Request("OrgName7")
    strOrgCd81  = Request("OrgCd81")
    strOrgCd82  = Request("OrgCd82")
    strOrgName8 = Request("OrgName8")
    strOrgCd91  = Request("OrgCd91")
    strOrgCd92  = Request("OrgCd92")
    strOrgName9 = Request("OrgName9")
    strOrgCd101 = Request("OrgCd101")
    strOrgCd102 = Request("OrgCd102")
    strOrgName10 = Request("OrgName10")
Else
    strOrgCd11  = Request("OrgCd1")
    strOrgCd21  = Request("OrgCd2")
    strOrgCd31  = Request("OrgCd3")
    strOrgCd41  = Request("OrgCd4")
    strOrgCd51  = Request("OrgCd5")
    strOrgCd61  = Request("OrgCd6")
    strOrgCd71  = Request("OrgCd7")
    strOrgCd81  = Request("OrgCd8")
    strOrgCd91  = Request("OrgCd9")
    strOrgCd101 = Request("OrgCd10")
    strOrgCd12  = ""
    strOrgCd22  = ""
    strOrgCd32  = ""
    strOrgCd42  = ""
    strOrgCd52  = ""
    strOrgCd62  = ""
    strOrgCd72  = ""
    strOrgCd82  = ""
    strOrgCd92  = ""
    strOrgCd102 = ""
End If
    strCsCd     = Request("csCd")
    strCsCd1    = Request("csCd1")
    strCsCd2    = Request("csCd2")
    strCsCd3    = Request("csCd3")
    strCsCd4    = Request("csCd4")
    strCsCd5    = Request("csCd5")
    strCsCd6    = Request("csCd6")
    strCsCd7    = Request("csCd7")
    strCsCd8    = Request("csCd8")
    strCsCd9    = Request("csCd9")

     
'◆ ユーザID
    UID = Session("USERID")

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

    Dim vntArrMessage	'エラーメッセージの集合

    'ここにチェック処理を記述
    With objCommon
'例)        .AppendArray vntArrMessage, コメント
        If strMode <> "" Then
            '受診日チェック
            If Not IsDate(strSCslDate) Then
                .AppendArray vntArrMessage, "開始日付が正しくありません。"
            End If
            If Not IsDate(strECslDate) Then
                .AppendArray vntArrMessage, "終了日付が正しくありません。"
            End If

             If strOrgCd11 = "" Then
                .AppendArray vntArrMessage, "団体コードが未設定です"
            End If
       
        End If
    
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



    Dim objCommon   '共通クラス
    Dim Ret         '関数戻り値
    Dim strURL
    Dim objPrintCls

    If Not IsArray(CheckValue()) Then

        'オブジェクトのインスタンス作成（プロジェクト名.クラス名）
        Set objPrintCls = Server.CreateObject("HainsprtAneiho.prtAneiho")

        'ドキュメントファイル作成処理（オブジェクト.メソッド名(引数)）
        Ret = objPrintCls.PrintOut(Server.HTMLEncode(Session("USERID")), strSCslDate, strECslDate, stroutputCls, strOrgCd11 & strOrgCd12, strOrgCd21 & strOrgCd22, strOrgCd31 & strOrgCd32, strOrgCd41 & strOrgCd42, strOrgCd51 & strOrgCd52, strOrgCd61 & strOrgCd62, strOrgCd71 & strOrgCd72, strOrgCd81 & strOrgCd82, strOrgCd91 & strOrgCd92, strOrgCd101 & strOrgCd102, strCsCd, strCsCd1, strCsCd2, strCsCd3, strCsCd4, strCsCd5, strCsCd6, strCsCd7, strCsCd8, strCsCd9)

        print=Ret

'		Set objCommon = Server.CreateObject("HainsCommon.Common")
'		strURL= ""
'		strURL = "http://192.168.100.182/webhains/contents/report_form/prtAneihoics_mrd.asp"
''	     strURL = "/webHains/contents/prtAneihoStatistics_mrd.asp"
'		strURL = strURL & "?p_Uid=" & UID
'		strURL = strURL & "&p_startDate=" & objCommon.FormatString(CDate(strSCslDate), "yyyy/mm/dd")
'		strURL = strURL & "&p_endDate=" & objCommon.FormatString(CDate(strECslDate), "yyyy/mm/dd")		
'		strURL = strURL & "&p_OrgMethod=" & stroutputCls
'		strURL = strURL & "&p_Orgcd1=" & strOrgCd11 & strOrgCd12 
'		strURL = strURL & "&p_Orgcd2=" & strOrgCd21 & strOrgCd22
'		strURL = strURL & "&p_Orgcd3=" & strOrgCd31 & strOrgCd32
'		strURL = strURL & "&p_Orgcd4=" & strOrgCd41 & strOrgCd42
'		strURL = strURL & "&p_Orgcd5=" & strOrgCd51 & strOrgCd52
'		strURL = strURL & "&p_Orgcd6=" & strOrgCd61 & strOrgCd62
'		strURL = strURL & "&p_Orgcd7=" & strOrgCd71 & strOrgCd72
'		strURL = strURL & "&p_Orgcd8=" & strOrgCd81 & strOrgCd82
'		strURL = strURL & "&p_Orgcd9=" & strOrgCd91 & strOrgCd92
'		strURL = strURL & "&p_Orgcd10=" & strOrgCd101 & strOrgCd102
'		strURL = strURL & "&p_Cscd1=" & strCsCd
'		strURL = strURL & "&p_Cscd2=" & strCsCd1
'		strURL = strURL & "&p_Cscd3=" & strCsCd2
'		strURL = strURL & "&p_Cscd4=" & strCsCd3
'		strURL = strURL & "&p_Cscd5=" & strCsCd4
'		strURL = strURL & "&p_Cscd6=" & strCsCd5
'		strURL = strURL & "&p_Cscd7=" & strCsCd6
'		strURL = strURL & "&p_Cscd8=" & strCsCd7
'		strURL = strURL & "&p_Cscd9=" & strCsCd8
'		strURL = strURL & "&p_Cscd10=" & strCsCd9
'		Set objCommon = Nothing
'		Response.Redirect strURL
'		Response.End

    End If
End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Microsoft FrontPage 4.0">
<TITLE>労働基準監督署統計</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// 団体画面表示
function showGuideOrgGrp( Cd1, Cd2, CtrlName ) {
    // 団体情報エレメントの参照設定
    orgPostGuide_getElement( Cd1, Cd2, CtrlName );
    // 画面表示
    orgPostGuide_showGuideOrg();
}
// 団体情報削除
function clearGuideOrgGrp( Cd1, Cd2, CtrlName ) {
    // 団体情報エレメントの参照設定
    orgPostGuide_getElement( Cd1, Cd2, CtrlName );
    // 削除
    orgPostGuide_clearOrgInfo();
}
// submit時の処理
function submitForm() {
    document.entryForm.submit();
}
//function selectHistoryPrint( index ) {
//  document.entryForm.historyPrint.value = document.historyPrintForm.historyPrint[ index ].value;
//}
-->
</SCRIPT>
<script TYPE="text/javascript" src="/webHains/js/checkRunState.js?v=1.2"></script>
<STYLE TYPE="text/css">
<!--
td.prttab { background-color:#ffffff }
-->
</STYLE>
</HEAD>
<BODY ONLOAD="checkRunState();">
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" onsubmit="setRunState();">
<INPUT TYPE="hidden" NAME="runstate" VALUE="">
<BLOCKQUOTE>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
	    <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">■労働基準監督署統計</SPAN></B></TD>
	</TR>
</TABLE>
<BR>
<%
    'エラーメッセージ表示
    Call EditMessage(vntMessage, MESSAGETYPE_WARNING)
%>
<%
    'モードはプレビュー固定
%>
    <INPUT TYPE="hidden" NAME="mode" VALUE="0">	

    <INPUT TYPE="hidden" NAME="OrgGrpName"    VALUE="<%= strOrgGrpName    %>">
    <INPUT TYPE="hidden" NAME="orgCd11"       VALUE="<%= strOrgCd11       %>">
    <INPUT TYPE="hidden" NAME="orgCd12"       VALUE="<%= strOrgCd12       %>">
    <INPUT TYPE="hidden" NAME="orgCd21"       VALUE="<%= strOrgCd21       %>">
    <INPUT TYPE="hidden" NAME="orgCd22"       VALUE="<%= strOrgCd22       %>">
    <INPUT TYPE="hidden" NAME="orgCd31"       VALUE="<%= strOrgCd31       %>">
    <INPUT TYPE="hidden" NAME="orgCd32"       VALUE="<%= strOrgCd32       %>">
    <INPUT TYPE="hidden" NAME="orgCd41"       VALUE="<%= strOrgCd41       %>">
    <INPUT TYPE="hidden" NAME="orgCd42"       VALUE="<%= strOrgCd42       %>">
    <INPUT TYPE="hidden" NAME="orgCd51"       VALUE="<%= strOrgCd51       %>">
    <INPUT TYPE="hidden" NAME="orgCd52"       VALUE="<%= strOrgCd52       %>">
    <INPUT TYPE="hidden" NAME="orgCd61"       VALUE="<%= strOrgCd61       %>">
    <INPUT TYPE="hidden" NAME="orgCd62"       VALUE="<%= strOrgCd62       %>">
    <INPUT TYPE="hidden" NAME="orgCd71"       VALUE="<%= strOrgCd71       %>">
    <INPUT TYPE="hidden" NAME="orgCd72"       VALUE="<%= strOrgCd72       %>">
    <INPUT TYPE="hidden" NAME="orgCd81"       VALUE="<%= strOrgCd81       %>">
    <INPUT TYPE="hidden" NAME="orgCd82"       VALUE="<%= strOrgCd82       %>">
    <INPUT TYPE="hidden" NAME="orgCd91"       VALUE="<%= strOrgCd91       %>">
    <INPUT TYPE="hidden" NAME="orgCd92"       VALUE="<%= strOrgCd92       %>">
    <INPUT TYPE="hidden" NAME="orgCd101"      VALUE="<%= strOrgCd101      %>">
    <INPUT TYPE="hidden" NAME="orgCd102"      VALUE="<%= strOrgCd102      %>">

    <!--- 日付 -->
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD><FONT COLOR="#ff0000">■</FONT></TD>
            <TD WIDTH="90" NOWRAP>受診日</TD>
            <TD>：</TD>
            <TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
            <TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strSCslYear, False) %></TD>
            <TD>年</TD>
            <TD><%= EditNumberList("strCslMonth", 1, 12, strSCslMonth, False) %></TD>
            <TD>月</TD>
            <TD><%= EditNumberList("strCslDay", 1, 31, strSCslDay, False) %></TD>
            <TD>日</TD>
            <TD>～</TD>
            <TD><A HREF="javascript:calGuide_showGuideCalendar('endCslYear', 'endCslMonth', 'endCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
            <TD><%= EditNumberList("endCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strECslYear, False) %></TD>
            <TD>年</TD>
            <TD><%= EditNumberList("endCslMonth", 1, 12, strECslMonth, False) %></TD>
            <TD>月</TD>
            <TD><%= EditNumberList("endCslDay", 1, 31, strECslDay, False) %></TD>
            <TD>日</TD>
        </TR>
    </TABLE>

    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <tr>
            <td><FONT COLOR="#ff0000">■</FONT></td>
            <td width="96" nowrap>団体コード選択</td>
            <td>：</td>
            <TD>
                <select name="outputCls" size="1">
                    <option selected value="0">団体コード　1-2</option>
                    <option value="1">団体コード　1　のみ</option>
                </select>
            </TD>
            <td></td>
        </tr>
    </TABLE>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD>□</TD>
            <TD WIDTH="90" NOWRAP>団体１</TD>
            <TD>：</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd11, document.entryForm.orgCd12, 'OrgName1')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd11, document.entryForm.orgCd12, 'OrgName1')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName1"><% = strOrgName1 %></SPAN></TD>
        </TR>
        <TR>
            <TD>□</TD>
            <TD WIDTH="90" NOWRAP>団体２</TD>
            <TD>：</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd21, document.entryForm.orgCd22, 'OrgName2')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd121, document.entryForm.orgCd22, 'OrgName2')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName2"><% = strOrgName2 %></SPAN></TD>
        </TR>
        <TR>
            <TD>□</TD>
            <TD WIDTH="90" NOWRAP>団体３</TD>
            <TD>：</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd31, document.entryForm.orgCd32, 'OrgName3')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd131, document.entryForm.orgCd32, 'OrgName3')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName3"><% = strOrgName3 %></SPAN></TD>
        </TR>
        <TR>
            <TD>□</TD>
            <TD WIDTH="90" NOWRAP>団体４</TD>
            <TD>：</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd41, document.entryForm.orgCd42, 'OrgName4')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd141, document.entryForm.orgCd42, 'OrgName4')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName4"><% = strOrgName4 %></SPAN></TD>
        </TR>
        <TR>
            <TD>□</TD>
            <TD WIDTH="90" NOWRAP>団体５</TD>
            <TD>：</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd51, document.entryForm.orgCd52, 'OrgName5')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd51, document.entryForm.orgCd52, 'OrgName5')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName5"><% = strOrgName5 %></SPAN></TD>
        </TR>
        <TR>
            <TD>□</TD>
            <TD WIDTH="90" NOWRAP>団体６</TD>
            <TD>：</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd61, document.entryForm.orgCd62, 'OrgName6')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd61, document.entryForm.orgCd62, 'OrgName6')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName6"><% = strOrgName6 %></SPAN></TD>
        </TR>
        <TR>
            <TD>□</TD>
            <TD WIDTH="90" NOWRAP>団体７</TD>
            <TD>：</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd71, document.entryForm.orgCd72, 'OrgName7')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd71, document.entryForm.orgCd72, 'OrgName7')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName7"><% = strOrgName7 %></SPAN></TD>
        </TR>
        <TR>
            <TD>□</TD>
            <TD WIDTH="132" NOWRAP>団体8</TD>
            <TD>：</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd81, document.entryForm.orgCd82, 'OrgName8')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd81, document.entryForm.orgCd82, 'OrgName8')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName8"><% = strOrgName8 %></SPAN></TD>
        </TR>
        <TR>
            <TD>□</TD>
            <TD WIDTH="132" NOWRAP>団体9</TD>
            <TD>：</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd91, document.entryForm.orgCd92, 'OrgName9')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd91, document.entryForm.orgCd92, 'OrgName9')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName9"><% = strOrgName9 %></SPAN></TD>
        </TR>		
        <TR>
            <TD>□</TD>
            <TD WIDTH="132" NOWRAP>団体10</TD>
            <TD>：</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd101, document.entryForm.orgCd102, 'OrgName10')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd101, document.entryForm.orgCd102, 'OrgName10')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName10"><% = strOrgName10 %></TD>
        </TR>	
    </TABLE>

    <table border="0" cellpadding="1" cellspacing="2">
                    <tr>
                        <TD>□</TD>
                        <td width="150" nowrap>団体コード（手入力） 1-5</td>
                        <td>：</td>
                        <td><input type="text" name="orgCd1" size="15" value="" maxlength="5"> <input type="text" name="orgCd2" size="15" value="" maxlength="5"> <input type="text" name="orgCd3" size="15" value="" maxlength="5"> <input type="text" name="orgCd4" size="15" value="" maxlength="5"> <input type="text" name="orgCd5" size="15" value="" maxlength="5"> </td>
                    </tr>
                    <tr>
                            <TD>□</TD>
                        <td width="150" nowrap>団体コード（手入力） 6-10</td>
                        <td>：</td>
                        <td><input type="text" name="orgCd6" size="15" value="" maxlength="5"> <input type="text" name="orgCd7" size="15" value="" maxlength="5"> <input type="text" name="orgCd8" size="15" value="" maxlength="5"> <input type="text" name="orgCd9" size="15" value="" maxlength="5"> <input type="text" name="orgCd10" size="15" value="" maxlength="5"></td>
                    </tr>
</table>

<table border="0" cellpadding="1" cellspacing="2">

<%
    '## 2013/1/4 張 デフォルトコース設定の為、コメント追加 Start ##########################################
%>
                    <tr><td colspan="5">&nbsp;</td></tr>
                    <tr>
                        <td colspan="5"><font color="red">※ コースコード未指定の場合、「1日人間ドック」、「職員定期健康診断（ドック）」、「企業健診」のみ対象とします。</font></td>
                    </tr>
<%
    '## 2013/1/4 張 デフォルトコース設定の為、コメント追加 Start ##########################################
%>

                    <tr>
                        <td>□</td>
                        <td width="120" nowrap>コースコード 1-2</td>
                        <td>：</td>
                        <td><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd", strCsCd, NON_SELECTED_ADD, False) %></td>
                              <td><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd1", strCsCd1, NON_SELECTED_ADD, False) %></td>
                    </tr>
                    <tr>
                        <td>□</td>
                        <td width="120" nowrap>コースコード 3-4</td>
                        <td>：</td>
                              <td><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd2", strCsCd2, NON_SELECTED_ADD, False) %></td>
                              <td><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd3", strCsCd3, NON_SELECTED_ADD, False) %></td>
                    </tr>
                    <tr>
                        <td>□</td>
                        <td width="120" nowrap>コースコード 5-6</td>
                        <td>：</td>
                        <td><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd4", strCsCd4, NON_SELECTED_ADD, False) %></td>
                              <td><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd5", strCsCd5, NON_SELECTED_ADD, False) %></td>
                    </tr>
                    <tr>
                        <td>□</td>
                        <td width="120" nowrap>コースコード 7-8</td>
                        <td>：</td>
                        <td><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd6", strCsCd6, NON_SELECTED_ADD, False) %></td>
                              <td><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd7", strCsCd7, NON_SELECTED_ADD, False) %></td>
                    </tr>
                    <tr>
                        <td>□</td>
                        <td width="120" nowrap>コースコード 9-10</td>
                        <td>：</td>
                              <td><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd8", strCsCd8, NON_SELECTED_ADD, False) %></td>
                              <td><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd9", strCsCd9, NON_SELECTED_ADD, False) %></td>
                    </tr>
</table>

<!--- 印刷モード -->
<%
    '印刷モードの初期設定
    strMode = IIf(strMode = "", PRINTMODE_PREVIEW, strMode)
%>
    <BR><BR>

<!--- 印刷ボタン -->
    <!---2006.07.04 権限管理 追加 by 李  -->
    <% If Session("PAGEGRANT") = "4" Then   %>
        <INPUT TYPE="image" NAME="print" SRC="/webHains/images/print.gif" WIDTH="77" HEIGHT="24" ALT="印刷する">
    <%  End if  %>
</BLOCKQUOTE>


</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
</BODY>
</HTML>