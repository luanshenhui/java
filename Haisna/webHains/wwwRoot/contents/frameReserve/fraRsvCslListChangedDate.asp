<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		受診日一括変更(変更完了) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"  -->
<%
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objConsult		'受診情報アクセス用
Dim objPerson		'個人情報アクセス用

'引数値
Dim dtmCslDate		'受診日
Dim strRsvNo		'予約番号

'受診情報
Dim strWebColor		'webカラー
Dim strCsName		'コース名
Dim strLastName		'姓
Dim strFirstName	'名
Dim strOrgSName		'団体略称
Dim strOptName		'オプション名
Dim strRsvGrpName	'予約群名称
Dim lngCount		'レコード数

Dim i				'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'引数値の取得
dtmCslDate = CDate(Request("cslDate"))
strRsvNo   = ConvIStringToArray(Request("rsvNo"))
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>変更完了</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// 本画面が開かれている場合は必ず受診日変更が行われているため、親画面である予約情報詳細画面をリロードする
function closeWindow() {

	if ( opener != null ) {
		if ( opener.top != null ) {
			opener.top.location.reload();
		}
	}

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">
<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
	<TR>
		<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">変更完了</FONT></B></TD>
	</TR>
</TABLE>
<BR>「<B><FONT COLOR="#ffa500"><%= Year(dtmCslDate) %>年<%= Month(dtmCslDate) %>月<%= Day(dtmCslDate) %>日</FONT></B>」 に対して <B><FONT COLOR="#ffa500"><%= UBound(strRsvNo) + 1 %></FONT></B>名の受診日変更が行われました。<BR>
<BR>
<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
	<TR BGCOLOR="#dcdcdc">
		<TD NOWRAP WIDTH="120">受診コース</TD>
		<TD NOWRAP WIDTH="120">個人名称</TD>
		<TD NOWRAP WIDTH="150">団体名</TD>
		<TD NOWRAP WIDTH="200">検査オプション</TD>
		<TD NOWRAP>時間枠</TD>
	</TR>
<%
	Set objConsult = Server.CreateObject("HainsConsult.Consult")

	'受診者一覧の編集
	For i = 0 To UBound(strRsvNo)

		'受診情報読み込み
		lngCount = objConsult.SelectConsultListForFraRsv(strRsvNo(i), strRsvNo(i), , , strWebColor, strCsName, , strLastName, strFirstName, , , , , , , , strOrgSName, strOptName, strRsvGrpName)
		If lngCount <= 0 Then
			Err.Raise 1000, , "受診情報が存在しません。"
		End If
%>
		<TR BGCOLOR="#<%= IIf(i Mod 2 = 0, "ffffff", "e0ffff") %>">
			<TD NOWRAP><FONT COLOR="<%= strWebColor(0) %>">■</FONT><A HREF="/webHains/contents/reserve/rsvMain.asp?rsvNo=<%= strRsvNo(i) %>" TARGET="_blank"><%= strCsName(0) %></A></TD>
			<TD NOWRAP><%= Trim(strLastName(0) & "　" & strFirstName(0)) %></TD>
			<TD NOWRAP><%= strOrgSName(0) %></TD>
			<TD NOWRAP><%= Replace(strOptName(0), ",", "、") %></TD>
			<TD NOWRAP><%= strRsvGrpName(0) %></TD>
		</TR>
<%
	Next

	Set objConsult = Nothing
%>
</TABLE>
<BR>
<A HREF="javascript:close()"><IMG SRC="/webHains/images/toRsv.gif" ALT="予約詳細情報へ戻ります" HEIGHT="24" WIDTH="77"></A>
</BODY>
</HTML>
