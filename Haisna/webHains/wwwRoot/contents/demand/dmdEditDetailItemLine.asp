<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�������ד���o�^�E�C���\�� (Ver0.0.1)
'		AUTHER  : T.Yaguchi@Orb
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
Dim objDemand				'�������A�N�Z�X�p

Dim Ret						'�֐��߂�l

Dim lngCount				'�擾����
Dim lngCount2				'�擾����
Dim lngCount3				'�擾����
Dim lngRecord				'���R�[�h�J�E���^
Dim i						'���[�v�J�E���^

'�p�����[�^
Dim strBillNo				'�������ԍ�
Dim strLineNo				'����No.
Dim strItemNo				'����No.
Dim strSecondLineDivCd			'�Q���������׃R�[�h
Dim strSecondLineDivName		'�Q���������ז�
Dim strRsvNo				'�\��ԍ�
Dim strDayId				'����ID
Dim strLastName				'��
Dim strFirstName			'��
Dim strLastKName			'�J�i��
Dim strFirstKName			'�J�i��
Dim strDetailName			'����
Dim lngPrice				'���z
Dim lngEditPrice			'�������z
Dim lngTaxPrice				'�Ŋz
Dim lngEditTax				'�����Ŋz
Dim strPerId				'�lID
Dim strPerName				'����
Dim strOrgCd1				'�c�̃R�[�h�P
Dim strOrgCd2				'�c�̃R�[�h�Q
Dim strGetCount				'�O��ʂP�y�[�W�\������
Dim strStartPos				'�O��ʎ擾�J�n�ʒu

Dim lngStrYear				'��f���i�N�j
Dim lngStrMonth				'��f���i���j
Dim lngStrDay				'��f���i���j
Dim strCslDate				'��M��

'���������׎擾
Dim vntArrBillNo			'�������ԍ�
Dim vntArrLineNo			'����No.
Dim vntArrCloseDate			'���ߓ�
Dim vntArrBillSeq			'������Seq
Dim vntArrBranchno			'�������}��
Dim vntArrDayId				'����ID
Dim vntArrRsvNo				'�\��ԍ�
Dim vntArrCslDate			'��f��
Dim vntArrDetailName		'����
Dim vntArrPerId				'�lID
Dim vntArrLastName			'��
Dim vntArrFirstName			'��
Dim vntArrLastKName			'�J�i��
Dim vntArrFirstKName		'�J�i��
Dim vntArrPrice				'���z
Dim vntArrEditPrice			'�������z
Dim vntArrTaxPrice			'�Ŋz
Dim vntArrEditTax			'�����Ŋz
Dim vntArrOrgCd1			'�c�̃R�[�h�P
Dim vntArrOrgCd2			'�c�̃R�[�h�Q
Dim vntArrOrgName			'�c�̖�
Dim vntArrOrgKName			'�c�̃J�i��
Dim vntArrMethod			'�쐬���@
Dim vntArrSecondLineDivCd		'�Q���������׃R�[�h
Dim vntArrSecondLineDivName		'�Q���������ז�
Dim vntArrItemNo			'����R�[�h
Dim vntArrPaymentCnt		'��������
Dim vntArrDispatchCnt		'��������

Dim vntArrYMD				'���ߓ��i/�ŕ�����j

Dim strDivCd				'�Z�b�g�O�������׃R�[�h
Dim strSetName				'�Ή��Z�b�g����
Dim strNoEditFlg			'�C���s�t���O

Dim strMode					'�������[�h
Dim strAction				'���샂�[�h(�ۑ�:"save"�A�ۑ�����:"saved"�A�폜�F"delete"�A�폜�����F"deleted")
Dim strHTML
Dim strArrMessage	'�G���[���b�Z�[�W

strArrMessage = ""
strNoEditFlg = 0
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�������דo�^�E�C��</TITLE>
<!-- #include virtual = "/webHains/includes/perGuide.inc"  -->
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->

<%
'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objDemand  = Server.CreateObject("HainsDemand.Demand")

'�����l�̎擾
strBillNo = Request("BillNo")
strLineNo = Request("LineNo")
strItemNo = Request("ItemNo")
strSecondLineDivCd = Request("secondLineDivCd")
strSecondLineDivName = Request("secondLineDivName")

lngStrYear     = CLng("0" & Request("strYear"))
lngStrMonth    = CLng("0" & Request("strMonth"))
lngStrDay      = CLng("0" & Request("strDay"))
'���ݒ莞�̓V�X�e�����t
If IsNull(strLineNo) Or strLineNo = "" Then
	lngStrYear    = IIf(lngStrYear  = 0, Year(Now),    lngStrYear )
	lngStrMonth   = IIf(lngStrMonth = 0, Month(Now),   lngStrMonth)
	lngStrDay     = IIf(lngStrDay   = 0, Day(Now),     lngStrDay  )
End If

'strCslDate = lngStrYear & "/" & lngStrMonth & "/" & lngStrDay
strCslDate = Request("cslDate")
strDayId = Request("DayId")
strRsvNo = Request("RsvNo")
strDetailName   = Request("DetailName")
strLastName = Request("LastName")
strFirstName = Request("FirstName")
strLastKName = Request("LastKName")
strFirstKName = Request("FirstKName")
lngPrice = Request("Price")
lngEditPrice = Request("EditPrice")
lngTaxPrice = Request("TaxPrice")
lngEditTax = Request("EditTax")
strPerId = Request("perId")
strOrgCd1 = Request("OrgCd1")
strOrgCd2 = Request("OrgCd2")

strGetCount = Request("getCount")
strStartPos = Request("startpos")

strAction      = Request("act")
strMode        = Request("mode")

'�����\���ݒ�
If strMode = "" Then strMode = "init"
Do
	'����������
	lngCount = objDemand.SelectDmdBurdenModifyBillDetail(strBillNo, _
														strLineNo, _
														"","", _
														vntArrBillNo, _
														vntArrLineNo, _
														vntArrCloseDate, _
														vntArrBillSeq, _
														vntArrBranchno, _
														vntArrDayId, _
														vntArrRsvNo, _
														vntArrCslDate, _
														vntArrDetailName, _
														vntArrPerId, _
														vntArrLastName, _
														vntArrFirstName, _
														vntArrLastKName, _
														vntArrFirstKName, _
														vntArrPrice, _
														vntArrEditPrice, _
														vntArrTaxPrice, _
														vntArrEditTax, _
														vntArrOrgCd1, _
														vntArrOrgCd2, _
														vntArrOrgName, _
														vntArrOrgKName,_
														vntArrMethod)

	'���������ד��󂪑��݂��Ȃ��ꍇ
	If lngCount < 1 Then
		strArrMessage = Array("�Y�����鐿���������݂��܂���")
		strAction = "Err"
		Exit Do
	End If

	'���������ד���
	lngCount3 = 0
	If strItemNo <> "" Then
		lngCount3 = objDemand.SelectDmdDetailItmList(strBillNo, _
														strLineNo, strItemNo, _
														"","", _
														vntArrBillNo, _
														vntArrLineNo, _
														vntArrCloseDate, _
														vntArrBillSeq, _
														vntArrBranchno, _
														vntArrDayId, _
														vntArrRsvNo, _
														vntArrCslDate, _
														vntArrDetailName, _
														vntArrPerId, _
														vntArrLastName, _
														vntArrFirstName, _
														vntArrLastKName, _
														vntArrFirstKName, _
														vntArrPrice, _
														vntArrEditPrice, _
														vntArrTaxPrice, _
														vntArrEditTax, _
														vntArrOrgCd1, _
														vntArrOrgCd2, _
														vntArrOrgName, _
														vntArrOrgKName,_
														vntArrMethod,,vntArrItemNo,vntArrSecondLineDivCd,vntArrSecondLineDivName)
	End If

	If strMode = "init" Then
		'�����\���ݒ�
		If lngStrYear = "0" Then
			vntArrYMD = split(vntArrCslDate(lngRecord),"/")
			For i=0 to UBound(vntArrYMD)
				Select Case i
				case 0
					lngStrYear = vntArrYMD(i)
				case 1
					lngStrMonth = vntArrYMD(i)
				case 2
					lngStrDay = vntArrYMD(i)
				End Select
			Next
		End If
		If strDetailName = "" Then strDetailName = vntArrDetailName(lngRecord)
		If lngCount3 > 0 Then
			If lngPrice = "" Then lngPrice = vntArrPrice(0)
			If lngTaxPrice = "" Then lngTaxPrice = vntArrTaxPrice(0)
			If lngEditPrice = "" Then lngEditPrice = vntArrEditPrice(0)
			If lngEditTax = "" Then lngEditTax = vntArrEditTax(0)
			If strSecondLineDivCd = "" Then strSecondLineDivCd = vntArrSecondLineDivCd(0)
			If strSecondLineDivName = "" Then strSecondLineDivName = vntArrSecondLineDivName(0)
		End If
		If strPerName = "" Then strPerName = vntArrLastName(lngRecord) & " " & vntArrFirstName(lngRecord)
		If strPerId = "" Then strPerId = vntArrPerId(lngRecord)
		If strDayId = "" Then strDayId = vntArrDayId(lngRecord)
		If strRsvNo = "" Then strRsvNo = vntArrRsvNo(lngRecord)
		If strOrgCd1 = "" Then strOrgCd1 = vntArrOrgCd1(lngRecord)
		If strOrgCd2 = "" Then strOrgCd2 = vntArrOrgCd2(lngRecord)
		strMode = "initend"
	End If

	If lngPrice = ""  OR IsNull(lngPrice) Then lngPrice = 0
	If lngEditPrice = "" OR IsNull(lngEditPrice) Then lngEditPrice = 0
	If lngTaxPrice = "" OR IsNull(lngTaxPrice) Then lngTaxPrice = 0
	If lngEditTax = "" OR IsNull(lngEditTax) Then lngEditTax = 0

	'�����ς݁A�����ς݃`�F�b�N
	lngCount2 = objDemand.SelectPaymentAndDispatchCnt(strBillNo, _
													vntArrPaymentCnt, _
													vntArrDispatchCnt)



	If vntArrPaymentCnt(0) > 0 Or vntArrDispatchCnt(0) > 0 Then
		strAction = "Err"
		strNoEditFlg = 1
		strArrMessage = Array("�����ς݂܂��͓����ς݂̂��߁A�ύX�ł��܂���")
		Exit Do
	End If

	If vntArrBranchno(0) = "1" Then
		strAction = "Err"
		strNoEditFlg = 1
		strArrMessage = Array("����ς݂̂��߁A�ύX�ł��܂���")
		Exit Do
	End If

	'�m��{�^���������A�ۑ��������s
	If strAction = "save" Then

		'���̓`�F�b�N
		strArrMessage = CheckValue()
		If Not IsEmpty(strArrMessage) Then
			Exit Do
		End If

		If strItemNo = "" Then
		'���������ׂ̓o�^
		Ret = objDemand.InsertBillDetail_Items(strBillNo, _
										strLineNo, _
										strSecondLineDivCd, _
										lngPrice, _
										lngEditPrice, _
										lngTaxPrice, _
										lngEditTax)
		Else
		'���������ׂ̍X�V
		Ret = objDemand.UpdateBillDetail_Items(strBillNo, _
										strLineNo, _
										strItemNo, _
										strSecondLineDivCd, _
										lngPrice, _
										lngEditPrice, _
										lngTaxPrice, _
										lngEditTax)
		End If

		'�ۑ��Ɏ��s�����ꍇ
		If Ret <> True Then
			strArrMessage = Array("�������ד���̍X�V�Ɏ��s���܂����B")
'			Err.Raise 1000, , "�������ד��󂪍X�V�ł��܂���B�i������No�@= " & objCommon.FormatString(strDmdDate, "yyyymmdd") & objCommon.FormatString(lngBillSeq, "00000") & lngBranchNo &" )"
			Exit Do
		Else
			'�G���[���Ȃ���ΌĂь���ʂ������[�h���Ď��g�����
			strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
'			strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); location.href='dmdDetailItmList.asp?BillNo=" & strBillNo & "&LineNo=" & strLineNo & "&perId=" & strPerId & "&lastName=" & strLastName & "&firstName=" & strFirstName & "&cslDate=" & strCslDate & "'"">"
			strHTML = strHTML & "<BODY ONLOAD=""location.href='dmdDetailItmList.asp?BillNo=" & strBillNo & "&LineNo=" & strLineNo & "&perId=" & strPerId & "&lastName=" & strLastName & "&firstName=" & strFirstName & "&cslDate=" & strCslDate & "'"">"
			strHTML = strHTML & "</BODY>"
			strHTML = strHTML & "</HTML>"
			Response.Write strHTML
			Response.End
			Exit Do
		End If

	End If

	'�폜�{�^���������A�폜�������s
	If strAction = "delete" Then
		'���������ׂ̓o�^
		Ret = objDemand.DeleteBillDetail_Items(strBillNo, strLineNo, strItemNo)
		'�폜�Ɏ��s�����ꍇ
		If Ret <> True Then
			strArrMessage = Array("�������ד���̍폜�Ɏ��s���܂����B")
			Exit Do
		Else
			'�G���[���Ȃ���ΌĂь���ʂ������[�h���Ď��g�����
			strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
			strHTML = strHTML & "<BODY ONLOAD=""location.href='dmdDetailItmList.asp?BillNo=" & strBillNo & "&LineNo=" & strLineNo & "&perId=" & strPerId & "&lastName=" & strLastName & "&firstName=" & strFirstName & "&cslDate=" & strCslDate & "'"">"
			strHTML = strHTML & "</BODY>"
			strHTML = strHTML & "</HTML>"
			Response.Write strHTML
			Response.End
			Exit Do
		End If

	End If

	Exit Do
Loop


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

	Dim objCommon		'���ʃN���X
	Dim vntArrMessage	'�G���[���b�Z�[�W�̏W��

	'���ʃN���X�̃C���X�^���X�쐬
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'�e�l�`�F�b�N����
	With objCommon
		'�������R�����g�`�F�b�N
		If strSecondLineDivCd = "" Then 
			.AppendArray vntArrMessage, "�����ڍז������͂���Ă��܂���B"
		End If
		If IsNumeric(lngPrice) Then lngPrice = CDbl(lngPrice)
		If IsNumeric(lngEditPrice) Then lngEditPrice = CDbl(lngEditPrice)
		If IsNumeric(lngTaxPrice) Then lngTaxPrice = CDbl(lngTaxPrice)
		If IsNumeric(lngEditTax) Then lngEditTax = CDbl(lngEditTax)
		.AppendArray vntArrMessage, .CheckNumericWithSign("�������z", lngPrice, 7)
		.AppendArray vntArrMessage, .CheckNumericWithSign("�������z", lngEditPrice, 7)
		.AppendArray vntArrMessage, .CheckNumericWithSign("�����", lngTaxPrice, 7)
		.AppendArray vntArrMessage, .CheckNumericWithSign("�����Ŋz", lngEditTax, 7)
	End With

	'�߂�l�̕ҏW
	If IsArray(vntArrMessage) Then
		CheckValue = vntArrMessage
	End If

End Function


%>
<!--
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�������ד���o�^�E�C��</TITLE>
-->
<!-- #include virtual = "/webHains/includes/perGuide.inc"  -->
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!-- #include virtual = "/webHains/includes/secondLineDivGuide.inc"    -->
<!--

function closeGuide(){
	// �J�����_�[�K�C�h�����
	if ( winGuideCalendar ) {
		if ( !winGuideCalendar.closed ) {
			winGuideCalendar.close();
		}
	}

	// �l�����K�C�h�����
	if ( winGuidePersonal ) {
		if ( !winGuidePersonal.closed ) {
			winGuidePersonal.close();
		}
	}
}

//�ۑ�
function saveData() {

	// ���[�h���w�肵��submit
	document.entryForm.act.value = 'save';
	document.entryForm.submit();

}

//�폜
function deleteData(){
	// ���[�h���w�肵��submit
	var rt = confirm('���̖��ד�����폜���Ă���낵���ł����H');
	if(rt == true){
		document.entryForm.act.value = 'delete';
		document.entryForm.submit();
	}
}

// ���̓K�C�h�Ăяo��
function callSecondLineDivGuide() {

	// �K�C�h��ʂ̘A����ɃK�C�h��ʂ���Ăяo����鎩��ʂ̊֐���ݒ肷��
	secondLineDivGuide_CalledFunction = setSecondLineDivInfo;

	// ���̓K�C�h�\��
	showGuideSecondLineDiv();
}

// ���̓R�[�h�E�����͂̃Z�b�g
function setSecondLineDivInfo() {

	setSecondLineDiv( secondLineDivGuide_SecondLineDivCd, secondLineDivGuide_SecondLineDivName , secondLineDivGuide_stdPrice , secondLineDivGuide_stdTax );

}

// �Q���������ׂ̕ҏW
function setSecondLineDiv( secondLineDivCd, secondLineDivName , stdPrice , stdTax ) {

	var myForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g
	var objSecondLineDivCd, objSecondLineDivName;		// ���ʁE���͂̃G�������g
	var objstdPrice, objstdTax;						// �W���P���E�W���Ŋz�̃G�������g
	var secondLineDivNameElement;					// ���͂̃G�������g

	// �ҏW�G�������g�̐ݒ�
	objSecondLineDivCd   = myForm.secondLineDivCd;
	objSecondLineDivName = myForm.secondLineDivName;
	objstdPrice = myForm.Price;
	objstdTax = myForm.TaxPrice;

	secondLineDivNameElement = 'secondLineDivName';

	// �l�̕ҏW
	objSecondLineDivCd.value   = secondLineDivCd;
	document.getElementById(secondLineDivNameElement).innerHTML = secondLineDivName;
	objstdPrice.value   = stdPrice;
	objstdTax.value   = stdTax;

	if ( document.getElementById(secondLineDivNameElement) ) {
		document.getElementById(secondLineDivNameElement).innerHTML = secondLineDivName;
	}

}

function secondLineDivGuide_clearPerInfo() {
	var myForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g

	// �ҏW�G�������g�̐ݒ�
	myForm.secondLineDivCd.value = '';
	document.getElementById('secondLineDivName').innerHTML = '';

}

//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 20px 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:closeGuide();">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">��</SPAN>�������ד���o�^�E�C��</B></TD>
		</TR>
	</TABLE>
	<!-- ������� -->
	<INPUT TYPE="hidden" NAME="act" VALUE="">
	<INPUT TYPE="hidden" NAME="mode" VALUE="<%= strMode %>">

	<INPUT TYPE="hidden" NAME="record" VALUE="<%= lngRecord %>">
	<INPUT TYPE="hidden" NAME="divcd" VALUE="<%= strDivCd %>">
	<INPUT TYPE="hidden" NAME="setname" VALUE="<%= strSetName %>">
	<INPUT TYPE="hidden" NAME="BillNo" VALUE="<%= strBillNo%>">
	<INPUT TYPE="hidden" NAME="LineNo" VALUE="<%= strLineNo%>">
	<INPUT TYPE="hidden" NAME="ItemNo" VALUE="<%= strItemNo%>">
	<INPUT TYPE="hidden" NAME="perId" VALUE="<%= strPerId%>">
	<INPUT TYPE="hidden" NAME="lastName" VALUE="<%= strLastName%>">
	<INPUT TYPE="hidden" NAME="firstName" VALUE="<%= strFirstName%>">
	<INPUT TYPE="hidden" NAME="cslDate" VALUE="<%= strCslDate%>">
	<INPUT TYPE="hidden" NAME="OrgCd1" VALUE="<%= strOrgCd1%>">
	<INPUT TYPE="hidden" NAME="OrgCd2" VALUE="<%= strOrgCd2%>">
	<INPUT TYPE="hidden" NAME="getCount" VALUE="<%= strGetCount%>">
	<INPUT TYPE="hidden" NAME="startpos" VALUE="<%= strStartPos%>">
	<BR>
<%
'���b�Z�[�W�̕ҏW
	'���b�Z�[�W�̕ҏW
	If strAction <> "" Then
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
				If lngCount = 0 Then
				Response.End
				End If
		End Select

	End If
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD NOWRAP>�c�̖�</TD>
			<TD>�F</TD>
			<TD NOWRAP><%= vntArrOrgName(lngRecord) %></TD>
		</TR>
		<TR>
			<TD NOWRAP>��f��</TD>
			<TD>�F</TD>
			<TD>
				<TABLE>
					<TR>
						<TD><%= objCommon.FormatString(strCslDate, "yyyy�Nmm��dd��") %></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>�������ד���</TD>
			<TD>�F</TD>
			<TD NOWRAP>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD>
							<A HREF="javascript:callSecondLineDivGuide()">
								<IMG SRC="/webHains/images/question.gif" ALT="�Q����������K�C�h��\��" HEIGHT="21" WIDTH="21">
							</A>
							<A HREF="javascript:secondLineDivGuide_clearPerInfo();">
								<IMG SRC="/webHains/images/delicon.gif" ALT="�ݒ肵���l���N���A" HEIGHT="21" WIDTH="21">
							</A>
						</TD>
						<TD>
							<INPUT TYPE="hidden" NAME="secondLineDivCd" VALUE="<%= strSecondLineDivCd %>">
							<!--<INPUT TYPE="hidden" NAME="secondLineDivName" VALUE="<%= strSecondLineDivName %>">-->
							<SPAN ID="secondLineDivName"><%= strSecondLineDivName %></SPAN>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>�������z</TD>
			<TD>�F</TD>
			<TD NOWRAP>
				<%If vntArrMethod(0) = "0" Or strLineNo = "" Then%>
					<INPUT TYPE="text" NAME="Price" VALUE="<%= lngPrice %>" SIZE="10" MAXLENGTH="8">
				<%Else%>
					<%= FormatCurrency(lngPrice) %>
					<INPUT TYPE="hidden" NAME="Price" VALUE="<%= lngPrice%>">
				<%End If%>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>�������z</TD>
			<TD>�F</TD>
			<TD><INPUT TYPE="text" NAME="EditPrice" VALUE="<%= lngEditPrice %>" SIZE="10" MAXLENGTH="8"></TD>
		</TR>
		<TR>
			<TD NOWRAP>�����</TD>
			<TD>�F</TD>
			<TD NOWRAP>
				<%If vntArrMethod(0) = "0" Or strLineNo = "" Then%>
					<INPUT TYPE="text" NAME="TaxPrice" VALUE="<%= lngTaxPrice %>" SIZE="10" MAXLENGTH="8">
				<%Else%>
					<%= FormatCurrency(lngTaxPrice) %>
					<INPUT TYPE="hidden" NAME="TaxPrice" VALUE="<%= lngTaxPrice %>">
				<%End If%>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>�����Ŋz</TD>
			<TD>�F</TD>
			<TD><INPUT TYPE="text" NAME="EditTax" VALUE="<%= lngEditTax %>" SIZE="10" MAXLENGTH="8"></TD>
		</TR>
	</TABLE>
	<BR>
<%If strItemNo <> "" Then%>
	<%If strNoEditFlg = 0 Then%>
	<A HREF="javascript:deleteData()"><IMG SRC="../../images/delete.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="���ׂ��폜���܂��B"></A>
	<%End If%>
<%End If%>
<%If strNoEditFlg = 0 Then%>
	<A HREF="javascript:saveData()"><IMG SRC="../../images/ok.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="���̓��e�Ŋm��"></A>
<%End If%>
	<A HREF="javascript:location.href='dmdDetailItmList.asp?BillNo=<%=strBillNo%>&LineNo=<%=strLineNo%>&perId=<%=strPerId%>&lastName=<%=strLastName%>&firstName=<%=strFirstName%>&cslDate=<%=strCslDate%>';"><IMG SRC="../../images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="�L�����Z������"></A></TD>
</FORM>
</BODY>
</HTML>
