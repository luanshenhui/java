<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		��t���� (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const MODE_SAVE = "save"	'�������[�h(�ۑ�)

'�����l
Dim strCslYear		'��f�N
Dim strCslMonth 	'��f��
Dim strCslDay		'��f��
Dim lngReceiptMode	'��t�������[�h
Dim lngDayId		'�����h�c

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�����l�̎擾
strCslYear     = Request("cslYear")
strCslMonth    = Request("cslMonth")
strCslDay      = Request("cslDay")
lngReceiptMode = CLng("0" & Request("receiptMode"))
lngDayId       = CLng("0" & Request("dayId"))
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>��t</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
function receipt() {

	with ( opener.top.main.document.entryForm ) {
		cslYear.value     = '<%= strCslYear     %>';
		cslMonth.value    = '<%= strCslMonth    %>';
		cslDay.value      = '<%= strCslDay      %>';
		receiptMode.value = '<%= lngReceiptMode %>';
		dayId.value       = '<%= lngDayId       %>';
	}

	// �\����ڍ׉�ʂ�submit����
	opener.top.submitForm('<%= MODE_SAVE %>');

}
//-->
</SCRIPT>
</HEAD>
<BODY BGCOLOR="#ffffff" ONLOAD="javascript:receipt()">
</BODY>
</HTML>
