<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �������ʕ\���^�C�v�R�`�X�V���[�h  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/editCsGrp.inc" -->
<!-- #include virtual = "/webHains/includes/interviewResult.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
'Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objInterView		'�ʐڏ��A�N�Z�X�p
Dim objResult			'�������ʃA�N�Z�X�pCOM�I�u�W�F�N�g

'�p�����[�^
Dim strAction			'�������(�ۑ��{�^��������:"save"�A�ۑ�������:"saveend")
Dim strGrpNo			'�O���[�vNo
Dim	strWinMode			'�E�B���h�E���[�h
Dim lngRsvNo			'�\��ԍ��i���񕪁j
Dim strCsCd				'�R�[�X�R�[�h

Dim lngLastDspMode		'�O���\�����[�h�i0:���ׂāA1:����R�[�X�A2:�C�ӎw��j
Dim vntCsGrp			'�O���\�����[�h��0:null ��1:�R�[�X�R�[�h ��2:�R�[�X�O���[�v�R�[�h
Dim vntPerId			'�l�h�c
Dim vntRsvNo			'�\��ԍ�
Dim vntCslDate			'��f��
Dim vntCsCd				'�R�[�X�R�[�h
Dim vntCsName			'�R�[�X��
Dim vntCsSName			'�R�[�X����
Dim lngHisCount			'�\����
Dim i					'�C���f�b�N�X

'�������ʏ��
Dim vntRsvNo1			'�\��ԍ�
Dim vntItemCd			'�������ڃR�[�h
Dim vntSuffix			'�T�t�B�b�N�X
Dim vntResult			'��������
Dim vntRslCmtCd1		'���ʃR�����g�P
Dim vntRslCmtCd2		'���ʃR�����g�Q
Dim vntUpdFlg			'�X�V�t���O

'���ۂɍX�V���鍀�ڏ����i�[������������
Dim vntUpdItemCd		'�������ڃR�[�h
Dim vntUpdSuffix		'�T�t�B�b�N�X
Dim vntUpdResult		'��������
Dim vntUpdRslCmtCd1		'���ʃR�����g�P
Dim vntUpdRslCmtCd2		'���ʃR�����g�Q
Dim lngUpdCount			'�X�V���ڐ�
Dim strArrMessage		'�G���[���b�Z�[�W

Dim strUpdUser			'�X�V��
Dim strIPAddress		'IP�A�h���X

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objInterView	= Server.CreateObject("HainsInterView.InterView")

'�����l�̎擾
strAction			= Request("act")
strWinMode			= Request("winmode")
strGrpNO			= Request("grpno")
lngRsvNo			= Request("rsvno")
strCsCd				= Request("cscd")
strSelCsGrp			= Request("csgrp")
strSelCsGrp			= IIf(strSelCsGrp="", "0", strSelCsGrp)
lngEntryMode		= Request("entrymode")
lngEntryMode		= IIf(lngEntryMode="", INTERVIEWRESULT_REFER, lngEntryMode)
lngHideFlg			= Request("hideflg")
lngHideFlg			= IIf(lngHideFlg="", "1", lngHideFlg)

'�������ʏ��
vntItemCd			= ConvIStringToArray(Request("itemcd"))
vntSuffix			= ConvIStringToArray(Request("suffix"))
vntResult			= ConvIStringToArray(Request("stccd"))
vntRslCmtCd1		= ConvIStringToArray(Request("cmtcd1"))
vntRslCmtCd2		= ConvIStringToArray(Request("cmtcd2"))
vntUpdFlg			= ConvIStringToArray(Request("updflg"))
'�O���[�v���擾
Call GetMenResultGrpInfo(strGrpNo)

Select Case strSelCsGrp
	'���ׂẴR�[�X
	Case "0"
		lngLastDspMode = 0
		vntCsGrp = ""
	'����R�[�X
	Case "1"
		lngLastDspMode = 1
		vntCsGrp = strCsCd
	Case Else
		lngLastDspMode = 2
		vntCsGrp = strSelCsGrp
End Select

Do	
	'�ۑ�
	If strAction = "save" Then

		lngUpdCount = 0
		vntUpdItemCd = Array()
		vntUpdSuffix = Array()
		vntUpdResult = Array()
		vntUpdRslCmtCd1 = Array()
		vntUpdRslCmtCd2 = Array()

		'���ۂɍX�V���s�����ڂ݂̂𒊏o
		For i = 0 To UBound(vntUpdFlg)
			If vntUpdFlg(i) = "1" Then
				ReDim Preserve vntUpdItemCd(lngUpdCount)
				ReDim Preserve vntUpdSuffix(lngUpdCount)
				ReDim Preserve vntUpdResult(lngUpdCount)
				ReDim Preserve vntUpdRslCmtCd1(lngUpdCount)
				ReDim Preserve vntUpdRslCmtCd2(lngUpdCount)
				vntUpdItemCd(lngUpdCount) = vntItemCd(i)
				vntUpdSuffix(lngUpdCount) = vntSuffix(i)
				vntUpdResult(lngUpdCount) = vntResult(i)
				vntUpdRslCmtCd1(lngUpdCount) = vntRslCmtCd1(i)
				vntUpdRslCmtCd2(lngUpdCount) = vntRslCmtCd2(i)
				lngUpdCount = lngUpdCount + 1
			End If
		Next

		If lngUpdCount > 0 Then
			'�X�V�҂̐ݒ�
			strUpdUser = Session("USERID")
			'IP�A�h���X�̎擾
			strIPAddress = Request.ServerVariables("REMOTE_ADDR")

			'�I�u�W�F�N�g�̃C���X�^���X�쐬
			Set objResult  = Server.CreateObject("HainsResult.Result")

			'�������ʍX�V
'			strArrMessage = objResult.UpdateRsl_tk( _
'								strUpdUser, _
'								strIPAddress, _
'								lngRsvNo, _
'								vntUpdItemCd, _
'								vntUpdSuffix, _
'								vntUpdResult, _
'								vntUpdRslCmtCd1, _
'								vntUpdRslCmtCd2 _
'								)
			objResult.UpdateResult lngRsvNo, strIPAddress, strUpdUser, vntUpdItemCd, vntUpdSuffix, vntUpdResult, vntUpdRslCmtCd1, vntUpdRslCmtCd2, strArrMessage
			If Not IsEmpty(strArrMessage) Then
				Exit Do
			End If

			'�I�u�W�F�N�g�̃C���X�^���X�폜
			Set objResult = Nothing

			'�ۑ�����
			strAction = "saveend"
		Else
			strAction = ""
		End If
	End If

	'�w�肳�ꂽ�l�h�c�̎�f���ꗗ���擾����
	lngHisCount = objInterView.SelectConsultHistory( _
						lngRsvNo, _
						False, _
						lngLastDspMode, _
						vntCsGrp, _
						3, _
						0, _
						vntPerId, _
						vntRsvNo, _
						vntCslDate, _
						vntCsCd, _
						vntCsName, _
						vntCsSName _
						)
	If lngHisCount < 1 Then
		Err.Raise 1000, , "��f�����擾�ł��܂���B�i�\��ԍ� = " & lngRsvNo & ")"
	End If

Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�������ʕ\��</TITLE>
<SCRIPT TYPE="text/JavaScript">
<!-- #include virtual = "/webHains/includes/interviewSentence.inc" -->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/mensetsutable.css">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<!-- �����l -->
	<INPUT TYPE="hidden" NAME="act"       VALUE="<%= strAction %>">
	<INPUT TYPE="hidden" NAME="winmode"   VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="grpno"     VALUE="<%= strGrpNo %>">
	<INPUT TYPE="hidden" NAME="rsvno"     VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="cscd"      VALUE="<%= strCsCd %>">
	<INPUT TYPE="hidden" NAME="entrymode" VALUE="<%= lngEntryMode %>">
	<INPUT TYPE="hidden" NAME="hideflg"   VALUE="<%= lngHideFlg %>">
<%
	'���b�Z�[�W�̕ҏW
	If strAction <> "" Then

		'�ۑ��������́u�ۑ������v�̒ʒm
		If strAction = "saveend" Then
			Call EditMessage("�ۑ����������܂����B", MESSAGETYPE_NORMAL)

		'�����Ȃ��΃G���[���b�Z�[�W��ҏW
		Else
			Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
		End If

	End If
%>

	<!-- �������ʂ̈ꗗ�\�� -->
<%
	Call EditMenResultTable3( lngHisCount, vntRsvNo, lngRsvNo, strMenResultGrpCd3, lngLastDspMode, vntCsGrp )
%>
</FORM>
</BODY>
</HTML>
