<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �����|�[�g�Ɖ�  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X

'�p�����[�^
Dim lngCslYear			'��f��(�N)
Dim lngCslMonth			'��f��(��)
Dim lngCslDay			'��f��(��)
Dim strCsCd				'�R�[�X�R�[�h
Dim blnNeedUnReceipt	'����t�Ҏ擾�t���O(True:�����h�c�����ԏ�Ԃ��擾)

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon  = Server.CreateObject("HainsCommon.Common")

'�����l�̎擾
lngCslYear			= CLng("0" & Request("cslYear") )
lngCslMonth			= CLng("0" & Request("cslMonth"))
lngCslDay			= CLng("0" & Request("cslDay")  )
strCsCd				= Request("csCd")
blnNeedUnReceipt	= IIf(Request("NeedUnReceipt")="True", True, False)

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�����|�[�g�Ɖ�</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!-- #include virtual = "/webHains/includes/Date.inc"     -->
<!--
// �\��
function callMorningReport() {

	var myForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g
	var url;							// URL������

	// ��f�����̓`�F�b�N
	if ( !isDate( myForm.cslYear.value, myForm.cslMonth.value, myForm.cslDay.value ) ) {
		alert('��f���̌`���Ɍ�肪����܂��B');
		return;
	}

	url = '/WebHains/contents/morningreport/MorningReportMain.asp';
	url = url + '?cslYear=' + myForm.cslYear.value;
	url = url + '&cslMonth=' + myForm.cslMonth.value;
	url = url + '&cslDay=' + myForm.cslDay.value;
	url = url + '&csCd=' + myForm.csCd.value;
	if ( myForm.NeedUnReceipt.checked ) {
		url = url + '&NeedUnReceipt=True';
	} else {
		url = url + '&NeedUnReceipt=False';
	}

	parent.location.href(url);
}
//-->
</SCRIPT>
<style type="text/css">
	td.toujitsutab    { background-color:#ffffff }
	div.maindiv { margin: 10px 10px 0 10px; }
</style>
</HEAD>
<BODY ONUNLOAD="JavaScript:calGuide_closeGuideCalendar()">
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<div class="maindiv">
	<!-- �^�C�g���̕\�� -->
	<TABLE WIDTH="100%" BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD WIDTH="100%">
				<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
					<TR>
						<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000">�����|�[�g�Ɖ�</FONT></B></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
	<!-- �w���f���A�R�[�X�̕\�� -->
	<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
		<TR HEIGHT="25">
			<TD NOWRAP>��f��</TD>
			<TD NOWRAP WIDTH="15">�F</TD>
			<TD>
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="0">
					<TR>
						<TD><A HREF="JavaScript:calGuide_showGuideCalendar('cslYear', 'cslMonth', 'cslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
						<TD><%= EditNumberList("cslYear", YEARRANGE_MIN, YEARRANGE_MAX, lngCslYear, False) %></TD>
						<TD>�N</TD>
						<TD><%= EditNumberList("cslMonth", 1, 12, lngCslMonth, False) %></TD>
						<TD>��</TD>
						<TD><%= EditNumberList("cslDay", 1, 31, lngCslDay, False) %></TD>
						<TD>��</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR HEIGHT="25">
			<TD NOWRAP>�R�[�X</TD>
			<TD NOWRAP WIDTH="15">�F</TD>
			<TD NOWRAP COLSPAN="8">
				<%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd", strCsCd, SELECTED_ALL, False) %>
				<INPUT TYPE="CHECKBOX" NAME="NeedUnReceipt" <%=IIF(blnNeedUnReceipt=True,"CHECKED","") %>>�����h�c�����ԏ�Ԃ̃f�[�^���\���ΏۂƂ���
			</TD>
			<TD><IMG SRC="../../images/spacer.gif" ALT="" HEIGHT="1" WIDTH="30" BORDER="0"></TD>
			<TD NOWRAP><A HREF="JavaScript:callMorningReport()"><IMG SRC="../../images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="�\��"></A></TD>
		</TR>
	</TABLE>

</div>
</FORM>
</BODY>
</HTML>
