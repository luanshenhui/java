<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		室部検索ガイド (Ver0.0.1)
'		AUTHER  : Eiichi Yamamoto K-MIX
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/EditPageNavi.inc" -->
<%
'セッション・権限チェック
'Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const STARTPOS = 1	'開始位置のデフォルト値
Const GETCOUNT = 20	'表示件数のデフォルト値

'データベースアクセス用オブジェクト
Dim objCommon		'共通クラス
Dim objOrgRoom		'室部情報アクセス用

'室部情報
Dim strOrgCd1		'団体コード1
Dim strOrgCd2		'団体コード2
Dim strOrgBsdCd		'事業部コード
Dim strOrgRoomCd	'室部コード
Dim strOrgRoomName	'室部名称
Dim strOrgRoomKName	'室部カナ名称
Dim strOrgKanaName	'団体カナ名称
Dim strOrgName		'団体名称
Dim strOrgSName		'略称
Dim strOrgBsdKName	'事業部カナ名称
Dim strOrgBsdName	'事業部名称

Dim lngAllCount		'検索件数
Dim BlnCheckBsd		'URL文字列
Dim strURL			'URL文字列
Dim i, j			'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objOrgRoom 		= Server.CreateObject("HainsOrgRoom.OrgRoom")

'引数値の取得
strOrgRoomCd = Request("orgRoomCd")
strOrgBsdCd  = Request("orgBsdCd")
strOrgCd1	 = Request("orgCd1")
strOrgCd2    = Request("orgCd2")

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>室部の検索</TITLE>
<style type="text/css">
	body { margin: 15px 0 0 15px; }
</style>
</HEAD>
<BODY ONLOAD="JavaScript:document.entryForm.orgRoomCd.focus()">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">■</SPAN><FONT COLOR="#000000">室部の検索</FONT></B></TD>
	</TR>
</TABLE>

<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" WIDTH="100%">
		<TR>
			<TD COLSPAN="3">室部コードを入力して下さい。</TD>
		</TR>
		<TR>
		<TD WIDTH="1"><INPUT TYPE="text" NAME="orgRoomCd" SIZE="30" VALUE="<%= strOrgRoomCd %>"></TD>
		<TD WIDTH="1"><INPUT TYPE="hidden" NAME="orgCd1" SIZE="30" VALUE="<%= strOrgCd1 %>"></TD>
		<TD WIDTH="1"><INPUT TYPE="hidden" NAME="orgCd2" SIZE="30" VALUE="<%= strOrgCd2 %>"></TD>
		<TD WIDTH="1"><INPUT TYPE="hidden" NAME="orgBsdCd" SIZE="30" VALUE="<%= strOrgBsdCd %>"></TD>
		<TD WIDTH="5"><IMG SRC="/webHains/images/spacer.gif" WIDTH="5" HEIGHT="1" BORDER="0"></TD>
		<TD WIDTH="77"><INPUT TYPE="image" NAME="search" SRC="/webHains/images/findrsv.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="この条件で検索"></TD>
		</TR>
	</TABLE>
</FORM>
<%
	Do
		'検索条件が存在しない場合は何もしない
		If strOrgRoomCd = "" Then
			Exit Do
		End If

		'室部情報から検索条件を満たしているデータを取得
		BlnCheckBsd = objOrgRoom.SelectOrgRoom( strOrgCd1, _
												strOrgCd2, _
												strOrgBsdCd, _
												strOrgRoomCd, _
												strOrgRoomName, _
												strOrgRoomKName, _
												strOrgKanaName, _
												strOrgName, _
												strOrgSName, _
												strOrgBsdKName, _
												strOrgBsdName _
											  )
		If( BlnCheckBsd ) Then
			lngAllCount = 1
		Else
			lngAllCount = 0
		End If
%>
		「<FONT COLOR="#ff6600"><B><%= strOrgRoomCd %></B></FONT>」の検索結果は <FONT COLOR="#ff6600"><B><%= lngAllCount %></B></FONT>件ありました。<BR><BR>
		<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
<%
		If ( BlnCheckBsd = True ) Then
		'室部一覧の編集開始

			'室部選択時のURLを編集
			strURL = "/webHains/contents/guide/gdeSelectOrgRoom.asp?orgCd1=" & strOrgCd1 & "&orgCd2=" & strOrgCd2 & "&orgBsdCd=" & strOrgBsdCd & "&orgRoomCd=" & strOrgRoomCd

			'室部情報の編集
%>
			<TR>
				<TD WIDTH="10"></TD>
				<TD NOWRAP><%= strOrgRoomCd %>　<A HREF="<%= strURL %>"><%= strOrgRoomName %></A></TD>
			</TR>
		</TABLE>

<%
		End If
		Exit Do
	Loop
%>
</BODY>
</HTML>
