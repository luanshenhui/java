<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		��t���� (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"  -->
<%
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const MODE_SAVE         = "save"	'�������[�h(�ۑ�)
Const CALLED_FROMDETAIL = "detail"	'�Ăь����(�\��ڍ�)
Const CALLED_FROMLIST   = "list"	'�Ăь����(��f�҈ꗗ)

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon		'���ʃN���X
Dim objConsult		'��f���A�N�Z�X�p
Dim objCourse		'�R�[�X���A�N�Z�X�p
Dim objPerson		'�l���A�N�Z�X�p

'�����l
Dim strCalledFrom	'�Ăь����("detail":�\��ڍׁA"list":��f�҈ꗗ)
Dim strActMode		'�u�m��v�{�^�����������ꂽ�ꍇ"1"
Dim strRsvNo		'�\��ԍ�
Dim strPerId		'�l�h�c
Dim strCsCd			'�R�[�X�R�[�h
Dim strCslYear		'���݂̎�f�N
Dim strCslMonth 	'���݂̎�f��
Dim strCslDay		'���݂̎�f��
Dim lngCtrPtCd  	'�_��p�^�[���R�[�h
Dim lngMode			'��t���[�h
Dim strUseEmptyId	'�󂫔ԍ����ݎ��ɂ��̔ԍ��Ŋ��蓖�Ă��s���ꍇ"1"
Dim strDayId		'�����h�c

'�l���
Dim strLastName		'��
Dim strFirstName	'��
Dim strLastKName	'�J�i��
Dim strFirstKName	'�J�i��
Dim dtmBirth		'���N����
Dim strGender		'����

Dim lngReceiptMode	'��t�������[�h
Dim lngDayId		'�����h�c
Dim dtmCslDate		'��f��
Dim strCsName		'�R�[�X��
Dim strMessage		'�G���[���b�Z�[�W
Dim strURL			'�W�����v���URL
Dim strHTML			'HTML������
Dim Ret				'�֐��߂�l

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objCourse  = Server.CreateObject("HainsCourse.Course")
Set objPerson  = Server.CreateObject("HainsPerson.Person")

'�����l�̎擾
strCalledFrom = Request("calledFrom")
strActMode    = Request("actMode")
strRsvNo      = Request("rsvNo")
strPerId      = Request("perId")
strCsCd       = Request("csCd")
strCslYear    = Request("cslYear")
strCslMonth   = Request("cslMonth")
strCslDay     = Request("cslDay")
lngCtrPtCd    = CLng("0" & Request("ctrPtCd"))
lngMode       = CLng("0" & Request("mode"))
strUseEmptyId = Request("useEmptyId")
strDayId      = Request("dayId")

'�l���ǂݍ���
If objPerson.SelectPerson_Lukes(strPerId, strLastName, strFirstName, strLastKName, strFirstKName, , dtmBirth, strGender) = False Then
	Err.Raise 1000, , "�l��񂪑��݂��܂���B"
End If

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do

	'�u�m��v�{�^���������ȊO�͉������Ȃ�
	If strActMode = "" Then
		Exit Do
	End If

	'�����h�c�𒼐ڎw�肷��ꍇ
	If lngMode = 1 Then

		'�����h�c�l�̃`�F�b�N
		strMessage = objCommon.CheckNumeric("�����h�c", strDayId, LENGTH_RECEIPT_DAYID, CHECK_NECESSARY)
		If strMessage <> "" Then
			Exit Do
		End If

	End If

	'��t�������[�h�E��t�ԍ��̐ݒ�
	lngReceiptMode = IIf(lngMode =  0, IIf(strUseEmptyId <> "", 2, 1), 3)
	If lngMode = 1 Then
		lngDayId = CLng(strDayId)
	Else
		lngDayId = 0
	End If

	'�\��ڍ׉�ʂ���Ă΂ꂽ�ꍇ
	If strCalledFrom = CALLED_FROMDETAIL Then

		// �e��ʂɎw�肳�ꂽ�l��n���Asubmit���s��
		strHTML = strHTML & "<SCRIPT TYPE=""text/javascript"">" & vbLf
		strHTML = strHTML & "<!--" & vbLf
		strHTML = strHTML & "opener.top.main.document.entryForm.receiptMode.value = '" & lngReceiptMode & "';" & vbLf
		strHTML = strHTML & "opener.top.main.document.entryForm.dayId.value       = '" & lngDayId       & "';" & vbLf
		strHTML = strHTML & "close();" & vbLf
		strHTML = strHTML & "opener.top.submitForm('" & MODE_SAVE & "');" & vbLf
		strHTML = strHTML & "//-->" & vbLf
		strHTML = strHTML & "</SCRIPT>"
		Response.Write strHTML
		Response.End
		Exit Do

	End If

	'��f�҈ꗗ����Ă΂ꂽ�ꍇ
	If strCalledFrom = CALLED_FROMLIST Then

		'��t����
		Set objConsult = Server.CreateObject("HainsConsult.Consult")
		Ret = objConsult.Receipt(strRsvNo, strCslYear, strCslMonth, strCslDay, Session("USERID"), lngReceiptMode, 0, lngDayId, Request.ServerVariables("REMOTE_ADDR"), strMessage)
		If Ret <= 0 Then
			Exit Do
		End If

		'�G���[���Ȃ���Ύ�f�҈ꗗ��ʂ������[�h���Ď��g�����
		strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
		strHTML = strHTML & "<BODY ONLOAD=""JavaScript:if ( opener != null ) opener.location.reload(); close()"">"
		strHTML = strHTML & "</BODY>"
		strHTML = strHTML & "</HTML>"
		Response.Write strHTML
		Response.End

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
<TITLE>��t</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// submit���̏���
function submitForm() {

	document.entryForm.submit();

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 15px 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" ONSUBMIT="JavaScript:return false">

	<INPUT TYPE="hidden" NAME="calledFrom" VALUE="<%= strCalledFrom %>">
	<INPUT TYPE="hidden" NAME="actMode"    VALUE="1">
	<INPUT TYPE="hidden" NAME="rsvNo"      VALUE="<%= strRsvNo    %>">
	<INPUT TYPE="hidden" NAME="perId"      VALUE="<%= strPerId    %>">
	<INPUT TYPE="hidden" NAME="csCd"       VALUE="<%= strCsCd     %>">
	<INPUT TYPE="hidden" NAME="ctrPtCd"    VALUE="<%= lngCtrPtCd  %>">
	<INPUT TYPE="hidden" NAME="cslYear"    VALUE="<%= strCslYear  %>">
	<INPUT TYPE="hidden" NAME="cslMonth"   VALUE="<%= strCslMonth %>">
	<INPUT TYPE="hidden" NAME="cslDay"     VALUE="<%= strCslDay   %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000">��t</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'���b�Z�[�W�̕ҏW
	If strMessage <> "" Then

		EditMessage strMessage, MESSAGETYPE_WARNING
%>
		<BR>
<%
	End If
%>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD><%= strPerId %></TD>
			<TD NOWRAP><B><%= strLastName %>�@<%= strFirstName %></B> �i<FONT SIZE="-1"><%= strLastKName %>�@<%= strFirstKName %></FONT>�j</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD NOWRAP><%= objCommon.FormatString(dtmBirth, "ge.m.d") %>��<IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1"><%= IIf(strGender = CStr(GENDER_MALE), "�j��", "����") %></TD>
		</TR>
	</TABLE>
<%
	'�R�[�X���̓ǂݍ���
	If objCourse.SelectCourse(strCsCd, strCsName) = False Then
		Err.Raise 1000, , "�R�[�X��񂪑��݂��܂���B"
	End If
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD NOWRAP>��f�R�[�X�F</TD>
			<TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCsName %></B></FONT></TD>
		</TR>
	</TABLE>

	<BR><FONT COLOR="#cc9999">��</FONT>&nbsp;�����h�c�̊��蓖�ĕ��@���w�肵�ĉ������B</FONT>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD WIDTH="10"><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1"></TD>
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="0" <%= IIf(lngMode = 0, "CHECKED", "") %>></TD>
			<TD COLSPAN="2">�����h�c�������Ŕ��Ԃ���</TD>
		</TR>
		<TR>
			<TD COLSPAN="2"></TD>
			<TD><INPUT TYPE="checkbox" NAME="useEmptyId" VALUE="1" <%= IIf(strUseEmptyId = "1", "CHECKED", "") %>></TD>
			<TD NOWRAP>�󂫔ԍ������݂���ꍇ�A���̔ԍ��Ŋ��蓖�Ă��s��</TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD WIDTH="10"><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1"></TD>
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="1" <%= IIf(lngMode = 1, "CHECKED", "") %>></TD>
			<TD COLSPAN="2">�����h�c�𒼐ڎw�肷��</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD></TD>
			<TD NOWRAP>�����h�c�F</TD>
			<TD WIDTH="100%"><INPUT TYPE="text" NAME="dayId" SIZE="4" MAXLENGTH="4" VALUE="<%= strDayId %>"></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="3" ALIGN="right">
		<TR>
			<% '2005.08.22 �����Ǘ� Add by ���@--- START %>
           	<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>  			
				<TD><A HREF="javascript:submitForm()"><IMG SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="���̓��e�ŗ\��m��"></A></TD>
			<% End If %>

			<TD><A HREF="javascript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z������"></A></TD>
		</TR>
	</TABLE>

</FORM>
</BODY>
</HTML>
