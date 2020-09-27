<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		トップページ (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 

Response.Expires = -1
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'セッションチェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_SELF)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim strCslYear	'受診日(年)
Dim strCslMonth	'受診日(月)
Dim strCslDay	'受診日(日)

Dim strURL		'ジャンプ先のURL
Dim bolMsg

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'引数値の取得
strCslYear  = Request("cslYear")
strCslMonth = Request("cslMonth")
strCslDay   = Request("cslDay")
%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>webHains Portal Menu</TITLE>
<%
if  Session("EXPDATE") <> "" then
%>
    <SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript" >
    <!--
        alert ('<%= Session("EXPDATE") %>');
    //-->
    </SCRIPT>     

<%
    Session("EXPDATE") = ""
end if
%>
</HEAD>
<FRAMESET ROWS="26,*" BORDER="0" FRAMESPACING="0" FRAMEBORDER="0">
	<FRAME SRC="/webHains/contents/common/navibar.asp" NAME="NaviBar" SCROLLING="NO" NORESIZE>
<!--
	<FRAMESET COLS="133,*" BORDER="0" FRAMESPACING="0" NAME="Main">
-->
	<FRAMESET COLS="133,*" BORDER="0" FRAMESPACING="0">
		<FRAME SRC="/webHains/contents/common/calendar.asp" NAME="Calendar" SCROLLING="AUTO">
<%
		'受診日が指定されている場合
		If strCslYear <> "" And strCslMonth <> "" And strCslDay <> "" Then

			'受診者一覧のURL編集
			strURL = "/webHains/contents/common/dailyList.asp"
			strURL = strURL & "?strYear="  & strCslYear
			strURL = strURL & "&strMonth=" & strCslMonth
			strURL = strURL & "&strDay="   & strCslDay

		'受診日が指定されていない場合
		Else

			'今日の予定のURL編集
			strURL = "/webHains/contents/common/todaysInfo.asp"

		End If
%>
		<FRAME SRC="<%= strURL %>" NAME="Main" SCROLLING="AUTO" NORESIZE>
	</FRAMESET>
</FRAMESET>
</HTML>