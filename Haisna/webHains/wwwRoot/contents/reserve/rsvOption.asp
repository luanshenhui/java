<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�\����ڍ�(�I�v�V�����������) (Ver0.0.1)
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
Const SETCLASS_REPEATER = "023"	'�Z�b�g����(���s�[�^����)

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objContract				'�_����A�N�Z�X�p
Dim objFree					'�ėp���A�N�Z�X�p
Dim objSchedule				'�X�P�W���[�����A�N�Z�X�p

'�����l(����)
Dim strRsvNo				'�\��ԍ�
Dim lngCancelFlg			'�L�����Z���t���O
Dim strPerId				'�l�h�c
Dim strGender				'����
Dim strBirth				'���N����
Dim strOrgCd1				'�c�̃R�[�h�P
Dim strOrgCd2				'�c�̃R�[�h�Q
Dim strCsCd					'�R�[�X�R�[�h
Dim strCslDate				'��f��
Dim strCslDivCd				'��f�敪�R�[�h
Dim strRsvGrpCd				'�\��Q�R�[�h
Dim strCtrPtCd				'(�ǂݍ��ݒ����)�_��p�^�[���R�[�h
Dim strOptCd				'(�ǂݍ��ݒ����)�I�v�V�����R�[�h
Dim strOptBranchNo			'(�ǂݍ��ݒ����)�I�v�V�����}��
'12.16
Dim strNowCtrPtCd			'(�{ASP�Ăяo�����O��)�_��p�^�[���R�[�h
Dim strNowOptCd				'(�{ASP�Ăяo�����O��)�I�v�V�����R�[�h
Dim strNowOptBranchNo		'(�{ASP�Ăяo�����O��)�I�v�V�����}��
'12.16
Dim strChanged				'��{���(�c�́E�R�[�X�E��f�敪)����������ύX����Ă��邩
Dim strShowAll				'"1":���ׂĂ̌�����\��
Dim strInit					'�����ǂݍ��݂�
Dim strReadNoRep			'�w�莞�̓��s�[�^����ǂ܂Ȃ�
'## 2004.10.27 Add By T.Takagi@FSIT ���t�ύX���̓Z�b�g��r��ʂ������\��
Dim blnDateChanged			'���t���ύX����ČĂ΂ꂽ��
'## 2004.10.27 Add End

'�_����
Dim strNewCtrPtCd			'�_��p�^�[���R�[�h
Dim strAgeCalc				'�N��N�Z��
Dim strRefOrgCd1			'�Q�Ɛ�c�̃R�[�h�P
Dim strRefOrgCd2			'�Q�Ɛ�c�̃R�[�h�Q
Dim strCsName				'�R�[�X��

'�I�v�V�����������
Dim strArrOptCd				'�I�v�V�����R�[�h
Dim strArrOptBranchNo		'�I�v�V�����}��
Dim strOptName				'�I�v�V������
Dim strSetColor				'�Z�b�g�J���[
Dim strSetClassCd			'�Z�b�g���ރR�[�h
Dim strConsult				'��f�v��
Dim strBranchCount			'�I�v�V�����}�Ԑ�
Dim strAddCondition			'�ǉ�����
Dim strHideRsv				'�\���ʔ�\��
Dim strPrice				'�����z
Dim strPerPrice				'�l���S���z
'## 2004.01.04 Add By T.Takagi@FSIT ���S���L���̎擾
Dim strExistsPrice			'���S���̗L��
'## 2004.01.04 Add End
Dim lngCount				'�I�v�V����������

'��\���I�v�V�������
Dim strHideElementName()	'�G�������g��
Dim strHideOptCd()			'�I�v�V�����R�[�h
Dim strHideOptBranchNo()	'�I�v�V�����}��
Dim strHideConsult()		'��f�v��
Dim lngHideCount			'�I�v�V������

'�_����
Dim strArrCsCd				'�R�[�X�R�[�h
Dim strArrCsName			'�R�[�X��
Dim strArrCtrPtCd			'�_��p�^�[���R�[�h
Dim lngCtrCount				'�_����

'��f�敪���
Dim strArrCslDivCd			'��f�敪�R�[�h
Dim strArrCslDivName		'��f�敪��
Dim lngCslDivCount			'��f�敪��

'�\��Q���
Dim strArrRsvGrpCd			'�\��Q�R�[�h
Dim strArrRsvGrpName		'�\��Q����
Dim lngRsvGrpCount			'�\��Q��

Dim strAge					'��f���N��
Dim strRealAge				'���N��

Dim blnConsult				'��f�`�F�b�N�̗v��
Dim strChecked				'�`�F�b�N�{�b�N�X�̃`�F�b�N���

Dim strPrevOptCd			'���O���R�[�h�̃I�v�V�����R�[�h
Dim lngOptGrpSeq			'�I�v�V�����O���[�v��SEQ�l
Dim strElementType			'�I�v�V�����I��p�̃G�������g���
Dim strElementName			'�I�v�V�����I��p�̃G�������g��

Dim blnExist				'���݃t���O
Dim strMessage				'���b�Z�[�W
Dim strURL					'�W�����v���URL
Dim Ret						'�֐��߂�l
Dim i, j					'�C���f�b�N�X

Dim blnHasRepeaterSet		'�_��ɂ����郊�s�[�^�����Z�b�g�̗L��
Dim blnRepeaterConsult		'���s�[�^�����Z�b�g�̎�f�L��

'12.16
Dim strWkOptCd				'(�`�F�b�N���ׂ�)�I�v�V�����R�[�h
Dim strWkOptBranchNo		'(�`�F�b�N���ׂ�)�I�v�V�����}��
'12.16

Dim lngMode					'�Z�b�g�p�����[�h(0:�f�t�H���g��ԂɈˑ��A1:�����w�肳�ꂽ�Z�b�g��S�Čp���A2:�����w��Z�b�g�̂����C�ӎ�f�̂݌p��)

'## 2004.10.27 Add By T.Takagi@FSIT ���t�ύX���̓Z�b�g��r��ʂ������\��
Dim blnCompare				'�Z�b�g��r��ʕ\����
'## 2004.10.27 Add End


'## 2006.06.15 Add by ��
Const SETCLASS_GF	= "003"				'�P���h�b�N�i�ݓ������j
Const KOJIN_DANTAI	= "XXXXXXXXXX"		'�l��f��
Const CSCD_1		= "100"				'�R�[�X�R�[�h�i1���h�b�N�j
Dim strHideSetClassCd()
Dim strSetClassName
Dim blnGF
Dim blnRepeater
'## 2006.06.15 Add End

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objContract = Server.CreateObject("HainsContract.Contract")

'�\���{��񂩂瑗�M�����p�����[�^�l�̎擾
strRsvNo       = Request("rsvNo")
lngCancelFlg   = CLng("0" & Request("cancelFlg"))
strPerId       = Request("perId")
strGender      = Request("gender")
strBirth       = Request("birth")
strOrgCd1      = Request("orgCd1")
strOrgCd2      = Request("orgCd2")
strCsCd        = Request("csCd")
strCslDate     = Request("cslDate")
strCslDivCd    = Request("cslDivCd")
strRsvGrpCd    = Request("rsvGrpCd")
strCtrPtCd     = Request("ctrPtCd")
strOptCd       = ConvIStringToArray(Request("optCd"))
strOptBranchNo = ConvIStringToArray(Request("optBNo"))
'12.16
strNowCtrPtCd     = Request("nowCtrPtCd")
strNowOptCd       = ConvIStringToArray(Request("nowOptCd"))
strNowOptBranchNo = ConvIStringToArray(Request("notOptBNo"))
'12.16
strChanged     = Request("changed")
strShowAll     = Request("showAll")
strInit        = Request("init")
strReadNoRep   = Request("readNoRep")
'## 2004.10.27 Add By T.Takagi@FSIT ���t�ύX���̓Z�b�g��r��ʂ������\��
blnDateChanged = (Request("dateChanged") <> "")
'## 2004.10.27 Add End

Do

	'���t���������Ȃ��ꍇ�͉������Ȃ�
	If strCslDate = "" Or Not IsDate(strCslDate) Then
		Exit Do
	End If

	'���N��v�Z
	If strBirth <> "" And IsDate(strBirth) Then

		Set objFree = Server.CreateObject("HainsFree.Free")
		strRealAge = objFree.CalcAge(strBirth, strCslDate)
		Set objFree = Nothing

		'�����_�ȉ��̐؂�̂�
		If IsNumeric(strRealAge) Then
			strRealAge = CStr(Int(strRealAge))
		End If

	End If

	'�c�̂����݂��Ȃ��ꍇ�͉������Ȃ�
	If strOrgCd1 = "" Or strOrgCd2 = "" Then
		Exit Do
	End If

	'�w��c�̂ɂ������f�����_�ŗL���Ȃ��ׂẴR�[�X���_��Ǘ��������ɓǂݍ���
	lngCtrCount = objContract.SelectAllCtrMng(strOrgCd1, strOrgCd2, "", strCslDate, strCslDate, , strArrCsCd, , strArrCsName, , , , strArrCtrPtCd)
	If lngCtrCount <= 0 Then
		Exit Do
	End If

	'�w��c�̂ɂ������f�����_�ŗL���Ȏ�f�敪���_��Ǘ��������ɓǂݍ���(�R�[�X�w�莞�͂���ɂ��̃R�[�X�ŗL���Ȃ���)
	lngCslDivCount = objContract.SelectAllCslDiv(strOrgCd1, strOrgCd2, strCsCd, strCslDate, strCslDate, strArrCslDivCd, strArrCslDivName)
	If lngCslDivCount <= 0 Then
		Exit Do
	End If

	'��f�����_�ŗL���Ȃ��ׂẴR�[�X�Ɏw�肳�ꂽ�R�[�X�����݂��邩���������A���̌_��p�^�[���R�[�h���擾
	For i = 0 To lngCtrCount - 1
		If strArrCsCd(i) = strCsCd Then
			strNewCtrPtCd = strArrCtrPtCd(i)
			Exit For
		End If
	Next

	'���t���V�X�e�����t���܂ވȍ~�̏ꍇ�̓R�[�X�ŗL���ȌQ���A�ߋ����̏ꍇ�͂��ׂĂ̌Q���擾
	If CDate(strCslDate) >= Date() Then

		'�R�[�X�����݂��Ȃ��ꍇ�A�L���ȗ\��Q�͂Ȃ��Ɣ��f���A�������I������
		If strCsCd = "" Then
			Exit Do
		End If

		Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")

		'�w��R�[�X�ɂ�����L���ȗ\��Q�R�[�X��f�\��Q�������ɓǂݍ���
		lngRsvGrpCount = objSchedule.SelectCourseRsvGrpListSelCourse(strCsCd, 0, strArrRsvGrpCd, strArrRsvGrpName)

		Set objSchedule = Nothing

	Else

		Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")

		'���ׂĂ̗\��Q��ǂݍ���
		lngRsvGrpCount = objSchedule.SelectRsvGrpList(0, strArrRsvGrpCd, strArrRsvGrpName)

		Set objSchedule = Nothing

	End If

	'�w������𖞂����_���񂪑��݂��Ȃ��ꍇ�A�N��v�Z���s�\�A���I�v�V���������̎擾���s�\�Ȃ��߁A�������I������
	If strNewCtrPtCd = "" Then
		Exit Do
	End If

	If strBirth = "" Then
		Exit Do
	End If

	'�N��v�Z�ɍۂ��A�܂��_�����ǂݍ���ŔN��N�Z�����擾����(�Q�Ɛ�̒c�̂͌�ŃA���J�[�p�Ɏg�p����)
	objContract.SelectCtrMng strOrgCd1, strOrgCd2, strNewCtrPtCd, , , , , , , , strRefOrgCd1, strRefOrgCd2, strAgeCalc

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objFree = Server.CreateObject("HainsFree.Free")

	'�N��v�Z
	strAge = objFree.CalcAge(strBirth, strCslDate, strAgeCalc)

	Set objFree = Nothing

	'�I�����ׂ���f�敪�����݂��邩������
	For i = 0 To lngCslDivCount - 1
		If strArrCslDivCd(i) = strCslDivCd Then
			blnExist = True
			Exit For
		End If
	Next

	'�I�����ׂ���f�敪�����݂��Ȃ���΃I�v�V���������̎擾�͕s�\�Ɣ��f���A�������I������
	If Not blnExist Then
		Exit Do
	End If

	'�w��_��p�^�[���̑S�I�v�V���������Ƃ��̃f�t�H���g��f��Ԃ��擾
'## 2004.01.04 Mod By T.Takagi@FSIT ���S���L���̎擾
'	lngCount = objContract.SelectCtrPtOptFromConsult( _
'				   strCslDate,        _
'				   strCslDivCd,       _
'				   strNewCtrPtCd,     _
'				   strPerId,          _
'				   strGender,         _
'				   strBirth, ,        _
'				   True,              _
'				   False,             _
'				   strArrOptCd,       _
'				   strArrOptBranchNo, _
'				   strOptName, ,      _
'				   strSetColor,       _
'				   strSetClassCd,     _
'				   strConsult, , ,    _
'				   strBranchCount,    _
'				   strAddCondition, , _
'				   strHideRsv, , ,    _
'				   strPrice,          _
'				   strPerPrice,       _
'				   1                  _
'			   )
	lngCount = objContract.SelectCtrPtOptFromConsult( _
				   strCslDate,        _
				   strCslDivCd,       _
				   strNewCtrPtCd,     _
				   strPerId,          _
				   strGender,         _
				   strBirth, ,        _
				   True,              _
				   False,             _
				   strArrOptCd,       _
				   strArrOptBranchNo, _
				   strOptName, ,      _
				   strSetColor,       _
				   strSetClassCd,     _
				   strConsult, , ,    _
				   strBranchCount,    _
				   strAddCondition, , _
				   strHideRsv, , ,    _
				   strPrice,          _
				   strPerPrice,       _
				   1, ,               _
				   strExistsPrice     _
			   )
'## 2004.01.04 Mod End

	'�f�t�H���g��f����̌���
	Do

		'�{ASP�Ăяo�����O�̌_��p�^�[���ƈ�v����ꍇ
		If strNewCtrPtCd = strNowCtrPtCd Then
			strWkOptCd       = strNowOptCd
			strWkOptBranchNo = strNowOptBranchNo
			lngMode          = 2
			Exit Do
		End If

		'�{ASP�Ăяo�����O�̌_��p�^�[���Ƃ͈�v���Ȃ����A�ڍ׉�ʌĂяo������̌_��p�^�[���ƈ�v����ꍇ
		If strNewCtrPtCd = strCtrPtCd Then
			strWkOptCd       = strOptCd
			strWkOptBranchNo = strOptBranchNo
			lngMode          = 1
			Exit Do
		End If

		'����ȊO�͓ǂݍ��񂾃f�t�H���g��ԂɈˑ�
		strWkOptCd       = Empty
		strWkOptBranchNo = Empty
		lngMode          = 0

		Exit Do
	Loop

	'�ǂݍ��񂾃I�v�V�������������������A�f�t�H���g��f������s��
	For i = 0 To lngCount - 1
		strConsult(i) = SetConsults(lngMode, strConsult(i), strAddCondition(i), strArrOptCd(i), strArrOptBranchNo(i), strWkOptCd, strWkOptBranchNo)
	Next

	'���̎��_�Ŏ�f�t���O�������Ă��Ȃ��C�ӎ�f�̃Z�b�g�ɑ΂��A�擪�Z�b�g����f��Ԃɂ���
	i = 0
	Do Until i >= lngCount

		Do

			'�����ǉ��I�v�V�����̓X�L�b�v
			If strAddCondition(i) = "0" Then
				i = i + 1
				Exit Do
			End If

			'�}�Ԑ����P�̂��̂�(�`�F�b�N�{�b�N�X����ƂȂ�̂�)�X�L�b�v
			If CLng("0" & strBranchCount(i)) <= 1 Then
				i = i + 1
				Exit Do
			End If

			'���݈ʒu���L�[�v
			j = i

			strPrevOptCd = strArrOptCd(i)
			blnConsult = False

			'���݈ʒu���瓯��I�v�V�����R�[�h�̎�f��Ԃ�����
			Do Until i >= lngCount

				'���O���R�[�h�ƃI�v�V�����R�[�h���قȂ�ꍇ�͏I��
				If strArrOptCd(i) <> strPrevOptCd Then
					Exit Do
				End If

				'���łɎ�f��Ԃ̂��̂�����΃t���O����
				If strConsult(i) = "1" Then
					blnConsult = True
				End If

				'���݂̃I�v�V�����R�[�h��ޔ�
				strPrevOptCd = strArrOptCd(i)
				i = i + 1
			Loop

			'���ʁA��f��Ԃ̂��̂��Ȃ���ΐ�ɃL�[�v���Ă������擪�̃I�v�V��������f��Ԃɂ���
			If Not blnConsult Then
				strConsult(j) = "1"
			End If

			Exit Do
		Loop

	Loop

	Exit Do
Loop
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ��f��Ԃ̐ݒ�
'
' �����@�@ : (In)     lngParaMode            �Z�b�g�p�����[�h
' �@�@�@�@ : (In)     strParaAddCondition    �����ǉ����[�h
' �@�@�@�@ : (In)     strParaOptCd           �I�v�V�����R�[�h
' �@�@�@�@ : (In)     strParaOptBranchNo     �I�v�V�����}��
' �@�@�@�@ : (In)     strParaDefOptCd        �p���`�F�b�N���ׂ��I�v�V�����R�[�h�̏W��
' �@�@�@�@ : (In)     strParaDefOptBranchNo  �p���`�F�b�N���ׂ��I�v�V�����}�Ԃ̏W��
'
' �߂�l�@ : "1":��f����
' �@�@�@�@ : "0":��f���Ȃ�
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function SetConsults(lngParaMode, strParaConsult, strParaAddCondition, strParaOptCd, strParaOptBranchNo, strParaDefOptCd, strParaDefOptBranchNo)

	Dim Ret	'�֐��߂�l
	Dim i	'�C���f�b�N�X

	Do

		'�����ݒ�
		Ret = "0"

		'���݂̑I���Z�b�g��S���p�����Ȃ��ꍇ�A����f��Ԃ����̂܂ܕԂ�
		If lngParaMode <> 1 And lngParaMode <> 2 Then
			Ret = strParaConsult
			Exit Do
		End If

		'�����ǉ��Z�b�g�̂݌p������ꍇ�A�����ǉ��Z�b�g�ł���Ό���f��Ԃ����̂܂ܕԂ�
		If lngParaMode = 2 And strParaAddCondition = "0" Then
			Ret = strParaConsult
			Exit Do
		End If

		'����ȊO�͌��݂̑I���Z�b�g�ɑ��݂�����̂��p������

		'�������w�莞�̓`�F�b�N�s�\�B�p�����Ȃ��B
		If IsEmpty(strParaDefOptCd) Or IsEmpty(strParaDefOptBranchNo) Then
			Exit Do
		End If

		'�����w�肳�ꂽ�I�v�V�����ɑ΂��ă`�F�b�N������
		For i = 0 To UBound(strParaDefOptCd)
			If strParaDefOptCd(i) = strParaOptCd And strParaDefOptBranchNo(i) = strParaOptBranchNo Then
				Ret = "1"
				Exit Do
			End If
		Next

		'�����܂łŃq�b�g���Ȃ��ꍇ�͌p�����Ȃ�
		Exit Do
	Loop

	'�߂�l�̐ݒ�
	SetConsults = Ret

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META http-equiv="Content-Style-Type" content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�I�v�V��������</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// �Z�b�g�����ڍ폜��ʌĂяo��
function callDelItemWindow( selOptCd, selOptBranchNo ) {
	top.callDelItemWindow( '<%= strRsvNo %>', document.entryForm.ctrPtCd.value, selOptCd, selOptBranchNo );
}

// �Z�b�g����ʌĂяo��
function callSetInfoWindow( selOptCd, selOptBranchNo ) {
	top.callSetInfoWindow( document.entryForm.ctrPtCd.value, selOptCd, selOptBranchNo );
}

// �T�u��ʂ����
function closeWindow() {
	top.closeWindow( top.winCompare );	// �����Z�b�g���̔�r
	top.closeWindow( top.winDelItem );	// �Z�b�g�����ڍ폜
	top.closeWindow( top.winSetInfo );	// �Z�b�g�����
}

// �w��G�������g�̃`�F�b�N��Ԃɂ��s�\���F�ݒ�
function selColor( selObj ) {

	var rowColor, topColor;	// �s�S�̂̐F�A�擪��̐F

	// �\���F��ύX���ׂ��m�[�h���擾
	var changedNode = selObj.parentNode.parentNode;

	// �\���F�̐ݒ�
	if ( selObj.checked ) {
		rowColor = '#eeeeee';
		topColor = '#ffc0cb';
	} else {
		rowColor = '#ffffff';
		topColor = '#ffffff';
	}

	// �\���F�̕ύX
	changedNode.style.backgroundColor = rowColor;
	changedNode.getElementsByTagName('td')[0].style.backgroundColor = topColor;

}

function setAge( age, realAge ) {

	var ageName = '';

	// �\��ڍ׉�ʂ̔N����X�V����
	top.main.document.entryForm.age.value     = age;
	top.main.document.entryForm.realAge.value = realAge;

	// ���N��̕ҏW
	if ( realAge != '' ) {
		ageName = realAge + '��';
	}

	// ��f���̎�f���N��ҏW
	if ( age != '' ) {
		ageName = ageName + '�i' + age.substring(0, age.indexOf('.')) + '�΁j';
	}

	top.main.document.getElementById('dspAge').innerHTML = ageName;

}

// �w��G�������g�ɑΉ�����s�̑I��\��
function setRow( selObj,chkFlg ) {

	var objRadio;	// ���W�I�{�^���̏W��
	var selFlg;		// �I���t���O

	// �G�������g�^�C�v���Ƃ̏�������
	switch ( selObj.type ) {

		case 'checkbox':	// �`�F�b�N�{�b�N�X
			selColor( selObj );
			break;

		case 'radio':		// ���W�I�{�^��

			// �����̑S�G�������g�ɑ΂���I��\��
			objRadio = document.optList.elements[ selObj.name ];
/*********************************
			selFlg = false;

			// �G�������g���S���I������Ă��Ȃ����𔻒�
			for ( var i = 0; i < objRadio.length; i++ ) {
				if ( objRadio[ i ].checked ) {
					selFlg = true;
				}
			}

			// �G�������g���S���I������Ă��Ȃ���ΐ擪���ڂ�I��
			if ( !selFlg ) {
				objRadio[ 0 ].checked = true;
			}
*********************************/
			for ( var i = 0; i < objRadio.length; i++ ) {
				selColor( objRadio[ i ] );
			}

            // 2006.06.15 Add By ���@�FGF���ʊ����ݒ� *****
            setGFRepeater( document.optList,chkFlg );  
            // 2006.06.15 Add End.					 *****
    
    }


    //alert(document.optList.hideCheck.value);
}


// 2006.06.15 Add By ���@�FGF���ʊ����ݒ� *****
function setGFRepeater( objForm,chkFlg ) {

	var GFFlg = false;				// GF�����t���O
	var RepeaterFlg = false;			// Repeater�t���O
	var cslDate;
	var selOptCd;
    var hdnOptCd;
    var gfIndex;
    var strCheck = '';
    var hideCheck = false;
    var iscase = false;
    var mainForm = top.main.document.entryForm;

	if ( !objForm ) return;
	if ( objForm.length == null ) return;

	if ( mainForm.orgCd1.value != 'XXXXX' ) return;
	if ( mainForm.orgCd2.value != 'XXXXX' ) return;
	if ( mainForm.csCd.value != '100' ) return;

	cslDate = mainForm.cslYear.value + mainForm.cslMonth.value + mainForm.cslDay.value;

	// �S�G�������g������
	for ( var i = 0; i < objForm.length; i++ ) {
        selOptCd = objForm.elements[ i ].value.split(',');
		// �^�C�v�𔻒f      
        switch ( objForm.elements[ i ].type ) {

			case 'checkbox':	// �`�F�b�N�{�b�N�X�A���W�I�{�^���̏ꍇ
            case 'radio':
				// 
				if ( objForm.elements[ i ].checked ) {
					//selOptCd = objForm.elements[ i ].value.split(',');
                    strCheck = CheckFlag(selOptCd[ 3 ]);
				}
				break;

			default:
				continue;

		}

        if (strCheck =="1"){
            GFFlg = true;
        }
        
        if (strCheck =="2"){
            RepeaterFlg = true;
        }

	}


    for ( var j = 0; j < objForm.length; j++ ) {
        selOptCd = objForm.elements[j].value.split(',');

        if ( selOptCd[ 3 ] == '069' ) {
            iscase = true ;
            switch ( objForm.elements[ j ].type ) {
                case 'checkbox':	// �`�F�b�N�{�b�N�X�A���W�I�{�^���̏ꍇ
                case 'radio':         
                    gfIndex = j;
                    if ( GFFlg  && RepeaterFlg ) {
                        if (chkFlg == 1) {
                             objForm.elements[j].checked = true;
                        } else {
                            hideCheck = true;
                        }

                    } else {
                        objForm.elements[j].checked = false;
                    }
                    
                    selColor( objForm.elements[j] );
                    break;

                case 'hidden':		// �B���G�������g�̏ꍇ

                    if ( GFFlg  && RepeaterFlg ) {
                        objForm.elements[j].value = selOptCd[0] + ',' + selOptCd[1] + ',' +'1,' + selOptCd[3] ; 
                    } else {
                        objForm.elements[j].value = selOptCd[0] + ',' + selOptCd[1] + ',' +'0,' + selOptCd[3] ; 
                    }
                    
                    break;

                default:
                    continue;
             }
        }
    }


    if (iscase) {
        //alert(iscase);
        hdnOptCd = objForm.elements[gfIndex].value.split(',');
        if (hideCheck && objForm.elements[gfIndex].checked == false) {
            objForm.hideCheck.value =hdnOptCd[0] + ',' + hdnOptCd[1] + ',' +'1,' + hdnOptCd[3] ;
        } else {
            objForm.hideCheck.value =hdnOptCd[0] + ',' + hdnOptCd[1] + ',' +'0,' + hdnOptCd[3] ;
        }
         //alert(objForm.hideCheck.value);
    }


}


// 2006.06.20 Add By ���@�FGF,Repeater Check
function CheckFlag(setClassCd)  {

	if ( setClassCd == '002' || setClassCd == '003' ) {
         return 1;
	}

	if ( setClassCd == '023' ) {
        return 2;
	}

}


// �S�s�̑I��\��
function setRows() {

	// �ꗗ�����݂��Ȃ���Ή������Ȃ�
	if ( !document.optList ) {
		return;
	}

	var objElements = document.optList.elements;
	for ( var i = 0; i < objElements.length; i++ ) {
		setRow( objElements[ i ],0 );
	}

}

// �ꗗ�̍ĕ\��
function showOptList() {

	var arrOptCd       = new Array();	// �I�v�V�����R�[�h
	var arrOptBranchNo = new Array();	// �I�v�V�����}��

	// �I�v�V�����������ǂݍ���
	var url = '<%= Request.ServerVariables("SCRIPT_NAME") %>';

	// ���݂̕\����������{����ʂ��擾
	var mainForm = top.main.document.entryForm;
	url = url + '?rsvno=<%= strRsvNo %>';
	url = url + '&cancelFlg=<%= lngCancelFlg %>';
	url = url + '&gender='   + mainForm.gender.value;
	url = url + '&birth='    + mainForm.birth.value;
	url = url + '&orgCd1='   + mainForm.orgCd1.value;
	url = url + '&orgCd2='   + mainForm.orgCd2.value;
	url = url + '&csCd='     + mainForm.csCd.value;
	url = url + '&cslDate='  + mainForm.cslYear.value + '/' + mainForm.cslMonth.value + '/' + mainForm.cslDay.value;
	url = url + '&cslDivCd=' + mainForm.cslDivCd.value;
	url = url + '&rsvGrpCd=' + mainForm.rsvGrpCd.value;

	// ���݂̃p�^�[���l�A�\�����@���擾
	var myForm = document.entryForm;
	url = url + '&ctrPtCd=' + myForm.ctrPtCd.value;
	url = url + '&showAll=' + ( myForm.showAll.checked ? myForm.showAll.value : '');

	// ���݂̑I���I�v�V�����l���擾
	top.convOptCd( document.optList, arrOptCd, arrOptBranchNo );

	// �I�v�V�����l��ǉ�
	url = url + '&optCd='  + arrOptCd;
	url = url + '&optBNo=' + arrOptBranchNo;

	url = url + '&readNoRep=1';

	// ��ʂ̍ēǂݍ���
	location.replace( url );

}
//-->
</SCRIPT>
<style type="text/css">
body { margin: 0 0 0 10px; }
</style>
</HEAD>
<BODY ONLOAD="javascript:setRows()" ONUNLOAD="javascript:closeWindow()">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#eeeeee" NOWRAP><B><FONT COLOR="#333333">�����Z�b�g</FONT></B></TD>
	</TR>
</TABLE>
<%
Do
	'�_����̕\�����s���Ȃ��ꍇ�̓��b�Z�[�W��ҏW
	If Not blnExist Then
%>
		<BR>��{������͂��ĉ������B
<%
		Exit Do
	End If
%>
	<FORM NAME="entryForm" STYLE="margin: 0px" action="#">
		<INPUT TYPE="hidden" NAME="ctrPtCd" VALUE="<%= strNewCtrPtCd %>">
		<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="0">
			<TR>
				<TD NOWRAP>�p�^�[��No.</TD>
				<TD>�F</TD>
				<TD><B><%= strNewCtrPtCd %></B></TD>
<%
				'�_��Q�Ɨp��URL�ҏW
				strURL = "/webHains/contents/contract/ctrDetail.asp"
				strURL = strURL & "?orgCd1="  & strRefOrgCd1
				strURL = strURL & "&orgCd2="  & strRefOrgCd2
				strURL = strURL & "&csCd="    & strCsCd
				strURL = strURL & "&ctrPtCd=" & strNewCtrPtCd
%>
				<TD NOWRAP>�@<A HREF="<%= Replace(strURL, "&", "&amp;") %>" TARGET="_blank">���̌_����Q��</A></TD>
<%
				'�V�K�ȊO�̏ꍇ�u�Z�b�g���̔�r�v�A���J�[��\��
				If strRsvNo <> "" Then
%>
					<TD NOWRAP>�@<A HREF="javascript:function voi(){};voi()" ONCLICK="javascript:top.callCompareWindow()">�����Z�b�g�̔�r</A></TD>
<%
'## 2004.10.27 Add By T.Takagi@FSIT ���t�ύX���̓Z�b�g��r��ʂ������\��
					blnCompare = True
'## 2004.10.27 Add End
				End If
%>
				<TD WIDTH="100%" ALIGN="right"><INPUT TYPE="checkBox" NAME="showAll" VALUE="1"<%= IIf(strShowAll <> "", " CHECKED", "") %> ONCLICK="javascript:top.main.optionForm.showAll.value = (this.checked ? '1' : '')"></TD>
				<TD NOWRAP>���ׂĂ̌�����</TD>
				<TD><A HREF="javascript:showOptList()"><IMG SRC="/webHains/images/b_prev.gif" HEIGHT="28" WIDTH="53" ALT="�����Z�b�g���ĕ\�����܂�"></A></TD>
			</TR>
			<TR>
				<TD HEIGHT="5"></TD>
			</TR>
		</TABLE>
	</FORM>
<%
	'�I�v�V�������������݂��Ȃ��ꍇ�̓��b�Z�[�W�ҏW
	If lngCount = 0 Then
		Response.Write "���̌_����̃I�v�V���������͑��݂��܂���B"
		Exit Do
	End If

	lngOptGrpSeq = 0
%>
	<FORM NAME="optList" STYLE="margin: 0px" action="#">
		<TABLE ID="optTable" BORDER="0" CELLPADDING="1" CELLSPACING="1" WIDTH="100%">
			<TR>
				<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="7" HEIGHT="1" ALT=""></TD>
			</TR>
			<TR BGCOLOR="#eeeeee" ALIGN="center">
<%
				'�_��p�^�[������ǂ݁A�_���̃R�[�X�����擾
				objContract.SelectCtrPt strNewCtrPtCd, , , , , strCsName
%>
				<TD ALIGN="left" COLSPAN="3" NOWRAP>�����Z�b�g���i<%= strCsName %>�j</TD>
				<TD NOWRAP>���S���z�v</TD>
				<TD NOWRAP>�l���S��</TD>
				<TD NOWRAP>�Z�b�g��</TD>
				<TD NOWRAP>���</TD>
				<TD></TD>
			</TR>
<%
			'�ǂݍ��񂾃I�v�V�����������̌���
			strPrevOptCd = ""

			For i = 0 To lngCount - 1
				'���O���R�[�h�ƃI�v�V�����R�[�h���قȂ�ꍇ
				If strArrOptCd(i) <> strPrevOptCd Then

					'�܂��ҏW����G�������g��ݒ肷��(�}�Ԑ����P�Ȃ�`�F�b�N�{�b�N�X�A�����Ȃ��΃��W�I�{�^���I��)
					strElementType = IIf(CLng(strBranchCount(i)) = 1, "checkbox", "radio")

					'�I�v�V�����ҏW�p�̃G�������g�����`����
					lngOptGrpSeq   = lngOptGrpSeq + 1
					strElementName = "opt" & CStr(lngOptGrpSeq)

				End If

				'���s�[�^�����Z�b�g�ł����
				If strSetClassCd(i) = SETCLASS_REPEATER Then

					'���s�[�^�����Z�b�g�̗L�����u����v�ɂ���
					blnHasRepeaterSet = True

					'����Ɍ��݂̎�f��Ԃ��擾
					If strConsult(i) = "1" Then
						blnRepeaterConsult = True
					End If

				End If

				'�\���ʔ�\���I�v�V�����A�����ׂĂ̌�����\�����Ȃ��ꍇ
				If strHideRsv(i) <> "" And strShowAll = "" Then

					'��ŕҏW���邽�߂ɂ����ŃX�^�b�N����
					ReDim Preserve strHideElementName(lngHideCount)
					ReDim Preserve strHideOptCd(lngHideCount)
					ReDim Preserve strHideOptBranchNo(lngHideCount)
					ReDim Preserve strHideConsult(lngHideCount)
					strHideElementName(lngHideCount) = strElementName
					strHideOptCd(lngHideCount) = strArrOptCd(i)
					strHideOptBranchNo(lngHideCount) = strArrOptBranchNo(i)
					strHideConsult(lngHideCount) = strConsult(i)

					'## 2006.06.20 Add by �� ---------------------------------------
					ReDim Preserve strHideSetClassCd(lngHideCount)
					strHideSetClassCd(lngHideCount) = strSetClassCd(i)
					'## 2006.06.20 End.  ---

					lngHideCount = lngHideCount + 1

				'�\���ΏۃI�v�V�����̏ꍇ
				Else

					'���O���R�[�h�ƃI�v�V�����R�[�h���قȂ�ꍇ�̓Z�p���[�^��ҏW
					If strPrevOptCd <> "" And strArrOptCd(i) <> strPrevOptCd Then
%>
						<TR><TD HEIGHT="3"></TD></TR>
<%
					End If

					strChecked = IIf(strConsult(i) = "1", " CHECKED", "")
%>
					<TR ALIGN="right">
						<TD></TD>
						<!--2006.06.20 strSetClassCd�ǉ�   -->
						<TD><INPUT TYPE="<%= strElementType %>" NAME="<%= strElementName %>" VALUE="<%= strArrOptCd(i) & "," & strArrOptBranchNo(i) & "," & "," & strSetClassCd(i) %>"<%= strChecked %> ONCLICK="javascript:setRow(this,1)"></TD>
						
						<TD ALIGN="left" WIDTH="100%"><FONT COLOR="<%= strSetColor(i) %>">��</FONT><%= strOptName(i) %></TD>
						<TD><%= FormatCurrency(strPrice(i)) %></TD>
						<TD><%= FormatCurrency(strPerPrice(i)) %></TD>
<%
						'�L�����Z���҂łȂ��ꍇ�u�폜�v�A���J�[��\������
						If strRsvNo <> "" And lngCancelFlg = CONSULT_USED Then
%>
							<TD ALIGN="center"><A HREF="javascript:callDelItemWindow('<%= strArrOptCd(i) %>','<%= strArrOptBranchNo(i) %>')">�폜</A></TD>
<%
						Else
%>
							<TD></TD>
<%
						End If
%>
						<TD><A HREF="javascript:callSetInfoWindow('<%= strArrOptCd(i) %>','<%= strArrOptBranchNo(i) %>')">���</A></TD>
						<TD NOWRAP>&nbsp;<%= strArrOptCd(i) & "-" & strArrOptBranchNo(i) %></TD>

					</TR>
<%
				End If

				'�����R�[�h�̃I�v�V�����R�[�h��ޔ�
				strPrevOptCd = strArrOptCd(i)
			Next
%>
		</TABLE>
<%
		'�X�^�b�N���ꂽ����������hidden�ɂĕێ�
		For i = 0 To lngHideCount - 1
%>
			<INPUT TYPE="hidden" NAME="<%= strHideElementName(i) %>" VALUE="<%= strHideOptCd(i) & "," & strHideOptBranchNo(i) & "," & strHideConsult(i) & "," & strHideSetClassCd(i)  %>">
<%
		Next
%>
        <INPUT TYPE="hidden" NAME="hideCheck"       VALUE="">
	</FORM>
<%
	Exit Do
Loop
%>
<SCRIPT TYPE="text/javascript">
<!--
<%
'�R�[�X�Z���N�V�����{�b�N�X�̕ҏW
%>
var courseInfo = new Array();
<%
For i = 0 To lngCtrCount - 1
%>
	courseInfo[ <%= i %> ] = new top.codeAndName('<%= strArrCsCd(i) %>', '<%= strArrCsName(i) %>');
<%
Next
%>
top.editCourse(courseInfo, '<%= strCsCd %>');
<%
'��f�敪�Z���N�V�����{�b�N�X�̕ҏW
%>
var cslDivInfo = new Array();
<%
For i = 0 To lngCslDivCount - 1
%>
	cslDivInfo[ <%= i %> ] = new top.codeAndName( '<%= strArrCslDivCd(i) %>', '<%= strArrCslDivName(i) %>' );
<%
Next
%>
top.editCslDiv(cslDivInfo, '<%= strCslDivCd %>');
<%
'�\��Q�Z���N�V�����{�b�N�X�̕ҏW
%>
var rsvGrpInfo = new Array();
<%
For i = 0 To lngRsvGrpCount - 1
%>
	rsvGrpInfo[ <%= i %> ] = new top.codeAndName( '<%= strArrRsvGrpCd(i) %>', '<%= strArrRsvGrpName(i) %>' );
<%
Next
%>
top.editRsvGrp(rsvGrpInfo, '<%= strRsvGrpCd %>');

<% '�N����v�Z���A��{���ɕҏW���� %>
setAge('<%= strAge %>','<%= strRealAge %>');
<%
Do

	'�_����̕\�����s���Ă��Ȃ��ꍇ
	If Not blnExist Then
%>
		// �ŐV��Ԃ��X�V
		top.main.document.repInfo.hasRepeaterSet.value  = '';
		top.main.document.repInfo.repeaterConsult.value = '';
<%
		Exit Do
	End If

	'�L�����Z���҂̏ꍇ�A���ׂĂ̓��͗v�f���g�p�s�\�ɂ���
	If lngCancelFlg <> CONSULT_USED Then
%>
		if ( document.optList ) {
			var elem = document.optList.elements;
			for ( var i = 0; i < elem.length; i++ ) {
				elem[i].disabled = true;
			}
		}
<%
		Exit Do
	End If

	'���łɓ����ς݂Ȃ�΂����ŃC�l�[�u��������s��(���̃��s�[�^�������������͍s��Ȃ��B���z�������B)
%>
//		if ( document.optList ) {
//			var elem = document.optList.elements;
//			for ( var i = 0; i < elem.length; i++ ) {
//				alert(elem[i].name);
//			}
//		}
<%
	'�I�v�V������񂻂̂Q��ǂ�
	If strReadNoRep = "" Then

		'�����\�����͖{��ʂŋ��߂����s�[�^��Ԃ�n��
		If strInit <> "" Then
%>
			var hasRepeaterSet  = '<%= IIf(blnHasRepeaterSet,  "1", "") %>';
			var repeaterConsult = '<%= IIf(blnRepeaterConsult, "1", "") %>';
<%
		'����ȊO�͊�{����ʂŃL�[�v���Ă����Ԃ�n��
		Else
%>
			var hasRepeaterSet  = top.main.repInfo.hasRepeaterSet.value;
			var repeaterConsult = top.main.repInfo.repeaterConsult.value;
<%
		End If
%>
		top.replaceCslList('<%= strCslDate %>','<%= strCslDivCd %>','<%= strNewCtrPtCd %>','<%= strPerId %>','<%= strGender %>','<%= strBirth %>', hasRepeaterSet, repeaterConsult);
<%
	End If

	Exit Do
Loop

'## 2004.10.27 Add By T.Takagi@FSIT ���t�ύX���̓Z�b�g��r��ʂ������\��
If blnDateChanged And blnCompare Then
%>
top.callCompareWindow();
<%
End If
'## 2004.10.27 Add End
%>
//-->
</SCRIPT>
</BODY>
</HTML>

