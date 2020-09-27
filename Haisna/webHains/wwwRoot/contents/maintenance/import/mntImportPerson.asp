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
Const DATADIV_SELF   = "self"		'��荞�݃f�[�^�敪(�{�l)
Const DATADIV_FAMILY = "family"		'��荞�݃f�[�^�敪(�Ƒ�)

'�I�u�W�F�N�g
Dim objExec			'��荞�ݏ������s�p
Dim objFso			'�t�@�C���V�X�e���I�u�W�F�N�g
Dim objTempFolder	'�t�H���_�I�u�W�F�N�g

'�����l
Dim strDataDiv		'��荞�݃f�[�^�敪
Dim strDriveLetter	'�h���C�u����
Dim strFileName		'��荞�݃t�@�C����
Dim strActEnd		'�������J�n�ς݂ł���Βl���i�[�����

Dim strImportFile	'��荞�݃t�@�C����
Dim strTempFile		'�ꎞ�t�@�C����

Dim strMessage		'�G���[���b�Z�[�W
Dim strURL			'URL������

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
strDataDiv     = Request("dataDiv")
strDriveLetter = Request("driveLetter")
strFileName    = Request("fileName")
strActEnd      = Request("actEnd")

Do

	'�������J�n�ς݂ł���Ή������Ȃ�
	If strActEnd <> "" Then
		Exit Do
	End If

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objFso = CreateObject("Scripting.FileSystemObject")

	'�h���C�u�����ƃt�@�C��������荞�݃t�@�C�����̃t���p�X���쐬
	strImportFile = strDriveLetter & ":\" & strFileName

	'�ꎞ�t�@�C���̃t�H���_���擾
	Set objTempFolder = objFso.GetSpecialFolder(2)
	If objTempFolder Is Nothing Then
		Exit Do
	End If

	'�ꎞ�t�@�C�����������_���ɍ쐬
	strTempFile = Server.MapPath("/webHains/Temp") & "\" & strFileName

	'�t�@�C���̕���
	objFso.CopyFile strImportFile, strTempFile, True

	'��荞�ݏ����N��
	Set objExec = Server.CreateObject("HainsCooperation.Exec")
	objExec.Run "cscript " & Server.MapPath("/webHains/script") & "\ImportIsr.vbs " & strDataDiv & " " & strTempFile & " " & Session("USERID")

	'���������Ƃ���
	strURL = Request.ServerVariables("SCRIPT_NAME")
	strURL = strURL & "?dataDiv="     & strDataDiv
	strURL = strURL & "&driveLetter=" & strDriveLetter
	strURL = strURL & "&fileName="    & strFileName
	strURL = strURL & "&actEnd="      & "actEnd"
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
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">��</SPAN><FONT COLOR="#000000">Step3�F�N������</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>����<%= IIf(strDataDiv = DATADIV_SELF, "�{�l", "�Ƒ�") %>�f�[�^�̎�荞�ݏ������J�n���܂����B�ڍׂ̓V�X�e�����O���Q�Ƃ��ĉ������B<BR><BR><BR>

	<A HREF="/webHains/contents/maintenance/hainslog/dispHainsLog.asp?mode=print&transactionDiv=<%= IIf(strDataDiv = DATADIV_SELF, "LOGISRSLF", "LOGISRFML") %>"><IMG SRC="/webHains/images/prevlog.gif" WIDTH="77" HEIGHT="24" ALT="���O���Q�Ƃ���"></A><BR><BR>
	<A HREF="/webHains/contents/maintenance/mntMenu.asp"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�߂�"></A>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>