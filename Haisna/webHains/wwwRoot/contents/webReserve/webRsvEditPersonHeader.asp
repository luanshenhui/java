<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �h�b�N�\�����݌l���(�w�b�_) (Ver1.0.0)
'	   AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon		'���ʃN���X
Dim objWebRsv		'web�\����A�N�Z�X�p

'�����l
Dim dtmCslDate		'��f�N����
Dim lngWebNo		'webNo.
Dim dtmBirth		'���N����
Dim blnReadOnly		'�ǂݍ��ݐ�p

Dim strZipNo		'�X�֔ԍ�
Dim strAddress1		'�Z��1
Dim strAddress2		'�Z��2
Dim strAddress3		'�Z��3
Dim strTel			'�d�b�ԍ�
Dim strEMail		'e-mail
Dim strOfficeName	'�Ζ��於��
Dim strOfficeTel	'�Ζ���d�b�ԍ�

Dim strZipNo1		'�X�֔ԍ�1
Dim strZipNo2		'�X�֔ԍ�2
Dim strEditZipNo	'�ҏW�p�̗X�֔ԍ�

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
dtmCslDate  = CDate(Request("cslDate"))
lngWebNo    = CLng("0" & Request("webNo"))
dtmBirth    = CDate(Request("birth"))
blnReadOnly = (Request("readOnly") <> "")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�h�b�N�\���l���</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
function regist() {
	top.regist();
}
function closeWindow() {
	top.opener.closeEditPersonalWindow();
}

// ��������
function initialize() {

	// ��{���ł̕ێ��l��ݒ�
	top.getHeader();
<%
	'�ǂݎ���p��
	If blnReadOnly Then

		'���ׂĂ̓��͗v�f���g�p�s�\�ɂ���
%>
		top.opener.top.disableElements( document.entryForm );
<%
		'�{�^���̃N���A
%>
		document.getElementById('saveButton').innerHTML  = '';
<%
	End If
%>
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 10px 0 0 10px; }
</style>
</HEAD>
<BODY ONLOAD="javascript:initialize()">
<FORM NAME="entryForm" action="#">
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000">�h�b�N�\���l���</FONT></B></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="3">
		<TR>
			<TD ID="saveButton"><A HREF="javascript:regist()"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="���͂����f�[�^��ۑ����܂�"></A></TD>
			<TD><A HREF="javascript:closeWindow()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z��"></A></TD>
		</TR>
	</TABLE>
	<SPAN ID="errMsg"></SPAN>
	<BR>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�l�h�c</TD>
			<TD ID="perId" NOWRAP></TD>
		</TR>
		<TR>
			<TD BGCOLOR="#eeeeee" ALIGN="right">�t���K�i</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD>��&nbsp;</TD>
						<TD><INPUT TYPE="text" NAME="lastKName"  SIZE="50" MAXLENGTH="25" VALUE="" STYLE="ime-mode:active;"></TD>
						<TD>&nbsp;��&nbsp;</TD>
						<TD><INPUT TYPE="text" NAME="firstKName" SIZE="50" MAXLENGTH="25" VALUE="" STYLE="ime-mode:active;"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD BGCOLOR="#eeeeee" ALIGN="right">���O</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD>��&nbsp;</TD>
						<TD><INPUT TYPE="text" NAME="lastName"  SIZE="50" MAXLENGTH="25" VALUE="" STYLE="ime-mode:active;"></TD>
						<TD>&nbsp;��&nbsp;</TD>
						<TD><INPUT TYPE="text" NAME="firstName" SIZE="50" MAXLENGTH="25" VALUE="" STYLE="ime-mode:active;"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD BGCOLOR="#eeeeee" ALIGN="right">���[�}����</td>
			<TD><INPUT TYPE="text" NAME="romeName" SIZE="111" MAXLENGTH="60" VALUE="" STYLE="ime-mode:disabled;"></TD>
		</TR>
		<TR>
			<TD HEIGHT="10"></TD>
		</TR>
		<TR>
			<TD BGCOLOR="#eeeeee" ALIGN="right">����</TD>
			<TD ID="gender"></TD>
		</TR>
<%
		'�I�u�W�F�N�g�̃C���X�^���X�쐬
		Set objCommon = Server.CreateObject("HainsCommon.Common")
%>
		<TR>
			<TD BGCOLOR="#eeeeee" ALIGN="right">���N����</TD>
			<TD><%= objCommon.FormatString(dtmBirth, "ggge�iyyyy�j�Nm��d��") %></TD>
		</TR>
<%
		'�I�u�W�F�N�g�̉��
		Set objCommon = Nothing
%>
		<TR>
			<TD HEIGHT="10"></TD>
		</TR>
		<TR>
			<TD>�\�����ݏ��</TD>
		</TR>
<%
		'�I�u�W�F�N�g�̃C���X�^���X�쐬
		Set objWebRsv = Server.CreateObject("HainsWebRsv.WebRsv")
	
		'web�\����ǂݍ���
		objWebRsv.SelectWebRsv dtmCslDate, lngWebNo, , , , , , , , , , , , , strZipNo, strAddress1, strAddress2, strAddress3, strTel, strEMail, strOfficeName, strOfficeTel

		'�I�u�W�F�N�g�̉��
		Set objWebRsv = Nothing
%>
		<TR>
			<TD BGCOLOR="#eeeeee" ALIGN="right">�Z��</TD>
<%
			'�X�֔ԍ��w�莞
			If strZipNo <> "" Then
				strZipNo1 = Left(strZipNo, 3)
				strZipNo2 = Mid(strZipNo, 4, 4)
				strEditZipNo = strZipNo1 & IIf(strZipNo2 <> "", "-", "") & strZipNo2
			End If
%>
			<TD NOWRAP><%= strEditZipNo & "&nbsp;" & strAddress1 & strAddress2 & strAddress3 %></TD>
		</TR>
		<TR>
			<TD BGCOLOR="#eeeeee" ALIGN="right">�d�b�ԍ�</TD>
			<TD NOWRAP><%= strTel %></TD>
		</TR>
		<TR>
			<TD BGCOLOR="#eeeeee" ALIGN="right">E-mail</TD>
			<TD NOWRAP><%= strEMail %></TD>
		</TR>
		<TR>
			<TD BGCOLOR="#eeeeee" ALIGN="right">�Ζ���</TD>
			<TD NOWRAP><%= strOfficeName %></TD>
		</TR>
		<TR>
			<TD NOWRAP BGCOLOR="#eeeeee" ALIGN="right">�Ζ���d�b�ԍ�</TD>
			<TD NOWRAP><%= strOfficeTel %></TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>
