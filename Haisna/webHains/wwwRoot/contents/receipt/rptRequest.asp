<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'		�����˗� (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_BUSINESS_TOP)

'�^�C���A�E�g���Q�O���ɐݒ�
'Server.ScriptTimeOut = 20 * 60

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const FREECD_REQFILE = "REQFILE"	'�����˗��t�@�C�����

'COM�I�u�W�F�N�g
Dim objFree			'�ėp���A�N�Z�X�p
Dim objPerson		'�l���A�N�Z�X�p
Dim objRequest		'�����˗������p
'Dim objResponse		'���ʎ�荞�ݏ����p

'�����l
Dim strMode			'�������[�h
Dim lngCslYear		'��f�N
Dim lngCslMonth		'��f��
Dim lngCslDay		'��f��
Dim strPerId		'�l�h�c
Dim strIncSentData	'���M�ς݃f�[�^��ΏۂƂ��邩("1":�Ώ�)
Dim strCount		'�˗�����
Dim strStat			'�R�s�[�����̌���

'�l���
Dim strEmpNo		'�]�ƈ��ԍ�
Dim strLastName		'��
Dim strFirstName	'��

Dim strFilePath		'�˗����t�@�C���i�[�p�X
Dim strFileName		'�˗����t�@�C����
Dim strSharePath	'�����V�X�e���Ƃ̋��L�p�X

Dim strCslDate		'��f�N����
Dim strMessage		'�G���[���b�Z�[�W
Dim lngMessageType	'���b�Z�[�W�^�C�v
Dim strURL			'�W�����v���URL
Dim Ret				'�֐��߂�l
Dim i				'�C���f�b�N�X

Dim objExec			'��荞�ݏ������s�p

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objFree     = Server.CreateObject("HainsFree.Free")
Set objPerson   = Server.CreateObject("HainsPerson.Person")
'Set objResponse = Server.CreateObject("HainsCooperation.Response")

'�����l�̎擾
strMode        = Request("mode")
lngCslYear     = CLng("0" & Request("cslYear"))
lngCslMonth    = CLng("0" & Request("cslMonth"))
lngCslDay      = CLng("0" & Request("cslDay"))
strPerId       = Request("perId")
strIncSentData = Request("incSentData")
strCount       = Request("count")
strStat        = Request("stat")

'�������[�h�̃f�t�H���g�l�ݒ�(�f�t�H���g�̓��j���[�����΂��́u�R�s�[�v)
strMode = IIf(strMode = "", "3", strMode)

'��f�J�n�E�I�����̃f�t�H���g�l�ݒ�
'(��f�J�n�N���O�ɂȂ�P�[�X�͏����\�����ȊO�ɂȂ�)
If lngCslYear = 0 Then
	lngCslYear  = Year(Date())
	lngCslMonth = Month(Date())
	lngCslDay   = Day(Date())
End If

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do

	'�u�m��v�{�^���������ȊO�͉������Ȃ�
	If IsEmpty(Request("x")) Then
		Exit Do
	End If

	'�������[�h���Ƃ̘A�g����
	Select Case strMode

		Case "1"	'�����˗���

			'��f�N�����̃`�F�b�N
			strCslDate = lngCslYear & "/" & lngCslMonth & "/" & lngCslDay
			If Not IsDate(strCslDate) Then
				strMessage = "��f���̓��͌`��������������܂���B"
				Exit Do
			End If

'			'�����˗�����
'			Ret = objRequest.CreateFile(strCslDate, strPerId, (strIncSentData <> ""))

			'��荞�ݏ����N��
			Set objExec = Server.CreateObject("HainsCooperation.Exec")
			objExec.Run "cscript " & Server.MapPath("/webHains/script") & "\CreateRequestFile.vbs " & strCslDate & " " & IIf(strPerId <> "", strPerId, """""") & " " & (strIncSentData <> "")
			Ret = 0

		Case "2"	'���ʎ�荞�ݎ�

'			'���ʎ�荞�ݏ���
'			Ret = objResponse.ImportFile()

			'��荞�ݏ����N��
			Set objExec = Server.CreateObject("HainsCooperation.Exec")
			objExec.Run "cscript " & Server.MapPath("/webHains/script") & "\ImportResultFile.vbs"
			Ret = 0

		Case "3"	'�����˗��t�@�C���̃R�s�[

			'�ėp�e�[�u�����猟���˗��t�@�C�������擾
			Ret = objFree.SelectFree(0, FREECD_REQFILE, , , , strFilePath, strFileName, strSharePath)
			If Ret = False Or strFilePath = "" Or strFileName = "" Or strSharePath = "" Then
				strMessage = "�ėp�e�[�u���ɂ����錟���˗����̐ݒ�Ɍ�肪����܂��B"
				Exit Do
			End If

			'�����˗��t�@�C���̃R�s�[
			strFilePath  = strFilePath  & IIf(Right(strFilePath,  1) <> "\", "\", "")
			strSharePath = strSharePath & IIf(Right(strSharePath, 1) <> "\", "\", "")
			Set objRequest = Server.CreateObject("HainsCooperation.Request")
			Ret = objRequest.CopyFile(strFilePath & strFileName, strSharePath & strFileName)

		Case Else
			Exit Do

	End Select

	'����ʂ����_�C���N�g
	strURL = Request.ServerVariables("SCRIPT_NAME")
	strURL = strURL & "?mode="        & strMode
	strURL = strURL & "&cslYear="     & lngCslYear
	strURL = strURL & "&cslMonth="    & lngCslMonth
	strURL = strURL & "&cslDay="      & lngCslDay
	strURL = strURL & "&perId="       & strPerId
	strURL = strURL & "&incSentData=" & strIncSentData
	If strMode = "1" Or strMode = "2" Then
		strURL = strURL & "&count="   & Ret
	Else
		strURL = strURL & "&stat="    & Ret
	End If
	Response.Redirect strURL
	Response.End

	Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�����˗�</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<!-- #include virtual = "/webHains/includes/perGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// �l�����K�C�h�Ăяo��
function callPersonGuide() {

	// �l�K�C�h�\��
	perGuide_showGuidePersonal( document.entryForm.perId, 'perName', null, setEmpNo );

}

// �]�ƈ��ԍ��̕ҏW
function setEmpNo( perInfo ) {

	document.getElementById('empNo').innerHTML = ( perInfo.empNo != '' ) ? perInfo.empNo + '�F' : '';


}

// �l���̃N���A
function clearPersonInfo() {

	with ( document ) {
		entryForm.perId.value               = '';
		getElementById('empNo').innerHTML   = '';
		getElementById('perName').innerHTML = '';
	}

}

// �m�F���b�Z�[�W�̕\��
function showConfirmMessage() {

	var msg;	// ���b�Z�[�W

	if ( document.entryForm.mode[ 0 ].checked ) {
		msg = '�����˗��t�@�C���̃R�s�[';
	}

	if ( document.entryForm.mode[ 1 ].checked ) {
		msg = '���ʎ�荞��';
	}

	if ( document.entryForm.mode[ 2 ].checked ) {
		msg = '���̓��e�Ō����˗�';
	}

	return confirm( msg  + '���s���܂��B��낵���ł����H' );

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.rsvtab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" ONSUBMIT="javascript:return showConfirmMessage()">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000">�����˗�</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'���b�Z�[�W�̕ҏW
	Do

		'�R�s�[�������s��ꂽ�ꍇ
		If strStat <> "" Then

			Select Case CLng(strStat)
				Case 0
					strMessage = "�����˗��t�@�C���̃R�s�[���s���܂����B"
					lngMessageType = MESSAGETYPE_NORMAL
				Case -1
					strMessage = "�����˗��t�@�C���͑��݂��܂���ł����B"
					lngMessageType = MESSAGETYPE_NORMAL
				Case -2
					strMessage = "�����˗��t�@�C���͌��ݎg�p���ł��B"
					lngMessageType = MESSAGETYPE_WARNING
				Case -3
					strMessage = "�R�s�[��̃t�@�C���͌��ݎg�p���ł��B"
					lngMessageType = MESSAGETYPE_WARNING
				Case Else
					strMessage = "�R�s�[�����ɂ����ď������݃G���[���������܂����B"
					lngMessageType = MESSAGETYPE_WARNING
			End Select

			EditMessage strMessage, lngMessageType
			Exit Do

		End If

		'�������w�莞�͒ʏ�̃��b�Z�[�W�ҏW
		If strCount = "" then
			EditMessage strMessage, MESSAGETYPE_WARNING
			Exit Do
		End If

		'���ʎ�荞�݂̏ꍇ
		If strMode = "2" Then
			strMessage = "�������ʂ̎�荞�ݏ������J�n����܂����B�ڍׂ̓V�X�e�����O���Q�Ƃ��ĉ������B"
			EditMessage strMessage, MESSAGETYPE_NORMAL
			Exit Do
		End If

		EditMessage "�����˗��t�@�C���̍쐬�������J�n����܂����B�ڍׂ̓V�X�e�����O���Q�Ƃ��ĉ������B", MESSAGETYPE_NORMAL
		Exit Do

		'�O���̏ꍇ
		If strCount = "0" Then
			strMessage = IIf(strMode = "1", "�˗����͍쐬����܂���ł����B", "��荞�ݑΏۂƂȂ郌�R�[�h�͑��݂��܂���ł����B")
			EditMessage strMessage & "�ڍׂ̓V�X�e�����O���Q�Ƃ��ĉ������B", MESSAGETYPE_NORMAL
			Exit Do
		End If

		'�P���ȏ㏈�����ꂽ�ꍇ
		strMessage = strCount & "����" & IIf(strMode = "1", "�˗���񂪍쐬����܂����B", "���R�[�h����荞�܂�܂����B")
		EditMessage strMessage & "�ڍׂ̓V�X�e�����O���Q�Ƃ��ĉ������B", MESSAGETYPE_NORMAL
		Exit Do
	Loop
%>
	<BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="3" <%= IIf(strMode = "3", "CHECKED", "") %>></TD>
			<TD NOWRAP>�����˗��t�@�C���̃R�s�[���s��</TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="2" <%= IIf(strMode = "2", "CHECKED", "") %>></TD>
			<TD NOWRAP>�������ʂ̎�荞�݂��s��</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD HEIGHT="35" VALIGN="bottom"><A HREF="/webHains/contents/maintenance/hainslog/dispHainsLog.asp?mode=print&transactionDiv=LOGRESISP"><IMG SRC="/webHains/images/prevlog.gif" WIDTH="77" HEIGHT="24" ALT="���O���Q�Ƃ���"></A></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="1" <%= IIf(strMode = "1", "CHECKED", "") %>></TD>
			<TD NOWRAP>�����˗��t�@�C�����쐬����</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD WIDTH="20"></TD>
			<TD><FONT COLOR="#ff0000">��</FONT></TD>
			<TD WIDTH="90" NOWRAP>��f��</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('cslYear', 'cslMonth', 'cslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
			<TD><%= EditNumberList("cslYear", YEARRANGE_MIN, YEARRANGE_MAX, lngCslYear, False) %></TD>
			<TD>�N</TD>
			<TD><%= EditNumberList("cslMonth", 1, 12, lngCslMonth, False) %></TD>
			<TD>��</TD>
			<TD><%= EditNumberList("cslDay", 1, 31, lngCslDay, False) %></TD>
			<TD>��</TD>
		</TR>
	</TABLE>

	<INPUT TYPE="hidden" NAME="perId" VALUE="<%= strPerId %>">
<%
	'�l���ǂݍ���
	If strPerId <> "" Then
		objPerson.SelectPerson strPerId, strLastName, strFirstName, , , , , , , , , , , , , , , , , , , , , , , , ,strEmpNo
	End If
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD WIDTH="20"></TD>
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>�]�ƈ��w��</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:callPersonGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�l�����K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:clearPersonInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
			<TD NOWRAP><SPAN ID="empNo"><%= IIf(strEmpNo <> "", strEmpNo & "�F", "") %></SPAN><SPAN ID="perName"><%= strLastName & "&nbsp;&nbsp;" & strFirstName %></SPAN></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD WIDTH="20"></TD>
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>���̑�</TD>
			<TD>�F</TD>
			<TD><INPUT TYPE="checkbox" NAME="incSentData" VALUE="1" <%= IIf(strIncSentData = "1", "CHECKED", "") %>></TD>
			<TD>���łɑ��M���ꂽ�f�[�^���ΏۂƂ���</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD WIDTH="20"></TD>
			<TD HEIGHT="35" VALIGN="bottom"><A HREF="/webHains/contents/maintenance/hainslog/dispHainsLog.asp?mode=print&transactionDiv=LOGREQISP"><IMG SRC="/webHains/images/prevlog.gif" WIDTH="77" HEIGHT="24" ALT="���O���Q�Ƃ���"></A></TD>
		</TR>
	</TABLE>

	<BR><BR>

	<A HREF="/webHains/contents/reserve/rsvMenu.asp"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�߂�"></A>
	<INPUT TYPE="image" SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="���̏����Ŋm�肷��">

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>