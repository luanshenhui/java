<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'        成績書 (Ver0.0.1)
'        AUTHER  : (NSC)birukawa
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
Dim strMode                '印刷モード
Dim vntMessage            '通知メッセージ

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

'パラメータ値
Dim strSCslYear, strSCslMonth, strSCslDay   '開始年月日
Dim strECslYear, strECslMonth, strECslDay   '終了年月日
Dim strOrgdiv                               '
Dim strDm                                   '
Dim striti                                  '
Dim strbusu                                 '
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
dim strOptResult

Dim strReportOutDate                        '出力日
Dim strReportOutput                         '出力様式
Dim strHistoryPrint                         '過去歴印刷
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

Dim i                    'ループインデックス
Dim j                    'ループインデックス

Dim strOutPutCls                            '出力対象
Dim strArrOutputCls()                       '出力対象区分
Dim strArrOutputClsName()                   '出力対象区分名

Dim strOutPutCls1                           '出力対象
Dim strArrOutputCls1()                      '出力対象区分
Dim strArrOutputClsName1()                  '出力対象区分名

Dim strOutPutCls2                           '出力対象
Dim strArrOutputCls2()                      '出力対象区分
Dim strArrOutputClsName2()                  '出力対象区分名

Dim strOutPutCls3                           '出力対象
Dim strArrOutputCls3()                      '出力対象区分
Dim strArrOutputClsName3()                  '出力対象区分名

Dim strOutPutCls4                           '出力対象
Dim strArrOutputCls4()                      '出力対象区分
Dim strArrOutputClsName4()                  '出力対象区分名

Dim strOutPutCls5                           '出力対象
Dim strArrOutputCls5()                      '出力対象区分
Dim strArrOutputClsName5()                  '出力対象区分名

Dim strOutPutCls6                           '出力対象
Dim strArrOutputCls6()                      '出力対象区分
Dim strArrOutputClsName6()                  '出力対象区分名

Dim ogc1
Dim ogc2
Dim ogc3
Dim ogc4
Dim ogc5
Dim ogc6
Dim ogc7
Dim ogc8
Dim ogc9
Dim ogc10

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
        strSCslYear   = Year(Now())                '開始年
        strSCslMonth  = Month(Now())            '開始月
        strSCslDay    = Day(Now())                '開始日
    Else
        strSCslYear   = Request("strCslYear")    '開始年
        strSCslMonth  = Request("strCslMonth")    '開始月
        strSCslDay    = Request("strCslDay")    '開始日
    End If
    strSCslDate     = strSCslYear & "/" & strSCslMonth & "/" & strSCslDay


    strOutputCls    = Request("outputCls")
    strOptResult    = Request("OptResult")
    
    
'◆ 団体コード
    '団体１
    strOrgCd11      = Request("OrgCd11")
    strOrgCd12      = Request("OrgCd12")
    strOrgName1     = Request("OrgName1")

    '団体２
    strOrgCd21      = Request("OrgCd21")
    strOrgCd22      = Request("OrgCd22")
    strOrgName2     = Request("OrgName2")
    '団体３
    strOrgCd31      = Request("OrgCd31")
    strOrgCd32      = Request("OrgCd32")
    strOrgName3     = Request("OrgName3")
    '団体４
    strOrgCd41      = Request("OrgCd41")
    strOrgCd42      = Request("OrgCd42")
    strOrgName4     = Request("OrgName4")
    '団体５
    strOrgCd51      = Request("OrgCd51")
    strOrgCd52      = Request("OrgCd52")
    strOrgName5     = Request("OrgName5")
    '団体６
    strOrgCd61      = Request("OrgCd61")
    strOrgCd62      = Request("OrgCd62")
    strOrgName6     = Request("OrgName6")
    '団体７
    strOrgCd71      = Request("OrgCd71")
    strOrgCd72      = Request("OrgCd72")
    strOrgName7     = Request("OrgName7")
    strOrgCd81      = Request("OrgCd81")
    strOrgCd82      = Request("OrgCd82")
    strOrgName8     = Request("OrgName8")
    strOrgCd91      = Request("OrgCd91")
    strOrgCd92      = Request("OrgCd92")
    strOrgName9     = Request("OrgName9")
    strOrgCd101     = Request("OrgCd101")
    strOrgCd102     = Request("OrgCd102")
    strOrgName10    = Request("OrgName10")

'◆ ユーザID
    UID             = Session("USERID")

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

    Dim vntArrMessage    'エラーメッセージの集合
    Dim blnErrFlg

    'ここにチェック処理を記述(主に必須のチェック（有・無）
    With objCommon


    End With

    '戻り値の編集
    If IsArray(vntArrMessage) Then
        CheckValue = vntArrMessage
    End If

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 出力対象に関する配列を生成する
'
' 引数　　 : 
'
' 戻り値　 : なし
'
' 備考　　 : 
'
'-------------------------------------------------------------------------------
Sub CreateOutputInfo()

    
End Sub

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
    
    Dim objCommon    '共通クラス
    Dim Ret            '関数戻り値
    Dim strURL
    Dim objFlexReport
          
    If Not IsArray(CheckValue()) Then
    
        ogc1 = strOrgCd11 & strOrgCd12
        ogc2 = strOrgCd21 & strOrgCd22
        ogc3 = strOrgCd31 & strOrgCd32
        ogc4 = strOrgCd41 & strOrgCd42
        ogc5 = strOrgCd51 & strOrgCd52
        ogc6 = strOrgCd61 & strOrgCd62
        ogc7 = strOrgCd71 & strOrgCd72
        ogc8 = strOrgCd81 & strOrgCd82
        ogc9 = strOrgCd91 & strOrgCd92
        ogc10 = strOrgCd101 & strOrgCd102
        
        Set objFlexReport = Server.CreateObject("HainsCompanyconduct.company")
        Ret = objFlexReport.Printcompany(Session("USERID"),strSCslDate,strOptResult,ogc1,ogc2,ogc3,ogc4,ogc5,ogc6,ogc7,ogc8,ogc9,ogc10,strOutputCls)
        Print = Ret
        
    End If

End Function

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Microsoft FrontPage 4.0">
<TITLE>契約団体調査票出力</TITLE>
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
//    document.entryForm.historyPrint.value = document.historyPrintForm.historyPrint[ index ].value;
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
<BODY ONLOAD="javascript:checkRunState();">
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" onsubmit="setRunState();">
<INPUT TYPE="hidden" NAME="runstate" VALUE="">
    <BLOCKQUOTE>

    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">■</SPAN>契約団体調査票出力</B></TD>
        </TR>
    </TABLE>
    <BR>
    
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
    <INPUT TYPE="hidden" NAME="orgCd101"       VALUE="<%= strOrgCd101       %>">
    <INPUT TYPE="hidden" NAME="orgCd102"       VALUE="<%= strOrgCd102       %>">
                <table border="0" cellpadding="1" cellspacing="2">
                    <tr>
                        <td><font color="#ff0000">■</font></td>
                        <td width="90" nowrap>基準日</td>
                        <td>：</td>
                        <td><a href="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay')"><img src="/webHains/images/question.gif" width="21" height="21" alt="日付ガイドを表示"></a></td>
                        <td><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strSCslYear, False) %></td>
                        <td>年</td>
                        <td><%= EditNumberList("strCslMonth", 1, 12, strSCslMonth, False) %></td>
                        <td>月</td>
                        <td><%= EditNumberList("strCslDay", 1, 31, strSCslDay, False) %></td>
                        <td>日</td>
                    </tr>
                </table>
                <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
            <TR>
                    <td><font color="#ff0000">■</font></td>
                    <td width="132" nowrap>団体指定方法</td>
                    <td>：</td>
                    <TD>
                        <INPUT TYPE="radio" NAME="optResult" VALUE="0"  <%= IIf(strOptResult = 0, "CHECKED", "") %>>個別
                        <INPUT TYPE="radio" NAME="optResult" VALUE="2"  <%= IIf(strOptResult = 2, "CHECKED", "") %>>全て
                    </TD>
              </TR>
</table>
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD>□</TD>
            <TD WIDTH="90" NOWRAP>団体１</TD>
            <TD>：</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd11, document.entryForm.orgCd12, 'OrgName1')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd11, document.entryForm.orgCd12, 'OrgName1')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName1"></SPAN></TD>
        </TR>
        <TR>
            <TD>□</TD>
            <TD WIDTH="90" NOWRAP>団体２</TD>
            <TD>：</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd21, document.entryForm.orgCd22, 'OrgName2')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd21, document.entryForm.orgCd22, 'OrgName2')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName2"></SPAN></TD>
        </TR>
        <TR>
            <TD>□</TD>
            <TD WIDTH="90" NOWRAP>団体３</TD>
            <TD>：</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd31, document.entryForm.orgCd32, 'OrgName3')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd31, document.entryForm.orgCd32, 'OrgName3')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName3"><% = strOrgName3 %></SPAN></TD>
        </TR>
        <TR>
            <TD>□</TD>
            <TD WIDTH="90" NOWRAP>団体４</TD>
            <TD>：</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd41, document.entryForm.orgCd42, 'OrgName4')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd41, document.entryForm.orgCd42, 'OrgName4')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
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
            <TD NOWRAP><SPAN ID="OrgName10"><% = strOrgName10 %></SPAN></TD>
        </TR>    
    </TABLE>
    
<table border="0" cellpadding="1" cellspacing="2">
        <tr>
            <td><font color="#ff0000">■</font></td>
            <td width="132" nowrap>ｺｰｽ区分</td>
            <td>：</td>
                            <TD>
                <select name="outputCls" size="1">
                    <option selected value="0">全て</option>
                    <option value="1">1日ドック</option>
                    <option value="2">企業健診</option>
                </select>
            </TD>
                        </tr>
</table>
                <!--- 印刷モード -->
<%
    '印刷モードの初期設定
    strMode = IIf(strMode = "", PRINTMODE_PREVIEW, strMode)
%>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">

    </TABLE>

    <BR><BR>

<!--- 印刷ボタン -->
    <!---2006.07.04 権限管理 追加 by 李  -->
    <% If Session("PAGEGRANT") = "4" Then   %>
        <INPUT TYPE="image" NAME="print" SRC="/webHains/images/print.gif" WIDTH="77" HEIGHT="24" ALT="印刷する">
    <%  End if  %>
</BLOCKQUOTE>
<!--
<%= strSCslDate %>
    <BR>
<%= strOptResult %>
    <BR>
<%= ogc1 %>
    <BR>
<%= ogc2 %>
    <BR>
<%= ogc3 %>
    <BR>
<%= ogc4 %>
    <BR>
<%= ogc5 %>
    <BR>
<%= ogc6 %>
    <BR>
<%= ogc7 %>
    <BR>
<%= ogc8 %>
    <BR>
<%= ogc9 %>
    <BR>
<%= ogc10 %>
    <BR>
<%= strOutputCls %>
-->
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
</BODY>
</HTML>