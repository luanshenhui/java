<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�_����(�����Z�b�g�̓o�^) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editJudClassList.inc"     -->
<!-- #include virtual = "/webHains/includes/editJudList.inc"          -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editRsvFraList.inc"       -->
<!-- #include virtual = "/webHains/includes/editSetClassList.inc"     -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const MODE_INSERT          = "INS"	'�������[�h(�}��)
Const MODE_UPDATE          = "UPD"	'�������[�h(�X�V)
Const MODE_COPY            = "COPY"	'�������[�h(�R�s�[)
Const ACTMODE_SAVE         = "save"	'���샂�[�h(�ۑ�)
Const ACTMODE_DELETE       = "del"	'���샂�[�h(�폜)

Const LENGTH_OPTCD         = 4		'�I�v�V�����R�[�h�̍��ڒ�
Const LENGTH_OPTBRANCHNO   = 2		'�I�v�V�����}�Ԃ̍��ڒ�
Const LENGTH_OPTNAME       = 30		'�I�v�V�������̍��ڒ�
Const LENGTH_OPTSNAME      = 20		'�I�v�V�������̂̍��ڒ�

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon				'���ʃN���X
Dim objContract				'�_����A�N�Z�X�p
Dim objContractControl		'�_����A�N�Z�X�p
Dim objFree					'�ėp���A�N�Z�X�p

'�����l�i�_���{���j
Dim strMode					'�������[�h
Dim strActMode				'���샂�[�h
Dim strOrgCd1				'�c�̃R�[�h�P
Dim strOrgCd2				'�c�̃R�[�h�Q
Dim strCtrPtCd				'�_��p�^�[���R�[�h

'�����l�i�I�v�V����������{���j
Dim strOptCd				'�I�v�V�����R�[�h
Dim strOptBranchNo			'�I�v�V�����}��
Dim strOptName				'�I�v�V������
Dim strOptSName				'�I�v�V��������
Dim strSubCsCd				'�i�T�u�j�R�[�X�R�[�h
Dim strSetColor				'�Z�b�g�J���[
Dim strSetClassCd			'�Z�b�g���ރR�[�h
Dim strRsvFraCd				'�\��g�R�[�h

'�����l�i�I�v�V���������Ώۏ����j
Dim strCslDivCd				'��f�敪�R�[�h
Dim lngGender				'��f�\����
Dim strAge					'��f�Ώ۔N��
Dim strLastRefMonth			'�O��l�Q�Ɨp����
Dim strLastRefCsCd			'�O��l�Q�Ɨp�R�[�X�R�[�h
Dim lngAddCondition			'�ǉ�����
Dim strHideRsvFra			'�\��g��ʔ�\��
Dim strHideRsv				'�\���ʔ�\��
Dim strHideRpt				'��t��ʔ�\��
Dim strHideQuestion			'��f��ʔ�\��
Dim strExceptLimit			'���x�z�ݒ菜�O

'�����l�i�������j
Dim strApDiv				'�K�p���敪
Dim strSeq					'SEQ
Dim strBdnOrgCd1			'�c�̃R�[�h1
Dim strBdnOrgCd2			'�c�̃R�[�h2
Dim strArrOrgName			'�c�̖���
Dim strPrice				'���S���z
Dim strTax					'�����
Dim strCtrOrgDiv			'(�_��p�^�[�����S���z�Ǘ��e�[�u�����)�c�̎��
Dim strBillPrintName		'�������o�͖�
Dim strBillPrintEName		'�������p��o�͖�
Dim lngCount				'���S���

'�����l�i��f���ڏ��j
Dim strGrpCd				'�O���[�v�R�[�h�̔z��
Dim strGrpName				'�O���[�v�R�[�h�̔z��
Dim strItemCd				'�˗����ڃR�[�h�̔z��
Dim strRequestName			'�˗����ږ��̔z��

'�_����
Dim strOrgName				'��������
Dim strCsCd					'�R�[�X�R�[�h
Dim strCsName				'�R�[�X��
Dim dtmStrDate				'�_��J�n��
Dim dtmEndDate				'�_��I����

'�_��p�^�[���I�v�V�����Ǘ����ǂݍ��݁^�X�V�p
Dim strStrAge				'��f�ΏۊJ�n�N��
Dim strEndAge				'��f�ΏۏI���N��

'�ėp���
Dim strFreeCd				'�ėp�R�[�h
Dim strFreeDate				'�ėp���t
Dim strFreeField1			'�t�B�[���h�P
Dim strFreeField2			'�t�B�[���h�Q

Dim strTaxRate				'����ŗ�

Dim strMode2				'�������[�h(COM�Ăяo���p)
Dim strHTML					'HTML������
Dim strURL					'�W�����v���URL
Dim strMessage				'�G���[���b�Z�[�W
Dim Ret						'�֐��߂�l
Dim Ret2					'�֐��߂�l
Dim i, j, k					'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objContract = Server.CreateObject("HainsContract.Contract")

'�����l�̎擾�i�_���{���j
strMode     = Request("mode")
strActMode  = Request("actMode")
strOrgCd1   = Request("orgCd1")
strOrgCd2   = Request("orgCd2")
strCtrPtCd  = Request("ctrPtCd")

'�����l�̎擾�i�I�v�V�����������j
strOptCd         = Request("optCd")
strOptBranchNo   = Request("optBranchNo")
strOptName       = Request("optName")
strOptSName      = Request("optSName")
strSubCsCd       = Request("subCsCd")
strSetColor      = Request("setColor")
strSetClassCd    = Request("setClassCd")
strRsvFraCd      = Request("rsvFraCd")
strCslDivCd      = Request("cslDivCd")
lngGender        = CLng("0" & Request("gender"))
strAge           = ConvIStringToArray(Request("age"))
strLastRefMonth  = Request("lastRefMonth")
strLastRefCsCd   = Request("lastRefCsCd")
lngAddCondition  = CLng("0" & Request("addCondition"))
strHideRsvFra    = Request("hideRsvFra")
strHideRsv       = Request("hideRsv")
strHideRpt       = Request("hideRpt")
strHideQuestion  = Request("hideQuestion")
strExceptLimit   = Request("exceptLimit")

'�����l�̎擾�i�������j
strApDiv          = ConvIStringToArray(Request("apDiv"))
strSeq            = ConvIStringToArray(Request("seq"))
strBdnOrgCd1      = ConvIStringToArray(Request("bdnOrgCd1"))
strBdnOrgCd2      = ConvIStringToArray(Request("bdnOrgCd2"))
strArrOrgName     = ConvIStringToArray(Request("orgName"))
strPrice          = ConvIStringToArray(Request("price"))
strTax            = ConvIStringToArray(Request("tax"))
strCtrOrgDiv      = ConvIStringToArray(Request("ctrOrgDiv"))
strPrice          = ConvIStringToArray(Request("price"))
strBillPrintName  = ConvIStringToArray(Request("billPrintName"))
strBillPrintEName = ConvIStringToArray(Request("billPrintEName"))

'�����l�̎擾�i��f���ڏ��j
strGrpCd       = Split(Request("grpCd"),       ",")
strGrpName     = Split(Request("grpName"),     ",")
strItemCd      = Split(Request("itemCd"),      ",")
strRequestName = Split(Request("requestName"), ",")

'�Z�b�g�J���[�̃f�t�H���g�l�ݒ�
If strSetColor = "" Then
	strSetColor = "000000"
End If

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do
	'���샂�[�h���Ƃ̐���
	Select Case strActMode

		'�폜�{�^��������
		Case ACTMODE_DELETE

			'�w��_��p�^�[���A�I�v�V�����R�[�h�̃I�v�V�������������폜
			Set objContractControl = Server.CreateObject("HainsContract.ContractControl")
			Ret = objContractControl.DeleteOption(strOrgCd1, strOrgCd2, strCtrPtCd, strOptCd, strOptBranchNo)
			Set objContractControl = Nothing

			Select Case Ret
				Case 0
				Case 1, 2
					strMessage = Array("���̃Z�b�g���Q�Ƃ��Ă����f��񂪑��݂��܂��B�폜�ł��܂���B")
					Exit Do
				Case 3
					strMessage = Array("����web�I�v�V���������͍폜�ł��܂���B")
					Exit Do
				Case Else
					Exit Do
			End Select

			'�G���[���Ȃ���ΌĂь�(�_����)��ʂ������[�h���Ď��g�����
			strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
			strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
			strHTML = strHTML & "</BODY>"
			strHTML = strHTML & "</HTML>"
			Response.Write strHTML
			Response.End
			Exit Do

		'�ۑ��{�^��������
		Case ACTMODE_SAVE

			'���̓`�F�b�N
			strMessage = CheckValue()
			If Not IsEmpty(strMessage) Then
				Exit Do
			End If

			'��f�Ώ۔N����f�ΏۊJ�n�E�I���N��z��ւ̕ϊ�
			Call ConvAgeArray(strAge, strStrAge, strEndAge)

			'COM�Ăяo���p�̏������[�h�ݒ�
			Select Case strMode
				Case MODE_INSERT, MODE_COPY
					strMode2 = MODE_INSERT
				Case MODE_UPDATE
					strMode2 = MODE_UPDATE
			End Select

			'�ǉ��I�v�V������������
			Set objContractControl = Server.CreateObject("HainsContract.ContractControl")
			Ret = objContractControl.SetAddOption(strMode2,          _
												  strOrgCd1,         _
												  strOrgCd2,         _
												  strCtrPtCd,        _
												  strOptCd,          _
												  strOptBranchNo,    _
												  strOptName,        _
												  strOptSName,       _
												  strSubCsCd,        _
												  strSetColor,       _
												  strSetClassCd,     _
												  strRsvFraCd,       _
												  strCslDivCd,       _
												  lngGender,         _
												  strLastRefMonth,   _
												  strLastRefCsCd,    _
												  lngAddCondition,   _
												  strHideRsvFra,     _
												  strHideRsv,        _
												  strHideRpt,        _
												  strHideQuestion,   _
												  strExceptLimit,    _
												  strStrAge,         _
												  strEndAge,         _
												  strSeq,            _
												  strBdnOrgCd1,      _
												  strBdnOrgCd2,      _
												  strPrice,          _
												  strTax,            _
												  strBillPrintName,  _
												  strBillPrintEName, _
												  strCtrOrgDiv,      _
												  strGrpCd,          _
												  strItemCd)

			Set objContractControl = Nothing

			Select Case Ret
				Case 0
				Case 1
					strMessage = Array("���̌_����̕��S�����͕ύX����Ă��܂��B�X�V�ł��܂���B")
					Exit Do
				Case 2
					strMessage = Array("�������z���ݒ肳��Ă��镉�S���̕��S���z�ɂ͕K���l����͂���K�v������܂��B")
					Exit Do
				Case 3
					strMessage = Array("����Z�b�g�R�[�h�A�}�Ԃ̌��������łɑ��݂��܂��B")
					Exit Do
				Case Else
					Exit Do
			End Select

			'�G���[���Ȃ���ΌĂь�(�_����)��ʂ������[�h���Ď��g�����
			strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
			strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
			strHTML = strHTML & "</BODY>"
			strHTML = strHTML & "</HTML>"
			Response.Write strHTML
			Response.End
			Exit Do

	End Select

	'�X�V���[�h�܂��̓R�s�[���[�h�̏ꍇ
	If strMode = MODE_UPDATE Or strMode = MODE_COPY Then

		'�_��p�^�[���I�v�V�����Ǘ����̓ǂݍ���
		If objContract.SelectCtrPtOpt( _
						   strCtrPtCd,      strOptCd,        strOptBranchNo, _
						   strOptName,      strOptSName,     strSubCsCd,     _
						   strSetClassCd,   strCslDivCd,     lngGender,      _
						   strLastRefMonth, strLastRefCsCd,  strExceptLimit, _
						   lngAddCondition, strHideRsvFra,   strHideRsv,     _
						   strHideRpt,      strHideQuestion, strRsvFraCd, _
						   strSetColor) = False Then
			Err.Raise 1000, ,"�Z�b�g������񂪑��݂��܂���B"
		End If

		'�_��p�^�[���I�v�V�����N��������̓ǂݍ���
		objContract.SelectCtrPtOptAge strCtrPtCd, strOptCd, strOptBranchNo, strStrAge, strEndAge

		'��f�ΏۊJ�n�E�I���N����f�Ώ۔N��z��ւ̕ϊ�
		Call RevConvAgeArray(strStrAge, strEndAge, strAge)

		'�_��p�^�[���O���[�v���̓ǂݍ���
		objContract.SelectCtrPtGrp strCtrPtCd, strOptCd, strOptBranchNo, strGrpCd, strGrpName

		'�_��p�^�[���������ڏ��̓ǂݍ���
		objContract.SelectCtrPtItem strCtrPtCd, strOptCd, strOptBranchNo, strItemCd, strRequestName

		'�_��p�^�[�����S���z���̓ǂݍ���
		lngCount = objContract.SelectCtrPtOrgPrice(strCtrPtCd, strOptCd, strOptBranchNo, strSeq, strApDiv, strBdnOrgCd1, strBdnOrgCd2, strArrOrgName, , strPrice, strTax, strBillPrintName, strBillPrintEName, , , , , , strCtrOrgDiv)
		If lngCount <= 0 Then
			Err.Raise 1000, ,"�_���񂪑��݂��܂���B"
		End If

		'�R�s�[���[�h�̏ꍇ�̓I�v�V�����R�[�h�A�}�Ԃ��N���A����
		If strMode = MODE_COPY Then
			strOptCd = ""
			strOptBranchNo = ""
		End If

		Exit Do
	End If

	'�V�K���[�h�̏ꍇ

	'���ׂĂ̔N����`�F�b�N�ΏۂƂ����邽�߂̏����l���쐬
	strStrAge = Array("0")
	strEndAge = Array("999")
	Call RevConvAgeArray(strStrAge, strEndAge, strAge)

	'�_��p�^�[�����S���z���̓ǂݍ���
	lngCount = objContract.SelectCtrPtOrgPrice(strCtrPtCd, , , strSeq, strApDiv, strBdnOrgCd1, strBdnOrgCd2, strArrOrgName, , strPrice, strTax, strBillPrintName, strBillPrintEName, , , , , , strCtrOrgDiv)
	If lngCount <= 0 Then
		Err.Raise 1000, ,"�_���񂪑��݂��܂���B"
	End If

	Exit Do
Loop

'�_����̓ǂݍ���
Ret2 = objContract.SelectCtrMng(strOrgCd1, strOrgCd2, strCtrPtCd, strOrgName, strCsCd, strCsName, dtmStrDate, dtmEndDate)

'�ȍ~�͎g�p���Ȃ��̂ŃI�u�W�F�N�g�����
Set objContract = Nothing

If Ret2 = False Then
	Err.Raise 1000, ,"�_���񂪑��݂��܂���B"
End If

'�ŗ��̎擾
Do

	'�ėp�e�[�u������ŗ���ǂݍ���
	Set objFree = Server.CreateObject("HainsFree.Free")
	Ret = objFree.SelectFree(0, "TAX", , , strFreeDate, strFreeField1, strFreeField2)
	Set objFree = Nothing

	If Ret <= 0 Then
		Exit Do
	End If

	'�ėp���t���ݒ莞�͌v�Z���Ȃ�
	If Not IsDate(strFreeDate) Then
		Exit Do
	End If
	
	'�ėp���t�ƌ_��J�n���Ƃ̊֌W��肢����̐ŗ����g�p���邩�𔻒�
	strTaxRate = IIf(dtmStrDate >= CDate(strFreeDate), strFreeField2, strFreeField1)

	Exit Do
Loop

Set objFree = Nothing

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���̓`�F�b�N
'
' �����@�@ :
'
' �߂�l�@ : �G���[���b�Z�[�W�̔z��
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CheckValue()

	Dim objCommon		'���ʃN���X

	Dim strArrMessage	'�G���[���b�Z�[�W�̔z��
	Dim strMessage		'�G���[���b�Z�[�W
	Dim i				'�C���f�b�N�X

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'�I�v�V�����R�[�h�`�F�b�N
	Do

		'���p�����`�F�b�N
		strMessage = objCommon.CheckNarrowValue("�Z�b�g�R�[�h", strOptCd, LENGTH_OPTCD, CHECK_NECESSARY)
		If strMessage <> "" Then
			objCommon.AppendArray strArrMessage, strMessage
			Exit Do
		End If

		'�J���}�͎w��ł��Ȃ�
		If InStr(strOptCd, ",") > 0 Then
			objCommon.AppendArray strArrMessage, "�Z�b�g�R�[�h�ɃJ���}�͎w��ł��܂���B"
		End If

		Exit Do
	Loop

	'�I�v�V�����}�ԃ`�F�b�N
	objCommon.AppendArray strArrMessage, objCommon.CheckNumeric("�Z�b�g�}��", strOptBranchNo, LENGTH_OPTBRANCHNO, CHECK_NECESSARY)

	'�I�v�V�������`�F�b�N
	objCommon.AppendArray strArrMessage, objCommon.CheckWideValue("�Z�b�g��", strOptName, LENGTH_OPTNAME, CHECK_NECESSARY)

	'�I�v�V�������̃`�F�b�N
	objCommon.AppendArray strArrMessage, objCommon.CheckWideValue("�Z�b�g����", strOptSName, LENGTH_OPTSNAME)

	'�O��l�����`�F�b�N
	Do

		'�������͂���Ă��Ȃ��ꍇ
		If strLastRefMonth & strLastRefCsCd = "" Then
			Exit Do
		End If

		'�����Ƃ����͂���Ă���ꍇ
		If strLastRefMonth <> "" And strLastRefCsCd <> "" Then

			'�O��l�Q�Ɨp�����`�F�b�N
			strMessage = objCommon.CheckNumeric("����", strLastRefMonth, 2)
			If strMessage <> "" Then
				objCommon.AppendArray strArrMessage, strMessage
				Exit Do
			End If

			'���̐��������`�F�b�N
			If CLng(strLastRefMonth) < 1 Then
				objCommon.AppendArray strArrMessage, "�����͂P�ȏ�̒l��ݒ肵�Ă��������B"
				Exit Do
			End If

			Exit Do
		End If

		'��L�ȊO�̓G���[
		objCommon.AppendArray strArrMessage, "�O��l�̏����w�肪�s���S�ł��B"
		Exit Do
	Loop

	'���S���z�`�F�b�N
	For i = 0 To UBound(strPrice)
		strMessage = objCommon.CheckNumericWithSign("���S���z", strPrice(i), LENGTH_CTRPT_PRICE_PRICE)
		If strMessage <> "" Then
			objCommon.AppendArray strArrMessage, strMessage
			Exit For
		End If
	Next

	'����Ń`�F�b�N
	For i = 0 To UBound(strTax)
		strMessage = objCommon.CheckNumericWithSign("�����", strTax(i), LENGTH_CTRPT_PRICE_PRICE)
		If strMessage <> "" Then
			objCommon.AppendArray strArrMessage, strMessage
			Exit For
		End If
	Next

	'�������o�͖��`�F�b�N
	For i = 0 To UBound(strBillPrintName)
		strMessage = objCommon.CheckWideValue("�������E�̎����o�͖�", strBillPrintName(i), LENGTH_OPTNAME)
		If strMessage <> "" Then
			objCommon.AppendArray strArrMessage, strMessage
			Exit For
		End If
	Next

	'�������p��o�͖��`�F�b�N
	For i = 0 To UBound(strBillPrintEName)
		strMessage = objCommon.CheckNarrowValue("�������E�̎����o�͖��i�p��j", strBillPrintEName(i), LENGTH_OPTNAME)
		If strMessage <> "" Then
			objCommon.AppendArray strArrMessage, strMessage
			Exit For
		End If
	Next

	'�`�F�b�N���ʂ�Ԃ�
	CheckValue = strArrMessage

	Set objCommon = Nothing

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ��f�Ώ۔N����f�ΏۊJ�n�E�I���N��z��ւ̕ϊ�
'
' �����@�@ : (In)     strAge     ��f�Ώ۔N��
' �@�@�@�@   (Out)    strStrAge  ��f�ΏۊJ�n�N��
' �@�@�@�@   (Out)    strEndAge  ��f�ΏۏI���N��
'
' �߂�l�@ :
'
' ���l�@�@ : ��f�Ώ۔N��ɂ͕K���A
' �@�@�@�@   �@�����l���i�[����Ă��邱��
' �@�@�@�@   �A�����Œl���i�[����Ă��邱��
' �@�@�@�@   ��O��Ƃ���
'
'-------------------------------------------------------------------------------
Sub ConvAgeArray(strAge, strStrAge, strEndAge)

	Dim lngCount		'�z��̗v�f��
	Dim strLastAge		'���O�Ɍ��������N��̒l
	Dim blnAdd			'�V�v�f�ǉ��̗v��
	Dim i				'�C���f�b�N�X

	'��������
	strStrAge = Empty
	strEndAge = Empty

	'�������w�莞�͉������Ȃ�
	If IsEmpty(strAge) Then
		Exit Sub
	End If

	'��f�ΏۊJ�n�E�I���N��̔z����쐬
	strStrAge = Array()
	strEndAge = Array()

	strLastAge = ""
	lngCount = 0

	'��f�Ώ۔N��̔z�������
	For i = 0 To UBound(strAge)

		blnAdd = False

		'�ŏ��͕K���V���ȗv�f���쐬
		If strLastAge = "" Then
			blnAdd = True
		End If

		'���O�Ɍ��������N��l�ƘA�����Ă��Ȃ��ꍇ�͐V���ȗv�f���쐬
		If strLastAge <> "" Then
			If CLng(strAge(i)) - CLng(strLastAge) > 1 Then
				blnAdd = True
			End If
		End If

		'�V�v�f�쐬����
		If blnAdd Then
			ReDim Preserve strStrAge(lngCount)
			ReDim Preserve strEndAge(lngCount)
			strStrAge(lngCount) = strAge(i)
			strEndAge(lngCount) = strAge(i)
			lngCount = lngCount + 1
		End If

		'�V�v�f���쐬���Ȃ��ꍇ�͍ŏI�v�f�̎�f�ΏۏI���N����X�V����
		If Not blnAdd Then
			strEndAge(lngCount - 1) = strAge(i)
		End If

		'���݂̎�f�Ώ۔N���ޔ�
		strLastAge = strAge(i)

	Next

	'�ŏI�v�f�̎�f�ΏۏI���N�100�΂̏ꍇ��100�Έȏオ�ΏۂƂȂ�悤�A�l��u��
	If CLng(strEndAge(lngCount - 1)) >= 100 Then
		strEndAge(lngCount - 1) = AGE_MAXVALUE
	End If

End Sub

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ��f�Ώ۔N����f�ΏۊJ�n�E�I���N��z��ւ̕ϊ�
'
' �����@�@ : (In)    strStrAge  ��f�ΏۊJ�n�N��
' �@�@�@�@   (In)    strEndAge  ��f�ΏۏI���N��
' �@�@�@�@   (Out)   strAge     ��f�Ώ۔N��
'
' �߂�l�@ :
'
' ���l�@�@ : ��f�ΏۊJ�n�E�I���N��ɂ͕K���A
' �@�@�@�@   �@�����l���i�[����Ă��邱��
' �@�@�@�@   �A�����Œl���i�[����Ă��邱��
' �@�@�@�@   ��O��Ƃ���
'
'-------------------------------------------------------------------------------
Sub RevConvAgeArray(strStrAge, strEndAge, strAge)

	Dim lngCount	'�z��̗v�f��

	'��������
	strAge = Empty

	'�������w�莞�͉������Ȃ�
	If IsEmpty(strStrAge) Or IsEmpty(strEndAge) Then
		Exit Sub
	End If

	'��f�Ώ۔N��̔z����쐬
	strAge = Array()

	'��f�ΏۊJ�n�E�I���N��̔z�������
	For i = 0 To UBound(strStrAge)

		'�J�n�E�I���͈͂̑S�N��l��ǉ�
		For j = CLng(strStrAge(i)) To CLng(strEndAge(i))

			'�N�100�΂𒴂���ꍇ�͑ł��؂�
			If j > 100 Then
				Exit For
			End If

			'�z��̐V�v�f�Ƃ��Ēǉ�
			ReDim Preserve strAge(lngCount)
			strAge(lngCount) = CStr(j)
			lngCount = lngCount + 1
		Next

	Next

End Sub
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ��f�Ώ۔N��̌���
'
' �����@�@ : (In)     strAge     ��f�Ώ۔N��
' �@�@�@�@   (In)     lngAge     �����N��
'
' �߂�l�@ : True   ��f�Ώ۔N��̔z��Ɍ����N�����
' �@�@�@�@   False  ��f�Ώ۔N��̔z��Ɍ����N����݂��Ȃ�
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CheckDateCheckBox(strAge, lngAge)

	Dim i	'�C���f�b�N�X

	CheckDateCheckBox = False

	'�������ݒ莞�͉������Ȃ�
	If IsEmpty(strAge) Then
		Exit Function
	End If

	'��f�Ώ۔N��̌���
	For i = 0 To UBound(strAge)
		If CLng(strAge(i)) = CInt(lngAge) Then
			CheckDateCheckBox = True
			Exit Function
		End If
	Next

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�����Z�b�g�̓o�^</TITLE>
<!-- #include virtual = "/webHains/includes/colorGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!-- #include virtual = "/webHains/includes/price.inc"    -->
<!-- #include virtual = "/webHains/includes/itmGuide.inc" -->
<!--
// �����ɑ΂���I����e�̒ǉ�
function appendItem( dataDiv ) {

	var optList;	// SELECT�I�u�W�F�N�g
	var curOptInf;	// ���I�v�V�������

	var hit;		// �����t���O
	var i;			// �C���f�b�N�X

	optList = document.entryForm.optionItem;

	// �w�荀�ڕ��ނ̌��I�v�V���������擾
	curOptInf = new Array();
	for ( i = 0; i < optList.length; i++ ) {

		// �I�v�V�����v�f�̐擪�����Ŕ��f
		if ( optList.options[ i ].value.charAt(0) == dataDiv ) {

			// �I�v�V�����v�f��2�Ԗڈȍ~�̕������R�[�h�Ƃ��āA�\�����e�𖼏̂Ƃ��Ď擾
			curOptInf[curOptInf.length] = new optInf(optList.options[ i ].value.substring(1, optList.options[ i ].value.length), optList.options[ i ].text);

		}

	}

	// �K�C�h�I�����ڂ�����
	for ( i = 0; i < itmGuide_dataDiv.length; i++ ) {

		// ���ڕ��ނ����v���Ȃ���ΑΏۊO
		if ( itmGuide_dataDiv[ i ] != dataDiv ) {
			continue;
		}

		// ���I�v�V�������Ɋ܂܂�邩�������A�R�[�h�����v����΃t���O����
		for ( j = 0, hit = false; j < curOptInf.length; j++ ) {
			if ( curOptInf[j].itemCd == itmGuide_itemCd[ i ] ) {
				hit = true;
				break;
			}
		}

		// �q�b�g���Ȃ������ꍇ�͌��I�v�V�������̖����ɒǉ�
		if ( !hit ) {
			curOptInf[curOptInf.length] = new optInf(itmGuide_itemCd[ i ], itmGuide_itemName[ i ]);
		}

	}

	return curOptInf;
}

// ���ڃK�C�h�Ăяo��
function callItemGuide( mode, group, item, que, calledFunction ) {

	// �K�C�h����U����
	closeGuideItm();

	itmGuide_mode     = mode;	// �˗��^���ʃ��[�h�@1:�˗��A2:����
	itmGuide_group    = group;	// �O���[�v�\���L���@0:�\�����Ȃ��A1:�\������
	itmGuide_item     = item;	// �������ڕ\���L���@0:�\�����Ȃ��A1:�\������
	itmGuide_question = que;	// ��f���ڕ\���L���@0:�\�����Ȃ��A1:�\������

	// �K�C�h��ʂ̘A����ɃK�C�h��ʂ���Ăяo����鎩��ʂ̊֐���ݒ肷��
	itmGuide_CalledFunction = calledFunction;

	// ���ڃK�C�h�\��
	showGuideItm();

}

// �N��`�F�b�N�{�b�N�X����
function checkAge( onOff, strAge, endAge ) {

	var i;	// �C���f�b�N�X

	// �w��N��͈͂̃`�F�b�N�{�b�N�X����
	for ( i = strAge; i <= endAge; i++ ) {
		document.entryForm.age[ i ].checked = ( onOff > 0 );
	}

}

// ���X�g����O���[�v�܂��͌������ڂ��폜����(�Œ茩�o���͔�Ώ�)
function deleteItem() {

	var optList;	// SELECT�I�u�W�F�N�g
	var i;			// �C���f�b�N�X

	optList = document.entryForm.optionItem;

	// ���X�g��������猟��
	for ( i = optList.length - 1; i >= 0; i-- ) {

		// �I������ĂȂ���΃X�L�b�v
		if ( !optList.options[ i ].selected ) {
			continue;
		}

		// �Œ茩�o���ł���ΑI������
		if ( optList.options[ i ].value.charAt(0) == '' ) {
			optList.options[ i ].selected = false;
			continue;
		}

		// ���X�g�폜
		optList.options[ i ] = null;

	}

}

// �I�v�V���������̍폜
function deleteOption() {

    /** submitForm�t�@���N�V�����ł܂Ƃ߂ă`�F�b�N�ł���悤�ɏC�� Start 2005.06.18 �� **/
    // �m�F���b�Z�[�W�̕\��
    //if ( !confirm('���̌����Z�b�g���폜���܂��B��낵���ł����H') ) {
    //    return;
    //}
    /** submitForm�t�@���N�V�����ł܂Ƃ߂ă`�F�b�N�ł���悤�ɏC�� End   2005.06.18 �� **/

	// submit����
	submitForm('<%= ACTMODE_DELETE %>');
}

// �������ڕҏW�p�֐�
function editItemInfo( itemCd, suffix, itemName, resultType, itemType ) {

	var myForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g

	// �������ڃR�[�h�̕ҏW
	myForm.perItemCd.value     = itemCd;
	myForm.perSuffix.value     = suffix;
	myForm.perResultType.value = resultType;
	myForm.perItemType.value   = itemType;

	// �������ږ��̕ҏW
	document.getElementById('perItemName').innerHTML = itemName;
}

// ���X�g�̕ҏW
function editList() {

	var grpInf;		// �O���[�v���
	var itemInf;	// �˗����ڏ��

	var optList;	// SELECT�I�u�W�F�N�g

	var i			// �C���f�b�N�X

	// �����X�g�̃O���[�v�ɃK�C�h�I����e��ǉ�
	grpInf = appendItem('G');

	// �����X�g�̈˗����ڂɃK�C�h�I����e��ǉ�
	itemInf = appendItem('P');

	optList = document.entryForm.optionItem;

	// �I�u�W�F�N�g�̏�����
	while ( optList.length > 0 ) {
		optList.options[0] = null;
	}

	// �O���[�v���o���ǉ�
	optList.options[ optList.length ] = new Option('�������O���[�v', '');

	// �O���[�v�ǉ�
	for ( i = 0; i < grpInf.length; i++ ) {
		optList.options[ optList.length ] = new Option(grpInf[ i ].itemName, 'G' + grpInf[ i ].itemCd);
	}

	// �˗����ڌ��o���ǉ�
	optList.options[ optList.length ] = new Option( '����������', '' );

	// �˗����ڒǉ�
	for ( i = 0; i < itemInf.length; i++ ) {
		optList.options[ optList.length ] = new Option( itemInf[ i ].itemName, 'P' + itemInf[ i ].itemCd );
	}

}

// �I�v�V�������N���X
function optInf( itemCd, itemName ) {
	this.itemCd   = itemCd;
	this.itemName = itemName;
}

// �������ڂ̃Z�b�g
function setItemInfo() {

	// ���I�����͉������Ȃ�
	if ( itmGuide_itemCd == '' ) {
		return;
	}

	// �I���������ڏ���ҏW
	editItemInfo( itmGuide_itemCd[ 0 ], itmGuide_suffix[ 0 ], itmGuide_itemName[ 0 ], itmGuide_resultType[ 0 ], itmGuide_itemType[ 0 ] );

}

// ���͌������ʕҏW�p�֐�
function setStcResultInfo() {

	var myForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g

	// �������ʂ̕ҏW
	myForm.perResult.value = stcGuide_StcCd;

}

// �萫�������ʕҏW�p�֐�
function setTeiseiResultInfo() {

	var myForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g

	// �������ʂ̕ҏW
	myForm.perResult.value = tseGuide_Result;

}

// submit���A�I�v�V�����������e��hidden�f�[�^�Ɋi�[����
function submitForm( actMode ) {

	var myForm  = document.entryForm;				// ����ʂ̃t�H�[���G�������g
	var optList = document.entryForm.optionItem;	// SELECT�I�u�W�F�N�g

	var grpCd;										// �O���[�v�R�[�h
	var grpName;									// �O���[�v��
	var itemCd;										// �˗����ڃR�[�h
	var requestName;								// �˗����ږ�

	var i;											// �C���f�b�N�X

    /** �_����̕ۑ��E�폜�������s�������[�j���O���b�Z�[�W��\�����čĊm�F����悤�ɏC�� Start 2005.06.18 �� **/
    var strMsg;                                     // ���b�Z�[�W�敪�i�ۑ��E�폜)

    if(actMode == "<%=ACTMODE_DELETE%>"){
        strMsg = "���̌����Z�b�g���폜���܂��B��낵���ł����H";
    }else{
        strMsg = "���̌����Z�b�g���ύX����܂��B��낵���ł����H";
    }
    // �m�F���b�Z�[�W�̕\��
    if ( !confirm(strMsg) ) {
        return;
    }
    /** �_����̕ۑ��E�폜�������s�������[�j���O���b�Z�[�W��\�����čĊm�F����悤�ɏC�� End   2005.06.18 �� **/


	// �e���ڂ̔z����쐬
	grpCd       = new Array();
	grpName     = new Array();
	itemCd      = new Array();
	requestName = new Array();

	// �e���ڕ��ނ̒l���Y������z��ɒǉ�����
	for ( i = 0; i < optList.length; i++ ) {

		switch( optList.options[ i ].value.charAt( 0 ) ) {

			case 'G':	// �O���[�v

				grpCd[ grpCd.length ]     = optList.options[ i ].value.substring( 1, optList.options[ i ].value.length );
				grpName[ grpName.length ] = optList.options[ i ].text;
				break;

			case 'P':	// �˗�����
				itemCd[itemCd.length]             = optList.options[ i ].value.substring( 1, optList.options[ i ].value.length );
				requestName[ requestName.length ] = optList.options[ i ].text;

			default:

		}

	}

	// hidden�f�[�^�Ɋi�[
	myForm.grpCd.value       = grpCd;
	myForm.grpName.value     = grpName;
	myForm.itemCd.value      = itemCd;
	myForm.requestName.value = requestName;

	// submit����
	myForm.actMode.value = actMode;
	myForm.submit();
}

// �T�u��ʂ����
function closeWindow() {

	// ���ڃK�C�h��ʂ����
	closeGuideItm();

	// �F�I���K�C�h��ʂ����
	if ( winColor != null ) {
		if ( !winColor.closed ) {
			winColor.close();
		}
	}

	winColor = null;

}

// ����ł̌v�Z
function calcTax( taxRate, objPrice, objTax ) {

	for ( ; ; ) {

		// ���S���z�����͂ł���Όv�Z���Ȃ�
		if ( objPrice.value == '' ) {
			break;
		}

		// ����ł����͂���Ă���Όv�Z���Ȃ�
		if ( objTax.value != '' ) {
			break;
		}

		// ���K�\���`�F�b�N
		if ( objPrice.value.match('^[+-]?[0-9]+$') == null ) {
			break;
		}

		// ���S���z������ł��v�Z����(�[���͐؂�̂�)
		objTax.value = parseInt(parseInt(objPrice.value, 10) * taxRate, 10);

		break;
	}

}

// �v�Z����
function calculate( mode ) {

	var objPrice = document.entryForm.price;
	var objTax   = document.entryForm.tax;
	var taxRate  = '<%= strTaxRate %>';

	// ����ł̌v�Z
	for ( ; ; ) {

		if ( mode != 1 ) break;

		// �ŗ����s���Ȃ�v�Z���Ȃ�
		if ( taxRate == '' || isNaN(taxRate) ) {
			break;
		}

		taxRate = parseFloat(taxRate);

		// ���S���z�e�L�X�g���P�������݂��Ȃ��ꍇ
		if ( objPrice.length == null ) {
			calcTax( taxRate, objPrice, objTax );
			break;
		}

		// �S���S���z�e�L�X�g�̌���
		for ( var i = 0; i < objPrice.length; i++ ) {
			calcTax( taxRate, objPrice[ i ], objTax[ i ] );
		}

		break;
	}

	calcPrice( objPrice, 'totalPrice' );
	calcPrice( objTax,   'totalTax'   );

}

// �F�I���K�C�h��ʂ�\��
function showGuideColor( elemName, colorElemName ) {

	colorGuide_showGuideColor( document.entryForm.elements[elemName], colorElemName );

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY ONLOAD="javascript:calculate(0)" ONUNLOAD="javascript:closeWindow()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">

	<INPUT TYPE="hidden" NAME="mode"        VALUE="<%= strMode %>">
	<INPUT TYPE="hidden" NAME="actMode"     VALUE="">
	<INPUT TYPE="hidden" NAME="orgCd1"      VALUE="<%= strOrgCd1   %>">
	<INPUT TYPE="hidden" NAME="orgCd2"      VALUE="<%= strOrgCd2   %>">
	<INPUT TYPE="hidden" NAME="ctrPtCd"     VALUE="<%= strCtrPtCd  %>">
	<INPUT TYPE="hidden" NAME="grpCd"       VALUE="">
	<INPUT TYPE="hidden" NAME="grpName"     VALUE="">
	<INPUT TYPE="hidden" NAME="itemCd"      VALUE="">
	<INPUT TYPE="hidden" NAME="requestName" VALUE="">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="contract">��</SPAN><FONT COLOR="#000000">�����Z�b�g�̓o�^</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'�G���[���b�Z�[�W�̕ҏW
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)
%>
	<BR>
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
		<TR>
			<TD>�_��c��</TD>
			<TD>�F</TD>
			<TD NOWRAP><B><%= strOrgName %></B></TD>
		</TR>
		<TR>
			<TD HEIGHT="22" NOWRAP>�ΏۃR�[�X</TD>
			<TD>�F</TD>
			<TD NOWRAP><B><%= strCsName %></B></TD>
			<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="80" HEIGHT="1" ALT=""></TD>
			<TD ROWSPAN="2" VALIGN="bottom">
<%
				'�X�V���́u�폜�v�u�R�s�[�v�{�^����p�ӂ���
				If strMode = MODE_UPDATE Then
					'2005.08.22 �����Ǘ� Add by ���@--- START 
					if Session("PAGEGRANT") = "3" or Session("PAGEGRANT") = "4" then  
%>
						<A HREF="javascript:deleteOption()"><IMG SRC="/webHains/images/delete.gif" WIDTH="77" HEIGHT="24" ALT="�폜"></A>
<%
						'�R�s�[������URL�ҏW
						strURL = Request.ServerVariables("SCRIPT_NAME")
						strURL = strURL & "?orgCd1="      & strOrgCd1
						strURL = strURL & "&orgCd2="      & strOrgCd2
						strURL = strURL & "&ctrPtCd="     & strCtrPtCd
						strURL = strURL & "&optCd="       & strOptCd
						strURL = strURL & "&optBranchNo=" & strOptBranchNo
						strURL = strURL & "&mode="        & MODE_COPY
					end if

					if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then
%>
						<A HREF="<%= strURL %>"><IMG SRC="/webHains/images/copy.gif" WIDTH="77" HEIGHT="24" ALT="�R�s�["></A>
<%
					end if
				End If
%>
				<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
					<A HREF="javascript:submitForm('<%= ACTMODE_SAVE %>')"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="�ۑ�"></A>
				<%  else    %>
					&nbsp;
				<%  end if  %>
				<% '2005.08.22 �����Ǘ� Add by ��  ---- END %>
				
				<A HREF="javascript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z��"></A>
			</TD>
		</TR>
		<TR>
			<TD>�_�����</TD>
			<TD>�F</TD>
<%
			Set objCommon = Server.CreateObject("HainsCommon.Common")
%>
			<TD NOWRAP><B><%= objCommon.FormatString(dtmStrDate, "yyyy�Nm��d��") %>�`<%= objCommon.FormatString(dtmEndDate, "yyyy�Nm��d��") %></B></TD>
<%
			Set objCommon = Nothing
%>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="1" WIDTH="100%">
		<TR>
			<TD BGCOLOR="#eeeeee" NOWRAP>��{���</TD>
		</TR>
		<TR>
			<TD HEIGHT="3"></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD WIDTH="65" NOWRAP>�Z�b�g�R�[�h</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
					<TR>
<%
						'�V�K�E�R�s�[���ɃI�v�V�����R�[�h�̓e�L�X�g���͉Ƃ��A�X�V���͕\���݂̂Ƃ���
						If strMode = MODE_INSERT Or strMode = MODE_COPY Then
%>
							<TD NOWRAP><INPUT TYPE="text" NAME="optCd" SIZE="<%= LENGTH_OPTCD %>" MAXLENGTH="<%= LENGTH_OPTCD %>" VALUE="<%= strOptCd %>">-<INPUT TYPE="text" NAME="optBranchNo" SIZE="2" MAXLENGTH="2" VALUE="<%= strOptBranchNo %>"></TD>
<%
						Else
%>
							<TD NOWRAP><INPUT TYPE="hidden" NAME="optCd" VALUE="<%= strOptCd %>"><INPUT TYPE="hidden" NAME="optBranchNo" VALUE="<%= strOptBranchNo %>"><B><%= strOptCd %>-<%= strOptBranchNo %></B>&nbsp;&nbsp;</TD>
<%
						End If
%>
						<TD NOWRAP>�Z�b�g���F</TD>
						<TD><INPUT TYPE="text" NAME="optName" SIZE="<%= TextLength(LENGTH_OPTNAME) %>" MAXLENGTH="<%= TextMaxLength(LENGTH_OPTNAME) %>" VALUE="<%= strOptName %>"></TD>
						<TD NOWRAP>�@�Z�b�g���́F</TD>
						<TD><INPUT TYPE="text" NAME="optSName" SIZE="<%= TextLength(LENGTH_OPTSNAME) %>" MAXLENGTH="<%= TextMaxLength(LENGTH_OPTSNAME) %>" VALUE="<%= strOptSName %>"></TD>
						<TD NOWRAP>�@�Z�b�g�J���[�F</TD>
						<TD><A HREF="javascript:showGuideColor('setColor', 'elemSetColor')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�F�I���K�C�h�\��"></A></TD>
						<TD><INPUT TYPE="hidden" NAME="setColor" VALUE="<%= strSetColor %>"><FONT SIZE="4" COLOR="#<%= strSetColor %>" ID="elemSetColor">��</FONT></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD COLSPAN="2"></TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
					<TR>
						<TD NOWRAP>�Ǘ��R�[�X�F</TD>
						<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_SUB, "subCsCd", IIf(strSubCsCd <> "", strSubCsCd, strCsCd), NON_SELECTED_DEL, False) %></TD>
						<TD NOWRAP>�@�Z�b�g���ށF</TD>
						<TD><%= EditSetClassList("setClassCd", strSetClassCd, NON_SELECTED_ADD) %></TD>
						<TD NOWRAP>�@�Ǘ��ΏۂƂȂ�\��g�F</TD>
						<TD><%= EditRsvFraList("rsvFraCd", strRsvFraCd, NON_SELECTED_ADD) %></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD HEIGHT="2"></TD>
		</TR>
		<TR>
			<TD WIDTH="65" NOWRAP>��f����</TD>
			<TD>�F</TD>
			<TD NOWRAP>��f�敪</TD>
			<TD>�F</TD>
<%
			'�ėp�e�[�u�������f�敪��ǂݍ���
			Set objFree = Server.CreateObject("HainsFree.Free")
			objFree.SelectFree 1, "CSLDIV", strFreeCd, , , strFreeField1
			Set objFree = Nothing
%>
			<TD><%= EditDropDownListFromArray("cslDivCd", strFreeCd, strFreeField1, strCslDivCd, NON_SELECTED_DEL) %></TD>
		</TR>
		<TR>
			<TD COLSPAN="2" ROWSPAN="3"></TD>
			<TD>����</TD>
			<TD>�F</TD>
			<TD>
				<SELECT NAME="gender">
					<OPTION VALUE="<%= GENDER_BOTH   %>" <%= IIf(lngGender = GENDER_BOTH,   "SELECTED", "") %>>�j������
					<OPTION VALUE="<%= GENDER_MALE   %>" <%= IIf(lngGender = GENDER_MALE,   "SELECTED", "") %>>�j��
					<OPTION VALUE="<%= GENDER_FEMALE %>" <%= IIf(lngGender = GENDER_FEMALE, "SELECTED", "") %>>����
				</SELECT>
			</TD>
		</TR>
		<TR>
			<TD VALIGN="top"><IMG SRC="/webHains/images/spacer.gif" BORDER="0" WIDTH="1" HEIGHT="3" ALT=""><BR>�N��</TD>
			<TD VALIGN="top"><IMG SRC="/webHains/images/spacer.gif" BORDER="0" WIDTH="1" HEIGHT="3" ALT=""><BR>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
<%
					'0�΂���99�΂܂ł̔N��`�F�b�N�{�b�N�X�ҏW
					i = 0

					'10�s���ҏW
					For j = 1 To 10
%>
						<TR BGCOLOR="#<%= IIf(j Mod 2 = 0, "eeeeee", "ffffff") %>">
<%
							'10�񕪕ҏW
							For k = 1 To 10
%>
								<TD><INPUT TYPE="checkbox" NAME="age" VALUE="<%= i %>" <%= IIf(CheckDateCheckBox(strAge, i), "CHECKED", "") %>></TD><TD NOWRAP><%= i %>��</TD>
<%
								i = i + 1
							Next
%>
							<TD BGCOLOR="#ffffff" VALIGN="bottom">&nbsp;<A HREF="javascript:checkAge( 1, <%= i - 10 %>, <%= i - 1 %> )"><IMG SRC="/webHains/images/allcheck.gif" WIDTH="97" HEIGHT="13" ALT="���̍s���ׂă`�F�b�N"></A></TD>
						</TR>
<%
					Next
%>
					<TR>
						<TD><INPUT TYPE="checkbox" NAME="age" VALUE="100" <%= IIf(CheckDateCheckBox(strAge, 100), "CHECKED", "") %>></TD>
						<TD COLSPAN="19" NOWRAP>100�Έȏ�</TD>
						<TD VALIGN="bottom">&nbsp;&nbsp;&nbsp;<A HREF="javascript:checkAge( 0, 0, 100 )"><IMG SRC="/webHains/images/alloff.gif" WIDTH="97" HEIGHT="13" ALT="���ׂăI�t�ɂ���"></A></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD>�O��l</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
					<TR>
						<TD NOWRAP>�ߋ�</TD>
						<TD><INPUT TYPE="text" NAME="lastRefMonth" SIZE="2" MAXLENGTH="2" VALUE="<%= strLastRefMonth %>"></TD>
						<TD NOWRAP>�����ȓ���</TD>
						<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "lastRefCsCd", strLastRefCsCd, "", False) %></TD>
						<TD NOWRAP>����f</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD WIDTH="65" NOWRAP>�ǉ�����</TD>
			<TD>�F</TD>
			<TD>
				<SELECT NAME="addCondition">
					<OPTION VALUE="0" <%= IIf(lngAddCondition = 0, "SELECTED", "") %>>��L�����ɓ��Ă͂܂�ꍇ�A�����ǉ�
					<OPTION VALUE="1" <%= IIf(lngAddCondition = 1, "SELECTED", "") %>>��L�����ɓ��Ă͂܂��f�҂��C�ӑI��
				</SELECT>
			</TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD WIDTH="65" NOWRAP>��\������</TD>
			<TD>�F</TD>
			<TD><INPUT TYPE="checkbox" NAME="hideRsvFra" VALUE="1"<%= IIf(strHideRsvFra <> "", " CHECKED", "") %>></TD>
			<TD NOWRAP>�\��g���</TD>
			<TD><INPUT TYPE="checkbox" NAME="hideRsv" VALUE="1"<%= IIf(strHideRsv <> "", " CHECKED", "") %>></TD>
			<TD NOWRAP>�\����</TD>
			<TD><INPUT TYPE="checkbox" NAME="hideRpt" VALUE="1"<%= IIf(strHideRpt <> "", " CHECKED", "") %>></TD>
			<TD NOWRAP>��t���</TD>
			<TD><INPUT TYPE="checkbox" NAME="hideQuestion" VALUE="1"<%= IIf(strHideQuestion <> "", " CHECKED", "") %>></TD>
			<TD NOWRAP>��f���</TD>
		</TR>
	</TABLE>
	<IMG SRC="/webHains/images/spacer.gif" WIDTH="85" HEIGHT="1" ALT=""><FONT COLOR="#999999">���`�F�b�N��������ʂŁA���̃Z�b�g�͔�\���ɂȂ�܂��B�i�Z�b�g�O���[�v�̏ꍇ�S�Ăɔ��f����܂��j</FONT><BR><BR>
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="1" WIDTH="100%">
		<TR>
			<TD BGCOLOR="#eeeeee" NOWRAP>�������</TD>
		</TR>
		<TR>
			<TD HEIGHT="3"></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD><INPUT TYPE="checkbox" NAME="exceptLimit" VALUE="1"<%= IIf(strExceptLimit <> "", " CHECKED", "") %>></TD>
			<TD NOWRAP>���̃Z�b�g�͌��x�z�ݒ�̑ΏۂƂ��Ȃ�</TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="1" WIDTH="100%">
		<TR>
			<TD HEIGHT="2"></TD>
		</TR>
		<TR BGCOLOR="#eeeeee">
			<TD WIDTH="100%" COLSPAN="2" NOWRAP>���S��</TD>
			<TD WIDTH="90"  NOWRAP>���S���z</TD>
			<TD WIDTH="90"  NOWRAP>�����</TD>
			<TD NOWRAP>�������E�̎����o�͖�</TD>
			<TD NOWRAP>�������E�̎����o�͖��i�p��j</TD>
		</TR>
		<TR>
			<TD HEIGHT="2"></TD>
		</TR>
<%
		'�c�̎w��̕��S���ҏW
		For i = 0 To UBound(strSeq)
%>
			<TR>
				<TD COLSPAN="2" NOWRAP>
					<INPUT TYPE="hidden" NAME="apDiv"     VALUE="<%= strApDiv(i)      %>">
					<INPUT TYPE="hidden" NAME="seq"       VALUE="<%= strSeq(i)        %>">
					<INPUT TYPE="hidden" NAME="bdnOrgCd1" VALUE="<%= strBdnOrgCd1(i)  %>">
					<INPUT TYPE="hidden" NAME="bdnOrgCd2" VALUE="<%= strBdnOrgCd2(i)  %>">
					<INPUT TYPE="hidden" NAME="orgName"   VALUE="<%= strArrOrgName(i) %>">
					<INPUT TYPE="hidden" NAME="ctrOrgDiv" VALUE="">
					<%= IIf(strApDiv(i) = CStr(APDIV_MYORG), strOrgName, strArrOrgName(i)) %>
				</TD>
				<TD ALIGN="right"><INPUT TYPE="text" NAME="price" SIZE="<%= TextLength(LENGTH_CTRPT_PRICE_PRICE) %>" MAXLENGTH="<%= LENGTH_CTRPT_PRICE_PRICE %>" STYLE="text-align:right;ime-mode:disabled;" VALUE="<%= strPrice(i) %>"></TD>
				<TD ALIGN="right"><INPUT TYPE="text" NAME="tax"   SIZE="<%= TextLength(LENGTH_CTRPT_PRICE_PRICE) %>" MAXLENGTH="<%= LENGTH_CTRPT_PRICE_PRICE %>" STYLE="text-align:right;ime-mode:disabled;" VALUE="<%= strTax(i)   %>"></TD>
				<TD><INPUT TYPE="text" NAME="billPrintName" SIZE="<%= TextLength(LENGTH_OPTNAME) %>" MAXLENGTH="<%= TextMaxLength(LENGTH_OPTNAME) %>" VALUE="<%= strBillPrintName(i) %>"></TD>
				<TD><INPUT TYPE="text" NAME="billPrintEName" SIZE="<%= TextLength(LENGTH_OPTNAME) %>" MAXLENGTH="<%= LENGTH_OPTNAME %>" VALUE="<%= strBillPrintEName(i) %>"></TD>
			</TR>
<%
		Next
%>
		<TR>
			<TD HEIGHT="5"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD HEIGHT="1" BGCOLOR="#999999" COLSPAN="6"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1"></TD>
		</TR>
		<TR>
			<TD>���S���z���v</TD>
			<TD ALIGN="right"><INPUT TYPE="button" VALUE="�Čv�Z" ONCLICK="javascript:calculate(1)"></TD>
			<TD ALIGN="right"><B><SPAN ID="totalPrice"></SPAN></B></TD>
			<TD ALIGN="right"><B><SPAN ID="totalTax"></SPAN></B></TD>
			<TD COLSPAN="2"><FONT COLOR="#999999">�@���o�͖��i���{��j�͖��w��̏ꍇ�A�Z�b�g�����K�p����܂��B</FONT></TD>
		</TR>
	</TABLE>
	<BR>
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="1" WIDTH="100%">
		<TR>
			<TD BGCOLOR="#eeeeee" NOWRAP>��f����</TD>
		</TR>
		<TR>
			<TD HEIGHT="3"></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD VALIGN="top" ROWSPAN="2">
				<SELECT NAME="optionItem" MULTIPLE SIZE="12" STYLE="width:150;height:180;">
					<OPTION VALUE="">�������O���[�v
<%
					'�O���[�v�̕ҏW
					If Not IsEmpty(strGrpCd) Then
						For i = 0 To UBound(strGrpCd)
%>
							<OPTION VALUE="G<%= strGrpCd(i) %>"><%= strGrpName(i) %>
<%
						Next
					End If
%>
					<OPTION VALUE="">����������
<%
					'�˗����ڂ̕ҏW
					If Not IsEmpty(strItemCd) Then
						For i = 0 To UBound(strItemCd)
%>
							<OPTION VALUE="P<%= strItemCd(i) %>"><%= strRequestName(i) %>
<%
						Next
					End If
%>
				</SELECT>
			</TD>
			<TD VALIGN="top" NOWRAP>

            <% '2005.08.22 �����Ǘ� Add by ���@--- START %>
			<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
				<A HREF="javascript:callItemGuide( 1, 1, 1, 0, editList )"><IMG SRC="/webHains/images/additem.gif" WIDTH="77" HEIGHT="24" ALT="��f���ڂ�ǉ����܂�"></A><BR>
			<%  else    %>
                 &nbsp;
            <%  end if  %>
            <% '2005.08.22 �����Ǘ� Add by ���@--- END %>
			</TD>
		</TR>

		<TR>
			<TD VALIGN="BOTTOM">
            <% '2005.08.22 �����Ǘ� Add by ���@--- START %>
			<%  if Session("PAGEGRANT") = "3" or Session("PAGEGRANT") = "4" then   %>
				<A HREF="javascript:deleteItem()"><IMG SRC="/webHains/images/delitem.gif" WIDTH="77" HEIGHT="24" ALT="�I��������f���ڂ��폜���܂�"></A>
			<%  else    %>
                 &nbsp;
            <%  end if  %>
            <% '2005.08.22 �����Ǘ� Add by ���@--- END %>

			</TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>