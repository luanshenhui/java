<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �h�b�N�\�����݌l���(�{�f�B) (Ver1.0.0)
'	   AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/EditPrefList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Dim blnReadOnly	'�ǂݍ��ݐ�p

Dim strTitle	'���o��
Dim i			'�C���f�b�N�X

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
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
<!-- #include virtual = "/webHains/includes/zipGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// �X�֔ԍ��K�C�h�Ăяo��
function callZipGuide( index ) {

	var objForm = document.entryForm;

	zipGuide_showGuideZip( objForm.prefCd[ index ].value, objForm.zipCd[ index ], objForm.prefCd[ index ], objForm.cityName[ index ], objForm.address1[ index ] );

}

// �X�֔ԍ��̃N���A
function clearZipInfo( index ) {

	zipGuide_clearZipInfo( document.entryForm.zipCd[ index ] );

}

// ��������
function initialize() {

	// ��{���ł̕ێ��l��ݒ�
	top.getBody();
<%
	'�ǂݎ���p���͂��ׂĂ̓��͗v�f���g�p�s�\�ɂ���
	If blnReadOnly Then
%>
		top.opener.top.disableElements( document.entryForm );
<%
	End If
%>
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 0 0 0 10px; }
</style>
</HEAD>
<BODY ONLOAD="javascript:initialize()" ONUNLOAD="javascript:zipGuide_closeGuideZip()">
<FORM NAME="entryForm" action="#">
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
<%
		For i = 0 To 2

			'���o���̕ҏW
			Select Case i
				Case 0
					strTitle = "����"
				Case 1
					strTitle = "�Ζ���"
				Case 2
					strTitle = "���̑�"
			End Select
%>
			<TR>
				<TD NOWRAP>�Z���i<%= strTitle %>�j</TD>
			</TR>
			<TR>
				<TD BGCOLOR="#eeeeee" ALIGN="right">�X�֔ԍ�</TD>
				<TD>
					<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
<%
						If Not blnReadOnly Then
%>
							<TD><A HREF="javascript:callZipGuide(<%= i %>)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�X�֔ԍ��K�C�h�\��"></A></TD>
							<TD><A HREF="javascript:clearZipInfo(<%= i %>)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�X�֔ԍ����폜���܂�"></A></TD>
<%
						End If
%>
						<TD><INPUT TYPE="text" NAME="zipCd" VALUE="" SIZE="9" MAXLENGTH="7" STYLE="ime-mode:disabled;"></TD>
					</TABLE>
				</TD>
			</TR>
			<TR>
				<TD BGCOLOR="#eeeeee" ALIGN="right">�s���{��</TD>
				<TD><%= EditPrefList("prefCd", "") %></TD>
			</TR>
			<TR>
				<TD BGCOLOR="#eeeeee" ALIGN="right">�s�撬��</TD>
				<TD><INPUT TYPE="text" NAME="cityName" SIZE="65" MAXLENGTH="50" VALUE="" STYLE="ime-mode:active;"></TD>
			</TR>
			<TR>
				<TD BGCOLOR="#eeeeee" ALIGN="right">�Z���P</TD>
				<TD><INPUT TYPE="text" NAME="address1" SIZE="78" MAXLENGTH="60" VALUE="" STYLE="ime-mode:active;"></TD>
			</TR>
			<TR>
				<TD BGCOLOR="#eeeeee" ALIGN="right">�Z���Q</TD>
				<TD><INPUT TYPE="text" NAME="address2" SIZE="78" MAXLENGTH="60" VALUE="" STYLE="ime-mode:active;"></TD>
			</TR>
			<TR>
				<TD HEIGHT="10"></TD>
			</TR>
			<TR>
				<TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�d�b�ԍ��P</TD>
				<TD><INPUT TYPE="text" NAME="tel1"  SIZE="19" MAXLENGTH="15" VALUE="" STYLE="ime-mode:disabled;"></TD>
			</TR>
			<TR>
				<TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�g�єԍ�</TD>
				<TD><INPUT TYPE="text" NAME="phone" SIZE="19" MAXLENGTH="15" VALUE="" STYLE="ime-mode:disabled;"></TD>
			</TR>
			<TR>
				<TD BGCOLOR="#eeeeee" ALIGN="right">�d�b�ԍ��Q</TD>
				<TD>&nbsp;<SPAN ID="tel2_<%= i %>"></SPAN></TD>
			</TR>
			<TR>
				<TD BGCOLOR="#eeeeee" ALIGN="right">����</TD>
				<TD>&nbsp;<SPAN ID="extension_<%= i %>"></SPAN></TD>
			</TR>
			<TR>
				<TD BGCOLOR="#eeeeee" ALIGN="right">FAX�ԍ�</TD>
				<TD>&nbsp;<SPAN ID="fax_<%= i %>"></SPAN></TD>
			</TR>
			<TR>
				<TD NOWRAP BGCOLOR="#eeeeee" ALIGN="right">E-mail�A�h���X</TD>
				<TD><INPUT TYPE="text" NAME="eMail" SIZE="52" MAXLENGTH="40" VALUE="" STYLE="ime-mode:disabled;"></TD>
			</TR>
			<TR>
				<TD HEIGHT="10"></TD>
			</TR>
<%
		Next
%>
	</TABLE>
</FORM>
</BODY>
</HTML>
