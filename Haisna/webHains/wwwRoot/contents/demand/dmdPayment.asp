<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       �������� (Ver0.0.1)
'       AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>

<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/EditPaymentDivList.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>��������</TITLE>

<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�����l
Dim strAction				'�������(�m��{�^��������:"save")
Dim strMode					'�������[�h(�폜��:"delete")
Dim strBillNo				'�������ԍ�
Dim strSeq					'����SEQ(�󔒂̏ꍇ�V�K)

'�������
Dim lngCloseYear			'���ߓ�(�N)
Dim lngCloseMonth			'���ߓ�(��)
Dim lngCloseDay				'���ߓ�(��)
Dim strCloseDate			'���ߓ�
Dim lngBillSeq				'������Seq
Dim lngBranchNo				'�������}��
Dim lngDelFlg				'�폜�t���O

Dim strOrgName				'���S���c�̖�
Dim lngTotal				'�������z
Dim lngNotPayment			'�������z
Dim strDispTotal			'�\���p�������z
Dim strDispNotPayment		'�\���p�������z
Dim strDispPayment			'�\���p�����z

'�������
Dim lngSeq					'����SEQ
Dim strPaymentDate			'������
Dim lngPaymentYear			'�������i�N�j
Dim lngPaymentMonth			'�������i���j
Dim lngPaymentDay			'�������i���j
Dim strPaymentPrice			'�����z
Dim strPaymentDiv			'�������
Dim strUpdUser				'�X�V��
Dim strUserName				'�X�V�Җ�
Dim strPayNote				'�R�����g
Dim strDuePrice				'�����\��z

'### 2004.02.18 Add by H.Ishihara ���W�ԍ��ǉ�
Dim strRegisterNo			'���W�ԍ�
Dim strCash					'����

Dim strArrRegisterno()		'���W�ԍ��i�R���{�p�j
Dim strArrRegisternoName()	'���W�ԍ����́i�R���{�p�j

Dim strDispCharge			'����i��ʕ\���p�j
'### 2004.02.18 Add End

Dim objDemand				'�������A�N�Z�X�pCOM�I�u�W�F�N�g

'## 2004.06.01 ADD STR ORB)T.YAGUCHI �Q�������̍��v���z�ǉ��ǉ�
Dim strSumPrice			'���z���v
Dim strSumEditPrice		'�������z���v
Dim strSumTaxPrice		'�Ŋz���v
Dim strSumEditTax		'�����Ŋz���v
Dim strSumPriceTotal		'�����v
Dim lngSumRecord		'���R�[�h��
Dim strSumPrice2		'���z���v
Dim strSumEditPrice2		'�������z���v
Dim strSumTaxPrice2		'�Ŋz���v
Dim strSumEditTax2		'�����Ŋz���v
Dim strSumPriceTotal2		'�����v
Dim lngSumRecord2		'���R�[�h��
'## 2004.06.01 ADD END

Dim strArrMessage			'�G���[���b�Z�[�W
Dim strRet					'�֐��߂�l
Dim i						'�C���f�b�N�X
Dim flgNoInput				

'2004.01.28 �ǉ�
Dim objFree				'�ėp���A�N�Z�X�p
Dim strCardKind     	'�J�[�h���
Dim strCardName     	'�J�[�h��
Dim strCreditslipno 	'�`�[No
'Dim lngCreditslipno 	'�`�[No
Dim strBankCode     	'���Z�@�փR�[�h
Dim strBankName     	'���Z�@�֖���
Dim strArrCardKind		'�J�[�h���
Dim strArrCardName		'�J�[�h����
Dim strArrBankCode		'��s�R�[�h
Dim strArrBankName		'��s����
Dim objCommon

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
strAction = Request("act") & ""
strMode   = Request("mode") & ""
strBillNo = Request("billNo") & ""
strSeq    = Request("seq") & ""
lngPaymentYear  = CLng("0" & Request("paymentYear"))	'�������i�N�j
lngPaymentMonth = CLng("0" & Request("paymentMonth"))	'�������i���j
lngPaymentDay   = CLng("0" & Request("paymentDay"))		'�������i���j
strPaymentDiv   = Request("paymentDiv")					'�������
strPaymentPrice = Request("paymentPrice")
strPayNote      = Request("payNote")					'�R�����g
strUpdUser      = Session("userid")
strUserName     = Session("username")

'2004.01.28 �ǉ�
strCardKind     = Request("cardKind") & ""
strCreditslipno = Request("creditslipno") & ""
strBankCode     = Request("bankCode") & ""
strCardName = ""
strBankName = ""

'### 2004.02.18 Add by H.Ishihara ���W�ԍ��A�����ǉ�
strRegisterNo   = Request("registerNo")
strCash         = Request("paymentPrice")
'### 2004.02.18 Add End

'������
strCloseDate  = empty
strOrgName    = empty
strArrMessage = empty
lngDelFlg = CLng("0")
flgNoInput = 0

'### 2004.02.18 Add by H.Ishihara ���W�ԍ��ǉ�
'���W�ԍ��E���̂̔z��쐬
Call CreateRegisternoInfo()
'### 2004.02.18 Add End

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objDemand = Server.CreateObject("HainsDemand.Demand")
Set objFree   = Server.CreateObject("HainsFree.Free")
Set objCommon = Server.CreateObject("HainsCommon.Common")

Do

	' Request ���琿�����L�[
	If Len(strBillNo) <> 14 Then
		strArrMessage = Array("�������ԍ����s���ł�")
		Exit Do
	Else 
		If Not IsNumeric(strBillNo) Then
			strArrMessage = Array("�������ԍ����s���ł�")
			Exit Do
		End If	
	End If

	lngCloseYear  = CLng("0" & Mid(strBillNo, 1, 4))
	lngCloseMonth = CLng("0" & Mid(strBillNo, 5, 2))
	lngCloseDay   = CLng("0" & Mid(strBillNo, 7, 2))
	lngBillSeq    = CLng("0" & Mid(strBillNo, 9, 5))
	lngBranchNo   = CLng("0" & Mid(strBillNo, 14, 1))

	'�������擾(�O�������Ŏ擾���Ă���)
	If Not objDemand.SelectDmdPaymentBillSum(lngCloseYear, _
											lngCloseMonth, _
											lngCloseDay, _
											strCloseDate, _
											lngBillSeq, _
											lngBranchNo, _
											lngDelFlg, _
											strOrgName, _
											lngTotal, _
											lngNotPayment ) Then
		strArrMessage = Array("���������̎擾�Ɏ��s���܂����B")
		Exit Do
	End If

'## 2004.06.01 ADD STR ORB)T.YAGUCHI �Q�������̍��v���z�ǉ��ǉ�
	lngSumRecord = objDemand.SelectSumDetailItems(Mid(strBillNo, 1, 13) & "0",, _
							strSumPrice, _
							strSumEditPrice, _
							strSumTaxPrice, _
							strSumEditTax, _
							strSumPriceTotal)
	lngSumRecord2 = objDemand.SelectSumDetailItems(Mid(strBillNo, 1, 13) & "1",, _
							strSumPrice2, _
							strSumEditPrice2, _
							strSumTaxPrice2, _
							strSumEditTax2, _
							strSumPriceTotal2)
'	If lngSumRecord > 0 Then
'		lngTotal = lngTotal + strSumPriceTotal(0)
'	End If
'## 2004.06.01 ADD END

	'�������z����ʗp�ɐ��`
	strDispTotal = FormatCurrency(lngTotal)
	'�������z�i�������z �| �����z�j����ʗp�ɐ��`
	strDispNotPayment = FormatCurrency(lngNotPayment)

	'����Seq�i�V�K�̏ꍇ��0�j
	lngSeq = CLng("0" & strSeq)

	'�����z�͓��͂ł��Ȃ��̂ł�����ŗ^����
	'���łɓ������R�[�h������ꍇ�͂��̃��R�[�h�̒l�A
	'�����łȂ��ꍇ�́A�����z���v��ݒ�
	If Not objDemand.GetDmdPaymentPrice(strCloseDate, _
										  lngBillSeq, _
										  lngBranchNo, _
										  lngSeq, _
										  strPaymentPrice, _
										  strDuePrice) Then
		strArrMessage = Array("���������̎擾�Ɏ��s���܂����B")
		Exit Do
	End If

	If lngSeq = 0 Then
'## 2004.06.01 ADD STR ORB)T.YAGUCHI �Q�������̍��v���z�ǉ��ǉ�
		If lngSumRecord > 0 Then
			strDuePrice = strDuePrice + strSumPriceTotal(0)
		End if
		If lngSumRecord2 > 0 Then
			strDuePrice = strDuePrice + strSumPriceTotal2(0)
		End if
'## 2004.06.01 ADD END
		strPaymentPrice = strDuePrice
	End If

	' �m�艟��
	If strAction = "save" Then

		'����`�[�͎Q�Ƃ݂̂Ńf�[�^�C���ł��܂���
		If lngBranchNo = 0 And lngDelFlg = 1 Then
			strArrMessage = Array("����`�[�̓����ǉ��E�ύX�E�폜�͂ł��܂���B")
			Exit Do
		End If

		'mode���m��͖���
		If strMode = "" Then Exit Do

		'�폜����
		If strMode = "delete" Then

			If Not objDemand.DeletePayment(strCloseDate, _
											lngBillSeq, _
											lngBranchNo, _
											lngSeq) Then
				strArrMessage = Array("�������͍폜�ł��܂���ł���")
				Exit Do
			End If

		Else
			'���̓`�F�b�N
			strArrMessage = CheckPaymentDivValue()
			If IsEmpty(strArrMessage) Then
				strArrMessage = objDemand.CheckValuePayment(strCloseDate, _
															lngBillSeq, _
															lngBranchNo, _
															strSeq, _
															lngPaymentYear, _
															lngPaymentMonth, _
															lngPaymentDay, _
															strPaymentDate, _
															strPaymentPrice, _
															strPaymentDiv, _
															strPayNote)
			End If
			If Not IsEmpty(strArrMessage) Then Exit Do

			'���̓`�F�b�N����
			'�������X�V
			If strSeq <> "" Then
'### 2004.02.18 Mod by H.Ishihara ���W�ԍ��A�����ǉ�
'				strRet = objDemand.UpdatePayment(strCloseDate, _
'													lngBillSeq, _
'													lngBranchNo, _
'													lngSeq, _
'													strPaymentDate, _
'													strPaymentPrice, _
'													strPaymentDiv, _
'													strUpdUser, _
'													strPayNote, _
'													strCardKind, _
'													strCreditslipno, _
'													strBankCode)
				strRet = objDemand.UpdatePayment(strCloseDate, _
													lngBillSeq, _
													lngBranchNo, _
													lngSeq, _
													strPaymentDate, _
													strPaymentPrice, _
													strPaymentDiv, _
													strUpdUser, _
													strPayNote, _
													strCardKind, _
													strCreditslipno, _
													strBankCode, _
													strRegisterNo, _
													strCash)
'### 2004.02.18 Mod End
				If Not strRet Then
					strArrMessage = Array("�������͍X�V�ł��܂���ł���")
					Exit Do
				End If
			Else
				'�����������Ȃ�����seq�͏�ɂP�ƂȂ�悤dll���C������
'### 2004.02.18 Mod by H.Ishihara ���W�ԍ��A�����ǉ�
'				strRet = objDemand.InsertPayment(strCloseDate, _
'													lngBillSeq, _
'													lngBranchNo, _
'													strPaymentDate, _
'													strPaymentPrice, _
'													strPaymentDiv, _
'													strUpdUser, _
'													strPayNote, _
'													strCardKind, _
'													strCreditslipno, _
'													strBankCode)
				strRet = objDemand.InsertPayment(strCloseDate, _
													lngBillSeq, _
													lngBranchNo, _
													strPaymentDate, _
													strPaymentPrice, _
													strPaymentDiv, _
													strUpdUser, _
													strPayNote, _
													strCardKind, _
													strCreditslipno, _
													strBankCode, _
													strRegisterNo, _
													strCash)
'### 2004.02.18 Mod End

				'�L�[�d�����̓G���[���b�Z�[�W��ҏW����
				If strRet = INSERT_DUPLICATE Then
					strArrMessage = Array("������񂪂��łɑ��݂��܂��B")
					Exit Do
				End If
			End If
		End If
	
		'DB�X�V�����̏ꍇ�͑O��ʂɖ߂�
		If IsEmpty(strArrMessage) Then
			strAction = "saveend"
			Response.Write "<BODY ONLOAD=""goBackPage()"">"
			Exit Do
		End If

	End If

	'�C�����͓������擾
	If strSeq <> "" Then

'### 2004.02.18 Mod by H.Ishihara ���W�ԍ��A�����ǉ�
'		Call objDemand.SelectPayment(strCloseDate, _
'										lngBillSeq, _
'										lngBranchNo, _
'										lngSeq, _
'										strPaymentDate, _
'										strPaymentPrice, _
'										strPaymentDiv, _
'										strUpdUser, _
'										strUserName, _
'										strPayNote, _
'										strCardKind, _
'										strCreditslipno, _
'										strBankCode, _
'										strCardName, _
'										strBankName)
		Call objDemand.SelectPayment(strCloseDate, _
										lngBillSeq, _
										lngBranchNo, _
										lngSeq, _
										strPaymentDate, _
										strPaymentPrice, _
										strPaymentDiv, _
										strUpdUser, _
										strUserName, _
										strPayNote, _
										strCardKind, _
										strCreditslipno, _
										strBankCode, _
										strCardName, _
										strBankName, _
										strRegisterNo, _
										strCash)

		If Trim(strCash) = "" Then strCash = 0
'### 2004.02.18 Mod End

		lngPaymentYear = Year(strPaymentDate)
		lngPaymentMonth = Month(strPaymentDate)
		lngPaymentDay = Day(strPaymentDate)
		strDispPayment = FormatCurrency(strPaymentPrice)

	' �o�^��
	Else
		If strDuePrice = 0 Then
			'�����̕K�v���Ȃ��ꍇ�́A�\�����Ȃ�
			strPaymentPrice = 0
			strDispPayment = ""
			flgNoInput = 1
		Else 
			strDispPayment = FormatCurrency(strPaymentPrice)

			'2004.01.28 �ǉ�
			strPaymentDiv = "3"
		End If
	End If

	Exit Do
Loop

strDispCharge = ""
If strPaymentDiv = "1" Then
	If IsNumeric(strCash) Then
	strDispCharge = "�����" & FormatCurrency(strCash - strPaymentPrice) & "�ł��B"
	End If
End If

'���t�͖{���ɂ��Ă�����������
lngPaymentYear = IIf(lngPaymentYear = 0, Year(Now()), lngPaymentYear)
lngPaymentMonth = IIf(lngPaymentMonth = 0, Month(Now()), lngPaymentMonth)
lngPaymentDay = IIf(lngPaymentDay = 0, Day(Now()), lngPaymentDay)

'�I�u�W�F�N�g�̃C���X�^���X�폜
Set objDemand = Nothing
'Set objCommon = Nothing

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ��ʖ��̑I���󋵃`�F�b�N
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CheckPaymentDivValue()

	Dim vntArrMessage

	With objCommon

'### 2004.02.18 Add by H.Ishihara ���W�ԍ��A�����ǉ�

		'������ʂ��U���݂ł����̑��ł��Ȃ��ꍇ�́A���W�ԍ��K�{
		If (strPaymentDiv <> "3") And (strPaymentDiv <> "7") And (Trim(strRegisterNo) = "") Then
			.AppendArray vntArrMessage, "�u�U���݁v�A�u���̑��v�ȊO�̓�����ʂ��I�����ꂽ�ꍇ�A���W�ԍ��͕K�{�ł��B"
		End If

		'������ʂ������̏ꍇ
		If strPaymentDiv = "1" Then

			Do

				'���z���Z�b�g����Ă��Ȃ��Ȃ�A0�Z�b�g
				If Trim(strCash) = "" Then strCash = 0

				'���z�̒l�`�F�b�N
				.AppendArray vntArrMessage, .CheckNumericWithSign("�����z", _
														 strCash, _
														 8, _
														 CHECK_NECESSARY)

				If IsArray(vntArrMessage) Then Exit Do

				'�����z�ɒB���Ă��Ȃ��Ȃ�A�G���[
				If cDbl(strCash) < cDbl(strPaymentPrice) Then
					.AppendArray vntArrMessage, "�����z�������z�ɒB���Ă��܂���B"
				End If

				Exit Do
			Loop

		Else
			'������ʂ������łȂ��Ȃ�A�����t�B�[���h�̓N���A
			strCash = ""
		End If

		'�U���݂Ȃ�A���W�ԍ����N���A
		If strPaymentDiv = "3" Then
			strRegisterNo = ""
		End IF
'### 2004.02.18 Add End
		
		If strPaymentDiv = "5" Then
			If strCardKind = "" Then
				.AppendArray vntArrMessage, "�J�[�h��ʂ�I�����ĉ������B"
			End If
			.AppendArray vntArrMessage, .CheckNumeric("�`�[No.", _
													 strCreditslipno, _
													 5, _
													 CHECK_NECESSARY)
		End If

		If strPaymentDiv = "6" Then
			If strBankCode = "" Then
				.AppendArray vntArrMessage, "���Z�@�ւ�I�����ĉ������B"
			End If
		End If

	End With

	If IsArray(vntArrMessage) Then
		CheckPaymentDivValue = vntArrMessage
	End If

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ������ʂ̓ǂݍ���
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function getPaymentDivName()

'	Dim objCommon				'������ʏ��A�N�Z�X�pCOM�I�u�W�F�N�g
	Dim vntPaymentDiv			'�������
	Dim vntPaymentDivName		'������ʖ���
	Dim i

	getPaymentDivName = ""

	'������ʏ��̓ǂݍ���
	If objCommon.SelectPaymentDivList(vntPaymentDiv, vntPaymentDivName) > 0 Then
		If Not IsEmpty(vntPaymentDiv) Then
			For i = 0 to UBound(vntPaymentDiv)
				If CStr(vntPaymentDiv(i)) = CStr(strPaymentDiv) Then 
					getPaymentDivName = vntPaymentDivName(i)
					Exit For
				End If
			Next
		End If
	End If
	
	Set objCommon = Nothing

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���W�ԍ��E���̂̔z��쐬
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub CreateRegisternoInfo()

	Redim Preserve strArrRegisterno(3)
	Redim Preserve strArrRegisternoName(3)

	strArrRegisterno(0) = "":strArrRegisternoName(0) = ""
	strArrRegisterno(1) = "1":strArrRegisternoName(1) = "1"
	strArrRegisterno(2) = "2":strArrRegisternoName(2) = "2"
	strArrRegisterno(3) = "3":strArrRegisternoName(3) = "3"

End Sub
%>



<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!-- #include virtual = "/webHains/includes/Date.inc" -->
<!--

// �폜�m�F���b�Z�[�W
function delConfirm() {

	var ret;		// �߂�l

	ret = self.confirm('�w�肳�ꂽ���������폜���܂��B��낵���ł����B');

	// �폜OK
	if ( ret ) {
		document.dmdPayment.act.value = 'save';
		document.dmdPayment.mode.value = 'delete';
		document.dmdPayment.submit();
	}

	return false;
}

// ����ʏ���
function goNextPage() {

	var paymentDate;		// ������

	// ���������̓`�F�b�N
	if ( !isDate(document.dmdPayment.paymentYear.value, document.dmdPayment.paymentMonth.value, document.dmdPayment.paymentDay.value) ) {
		self.alert('�������̌`���Ɍ�肪����܂��B');
		return false;
	}

	// �������ҏW
	paymentDate = formatDate(document.dmdPayment.paymentYear.value, document.dmdPayment.paymentMonth.value, document.dmdPayment.paymentDay.value);

	// �����������ߓ����O�ƂȂ��Ă��Ȃ����`�F�b�N
	if ( paymentDate < document.dmdPayment.closeDate.value ) {
		self.alert('�������͒��ߓ��ȍ~�̓��t����͂��Ă��������B');
		return false;
	}

	// 2004.01.28 �ǉ�
	if ( document.dmdPayment.paymentDiv.value != '5' ) {
		document.dmdPayment.cardkind.value = '';
		document.dmdPayment.creditslipno.value = '';
	}
	if ( document.dmdPayment.paymentDiv.value != '6' ) {
		document.dmdPayment.bankcode.value = '';
	}

	// ����ʂ𑗐M
	document.dmdPayment.act.value = 'save';
<%' 2004/02/02 Shiramizu Modified Start%>
	document.dmdPayment.mode.value = 'update';
<%' 2004/02/02 Shiramizu Modified End%>
	document.dmdPayment.submit();

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

<%' 2004/02/18 Add Function by Ishihara@FSIT %>
// ���WNo���I�����ꂽ�Ƃ��̏���
function selectRegiNo( val ) {

	var curDate = new Date();
	var previsit = curDate.toGMTString();

	curDate.setTime( curDate.getTime() + 30*365*24*60*60*1000 ); // 30�N��

	var expire = curDate.toGMTString();

	document.cookie = 'billregino=' + val + ';expires=' + expire;

	document.dmdPayment.registernoval.value = val;

}

//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<style type="text/css">
	body { margin: 10px 10px 0 10px; }
</style>
</HEAD>
<BODY ONUNLOAD="JavaScript:calGuide_closeGuideCalendar()">
<FORM NAME="dmdPayment" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">��</SPAN><FONT COLOR="#000000">��������</FONT></B></TD>
	</TR>
</TABLE>
<!-- ������� -->
<INPUT TYPE="hidden" NAME="act"    VALUE="<%= strAction %>">
<INPUT TYPE="hidden" NAME="mode">
<INPUT TYPE="hidden" NAME="billNo" VALUE="<%= strBillNo %>">
<INPUT TYPE="hidden" NAME="closeDate"  VALUE="<%= strCloseDate %>">
<INPUT TYPE="hidden" NAME="billSeq" VALUE="<%= lngBillSeq %>">
<INPUT TYPE="hidden" NAME="branchNo" VALUE="<%= lngBranchNo %>">
<INPUT TYPE="hidden" NAME="seq"    VALUE="<%= strSeq %>">
<!-- ## 2004.02.18 Del by H.Ishihara �����z�͓��͉\�Ƃ���
<INPUT TYPE="hidden" NAME="paymentPrice" VALUE="<%= strPaymentPrice %>">
-->
<%
	If Not IsEmpty(strArrMessage) Then
		Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
	End If
%>
<BR>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
	<TR>
		<TD>���ߓ�</TD>
		<TD>�F</TD>
		<TD><%= strCloseDate %></TD>
	</TR>
	<TR>
		<TD>������</TD>
		<TD>�F</TD>
		<TD><%= strOrgName %></TD>
	</TR>
	<TR>
		<TD>�������z</TD>
		<TD>�F</TD>
		<TD NOWRAP><B><%= strDispTotal %></B></TD>
	</TR>
	<TR>
		<TD>�������z</TD>
		<TD>�F</TD>
<% If lngNotPayment = 0 Then %>
		<TD NOWRAP><B><%= strDispNotPayment %></B></TD>
<% Else %>
		<TD NOWRAP><FONT COLOR="RED"><B><%= strDispNotPayment %></B></FONT></TD>
<% End If %>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">

<!-- ����`�[�̓f�[�^�Q�Ƃ̂� -->
<% If (lngBranchNo = 0 and lngDelFlg = 1) Or flgNoInput = 1 Then %>
<INPUT TYPE="hidden" NAME="paymentYear" VALUE="<%= lngPaymentYear %>">
<INPUT TYPE="hidden" NAME="paymentMonth" VALUE="<%= lngPaymentMonth %>">
<INPUT TYPE="hidden" NAME="paymentDay" VALUE="<%= lngPaymentDay %>">
<INPUT TYPE="hidden" NAME="paymentDiv" VALUE="<%= strPaymentDiv %>">
<INPUT TYPE="hidden" NAME="payNote" VALUE="<%= strPayNote %>">
<%' ### 2004/02/18 Add Function by Ishihara@FSIT %>
	<TR>
		<TD>���W�ԍ�</TD>
		<TD>�F</TD>
		<TD><%= strRegisterNo %></TD>
	</TR>
<%' ### 2004/02/18 Add End %>
	<TR>
		<TD>������</TD>
		<TD>�F</TD>
		<TD><%= strPaymentDate %></TD>
	</TR>
	<TR>
		<TD>�����z</TD>
		<TD>�F</TD>
<%
'### 2004.02.18 Add by H.Ishihara ���W�ԍ��A�����ǉ�
If strPaymentDiv = "1" Then
%>
		<TD NOWRAP><%= FormatCurrency(strCash) %>�@<FONT COLOR="#999999"><%= strDispCharge %></FONT></TD>
<%
Else
%>
		<TD NOWRAP><%= strDispPayment %></TD>
<%
End If
%>

	</TR>
	<TR>
		<TD>�������</TD>
		<TD>�F</TD>
		<TD>
<% If strPaymentDiv = "5" Then %>
			<table border="0" cellspacing="0" cellpadding="1">
				<tr>
					<TD><%= getPaymentDivName %></TD>
					<TD>&nbsp;�i�J�[�h��ʁF&nbsp;<%= strCardName %></TD>
					<TD>&nbsp;&nbsp;�`�[No.�F&nbsp;<%= strCreditslipno %>�j</TD>
				<tr>
			</table>
<% ElseIf strPaymentDiv = "6" Then %>
			<table border="0" cellspacing="0" cellpadding="1">
				<tr>
					<TD><%= getPaymentDivName %></TD>
					<TD>&nbsp;�i���Z�@�ցF&nbsp;<%= strBankName %>�j</TD>
				<tr>
			</table>
<% Else %>
			<%= getPaymentDivName %>
<% End If %>
		</TD>
	</TR>
	<TR>
		<TD VALIGN="top">�R�����g</TD>
		<TD VALIGN="top">�F</TD>
		<TD><%= strPayNote %></TD>
	</TR>

<% Else %>

<%' ### 2004/02/18 Add Function by Ishihara@FSIT %>
	<TR>
		<TD>���W�ԍ�</TD>
		<TD>�F</TD>
		<TD>
			<SPAN ID="registerDrop"></SPAN>
			<INPUT TYPE="hidden" NAME="registernoval" VALUE="<%= strRegisterNo %>">
		</TD>
	</TR>
<%' ### 2004/02/18 Add End %>
	<TR>
		<TD>������</TD>
		<TD>�F</TD>
		<TD>
			<table border="0" cellspacing="0" cellpadding="1">
				<tr>
					<td><a href="javascript:calGuide_showGuideCalendar('paymentYear', 'paymentMonth', 'paymentDay')"><img src="/webHains/images/question.gif" alt="���t�K�C�h��\��" height="21" width="21" border="0"></a></td>
					<TD><%= EditNumberList("paymentYear", YEARRANGE_MIN, YEARRANGE_MAX, lngPaymentYear, False) %></TD>
					<TD>&nbsp;�N&nbsp;</TD>
					<TD><%= EditNumberList("paymentMonth", 1, 12, lngPaymentMonth, False) %></TD>
					<TD>&nbsp;��&nbsp;</TD>
					<TD><%= EditNumberList("paymentDay", 1, 31, lngPaymentDay, False) %></TD>
					<TD>&nbsp;��</TD>
					<td></td>
				</tr>
			</table>
		</TD>
	</TR>
	<TR>
		<TD>�����z</TD>
		<TD>�F</TD>
<%
'### 2004.02.18 Add by H.Ishihara ���W�ԍ��A�����ǉ�
If strPaymentDiv = "1" Then
%>
		<TD NOWRAP><INPUT TYPE="TEXT" NAME="paymentPrice" VALUE="<%= strCash %>" SIZE="10" MAXLENGTH="9">�@<FONT COLOR="#999999"><%= strDispCharge %></FONT></TD>
<%
Else
%>
		<TD NOWRAP><INPUT TYPE="TEXT" NAME="paymentPrice" VALUE="<%= strPaymentPrice %>" SIZE="10" MAXLENGTH="9"></TD>
<%
End If
%>

	</TR>
	<TR>
		<TD COLSPAN="2"></TD>
		<TD><FONT COLOR="#999999">���������=�����ȊO�̓����z�͖�������܂��B�i�������z�ƃC�R�[���ɂȂ�܂��j</FONT></TD>
	</TR>
	<TR>
		<TD HEIGHT="10"></TD>
	</TR>
	<TR>
		<TD VALIGN="top">�������</TD>
		<TD VALIGN="top">�F</TD>
		<TD >
			<table border="0" cellspacing="0" cellpadding="1">
				<tr>
				<TD><%= EditPaymentDivList("paymentDiv", strPaymentDiv) %></TD>
				<TD>&nbsp;�J�[�h���&nbsp;</TD>
<%
				'�J�[�h���̓ǂݍ���
				If objFree.SelectFree( 1, "CARD" , strArrCardKind, , , strArrCardName) > 0 Then
%>
				<TD>
				<%= EditDropDownListFromArray("cardkind", strArrCardKind, strArrCardName, strCardKind, NON_SELECTED_ADD) %>
				</TD>
<%
				End If
%>
				<TD>&nbsp;�`�[No.&nbsp;</TD>
				<TD><input type="text" name="creditslipno" value="<%= strCreditslipno %>" size="7" maxlength="5" ></TD>
				<tr>
				<tr>
				<TD></TD>
				<TD>&nbsp;���Z�@��&nbsp;</TD>
<%
				'��s���̓ǂݍ���
				If objFree.SelectFree( 1, "BANK" , strArrBankCode, , , strArrBankName) > 0 Then
%>
				<TD>
				<%= EditDropDownListFromArray("bankcode", strArrBankCode, strArrBankName, strBankCode, NON_SELECTED_ADD) %>
				</TD>
<%
				End If
%>
				</tr>
			</table>
		</TD>
	</TR>
	<TR>
		<TD VALIGN="top">�R�����g</TD>
		<TD VALIGN="top">�F</TD>
		<TD>
			<TEXTAREA NAME="payNote" SIZE="" ROWS="4" COLS="40"><%= strPayNote %></TEXTAREA>
		</TD>
	</TR>
<% End If %>

	<TR>
		<TD>�����S����</TD>
		<TD>�F</TD>
		<TD><%= strUserName %>
		</TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
	<TR>
<!-- ����`�[�͎Q�Ƃ̂� -->
<% If lngBranchNo = 1 or lngDelFlg = 0 Then %>

	<!-- �C���� -->
	<% If strSeq <> "" Then %>
			<TD>
				<A HREF="javascript:function voi(){};voi()" ONCLICK="return delConfirm()">
				<IMG SRC="/webHains/images/delete.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="���̓��������폜���܂�"></A>
			</TD>
			<TD WIDTH="190"></TD>
	<% Else %>
			<TD WIDTH="264"></TD>
	<% End If %>

		<TD WIDTH="5"></TD>
		<TD>
		<% '2005.08.22 �����Ǘ� Add by ���@--- START %>
        <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %> 
			<A HREF="javascript:function voi(){};voi()" ONCLICK="return goNextPage()">
			<IMG SRC="/webHains/images/ok.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="���̓��e�Ŋm��"></A>
		<%  else    %>
			 &nbsp;
		<%  end if  %>
		<% '2005.08.22 �����Ǘ� Add by ���@--- END %>
		</TD>

<% Else %>
		<TD WIDTH="264"></TD>

<% End If %>

		<TD WIDTH="5"></TD>
		<TD>
			<A HREF="JavaScript:close()"><IMG SRC="/webHains/images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="�L�����Z������"></A></TD>
		</TD>
	</TR>
</TABLE>
</FORM>
<% Set objCommon = Nothing %>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
<!-- ����`�[�̓f�[�^�Q�Ƃ̂� -->
<% If (lngBranchNo = 0 and lngDelFlg = 1) Or flgNoInput = 1 Then %>
<% Else %>
<SCRIPT TYPE="text/javascript">
<!--
	var i;

	// cookie�l�̎擾
	var searchStr = 'billregino=';
	var strCookie = document.cookie;

	if ( strCookie.length > 0 ){

		var startPos  = strCookie.indexOf(searchStr) + searchStr.length;
		var regino = strCookie.substring(startPos, startPos + 1);

		if (regino != '' ){
			document.dmdPayment.registernoval.value = regino;
			var html = '';
			html = html + '<TD>';
    		html = html + '<SELECT NAME="registerno" ONCHANGE="javascript:selectRegiNo( document.dmdPayment.registerno.value )">';

<%
	    	'�z��Y�������̃��X�g��ǉ�
			If Not IsEmpty(strArrRegisterno) Then
				For i = 0 To UBound(strArrRegisterno)
%>
					html = html + '<OPTION VALUE="<%= strArrRegisterno(i) %>"'

<%
					If strSeq <> "" Then
%>
					if ( '<%= strArrRegisterno(i) %>' == '<%= strRegisterNo %>' ){
						html = html + '  SELECTED';
					}
<%
					Else
%>
					if ( '<%= strArrRegisterno(i) %>' == regino ){
						html = html + '  SELECTED';
					}
<%
					End If
%>
					html = html + '> <%= strArrRegisternoName(i) %>';
<%
				Next
			End If
%>

  			html = html + '</SELECT>';
			html = html + '</TD>';
			document.getElementById('registerDrop').innerHTML = html;
		}
	}
//-->
</SCRIPT>
<% End If %>
</BODY>
</HTML>
