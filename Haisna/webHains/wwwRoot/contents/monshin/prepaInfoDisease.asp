<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   ���f�O�����i��f�j���� ���������C��  (Ver0.0.1)
'	   AUTHER  : K.Fujii@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
'Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�p�����[�^
Dim lngRsvNo			'�\��ԍ�

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
lngRsvNo			= Request("rsvno")

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Adobe GoLive 6">
<TITLE>������</TITLE>
<FRAMESET FRAMEBORDER="no" ROWS="52,*">
	<FRAME NAME="DiseaseHeader" NORESIZE SRC="prepaInfoDiseaseHeader.asp">
	<FRAME NAME="DiseaseBody" NORESIZE SRC="prepaInfoDiseaseBody.asp?rsvno=<%=lngRsvNo%>">
	<NOFRAMES></NOFRAMES>
</FRAMESET>