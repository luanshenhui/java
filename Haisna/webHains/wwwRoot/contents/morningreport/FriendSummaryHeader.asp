<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   朝レポート照会（同伴者（お連れ様）受診者情報）  (Ver0.0.1)
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
<TITLE>同伴者（お連れ様）受診者情報</TITLE>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
</HEAD>
<BODY>
	<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
		<TR>
			<TD NOWRAP BGCOLOR="#eeeeee" HEIGHT="15"><B><FONT COLOR="#333333">同伴者（お連れ様）受診者情報</FONT></B></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="0">
		<TR>
			<TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5" ALT=""></TD>
		</TR>
		<TR HEIGHT="15">
			<TD NOWRAP ALIGN="center" BGCOLOR="#dcdcdc" WIDTH="70">受診番号</TD>
			<TD NOWRAP ALIGN="center" BGCOLOR="#dcdcdc" WIDTH="135">受診者氏名</TD>
			<TD NOWRAP ALIGN="center" BGCOLOR="#dcdcdc" WIDTH="40">同伴</TD>
			<TD NOWRAP ALIGN="center" BGCOLOR="#dcdcdc" WIDTH="100">同伴受診番号</TD>
			<TD NOWRAP ALIGN="center" BGCOLOR="#dcdcdc" WIDTH="135">同伴者氏名</TD>
		</TR>
	</TABLE>
</BODY>
</HTML>
