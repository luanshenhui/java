<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�����̃R�[�X (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'�Z�b�V�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_SELF)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim objCourse	'�R�[�X���A�N�Z�X�p

'�����̃R�[�X
Dim strCsCd		'�R�[�X�R�[�h
Dim strCsName	'�R�[�X��
Dim strCsCount	'�R�[�X�l��
Dim strWebColor	'Web�J���[
Dim lngCsCount	'���R�[�h��

Dim lngAllCount	'��f�Ґ�
Dim i			'�C���f�b�N�X
'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�����̗\��</TITLE>
</HEAD>
<BODY>

<%
'�����̎�f�Ҏ擾�i�R�[�X�ʁj
Set objCourse = Server.CreateObject("HainsCourse.Course")
lngCsCount = objCourse.SelectSelDateCourse(Date, strCsCd, strCsName, strWebColor, strCsCount)
Set objCourse = Nothing

If lngCsCount > 0 Then
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
<%
		'�����̎�f�ҕ\���i�R�[�X�ʁj
		For i = 0 To lngCsCount - 1 

			lngAllCount = lngAllCount + strCsCount(i)
%>
			<TR>
				<TD WIDTH="35"><IMG SRC="/webHains/images/spacer.gif" WIDTH="35" HEIGHT="1" BORDER="0"></TD>
				<TD><FONT COLOR="<%= strWebColor(i) %>">��</FONT><A HREF="/webHains/contents/common/dailyList.asp?strYear=<%= Year(Date) %>&strMonth=<%= Month(Date) %>&strDay=<%= Day(Date) %>&cscd=<%= strCsCd(i) %>" TARGET="_parent"><%= strCsName(i) %></A></TD>
<!--
				<TD WIDTH="50" ALIGN="right" NOWRAP><B><%= strCsCount(i) %></B>�l</TD>
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