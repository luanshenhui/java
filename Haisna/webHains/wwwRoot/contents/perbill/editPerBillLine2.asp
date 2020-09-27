<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�Z�b�g�O�������דo�^�E�C���\�� (Ver0.0.1)
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
Dim objPerbill				'��f���A�N�Z�X�p

Dim Ret						'�֐��߂�l

Dim lngCount				'�擾����
Dim lngRsvNo				'�\��ԍ�
Dim lngRecord				'���R�[�h�ԍ�

Dim strLineName				'�������ז���
Dim lngPrice				'���z
Dim lngEditPrice			'�������z
Dim lngTaxPrice				'�Ŋz
Dim lngEditTax				'�����Ŋz
Dim lngOmitTaxFlg			'����ŖƏ��t���O

'�l��f���z�p�ϐ�
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
Dim vntOptBranchNo			'�I�v�V�����}��
Dim vntOptName				'�I�v�V��������
Dim vntOtherLineDivCd		'�Z�b�g�O���̋敪
Dim vntLineName				'���ז��́i�Z�b�g�O���ז��̊܂ށj
Dim vntDmdDate				'������
Dim vntBillSeq				'�������r����
Dim vntBranchNo				'�������}��
Dim vntBillLineNo			'���������׍sNo
Dim vntOmitTaxFlg			'����ŖƏ��t���O
Dim vntPaymentDate_m		'������
Dim vntPaymentSeq_m			'�����r����

Dim vntOtherLineDivName		'�Z�b�g�O�������ז��i�S���́j
' ### 2004.01.08 add
Dim vntListOtherLineDivCd	'�Z�b�g�O�������׃R�[�h�i�S���j

Dim strDivCd				'�Z�b�g�O�������׃R�[�h
Dim strDivName				'�Z�b�g�O�������ז���
Dim strOrgName				'���ݕ\������Ă閼��

Dim strMode					'�������[�h
Dim strAction				'���샂�[�h(�ۑ�:"save"�A�ۑ�����:"saved")
Dim i						'�C���f�b�N�X
Dim strHTML
Dim strArrMessage	'�G���[���b�Z�[�W

strArrMessage = ""

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objDemand  = Server.CreateObject("HainsDemand.Demand")
Set objPerbill = Server.CreateObject("HainsPerBill.PerBill")

'�����l�̎擾

lngPrice       = Request("price")
lngEditPrice   = Request("editprice")
lngTaxPrice    = Request("taxprice")
lngEditTax     = Request("edittax")
strLineName    = Request("linename")
lngRsvNo       = Request("rsvno")
strDivCd       = Request("divcd")
strDivName     = Request("divname")
lngRecord      = Request("record")
strOrgName     = Request("orgname")
lngOmitTaxFlg  = Request("omitTaxFlg")

strAction      = Request("act")
strMode        = Request("mode")

'�����\���ݒ�
If strMode = "" Then strMode = "init"

Do

	'�l��f���z���擾
		lngCount = objDemand.SelectConsult_mInfo(lngRsvNo, _
												 vntOrgCd1, _
												 vntOrgCd2, _
												 vntOrgSeq, _
												 vntOrgName, _
												 vntPrice, _
												 vntEditPrice, _
												 vntTaxPrice, _
												 vntEditTax, _
												 vntLineTotal, _ 
												 vntPriceSeq, _
												 vntCtrPtCd, _
												 vntOptCd, _
												 vntOptBranchNo, _
												 vntOptName, _
												 vntOtherLineDivCd, _
												 vntLineName, _
												 vntDmdDate, _
												 vntBillSeq, _
												 vntBranchNo, _
												 vntBillLineNo, _
												 vntPaymentDate_m, _
												 vntPaymentSeq_m, _
												 vntOmitTaxFlg )

	'��f���z��񂪑��݂��Ȃ��ꍇ
	If lngCount < 1 Then
		Exit Do
	End If

'	vntOtherLineDivName = Array()

	'�Z�b�g�O�������׎擾
	'### �R�[�h���擾����悤�ɏC��
	Ret = objPerbill.SelectOtherLineDiv( vntListOtherLineDivCd, vntOtherLineDivName )
	'�Ǎ��ݎ��s
	If Ret < 1 Then
		Exit Do
	End If

	If strMode = "init" Then
		'�����\���ݒ�
		'###�R�[�h�͘A�ԂƂ͌���Ȃ��̂ŏC���@2004.01.08
'		If strDivName = "" Then strDivName = vntOtherLineDivName(vntOtherLineDivCd(lngRecord)-1)
		If strLineName = "" Then strLineName = vntLineName(lngRecord)
		If strOrgName = "" Then strOrgName = vntLineName(lngRecord)
		If strDivCd = "" Then strDivCd = vntOtherLineDivCd(lngRecord)
		' ### �}�X�^���ז��擾�@2004.01.08 add start
		If strDivCd <> "" Then
			If strDivName = "" Then 
				For i = 0 To Ret - 1
					If vntListOtherLineDivCd(i) = strDivCd Then
						strDivName = Trim(vntOtherLineDivName(i))
						Exit For
					End If
				Next
			End If
		End If
		' ### �}�X�^���ז��擾�@2004.01.08 add start
		If lngPrice = "" Then lngPrice = vntPrice(lngRecord)
		If lngEditPrice = "" Then lngEditPrice = vntEditPrice(lngRecord)
		If lngTaxPrice = "" Then lngTaxPrice = vntTaxPrice(lngRecord)
		If lngEditTax = "" Then lngEditTax = vntEditTax(lngRecord)
		If lngOmitTaxFlg = "" Then lngOmitTaxFlg = vntOmitTaxFlg(lngRecord)
		strMode = "initend"
	End If

	'�m��{�^���������A�ۑ��������s
	If strAction = "save" Then
'KMT
'Err.Raise 1000, , "act = " & strAction

		If lngPrice = "" OR IsNull(lngPrice) Then lngPrice = 0
		If lngEditPrice = "" OR IsNull(lngEditPrice) Then lngEditPrice = 0
		If lngTaxPrice = "" OR IsNull(lngTaxPrice) Then lngTaxPrice = 0
		If lngEditTax = "" OR IsNull(lngEditTax) Then lngEditTax = 0

		'���̓`�F�b�N
		strArrMessage = CheckValue()
		If Not IsEmpty(strArrMessage) Then
			Exit Do
		End If

		'��f�m����z���A�l�������׏��̓o�^
		Ret = objPerbill.UpdatePerBill_c(vntDmdDate(lngRecord), _
											IIf( vntBillSeq(lngRecord) = "", 0, vntBillSeq(lngRecord)), _
											IIf( vntBranchNo(lngRecord)= "", 0, vntBranchNo(lngRecord)), _
											IIf( vntBillLineNo(lngRecord)= "", 0, vntBillLineNo(lngRecord)), _
											lngPrice, _
											lngEditPrice, _
											lngTaxPrice, _
											lngEditTax, _
											IIf( strOrgName = strLineName, "", strLineName), _
											lngRsvNo, _
											vntPriceSeq(lngRecord), _
											lngOmitTaxFlg, _
											strDivCd )

		'�ۑ��Ɏ��s�����ꍇ
		If Ret <> True Then
			strArrMessage = Array("�Z�b�g�O�������ׂ̍X�V�Ɏ��s���܂����B")
'			Err.Raise 1000, , "�Z�b�g�O�������ׂ��X�V�ł��܂���B�i������No�@= " & objCommon.FormatString(strDmdDate, "yyyymmdd") & objCommon.FormatString(lngBillSeq, "00000") & lngBranchNo &" )"
			Exit Do
		Else
			'�G���[���Ȃ���ΌĂь���ʂ������[�h���Ď��g�����
			strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
			strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
			strHTML = strHTML & "</BODY>"
			strHTML = strHTML & "</HTML>"
			Response.Write strHTML
			Response.End
			Exit Do
		End If

	End If

	'�폜�{�^���������A�폜�������s
	If strAction = "delete" Then

		'��f�m����z���A�l�������׏��̍폜
		Ret = objPerbill.DeletePerBill_c( lngRsvNo, vntPriceSeq(lngRecord) )

		'�폜�Ɏ��s�����ꍇ
		If Ret <> True Then
			strArrMessage = Array("�Z�b�g�O�������ׂ̍폜�Ɏ��s���܂����B")
'			Err.Raise 1000, , "�Z�b�g�O�������ׂ��폜�ł��܂���B�i�\��No�@= " & lngRsvNo & "-" & vntPriceSeq(lngRecord) &" )"
			Exit Do
		Else
			'�G���[���Ȃ���ΌĂь���ʂ������[�h���Ď��g�����
			strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
			strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
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
		If strLineName = "" Then 
			.AppendArray vntArrMessage, "�����ڍז������͂���Ă��܂���B"
		End If
		.AppendArray vntArrMessage, .CheckWideValue("�����ڍז�", strLineName, 40)
		.AppendArray vntArrMessage, objPerBill.CheckNumeric("�������z", lngPrice, 7)
		.AppendArray vntArrMessage, objPerBill.CheckNumeric("�������z", lngEditPrice, 7)
		.AppendArray vntArrMessage, objPerBill.CheckNumeric("�����", lngTaxPrice, 7)
		.AppendArray vntArrMessage, objPerBill.CheckNumeric("�����Ŋz", lngEditTax, 7)
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
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�Z�b�g�O�������דo�^�E�C��</TITLE>
<SCRIPT TYPE="text/javascript">
<!--

var winGuideOther;			// �E�B���h�E�n���h��
var Other_divCd;			// �Z�b�g�O���������׃R�[�h
var Other_divName;			// �Z�b�g�O���������ז�
var Other_lineName;			// ���������ז�
var Other_Price;			// �W���P��
var Other_TaxPrice;			// �W���Ŋz

function showOtherIncomeWindow( divCd, divName, price, taxPrice, lineName ) {

	var objForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g

	var url;			// URL������
	var opened = false;	// ��ʂ����łɊJ����Ă��邩

	// �K�C�h�Ƃ̘A���p�ϐ��ɃG�������g��ݒ�
	Other_divCd     = divCd;
	Other_divName   = divName;
	Other_lineName  = lineName;
	Other_Price     = price;
	Other_TaxPrice  = taxPrice;

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winGuideOther != null ) {
		if ( !winGuideOther.closed ) {
			opened = true;
		}
	}

	url = '/WebHains/contents/perbill/gdeOtherIncome.asp'

	// �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winGuideOther.focus();
		winGuideOther.location.replace( url );
	} else {
// ## 2003.12.20 Mod By T.Takagi@FSIT
//		winGuidOther = window.open( url, '', 'width=400,height=370,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
		winGuidOther = window.open( url, '', 'width=400,height=450,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
// ## 2003.12.20 Mod End
	}
}

// �Z�b�g�O�������׏��ҏW�p�֐�
function setDivInfo( divCd, divName, price, taxPrice ) {

	// �Z�b�g�O�������׃R�[�h�̕ҏW
	if ( Other_divCd ) {
		Other_divCd.value = divCd;
	}

	// �Z�b�g�O�������ז��̕ҏW
	if ( Other_divName ) {
		Other_divName.value = divName;
		Other_lineName.value = divName;
	}

	if ( document.getElementById( 'dspdivname' ) ) {
		document.getElementById( 'dspdivname' ).innerHTML = divName;
	}

	// �W�����z�̕ҏW
	if ( Other_Price ) {
		Other_Price.value = price;
	}

	// �W���Ŋz�̕ҏW
	if ( Other_TaxPrice ) {
		Other_TaxPrice.value = taxPrice;
	}

}

// �K�C�h�����
function closeGuideOther() {

	if ( winGuideOther != null ) {
		if ( !winGuideOther.closed ) {
			winGuideOther.close();
		}
	}

	winGuideOther = null;

}
//-->

<!--
//����ŖƏ��`�F�b�N����
function checkOmitTaxFlgAct(datataxprice) {

	with ( document.entryForm ) {
		checkOmitTaxFlg.value = (checkOmitTaxFlg.checked ? '1' : '0');
		edittax.value = (checkOmitTaxFlg.checked ? -1*(datataxprice-0) : edittax.value );
		omitTaxFlg.value = checkOmitTaxFlg.value;
	}
}

function saveData() {

	// ���[�h���w�肵��submit
	document.entryForm.act.value = 'save';
	document.entryForm.submit();

}

// �폜�m�F���b�Z�[�W
function deleteData() {

	if ( !confirm( '���̃Z�b�g�O�������ׂ��폜���܂��B��낵���ł����H' ) ) {
		return;
	}


	// ���[�h���w�肵��submit
	document.entryForm.act.value = 'delete';
	document.entryForm.submit();

}

function windowClose() {

	//�K�C�h�����
	closeGuideOther();
}

//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:windowClose()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">��</SPAN>�Z�b�g�O�������דo�^�E�C��</B></TD>
		</TR>
	</TABLE>
	<!-- ������� -->
	<INPUT TYPE="hidden" NAME="act" VALUE="">
	<INPUT TYPE="hidden" NAME="mode" VALUE="<%= strMode %>">

	<INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="record" VALUE="<%= lngRecord %>">
	<INPUT TYPE="hidden" NAME="divcd" VALUE="<%= strDivCd %>">
	<INPUT TYPE="hidden" NAME="divname" VALUE="<%= strDivName %>">
	<INPUT TYPE="hidden" NAME="orgname" VALUE="<%= strOrgName %>">

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

		End Select

	End If
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD NOWRAP>������</TD>
			<TD>�F</TD>
			<TD>�l��f</TD>
		</TR>

		<TR>
			<TD NOWRAP >�Z�b�g�O�������ז�</TD>
			<TD>�F</TD>
			<TD>
				<TABLE WIDTH="100" BORDER="0" CELLSPACING="1" CELLPADDING="0">
					<TR>
						<TD NOWRAP ><A HREF="javascript:showOtherIncomeWindow(document.entryForm.divcd, document.entryForm.divname, document.entryForm.price, document.entryForm.taxprice, document.entryForm.linename )" ><IMG SRC="../../images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="�Z�b�g�O�������׈ꗗ�\��"></A></TD>
						<TD NOWRAP ><SPAN ID="dspdivname"><%= strDivName %></SPAN></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP >�������ז�</TD>
			<TD>�F</TD>
			<TD>
				<TABLE WIDTH="120" BORDER="0" CELLSPACING="1" CELLPADDING="0">
					<TR>
						<TD NOWRAP ><INPUT TYPE="text" NAME="linename" VALUE="<%= strLineName %>" SIZE="40" MAXLENGTH="20"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
<!-- KMT
		<TR>
			<TD NOWRAP>�������ז�</TD>
			<TD>�F</TD>
			<TD>
				<TABLE WIDTH="120" BORDER="0" CELLSPACING="1" CELLPADDING="0">
					<TR>
						<TD><A HREF="javascript:showOtherIncomeWindow(document.entryForm.divcd, document.entryForm.linename, document.entryForm.price, document.entryForm.taxprice )" ><IMG SRC="../../images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="�Z�b�g�O�������׈ꗗ�\��"></A></TD>
						<TD><INPUT TYPE="text" NAME="linename" VALUE="<%= strLineName %>" SIZE="40" MAXLENGTH="20"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
-->
		<TR>
			<TD NOWRAP>�������z</TD>
			<TD>�F</TD>
			<TD><INPUT TYPE="text" NAME="price" VALUE="<%= lngPrice %>" SIZE="10" MAXLENGTH="7"></TD>
		</TR>
		<TR>
			<TD NOWRAP>�������z</TD>
			<TD>�F</TD>
			<TD><INPUT TYPE="text" NAME="editprice" VALUE="<%= lngEditPrice %>" SIZE="10" MAXLENGTH="7"></TD>
		</TR>
		<TR>
			<TD NOWRAP>�����</TD>
			<TD>�F</TD>
			<TD><INPUT TYPE="text" NAME="taxprice" VALUE="<%= lngTaxPrice %>" SIZE="10" MAXLENGTH="7"></TD>
		</TR>
		<TR>
			<TD NOWRAP>�����Ŋz</TD>
			<TD>�F</TD>
			<TD><INPUT TYPE="text" NAME="edittax" VALUE="<%= lngEditTax %>" SIZE="10" MAXLENGTH="7"></TD>
		</TR>
		<TR>
			<TD WIDTH="114"><INPUT TYPE="checkbox" NAME="checkOmitTaxFlg" VALUE="1" <%= IIf(lngOmitTaxFlg <> 0, " CHECKED", "") %>  ONCLICK="javascript:checkOmitTaxFlgAct(<%= lngTaxPrice %>)" border="0">����ŖƏ�</TD>
			<INPUT TYPE="hidden" NAME="omitTaxFlg" VALUE="<%= lngOmitTaxFlg %>">
		</TR>
	</TABLE>
	<BR>
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD NOWRAP><A HREF="javascript:saveData()"><IMG SRC="../../images/ok.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="���̓��e�Ŋm��"></A></TD>
			<TD>&nbsp;</TD>
			<TD NOWRAP><A HREF="javascript:close()"><IMG SRC="../../images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="�L�����Z������"></A></TD>
<%
	'���S�����l�Ŗ����̏ꍇ�́A�폜�{�^���\��
	If (( vntOrgCd1(lngRecord) = "XXXXX" ) AND (vntOrgCd2(lngRecord) = "XXXXX")) Then
		If (vntPaymentDate_m(lngRecord) = "") AND (vntPaymentSeq_m(lngRecord) = "") Then 
%>
			<TD ALIGN="right" WIDTH="100%"><A HREF="javascript:deleteData()"><IMG SRC="../../images/delete.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="�Z�b�g�O�������ׂ��폜���܂�"></A></TD>
<%
		End If
	End If
%>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>
