<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�Z�b�g�O�������ו\�� (Ver0.0.1)
'		AUTHER  : H.Kamata@FFCS
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
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

Dim objCommon				'���ʃN���X
Dim objPerbill				'��f���A�N�Z�X�p

Dim Ret						'�֐��߂�l
Dim lngRsvNo				'�\��ԍ�
Dim lngCount				'�Z�b�g�O���׌���
Dim lngBillCount			'����������

Dim vntOtherLineDivCd		'�Z�b�g�O�������׃R�[�h
Dim vntOtherLineDivName		'�Z�b�g�O�������ז�
Dim vntStdPrice				'�W���P��
Dim vntStdTax				'�W���Ŋz

Dim strMode					'�������[�h
Dim strAction				'���샂�[�h(�ۑ�:"save"�A�ۑ�����:"saved")
Dim strMessage				'�G���[���b�Z�[�W
Dim i						'�C���f�b�N�X
Dim strHTML
Dim strArrMessage	'�G���[���b�Z�[�W

strMessage = ""

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objPerbill = Server.CreateObject("HainsPerBill.PerBill")

'�����l�̎擾
lngRsvNo     = Request("rsvno")
lngBillCount = Request("billcount")

Do


	'�Z�b�g�O�������׏��̊l��
	lngCount = objPerbill.SelectOtherLineDiv(vntOtherLineDivCd, _
											 vntOtherLineDivName, _
											 vntStdPrice, _
											 vntStdTax )
	'�Z�b�g�O�������׏�񂪑��݂��Ȃ��ꍇ
	If lngCount < 1 Then
		Exit Do
	End If

	Exit Do
Loop
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�Z�b�g�O�������ׂ̑I��</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// �Z�b�g�O�������ׂ̃Z�b�g
function selectList( index ) {

	var objForm;		// ����ʂ̃t�H�[���G�������g
	var divCd;			// �Z�b�g�O���������׃R�[�h
	var divName;		// �Z�b�g�O���������ז�
	var Price;			// �W���P��
	var TaxPrice;		// �W���Ŋz

	objForm = document.entryForm;

	// �Ăь��E�B���h�E�����݂��Ȃ���Ή������Ȃ�
	if ( opener == null ) {
		return;
	}

	// �Z�b�g�O�������׃R�[�h�̎擾
	if ( objForm.divcd.length != null ) {
		divCd  = objForm.divcd[ index ].value;
	} else {
		divCd  = objForm.divcd.value;
	}

	// �Z�b�g�O�������ז��̎擾
	if ( objForm.divname.length != null ) {
		divName = objForm.divname[ index ].value;
	} else {
		divName = objForm.divname.value;
	}

	// �W�����z�̎擾
	if ( objForm.price.length != null ) {
		Price = objForm.price[ index ].value;
	} else {
		Price = objForm.price.value;
	}

	// �W���Ŋz�̎擾
	if ( objForm.taxprice.length != null ) {
		TaxPrice = objForm.taxprice[ index ].value;
	} else {
		TaxPrice = objForm.taxprice.value;
	}

	opener.setDivInfo( divCd, divName, Price, TaxPrice );

	// ��ʂ����
	opener.winGuideOther = null;
	close();

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
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">��</SPAN><FONT COLOR="#000000">�Z�b�g�O�������ׂ̑I��</FONT></B></TD>
		</TR>
	</TABLE>
	<BR>
	<TABLE WIDTH="262" BORDER="0" CELLSPACING="2" CELLPADDING="0">
		<TR ALIGN="right">
			<TD></TD>
			<TD WIDTH="30"></TD>
			<TD WIDTH="70" NOWRAP>���z</TD>
			<TD WIDTH="30"></TD>
			<TD WIDTH="70" NOWRAP>�Ŋz</TD>
		</TR>
<%
	Do
		For i=0 To lngCount - 1
%>
			<INPUT TYPE="hidden" NAME="divcd"    VALUE="<%= vntOtherLineDivCd(i) %>">
			<INPUT TYPE="hidden" NAME="divname" VALUE="<%= vntOtherLineDivName(i) %>">
			<INPUT TYPE="hidden" NAME="price"    VALUE="<%= vntStdPrice(i) %>">
			<INPUT TYPE="hidden" NAME="taxprice" VALUE="<%= vntStdTax(i) %>">
			<TR ALIGN="right">
				<TD NOWRAP ALIGN="left"><A HREF="JavaScript:selectList(<%= i %>)" CLASS="guideItem"><%= vntOtherLineDivName(i) %></A></TD>
				<TD></TD>
				<TD NOWRAP><%= FormatCurrency(vntStdPrice(i)) %></TD>
				<TD></TD>
				<TD NOWRAP><%= FormatCurrency(vntStdTax(i)) %></TD>
			</TR>
<%
		Next

		Exit Do
	Loop

%>
	</TABLE>
</FORM>
</BODY>
</HTML>