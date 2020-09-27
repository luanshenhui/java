
<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'		請求書チェックリスト (Ver0.0.1)
'		AUTHER  : (NSC)birukawa
'-------------------------------------------------------------------------------
'       管理番号：SL-UI-Y0101-234
'       修正日  ：2010.04.26
'       担当者  ：ASC)三浦
'       修正内容：Report DesignerをCo Reportsに変更
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/print.inc"                -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim strMode				'印刷モード
Dim vntMessage			'通知メッセージ
Dim strURL				'URL

'-------------------------------------------------------------------------------
' 固有宣言部（各帳票に応じてこのセクションに変数を定義して下さい）
'-------------------------------------------------------------------------------
'COMオブジェクト
Dim objCommon								'共通クラス

'パラメータ値
Dim strSCslYear, strSCslMonth, strSCslDay	'受診開始年月日
Dim strDayId								'当日ID
Dim UID										'ユーザID

'作業用変数
Dim strSCslDate								'開始日

Dim i					'ループインデックス
Dim j					'ループインデックス

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

'◆ 開始年月日
	If IsEmpty(Request("strCslYear")) Then
		strSCslYear   = Year(Now())				'開始年
		strSCslMonth  = Month(Now())			'開始月
'		strSCslDay    = Day(Now())				'開始日
	Else
		strSCslYear   = Request("strCslYear")	'開始年
		strSCslMonth  = Request("strCslMonth")	'開始月
'		strSCslDay    = Request("strCslDay")	'開始日
	End If
'	strSCslDate   = strSCslYear & "/" & strSCslMonth & "/" & strSCslDay
	strSCslDate   = strSCslYear & "/" & strSCslMonth 


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
	Dim blnErrFlg
	Dim aryChkString
	
	aryChkString = Array("1","2","3","4","5","6","7","8","9","0")

	'ここにチェック処理を記述
	With objCommon
'例)		.AppendArray vntArrMessage, コメント
		If strMode <> "" Then
			'受診日チェック
'			If Not IsDate(strSCslDate) Then
'				.AppendArray vntArrMessage, "開始日付が正しくありません。"
'			End If

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

	Dim Ret			'関数戻り値
	Dim objCommon
	Dim objPrintCls	

	If Not IsArray(CheckValue()) Then

'#### 2010.04.26 SL-UI-Y0101-234 MOD START ####'
'		Set objCommon = Server.CreateObject("HainsCommon.Common")
'		strURL = "/webHains/contents/report_form/rd_28_prtBillCheck.asp"
'		strURL = strURL & "?p_Uid=" & UID
''		strURL = strURL & "&p_ScslDate=" & objCommon.FormatString(CDate(strSCslDate), "yyyy/mm/dd")
'		strURL = strURL & "&p_ScslDate=" & objCommon.FormatString(CDate(strSCslDate & "/01"), "yyyy/mm")
'		Set objCommon = Nothing
'		Response.Redirect strURL
'		Response.End

		'オブジェクトのインスタンス作成（プロジェクト名.クラス名）
		Set objPrintCls = Server.CreateObject("HainsprtBillCheck.prtBillCheck")
		'ドキュメントファイル作成処理（オブジェクト.メソッド名(引数)）
		Ret = objPrintCls.PrintOut(UID, _
								   strSCslYear, _
							       strSCslMonth)
		Print = Ret

'#### 2010.04.26 SL-UI-Y0101-234 MOD END ####'

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
<TITLE>請求書チェックリスト</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--

//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.prttab { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">■請求書チェックリスト</SPAN></B></TD>
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
			<TD WIDTH="90" NOWRAP>受診月</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
			<TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strSCslYear, False) %></TD>
			<TD>年</TD>
			<TD><%= EditNumberList("strCslMonth", 1, 12, strSCslMonth, False) %></TD>
			<TD>月</TD>
<!--
			<TD><%= EditNumberList("strCslDay", 1, 31, strSCslDay, False) %></TD>
			<TD>日</TD>
-->
		</TR>
	</TABLE>


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
	<!---2006.07.04 権限管理 追加 by 李  -->
    <% If Session("PAGEGRANT") = "4" Then   %>
		<INPUT TYPE="image" NAME="print" SRC="/webHains/images/print.gif" WIDTH="77" HEIGHT="24" ALT="印刷する">
	<%  End if  %>

	</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
</BODY>
</HTML>