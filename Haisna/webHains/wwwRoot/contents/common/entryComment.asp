<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		コメントの登録 (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@FSIT
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'セッションチェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_SELF)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim strMode 		'モード
Dim strArrMessage	'エラーメッセージ

Dim objBbs 			'ユーザー名取得用ＣＯＭオブジェクト
Dim objHainsUser 	'ユーザー名取得用ＣＯＭオブジェクト

Dim strUserId		'ユーザーID
Dim strUserName		'ユーザー名

Dim strStrYear		'表示開始日付(年)
Dim strStrMonth		'表示開始日付(月)
Dim strStrDay		'表示開始日付(日)
Dim strEndYear		'表示終了日付(年)
Dim strEndMonth		'表示終了日付(月)
Dim strEndDay		'表示日付(日)
Dim strTitle		'タイトル
Dim strHandle		'投稿者
Dim strMessage		'コメント

Dim strStrDate		'表示開始日付
Dim strEndDate		'表示終了日付

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------

'引数値の取得
strUserId   = Session.Contents("userid")
strMode     = Request("mode")
strStrYear	= Clng("0" & Request("stryear"))	'表示開始日付(年)
strStrMonth	= Clng("0" & Request("strmonth"))	'表示開始日付(月)
strStrDay	= Clng("0" & Request("strday"))		'表示開始日付(日)
strEndYear	= Clng("0" & Request("endyear"))	'表示終了日付(年)
strEndMonth	= Clng("0" & Request("endmonth"))	'表示終了日付(月)
strEndDay	= Clng("0" & Request("endday"))		'表示日付(日)
strTitle	= Request("title")		'タイトル
strHandle	= Request("handle")		'投稿者
strMessage	= Request("message")	'コメント

Do

	'オブジェクトインスタンス作成
	Set objBbs = Server.CreateObject("HainsBbs.Bbs")
	Set objHainsUser = Server.CreateObject("HainsHainsUser.HainsUser")

	If strMode = "insert" Then
		
		strArrMessage = objBbs.CheckValue(strStrYear, _
												strStrMonth, _
												strStrDay, _
												strEndYear, _
												strEndMonth, _
												strEndDay, _
												strHandle, _
												strTitle, _
												strMessage, _
												strStrDate, _
												strEndDate)

		If Not IsEmpty(strArrMessage) Then

			Exit Do
		End If

		 objBbs.InsertBbs strStrDate, _
								strEndDate, _
								strHandle, _
								strTitle, _
								strMessage, _
								strUserId


		Response.Redirect "/webHains/contents/common/todaysInfo.asp"

		Response.End

		Exit Do
	Else
		'ユーザ名取得
		objHainsUser.SelectHainsUser strUserId, strUserName

		'初期値セット
		strStrYear	= Year(Now)		'表示開始日付(年)
		strStrMonth	= Month(Now)	'表示開始日付(月)
		strStrDay	= Day(Now)		'表示開始日付(日)
		strEndYear	= Year(Now)		'表示終了日付(年)
		strEndMonth	= Month(Now)	'表示終了日付(月)
		strEndDay	= Day(Now)		'表示日付(日)
		strTitle	= ""			'タイトル
		strHandle	= strUserName	'投稿者
		strMessage	= ""			'コメント
		
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
<TITLE>コメントの登録</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
</HEAD>
<BODY BGCOLOR="#FFFFFF">

<FORM NAME="inqwiz" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>?mode=insert" METHOD="post">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">■</SPAN><FONT COLOR="#000000">コメントの登録</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'エラーメッセージの編集
	If Not IsEmpty(strArrMessage) Then
		Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
	End If
%>
	<BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD WIDTH="85" NOWRAP>表示開始日付</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('stryear', 'strmonth', 'strday')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
			<TD><%= EditNumberList("stryear", YEARRANGE_MIN, YEARRANGE_MAX, CLng(strStrYear), False) %></TD>
			<TD>年</TD>
			<TD><%= EditNumberList("strmonth", 1, 12, CLng(strStrMonth), False) %></TD>
			<TD>月</TD>
			<TD><%= EditNumberList("strday", 1, 31, CLng(strStrDay), False) %></TD>
			<TD>日</TD>
		</TR>
		<TR>
			<TD>表示終了日付</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('endyear', 'endmonth', 'endday')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
			<TD><%= EditNumberList("endyear", YEARRANGE_MIN, YEARRANGE_MAX, CLng(strEndYear), False) %></TD>
			<TD>年</TD>
			<TD><%= EditNumberList("endmonth", 1, 12, CLng(strEndMonth), False) %></TD>
			<TD>月</TD>
			<TD><%= EditNumberList("endday", 1, 31, CLng(strEndDay), False) %></TD>
			<TD>日</TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD WIDTH="85" NOWRAP>表題</TD>
			<TD>：</TD>
			<TD><INPUT TYPE="text" NAME="title" SIZE="50" MAXLENGTH="40" VALUE="<%= strTitle %>"><TD>
		</TR>
		<TR>
			<TD>記入者</TD>
			<TD>：</TD>
			<TD><INPUT TYPE="text" NAME="handle" SIZE="50" MAXLENGTH="30" VALUE="<%= strHandle %>"><TD>
		</TR>
		<TR>
			<TD VALIGN="top">コメント</TD>
			<TD VALIGN="top">：</TD>
			<TD><TEXTAREA ROWS="8" COLS="100" WRAP="hard" NAME="Message" ><%= strMessage %></TEXTAREA></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2" WIDTH="150">
		<TR>
			<TD ALIGN="left">
				<INPUT TYPE="submit" VALUE="登　録">
				<INPUT TYPE="reset" VALUE="リセット">
			</TD>
		</TR>
	</TABLE>

</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
