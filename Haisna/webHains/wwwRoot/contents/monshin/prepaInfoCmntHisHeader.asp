<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   健診前準備（問診） 前回総合コメントヘッダー  (Ver0.0.1)
'	   AUTHER  : K.Fujii@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
'Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'パラメータ

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Adobe GoLive 6">
<TITLE>健診前準備（問診） 前回総合コメントヘッダー</TITLE>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: 0 0 0 15px; }
</style>
</HEAD>
<BODY>
	<FORM NAME="entryForm" action="#">
		<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
			<TR>
				<TD NOWRAP BGCOLOR="#eeeeee" HEIGHT="15"><B><FONT COLOR="#333333">前回総合コメント</FONT></B></TD>
			</TR>
		</TABLE>
<!--
		<BR>
-->
		<TABLE WIDTH="431" BORDER="0" CELLSPACING="1" CELLPADDING="0">
			<TR HEIGHT="16">
					<TD ALIGN="center" NOWRAP BGCOLOR="#dcdcdc" WIDTH="81" HEIGHT="16">受診日</TD>
					<TD ALIGN="center" NOWRAP BGCOLOR="#dcdcdc" WIDTH="116" HEIGHT="16">受診コース</TD>
					<TD ALIGN="center" NOWRAP BGCOLOR="#dcdcdc" WIDTH="350" HEIGHT="16">コメント</TD>
			</TR>
		</TABLE>
	</FORM>
</BODY>