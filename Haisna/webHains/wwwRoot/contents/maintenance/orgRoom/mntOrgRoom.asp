<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		������񃁃��e�i���X(���C�����) (Ver0.0.1)
'		AUTHER  : �����@���
'		Comment : �����̊e���ڂ̒����`�F�b�N�Ɏ��ƕ��̍��ڒ����g���Ă��邪�A
'				: �����������Ȃ̂Ŗ��Ȃ��Ǝv����ׂł���B
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"  -->
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

'COM�R���|�[�l���g
Dim objCommon			'���ʃN���X
Dim objOrganization		'�c�̏��A�N�Z�X�p
Dim objOrgBsd			'���ƕ����A�N�Z�X�p
Dim objOrgRoom			'�������A�N�Z�X�p

'�����l�i�{�X�N���v�g���Ăяo���ۂ̈��������`���܂��j
Dim strMode				'�������[�h(�}��:"insert"�A�X�V:"update")
Dim strActMode			'���샂�[�h(�ۑ�:"save"�A�ۑ�����:"saved")
Dim strOrgCd1			'�c�̃R�[�h1
Dim strOrgCd2			'�c�̃R�[�h2
Dim strOrgBsdCd			'���ƕ��R�[�h
Dim strOrgRoomCd		'�����R�[�h
Dim strOrgRoomKName		'�����J�i����
Dim strOrgRoomName		'��������

'��Ɨp�̕ϐ�
Dim strOrgSName			'�c�̗���
Dim strOrgBsdName		'���ƕ�����
Dim strArrMessage		'�G���[���b�Z�[�W
Dim strURL				'�W�����v���URL
Dim Ret					'�֐��߂�l

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objOrgBsd       = Server.CreateObject("HainsOrgBsd.OrgBsd")
Set objOrgRoom      = Server.CreateObject("HainsOrgRoom.OrgRoom")

'�����l�̎擾
strMode         = Request("mode")
strActMode      = Request("actMode")
strOrgCd1       = Request("orgCd1")
strOrgCd2       = Request("orgCd2")
strOrgBsdCd     = Request("orgBsdCd")
strOrgRoomCd    = Request("orgRoomCd")
strOrgRoomName  = Request("orgRoomName")
strOrgRoomKName	= Request("orgRoomKName")

'�������[�h���w�莞�͑}�����[�h�Ƃ���
strMode = IIf(strMode = "", MODE_INSERT, strMode)

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do

	'�폜���̏���
	If strActMode = ACTMODE_DELETE Then

		'�����e�[�u�����R�[�h�폜
		Ret = objOrgRoom.DeleteOrgRoom(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd)
		If Ret = 0 Then
			strArrMessage = Array("���̎����͑�����Q�Ƃ���Ă��܂��B�폜�ł��܂���B")
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

			'�����e�[�u�����R�[�h�X�V
			Ret = objOrgRoom.UpdateOrgRoom(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgRoomName, strOrgRoomKName)

			'���R�[�h�����݂��Ȃ��ꍇ�͐V�K���̏������s��
			If Ret = 0 Then
				strMode = MODE_INSERT
			End If

		End If

		'�}���̏ꍇ
		If strMode = MODE_INSERT Then

			'�����e�[�u�����R�[�h�}��
			Ret = objOrgRoom.InsertOrgRoom(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgRoomName, strOrgRoomKName)

			'�L�[�d�����̓G���[���b�Z�[�W��ҏW����
			If Ret = INSERT_DUPLICATE Then
				strArrMessage = Array("����c�́A���ƕ��A�����R�[�h�̎�����񂪂��łɑ��݂��܂��B")
				Exit Do
			End If

		End If

		'�ۑ��ɐ��������ꍇ�͍X�V���[�h�Ŏ������g���Ăяo��
		strURL = Request.ServerVariables("SCRIPT_NAME")
		strURL = strURL & "?mode="		& MODE_UPDATE
		strURL = strURL & "&actMode="	& ACTMODE_SAVED
		strURL = strURL & "&orgCd1="	& strOrgCd1
		strURL = strURL & "&orgCd2="	& strOrgCd2
		strURL = strURL & "&orgBsdCd="	& strOrgBsdCd
		strURL = strURL & "&orgRoomCd=" & strOrgRoomCd
		Response.Redirect strURL
		Response.End

	End If

	'�V�K�̏ꍇ�͓ǂݍ��݂��s��Ȃ�
	If strMode = MODE_INSERT Then
		Exit Do
	End If

	'�����e�[�u�����R�[�h�ǂݍ���
	If objOrgRoom.SelectOrgRoom(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgRoomName, strOrgRoomKName) = False Then
		Err.Raise 1000, , "������񂪑��݂��܂���B"
	End If

	'�������[�h���X�V�Ƃ���
	strMode = MODE_UPDATE

	Exit Do
Loop

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���ƕ����e�l�̑Ó����`�F�b�N���s��
'
' �����@�@ :
'
' �߂�l�@ : �G���[�l������ꍇ�A�G���[���b�Z�[�W�̔z���Ԃ�
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CheckValue()

	Dim vntArrMessage	'�G���[���b�Z�[�W�̏W��
	Dim strMessage		'�G���[���b�Z�[�W

	'�e�l�`�F�b�N����
	With objCommon

		'�c�̃R�[�h
		If strOrgCd1 = "" Or  strOrgCd2 = "" Then
			.AppendArray vntArrMessage, "�c�̂���͂��ĉ������B"
		End If

		'���ƕ��R�[�h
		.AppendArray vntArrMessage, .CheckAlphabetAndNumeric("���ƕ��R�[�h", strOrgBsdCd, LENGTH_ORGBSD_ORGBSDCD, CHECK_NECESSARY)

		'�����R�[�h
		.AppendArray vntArrMessage, .CheckAlphabetAndNumeric("�����R�[�h", strOrgRoomCd, LENGTH_ORGBSD_ORGBSDCD, CHECK_NECESSARY)

		'�����J�i����
		strMessage = .CheckWideValue("�����J�i����", strOrgRoomKName,  LENGTH_ORGBSD_ORGBSDKNAME)
		If strMessage = "" Then
			If .CheckKana(strOrgRoomKName) = False Then
				strMessage = "�����J�i���̂ɕs���ȕ������܂܂�܂��B"
			End If
		End If
		.AppendArray vntArrMessage, strMessage

		'��������
		.AppendArray vntArrMessage, .CheckWideValue("��������", strOrgRoomName, LENGTH_ORGBSD_ORGBSDNAME, CHECK_NECESSARY)

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
<TITLE>������񃁃��e�i���X</TITLE>
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// �K�C�h��ʌĂяo��
// (1) �c�̃R�[�h�ɂ��Ă͑��text��hidden�Œ�`����邽�߁A�z��`���ƂȂ�ꍇ������B�i��F�_����̕��S���o�^��ʁj
//     �䂦�ɃI�u�W�F�N�g���̂������ɂēn���B
// (2) �c�̖��́i�����E�J�i�E���́j�ɂ��Ă�SPAN�^�O�Œ�`���ꂽID���w�肷��B
function callOrgGuide() {

	orgGuide_showGuideOrg( document.entryForm.orgCd1, document.entryForm.orgCd2, '', 'orgSName', '' );

}

function callOrgBsdGuide() {

	orgPostGuide_getElement( document.entryForm.orgCd1, document.entryForm.orgCd2, 'orgName', document.entryForm.orgBsdCd, 'orgBsdName', '', '', '', '', '', '' );
	orgPostGuide_showGuideOrgBsd();

}

// submit���̏���
function submitForm( actMode ) {

	// �폜���͊m�F���b�Z�[�W��\��
	if ( actMode == '<%= ACTMODE_DELETE %>' ) {
		if ( !confirm( '���̎��������폜���܂��B��낵���ł����H' ) ) {
			return;
		}
	}

	// ���샂�[�h���w�肵��submit
	document.entryForm.actMode.value = actMode;
	document.entryForm.submit();

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.mnttab { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="mode"    VALUE="<%= strMode %>">
	<INPUT TYPE="hidden" NAME="actMode" VALUE="">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">��</SPAN><FONT COLOR="#000000">������񃁃��e�i���X</FONT></B></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
		<TR>
			<TD ALIGN="right">
				<TABLE BORDER="0" CELLPADDING="5" CELLSPACING="0">
					<TR>
<%
						'�O��ʂ�URL�ҏW
						strURL = "mntSearchOrgRoom.asp"
						strURL = strURL & "?orgCd1=" & strOrgCd1
						strURL = strURL & "&orgCd2=" & strOrgCd2
%>
						<TD><A HREF="<%= strURL %>"><IMG SRC="/webhains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�����̌�����ʂɖ߂�"></A></TD>
<%
						'�X�V���͍폜�{�^����\������
						If strMode = "update" And strOrgRoomCd <> "0000000000" Then
%>
							<TD><A HREF="javascript:submitForm('<%= ACTMODE_DELETE %>')"><IMG SRC="/webhains/images/delete.gif" WIDTH="77" HEIGHT="24" ALT="���̎��������폜���܂�"></A></TD>
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

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right" NOWRAP>�c��</TD>
			<!-- TD ROWSPAN="5" WIDTH="5"></TD -->
			<TD>
				<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
				<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
<%
						'�c�̃R�[�h���w�肳��Ă���ꍇ
						If strOrgCd1 <> "" And strOrgCd2 <> "" Then

							'�c�̏��ǂݍ���
							objOrganization.SelectOrg strOrgCd1, strOrgCd2, , , , strOrgSName

						End If
%>
						<TD NOWRAP><SPAN ID="orgSName"><%= strOrgSName %></SPAN></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>

		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right" NOWRAP>���ƕ�</TD>
			<TD>
				<INPUT TYPE="hidden" NAME="orgBsdCd" VALUE="<%= strOrgBsdCd %>">
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
<%
						'�}�����[�h�̏ꍇ�̓K�C�h�{�^����\������
						If strMode = MODE_INSERT Then
%>
							<TD><A HREF="javascript:callOrgBsdGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���ƕ������K�C�h��\��"></A></TD>
							<TD>&nbsp;</TD>
<%
						End If

						'�c�̃R�[�h���w�肳��Ă���ꍇ
						If strOrgCd1 <> "" And strOrgCd2 <> "" And strOrgBsdCd <> "" Then

							'�c�̏��ǂݍ���
							objOrgBsd.SelectOrgBsd strOrgCd1, strOrgCd2, strOrgBsdCd, , strOrgBsdName

						End If
%>
						<TD NOWRAP><SPAN ID="orgBsdName"><%= strOrgBsdName %></SPAN></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>

		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right" NOWRAP>�����R�[�h</TD>
<%
			'�}�����[�h�̏ꍇ�̓e�L�X�g�\�����s���A�X�V���[�h�̏ꍇ��hidden�ŃR�[�h��ێ�
			If strMode = MODE_INSERT Then
%>
				<TD><INPUT TYPE="text" NAME="orgRoomCd" SIZE="<%= TextLength(LENGTH_ORGBSD_ORGBSDCD) %>" MAXLENGTH="<%= LENGTH_ORGBSD_ORGBSDCD %>" VALUE="<%= strOrgRoomCd %>"></TD>
<%
			Else
%>
				<TD><INPUT TYPE="hidden" NAME="orgRoomCd" VALUE="<%= strOrgRoomCd %>"><%= strOrgRoomCd %></TD>
<%
			End If
%>
		</TR>
		<TR>
			<TD HEIGHT="12"></TD>
		</TR>
		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right" NOWRAP>�����J�i����</TD>
			<TD><INPUT TYPE="text" NAME="orgRoomKName" SIZE="<%= TextLength(LENGTH_ORGBSD_ORGBSDKNAME) %>" MAXLENGTH="<%= TextMaxLength(LENGTH_ORGBSD_ORGBSDKNAME) %>" VALUE="<%= strOrgRoomKName %>" STYLE="ime-mode:active;"></TD>
		</TR>
		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right" NOWRAP>��������</TD>
			<TD><INPUT TYPE="text" NAME="orgRoomName" SIZE="<%= TextLength(LENGTH_ORGBSD_ORGBSDNAME) %>" MAXLENGTH="<%= TextMaxLength(LENGTH_ORGBSD_ORGBSDNAME) %>" VALUE="<%= strOrgRoomName %>" STYLE="ime-mode:activate;"></TD>
		</TR>
	</TABLE>

</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
