<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�g�b�v�y�[�W (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 

Response.Expires = -1
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'�Z�b�V�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_SELF)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim strCslYear	'��f��(�N)
Dim strCslMonth	'��f��(��)
Dim strCslDay	'��f��(��)

Dim strURL		'�W�����v���URL
Dim bolMsg

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�����l�̎擾
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
		'��f�����w�肳��Ă���ꍇ
		If strCslYear <> "" And strCslMonth <> "" And strCslDay <> "" Then

			'��f�҈ꗗ��URL�ҏW
			strURL = "/webHains/contents/common/dailyList.asp"
			strURL = strURL & "?strYear="  & strCslYear
			strURL = strURL & "&strMonth=" & strCslMonth
			strURL = strURL & "&strDay="   & strCslDay

		'��f�����w�肳��Ă��Ȃ��ꍇ
		Else

			'�����̗\���URL�ҏW
			strURL = "/webHains/contents/common/todaysInfo.asp"

		End If
%>
		<FRAME SRC="<%= strURL %>" NAME="Main" SCROLLING="AUTO" NORESIZE>
	</FRAMESET>
</FRAMESET>
</HTML>