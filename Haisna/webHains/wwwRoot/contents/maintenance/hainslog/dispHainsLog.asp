<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		webHainsログ表示 (Ver0.0.1)
'		AUTHER  : Hiroki Ishihara@FSIT
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/editPageNavi.inc"   -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const FREECD_LOG = "LOG"	'汎用コード(ログ用処理区分)

Dim objHainsLog		'ログアクセス用
Dim objFree			'汎用情報アクセス用

Dim strMode			'処理モード
Dim strStrDate		'印刷日
Dim strPrtStatus	'ステータス

Dim strLineColor	'明細行カラー
Dim strInUserID		'ユーザＩＤ（テーブルメンテ権限がないユーザは自分が印刷したものだけ表示）

Dim lngCount					'表示件数

Dim vntIn_TransactionDiv 		'表示処理区分
Dim vntIn_InformationDiv 		'表示情報区分
Dim vntIn_TransactionID			'処理ID
Dim vntIn_Message				'検索文字列
Dim vntTransactionID 			'処理ID
Dim vntInsDate 					'処理日時
Dim vntTransactionDiv 			'処理区分
Dim vntTransactionName 			'処理名称
Dim vntInformationDiv 			'情報区分
Dim vntStatementNo 				'処理行
Dim vntLineNo 					'対象処理行
Dim vntMessage1 				'メッセージ１
Dim vntMessage2 				'メッセージ２

Dim strTransactionDiv 			'処理区分
Dim strTransactionName 			'処理区分名称

Dim strImageURL					'処理状態用画像URL
Dim strInformationName			'情報名
Dim strEditTransactionName		'編集用処理名
Dim strEditMessage1				'編集用メッセージ１
Dim strEditMessage2				'編集用メッセージ２

Dim vntMessage					'エラーメッセージ
Dim i							'インデックス

Dim lngStartPos					'表示開始位置
Dim strPageMaxLine				'１ページ表示行数
Dim lngGetCount					'１ページ表示件数
Dim lngAllCount					'条件を満たす全レコード件数

Dim strSearchString				'ページナビ用QueryString
Dim strOrderByOld				'表示順（1:古いものから）
Dim lngYear						'年
Dim lngMonth					'月
Dim lngDay						'日
Dim strDate						'日付

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------

'引数値の取得
strMode              = Request("mode")
vntIn_InformationDiv = Request("informationDiv")
vntIn_TransactionDiv = Request("transactionDiv")
vntIn_TransactionID  = Request("transactionID")
vntIn_Message        = Request("searchChar")
strPageMaxLine       = Request("PageMaxLine")
strOrderByOld        = Request("OrderByOld")
lngYear              = CLng("0" & Request("Year"))
lngMonth             = CLng("0" & Request("Month"))
lngDay               = CLng("0" & Request("Day"))
lngStartPos          = CLng("0" & Request("startPos"))
lngStartPos          = IIf(lngStartPos = 0, 1, lngStartPos)

'受診開始・終了日のデフォルト値設定(受診開始年が０になるケースは初期表示時以外にない)
If lngYear = 0 Then
	lngYear  = Year(Date)
	lngMonth = Month(Date)
	lngDay   = Day(Date)
End If

'表示行数未指定ならデフォルトセット
If strPageMaxLine = "" Then
	strPageMaxLine = "50"
End If

'引数値のチェック
vntMessage = CheckValue()

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

	Dim strMessage		'エラーメッセージの集合

	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'日付妥当性のチェック
	strDate = lngYear & "/" & lngMonth & "/" & lngDay
	If Not IsDate(strDate) Then
		objCommon.appendArray strMessage, "開始受診日の入力形式が正しくありません。"
	End If

	'戻り値の編集
	If IsArray(strMessage) Then
		CheckValue = strMessage
	End If

End Function

%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>システムログの表示</TITLE>

<SCRIPT TYPE="text/javascript">
<!--
// 検索実行
function searchSubmit(){

	var myForm = document.ReportLog;	// 自画面のフォームエレメント
	var url    = '';					// フォームの送信先ＵＲＬ

	myForm.startPos.value = 1;			//Position初期化
	document.ReportLog.submit();
	return false;

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.mnttab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->

<!-- #include virtual = "/webHains/includes/navibar.inc"  -->
<FORM NAME="ReportLog" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
<BLOCKQUOTE>
<INPUT TYPE="hidden" NAME="startPos" VALUE="<%= CStr(lngStartPos) %>">
<INPUT TYPE="hidden" NAME="mode" VALUE="print">
<!-- 表題 -->
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">■</SPAN><FONT COLOR="#000000">システムログの表示</FONT></B></TD>
	</TR>
</TABLE>
<%
	'エラーメッセージの編集
	Call EditMessage(vntMessage, MESSAGETYPE_WARNING)
%>
<BR>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
	<TR>
		<TD HEIGHT="5"></TD>
	</TR>
	<TR>
<%
	'汎用テーブルからログ処理情報を読み込む
	Set objFree = Server.CreateObject("HainsFree.Free")
	lngCount = objFree.SelectFree(1, FREECD_LOG, strTransactionDiv, strTransactionName)
	Set objFree = Nothing
	If lngCount > 0 Then
%>
		<TD>処理名</TD>
		<TD>：</TD>
		<TD><%= EditDropDownListFromArray("transactionDiv", strTransactionDiv, strTransactionName, vntIn_TransactionDiv, NON_SELECTED_ADD) %></TD>
<%
	End If
%>
		<TD NOWRAP>　実行日</TD>
		<TD>：</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
				<TR>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('Year', 'Month', 'Day')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
					<TD><%= EditNumberList("Year", YEARRANGE_MIN, YEARRANGE_MAX, lngYear, False) %></TD>
					<TD>年</TD>
					<TD><%= EditNumberList("Month", 1, 12, lngMonth, False) %></TD>
					<TD>月</TD>
					<TD><%= EditNumberList("Day", 1, 31, lngDay, False) %></TD>
					<TD>日</TD>
				</TR>
			</TABLE>
		</TD>

		<TD>処理ID</TD>
		<TD>：</TD>
		<TD><INPUT TYPE="text" SIZE="5" NAME="transactionID" VALUE="<%= vntIn_TransactionID %>" STYLE="ime-mode:disabled"></TD>


		<TD></TD>
	</TR>

</TABLE>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
	<TR>
		<TD>検索文字列</TD>
		<TD>：</TD>
		<TD COLSPAN="4">
			<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
				<TR>
					<TD><INPUT TYPE="text" SIZE="15" NAME="searchChar" VALUE="<%= vntIn_Message %>"></TD>
					<TD>　状態</TD>
					<TD>：</TD>
					<TD>
						<SELECT NAME="informationDiv">
							<OPTION VALUE="" <%= IIf(vntIn_InformationDiv = "",  "SELECTED", "")%>>
							<OPTION VALUE="I"  <%= IIf(vntIn_InformationDiv = "I", "SELECTED", "")%>>正常
							<OPTION VALUE="W"  <%= IIf(vntIn_InformationDiv = "W", "SELECTED", "" )%>>警告
							<OPTION VALUE="E"  <%= IIf(vntIn_InformationDiv = "E", "SELECTED", "" )%>>エラー
						</SELECT>
					</TD>

					<TD>　表示：</TD>
					<TD>
						<SELECT NAME="OrderByOld">
							<OPTION VALUE=""  <%= IIf(strOrderByOld = "",  "SELECTED", "")%>>新しいものから
							<OPTION VALUE="1" <%= IIf(strOrderByOld = "1", "SELECTED", "")%>>古いものから
						</SELECT>
					</TD>
					<TD WIDTH="5"></TD>
					<TD>
						<SELECT NAME="pageMaxLine">
							<OPTION VALUE="50"  <%= IIf(strPageMaxLine = 50,  "SELECTED", "")%>>50行ずつ
							<OPTION VALUE="100" <%= IIf(strPageMaxLine = 100, "SELECTED", "")%>>100行ずつ
							<OPTION VALUE="200" <%= IIf(strPageMaxLine = 200, "SELECTED", "" )%>>200行ずつ
							<OPTION VALUE="300" <%= IIf(strPageMaxLine = 300, "SELECTED", "" )%>>300行ずつ
							<OPTION VALUE="999999999" <%= IIf(strPageMaxLine = 999999999, "SELECTED", "" )%>>すべて
						</SELECT>
					</TD>
					<TD WIDTH="40"></TD>
					<TD WIDTH="40"></TD>
					<TD>
<!--						<A HREF="javascript:function voi(){};voi()">
							<IMG SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="表示">
						</A>
-->
							<INPUT TYPE="IMAGE" SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="表示" ONCLICK="JavaScript:return searchSubmit()">
					</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
</TABLE>
<%
	Do
		'初期表示モードなら何もしない
		If strMode = "" Then Exit Do

		'エラー時は何もしない
		If Not IsEmpty(vntMessage) Then Exit Do

		'オブジェクトのインスタンス作成
		Set objHainsLog = Server.CreateObject("HainsHainsLog.HainsLog")

		'印刷ログ情報取得
'		lngAllCount = objHainsLog.SelectHainsLog("CNT", _
'											  , _
'											  , _
'											  vntIn_TransactionDiv, _
'											  vntIn_InformationDiv, _
'											  vntIn_TransactionID, _
'											  vntIn_Message)

		lngAllCount = objHainsLog.SelectHainsLog("CNT", _
											  , _
											  , _
											  vntIn_TransactionDiv, _
											  vntIn_InformationDiv, _
											  vntIn_TransactionID, _
											  vntIn_Message, , , , , , , , , , strOrderByOld, strDate)

%>
		<BR>検索結果は <FONT COLOR="#ff6600"><B><%= lngAllCount %></B></FONT>件ありました。<BR><BR>
<%
		'印刷ログ情報が存在しない場合
		If lngAllCount = 0 Then
			Exit Do
		End If

%>
<TABLE>
	<TR BGCOLOR="CCCCCC">
		<TD NOWRAP>処理名</TD>
		<TD COLSPAN="2" NOWRAP>状態</TD>
		<TD NOWRAP>メッセージ１</TD>
		<TD NOWRAP>メッセージ２</TD>
		<TD NOWRAP>処理対象行</TD>
		<TD NOWRAP>処理開始日時</TD>
		<TD NOWRAP>StatementNo</TD>
	</TR>

<%

		'印刷ログ情報取得
		lngCount = objHainsLog.SelectHainsLog("SRC", _
											  lngStartPos, _
											  strPageMaxLine, _
											  vntIn_TransactionDiv, _
											  vntIn_InformationDiv, _
											  vntIn_TransactionID, _
											  vntIn_Message, _
											  vntTransactionID, _
											  vntInsDate, _
											  vntTransactionDiv, _
											  vntTransactionName, _
											  vntInformationDiv, _
											  vntStatementNo, _
											  vntLineNo, _
											  vntMessage1, _
											  vntMessage2, _
											  strOrderByOld, _
											  strDate)

		'印刷ログの編集
		For i = 0 To lngCount - 1

			'処理状態の編集
			Select Case trim(vntInformationDiv(i))
				Case "I"
					strImageURL = "ico_i.gif"
					strInformationName = "正常"
				Case "E"
					strImageURL = "ico_e.gif"
					strInformationName = "エラー"
				Case "W"
					strImageURL = "ico_w.gif"
					strInformationName = "警告"
				Case Else
					strInformationName = vntInformationDiv(i)
			End Select

			'処理名の再編集
			If Trim(vntTransactionName(i)) = "" Then
				strEditTransactionName =  vntTransactionName(i)
			Else
				strEditTransactionName =  vntTransactionName(i)
			End If
			strEditTransactionName = strEditTransactionName & " (ID:" & vntTransactionID(i) & ")"

			'
			'文字列検索の場合Bold化
			strEditMessage1 = Replace(vntMessage1(i), vntIn_Message, "<FONT COLOR=""#ff6600""><B>" & vntIn_Message & "</B></FONT>")
			strEditMessage2 = Replace(vntMessage2(i), vntIn_Message, "<FONT COLOR=""#ff6600""><B>" & vntIn_Message & "</B></FONT>")

			'明細行カラーの変更
			If ((i + 1) Mod 2) > 0 Then
				strLineColor = "#FFFFFF"
			Else
				strLineColor = "#EEEEEE"
			End If
%>
	<TR BGCOLOR=<%= strLineColor%>>
		<TD NOWRAP><%= strEditTransactionName %></TD>
		<TD NOWRAP><IMG SRC="/webHains/images/<%= strImageURL %>" WIDTH="16" HEIGHT="16"></TD>
		<TD NOWRAP><%= strInformationName %></TD>
		<TD NOWRAP><%= strEditMessage1 %></TD>
		<TD NOWRAP><%= strEditMessage2 %></TD>
		<TD NOWRAP><%= vntLineNo(i) %></TD>
		<TD NOWRAP><%= vntInsDate(i) %></TD>
		<TD NOWRAP><%= vntStatementNo(i) %></TD>
	</TR>
<%
		Next
%>
</TABLE>
<%
		Exit Do
	Loop
	Set objHainsLog = Nothing
%>

<%
	'ページングナビゲータの編集
	If IsNumeric(strPageMaxLine) Then
		lngGetCount = CLng(strPageMaxLine)
		strSearchString = ""
		strSearchString = strSearchString & "mode=print"
		strSearchString = strSearchString & "&transactionDiv=" & vntIn_TransactionDiv
		strSearchString = strSearchString & "&informationDiv=" & vntIn_InformationDiv
		strSearchString = strSearchString & "&transactionID="  & vntIn_TransactionID
		strSearchString = strSearchString & "&searchChar="     & vntIn_Message
		strSearchString = strSearchString & "&pageMaxLine="    & strPageMaxLine

		strSearchString = strSearchString & "&Year="           & lngYear
		strSearchString = strSearchString & "&Month="          & lngMonth
		strSearchString = strSearchString & "&Day="            & lngDay
		strSearchString = strSearchString & "&lngMonth="       & strOrderByOld

%>
		<%= EditPageNavi(Request.ServerVariables("SCRIPT_NAME") & "?" & strSearchString, lngAllCount, lngStartPos, lngGetCount) %>
<%
	End If
%>
</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
