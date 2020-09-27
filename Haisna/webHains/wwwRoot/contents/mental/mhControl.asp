<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�����^���w���X�@���䏈��(Ver0.0.1)
'		AUTHER  : S.Sugie@C's
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!--#INCLUDE VIRTUAL="/webhains/includes/mental/mhCommon.inc"-->
<%
'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objConsult		'��f���A�N�Z�X�p
Dim objResult		'�l���A�N�Z�X�p
Dim objMentalHealth '�����^���w���X���A�N�Z�X�p

Dim i
Dim lngLockDiv
Dim lngMHCount
Dim lngCount
Dim strTarget		'��ʑJ�ڐ�
Dim arrQuestion()	'�S���⍀�ږ�
Dim arrAnswer()		'�S��
Dim strErrMsg1
Dim strErrMsg2

'�O��ʂ��瑗�M�����p�����[�^�l
Dim strCntlNo		'�Ǘ��ԍ�
Dim dtmCslDate		'��f��
Dim strDayId 		'�����h�c
Dim intLoginDiv		'���O�C���敪

'�N���C�A���g���
Dim lngRsvNo		'�\��ԍ�
Dim strPerID		'�lID
Dim strLastName		'��
Dim strFirstName	'��
Dim dtmBirth		'���N����
Dim lngGender		'����
Dim intBMIValue		'�얞�l
Dim intWeight		'�̏d

Dim strItemCd
Dim strResult
Dim emp1,emp2,emp3,emp4,emp5,emp6,emp7,emp8,emp9,emp10,emp11,emp12,emp13,emp14,emp15

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objConsult = Server.CreateObject("HainsConsult.Consult")
Set objResult = Server.CreateObject("HainsResult.Result")
Set objMentalHealth = Server.CreateObject("HainsMentalHealth.MentalHealth")

'�p�����[�^�l�擾
intLoginDiv = Request("LOGINKBN")

Do

	If intLoginDiv = 0 Then
		'�N���C�A���g���O�C��
		strDayId  = Trim(Request("DAYID"))
		strCntlNo = Trim(Request("CNTLNO"))
		dtmCslDate = Trim(Request("CSLDATE"))
		strTarget = "mhConsulItem1.asp"

		'��f���E�Ǘ��ԍ��E����ID�����Ƃɗ\��ԍ����擾����
		'�����h�c�`�F�b�N
		If Len(strDayId) <> 4 Then
			strErrMsg1 = "�����h�c������������܂���"
			strErrMsg2 = "�ēx�A���O�C�����s�Ȃ��Ă�������"
			Exit Do
		End If
		'�Ǘ��ԍ��`�F�b�N
		If IsNull(strCntlNo) Or strCntlNo = "" Then
			'"0"�Œ�
			strCntlNo = 0
		End If

		'��f���`�F�b�N
		If IsNull(dtmCslDate) Or dtmCslDate = "" Then
			'�V�X�e�����t���Z�b�g
			dtmCslDate = FormatDateTime(Now(), vbShortDate)
		End If

		'��f���E�Ǘ��ԍ��E����ID�����Ƃɗ\��ԍ����擾����
		If objConsult.SelectConsultFromReceipt(dtmCslDate, strCntlNo, strDayId, lngRsvNo, , strPerID, strLastName, strFirstName, , ,dtmBirth, lngGender) = False Then
			strErrMsg1 = "�\��ԍ��̎擾�Ɏ��s���܂���"
			strErrMsg2 = "�\���󂠂�܂��񂪁A�T�|�[�g�S���҂܂ł��A����������"
			Exit Do
		End If

		'�N���C�A���g���b�N�敪�擾
		lngLockDiv = objMentalHealth.SelectClientPermission(lngRsvNo)
		If lngLockDiv < 0 Then
			strErrMsg1 = "�N���C�A���g���b�N���̎擾�Ɏ��s���܂���"
			strErrMsg2 = "�\���󂠂�܂��񂪁A�T�|�[�g�S���҂܂ł��A����������"
			Exit Do
		ElseIf lngLockDiv = 2 And intLoginDiv = 0 Then
			strErrMsg1 = "���݁A�����^���w���X�����Q�ƁE�ύX���邱�Ƃ͂ł��܂���"
			strErrMsg2 = "�����^���w���X�����Q�ƁE�ύX�������ꍇ�́A�S����ɂ����k��������"
			Exit Do
		End If
	Else
		'�h�N�^�[���O�C��
		strTarget = "mhResult.asp"
		lngRsvNo = CLng(Request("RSVNO"))

		'�\��ԍ������ƂɌl�����擾����
		If objMentalHealth.SelectPersonInfo(lngRsvNo,strPerID,strLastName,strFirstName,dtmBirth,lngGender) = False Then
			strErrMsg1 = "�N���C�A���g���̎擾�Ɏ��s���܂���"
			strErrMsg2 = "�\���󂠂�܂��񂪁A�T�|�[�g�S���҂܂ł��A����������"
			Exit Do
		End If
	End If


	'�\��ԍ������ƂɃ����^���w���X�����擾����
	lngMHCount = objMentalHealth.SelectMentalHealth(lngRsvNo, arrQuestion, arrAnswer)
	If lngMHCount < 0 Then
		strErrMsg1 = "�����^���w���X���̎擾�Ɏ��s���܂���"
		strErrMsg2 = "�\���󂠂�܂��񂪁A�T�|�[�g�S���҂܂ł��A����������"
		Exit Do
	ElseIf lngMHCount = 0 And intLoginDiv = 1 Then
		strErrMsg1 = "�N���C�A���g�̓��͂��I�����Ă��Ȃ��ׁA�����^���w���X�����Q�ƁE�ύX���邱�Ƃ͂ł��܂���"
		strErrMsg2 = "�N���C�A���g�̓��͂��I�����Ă���A�ēx�A���O�C�����s�Ȃ��Ă�������"
		Exit Do
	End If

	'�̏d�E�얞�l�擾
	intWeight = 0
	intBMIValue = 0
	lngCount = objResult.SelectRslList("", lngRsvNo, "Z100",emp1,emp2,emp3,strItemCd,emp4,emp5,strResult,emp6,emp7,emp8,emp9,emp10,emp11,emp12,emp13,emp14,emp15)

	If lngCount < 0 Then
		'�G���[
		strErrMsg1 = "�N���C�A���g���(�̏d�E�a�l�h)�̎擾�Ɏ��s���܂���"
		strErrMsg2 = "�\���󂠂�܂��񂪁A�T�|�[�g�S���҂܂ł��A����������"
		Exit Do
	End If

	For i = 0 To lngCount - 1
		'�̏d�E�얞�l�Z�b�g
		If strItemCd(i) = "001011" Then
			If IsNumeric(strResult(i)) Then
				intWeight = CDbl(strResult(i))
			Else
				strErrMsg1 = "�g���E�̏d���Ɍv�����Ă�������"
				strErrMsg2 = ""
				Exit Do
			End If
		ElseIf strItemCd(i) = "001014" Then
			If IsNumeric(strResult(i)) Then
				intBMIValue = CDbl(strResult(i))
			Else
				strErrMsg1 = "�g���E�̏d���Ɍv�����Ă�������"
				strErrMsg2 = ""
				Exit Do
			End If
		End If
	Next

	If intWeight = 0 Then
		strErrMsg1 = "�g���E�̏d���Ɍv�����Ă�������"
		strErrMsg2 = ""
		Exit Do
	End If

	If intBMIValue = 0 Then
		strErrMsg1 = "�g���E�̏d���Ɍv�����Ă�������"
		strErrMsg2 = ""
		Exit Do
	End If

	'�����Z�b�V�������N���A
	If ClearSession() = False Then
	End if

	'�Z�b�V�����ɃZ�b�g
	Session("LoginDiv") = intLoginDiv
	Session("RsvNo") = lngRsvNo
	Session("PerID") = strPerID
	Session("LastName") = strLastName
	Session("FirstName") = strFirstName
	Session("Gender") = lngGender
	Session("Birth") = dtmBirth
	Session("Weight") = intWeight
	Session("BMI") = intBMIValue

	For i = 0 To lngMHCount - 1
		Session(arrQuestion(i)) = arrAnswer(i)
	Next

	Response.Redirect strTarget & "?RSVNO=" & lngRsvNo
	Exit Do
Loop

'�G���[��ʕ\��
Session("ErrorMsg1") = strErrMsg1
Session("ErrorMsg2") = strErrMsg2
Response.Redirect "mhError.asp"
%>
