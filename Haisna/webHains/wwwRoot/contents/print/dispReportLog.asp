<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		印刷ログ表示 (Ver0.0.1)
'		AUTHER  : Hiroki Ishihara@FSIT
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim objReportLog	'印刷ログアクセス用

Dim strMode			'処理モード
Dim lngPrtYear		'印刷年
Dim lngPrtMonth		'印刷月
Dim lngPrtDay		'印刷日
Dim lngCount		'表示件数
Dim strStrDate		'印刷日
Dim intSortOld		'ソート順
Dim strPrtStatus	'ステータス

Dim vntPrintSeq 	'プリントＳＥＱ
Dim vntPrintDate 	'印刷開始日時
Dim vntReportCd 	'帳票コード
Dim vntReportName 	'帳票名
Dim vntUserId 		'ユーザＩＤ
Dim vntUserName 	'ユーザ名
Dim vntStatus 		'ステータス
Dim vntReportTempID '帳票一時ファイル名
Dim vntEndDate 		'印刷終了時間
Dim vntCount 		'出力枚数
Dim strStatusString	'印刷ステータス（文字列）
Dim strStatusColor	'印刷ステータス（色）
Dim strLineColor	'明細行カラー
Dim strInUserID		'ユーザＩＤ（テーブルメンテ権限がないユーザは自分が印刷したものだけ表示）

Dim strMessage		'エラーメッセージ
Dim i				'インデックス

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objReportLog       = Server.CreateObject("HainsReportLog.ReportLog")

'引数値の取得
strMode      = Request("mode")
lngPrtYear   = CLng("0" & Request("prtYear"))
lngPrtMonth  = CLng("0" & Request("prtMonth"))
lngPrtDay    = CLng("0" & Request("prtDay"))
intSortOld   = Request("SortOld")
strPrtStatus = Request("PrtStatus")

'パラメタのデフォルト値設定
lngPrtYear   = IIf(lngPrtYear  = 0, Year(Now()),  lngPrtYear )
lngPrtMonth  = IIf(lngPrtMonth = 0, Month(Now()), lngPrtMonth)
lngPrtDay    = IIf(lngPrtDay = 0,   Day(Now()),   lngPrtDay)
intSortOld   = IIf(intSortOld = Empty, 0, intSortOld)

Do
	'初期表示モードなら何もしない
	If strMode = "" Then
		Exit Do
	End If

	'印刷日の編集
	strStrDate = lngPrtYear & "/" & lngPrtMonth & "/" & lngPrtDay

	'印刷日の日付チェック
	If Not IsDate(strStrDate) Then
		strMessage = "印刷日の入力形式が正しくありません。"
		Exit Do
	End If

	Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>印刷ログの表示</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<STYLE TYPE="text/css">
td.prttab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="ReportLog" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="mode" VALUE="print">

	<!-- 表題 -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">■</SPAN><FONT COLOR="#000000">印刷ログの表示</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'エラーメッセージの編集
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)
%>
	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD>印刷日：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('prtYear', 'prtMonth', 'prtDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
						<TD><%= EditNumberList("prtYear", YEARRANGE_MIN, YEARRANGE_MAX, lngPrtYear, False) %></TD>
						<TD>年</TD>
						<TD><%= EditNumberList("prtMonth", 1, 12, lngPrtMonth, False) %></TD>
						<TD>月</TD>
						<TD><%= EditNumberList("prtDay", 1, 31, lngPrtDay, False) %></TD>
						<TD>日</TD>
					</TR>
				</TABLE>
			</TD>
			<TD>
				<SELECT NAME="prtStatus">
					<OPTION VALUE="" <%= IIf(strPrtStatus = "",  "SELECTED", "")%>>
					<OPTION VALUE=0  <%= IIf(strPrtStatus = "0", "SELECTED", "")%>>印刷中
					<OPTION VALUE=1  <%= IIf(strPrtStatus = "1", "SELECTED", "" )%>>正常終了
					<OPTION VALUE=2  <%= IIf(strPrtStatus = "2", "SELECTED", "" )%>>異常終了
				</SELECT>
			</TD>
			<TD>
				<SELECT NAME="SortOld">
					<OPTION VALUE=0 <%= IIf(intSortOld = "0", "SELECTED", "")%>>新しい順
					<OPTION VALUE=1 <%= IIf(intSortOld = "1", "SELECTED", "" )%>>古い順
				</SELECT>
			</TD>
			<TD><INPUT TYPE="image" NAME="display" SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="表示"></TD>
		</TR>
	</TABLE>
<%
	Do
		'初期表示モードなら何もしない
		If strMode = "" Then Exit Do

		'エラー時は何もしない
		If strMessage <> "" Then Exit Do

		'全ログ表示か、自ユーザのみか？
		strInUserID = ""
		If Session("AUTH_TBLMNT") = 0 Then
			strInUserID = Session("USERID")
		End If

		'印刷ログ情報取得
		lngCount = objReportLog.SelectReportLog(strStrDate, _
												, _
												Iif(intSortOld = "1", True, False),_
												strPrtStatus,_
												vntPrintSeq, _
												vntPrintDate, _
												vntReportCd, _
												vntReportName, _
												vntUserId, _
												vntUserName, _
												vntStatus, _
												vntReportTempID, _
												vntEndDate, _
												vntCount, _
												strInUserID)

%>
		<BR>「<FONT COLOR="#ff6600"><B><%= strStrDate %>以降の印刷ログ</B></FONT>」の検索結果は <FONT COLOR="#ff6600"><B><%= lngCount %></B></FONT>件ありました。<BR><BR>
<%
		'印刷ログ情報が存在しない場合
		If lngCount = 0 Then
			Exit Do
		End If
%>
	<TABLE>
		<TR BGCOLOR="CCCCCC">
			<TD NOWRAP>プリントＳＥＱ</TD>
			<TD NOWRAP>印刷開始日時</TD>
			<TD NOWRAP>帳票コード</TD>
			<TD NOWRAP>帳票名</TD>
			<TD NOWRAP>ステータス</TD>
			<TD NOWRAP>印刷終了時間</TD>
			<TD NOWRAP>出力枚数</TD>
			<TD NOWRAP>ユーザＩＤ</TD>
			<TD NOWRAP>ユーザ名</TD>
			<TD NOWRAP>帳票一時ファイル名</TD>
		</TR>

<%
		'印刷ログの編集
		For i = 0 To lngCount - 1
			Select Case vntStatus(i)
				Case 0
					strStatusString = "印刷中"
					strStatusColor = "#999999"
				Case 1
					strStatusString = "正常終了"
					strStatusColor = "BLACK"
				Case 2
					strStatusString = "異常終了"
					strStatusColor = "RED"
				Case Else
					strStatusString = vntStatus(i)
					strStatusColor = "RED"
			End Select

			If ((i + 1) Mod 2) > 0 Then
				strLineColor = "#FFFFFF"
			Else
				strLineColor = "#EEEEEE"
			End If
%>
		<TR BGCOLOR=<%= strLineColor%>>
			<TD NOWRAP ALIGN="RIGHT"><%= vntPrintSeq(i) %></TD>
			<TD NOWRAP><%= vntPrintDate(i) %></TD>
			<TD NOWRAP ALIGN="RIGHT"><%= vntReportCd(i) %></TD>
			<TD NOWRAP><%= vntReportName(i) %></TD>
			<TD NOWRAP><FONT COLOR="<%= strStatusColor %>"><%= strStatusString %></FONT<</TD>
			<TD NOWRAP><%= vntEndDate(i) %></TD>
			<TD NOWRAP ALIGN="RIGHT"><%= vntCount(i) %></TD>
			<TD NOWRAP><%= vntUserId(i) %></TD>
			<TD NOWRAP><%= vntUserName(i) %></TD>
			<TD NOWRAP><A HREF="/webHains/contents/print/prtPreview.asp?documentFileName=<%= vntReportTempID(i) %>"><%= vntReportTempID(i) %></A></TD>
		</TR>
<%
		Next
%>
	</TABLE>
<%

		Exit Do
	Loop
%>
</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
