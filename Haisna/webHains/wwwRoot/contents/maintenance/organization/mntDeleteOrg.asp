<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�c�̏�񃁃��e�i���X(�폜�����ʒm���) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@FSIT
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
Dim strOrgCd1		'�c�̃R�[�h1
Dim strOrgCd2		'�c�̃R�[�h2
Dim strOrgName		'�c�̖�

Dim objOrganization	'�c�̏��A�N�Z�X�pCOM�I�u�W�F�N�g

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�����l�̎擾
strOrgCd1  = Request("orgcd1")
strOrgCd2  = Request("orgcd2")
strOrgName = Request("orgname")

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

'�c�̃e�[�u�����R�[�h�폜
If objOrganization.DeleteOrg(strOrgCd1, strOrgCd2) <= 0 Then
	Err.Raise 1000, , "���̒c�̂͑��Ŏg�p����Ă��܂��B�폜�ł��܂���B"
End If
%>
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
		<TD>&nbsp;&nbsp;�c�̃R�[�h</TD>
		<TD>�F</TD>
		<TD><B><%= strOrgcd1 %>-<%= strOrgCd2 %></B></TD>
	</TR>
	<TR>
		<TD>&nbsp;&nbsp;�c�̖���</TD>
		<TD>�F</TD>
		<TD><B><%= strOrgName %></B></TD>
	</TR>
	<TR>
		<TD COLSPAN="3"><BR>&nbsp;&nbsp;�̒c�̏�񂪍폜����܂����B</TD>
	</TR>
</TABLE>

<BR>
<A HREF="mntSearchOrg.asp"><IMG SRC="/webhains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�c�̌�����ʂɖ߂�܂�"></A>
</BLOCKQUOTE>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
