<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		���ۃf�[�^��荞��(�t�@�C���̑I��) (Ver0.0.1)
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

'�I�u�W�F�N�g
Dim objFso			'�t�@�C���V�X�e���I�u�W�F�N�g
Dim objFolder		'�t�H���_�I�u�W�F�N�g
Dim colFile			'�t�@�C���R���N�V����
Dim objFile			'�t�@�C���I�u�W�F�N�g

'�����l
Dim strDataDiv		'��荞�݃f�[�^�敪
Dim strDriveLetter	'�h���C�u����

Dim strMessage		'�G���[���b�Z�[�W

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
strDataDiv     = Request("dataDiv")
strDriveLetter = Request("driveLetter")

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objFso = CreateObject("Scripting.FileSystemObject")

'�ꗗ�\���ΏۂƂȂ�t�H���_(�����ł̓h���C�u�̃��[�g�t�H���_)�I�u�W�F�N�g���擾
Set objFolder = objFso.GetFolder(strDriveLetter & ":\")

'�t�@�C���R���N�V�����̎Q�Ɛݒ�
Set colFile = objFolder.Files
If colFile.Count = 0 Then
	strMessage = "��荞�݃t�@�C�������݂��܂���B"
End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>���ۃf�[�^��荞��</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
function importFile( fileName ) {

	var url;	// URL������

	if ( !confirm( '�I�����ꂽ�f�[�^����荞�݂܂��B��낵���ł����H' ) ) {
		return;
	}

	url = 'mntImportPerson.asp';
	url = url + '?dataDiv=<%= strDataDiv %>';
	url = url + '&driveLetter=<%= strDriveLetter %>';
	url = url + '&fileName=' + fileName;
	location.href = url;

}
//-->
</SCRIPT>
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
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">��</SPAN><FONT COLOR="#000000">Step2�F��荞�݃t�@�C���̑I��</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'���b�Z�[�W�̕ҏW
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)

	If colFile.Count > 0 Then
%>
		<BR>��荞�݂��s������<%= IIf(strDataDiv = DATADIV_SELF, "�{�l", "�Ƒ�") %>�f�[�^�t�@�C����I�����Ă��������B<BR><BR>

		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
<%
		For Each objFile In objFolder.Files
%>
			<TR>
				<TD WIDTH="30"></TD>
				<TD NOWRAP><A HREF="javascript:importFile('<%= objFile.Name %>')"><%= objFile.Name %></A></TD>
			</TR>
<%
		Next
%>
		</TABLE>
<%
	End If
%>
	<BR><BR><A HREF="javascript:history.back()"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�߂�"></A>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>