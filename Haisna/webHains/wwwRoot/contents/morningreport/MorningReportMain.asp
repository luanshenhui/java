<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �����|�[�g�Ɖ�  (Ver0.0.1)
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
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X

'�p�����[�^
Dim lngCslYear			'��f��(�N)
Dim lngCslMonth			'��f��(��)
Dim lngCslDay			'��f��(��)
Dim strCsCd				'�R�[�X�R�[�h
Dim blnNeedUnReceipt	'����t�Ҏ擾�t���O(True:�����h�c�����ԏ�Ԃ��擾)

Dim strUrlPara			'�t���[���ւ̃p�����[�^

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon  = Server.CreateObject("HainsCommon.Common")

'�����l�̎擾
'��f�N�������n����Ă��Ȃ��ꍇ�A�V�X�e���N������K�p����
lngCslYear			= CLng(IIf(Request("cslYear" )="", Year(Now),  Request("cslYear" )))
lngCslMonth			= CLng(IIf(Request("cslMonth")="", Month(Now), Request("cslMonth")))
lngCslDay			= CLng(IIf(Request("cslDay"  )="", Day(Now),   Request("cslDay"  )))
strCsCd				= Request("csCd")
blnNeedUnReceipt	= Request("NeedUnReceipt")

'�t���[���ւ̃p�����[�^�ݒ�
strUrlPara = "cslYear=" & lngCslYear 
strUrlPara = strUrlPara & "&cslMonth=" & lngCslMonth
strUrlPara = strUrlPara & "&cslDay=" & lngCslDay
strUrlPara = strUrlPara & "&csCd=" & strCsCd
strUrlPara = strUrlPara & "&NeedUnReceipt=" & blnNeedUnReceipt

%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML lang="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>�����|�[�g�Ɖ�</TITLE>
</HEAD>
<FRAMESET BORDER="0" FRAMEBORDER="no" FRAMESPACING="5" ROWS="120,245,*">
	<FRAME NAME="header" NORESIZE SRC="MorningReportHeader.asp?<%= strUrlPara %>">
	<FRAMESET COLS="5,250,540,240,*" FRAMEBORDER="no">
		<FRAME NAME="blank" NORESIZE SRC="../common/blank.html">
		<FRAME NAME="Report1" NORESIZE SRC="RsvFraSummary.asp?<%= strUrlPara %>">
		<FRAME NAME="Report2" NORESIZE SRC="FriendSummary.asp?<%= strUrlPara %>">
		<FRAME NAME="Report3" NORESIZE SRC="SameName.asp?<%= strUrlPara %>">
		<FRAME NAME="blank" NORESIZE SRC="../common/blank.html">
	</FRAMESET>
	<FRAMESET COLS="5,250,*">
		<FRAME NAME="blank" NORESIZE SRC="../common/blank.html">
		<FRAME NAME="Report4" NORESIZE SRC="SetCountInfo.asp?<%= strUrlPara %>">
		<FRAMESET BORDER="10" FRAMEBORDER="no" FRAMESPACING="5" ROWS="100,*">
			<FRAME NAME="Report5" NORESIZE SRC="volunteerInfo.asp?<%= strUrlPara %>">
			<FRAME NAME="Report6" NORESIZE SRC="TroubleInfo.asp?<%= strUrlPara %>">
		</FRAMESET>
	</FRAMESET>
	<NOFRAMES>
		<BODY BGCOLOR="#ffffff">
			<P></P>
		</BODY>
	</NOFRAMES>
</FRAMESET>
</HTML>