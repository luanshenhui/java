<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �����|�[�g�Ɖ�i�����ҁi���A��l�j��f�ҏ��j  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Adobe GoLive 6">
<TITLE>�����ҁi���A��l�j��f�ҏ��</TITLE>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
</HEAD>
<BODY>
	<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
		<TR>
			<TD NOWRAP BGCOLOR="#eeeeee" HEIGHT="15"><B><FONT COLOR="#333333">�����ҁi���A��l�j��f�ҏ��</FONT></B></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="0">
		<TR>
			<TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5" ALT=""></TD>
		</TR>
		<TR HEIGHT="15">
			<TD NOWRAP ALIGN="center" BGCOLOR="#dcdcdc" WIDTH="70">��f�ԍ�</TD>
			<TD NOWRAP ALIGN="center" BGCOLOR="#dcdcdc" WIDTH="135">��f�Ҏ���</TD>
			<TD NOWRAP ALIGN="center" BGCOLOR="#dcdcdc" WIDTH="40">����</TD>
			<TD NOWRAP ALIGN="center" BGCOLOR="#dcdcdc" WIDTH="100">������f�ԍ�</TD>
			<TD NOWRAP ALIGN="center" BGCOLOR="#dcdcdc" WIDTH="135">�����Ҏ���</TD>
		</TR>
	</TABLE>
</BODY>
</HTML>
