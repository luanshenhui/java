<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   ���f�O�����i��f�j����  (Ver0.0.1)
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
<TITLE>��f����</TITLE>
</HEAD>
<FRAMESET BORDER="0" FRAMEBORDER="no" FRAMESPACING="0" ROWS="100,*">

	<FRAME NAME="naviBar" NORESIZE SRC="preparationInfoHeader.asp?rsvno=<%=lngRsvNo%>">
	<FRAMESET BORDER="0" COLS="300,*" FRAMEBORDER="no" FRAMESPACING="0">
		<FRAME NAME="prepaInfoBasic" NORESIZE SRC="prepaInfoBasic.asp?rsvno=<%=lngRsvNo%>">
		<FRAMESET BORDER="0" COLS="330,*" FRAMEBORDER="no" FRAMESPACING="0">
			<FRAMESET BORDER="0" FRAMEBORDER="no" FRAMESPACING="10" ROWS="250,*">
				<FRAME NAME="prepaInfoDisease" NORESIZE SRC="prepaInfoDisease.asp?rsvno=<%=lngRsvNo%>">
				<FRAME NAME="detail" NORESIZE SRC="prepaInfoReexamin.asp?rsvno=<%=lngRsvNo%>">
			</FRAMESET>
			<FRAMESET BORDER="10" FRAMEBORDER="no" FRAMESPACING="10" ROWS="250,*">
				<FRAME NAME="prepaInfoCmntHis" NORESIZE SRC="prepaInfoCmntHis.asp?rsvno=<%=lngRsvNo%>">
				<FRAME NAME="prepaInfoSecond" NORESIZE SRC="prepaInfoSecond.asp?rsvno=<%=lngRsvNo%>">
			</FRAMESET>
		</FRAMESET>
	</FRAMESET>
</FRAMESET>
</HTML>
