<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�����̗\��(�w�b�_) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'�Z�b�V�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_SELF)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�����̗\��</TITLE>
</HEAD>
<BODY>

<!--
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="97%">
	<TR>
		<TD HEIGHT="14"></TD>
	</TR>
	<TR>
		<TD WIDTH="20"><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="20" BORDER="0"></TD>
		<TD NOWRAP BGCOLOR="#eeeeee" WIDTH="100%">&nbsp;&nbsp;<B><%= Year(Date) %></B>�N<B><%= Month(Date) %></B>��<B><%= Day(Date) %></B>���i<%= WeekdayName(Weekday(Date), True) %>�j</TD>
	</TR>
</TABLE>
-->
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="97%">
	<TR>
		<TD HEIGHT="8"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2" WIDTH="20"><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="1" BORDER="0"></TD>
		<TD NOWRAP VALIGN="bottom"><FONT SIZE="3"><B><%= Year(Date) %></B>�N<B><%= Month(Date) %></B>��<B><%= Day(Date) %></B>���i<%= WeekdayName(Weekday(Date), True) %>�j</FONT></TD>
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
		<TD><FONT COLOR="#cccccc">��</FONT></TD>
		<TD WIDTH="240">&nbsp;���{���錒�N�f�f�R�[�X</TD>
		<TD><FONT COLOR="#cccccc">��</FONT></TD>
		<TD NOWRAP>&nbsp;�����������ɂȂ�c�̗l</TD>
	</TR>
</TABLE>
</BODY>
</HTML>