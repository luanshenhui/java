<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       �l��� �폜���� (Ver0.0.1)
'       AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim strPerID		'�l�h�c
Dim strLastName		'��
Dim strFirstName	'��

Dim objPerson	'�l���A�N�Z�X�pCOM�I�u�W�F�N�g

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�����l�̎擾
strPerID     = Request("perid")
strLastName  = Request("lastname")
strFirstName = Request("firstname")

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objPerson = Server.CreateObject("HainsPerson.Person")

'�l�e�[�u�����R�[�h�폜
objPerson.DeletePerson strPerID
%>
<!-- #include virtual = "/webHains/includes/common.inc" -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�폜����</TITLE>
<STYLE TYPE="text/css">
td.mnttab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BLOCKQUOTE>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">��</SPAN><FONT COLOR="#000000">�폜����</FONT></B></TD>
	</TR>
</TABLE>

<BR>

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
	<TR>
		<TD>&nbsp;&nbsp;�l�R�[�h</TD>
		<TD>�F</TD>
		<TD><B><%= strPerID %></B></TD>
	</TR>
	<TR>
		<TD>&nbsp;&nbsp;����</TD>
		<TD>�F</TD>
		<TD><B><%= strLastName & "�@" & strFirstName %></B></TD>
	</TR>
	<TR>
		<TD COLSPAN="3"><BR>&nbsp;&nbsp;�̌l��񂪍폜����܂����B</TD>
	</TR>
</TABLE>

<BR>
<A HREF="mntSearchPerson.asp"><IMG SRC="/webhains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�l������ʂɖ߂�܂�"></A>

</BLOCKQUOTE>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
