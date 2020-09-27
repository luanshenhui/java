<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		ダウンロードメニュー (Ver0.0.1)
'		AUTHER  : Hiroki Ishihara@fsit.fujitsu.com
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
<TITLE>ダウンロード</TITLE>
<STYLE TYPE="text/css">
td.mnttab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BLOCKQUOTE>

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2" WIDTH="650">
	<TR VALIGN="bottom">
		<TD><FONT SIZE="+2"><B>ダウンロード</B></FONT></TD>
	</TR>
	<TR BGCOLOR="#cccccc">
		<TD HEIGHT="2"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1" BORDER="0"></TD>
	</TR>
</TABLE>

<BR>

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/cab/AppProxy/webHainsAppProxy.MSI"><IMG SRC="/webHains/images/keyboard.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2" WIDTH="20"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/cab/AppProxy/webHainsAppProxy.MSI">アプリケーションプロキシをインストールする</A></B><SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">webHainsシステム管理アプリケーションを動作させるには必須のアプリケーションです。<BR>インストールするにはAdministrator権限が必要です。</TD>
	</TR>
<!--
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/cab/Mnt/webHainsMnt.msi"><IMG SRC="/webHains/images/keyboard.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/cab/Mnt/webHainsMnt.msi">webHainsシステム管理アプリケーションをインストールする</A></B><SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">webHainsの環境設定を行うアプリケーションです。クリックするとインストールが始まります。</TD>
	</TR>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/cab/WindowsInstaller/instmsiw.arc"><IMG SRC="/webHains/images/keyboard.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/cab/WindowsInstaller/instmsiw.arc">Windows Installer For NT4.0をインストールする</A></B><SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">上記２点のインストールが出来ない場合、Windows Installerがセットアップされていない可能性があります。<BR>ファイルをローカルに保存した後、拡張子をexeに変更して実行してください。</TD>
	</TR>
-->
</TABLE>
</BLOCKQUOTE>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>