<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		結果参照　対象者 (Ver0.0.1)
'		AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Dim objPerson		'個人情報アクセス用COMオブジェクト
Dim objConsult		'受診情報アクセス用COMオブジェクト
Dim objCommon		'共通関数アクセス用COMオブジェクト

Dim strPerID		'個人ＩＤ

'個人情報
Dim strLastName		'姓
Dim strFirstName	'名
Dim strLastKName	'カナ姓	
Dim strFirstKName	'カナ名
Dim strBirth		'生年月日
Dim strGender		'性別
Dim strGenderName	'性別名称

'受診歴
Dim strRsvNo		'予約番号
Dim strCslDate		'受診日
Dim strCsName		'コース名
Dim strAge			'年齢
Dim strCsSName		'コース略称
Dim strWebColor		'webカラー

Dim lngCount		'レコード件数
Dim i				'インデックス

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
strPerID = Request("PerID")

'オブジェクトのインスタンス作成
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objConsult = Server.CreateObject("HainsConsult.Consult")
Set objPerson  = Server.CreateObject("HainsPerson.Person")

'個人情報読み込み
objPerson.SelectPersonInf strPerId, strLastName, strFirstName, strLastKName, strFirstKName, strBirth, strGender, strGenderName

'生年月日和暦表示
strBirth = objCommon.FormatString(strBirth, "g ee.mm.dd")

'受診歴読み込み
lngCount = objConsult.SelectConsultHistory(strPerId, , , , ,strRsvNo, strCslDate, , strCsName, strAge, strCsSName, strWebColor)
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>対象者</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">


「<FONT COLOR="#FF6600"><B><%= strLastKName %>　<%= strFirstKName %></B></FONT>」<BR>
の受診歴は <FONT COLOR="#FF6600"><B><%= lngCount %></B></FONT>件ありました。<BR><BR>

<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#eeeeee" NOWRAP><B><FONT COLOR="#000000">対象者</FONT></B></TD>
	</TR>
</TABLE>

<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
	<TR><TD COLSPAN="2" HEIGHT="5"></TD></TR>
	<TR>
		<TD><%= strPerID %></TD>
		<TD><B><%= strLastName %>　<%= strFirstName %></B><FONT SIZE="-1">（<%= strLastKName %>　<%= strFirstKName %>）</FONT></TD>
	</TR>
	<TR>
		<TD></TD>
		<TD><%= strBirth %>生　<%= strGenderName %></TD>
	</TR>
</TABLE>

<BR>

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2" WIDTH="122">
	<TR>
		<TD><A HREF="inqWiz.asp" TARGET="_top"><IMG SRC="/webHains/images/changeper.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="表示する受診者を変更します"></A></TD>
		<TD><A HREF="/webHains/contents/inquiry/inqRslHistory.asp?mode=1&perId=<%= strPerId %>" TARGET="detail"><IMG SRC="/webHains/images/inqhistory.gif"></A></TD>
		<TD><A HREF="/webHains/contents/inquiry/inqGraph.asp?perId=<%= strPerId %>" TARGET="detail"><IMG SRC="/webHains/images/graph.gif"></A></TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
	<TR ALIGN="center" BGCOLOR="#cccccc">
		<TD>受診日</TD>
		<TD>コース</TD>
		<TD>年齢</TD>
	</TR>
<%
	For i = 0 To lngCount - 1
%>
		<TR BGCOLOR="#<%= IIf(i Mod 2 = 0, "ffffff", "eeeeee") %>" ALIGN="center">
		<TD><A HREF="/webHains/contents/inquiry/inqReport.asp?rsvNo=<%= strRsvNo(i) %>" TARGET="detail"><%= strCslDate(i) %></A></TD>
		<TD WIDTH="120" ALIGN="left"><FONT COLOR="<%= strWebColor(i) %>">■</FONT><%= strCsSName(i) %></TD>
		<TD><%= strAge(i) %>歳</TD>
	</TR>
<%
Next
%>
</TABLE>
</BODY>
</HTML>
