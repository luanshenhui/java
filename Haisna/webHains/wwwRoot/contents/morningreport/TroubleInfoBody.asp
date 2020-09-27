<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �����|�[�g�Ɖ�i�g���u�����j  (Ver0.0.1)
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
Dim vntSortNo			'�\�����i1:�l�A2:��f���j
Dim vntSeq				'seq
Dim vntPubNoteDivCd		'��f���m�[�g���ރR�[�h
Dim vntPubNoteDivName	'��f���m�[�g���ޖ���
Dim vntDefaultDispKbn	'�\���Ώۋ敪�����l
Dim vntOnlyDispKbn		'�\���Ώۋ敪���΂�
Dim vntDispKbn			'�\���Ώۋ敪
Dim vntUpdDate			'�o�^����
Dim vntUpdUser			'�o�^��
Dim vntUserName			'�o�^�Җ�
Dim vntBoldFlg			'�����敪
Dim vntPubNote			'�m�[�g
Dim vntDispColor		'�\���F
Dim vntCslDate			'��f��
Dim vntDayId			'�����h�c
Dim vntCsName           '�R�[�X��
Dim vntLastName			'��
Dim vntFirstName		'��

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

	'�g���u�������擾
	lngCount = objMorningReport.SelectPubNoteDaily(	lngCslYear, lngCslMonth, lngCslDay, _
													strCsCd, _
													blnNeedUnReceipt, _
													"100", _
													"0", _
													Session("USERID"), _
													vntRsvNo, _
													vntSortNo, _
													vntSeq, _
													vntPubNoteDivCd, _
													vntPubNoteDivName, _
													vntDefaultDispKbn, _
													vntOnlyDispKbn, _
													vntDispKbn, _
													vntUpdDate, _
													vntUpdUser, _
													vntUserName, _
													vntBoldFlg, _
													vntPubNote, _
													vntDispColor, _
													vntCslDate, _
													vntCsName, _
													vntDayID, _
													vntLastName, _
													vntFirstName _
													)
	If lngCount < 0 Then
		Err.Raise 1000, , "�g���u����񂪎擾�ł��܂���B�i��f��=" & dtmCslDate & ",�R�[�X�R�[�h=" & strCsCd & ",�����h�c������=" & blnReceptOnly &")"
	End If

Exit Do
Loop
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Adobe GoLive 6">
<TITLE>�g���u�����</TITLE>
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
			<TD NOWRAP<%= strBgColor %> ALIGN="left" WIDTH="80"><%= IIf(vntDayID(i)<>"", objCommon.FormatString(vntDayID(i), "0000"), "&nbsp;") %></TD>
			<TD NOWRAP<%= strBgColor %> ALIGN="left" WIDTH="150"><%= vntLastName(i) %>�@<%= vntFirstName(i) %></TD>
			<TD NOWRAP<%= strBgColor %> ALIGN="left" WIDTH="360"><%= vntPubNote(i) %></TD>
			<TD NOWRAP<%= strBgColor %> ALIGN="left" WIDTH="140"><%= vntUpdDate(i)  %></TD>
		</TR>
<%
Next
%>
	</TABLE>
</FORM>
</BODY>
</HTML>
