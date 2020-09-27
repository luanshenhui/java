<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       個人情報 削除完了 (Ver0.0.1)
'       AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
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
Dim strPerID		'個人ＩＤ
Dim strLastName		'姓
Dim strFirstName	'名

Dim objPerson	'個人情報アクセス用COMオブジェクト

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'引数値の取得
strPerID     = Request("perid")
strLastName  = Request("lastname")
strFirstName = Request("firstname")

'オブジェクトのインスタンス作成
Set objPerson = Server.CreateObject("HainsPerson.Person")

'個人テーブルレコード削除
objPerson.DeletePerson strPerID
%>
<!-- #include virtual = "/webHains/includes/common.inc" -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>削除完了</TITLE>
<STYLE TYPE="text/css">
td.mnttab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BLOCKQUOTE>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">■</SPAN><FONT COLOR="#000000">削除完了</FONT></B></TD>
	</TR>
</TABLE>

<BR>

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
	<TR>
		<TD>&nbsp;&nbsp;個人コード</TD>
		<TD>：</TD>
		<TD><B><%= strPerID %></B></TD>
	</TR>
	<TR>
		<TD>&nbsp;&nbsp;氏名</TD>
		<TD>：</TD>
		<TD><B><%= strLastName & "　" & strFirstName %></B></TD>
	</TR>
	<TR>
		<TD COLSPAN="3"><BR>&nbsp;&nbsp;の個人情報が削除されました。</TD>
	</TR>
</TABLE>

<BR>
<A HREF="mntSearchPerson.asp"><IMG SRC="/webhains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="個人検索画面に戻ります"></A>

</BLOCKQUOTE>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
