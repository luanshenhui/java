<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�c�̏��̒��o (Ver0.0.1)
'		AUTHER  : Toyonobu Manabe@takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/download.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim strMode				'�������[�h(���o���s:"edit")

'����p
Dim objOrganization		'�c�̃e�[�u���A�N�Z�X�pCOM�I�u�W�F�N�g
Dim strFileName			'�o��CSV�t�@�C����
Dim strDownloadFile		'�_�E�����[�h�t�@�C����
Dim strArrMessage		'�G���[���b�Z�[�W(�S��)
Dim lngMessageStatus	'���b�Z�[�W�X�e�[�^�X(MessageType:NORMAL or WARNING)
Dim lngCount			'�o�̓f�[�^����

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------

'CSV�t�@�C���i�[�p�X�ݒ�
strDownloadFile   = CSV_DATAPATH & CSV_ORGANIZATION		'�_�E�����[�h�t�@�C�����Z�b�g
strFileName       = Server.MapPath(strDownloadFile)		'CSV�t�@�C�����Z�b�g

strMode           = Request("mode") & ""				'�������[�h�̎擾

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objOrganization = Server.CreateObject("HainsCsvOrganization.CsvOrganization")

'CSV�t�@�C���ҏW�����̐���
Do

	'�u���o���������s�v������
	If strMode = "edit" Then

		'CSV�t�@�C���̕ҏW
		lngCount = objOrganization.EditCSVDatOrg(strFileName)

		'�f�[�^������΃_�E�����[�h�A������΃��b�Z�[�W���Z�b�g
		If lngCount > 0 Then
			Response.ContentType = "application/x-download"
			Response.AddHeader "Content-Type", "text/csv;charset=Shift_JIS"
			Response.AddHeader "Content-Disposition","filename=" & CSV_ORGANIZATION
			Server.Execute strDownloadFile
			Response.End
		Else
			ReDim strArrMessage(0)
			strArrMessage(0) = "�w��̃f�[�^�͂���܂���ł����B"
			lngMessageStatus = MESSAGETYPE_NORMAL
		End If

	End If

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
<TITLE>�c�̏��̒��o</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// �ĕ\��
function redirectPage( actionmode ) {

	document.entryCondition.mode.value = actionmode;		/* ���샂�[�h�ݒ� */
	document.entryCondition.submit();						/* ���g�֑��M */

	return false;

}

//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.datatab  { background-color:#ffffff }
</STYLE>
</HEAD>

<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryCondition" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="mode" VALUE="<%= strMode %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="download">��</SPAN><FONT COLOR="#000000">�c�̏��̒��o</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'���b�Z�[�W�̕ҏW
	Call EditMessage(strArrMessage, lngMessageStatus)
%>
	<BR>

	<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>    
        <A HREF="javascript:function voi(){};voi()" ONCLICK="return redirectPage('edit')"><IMG SRC="/webHains/images/DataSelect.gif"></A>
    <%  end if  %>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
