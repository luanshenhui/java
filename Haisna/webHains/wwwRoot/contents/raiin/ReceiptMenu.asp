<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		暫定メニュー (Ver0.0.1)
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
'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>当日メニュー</TITLE>
<STYLE TYPE="text/css">
<!--
td.toujitsutab  { background-color:#FFFFFF }
-->
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BLOCKQUOTE>

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2" WIDTH="650">
	<TR VALIGN="bottom">
		<TD><FONT SIZE="+2"><B>当日処理</B></FONT></TD>
	</TR>
	<TR BGCOLOR="#cccccc">
		<TD HEIGHT="2"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1"></TD>
	</TR>
</TABLE>

<BR>

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/raiin/ReceiptFrontDoor.asp"><IMG SRC="/webhains/images/raiin.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2" WIDTH="20"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/raiin/ReceiptFrontDoor.asp">来院処理</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">受診者が来院されたときの処理を行います。</TD>
	</TR>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/morningreport/MorningReportMain.asp"><IMG SRC="/webhains/images/asareport.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/morningreport/MorningReportMain.asp">朝レポート</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">朝レポートを表示します。</TD>
	</TR>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/mngAccuracy/mngAccuracyInfo.asp"><IMG SRC="/webhains/images/seidokanri.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/mngAccuracy/mngAccuracyInfo.asp">精度管理</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">精度管理を表示します。</TD>
	</TR>
<!--
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/judgement/judAutoSet.asp"><IMG SRC="" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/judgement/judAutoSet.asp">計算処理</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">指定された計算を起動します。</TD>
	</TR>
-->
</TABLE>

</BLOCKQUOTE>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
