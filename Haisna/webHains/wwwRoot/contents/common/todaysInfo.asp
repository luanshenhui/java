<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�����̗\�� (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_SELF)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�����̗\��</TITLE>
</HEAD>
<FRAMESET ROWS="82,*" BORDER="1" FRAMESPACING="0" FRAMEBORDER="no">
	<FRAME SRC="todaysInfoHeader.asp" name="header">
	<FRAMESET ROWS="100,*" BORDER="1" FRAMESPACING="0" FRAMEBORDER="no">
		<FRAMESET COLS="270,*" BORDER="1" FRAMESPACING="0" FRAMEBORDER="no">
			<FRAME SRC="todaysCourse.asp" NAME="todaysCourse">
			<FRAME SRC="todaysOrg.asp"    NAME="todaysOrg">
		</FRAMESET>
		<FRAME SRC="todaysComment.asp" NAME="todaysComment">
	</FRAMESET>
</FRAMESET>
</HTML>
