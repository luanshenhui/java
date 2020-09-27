<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       個人検索 (Ver0.0.1)
'       AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditPersonList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const GETCOUNT = 20	'表示件数のデフォルト値

Dim objCommon		'共通クラス

Dim strKey			'検索キー
Dim lngStartPos		'検索開始位置
Dim lngGetCount		'表示件数

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon = Server.CreateObject("HainsCommon.Common")

'引数値の取得
strKey      = Request("key")
lngStartPos = CLng("0" & Request("startpos"))
lngGetCount = CLng("0" & Request("getcount"))

'## 2003.11.21 Add by T.Takagi@FSIT 複合検索はやめる
'検索キー中の半角カナを全角カナに変換する
strKey = objCommon.StrConvKanaWide(strKey)

'検索キー中の小文字を大文字に変換する
strKey = UCase(strKey)

'全角空白を半角空白に置換する
strKey = Replace(Trim(strKey), "　", " ")

'2バイト以上の半角空白文字が存在しなくなるまで置換を繰り返す
Do Until InStr(1, strKey, "  ") = 0
    strKey = Replace(strKey, "  ", " ")
Loop
'## 2003.11.21 Add End

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
<TITLE>個人の検索</TITLE>
<STYLE TYPE="text/css">
td.mnttab  { background-color:#FFFFFF }
</STYLE>
</HEAD>

<BODY ONLOAD="JavaScript:document.kensakulist.key.focus()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="kensakulist" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">■</SPAN><FONT COLOR="#000000">個人の検索</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
		<TR>
			<TD COLSPAN="3">検索条件を入力して下さい。</TD>
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
						<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="document.kensakulist.submit();return false"><IMG SRC="/webHains/images/findrsv.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="この条件で検索"></A></TD>
					</TR>
				</TABLE>
			</TD>
			
            <% If Session("PAGEGRANT") = "4" Then %>
                <TD ALIGN="right" VALIGN="top"><A HREF="mntPersonal.asp?mode=insert"><IMG SRC="/webHains/images/newrsv.gif" WIDTH="77" HEIGHT="24" ALT="新規に個人データの登録を行います"></A> </TD>
            <% End IF %>

		</TR>
	</TABLE>
<%
	'個人一覧の編集
	Call EditPersonList(strKey, lngStartPos, lngGetCount, "mntPersonal.asp?mode=update&perid=")
%>
	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>