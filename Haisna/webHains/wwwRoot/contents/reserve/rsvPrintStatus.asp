<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		����󋵊m�F (Ver0.0.1)
'		AUTHER  : Tsutomu Ishida@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checksession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/EditIsrDivList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim blnOpAnchor			'����p�A���J�[����
Dim dtmCardPrintDate	'�m�F�͂����o�͓���
Dim dtmFormPrintDate	'�ꎮ�����o����
Dim objCommon			'���ʃA�N�Z�X�p
Dim objConsult			'��f���A�N�Z�X�p
Dim strAction			'�������(�ۑ��{�^��������:"save")
Dim strRsvNo			'�\��ԍ���
Dim strHTML				'���z�y�[�W


'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objConsult = Server.CreateObject("HainsConsult.Consult")

'���ʃN���X�̃C���X�^���X�쐬
Set objCommon = Server.CreateObject("HainsCommon.Common")

'�����l�̎擾
strAction        = Request("act")
dtmCardPrintDate = Request("CardPrintDate")
dtmFormPrintDate = Request("FormPrintDate")
strRsvNo         = Request("rsvNo")

'�Ǎ��ݏ����̐���
Do
'�ۑ��{�^��������
	If strAction = "save" Then
		'��f���e�[�u�����R�[�h�X�V
		objConsult.UpdateConsultPrintStatus strRsvNo, dtmCardPrintDate, dtmFormPrintDate
		'�G���[���Ȃ���Ύ��g�����
		strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
'## 2003.01.13 Mod By T.Takagi �ۑ������������@�ύX
		'�ۑ����e��\����ڍ׉�ʂɕԂ��A���ۑ������������s��
'		strHTML = strHTML & "<BODY ONLOAD=""javascript:close()"">"
'		strHTML = strHTML & "</BODY>"
'		strHTML = strHTML & "</HTML>"
		strHTML = strHTML & vbCrLf & "<SCRIPT TYPE=""text/javascript"">"
		strHTML = strHTML & vbCrLf & "<!--"
		strHTML = strHTML & vbCrLf & "if ( opener ) {"
		strHTML = strHTML & vbCrLf & "    if ( opener.top ) {"
		strHTML = strHTML & vbCrLf & "        if ( opener.top.cardPrinted != null ) {"
		strHTML = strHTML & vbCrLf & "            opener.top.cardPrinted = " & IIf(dtmCardPrintDate <> "", "true", "false") & ";"
		strHTML = strHTML & vbCrLf & "        }"
		strHTML = strHTML & vbCrLf & "        if ( opener.top.formPrinted != null ) {"
		strHTML = strHTML & vbCrLf & "            opener.top.formPrinted = " & IIf(dtmFormPrintDate <> "", "true", "false") & ";"
		strHTML = strHTML & vbCrLf & "        }"
		strHTML = strHTML & vbCrLf & "        if ( opener.top.controlPrtOnSave != null ) {"
		strHTML = strHTML & vbCrLf & "            opener.top.controlPrtOnSave();"
		strHTML = strHTML & vbCrLf & "        }"
		strHTML = strHTML & vbCrLf & "    }"
		strHTML = strHTML & vbCrLf & "}"
		strHTML = strHTML & vbCrLf & "close();"
		strHTML = strHTML & vbCrLf & "//-->"
		strHTML = strHTML & vbCrLf & "</SCRIPT>"
		strHTML = strHTML & vbCrLf & "</HTML>"
'## 2003.01.13 Mod End
		Response.Write strHTML
		Response.End
	End If
	'��f���e�[�u�����R�[�h�Ǎ��ݏ���
	objConsult.SelectConsultPrintStatus strRsvNo, dtmCardPrintDate, dtmFormPrintDate
	Exit Do
Loop
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>����󋵊m�F</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// ��������̕ۑ�
function saveData() {
	
	document.entryForm.act.value = 'save';
	document.entryForm.submit();
}

// ��������̃N���A
 function ClearDate(updating) {

	// ��������̃N���A
	document.getElementById(updating).innerHTML = '<FONT COLOR="#999999">���o��</FONT>';
	
	if (updating == 'dspCardPrintDate') {
		document.entryForm.CardPrintDate.value = '';		//�m�F�͂����o�͓�����NULL�ɂ���
	} else if (updating == 'dspFormPrintDate') {
		document.entryForm.FormPrintDate.value = '';	//�ꎮ�����o�͓�����NULL�ɂ���
	}
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<INPUT TYPE="hidden" NAME="act" VALUE="">
	<INPUT TYPE="hidden" NAME="CardPrintDate" VALUE="<%= dtmCardPrintDate %>">
	<INPUT TYPE="hidden" NAME="FormPrintDate" VALUE="<%= dtmFormPrintDate %>">
	<INPUT TYPE="hidden" NAME="rsvNo" VALUE="<%= strRsvNo %>">
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000">�����</FONT></B></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="0">
		<TR>
			<TD HEIGHT="8"></TD>
		</TR>
		<TR>
			<TD NOWRAP>�m�F�͂����o��</TD>
			<TD>�F</TD>
<%
		If dtmCardPrintDate = "" Then
%>
			<TD WIDTH="160"><SPAN ID="dspCardPrintDate"><FONT COLOR="#999999">���o��</FONT></SPAN></TD>
			<TD WIDTH="50" ALIGN="right" NOWRAP><A HREF="javascript:ClearDate('dspCardPrintDate')">�N���A</A></TD>
<%
		Else
%>
			<TD WIDTH="160"><SPAN ID="dspCardPrintDate"><%= objcommon.FormatString(dtmCardPrintDate,"yyyy�Nmm��dd�� hh:nn:ss") %></SPAN></TD>
			<TD WIDTH="50" ALIGN="right" NOWRAP><A HREF="javascript:ClearDate('dspCardPrintDate')">�N���A<ALT="�ݒ肵���l���N���A"></A></TD>
<%
		End If
%>
		</TR>
		<TR>
			<TD HEIGHT="21" NOWRAP>�ꎮ�����o��</TD>
			<TD>�F</TD>
<%
		If dtmFormPrintDate = "" Then
%>
			<TD WIDTH="160"><SPAN ID="dspFormPrintDate"><FONT COLOR="#999999">���o��</FONT></SPAN></TD>
			<TD WIDTH="50" ALIGN="right" NOWRAP><A HREF="javascript:ClearDate('dspFormPrintDate')">�N���A<ALT="�ݒ肵���l���N���A"></A></TD>
<%
		Else
%>			
			<TD NOWRAP><SPAN ID="dspFormPrintDate"><%= objcommon.FormatString(dtmFormPrintDate,"yyyy�Nmm��dd�� hh:nn:ss") %></SPAN></TD>
			<TD WIDTH="50" ALIGN="right" NOWRAP><A HREF="javascript:ClearDate('dspFormPrintDate')">�N���A</A></TD>
<%
		End If
%>
		</TR>
	</TABLE>
	<BR>
	<%  If Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" Then   %>
        <A HREF="javascript:saveData()"><IMG SRC="../../images/save.gif" WIDTH="77" HEIGHT="24" ALT="�ύX�������e��ۑ����܂�" BORDER="0"></A>
	<%  End IF  %>
    <A HREF="javascript:close()"><IMG SRC="../../images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z�����܂�" BORDER="0"></A></TD>
</FORM>
</BODY>
</HTML>