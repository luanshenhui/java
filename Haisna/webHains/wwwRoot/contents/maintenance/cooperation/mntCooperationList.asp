<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		他システム連携ログ一覧 (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/EditCourseList.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const LOGFILEPATH = "/webHains/log/cooperation"	'ログファイルのパス

'データベースアクセス用オブジェクト
Dim objCommon	'共通クラス

Dim lngOpYear	'処理年
Dim lngOpMonth	'処理月
Dim lngOpDay	'処理日

Dim strFileName	'ログファイル名
Dim lngCount	'ログファイル数

Dim strOpDate	'処理年月日
Dim strMessage	'エラーメッセージ
Dim i			'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon = Server.CreateObject("HainsCommon.Common")

'引数値の取得
lngOpYear  = CLng("0" & Request("opYear") )
lngOpMonth = CLng("0" & Request("opMonth"))
lngOpDay   = CLng("0" & Request("opDay")  )

'処理日のデフォルト値としてシステム日付を設定
lngOpYear  = IIf(lngOpYear  = 0, Year(Now()),  lngOpYear )
lngOpMonth = IIf(lngOpMonth = 0, Month(Now()), lngOpMonth)
lngOpDay   = IIf(lngOpDay   = 0, Day(Now()),   lngOpDay  )

'チェック・更新・読み込み処理の制御
Do
	'表示ボタン押下時以外は何もしない
	If IsEmpty(Request("display.x")) Then
		Exit Do
	End If

	'処理日の編集
	strOpDate = lngOpYear & "/" & lngOpMonth & "/" & lngOpDay

	'処理日の日付チェック
	If Not IsDate(strOpDate) Then
		strMessage = "処理日の入力形式が正しくありません。"
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
<TITLE>他システム連携ログ一覧</TITLE>
<STYLE TYPE="text/css">
td.mnttab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">■</SPAN><FONT COLOR="#000000">他システム連携ログ一覧</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'エラーメッセージの編集
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)
%>
	<BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD>処理日が</TD>
			<TD><%= EditNumberList("opYear", YEARRANGE_MIN, YEARRANGE_MAX, lngOpYear, False) %></TD>
			<TD>年</TD>
			<TD><%= EditNumberList("opMonth", 1, 12, lngOpMonth, False) %></TD>
			<TD>月</TD>
			<TD><%= EditNumberList("opDay", 1, 31, lngOpDay, False) %></TD>
			<TD>日以降の他システム連携ログを</TD>
			<TD><INPUT TYPE="image" NAME="display" SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="表示"></TD>
		</TR>
	</TABLE>
<%
	Do
		'表示ボタン押下時以外は何もしない
		If IsEmpty(Request("display.x")) Then
			Exit Do
		End If

		'エラー時は何もしない
		If strMessage <> "" Then
			Exit Do
		End If

		'ログファイル名の取得
		lngCount = objCommon.GetFileList(Server.MapPath(LOGFILEPATH), strOpDate, strFileName)
%>
		<BR>「<FONT COLOR="#ff6600"><B><%= strOpDate %>以降の他システム連携ログ</B></FONT>」の検索結果は <FONT COLOR="#ff6600"><B><%= lngCount %></B></FONT>件ありました。<BR><BR>
<%
		'ファイル名が存在しない場合は処理を終了する
		If lngCount <= 0 Then
			Exit Do
		End If

		'ログファイル名の取得
%>
		<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
<%
			For i = 0 To lngCount - 1
%>
				<TR>
					<TD><A HREF="<%= LOGFILEPATH %>/<%= strFileName(i) %>"><%= strFileName(i) %></A></TD>
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
