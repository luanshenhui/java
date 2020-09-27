<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		���ƕ���񃁃��e�i���X(���C�����) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
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
Dim objCommon		'���ʃN���X
Dim objOrganization	'�c�̏��A�N�Z�X�p
Dim objOrgBsd		'���ƕ����A�N�Z�X�p

'�����l�i�{�X�N���v�g���Ăяo���ۂ̈��������`���܂��j
Dim strMode			'�������[�h(�}��:"insert"�A�X�V:"update")
Dim strActMode		'���샂�[�h(�ۑ�:"save"�A�ۑ�����:"saved")
Dim strOrgCd1		'�c�̃R�[�h1
Dim strOrgCd2		'�c�̃R�[�h2
Dim strOrgBsdCd		'���ƕ��R�[�h
Dim strOrgBsdKName	'���ƕ��J�i����
Dim strOrgBsdName	'���ƕ�����

'��Ɨp�̕ϐ�
Dim strOrgSName		'�c�̗���
Dim strArrMessage	'�G���[���b�Z�[�W
Dim strURL			'�W�����v���URL
Dim Ret				'�֐��߂�l

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objOrgBsd       = Server.CreateObject("HainsOrgBsd.OrgBsd")

'�����l�̎擾
strMode        = Request("mode")
strActMode     = Request("actMode")
strOrgCd1      = Request("orgCd1")
strOrgCd2      = Request("orgCd2")
strOrgBsdCd    = Request("orgBsdCd")
strOrgBsdName  = Request("orgBsdName")
strOrgBsdKName = Request("orgBsdKName")

'�������[�h���w�莞�͑}�����[�h�Ƃ���
strMode = IIf(strMode = "", MODE_INSERT, strMode)

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do

	'�폜���̏���
	If strActMode = ACTMODE_DELETE Then

		'���ƕ����e�[�u�����R�[�h�폜
		Ret = objOrgBsd.DeleteOrgBsd(strOrgCd1, strOrgCd2, strOrgBsdCd)
		If Ret = 0 Then
			strArrMessage = Array("���̎��ƕ��͑�����Q�Ƃ���Ă��܂��B�폜�ł��܂���B")
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

			'���ƕ��e�[�u�����R�[�h�X�V
			Ret = objOrgBsd.UpdateOrgBsd(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgBsdKName, strOrgBsdName)

			'���R�[�h�����݂��Ȃ��ꍇ�͐V�K���̏������s��
			If Ret = 0 Then
				strMode = MODE_INSERT
			End If

		End If

		'�}���̏ꍇ
		If strMode = MODE_INSERT Then

			'���ƕ��e�[�u�����R�[�h�}��
			Ret = objOrgBsd.InsertOrgBsd(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgBsdKName, strOrgBsdName)

			'�L�[�d�����̓G���[���b�Z�[�W��ҏW����
			If Ret = INSERT_DUPLICATE Then
				strArrMessage = Array("����c�́A���ƕ��R�[�h�̎��ƕ���񂪂��łɑ��݂��܂��B")
				Exit Do
			End If

		End If

		'�ۑ��ɐ��������ꍇ�͍X�V���[�h�Ŏ������g���Ăяo��
		strURL = Request.ServerVariables("SCRIPT_NAME")
		strURL = strURL & "?mode="     & MODE_UPDATE
		strURL = strURL & "&actMode="  & ACTMODE_SAVED
		strURL = strURL & "&orgCd1="   & strOrgCd1
		strURL = strURL & "&orgCd2="   & strOrgCd2
		strURL = strURL & "&orgBsdCd=" & strOrgBsdCd
		Response.Redirect strURL
		Response.End

	End If

	'�V�K�̏ꍇ�͓ǂݍ��݂��s��Ȃ�
	If strMode = MODE_INSERT Then
		Exit Do
	End If

	'���ƕ��e�[�u�����R�[�h�ǂݍ���
	If objOrgBsd.SelectOrgBsd(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgBsdKName, strOrgBsdName) = False Then
		Err.Raise 1000, , "���ƕ���񂪑��݂��܂���B"
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

		'���ƕ��J�i����
		strMessage = .CheckWideValue("���ƕ��J�i����", strOrgBsdKName,  LENGTH_ORGBSD_ORGBSDKNAME)
		If strMessage = "" Then
			If .CheckKana(strOrgBsdKName) = False Then
				strMessage = "���ƕ��J�i���̂ɕs���ȕ������܂܂�܂��B"
			End If
		End If
		.AppendArray vntArrMessage, strMessage

		'���ƕ�����
		.AppendArray vntArrMessage, .CheckWideValue("���ƕ�����", strOrgBsdName, LENGTH_ORGBSD_ORGBSDNAME, CHECK_NECESSARY)

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
<TITLE>���ƕ���񃁃��e�i���X</TITLE>
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// �K�C�h��ʌĂяo��
// (1) �c�̃R�[�h�ɂ��Ă͑��text��hidden�Œ�`����邽�߁A�z��`���ƂȂ�ꍇ������B�i��F�_����̕��S���o�^��ʁj
//     �䂦�ɃI�u�W�F�N�g���̂������ɂēn���B
// (2) �c�̖��́i�����E�J�i�E���́j�ɂ��Ă�SPAN�^�O�Œ�`���ꂽID���w�肷��B
function callOrgGuide() {

	orgGuide_showGuideOrg( document.entryForm.orgCd1, document.entryForm.orgCd2, '', 'orgSName', '' );

}

// submit���̏���
function submitForm( actMode ) {

	// �폜���͊m�F���b�Z�[�W��\��
	if ( actMode == '<%= ACTMODE_DELETE %>' ) {
		if ( !confirm( '���̎��ƕ������폜���܂��B��낵���ł����H' ) ) {
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
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">��</SPAN><FONT COLOR="#000000">���ƕ���񃁃��e�i���X</FONT></B></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
		<TR>
			<TD ALIGN="right">
				<TABLE BORDER="0" CELLPADDING="5" CELLSPACING="0">
					<TR>
<%
						'�O��ʂ�URL�ҏW
						strURL = "mntSearchOrgBsd.asp"
						strURL = strURL & "?orgCd1=" & strOrgCd1
						strURL = strURL & "&orgCd2=" & strOrgCd2
%>
						<TD><A HREF="<%= strURL %>"><IMG SRC="/webhains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="���ƕ��̌�����ʂɖ߂�"></A></TD>
<%
						'�X�V���͍폜�{�^����\������
						If strMode = "update" And strOrgBsdCd <> "0000000000" Then
%>
							<TD><A HREF="javascript:submitForm('<%= ACTMODE_DELETE %>')"><IMG SRC="/webhains/images/delete.gif" WIDTH="77" HEIGHT="24" ALT="���̎��ƕ������폜���܂�"></A></TD>
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
			<TD ROWSPAN="5" WIDTH="5"></TD>
			<TD>
				<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
				<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
<%
						Do

							'�c�̃R�[�h���w�肳��Ă���ꍇ
							If strOrgCd1 <> "" And strOrgCd2 <> "" Then

								'�c�̏��ǂݍ���
								objOrganization.SelectOrg strOrgCd1, strOrgCd2, , , , strOrgSName

								Exit Do
							End If

							'�}�����[�h�̏ꍇ�̓K�C�h�{�^����\������
							If strMode = MODE_INSERT Then
%>
								<TD><A HREF="javascript:callOrgGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
								<TD>&nbsp;</TD>
<%
							End If

							Exit Do
						Loop
%>
						<TD NOWRAP><SPAN ID="orgSName"><%= strOrgSName %></SPAN></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right" NOWRAP>���ƕ��R�[�h</TD>
<%
			'�}�����[�h�̏ꍇ�̓e�L�X�g�\�����s���A�X�V���[�h�̏ꍇ��hidden�ŃR�[�h��ێ�
			If strMode = MODE_INSERT Then
%>
				<TD><INPUT TYPE="text" NAME="orgBsdCd" SIZE="<%= TextLength(LENGTH_ORGBSD_ORGBSDCD) %>" MAXLENGTH="<%= LENGTH_ORGBSD_ORGBSDCD %>" VALUE="<%= strOrgBsdCd %>"></TD>
<%
			Else
%>
				<TD><INPUT TYPE="hidden" NAME="orgBsdCd" VALUE="<%= strOrgBsdCd %>"><%= strOrgBsdCd %></TD>
<%
			End If
%>
		</TR>
		<TR>
			<TD HEIGHT="12"></TD>
		</TR>
		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right" NOWRAP>���ƕ��J�i����</TD>
			<TD><INPUT TYPE="text" NAME="orgBsdKName" SIZE="<%= TextLength(LENGTH_ORGBSD_ORGBSDKNAME) %>" MAXLENGTH="<%= TextMaxLength(LENGTH_ORGBSD_ORGBSDKNAME) %>" VALUE="<%= strOrgBsdKName %>" STYLE="ime-mode:active;"></TD>
		</TR>
		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right" NOWRAP>���ƕ�����</TD>
			<TD><INPUT TYPE="text" NAME="orgBsdName" SIZE="<%= TextLength(LENGTH_ORGBSD_ORGBSDNAME) %>" MAXLENGTH="<%= TextMaxLength(LENGTH_ORGBSD_ORGBSDNAME) %>" VALUE="<%= strOrgBsdName %>" STYLE="ime-mode:activate;"></TD>
		</TR>
	</TABLE>

</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
