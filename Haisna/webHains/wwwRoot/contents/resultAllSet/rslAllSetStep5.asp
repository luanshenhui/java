<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		���ʈꊇ����(��O�ғ���) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const STDFLG_H = "H"		'�ُ�i��j
Const STDFLG_U = "U"		'�y�x�ُ�i��j
Const STDFLG_D = "D"		'�y�x�ُ�i���j
Const STDFLG_L = "L"		'�ُ�i���j
Const STDFLG_T1 = "*"		'�萫�l�ُ�
Const STDFLG_T2 = "@"		'�萫�l�y�x�ُ�

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objConsult		'��f���A�N�Z�X�pCOM�I�u�W�F�N�g
Dim objResult		'�������ʃA�N�Z�X�pCOM�I�u�W�F�N�g
Dim objCommon		'���ʊ֐��A�N�Z�X�pCOM�I�u�W�F�N�g

'�����l
Dim strAction		'�������(�ۑ��{�^��������"save"�A�ۑ�������"saveend")
Dim strDate			'��f��
Dim strGrpCd		'�����O���[�v�R�[�h
Dim lngCount		'���R�[�h����
Dim strRsvNo		'�\��ԍ�

'��f�ҏ��
Dim strPerId		'�l�h�c
Dim strCslDate		'��f��
Dim strCsCd			'�R�[�X�R�[�h
Dim strCsName		'�R�[�X��
Dim strLastName		'��
Dim strFirstName	'��
Dim strLastKName	'�J�i��
Dim strFirstKName	'�J�i��
Dim strBirth		'���N����
Dim strAge			'�N��
Dim strGender		'����
Dim strGenderName	'���ʖ���
Dim strDayId		'�����h�c

'�������ʏ��
Dim strRslRsvNo		'�\��ԍ�
Dim strRslName		'����
Dim strConsultFlg	'��f���ڃt���O
Dim strItemCd		'�������ڃR�[�h
Dim strSuffix		'�T�t�B�b�N�X
Dim strItemName		'�������ږ���
Dim strResult		'��������
Dim strResultType	'���ʃ^�C�v
Dim strItemType		'���ڃ^�C�v
Dim strStcItemCd	'���͎Q�Ɨp���ڃR�[�h
Dim strShortStc		'���͗���
Dim strStdFlg		'��l�t���O
Dim strInitRsl		'�����ǂݍ��ݏ�Ԃ̌���
Dim lngItemCount	'���R�[�h����

'���ۂɍX�V���鍀�ڏ����i�[������������
Dim strUpdRsvNo			'�\��ԍ�
Dim strUpdItemCd		'�������ڃR�[�h
Dim strUpdSuffix		'�T�t�B�b�N�X
Dim strUpdResult		'��������
Dim lngUpdCount			'�X�V���ڐ�

'���ʓ��̓`�F�b�N�p
Dim strResultErr		'�������ʃG���[

Dim strArrMessage		'�G���[���b�Z�[�W
Dim i					'�C���f�b�N�X

'�\���F
Dim strH_Color			'��l�t���O�F�i�g�j
Dim strU_Color			'��l�t���O�F�i�t�j
Dim strD_Color			'��l�t���O�F�i�c�j
Dim strL_Color			'��l�t���O�F�i�k�j
Dim strT1_Color			'��l�t���O�F�i���j
Dim strT2_Color			'��l�t���O�F�i���j

Dim strUpdUser			'�X�V��
Dim strIPAddress		'IPAddress

Dim lngChkIndex()		'�������ڃR�[�h
Dim strChkItemCd()		'�������ڃR�[�h
Dim strChkSuffix()		'�T�t�B�b�N�X
Dim strChkResult()		'��������
Dim strChkShortStc()	'���͗���
Dim strChkResultErr()	'�������ʃG���[
Dim lngChkCount			'�`�F�b�N���ڐ�
Dim j					'�C���f�b�N�X
Dim strPrevRsvNo		'���O���R�[�h�̗\��ԍ�
Dim strPrevRslName		'���O���R�[�h�̎���
Dim strArrMessage2		'���b�Z�[�W
Dim lngMsgCount			'���b�Z�[�W��

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�X�V�҂̐ݒ�
strUpdUser = Session("USERID")

'IP�A�h���X�̎擾
strIPAddress = Request.ServerVariables("REMOTE_ADDR")

'�����l�̎擾
strAction			= Request("act")
strDate				= CDate(Request("date"))
strGrpCd			= Request("grpCd")
lngCount			= CLng("0" & Request("count"))
strRsvNo			= ConvIStringToArray(Request("rsvNo"))

'��f�ҏ��
strPerId			= ConvIStringToArray(Request("perID"))
strCslDate			= ConvIStringToArray(Request("cslDate"))
strCsCd				= ConvIStringToArray(Request("csCd"))
strCsName			= ConvIStringToArray(Request("csName"))
strLastName			= ConvIStringToArray(Request("lastName"))
strFirstName		= ConvIStringToArray(Request("firstName"))
strLastKName		= ConvIStringToArray(Request("lastKName"))
strFirstKName		= ConvIStringToArray(Request("firstKName"))
strBirth			= ConvIStringToArray(Request("birth"))
strAge				= ConvIStringToArray(Request("age"))
strGender			= ConvIStringToArray(Request("gender"))
strGenderName		= ConvIStringToArray(Request("genderName"))
strDayId			= ConvIStringToArray(Request("dayID"))

'�������ʏ��
strRslRsvNo			= ConvIStringToArray(Request("rslRsvNo"))
strRslName			= ConvIStringToArray(Request("rslName"))
strConsultFlg		= ConvIStringToArray(Request("consultFlg"))
strItemCd			= ConvIStringToArray(Request("itemCd"))
strSuffix			= ConvIStringToArray(Request("suffix"))
strItemName			= ConvIStringToArray(Request("itemName"))
strResult			= ConvIStringToArray(Request("result"))
strResultType		= ConvIStringToArray(Request("resultType"))
strItemType			= ConvIStringToArray(Request("itemType"))
strStcItemCd		= ConvIStringToArray(Request("stcItemCd"))
strShortStc			= ConvIStringToArray(Request("shortStc"))
strStdFlg			= ConvIStringToArray(Request("stdFlg"))
strInitRsl			= ConvIStringToArray(Request("initRsl"))
lngItemCount		= CLng("0" & Request("itemCount"))

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon = Server.CreateObject("HainsCommon.Common")

'��l�t���O�F�擾
objCommon.SelectStdFlgColor "H_COLOR", strH_Color
objCommon.SelectStdFlgColor "U_COLOR", strU_Color
objCommon.SelectStdFlgColor "D_COLOR", strD_Color
objCommon.SelectStdFlgColor "L_COLOR", strL_Color
objCommon.SelectStdFlgColor "*_COLOR", strT1_Color
objCommon.SelectStdFlgColor "@_COLOR", strT2_Color

Do
	'�ۑ�����
	If strAction = "save" Then

		'���̓`�F�b�N�p�z��쐬
		ReDim strResultErr(lngItemCount - 1)

		'�I�u�W�F�N�g�̃C���X�^���X�쐬
		Set objResult = Server.CreateObject("HainsResult.Result")

		'���ʓ��̓`�F�b�N
		For i = 0 To UBound(strRslRsvNo)

			'���O���R�[�h�Ɨ\��ԍ����ς�������_�Ń`�F�b�N���s��
			If strPrevRsvNo <> "" And strRslRsvNo(i) <> strPrevRsvNo Then

				'���ʓ��̓`�F�b�N
				strArrMessage2 = objResult.CheckResult(strDate, strChkItemCd, strChkSuffix, strChkResult, strChkShortStc, strChkResultErr)

				'�`�F�b�N���ʂ�߂�
				For j = 0 To lngChkCount - 1
					strResult(lngChkIndex(j))    = strChkResult(j)
					strResultErr(lngChkIndex(j)) = strChkResultErr(j)
					strShortStc(lngChkIndex(j))  = strChkShortStc(j)
				Next

				'�G���[�����݂���ꍇ
				If Not IsEmpty(strArrMessage2) Then

					If IsEmpty(strArrMessage) Then
						strArrMessage = Array()
					End If

					'�G���[���b�Z�[�W��ǉ�
					For j = 0 To UBound(strArrMessage2)
						ReDim Preserve strArrMessage(lngMsgCount)
						strArrMessage(lngMsgCount) = strPrevRslName & "�@" & strArrMessage2(j)
						lngMsgCount = lngMsgCount + 1
					Next

				End If

				'�`�F�b�N�����N���A
				Erase lngChkIndex
				Erase strChkItemCd
				Erase strChkSuffix
				Erase strChkResult
				Erase strChkShortStc
				Erase strChkResultErr
				lngChkCount = 0

			End If

			'�`�F�b�N�����X�^�b�N
			ReDim Preserve lngChkIndex(lngChkCount)
			ReDim Preserve strChkItemCd(lngChkCount)
			ReDim Preserve strChkSuffix(lngChkCount)
			ReDim Preserve strChkResult(lngChkCount)
			ReDim Preserve strChkShortStc(lngChkCount)
			ReDim Preserve strChkResultErr(lngChkCount)
			lngChkIndex(lngChkCount)     = i
			strChkItemCd(lngChkCount)    = strItemCd(i)
			strChkSuffix(lngChkCount)    = strSuffix(i)
			strChkResult(lngChkCount)    = strResult(i)
			strChkShortStc(lngChkCount)  = strShortStc(i)
			strChkResultErr(lngChkCount) = strResultErr(i)
			lngChkCount = lngChkCount + 1

			'�����R�[�h�̗\��ԍ��A������ޔ�
			strPrevRsvNo   = strRslRsvNo(i)
			strPrevRslName = strRslName(i)

		Next

		'�X�^�b�N�c�蕪�̌��ʃ`�F�b�N

		'���ʓ��̓`�F�b�N
		strArrMessage2 = objResult.CheckResult(strDate, strChkItemCd, strChkSuffix, strChkResult, strChkShortStc, strChkResultErr)

		'�`�F�b�N���ʂ�߂�
		For j = 0 To lngChkCount - 1
			strResult(lngChkIndex(j))    = strChkResult(j)
			strResultErr(lngChkIndex(j)) = strChkResultErr(j)
			strShortStc(lngChkIndex(j))  = strChkShortStc(j)
		Next

		'�G���[�����݂���ꍇ
		If Not IsEmpty(strArrMessage2) Then

			If IsEmpty(strArrMessage) Then
				strArrMessage = Array()
			End If

			'�G���[���b�Z�[�W��ǉ�
			For j = 0 To UBound(strArrMessage2)
				ReDim Preserve strArrMessage(lngMsgCount)
				strArrMessage(lngMsgCount) = strPrevRslName & "�@" & strArrMessage2(j)
				lngMsgCount = lngMsgCount + 1
			Next

		End If

		'���̓G���[�̏ꍇ�͉������Ȃ�
		If Not IsEmpty(strArrMessage) Then

			'�I�u�W�F�N�g�̃C���X�^���X�폜
			Set objResult = Nothing

			strAction = "error"

			Exit Do
		End If

		lngUpdCount  = 0
		strUpdRsvNo  = Array()
		strUpdItemCd = Array()
		strUpdSuffix = Array()
		strUpdResult = Array()

		'���ۂɍX�V���s�����ڂ݂̂𒊏o(���ʖ����͂Ń`�F�b�N�Ȃ��̍��ڈȊO���X�V�Ώ�)
		For i = 0 To UBound(strRslRsvNo)

			'���ʂ��X�V����Ă�����f�[�^�X�V
			If strConsultFlg(i) = CStr(CONSULT_ITEM_T) And strResult(i) <> strInitRsl(i) Then
				ReDim Preserve strUpdRsvNo(lngUpdCount)
				ReDim Preserve strUpdItemCd(lngUpdCount)
				ReDim Preserve strUpdSuffix(lngUpdCount)
				ReDim Preserve strUpdResult(lngUpdCount)
				strUpdRsvNo(lngUpdCount)      = strRslRsvNo(i)
				strUpdItemCd(lngUpdCount)     = strItemCd(i)
				strUpdSuffix(lngUpdCount)     = strSuffix(i)
				strUpdResult(lngUpdCount)     = strResult(i)
				lngUpdCount = lngUpdCount + 1
			End If

		Next

		'�������ʍX�V
		If lngUpdCount > 0 Then
			strArrMessage = objResult.UpdateResultList(strUpdUser, strIPAddress, strUpdRsvNo, strUpdItemCd, strUpdSuffix, strUpdResult)
			If Not IsEmpty(strArrMessage) Then

				'�I�u�W�F�N�g�̃C���X�^���X�폜
				Set objResult = Nothing

				strAction = "error"

				Exit Do
			End If
		End If

		'�I�u�W�F�N�g�̃C���X�^���X�폜
		Set objResult = Nothing

		'�ۑ�����
		strAction = "saveend"

	End If

	'��f���i�[�p�z��쐬
	ReDim strPerId(lngCount - 1)
	ReDim strCslDate(lngCount - 1)
	ReDim strCsCd(lngCount - 1)
	ReDim strCsName(lngCount - 1)
	ReDim strLastName(lngCount - 1)
	ReDim strFirstName(lngCount - 1)
	ReDim strLastKName(lngCount - 1)
	ReDim strFirstKName(lngCount - 1)
	ReDim strBirth(lngCount - 1)
	ReDim strAge(lngCount - 1)
	ReDim strGender(lngCount - 1)
	ReDim strGenderName(lngCount - 1)
	ReDim strDayId(lngCount - 1)

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objConsult	= Server.CreateObject("HainsConsult.Consult")

	'�\��ԍ����ƂɎ�f�ҏ����擾����
	lngItemCount = 0
	For i = 0 To lngCount - 1

		'��f���擾
		Call objConsult.SelectConsult(strRsvNo(i), 0, strCslDate(i), strPerId(i), strCsCd(i), strCsName(i), , , , , , _
									  strAge(i), , , , , , , , , , , , , _
									  strDayId(i), , , , , , , , , , , , , , , , , , _
									  strLastName(i), strFirstName(i), strLastKName(i), strFirstKName(i), strBirth(i), strGender(i))

		strGenderName(i) = IIf(CLng(strGender(i)) = GENDER_MALE, "�j��", "����")

		'�����h�c�ҏW
		strDayId(i) = objCommon.FormatString(strDayId(i), "0000")

		'���N�����ҏW
		strBirth(i) = objCommon.FormatString(strBirth(i), "g ee.mm.dd")

		'�������ʎ擾
		Call SelectRsl(strRsvNo(i), strLastName(i), strFirstName(i), strGrpCd)

	Next

	'�I�u�W�F�N�g�̃C���X�^���X�폜
	Set objConsult = Nothing

	Exit Do
Loop

'�I�u�W�F�N�g�̃C���X�^���X�폜
Set objCommon	= Nothing

'-----------------------------------------------------------------------------
' �������ʏ��擾
'-----------------------------------------------------------------------------
Sub SelectRsl(strRsvNo, strLastName, strFirstName ,strGrpCd)

	Dim strArrRslRsvNo()		'�������ʗ\��ԍ�
	Dim strArrConsultFlg()		'��f���ڃt���O
	Dim strArrItemCd()			'�������ڃR�[�h
	Dim strArrSuffix()			'�T�t�B�b�N�X
	Dim strArrItemName()		'�������ږ���
	Dim strArrResult()			'��������
	Dim strArrResultType()		'���ʃ^�C�v
	Dim strArrItemType()		'���ڃ^�C�v
	Dim strArrStcItemCd()		'���͎Q�Ɨp���ڃR�[�h
	Dim strArrShortStc()		'���͗���
	Dim strArrStdFlg()			'��l�t���O

	Dim lngCount				'���R�[�h����

	Dim i						'�C���f�b�N�X

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objResult = Server.CreateObject("HainsResult.Result")

	'�������ʎ擾
	lngCount = objResult.SelectRslAllSetList(strRsvNo, strGrpCd, strArrConsultFlg, strArrItemCd, strArrSuffix, strArrItemName, strArrResult, strArrResultType, strArrItemType, strArrStcItemCd, strArrShortStc, strArrStdFlg)

	'�I�u�W�F�N�g�̃C���X�^���X�폜
	Set objResult = Nothing

	'�������ʔz��֒ǉ�
	For i = 0 To lngCount - 1

		If IsArray(strRslRsvNo) Then

			ReDim Preserve strRslRsvNo(lngItemCount)
			ReDim Preserve strRslName(lngItemCount)
			ReDim Preserve strConsultFlg(lngItemCount)
			ReDim Preserve strItemCd(lngItemCount)
			ReDim Preserve strSuffix(lngItemCount)
			ReDim Preserve strItemName(lngItemCount)
			ReDim Preserve strResult(lngItemCount)
			ReDim Preserve strResultType(lngItemCount)
			ReDim Preserve strItemType(lngItemCount)
			ReDim Preserve strStcItemCd(lngItemCount)
			ReDim Preserve strShortStc(lngItemCount)
			ReDim Preserve strStdFlg(lngItemCount)
			ReDim Preserve strInitRsl(lngItemCount)
			strRslRsvNo(lngItemCount) = strRsvNo
			strRslName(lngItemCount) = strLastName & "�@" & strFirstName
			strConsultFlg(lngItemCount) = strArrConsultFlg(i)
			strItemCd(lngItemCount) = strArrItemCd(i)
			strSuffix(lngItemCount) = strArrSuffix(i)
			strItemName(lngItemCount) = strArrItemName(i)
			strResult(lngItemCount) = strArrResult(i)
			strResultType(lngItemCount) = strArrResultType(i)
			strItemType(lngItemCount) = strArrItemType(i)
			strStcItemCd(lngItemCount) = strArrStcItemCd(i)
			strShortStc(lngItemCount) = strArrShortStc(i)
			strStdFlg(lngItemCount) = strArrStdFlg(i)
			strInitRsl(lngItemCount) = strArrResult(i)

			'���̓G���[�i�[�p�z��ɂ��ǉ�
			ReDim Preserve strResultErr(lngItemCount)

		Else

			strRslRsvNo   = Array(strRsvNo)
			strRslName    = Array(strLastName & "�@" & strFirstName)
			strConsultFlg = Array(strArrConsultFlg(i))
			strItemCd     = Array(strArrItemCd(i))
			strSuffix     = Array(strArrSuffix(i))
			strItemName   = Array(strArrItemName(i))
			strResult     = Array(strArrResult(i))
			strResultType = Array(strArrResultType(i))
			strItemType   = Array(strArrItemType(i))
			strStcItemCd  = Array(strArrStcItemCd(i))
			strShortStc   = Array(strArrShortStc(i))
			strStdFlg     = Array(strArrStdFlg(i))
			strInitRsl    = Array(strArrResult(i))

			'���̓G���[�i�[�p�z��ɂ��ǉ�
			strResultErr = Array("")

		End If

		lngItemCount = lngItemCount + 1
	Next

End Sub

'-----------------------------------------------------------------------------
' �������ځE���ʂ̕ҏW
'-----------------------------------------------------------------------------
Sub EditItemList(strRsvNo)

	Const ALIGNMENT_RIGHT = "STYLE=""text-align:right"""	'�E��
	Const CLASS_ERROR     = "CLASS=""rslErr"""				'�G���[�\���̃N���X�w��

	Dim strArrConsultFlg()	'�ҏW�p��f���ڃt���O
	Dim strArrItemCd()		'�ҏW�p�������ڃR�[�h
	Dim strArrSuffix()		'�ҏW�p�T�t�B�b�N�X
	Dim strArrItemName()	'�ҏW�p�������ږ���
	Dim strArrResultType()	'�ҏW�p���ʃ^�C�v
	Dim strArrItemType()	'�ҏW�p���ڃ^�C�v
	Dim strArrResult()		'�ҏW�p��������
	Dim strArrResultErr()	'�ҏW�p�������ʃG���[
	Dim strArrStcItemCd()	'�ҏW�p���͎Q�Ɨp���ڃR�[�h
	Dim strArrShortStc()	'�ҏW�p���͗���
	Dim strArrStdFlg()		'�ҏW�p��l�t���O
	Dim strArrInitRsl()		'�ҏW�p�����\������
	Dim lngArrPos()			'���ʔz��ʒu

	Dim strOldItemCd		'�ۑ��p�������ڃR�[�h
	Dim strOldSuffix		'�ۑ��p�T�t�B�b�N�X
	Dim strOldItemType		'�ۑ��p���ڃ^�C�v

	Dim strDispStdFlgColor	'�ҏW�p��l�\���F
	Dim strAlignMent		'�\���ʒu

	Dim strClass			'�X�^�C���V�[�g��CLASS�w��
	Dim strClassStdFlg		'��l�X�^�C���V�[�g��CLASS�w��

	Dim strElementName		'�G�������g��

	Dim lngArraySize		'�z��T�C�Y
	Dim i					'�C���f�b�N�X

	If lngItemCount = 0 Then
		Exit Sub
	End If

	'�z���\���p�ɍĕҏW
	lngArraySize = 0
	For i = 0 To lngItemCount - 1
		Do
			If strRslRsvNo(i) <> strRsvNo Then
				Exit Do
			End If
			'�ŏ��̏���
			If strOldItemCd = "" Then
				'�ҏW�p�z��쐬
				ReDim strArrConsultFlg(1, lngArraySize)
				ReDim strArrItemCd(1, lngArraySize)
				ReDim strArrSuffix(1, lngArraySize)
				ReDim strArrItemName(lngArraySize)
				ReDim strArrResultType(1, lngArraySize)
				ReDim strArrItemType(1, lngArraySize)
				ReDim strArrResult(1, lngArraySize)
				ReDim strArrResultErr(1, lngArraySize)
				ReDim strArrStcItemCd(1, lngArraySize)
				ReDim strArrShortStc(1, lngArraySize)
				ReDim strArrStdFlg(1, lngArraySize)
				ReDim strArrInitRsl(1, lngArraySize)
				ReDim lngArrPos(1, lngArraySize)
				lngArraySize = lngArraySize + 1
				'�������ڕۑ�
				strOldItemCd = strItemCd(i)
				strOldItemType = strItemType(i)
				'���ʂ̏ꍇ
				If CStr(strItemType(i)) = CStr(ITEMTYPE_BUI) Then
					strArrConsultFlg(0, lngArraySize - 1) = strConsultFlg(i)
					strArrItemCd(0, lngArraySize - 1) = strItemCd(i)
					strArrSuffix(0, lngArraySize - 1) = strSuffix(i)
					strArrResultType(0, lngArraySize - 1) = strResultType(i)
					strArrItemType(0, lngArraySize - 1) = strItemType(i)
					strArrResult(0, lngArraySize - 1) = strResult(i)
					strArrResultErr(0, lngArraySize - 1) = strResultErr(i)
					strArrStcItemCd(0, lngArraySize - 1) = strStcItemCd(i)
					strArrShortStc(0, lngArraySize - 1) = strShortStc(i)
					strArrStdFlg(0, lngArraySize - 1) = strStdFlg(i)
					strArrInitRsl(0, lngArraySize - 1) = strInitRsl(i)
					lngArrPos(0, lngArraySize -1) = i
				Else
					strArrConsultFlg(1, lngArraySize - 1) = strConsultFlg(i)
					strArrItemCd(1, lngArraySize - 1) = strItemCd(i)
					strArrSuffix(1, lngArraySize - 1) = strSuffix(i)
					strArrResultType(1, lngArraySize - 1) = strResultType(i)
					strArrItemType(1, lngArraySize - 1) = strItemType(i)
					strArrResult(1, lngArraySize - 1) = strResult(i)
					strArrResultErr(1, lngArraySize - 1) = strResultErr(i)
					strArrStcItemCd(1, lngArraySize - 1) = strStcItemCd(i)
					strArrShortStc(1, lngArraySize - 1) = strShortStc(i)
					strArrStdFlg(1, lngArraySize - 1) = strStdFlg(i)
					strArrInitRsl(1, lngArraySize - 1) = strInitRsl(i)
					lngArrPos(1, lngArraySize -1) = i
				End If
				strArrItemName(lngArraySize - 1) = strItemName(i)
			Else
				'�O���ڂƍ��ڃR�[�h����v���A�O���ڃ^�C�v���h���ʁh�ō����ڃ^�C�v���h�����h�̏ꍇ
				If strOldItemCd = strItemCd(i) And CStr(strOldItemType) = CStr(ITEMTYPE_BUI) And CStr(strItemType(i)) = CStr(ITEMTYPE_SHOKEN) Then
					strArrConsultFlg(1, lngArraySize - 1) = strConsultFlg(i)
					strArrItemCd(1, lngArraySize - 1) = strItemCd(i)
					strArrSuffix(1, lngArraySize - 1) = strSuffix(i)
					strArrResultType(1, lngArraySize - 1) = strResultType(i)
					strArrItemType(1, lngArraySize - 1) = strItemType(i)
					strArrResult(1, lngArraySize - 1) = strResult(i)
					strArrResultErr(1, lngArraySize - 1) = strResultErr(i)
					strArrStcItemCd(1, lngArraySize - 1) = strStcItemCd(i)
					strArrShortStc(1, lngArraySize - 1) = strShortStc(i)
					strArrStdFlg(1, lngArraySize - 1) = strStdFlg(i)
					strArrInitRsl(1, lngArraySize - 1) = strInitRsl(i)
					lngArrPos(1, lngArraySize -1) = i
					strArrItemName(lngArraySize - 1) = strItemName(i)
				Else
					'�ҏW�p�z��쐬
					ReDim Preserve strArrConsultFlg(1, lngArraySize)
					ReDim Preserve strArrItemCd(1, lngArraySize)
					ReDim Preserve strArrSuffix(1, lngArraySize)
					ReDim Preserve strArrItemName(lngArraySize)
					ReDim Preserve strArrResultType(1, lngArraySize)
					ReDim Preserve strArrItemType(1, lngArraySize)
					ReDim Preserve strArrResult(1, lngArraySize)
					ReDim Preserve strArrResultErr(1, lngArraySize)
					ReDim Preserve strArrStcItemCd(1, lngArraySize)
					ReDim Preserve strArrShortStc(1, lngArraySize)
					ReDim Preserve strArrStdFlg(1, lngArraySize)
					ReDim Preserve strArrInitRsl(1, lngArraySize)
					ReDim Preserve lngArrPos(1, lngArraySize)
					lngArraySize = lngArraySize + 1
					'���ʂ̏ꍇ
					If CStr(strItemType(i)) = CStr(ITEMTYPE_BUI) Then
						strArrConsultFlg(0, lngArraySize - 1) = strConsultFlg(i)
						strArrItemCd(0, lngArraySize - 1) = strItemCd(i)
						strArrSuffix(0, lngArraySize - 1) = strSuffix(i)
						strArrResultType(0, lngArraySize - 1) = strResultType(i)
						strArrItemType(0, lngArraySize - 1) = strItemType(i)
						strArrResult(0, lngArraySize - 1) = strResult(i)
						strArrResultErr(0, lngArraySize - 1) = strResultErr(i)
						strArrStcItemCd(0, lngArraySize - 1) = strStcItemCd(i)
						strArrShortStc(0, lngArraySize - 1) = strShortStc(i)
						strArrStdFlg(0, lngArraySize - 1) = strStdFlg(i)
						strArrInitRsl(0, lngArraySize - 1) = strInitRsl(i)
						lngArrPos(0, lngArraySize - 1) = i
					Else
						strArrConsultFlg(1, lngArraySize - 1) = strConsultFlg(i)
						strArrItemCd(1, lngArraySize - 1) = strItemCd(i)
						strArrSuffix(1, lngArraySize - 1) = strSuffix(i)
						strArrResultType(1, lngArraySize - 1) = strResultType(i)
						strArrItemType(1, lngArraySize - 1) = strItemType(i)
						strArrResult(1, lngArraySize - 1) = strResult(i)
						strArrResultErr(1, lngArraySize - 1) = strResultErr(i)
						strArrStcItemCd(1, lngArraySize - 1) = strStcItemCd(i)
						strArrShortStc(1, lngArraySize - 1) = strShortStc(i)
						strArrStdFlg(1, lngArraySize - 1) = strStdFlg(i)
						strArrInitRsl(1, lngArraySize - 1) = strInitRsl(i)
						lngArrPos(1, lngArraySize -1) = i
					End If
					strArrItemName(lngArraySize - 1) = strItemName(i)
				End If
				'�������ڕۑ�
				strOldItemCd = strItemCd(i)
				strOldItemType = strItemType(i)
			End If
			Exit Do
		Loop
	Next

	For i = 0 To lngArraySize - 1
%>
		<TR>
			<TD NOWRAP ALIGN="right"><%= strArrItemName(i) %></TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPAGING="0">
					<TR>
<%
						'���ʌ��ʃK�C�h�{�^���̕ҏW
						If strArrItemCd(0, i) <> "" And CStr(strArrConsultFlg(0, i)) = CStr(CONSULT_ITEM_T) Then

							Select Case strArrResultType(0, i)

								Case CStr(RESULTTYPE_SENTENCE)
%>
									<TD><A HREF="JavaScript:callStcGuide('<%= lngArrPos(0, i) %>','0','<%= CStr(i) %>')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�������ʃK�C�h�\��"></A></TD>
<%
								Case CStr(RESULTTYPE_TEISEI1), CStr(RESULTTYPE_TEISEI2)
%>
									<TD><A HREF="JavaScript:callTseGuide('<%= lngArrPos(0, i) %>')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�������ʃK�C�h�\��"></A></TD>
<%
								Case Else
%>
									<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="21"></TD>
<%
							End Select

						Else
%>
							<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="21"></TD>
<%
						End If

						'���ʌ��ʂ̕ҏW

						'��l�t���O�ɂ��F��ݒ肷��
						Select Case strArrStdFlg(0, i)
							Case STDFLG_H
								strDispStdFlgColor = strH_Color
							Case STDFLG_U
								strDispStdFlgColor = strU_Color
							Case STDFLG_D
								strDispStdFlgColor = strD_Color
							Case STDFLG_L
								strDispStdFlgColor = strL_Color
							Case STDFLG_T1
								strDispStdFlgColor = strT1_Color
							Case STDFLG_T2
								strDispStdFlgColor = strT2_Color
							Case Else
								strDispStdFlgColor = ""
						End Select

						If strArrResultErr(0, i) <> "" Then
							strClass       = CLASS_ERROR
							strClassStdFlg = ""
						Else
							strClass       = ""
							strClassStdFlg = IIf(strDispStdFlgColor <> "", "STYLE=""color:" & strDispStdFlgColor & """", "")
						End If
%>
						<TD>
<%
							Do
								'���ڎ��̂����݂��Ȃ���Ή������Ȃ�
								If strArrItemCd(0, i) = "" Then
									Exit Do
								End If

								'����f�̏ꍇ
								If CStr(strArrConsultFlg(0, i)) = CStr(CONSULT_ITEM_F) Then
%>
									<INPUT TYPE="hidden" NAME="stdFlg"  VALUE="<%= strArrStdFlg(0, i)  %>">
									<INPUT TYPE="hidden" NAME="initRsl" VALUE="<%= strArrInitRsl(0, i) %>">
									<INPUT TYPE="hidden" NAME="result"  VALUE="<%= strArrResult(0, i)  %>">
<%
									Exit Do
								End If

								'�v�Z���ڂ̏ꍇ
								If CStr(strArrResultType(0, i)) = CStr(RESULTTYPE_CALC) Then
%>
									<INPUT TYPE="hidden" NAME="stdFlg"  VALUE="<%= strArrStdFlg(0, i)  %>">
									<INPUT TYPE="hidden" NAME="initRsl" VALUE="<%= strArrInitRsl(0, i) %>">
									<INPUT TYPE="hidden" NAME="result"  VALUE="<%= strArrResult(0, i)  %>">
									<SPAN <%= strClassStdFlg %> <%= ALIGNMENT_RIGHT %>"><%= strArrResult(0, i) %></SPAN>
<%
									Exit Do
								End If

								'����ȊO

								'�X�^�C���V�[�g�̐ݒ�
								strAlignment = IIf(CLng(strArrResultType(0, i)) = RESULTTYPE_NUMERIC, ALIGNMENT_RIGHT, "")
%>
								<INPUT TYPE="hidden" NAME="stdFlg"  VALUE="<%= strArrStdFlg(0, i)  %>">
								<INPUT TYPE="hidden" NAME="initRsl" VALUE="<%= strArrInitRsl(0, i) %>">
								<INPUT TYPE="text" NAME="result" SIZE="10" MAXLENGTH="8" VALUE="<%= strArrResult(0, i) %>" <%= strAlignment %> <%= strClass %> <%= strClassStdFlg %>>
<%
								Exit Do
							Loop
%>
						</TD>
					</TR>
				</TABLE>
			</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPAGING="0">
					<TR>
<%
						'�������ʃK�C�h�{�^���̕ҏW
						If strArrItemCd(1, i) <> "" And CStr(strArrConsultFlg(1, i)) = CStr(CONSULT_ITEM_T) Then

							Select Case strArrResultType(1, i)

								Case CStr(RESULTTYPE_SENTENCE)
%>
									<TD><A HREF="JavaScript:callStcGuide('<%= lngArrPos(1, i) %>','1','<%= CStr(i) %>')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�������ʃK�C�h�\��"></A></TD>
<%
								Case CStr(RESULTTYPE_TEISEI1), CStr(RESULTTYPE_TEISEI2)
%>
									<TD><A HREF="JavaScript:callTseGuide('<%= lngArrPos(1, i) %>')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�������ʃK�C�h�\��"></A></TD>
<%
								Case Else
%>
									<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="21"></TD>
<%
							End Select

						Else
%>
							<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="21"></TD>
<%
						End If

						'�������ʂ̕ҏW

						'��l�t���O�ɂ��F��ݒ肷��
						Select Case strArrStdFlg(1, i)
							Case STDFLG_H
								strDispStdFlgColor = strH_Color
							Case STDFLG_U
								strDispStdFlgColor = strU_Color
							Case STDFLG_D
								strDispStdFlgColor = strD_Color
							Case STDFLG_L
								strDispStdFlgColor = strL_Color
							Case STDFLG_T1
								strDispStdFlgColor = strT1_Color
							Case STDFLG_T2
								strDispStdFlgColor = strT2_Color
							Case Else
								strDispStdFlgColor = ""
						End Select

						If strArrResultErr(1, i) <> "" Then
							strClass       = CLASS_ERROR
							strClassStdFlg = ""
						Else
							strClass       = ""
							strClassStdFlg = IIf(strDispStdFlgColor <> "", "STYLE=""color:" & strDispStdFlgColor & """", "")
						End If
%>
						<TD>
<%
							Do
								'���ڎ��̂����݂��Ȃ���Ή������Ȃ�
								If strArrItemCd(1, i) = "" Then
									Exit Do
								End If

								'����f�̏ꍇ
								If CStr(strArrConsultFlg(1, i)) = CStr(CONSULT_ITEM_F) Then
%>
									<INPUT TYPE="hidden" NAME="stdFlg"  VALUE="<%= strArrStdFlg(1, i)  %>">
									<INPUT TYPE="hidden" NAME="initRsl" VALUE="<%= strArrInitRsl(1, i) %>">
									<INPUT TYPE="hidden" NAME="result"  VALUE="<%= strArrResult(1, i)  %>">
<%
									Exit Do
								End If

								'�v�Z���ڂ̏ꍇ
								If CStr(strArrResultType(1, i)) = CStr(RESULTTYPE_CALC) Then
%>
									<INPUT TYPE="hidden" NAME="stdFlg"  VALUE="<%= strArrStdFlg(1, i)  %>">
									<INPUT TYPE="hidden" NAME="initRsl" VALUE="<%= strArrInitRsl(1, i) %>">
									<INPUT TYPE="hidden" NAME="result"  VALUE="<%= strArrResult(1, i)  %>">
									<SPAN <%= strClassStdFlg %>><%= strArrResult(1, i) %></SPAN>
<%
									Exit Do
								End If

								'����ȊO

								'�X�^�C���V�[�g�̐ݒ�
								strAlignment = IIf(CLng(strArrResultType(1, i)) = RESULTTYPE_NUMERIC, ALIGNMENT_RIGHT, "")
%>
								<INPUT TYPE="hidden" NAME="stdFlg"  VALUE="<%= strArrStdFlg(1, i)  %>">
								<INPUT TYPE="hidden" NAME="initRsl" VALUE="<%= strArrInitRsl(1, i) %>">
								<INPUT TYPE="text" NAME="result" SIZE="10" MAXLENGTH="8" VALUE="<%= strArrResult(1, i) %>" <%= strAlignment %> <%= strClass %> <%= strClassStdFlg %>>
<%
								Exit Do
							Loop
%>
						</TD>
					</TR>
				</TABLE>
			</TD>
<%
			strElementName = "stcName_0" & lngArrPos(0, i)
%>
			<TD WIDTH="181" NOWRAP><SPAN ID="<%= strElementName %>" STYLE="position:relative"><%= strArrShortStc(0, i) %></SPAN></TD>
<%
			strElementName = "stcName_1" & lngArrPos(1, i)
%>
			<TD WIDTH="181" NOWRAP><SPAN ID="<%= strElementName %>" STYLE="position:relative"><%= strArrShortStc(1, i) %></SPAN></TD>
		</TR>
<%
	Next

End Sub

'-----------------------------------------------------------------------------
' ��f���ҏW�iyyyy�Nmm��dd�� �`��)
'-----------------------------------------------------------------------------
Function EditCslDate(cslDate)

	Dim objCommon		'���ʊ֐��A�N�Z�X�pCOM�I�u�W�F�N�g

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	EditCslDate = objCommon.FormatString(cslDate, "yyyy�Nmm��dd��")

	'�I�u�W�F�N�g�̃C���X�^���X�폜
	Set objCommon = Nothing

End Function

'-----------------------------------------------------------------------------
' �����O���[�v���ҏW
'-----------------------------------------------------------------------------
Function EditGrpName(grpCd)

	Dim objGrp			'�O���[�v�A�N�Z�X�pCOM�I�u�W�F�N�g
	Dim strGrpName		'�O���[�v��

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objGrp = Server.CreateObject("HainsGrp.Grp")

	Call objGrp.SelectGrp_P(grpCd, strGrpName)

	'�I�u�W�F�N�g�̃C���X�^���X�폜
	Set objGrp = Nothing

	EditGrpName = strGrpName

End Function

'-----------------------------------------------------------------------------
' �������ʕҏW
'-----------------------------------------------------------------------------
Sub EditRslList()

	Dim i				'�C���f�b�N�X

%>
	<INPUT TYPE="hidden" NAME="itemCount" VALUE="<%= lngItemCount %>">
<%
	For i = 0 To lngItemCount - 1
%>
		<INPUT TYPE="hidden" NAME="rslRsvNo"   VALUE="<%= strRslRsvNo(i)   %>">
		<INPUT TYPE="hidden" NAME="rslName"    VALUE="<%= strRslName(i)    %>">
		<INPUT TYPE="hidden" NAME="consultFlg" VALUE="<%= strConsultFlg(i) %>">
		<INPUT TYPE="hidden" NAME="itemCd"     VALUE="<%= strItemCd(i)     %>">
		<INPUT TYPE="hidden" NAME="suffix"     VALUE="<%= strSuffix(i)     %>">
		<INPUT TYPE="hidden" NAME="itemName"   VALUE="<%= strItemName(i)   %>">
		<INPUT TYPE="hidden" NAME="resultType" VALUE="<%= strResultType(i) %>">
		<INPUT TYPE="hidden" NAME="itemType"   VALUE="<%= strItemType(i)   %>">
		<INPUT TYPE="hidden" NAME="stcItemCd"  VALUE="<%= strStcItemCd(i)  %>">
		<INPUT TYPE="hidden" NAME="shortStc"   VALUE="<%= strShortStc(i)   %>">
<%
	Next

	For i = 0 To lngCount - 1
%>
		<INPUT TYPE="hidden" NAME="perID"      VALUE="<%= strPerId(i)      %>">
		<INPUT TYPE="hidden" NAME="cslDate"    VALUE="<%= strCslDate(i)    %>">
		<INPUT TYPE="hidden" NAME="csCd"       VALUE="<%= strCsCd(i)       %>">
		<INPUT TYPE="hidden" NAME="csName"     VALUE="<%= strCsName(i)     %>">
		<INPUT TYPE="hidden" NAME="lastName"   VALUE="<%= strLastName(i)   %>">
		<INPUT TYPE="hidden" NAME="firstName"  VALUE="<%= strFirstName(i)  %>">
		<INPUT TYPE="hidden" NAME="lastKName"  VALUE="<%= strLastKName(i)  %>">
		<INPUT TYPE="hidden" NAME="firstKName" VALUE="<%= strFirstKName(i) %>">
		<INPUT TYPE="hidden" NAME="birth"      VALUE="<%= strBirth(i)      %>">
		<INPUT TYPE="hidden" NAME="age"        VALUE="<%= strAge(i)        %>">
		<INPUT TYPE="hidden" NAME="gender"     VALUE="<%= strGender(i)     %>">
		<INPUT TYPE="hidden" NAME="genderName" VALUE="<%= strGenderName(i) %>">
		<INPUT TYPE="hidden" NAME="dayID"      VALUE="<%= strDayId(i)      %>">

		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
			<TR VALIGN="top">
				<TD>
					<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
						<TR BGCOLOR="#eeeeee">
							<TD NOWRAP><B>�����h�c</B></TD>
						</TR>
						<TR>
							<TD><%= strDayId(i) %></TD>
						</TR>
					</TABLE>
				</TD>
				<TD>
					<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
						<TR BGCOLOR="#eeeeee">
							<TD COLSPAN="2"><B>����</B></TD>
						</TR>
						<TR>
							<TD><%= strPerID(i) %></TD>
							<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="200" HEIGHT="1"><BR><B><%= strLastName(i) & "�@" & strFirstName(i) %></B></TD>
						</TR>
						<TR>
							<TD></TD>
							<TD><%= strBirth(i) %>��&nbsp;<%= strAge(i) %>��&nbsp;<%= strGenderName(i) %></TD>
						</TR>
						<TR>
							<TD NOWRAP>��f�R�[�X�F</TD>
							<TD><FONT COLOR="#FF6600"><B><%= strCsName(i) %></B></FONT></TD>
						</TR>
					</TABLE>
				</TD>
				<TD>
					<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="1">
						<TR BGCOLOR="#eeeeee">
							<TD ALIGN="right"><B>�������ږ�</B></TD>
							<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="90" HEIGHT="1"><BR><B>����</B></TD>
							<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="90" HEIGHT="1"><BR><B>����</B></TD>
							<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1"><BR><B>���ʕ���</B></TD>
							<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1"><BR><B>��������</B></TD>
						</TR>
<%
						'�������ʕҏW
						Call EditItemList(strRsvNo(i))
%>
					</TABLE>
				</TD>
<%
				'��؂��
				If i <> lngCount - 1 Then
%>
					<TR>
						<TD HEIGHT="5"></TD>
					</TR>
					<TR>
						<TD BGCOLOR="#999999" COLSPAN="3"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1"></TD>
					</TR>
					<TR>
						<TD HEIGHT="5"></TD>
					</TR>
<%
				End If
%>
			</TR>
		</TABLE>
<%
	Next

	Response.Flush

End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>��O�ғ���</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!-- #include virtual = "/webHains/includes/stcGuide.inc" -->
<!-- #include virtual = "/webHains/includes/tseGuide.inc" -->
<!--
var lngSelectedIndex1;	// �K�C�h�\�����ɑI�����ꂽ�G�������g�̃C���f�b�N�X
var lngSelectedIndex2;	// �K�C�h�\�����ɑI�����ꂽ�G�������g�̃C���f�b�N�X
var lngSelectedIndex3;	// �K�C�h�\�����ɑI�����ꂽ�G�������g�̃C���f�b�N�X

// ���̓K�C�h�Ăяo��
function callStcGuide( index1, index2, index3 ) {

	// �I�����ꂽ�G�������g�̃C���f�b�N�X��ޔ�(���̓R�[�h�E�����͂̃Z�b�g�p�֐��ɂĎg�p����)
	lngSelectedIndex1 = index1;
	lngSelectedIndex2 = index2;
	lngSelectedIndex3 = index3;

	// �K�C�h��ʂ̘A����Ɍ������ڃR�[�h��ݒ肷��
	if ( document.step5.stcItemCd.length != null ) {
		stcGuide_ItemCd = document.step5.stcItemCd[ index1 ].value;
	} else {
		stcGuide_ItemCd = document.step5.stcItemCd.value;
	}

	// �K�C�h��ʂ̘A����ɍ��ڃ^�C�v�i�W���j��ݒ肷��
	if ( document.step5.itemType.length != null ) {
		stcGuide_ItemType = document.step5.itemType[ index1 ].value;
	} else {
		stcGuide_ItemType = document.step5.itemType.value;
	}

	// �K�C�h��ʂ̘A����ɃK�C�h��ʂ���Ăяo����鎩��ʂ̊֐���ݒ肷��
	stcGuide_CalledFunction = setStcInfo;

	// ���̓K�C�h�\��
	showGuideStc();
}

// ���̓R�[�h�E�����͂̃Z�b�g
function setStcInfo() {

	var stcNameElement; /* �����͂�ҏW����G�������g�̖��� */
	var stcName;        /* �����͂�ҏW����G�������g���g */

	// �\�ߑޔ������C���f�b�N�X��̃G�������g�ɁA�K�C�h��ʂŐݒ肳�ꂽ�A����̒l��ҏW
	if ( document.step5.result.length != null ) {
		document.step5.result[lngSelectedIndex1].value = stcGuide_StcCd;
	} else {
		document.step5.result.value = stcGuide_StcCd;
	}
	if ( document.step5.shortStc.length != null ) {
		document.step5.shortStc[lngSelectedIndex1].value = stcGuide_ShortStc;
	} else {
		document.step5.shortStc.value = stcGuide_ShortStc;
	}

	// �u���E�U���Ƃ̒c�̖��ҏW�p�G�������g�̐ݒ菈��
	for ( ; ; ) {

		// �G�������g���̕ҏW
//		stcNameElement = 'stcName_' + lngSelectedIndex2 + lngSelectedIndex3;
		stcNameElement = 'stcName_' + lngSelectedIndex2 + lngSelectedIndex1;

		// IE�̏ꍇ
		if ( document.all ) {
			document.all(stcNameElement).innerHTML = stcGuide_ShortStc;
			break;
		}

		// Netscape6�̏ꍇ
		if ( document.getElementById ) {
			document.getElementById(stcNameElement).innerHTML = stcGuide_ShortStc;
		}

		break;
	}

	return false;
}

// �萫�K�C�h�Ăяo��
function callTseGuide( index1 ) {

	// �I�����ꂽ�G�������g�̃C���f�b�N�X��ޔ�(�������ʂ̃Z�b�g�p�֐��ɂĎg�p����)
	lngSelectedIndex1 = index1;

	// �K�C�h��ʂ̘A����Ɍ��ʃ^�C�v��ݒ肷��
	if ( document.step5.itemType.length != null ) {
		tseGuide_ResultType = document.step5.resultType[ index1 ].value;
	} else {
		tseGuide_ResultType = document.step5.resultType.value;
	}

	// �K�C�h��ʂ̘A����ɃK�C�h��ʂ���Ăяo����鎩��ʂ̊֐���ݒ肷��
	tseGuide_CalledFunction = setTseInfo;

	// ���̓K�C�h�\��
	showGuideTse();
}

// �������ʂ̃Z�b�g
function setTseInfo() {

	// �\�ߑޔ������C���f�b�N�X��̃G�������g�ɁA�K�C�h��ʂŐݒ肳�ꂽ�A����̒l��ҏW
	if ( document.step5.result.length != null ) {
		document.step5.result[lngSelectedIndex1].value = tseGuide_Result;
	} else {
		document.step5.result.value = tseGuide_Result;
	}

	return false;
}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.rsltab  { background-color:#FFFFFF }
</STYLE>
</HEAD>

<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="step5" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="act" VALUE="save">

	<!-- �O���(Step4)����̈��p����� -->

	<INPUT TYPE="hidden" NAME="date"  VALUE="<%= strDate %>">
	<INPUT TYPE="hidden" NAME="grpCd" VALUE="<%= strGrpCd %>">
	<INPUT TYPE="hidden" NAME="count" VALUE="<%= lngCount %>">
<%
	For i = 0 To lngCount - 1
%>
		<INPUT TYPE="hidden" NAME="rsvNo" VALUE="<%= strRsvNo(i) %>">
<%
	Next
%>
	<!-- �\�� -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">Step5�F��O�҂̌��ʓ���</FONT></B></TD>
		</TR>
	</TABLE>
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
		<BR>
		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="635">
			<TR>
				<TD NOWRAP>��f��</TD>
				<TD>�F</TD>
				<TD NOWRAP><FONT COLOR="#FF6600"><B><%= EditCslDate(strDate) %></B></FONT></TD>
				<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1"></TD>
				<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1"></TD>
				<TD NOWRAP>���͗p�������ڃZ�b�g</TD>
				<TD>�F</TD>
				<TD NOWRAP><FONT COLOR="#FF6600"><B><%= EditGrpName(strGrpCd) %></B></FONT></TD>
				<TD WIDTH="100%" ALIGN="right"><A HREF="javascript:function voi(){};voi()" ONCLICK="document.step5.submit();return false;"><INPUT TYPE="image" NAME="save" SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="�ۑ�"></A></TD>
			</TR>
		</TABLE>
		<BR>

		<!-- �������ʕҏW -->
		<% Call EditRslList %>
		
	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
