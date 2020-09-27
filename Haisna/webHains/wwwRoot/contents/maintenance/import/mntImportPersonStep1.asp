<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		���ۃf�[�^��荞��(�{�l�E�Ƒ��̑I��) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"  -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const DATADIV_SELF   = "self"	'��荞�݃f�[�^�敪(�{�l)
Const DATADIV_FAMILY = "family"	'��荞�݃f�[�^�敪(�Ƒ�)

Const MODRIVELETTER  = "F"		'�l�n�h���C�u����

'�I�u�W�F�N�g
Dim objFso		'�t�@�C���V�X�e���I�u�W�F�N�g
Dim objDrive	'�h���C�u�I�u�W�F�N�g

'�����l
Dim strDataDiv	'��荞�݃f�[�^�敪

Dim strMessage	'�G���[���b�Z�[�W

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
strDataDiv = Request("dataDiv")

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do

	'�u���ցv�{�^����������ĂȂ���Ή������Ȃ�
	If Request("next.x") = "" Then
		Exit Do
	End If

	'��荞�݃f�[�^�敪�̕K�{�`�F�b�N
	If strDataDiv = "" Then
		strMessage = "��荞�݂��s���f�[�^���I������Ă��܂���B"
		Exit Do
	End If

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objFso = CreateObject("Scripting.FileSystemObject")

	'�h���C�u���̂̑��݃`�F�b�N
	If Not objFso.DriveExists(MODRIVELETTER) Then
		strMessage = UCase(MODRIVELETTER) & "�h���C�u�����݂��܂���B"
		Exit Do
	End If

	'�h���C�u�I�u�W�F�N�g�̎擾
	Set objDrive = objFso.GetDrive(MODRIVELETTER)

	'�h���C�u�̏������ł��Ă��邩���`�F�b�N
	If Not objDrive.IsReady Then
		strMessage = "�h���C�u�̏������ł��Ă��܂���B"
		Exit Do
	End If

	'�X�e�b�v�Q��
	Response.Redirect "mntImportPersonStep2.asp?dataDiv=" & strDataDiv & "&driveLetter=" & MODRIVELETTER

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
<TITLE>���ۃf�[�^��荞��</TITLE>
<STYLE TYPE="text/css">
td.mnttab { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">��</SPAN><FONT COLOR="#000000">Step1�F��荞�݃f�[�^�̑I��</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'���b�Z�[�W�̕ҏW
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)
%>
	<BR>��荞�݂��s���f�[�^��I�����Ă��������B<BR><BR>

	<TABLE BORDER="0" CELLPADDING="3" CELLSPACING="3">
		<TR>
			<TD><INPUT TYPE="radio" NAME="dataDiv" VALUE="<%= DATADIV_SELF %>" <%= IIf(strDataDiv = DATADIV_SELF, "CHECKED", "") %>></TD>
			<TD NOWRAP>�{�l�f�[�^</TD>
		</TR>
		<TR>
			<TD><INPUT TYPE="radio" NAME="dataDiv" VALUE="<%= DATADIV_FAMILY %>" <%= IIf(strDataDiv = DATADIV_FAMILY, "CHECKED", "") %>></TD>
			<TD NOWRAP>�Ƒ��f�[�^</TD>
		</TR>
	</TABLE>

	<BR>�I�����ꂽ�f�[�^���i�[����Ă���l�n���j�d�m�r�u�O�O�P�T�[�o�ɃZ�b�g���A�u���ցv���N���b�N���Ă��������B<BR><BR><BR>

	<A HREF="/webHains/contents/maintenance/mntMenu.asp"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�߂�"></A>
	<INPUT TYPE="image" NAME="next" SRC="/webHains/images/next.gif" WIDTH="77" HEIGHT="24" ALT="����">

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>