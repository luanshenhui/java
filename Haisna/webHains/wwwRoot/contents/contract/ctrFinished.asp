<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		契約情報(参照・コピー処理の完了通知) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'前画面から送信されるパラメータ値
Dim strOrgCd1	'団体コード1
Dim strOrgCd2	'団体コード2

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'前画面から送信されるパラメータ値の取得
strOrgCd1 = Request("orgCd1")
strOrgCd2 = Request("orgCd2")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>参照・コピー処理の完了</TITLE>
<STYLE TYPE="text/css">
td.mnttab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BLOCKQUOTE>

<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="contract">■</SPAN><FONT COLOR="#000000">登録完了</FONT></B></TD>
	</TR>
</TABLE>

<BR>

契約情報の参照・複写処理が完了しました。

<BR>
<BR>

<A HREF="ctrCourseList.asp?orgCd1=<%= strOrgCd1 %>&orgCd2=<%= strOrgCd2 %>">契約情報へ</A>

</BLOCKQUOTE>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
