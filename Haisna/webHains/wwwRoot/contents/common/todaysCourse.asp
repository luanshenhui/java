<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		今日のコース (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'セッションチェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_SELF)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim objCourse	'コース情報アクセス用

'今日のコース
Dim strCsCd		'コースコード
Dim strCsName	'コース名
Dim strCsCount	'コース人数
Dim strWebColor	'Webカラー
Dim lngCsCount	'レコード数

Dim lngAllCount	'受診者数
Dim i			'インデックス
'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>今日の予定</TITLE>
</HEAD>
<BODY>

<%
'今日の受診者取得（コース別）
Set objCourse = Server.CreateObject("HainsCourse.Course")
lngCsCount = objCourse.SelectSelDateCourse(Date, strCsCd, strCsName, strWebColor, strCsCount)
Set objCourse = Nothing

If lngCsCount > 0 Then
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
<%
		'今日の受診者表示（コース別）
		For i = 0 To lngCsCount - 1 

			lngAllCount = lngAllCount + strCsCount(i)
%>
			<TR>
				<TD WIDTH="35"><IMG SRC="/webHains/images/spacer.gif" WIDTH="35" HEIGHT="1" BORDER="0"></TD>
				<TD><FONT COLOR="<%= strWebColor(i) %>">■</FONT><A HREF="/webHains/contents/common/dailyList.asp?strYear=<%= Year(Date) %>&strMonth=<%= Month(Date) %>&strDay=<%= Day(Date) %>&cscd=<%= strCsCd(i) %>" TARGET="_parent"><%= strCsName(i) %></A></TD>
<!--
				<TD WIDTH="50" ALIGN="right" NOWRAP><B><%= strCsCount(i) %></B>人</TD>
-->
			</TR>
<%
		Next
%>
	</TABLE>
<%
End If
%>
</BODY>
</HTML>