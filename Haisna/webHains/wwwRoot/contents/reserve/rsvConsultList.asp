<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		���f���ꗗ (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon		'���ʃN���X
Dim objConsult		'��f���A�N�Z�X�p

'�O��ʂ��瑗�M�����p�����[�^�l(�X�V�̂�)
Dim strPerId		'�lID
Dim strCslYear		'��f�N
Dim strCslMonth 	'��f��
Dim strCslDay		'��f��
Dim strRsvNo		'�\��ԍ�

'��f���
Dim strArrCslDate	'��f�N����
Dim strArrCsCd		'�R�[�X�R�[�h
Dim strArrCsName	'�R�[�X��
Dim strArrRsvNo		'�\��ԍ�
Dim strArrAge		'��f���N��
Dim lngCount		'���R�[�h��

Dim strCslDate		'��f�N����
Dim i				'�C���f�b�N�X
'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objConsult = Server.CreateObject("HainsConsult.Consult")

'�����l�̎擾
strPerId    = Request("perId")
strCslYear  = Request("cslYear")
strCslMonth = Request("cslMonth")
strCslDay   = Request("cslDay")
strRsvNo    = Request("rsvNo")

'��f�N�����̕ҏW
strCslDate = strCslYear & "/" & strCslMonth & "/" & strCslDay
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>���f���̈ꗗ</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// ���f���̑I��
function selectList( index ) {

	var myForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g
	var rsvNo;							// �\��ԍ�
	var cslDate;						// ��f�N����
	var csName;							// �R�[�X��

	// �Ăь��E�B���h�E�����݂��Ȃ���Ή������Ȃ�
	if ( opener == null ) {
		return;
	}

	if ( myForm.firstRsvNo.length == null ) {

		// ���f���ꗗ���P���������݂��Ȃ��ꍇ�̑I������
		rsvNo   = myForm.firstRsvNo.value;
		cslDate = myForm.firstCslDate.value;
		csName  = myForm.firstCsName.value;

	} else {

		// ���f���ꗗ�����������݂���ꍇ�̑I������
		rsvNo   = myForm.firstRsvNo[ index ].value;
		cslDate = myForm.firstCslDate[ index ].value;
		csName  = myForm.firstCsName[ index ].value;

	}

	// �e��ʂ̊֐��Ăяo��
	opener.top.setFirstCslInfo( rsvNo, cslDate, csName );

	// ��ʂ����
	opener.winConsult = null;
	close();
}
//-->
</SCRIPT>
</HEAD>
<BODY>

<FORM NAME="entryForm" action="#">
<%
	'���f���ꗗ�̓ǂݍ���
	lngCount = objConsult.SelectConsultHistory(strPerId, strCslDate, True, True, , strArrRsvNo, strArrCslDate, strArrCsCd, strArrCsName, strArrAge)
%>
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="100%">
		<TR BGCOLOR="#cccccc" ALIGN="center">
			<TD NOWRAP>��f��</TD>
			<TD WIDTH="100%">�R�[�X</TD>
		</TR>
<%
		'���f���ꗗ�̕ҏW�J�n
		For i = 0 To lngCount - 1
%>
			<INPUT TYPE="hidden" NAME="firstRsvNo"   VALUE="<%= strArrRsvNo(i)   %>">
			<INPUT TYPE="hidden" NAME="firstCslDate" VALUE="<%= strArrCslDate(i) %>">
			<INPUT TYPE="hidden" NAME="firstCsName"  VALUE="<%= strArrCsName(i)  %>">
			<TR BGCOLOR="#<%= IIf(i Mod 2 = 0, "ffffff", "eeeeee") %>">
				<TD><A HREF="JavaScript:selectList(<%= i %>)"><%= strArrCslDate(i) %></A></TD>
				<TD><%= strArrCsName(i) %></TD>
			</TR>
<%
		Next
%>
	</TABLE>

	<BR>

	<A HREF="JavaScript:close()"><IMG ALIGN="right" SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z������"></A>

</FORM>
</BODY>
</HTML>
