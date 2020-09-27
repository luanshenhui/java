<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		団体情報メンテナンス(団体の検索) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@FSIT
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editOrgList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const GETCOUNT = 20	'表示件数のデフォルト値

Dim strKey		'検索キー
Dim lngStartPos	'検索開始位置
Dim lngGetCount	'表示件数

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
strKey      = Request("key")
lngStartPos = CLng("0" & Request("startPos"))
lngGetCount = CLng("0" & Request("getCount"))

'検索開始位置未指定時は先頭から検索する
If lngStartPos = 0 Then
	lngStartPos = 1
End If

'表示件数未指定時はデフォルト値を適用する
If lngGetCount = 0 Then
	lngGetCount = GETCOUNT
End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>団体の検索</TITLE>
<STYLE TYPE="text/css">
td.mnttab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY ONLOAD="JavaScript:document.entryForm.key.focus()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="act" VALUE="1">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">■</SPAN><FONT COLOR="#000000">団体の検索</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
		<TR>
			<TD COLSPAN="3">団体コードもしくは団体名称を入力して下さい。</TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD><INPUT TYPE="text" NAME="key" SIZE="30" VALUE="<%= strKey %>"></TD>
						<TD WIDTH="5"><IMG SRC="/webHains/images/spacer.gif" WIDTH="5" HEIGHT="1" BORDER="0"></TD>
						<TD><INPUT TYPE="image" NAME="search" SRC="/webHains/images/findrsv.gif" WIDTH="70" HEIGHT="24" ALT="この条件で検索"></TD>
					</TR>
				</TABLE>
			</TD>
			<TD ALIGN="right" VALIGN="top"><A HREF="mntOrganization.asp?mode=insert"><IMG SRC="/webHains/images/newrsv.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="新しく団体を登録します"></A></TD>
		</TR>
	</TABLE>
<%
	'団体一覧の編集
	If Request("act") <> "" Then
		Call EditOrgList(strKey, lngStartPos, lngGetCount, "mntOrganization.asp?mode=update&", False, False)
	End If
%>
	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
