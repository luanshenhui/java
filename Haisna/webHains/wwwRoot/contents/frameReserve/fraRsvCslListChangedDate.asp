<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		��f���ꊇ�ύX(�ύX����) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"  -->
<%
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objConsult		'��f���A�N�Z�X�p
Dim objPerson		'�l���A�N�Z�X�p

'�����l
Dim dtmCslDate		'��f��
Dim strRsvNo		'�\��ԍ�

'��f���
Dim strWebColor		'web�J���[
Dim strCsName		'�R�[�X��
Dim strLastName		'��
Dim strFirstName	'��
Dim strOrgSName		'�c�̗���
Dim strOptName		'�I�v�V������
Dim strRsvGrpName	'�\��Q����
Dim lngCount		'���R�[�h��

Dim i				'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�����l�̎擾
dtmCslDate = CDate(Request("cslDate"))
strRsvNo   = ConvIStringToArray(Request("rsvNo"))
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�ύX����</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// �{��ʂ��J����Ă���ꍇ�͕K����f���ύX���s���Ă��邽�߁A�e��ʂł���\����ڍ׉�ʂ������[�h����
function closeWindow() {

	if ( opener != null ) {
		if ( opener.top != null ) {
			opener.top.location.reload();
		}
	}

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">
<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
	<TR>
		<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000">�ύX����</FONT></B></TD>
	</TR>
</TABLE>
<BR>�u<B><FONT COLOR="#ffa500"><%= Year(dtmCslDate) %>�N<%= Month(dtmCslDate) %>��<%= Day(dtmCslDate) %>��</FONT></B>�v �ɑ΂��� <B><FONT COLOR="#ffa500"><%= UBound(strRsvNo) + 1 %></FONT></B>���̎�f���ύX���s���܂����B<BR>
<BR>
<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
	<TR BGCOLOR="#dcdcdc">
		<TD NOWRAP WIDTH="120">��f�R�[�X</TD>
		<TD NOWRAP WIDTH="120">�l����</TD>
		<TD NOWRAP WIDTH="150">�c�̖�</TD>
		<TD NOWRAP WIDTH="200">�����I�v�V����</TD>
		<TD NOWRAP>���Ԙg</TD>
	</TR>
<%
	Set objConsult = Server.CreateObject("HainsConsult.Consult")

	'��f�҈ꗗ�̕ҏW
	For i = 0 To UBound(strRsvNo)

		'��f���ǂݍ���
		lngCount = objConsult.SelectConsultListForFraRsv(strRsvNo(i), strRsvNo(i), , , strWebColor, strCsName, , strLastName, strFirstName, , , , , , , , strOrgSName, strOptName, strRsvGrpName)
		If lngCount <= 0 Then
			Err.Raise 1000, , "��f��񂪑��݂��܂���B"
		End If
%>
		<TR BGCOLOR="#<%= IIf(i Mod 2 = 0, "ffffff", "e0ffff") %>">
			<TD NOWRAP><FONT COLOR="<%= strWebColor(0) %>">��</FONT><A HREF="/webHains/contents/reserve/rsvMain.asp?rsvNo=<%= strRsvNo(i) %>" TARGET="_blank"><%= strCsName(0) %></A></TD>
			<TD NOWRAP><%= Trim(strLastName(0) & "�@" & strFirstName(0)) %></TD>
			<TD NOWRAP><%= strOrgSName(0) %></TD>
			<TD NOWRAP><%= Replace(strOptName(0), ",", "�A") %></TD>
			<TD NOWRAP><%= strRsvGrpName(0) %></TD>
		</TR>
<%
	Next

	Set objConsult = Nothing
%>
</TABLE>
<BR>
<A HREF="javascript:close()"><IMG SRC="/webHains/images/toRsv.gif" ALT="�\��ڍ׏��֖߂�܂�" HEIGHT="24" WIDTH="77"></A>
</BODY>
</HTML>
