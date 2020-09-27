<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		団体情報メンテナンス(削除完了通知画面) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@FSIT
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
Dim strOrgCd1		'団体コード1
Dim strOrgCd2		'団体コード2
Dim strOrgName		'団体名

Dim objOrganization	'団体情報アクセス用COMオブジェクト

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'引数値の取得
strOrgCd1  = Request("orgcd1")
strOrgCd2  = Request("orgcd2")
strOrgName = Request("orgname")

'オブジェクトのインスタンス作成
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

'団体テーブルレコード削除
If objOrganization.DeleteOrg(strOrgCd1, strOrgCd2) <= 0 Then
	Err.Raise 1000, , "この団体は他で使用されています。削除できません。"
End If
%>
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
		<TD>&nbsp;&nbsp;団体コード</TD>
		<TD>：</TD>
		<TD><B><%= strOrgcd1 %>-<%= strOrgCd2 %></B></TD>
	</TR>
	<TR>
		<TD>&nbsp;&nbsp;団体名称</TD>
		<TD>：</TD>
		<TD><B><%= strOrgName %></B></TD>
	</TR>
	<TR>
		<TD COLSPAN="3"><BR>&nbsp;&nbsp;の団体情報が削除されました。</TD>
	</TR>
</TABLE>

<BR>
<A HREF="mntSearchOrg.asp"><IMG SRC="/webhains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="団体検索画面に戻ります"></A>
</BLOCKQUOTE>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
