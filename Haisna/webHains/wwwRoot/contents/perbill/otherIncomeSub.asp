<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�������������ꗗ�\�� (Ver0.0.1)
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
Dim objPerbill				'��f���A�N�Z�X�p

Dim strDmdDate				'������
Dim lngBillSeq				'�������r����
Dim lngBranchNo				'�������}��

Dim Ret						'�֐��߂�l

'�l���������p�ϐ�
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
Dim vntPrice                '���z
Dim vntEditPrice            '�������z
Dim vntTaxPrice             '�Ŋz
Dim vntEditTax            	'�����Ŋz
Dim vntLineTotal			'���v�i���z�A�������z�A�Ŋz�A�����Ŋz�j


Dim lngCount				'�擾����

Dim lngRsvNo
Dim strLineName				'�Z�b�g�O�������ז���
Dim lngDivCd				'�Z�b�g�O�������׃R�[�h
Dim lngPrice				'���z
Dim lngEditPrice			'�������z
Dim lngTaxPrice				'�Ŋz
Dim lngEditTax				'�����Ŋz

Dim strMode					'�������[�h
Dim strActMode				'���샂�[�h(�ۑ�:"save"�A�ۑ�����:"saved")
Dim strMessage				'�G���[���b�Z�[�W
Dim i						'�C���f�b�N�X
Dim strHTML

Dim vntSubTotal

strMessage = ""

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objPerbill = Server.CreateObject("HainsPerBill.PerBill")

'�����l�̎擾

'strDmdDate     = Request("dmddate")
'lngBillSeq     = Request("billseq")
'lngBranchNo    = Request("branchno")

strActMode     = Request("act")
strMode        = Request("mode")

strLineName    = Request("linename")
lngPrice       = Request("price")
lngEditPrice   = Request("editprice")
lngTaxPrice    = Request("taxprice")
lngEditTax     = Request("edittax")
lngDivCd       = Request("divcd")
lngRsvNo       = Request("rsvno")


Do

	'�\��ԍ�����l�������Ǘ������擾����
	lngCount = objPerbill.SelectPerBill(lngRsvNo, _
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

	'�l��������񂪑��݂��Ȃ��ꍇ
	If lngCount < 1 Then
		Err.Raise 1000, , "�l��������񂪑��݂��܂���B�i�\��ԍ�= " & lngRsvNo & " lngCount= " & lngCount & ")"
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
<TITLE>�������ԍ��I��</TITLE>
<style type="text/css">
	body { margin: 20px 0 0 0; }
	td.prttab  { background-color:#ffffff }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
<BLOCKQUOTE>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">���������ԍ��I��</SPAN></B></TD>
		</TR>
	</TABLE>
	<!-- ������� -->
	<INPUT TYPE="hidden" NAME="act"    VALUE="">
	<INPUT TYPE="hidden" NAME="mode">

	<INPUT TYPE="hidden" NAME="rsvno"     VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="linename"  VALUE="<%= strLineName %>">
	<INPUT TYPE="hidden" NAME="price"     VALUE="<%= lngPrice %>">
	<INPUT TYPE="hidden" NAME="editprice" VALUE="<%= lngEditPrice %>">
	<INPUT TYPE="hidden" NAME="taxprice"  VALUE="<%= lngTaxPrice %>">
	<INPUT TYPE="hidden" NAME="edittax"   VALUE="<%= lngEditTax %>">
	<INPUT TYPE="hidden" NAME="divcd"     VALUE="<%= lngDivCd %>">


	<BR>
	<TR><B>�������m���D��I�����ĉ������B</B></TR>
	<BR>

	<FONT COLOR="black"><SPAN STYLE="color:#cc9999"></SPAN></FONT>
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
		</TR>
<%
	Do

		'�l���S���������̕ҏW
		For i = 0 To lngCount - 1
		If (IsNull(vntPaymentDate(i)) = True) AND (vntDelflg(i) = 0) Then
%>
				<TR BGCOLOR="#EEEEEE">
					<TD NOWRAP ALIGN="left"><A HREF="otherIncomeInfo.asp?linename=<%= strLineName %>&price=<%= lngPrice %>&editPrice=<%= lngEditPrice %>&taxprice=<%= lngTaxPrice %>&edittax=<%= lngEditTax %>&divcd=<%= lngDivCd %>&dmddate=<%= vntDmdDate(i) %>&billseq=<%= vntBillSeq(i) %>&branchno=<%= vntBranchNo(i) %>&rsvno=<%= lngRsvNo %>&act=save">
						<%= objCommon.FormatString(vntDmdDate(i), "yyyymmdd") %>
						<%= objCommon.FormatString(vntBillSeq(i), "00000") %>
						<%= vntBranchNo(i) %></A></TD>
					<TD NOWRAP><%= vntDmdDate(i) %><FONT COLOR="#666666"></FONT></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntPrice(i)) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntEditPrice(i)) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntTaxPrice(i)) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntEditTax(i)) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><B><%= FormatCurrency(vntSubTotal(i)) %></B></TD>
					<TD NOWRAP ALIGN="RIGHT"><B><FONT COLOR="RED"><%= FormatCurrency(vntSubTotal(i)) %></FONT></B></TD>
				</TR>
<%
			End If
		Next
%>
	</TABLE>
<%
		Exit Do
	Loop
%>

	<BR>
<!-- KMT
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD WIDTH="190"></TD>
			<TD WIDTH="5"></TD>
			<TD>
				<A HREF="javascript:close()"><IMG SRC="../../images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="�L�����Z������"></A></TD>
			</TD>
		</TR>
	</TABLE>
-->
</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>

</BODY>
</HTML>
