<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�_����(�I�v�V���������̓o�^) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editJudClassList.inc" -->
<!-- #include virtual = "/webHains/includes/editJudList.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<!-- #include virtual = "/webHains/includes/tokyu_editDmdLineClassList.inc" -->
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
Const CALCMODE_NORMAL      = "0"	'���z�v�Z���[�h�i�����蓮�ݒ�j
Const CALCMODE_ROUNDUP     = "1"	'���z�v�Z���[�h�i�������ڒP���ώZ�j
Const EXISTSISR_NOT_EXISTS = "0"	'���ۗL���敪(���ۂȂ�)
Const EXISTSISR_EXISTS     = "1"	'���ۗL���敪(���ۂ���)

Const LENGTH_OPTCD         = 3		'�I�v�V�����R�[�h�̍��ڒ�
Const LENGTH_OPTNAME       = 30		'�I�v�V�������̍��ڒ�

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon				'���ʃN���X
Dim objContract				'�_����A�N�Z�X�p
Dim objContractControl		'�_����A�N�Z�X�p

'�����l�i�_���{���j
Dim strMode					'�������[�h
Dim strActMode				'���샂�[�h
Dim strCalcMode				'���z�v�Z���[�h
Dim strOrgCd1				'�c�̃R�[�h1
Dim strOrgCd2				'�c�̃R�[�h2
Dim strCtrPtCd				'�_��p�^�[���R�[�h

'�����l�i�I�v�V����������{���j
Dim strOptCd				'�I�v�V�����R�[�h
Dim strOptName				'�I�v�V������
Dim strSubCsCd				'�i�T�u�j�R�[�X�R�[�h
Dim strOptAddMode			'�I�v�V�����ǉ����[�h

'�����l�i�I�v�V���������Ώۏ����j
Dim strExistsIsr			'���ۗL���敪
Dim lngGender				'��f�\����
Dim strAge					'��f�Ώ۔N��
Dim strLastRefMode			'�O��l�Q�ƃ��[�h
Dim strLastRefCsCd			'�O��l�Q�Ɨp�R�[�X�R�[�h
Dim strJudClassCd			'���蕪�ރR�[�h
Dim strSign					'�����L��
Dim strJudCd				'����R�[�h
Dim strPerItemCd			'�i�l�������ʁj�������ڃR�[�h
Dim strPerSuffix			'�i�l�������ʁj�T�t�B�b�N�X
Dim strPerItemName			'�i�l�������ʁj�������ږ�
Dim strPerResultType		'�i�l�������ʁj���ʃ^�C�v
Dim strPerItemType			'�i�l�������ʁj���ڃ^�C�v
Dim strPerResult			'�i�l�������ʁj��������
Dim strCslFlg				'��f�t���O
Dim strNightDutyFlg			'��ΎҌ��f�Ώ�

'�����l�i�������j
Dim strDmdLineClassCd		'�������ו��ރR�[�h
Dim strIsrDmdLineClassCd	'���ۗp�������ו��ރR�[�h
Dim strApDiv				'�K�p���敪
Dim strSeq					'SEQ
Dim strBdnOrgCd1			'�c�̃R�[�h1
Dim strBdnOrgCd2			'�c�̃R�[�h2
Dim strArrOrgName			'�c�̖���
Dim strOrgDiv				'(�c�̃e�[�u�����)�c�̎��
Dim strPrice				'���S���z
Dim strTax					'�����
Dim strCtrOrgDiv			'(�_��p�^�[�����S���z�Ǘ��e�[�u�����)�c�̎��
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
Dim strOptDiv				'�I�v�V�����敪
Dim strUpdCsCd				'�i�X�V�p�́j�R�[�X�R�[�h
Dim strRegularFlg			'������f�t���O
Dim strStrAge				'��f�ΏۊJ�n�N��
Dim strEndAge				'��f�ΏۏI���N��

Dim strMode2				'�������[�h(COM�Ăяo���p)
Dim strHTML					'HTML������
Dim strURL					'�W�����v���URL
Dim strMessage				'�G���[���b�Z�[�W
DIm blnSet					'�����l�ݒ�t���O
Dim Ret						'�֐��߂�l
Dim i, j, k					'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon          = Server.CreateObject("HainsCommon.Common")
Set objContract        = Server.CreateObject("HainsContract.Contract")
Set objContractControl = Server.CreateObject("HainsContract.ContractControl")

'�����l�̎擾�i�_���{���j
strMode     = Request("mode")
strActMode  = Request("actMode")
strCalcMode = Request("calcMode")
strOrgCd1   = Request("orgCd1")
strOrgCd2   = Request("orgCd2")
strCtrPtCd  = Request("ctrPtCd")

'�����l�̎擾�i�I�v�V����������{���j
strOptCd      = Request("optCd")
strOptName    = Request("optName")
strSubCsCd    = Request("subCsCd")
strOptAddMode = Request("optAddMode")

'�����l�̎擾�i�I�v�V���������Ώۏ����j
strExistsIsr     = Request("existsIsr")
lngGender        = CLng("0" & Request("gender"))
strAge           = ConvIStringToArray(Request("age"))
strLastRefMode   = Request("lastRefMode")
strLastRefCsCd   = Request("lastRefCsCd")
strJudClassCd    = Request("judClassCd")
strSign          = Request("sign")
strJudCd         = Request("judCd")
strPerItemCd     = Request("perItemCd")
strPerSuffix     = Request("perSuffix")
strPerResultType = Request("perResultType")
strPerItemType   = Request("perItemType")
strPerResult     = Request("perResult")
strCslFlg        = Request("cslFlg")
strNightDutyFlg  = Request("nightDutyFlg")

'�����l�̎擾�i�������j
strDmdLineClassCd    = Request("dmdLineClassCd")
strIsrDmdLineClassCd = Request("isrDmdLineClassCd")
strApDiv             = ConvIStringToArray(Request("apDiv"))
strSeq               = ConvIStringToArray(Request("seq"))
strBdnOrgCd1         = ConvIStringToArray(Request("bdnOrgCd1"))
strBdnOrgCd2         = ConvIStringToArray(Request("bdnOrgCd2"))
strArrOrgName        = ConvIStringToArray(Request("orgName"))
strOrgDiv            = ConvIStringToArray(Request("orgDiv"))
strPrice             = ConvIStringToArray(Request("price"))
strTax               = ConvIStringToArray(Request("tax"))
strCtrOrgDiv         = ConvIStringToArray(Request("ctrOrgDiv"))

'�����l�̎擾�i��f���ڏ��j
strGrpCd       = Split(Request("grpCd"),       ",")
strGrpName     = Split(Request("grpName"),     ",")
strItemCd      = Split(Request("itemCd"),      ",")
strRequestName = Split(Request("requestName"), ",")

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do
	'���샂�[�h���Ƃ̐���
	Select Case strActMode

		'�폜�{�^��������
		Case ACTMODE_DELETE

			'�w��_��p�^�[���A�I�v�V�����R�[�h�̃I�v�V�������������폜
			Ret = objContractControl.DeleteOption(strOrgCd1, strOrgCd2, strCtrPtCd, strOptCd)
			Select Case Ret
				Case 0
				Case 1, 2
					strMessage = Array("���̃I�v�V�������Q�Ƃ��Ă����f��񂪑��݂��܂��B�폜�ł��܂���B")
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

			'�O��l�Q�Ɨp�R�[�X�R�[�h�ƒ�����f�t���O�̐ݒ�
			strUpdCsCd    = IIf(strLastRefCsCd = CSCD_REGULAR, "", strLastRefCsCd)
			strRegularFlg = IIf(strLastRefCsCd = CSCD_REGULAR, "1", "")

			'COM�Ăяo���p�̏������[�h�ݒ�
			Select Case strMode
				Case MODE_INSERT, MODE_COPY
					strMode2 = MODE_INSERT
				Case MODE_UPDATE
					strMode2 = MODE_UPDATE
			End Select

			'�ǉ��I�v�V������������
			Ret = objContractControl.SetAddOption(strMode2,             _
												  strOrgCd1,            _
												  strOrgCd2,            _
												  strCtrPtCd,           _
												  strOptCd,             _
												  strOptName,           _
												  strSubCsCd,           _
												  strDmdLineClassCd,    _
												  strIsrDmdLineClassCd, _
												  strOptAddMode,        _
												  lngGender,            _
												  strExistsIsr,         _
												  strLastRefMode,       _
												  strUpdCsCd,           _
												  strRegularFlg,        _
												  strJudClassCd,        _
												  strSign,              _
												  strJudCd,             _
												  strNightDutyFlg,      _
												  strPerItemCd,         _
												  strPerSuffix,         _
												  strPerResult,         _
												  strCslFlg,            _
												  strStrAge,            _
												  strEndAge,            _
												  strSeq,               _
												  strBdnOrgCd1,         _
												  strBdnOrgCd2,         _
												  strPrice,             _
												  strTax,               _
												  strCtrOrgDiv,         _
												  strGrpCd,             _
												  strItemCd)

			Select Case Ret
				Case 0
				Case 1
					strMessage = Array("���̌_����̕��S�����͕ύX����Ă��܂��B�X�V�ł��܂���B")
					Exit Do
				Case 2
					strMessage = Array("�������z���ݒ肳��Ă��镉�S���̕��S���z�ɂ͕K���l����͂���K�v������܂��B")
					Exit Do
				Case 3
					strMessage = Array("����I�v�V�����R�[�h�̃I�v�V�������������łɑ��݂��܂��B")
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
		If objContract.SelectCtrPtOpt(strCtrPtCd,           strOptCd,          _
									  strOptName,           strOptDiv,         _
									  strSubCsCd,           strDmdLineClassCd, _
									  strIsrDmdLineClassCd, strOptAddMode,     _
									  lngGender,            strExistsIsr,      _
									  strLastRefMode,       strLastRefCsCd,    _
									  strRegularFlg,        strJudClassCd,     _
									  strSign,              strJudCd,          _
									  strNightDutyFlg,      strPerItemCd,      _
									  strPerSuffix,         strPerItemName,    _
									  strPerResultType,     strPerItemType,    _
									  strPerResult,         strCslFlg) = False Then
			Err.Raise 1000, ,"�I�v�V����������񂪑��݂��܂���B"
		End If

		'���z�v�Z���[�h�̐ݒ�
		strCalcMode = IIf(strDmdLineClassCd <> "" Or strIsrDmdLineClassCd <> "", CALCMODE_NORMAL, CALCMODE_ROUNDUP)

		'�O��l�Q�Ɨp�R�[�X�R�[�h�̐ݒ�
		strLastRefCsCd = IIf(strRegularFlg = "1", CSCD_REGULAR, strLastRefCsCd)

		'�_��p�^�[���I�v�V�����N��������̓ǂݍ���
		objContract.SelectCtrPtOptAge strCtrPtCd, strOptCd, strStrAge, strEndAge

		'��f�ΏۊJ�n�E�I���N����f�Ώ۔N��z��ւ̕ϊ�
		Call RevConvAgeArray(strStrAge, strEndAge, strAge)

		'�_��p�^�[���O���[�v���̓ǂݍ���
		objContract.SelectCtrPtGrp strCtrPtCd, strOptCd, strGrpCd, strGrpName

		'�_��p�^�[���������ڏ��̓ǂݍ���
		objContract.SelectCtrPtItem strCtrPtCd, strOptCd, strItemCd, strRequestName

		'�_��p�^�[�����S���z���̓ǂݍ���
		lngCount = objContract.SelectCtrPtOrgPrice(strCtrPtCd, strOptCd, strSeq, strApDiv, strBdnOrgCd1, strBdnOrgCd2, strArrOrgName, , strPrice, strTax, , , , , , , strOrgDiv, strCtrOrgDiv)
		If lngCount <= 0 Then
			Err.Raise 1000, ,"�_���񂪑��݂��܂���B"
		End If

		'�R�s�[���[�h�̏ꍇ�̓I�v�V�����R�[�h���N���A����
		If strMode = MODE_COPY Then
			strOptCd = ""
		End If

		Exit Do
	End If

	'�V�K���[�h�̏ꍇ

	'���ׂĂ̔N����`�F�b�N�ΏۂƂ����邽�߂̏����l���쐬
	strStrAge = Array("0")
	strEndAge = Array("999")
	Call RevConvAgeArray(strStrAge, strEndAge, strAge)

	'�_��p�^�[�����S���z���̓ǂݍ���
	lngCount = objContract.SelectCtrPtOrgPrice(strCtrPtCd, , strSeq, strApDiv, strBdnOrgCd1, strBdnOrgCd2, strArrOrgName, , strPrice, strTax, , , , , , , strOrgDiv, strCtrOrgDiv)
	If lngCount <= 0 Then
		Err.Raise 1000, ,"�_���񂪑��݂��܂���B"
	End If

	'�����蓮�ݒ胂�[�h�̏ꍇ�͂����ŏ����I��
	If strCalcMode = CALCMODE_NORMAL Then
		Exit Do
	End If

	'�������ڒP���ώZ���[�h�̐V�K�o�^���͒c�̎�ʂ̏����l��ݒ肷��
	blnSet = False
	For i = 0 To lngCount - 1

		Do
			'�_��c�̎��g���f�t�H���g���S���Ə��Ƃ���
			If strApDiv(i) = CStr(APDIV_MYORG) Then
				strCtrOrgDiv(i) = "0"
				Exit Do
			End If

			'�ŏ��Ɍ������ꂽ���ۗp�c�̂��f�t�H���g���S���ۂƂ���
			If Not blnSet And strOrgDiv(i) = "1" Then
				strCtrOrgDiv(i) = "1"
				blnSet = True
				Exit Do
			End If

			'����ȊO�͒c�̎�ʂ�ݒ肵�Ȃ�
			strCtrOrgDiv(i) = ""
			Exit Do
		Loop

	Next

	Exit Do
Loop

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

	Dim lngStrAgeInt	'��f�ΏۊJ�n�N��(�N��)
	Dim lngStrAgeDec	'��f�ΏۊJ�n�N��(����)
	Dim lngEndAgeInt	'��f�ΏۏI���N��(�N��)
	Dim lngEndAgeDec	'��f�ΏۏI���N��(����)

	Dim strArrMessage	'�G���[���b�Z�[�W�̔z��
	Dim strMessage		'�G���[���b�Z�[�W
	Dim blnPriceError	'���z�G���[�t���O
	Dim blnError1		'�G���[�t���O�P
	Dim blnError2		'�G���[�t���O�Q
	Dim i				'�C���f�b�N�X

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'�I�v�V�����R�[�h�`�F�b�N
	strMessage = objCommon.CheckNumeric("�I�v�V�����R�[�h", strOptCd, LENGTH_OPTCD, CHECK_NECESSARY)
	If strMessage <> "" Then
		objCommon.AppendArray strArrMessage, strMessage
	Else
		'�O�͋����Ȃ�
		If CLng(strOptCd) = 0 Then
			objCommon.AppendArray strArrMessage, "�I�v�V�����R�[�h�ɂ͂P�ȏ�̒l��ݒ肵�Ă��������B"
		End If
	End If

	'�I�v�V�������`�F�b�N
	objCommon.AppendArray strArrMessage, objCommon.CheckWideValue("�I�v�V������", strOptName, LENGTH_OPTNAME, CHECK_NECESSARY)

	'��f�������݃`�F�b�N
	If strOptAddMode = "" Then
		objCommon.AppendArray strArrMessage, "��f�������w�肵�ĉ������B"
	End If

	'�O��l�����`�F�b�N
	Do

		'�������͂���Ă��Ȃ���ΐ���
		If strLastRefCsCd & strJudClassCd & strSign & strJudCd = "" Then
			Exit Do
		End If

		'���蕪�ށA����A�����L�����S�ē��͂���Ă���ΐ���
		If strJudClassCd <> "" And strJudCd <> "" And strSign <> "" Then
			Exit Do
		End If

		'��L�ȊO�̓G���[
		objCommon.AppendArray strArrMessage, "�O��l�̏����w�肪�s���S�ł��B"
		Exit Do
	Loop

	'�l�������ʏ����`�F�b�N
	Do

		'�������͂���Ă��Ȃ���ΐ���
		If strPerItemCd & strPerSuffix & strPerResult & strCslFlg = "" Then
			Exit Do
		End If

		'�S�ē��͂���Ă���ΐ���
		If strPerItemCd <> "" And strPerSuffix <> "" And strPerResult <> "" And strCslFlg <> "" Then
			Exit Do
		End If

		'��L�ȊO�̓G���[
		objCommon.AppendArray strArrMessage, "�l�������ʂ̏����w�肪�s���S�ł��B"
		Exit Do
	Loop

	'�����蓮�ݒ莞�͐������ו��ށA���ې������ו��ނ̂����ꂩ���K�{
	If strCalcMode = CALCMODE_NORMAL And strDmdLineClassCd = "" And strIsrDmdLineClassCd = "" Then
		objCommon.AppendArray strArrMessage, "�������ށA���ې������ނ̂����ꂩ���w�肵�ĉ������B"
	End If

	blnPriceError = False

	'���S���z�`�F�b�N
	For i = 0 To UBound(strPrice)
		strMessage = objCommon.CheckNumeric("���S���z", strPrice(i), LENGTH_CTRPT_PRICE_PRICE)
		If strMessage <> "" Then
			objCommon.AppendArray strArrMessage, strMessage
			blnPriceError = True
			Exit For
		End If
	Next

	'����Ń`�F�b�N
	For i = 0 To UBound(strTax)
		strMessage = objCommon.CheckNumeric("�����", strTax(i), LENGTH_CTRPT_PRICE_PRICE)
		If strMessage <> "" Then
			objCommon.AppendArray strArrMessage, strMessage
			blnPriceError = True
			Exit For
		End If
	Next

	'���ۗL���敪�Ƌ��z�ݒ�̊֘A�`�F�b�N
	Do

		'���z�G���[���͉������Ȃ�
		If blnPriceError Then
			Exit Do
		End If

		'���ۗL���敪�����ۂȂ��ȊO�̏ꍇ�̓`�F�b�N�s�v
		If strExistsIsr <> EXISTSISR_NOT_EXISTS Then
			Exit Do
		End If

		'���S���z��������
		For i = 0 To UBound(strApDiv)

			'�c�̎�ʂ����ۂ̏ꍇ
			If strOrgDiv(i) = "1" Then

				'���S���z�܂��͏���łɒl�����݂���ꍇ�̓G���[
				If CLng(strPrice(i) & "0") <> 0 Or CLng(strTax(i) & "0") <> 0 Then
					objCommon.AppendArray strArrMessage, "���ە��S�敪���u���ۂȂ��v�̏ꍇ�A���ۂɕ��S���z�͐ݒ�ł��܂���B"
					Exit Do
				End If

			End If
		Next

		Exit Do
	Loop

	'�������ނƋ��z�ݒ�̊֘A�`�F�b�N
	Do

		'���z�G���[���͉������Ȃ�
		If blnPriceError Then
			Exit Do
		End If

		blnError1 = False
		blnError2 = False

		'���S���z��������
		For i = 0 To UBound(strApDiv)

			'���S���z�܂��͏���łɒl�����݂���ꍇ
			If CLng(strPrice(i) & "0") <> 0 Or CLng(strTax(i) & "0") <> 0 Then

				'�c�̎�ʂ��u�c�́v�ł��������ނ����ݒ�̏ꍇ�̓G���[
				If blnError1 = False And strOrgDiv(i) = "0" And strDmdLineClassCd = "" Then
					objCommon.AppendArray strArrMessage, "�c�̕��S���z�ݒ莞�͕K���������ނ��w�肷��K�v������܂��B"
					blnError1 = True
				End If

				'�c�̎�ʂ��u���ہv�ł����ې������ނ����ݒ�̏ꍇ�̓G���[
				If blnError2 = False And strOrgDiv(i) = "1" And strIsrDmdLineClassCd = "" Then
					objCommon.AppendArray strArrMessage, "���ە��S���z�ݒ莞�͕K�����ې������ނ��w�肷��K�v������܂��B"
					blnError2 = True
				End If

			End If

			'�o���ŃG���[�����������ꍇ�A����ȏ�`�F�b�N�𑱂���K�v�͂Ȃ�
			If blnError1 And blnError2 Then
				Exit Do
			End If

		Next

		Exit Do
	Loop

	'�`�F�b�N���ʂ�Ԃ�
	CheckValue = strArrMessage

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
<TITLE>�I�v�V���������̓o�^</TITLE>
<SCRIPT TYPE="text/javascript">
<!-- #include virtual = "/webHains/includes/price.inc"    -->
<!-- #include virtual = "/webHains/includes/itmGuide.inc" -->
<!-- #include virtual = "/webHains/includes/stcGuide.inc" -->
<!-- #include virtual = "/webHains/includes/tseGuide.inc" -->
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

// ���ʊ֘A�K�C�h�Ăяo��
function callResultGuide() {

	// ���ʃ^�C�v�ɂ�鏈������
	switch ( document.entryForm.perResultType.value ) {

		// �萫�̏ꍇ
		case '<%= RESULTTYPE_TEISEI1 %>':
		case '<%= RESULTTYPE_TEISEI2 %>':
			callTseGuide();
			break;

		case '<%= RESULTTYPE_SENTENCE %>':
			callStcGuide();

		default:

	}

}

// ���̓K�C�h�Ăяo��
function callStcGuide() {

	var myForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g

	// �������ڃR�[�h�E���ڃ^�C�v�̐ݒ�
	stcGuide_ItemCd   = myForm.perItemCd.value;
	stcGuide_ItemType = myForm.perItemType.value;

	// �K�C�h��ʂ̘A����ɃK�C�h��ʂ���Ăяo����鎩��ʂ̊֐���ݒ肷��
	stcGuide_CalledFunction = setStcResultInfo;

	// ���̓K�C�h�\��
	showGuideStc();
}

// �萫���ʃK�C�h�Ăяo��
function callTseGuide() {

	// ���ʃ^�C�v�̐ݒ�
	tseGuide_ResultType = document.entryForm.perResultType.value;

	// �K�C�h��ʂ̘A����ɃK�C�h��ʂ���Ăяo����鎩��ʂ̊֐���ݒ肷��
	tseGuide_CalledFunction = setTeiseiResultInfo;

	// �萫���ʃK�C�h�\��
	showGuideTse();

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

	// �m�F���b�Z�[�W�̕\��
	if ( !confirm('���̃I�v�V�����������폜���܂��B��낵���ł����H') ) {
		return;
	}

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

// �c�̎�ʂ̐ݒ�
function setCtrOrgDiv( index, ctrOrgDiv ) {

	var myForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g
	var i;								// �C���f�b�N�X

	// ���S�����P���̏ꍇ
	if ( !myForm.apDiv.length ) {
		myForm.ctrOrgDiv.value = ctrOrgDiv;
		return;
	}

	// ���S���������̏ꍇ
	for ( i = 0; i < myForm.apDiv.length; i++ ) {

		// �w�肳�ꂽ�C���f�b�N�X�̒c�̎�ʂ�ݒ�
		if ( i == index ) {
			myForm.ctrOrgDiv[ i ].value = ctrOrgDiv;
			continue;
		}

		// �w��C���f�b�N�X�ȊO�̏ꍇ�A�ȑO�̐ݒ�l���N���A
		if ( myForm.ctrOrgDiv[ i ].value == ctrOrgDiv ) {
			myForm.ctrOrgDiv[ i ].value = '';
		}

	}

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

	// ���̓K�C�h��ʂ����
	closeGuideStc();

	// �萫���ʃK�C�h��ʂ����
	closeGuideTse();

}

// �v�Z����
function calculate() {

	calcPrice( document.entryForm.price, 'totalPrice' );
	calcPrice( document.entryForm.tax,   'totalTax'   );

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 0; }
</style>
</HEAD>
<BODY ONLOAD="javascript:calculate()" ONUNLOAD="javascript:closeWindow()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="mode"        VALUE="<%= strMode %>">
	<INPUT TYPE="hidden" NAME="actMode"     VALUE="">
	<INPUT TYPE="hidden" NAME="calcMode"    VALUE="<%= strCalcMode %>">
	<INPUT TYPE="hidden" NAME="orgCd1"      VALUE="<%= strOrgCd1   %>">
	<INPUT TYPE="hidden" NAME="orgCd2"      VALUE="<%= strOrgCd2   %>">
	<INPUT TYPE="hidden" NAME="ctrPtCd"     VALUE="<%= strCtrPtCd  %>">
	<INPUT TYPE="hidden" NAME="grpCd"       VALUE="">
	<INPUT TYPE="hidden" NAME="grpName"     VALUE="">
	<INPUT TYPE="hidden" NAME="itemCd"      VALUE="">
	<INPUT TYPE="hidden" NAME="requestName" VALUE="">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="contract">��</SPAN><FONT COLOR="#000000">�I�v�V���������̓o�^</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'�G���[���b�Z�[�W�̕ҏW
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)

	'�_����̓ǂݍ���
	If Not objContract.SelectCtrMng(strOrgCd1, strOrgCd2, strCtrPtCd, strOrgName, strCsCd, strCsName, dtmStrDate, dtmEndDate) Then
		Err.Raise 1000, ,"�_���񂪑��݂��܂���B"
	End If
%>
	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
		<TR>
			<TD>�_��c��</TD>
			<TD>�F</TD>
			<TD WIDTH="100%" NOWRAP><B><%= strOrgName %></B></TD>
<%
			'�X�V���́u�폜�v�{�^����p�ӂ���
			If strMode = MODE_UPDATE Then
%>
				<TD ALIGN="right" VALIGN="bottom" ROWSPAN="5"><A HREF="javascript:deleteOption()"><IMG SRC="/webHains/images/delete.gif" WIDTH="77" HEIGHT="24" ALT="�폜"></A></TD>
				<TD>&nbsp;</TD>
<%
				'�R�s�[������URL�ҏW
				strURL = Request.ServerVariables("SCRIPT_NAME")
				strURL = strURL & "?orgCd1="   & strOrgCd1
				strURL = strURL & "&orgCd2="   & strOrgCd2
				strURL = strURL & "&ctrPtCd="  & strCtrPtCd
				strURL = strURL & "&optCd="    & strOptCd
				strURL = strURL & "&mode="     & MODE_COPY
%>
				<TD ALIGN="right" VALIGN="bottom" ROWSPAN="5"><A HREF="<%= strURL %>"><IMG SRC="/webHains/images/copy.gif" WIDTH="77" HEIGHT="24" ALT="�R�s�["></A></TD>
				<TD>&nbsp;</TD>
<%
			End If
%>

			<TD ALIGN="right" VALIGN="bottom" ROWSPAN="5"><A HREF="javascript:submitForm('<%= ACTMODE_SAVE %>')"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="�ۑ�"></A></TD>
			<TD>&nbsp;</TD>
<%
			'�V�K���́u�߂�v�{�^���A����ȊO(�X�V�E�R�s�[��)�́u�L�����Z���v�{�^����p�ӂ���
			If strMode = MODE_INSERT Then

				'�_����Q�ƁE�o�^�pURL�̕ҏW
				strURL = "ctrOptionGate.asp"
				strURL = strURL & "?orgCd1="   & strOrgCd1
				strURL = strURL & "&orgCd2="   & strOrgCd2
				strURL = strURL & "&ctrPtCd="  & strCtrPtCd
				strURL = strURL & "&calcMode=" & strCalcMode
%>
				<TD ALIGN="right" VALIGN="bottom" ROWSPAN="5"><A HREF="<%= strURL %>"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�߂�"></A></TD>
<%
			Else
%>
				<TD ALIGN="right" VALIGN="bottom" ROWSPAN="5"><A HREF="javascript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z��"></A></TD>
<%
			End If
%>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD NOWRAP>�ΏۃR�[�X</TD>
			<TD>�F</TD>
			<TD NOWRAP><B><%= strCsName %></B></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD>�_�����</TD>
			<TD>�F</TD>
			<TD NOWRAP><B><%= objCommon.FormatString(dtmStrDate, "yyyy�Nm��d��") %>�`<%= objCommon.FormatString(dtmEndDate, "yyyy�Nm��d��") %></B></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="1" WIDTH="850">
		<TR>
			<TD BGCOLOR="#eeeeee" NOWRAP>��{���</TD>
		</TR>
		<TR>
			<TD HEIGHT="3"></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD NOWRAP>�I�v�V�����R�[�h</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
					<TR>
<%
						'�V�K�E�R�s�[���ɃI�v�V�����R�[�h�̓e�L�X�g���͉Ƃ��A�X�V���͕\���݂̂Ƃ���
						If strMode = MODE_INSERT Or strMode = MODE_COPY Then
%>
							<TD><INPUT TYPE="text" NAME="optCd" SIZE="3" MAXLENGTH="3" VALUE="<%= strOptCd %>"></TD>
<%
						Else
%>
							<TD><INPUT TYPE="hidden" NAME="optCd" VALUE="<%= strOptCd %>"><B><%= strOptCd %></B>&nbsp;&nbsp;</TD>
<%
						End If
%>
						<TD NOWRAP>�I�v�V�������F</TD>
						<TD><INPUT TYPE="text" NAME="optName" SIZE="<%= TextLength(LENGTH_OPTNAME) %>" MAXLENGTH="<%= TextMaxLength(LENGTH_OPTNAME) %>" VALUE="<%= strOptName %>"></TD>
						<TD NOWRAP>�T�u�R�[�X�F</TD>
						<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_SUB, "subCsCd", IIf(strSubCsCd <> "", strSubCsCd, strCsCd), NON_SELECTED_DEL, False) %></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>��f����</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
					<TR>
						<TD>
							<SELECT NAME="optAddMode">
<%
								'�V�K���͋�s��p�ӂ���
								If strMode = MODE_INSERT Then
%>
									<OPTION VALUE="">
<%
								End If
%>
								<OPTION VALUE="<%= OPTADDMODE_FREE      %>" <%= IIf(strOptAddMode = CStr(OPTADDMODE_FREE),      "SELECTED", "") %>>��]�҂̂�
								<OPTION VALUE="<%= OPTADDMODE_ALL       %>" <%= IIf(strOptAddMode = CStr(OPTADDMODE_ALL),       "SELECTED", "") %>>�S�Ă̎�f�҂�Ώ�
								<OPTION VALUE="<%= OPTADDMODE_CONDITION %>" <%= IIf(strOptAddMode = CStr(OPTADDMODE_CONDITION), "SELECTED", "") %>>�����w��
							</SELECT>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD COLSPAN="2"></TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
					<TR>
						<TD>����</TD>
						<TD>�F</TD>
						<TD>
							<SELECT NAME="existsIsr">
								<OPTION VALUE=""  <%= IIf(strExistsIsr = "",                   "SELECTED", "") %>>�w��Ȃ�
								<OPTION VALUE="0" <%= IIf(strExistsIsr = EXISTSISR_NOT_EXISTS, "SELECTED", "") %>>���ۂȂ�
								<OPTION VALUE="1" <%= IIf(strExistsIsr = EXISTSISR_EXISTS,     "SELECTED", "") %>>���ۂ���
							</SELECT>
						</TD>
					</TR>
					<TR>
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
											<TD><INPUT TYPE="checkbox" NAME="age" VALUE="<%= i %>" <%= IIf(CheckDateCheckBox(strAge, i), "CHECKED", "") %>></TD>
											<TD NOWRAP><%= i %>��</TD>
<%
											i = i + 1
										Next
%>
										<TD BGCOLOR="#FFFFFF" VALIGN="BOTTOM">&nbsp;<A HREF="javascript:checkAge( 1, <%= i - 10 %>, <%= i - 1 %> )"><IMG SRC="/webHains/images/allcheck.gif" WIDTH="97" HEIGHT="13" ALT="���̍s���ׂă`�F�b�N"></A></TD>
									</TR>
<%
								Next
%>
								<TR>
									<TD><INPUT TYPE="checkbox" NAME="age" VALUE="100" <%= IIf(CheckDateCheckBox(strAge, 100), "CHECKED", "") %>></TD>
									<TD COLSPAN="19" NOWRAP>100�Έȏ�</TD>
									<TD VALIGN="BOTTOM">&nbsp;&nbsp;&nbsp;<A HREF="javascript:checkAge( 0, 0, 100 )"><IMG SRC="/webHains/images/alloff.gif" WIDTH="97" HEIGHT="13" ALT="���ׂăI�t�ɂ���"></A></TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
					<TR>
						<TD>�O��l</TD>
						<TD>�F</TD>
						<TD>
							<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
								<TR>
									<TD NOWRAP>�O��R�[�X</TD>
									<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "lastRefCsCd", strLastRefCsCd, "�w��Ȃ�", True) %></TD>
									<TD NOWRAP>�ɂ�����</TD>
									<TD><%= EditJudClassList("judClassCd", strJudClassCd, NON_SELECTED_ADD) %></TD>
									<TD NOWRAP>�̔��肪</TD>
									<TD><%= EditJudList("judCd", strJudCd) %></TD>
									<TD>
										<SELECT NAME="sign">
											<OPTION VALUE=""  <%= IIf(strSign = "",  "SELECTED", "") %>>
											<OPTION VALUE="0" <%= IIf(strSign = "0", "SELECTED", "") %>>�Ɠ�����
											<OPTION VALUE="1" <%= IIf(strSign = "1", "SELECTED", "") %>>�ȏ�
											<OPTION VALUE="2" <%= IIf(strSign = "2", "SELECTED", "") %>>�ȉ�
										</SELECT>
									</TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
					<TR>
						<TD COLSPAN="2"></TD>
						<TD>
							<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
								<TR>
									<TD><INPUT TYPE="radio" NAME="lastRefMode" VALUE="0" <%= IIf(strLastRefMode <> "1", "CHECKED", "") %>></TD>
									<TD NOWRAP>���ׂĂ̌��f��������</TD>
									<TD><INPUT TYPE="radio" NAME="lastRefMode" VALUE="1" <%= IIf(strLastRefMode  = "1", "CHECKED", "") %>></TD>
									<TD NOWRAP>���߂P�N���̌��f��������</TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
					<TR>
						<TD NOWRAP>�l��������</TD>
						<TD>�F</TD>
						<TD>
							<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
								<TR>
									<TD><A HREF="javascript:callItemGuide( 2, 0, 1, 1, setItemInfo )"><IMG SRC="/webHains/images/question.gif" ALT="" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
									<TD><A HREF="javascript:editItemInfo( '', '', '', '', '' )"><IMG SRC="/webHains/images/delicon.gif"  ALT="" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
									<TD WIDTH="200" NOWRAP>
										<INPUT TYPE="hidden" NAME="perItemCd"     VALUE="<%= strPerItemCd     %>">
										<INPUT TYPE="hidden" NAME="perSuffix"     VALUE="<%= strPerSuffix     %>">
										<INPUT TYPE="hidden" NAME="perResultType" VALUE="<%= strPerResultType %>">
										<INPUT TYPE="hidden" NAME="perItemType"   VALUE="<%= strPerItemType   %>">
										<SPAN ID="perItemName"><%= strPerItemName %></SPAN>
									</TD>
									<TD NOWRAP>�̌��ʂ�</TD>
									<TD><A HREF="javascript:callResultGuide()"><IMG SRC="/webHains/images/question.gif" ALT="" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
									<TD><INPUT TYPE="text" NAME="perResult" SIZE="10" MAXLENGTH="8" VALUE="<%= strPerResult %>"></TD>
									<TD NOWRAP>�̏ꍇ�Ɏ�f�Ώۂ�</TD>
									<TD>
										<SELECT NAME="cslFlg">
											<OPTION VALUE=""  <%= IIf(strCslFlg = "",  "SELECTED", "") %>>
											<OPTION VALUE="0" <%= IIf(strCslFlg = "0", "SELECTED", "") %>>���Ȃ�
											<OPTION VALUE="1" <%= IIf(strCslFlg = "1", "SELECTED", "") %>>����
										</SELECT>
									</TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
					<TR>
						<TD COLSPAN="2"></TD>
						<TD NOWRAP><FONT COLOR="#666666">�i�u��f�ΏۂƂ��Ȃ��v��I�������ꍇ�A���̎�f�����͖����ƂȂ�܂��B�j</FONT></TD>
					</TR>
					<TR>
						<TD>��ΎҌ��f</TD>
						<TD>�F</TD>
						<TD>
							<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
								<TR>
									<TD><INPUT TYPE="checkbox" NAME="nightDutyFlg" VALUE="1" <%= IIf(strNightDutyFlg = "1", "CHECKED", "") %>></TD>
									<TD NOWRAP>��ΎҌ��f�Ώێ҂̂ݎ�f</TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="1" WIDTH="850">
		<TR BGCOLOR="#eeeeee">
			<TD WIDTH="400" NOWRAP>�������</TD>
			<TD NOWRAP>��f����</TD>
		</TR>
		<TR>
			<TD VALIGN="top">
<%
				'�������[�h���Ƃ̕\������
				Select Case strCalcMode

					'�����蓮�ݒ莞
					Case CALCMODE_NORMAL
%>
						<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
							<TR>
								<TD HEIGHT="2"></TD>
							</TR>
							<TR>
								<TD>��������</TD>
								<TD>�F</TD>
								<TD><%= Tokyu_EditDmdLineClassList(EDITDMDLINECLASSLIST_MODE_NORMAL, "dmdLineClassCd", strDmdLineClassCd, NON_SELECTED_ADD) %></TD>
							</TR>
							<TR>
								<TD NOWRAP>���ې�������</TD>
								<TD>�F</TD>
								<TD><%= Tokyu_EditDmdLineClassList(EDITDMDLINECLASSLIST_MODE_ISR, "isrDmdLineClassCd", strIsrDmdLineClassCd, NON_SELECTED_ADD) %></TD>
							</TR>
						</TABLE>

						<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="1">
							<TR>
								<TD HEIGHT="2"></TD>
							</TR>
							<TR BGCOLOR="#eeeeee">
								<TD WIDTH="300" COLSPAN="2" NOWRAP>���S��</TD>
								<TD WIDTH="90"  NOWRAP>���S���z</TD>
								<TD WIDTH="90"  NOWRAP>�����</TD>
							</TR>
							<TR>
								<TD HEIGHT="2"></TD>
							</TR>
<%
							'�c�̎w��̕��S���ҏW
							For i = 0 To UBound(strSeq)
%>
								<TR>
									<TD COLSPAN="2">
										<INPUT TYPE="hidden" NAME="apDiv"     VALUE="<%= strApDiv(i)      %>">
										<INPUT TYPE="hidden" NAME="seq"       VALUE="<%= strSeq(i)        %>">
										<INPUT TYPE="hidden" NAME="bdnOrgCd1" VALUE="<%= strBdnOrgCd1(i)  %>">
										<INPUT TYPE="hidden" NAME="bdnOrgCd2" VALUE="<%= strBdnOrgCd2(i)  %>">
										<INPUT TYPE="hidden" NAME="orgName"   VALUE="<%= strArrOrgName(i) %>">
										<INPUT TYPE="hidden" NAME="orgDiv"    VALUE="<%= strOrgDiv(i)     %>">
										<INPUT TYPE="hidden" NAME="ctrOrgDiv" VALUE="">
										<%= IIf(strApDiv(i) = CStr(APDIV_MYORG), strOrgName, strArrOrgName(i)) %>
									</TD>
									<TD ALIGN="right"><INPUT TYPE="text" NAME="price" SIZE="<%= TextLength(LENGTH_CTRPT_PRICE_PRICE) %>" MAXLENGTH="<%= LENGTH_CTRPT_PRICE_PRICE %>" STYLE="text-align:right;ime-mode:disabled" VALUE="<%= strPrice(i) %>"></TD>
									<TD ALIGN="right"><INPUT TYPE="text" NAME="tax"   SIZE="<%= TextLength(LENGTH_CTRPT_PRICE_PRICE) %>" MAXLENGTH="<%= LENGTH_CTRPT_PRICE_PRICE %>" STYLE="text-align:right;ime-mode:disabled" VALUE="<%= strTax(i)   %>"></TD>
								</TR>
<%
							Next
%>
							<TR>
								<TD HEIGHT="5"></TD>
								<TD>���������E�̎����o�͖��͋󔒂̏ꍇ�A�����I�ɃZ�b�g�����K�p����܂��B</TD>
							</TR>
							<TR>
								<TD HEIGHT="5"></TD>
								<TD></TD>
							</TR>
							<TR>
								<TD HEIGHT="1" BGCOLOR="#999999" COLSPAN="4"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1"></TD>
							</TR>
							<TR>
								<TD HEIGHT="1"></TD>
								<TD></TD>
							</TR>
							<TR>
								<TD>���S���z���v�ق�</TD>
								<TD ALIGN="right"><INPUT TYPE="button" VALUE="�Čv�Z" ONCLICK="javascript:calculate()"></TD>
								<TD ALIGN="right"><B><SPAN ID="totalPrice"></SPAN></B></TD>
								<TD ALIGN="right"><B><SPAN ID="totalTax"></SPAN></B></TD>
							</TR>
						</TABLE>
<%
					'�������ڒP���ώZ��
					Case CALCMODE_ROUNDUP
%>
						<BR>���z�v�Z���@�F<B>�������ڐݒ藿������v�Z�i�}��������j</B><BR><BR>

						<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="1">
							<TR BGCOLOR="#eeeeee">
								<TD WIDTH="280" NOWRAP>���S��</TD>
								<TD COLSPAN="2" NOWRAP>����</TD>
								<TD COLSPAN="2" NOWRAP>���Ə�</TD>
							</TR>
							<TR>
								<TD HEIGHT="2"></TD>
							</TR>
<%
							'�c�̎w��̕��S���ҏW
							For i = 0 To UBound(strSeq)
%>
								<TR>
									<TD>
										<INPUT TYPE="hidden" NAME="apDiv"     VALUE="<%= strApDiv(i)      %>">
										<INPUT TYPE="hidden" NAME="seq"       VALUE="<%= strSeq(i)        %>">
										<INPUT TYPE="hidden" NAME="bdnOrgCd1" VALUE="<%= strBdnOrgCd1(i)  %>">
										<INPUT TYPE="hidden" NAME="bdnOrgCd2" VALUE="<%= strBdnOrgCd2(i)  %>">
										<INPUT TYPE="hidden" NAME="orgName"   VALUE="<%= strArrOrgName(i) %>">
										<INPUT TYPE="hidden" NAME="orgDiv"    VALUE="<%= strOrgDiv(i)     %>">
										<INPUT TYPE="hidden" NAME="ctrOrgDiv" VALUE="<%= strCtrOrgDiv(i)  %>">
										<INPUT TYPE="hidden" NAME="price"     VALUE="">
										<INPUT TYPE="hidden" NAME="tax"       VALUE="">
										<%= IIf(strApDiv(i) = CStr(APDIV_MYORG), strOrgName, strArrOrgName(i)) %>
									</TD>
									<TD><INPUT TYPE="radio" NAME="isr" <%= IIf(strCtrOrgDiv(i) = "1", "CHECKED", "") & " " & IIf(strOrgDiv(i) <> "1", "DISABLED", "") %> ONCLICK="javascript:setCtrOrgDiv(<%= i %>, '1')"></TD>
									<TD NOWRAP>���S</TD>
									<TD><INPUT TYPE="radio" NAME="bsd" <%= IIf(strCtrOrgDiv(i) = "0", "CHECKED", "") & " " & IIf(strOrgDiv(i) =  "1", "DISABLED", "") %> ONCLICK="javascript:setCtrOrgDiv(<%= i %>, '0')"></TD>
									<TD NOWRAP>���S</TD>
								</TR>
<%
							Next
%>
						</TABLE>
<%
				End Select
%>
			</TD>
			<TD VALIGN="top">
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
							<A HREF="javascript:callItemGuide( 1, 1, 1, 0, editList )"><IMG SRC="/webHains/images/additem.gif" WIDTH="77" HEIGHT="24" ALT="��f���ڂ�ǉ����܂�"></A><BR>
						</TD>
					</TR>
					<TR>
						<TD VALIGN="BOTTOM">
							<A HREF="javascript:deleteItem()"><IMG SRC="/webHains/images/delitem.gif" WIDTH="77" HEIGHT="24" ALT="�I��������f���ڂ��폜���܂�"></A>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

	</BLOCKQUOTE>
</FORM>
</BODY>
</HTML>