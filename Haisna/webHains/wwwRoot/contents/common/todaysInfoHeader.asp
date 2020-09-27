<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		今日の予定(ヘッダ) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'セッションチェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_SELF)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>今日の予定</TITLE>
</HEAD>
<BODY>

<!--
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="97%">
	<TR>
		<TD HEIGHT="14"></TD>
	</TR>
	<TR>
		<TD WIDTH="20"><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="20" BORDER="0"></TD>
		<TD NOWRAP BGCOLOR="#eeeeee" WIDTH="100%">&nbsp;&nbsp;<B><%= Year(Date) %></B>年<B><%= Month(Date) %></B>月<B><%= Day(Date) %></B>日（<%= WeekdayName(Weekday(Date), True) %>）</TD>
	</TR>
</TABLE>
-->
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="97%">
	<TR>
		<TD HEIGHT="8"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2" WIDTH="20"><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="1" BORDER="0"></TD>
		<TD NOWRAP VALIGN="bottom"><FONT SIZE="3"><B><%= Year(Date) %></B>年<B><%= Month(Date) %></B>月<B><%= Day(Date) %></B>日（<%= WeekdayName(Weekday(Date), True) %>）</FONT></TD>
		<TD NOWRAP VALIGN="bottom" ALIGN="right"><FONT FACE="Arial Narrow" SIZE="6" COLOR="silver">Today's Schedule</FONT></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#cccccc" COLSPAN="2"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="2" BORDER="0"></TD>
	</TR>
</TABLE>

<BR>

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
	<TR>
		<TD WIDTH="20"><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="20" BORDER="0"></TD>
		<TD><FONT COLOR="#cccccc">■</FONT></TD>
		<TD WIDTH="240">&nbsp;実施する健康診断コース</TD>
		<TD><FONT COLOR="#cccccc">■</FONT></TD>
		<TD NOWRAP>&nbsp;今日お見えになる団体様</TD>
	</TR>
</TABLE>
</BODY>
</HTML>