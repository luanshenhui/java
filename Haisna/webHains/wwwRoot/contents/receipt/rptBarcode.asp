<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�o�[�R�[�h��t (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const FREECD_BCDRPT_FECES = "BCDRPTFECES"	'�ėp�R�[�h(�֌��̎�t���)
Const FREECD_BCDRPT_URINE = "BCDRPTURINE"	'�ėp�R�[�h(�A���̎�t���)

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon		'���ʃN���X
Dim objConsult		'��f���A�N�Z�X�p
Dim objFree			'�ėp���A�N�Z�X�p
Dim objItem			'�������ڏ��A�N�Z�X�p
Dim objResult		'���ʏ��A�N�Z�X�p

'�����l
Dim strKey			'�o�[�R�[�h�l
Dim strRsvNo		'�\��ԍ�
Dim strStatus		'���
Dim strActMode		'���샂�[�h
Dim strResult		'���̎��Q���
DIm strCtrPtCd		'�폜���ꂽ���_�ł̌_��p�^�[���R�[�h
DIm strDelOptCd		'�폜���ꂽ�I�v�V�����R�[�h
Dim strSaveEnd		'���̎��Q��񂪕ۑ����ꂽ�ꍇ��"1"

'�o�[�R�[�h���
Dim strKeyCslDate	'��f�N����
Dim strKeyCsCd		'�R�[�X�R�[�h
Dim strKeyDiv		'�敪
Dim strKeyPerId		'�l�h�c

'��f���
Dim strCslDate		'��f�N����
Dim strPerId		'�l�h�c
Dim strCsCd			'�R�[�X�R�[�h
Dim strCsName		'�R�[�X��
Dim strAge			'��f���N��
Dim strDayId		'�����h�c
Dim strOrgSName		'�c�̗���
Dim strUpdDate		'(��t����)�X�V����
Dim strLastName		'��
Dim strFirstName	'��
Dim strLastKName	'�J�i��
Dim strFirstKName	'�J�i��
Dim strBirth		'���N����
Dim strGender		'����

'�T�u�R�[�X���
Dim strSubCsName	'�T�u�R�[�X��
Dim lngCount		'���R�[�h��

'���̎�t���
Dim strItemCd(1)	'�������ڃR�[�h
Dim strSuffix(1)	'�T�t�B�b�N�X
Dim strItemName(1)	'�������ږ�
Dim strResultOn(1)	'���Q���̌�������
Dim strResultOff(1)	'�����Q���̌�������
Dim strCode(1)		'�������ו��ރR�[�h(�ւ̏ꍇ)�܂��͌������ڃR�[�h(�A�̏ꍇ)
'## 2003.08.18 Add 1Line By T.Takagi@FSIT �ւ̃I�v�V���������݂��Ȃ��ꍇ�A�ւ̌������ڃR�[�h�ň������߂̐ݒ�
Dim strFecesItemCd	'�֌������ڃR�[�h
'## 2003.08.18 Add End

Dim lngRsvNo		'�\��ԍ�
Dim lngStatus		'���

Dim strGetResult	'��������
Dim strChecked		'�`�F�b�N���
Dim strMessage		'�G���[���b�Z�[�W
Dim strURL			'�W�����v���URL
Dim strUpdUser		'�X�V��
Dim strBuffer		'������o�b�t�@
Dim strSubject		'����
Dim blnExistsResult	'�˗��̗L��
Dim Ret				'�֐��߂�l
Dim Ret2			'�֐��߂�l
Dim i				'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objConsult = Server.CreateObject("HainsConsult.Consult")
Set objFree    = Server.CreateObject("HainsFree.Free")
Set objItem    = Server.CreateObject("HainsItem.Item")
Set objResult  = Server.CreateObject("HainsResult.Result")

'�֌��̎�t���̓ǂݍ���
objFree.SelectFree 0, FREECD_BCDRPT_FECES, , , , strItemCd(0), strSuffix(0), strResultOn(0), strResultOff(0), strCode(0), , , strFecesItemCd

'�֌��̌������ڂ̓ǂݍ���
If strItemCd(0) <> "" And strSuffix(0) <> "" Then
	objItem.SelectItemName strItemCd(0), strSuffix(0), strItemName(0)
End If

'�A���̎�t���̓ǂݍ���
objFree.SelectFree 0, FREECD_BCDRPT_URINE, , , , strItemCd(1), strSuffix(1), strResultOn(1), strResultOff(1), strCode(1)

'�A���̌������ڂ̓ǂݍ���
If strCode(1) <> "" Then
	objItem.SelectItem_P strCode(1), strItemName(1)
End If

'�X�V�҂̐ݒ�
strUpdUser = Session("USERID")

'�����l�̎擾
strKey      = Request("key")
strRsvNo    = Request("rsvNo")
strStatus   = Request("status")
strActMode  = Request("act")
strCtrPtCd  = Request("ctrPtCd")
strDelOptCd = Request("delOptCd")
strSaveEnd  = Request("saveEnd")

'���̎��Q���`�F�b�N��Ԃ̎擾
strResult = ConvIStringToArray(Request("result"))

'���̎�t���̕ۑ����w�肳�ꂽ�ꍇ
If strActMode <> "" Then

	'���̎��Q���̍X�V
	lngStatus = UpdateResult(strRsvNo, strResult, strCtrPtCd, strDelOptCd)

	'�\��ԍ��A�X�e�[�^�X(�\��ԍ�)�t����URL���쐬
	strURL = Request.ServerVariables("SCRIPT_NAME")
	strURL = strURL & "?rsvNo="   & strRsvNo
	strURL = strURL & "&status="  & lngStatus

	'���펞�͏I���ʒm�ƍ폜���ꂽ�I�v�V�����R�[�h�Ƃ̂��̌_��p�^�[�����X�ɒǉ�
	If lngStatus > 0 Then
		strURL = strURL & "&ctrPtCd="  & strCtrPtCd
		strURL = strURL & "&delOptCd=" & strDelOptCd
		strURL = strURL & "&saveEnd="  & "1"
	End If

	'���_�C���N�g
	Response.Redirect strURL
	Response.End

End If

'�o�[�R�[�h�l�����݂���ꍇ
If strKey <> "" Then

	'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
	Do

		'�o�[�R�[�h���������f���̗\��ԍ����擾
		Ret = objConsult.GetRsvNoFromBarCode(strKey)

		'�o�[�R�[�h�����񂪕s���ȏꍇ
		If Ret < 0 Then
			lngStatus = -99
			Exit Do
		End If

		'��f��񂪑��݂��Ȃ��ꍇ
		If Ret = 0 Then
			lngStatus = 0
			Exit Do
		End If

		'�\��ԍ����擾
		lngRsvNo = Ret

		'�V�X�e�����t�Ŏ�t�������s��(�������ԃ��[�h��)
		'(�����ŋN���肤��G���[�͎��̂Ƃ���)
		'-1  �w���f���ɓ����f�ҁA�R�[�X�̎�f��񂪑���(�^�p��قƂ�ǗL�蓾�Ȃ�)
		'-2  ���łɃL�����Z���ς݂ł���
		'-11 ���łɎ�t�ς݂ł���
		'-14 ���ԉ\�ȍő�ԍ����𒴂���(�^�p��قƂ�ǗL�蓾�Ȃ�)
		'-15 ��f��񂪕ۗ���
		'-21 �_����ԊO�̎�f�����w�肳�ꂽ(�^�p�゠�܂�L�蓾�Ȃ�)
		'-22 ����f���N��Ǝw���f�����_�ł̔N��قȂ�(�^�p��قƂ�ǗL�蓾�Ȃ�)
		'-30 �g���

		Ret2 = objConsult.Receipt(lngRsvNo, Year(Date), Month(Date), Day(Date), strUpdUser, 1, 0, 0, Request.ServerVariables("REMOTE_ADDR"), strMessage)

		'����ȏꍇ
		If Ret2 > 0 Then

			'��ԂƂ��ė\��ԍ���ݒ肷��
			lngStatus = lngRsvNo

			'���̎��Q���̃`�F�b�N��Ԃ͂��ׂāu���Q�v�Ƃ���
			strResult = Array()
			Redim Preserve strResult(1)
			strResult(0) = "1"
			strResult(1) = "1"

			'���̎��Q���̍X�V
			InsertResult lngRsvNo, strResult

			Exit Do
		End If

		'���\�b�h�ɂăG���[�R�[�h���Ԃ��ꂽ�ꍇ�A��L�G���[�ȊO�͋N���肦�Ȃ����A�O�̂���
		Select Case Ret2
			Case -1, -2, -11, -14, -15, -21, -22, -30
				lngStatus = Ret2
			Case Else
				Err.Raise, 1000, , strMessage
		End Select

		Exit Do
	Loop

	'�\��ԍ��A�X�e�[�^�X(�\��ԍ�)�t����URL�Ń��_�C���N�g
	strURL = Request.ServerVariables("SCRIPT_NAME")
	strURL = strURL & "?rsvNo="  & lngRsvNo
	strURL = strURL & "&status=" & lngStatus
	Response.Redirect strURL
	Response.End

End If

Do

	'��Ԃ����݂��Ȃ��ꍇ
	If strStatus = "" Then
		strMessage = "�o�[�R�[�h��ǂݍ��܂��Ă��������B"
		Exit Do
	End If

	'�ē����b�Z�[�W�̕ҏW
	Select Case CLng(strStatus)
		Case 0
			strMessage = "��f��񂪑��݂��܂���B"
		Case -1
			strMessage = "�w�肳�ꂽ�l�̎�f��񂪖{�����łɑ��݂��܂��B"
		Case -2
			strMessage = "���̎�f���̓L�����Z������Ă��܂��B"
		Case -11
			strMessage = "���łɎ�t�ς݂ł��B"
		Case -14
			strMessage = "����ȏ㓖���h�c�̔��Ԃ��ł��܂���B"
		Case -15
			strMessage = "���̎�f���͌��ݕۗ����ł��B"
		Case -21
			strMessage = "�{�����_�ł��̎�f���̌_��͗L���ł���܂���B"
		Case -22
			strMessage = "�{�����_�ł̔N��\�񎞂ƈقȂ邽�߁A<BR>��f�I�v�V���������ɕύX����������\��������܂��B"
		Case -30
			strMessage = "�󂫗\��g������܂���B"
		Case -81
			strMessage = "�_���񂪕ύX���ꂽ���ߕۑ��ł��܂���B"
		Case -82
			strMessage = "�֐����I�v�V�������������݂��Ȃ����ߕۑ��ł��܂���B"
		Case -99
			strMessage = "�o�[�R�[�h�̒l������������܂���B"
		Case Else
			strMessage = "�o�[�R�[�h��ǂݍ��܂��Ă��������B"
	End Select

	Exit Do
Loop

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���̎��Q���̍X�V
'
' �����@�@ : (In)     lngRsvNo          �\��ԍ�
' �@�@�@�@   (In)     strCheckedResult  ���̎��Q���̃`�F�b�N���("":�˗��Ȃ��A"0":�����Q�A"1":���Q)
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub InsertResult(lngRsvNo, strCheckedResult)

	Dim strUpdItemCd(0)	'�������ڃR�[�h
	Dim strUpdSuffix(0)	'�T�t�B�b�N�X
	Dim strUpdResult(0)	'��������

	Dim strUpdRslCmtCd1(0)	'���ʃR�����g�R�[�h�P
	Dim strUpdRslCmtCd2(0)	'���ʃR�����g�R�[�h�Q

	Dim i				'�C���f�b�N�X

	For i = 0 To UBound(strItemCd)

		Do

			'�ėp�e�[�u���ݒ�s�����ō��ڏ�񂪑��݂��Ȃ��ꍇ�͉������Ȃ�
			If strItemCd(i) = "" Or strSuffix(i) = "" Or strItemName(i) = "" Then
				Exit Do
			End If

			'�������ו��ނ܂��͌������ڂ��ݒ肳��Ă��Ȃ���Ή������Ȃ�
			If strCode(i) = "" Then
				Exit Do
			End If

			'�`�F�b�N��Ԃ����݂��Ȃ��ꍇ�͉������Ȃ�
			If strCheckedResult(i) = "" Then
				Exit Do
			End If

			'�ւ̏ꍇ
			If i = 0 Then

				'�w�萿�����ו���(���ۂ͕֐���)�̎�f�I�v�V�����������ň˗������邩���`�F�b�N
				'�˗����Ȃ���Ή������Ȃ�
				If objConsult.CheckConsult_O_Isr(lngRsvNo, strCode(i)) = False Then

'## 2003.08.18 Add 4Lines By T.Takagi@FSIT ��f�I�v�V���������݂��Ȃ��ꍇ�͔A�Ɠ���
					'�˗������݂��Ȃ��ꍇ�͔A�Ɠ������A�w�茟�����ڂ������Ń`�F�b�N
					If objConsult.ExistsItem(lngRsvNo, strFecesItemCd) = False Then
						Exit Do
					End If
'## 2003.08.18 Add End

				End If

			'�A�̏ꍇ
			Else

				'�w�茟������(�A����)�������ň˗������邩���`�F�b�N
				If objConsult.ExistsItem(lngRsvNo, strCode(i)) = False Then
					Exit Do
				End If

			End If

			'�X�V�������ʂ̕ҏW
			strUpdItemCd(0) = strItemCd(i)
			strUpdSuffix(0) = strSuffix(i)
			strUpdResult(0) = IIf(strCheckedResult(i) = "1", strResultOn(i), strResultOff(i))

			'���̎��Q�����X�V
			objResult.MergeRsl lngRsvNo, strUpdItemCd, strUpdSuffix, strUpdResult

			Exit Do
		Loop

	Next

End Sub

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���̎��Q���̍X�V
'
' �����@�@ : (In)     lngRsvNo          �\��ԍ�
' �@�@�@�@   (In)     strCheckedResult  ���̎��Q���̃`�F�b�N���("":�˗��Ȃ��A"0":�����Q�A"1":���Q)
' �@�@�@�@   (In/Out) strCtrPtCd        (�֐����̃I�v�V���������폜��)�폜���ꂽ���_�ł̌_��p�^�[���R�[�h
' �@�@�@�@   (In/Out) strDelOptCd       (�֐����̃I�v�V���������폜��)�폜���ꂽ�I�v�V�����R�[�h
'
' �߂�l�@ : �X�e�[�^�X(���펞�͗\��ԍ�)
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function UpdateResult(lngRsvNo, strCheckedResult, strCtrPtCd, strDelOptCd)

	Dim strUpdItemCd(0)		'�������ڃR�[�h
	Dim strUpdSuffix(0)		'�T�t�B�b�N�X
	Dim strUpdResult(0)		'��������

	Dim strUpdRslCmtCd1(0)	'���ʃR�����g�R�[�h�P
	Dim strUpdRslCmtCd2(0)	'���ʃR�����g�R�[�h�Q

	Dim blnExists			'�I�v�V���������̑��ݏ��(�����˗��L��)
	Dim lngStatus			'�X�e�[�^�X
	Dim Ret					'�֐��߂�l
	Dim i					'�C���f�b�N�X

	'��������
	lngStatus = lngRsvNo

	For i = 0 To UBound(strItemCd)

		Do

			'�ėp�e�[�u���ݒ�s�����ō��ڏ�񂪑��݂��Ȃ��ꍇ�͉������Ȃ�
			If strItemCd(i) = "" Or strSuffix(i) = "" Or strItemName(i) = "" Then
				Exit Do
			End If

			'�`�F�b�N��Ԃ����݂��Ȃ��ꍇ�͉������Ȃ�
			If strCheckedResult(i) = "" Then
				Exit Do
			End If

			'�X�V�������ʂ̕ҏW
			strUpdItemCd(0) = strItemCd(i)
			strUpdSuffix(0) = strSuffix(i)
			strUpdResult(0) = IIf(strCheckedResult(i) = "1", strResultOn(i), strResultOff(i))

			'���̎��Q�����X�V
			objResult.MergeRsl lngRsvNo, strUpdItemCd, strUpdSuffix, strUpdResult

			'�A�̏ꍇ�͂����܂�
			If i = 1 Then
				Exit Do
			End If

			'�ւ̏ꍇ

			'�������ו��ނ��ݒ肳��Ă��Ȃ���Ή������Ȃ�
			If strCode(i) = "" Then
				Exit Do
			End If

			'�w�萿�����ו���(���ۂ͕֐���)�̎�f�I�v�V�����������ň˗������邩���`�F�b�N
			blnExists = objConsult.CheckConsult_O_Isr(lngRsvNo, strCode(i))

			'�`�F�b�N��Ԃɂ�鏈������
			Select Case strCheckedResult(i)

				'�`�F�b�N����(���Q)
				Case "1"

					'�˗�������Ή������Ȃ�
					If blnExists Then
						Exit Do
					End If

'## 2003.08.18 Add 5Lines By T.Takagi@FSIT ��f�I�v�V���������݂��Ȃ��ꍇ�͔A�Ɠ���
					'�`�F�b�N�����݂��A���p�^�[���A�I�v�V���������݂��Ȃ��ꍇ�Ƃ����͎̂�f�I�v�V�����ł͂Ȃ��������ڂ̗L���ň˗������f���ꂽ�ꍇ�ɓ������B
					'����Ă��̏ꍇ�A�ȉ��̃I�v�V�����ǉ������͕s�v�B
					If strCtrPtCd = "" Or strDelOptCd = "" Then
						Exit Do
					End If
'## 2003.08.18 Add End

					'�w��I�v�V������ǉ����A��f���̍č쐬���s��
					Ret = objConsult.UpdateConsultWithAddOption(lngRsvNo, strCtrPtCd, strDelOptCd)

					'�G���[��
					If Ret <= 0 Then

						Select Case Ret
							Case 0		'��f��񂪑��݂��Ȃ�
								lngStatus = 0
							Case -2		'�_��p�^�[�����ύX���ꂽ
								lngStatus = -81
							Case -3, -4	'�w��I�v�V�������_��ɂȂ�
								lngStatus = -82
							Case -10	'��f��񂪃L�����Z�����ꂽ
								lngStatus = -3
							Case Else	'��L�ȊO���Ԃ邱�Ƃ͂Ȃ����C�����I��
								Err.Raise, 1000, , "���̎�t���̍X�V�ɂăG���[���������܂����B�i�G���[�R�[�h=" & Ret & "�j"
						End Select

						Exit For
					End If

					'����I�����̓p�^�[���A�I�v�V������ێ�����K�v���Ȃ����ߒl���N���A����
					strCtrPtCd = ""
					strDelOptCd = ""

				'�`�F�b�N�Ȃ�(�����Q)
				Case "0"

					'�˗����Ȃ���Ή������Ȃ�
					If Not blnExists Then
						Exit Do
					End If

					'�w�萿�����ו��ނ̃I�v�V�����������폜���A��f���̍č쐬���s��
					Ret = objConsult.UpdateConsultWithDelOption(lngRsvNo, strCode(i), strCtrPtCd, strDelOptCd)

					'�G���[��
					If Ret <= 0 Then

						Select Case Ret
							Case 0		'��f��񂪑��݂��Ȃ�
								lngStatus = 0
							Case -10	'��f��񂪃L�����Z�����ꂽ
								lngStatus = -3
							Case Else	'��L�ȊO���Ԃ邱�Ƃ͂Ȃ����C�����I��
								Err.Raise, 1000, , "���̎�t���̍X�V�ɂăG���[���������܂����B�i�G���[�R�[�h=" & Ret & "�j"
						End Select

						Exit For
					End If

			End Select

			Exit Do
		Loop

	Next

	UpdateResult = lngStatus

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>��f�Ҏ�t</TITLE>
<!-- #include virtual = "/webHains/includes/printDialog.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
var winCancelReceipt;	// ��t���������

function setFocus() {

	document.entryForm.key.focus();
	document.entryForm.key.value = '';

}

// �`�F�b�N�{�b�N�X�̃`�F�b�N��Ԃ�hidden�֕ҏW
function checkResult( objCheckBox, index ) {

	document.kentai.result[ index ].value = (objCheckBox.checked ? '1' : '0');
	document.entryForm.key.focus();

}

function printAll( rsvNo, cslDate ) {

	document.entryForm.key.focus();

	// ��f�J�[�h����p�̃_�C�A���O�Ăяo��
	showPrintDialog(3, rsvNo, cslDate);

	// ���̃��x������p�̃_�C�A���O�Ăяo��
	showPrintDialog(4, rsvNo);

}

function printCard( rsvNo, cslDate ) {

	document.entryForm.key.focus();

	// ��f�J�[�h����p�̃_�C�A���O�Ăяo��
	showPrintDialog(3, rsvNo, cslDate);

}

function printLabel( rsvNo ) {

	document.entryForm.key.focus();

	// ���̃��x������p�̃_�C�A���O�Ăяo��
	showPrintDialog(4, rsvNo);

}

// ���̎��Q���̕ۑ�����
function saveData() {

	document.kentai.submit();

}

// ��t��������ʌĂяo��
function callCancelReceiptWindow() {

	var opened = false;	// ��ʂ��J����Ă��邩
	var url;			// ��t��������ʂ�URL

	document.entryForm.key.focus();

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winCancelReceipt != null ) {
		if ( !winCancelReceipt.closed ) {
			opened = true;
		}
	}

	// ��t��������ʂ�URL�ҏW
	url = '/webHains/contents/receipt/rptCancel.asp';
	url = url + '?calledFrom=bcd';
	url = url + '&rsvNo=<%= strRsvNo %>';

	// �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winCancelReceipt.focus();
	} else {
		winCancelReceipt = window.open( url, '', 'toolbar=no,directories=no,menubar=no,resizable=no,scrollbars=yes,width=500,height=385' );
	}

}

// �T�u��ʂ����
function closeWindow() {

	// ��t��������ʂ����
	if ( winCancelReceipt != null ) {
		if ( !winCancelReceipt.closed ) {
			winCancelReceipt.close();
		}
	}

	winCancelReceipt = null;

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.rsvtab { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONLOAD="javascript:setFocus()" ONUNLOAD="javascript:closeWindow()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000">��f�Ҏ�t</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>

	<IMG SRC="/webHains/images/barcode.jpg" WIDTH="171" HEIGHT="172" ALIGN="left" ONCLICK="javascript:document.entryForm.key.focus()">
	<IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="320" ALIGN="left">

	<BR>

	<FONT SIZE="6"><%= strMessage %></FONT>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD NOWRAP>BarCode�F</TD>
			<TD><INPUT TYPE="text" NAME="key" SIZE="30" STYLE="ime-mode:disabled"></TD>
		</TR>
	</TABLE>

</FORM>

<FORM NAME="kentai" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<INPUT TYPE="hidden" NAME="act"     VALUE="save">
	<INPUT TYPE="hidden" NAME="rsvNo"   VALUE="<%= strRsvNo  %>">
	<INPUT TYPE="hidden" NAME="status"  VALUE="<%= strStatus %>">
	<INPUT TYPE="hidden" NAME="autoFlg" VALUE="">
<%
	'�\������
	Do

		'�\��ԍ������݂��Ȃ��ꍇ�͉������Ȃ�
		If strRsvNo = "" Then
			Exit Do
		End If

		'��f���ǂݍ���
		objConsult.SelectConsult strRsvNo, ,   _
								 strCslDate,   _
								 strPerId,     _
								 strCsCd,      _
								 strCsName, , , , , , _
								 strAge , , , , , , , , , , , , , _
								 strDayId , , , , , , _
								 strOrgSName , , , , , , , , , , , _
								 strUpdDate,    _
								 strLastName,   _
								 strFirstName,  _
								 strLastKName,  _
								 strFirstKName, _
								 strBirth,      _
								 strGender
%>
<%
		'��t�ς݂̏ꍇ
		If strDayId <> "" Then

			'��t���Ԃ�ҏW����
			strBuffer = objCommon.FormatString(CDate("0" & strUpdDate), "yyyy/m/d hh:nnam/pm") & "&nbsp;" & "��t����"
%>
			<TABLE BORDER="0" CELLPADDING="3" CELLSPACING="0" WIDTH="450">
				<TR>
<%
					'��t�ς݃G���[���������Ă���ꍇ�͋����\��
					If CLng(strStatus) = -4 Then
%>
						<TD NOWRAP><B><FONT COLOR="#ff0000"><%= strBuffer %></FONT></B></TD>
<%
					Else
%>
						<TD NOWRAP><%= strBuffer %></TD>
<%
					End If
%>
					<TD ALIGN="right" NOWRAP>�\��ԍ��F<B><%= strRsvNo %></B></TD>
				</TR>
			</TABLE>
<%
		End If
%>
		<TABLE BORDER="0" CELLPADDING="3" CELLSPACING="0">
			<TR>
				<TD NOWRAP><B><%= strPerId %></B></TD>
				<TD><B><%= strLastName %>&nbsp;<%= strFirstName %></B>�i<%= strLastKName %>&nbsp;<%= strFirstKName %>�j<%= objCommon.FormatString(strBirth, "ge.m.d") %>��&nbsp;<%= strAge %>��&nbsp;<%= IIf(strGender = CStr(GENDER_MALE), "�j��", "����") %></TD>
			</TR>
			<TR>
				<TD ROWSPAN="3"></TD>
				<TD NOWRAP><B><%= strOrgSName %></B></TD>
			</TR>
<%
			strBuffer = ""

			'��f�I�v�V�����Ǘ��������ƂɎ�f�T�u�R�[�X���擾
			lngCount = objConsult.SelectConsult_O_SubCourse(strRsvNo, strSubCsName)

			'���R�[�h�����݂���ꍇ�͑S�T�u�R�[�X����Ǔ_�ŘA��
			If lngCount > 0 Then
				strBuffer = "&nbsp;�i" & Join(strSubCsName, "�A") & "&nbsp;������f�j"
			End If
%>
			<TR>
				<TD NOWRAP><B><%= strCsName %></B></TD>
			</TR>
			<TR>
				<TD><%= strBuffer %></TD>
			</TR>
		</TABLE>

		<BR>
<%
		'�X�e�[�^�X������ȏꍇ�͌��̎�t����ҏW
		If CLng(strStatus) > 0 Or CLng(strStatus) = -4 Then

			blnExistsResult = False
%>
			<TABLE BORDER="0" CELLPADDING="3" CELLSPACING="0">
				<TR>
					<TD NOWRAP><FONT COLOR="#cc9999">��</FONT>���̎�t���</TD>
					<TD><INPUT TYPE="hidden" NAME="ctrPtCd" VALUE="<%= strCtrPtCd %>"><INPUT TYPE="hidden" NAME="delOptCd" VALUE="<%= strDelOptCd %>"></TD>
<%
					For i = 0 To UBound(strItemCd)

						strSubject = IIf(i = 0, "��", "�A")

						Do

							'�e�[�u���ݒ�s���̏ꍇ
							If strItemCd(i) = "" Or strSuffix(i) = "" Then
%>
								<TD NOWRAP><INPUT TYPE="hidden" NAME="result" VALUE=""><FONT COLOR="#999999">�i<%= strSubject %>���Q���ʗp�������ڂ��ėp�e�[�u���ɑ��݂��܂���B�j</FONT></TD>
<%
								Exit Do
							End If

							'�������ڂ����݂��Ȃ��ꍇ
							If strItemName(i) = "" Then
%>
								<TD NOWRAP><INPUT TYPE="hidden" NAME="result" VALUE=""><FONT COLOR="#999999">�i<%= strSubject %>���Q���ʗp�������ڂ��������ڃe�[�u���ɑ��݂��܂���B�j</FONT></TD>
<%
								Exit Do
							End If

							'���̎�t����ǂ�
							strGetResult = ""
							If objResult.SelectRsl(strRsvNo, strItemCd(i), strSuffix(i), strGetResult) = False Then
%>
								<TD NOWRAP><INPUT TYPE="hidden" NAME="result" VALUE=""><FONT COLOR="#999999">�i<%= strSubject %>�˗��Ȃ��j</FONT></TD>
<%
								Exit Do
							End If

							'���R�[�h�����݂���ꍇ�A���ʂ��`�F�b�N���̒l�ƈ�v����ꍇ�̓`�F�b�N����
							strChecked = IIf(strGetResult = strResultOn(i), "CHECKED", "")
%>
							<TD>
								<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
									<TR>
										<TD><INPUT TYPE="hidden" NAME="result" VALUE="<%= IIf(strChecked <> "", "1", "0") %>"><INPUT TYPE="checkbox" <%= strChecked %> ONCLICK="javascript:checkResult(this,<%= i %>)"></TD>
										<TD NOWRAP><%= strSubject %></TD>
									</TR>
								</TABLE>
							</TD>
<%
							blnExistsResult = True
							Exit Do
						Loop

					Next

					'�˗������݂���ꍇ
					If blnExistsResult Then
%>
						<TD>&nbsp;&nbsp;<A HREF="javascript:saveData()"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="���̎�t����ۑ�����"></A></TD>
<%
					End If
%>
				</TR>
			</TABLE>
<%
		End If
%>
		<BR><BR>

		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0" WIDTH="450">
			<TR>
				<TD><A HREF="javascript:callCancelReceiptWindow()"><IMG SRC="/webHains/images/cancelrsv.gif" WIDTH="77" HEIGHT="24" ALT="��t���������܂�"></A></TD>
				<TD WIDTH="100%"></TD>
				<TD><A HREF="<%= Request.ServerVariables("SCRIPT_NAME") %>"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�ǂݍ��݉�ʂɖ߂�܂�"></A></TD>
				<TD WIDTH="10"></TD>
				<TD>
<!--
					<TABLE BORDER="0" CELLPADDING="5" CELLSPACING="0">
						<TR>
							<TD>
								<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999">
									<TR>
<%
										'�\��ڍ׉�ʂ�URL�ҏW
										strURL = "/webHains/contents/reserve/rsvMain.asp"
										strURL = strURL & "?rsvNo=" & strRsvNo
%>
										<TD BGCOLOR="#eeeeee" NOWRAP></TD>
									</TR>
								</TABLE>
							</TD>

						</TR>
					</TABLE>
-->
					<A HREF="<%= strURL %>" TARGET="_blank" ALT="�\����ڍ׉�ʂ��J���܂�"><IMG SRC="/webHains/images/torsv.gif" WIDTH="77" HEIGHT="24" ALT="�\�����"></A>
				</TD>
				<TD WIDTH="10"></TD>
				<TD>
<!--
					<TABLE BORDER="0" CELLPADDING="5" CELLSPACING="0">
						<TR>
-->
<!-- 2003.02.25 Updated by Ishihara@FSIT
							<TD NOWRAP><A HREF="javascript:printLabel('<%= strRsvNo %>')">���̃��x�������</A></TD>
							<TD NOWRAP><A HREF="javascript:printCard('<%= strRsvNo %>','<%= strCslDate %>')">��f�J�[�h�����</A></TD>
							<TD NOWRAP><A HREF="javascript:printAll('<%= strRsvNo %>','<%= strCslDate %>')">���̃��x���Ǝ�f�J�[�h�����</A></TD>
-->
<!--
							<TD>
								<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999">
									<TR>
										<TD BGCOLOR="#eeeeee" NOWRAP><B><A HREF="javascript:printAll('<%= strRsvNo %>','<%= strCslDate %>')">���x���ƃJ�[�h�����</A></B></TD>
									</TR>
								</TABLE>
							</TD>
						</TR>
					</TABLE>
-->
					<A HREF="javascript:printAll('<%= strRsvNo %>','<%= strCslDate %>')"><IMG SRC="/webHains/images/prtlabel.gif" WIDTH="110" HEIGHT="24" ALT="���̃��x���Ǝ�f�J�[�h��������܂�"></A>
				</TD>
			</TR>
		</TABLE>
<%
		Exit Do
	Loop
%>
	</BLOCKQUOTE>

</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>