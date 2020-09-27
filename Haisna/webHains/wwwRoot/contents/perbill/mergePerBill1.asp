<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �������������� (Ver0.0.1)
'	   AUTHER  : keiko fujii@ffcs.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const DEFAULT_ROW         = 5			'�f�t�H���g�\���s��
Const INCREASE_COUNT      =  5			'�\���s���̑����P��

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon		'���ʃN���X
Dim objPerBill		'��v���A�N�Z�X�p
Dim objHainsUser	'���[�U���A�N�Z�X�p
Dim objConsult		'��f���A�N�Z�X�p

Dim strMode			'�������[�h(�}��:"insert"�A�X�V:"update")
Dim strAction		'�������(�ۑ��{�^��������:"save"�A�ۑ�������:"saveend")
Dim strTarget		'�^�[�Q�b�g���URL

Dim strDmdDate     	'������
Dim lngBillSeq     	'�������r����
Dim lngDelflg     	'����`�[�t���O
Dim lngBranchNo     '�������}��
Dim lngPriceTotal   '�������z���v
Dim lngTaxTotal     '�ŋ����v
Dim strUpdDate		'�X�V���t
Dim strUpdUser      '�X�V��

'�����ς�
Dim vntPerID		'�l�h�c
Dim vntLastName		'��
Dim vntFirstName	'��
Dim vntLastKName	'�J�i��
Dim vntFirstKName	'�J�i��
Dim vntCslDate		'��f��
Dim vntRsvNo		'�\��ԍ�
Dim vntCtrPtCd		'�_��p�^�[���R�[�h�i��f�R�[�X�j
Dim vntCsName		'��f�R�[�X��


Dim lngCountCsl		'��f���
Dim lngBillCnt		'�w�萿������
Dim lngDispCnt		'�w��\��������

'�I��p
Dim arrDmdDate     	'������ �z��
Dim arrBillSeq     	'�������r���� �z��
Dim arrBranchNo     '�������}�� �z��
Dim arrPerID		'�l�h�c �z��
Dim arrLastName		'�� �z��
Dim arrFirstName	'�� �z��
Dim arrLastKName	'�J�i�� �z��
Dim arrFirstKName	'�J�i�� �z��
Dim arrRsvNo		'�\��ԍ� �z��
Dim arrAge			'�N�� �z��
Dim arrGender		'���� �z��
'Dim arrGenderName	'���ʖ��� �z��

'�����ҏ��
Dim vntFDmdDate     '������ �z��
Dim vntFBillSeq     '�������r���� �z��
Dim vntFBranchNo    '�������}�� �z��
Dim vntFPerID		'�l�h�c �z��
Dim vntFLastName	'�� �z��
Dim vntFFirstName	'�� �z��
Dim vntFLastKName	'�J�i�� �z��
Dim vntFFirstKName	'�J�i�� �z��
Dim vntFRsvNo		'�\��ԍ� �z��
Dim vntFAge			'�N�� �z��
Dim vntFGender		'���� �z��
Dim lngFriendsCnt	'�����Ґ���������
Dim lngSetFlg		'�����҃Z�b�g�ς݃t���O

Dim i				'�J�E���^
Dim j				'�J�E���^

Dim Ret				'�֐��߂�l

Dim strArrGenderName()		'���ʖ���

Dim strArrDispCnt()         '�w��\����
Dim strArrDispCntName()		'�w��\��������

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objHainsUser    = Server.CreateObject("HainsHainsUser.HainsUser")
Set objPerBill      = Server.CreateObject("HainsPerBill.PerBill")
Set objConsult      = Server.CreateObject("HainsConsult.Consult")

'�����l�̎擾
strMode           = Request("mode")
strAction         = Request("act")
strTarget         = Request("target")
strDmdDate        = Request("dmddate")
lngBillSeq        = Request("billseq")
lngBranchNo       = Request("branchno")


arrPerId       = ConvIStringToArray(Request("gdePerId"))
arrLastName    = ConvIStringToArray(Request("gdeLastName"))
arrFirstName   = ConvIStringToArray(Request("gdeFirstName"))
arrLastKName   = ConvIStringToArray(Request("gdeLastKName"))
arrFirstKName  = ConvIStringToArray(Request("gdeFirstKName"))
arrAge         = ConvIStringToArray(Request("gdeAge"))
arrGender      = ConvIStringToArray(Request("gdeGender"))
arrRsvNo       = ConvIStringToArray(Request("gdeRsvNo"))
arrDmdDate     = ConvIStringToArray(Request("gdeDmdDate"))
arrBillSeq     = ConvIStringToArray(Request("gdeBillSeq"))
arrBranchNo    = ConvIStringToArray(Request("gdeBranchNo"))

lngPriceTotal  = Request("priceTotal")
lngTaxTotal    = Request("taxTotal")
strUpdDate	   = Request("updDate")
strUpdUser     = Session.Contents("userId")

lngBillCnt     = Request("billcnt")
lngDispCnt     = CLng("0" & Request("dispCnt"))

'�����l�ݒ�
lngBillCnt   = IIf(IsNumeric(lngBillCnt) = False, 0,  lngBillCnt )
strMode   = IIf(strMode = "", "init",  strMode )

'���ʂ̔z��쐬
Call CreateGenderInfo()

'�w��\�����̔z��쐬
Call CreateDispCntInfo

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do

	'�����\����
	If lngDispCnt <= 0 Then
		'�����l
		lngDispCnt = DEFAULT_ROW
	End If
	
	If strMode = "init" Then
		arrPerId = Array()
		Redim Preserve arrPerId(lngDispCnt)       
		arrLastName = Array()
		Redim Preserve arrLastName(lngDispCnt)       
		arrFirstName = Array()
		Redim Preserve arrFirstName(lngDispCnt)       
		arrLastKname = Array()
		Redim Preserve arrLastKname(lngDispCnt)       
		arrFirstKName = Array()
		Redim Preserve arrFirstKName(lngDispCnt)       
		arrAge = Array()
		Redim Preserve arrAge(lngDispCnt)       
		arrGender = Array()
		Redim Preserve arrGender(lngDispCnt)       
		arrRsvNo = Array()
		Redim Preserve arrRsvNo(lngDispCnt)       
		arrDmdDate = Array()
		Redim Preserve arrDmdDate(lngDispCnt)       
		arrBillSeq = Array()
		Redim Preserve arrBillSeq(lngDispCnt)       
		arrBranchNo = Array()
		Redim Preserve arrBranchNo(lngDispCnt)
	Else
		'�s���ύX���A�z��̍Ē�`
		If strMode = "change" Then
			Redim Preserve arrPerId(lngDispCnt)       
			Redim Preserve arrLastName(lngDispCnt)       
			Redim Preserve arrFirstName(lngDispCnt)       
			Redim Preserve arrLastKname(lngDispCnt)       
			Redim Preserve arrFirstKName(lngDispCnt)       
			Redim Preserve arrAge(lngDispCnt)       
			Redim Preserve arrGender(lngDispCnt)       
			Redim Preserve arrRsvNo(lngDispCnt)       
			Redim Preserve arrDmdDate(lngDispCnt)       
			Redim Preserve arrBillSeq(lngDispCnt)       
			Redim Preserve arrBranchNo(lngDispCnt)
		End If
	End If       


	'�������m������\��ԍ����擾�����ꂼ��̎�f�����擾����
	lngCountCsl = objPerbill.SelectPerBill_csl(strDmdDate, _
							lngBillSeq, _
							lngBranchNo, _
							vntRsvNo, _
							vntCslDate, _
							vntPerId, _
							vntLastName, _
							vntFirstName, _
							vntLastKName, _
							vntFirstKName, _
							vntCtrPtCd, _
							vntCsName )
	'��f��񂪑��݂��Ȃ��ꍇ
	If lngCountCsl < 1 Then
		Err.Raise 1000, , "��������񂪎擾�ł��܂���B�i������No�@= " & objCommon.FormatString(strDmdDate, "yyyymmdd") & objCommon.FormatString(lngBillSeq, "00000") & lngBranchNo &" )"
	End If


	'�������m������l�������Ǘ������擾����
	objPerbill.SelectPerBill_BillNo strDmdDate, _
						   lngBillSeq, _
						   lngBranchNo, _
						   lngDelflg, _
						   , _
						   , _
						   , _
						   , _
						   , _
						   , _
						   , _
						   , _
						   , _
						   , _
						   lngPriceTotal, _
						   lngTaxTotal
						   

	'�����Ґ������Z�b�g�v����
	If strMode = "friends" Then
		'�����Ґ������擾
		lngFriendsCnt = objPerbill.SelectFriendsPerBill ( _
													vntCslDate,    vntRsvNo, _
													vntFDmdDate,   vntFBillSeq,     vntFBranchNo, _
													vntFPerID,     vntFLastName,    vntFFirstName, _
													vntFLastKName, vntFFirstKName, _
													vntFRsvNo,     vntFAge,         vntFGender )

		For i = 0 To lngFriendsCnt - 1
			lngSetFlg = 0
			For j = 0 To lngBillCnt - 1
				'���ɃZ�b�g����Ă��邩�H
				If arrDmdDate(j) = vntFDmdDate(i) And _
                   arrBillSeq(j) = vntFBillSeq(i) And _
                   arrBranchNo(j) = vntFBranchNo(i)      Then
					lngSetFlg = 1
					Exit For
				End If
			Next
			'���ɂȂ鐿�����H
			If strDmdDate = vntFDmdDate(i) And _
			   lngBillSeq = vntFBillSeq(i) And _
			   lngBranchNo = vntFBranchNo(i)      Then
				lngSetFlg = 1
			End If
			'�Z�b�g����Ă��Ȃ����
			If lngSetFlg = 0 Then
				'�s��������Ȃ���Α��₷
				If CLng(lngDispCnt) <= CLng(lngBillCnt) Then
					lngDispCnt = lngDispCnt + INCREASE_COUNT
		        	Redim Preserve arrPerId(lngDispCnt)       
		        	Redim Preserve arrLastName(lngDispCnt)      
		        	Redim Preserve arrFirstName(lngDispCnt)     
		        	Redim Preserve arrLastKname(lngDispCnt)     
		        	Redim Preserve arrFirstKName(lngDispCnt)    
		        	Redim Preserve arrAge(lngDispCnt)       
		        	Redim Preserve arrGender(lngDispCnt)       
		        	Redim Preserve arrRsvNo(lngDispCnt)       
		        	Redim Preserve arrDmdDate(lngDispCnt)       
		        	Redim Preserve arrBillSeq(lngDispCnt)       
		        	Redim Preserve arrBranchNo(lngDispCnt)
		        End If
				arrPerId(lngBillCnt)      = vntFPerID(i)
			    arrLastName(lngBillCnt)   = vntFLastName(i)
			    arrFirstName(lngBillCnt)  = vntFFirstName(i)
			    arrLastKname(lngBillCnt)  = vntFLastKName(i)
			    arrFirstKName(lngBillCnt) = vntFFirstKName(i)
			    arrAge(lngBillCnt)        = vntFAge(i)
			    arrGender(lngBillCnt)     = vntFGender(i)
			    arrRsvNo(lngBillCnt)      = vntFRsvNo(i)
			    arrDmdDate(lngBillCnt)    = vntFDmdDate(i)
			    arrBillSeq(lngBillCnt)    = vntFBillSeq(i)
			    arrBranchNo(lngBillCnt)   = vntFBranchNo(i)
				lngBillCnt = lngBillCnt + 1
			End If
		Next
		
	End If
	Exit Do
Loop

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �w��\�����������̔z��쐬
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub CreateDispCntInfo()

	Redim Preserve strArrDispCnt(9)
	Redim Preserve strArrDispCntName(9)

	strArrDispCnt(0) = 5:strArrDispCntName(0) = "5��"
	strArrDispCnt(1) = 10:strArrDispCntName(1) = "10��"
	strArrDispCnt(2) = 15:strArrDispCntName(2) = "15��"
	strArrDispCnt(3) = 20:strArrDispCntName(3) = "20��"
	strArrDispCnt(4) = 25:strArrDispCntName(4) = "25��"
	strArrDispCnt(5) = 30:strArrDispCntName(5) = "30��"
	strArrDispCnt(6) = 35:strArrDispCntName(6) = "35��"
	strArrDispCnt(7) = 40:strArrDispCntName(7) = "40��"
	strArrDispCnt(8) = 45:strArrDispCntName(8) = "45��"
	strArrDispCnt(9) = 50:strArrDispCntName(9) = "50��"

End Sub

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���ʖ��̂̔z��쐬
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub CreateGenderInfo()

	Redim Preserve strArrGenderName(1)

	strArrGenderName(0) = "�j��"
	strArrGenderName(1) = "����"

End Sub

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>��������������</TITLE>
<SCRIPT TYPE="text/javascript">
<!---
// ���������̃N���A
function clearPerBillInfo(index, PerId, LastName, FirstName, LastKName, FirstKName, Age, Gender, RsvNo, DmdDate, BillSeq, BranchNo ) {

	// �l�h�c�̃N���A
	if ( PerId ) {
		PerId.value = '';
	}
	// �l�h�c�G�������g�̃N���A
	if ( document.getElementById( 'billPerId' + index ) ) {
		document.getElementById( 'billPerId' + index ).innerHTML = '';
	}


	// �����̃N���A
	if ( LastName ) {
		LastName.value = '';
	}
	if ( FirstName ) {
		FirstName.value = '';
	}
	if ( LastKName ) {
		LastKName.value = '';
	}
	if ( FirstKName ) {
		FirstKName.value = '';
	}
	// �����G�������g�̃N���A
	if ( document.getElementById( 'billPerName' + index ) ) {
		document.getElementById( 'billPerName' + index ).innerHTML = '';
	}


	// �N��̃N���A
	if ( Age ) {
		Age.value = '';
	}
	// �N��G�������g�̃N���A
	if ( document.getElementById( 'billAge' + index ) ) {
		document.getElementById( 'billAge' + index ).innerHTML = '';
	}


	// ���ʂ̃N���A
	if ( Gender ) {
		Gender.value = '';
	}
	// ���ʃG�������g�̃N���A
	if ( document.getElementById( 'billGender' + index ) ) {
		document.getElementById( 'billGender' + index ).innerHTML = '';
	}


	// �\��ԍ��̃N���A
	if ( RsvNo ) {
		RsvNo.value = '';
	}
	// �\��ԍ��G�������g�̃N���A
	if ( document.getElementById( 'billRsvno' + index ) ) {
		document.getElementById( 'billRsvNo' + index ).innerHTML = '';
	}


	// �������m���̃N���A
	if ( DmdDate ) {
		DmdDate.value = '';
	}
	if ( BillSeq ) {
		BillSeq.value = '';
	}
	if ( BranchNo ) {
		BranchNo.value = '';
	}
	// �������m���G�������g�̃N���A
	if ( document.getElementById( 'billNo' + index ) ) {
		document.getElementById( 'billNo' + index ).innerHTML = '';
	}


}
//-->
<!--
// ����ʏ���
function goNextPage() {


	// ����ʂ𑗐M
	document.entryForm.act.value = 'save';
	document.entryForm.submit();

	return false;
}

// �e�E�C���h�E�֖߂�
function goBackPage() {

	// �A����ɐݒ肳��Ă���e��ʂ̊֐��Ăяo��
	if ( opener.dmdPayment_CalledFunction != null ) {
		opener.dmdPayment_CalledFunction();
	}

	close();

	return false;
}

var winGuidePerBill;		// �E�B���h�E�n���h��
var winmergePerBill2;		// �E�B���h�E�n���h��
var varPerBill_PerId;		// �l�h�c
var varPerBill_LastName;	// ��
var varPerBill_FirstName;	// ��
var varPerBill_LastKName;	// �J�i��
var varPerBill_FirstKName;	// �J�i��
var varPerBill_Age;		// �N��
var varPerBill_Gender;		// ����
var varPerBill_RsvNo;		// �\��ԍ�
var varPerBill_DmdDate;		// ������
var varPerBill_BillSeq;		// �������r����
var varPerBill_BranchNo;	// �������}��

//�l�������̌�����ʌĂяo��
function callgdePerBill(index,keyDmdDate, mergeBillSeq, mergeBranchNo, Perid, LastName,FirstName, LastKName, FirstKName, Age, Gender, RsvNo, DmdDate, BillSeq, BranchNo) {

	var objForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g

	var url;			// URL������
	var opened = false;	// ��ʂ����łɊJ����Ă��邩


	// �K�C�h�Ƃ̘A���p�ϐ��ɃG�������g��ݒ�
	varPerBill_PerId = Perid;
	varPerBill_LastName = LastName;
	varPerBill_FirstName = FirstName;
	varPerBill_LastKName = LastKName;
	varPerBill_FirstKName = FirstKName;
	varPerBill_Age = Age;
	varPerBill_Gender = Gender;
	varPerBill_RsvNo = RsvNo;
	varPerBill_DmdDate = DmdDate;
	varPerBill_BillSeq = BillSeq;
	varPerBill_BranchNo = BranchNo;

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winGuidePerBill != null ) {
		if ( !winGuidePerBill.closed ) {
			opened = true;
		}
	}
	url = '/WebHains/contents/perbill/gdePerBill.asp?dmddate=' + keyDmdDate + '&billseq=' + mergeBillSeq + '&branchno=' + mergeBranchNo + '&lineno=' + index;

	// �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winGuidePerBill.focus();
		winGuidePerBill.location.replace( url );
	} else {
// ## 2003.12.20 Mod By T.Takagi@FSIT
//		winGuidePerBill = window.open( url, '', 'width=1000,height=370,status=yes,directories=no,menubar=yes,resizable=yes,toolbar=yes,scrollbars=yes');
		winGuidePerBill = window.open( url, '', 'width=800,height=370,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
// ## 2003.12.20 Mod End
	}

	if (document.entryForm.billcnt.value < index+1){
		document.entryForm.billcnt.value = index+1
	}

	document.entryForm.mode.value = 'guide';

}

// ���������ҏW�p�֐�
function setDmdDataInfo(lineno, PerId, LastName, FirstName, LastKName, FirstKName, Age, Gender, RsvNo, DmdDate, BillSeq, BranchNo ) {

	var varWorkSeq;

	// �l�h�c�̕ҏW
	if ( varPerBill_PerId ) {
		varPerBill_PerId.value = PerId;
	}
	if ( document.getElementById( 'billPerId' + lineno ) ) {
		document.getElementById( 'billPerId' + lineno ).innerHTML = PerId;
	}

	// �����̕ҏW
	if ( varPerBill_LastName ) {
		varPerBill_LastName.value = LastName;
	}
	if ( varPerBill_FirstName ) {
		varPerBill_FirstName.value = FirstName;
	}
	if ( varPerBill_LastKName ) {
		varPerBill_LastKName.value = LastKName;
	}
	if ( varPerBill_FirstKName ) {
		varPerBill_FirstKName.value = FirstKName;
	}
	if ( document.getElementById( 'billPerName' + lineno ) ) {
		document.getElementById( 'billPerName' + lineno ).innerHTML = LastName + ' ' + FirstName + '�i<FONT SIZE="-1">' + LastKName + '�@' + FirstKName + '�j';	
	}

	// �N��̕ҏW
	if ( varPerBill_Age ) {
		varPerBill_Age.value = Age;
	}
	if ( document.getElementById( 'billAge' + lineno ) ) {
		document.getElementById( 'billAge' + lineno ).innerHTML = Age + '��';	
	}

	// ���ʂ̕ҏW
	if ( varPerBill_Gender ) {
		varPerBill_Gender.value = Gender;
	}
	if ( document.getElementById( 'billGender' + lineno ) ) {
		if (Gender == 1) {
			document.getElementById( 'billGender' + lineno ).innerHTML = '�j��';	
		} else if (Gender == 2) {
			document.getElementById( 'billGender' + lineno ).innerHTML = '����';
		}	
	}

	// �\��ԍ��̕ҏW
	if ( varPerBill_RsvNo ) {
		varPerBill_RsvNo.value = RsvNo;
	}
	if ( document.getElementById( 'billRsvNo' + lineno ) ) {
		document.getElementById( 'billRsvNo' + lineno ).innerHTML = RsvNo;
	}

	// �������m���̕ҏW
	if ( varPerBill_DmdDate ) {
		varPerBill_DmdDate.value = DmdDate;
	}
	if ( varPerBill_BillSeq ) {
		varPerBill_BillSeq.value = BillSeq;
	}
	if ( varPerBill_BranchNo ) {
		varPerBill_BranchNo.value = BranchNo;
	}
	if ( document.getElementById( 'billNo' + lineno ) ) {
		varRsltDate = DmdDate.split( "/" );
		varWorkSeq = '';
		for ( i = 0; i < 5 - BillSeq.length; i++ ){
			varWorkSeq += '0'
		}
		document.getElementById( 'billNo' + lineno ).innerHTML = varRsltDate[0] + varRsltDate[1] + varRsltDate[2] + varWorkSeq + BillSeq + BranchNo;	
	}

	// ������ʂ���߂邱�Ƃ����邽�߃f�[�^��hidden�ɓ��ꂽ���̂Œǉ� 2003.12.18
	document.entryForm.submit();
}

//�����m�F��ʕ\��
function callmergePerBill2(dispCnt) {

	var url;			// URL������
	var objForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g
	var opened = false;	// ��ʂ����łɊJ����Ă��邩

	//���ꐿ����No.���`�F�b�N
	for ( i = 0; i < dispCnt; i++ ){
		for ( j = 0; j < i; j++ ){
			if ( objForm.gdePerId[i].value == objForm.gdePerId[j].value 
			  && objForm.gdeDmdDate[i].value == objForm.gdeDmdDate[j].value
			  && objForm.gdeBillSeq[i].value == objForm.gdeBillSeq[j].value
			  && objForm.gdeBranchNo[i].value == objForm.gdeBranchNo[j].value ) {
				objForm.gdePerId[i].value = ''
				objForm.gdeDmdDate[i].value = ''
				objForm.gdeBillSeq[i].value = ''
				objForm.gdeBranchNo[i].value = ''
				break;
			}
		}
	}

	url = '/WebHains/contents/perbill/mergePerBill2.asp?perId=' + objForm.perid.value ;
	for ( i = 0; i < dispCnt; i++ ){
		url += (',' + objForm.gdePerId[i].value) ;
	}

	url += ('&dmdDate=' + objForm.dmddate.value );
	for ( i = 0; i < dispCnt; i++ ){
		url += (',' + objForm.gdeDmdDate[i].value) ;
	}

	url += ('&billSeq=' + objForm.billseq.value );
	for ( i = 0; i < dispCnt; i++ ){
		url += (',' + objForm.gdeBillSeq[i].value) ;
	}

	url += ('&branchNo=' + objForm.branchno.value );
	for ( i = 0; i < dispCnt; i++ ){
		url += (',' + objForm.gdeBranchNo[i].value) ;
	}

//	location.replace( url );
	// �߂�@�\�̂��߂�replace��href�ɕύX�@2003.12.18
	location.href(url);
}

//�������s�̕\�����Ȃ���
function changeRow() {

	document.entryForm.mode.value = 'change';
	document.entryForm.submit();
}

// �����Ґ������Z�b�g�v��
function friendsDmdSet() {
	document.entryForm.mode.value = 'friends';
	document.entryForm.submit();
}

function windowClose() {

	// �l�������̌����E�C���h�E�����
	if ( winGuidePerBill != null ) {
		if ( !winGuidePerBill.closed ) {
			winGuidePerBill.close();
		}
	}

	winGuidePerBill = null;
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:windowClose()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">��</SPAN>��������������</B></TD>
	</TR>
</TABLE>
	<!-- ������� -->
	<INPUT TYPE="hidden" NAME="act"    VALUE="save">
	<INPUT TYPE="hidden" NAME="mode" VALUE="<%= strMode %>">
	<INPUT TYPE="hidden" NAME="perid" VALUE="<%= vntPerId(0) %>">
	<INPUT TYPE="hidden" NAME="dmddate" VALUE="<%= strDmdDate %>">
	<INPUT TYPE="hidden" NAME="billseq" VALUE="<%= lngBillSeq %>">
	<INPUT TYPE="hidden" NAME="branchno" VALUE="<%= lngBranchNo %>">
	<INPUT TYPE="hidden" NAME="pricetotal"  VALUE="<%= lngPriceTotal %>"> 
	<INPUT TYPE="hidden" NAME="taxtotal"  VALUE="<%= lngTaxTotal %>"> 
	<INPUT TYPE="hidden" NAME="billcnt"  VALUE="<%= lngBillCnt %>"> 
<%	
	For i = 0 To lngDispCnt - 1
%>
		<INPUT TYPE="hidden" NAME="gdePerId"  VALUE="<%= arrPerId(i) %>"> 
		<INPUT TYPE="hidden" NAME="gdeLastName"  VALUE="<%= arrLastName(i) %>"> 
		<INPUT TYPE="hidden" NAME="gdeFirstName"  VALUE="<%= arrFirstName(i) %>"> 
		<INPUT TYPE="hidden" NAME="gdeLastKName"  VALUE="<%= arrLastKName(i) %>"> 
		<INPUT TYPE="hidden" NAME="gdeFirstKName"  VALUE="<%= arrFirstKName(i) %>"> 
		<INPUT TYPE="hidden" NAME="gdeAge"  VALUE="<%= arrAge(i) %>"> 
		<INPUT TYPE="hidden" NAME="gdeGender"  VALUE="<%= arrGender(i) %>"> 
		<INPUT TYPE="hidden" NAME="gdeRsvNo"  VALUE="<%= arrRsvNo(i) %>"> 
		<INPUT TYPE="hidden" NAME="gdeDmdDate"  VALUE="<%= arrDmdDate(i) %>"> 
		<INPUT TYPE="hidden" NAME="gdeBillSeq"  VALUE="<%= arrBillSeq(i) %>"> 
		<INPUT TYPE="hidden" NAME="gdeBranchNo"  VALUE="<%= arrBranchNo(i) %>"> 
<%
	Next
%>
<BR>
<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
	<TR>
		<TD NOWRAP>����������</TD>
		<TD NOWRAP>�F</TD>
		<TD NOWRAP><%= strDmdDate %></TD>
	</TR>
	<TR>
		<TD NOWRAP>������No</TD>
		<TD NOWRAP>�F</TD>
		<TD NOWRAP><%= objCommon.FormatString(strDmdDate, "yyyymmdd") %><%= objCommon.FormatString(lngBillSeq, "00000") %><%= lngBranchNo %></TD>
	</TR>
	<TR>
		<TD NOWRAP>�������z</TD>
		<TD NOWRAP>�F</TD>
		<TD NOWRAP><B><%= FormatCurrency(lngPriceTotal) %></B>�@�i���@�����<%= FormatCurrency(lngTaxTotal) %>�j</TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="3">
	<TR BGCOLOR="#eeeeee">
		<TD NOWRAP>��f��</TD>
		<TD NOWRAP>��f�R�[�X</TD>
		<TD NOWRAP>�\��ԍ�</TD>
		<TD NOWRAP>�l�h�c</TD>
		<TD NOWRAP>��f�Җ�</TD>
	</TR>
<%
	For i = 0 To lngCountCsl - 1
%>
	<TR height="15">
		<TD NOWRAP height="15"><%= vntCslDate(i) %></TD>
		<TD NOWRAP height="15"><%= vntCsName(i) %></TD>
		<TD NOWRAP height="15"><A HREF="/webHains/contents/reserve/rsvMain.asp?rsvNo=<%= vntRsvNo(i) %>" TARGET="_blank"><%= vntRsvNo(i) %></A></TD>
		<TD NOWRAP height="15"><%= vntPerId(i) %></TD>
		<TD NOWRAP height="15"><B><%= vntLastName(i) & " " & vntFirstName(i) %></B> (<FONT SIZE="-1"><%= vntLastKname(i) & "�@" & vntFirstKName(i) %></FONT>)</TD>
	</TR>
<%
	Next
%>
</TABLE>
<BR>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
	<TR>
		<TD NOWRAP><SPAN STYLE="color:#cc9999">��</SPAN>������������������I�����Ă��������B</TD>
		<TD NOWRAP>�@<A HREF="javascript:friendsDmdSet()">��L��f�҂̂��A��l���������Z�b�g</A></TD>
<!---
		<TD NOWRAP><A HREF="/webHains/contents/perBill/mergePerBill2.asp" ONCLICK="document.entryForm.submit();return false;" TARGET="_blank"><IMG SRC="/webHains/images/ok.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="���̏����Ŋm��"></A></TD>
-->
<!---
		<TD NOWRAP><A HREF="/webHains/contents/perBill/mergePerBill2.asp?perId=<%= vntPerId(0) %>,<%= Join(arrPerId,",") %>&dmdDate=<%= strDmdDate %>,<%= Join(arrDmdDate,",") %>&billSeq=<%= lngBillSeq %>,<%= Join(arrBillSeq,",") %>&branchNo=<%=lngBranchNo %>,<%= Join(arrBranchNo,",") %>" TARGET="_blank"><IMG SRC="/webHains/images/ok.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="���̏����Ŋm��"></A></TD>
-->
		<% if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then %>
			<TD NOWRAP><A HREF="Javascript:callmergePerBill2(<%= lngDispCnt %>)"><IMG SRC="/webHains/images/ok.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="���̏����Ŋm��"></A></TD>
		<% End If %>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
	<TR>
		<TD NOWRAP WIDTH="10"></TD>
		<TD NOWRAP WIDTH="10"></TD>
		<TD NOWRAP>�l�h�c</TD>
		<TD NOWRAP WIDTH="10"></TD>
		<TD NOWRAP>����</TD>
		<TD NOWRAP WIDTH="10"></TD>
		<TD NOWRAP NOWRAP>�N��</TD>
		<TD NOWRAP WIDTH="10"></TD>
		<TD NOWRAP>����</TD>
		<TD NOWRAP WIDTH="10"></TD>
		<TD NOWRAP>�\��ԍ�</TD>
		<TD NOWRAP WIDTH="10"></TD>
		<TD NOWRAP>������No.</TD>
	</TR>
	<TR>
		<TD NOWRAP WIDTH="10"></TD>
		<TD NOWRAP WIDTH="10"></TD>
		<TD NOWRAP COLSPAN="11" BGCOLOR="#999999"><IMG SRC="/webHains/images/spacer.gif" ALT="" HEIGHT="1" WIDTH="1" BORDER="0"></TD>
	</TR>
<%	
	For i = 0 To lngDispCnt - 1
%>
	<TR VALIGN="bottom">

		<TD WIDTH="10"><A HREF="javascript:callgdePerBill(<%= i %>,document.entryForm.dmddate.value,document.entryForm.billseq.value,document.entryForm.branchno.value,document.entryForm.gdePerId[<%= i %>],document.entryForm.gdeLastName[<%= i %>],document.entryForm.gdeFirstName[<%= i %>],document.entryForm.gdeLastKName[<%= i %>],document.entryForm.gdeFirstKName[<%= i %>],document.entryForm.gdeAge[<%= i %>],document.entryForm.gdeGender[<%= i %>],document.entryForm.gdeRsvNo[<%= i %>],document.entryForm.gdeDmdDate[<%= i %>],document.entryForm.gdeBillSeq[<%= i %>],document.entryForm.gdeBranchNo[<%= i %>])"><IMG SRC="/webHains/images/question.gif" ALT="�l������������\��" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>



			
		<TD NOWRAP WIDTH="10"><A HREF="javascript:clearPerBillInfo(<%= i %>,document.entryForm.gdePerId[<%= i %>],document.entryForm.gdeLastName[<%= i %>],document.entryForm.gdeFirstName[<%= i %>],document.entryForm.gdeLastKName[<%= i %>],document.entryForm.gdeFirstKName[<%= i %>],document.entryForm.gdeAge[<%= i %>],document.entryForm.gdeGender[<%= i %>],document.entryForm.gdeRsvNo[<%= i %>],document.entryForm.gdeDmdDate[<%= i %>],document.entryForm.gdeBillSeq[<%= i %>],document.entryForm.gdeBranchNo[<%= i %>])"><IMG SRC="/webHains/images/delicon.gif" ALT="" HEIGHT="21" WIDTH="21" BORDER="0"></TD>
		<TD NOWRAP><SPAN ID="billPerId<%= i %>"><%= arrPerId(i) %></SPAN></TD>
		<TD NOWRAP WIDTH="10"></TD>
<%
		If  arrPerId(i) <> "" Then
%>
			<TD NOWRAP><SPAN ID="billPerName<%= i %>"><%= arrLastName(i) & " " & arrFirstName(i) %></B>�i<FONT SIZE="-1"><%= arrLastKname(i) & "�@" & arrFirstKName(i) %>�j</SPAN></TD>
			<TD NOWRAP WIDTH="10"></TD>
<%
			If arrAge(i) <> "" Then
%>
				<TD NOWRAP ALIGN="right"><SPAN ID="billAge<%= i %>"><%= Int(arrAge(i)) %>��</SPAN></TD>
<%
			Else
%>
				<TD NOWRAP ALIGN="right"><SPAN ID="billAge<%= i %>"></SPAN></TD>
<%
			End If
%>
			<TD NOWRAP WIDTH="10"></TD>
<%
			arrGender(i) = IIf( arrGender(i) = "", 0,arrGender(i) )
			If arrGender(i) = 1 Or arrGender(i) = 2 Then
%>
				<TD NOWRAP><SPAN ID="billGender<%= i %>"><%= strArrGenderName(arrGender(i)-1) %></SPAN></TD>
<%
			Else
%>
				<TD NOWRAP><SPAN ID="billGender<%= i %>"></SPAN></TD>
<%
			End If
%>
<%
		Else
%>
			<TD NOWRAP><SPAN ID="billPerName<%= i %>"></SPAN></TD>
			<TD NOWRAP WIDTH="10"></TD>
			<TD NOWRAP ALIGN="right"><SPAN ID="billAge<%= i %>"></SPAN></TD>
			<TD NOWRAP WIDTH="10"></TD>
			<TD NOWRAP><SPAN ID="billGender<%= i %>"></SPAN></TD>
<%
		End If
%>
		<TD NOWRAP WIDTH="10"></TD>
		<TD NOWRAP><SPAN ID="billRsvNo<%= i %>"><%= arrRsvNo(i) %></SPAN></TD>
		<TD NOWRAP WIDTH="10"></TD>
		<TD NOWRAP ALIGN="right"><SPAN ID="billNo<%= i %>"><%= objCommon.FormatString(arrDmdDate(i), "yyyymmdd") %><%= objCommon.FormatString(arrBillSeq(i), "00000") %><%= arrBranchNo(i) %></SPAN></TD>
	</TR>
<%
	Next
%>
	<TR VALIGN="bottom">
</TABLE>
<BR>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
	<TR>
		<TD></TD>
		<TD NOWRAP>�w��\��������</TD>
		<TD>
			<SELECT NAME="dispCnt">
<%
				'�s���I�����X�g�̕ҏW
				i = DEFAULT_ROW
				Do
					'���݂̍s���ȏ�̍s����I���\�Ƃ���
					If i >= lngDispCnt Then
%>
						<OPTION VALUE="<%= i %>" <%= IIf(i = lngDispCnt, "SELECTED", "") %>><%= i %>��
<%
					End If

					'�ҏW�s�����\���s���𒴂����ꍇ�͏������I������
					If i > lngDispCnt Then
						Exit Do
					End If

					i = i + INCREASE_COUNT
				Loop
%>
			</SELECT>
		</TD>
		<TD><A HREF="JavaScript:changeRow()"><IMG SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="�\��" BORDER="0"></A></TD>
	</TR>
</TABLE>
</FORM>
</BODY>
</HTML>
