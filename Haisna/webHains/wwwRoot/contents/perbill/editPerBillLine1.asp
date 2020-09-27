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
Dim objPerbill				'��f���A�N�Z�X�p

Dim Ret						'�֐��߂�l

Dim lngCount				'�擾����
Dim lngRsvNo				'�\��ԍ�
Dim lngRecord				'���R�[�h�ԍ�

Dim strLineName				'�Z�b�g�O�������ז���
'Dim lngPrice				'���z
Dim lngEditPrice			'�������z
'Dim lngTaxPrice				'�Ŋz
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

Dim strDivCd				'�Z�b�g�O�������׃R�[�h
Dim strSetName				'�Ή��Z�b�g����


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

lngEditPrice   = Request("editprice")
'lngTaxPrice   = Request("taxprice")
lngEditTax     = Request("edittax")
strLineName    = Request("linename")
lngRsvNo       = Request("rsvno")
strDivCd       = Request("divcd")
lngRecord      = Request("record")
strSetName     = Request("setname")
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
												, , vntOmitTaxFlg )
	'��f���z��񂪑��݂��Ȃ��ꍇ
	If lngCount < 1 Then
		Exit Do
	End If

	If strMode = "init" Then
		'�����\���ݒ�
		If strLineName = "" Then strLineName = vntLineName(lngRecord)
		If lngEditPrice = "" Then lngEditPrice = vntEditPrice(lngRecord)
		If lngEditTax = "" Then lngEditTax = vntEditTax(lngRecord)
		If lngOmitTaxFlg = "" Then lngOmitTaxFlg = vntOmitTaxFlg(lngRecord)
		strMode = "initend"
	End If

	'�Ή��Z�b�g���ۑ�����B
	If strSetName = "" Then strSetName = vntLineName(lngRecord)


	'�m��{�^���������A�ۑ��������s
	If strAction = "save" Then
'KMT
'Err.Raise 1000, , "vntPrice= " & vntPrice(lngRecord)

		If lngEditPrice = "" OR IsNull(lngEditPrice) Then lngEditPrice = 0
		If lngEditTax = "" OR IsNull(lngEditTax) Then lngEditTax = 0

		'���̓`�F�b�N
		strArrMessage = CheckValue()
		If Not IsEmpty(strArrMessage) Then
			Exit Do
		End If

		'��f�m����z���A�l�������׏��̓o�^
		Ret = objPerbill.UpdatePerBill_c(vntDmdDate(lngRecord), _
											IIf( vntBillSeq(lngRecord)="", 0, vntBillSeq(lngRecord)), _
											IIf( vntBranchNo(lngRecord)="",0, vntBranchNo(lngRecord)), _
											IIf( vntBillLineNo(lngRecord)="", 0, vntBillLineNo(lngRecord)), _
											vntPrice(lngRecord), _
											lngEditPrice, _
											vntTaxPrice(lngRecord), _
											lngEditTax, _
											IIf( strSetName = strLineName, "", strLineName), _
											lngRsvNo, _
											vntPriceSeq(lngRecord), _
											lngOmitTaxFlg, _
											vntOtherLineDivCd(lngRecord)  )

		'�ۑ��Ɏ��s�����ꍇ
		If Ret <> True Then
			strArrMessage = Array("�������ׂ̍X�V�Ɏ��s���܂����B")
'			Err.Raise 1000, , "�������ׂ��X�V�ł��܂���B�i������No�@= " & objCommon.FormatString(strDmdDate, "yyyymmdd") & objCommon.FormatString(lngBillSeq, "00000") & lngBranchNo &" )"
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
'		.AppendArray vntArrMessage, .CheckNumeric("�������z", lngPrice, 7)
		.AppendArray vntArrMessage, objPerBill.CheckNumeric("�������z", lngEditPrice, 7)
'		.AppendArray vntArrMessage, .CheckNumeric("�����", lngTaxPrice, 7)
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
<TITLE>�������דo�^�E�C��</TITLE>
<SCRIPT TYPE="text/javascript">
<!--

//����ŖƏ��`�F�b�N����
function checkOmitTaxFlgAct(taxprice) {

	with ( document.entryForm ) {
		checkOmitTaxFlg.value = (checkOmitTaxFlg.checked ? '1' : '0');
		edittax.value = (checkOmitTaxFlg.checked ? -1*(taxprice-0) : edittax.value );
		omitTaxFlg.value = checkOmitTaxFlg.value;
	}

}

//�ۑ�
function saveData() {

	// ���[�h���w�肵��submit
	document.entryForm.act.value = 'save';
	document.entryForm.submit();

}


//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">��</SPAN>�������דo�^�E�C��</B></TD>
		</TR>
	</TABLE>
	<!-- ������� -->
	<INPUT TYPE="hidden" NAME="act" VALUE="">
	<INPUT TYPE="hidden" NAME="mode" VALUE="<%= strMode %>">

	<INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="record" VALUE="<%= lngRecord %>">
	<INPUT TYPE="hidden" NAME="divcd" VALUE="<%= strDivCd %>">
	<INPUT TYPE="hidden" NAME="setname" VALUE="<%= strSetName %>">


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
			<TD NOWRAP>���S��</TD>
			<TD>�F</TD>
			<TD NOWRAP><%= vntOrgName(lngRecord) %></TD>
		</TR>
		<TR>
			<TD NOWRAP>�Ή��Z�b�g�R�[�h</TD>
			<TD>�F</TD>
<%
			If vntOptCd(lngRecord) <> "" Then
%>
				<TD NOWRAP><%= vntOptCd(lngRecord) & "-" & vntOptBranchNo(lngRecord) %></TD>
<%
			Else
%>
				<TD NOWRAP ALIGN="RIGHT"></TD>
<%
			End If
%>
		</TR>
		<TR>
			<TD NOWRAP>�Ή��Z�b�g��</TD>
			<TD>�F</TD>
			<TD><%= vntOptName(lngRecord) %></TD>
		</TR>
		<TR>
			<TD NOWRAP>�������ז�</TD>
			<TD>�F</TD>
			<TD>
				<TABLE WIDTH="120" BORDER="0" CELLSPACING="1" CELLPADDING="0">
					<TR>
						<TD><INPUT TYPE="text" NAME="linename" VALUE="<%= strLineName %>" SIZE="40" MAXLENGTH="20"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>�������z</TD>
			<TD>�F</TD>
			<TD NOWRAP><%= FormatCurrency(vntPrice(lngRecord)) %></TD>
		</TR>
		<TR>
			<TD NOWRAP>�������z</TD>
			<TD>�F</TD>
			<TD><INPUT TYPE="text" NAME="editprice" VALUE="<%= lngEditPrice %>" SIZE="10" MAXLENGTH="7"></TD>
		</TR>
		<TR>
			<TD NOWRAP>�����</TD>
			<TD>�F</TD>
			<TD NOWRAP><%= FormatCurrency(vntTaxPrice(lngRecord)) %></TD>
		</TR>
		<TR>
			<TD NOWRAP>�����Ŋz</TD>
			<TD>�F</TD>
			<TD><INPUT TYPE="text" NAME="edittax" VALUE="<%= lngEditTax %>" SIZE="10" MAXLENGTH="7"></TD>
		</TR>
		<TR>
			<TD NOWRAP><INPUT TYPE="checkbox" NAME="checkOmitTaxFlg" VALUE="1" <%= IIf(lngOmitTaxFlg <> 0, " CHECKED", "") %>  ONCLICK="javascript:checkOmitTaxFlgAct(<%= vntTaxPrice(lngRecord) %>)" border="0">����ŖƏ�</TD>
			<INPUT TYPE="hidden" NAME="omitTaxFlg" VALUE="<%= lngOmitTaxFlg %>">
		</TR>
	</TABLE>
	<BR>
	
    <% if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then %>
        <A HREF="javascript:saveData()"><IMG SRC="../../images/ok.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="���̓��e�Ŋm��"></A>
	<% End If %>
    
    <A HREF="javascript:close()"><IMG SRC="../../images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="�L�����Z������"></A></TD>
</FORM>
</BODY>
</HTML>
