<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'		未請求受診情報一覧 (Ver0.0.1)
'		AUTHER  : Hiroki Ishihara@fsit.fujitsu.com
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
Dim strMode			'印刷モード
Dim vntMessage		'通知メッセージ

'-------------------------------------------------------------------------------
' 固有宣言部
'-------------------------------------------------------------------------------
'引数値
Dim lngGetMode			'抽出モード(0:受診日指定、1:締め日指定)
Dim lngStrCslYear		'開始受診年
Dim lngStrCslMonth		'開始受診月
Dim lngStrCslDay		'開始受診日
Dim lngEndCslYear		'終了受診年
Dim lngEndCslMonth		'終了受診月
Dim lngEndCslDay		'終了受診日
Dim strNoDemandData		'"1":未請求データのみ抽出
Dim strBillNo			'請求書番号

'作業用変数
Dim strStrCslDate		'開始受診年月日
Dim strEndCslDate		'終了受診年月日

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

	'抽出モード
	lngGetMode = CLng("0" & Request("getMode"))

	'開始受診年月日
	lngStrCslYear  = CLng("0" & Request("strCslYear"))
	lngStrCslMonth = CLng("0" & Request("strCslMonth"))
	lngStrCslDay   = CLng("0" & Request("strCslDay"))
	lngStrCslYear  = IIf(lngStrCslYear  <> 0, lngStrCslYear,  Year(Date))
	lngStrCslMonth = IIf(lngStrCslMonth <> 0, lngStrCslMonth, Month(Date))
	lngStrCslDay   = IIf(lngStrCslDay   <> 0, lngStrCslDay,   Day(Date))
	strStrCslDate  = lngStrCslYear & "/" & lngStrCslMonth & "/" & lngStrCslDay

	'終了受診年月日
	lngEndCslYear  = CLng("0" & Request("endCslYear"))
	lngEndCslMonth = CLng("0" & Request("endCslMonth"))
	lngEndCslDay   = CLng("0" & Request("endCslDay"))
	lngEndCslYear  = IIf(lngEndCslYear  <> 0, lngEndCslYear,  Year(Date))
	lngEndCslMonth = IIf(lngEndCslMonth <> 0, lngEndCslMonth, Month(Date))
	lngEndCslDay   = IIf(lngEndCslDay   <> 0, lngEndCslDay,   Day(Date))
	strEndCslDate  = lngEndCslYear & "/" & lngEndCslMonth & "/" & lngEndCslDay

	'対象データ
	strNoDemandData = IIf(strMode <> "", Request("noDemandData"), "1")

	'請求書番号
	strBillNo = Request("billNo")

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

	Dim objCommon		'共通クラス
	Dim vntArrMessage	'エラーメッセージの集合

	Set objCommon = Server.CreateObject("HainsCommon.Common")

	With objCommon

		'受診日指定の場合
		If lngGetMode = 0 Then

			If Not IsDate(strStrCslDate) Then
				.AppendArray vntArrMessage, "開始受診日の入力形式が正しくありません。"
			End If

			If Not IsDate(strEndCslDate) Then
				.AppendArray vntArrMessage, "終了受診日の入力形式が正しくありません。"
			End If

		'締め日指定の場合
		Else

'## 2004/06/28 MOD STR ORB)T.YAGUCHI 聖路加版対応
'			.AppendArray vntArrMessage, .CheckNumeric("請求書番号", strBillNo, 9)
			.AppendArray vntArrMessage, .CheckNumeric("請求書番号", strBillNo, 14)
'## 2004/06/28 MOD END

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

	Dim objBillConsultList	'個人受診金額一覧出力用COMコンポーネント

	Dim dtmStrCslDate	'開始受診日または締め日
	Dim dtmEndCslDate	'終了受診日または締め日
	Dim Ret				'関数戻り値

	'オブジェクトのインスタンス作成
	Set objBillConsultList = Server.CreateObject("HainsBillConsultList.BillConsultList")

	dtmStrCslDate = CDate(strStrCslDate)
	dtmEndCslDate = CDate(strEndCslDate)

	'情報漏えい対策用ログ書き出し
	Call putPrivacyInfoLog("PH103", "データ抽出 未請求受診一覧抽出よりファイル出力を行った")

	'個人受診金額一覧ドキュメントファイル作成処理
	Ret = objBillConsultList.PrintBillConsultList(Session("USERID"), lngGetMode, dtmStrCslDate, dtmEndCslDate, strBillNo, (strNoDemandData = "1"))

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
<TITLE>未請求受診情報一覧</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<SCRIPT TYPE="text/javascript">
<!--

// submit時の処理
function submitForm() {

	document.entryForm.submit();

}

// ガイド画面を閉じる
function closeWindow() {

	calGuide_closeGuideCalendar();

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
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">■</SPAN><FONT COLOR="#000000">未請求受診情報一覧</FONT></B></TD>
	</TR>
</TABLE>
<%
	'エラーメッセージ表示
	Call EditMessage(vntMessage, MESSAGETYPE_WARNING)
%>
<BR>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
	<TR>
		<TD><INPUT TYPE="radio" NAME="getMode" VALUE="0" <%= IIf(lngGetMode = 0, "CHECKED", "") %>></TD>
		<TD NOWRAP>受診期間で抽出</TD>
	</TR>
	<TR>
		<TD></TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
				<TR>
					<TD><FONT COLOR="#ff0000">■</FONT></TD>
					<TD WIDTH="90" NOWRAP>受診日</TD>
					<TD>：</TD>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
					<TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, lngStrCslYear, False) %></TD>
					<TD>年</TD>
					<TD><%= EditNumberList("strCslMonth", 1, 12, lngStrCslMonth, False) %></TD>
					<TD>月</TD>
					<TD><%= EditNumberList("strCslDay", 1, 31, lngStrCslDay, False) %></TD>
					<TD>日</TD>
					<TD>～</TD>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('endCslYear', 'endCslMonth', 'endCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
					<TD><%= EditNumberList("endCslYear", YEARRANGE_MIN, YEARRANGE_MAX, lngEndCslYear, False) %></TD>
					<TD>年</TD>
					<TD><%= EditNumberList("endCslMonth", 1, 12, lngEndCslMonth, False) %></TD>
					<TD>月</TD>
					<TD><%= EditNumberList("endCslDay", 1, 31, lngEndCslDay, False) %></TD>
					<TD>日</TD>
				</TR>
			</TABLE>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
				<TR>
					<TD><FONT COLOR="#ff0000">■</FONT></TD>
					<TD WIDTH="90" NOWRAP>対象データ</TD>
					<TD>：</TD>
					<TD><INPUT TYPE="checkbox" NAME="noDemandData" VALUE="1" <%= IIf(strNoDemandData <> "", "CHECKED", "") %>></TD>
					<TD>未請求データのみ出力</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD><INPUT TYPE="radio" NAME="getMode" VALUE="1" <%= IIf(lngGetMode = 1, "CHECKED", "") %>></TD>
		<TD NOWRAP>請求書Noで抽出</TD>
	</TR>
	<TR>
		<TD></TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
				<TR>
					<TD><FONT COLOR="#ff0000">■</FONT></TD>
					<TD WIDTH="90" NOWRAP>請求書番号</TD>
					<TD>：</TD>
<% '## 2004/06/28 MOD STR ORB)T.YAGUCHI 聖路加版対応 %>
<!--					<TD><INPUT TYPE="text" NAME="billNo" SIZE="12" MAXLENGTH="9" VALUE="<%= strBillNo %>"></TD>-->
					<TD><INPUT TYPE="text" NAME="billNo" SIZE="20" MAXLENGTH="14" VALUE="<%= strBillNo %>"></TD>
<% '## 2004/06/28 MOD END %>
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