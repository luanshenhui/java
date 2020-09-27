<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�J�������񃁃��e�i���X(���C�����) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"  -->
<!-- #include virtual = "/webHains/includes/EditPageNavi.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�萔�̒�`
Const MODE_INSERT     = "insert"	'�������[�h(�}��)
Const MODE_UPDATE     = "update"	'�������[�h(�X�V)
Const ACTMODE_SAVE    = "save"		'���샂�[�h(�ۑ�)
Const ACTMODE_SAVED   = "saved"		'���샂�[�h(�ۑ�����)
Const ACTMODE_DELETE  = "delete"	'���샂�[�h(�폜)
Const ACTMODE_DELETED = "deleted"	'���샂�[�h(�폜����)
Const STARTPOS        = 1			'�J�n�ʒu�̃f�t�H���g�l
Const GETCOUNT        = 20			'�\�������̃f�t�H���g�l

'COM�R���|�[�l���g
Dim objOrganization		'�c�̏��A�N�Z�X�p
Dim objOrgPost			'�������A�N�Z�X�p

'�����l�i�{�X�N���v�g���Ăяo���ۂ̈��������`���܂��j
Dim strMode				'�������[�h(�}��:"insert"�A�X�V:"update")
Dim strActMode			'���샂�[�h(�ۑ�:"save"�A�ۑ�����:"saved")
Dim strOrgCd1			'�c�̃R�[�h�P
Dim strOrgCd2			'�c�̃R�[�h�Q
Dim strOrgWkPostCd		'�J������R�[�h
Dim strOrgWkPostName	'�J�������
Dim strOrgWkPostSeq		'�J������r�d�p
Dim lngStartPos			'�����J�n�ʒu
Dim lngGetCount			'�\������

'�������
Dim strArrOrgBsdCd		'���ƕ��R�[�h
Dim strArrOrgRoomCd		'�����R�[�h
Dim strArrOrgPostCd		'�����R�[�h
Dim strArrOrgPostName	'��������
Dim strArrOrgPostKName	'�����J�i����
Dim strArrOrgBsdName	'���ƕ�����
Dim strArrOrgBsdKName	'���ƕ��J�i����
Dim strArrOrgRoomName	'��������
Dim strArrOrgRoomKName	'�����J�i����

'��Ɨp�̕ϐ�
Dim strOrgSName			'�c�̗���
Dim lngCount			'���R�[�h����
Dim strArrMessage		'�G���[���b�Z�[�W
Dim strURL				'�W�����v���URL
Dim strURL2				'�W�����v���URL
Dim Ret					'�֐��߂�l
Dim i, j				'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objOrgPost = Server.CreateObject("HainsOrgPost.OrgPost")

'�����l�̎擾
strMode          = Request("mode")
strActMode       = Request("actMode")
strOrgCd1        = Request("orgCd1")
strOrgCd2        = Request("orgCd2")
strOrgWkPostCd   = Request("orgWkPostCd")
strOrgWkPostName = Request("orgWkPostName")
strOrgWkPostSeq  = Request("orgWkPostSeq")
lngStartPos      = Request("startPos")
lngGetCount      = Request("getCount")

'�����ȗ����̃f�t�H���g�l�ݒ�
strMode     = IIf(strMode = "", MODE_INSERT, strMode)
lngStartPos = CLng(IIf(lngStartPos = "", STARTPOS, lngStartPos))
lngGetCount = CLng(IIf(lngGetCount = "", GETCOUNT, lngGetCount))

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do

	'�폜���̏���
	If strActMode = ACTMODE_DELETE Then

		'�J������e�[�u�����R�[�h�폜
		Ret = objOrgPost.DeleteOrgWkPost(strOrgCd1, strOrgCd2, strOrgWkPostCd)
		If Ret = 0 Then
			strArrMessage = Array("���̘J��������Q�Ƃ��Ă��鏊����񂪑��݂��܂��B�폜�ł��܂���B")
			Exit Do
		End If

		'�폜�ɐ��������ꍇ�͑}�����[�h�Ŏ������g���Ăяo��
		strURL = Request.ServerVariables("SCRIPT_NAME")
		strURL = strURL & "?mode="    & MODE_INSERT
		strURL = strURL & "&actMode=" & ACTMODE_DELETED
		strURL = strURL & "&orgCd1="  & strOrgCd1
		strURL = strURL & "&orgCd2="  & strOrgCd2
		Response.Redirect strURL
		Response.End

	End If

	'�ۑ����̏���
	If strActMode = ACTMODE_SAVE Then

		'���̓`�F�b�N
		strArrMessage = CheckValue()
		If Not IsEmpty(strArrMessage) Then
			Exit Do
		End If

		'�X�V�̏ꍇ
		If strMode = MODE_UPDATE Then

			'�J������e�[�u�����R�[�h�X�V
			Ret = objOrgPost.UpdateOrgWkPost(strOrgCd1, strOrgCd2, strOrgWkPostCd, strOrgWkPostName)

			'���R�[�h�����݂��Ȃ��ꍇ�͐V�K���̏������s��
			If Ret = 0 Then
				strMode = MODE_INSERT
			End If

		End If

		'�}���̏ꍇ
		If strMode = MODE_INSERT Then

			'�J������e�[�u�����R�[�h�}��
			Ret = objOrgPost.InsertOrgWkPost(strOrgCd1, strOrgCd2, strOrgWkPostCd, strOrgWkPostName)

			'�L�[�d�����̓G���[���b�Z�[�W��ҏW����
			If Ret = INSERT_DUPLICATE Then
				strArrMessage = Array("����c�́A�J������R�[�h�̘J�������񂪂��łɑ��݂��܂��B")
				Exit Do
			End If

		End If

		'�ۑ��ɐ��������ꍇ�͍X�V���[�h�Ŏ������g���Ăяo��
		strURL = Request.ServerVariables("SCRIPT_NAME")
		strURL = strURL & "?mode="        & MODE_UPDATE
		strURL = strURL & "&actMode="     & ACTMODE_SAVED
		strURL = strURL & "&orgCd1="      & strOrgCd1
		strURL = strURL & "&orgCd2="      & strOrgCd2
		strURL = strURL & "&orgWkPostCd=" & strOrgWkPostCd
		Response.Redirect strURL
		Response.End

	End If

	'�V�K�̏ꍇ�͓ǂݍ��݂��s��Ȃ�
	If strMode = MODE_INSERT Then
		Exit Do
	End If

	'�J������e�[�u�����R�[�h�ǂݍ���
	objOrgPost.SelectOrgWkPost strOrgCd1, strOrgCd2, strOrgWkPostCd, strOrgWkPostName, strOrgWkPostSeq

	'�������[�h���X�V�Ƃ���
	strMode = MODE_UPDATE

	Exit Do
Loop

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �e�l�̑Ó����`�F�b�N���s��
'
' �����@�@ :
'
' �߂�l�@ : �G���[�l������ꍇ�A�G���[���b�Z�[�W�̔z���Ԃ�
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CheckValue()

	Dim objCommon		'���ʃN���X
	Dim vntArrMessage	'�G���[���b�Z�[�W�̏W��
	Dim strMessage		'�G���[���b�Z�[�W

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'�e�l�`�F�b�N����
	With objCommon

		'�c�̃R�[�h
		If strOrgCd1 = "" Or strOrgCd2 = "" Then
			.AppendArray vntArrMessage, "�c�̂���͂��ĉ������B"
		End If

		'�J������R�[�h
		.AppendArray vntArrMessage, .CheckAlphabetAndNumeric("�J������R�[�h", strOrgWkPostCd, 10, CHECK_NECESSARY)

		'�J���������
		.AppendArray vntArrMessage, .CheckWideValue("�J���������", strOrgWkPostName, LENGTH_ORGBSD_ORGBSDNAME, CHECK_NECESSARY)

	End With

	'�߂�l�̕ҏW
	If IsArray(vntArrMessage) Then
		CheckValue = vntArrMessage
	End If

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�J�������񃁃��e�i���X</TITLE>
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
var winAllocOrgPost;	// �������蓖�ĉ�ʂ̃E�B���h�E�n���h��

// �K�C�h��ʌĂяo��
function callOrgGuide() {

	orgGuide_showGuideOrg( document.entryForm.orgCd1, document.entryForm.orgCd2, '', 'orgSName', '' );

}

// submit���̏���
function submitForm( actMode ) {

	// �폜���͊m�F���b�Z�[�W��\��
	if ( actMode == '<%= ACTMODE_DELETE %>' ) {
		if ( !confirm( '���̘J����������폜���܂��B��낵���ł����H' ) ) {
			return;
		}
	}

	// ���샂�[�h���w�肵��submit
	document.entryForm.actMode.value = actMode;
	document.entryForm.submit();

}

// �������蓖�ĉ�ʌĂяo��
function callAllocOrgPostWindow() {

	var opened = false;					// ��ʂ��J����Ă��邩
	var myForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g
	var url;							// �c�́E�R�[�X�ύX��ʂ�URL

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winAllocOrgPost != null ) {
		if ( !winAllocOrgPost.closed ) {
			opened = true;
		}
	}

	// �c�̕ύX��ʂ�URL�ҏW
	url = 'mntAllocOrgPost.asp';
	url = url + '?orgCd1='      + myForm.orgCd1.value;
	url = url + '&orgCd2='      + myForm.orgCd2.value;
	url = url + '&orgWkPostCd=' + myForm.orgWkPostCd.value;

	// �J����Ă���ꍇ�͉�ʂ�FOCUS���A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winAllocOrgPost.focus();
	} else {
		winAllocOrgPost = window.open( url, '', 'status=yes,toolbar=no,directories=no,menubar=no,resizable=yes,scrollbars=yes,width=600,height=300' );
	}

}

// ��ʂ����
function closeWindow() {

	// �������蓖�ĉ�ʂ����
	if ( winAllocOrgPost ) {
		if ( !winAllocOrgPost.closed ) {
			winAllocOrgPost.close();
		}
	}

	winAllocOrgPost = null;

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

	<INPUT TYPE="hidden" NAME="mode"    VALUE="<%= strMode %>">
	<INPUT TYPE="hidden" NAME="actMode" VALUE="">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">��</SPAN><FONT COLOR="#000000">�J�������񃁃��e�i���X</FONT></B></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
		<TR>
			<TD ALIGN="right">
				<TABLE BORDER="0" CELLPADDING="5" CELLSPACING="0">
					<TR>
<%
						strURL = "mntSearchOrgWkPost.asp"
						strURL = strURL & "?orgCd1=" & strOrgCd1
						strURL = strURL & "&orgCd2=" & strOrgCd2
%>
						<TD><A HREF="<%= strURL %>"><IMG SRC="/webhains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�J������̌�����ʂɖ߂�"></A></TD>
<%
						'�X�V���͍폜�{�^����\������
						If strMode = "update" Then
%>
							<TD><A HREF="javascript:submitForm('<%= ACTMODE_DELETE %>')"><IMG SRC="/webhains/images/delete.gif" WIDTH="77" HEIGHT="24" ALT="���̘J����������폜���܂�"></A></TD>
<%
						End If
%>
						<TD><A HREF="javascript:submitForm('<%= ACTMODE_SAVE %>')"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="���͂����f�[�^��ۑ����܂�"></A></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
<%
	'�ۑ��A�폜�������͊����ʒm���s���A�����Ȃ��΃G���[���b�Z�[�W��ҏW����
	Select Case strActMode
		Case ACTMODE_SAVED
			EditMessage "�ۑ����������܂����B", MESSAGETYPE_NORMAL
		Case ACTMODE_DELETED
			EditMessage "�폜���������܂����B", MESSAGETYPE_NORMAL
		Case Else
			EditMessage strArrMessage, MESSAGETYPE_WARNING
	End Select
%>
	<BR>

	<INPUT TYPE="hidden" NAME="orgCd1"       VALUE="<%= strOrgCd1       %>">
	<INPUT TYPE="hidden" NAME="orgCd2"       VALUE="<%= strOrgCd2       %>">
	<INPUT TYPE="hidden" NAME="orgWkPostSeq" VALUE="<%= strOrgWkPostSeq %>">

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" NOWRAP>�c��</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
<%
						Do
							'�c�̃R�[�h���w��̏ꍇ�̓K�C�h�{�^����\������
							If strOrgCd1 = "" Or strOrgCd2 = "" Then
%>
								<TD><A HREF="javascript:callOrgGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
								<TD>&nbsp;</TD>
<%
								Exit Do
							End If

							'�c�̏��ǂݍ���
							Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
							objOrganization.SelectOrg strOrgCd1, strOrgCd2, , , , strOrgSName

							Exit Do
						Loop
%>
						<TD NOWRAP><SPAN ID="orgSName"><%= strOrgSName %></SPAN></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" NOWRAP>�J������R�[�h</TD>
<%
			'�}�����[�h�̏ꍇ�̓e�L�X�g�\�����s���A�X�V���[�h�̏ꍇ��hidden�ŃR�[�h��ێ�
			If strMode = MODE_INSERT Then
%>
				<TD><INPUT TYPE="text" NAME="orgWkPostCd" SIZE="13" MAXLENGTH="10" VALUE="<%= strOrgWkPostCd %>"></TD>
<%
			Else
%>
				<TD><INPUT TYPE="hidden" NAME="orgWkPostCd" VALUE="<%= strOrgWkPostCd %>"><%= strOrgWkPostCd %></TD>
<%
			End If
%>
		</TR>
		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" NOWRAP>�J���������</TD>
			<TD><INPUT TYPE="text" NAME="orgWkPostName" SIZE="104" MAXLENGTH="40" VALUE="<%= strOrgWkPostName %>" STYLE="ime-mode:active;"></TD>
		</TR>
	</TABLE>
<%
	Do

		'�X�V���[�h�ȊO�͉������Ȃ�
		If strMode <> MODE_UPDATE Then
			Exit Do
		End If
%>
		<BR><BR>

		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="1" WIDTH="650">
			<TR>
				<TD NOWRAP>���̘J��������Q�Ƃ��Ă��鏊�����</TD>
				<TD ALIGN="right" NOWRAP><A HREF="javascript:callAllocOrgPostWindow()">������͈͎w�肵�Ă��̘J������ւ̎Q�Ƃ��s��</A></TD>
			</TR>
			<TR>
				<TD COLSPAN="2" BGCOLOR="#999999"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1" ALT=""></TD>
			</TR>
		</TABLE>

		<BR>
<%
		'���������𖞂������R�[�h�������擾
		lngCount = objOrgPost.SelectOrgPostListFromOrgWkPostSeq(strOrgCd1, strOrgCd2, strOrgWkPostSeq, lngStartPos, lngGetCount, strArrOrgBsdCd, strArrOrgRoomCd, strArrOrgPostCd, strArrOrgPostName, strArrOrgPostKName, strArrOrgBsdName, strArrOrgBsdKName, strArrOrgRoomName,  strArrOrgRoomKName)

		'�������ʂ����݂��Ȃ��ꍇ�̓��b�Z�[�W��ҏW
		If lngCount = 0 Then
%>
			<IMG SRC="/webHains/images/spacer.gif" WIDTH="15" HEIGHT="1" ALT="">�������͂���܂���B
<%
			Exit Do
		End If
%>
		<IMG SRC="/webHains/images/spacer.gif" WIDTH="15" HEIGHT="1" ALT=""><FONT COLOR="#ff6600"><B><%= lngCount %></B></FONT>���̏�����񂪂���܂��B<BR><BR>

		<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
			<TR>
				<TD WIDTH="10"></TD>
				<TD NOWRAP>�R�[�h</TD>
				<TD WIDTH="10"></TD>
				<TD NOWRAP>��������</TD>
				<TD WIDTH="10"></TD>
				<TD NOWRAP>���ƕ�</TD>
				<TD WIDTH="10"></TD>
				<TD NOWRAP>����</TD>
			</TR>
			<TR>
				<TD></TD>
				<TD BGCOLOR="#999999" COLSPAN="8"></TD>
			</TR>
			<TR>
				<TD HEIGHT="2"></TD>
			</TR>
<%
			'������񃁃��e�i���X����߂��悤�A�{��ʂ�URL��ҏW
			strURL2 = Request.ServerVariables("SCRIPT_NAME")
			strURL2 = strURL2 & "?mode="        & MODE_UPDATE
			strURL2 = strURL2 & "&orgCd1="      & strOrgCd1
			strURL2 = strURL2 & "&orgCd2="      & strOrgCd2
			strURL2 = strURL2 & "&orgWkPostCd=" & strOrgWkPostCd

			For i = 0 To UBound(strArrOrgBsdCd)

				'�����I������URL��ҏW
				strURL = "/webHains/contents/maintenance/orgPost/mntOrgPost.asp"
				strURL = strURL & "?mode="      & "update"
				strURL = strURL & "&orgCd1="    & strOrgCd1
				strURL = strURL & "&orgCd2="    & strOrgCd2
				strURL = strURL & "&orgBsdCd="  & strArrOrgBsdCd(i)
				strURL = strURL & "&orgRoomCd=" & strArrOrgRoomCd(i)
				strURL = strURL & "&orgPostCd=" & strArrOrgPostCd(i)
				strURL = strURL & "&prevURL="   & Server.URLEncode(strURL2)

				'�������̕ҏW
%>
				<TR>
					<TD WIDTH="10"></TD>
					<TD NOWRAP><%= strArrOrgPostCd(i) %></TD>
					<TD WIDTH="10"></TD>
					<TD NOWRAP><A HREF="<%= strURL %>"><%= strArrOrgPostName(i) %></A></TD>
					<TD></TD>
					<TD NOWRAP><FONT COLOR="#aaaaaa"><%= strArrOrgBsdName(i) %></FONT></TD>
					<TD></TD>
					<TD NOWRAP><FONT COLOR="#aaaaaa"><%= strArrOrgRoomName(i) %></FONT></TD>
				</TR>
<%
			Next
%>
		</TABLE>
<%
		'�y�[�W���O�i�r�Q�[�^�̕ҏW
		strURL = Request.ServerVariables("SCRIPT_NAME")
		strURL = strURL & "?mode="        & MODE_UPDATE
		strURL = strURL & "&orgCd1="      & strOrgCd1
		strURL = strURL & "&orgCd2="      & strOrgCd2
		strURL = strURL & "&orgWkPostCd=" & strOrgWkPostCd
%>
		<%= EditPageNavi(strURL, lngCount, lngStartPos, lngGetCount) %>
<%
		Exit Do
	Loop
%>
	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
