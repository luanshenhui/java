<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		データ抽出メニュー (Ver0.0.1)
'		AUTHER  : Toyonobu Manabe@takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

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
<TITLE>データ抽出</TITLE>
<STYLE TYPE="text/css">
<!--
td.datatab  { background-color:#ffffff }
-->
</STYLE>
</HEAD>

<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2" WIDTH="635">
		<TR VALIGN="bottom">
			<TD><FONT SIZE="+2"><B>データ抽出</B></FONT></TD>
		</TR>
		<TR HEIGHT="2">
			<TD BGCOLOR="#CCCCCC"><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="2" BORDER="0"></TD>
		</TR>
	</TABLE>

	<BR>

	
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">


	<TR>
		<TD ROWSPAN="2"><A HREF="datSelectItem.asp?step=1"><IMG SRC="/webHains/images/dock.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2" WIDTH="20"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="datSelectItem.asp?step=1">結果、判定抽出</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">指定した日付、検査結果値などからデータをCSV形式で抽出します。</TD>
	</TR>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	
	
	<TR>
		<TD ROWSPAN="2"><A HREF="datPersonal.asp"><IMG SRC="/webHains/images/person.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2" WIDTH="20"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="datPersonal.asp">個人情報</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">登録されている個人情報をCSV形式で出力します。</TD>
	</TR>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>

	<TR>
		<TD ROWSPAN="2"><A HREF="datOrganization.asp"><IMG SRC="/webHains/images/office.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="datOrganization.asp">団体情報</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">登録されている団体情報をCSV形式で出力します。</TD>
	</TR>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	
	<TR>
		<TD ROWSPAN="2"><A HREF="datDemandAllMenu.asp"><IMG SRC="/webHains/images/money.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="datDemandAllMenu.asp">請求情報</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">指定された条件を満たす請求情報をCSV形式で出力します。</TD>
	</TR>
<!--
	<TR>
		<TD ROWSPAN="2"><A HREF="datDemandAllMenu.asp"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="datDemandAllMenu.asp">_</A></B></SPAN></TD>
	</TR>
-->		
</TABLE>



</BLOCKQUOTE>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
