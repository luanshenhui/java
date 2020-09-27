<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �����|�[�g�Ɖ�i�Z�b�g�ʎ�f�ҏ��j  (Ver0.0.1)
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

'�Z�b�g�ʎ�f�ҏ��
Dim vntSetName			'�Z�b�g��
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

	'�Z�b�g�ʎ�f�ҏ����擾
	lngCount = objMorningReport.SelectSetCountDaily(lngCslYear, lngCslMonth, lngCslDay, _
													strCsCd, _
													blnNeedUnReceipt, _
													vntSetName, _
													vntMaleCount, _
													vntFemaleCount _
													)
	If lngCount < 0 Then
		Err.Raise 1000, , "�Z�b�g�ʎ�f�ҏ�񂪎擾�ł��܂���B�i��f��=" & dtmCslDate & ",�R�[�X�R�[�h=" & strCsCd & ",�����h�c������=" & blnReceptOnly &")"
	End If

Exit Do
Loop
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Adobe GoLive 6">
<TITLE>�Z�b�g�ʎ�f�ҏ��</TITLE>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
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
			<TD NOWRAP ALIGN="left"<%= strBgColor %> WIDTH="130"><%= vntSetName(i) %></TD>
			<TD NOWRAP ALIGN="right"<%= strBgColor %> WIDTH="40"><%= vntMaleCount(i) %></TD>
			<TD NOWRAP ALIGN="right"<%= strBgColor %> WIDTH="40"><%= vntFemaleCount(i) %></TD>
		</TR>
<%
Next
%>
	</TABLE>
</FORM>
</BODY>
</HTML>
