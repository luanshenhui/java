<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		室部情報メンテナンス(室部の検索) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/EditPageNavi.inc" -->
<%
'セッション・権限チェック
'## 2003.03.31 Mod 2Lines By T.Takagi@FSIT 権限チェックがおかしい
'Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)
'## 2003.03.31 Mod End

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const MODE_BSD  = "1"	'検索モード(事業部)
Const MODE_ROOM = "2"	'検索モード(室部)
Const MODE_POST = "3"	'検索モード(所属)
Const STARTPOS  = 1		'開始位置のデフォルト値
Const GETCOUNT  = 20	'表示件数のデフォルト値

'データベースアクセス用オブジェクト
Dim objOrganization		'団体情報アクセス用
Dim objOrgBsd			'事業部情報アクセス用
Dim objOrgRoom			'室部情報アクセス用

'引数値
Dim strOrgCd1			'団体コード１
Dim strOrgCd2			'団体コード２
Dim strOrgBsdCd			'事業部コード
Dim strKey				'検索キー
Dim lngStartPos			'検索開始位置
Dim lngGetCount			'表示件数

'室部情報
Dim strArrOrgBsdCd		'事業部コード
Dim strArrOrgRoomCd		'室部コード
Dim strArrOrgRoomName	'室部名称
Dim strArrOrgRoomKName	'室部カナ名称
Dim strArrOrgBsdName	'事業部名称
Dim strArrOrgBsdKName	'事業部カナ名称

Dim strDispOrgRoomCd	'編集用の室部コード
Dim strDispOrgRoomName	'編集用の室部名称
Dim strOrgName			'団体名称
Dim strOrgBsdName		'事業部名称
Dim strArrKey			'(分割後の)検索キーの集合
Dim lngAllCount			'条件を満たす全レコード件数
Dim lngCount			'レコード件数
Dim strURL				'URL文字列
Dim i, j				'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objOrgBsd       = Server.CreateObject("HainsOrgBsd.OrgBsd")
Set objOrgRoom      = Server.CreateObject("HainsOrgRoom.OrgRoom")

'引数値の取得
strOrgCd1   = Request("orgCd1")
strOrgCd2   = Request("orgCd2")
strOrgBsdCd = Request("orgBsdCd")
strKey      = Request("key")
lngStartPos = Request("startPos")
lngGetCount = Request("getCount")

'引数省略時のデフォルト値設定
lngStartPos = CLng(IIf(lngStartPos = "", STARTPOS, lngStartPos))
lngGetCount = CLng(IIf(lngGetCount = "", GETCOUNT, lngGetCount))

'団体が未決定の場合は団体検索ガイドへ遷移
If strOrgCd1 = "" Or strOrgCd2 = "" Then
	strURL = "gdeOrganization.asp"
	strURL = strURL & "?orgDiv=" & "0"
	strURL = strURL & "&mode="   & MODE_ROOM
	Response.Redirect strURL
	Response.End
End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>室部の検索</TITLE>
<STYLE TYPE="text/css">
td.mnttab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY ONLOAD="JavaScript:document.entryForm.key.focus()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">■</SPAN><FONT COLOR="#000000">室部の検索</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'団体名称の読み込み
	If objOrganization.SelectOrg(strOrgCd1, strOrgCd2, , strOrgName) = False Then
		Err.Raise 1000, , "団体情報が存在しません。"
	End If
%>
	<BR>&nbsp;団体：&nbsp;<FONT COLOR="#ff6600"><B><%= strOrgName %></B></FONT>
<%
	'事業部コードが指定されている場合
	If strOrgBsdCd <> "" Then
	
		'事業部名称の読み込み
		If objOrgBsd.SelectOrgBsd(strOrgCd1, strOrgCd2, strOrgBsdCd, , strOrgBsdName) = False Then
			Err.Raise 1000, , "事業部情報が存在しません。"
		End If
%>
		&nbsp;事業部：&nbsp;<FONT COLOR="#ff6600"><B><%= strOrgBsdName %></B></FONT>
<%
	End If
%>
	<INPUT TYPE="hidden" NAME="orgCd1"   VALUE="<%= strOrgCd1   %>">
	<INPUT TYPE="hidden" NAME="orgCd2"   VALUE="<%= strOrgCd2   %>">
	<INPUT TYPE="hidden" NAME="orgBsdCd" VALUE="<%= strOrgBsdCd %>">

	<BR><BR>&nbsp;室部コードもしくは室部名称を入力して下さい。

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" WIDTH="650">
		<TR>
			<TD><INPUT TYPE="text" NAME="key" SIZE="30" VALUE="<%= strKey %>"></TD>
			<TD><INPUT TYPE="image" NAME="search" SRC="/webHains/images/findrsv.gif" WIDTH="77" HEIGHT="24" ALT="この条件で検索"></TD>
<%
			strURL = "/webHains/contents/maintenance/organization/mntOrganization.asp"
			strURL = strURL & "?mode="   & "update"
			strURL = strURL & "&orgCd1=" & strOrgCd1
			strURL = strURL & "&orgCd2=" & strOrgCd2
%>
			<TD WIDTH="100%" ALIGN="right"><A HREF="<%= strURL %>"><IMG SRC="/webhains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="団体情報メンテナンス画面に戻る"></A></TD>
<%
			'室部選択時のURLを編集
			strURL = "mntOrgRoom.asp"
			strURL = strURL & "?mode="     & "insert"
			strURL = strURL & "&orgCd1="   & strOrgCd1
			strURL = strURL & "&orgCd2="   & strOrgCd2
			strURL = strURL & "&orgBsdCd=" & strOrgBsdCd
%>
			<TD><A HREF="<%= strURL %>"><IMG SRC="/webHains/images/newrsv.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="新しく室部を登録します"></A></TD>
		</TR>
	</TABLE>

	<BR>
<%
	Do
		'検索キーを空白で分割する
		strArrKey = SplitByBlank(strKey)

		'検索条件を満たすレコード件数を取得
		lngAllCount = objOrgRoom.SelectOrgRoomListCount(strOrgCd1, strOrgCd2, strOrgBsdCd, strArrKey)

		'検索結果が存在しない場合はメッセージを編集
		If lngAllCount = 0 Then
%>
			検索条件を満たす室部情報は存在しません。<BR>
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
		検索結果は <FONT COLOR="#ff6600"><B><%= lngAllCount %></B></FONT>件ありました。<BR><BR>
<%
		'検索条件を満たしかつ指定開始位置、件数分のレコードを取得
		lngCount = objOrgRoom.SelectOrgRoomList(strOrgCd1,         strOrgCd2,          _
												strOrgBsdCd,       strArrKey,          _
												lngStartPos,       lngGetCount,        _
												strArrOrgBsdCd,    strArrOrgRoomCd,    _
												strArrOrgRoomName, strArrOrgRoomKName, _
												strArrOrgBsdName,  strArrOrgBsdKName)

		'室部一覧の編集開始
%>
		<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
			<TR>
				<TD WIDTH="10"></TD>
				<TD NOWRAP>コード</TD>
				<TD WIDTH="10"></TD>
				<TD NOWRAP>室部名称</TD>
				<TD WIDTH="10"></TD>
				<TD NOWRAP>事業部</TD>
			</TR>
			<TR>
				<TD></TD>
				<TD BGCOLOR="#999999" COLSPAN="6"></TD>
			</TR>
			<TR>
				<TD HEIGHT="2"></TD>
			</TR>
<%
			For i = 0 To lngCount - 1

				'室部情報の取得
				strDispOrgRoomCd   = strArrOrgRoomCd(i)
				strDispOrgRoomName = strArrOrgRoomName(i)

				'検索キーに合致する部分に<B>タグを付加
				If Not IsEmpty(strArrKey) Then
					For j = 0 To UBound(strArrKey)
						strDispOrgRoomCd   = Replace(strDispOrgRoomCd,   strArrKey(j), "<B>" & strArrKey(j) & "</B>")
						strDispOrgRoomName = Replace(strDispOrgRoomName, strArrKey(j), "<B>" & strArrKey(j) & "</B>")
					Next
				End If

				'室部選択時のURLを編集
				strURL = "mntOrgRoom.asp"
				strURL = strURL & "?mode="      & "update"
				strURL = strURL & "&orgCd1="    & strOrgCd1
				strURL = strURL & "&orgCd2="    & strOrgCd2
				strURL = strURL & "&orgBsdCd="  & strArrOrgBsdCd(i)
				strURL = strURL & "&orgRoomCd=" & strArrOrgRoomCd(i)

				'室部情報の編集
%>
				<TR>
					<TD></TD>
					<TD NOWRAP><%= strDispOrgRoomCd %></TD>
					<TD></TD>
					<TD NOWRAP><A HREF="<%= strURL %>"><%= strDispOrgRoomName %></A></TD>
					<TD></TD>
					<TD NOWRAP><FONT COLOR="#aaaaaa"><%= strArrOrgBsdName(i) %></FONT></TD>
				</TR>
<%
			Next
%>
		</TABLE>
<%
		'ページングナビゲータの編集
		strURL = Request.ServerVariables("SCRIPT_NAME")
		strURL = strURL & "?orgCd1="   & strOrgCd1
		strURL = strURL & "&orgCd2="   & strOrgCd2
		strURL = strURL & "&orgBsdCd=" & strOrgBsdCd
		strURL = strURL & "&key="      & Server.URLEncode(strKey)
%>
		<%= EditPageNavi(strURL, lngAllCount, lngStartPos, lngGetCount) %>
<%
		Exit Do
	Loop
%>
	</BLOCKQUOTE>
</FORM>
</BODY>
</HTML>
