<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �l�b�g�A�g�p�t�@�C���쐬  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g
Dim objHainsMchCooperation		'�l�b�g�A�g�p�t�@�C���쐬�p

'�p�����[�^
Dim lngRsvNo			'�\��ԍ��i���񕪁j
Dim Ret					'���A�l

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
lngRsvNo			= Request("rsvno")

Do
	Ret = -1

	If lngRsvNo <> "" Then
		'�I�u�W�F�N�g�̃C���X�^���X�쐬
		Set objHainsMchCooperation	= Server.CreateObject("HainsMchCooperation.MchCooperation")

		'�l�b�g�A�g�p�t�@�C���쐬
		Ret = objHainsMchCooperation.EditCSVDatMonshin( lngRsvNo )

		'�I�u�W�F�N�g�̃C���X�^���X�폜
		Set objHainsMchCooperation = Nothing
	End If

Exit Do
Loop
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�l�b�g�A�g�p�t�@�C���쐬</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 15px 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">

	<!-- �^�C�g���̕\�� -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="90%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="">���l�b�g�A�g�p�t�@�C���쐬</SPAN></B></TD>
		</TR>
	</TABLE>
	<BR>
	<BR>
<%
	If Ret > 0 Then
		'����I��
		Call EditMessage("�l�b�g�A�g�p�t�@�C�����쐬����܂����B", MESSAGETYPE_NORMAL)
	Else
		'�G���[���b�Z�[�W��ҏW
		Call EditMessage("�l�b�g�A�g�p�t�@�C���̍쐬�Ɏ��s���܂����B", MESSAGETYPE_WARNING)
	End If
%>
	<BR>
	<BR>
	<BR>
<TABLE BORDER="0" WIDTH="90%">
	<TR>
		<TD WIDTH="100%" ALIGN="right"><A HREF="JavaScript:close();"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�߂�" BORDER="0"></A></TD>
	</TR>
</TABLE>
</FORM>
</BODY>
</HTML>
