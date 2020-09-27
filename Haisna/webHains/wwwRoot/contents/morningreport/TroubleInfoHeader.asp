<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   朝レポート照会（トラブル情報）  (Ver0.0.1)
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
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>トラブル情報</TITLE>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
</HEAD>
<BODY>
	<TABLE WIDTH="750" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
		<TR>
			<TD NOWRAP BGCOLOR="#eeeeee" HEIGHT="15"><B><FONT COLOR="#333333">トラブル情報</FONT></B></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="0">
		<TR>
			<TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5" ALT=""></TD>
		</TR>
		<TR HEIGHT="16">
			<TD NOWRAP ALIGN="center" BGCOLOR="#dcdcdc" WIDTH="80" HEIGHT="16">受診番号</TD>
			<TD NOWRAP ALIGN="center" BGCOLOR="#dcdcdc" WIDTH="150" HEIGHT="16">氏名</TD>
			<TD NOWRAP ALIGN="center" BGCOLOR="#dcdcdc" WIDTH="360" HEIGHT="16">トラブル内容</TD>
			<TD NOWRAP ALIGN="center" BGCOLOR="#dcdcdc" WIDTH="140" HEIGHT="16">登録日時</TD>
		</TR>
	</TABLE>
</BODY>
</HTML>
