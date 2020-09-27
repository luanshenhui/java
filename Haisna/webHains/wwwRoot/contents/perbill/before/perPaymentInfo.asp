<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�l��f���z�\�� (Ver0.0.1)
'		AUTHER  : H.Kamata@FFCS
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�萔�̒�`
Const MODE_INSERT   = "insert"	'�������[�h(�}��)
Const MODE_UPDATE   = "update"	'�������[�h(�X�V)
Const ACTMODE_SAVE  = "save"	'���샂�[�h(�ۑ�)
Const ACTMODE_SAVED = "saved"	'���샂�[�h(�ۑ�����)

Dim objCommon			'���ʃN���X
Dim objDemand				'�������A�N�Z�X�p
Dim objConsult				'��f���A�N�Z�X�p
Dim objPerbill				'��f���A�N�Z�X�p

Dim strMode					'�������[�h
Dim lngRsvNo				'�\��ԍ�
Dim lngCount				'�擾����
Dim lngSubCount				'�擾����
Dim lngPerBillCount			'�擾����
Dim lngPerCount				'�l���S���� 2003.12.18 add
Dim lngDelCount				'������`�[��
Dim Ret						'�֐��߂�l

Dim lngHeader				'���ڏ����݃t���O
Dim lngTotalFlg

'��f���p�ϐ�
Dim strPerId				'�lID
Dim strCslDate				'��f��
Dim strCsCd					'�R�[�X�R�[�h
Dim strCsName				'�R�[�X��
Dim strLastName				'��
Dim strFirstName			'��
Dim strLastKName			'�J�i��
Dim strFirstKName			'�J�i��
Dim strBirth				'���N����
Dim strAge					'�N��
Dim strGender				'����
Dim strGenderName			'���ʖ���
Dim strKeyDayId				'����ID


'�l���������p�ϐ�(SelectPerBill)
Dim vntDmdDate				'������
Dim vntBillSeq				'�������r����
Dim vntBranchNo				'�������}��
Dim vntDelflg				'����`�[�t���O
Dim vntUpdDate				'�X�V����
Dim vntUpdUser				'���[�U�h�c
Dim vntUserName				'���[�U��������
Dim vntBillcoment			'�������R�����g
Dim vntPaymentDate			'������
Dim vntPaymentSeq			'�����r����

'�l��f���z�p�ϐ�(SelectConsult_m)
Dim vntOrgCd1               '�c�̃R�[�h�P
Dim vntOrgCd2               '�c�̃R�[�h�Q
Dim vntOrgSeq				'�_��p�^�[���r�d�p
Dim vntOrgName              '�c�̖�
Dim vntPrice                '���z
Dim vntEditPrice            '�������z
Dim vntTaxPrice             '�Ŋz
Dim vntEditTax            	'�����Ŋz
Dim vntLineTotal			'���v�i���z�A�������z�A�Ŋz�A�����Ŋz�j
Dim vntPriceSeq             '�r�d�p
Dim vntCtrPtCd				'�_��p�^�[���R�[�h
Dim vntOptCd				'�I�v�V�����R�[�h
Dim vntOptName				'�I�v�V��������
Dim vntOptBranchNo			'�I�v�V�����}��
Dim vntOtherLineDivCd		'�Z�b�g�O���̋敪
Dim vntLineName				'���ז��́i�Z�b�g�O���ז��̊܂ށj
Dim vntBillLineNo			'�������׍sNo
Dim vntOmitTaxFlg			'����ŖƏ��t���O
Dim vntPrintDate			'�̎��������

'KMT �����ϐ���ʂ�COM�Ŏg�p����Ǝ��ʂƂ����������ׁA�Ƃ肠�����ϐ�������
Dim vntDmdDate_m			'������
Dim vntBillSeq_m			'�������r����
Dim vntBranchNo_m			'�������}��
Dim vntPrice_m				'���z
Dim vntEditPrice_m			'�������z
Dim vntTaxPrice_m			'�Ŋz
Dim vntEditTax_m			'�����Ŋz
Dim vntPaymentDate_m		'������
Dim vntPaymentSeq_m			'�����r����

'�l��f���z���v�擾�p
Dim lngPriceCount			'�擾����
Dim vntSubOrgCd1            '�c�̃R�[�h�P
Dim vntSubOrgCd2            '�c�̃R�[�h�Q
Dim vntSubPrice_m			'���z���v
Dim vntSubEditPrice_m		'�������z���v
Dim vntSubTax_m				'���v�i�Ŋz�j
Dim vntSubEditTax_m			'���v�i�Œ����z�j
Dim vntSubTotal_m			'���v�i���v�́j



Dim lngCloseCount
Dim vntCloseOrgCd1          '�c�̃R�[�h�P
Dim vntCloseOrgCd2          '�c�̃R�[�h�Q
Dim vntCloseOrgName         '�c�̖�
Dim vntCloseCsCd            '�R�[�X�R�[�h
Dim vntCloseCsName          '�R�[�X��
Dim vntBillNo				'�������ԍ�
Dim blnVislbleSave			'�ۑ��{�^����\�����邩�ǂ���
Dim blnExistsClose			'���ɒ��ߍς�

'�l��f���z�X�V�p�ϐ�
Dim vntExistsZeroData		'\0�f�[�^ ON/OFF�X�C�b�`
Dim lngSaveRsvNo			'�X�V�p�\��ԍ�

Dim vntBreakOrgCd1			'�u���C�N�p�c�̃R�[�h
Dim vntBreakOrgCd2			'�u���C�N�p�c�̃R�[�h
Dim vntBreakCsCd			'�u���C�N�p�R�[�X�R�[�h
Dim vntBreakDmdLineClassCd	'�u���C�N�p�������ו��ރR�[�h

Dim lngPerBillTotal			'���z���v�i�l���S�������j
Dim lngPerPayTotal			'�������v�i�l���S�������j

'���z���v�p�ϐ�
Dim vntSubPrice				'���z���v
Dim vntSubEditPrice			'�������z���v
Dim vntSubTax				'���v�i�Ŋz�j
Dim vntSubEditTax			'���v�i�Œ����z�j
Dim vntSubTotal				'���v�i���v�́j

Dim lngPriceTotal			'���z���v
Dim lngEditPriceTotal		'�������z���v
Dim lngTaxTotal				'���v�i�Ŋz�j
Dim lngEditTaxTotal			'���v�i�Œ����z�j
Dim lngTotal				'���v�i�S���z�j

'�Z�b�g�O�������חp�p�����[�^
Dim lngBillCount			'��������������
Dim strReqDmdDate			'������
Dim lngReqBillSeq			'�������r����
Dim lngReqBranchNo			'�������}��

Dim lngDelDsp				'����`�[�\���L���t���O

Dim strActMode				'���샂�[�h(�ۑ�:"save"�A�ۑ�����:"saved")
Dim strMessage				'�G���[���b�Z�[�W
Dim i						'�C���f�b�N�X
Dim strReadyCloseString		'���ߍς݃��b�Z�[�W

strMessage = ""

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objDemand  = Server.CreateObject("HainsDemand.Demand")
Set objConsult = Server.CreateObject("HainsConsult.Consult")
Set objPerbill = Server.CreateObject("HainsPerBill.PerBill")

'�����l�̎擾
strMode      = Request("mode")
lngRsvNo     = Request("rsvNo")
strActMode   = Request("actMode")
lngDelDsp    = Request("DelDsp")


'�p�����^�̃f�t�H���g�l�ݒ�
lngRsvNo   = IIf(IsNumeric(lngRsvNo) = False, 0,  lngRsvNo )
lngDelDsp  = IIf(lngDelDsp <> 1, 0,  lngDelDsp )

Do

	'����ŖƏ��H
	If strActMode = "omit" Then
		Ret = objPerBill.OmitTaxSet( lngRsvNo )
		Response.Redirect Request.ServerVariables("SCRIPT_NAME") & "?mode=" & strMode & "&rsvNo=" & lngRsvNo & "&actMode=&DelDsp=" & lngDelDsp
		Response.End
	End If

	'��f��񌟍�
	Ret = objConsult.SelectRslConsult(lngRsvNo,      _
									  strPerId,      _
									  strCslDate,    _
									  strCsCd,       _
									  strCsName,     _
									  strLastName,   _
									  strFirstName,  _
									  strLastKName,  _
									  strFirstKName, _
									  strBirth,      _
									  strAge,        _
									  strGender,     _
									  strGenderName, _
									  strKeyDayId)

	'���ߊǗ����擾
	lngCloseCount = objDemand.SelectPersonalCloseMngInfo(lngRsvNo, _
														vntCloseOrgCd1, _
														vntCloseOrgCd2, _
														vntCloseOrgName, _
														vntCloseCsCd, _
														vntCloseCsName, _
														vntBillNo)

	blnVislbleSave = False
	blnExistsClose = False
	strReadyCloseString = ""

	'���ߏ��̑��݃`�F�b�N
	For i = 0 To lngCloseCount - 1
		If Trim(vntBillNo(i)) <> "" Then
			blnExistsClose = True
			strReadyCloseString = "���ɒ��ߏ��������s����Ă��܂��B���z�̏C���͂ł��܂���B"
			Exit For
		End If

	Next

	'��f��񂪑��݂��Ȃ��ꍇ�̓G���[�Ƃ���
	If Ret = False Then
		Err.Raise 1000, , "��f��񂪑��݂��܂���B�i�\��ԍ�= " & lngRsvNo & " )"
	End If


	'�\��ԍ�����l�������Ǘ������擾����
	lngPerBillCount = objPerbill.SelectPerBill(lngRsvNo, _
												vntDmdDate, _
												vntBillSeq, _
												vntBranchNo, _
												vntDelflg, _
												vntUpdDate, _
												vntUpdUser, _
												vntUserName, _
												vntBillcoment, _
												vntPaymentDate, _
												vntPaymentSeq, _
												vntPrice, _
												vntEditPrice, _
												vntTaxPrice, _
												vntEditTax, _
												vntSubTotal )

	lngBillCount = 0
	lngDelCount = 0

	For i=0 To lngPerBillCount - 1
		'������`�[�J�E���g����B
		If vntDelflg(i) = 1 Then
			lngDelCount = lngDelCount + 1
		End If

		'�������̐��������J�E���g����B�iohterIncomeInfo�̃p�����[�^�j
		If (IsNull(vntPaymentDate(i)) = True) AND (vntDelflg(i) = 0) Then
			lngBillCount = lngBillCount + 1
			strReqDmdDate = vntDmdDate(i)
			lngReqBillSeq = vntBillSeq(i)
			lngReqBranchNo = vntBranchNo(i)
		End If
	Next

	'�l��������񂪑��݂��Ȃ��ꍇ
'	If lngPerBillCount < 1 Then
'		Err.Raise 1000, , "�l��������񂪑��݂��܂���B�i�\��ԍ�= " & lngRsvNo & " PerBillCount= " & lngPerBillCount & ")"
'	End If

	''' �O�����Čl���S�����𐔂��邽�߂����ֈړ� 2003.12.18 by FFCS
	'�l��f���z���擾
	lngCount = objDemand.SelectConsult_mInfo(lngRsvNo, _
											 vntOrgCd1, _
											 vntOrgCd2, _
											 vntOrgSeq, _
											 vntOrgName, _
											 vntPrice_m, _
											 vntEditPrice_m, _
											 vntTaxPrice_m, _
											 vntEditTax_m, _
											 vntLineTotal, _ 
											 vntPriceSeq, _
											 vntCtrPtCd, _
											 vntOptCd, _
											 vntOptBranchNo, _
											 vntOptName, _
											 vntOtherLineDivCd, _
											 vntLineName, _
											 vntDmdDate_m, _
											 vntBillSeq_m, _
											 vntBranchNo_m, _
											 vntBillLineNo, _
											 vntPaymentDate_m, _
											 vntPaymentSeq_m, _
											 vntOmitTaxFlg, _
											 vntPrintDate )

	lngPerCount = 0
	For i=0 To lngCount - 1
		'�l���S���J�E���g����B
		If (( vntOrgCd1(i) = "XXXXX" ) AND (vntOrgCd1(i) = "XXXXX")) Then
			lngPerCount = lngPerCount + 1
		End If
	Next

	Exit Do
Loop

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���v�̕ҏW
'
' �����@�@ : 
'
' �߂�l�@ : ���v���R�[�h
'
' ���l�@�@ : SelectConsult_mTotal���s��ɋN��
'
'-------------------------------------------------------------------------------
Function SubPriceCount( )

	Dim lngRecode
	For lngRecode = 0 To lngPriceCount - 1
		If ( vntBreakOrgCd1 = vntSubOrgCd1(lngRecode) AND vntBreakOrgCd2 = vntSubOrgCd2(lngRecode) ) Then
			SubPriceCount = lngRecode
			Exit For
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
<TITLE>�������z�\���`�l</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
var winCreate1;			// �������쐬�E�B���h�E�n���h��
var winIncome1;			// �܂Ƃ߂ē����E�B���h�E�n���h��
var winOption;			// ��f�Z�b�g�ύX�E�B���h�E�n���h��
var winOther;			// �Z�b�g�O�����ǉ��E�B���h�E�n���h��
var winEditLine1;		// �Z�b�g�O�����o�^�E�C���E�B���h�E�n���h��
var winEditLine2;		// �������דo�^�E�C���E�B���h�E�n���h��
var winIncome;			// �������E�B���h�E�n���h��
var winHenkin;			// �ԋ����E�B���h�E�n���h��
var winPrint;			// ����E�B���h�E�n���h��


//�������쐬�E�B���h�E�\��
function create1Window() {

	var objForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g

	var url;			// URL������
	var opened = false;	// ��ʂ����łɊJ����Ă��邩

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winCreate1 != null ) {
		if ( !winCreate1.closed ) {
			opened = true;
		}
	}

	url = '/WebHains/contents/perbill/createPerBill1.asp?rsvno=<%= lngRsvNo %>';

	// �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winCreate1.focus();
		winCreate1.location.replace(url);
	} else {
		winCreate1 = window.open( url, '', 'width=530,height=500,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}
}

//�܂Ƃ߂ē����E�B���h�E�\��
function income1Window() {

	var objForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g

	var url;			// URL������
	var opened = false;	// ��ʂ����łɊJ����Ă��邩

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winIncome1 != null ) {
		if ( !winIncome1.closed ) {
			opened = true;
		}
	}

	url = '/WebHains/contents/perbill/perBillAllIncome.asp';
	url = url + '?rsvno=' + <%= lngRsvNo %>;
	url = url + '&perid=' + '<%= strPerID %>';

	// �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winIncome1.focus();
		winIncome1.location.replace(url);
	} else {
		winIncome1 = window.open( url, '', 'width=600,height=600,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}
}

//��f�Z�b�g�ύX�E�B���h�E�\��
function OptionWindow() {

	var objForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g

	var url;			// URL������
	var opened = false;	// ��ʂ����łɊJ����Ă��邩

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winOption != null ) {
		if ( !winOption.closed ) {
			opened = true;
		}
	}

	url = '/WebHains/contents/perbill/perBillOption.asp';
	url = url + '?rsvno=' + <%= lngRsvNo %>;

	// �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winOption.focus();
		winOption.location.replace(url);
	} else {
		winOption = window.open( url, '', 'width=430,height=500,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}
}

//�Z�b�g�O�����ǉ��E�B���h�E�\��
function otherIncomeWindow() {

	var objForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g

	var url;			// URL������
	var opened = false;	// ��ʂ����łɊJ����Ă��邩

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winOther != null ) {
		if ( !winOther.closed ) {
			opened = true;
		}
	}

	url = '/WebHains/contents/perbill/otherIncomeInfo.asp?rsvno=<%= lngRsvNo %>&billcount=<%= lngBillCount %>&dmddate=<%= strReqDmdDate %>&billseq=<%= lngReqBillSeq %>&branchno=<%= lngReqBranchNo %>';

	// �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winOther.focus();
		winOther.location.replace(url);
	} else {
		winOther = window.open( url, '', 'width=550,height=320,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}
}

//�Z�b�g�O�����o�^�E�C���E�B���h�E�\��
function editLine1Window( rsvNo, i) {

	var objForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g

	var url;			// URL������
	var opened = false;	// ��ʂ����łɊJ����Ă��邩

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winEditLine1 != null ) {
		if ( !winEditLine1.closed ) {
			opened = true;
		}
	}

	url = '/WebHains/contents/perbill/editPerBillLine1.asp';
	url = url + '?rsvno=' + rsvNo;
	url = url + '&record=' + i;

	// �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winEditLine1.focus();
		winEditLine1.location.replace(url);
	} else {
		winEditLine1 = window.open( url, '', 'width=550,height=335,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}
}

//�������דo�^�E�C���E�B���h�E�\��
function editLine2Window( rsvNo, i) {

	var objForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g

	var url;			// URL������
	var opened = false;	// ��ʂ����łɊJ����Ă��邩

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winEditLine2 != null ) {
		if ( !winEditLine2.closed ) {
			opened = true;
		}
	}

	url = '/WebHains/contents/perbill/editPerBillLine2.asp';
	url = url + '?rsvno=' + rsvNo;
	url = url + '&record=' + i;

	// �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winEditLine2.focus();
		winEditLine2.location.replace(url);
	} else {
		winEditLine2 = window.open( url, '', 'width=550,height=335,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}
}

//�������E�B���h�E�\��
function IncomeWindow(rsvNo, dmdDate, billSeq, branchNo ) {

	var objForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g

	var url;			// URL������
	var opened = false;	// ��ʂ����łɊJ����Ă��邩

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winIncome != null ) {
		if ( !winIncome.closed ) {
			opened = true;
		}
	}

	url = '/WebHains/contents/perbill/perBillIncome.asp';
	url = url + '?rsvno=' + rsvNo;
	url = url + '&dmddate=' + dmdDate;
	url = url + '&billseq=' + billSeq;
	url = url + '&branchno=' + branchNo;

	// �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winIncome.focus();
		winIncome.location.replace(url);
	} else {
		winIncome = window.open( url, '', 'width=600,height=600,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}
}

//�ԋ����E�B���h�E�\��
function HenkinWindow( rsvNo, dmdDate, billSeq, branchNo ) {

	var objForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g

	var url;			// URL������
	var opened = false;	// ��ʂ����łɊJ����Ă��邩

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winHenkin != null ) {
		if ( !winHenkin.closed ) {
			opened = true;
		}
	}

	url = '/WebHains/contents/perbill/perHenkin.asp';
	url = url + '?rsvno=' + rsvNo;
	url = url + '&dmddate=' + dmdDate;
	url = url + '&billseq=' + billSeq;
	url = url + '&branchno=' + branchNo;

	// �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winHenkin.focus();
		winHenkin.location.replace(url);
	} else {
		winHenkin = window.open( url, '', 'width=600,height=450,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}
}

//������E�B���h�E�\��
function PrintWindow( rsvNo, dmdDate, billSeq, branchNo ) {

	var objForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g

	var url;			// URL������
	var opened = false;	// ��ʂ����łɊJ����Ă��邩

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winPrint != null ) {
		if ( !winPrint.closed ) {
			opened = true;
		}
	}

	url = '/WebHains/contents/perbill/prtPerBill.asp';
	url = url + '?rsvno=' + rsvNo;
	url = url + '&dmddate=' + dmdDate;
	url = url + '&billseq=' + billSeq;
	url = url + '&branchno=' + branchNo;

	// �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winPrint.focus();
		winPrint.location.replace(url);
	} else {
		winPrint = window.open( url, '', 'width=600,height=450,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}
}

// submit���̏���
function submitForm( actMode ) {

	var objPrice;
	var i;

	objPrice = entryForm.editPrice;

	for ( ; ; ) {

		errFlg = false;

		// �S���S���z�e�L�X�g�̌���
		for ( i = 0; i < objPrice.length; i++ ) {
	
			if ( isNaN(objPrice[i].value) == true ) {
				errFlg = true;
				alert((i + 1) + '�s�ڂɓ��͂��ꂽ�������z�����l�Ƃ��ĔF�߂��܂���B');
				objPrice[i].focus()
			}

		}

		// ���K�\���`�F�b�N
		if ( errFlg == true ) {
			break;
		}

		// ���샂�[�h���w�肵��submit
		// �i�킴�킴���̂悤�ȏ������{���Ă���̂�Enter�L�[�ɂ��submit���s�킹�Ȃ����߂ł���j
		document.entryForm.actMode.value = actMode;
		document.entryForm.submit();

		break;
	}
}

// ���������
function deleteData() {

	if ( !confirm( '���̐��������폜���܂��B��낵���ł����H' ) ) {
		return;
	}

	// ���[�h���w�肵��submit
	document.entryForm.act.value = 'delete';
	document.entryForm.submit();

}

// ����ŖƏ�����
function OmitTaxAct() {

	if ( !confirm( '�l���S���z�̏���ł��ꊇ�ŖƏ����܂��B��낵���ł����H' ) ) {
		return;
	}

	// ���[�h���w�肵��submit
	document.entryForm.actMode.value = 'omit';
	document.entryForm.submit();

}

function windowClose() {

	// �������쐬�E�C���h�E�����
	if ( winCreate1 != null ) {
		if ( !winCreate1.closed ) {
			winCreate1.close();
		}
	}

	winCreate1 = null;

	// �܂Ƃ߂ē����E�C���h�E�����
	if ( winIncome1 != null ) {
		if ( !winIncome1.closed ) {
			winIncome1.close();
		}
	}

	winIncome1 = null;

	// �������E�C���h�E�����
	if ( winIncome != null ) {
		if ( !winIncome.closed ) {
			winIncome.close();
		}
	}

	winIncome = null;

	// �ԋ����E�C���h�E�����
	if ( winHenkin != null ) {
		if ( !winHenkin.closed ) {
			winHenkin.close();
		}
	}

	winHenkin = null;

	// ��f�Z�b�g�ύX�E�C���h�E�����
	if ( winOption != null ) {
		if ( !winOption.closed ) {
			winOption.close();
		}
	}

	winOption = null;

	// �Z�b�g�O�����ǉ��E�C���h�E�����
	if ( winOther != null ) {
		if ( !winOther.closed ) {
			winOther.close();
		}
	}

	winOther = null;

	// �Z�b�g�O�����o�^�E�C���E�C���h�E�����
	if ( winEditLine1 != null ) {
		if ( !winEditLine1.closed ) {
			winEditLine1.close();
		}
	}

	winEditLine1 = null;

	// �������דo�^�E�C���E�C���h�E�����
	if ( winEditLine2 != null ) {
		if ( !winEditLine2.closed ) {
			winEditLine2.close();
		}
	}

	winEditLine2 = null;

	// ����E�C���h�E�����
	if ( winPrint != null ) {
		if ( !winPrint.closed ) {
			winPrint.close();
		}
	}

	winPrint = null;


}


//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.prttab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONUNLOAD="javascript:windowClose()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
<BLOCKQUOTE>
<INPUT TYPE="hidden" NAME="mode"    VALUE="<%= strMode %>">
<INPUT TYPE="hidden" NAME="RsvNo"   VALUE="<%= lngRsvNo %>">
<INPUT TYPE="hidden" NAME="actMode" VALUE="<%= strActMode %>">
<!-- �\�� -->
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR HEIGHT="16">
		<TD HEIGHT="16" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print"></SPAN><FONT COLOR="#000000">���l��f���z���</FONT></B></TD>
	</TR>
</TABLE>

<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
		<TR>
			<TD NOWRAP >��f��</TD>
			<TD NOWRAP >�F</TD>
			<TD NOWRAP ><FONT COLOR="#ff6600"><B><%= strCslDate %></TD>
			<TD NOWRAP WIDTH="10"></TD>
			<TD NOWRAP >�\��ԍ�</TD>
			<TD NOWARP >�F</TD>
			<TD NOWRAP ><FONT COLOR="#ff6600"><B><%= lngRsvNo %></B></FONT></TD>
		</TR>
		<TR>
			<TD NOWRAP >��f�R�[�X</TD>
			<TD NOWRAP >�F</TD>
			<TD NOWRAP ><FONT COLOR="#ff6600"><B><%= strCsName %></B></FONT></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0" WIDTH="746">
		<TR>
			<TD COLSPAN="2" WIDTH="325" HEIGHT="10"></TD>
			<TD WIDTH="184" HEIGHT="10"></TD>
			<TD WIDTH="225" HEIGHT="10"></TD>
		</TR>
		<TR>
			<TD NOWRAP ROWSPAN="2" VALIGN="top" WIDTH="96" ><%= strPerId %></TD>
			<TD NOWRAP><B><a href="/webHains/contents/maintenance/personal/mntPersonal.asp?mode=update&perid=<%= strPerId %>" TARGET="_blank"><%= strLastName & " " & strFirstName %></a></B> (<FONT SIZE="-1"><%= strLastKname & "�@" & strFirstKName %></FONT>)</TD>
			<TD NOWRAP></TD>
			<TD NOWRAP></TD>
		</TR>
		<TR>
			<TD NOWRAP WIDTH="225"><%= FormatDateTime(strBirth, 1) %>���@<%= Int(strAge) %>�΁@<%= IIf(strGender = "1", "�j��", "����") %></TD>
			<TD align="right" NOWRAP WIDTH="184"><FONT COLOR="black"><INPUT TYPE="CHECKBOX" NAME="delDsp" VALUE="1" <%= IIf( lngDelDsp = "1", "CHECKED", "") %>> ����`�[���\������</FONT></TD>
			<TD NOWRAP WIDTH="225"><INPUT TYPE="IMAGE" SRC="../../images/b_prev.gif" BORDER="0" WIDTH="53" HEIGHT="28" ALT="�\������"></TD>
		</TR>
	</TABLE>
	<BR>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0" WIDTH="182">
		<TR>
			<TD NOWRAP><A HREF="JavaScript:create1Window()"><IMG SRC="/webHains/images/b_CrePerBill.gif" WIDTH="110" HEIGHT="24" ALT="�l�������ׂ��琿�������쐬���܂�"></A></TD>
			<TD NOWRAP><A HREF="JavaScript:income1Window()"><IMG SRC="/webHains/images/b_AllIncome.gif" WIDTH="110" HEIGHT="24" ALT="���̐������Ƃ܂Ƃ߂ē������܂�"></A></TD>
		</TR>
		<TR>
			<TD colspan="2" nowrap align="left" valign="BOTTOM"><BR>
			<SPAN STYLE="color:#cc9999">��</SPAN><FONT COLOR="black">�l���S���������</FONT></TD>
		</TR>
	</TABLE>

	<FONT COLOR="black"><SPAN STYLE="color:#cc9999"></SPAN></FONT>

<%
	'�l���S�Ȃ��H
	If lngPerCount = 0 Then
%>
		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
			<TD NOWRAP ><FONT>�@�l���S�͂���܂���B</TD>
		</TABLE>
<%
	Else
		'������`�[�����Ȃ��H
		If lngPerBillCount = lngDelCount Then
%>
			<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
				<TD NOWRAP ><FONT COLOR="#ff6600"><B>�@������������܂���B</B></TD>
			</TABLE>
<%
		End If
	End If
%>

<%
	If ((lngDelCount > 0) AND (lngDelDsp = 1)) OR (lngPerBillCount > lngDelCount) Then
%>
		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
			<TR BGCOLOR="CCCCCC">
				<TD NOWRAP ALIGN="left">������No.</TD>
				<TD NOWRAP>������������</TD>
				<TD NOWRAP ALIGN="RIGHT">�@���z</TD>
				<TD NOWRAP ALIGN="RIGHT">�������z</TD>
				<TD NOWRAP ALIGN="RIGHT">�@�Ŋz</TD>
				<TD NOWRAP ALIGN="RIGHT">�����Ŋz</TD>
				<TD NOWRAP ALIGN="RIGHT">���v</TD>
				<TD NOWRAP ALIGN="RIGHT">�����z</TD>
				<TD NOWRAP ALIGN="RIGHT">��������</TD>
				<TD NOWRAP ALIGN="RIGHT">�ԋ�</TD>
				<TD NOWRAP ALIGN="LEFT">���</TD>
			</TR>
<%
	End If

	Do

		'�G���[���͉������Ȃ�
		If strMessage <> "" Then Exit Do

		lngPerBillTotal = 0
		lngPerPayTotal = 0
		lngTotalFlg = 0

		'�l���������̕ҏW
		For i = 0 To lngPerBillCount - 1
			If ( (lngDelDsp = 1) OR (lngDelDsp <> 1 AND vntDelflg(i) <> 1) ) Then

				'������`�[�\�����莞�̐��������v�\��
				If( lngDelDsp = 1 AND vntDelflg(i) = 1 AND lngTotalFlg = 0 AND lngPerBillCount > lngDelCount) Then
%>
					<TR BGCOLOR="#FFFFFF">
						<TD></TD>
						<TD NOWRAP>���v</TD>
						<TD COLSPAN="4"></TD>
						<TD NOWRAP ALIGN="RIGHT"><B><%= FormatCurrency(lngPerBillTotal) %></B></TD>
						<TD NOWRAP ALIGN="RIGHT"><FONT COLOR=<%= IIf(lngPerPayTotal <> 0, "RED", "BLACK") %>><B><%= FormatCurrency(lngPerPayTotal) %></B></FONT></TD>
						<TD></TD>
					</TR>
<%
					lngTotalFlg = 1
					lngPerBillTotal = 0
					lngPerPayTotal = 0
				End If
%>
				<TR BGCOLOR=<%= IIf( vntDelflg(i) = "1", "#FFC0CB", "#EEEEEE") %> HEIGHT="24">
					<TD NOWRAP ALIGN="left"><A href="perBillInfo.asp?dmddate=<%= vntDmdDate(i) %>&billseq=<%= vntBillSeq(i) %>&branchno=<%= vntBranchNo(i) %>&rsvno=<%= lngRsvNo %>">
						<%= objCommon.FormatString(vntDmdDate(i), "yyyymmdd") %>
						<%= objCommon.FormatString(vntBillSeq(i), "00000") %>
						<%= vntBranchNo(i) %></A></TD>
					<TD NOWRAP><%= vntDmdDate(i) %><FONT COLOR="#666666"></FONT></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntPrice(i)) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntEditPrice(i)) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntTaxPrice(i)) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntEditTax(i)) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><B><%= FormatCurrency(vntSubTotal(i)) %></B></TD>
<%
				'������񂠂�H
				If IsNull(vntPaymentDate(i)) = False Then
%>
					<TD NOWRAP ALIGN="RIGHT"><B><%= FormatCurrency(0) %></B></TD>
<%
				Else
'					lngPerPayTotal = lngPerPayTotal + vntSubTotal(i)
					If vntBranchNo(i) = 0 Then
						lngPerPayTotal = lngPerPayTotal + vntSubTotal(i)
					End If
%>
					<TD NOWRAP ALIGN="RIGHT"><B><FONT  COLOR=<%= IIf(vntSubTotal(i) = 0 OR vntBranchNo(i) = 1, "BLACK", "RED") %>><%= IIf(vntBranchNo(i) = 0, FormatCurrency(vntSubTotal(i)), FormatCurrency(0)) %></FONT></B></TD>
<%
				End If
%>

<%
				If (vntBranchNo(i) = 0) Then
%>
					<TD NOWRAP ALIGN="RIGHT"><A HREF="JavaScript:IncomeWindow(<%= lngRsvNo %>, '<%= vntDmdDate(i) %>', <%= vntBillSeq(i) %>, <%= vntBranchNo(i) %>)">�������</A></TD>
					<TD nowrap align="CENTER"></TD>

<%				Else
%>
					<TD NOWRAP ALIGN="RIGHT"><A HREF="JavaScript:HenkinWindow(<%= lngRsvNo %>, '<%= vntDmdDate(i) %>', <%= vntBillSeq(i) %>, <%= vntBranchNo(i) %>)">�ԋ����</A></TD>
					<TD nowrap align="CENTER">��</TD>
<%
				End If
%>
				<TD NOWRAP ALIGN="RIGHT"><A HREF="JavaScript:PrintWindow(<%= lngRsvNo %>, '<%= vntDmdDate(i) %>', <%= vntBillSeq(i) %>, <%= vntBranchNo(i) %>)">
					<IMG SRC="/webHains/images/b_Prt.gif" WIDTH="51" HEIGHT="24" ALT="���̐�������������܂�">
				</A></TD>
				</TR>
<%
				lngPerBillTotal = lngPerBillTotal + vntSubTotal(i)
			End If

		Next

		Exit Do
	Loop
%>

<%
	'���v�\��
	If (lngPerBillCount > lngDelCount) OR (lngDelDsp = 1 AND lngDelCount > 0) Then
%>
			<TR BGCOLOR="#FFFFFF" HEIGHT="24">
				<TD></TD>
				<TD NOWRAP>���v</TD>
				<TD COLSPAN="4"></TD>
				<TD NOWRAP ALIGN="RIGHT"><B><%= FormatCurrency(lngPerBillTotal) %></B></TD>
				<TD NOWRAP ALIGN="RIGHT"><FONT COLOR=<%= IIf(lngPerPayTotal <> 0, "RED", "BLACK") %>><B><%= FormatCurrency(lngPerPayTotal) %></B></FONT></TD>
				<TD></TD>
			</TR>
		</TABLE>
<%
	End If
%>

	<BR>
	<HR>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="2">
		<TR>
			<TD nowrap align="left" valign="BOTTOM" COLSPAN="3">
				<SPAN STYLE="color:#cc9999">��</SPAN><FONT COLOR="black">�l���S���z�ڍ׏��</FONT>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP ALIGN="LEFT" VALIGN="BOTTOM">
				<A HREF="JavaScript:OptionWindow()">
					<IMG SRC="/webHains/images/b_ChangeSet.gif" WIDTH="110" HEIGHT="24" ALT="��f�Z�b�g��ύX���܂�">
				</A>
			</TD>
			<TD NOWRAP ALIGN="LEFT" VALIGN="BOTTOM">
				<A HREF="JavaScript:otherIncomeWindow()">
					<IMG SRC="/webHains/images/b_OtherSet.gif" WIDTH="110" HEIGHT="24" ALT="�Z�b�g�O�������׏���ǉ����܂�">
				</A>
			</TD>
			<TD NOWRAP ALIGN="LEFT" VALIGN="BOTTOM">
				<A HREF="JavaScript:OmitTaxAct()">
					<IMG SRC="/webHains/images/b_delTax.gif" WIDTH="110" HEIGHT="24" ALT="�S�Ă̌l���ׂɂ����ď���ł�Ə����܂�">
				</A>
			</TD>
		</TR>
	</TABLE>

<%
	Do

		'�G���[���͉������Ȃ�
		If strMessage <> "" Then Exit Do

		''' �O�����Čl���S�̌�����m�肽���̂ŁA�ŏ��Ɏ擾����B 2003.12.18 by FFCS
		'�l��f���z���擾
'		lngCount = objDemand.SelectConsult_mInfo(lngRsvNo, _
'												 vntOrgCd1, _
'												 vntOrgCd2, _
'												 vntOrgSeq, _
'												 vntOrgName, _
'												 vntPrice_m, _
'												 vntEditPrice_m, _
'												 vntTaxPrice_m, _
'												 vntEditTax_m, _
'												 vntLineTotal, _ 
'												 vntPriceSeq, _
'												 vntCtrPtCd, _
'												 vntOptCd, _
'												 vntOptBranchNo, _
'												 vntOptName, _
'												 vntOtherLineDivCd, _
'												 vntLineName, _
'												 vntDmdDate_m, _
'												 vntBillSeq_m, _
'												 vntBranchNo_m, _
'												 vntBillLineNo, _
'												 vntPaymentDate_m, _
'												 vntPaymentSeq_m, _
'												 vntOmitTaxFlg, _
'												 vntPrintDate )


		'��f���z��񂪑��݂��Ȃ��ꍇ
		If lngCount < 1 Then
			Exit Do
		End If

		'�l��f���z���v�擾
		lngPriceCount = objDemand.SelectConsult_mTotal(lngRsvNo, _
														vntSubOrgCd1, _
														vntSubOrgCd2, _
														vntSubPrice_m, _
														vntSubEditPrice_m, _
														vntSubTax_m, _
														vntSubEditTax_m, _
														vntSubTotal_m )

		'���v�v�Z
		lngPriceTotal = 0
		lngEditPriceTotal = 0
		lngTaxTotal = 0
		lngEditTaxTotal = 0
		lngTotal = 0

		For i = 0 To lngPriceCount - 1
			lngPriceTotal = lngPriceTotal + vntSubPrice_m(i)
			lngEditPriceTotal = lngEditPriceTotal + vntSubEditPrice_m(i)
			lngTaxTotal = lngTaxTotal + vntSubTax_m(i)
			lngEditTaxTotal = lngEditTaxTotal + vntSubEditTax_m(i)
			lngTotal = lngTotal + vntSubTotal_m(i)

		Next


		If blnExistsClose = True Then
%>
			<FONT COLOR="#ff6600"><B><%= strReadyCloseString %></B></FONT>
<%
		End If

		'�u���C�N�p�ϐ�������
		vntBreakOrgCd1 = vntORGCD1(0)
		vntBreakOrgCd2 = vntORGCD2(0)
'		vntBreakOrgCd1 = ""
'		vntBreakOrgCd2 = ""
		lngHeader = 0

%>
		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
			<TR BGCOLOR="silver">
				<TD NOWRAP >���S��</TD>
				<TD NOWRAP >�������ז�</TD>
				<TD NOWRAP ALIGN="RIGHT">�@���z</TD>
				<TD NOWRAP ALIGN="RIGHT">�������z</TD>
				<TD NOWRAP ALIGN="RIGHT">�@�Ŋz</TD>
				<TD NOWRAP ALIGN="RIGHT">�����Ŋz</TD>
				<TD NOWRAP ALIGN="RIGHT">���v</TD>
				<TD NOWRAP ALIGN="RIGHT">�ŖƏ�</TD>
				<TD NOWRAP ALIGN="RIGHT">SEQ</TD>
				<TD NOWRAP ALIGN="RIGHT">�Z�b�g�R�[�h</TD>
				<TD NOWRAP ALIGN="RIGHT">������No.</TD>
				<TD NOWRAP ALIGN="RIGHT">�����z</TD>
			</TR>

<%


		'�l���S���������̕ҏW
		For i = 0 To lngCount - 1

			'���S���̍Ō�ɏ��v��\������B
			If ((vntBreakOrgCd1 <> vntORGCD1(i)) OR (vntBreakOrgCd2 <> vntORGCD2(i)) ) Then

				lngSubCount = SubPriceCount()
%>
				<TR BGCOLOR="#FFFFFF">
					<TD COLSPAN="1"></TD>
					<TD NOWRAP>���v</TD>
					<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntSubPrice_m(lngSubCount)) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntSubEditPrice_m(lngSubCount)) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntSubTax_m(lngSubCount)) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntSubEditTax_m(lngSubCount)) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntSubTotal_m(lngSubCount)) %></TD>
				</TR>
				<TR BGCOLOR="#FFFFFF"><TD HEIGHT="5"></TD></TR>
<%
				
				'�u���C�N�p�ϐ��A�ăZ�b�g
				vntBreakOrgCd1       = vntORGCD1(i)
				vntBreakOrgCd2       = vntORGCD2(i)

			End If

			If (( vntORGCD1(i) <> "XXXXX" OR vntORGCD2(i) <> "XXXXX") AND (lngHeader = 0) ) Then

				lngHeader = 1
%>
				<TR BGCOLOR="#FFFFFF">
					<TD COLSPAN="2" VALIGN="bottom" HEIGHT="30"><SPAN STYLE="color:#cc9999">��</SPAN><FONT COLOR="black">�c�̕��S���z���</FONT></TD>
					<TD></TD>
				</TR>
				<TR BGCOLOR=#EEEEEE>
					<TD NOWRAP BGCOLOR="silver">���S��</TD>
					<TD NOWRAP BGCOLOR="silver">�������ז�</TD>
					<TD NOWRAP ALIGN="RIGHT" BGCOLOR="silver">�@���z</TD>
					<TD NOWRAP ALIGN="RIGHT" BGCOLOR="silver">�������z</TD>
					<TD NOWRAP ALIGN="RIGHT" BGCOLOR="silver">�@�Ŋz</TD>
					<TD NOWRAP ALIGN="RIGHT" BGCOLOR="silver">�����Ŋz</TD>
					<TD NOWRAP ALIGN="RIGHT" BGCOLOR="silver">���v</TD>
					<TD NOWRAP ALIGN="RIGHT" BGCOLOR="silver"></TD>
					<TD NOWRAP ALIGN="RIGHT" BGCOLOR="silver">SEQ</TD>
					<TD NOWRAP ALIGN="RIGHT" BGCOLOR="silver">�Z�b�g�R�[�h</TD>
					<TD NOWRAP ALIGN="RIGHT" BGCOLOR="silver">������No.</TD>
				</TR>

<%
			End If
%>
			<TR BGCOLOR=#EEEEEE>
				<TD NOWRAP><%= vntOrgCd1(i) & "-" & vntOrgCd2(i) & "�F" & vntOrgName(i) %></TD>
<%
				'���S�����l�̏ꍇ
				If (( vntORGCD1(i) = "XXXXX" ) AND (vntORGCD2(i) = "XXXXX")) Then

					'�̎�������ρH
					If vntPrintDate(i) <> "" Then
%>
						<TD NOWRAP><%= vntLineName(i) %></A><FONT COLOR="#666666"></FONT></TD>
<%
					Else
						'�Z�b�g�O�R�[�h�H
						If vntOtherLineDivCd(i) <> "" Then
%>
							<TD NOWRAP><A HREF="JavaScript:editLine2Window(<%= lngRsvNo %>, <%= i %>)"><%= vntLineName(i) %></A><FONT COLOR="#666666"></FONT></TD>
<%
						Else
%>
							<TD NOWRAP><A HREF="JavaScript:editLine1Window(<%= lngRsvNo %>, <%= i %>)"><%= vntLineName(i) %></A><FONT COLOR="#666666"></FONT></TD>
<%
						End If
					End If

				Else
%>
					<TD NOWRAP><A HREF="JavaScript:editLine1Window(<%= lngRsvNo %>, <%= i %>)"><%= vntLineName(i) %></A><FONT COLOR="#666666"></FONT></TD>
<%				
				End If
%>
				<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntPrice_m(i)) %></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntEditPrice_m(i)) %></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntTaxPrice_m(i)) %></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntEditTax_m(i)) %></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntLineTotal(i)) %></TD>
<%
				'���S�����l�̏ꍇ
				If (( vntORGCD1(i) = "XXXXX" ) AND (vntORGCD2(i) = "XXXXX")) Then
%>
					<TD NOWRAP ALIGN="CENTER"><%= IIf( vntOmitTaxFlg(i)=1, "��", "" ) %></TD>
<%
				Else
%>
				<TD NOWRAP ALIGN="RIGHT"></TD>

<%
				End If
%>
				<TD NOWRAP ALIGN="RIGHT"><%= vntPriceSeq(i) %></TD>
<%
				If vntOptCd(i) <> "" Then
%>
					<TD NOWRAP ALIGN="RIGHT"><%= vntOptCd(i) & "-" & vntOptBranchNo(i) %></TD>
<%
				Else
%>
					<TD NOWRAP ALIGN="RIGHT"></TD>
<%
				End If
%>

<%
				If (vntDmdDate_m(i) <> "") AND (vntBillSeq_m(i) <> "") AND (vntBranchNo_m(i) <> "") Then 

%>
					<TD NOWRAP ALIGN="left"><A href="perBillInfo.asp?dmddate=<%= vntDmdDate_m(i) %>&billseq=<%= vntBillSeq_m(i) %>&branchno=<%= vntBranchNo_m(i) %>&rsvno=<%= lngRsvNo %>">
						<%= objCommon.FormatString(vntDmdDate_m(i), "yyyymmdd") %>
						<%= objCommon.FormatString(vntBillSeq_m(i), "00000") %>
						<%= vntBranchNo_m(i) %></A></TD>
<%
				Else
%>
					<TD NOWRAP ALIGN="RIGHT"></TD>
<%
				End If

				'���S�����l�̏ꍇ
				If (( vntORGCD1(i) = "XXXXX" ) AND (vntORGCD2(i) = "XXXXX")) Then
'					If IsNull(vntPaymentDate_m(i)) = True Then
					If (vntPaymentDate_m(i) = "") OR (vntPaymentSeq_m(i) = "") Then 
%>
						<TD NOWRAP ALIGN="RIGHT"><FONT COLOR="RED"><B>����</B></FONT></TD>
<%
					Else
%>
						<TD NOWRAP ALIGN="RIGHT"></TD>
<%
					End If
				End If
%>
			</TR>
<%
		Next

		lngSubCount = SubPriceCount()
%>
			<TR BGCOLOR="#FFFFFF"><TD HEIGHT="5"></TD></TR>
			<TR BGCOLOR="#FFFFFF">
				<TD COLSPAN="1"></TD>
				<TD NOWRAP>���v</TD>
				<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntSubPrice_m(lngSubCount)) %></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntSubEditPrice_m(lngSubCount)) %></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntSubTax_m(lngSubCount)) %></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntSubEditTax_m(lngSubCount)) %></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntSubTotal_m(lngSubCount)) %></TD>
			</TR>

			<TR BGCOLOR="#FFFFFF"><TD HEIGHT="5"></TD></TR>
			<TR></TR>
			<TR></TR>
			<TR BGCOLOR="#FFFFFF">
				<TD COLSPAN="1"></TD>
				<TD NOWRAP>���v</TD>
				<TD NOWRAP ALIGN="RIGHT"><B><%= FormatCurrency(lngPriceTotal) %><B></TD>
				<TD NOWRAP ALIGN="RIGHT"><B><%= FormatCurrency(lngEditPriceTotal) %><B></TD>
				<TD NOWRAP ALIGN="RIGHT"><B><%= FormatCurrency(lngTaxTotal) %><B></TD>
				<TD NOWRAP ALIGN="RIGHT"><B><%= FormatCurrency(lngEditTaxTotal) %><B></TD>
				<TD NOWRAP ALIGN="RIGHT"><B><%= FormatCurrency(lngTotal) %><B></TD>
			</TR>
		</TABLE>

		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
			<BR>
			<TR>
				<TD COLSPAN="5" NOWRAP>
				<SPAN STYLE="color:#cc9999">��</SPAN>������No���\������Ă���ꍇ�A�������N���b�N����Ɛ���������ʂ��\������܂��B<BR>
				</TD>
			</TR>
			<TR BGCOLOR="silver">
				<TD NOWRAP COLSPAN="2">���S��</TD>
				<TD NOWRAP COLSPAN="2">�R�[�X</TD>
				<TD NOWRAP>������No</TD>
			</TR>
<%
			'���ߏ��̕ҏW
'KMT
'Err.Raise 1000, , "�i�\��ԍ�= " & lngRsvNo & " )  lngCloseCount= " & lngCloseCount & ""
'Exit Do

			For i = 0 To lngCloseCount - 1
%>
				<TR BGCOLOR=#EEEEEE>
					<TD NOWRAP><%= vntCloseORGCD1(i) & "-" & vntCloseORGCD2(i) %></TD>
					<TD NOWRAP><%= vntCloseORGNAME(i) %></TD>
					<TD NOWRAP><%= vntCloseCSCD(i) %></TD>
					<TD NOWRAP><%= vntCloseCSNAME(i) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><A HREF="/webHains/contents/demand/dmdBurdenList.asp?action=search&IsPrint=0&billNo=<%= vntBillNo(i) %>"><%= vntBillNo(i) %></A></TD>
				</TR>
<%
			Next
%>
		</TABLE>
<%
		Exit Do
	Loop
%>


</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->

</BODY>
</HTML>
