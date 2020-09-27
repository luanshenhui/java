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
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objMorningReport	'�����|�[�g���A�N�Z�X�p

'�p�����[�^
Dim lngCslYear			'��f��(�N)
Dim lngCslMonth			'��f��(��)
Dim lngCslDay			'��f��(��)
Dim strCsCd				'�R�[�X�R�[�h
Dim blnNeedUnReceipt	'����t�Ҏ擾�t���O(True:�����h�c�����ԏ�Ԃ��擾)

'�����ҁi���A��l�j��f�ҏ��
Dim vntRsvNo			'�\��ԍ�
Dim vntDayId			'�����h�c
Dim vntPerId			'�l�h�c
Dim vntLastName			'��
Dim vntFirstName		'��
Dim vntCompFlag			'�����҃t���O
Dim vntCompRsvNo		'�\��ԍ��i�����҂܂��͂��A��l�j
Dim vntCompDayId		'�����h�c�i�����҂܂��͂��A��l�j
Dim vntCompPerId		'�l�h�c�i�����҂܂��͂��A��l�j
Dim vntCompLastName		'���i�����҂܂��͂��A��l�j
Dim vntCompFirstName	'���i�����҂܂��͂��A��l�j

Dim lngCount			'���R�[�h����
Dim strBgColor			'�w�i�F
Dim i,j					'�C���f�b�N�X
Dim strRsvNo			'�O�s�̗\��ԍ�

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon			= Server.CreateObject("HainsCommon.Common")
Set objMorningReport	= Server.CreateObject("HainsMorningReport.MorningReport")

'�����l�̎擾
lngCslYear		= CLng("0" & Request("cslYear") )
lngCslMonth		= CLng("0" & Request("cslMonth"))
lngCslDay		= CLng("0" & Request("cslDay")  )
strCsCd			= Request("csCd")
blnNeedUnReceipt	= IIf(Request("NeedUnReceipt")="True", True, False)

Do

	'�����ҁi���A��l�j��f�ҏ����擾
	lngCount = objMorningReport.SelectFriendsDaily(	lngCslYear, lngCslMonth, lngCslDay, _
													strCsCd, _
													blnNeedUnReceipt, _
													vntRsvNo, _
													vntDayId, _
													vntPerId, _
													vntLastName, _
													vntFirstName, _
													vntCompFlag, _
													vntCompRsvNo, _
													vntCompDayId, _
													vntCompPerId, _
													vntCompLastName, _
													vntCompFirstName _
													)
	If lngCount < 0 Then
		Err.Raise 1000, , "�����ҁi���A��l�j��f�ҏ�񂪎擾�ł��܂���B�i��f��=" & dtmCslDate & ",�R�[�X�R�[�h=" & strCsCd & ",�����h�c������=" & blnReceptOnly &")"
	End If

Exit Do
Loop
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Adobe GoLive 6">
<TITLE>�����ҁi���A��l�j��f�ҏ��</TITLE>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
</HEAD>
<BODY>
	<TABLE  BORDER="0" CELLSPACING="1" CELLPADDING="0">
<%
strRsvNo = ""
For i = 0 To lngCount-1
	If (i Mod 2) = 0 Then
		strBgColor = ""
	Else
		strBgColor = " BGCOLOR=""#e0ffff"""
	End If
%>
		<TR HEIGHT="16">
<%
	'������f�҂̏ꍇ�͏ȗ�
	If strRsvNo <> vntRsvNo(i) Then
		strRsvNo = vntRsvNo(i)
%>
			<TD NOWRAP<%= strBgColor %> WIDTH="70"><%= IIf(vntDayID(i)<>"", objCommon.FormatString(vntDayID(i), "0000"), "&nbsp;") %></TD>
			<TD NOWRAP<%= strBgColor %> WIDTH="135"><%= vntLastName(i) %>�@<%= vntFirstName(i) %></TD>
<%
	Else
%>
			<TD NOWRAP<%= strBgColor %> WIDTH="70">&nbsp;</TD>
			<TD NOWRAP<%= strBgColor %> WIDTH="135">&nbsp;</TD>
<%
	End If
%>
			<TD NOWRAP<%= strBgColor %> ALIGN="center" WIDTH="40"><%= IIf(vntCompFlag(i)="1", "��", "&nbsp;") %></td>
			<TD NOWRAP<%= strBgColor %> WIDTH="100"><%= IIf(vntCompDayID(i)<>"", objCommon.FormatString(vntCompDayID(i), "0000"), "&nbsp;") %></td>
			<TD NOWRAP<%= strBgColor %> WIDTH="135"><%= vntCompLastName(i) %>�@<%= vntCompFirstName(i) %></TD>
		</TR>
<%
Next
%>
	</TABLE>
</BODY>
</HTML>
