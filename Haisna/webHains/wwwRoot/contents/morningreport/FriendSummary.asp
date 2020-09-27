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

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Adobe GoLive 6">
<TITLE>同伴者（お連れ様）受診者情報</TITLE>
</HEAD>
<FRAMESET border="0" FRAMEBORDER="no" framespacing="0" ROWS="52,*">
	<FRAME NAME="header" NORESIZE SRC="FriendSummaryHeader.asp?<%= Request.ServerVariables("QUERY_STRING") %>">
	<FRAME NAME="list"   NORESIZE SRC="FriendSummaryBody.asp?<%= Request.ServerVariables("QUERY_STRING") %>">
	<NOFRAMES></NOFRAMES>
</FRAMESET>
</HTML>
