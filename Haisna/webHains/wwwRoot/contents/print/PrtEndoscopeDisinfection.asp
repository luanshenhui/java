<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'   内視鏡洗浄消毒履歴表 (Ver0.0.1)
'   AUTHER  :
'-------------------------------------------------------------------------------
'       管理番号：SL-UI-Y0101-209
'       修正日  ：2010.05.27
'       担当者  ：ASC)武藤
'       修正内容：Report DesignerをCo Reportsに変更
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"          -->
<!-- #include virtual = "/webHains/includes/common.inc"                -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"           -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"        -->
<!-- #include virtual = "/webHains/includes/print.inc"                 -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc"  -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseTable.inc" -->
<!-- #include virtual = "/webHains/includes/tokyu_editReportList.inc"  -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim strMode         '印刷モード
Dim vntMessage      '通知メッセージ
Dim strURL          'URL
Dim UID
'-------------------------------------------------------------------------------
' 固有宣言部（各帳票に応じてこのセクションに変数を定義して下さい）
'-------------------------------------------------------------------------------
'COMオブジェクト
Dim objCommon       '共通クラス

'■■■■■■■■■■ 画面項目にあわせて編集
'引数値
Dim strSCslYear, strSCslMonth, strSCslDay       '撮影日(自)

'■■■■■■■■■■

'作業用変数
Dim strSCslDate         '開始日
Dim i, j                'カウンタ

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
Set objCommon       = Server.CreateObject("HainsCommon.Common")

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
'■■■■■■■■■■ 画面項目にあわせて編集
    '括弧内の文字列はHTML部で記述した項目の名称となります

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
    UID = Session("USERID")

'■■■■■■■■■■
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

    Dim vntArrMessage   'エラーメッセージの集合

'■■■■■■■■■■ 画面項目にあわせて編集
    'ここにチェック処理を記述
    With objCommon
'例)		.AppendArray vntArrMessage, コメント

    End With
'■■■■■■■■■■

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
' 備考　　 : 帳票ドキュメントファイル作成メソッドを呼び出す。メソッド内では次の処理が行われる。
' 　　　　   ?@印刷ログ情報の作成
' 　　　　   ?A帳票ドキュメントファイルの作成
' 　　　　   ?B処理成功時は印刷ログ情報レコードの主キーであるプリントSEQを戻り値として返す。
' 　　　　   このSEQ値を元に以降のハンドリングを行う。
'
'-------------------------------------------------------------------------------
Function Print()

    Dim objPrintCls     'COMコンポーネント
    Dim Ret             '関数戻り値

    Dim objCommon
    If Not IsArray(CheckValue()) Then

         '情報漏えい対策用ログ書き出し
         Call putPrivacyInfoLog("PH024", "内視鏡洗浄消毒履歴の印刷を行った")

        Set objCommon = Server.CreateObject("HainsCommon.Common")
'#### 2010.05.27 SL-UI-Y0101-209 MOD START ####'
'        strURL = "/webHains/contents/report_form/rd_14_PrtEndoscopeDisinfection.asp"
'        strURL = strURL & "?p_Uid=" & UID
'        strURL = strURL & "&p_ScslDate=" & objCommon.FormatString(CDate(strSCslDate), "yyyy/mm/dd")
'        Set objCommon = Nothing
'        Response.Redirect strURL
'        Response.End

        'オブジェクトのインスタンス作成（プロジェクト名.クラス名）
        Set objPrintCls = Server.CreateObject("HainsprtEndoscopeDisinfection.prtEndoDf")
        'ドキュメントファイル作成処理（オブジェクト.メソッド名(引数)）
        Ret = objPrintCls.PrintOut(UID, strSCslDate)
        Print = Ret
'#### 2010.05.27 SL-UI-Y0101-209 MOD END ####'
    End If

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<!--- ◆ ↓<Title>の修正を忘れないように ◆ -->
<TITLE>内視鏡洗浄消毒履歴</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<SCRIPT TYPE="text/javascript">
<!--
// エレメントの参照設定
function setElement() {
}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.prttab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONLOAD="javascript:setElement()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
    <BLOCKQUOTE>

<!--- タイトル -->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">■内視鏡洗浄消毒履歴</SPAN></B></TD>
        </TR>
    </TABLE>
<%
'エラーメッセージ表示
    Call EditMessage(vntMessage, MESSAGETYPE_WARNING)
%>
    <BR>

<!--- 日付 -->
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD><FONT COLOR="#ff0000">■</FONT></TD>
            <TD WIDTH="90" NOWRAP>受診日</TD>
            <TD> ：</TD>
            <TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
            <TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strSCslYear, False) %></TD>
            <TD>年</TD>
            <TD><%= EditNumberList("strCslMonth", 1, 12, strSCslMonth, False) %></TD>
            <TD>月</TD>
            <TD><%= EditNumberList("strCslDay", 1, 31, strSCslDay, False) %></TD>
            <TD>日</TD>
        </TR>
    </TABLE>
                <br>
                <BR>
                <!--- 印刷モード -->
<%
    '印刷モードの初期設定
    strMode = IIf(strMode = "", PRINTMODE_PREVIEW, strMode)
%>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
        <TR>
            <INPUT TYPE="hidden" NAME="mode" VALUE="0">
        </TR>
    </TABLE>

    <BR><BR>

<!--- 印刷ボタン -->
    <% If Session("PAGEGRANT") = "4" Then   %>
        <INPUT TYPE="image" NAME="print" SRC="/webHains/images/print.gif" WIDTH="77" HEIGHT="24" ALT="印刷する">
    <%  End if  %>

    </BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>

</BODY>
</HTML>