<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�l�������V�K�쐬 (Ver0.0.1)
'		AUTHER  : H.Kamata@FFCS
'
'		�V�K�쐬�� mode=insert�ŗv���A������������Ƃ���mode=update�Ɛ�����No
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
Dim objCommon				'���ʃN���X
Dim objPerbill				'�l���A�N�Z�X�p

Dim strAction				'���샂�[�h(�ۑ�:"save"�A�ۑ�����:"saved"�A�ĕ\���F"dsp")
Dim strMode					'�������[�h(�V�K�F"insert"�A�X�V�F"update")
Dim strArrMessage			'�G���[���b�Z�[�W
Dim i						'�C���f�b�N�X
Dim Ret						'�֐��߂�l

Dim strDmdDate				'������
Dim lngBillSeq				'�������r����
Dim lngBranchNo				'�������}��

Dim strReqDate				'�������i�V�K�܂��͕ύX��j

Dim strYear					'����������(�N)
Dim strMonth				'����������(��)
Dim strDay					'����������(��)

Dim lngPerCount				'��f�Ґ��i�\���p�j
Dim lngBillCount			'���������i�\���p�j

Dim strArrName				'��f�Җ�
Dim strArrKName				'��f�Җ��i�J�i�j

'�l�������Ǘ��l���(Person)
Dim lngPerRet				'���A�l�i��f�Ґ��j
Dim vntPerId				'�l�h�c
Dim vntLastName				'��
Dim vntFirstName			'��
Dim vntLastKName			'�J�i��
Dim vntFirstKName			'�J�i��

'�l�������׏��̎擾(perBill_c)
Dim lngBillRet				'���A�l�i���������j
Dim lngBillLineNo			'���������׍sNo
Dim vntPrice				'���z
Dim vntEditPrice			'�������z
Dim vntTaxPrice				'�Ŋz
Dim vntEditTax				'�����Ŋz
Dim vntLineName				'���ז���
Dim vntOtherLineDivCd		'�Z�b�g�O���׃R�[�h
Dim vntOtherLineName		'�Z�b�g�O���ז�

'�l�����Ǘ����(BillNo)
Dim vntDelFlg				'������`�[�t���O
Dim strBillComment			'�������R�����g
Dim strPaymentDate			'������
Dim lngPaymentSeq			'�����r����
Dim vntLineTotal			'���v

'�������
Dim lngPriceTotal_Pay		'�������z���v
Dim lngCredit				'�����a�����
Dim lngHappy_ticket			'�n�b�s�[������
Dim lngCard					'�J�[�h
Dim strCardKind				'�J�[�h���
Dim strCardNAME				'�J�[�h����
Dim lngCreditslipno			'�`�[�m��
Dim lngJdebit				'�i�f�r�b�g
Dim strBankCode				'���Z�@�փR�[�h
Dim strBankName				'���Z�@�֖�
Dim lngCheque				'���؎�
Dim lngRegisterno			'���W�ԍ�
Dim strIcomedate			'�X�V���t
Dim strUserId				'���[�U�h�c
Dim strUserName				'���[�U��������

Dim lngPaymentFlg			'�����σt���O�i������:"1"�A����:"0"�j
Dim lngPriceTotal			'���z���v
Dim lngEditPriceTotal		'�������z���v
Dim lngTaxPriceTotal		'�Ŋz���v
Dim lngEditTaxTotal			'�����Ŋz���v
Dim lngTotal				'���������v

strArrMessage = ""

Dim strHTML

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objPerbill = Server.CreateObject("HainsPerBill.PerBill")

'�����l�̎擾
strAction            = Request("act")
strMode              = Request("mode")

strDmdDate           = Request("dmddate")
lngBillSeq           = Request("billseq")
lngBranchNo          = Request("branchno")

strYear              = Request("year")
strMonth             = Request("month")
strDay               = Request("day")

strBillComment       = Request("comment")

lngPerCount          = Request("percount")
vntPerId			 = ConvIStringToArray(Request("perid"))
'vntLastName			 = ConvIStringToArray(Request("lastName"))
'vntFirstName		 = ConvIStringToArray(Request("firstName"))
'vntLastKName		 = ConvIStringToArray(Request("lastKName"))
'vntFirstKName		 = ConvIStringToArray(Request("firstKName"))
strArrName			 = ConvIStringToArray(Request("pername"))
strArrKName			 = ConvIStringToArray(Request("perKname"))

lngBillCount         = Request("billcount")
vntPrice             = ConvIStringToArray(Request("price"))
vntEditPrice         = ConvIStringToArray(Request("editprice"))
vntTaxPrice          = ConvIStringToArray(Request("taxprice"))
vntEditTax           = ConvIStringToArray(Request("edittax"))
vntLineName          = ConvIStringToArray(Request("linename"))
vntOtherLineDivCd    = ConvIStringToArray(Request("divcd"))
vntOtherLineName     = ConvIStringToArray(Request("divname"))

'�f�t�H���g�l��ݒ�
strYear        = IIf(strYear  = "", Year(Now()),  strYear )
strMonth       = IIf(strMonth = "", Month(Now()), strMonth)
strDay         = IIf(strDay   = "", Day(Now()),   strDay  )

lngPerCount    = IIf(lngPerCount = "", 5, lngPerCount )
lngBillCount   = IIf(lngBillCount = "", 5, lngBillCount )

strMode   = IIf(strMode = "", "insert", strMode )

Do

	'�폜�{�^��������
	If strAction = "delete" Then

		'�������̎�����
		Ret = objPerbill.DeletePerBill(strDmdDate, _
										lngBillSeq, _
										lngBranchNo, _
										Session("USERID"))

		'�ۑ��Ɏ��s�����ꍇ
		If Ret <> True Then
			srtMessage = "�������̎�����Ɏ��s���܂���"
'			Err.Raise 1000, , "�̎�����Ɏ��s���܂����B�i������No�@= " & objCommon.FormatString(strDmdDate, "yyyymmdd") & objCommon.FormatString(lngBillSeq, "00000") & lngBranchNo &" )"
		Else
			strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
			strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
			strHTML = strHTML & "</BODY>"
			strHTML = strHTML & "</HTML>"
			Response.Write strHTML
			Response.End
			Exit Do

'KMT �e��ʕs��
'			Response.Redirect "perPaymentInfo.asp?rsvno="&lngRsvNo
'			Response.end

		End If
	End If

	'�ۑ��{�^��������
	If strAction = "save" Then

       	'�������̕ҏW
		strReqDate = CDate(strYear & "/" & strMonth & "/" & strDay)

		'���̓`�F�b�N
		strArrMessage = CheckValue()
		If Not IsEmpty(strArrMessage) Then
			Exit Do
		End If


		'�������V�K�쐬�E�C������
		Ret = objPerbill.createPerBill_PERSON(strMode, _
									strReqDate, _
									vntPerId, _
									vntPrice, _
									vntEditPrice, _
									vntTaxPrice, _
									vntEditTax, _
									vntLineName, _
									vntOtherLineDivCd, _
									strBillComment, _
									Session("USERID"), _
									lngBillSeq, _
									lngBranchNo _
							)


		'�ۑ��Ɏ��s�����ꍇ
		If Ret = False Then
			Err.Raise 1000, , "�ۑ��Ɏ��s���܂����B"
		End If

		'�ۑ��I�����͍X�V���[�h�Ń��_�C���N�g
		Response.Redirect Request.ServerVariables("SCRIPT_NAME") & "?mode=update&act=saveend&percount=" & lngPerCount & "&billcount=" & lngBillCount & "&dmddate=" & strReqDate & "&billseq=" & lngBillSeq & "&branchno=" & lngBranchNo
		Response.End

	End If

	Exit Do
Loop

Do

	'�z��̐錾���s���B
	If strAction = "" Or strAction = "saveend" Then

		'�z��̐錾
		vntPerId          = Array()
		strArrName		  = Array()
		strArrKName		  = Array()

		vntPrice          = Array()
		vntEditPrice      = Array()
		vntTaxPrice       = Array()
		vntEditTax        = Array()
		vntLineTotal      = Array()
		vntLineName       = Array()
		vntOtherLineDivCd = Array()
		vntOtherLineName  = Array()

		ReDim Preserve vntPerId(lngPerCount)
		ReDim Preserve strArrName(lngPerCount)
		ReDim Preserve strArrKName(lngPerCount)

		ReDim Preserve vntPrice(lngBillCount)
		ReDim Preserve vntEditPrice(lngBillCount)
		ReDim Preserve vntTaxPrice(lngBillCount)
		ReDim Preserve vntEditTax(lngBillCount)
		ReDim Preserve vntLineTotal(lngBillCount)
		ReDim Preserve vntLineName(lngBillCount)
		ReDim Preserve vntOtherLineDivCd(lngBillCount)
		ReDim Preserve vntOtherLineName(lngBillCount)

	Else

		vntLineTotal      = Array()

		ReDim Preserve vntPerId(lngPerCount)
		ReDim Preserve strArrName(lngPerCount)
		ReDim Preserve strArrKName(lngPerCount)

		ReDim Preserve vntPrice(lngBillCount)
		ReDim Preserve vntEditPrice(lngBillCount)
		ReDim Preserve vntTaxPrice(lngBillCount)
		ReDim Preserve vntEditTax(lngBillCount)
		ReDim Preserve vntLineTotal(lngBillCount)
		ReDim Preserve vntLineName(lngBillCount)
		ReDim Preserve vntOtherLineDivCd(lngBillCount)
		ReDim Preserve vntOtherLineName(lngBillCount)

	End If


	'�V�K���[�h�A�X�V���[�h�i�����\���A�ۑ��I����j�ȊO�Ǎ��݂��s��Ȃ�
	If strMode = "insert" OR ( strMode = "update" AND strAction <> "" AND strAction <> "saveend" )   Then
		Exit Do
	End If

	strDmdDate = CDate(strDmdDate)
	strYear  = CStr(Year(strDmdDate))
	strMonth = CStr(Month(strDmdDate))
	strDay   = CStr(Day(strDmdDate))

	'�������m������lID���擾�����ꂼ��̌l�����擾����
	lngPerRet = objPerbill.SelectPerBill_Person( _
											strDmdDate, _
											lngBillSeq, _
											lngBranchNo, _
											vntPerId, _
											vntLastName, _
											vntFirstName, _
											vntLastKName, _
											vntFirstKName )

	'�l��񂪑��݂��Ȃ��ꍇ
	If lngPerRet < 1 Then
		Err.Raise 1000, , "�l��񂪎擾�ł��܂���B�i������No�@= " & objCommon.FormatString(strDmdDate, "yyyymmdd") & objCommon.FormatString(lngBillSeq, "00000") & lngBranchNo &" )"
	End If

	For i=0 To lngPerRet - 1
		If i <= UBound(vntLastName) Then
			'�l���ҏW
			strArrName(i)  = Trim(vntLastName(i) & "�@" &  vntFirstName(i))
			strArrKName(i) = Trim(vntLastKName(i) & "�@" &  vntFirstKName(i))
		End If
	Next

	If lngPerCount <= lngPerRet Then
		lngPerCount = (lngPerRet / 5)*5 + 5
	End If

	'�z��͕\���T�C�Y�ɕύX
	ReDim Preserve vntPerId(lngPerCount)
	ReDim Preserve strArrName(lngPerCount)
	ReDim Preserve strArrKName(lngPerCount)

	'�l�������׏��̎擾
	lngBillRet = objPerbill.SelectPerBill_Person_c(strDmdDate, _
													lngBillSeq, _
													lngBranchNo, _
													lngBillLineNo, _
													vntPrice, _
													vntEditPrice, _
													vntTaxPrice, _
													vntEditTax, _
													vntLineName, _
													vntOtherLineDivCd, _
													vntOtherLineName )

'	lngBillRet = objPerbill.SelectPerBill_c(strDmdDate, _
'											lngBillSeq, _
'											lngBranchNo, _
'											lngBillLineNo, _
'											vntPrice, _
'											vntEditPrice, _
'											vntTaxPrice, _
'											vntEditTax, _
'											, , , , , _
'											vntLineName, _
'											vntOtherLineDivCd, _
'											vntOtherLineName )

	'�l�������׏�񂪑��݂��Ȃ��ꍇ
	If lngBillRet < 1 Then
		Err.Raise 1000, , "�l�������׏�񂪎擾�ł��܂���B�i������No�@= " & objCommon.FormatString(strDmdDate, "yyyymmdd") & objCommon.FormatString(lngBillSeq, "00000") & lngBranchNo &" )"
	End If

	If lngBillCount <= lngBillRet Then
		lngBillCount = (lngBillRet / 5)*5 + 5
	End If

	'�z��͕\���T�C�Y�ɕύX
	ReDim Preserve vntPrice(lngBillCount)
	ReDim Preserve vntEditPrice(lngBillCount)
	ReDim Preserve vntTaxPrice(lngBillCount)
	ReDim Preserve vntEditTax(lngBillCount)
	ReDim Preserve vntLineTotal(lngBillCount)
	ReDim Preserve vntLineName(lngBillCount)
	ReDim Preserve vntOtherLineDivCd(lngBillCount)
	ReDim Preserve vntOtherLineName(lngBillCount)

	'�l�����Ǘ����̎擾
	Ret = objPerbill.SelectPerBill_BillNo(strDmdDate, _
											lngBillSeq, _
											lngBranchNo, _
											vntDelFlg, _
											, , , _
											strBillComment, _
											strPaymentDate, _
											lngPaymentSeq )

	'�l�����Ǘ���񂪑��݂��Ȃ��ꍇ
	If Ret <> True Then
		Err.Raise 1000, , "�l�����Ǘ���񂪎擾�ł��܂���B�i������No�@= " & objCommon.FormatString(strDmdDate, "yyyymmdd") & objCommon.FormatString(lngBillSeq, "00000") & lngBranchNo &" )"
	End If

	'�����σt���O������
	lngPaymentFlg = 0

	'������񂠂�H
	If IsNull(strPaymentDate) = False Then
		'�����σZ�b�g
		lngPaymentFlg = 1

		'�������̎擾
		Ret = objPerbill.SelectPerPayment(strPaymentDate, _
											lngPaymentSeq, _
											lngPriceTotal_Pay, _
											lngCredit, _
											lngHappy_ticket, _
											lngCard, _
											strCardKind, _
											strCardNAME, _
											lngCreditslipno, _
											lngJdebit, _
											strBankCode, _
											strBankName, _
											lngCheque, _
											lngRegisterno, _
											strIcomedate, _
											strUserId, _
											strUserName )
		'��f��񂪑��݂��Ȃ��ꍇ
		If Ret <> True Then
			Err.Raise 1000, , "������񂪎擾�ł��܂���B�i����No�@= " & vntPaymentDate(i) & vntPaymentSeq(i) &" )"
		End If
		objCommon.AppendArray strArrMessage, "�����ς̂��ߏC���ł��܂���B"
	End If


	Exit Do
Loop

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �w��l���̃h���b�v�_�E�����X�g�ҏW
'
' �����@�@ : 
'
' �߂�l�@ : HTML������
'
' ���l�@�@ : 
'
'-------------------------------------------------------------------------------
Function PerCountList( )

	Dim i

'	Redim Preserve strArrSelectNo(9)	'�l��
'	Redim Preserve strArrSelectName(9) 	'����

	'�Œ�l�̕ҏW
'	For i=0 To 9
'		strArrSelectNo(i)  = Cstr((i+1)*5)
'		strArrSelectName(i) = (i+1)*5 & "�l"
'	Next

	Redim Preserve strArrSelectNo(1)	'�l��
	Redim Preserve strArrSelectName(1) 	'����

	'�Œ�l�̕ҏW
	For i=0 To 1
		strArrSelectNo(i)  = lngPerCount + i*5
		strArrSelectName(i) = (lngPerCount+i*5) & "�l"
	Next


	PerCountList = EditDropDownListFromArray("percount", strArrSelectNo, strArrSelectName, lngPerCount, NON_SELECTED_DEL)

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �w�薾�א��̃h���b�v�_�E�����X�g�ҏW
'
' �����@�@ : 
'
' �߂�l�@ : HTML������
'
' ���l�@�@ : 
'
'-------------------------------------------------------------------------------
Function BillCountList( )

	Dim i

'	Redim Preserve strArrSelectNo(9)	'�l��
'	Redim Preserve strArrSelectName(9) 	'����

	'�Œ�l�̕ҏW
'	For i=0 To 9
'		strArrSelectNo(i)  = Cstr((i+1)*5)
'		strArrSelectName(i) = (i+1)*5 & "����"
'	Next

	Redim Preserve strArrSelectNo(1)	'�l��
	Redim Preserve strArrSelectName(1) 	'����

	'�Œ�l�̕ҏW
	For i=0 To 1
		strArrSelectNo(i)  = lngBillCount + i*5
		strArrSelectName(i) = (lngBillCount+i*5) & "����"

	Next

	BillCountList = EditDropDownListFromArray("billcount", strArrSelectNo, strArrSelectName, lngBillCount, NON_SELECTED_DEL)

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �������R�����g�̑Ó����`�F�b�N���s��
'
' �����@�@ :
'
' �߂�l�@ : �G���[�l������ꍇ�A�G���[���b�Z�[�W�̔z���Ԃ�
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CheckValue()

	Dim i
	Dim objCommon		'���ʃN���X
	Dim vntArrMessage	'�G���[���b�Z�[�W�̏W��

	'���ʃN���X�̃C���X�^���X�쐬
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'�e�l�`�F�b�N����
	With objCommon

		'���t�̃`�F�b�N�͕K�v���H

		'�������R�����g�`�F�b�N
		.AppendArray vntArrMessage, .CheckWideValue("�������R�����g", strBillComment, 200)

		'��f�ғ��̓`�F�b�N
		For i = 0 To lngPerCount -1
			If vntPerId(i) <> "" Then
				Exit For
			End If
		Next
		If Clng(i) >= Clng(lngPerCount) Then 
			.AppendArray vntArrMessage, "��f�҂��w�肵�ĉ������B"
		End If

		'�������ד��̓`�F�b�N
		For i = 0 To lngBillCount -1
			If vntOtherLineDivCd(i) <> "" Then
				Exit For
			End If
		Next
		If Clng(i) >= Clng(lngBillCount) Then 
			.AppendArray vntArrMessage, "�������ׂ��w�肵�ĉ������B"
		End If

	End With

	'�߂�l�̕ҏW
	If IsArray(vntArrMessage) Then
		CheckValue = vntArrMessage
	End If

End Function


%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�l�������V�K���</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<!-- #include virtual = "/webHains/includes/perGuide.inc" -->
<!-- #include virtual = "/webHains/includes/price.inc" -->
<!-- #include virtual = "/webHains/includes/Date.inc" -->

<SCRIPT TYPE="text/javascript">
<!--
var winOther;			// �Z�b�g�O�����ǉ��E�B���h�E�n���h��
var winIncome;			// �������E�B���h�E�n���h��
var Other_divCd;		// �Z�b�g�O���������׃R�[�h
var Other_lineName;		// ���������ז�
var Other_divName;		// �Z�b�g�O���������ז�
var Other_Price;		// �W���P��
var Other_EditPrice;	// �����P��
var Other_TaxPrice;		// �W���Ŋz
var Other_EditTax;		// �����Ŋz
var lngSelectedIndex;	// �l�����K�C�h�\�����ɑI�����ꂽ�l���̃C���f�b�N�X


//�Z�b�g�O�����ǉ��E�B���h�E�\��
function otherIncomeWindow(divCd, lineName, divName, price, editPrice, taxPrice, editTax) {

	var objForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g

	var url;			// URL������
	var opened = false;	// ��ʂ����łɊJ����Ă��邩

	// �K�C�h�Ƃ̘A���p�ϐ��ɃG�������g��ݒ�
	Other_divCd     = divCd;
	Other_divName   = divName;
	Other_lineName  = lineName;
	Other_Price     = price;
	Other_EditPrice = editPrice;
	Other_TaxPrice  = taxPrice;
	Other_EditTax   = editTax;

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winOther != null ) {
		if ( !winOther.closed ) {
			opened = true;
		}
	}

//	url = '/WebHains/contents/perbill/otherIncomeInfo.asp?billcount=0&mode=person'
	url = '/WebHains/contents/perbill/otherIncomeInfo.asp';
	url = url + '?billcount=0&mode=person';
	url = url + '&divcd=' + divCd.value;
	url = url + '&divname=' + divName.value;
	if ( lineName.value == '' ) {
		url = url + '&linename=' + divName.value;
	} else {
		url = url + '&linename=' + lineName.value;
	}
	url = url + '&price=' + price.value;
	url = url + '&editprice=' + editPrice.value;
	url = url + '&taxprice=' + taxPrice.value;
	url = url + '&edittax=' + editTax.value;

	// �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winOther.focus();
		winOther.location.replace(url);
	} else {
		winOther = window.open( url, '', 'width=430,height=300,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}
}

// �ۑ�����
function saveData() {

	if ( !confirm( '���̐��������쐬���܂��B��낵���ł����H' ) ) {
		return;
	}

	// ���[�h���w�肵��submit
	document.entryForm.act.value = 'save';
	document.entryForm.submit();

}

// �\���s���̕ύX
function changeRow() {

	document.entryForm.act.value = 'dsp';
	document.entryForm.submit();

}

// �폜����
function deleteData() {

	// ���������쐬�H
	if ( document.entryForm.dmddate.value == "" ||
		 document.entryForm.billseq.value == "" ||
		 document.entryForm.branchno.value == ""  ) {
		alert( '�������͖��쐬�ׁ̈A�폜�ł��܂���');
		return;
	}

	if ( !confirm( '���̐��������폜���܂��B��낵���ł����H' ) ) {
		return;
	}

	// ���[�h���w�肵��submit
	document.entryForm.act.value = 'delete';
	document.entryForm.submit();

}

// �Z�b�g�O�������׏��ҏW�p�֐�
function setOtherDiv( divCd, lineName, divName, price, editPrice, taxPrice, editTax ) {

	// �Z�b�g�O�������׃R�[�h�̕ҏW
	if ( Other_divCd ) {
		Other_divCd.value = divCd;
	}

	// �������ז��̕ҏW
	if ( Other_lineName ) {
		Other_lineName.value = lineName;
	}

	// �Z�b�g�O�������ז��̕ҏW
	if ( Other_divName ) {
		Other_divName.value = divName;
	}

	// �W�����z�̕ҏW
	if ( Other_Price ) {
		Other_Price.value = price;
	}
	// �������z�̕ҏW
	if ( Other_EditPrice ) {
		Other_EditPrice.value = editPrice;
	}

	// �W���Ŋz�̕ҏW
	if ( Other_TaxPrice ) {
		Other_TaxPrice.value = taxPrice;
	}

	// �����Ŋz�̕ҏW
	if ( Other_EditTax ) {
		Other_EditTax.value = editTax;
	}

	// �ĕ\��
	changeRow();

}

// ���������̃N���A
function otherIncome_clear( divCd, lineName, divName, price, editPrice, taxPrice, editTax ) {

	// �Z�b�g�O�������׃R�[�h�̕ҏW
	if (divCd ) {
		divCd.value = '';
	}

	// �������ז��̕ҏW
	if ( lineName ) {
		lineName.value = '';
	}

	// �Z�b�g�O�������ז��̕ҏW
	if ( divName ) {
		divName.value = '';
	}

	// �W�����z�̕ҏW
	if ( price ) {
		price.value = '';
	}
	// �������z�̕ҏW
	if ( editPrice ) {
		editPrice.value = '';
	}

	// �W���Ŋz�̕ҏW
	if ( taxPrice ) {
		taxPrice.value = '';
	}

	// �����Ŋz�̕ҏW
	if ( editTax ) {
		editTax.value = '';
	}

	// �ĕ\��
	changeRow();

}

// �l�K�C�h�Ăяo��
function callPerGuide( index ) {

	// �I�����ꂽ�K�C�h�̃C���f�b�N�X��ێ�
	lngSelectedIndex = index;

	perGuide_showGuidePersonal(document.entryForm.perid[ index ], 'pername' + index, 'perKname' + index, setPerName )

}

// �l���N���A
function clearPerInfo( index ) {

	document.getElementById('perid' + index ).innerHTML = "";
	document.getElementById('pername' + index ).innerHTML = "";
	document.getElementById('perKname' + index ).innerHTML = "";

	document.entryForm.perid[ index ].value = "";
	document.entryForm.pername[ index ].value = "";
	document.entryForm.perKname[ index ].value = "";

	// �ĕ\��
	changeRow();

}

// hidden�^�O�̌l�h�c�ҏW
function setPerName() {

	document.getElementById('perid' + lngSelectedIndex ).innerHTML = document.entryForm.perid[ lngSelectedIndex ].value ;

	document.entryForm.pername[ lngSelectedIndex ].value = document.getElementById('pername' + lngSelectedIndex ).innerHTML;
	document.entryForm.perKname[ lngSelectedIndex ].value = document.getElementById('perKname' + lngSelectedIndex ).innerHTML;

	// �ĕ\��
	changeRow();

}

//�������E�B���h�E�\��
function perBillIncomeWindow(perId, dmdDate, billSeq, branchNo ) {

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
	url = url + '?perid=' + perId;
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

function windowClose() {

	// �Z�b�g�O�����ǉ��E�C���h�E�����
	if ( winOther != null ) {
		if ( !winOther.closed ) {
			winOther.close();
		}
	}

	winOther = null;

	// �������E�C���h�E�����
	if ( winIncome != null ) {
		if ( !winIncome.closed ) {
			winIncome.close();
		}
	}

	winIncome = null;
}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.prttab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONUNLOAD="javascript:windowClose()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<BLOCKQUOTE>
	<INPUT TYPE="hidden" NAME="mode" VALUE="<%= strMode %>">
	<INPUT TYPE="hidden" NAME="act" VALUE="<%= strAction %>">
	<INPUT TYPE="hidden" NAME="dmddate" VALUE="<%= strDmdDate %>">
	<INPUT TYPE="hidden" NAME="billseq" VALUE="<%= lngBillSeq %>">
	<INPUT TYPE="hidden" NAME="branchno" VALUE="<%= lngBranchNo %>">

<!-- �\�� -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR HEIGHT="16">
			<TD HEIGHT="16" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print"></SPAN><FONT COLOR="#000000">���l�������V�K�쐬</FONT></B></TD>
		</TR>
	</TABLE>
	<BR>
<%
	'���b�Z�[�W�̕ҏW
	If strAction <> "" AND strAction <> "dsp" Then


		Select Case strAction

			'�ۑ��������́u�ۑ������v�̒ʒm
			Case "saveend"
				Call EditMessage("�ۑ����������܂����B", MESSAGETYPE_NORMAL)

			'�폜�������́u�폜�����v�̒ʒm
			Case "deleteend"
				Call EditMessage("�폜���������܂����B", MESSAGETYPE_NORMAL)

			'�����Ȃ��΃G���[���b�Z�[�W��ҏW
			Case Else
				Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
		End Select
	Else
		'�C�����[�h�œ�����񂠂�H
		If strMode = "update" And IsNull(strPaymentDate) = False Then
			Call EditMessage(strArrMessage, MESSAGETYPE_NORMAL)
		End If

	End If
%>
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">

<%
		'�V�K�쐬���͐�����No�\���Ȃ�
		If strMode = "update" Then
%>
			<TR>
				<TD NOWRAP height="15">������No</TD>
				<TD height="15">�F</TD>
				<TD height="15">
					<%= objCommon.FormatString(strDmdDate, "yyyymmdd") %><%= objCommon.FormatString(lngBillSeq, "00000") %><%= lngBranchNo %></TD>
				<TD height="15"></TD>
			</TR>
<%
		End If
%>
		<TR>
			<TD NOWRAP>����������</TD>     
			<TD NOWRAP>�F</TD>
			<TD NOWRAP>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
					<TR>
<%
						'�C�����[�h�œ�����񂠂�H
						If strMode = "update" And IsNull(strPaymentDate) = False Then
%>
						<TD WIDTH="21" HEIGHT="21"></TD>
						<TD><%= strYear %></TD>
						<TD>&nbsp;�N&nbsp;</TD>
						<TD><%= strMonth %></TD>
						<TD>&nbsp;��&nbsp;</TD>
						<TD><%= strDay %></TD>
						<TD>&nbsp;��</TD>
<%
						Else
%>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('year', 'month', 'day')"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��" BORDER="0"></A></TD>
						<TD><%= EditSelectNumberList("year", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strYear)) %></TD>
						<TD>&nbsp;�N&nbsp;</TD>
						<TD><%= EditSelectNumberList("month", 1, 12, Clng("0" & strMonth)) %></TD>
						<TD>&nbsp;��&nbsp;</TD>
						<TD><%= EditSelectNumberList("day",   1, 31, Clng("0" & strDay  )) %></TD>
						<TD>&nbsp;��</TD>
<%
						End if
%>
						<TD></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD VALIGN="top" NOWRAP>�������R�����g</TD>
			<TD VALIGN="top" >�F</TD>
<%
			'�C�����[�h�œ�����񂠂�H
			If strMode = "update" And IsNull(strPaymentDate) = False Then
%>
				<TD NOWRAP><TEXTAREA NAME="comment" ROWS="4" COLS="50" STYLE="ime-mode:active;" DISABLED><%= strBillComment %></TEXTAREA></TD>
				<TD WIDTH="153"></TD>
<%
			Else
%>
				<TD NOWRAP><TEXTAREA NAME="comment" ROWS="4" COLS="50" STYLE="ime-mode:active;"><%= strBillComment %></TEXTAREA></TD>
				<TD VALIGN="bottom" WIDTH="153"><A HREF="javascript:saveData();"><IMG SRC="../../images/save.gif" WIDTH="77" HEIGHT="24" ALT="���͂����f�[�^��ۑ����܂�" BORDER="0"></A></TD>
<%
			End if
%>
		</TR>
	</TABLE>
	<BR>
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
		<TR BGCOLOR="#eeeeee">
			<TD NOWRAP></TD>
			<TD NOWRAP></TD>
			<TD WIDTH="5"></TD>
			<TD NOWRAP>�l�h�c</TD>
			<TD WIDTH="5"></TD>
			<TD>��f�Җ�</TD>
		</TR>
<%
		For i=0 To lngPerCount -1 
%>
			<TR>
				<INPUT TYPE="hidden" NAME="perid" VALUE="<%= vntPerId(i) %>">
				<INPUT TYPE="hidden" NAME="pername" VALUE="<%= strArrName(i) %>">
				<INPUT TYPE="hidden" NAME="perKname" VALUE="<%= strArrKName(i) %>">

<%
				'�C�����[�h�œ�����񂠂�H
				If strMode = "update" And IsNull(strPaymentDate) = False Then
%>
					<TD WIDTH="20"></TD>
					<TD WIDTH="20"></TD>
<%
				Else
%>
					<TD><A HREF="javascript:callPerGuide(<%= i %>);"><IMG SRC="../../images/question.gif" ALT="�l�����K�C�h��\��" HEIGHT="21" WIDTH="22" BORDER="0"></A></TD>
					<TD><A HREF="javascript:clearPerInfo(<%= i %>)"><IMG SRC="../../images/delicon.gif" ALT="�ݒ肵���l���N���A" HEIGHT="21" WIDTH="21" BORDER="0"></TD>
<%
				End If
%>
				<TD WIDTH="5"></TD>
				<TD NOWRAP><SPAN ID="perid<%= i %>"><%= vntPerId(i) %></SPAN></TD>
				<TD WIDTH="5"></TD>
				<TD NOWRAP><B><SPAN ID="pername<%= i %>"><%= strArrName(i) %></SPAN></B>
							<%= IIf( vntPerId(i) <> "", "(", "") %><FONT SIZE="-1">
							<SPAN ID="perKname<%= i %>"><%= strArrKName(i) %></SPAN></FONT>
							<%= IIf( vntPerId(i) <> "", ")", "") %><FONT SIZE="-1"></TD>
			</TR>
<%
		Next
%>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
<%
			'�C�����[�h�œ�����񂠂�H
			If strMode = "update" And IsNull(strPaymentDate) = False Then
			Else
%>
				<TD></TD>
				<TD NOWRAP>�w��\�l��</TD>
				<TD><%= PerCountList() %></TD>
				<TD><A HREF="JavaScript:changeRow()"><IMG SRC="../../images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="�\��" BORDER="0"></A></TD>
<%
			End If
%>
		</TR>
	</TABLE>
	<BR>
	<TABLE BORDER="0" CELLSPACING="3" CELLPADDING="0">
		<TR BGCOLOR="#eeeeee">
			<TD NOWRAP></TD>
			<TD NOWRAP></TD>
			<TD NOWRAP>�������ו���</TD>
			<TD NOWRAP ALIGN="RIGHT">�@���z</TD>
			<TD NOWRAP ALIGN="RIGHT">�������z</TD>
			<TD NOWRAP ALIGN="RIGHT">�@�Ŋz</TD>
			<TD NOWRAP ALIGN="RIGHT">�����Ŋz</TD>
			<TD ALIGN="right" NOWRAP WIDTH="69">���v���z</TD>
		</TR>
<%
		lngPriceTotal     = 0
		lngEditPriceTotal = 0
		lngTaxPriceTotal  = 0
		lngEditTaxTotal   = 0
		lngTotal          = 0

		For i=0 To lngBillCount -1 
			vntLineTotal(i) = 0
%>
			<TR>
				<INPUT TYPE="hidden" NAME="divcd" VALUE="<%= vntOtherLineDivCd(i) %>">
				<INPUT TYPE="hidden" NAME="linename" VALUE="<%= vntLineName(i) %>">
				<INPUT TYPE="hidden" NAME="divname" VALUE="<%= vntOtherLineName(i) %>">
				<INPUT TYPE="hidden" NAME="price" VALUE="<%= vntPrice(i) %>">
				<INPUT TYPE="hidden" NAME="editprice" VALUE="<%= vntEditPrice(i) %>">
				<INPUT TYPE="hidden" NAME="taxprice" VALUE="<%= vntTaxPrice(i) %>">
				<INPUT TYPE="hidden" NAME="edittax" VALUE="<%= vntEditTax(i) %>">

<%
				'�C�����[�h�œ�����񂠂�H
				If strMode = "update" And IsNull(strPaymentDate) = False Then
%>
					<TD WIDTH="20"></TD>
					<TD WIDTH="20"></TD>
<%
				Else
%>
					<TD NOWRAP><A HREF="JavaScript:otherIncomeWindow( document.entryForm.divcd[<%= i %>], document.entryForm.linename[<%= i %>], document.entryForm.divname[<%= i %>], document.entryForm.price[<%= i %>], document.entryForm.editprice[<%= i %>], document.entryForm.taxprice[<%= i %>], document.entryForm.edittax[<%= i %>] )"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="�Z�b�g�O�����ǉ�" BORDER="0"></A></TD>
					<TD NOWRAP><A HREF="JavaScript:otherIncome_clear(document.entryForm.divcd[<%= i %>], document.entryForm.linename[<%= i %>], document.entryForm.divname[<%= i %>], document.entryForm.price[<%= i %>], document.entryForm.editprice[<%= i %>], document.entryForm.taxprice[<%= i %>], document.entryForm.edittax[<%= i %>])"><IMG SRC="../../images/delicon.gif" ALT="�ݒ肵���l���N���A" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
<%
				End If
%>

				<TD NOWRAP><%=IIf( vntLineName(i) <> "", vntLineName(i), vntOtherLineName(i)) %></TD>
<%
				If vntOtherLineDivCd(i) <> "" Then
%>
					<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntPrice(i)) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntEditPrice(i)) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntTaxPrice(i)) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntEditTax(i)) %></TD>
<%
					vntLineTotal(i)   = Clng(vntPrice(i)) + Clng(vntEditPrice(i)) + _
										Clng(vntTaxPrice(i)) + Clng(vntEditTax(i))
%>
					<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntLineTotal(i)) %></TD>
<%
				Else
%>
					<TD NOWRAP ALIGN="RIGHT"></TD>
					<TD NOWRAP ALIGN="RIGHT"></TD>
					<TD NOWRAP ALIGN="RIGHT"></TD>
					<TD NOWRAP ALIGN="RIGHT"></TD>
					<TD NOWRAP ALIGN="RIGHT"></TD>
<%
				End If
%>
			</TR>
<%
				If vntOtherLineDivCd(i) <> "" Then
					lngPriceTotal     = lngPriceTotal     + vntPrice(i)
					lngEditPriceTotal = lngEditPriceTotal + vntEditPrice(i)
					lngTaxPriceTotal  = lngTaxPriceTotal  + vntTaxPrice(i)
					lngEditTaxTotal   = lngEditTaxTotal   + vntEditTax(i)
					lngTotal          = lngTotal          + vntLineTotal(i)
				End If
		Next
%>
		<TR height="1">
			<TD 70" colspan="9" nowrap align="right" bgcolor="#999999" height="1"></TD>
		</TR>
		<TR height="15">
			<TD NOWRAP></TD>
			<TD NOWRAP></TD>
			<TD COLSPAN="1"70" NOWRAP ALIGN="right" height="15">���v</TD>
			<TD NOWRAP ALIGN="right" height="15"><%= FormatCurrency(lngPriceTotal) %></TD>
			<TD NOWRAP ALIGN="right" height="15"><%= FormatCurrency(lngEditPriceTotal) %></TD>
			<TD NOWRAP ALIGN="right" height="15"><%= FormatCurrency(lngTaxPriceTotal) %></TD>
			<TD NOWRAP ALIGN="right" height="15"><%= FormatCurrency(lngEditTaxTotal) %></TD>
			<TD NOWRAP ALIGN="right" height="15"><B><%= FormatCurrency(lngTotal) %></B></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
<%
			'�C�����[�h�œ�����񂠂�H
			If strMode = "update" And IsNull(strPaymentDate) = False Then
			Else
%>
				<TD></TD>
				<TD NOWRAP>�w��\���ׂ�</TD>
				<TD><%= BillCountList() %></TD>
				<TD><A HREF="JavaScript:changeRow()"><IMG SRC="../../images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="�\��" BORDER="0"></A></TD>
<%
			END If
%>
		</TR>
	</TABLE>
	<BR>
	<BR>
	<TABLE WIDTH="541" BORDER="0" CELLSPACING="1" CELLPADDING="0">
		<TR>
<%
			If strDmdDate = "" Then
%>
				<TD NOWRAP WIDTH="100%"><FONT COLOR="#cc9999">��</FONT>&nbsp;�������</TD>
<%
			Else
%>
				<TD NOWRAP WIDTH="100%"><FONT COLOR="#cc9999">��</FONT>
<%				For i = 0 To lngPerCount
					If vntPerId(i) <> "" Then
						Exit For
					End If
				Next
%>
				<A HREF="JavaScript:perBillIncomeWindow(<%= vntPerId(i) %>, '<%= strDmdDate %>', <%= lngBillSeq %>, <%= lngBranchNo %>)">�������</A></TD>
<%
			End If
%>
			<TD NOWRAP WIDTH="100%"></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLSPACING="3" CELLPADDING="0">
		<TR BGCOLOR="#eeeeee">
			<TD ALIGN="left" NOWRAP>������</TD>
			<TD NOWRAP>����</TD>
			<TD NOWRAP>�N���W�b�g</TD>
			<TD NOWRAP>J�f�r�b�h</TD>
			<TD NOWRAP>�n�b�s�[����</TD>
			<TD NOWRAP>���؎�</TD>
			<TD NOWRAP>�I�y���[�^</TD>
		</TR>
<%
		If lngPaymentFlg = 0 Then
%>
			<TR>
				<TD NOWRAP><B>��������Ă��܂���B</B></TD>
			</TR>
<%
		Else
%>
			<TR>
				<TD NOWRAP ALIGN="left"><A HREF="JavaScript:perBillIncomeWindow(<%= vntPerId(i) %>, '<%= strDmdDate %>', <%= lngBillSeq %>, <%= lngBranchNo %>)"><%= strPaymentDate %></A></TD>
				<TD NOWRAP ALIGN="right"><B><%= IIf( lngCredit <> "", FormatCurrency(lngCredit), "") %></B></TD>
				<TD NOWRAP ALIGN="right"><B><%= IIf( lngCard <> "", FormatCurrency(lngCard), "") %></B></FONT></TD>
				<TD NOWRAP ALIGN="right"><B><%= IIf( lngJdebit <> "", FormatCurrency(lngJdebit), "") %></B></TD>
				<TD NOWRAP ALIGN="right"><B><%= IIf( lngHappy_ticket <> "", FormatCurrency(lngHappy_ticket), "") %></B></TD>
				<TD NOWRAP ALIGN="right"><B><%= IIf( lngCheque <> "", FormatCurrency(lngCheque), "") %></B></TD>
				<TD NOWRAP ALIGN="left"><%= strUserName %></TD>
			</TR>
<%
		End If
%>
	</TABLE>
	<BR>
	<TABLE WIDTH="109" BORDER="0" CELLSPACING="2" CELLPADDING="0">
<%
		'������`�[�͎�����{�^����\��
 		If vntDelFlg <> 1 Then
%>
		<TR>
			<TD NOWRAP><A HREF="JavaScript:deleteData();">���̐�������������</A></TD>
		</TR>
<%
		End If
%>
	</TABLE>
	<BR>

</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>

</BODY>
</HTML>
