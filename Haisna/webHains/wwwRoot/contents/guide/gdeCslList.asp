<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		受診情報の検索 (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon		'共通クラス
Dim objConsult		'受診情報アクセス用
Dim objFree			'汎用情報アクセス用
Dim objPerson		'個人情報アクセス用

'引数値
Dim strPerId		'個人ＩＤ

'個人情報
Dim strLastName		'姓
Dim strFirstName	'名
Dim strLastKName	'カナ姓
Dim strFirstKName	'カナ名
Dim strBirth		'生年月日
Dim strGender		'性別
Dim strAge			'受診時年齢

'受診情報
Dim strRsvNo		'予約番号
Dim strCslDate		'受診日
Dim strCsName		'コース名
Dim strOrgSName		'団体略称
Dim strCslDivName	'受診区分名称
Dim lngCount		'受診歴数

Dim strURL			'URL文字列
Dim i				'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objConsult = Server.CreateObject("HainsConsult.Consult")
Set objFree    = Server.CreateObject("HainsFree.Free")
Set objPerson  = Server.CreateObject("HainsPerson.Person")

'引数値の取得
strPerId        = Request("perId")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>受診情報の検索</TITLE>
<style type="text/css">
	body { margin: 15px 0 0 15px; }
</style>
</HEAD>
<BODY>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">■</SPAN><FONT COLOR="#000000">受診情報の検索</FONT></B></TD>
	</TR>
</TABLE>
<%
'個人情報読み込み
If objPerson.SelectPerson_Lukes(strPerId, strLastName, strFirstName, strLastKName, strFirstKName, , strBirth, strGender) = False Then
	Err.Raise 1000, , "個人情報が存在しません。"
End If

'年齢計算
strAge = objFree.CalcAge(strBirth)
%>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
	<TR>
		<TD HEIGHT="3"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2" VALIGN="top" NOWRAP><%= strPerId %></TD>
		<TD NOWRAP><B><%= Trim(strLastName  & "　" & strFirstName) %></B>（<%= Trim(strLastKName & "　" & strFirstKName) %>）</TD>
	</TR>
	<TR>
		<TD NOWRAP><%= objCommon.FormatString(CDate(strBirth), "ge.m.d") %>生　<%= strAge %>歳　<%= IIf(strGender = CStr(GENDER_MALE), "男性", "女性") %></TD>
	</TR>
</TABLE>
<BR>
<%
Do
	'受診歴の検索
	lngCount = objConsult.SelectConsultHistory(strPerId, , , , , strRsvNo, strCslDate, , strCsName, , , , strOrgSName, strCslDivName)
	If lngCount <= 0 Then
%>
		受診情報はありません。<BR><BR>
<%
		Exit Do
	End If
%>
	検索結果は <FONT COLOR="#ff6600"><B><%= lngCount %></B></FONT>件ありました。<BR><BR>
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
		<TR>
			<TD WIDTH="10"></TD>
			<TD NOWRAP>受診日</TD>
			<TD WIDTH="10"></TD>
			<TD NOWRAP>団体</TD>
			<TD WIDTH="10"></TD>
			<TD NOWRAP>コース</TD>
			<TD WIDTH="10"></TD>
			<TD NOWRAP>受診区分</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD BGCOLOR="#999999" COLSPAN="7"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1" ALT=""></TD>
		</TR>
<%
		'URLの原型を編集
		strURL = "gdeSelectPerson.asp"
		strURL = strURL & "?perId=" & strPerId
		strURL = strURL & "&rsvNo="

		'受診歴の編集
		For i = 0 To lngCount - 1
%>
			<TR>
				<TD HEIGHT="25"></TD>
				<TD NOWRAP><%= strCslDate(i) %></TD>
				<TD></TD>
				<TD NOWRAP><A HREF="<%= strURL & strRsvNo(i) %>"><%= strOrgSName(i) %></A></TD>
				<TD></TD>
				<TD NOWRAP><%= strCsName(i) %></TD>
				<TD></TD>
				<TD NOWRAP><%= strCslDivName(i) %></TD>
			</TR>
<%
		Next
%>
	</TABLE>
<%
	Exit Do
Loop
%>
<BR><A HREF="javascript:history.back()"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="戻る"></A>
</BODY>
</HTML>
