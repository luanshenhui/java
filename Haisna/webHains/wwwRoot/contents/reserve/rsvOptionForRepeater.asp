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
Dim objConsult			'��f���A�N�Z�X�p
Dim objContract			'�_����A�N�Z�X�p

'�����l(����)
Dim strPerId			'�l�h�c
Dim strGender			'����
Dim strBirth			'���N����
Dim strCslDate			'��f��
Dim strCslDivCd			'��f�敪�R�[�h
Dim strCtrPtCd			'�_��p�^�[���R�[�h
Dim blnHasRepeaterSet	'(�{�������Ă΂ꂽ���_��)�_��ɂ����郊�s�[�^�����Z�b�g�̗L��
Dim blnRepeaterConsult	'(�{�������Ă΂ꂽ���_��)���s�[�^�����Z�b�g�̎�f�L��

'�I�v�V�����������
Dim strArrOptCd			'�I�v�V�����R�[�h
Dim strArrOptBranchNo	'�I�v�V�����}��
Dim strSetClassCd		'�Z�b�g���ރR�[�h
Dim strConsult			'��f�v��
Dim strAddCondition		'�ǉ�����
Dim strLastRefCsCd		'�O��l�Q�Ɨp�R�[�X�R�[�h
Dim lngCount			'�I�v�V����������

Dim strWkLastRefCsCd()	'�O��l�Q�Ɨp�R�[�X�R�[�h
Dim lngCsCount			'�O��l�Q�Ɨp�R�[�X��

Dim strHisCslDate		'(��f����)��f��
Dim strHisCsCd			'(��f����)�R�[�X�R�[�h
Dim lngHisCount			'��f��

Dim strStatement()		'�ҏW�p�X�e�[�g�����g
Dim lngStaCount			'�X�e�[�g�����g��
Dim i					'�C���f�b�N�X

Dim blnNewHasRepeaterSet	'(�{�������)�_��ɂ����郊�s�[�^�����Z�b�g�̗L��
Dim blnNewRepeaterConsult	'(�{�������)���s�[�^�����Z�b�g�̎�f�L��

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objContract = Server.CreateObject("HainsContract.Contract")

'�p�����[�^�l�̎擾
strCslDate  = Request("cslDate")
strCslDivCd = Request("cslDivCd")
strCtrPtCd  = Request("ctrPtCd")
strPerId    = Request("perId")
strGender   = Request("gender")
strBirth    = Request("birth")

blnHasRepeaterSet  = (Request("hasRepSet")  <> "")
blnRepeaterConsult = (Request("repConsult") <> "")

'�w��_��p�^�[���̑S�I�v�V���������Ƃ��̃f�t�H���g��f��Ԃ��擾
lngCount = objContract.SelectCtrPtOptFromConsult(strCslDate, strCslDivCd, strCtrPtCd, strPerId, strGender, strBirth, , True, , strArrOptCd, strArrOptBranchNo, , , , strSetClassCd, strConsult, , , , strAddCondition, , , , , , , 1, strLastRefCsCd)
%>
<SCRIPT TYPE="text/javascript">
<!--
function setRepeaterConsults( optCd, optBranchNo, consults ) {

	var objElements = top.opt.document.optList.elements;
	var elemOptCd;

	// �I�v�V����������ʂ̃G�������g����
	for ( var i = 0; i < objElements.length; i++ ) {

		elemOptCd = objElements[ i ].value.split(',');
		if ( elemOptCd[ 0 ] != optCd || elemOptCd[ 1 ] != optBranchNo ) {
			continue;
		}

		// �^�C�v�𔻒f
		switch ( objElements[ i ].type ) {

			case 'checkbox':	// �`�F�b�N�{�b�N�X�A���W�I�{�^���̏ꍇ
			case 'radio':
				objElements[ i ].checked = ( consults == '1' );
				break;

			case 'hidden':		// �B���G�������g�̏ꍇ
				objElements[ i ].value = optCd + ',' + optBranchNo + ',' + consults;
				break;

			default:

		}

	}

}
<%
'�I�v�V���������̌���
For i = 0 To lngCount - 1

	'���s�[�^�����̃Z�b�g�ł����
	If strSetClassCd(i) = SETCLASS_REPEATER Then

		'���s�[�^�����Z�b�g�̗L�����u����v�ɂ���
		blnNewHasRepeaterSet = True

		'���̃R�[�X���X�^�b�N
		If strLastRefCsCd(i) <> "" Then
			ReDim Preserve strWkLastRefCsCd(lngCsCount)
			strWkLastRefCsCd(lngCsCount) = strLastRefCsCd(i)
			lngCsCount = lngCsCount + 1
		End If

		'����Ɍ��݂̎�f��Ԃ��擾
		If strConsult(i) = "1" Then
			blnNewRepeaterConsult = True
		End If

		'�I�v�V����������ʂւ̕ҏW�p�֐����X�^�b�N
		ReDim Preserve strStatement(lngStaCount)
		strStatement(lngStaCount) = "setRepeaterConsults('" & strArrOptCd(i) & "','" & strArrOptBranchNo(i) & "','" & strConsult(i) & "');"
		lngStaCount = lngStaCount + 1

	End If

Next

'���s�[�^�����Z�b�g�������
If blnNewHasRepeaterSet Then

'	Set objConsult = Server.CreateObject("HainsConsult.Consult")
'
'	'��f����ǂ�
'	lngHisCount = objConsult.SelectConsultHistory(strPerId, , True, , , , strHisCslDate, strHisCsCd)
'
'	Set objConsult = Nothing

End If

'�X�e�[�g�����g�ҏW
For i = 0 To lngStaCount - 1
	Response.Write strStatement(i) & vbCrLf
Next
%>
// �S�s�̑I��\��
top.opt.setRows();
<%
If Not blnRepeaterConsult And blnNewRepeaterConsult Then
%>
	alert('���s�[�^�������ΏۂƂȂ�܂����B');
<%
End If

If blnRepeaterConsult And Not blnNewRepeaterConsult Then
%>
	alert('���s�[�^�����Ώۂ���O��܂����B');
<%
End If
%>
// �ŐV��Ԃ��X�V
top.main.document.repInfo.hasRepeaterSet.value  = '<%= IIf(blnNewHasRepeaterSet,  "1", "") %>';
top.main.document.repInfo.repeaterConsult.value = '<%= IIf(blnNewRepeaterConsult, "1", "") %>';
//-->
</SCRIPT>
