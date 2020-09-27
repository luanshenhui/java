<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		��f�c�̂̐ݒ� (Ver0.0.1)
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
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objOrganization	'�c�̏��A�N�Z�X�p
Dim objOrgBsd		'���ƕ����A�N�Z�X�p
Dim objOrgPost		'�������A�N�Z�X�p
Dim objOrgRoom		'�������A�N�Z�X�p
Dim objPerson		'�l���A�N�Z�X�p

'�����l
Dim strMode			'�������[�h
Dim strPerId		'�l�h�c
Dim strOrgCd1		'�c�̃R�[�h�P
Dim strOrgCd2		'�c�̃R�[�h�Q
Dim strOrgBsdCd		'���ƕ��R�[�h
Dim strOrgRoomCd	'�����R�[�h
Dim strOrgPostCd	'�����R�[�h
Dim strIsrSign		'���ۋL��
Dim strIsrNo		'���۔ԍ�

'�������
Dim strOrgName		'�c�̖���
Dim strOrgSName		'�c�̗���
Dim strOrgBsdName	'���ƕ�����
Dim strOrgRoomName	'��������
Dim strOrgPostName	'��������

Dim strMessage		'���b�Z�[�W
Dim strURL			'URL������

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objOrgBsd       = Server.CreateObject("HainsOrgBsd.OrgBsd")
Set objOrgPost      = Server.CreateObject("HainsOrgPost.OrgPost")
Set objOrgRoom      = Server.CreateObject("HainsOrgRoom.OrgRoom")
Set objPerson       = Server.CreateObject("HainsPerson.Person")

'�����l�̎擾
strMode      = Request("mode")
strPerId     = Request("perId")
strOrgCd1    = Request("orgCd1")
strOrgCd2    = Request("orgCd2")
strOrgBsdCd  = Request("orgBsdCd")
strOrgRoomCd = Request("orgRoomCd")
strOrgPostCd = Request("orgPostCd")
strIsrSign   = Request("isrSign")
strIsrNo     = Request("isrNo")

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Select Case strMode

	Case "person"	'�l��񂩂�̓K�p��

		'�l���ǂݍ���
		objPerson.SelectPerson strPerId, , , , , , , _
							   strOrgCd1, strOrgCd2, , , , _
							   strOrgBsdCd, , , _
							   strOrgRoomCd, , , _
							   strOrgPostCd, , , , , , , , , , _
							   strIsrSign, strIsrNo

	Case "select"	'�m�莞

		'���̓`�F�b�N
		strMessage = CheckValue()
		If IsEmpty(strMessage) Then

			'�e��ʂւ̐ݒ�pASP�Ăяo��
			strURL = "rsvSelectOrg.asp"
			strURL = strURL & "?orgCd1="    & strOrgCd1
			strURL = strURL & "&orgCd2="    & strOrgCd2
			strURL = strURL & "&orgBsdCd="  & strOrgBsdCd
			strURL = strURL & "&orgRoomCd=" & strOrgRoomCd
			strURL = strURL & "&orgPostCd=" & strOrgPostCd
			strURL = strURL & "&isrSign="   & strIsrSign
			strURL = strURL & "&isrNo="     & strIsrNo
			Response.Redirect strURL
			Response.End

		End If

End Select

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �����l�̑Ó����`�F�b�N���s��
'
' �����@�@ :
'
' �߂�l�@ : �G���[�l������ꍇ�A�G���[���b�Z�[�W�̔z���Ԃ�
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CheckValue()

	Dim objCommon	'���ʃN���X
	Dim strMessage	'�G���[���b�Z�[�W�̏W��

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'�c�̃R�[�h�̃`�F�b�N
	If strOrgCd1 = "" Or strOrgCd2 = "" Then
		objCommon.AppendArray strMessage, "�c�̂��w�肵�ĉ������B"
	End If

	'���ƕ��E�����E�����̃f�t�H���g�ݒ�
	strOrgBsdCd  = IIf(strOrgBsdCd  = "", "0000000000", strOrgBsdCd )
	strOrgRoomCd = IIf(strOrgRoomCd = "", "0000000000", strOrgRoomCd)
	strOrgPostCd = IIf(strOrgPostCd = "", "0000000000", strOrgPostCd)

	'���ۋL���E���۔ԍ��̃`�F�b�N
	objCommon.AppendArray strMessage, objCommon.CheckNarrowValue("���ۋL��", strIsrSign, 4)
	objCommon.AppendArray strMessage, objCommon.CheckNarrowValue("���۔ԍ�", strIsrNo,   8)

	'�߂�l�̕ҏW
	If IsArray(strMessage) Then
		CheckValue = strMessage
	End If

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>��f�c�̂̐ݒ�</TITLE>
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// �G�������g�̎Q�Ɛݒ�
function setElement() {

	with ( document.entryForm ) {
		orgPostGuide_getElement( orgCd1, orgCd2, 'orgName', orgBsdCd, 'orgBsdName', orgRoomCd, 'orgRoomName', orgPostCd, 'orgPostName' );
	}

}

// submit����
function submitForm( mode ) {

	// �������[�h���w�肵��submit
	document.entryForm.mode.value = mode;
	document.entryForm.submit();

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 15px 0 0 20px; }
</style>
</HEAD>
<BODY ONLOAD="javascript:setElement()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get" ONSUBMIT="javascript:return false">
	<INPUT TYPE="hidden" NAME="mode"      VALUE="">
	<INPUT TYPE="hidden" NAME="perId"     VALUE="<%= strPerId     %>">
	<INPUT TYPE="hidden" NAME="orgCd1"    VALUE="<%= strOrgCd1    %>">
	<INPUT TYPE="hidden" NAME="orgCd2"    VALUE="<%= strOrgCd2    %>">
	<INPUT TYPE="hidden" NAME="orgBsdCd"  VALUE="<%= strOrgBsdCd  %>">
	<INPUT TYPE="hidden" NAME="orgRoomCd" VALUE="<%= strOrgRoomCd %>">
	<INPUT TYPE="hidden" NAME="orgPostCd" VALUE="<%= strOrgPostCd %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="400">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000">��f�c�̂̐ݒ�</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'���b�Z�[�W�̕\��
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)
%>
	<BR>
<%
	'�e�햼�̂̎擾
	Do

		'�c�̃R�[�h���w�莞�͉������Ȃ�
		If strOrgCd1 = "" Or strOrgCd2 = "" Then
			Exit Do
		End If

		'�c�̖��̂̓ǂݍ���
		If objOrganization.SelectOrg_Lukes(strOrgCd1, strOrgCd2, , , strOrgName) = False Then
			Err.Raise 1000, , "�c�̏�񂪑��݂��܂���B"
		End If

		'���ƕ��R�[�h���w�莞�͉������Ȃ�
		If strOrgBsdCd = "" Then
			Exit Do
		End If

		'���ƕ����̂̓ǂݍ���
		If objOrgBsd.SelectOrgBsd(strOrgCd1, strOrgCd2, strOrgBsdCd, , strOrgBsdName) = False Then
			Err.Raise 1000, , "���ƕ���񂪑��݂��܂���B"
		End If

		'�����R�[�h���w�莞�͉������Ȃ�
		If strOrgRoomCd = "" Then
			Exit Do
		End If

		'�������̂̓ǂݍ���
		If objOrgRoom.SelectOrgRoom(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgRoomName) = False Then
			Err.Raise 1000, , "������񂪑��݂��܂���B"
		End If

		'�������̂̓ǂݍ���
		If strOrgPostCd <> "" Then
			If objOrgPost.SelectOrgPost(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgPostCd, strOrgPostName) = False Then
				Err.Raise 1000, , "������񂪑��݂��܂���B"
			End If
		End If

		Exit Do
	Loop
%>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD>�c��</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrg()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
			<TD></TD>
			<TD NOWRAP><SPAN ID="orgName"><%= strOrgName %></SPAN></TD>
		</TR>
		<TR>
			<TD NOWRAP>���ƕ�</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgBsd()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���ƕ������K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgBsdInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
			<TD NOWRAP><SPAN ID="orgBsdName"><%= strOrgBsdName %></SPAN></TD>
		</TR>
		<TR>
			<TD>����</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgRoom()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���������K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgRoomInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
			<TD NOWRAP><SPAN ID="orgRoomName"><%= strOrgRoomName %></SPAN></TD>
		</TR>
		<TR>
			<TD>����</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgPost(1)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���������K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgPostInfo(1)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
			<TD NOWRAP><SPAN ID="orgPostName"><%= strOrgPostName %></SPAN></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD NOWRAP>���ۋL��</TD>
			<TD>�F</TD>
			<TD><INPUT TYPE="text" NAME="isrSign" SIZE="<%= TextLength(4) %>" MAXLENGTH="4" VALUE="<%= strIsrSign %>"></TD>
		<TR>
			<TD NOWRAP>���۔ԍ�</TD>
			<TD>�F</TD>
			<TD><INPUT TYPE="text" NAME="isrNo" SIZE="<%= TextLength(8) %>" MAXLENGTH="8" VALUE="<%= strIsrNo %>"></TD>
		</TR>
	</TABLE>

	<BR>
<%
	'�l���莞�̓A���J�[��p�ӂ���
	If strPerId <> "" Then
%>
		&nbsp;<A HREF="javascript:submitForm('person')">���݂̌l��񂩂�K�p</A><BR><BR>
<%
	End If
%>
	<BR>

	<A HREF="javascript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z������"></A>
	<A HREF="javascript:submitForm('select')"><IMG SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="���̓��e�Ŋm�肷��"></A>

</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
