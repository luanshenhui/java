<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		���̓K�C�h (Ver0.0.1)
'		AUTHER  : Miyoshi Jun@takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objSecondBill	'�Q���������׏��A�N�Z�X�p

'�p�����[�^
Dim strItemCd			'�������ڃR�[�h
Dim lngItemType			'���ڃ^�C�v
Dim strStcClassCd		'���͕��ރR�[�h

'���͕���
Dim strArrSecondLineDivCd	'�Q���������׃R�[�h
Dim strArrSecondLineDivName	'�Q���������ז�
Dim strArrstdPrice		'�W���P��
Dim strArrstdTax		'�W���Ŋz

'����
Dim strStcCd			'���̓R�[�h
Dim strShortStc			'������
Dim lngCount			'���R�[�h����

Dim i					'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objSecondBill = Server.CreateObject("HainsSecondBill.SecondBill")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�Q���������׃K�C�h</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// �Q���������׃R�[�h�E�Q���������ז��̃Z�b�g
function selectList( index ) {

	// �Ăь��E�B���h�E�����݂��Ȃ���Ή������Ȃ�
	if ( opener == null ) {
		return false;
	}

	// �e��ʂ̘A����ɑ΂��A�Q���������׃R�[�h�E�Q���������ז���ҏW(���X�g���P���̏ꍇ�ƕ����̏ꍇ�Ƃŏ�����U�蕪��)

	// �Q���������׃R�[�h
	if ( opener.secondLineDivGuide_SecondLineDivCd != null ) {
		if ( document.secondLineDivList.secondLineDivCd.length != null ) {
			opener.secondLineDivGuide_SecondLineDivCd = document.secondLineDivList.secondLineDivCd[ index ].value;
		} else {
			opener.secondLineDivGuide_SecondLineDivCd = document.secondLineDivList.secondLineDivCd.value;
		}
	}

	// ������
	if ( opener.secondLineDivGuide_SecondLineDivName != null ) {
		if ( document.secondLineDivList.secondLineDivName.length != null ) {
			opener.secondLineDivGuide_SecondLineDivName = document.secondLineDivList.secondLineDivName[ index ].value;
		} else {
			opener.secondLineDivGuide_SecondLineDivName = document.secondLineDivList.secondLineDivName.value;
		}	
	}

	// �W���P��
	if ( opener.secondLineDivGuide_stdPrice != null ) {
		if ( document.secondLineDivList.stdPrice.length != null ) {
			opener.secondLineDivGuide_stdPrice = document.secondLineDivList.stdPrice[ index ].value;
		} else {
			opener.secondLineDivGuide_stdPrice = document.secondLineDivList.stdPrice.value;
		}	
	}

	// �W���Ŋz
	if ( opener.secondLineDivGuide_stdTax != null ) {
		if ( document.secondLineDivList.stdTax.length != null ) {
			opener.secondLineDivGuide_stdTax = document.secondLineDivList.stdTax[ index ].value;
		} else {
			opener.secondLineDivGuide_stdTax = document.secondLineDivList.stdTax.value;
		}	
	}

	// �A����ɐݒ肳��Ă���e��ʂ̊֐��Ăяo��
//	if ( opener.secondLineDivGuide_CalledFunction != null ) {
		opener.secondLineDivGuide_CalledFunction();
//	}

	opener.winGuideStc = null;
	close();

	return false;
}
//-->
</SCRIPT>
</HEAD>
<BODY BGCOLOR="#ffffff">

<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">

	�Q���������ז���I�����Ă��������B<BR><BR>
	<BR>
</FORM>
<FORM NAME="secondLineDivList" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="100%">
		<TR BGCOLOR="#cccccc" ALIGN="center">
			<TD NOWRAP>�R�[�h</TD>
			<TD NOWRAP>����</TD>
			<TD NOWRAP>���z</TD>
			<TD NOWRAP>�Ŋz</TD>
		</TR>
<%
		'�Q���������׈ꗗ�̕ҏW
		lngCount = objSecondBill.SelectSecondLineDiv(strArrSecondLineDivCd, strArrSecondLineDivName, strArrstdPrice, strArrstdTax)

		'���͂̕ҏW�J�n
		For i = 0 To lngCount - 1
%>
			<TR BGCOLOR="<%= IIf(i Mod 2 = 0, "#ffffff", "#eeeeee") %>">
				<TD><INPUT TYPE="hidden" NAME="secondLineDivCd" VALUE="<%= strArrSecondLineDivCd(i) %>"><%= strArrSecondLineDivCd(i) %></TD>
				<TD><INPUT TYPE="hidden" NAME="secondLineDivName" VALUE="<%= strArrSecondLineDivName(i) %>"><A HREF="javascript:function voi(){};voi()" ONCLICK="selectList(<%= i %>)" CLASS="guideItem"><%= strArrSecondLineDivName(i) %></A></TD>
				<TD><INPUT TYPE="hidden" NAME="stdPrice" VALUE="<%= strArrstdPrice(i) %>"><%= FormatCurrency(strArrstdPrice(i)) %></TD>
				<TD><INPUT TYPE="hidden" NAME="stdTax" VALUE="<%= strArrstdTax(i) %>"><%= FormatCurrency(strArrstdTax(i)) %></TD>
			</TR>
<%
		Next
%>
		<TR BGCOLOR="#ffffff" HEIGHT="40">
			<TD COLSPAN="2" ALIGN="right" VALIGN="bottom">
				<A HREF="javascript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z������"></A>
			</TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>
