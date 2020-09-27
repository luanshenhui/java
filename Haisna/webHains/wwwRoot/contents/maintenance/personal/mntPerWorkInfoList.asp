<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�l�A�J��񃁃��e�i���X (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objPerson			'�l���A�N�Z�X�p
Dim objPerWorkInfo		'�l�A�J���A�N�Z�X�p

'������
Dim strPerId			'�l�h�c
Dim lngStrYear			'�J�n�N
Dim lngStrMonth			'�J�n��
Dim lngEndYear			'�I���N
Dim lngEndMonth			'�I����

'�l�A�J���
Dim strDataDate			'�f�[�^�N��
Dim strNightWorkCount	'��Ɖ�
Dim strOverTime			'���ԊO�A�J����
Dim lngCount			'���R�[�h��

'�l���
Dim strLastName			'��
Dim strFirstName		'��
Dim strLastKName		'�J�i��	
Dim strFirstKName		'�J�i��
Dim strBirth			'���N����
Dim strAge				'�N��
Dim strGender			'����
Dim strGenderName		'���ʖ���

Dim dtmStrDataDate		'�J�n�f�[�^�N��
Dim dtmEndDataDate		'�I���f�[�^�N��
Dim i					'�C���f�b�N�X

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon      = Server.CreateObject("HainsCommon.Common")
Set objPerWorkInfo = Server.CreateObject("HainsPerWorkInfo.PerWorkInfo")

'�����l�̎擾
strPerId    = Request("perId")
lngStrYear  = CLng("0" & Request("strYear"))
lngStrMonth = CLng("0" & Request("strMonth"))
lngEndYear  = CLng("0" & Request("endYear"))
lngEndMonth = CLng("0" & Request("endMonth"))

'�J�n�E�I���N���̃f�t�H���g�l�ݒ�(���߂P�N��)
lngStrYear  = IIf(lngStrYear  = 0, Year(DateAdd("m",  -11, Date)),  lngStrYear)
lngStrMonth = IIf(lngStrMonth = 0, Month(DateAdd("m", -11, Date)), lngStrMonth)
lngEndYear  = IIf(lngEndYear  = 0, Year(Date),  lngEndYear)
lngEndMonth = IIf(lngEndMonth = 0, Month(Date), lngEndMonth)
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�l�A�J��񃁃��e�i���X</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
var winPerWorkInfo;	// �l�A�J���o�^��ʂ̃E�B���h�E�n���h��

// �l�A�J���o�^��ʌĂяo��
function callPerWorkInfoWindow( dataYear, dataMonth ) {

	var opened = false;					// ��ʂ��J����Ă��邩
	var myForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g
	var url;							// �c�́E�R�[�X�ύX��ʂ�URL

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winPerWorkInfo != null ) {
		if ( !winPerWorkInfo.closed ) {
			opened = true;
		}
	}

	// �l�A�J���o�^��ʂ�URL�ҏW
	url = 'mntPerWorkInfo.asp';
	if ( dataYear && dataMonth ) {
		url = url + '?mode='      + 'update';
		url = url + '&dataYear='  + dataYear;
		url = url + '&dataMonth=' + dataMonth;
	} else {
		url = url + '?mode='     + 'insert';
	}
	url = url + '&perId=' + myForm.perId.value;

	// �J����Ă���ꍇ�͉�ʂ�REPLACE���A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winPerWorkInfo.focus();
		winPerWorkInfo.location.replace();
	} else {
		winPerWorkInfo = window.open( url, '', 'status=yes,toolbar=no,directories=no,menubar=no,resizable=yes,scrollbars=yes,width=600,height=330' );
	}

}

// ��ʂ����
function closeWindow() {

	// �l�A�J���o�^��ʂ����
	if ( winPerWorkInfo ) {
		if ( !winPerWorkInfo.closed ) {
			winPerWorkInfo.close();
		}
	}

	winPerWorkInfo = null;

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.mnttab { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="perId" VALUE="<%= strPerId %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">��</SPAN><FONT COLOR="#000000">�l�A�J��񃁃��e�i���X</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>
<%
	'�l���ǂݍ���
	Set objPerson = Server.CreateObject("HainsPerson.Person")
	objPerson.SelectPersonInf strPerId, strLastName, strFirstName, strLastKName, strFirstKName, strBirth, strGender, strGenderName, strAge
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1" WIDTH="650">
		<TR>
			<TD NOWRAP><%= strPerId %></TD>
			<TD WIDTH="100%" NOWRAP><B><%= Trim(strLastName & "�@" & strFirstName) %></B> �i<FONT SIZE="-1"><%= Trim(strLastKName & "�@" & strFirstKName) %></FONT>�j</TD>
			<TD ROWSPAN="2" VALIGN="top" ALIGN="right"><A HREF="mntPersonal.asp?mode=update&perId=<%= strPerId %>"><IMG SRC="/webhains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�l��񃁃��e�i���X��ʂɖ߂�܂�"></A></TD>
		</TR>
		<TR>
			<TD></TD>
			<TD WIDTH="100%" NOWRAP><%= objCommon.FormatString(strBirth, "gee.mm.dd") %>���@<%= strAge %>�΁@<%= strGenderName %></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#eeeeee" NOWRAP><B><FONT COLOR="#333333">�l�A�J���̈ꗗ</FONT></B></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0" WIDTH="650">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD><%= EditNumberList("strYear", YEARRANGE_MIN, YEARRANGE_MAX, lngStrYear, False) %></TD>
			<TD>�N</TD>
			<TD><%= EditNumberList("strMonth", 1, 12, lngStrMonth, False) %></TD>
			<TD NOWRAP>���`</TD>
			<TD><%= EditNumberList("endYear", YEARRANGE_MIN, YEARRANGE_MAX, lngEndYear, False) %></TD>
			<TD>�N</TD>
			<TD><%= EditNumberList("endMonth", 1, 12, lngEndMonth, False) %></TD>
			<TD NOWRAP>���̌l�A�J����</TD>
			<TD><INPUT TYPE="image" NAME="display" SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="�\��"></TD>
			<TD WIDTH="100%" ALIGN="right"><A HREF="javascript:callPerWorkInfoWindow()"><IMG SRC="/webHains/images/newrsv.gif" WIDTH="77" HEIGHT="24" ALT="�V�����l�A�J����o�^���܂�"></A></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
		<TR>
		</TR>
	</TABLE>
<%
	Do

		'�f�[�^�N���̐ݒ�
		dtmStrDataDate = CDate(lngStrYear & "/" & lngStrMonth & "/1")
		dtmEndDataDate = CDate(lngEndYear & "/" & lngEndMonth & "/1")

		'�l�A�J���ǂݍ���
		lngCount = objPerWorkInfo.SelectPerWorkInfoList(strPerId, dtmStrDataDate, dtmEndDataDate, strDataDate, strNightWorkCount, strOverTime)
		If lngCount <= 0 Then
%>
			���������𖞂����l�A�J���͑��݂��܂���B
<%
			Exit Do
		End If
%>
		<BR>

		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
			<TR>
				<TD NOWRAP>�N��</TD>
				<TD WIDTH="10"></TD>
				<TD NOWRAP>��Ɖ�</TD>
				<TD WIDTH="10"></TD>
				<TD NOWRAP>���ԊO�A�J����</TD>
			</TR>
			<TR>
				<TD BGCOLOR="#999999" COLSPAN="5"></TD>
			</TR>
<%
			For i = 0 To lngCount - 1
%>
				<TR>
					<TD NOWRAP><A HREF="javascript:callPerWorkInfoWindow('<%= Year(strDataDate(i)) %>','<%= Month(strDataDate(i)) %>')"><%= objCommon.FormatString(strDataDate(i), "yyyy�Nmm��") %></A></TD>
					<TD></TD>
					<TD ALIGN="right" NOWRAP><%= strNightWorkCount(i) %>��</TD>
					<TD></TD>
					<TD ALIGN="right"><%= objCommon.FormatString(strOverTime(i), "0.0") %>����</TD>
				</TR>
<%
			Next
%>
		</TABLE>
<%
		Exit Do
	Loop
%>
	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
