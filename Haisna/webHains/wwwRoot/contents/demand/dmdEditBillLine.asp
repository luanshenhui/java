<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�������דo�^�E�C���\�� (Ver0.0.1)
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

Dim objCommon				'���ʃN���X
Dim objDemand				'�������A�N�Z�X�p

Dim Ret						'�֐��߂�l

Dim lngCount				'�擾����
Dim lngCount2				'�擾����
Dim lngRecord				'���R�[�h�J�E���^
Dim i						'���[�v�J�E���^

'�p�����[�^
Dim strBillNo				'�������ԍ�
Dim strLineNo				'����No.
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
Dim vntArrPaymentCnt		'��������
Dim vntArrDispatchCnt		'��������
'2004.06.02 ADD STR ORB)T.YAGUCHI ���ڒǉ�
Dim vntArrSecondFlg			'�Q�������t���O
Dim strSumPrice				'���z���v
Dim strSumEditPrice			'�������z���v
Dim strSumTaxPrice			'�Ŋz���v
Dim strSumEditTax			'�����Ŋz���v
Dim strSumPriceTotal			'�����v
Dim lngSumPrice				'���z���v
Dim lngSumEditPrice			'�������z���v
Dim lngSumTaxPrice			'�Ŋz���v
Dim lngSumEditTax			'�����Ŋz���v
Dim lngSumPriceTotal			'�����v
Dim lngSumRecord			'���R�[�h��
'2004.06.02 ADD END

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

lngStrYear     = CLng("0" & Request("strYear"))
lngStrMonth    = CLng("0" & Request("strMonth"))
lngStrDay      = CLng("0" & Request("strDay"))
'���ݒ莞�̓V�X�e�����t
If IsNull(strLineNo) Or strLineNo = "" Then
	lngStrYear    = IIf(lngStrYear  = 0, Year(Now),    lngStrYear )
	lngStrMonth   = IIf(lngStrMonth = 0, Month(Now),   lngStrMonth)
	lngStrDay     = IIf(lngStrDay   = 0, Day(Now),     lngStrDay  )
End If

strCslDate = lngStrYear & "/" & lngStrMonth & "/" & lngStrDay
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
'2004.06.02 MOD STR ORB)T.YAGUCHI ���ڒǉ�
'	'����������
'	lngCount = objDemand.SelectDmdBurdenModifyBillDetail(strBillNo, _
'														strLineNo, _
'														"","", _
'														vntArrBillNo, _
'														vntArrLineNo, _
'														vntArrCloseDate, _
'														vntArrBillSeq, _
'														vntArrBranchno, _
'														vntArrDayId, _
'														vntArrRsvNo, _
'														vntArrCslDate, _
'														vntArrDetailName, _
'														vntArrPerId, _
'														vntArrLastName, _
'														vntArrFirstName, _
'														vntArrLastKName, _
'														vntArrFirstKName, _
'														vntArrPrice, _
'														vntArrEditPrice, _
'														vntArrTaxPrice, _
'														vntArrEditTax, _
'														vntArrOrgCd1, _
'														vntArrOrgCd2, _
'														vntArrOrgName, _
'														vntArrOrgKName,_
'														vntArrMethod)
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
														vntArrMethod,, _
														vntArrSecondFlg)
	'�Q���������v���z�̒ǉ�
	lngSumRecord = objDemand.SelectSumDetailItems(strBillNo,, _
							strSumPrice, _
							strSumEditPrice, _
							strSumTaxPrice, _
							strSumEditTax, _
							strSumPriceTotal)
	If lngSumRecord > 0 Then
		If strSumPrice(0) = ""  OR IsNull(strSumPrice(0)) Then
		 	lngSumPrice = 0
		Else
		 	lngSumPrice = strSumPrice(0)
		End If
		If strSumEditPrice(0) = ""  OR IsNull(strSumEditPrice(0)) Then
			lngSumEditPrice = 0
		Else
			lngSumEditPrice = strSumEditPrice(0)
		End if
		If strSumTaxPrice(0) = ""  OR IsNull(strSumTaxPrice(0)) Then
			lngSumTaxPrice = 0
		Else
			lngSumTaxPrice = strSumTaxPrice(0)
		End if
		If strSumEditTax(0) = ""  OR IsNull(strSumEditTax(0)) Then
			lngSumEditTax = 0
		Else
			lngSumEditTax = strSumEditTax(0)
		End if
	Else
	 	lngSumPrice = 0
		lngSumEditPrice = 0
		lngSumTaxPrice = 0
		lngSumEditTax = 0
	End If
'2004.06.02 MOD END

	'���������ׂ����݂��Ȃ��ꍇ
	If lngCount < 1 Then
		strArrMessage = Array("�Y�����鐿���������݂��܂���")
		strAction = "Err"
		Exit Do
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
		If lngPrice = "" Then lngPrice = vntArrPrice(lngRecord)
		If lngTaxPrice = "" Then lngTaxPrice = vntArrTaxPrice(lngRecord)
		If lngEditPrice = "" Then lngEditPrice = vntArrEditPrice(lngRecord)
		If lngEditTax = "" Then lngEditTax = vntArrEditTax(lngRecord)
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

		If strLineNo = "" Then
		'���������ׂ̓o�^
		Ret = objDemand.InsertBillDetail(strBillNo, _
										strCslDate, _
										strRsvNo, _
										strDayId, _
										strDetailName, _
										strPerId, _
										lngPrice, _
										lngEditPrice, _
										lngTaxPrice, _
										lngEditTax)
		Else
		'���������ׂ̍X�V
		Ret = objDemand.UpdateBillDetail(strBillNo, _
										strLineNo, _
										strCslDate, _
										strDetailName, _
										strPerId, _
										lngPrice, _
										lngEditPrice, _
										lngTaxPrice, _
										lngEditTax, _
										strRsvNo, _
										strDayId)
		End If

		'�ۑ��Ɏ��s�����ꍇ
		If Ret <> True Then
			strArrMessage = Array("�������ׂ̍X�V�Ɏ��s���܂����B")
'			Err.Raise 1000, , "�������ׂ��X�V�ł��܂���B�i������No�@= " & objCommon.FormatString(strDmdDate, "yyyymmdd") & objCommon.FormatString(lngBillSeq, "00000") & lngBranchNo &" )"
			Exit Do
		Else
			'�G���[���Ȃ���ΌĂь���ʂ������[�h���Ď��g�����
			strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
'			strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); location.href='dmdBurdenModify.asp?BillNo=" & strBillNo & "'"">"
			strHTML = strHTML & "<BODY ONLOAD=""location.href='dmdBurdenModify.asp?BillNo=" & strBillNo & "&getCount=" & strGetCount & "&startpos=" & strStartPos & "'"">"
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
		Ret = objDemand.DeleteBillDetail(strBillNo, strLineNo, strRsvNo, strOrgCd1, strOrgCd2)
		'�폜�Ɏ��s�����ꍇ
		If Ret <> True Then
			strArrMessage = Array("�������ׂ̍폜�Ɏ��s���܂����B")
			Exit Do
		Else
			'�G���[���Ȃ���ΌĂь���ʂ������[�h���Ď��g�����
			strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
			strHTML = strHTML & "<BODY ONLOAD=""location.href='dmdBurdenModify.asp?BillNo=" & strBillNo & "&getCount=" & strGetCount & "'"">"
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
	Dim strYMD			'��f���߂�l

	'���ʃN���X�̃C���X�^���X�쐬
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'�e�l�`�F�b�N����
	With objCommon
		'�������R�����g�`�F�b�N
		If strDetailName = "" Then 
			.AppendArray vntArrMessage, "�����ڍז������͂���Ă��܂���B"
		End If
		.AppendArray vntArrMessage, .CheckDate("��f��",lngStrYear, lngStrMonth, lngStrDay, strYMD, 1)
		.AppendArray vntArrMessage, .CheckWideValue("�����ڍז�", strDetailName, 30)
		If IsNumeric(strDayId) Then strDayId = CDbl(strDayId)
		If IsNumeric(strRsvNo) Then strRsvNo = CDbl(strRsvNo)
		If IsNumeric(lngPrice) Then lngPrice = CDbl(lngPrice)
		If IsNumeric(lngEditPrice) Then lngEditPrice = CDbl(lngEditPrice)
		If IsNumeric(lngTaxPrice) Then lngTaxPrice = CDbl(lngTaxPrice)
		If IsNumeric(lngEditTax) Then lngEditTax = CDbl(lngEditTax)
		.AppendArray vntArrMessage, .CheckNumeric("����ID", strDayId, 5)
		.AppendArray vntArrMessage, .CheckNumeric("�\��ԍ�", strRsvNo, 9)
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
<TITLE>�������דo�^�E�C��</TITLE>
-->
<!-- #include virtual = "/webHains/includes/perGuide.inc"  -->
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
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
	var rt = confirm('���̖��ׂ��폜���Ă���낵���ł����H');
	if(rt == true){
		document.entryForm.act.value = 'delete';
		document.entryForm.submit();
	}
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
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">��</SPAN>�������דo�^�E�C��</B></TD>
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
						<TD><A HREF="javascript:calGuide_showGuideCalendar('strYear', 'strMonth', 'strDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
						<TD><%= EditNumberList("strYear", YEARRANGE_MIN, YEARRANGE_MAX, lngStrYear, False) %></TD>
						<TD>�N</TD>
						<TD><%= EditNumberList("strMonth", 1, 12, lngStrMonth, False) %></TD>
						<TD>��</TD>
						<TD><%= EditNumberList("strDay", 1, 31, lngStrDay, False) %></TD>
						<TD>��</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>����ID</TD>
			<TD>�F</TD>
			<TD>
				<TABLE WIDTH="120" BORDER="0" CELLSPACING="1" CELLPADDING="0">
					<TR>
						<TD>
						<%If vntArrMethod(0) = "0" Or strLineNo = "" Then%>
							<INPUT TYPE="text" NAME="DayId" VALUE="<%= strDayId%>" SIZE="7" MAXLENGTH="5">
						<%Else%>
							<%=strDayId%>
							<INPUT TYPE="hidden" NAME="DayId" VALUE="<%= strDayId%>">
						<%End If%>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>�\��ԍ�</TD>
			<TD>�F</TD>
			<TD>
				<TABLE WIDTH="120" BORDER="0" CELLSPACING="1" CELLPADDING="0">
					<TR>
						<TD>
						<%If vntArrMethod(0) = "0" Or strLineNo = "" Then%>
							<INPUT TYPE="text" NAME="RsvNo" VALUE="<%= strRsvNo%>" SIZE="10" MAXLENGTH="9">
						<%Else%>
							<%=strRsvNo%>
							<INPUT TYPE="hidden" NAME="RsvNo" VALUE="<%= strRsvNo%>">
						<%End If%>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>�������ז�</TD>
			<TD>�F</TD>
			<TD>
				<TABLE WIDTH="120" BORDER="0" CELLSPACING="1" CELLPADDING="0">
					<TR>
						<TD><INPUT TYPE="text" NAME="DetailName" VALUE="<%= strDetailName %>" SIZE="40" MAXLENGTH="30"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD HEIGHT="27">����</TD>
			<TD>�F</TD>
			<TD NOWRAP>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD>
							<A HREF="javascript:perGuide_showGuidePersonal(document.entryForm.perId, 'perName')">
								<IMG SRC="/webHains/images/question.gif" ALT="�l�����K�C�h��\��" HEIGHT="21" WIDTH="21">
							</A>
							<A HREF="javascript:perGuide_clearPerInfo(document.entryForm.perId, 'perName');">
								<IMG SRC="/webHains/images/delicon.gif" ALT="�ݒ肵���l���N���A" HEIGHT="21" WIDTH="21">
							</A>
						</TD>
						<TD>
							<INPUT TYPE="hidden" NAME="perId" VALUE="<%= strPerId %>">
							<INPUT TYPE="hidden" NAME="txtperName" VALUE="<%= strPerName %>">
							<SPAN ID="perName"><%= strPerName %></SPAN>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>�������z</TD>
			<TD>�F</TD>
			<TD NOWRAP>
<% '2004.06.02 MOD STR ORB)T.YAGUCHI ���ڒǉ� %>
<!--
				<%If vntArrMethod(0) = "0" Or strLineNo = "" Then%>
					<INPUT TYPE="text" NAME="Price" VALUE="<%= lngPrice %>" SIZE="10" MAXLENGTH="8">
				<%Else%>
					<%= FormatCurrency(lngPrice) %>
					<INPUT TYPE="hidden" NAME="Price" VALUE="<%= lngPrice%>">
				<%End If%>
-->
				<%If vntArrSecondFlg(0) <> "1" Then%>
					<%If vntArrMethod(0) = "0" Or strLineNo = "" Then%>
						<INPUT TYPE="text" NAME="Price" VALUE="<%= lngPrice %>" SIZE="10" MAXLENGTH="8">
					<%Else%>
						<%= FormatCurrency(lngPrice) %>
						<INPUT TYPE="hidden" NAME="Price" VALUE="<%= lngPrice%>">
					<%End If%>
				<%Else%>
					<INPUT TYPE="hidden" NAME="Price" VALUE="<%= lngPrice%>"><%= lngSumPrice %>
				<%End If%>
<% '2004.06.02 MOD END %>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>�������z</TD>
			<TD>�F</TD>
<% '2004.06.02 MOD STR ORB)T.YAGUCHI ���ڒǉ� %>
<!--
			<TD><INPUT TYPE="text" NAME="EditPrice" VALUE="<%= lngEditPrice %>" SIZE="10" MAXLENGTH="8"></TD>
-->
			<%If vntArrSecondFlg(0) <> "1" Then%>
				<TD><INPUT TYPE="text" NAME="EditPrice" VALUE="<%= lngEditPrice %>" SIZE="10" MAXLENGTH="8"></TD>
			<%Else%>
				<TD><INPUT TYPE="hidden" NAME="EditPrice" VALUE="<%= lngEditPrice %>"><%= lngSumEditPrice %></TD>
			<%End If%>
<% '2004.06.02 MOD END %>
		</TR>
		<TR>
			<TD NOWRAP>�����</TD>
			<TD>�F</TD>
			<TD NOWRAP>
<% '2004.06.02 MOD STR ORB)T.YAGUCHI ���ڒǉ� %>
<!--
				<%If vntArrMethod(0) = "0" Or strLineNo = "" Then%>
					<INPUT TYPE="text" NAME="TaxPrice" VALUE="<%= lngTaxPrice %>" SIZE="10" MAXLENGTH="8">
				<%Else%>
					<%= FormatCurrency(lngTaxPrice) %>
					<INPUT TYPE="hidden" NAME="TaxPrice" VALUE="<%= lngTaxPrice %>">
				<%End If%>
-->
				<%If vntArrSecondFlg(0) <> "1" Then%>
					<%If vntArrMethod(0) = "0" Or strLineNo = "" Then%>
						<INPUT TYPE="text" NAME="TaxPrice" VALUE="<%= lngTaxPrice %>" SIZE="10" MAXLENGTH="8">
					<%Else%>
						<%= FormatCurrency(lngTaxPrice) %>
						<INPUT TYPE="hidden" NAME="TaxPrice" VALUE="<%= lngTaxPrice %>">
					<%End If%>
				<%Else%>
					<INPUT TYPE="hidden" NAME="TaxPrice" VALUE="<%= lngTaxPrice %>"><%= lngSumTaxPrice %>
				<%End If%>
<% '2004.06.02 MOD END %>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>�����Ŋz</TD>
			<TD>�F</TD>
<% '2004.06.02 MOD STR ORB)T.YAGUCHI ���ڒǉ� %>
<!--
			<TD><INPUT TYPE="text" NAME="EditTax" VALUE="<%= lngEditTax %>" SIZE="10" MAXLENGTH="8"></TD>
-->
			<%If vntArrSecondFlg(0) <> "1" Then%>
				<TD><INPUT TYPE="text" NAME="EditTax" VALUE="<%= lngEditTax %>" SIZE="10" MAXLENGTH="8"></TD>
			<%Else%>
				<TD><INPUT TYPE="hidden" NAME="EditTax" VALUE="<%= lngEditTax %>"><%= lngSumEditTax %></TD>
			<%End If%>
<% '2004.06.02 MOD END %>
		</TR>
	</TABLE>
	<BR>
<%If strLineNo <> "" Then%>
	<%If strNoEditFlg = 0 Then%>
		<% '2005.08.22 �����Ǘ� Add by ���@--- START %>
		<%  if Session("PAGEGRANT") = "3" or Session("PAGEGRANT") = "4" then   %>
		<A HREF="javascript:deleteData()"><IMG SRC="../../images/delete.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="���ׂ��폜���܂��B"></A>
		<%  else    %>
			 &nbsp;
		<%  end if  %>
		<% '2005.08.22 �����Ǘ� Add by ���@--- END %>	
	<%End If%>
<%End If%>
<%If strNoEditFlg = 0 Then%>
	<% '2005.08.22 �����Ǘ� Add by ���@--- START %>
	<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
	<A HREF="javascript:saveData()"><IMG SRC="../../images/ok.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="���̓��e�Ŋm��"></A>
	<%  else    %>
		 &nbsp;
	<%  end if  %>
	<% '2005.08.22 �����Ǘ� Add by ���@--- END %>
<%End If%>
	<A HREF="javascript:location.href='dmdBurdenModify.asp?BillNo=<%=strBillNo%>&getCount=<%=strGetCount%>&startpos=<%=strStartPos%>';"><IMG SRC="../../images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="�L�����Z������"></A></TD>
</FORM>
</BODY>
</HTML>
