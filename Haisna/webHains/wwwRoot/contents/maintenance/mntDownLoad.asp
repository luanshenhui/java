<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�_�E�����[�h���j���[ (Ver0.0.1)
'		AUTHER  : Hiroki Ishihara@fsit.fujitsu.com
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
'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�_�E�����[�h</TITLE>
<STYLE TYPE="text/css">
td.mnttab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BLOCKQUOTE>

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2" WIDTH="650">
	<TR VALIGN="bottom">
		<TD><FONT SIZE="+2"><B>�_�E�����[�h</B></FONT></TD>
	</TR>
	<TR BGCOLOR="#cccccc">
		<TD HEIGHT="2"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1" BORDER="0"></TD>
	</TR>
</TABLE>

<BR>

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/cab/AppProxy/webHainsAppProxy.MSI"><IMG SRC="/webHains/images/keyboard.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2" WIDTH="20"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/cab/AppProxy/webHainsAppProxy.MSI">�A�v���P�[�V�����v���L�V���C���X�g�[������</A></B><SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">webHains�V�X�e���Ǘ��A�v���P�[�V�����𓮍삳����ɂ͕K�{�̃A�v���P�[�V�����ł��B<BR>�C���X�g�[������ɂ�Administrator�������K�v�ł��B</TD>
	</TR>
<!--
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/cab/Mnt/webHainsMnt.msi"><IMG SRC="/webHains/images/keyboard.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/cab/Mnt/webHainsMnt.msi">webHains�V�X�e���Ǘ��A�v���P�[�V�������C���X�g�[������</A></B><SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">webHains�̊��ݒ���s���A�v���P�[�V�����ł��B�N���b�N����ƃC���X�g�[�����n�܂�܂��B</TD>
	</TR>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/cab/WindowsInstaller/instmsiw.arc"><IMG SRC="/webHains/images/keyboard.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/cab/WindowsInstaller/instmsiw.arc">Windows Installer For NT4.0���C���X�g�[������</A></B><SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">��L�Q�_�̃C���X�g�[�����o���Ȃ��ꍇ�AWindows Installer���Z�b�g�A�b�v����Ă��Ȃ��\��������܂��B<BR>�t�@�C�������[�J���ɕۑ�������A�g���q��exe�ɕύX���Ď��s���Ă��������B</TD>
	</TR>
-->
</TABLE>
</BLOCKQUOTE>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>