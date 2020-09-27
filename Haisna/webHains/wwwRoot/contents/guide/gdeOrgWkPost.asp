<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		労基署所属ガイド (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/EditPageNavi.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const STARTPOS  = 1			'開始位置のデフォルト値
Const GETCOUNT  = 20		'表示件数のデフォルト値

'データベースアクセス用オブジェクト
Dim objOrganization			'団体情報アクセス用
Dim objOrgPost				'所属情報アクセス用

'引数値
Dim strOrgCd1				'団体コード１
Dim strOrgCd2				'団体コード２
Dim strKey					'検索キー
Dim lngStartPos				'検索開始位置
Dim lngGetCount				'表示件数

'労基署所属情報
Dim strOrgWkPostCd			'労基署所属コード
Dim strOrgWkPostName		'労基署所属名称
Dim strOrgWkPostSeq			'労基署所属ＳＥＱ

Dim strDispOrgWkPostCd		'編集用の労基署所属コード
Dim strDispOrgWkPostName	'編集用の労基署所属名称
Dim strOrgName				'団体名称
Dim strArrKey				'(分割後の)検索キーの集合
Dim lngCount				'レコード件数
Dim strURL					'URL文字列
Dim strBuffer				'文字列バッファ
Dim i, j					'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'引数値の取得
strOrgCd1    = Request("orgCd1")
strOrgCd2    = Request("orgCd2")
strKey       = Request("key")
lngStartPos  = Request("startPos")
lngGetCount  = Request("getCount")

'引数省略時のデフォルト値設定
lngStartPos = CLng(IIf(lngStartPos = "", STARTPOS, lngStartPos))
lngGetCount = CLng(IIf(lngGetCount = "", GETCOUNT, lngGetCount))
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>労基署所属の検索</TITLE>
<style type="text/css">
	body { margin: 15px 0 0 15px; }
</style>
</HEAD>
<BODY ONLOAD="JavaScript:document.entryForm.key.focus()">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">■</SPAN><FONT COLOR="#000000">労基署所属の検索</FONT></B></TD>
	</TR>
</TABLE>
<%
'団体名称の読み込み
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
objOrganization.SelectOrg strOrgCd1, strOrgCd2, , strOrgName
%>
<BR>&nbsp;団体：&nbsp;<FONT COLOR="#ff6600"><B><%= strOrgName %></B></FONT>

<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">

	<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
	<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">

	&nbsp;労基署所属コードもしくは労基署所属名称を入力して下さい。

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD><INPUT TYPE="text" NAME="key" SIZE="30" VALUE="<%= strKey %>"></TD>
			<TD><INPUT TYPE="image" NAME="search" SRC="/webHains/images/findrsv.gif" WIDTH="77" HEIGHT="24" ALT="この条件で検索"></TD>
		</TR>
	</TABLE>

</FORM>
<%
Do

	'検索キーを空白で分割する
	strArrKey = SplitByBlank(strKey)

	'検索条件を満たすレコード件数を取得
	Set objOrgPost = Server.CreateObject("HainsOrgPost.OrgPost")
	lngCount = objOrgPost.SelectOrgWkPostList(strOrgCd1, strOrgCd2, strArrKey, lngStartPos, lngGetCount, strOrgWkPostCd, strOrgWkPostName, strOrgWkPostSeq)

	'検索結果が存在しない場合はメッセージを編集
	If lngCount = 0 Then

		If strKey = "" Then
			Exit Do
		End If
%>
		検索条件を満たす労基署所属情報は存在しません。<BR>
		キーワードを減らす、もしくは変更するなどして、再度検索してみて下さい。<BR>
<%
		Exit Do
	End If

	'レコード件数情報を編集
	If strKey <> "" Then
%>
		「<FONT COLOR="#ff6600"><B><%= strKey %></B></FONT>」の
<%
	End If
%>
	検索結果は <FONT COLOR="#ff6600"><B><%= lngCount %></B></FONT>件ありました。<BR><BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD WIDTH="10"></TD>
			<TD NOWRAP>コード</TD>
			<TD WIDTH="10"></TD>
			<TD NOWRAP>労基署所属名称</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD BGCOLOR="#999999" COLSPAN="3"></TD>
		</TR>
		<TR>
			<TD HEIGHT="2"></TD>
		</TR>
<%
		For i = 0 To UBound(strOrgWkPostCd)

			'労基署所属情報の取得
			strDispOrgWkPostCd   = strOrgWkPostCd(i)
			strDispOrgWkPostName = strOrgWkPostName(i)

			'検索キーに合致する部分に<B>タグを付加
			If Not IsEmpty(strArrKey) Then
				For j = 0 To UBound(strArrKey)
					strDispOrgWkPostCd   = Replace(strDispOrgWkPostCd,   strArrKey(j), "<B>" & strArrKey(j) & "</B>")
					strDispOrgWkPostName = Replace(strDispOrgWkPostName, strArrKey(j), "<B>" & strArrKey(j) & "</B>")
				Next
			End If

			'労基署所属選択時のURLを編集
			strURL = "gdeSelectOrgWkPost.asp"
			strURL = strURL & "?orgWkPostSeq=" & strOrgWkPostSeq(i)

			'労基署所属情報の編集
%>
			<TR>
				<TD WIDTH="10"></TD>
				<TD NOWRAP><%= strDispOrgWkPostCd %></TD>
				<TD WIDTH="10"></TD>
				<TD NOWRAP><A HREF="<%= strURL %>"><%= strDispOrgWkPostName %></A></TD>
			</TR>
<%
		Next
%>
	</TABLE>
<%
	'ページングナビゲータの編集
	strURL = Request.ServerVariables("SCRIPT_NAME")
	strURL = strURL & "?orgCd1=" & strOrgCd1
	strURL = strURL & "&orgCd2=" & strOrgCd2
	strURL = strURL & "&key="    & Server.URLEncode(strKey)
%>
	<%= EditPageNavi(strURL, lngCount, lngStartPos, lngGetCount) %>
<%
	Exit Do
Loop
%>
</BODY>
</HTML>
