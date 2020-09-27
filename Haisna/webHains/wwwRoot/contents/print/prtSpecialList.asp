<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'   特定健診受診者リスト (Ver0.0.1)
'   AUTHER  :
'-------------------------------------------------------------------------------
'       管理番号：SL-UI-Y0101-215
'       修正日  ：2010.04.26
'       担当者  ：ASC)福地
'       修正内容：Report DesignerをCo Reportsに変更
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/print.inc"                -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc"   -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseTable.inc"  -->
<!-- #include virtual = "/webHains/includes/tokyu_editReportList.inc"   -->
<!-- #include virtual = "/webHains/includes/tokyu_editDmdClassList.inc" -->
<!-- #include virtual = "/webHains/includes/tokyu_editJudClassList.inc" -->
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
'データベースアクセス用オブジェクト
Dim objFree         '汎用情報アクセス用
Dim objCommon       '共通クラス
Dim objOrganization '団体情報アクセス用

'引数値
Dim strSSendDate,strSSendYear, strSSendMonth, strSSendDay   '開始年月日
Dim strESendDate,strESendYear, strESendMonth, strESendDay   '終了年月日

Dim strOutPutCls                            '出力対象
Dim strArrOutputCls()                       '出力対象区分
Dim strArrOutputClsName()                   '出力対象区分名

'作業用変数
Dim i, j            'カウンタ

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objFree         = Server.CreateObject("HainsFree.Free")

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
    If IsEmpty(Request("strSendYear")) Then
        strSSendYear   = Year(Now())             '開始年
        strSSendMonth  = Month(Now())            '開始月
        strSSendDay    = Day(Now())              '開始日
    Else
        strSSendYear   = Request("strSendYear")   '開始年
        strSSendMonth  = Request("strSendMonth")  '開始月
        strSSendDay    = Request("strSendDay")    '開始日
    End If
    strSSendDate   = strSSendYear & "/" & strSSendMonth & "/" & strSsendDay

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

    Dim vntArrMessage   'エラーメッセージの集合

    'ここにチェック処理を記述
    With objCommon
        If strMode <> "" Then

            '◆ 開始日付整合性チェック
            If Not IsDate(strSSendDate) Then
                .AppendArray vntArrMessage, "受診日が正しくありません。"
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
' 備考　　 : 帳票ドキュメントファイル作成メソッドを呼び出す。メソッド内では次の処理が行われる。
' 　　　　   ?@印刷ログ情報の作成
' 　　　　   ?A帳票ドキュメントファイルの作成
' 　　　　   ?B処理成功時は印刷ログ情報レコードの主キーであるプリントSEQを戻り値として返す。
' 　　　　   このSEQ値を元に以降のハンドリングを行う。
'
'-------------------------------------------------------------------------------
Function Print()

'#### 2010.04.26 SL-UI-Y0101-215 ADD START ####'
	Dim objPrintCls	'COMコンポーネント
	Dim Ret			'関数戻り値
'#### 2010.04.26 SL-UI-Y0101-215 ADD END ####'
    Dim objCommon
    If Not IsArray(CheckValue()) Then

		'情報漏えい対策用ログ書き出し
		Call putPrivacyInfoLog("PH031", "特定健診受診者リストの印刷を行った")

'#### 2010.04.26 SL-UI-Y0101-215 MOD START ####'
'        Set objCommon = Server.CreateObject("HainsCommon.Common")
'        strURL = "/webHains/contents/report_form/rd_38_prtSpecialList.asp"
'        strURL = strURL & "?p_Uid=" & UID
'        strURL = strURL & "&p_strSendDate=" & objCommon.FormatString(CDate(strSSendDate), "yyyy/mm/dd")
'        Set objCommon = Nothing
'
'        Response.Redirect strURL
'        Response.End

		'オブジェクトのインスタンス作成（プロジェクト名.クラス名）
		Set objPrintCls = Server.CreateObject("HainsprtSpecialList.prtSpecialList")
		'ドキュメントファイル作成処理（オブジェクト.メソッド名(引数)）
		Ret = objPrintCls.PrintOut(UID, _
								   strSSendDate)
		Print = Ret

'#### 2010.04.26 SL-UI-Y0101-215 MOD END ####'

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
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>特定健診受診者リスト</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
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
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">■</SPAN><FONT COLOR="#000000">特定健診受診者リスト</FONT></B></TD>
        </TR>
    </TABLE>
<%
'エラーメッセージ表示

    'メッセージの編集
    If( strMode <> "" )Then

        '保存完了時は「保存完了」の通知
        Call EditMessage(vntMessage, MESSAGETYPE_WARNING)

    End If
%>
    <BR>

<!--- 日付 -->
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD><FONT COLOR="#ff0000">■</FONT></TD>
            <TD WIDTH="90" NOWRAP>受診日</TD>
<!--- 日付 -->
            <TD>：</TD>
            <TD><A HREF="javascript:calGuide_showGuideCalendar('strSendYear', 'strSendMonth', 'strSendDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
            <TD><%= EditNumberList("strSendYear", YEARRANGE_MIN, YEARRANGE_MAX, strSSendYear, False) %></TD>
            <TD>年</TD>
            <TD><%= EditNumberList("strSendMonth", 1, 12, strSSendMonth, False) %></TD>
            <TD>月</TD>
            <TD><%= EditNumberList("strSendDay", 1, 31, strSSendDay, False) %></TD>
            <TD>日</TD>

        </TR>
    </TABLE>
    <p><BR><BR><BR>
<!--- 印刷モード -->
    <INPUT TYPE="hidden" NAME="mode" VALUE="0">
<!--- 印刷ボタン -->
	<!---2008.03.01 権限管理はとりあえず無視  -->
    <%' If Session("PAGEGRANT") = "4" Then   %>
	    <INPUT TYPE="image" NAME="print" SRC="/webHains/images/print.gif" WIDTH="77" HEIGHT="24" ALT="印刷する"><br>
	<%'  End if  %>

</FORM></p>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>

</BODY>
</HTML>