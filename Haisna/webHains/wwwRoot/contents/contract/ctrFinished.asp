<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�_����(�Q�ƁE�R�s�[�����̊����ʒm) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
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
'�O��ʂ��瑗�M�����p�����[�^�l
Dim strOrgCd1	'�c�̃R�[�h1
Dim strOrgCd2	'�c�̃R�[�h2

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�O��ʂ��瑗�M�����p�����[�^�l�̎擾
strOrgCd1 = Request("orgCd1")
strOrgCd2 = Request("orgCd2")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�Q�ƁE�R�s�[�����̊���</TITLE>
<STYLE TYPE="text/css">
td.mnttab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BLOCKQUOTE>

<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="contract">��</SPAN><FONT COLOR="#000000">�o�^����</FONT></B></TD>
	</TR>
</TABLE>

<BR>

�_����̎Q�ƁE���ʏ������������܂����B

<BR>
<BR>

<A HREF="ctrCourseList.asp?orgCd1=<%= strOrgCd1 %>&orgCd2=<%= strOrgCd2 %>">�_�����</A>

</BLOCKQUOTE>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
