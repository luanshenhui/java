<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �����|�[�g�Ɖ�i�����ҁi���A��l�j��f�ҏ��j  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Adobe GoLive 6">
<TITLE>�����ҁi���A��l�j��f�ҏ��</TITLE>
</HEAD>
<FRAMESET border="0" FRAMEBORDER="no" framespacing="0" ROWS="52,*">
	<FRAME NAME="header" NORESIZE SRC="FriendSummaryHeader.asp?<%= Request.ServerVariables("QUERY_STRING") %>">
	<FRAME NAME="list"   NORESIZE SRC="FriendSummaryBody.asp?<%= Request.ServerVariables("QUERY_STRING") %>">
	<NOFRAMES></NOFRAMES>
</FRAMESET>
</HTML>
