<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �����|�[�g�Ɖ�i���ԑѕʎ�f�ҏ��j  (Ver0.0.1)
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

'���ԑѕʎ�f�ҏ��
Dim vntRsvGrpName		'�\��Q����
Dim vntMaleCount		'�j���l��
Dim vntFemaleCount		'�����l��

Dim lngCount			'���R�[�h����
Dim strBgColor			'�w�i�F
Dim i,j					'�C���f�b�N�X

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

	'���ԑѕʎ�f�ҏ����擾
	lngCount = objMorningReport.SelectRsvFraDaily(	lngCslYear, lngCslMonth, lngCslDay, _
													strCsCd, _
													blnNeedUnReceipt, _
													vntRsvGrpName, _
													vntMaleCount, _
													vntFemaleCount _
													)
	If lngCount < 0 Then
		Err.Raise 1000, , "���ԑѕʎ�f�ҏ�񂪎擾�ł��܂���B�i��f��=" & dtmCslDate & ",�R�[�X�R�[�h=" & strCsCd & ",�����h�c������=" & blnReceptOnly &")"
	End If

Exit Do
Loop
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Adobe GoLive 6">
<TITLE>���ԑѕʎ�f�ҏ��</TITLE>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
</HEAD>
<BODY>
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="0">
<%
For i = 0 To lngCount-1
	If (i Mod 2) = 0 Then
		strBgColor = ""
	Else
		strBgColor = " BGCOLOR=""#e0ffff"""
	End If
%>
		<TR HEIGHT="17">
			<TD NOWRAP ALIGN="lefts"<%= strBgColor %> WIDTH="130"><%= vntRsvGrpName(i) %></TD>
			<TD NOWRAP ALIGN="right"<%= strBgColor %> WIDTH="40"><%= vntMaleCount(i) %></TD>
			<TD NOWRAP ALIGN="right"<%= strBgColor %> WIDTH="40"><%= vntFemaleCount(i) %></TD>
		</TR>
<%
Next
%>
	</TABLE>
</BODY>
</HTML>
