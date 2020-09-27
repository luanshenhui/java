<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   朝レポート照会（セット別受診者情報）  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Adobe GoLive 6">
<TITLE>セット別受診者情報</TITLE>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
</HEAD>
<BODY>
	<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
		<TR>
			<TD NOWRAP BGCOLOR="#eeeeee" HEIGHT="15"><B><FONT COLOR="#333333">セット別受診者情報</FONT></B></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="0">
		<TR>
			<TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5" ALT=""></TD>
		</TR>
		<TR HEIGHT="16">
			<TD NOWRAP ALIGN="center" BGCOLOR="#dcdcdc" WIDTH="130">セット名</TD>
			<TD NOWRAP ALIGN="center" BGCOLOR="#dcdcdc" WIDTH="40">男性</TD>
			<TD NOWRAP ALIGN="center" BGCOLOR="#dcdcdc" WIDTH="40">女性</TD>
		</TR>
	</TABLE>
</BODY>
</HTML>
