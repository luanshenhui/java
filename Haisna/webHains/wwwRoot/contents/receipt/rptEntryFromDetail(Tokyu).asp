<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		��t���� (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
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
Dim objContract		'�_����A�N�Z�X�p
Dim objConsult		'��f���A�N�Z�X�p
Dim objCourse		'�R�[�X���A�N�Z�X�p
Dim objFree			'�ėp���A�N�Z�X�p
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
Dim strNewCslYear	'�{��ʂŎw�肳�ꂽ��f�N
Dim strNewCslMonth 	'�{��ʂŎw�肳�ꂽ��f��
Dim strNewCslDay	'�{��ʂŎw�肳�ꂽ��f��
Dim lngMode			'��t���[�h
Dim strUseEmptyId	'�󂫔ԍ����ݎ��ɂ��̔ԍ��Ŋ��蓖�Ă��s���ꍇ"1"
Dim strDayId		'�����h�c

'�_����
Dim strStrDate		'�_��J�n��
Dim strEndDate		'�_��I����
Dim strAgeCalc		'�N��N�Z��

'�l���
Dim strLastName		'��
Dim strFirstName	'��
Dim strLastKName	'�J�i��
Dim strFirstKName	'�J�i��
Dim dtmBirth		'���N����
Dim strGender		'����

Dim strUpdUser		'�X�V��
Dim strCurAge		'���݂̎�f�����_�̔N��
Dim strNewAge		'�{��ʂŎw�肳�ꂽ��f�����_�̔N��
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
Set objCommon   = Server.CreateObject("HainsCommon.Common")
Set objContract = Server.CreateObject("HainsContract.Contract")
Set objConsult  = Server.CreateObject("HainsConsult.Consult")
Set objCourse   = Server.CreateObject("HainsCourse.Course")
Set objFree     = Server.CreateObject("HainsFree.Free")
Set objPerson   = Server.CreateObject("HainsPerson.Person")

'�X�V�҂̐ݒ�
strUpdUser = Session("USERID")

'�����l�̎擾
strCalledFrom  = Request("calledFrom")
strActMode     = Request("actMode")
strRsvNo       = Request("rsvNo")
strPerId       = Request("perId")
strCsCd        = Request("csCd")
strCslYear     = Request("cslYear")
strCslMonth    = Request("cslMonth")
strCslDay      = Request("cslDay")
lngCtrPtCd     = CLng("0" & Request("ctrPtCd"))
strNewCslYear  = Request("newCslYear")
strNewCslMonth = Request("newCslMonth")
strNewCslDay   = Request("newCslDay")
lngMode        = CLng("0" & Request("mode"))
strUseEmptyId  = Request("useEmptyId")
strDayId       = Request("dayId")

'�{��ʂŎw�肷���f���̃f�t�H���g�l�ݒ�
'strNewCslYear  = IIf(strNewCslYear  = "", strCslYear,  strNewCslYear)
'strNewCslMonth = IIf(strNewCslMonth = "", strCslMonth, strNewCslMonth)
'strNewCslDay   = IIf(strNewCslDay   = "", strCslDay,   strNewCslDay)
strNewCslYear  = IIf(strNewCslYear  = "", CStr(Year(Date)),  strNewCslYear)
strNewCslMonth = IIf(strNewCslMonth = "", CStr(Month(Date)), strNewCslMonth)
strNewCslDay   = IIf(strNewCslDay   = "", CStr(Day(Date)),   strNewCslDay)

'�l���ǂݍ���
If objPerson.SelectPerson_Lukes(strPerId, strLastName, strFirstName, strLastKName, strFirstKName, , dtmBirth, strGender) = False Then
	Err.Raise 1000, , "�l��񂪑��݂��܂���B"
End If

'�_��p�^�[�����ǂݍ���
If objContract.SelectCtrPt(lngCtrPtCd, strStrDate, strEndDate, strAgeCalc) = False Then
	Err.Raise 1000, ,"�_���񂪑��݂��܂���B"
End If

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do

	'�u�m��v�{�^���������ȊO�͉������Ȃ�
	If strActMode = "" Then
		Exit Do
	End If

	'��f���̓��t�`�F�b�N
	If Not IsDate(strNewCslYear & "/" & strNewCslMonth & "/" & strNewCslDay) Then
		strMessage = "��f���̓��͌`��������������܂���B"
		Exit Do
	End If

	'��f������t�^�Ƃ��Ď擾
	dtmCslDate = CDate(strNewCslYear & "/" & strNewCslMonth & "/" & strNewCslDay)

	'��f�����_����Ԃ��O���ꍇ�̓G���[
	If dtmCslDate < CDate(strStrDate) Or dtmCslDate > CDate(strEndDate) Then
		strMessage = "���_��p�^�[���̌_����Ԃ��O�����t�͎w��ł��܂���B"
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

	'����f�����_�̔N����v�Z
	strCurAge = objFree.CalcAge(dtmBirth, CDate(strCslYear & "/" & strCslMonth & "/" & strCslDay), strAgeCalc)
	If Not IsNumeric(strCurAge) Then
		Err.Raise 1000, , "�N��v�Z�����ɂăG���[���������܂����B"
	End If

	'�{��ʂŎw�肳�ꂽ��f�����_�̔N����v�Z
	strNewAge = objFree.CalcAge(dtmBirth, dtmCslDate, strAgeCalc)
	If Not IsNumeric(strNewAge) Then
		Err.Raise 1000, , "�N��v�Z�����ɂăG���[���������܂����B"
	End If

	'���݂̔N��Ǝw�肳�ꂽ��f�����_�ł̔N��Ƃ��قȂ�ꍇ�A��f���ׂ��I�v�V���������̓��e�ɖ�����������\�������邽�߂͂���
	If Int(strNewAge) <> Int(strCurAge) Then
		strMessage = "���݂̎�f���N��Ǝw�肳�ꂽ��f�����_�̔N��قȂ�܂��B��t�ł��܂���B"
		Exit Do
	End If

	'��t�������[�h�E��t�ԍ��̐ݒ�
	lngReceiptMode = IIf(lngMode =  0, IIf(strUseEmptyId <> "", 2, 1), 3)
	If lngMode = 1 Then
		lngDayId = CLng(strDayId)
	End If

	'�\��ڍ׉�ʂ���Ă΂ꂽ�ꍇ
	If strCalledFrom = CALLED_FROMDETAIL Then

		'�\��ڍ׉�ʂֈ�����n�����߂̃��_�C���N�g����
		strURL = "rptReceipt.asp"
		strURL = strURL & "?cslYear="     & strNewCslYear
		strURL = strURL & "&cslMonth="    & strNewCslMonth
		strURL = strURL & "&cslDay="      & strNewCslDay
		strURL = strURL & "&receiptMode=" & lngReceiptMode
		strURL = strURL & "&dayId="       & lngDayId
		Response.Redirect strURL
		Response.End
		Exit Do

	End If

	'��f�҈ꗗ����Ă΂ꂽ�ꍇ
	If strCalledFrom = CALLED_FROMLIST Then

		'��t����
		Ret = objConsult.Receipt(strRsvNo, strNewCslYear, strNewCslMonth, strNewCslDay, strUpdUser, lngReceiptMode, 0, lngDayId, strMessage)
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

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD><FONT COLOR="#cc9999">��</FONT></TD>
			<TD NOWRAP>��f����ύX����ꍇ�͂����Ŏw�肵�ĉ������B</TD>
		</TR>
		<TR>
			<TD><FONT COLOR="#cc9999">��</FONT></TD>
			<TD NOWRAP>���_��p�^�[���̌_����Ԃ��O�����t�͎w��ł��܂���B</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD NOWRAP>�i�_����ԁF<FONT COLOR="#ff6600"><B><%= strStrDate %></B></FONT>�`<FONT COLOR="#ff6600"><B><%= strEndDate %></B></FONT>�j</TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD NOWRAP>��f��</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('newCslYear', 'newCslMonth', 'newCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
			<TD><%= EditNumberList("newCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strNewCslYear, False) %></TD>
			<TD>�N</TD>
			<TD><%= EditNumberList("newCslMonth", 1, 12, strNewCslMonth, False) %></TD>
			<TD>��</TD>
			<TD><%= EditNumberList("newCslDay", 1, 31, strNewCslDay, False) %></TD>
			<TD>��</TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
	</TABLE>

	<FONT SIZE="+1"><FONT COLOR="#cc9999">��</FONT>&nbsp;�����h�c�̊��蓖�ĕ��@���w�肵�ĉ������B</FONT>

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
			<TD><A HREF="javascript:submitForm()"><IMG SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="���̓��e�ŗ\��m��"></A></TD>
			<TD><A HREF="javascript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z������"></A></TD>
		</TR>
	</TABLE>

</FORM>
</BODY>
</HTML>
