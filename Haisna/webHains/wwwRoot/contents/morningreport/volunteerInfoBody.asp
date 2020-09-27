<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �����|�[�g�Ɖ�i�{�����e�B�A���j  (Ver0.0.1)
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
Dim objConsult			'��f���A�N�Z�X�p

'�p�����[�^
Dim lngCslYear			'��f��(�N)
Dim lngCslMonth			'��f��(��)
Dim lngCslDay			'��f��(��)
Dim strCsCd				'�R�[�X�R�[�h
Dim blnNeedUnReceipt	'����t�Ҏ擾�t���O(True:�����h�c�����ԏ�Ԃ��擾)

'��f���
Dim dtmCslDate			'��f��
Dim lngCntlNo			'�Ǘ��ԍ�
Dim strArrRsvNo			'�\��ԍ��̔z��
Dim strArrDayId			'����ID�̔z��
Dim strArrWebColor		'web�J���[�̔z��
Dim strArrCsName		'�R�[�X���̔z��
Dim strArrPerId			'�lID�̔z��
Dim strArrLastName		'���̔z��
Dim strArrFirstName		'���̔z��
Dim vntArrVolunteer		'�{�����e�B�A�̔z��
Dim vntArrVolunteerName	'�{�����e�B�A���̔z��

Dim lngCount			'���R�[�h����
Dim lngDispCount		'�\������
Dim strBgColor			'�w�i�F
Dim strVolunteer		'�{�����e�B�A�敪
Dim i,j					'�C���f�b�N�X

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon	= Server.CreateObject("HainsCommon.Common")
Set objConsult	= Server.CreateObject("HainsConsult.Consult")

'�����l�̎擾
lngCslYear		= CLng("0" & Request("cslYear") )
lngCslMonth		= CLng("0" & Request("cslMonth"))
lngCslDay		= CLng("0" & Request("cslDay")  )
strCsCd			= Request("csCd")
blnNeedUnReceipt	= IIf(Request("NeedUnReceipt")="True", True, False)

Do

	'��f���E�Ǘ��ԍ��̐ݒ�
	dtmCslDate = CDate(lngCslYear & "/" & lngCslMonth & "/" & lngCslDay)
	lngCntlNo  = 0

	'���������𖞂�����f�҂̈ꗗ���擾����
	lngCount = objConsult.SelectConsultList(dtmCslDate, _
											lngCntlNo, _
											strCsCd, , , , , , , _
											blnNeedUnReceipt, , , , _
											strArrRsvNo, _
											strArrDayId, _
											, _
											strArrCsName, _
											strArrPerId, _
											strArrLastName, _
											strArrFirstName _
											, , , , , , , , , , , , , _
											vntArrVolunteer, _
											vntArrVolunteerName _
											)
	If lngCount < 0 Then
		Err.Raise 1000, , "��f�҂̈ꗗ���擾�ł��܂���B�i��f��=" & dtmCslDate & ",�R�[�X�R�[�h=" & strCsCd & ",�����h�c������=" & blnReceptOnly &")"
	End If

Exit Do
Loop
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Adobe GoLive 6">
<TITLE>�{�����e�B�A���</TITLE>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
</HEAD>
<BODY>
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="0">
<%
lngDispCount = 0
For i = 0 To lngCount-1
	If (vntArrVolunteer(i) <> "0" And vntArrVolunteer(i) <> "" ) Or vntArrVolunteerName(i) <> "" Then
		If (lngDispCount Mod 2) = 0 Then
			strBgColor = ""
		Else
			strBgColor = " BGCOLOR=""#e0ffff"""
		End If
		Select Case vntArrVolunteer(i)
		Case "0"
			strVolunteer = "���p�Ȃ�"
		Case "1"
			strVolunteer = "�ʖ�v"
		Case "2"
			strVolunteer = "���v"
		Case "3"
			strVolunteer = "�ʖ󁕉��v"
		Case "4"
			strVolunteer = "�Ԉ֎q�v"
		Case Else
			strVolunteer = ""
		End Select
%>
		<TR HEIGHT="17">
			<TD NOWRAP ALIGN="left"<%= strBgColor %>  WIDTH="80"><%= IIf(strArrDayId(i)<>"", objCommon.FormatString(strArrDayId(i), "0000"), "&nbsp;") %></TD>
			<TD NOWRAP ALIGN="left"<%= strBgColor %>  WIDTH="150"><%= strArrLastName(i) %>�@<%= strArrFirstName(i) %></TD>
			<TD NOWRAP ALIGN="left"<%= strBgColor %>  WIDTH="150"><%= strVolunteer %></TD>
			<TD NOWRAP ALIGN="left"<%= strBgColor %>  WIDTH="350"><%= vntArrVolunteerName(i) %></TD>
		</TR>
<%
		lngDispCount = lngDispCount + 1
	End If
Next
%>
	</TABLE>
</BODY>
</HTML>
