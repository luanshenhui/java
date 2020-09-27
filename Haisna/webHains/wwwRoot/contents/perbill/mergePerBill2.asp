<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   ���������������i�����m�F�j (Ver0.0.1)
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

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objPerBill			'��v���A�N�Z�X�p
Dim objHainsUser		'���[�U���A�N�Z�X�p
Dim objPerson			'�l���A�N�Z�X�p

'Dim strMode			'�������[�h(�\��:"disp"�A�m��:"save")
Dim strAction			'�������(�ۑ��{�^��������:"save"�A�ۑ�������:"saveend")

Dim strHTML			'

Dim vntPerID			'�l�h�c
Dim vntDmdDate     		'������
Dim vntBillSeq     		'�������r����
Dim vntBranchNo     		'�������}��

Dim strUpdDate			'�X�V���t
Dim strUpdUser        		'�X�V��



Dim lngBillCnt			'�w�萿������

'�I��p
Dim arrDmdDate     		'������ �z��
Dim arrBillSeq     		'�������r���� �z��
Dim arrBranchNo     		'�������}�� �z��
Dim arrPerID			'�l�h�c �z��
Dim arrLastName			'�� �z��
Dim arrFirstName		'�� �z��
Dim arrLastKName		'�J�i�� �z��
Dim arrFirstKName		'�J�i�� �z��
Dim arrPrice     		'���z �z��
Dim arrEditPrice     		'�������z �z��
Dim arrTaxPrice     		'�Ŋz �z��
Dim arrEditTax     		'�����Ŋz �z��
Dim arrPriceTotal     		'�������z���v �z��

Dim vntBillLineNo		'�������׍s�m��
Dim vntPrice			'���z
Dim vntEditPrice		'�������z
Dim vntTaxPrice			'�Ŋz
Dim vntEditTax			'�����Ŋz
Dim vntCtrPtCd			'�_��p�^�[���R�[�h
Dim vntOptCd			'�I�v�V�����R�[�h
Dim vntOptBranchNo		'�I�v�V�����}��
Dim vntRsvNo			'�\��ԍ�
Dim vntPriceSeq			'��f���z�r����
Dim vntLineName			'���ז���
Dim vntOtherLineDivCd		'�Z�b�g�O���׃R�[�h

Dim i				'�J�E���^
Dim j				'�J�E���^

Dim Ret				'�֐��߂�l


'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objHainsUser    = Server.CreateObject("HainsHainsUser.HainsUser")
Set objPerBill      = Server.CreateObject("HainsPerBill.PerBill")
Set objPerson       = Server.CreateObject("HainsPerson.Person")

'�����l�̎擾
'strMode           = Request("mode")
strAction         = Request("act")
vntPerId          = Request("perId")
vntDmdDate        = Request("dmdDate")
vntBillSeq        = Request("billSeq")
vntBranchNo       = Request("branchNo")

arrPerId       = ConvIStringToArray(Request("arrperId"))
'arrLastName       = ConvIStringToArray(Request("lastName"))
'arrFirstName       = ConvIStringToArray(Request("firstName"))
'arrLastKName       = ConvIStringToArray(Request("lastKName"))
'arrFirstKName       = ConvIStringToArray(Request("firstKName"))
arrDmdDate       = ConvIStringToArray(Request("arrdmdDate"))
arrBillSeq       = ConvIStringToArray(Request("arrbillSeq"))
arrBranchNo       = ConvIStringToArray(Request("arrbranchNo"))

'arrPrice     = ConvIStringToArray(Request("price"))
'arrEditPrice     = ConvIStringToArray(Request("editPrice"))
'arrTaxPrice     = ConvIStringToArray(Request("taxPrice"))
'arrEditTax     = ConvIStringToArray(Request("editTax"))
'arrPriceTotal     = ConvIStringToArray(Request("priceTotal"))

strUpdDate	  = Request("updDate")
strUpdUser        = Session.Contents("userId")

'lngBillCnt       = Request("billcnt")

'�����l�ݒ�
lngBillCnt   = IIf(IsNumeric(lngBillCnt) = False, 0,  lngBillCnt )
'strMode   = IIf(strMode = "", "init",  strMode )


'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do


	arrPerId = Split(vntPerId,",")
	arrDmdDate = Split(vntDmdDate,",")
	arrBillSeq = Split(vntBillSeq,",")
	arrBranchNo = Split(vntBranchNo,",")

	arrLastName = Array()
	Redim Preserve arrLastName(UBound(arrPerId))
	arrFirstName = Array()
	Redim Preserve arrFirstName(UBound(arrPerId))
	arrLastKName = Array()
	Redim Preserve arrLastKName(UBound(arrPerId))
	arrFirstKName = Array()
	Redim Preserve arrFirstKName(UBound(arrPerId))
	arrPrice = Array()
	Redim Preserve arrPrice(UBound(arrPerId))
	arrEditPrice = Array()
	Redim Preserve arrEditPrice(UBound(arrPerId))
	arrTaxPrice = Array()
	Redim Preserve arrTaxPrice(UBound(arrPerId))
	arrEditTax = Array()
	Redim Preserve arrEditTax(UBound(arrPerId))
	arrPriceTotal = Array()
	Redim Preserve arrPriceTotal(UBound(arrPerId))

	For i = 0 To UBound(arrPerId)
		
		If arrPerId(i) <> Empty  Then
			'�l�h�c��莁�����擾����
			Ret = objPerson.SelectPerson_lukes(arrPerId(i), _
							arrLastName(i), _
							arrFirstName(i), _
							arrLastKName(i), _
							arrFirstKName(i) )
			'�l��񂪑��݂��Ȃ��ꍇ
			If Ret = False Then
				Err.Raise 1000, , "�l��񂪎擾�ł��܂���B�i�l�h�c�@= " & arrPerId(i) &" �j"
			End If

			'�������m������l�������Ǘ������擾����
			Ret = objPerbill.SelectPerBill_BillNo (arrDmdDate(i), _
						   arrBillSeq(i), _
						   arrBranchNo(i), _
						   , _
						   , _
						   , _
						   , _
						   , _
						   , _
						   , _
						   arrPrice(i), _
						   arrEditPrice(i), _
						   arrTaxPrice(i), _
						   arrEditTax(i), _
						   arrPriceTotal(i) )
			'�l��񂪑��݂��Ȃ��ꍇ
'			If Ret = False Then
'				Err.Raise 1000, , "��������񂪎擾�ł��܂���B�i������No�@= " & objCommon.FormatString(arrDmdDate(i), "yyyymmdd") & objCommon.FormatString(arrBillSeq(i), "00000") & arrBranchNo(i) &" �j"
'			End If
		End If
	Next

	'�m��{�^��������
	If strAction = "save" Then
		
		For i = 1 To UBound(arrPerId)
			If arrPerId(i) <> Empty  Then

				'�����������������s��
				Ret = objPerbill.MergePerBill(arrDmdDate(0), _
								arrBillSeq(0), _
								arrBranchNo(0), _
								arrDmdDate(i), _
								arrBillSeq(i), _
								arrBranchNo(i) _
								) 
				'�X�V�G���[���͏����𔲂���
				If Ret = False Then
					Err.Raise 1000, , "�����������Ɏ��s���܂����B�P"
				End If

				'���̐�������������
				Ret = objPerbill.DeletePerBill( _
								arrDmdDate(i), _
								arrBillSeq(i), _
								arrBranchNo(i), _
								strUpdUser _
								)
				If Ret = False Then
					Err.Raise 1000, , "���̐������̎���Ɏ��s���܂����B"
				End If
			End If
		Next

		'�G���[���Ȃ���ΌĂь���ʂ��ĕ\�����Ď��g�����
		strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
		strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
		strHTML = strHTML & "</BODY>"
		strHTML = strHTML & "</HTML>"
		Response.Write strHTML
		Response.End
		Exit Do
	End If

	Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>������������</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!---
// ����������
function savePerBill() {

	document.entryForm.act.value = 'save';
	document.entryForm.submit();

	return false;
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">��</SPAN>������������</B></TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
	<TR>
		<TD NOWRAP WIDTH="342"><SPAN STYLE="color:#cc9999">��</SPAN>�ȉ��̐������𓝍����܂��B</TD>
		<TD NOWRAP WIDTH="77"><A HREF="javascript:savePerBill()"><IMG SRC="../../images/ok.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="�L�����Z������"></A></TD>
		<TD><A HREF="JavaScript:history.back();"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�߂�" BORDER="0"></A></TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
	<INPUT TYPE="hidden" NAME="act" VALUE="<%= strAction %>">
	<INPUT TYPE="hidden" NAME="perId"  VALUE="<%= vntPerId %>"> 
	<INPUT TYPE="hidden" NAME="dmdDate"  VALUE="<%= vntDmdDate %>"> 
	<INPUT TYPE="hidden" NAME="billSeq"  VALUE="<%= vntBillSeq %>"> 
	<INPUT TYPE="hidden" NAME="branchNo"  VALUE="<%= vntBranchNo %>"> 

	<TR BGCOLOR="#cccccc" ALIGN="right">
		<TD NOWRAP ALIGN="left">�l�h�c</TD>
		<TD NOWRAP ALIGN="left">����</TD>
		<TD NOWRAP>���z</TD>
		<TD NOWRAP>�������z</TD>
		<TD NOWRAP>�Ŋz</TD>
		<TD NOWRAP>�����Ŋz</TD>
		<TD NOWRAP>�������z</TD>
		<TD NOWRAP>������No.</TD>
	</TR>
<%
	For i = 0 To UBound(arrPerId)
%>
		<INPUT TYPE="hidden" NAME="arrperId"  VALUE="<%= arrPerId(i) %>"> 
		<INPUT TYPE="hidden" NAME="arrdmdDate"  VALUE="<%= arrDmdDate(i) %>"> 
		<INPUT TYPE="hidden" NAME="arrbillSeq"  VALUE="<%= arrBillSeq(i) %>"> 
		<INPUT TYPE="hidden" NAME="arrbranchNo"  VALUE="<%= arrBranchNo(i) %>"> 
		<INPUT TYPE="hidden" NAME="lastName"  VALUE="<%= arrLastName(i) %>"> 
		<INPUT TYPE="hidden" NAME="firstName"  VALUE="<%= arrFirstName(i) %>"> 
		<INPUT TYPE="hidden" NAME="lastKName"  VALUE="<%= arrLastKName(i) %>"> 
		<INPUT TYPE="hidden" NAME="firstKName"  VALUE="<%= arrFirstKName(i) %>"> 
		<INPUT TYPE="hidden" NAME="price"  VALUE="<%= arrPrice(i) %>"> 
		<INPUT TYPE="hidden" NAME="editPrice"  VALUE="<%= arrEditPrice(i) %>"> 
		<INPUT TYPE="hidden" NAME="taxPrice"  VALUE="<%= arrTaxPrice(i) %>"> 
		<INPUT TYPE="hidden" NAME="editTax"  VALUE="<%= arrEditTax(i) %>"> 
		<INPUT TYPE="hidden" NAME="priceTotal"  VALUE="<%= arrPriceTotal(i) %>"> 
<%
		If arrPerId(i) <> Empty  Then
%>
			<TR BGCOLOR=#EEEEEE>
				<TD NOWRAP><%= arrPerId(i) %></TD>
				<TD NOWRAP ALIGN="left"><SPAN STYLE="font-size:9px;"><B><%= arrLastKName(i) %></B>�@<B><%= arrFirstKName(i) %></B><BR></SPAN><%= arrLastName(i) %>�@<%= arrFirstName(i) %></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(arrPrice(i)) %></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(arrEditPrice(i)) %></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(arrTaxPrice(i)) %></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(arrEditTax(i)) %></TD>
				<TD NOWRAP ALIGN="RIGHT"><B><%= FormatCurrency(arrPriceTotal(i)) %></B></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= objCommon.FormatString(arrDmdDate(i), "yyyymmdd") & objCommon.FormatString(arrBillSeq(i), "00000") & arrBranchNo(i) %></TD>
			</TR>
<%
		End If
	Next
%>
</TABLE>
</FORM>
</BODY>
</HTML>
