<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		��t���� (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objConsult		'��f���A�N�Z�X�p

'�����l
Dim strRsvNo		'�\��ԍ�

'��f���
Dim strCancelFlg	'�L�����Z���t���O
Dim strCslDate		'��f�N����
Dim strPerId		'�l�h�c
Dim strCsCd			'�R�[�X�R�[�h
Dim strDayId		'�����h�c
Dim strCtrPtCd		'�_��p�^�[���R�[�h

Dim strURL			'�W�����v���URL

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objConsult = Server.CreateObject("HainsConsult.Consult")

'�����l�̎擾
strRsvNo = Request("rsvNo")

'��f���ǂݍ���
If objConsult.SelectConsult(strRsvNo,     _
							strCancelFlg, _
							strCslDate,   _
							strPerId,     _
							strCsCd, , , , , , , , , , , , , , , , , , , , _
							strDayId, , , , , , , , , , , , , , , , _
							strCtrPtCd) = False Then
	Err.Raise 1000, , "��f��񂪑��݂��܂���B"
End If

'�L�����Z���҂͎�t�ł��Ȃ�
If CLng("0" & strCancelFlg) <> CONSULT_USED Then
	Err.Raise 1000, , "���̎�f���̓L�����Z������Ă��܂��B"
End If

'����t�̏ꍇ
If strDayId = "" Then

	'��t������ʂ��Ăяo��
	strURL = "rptEntryFromDetail.asp"
	strURL = strURL & "?calledFrom=list"
	strURL = strURL & "&rsvNo="    & strRsvNo
	strURL = strURL & "&perId="    & strPerId
	strURL = strURL & "&csCd="     & strCsCd
	strURL = strURL & "&cslYear="  & Year(CDate(strCslDate))
	strURL = strURL & "&cslMonth=" & Month(CDate(strCslDate))
	strURL = strURL & "&cslDay="   & Day(CDate(strCslDate))
	strURL = strURL & "&ctrPtCd="  & strCtrPtCd

'��t�ς݂̏ꍇ
Else

	'��t��������ʂ��Ăяo��
	strURL = "rptCancel.asp"
	strURL = strURL & "?calledFrom=list"
	strURL = strURL & "&rsvNo=" & strRsvNo

End If

Response.Redirect strURL
%>
