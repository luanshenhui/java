<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�\��ꊇ�����̑I�� (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_BUSINESS_TOP)

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
<TITLE>�\��ꊇ�����̑I��</TITLE>
<STYLE TYPE="text/css">
td.rsvtab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BLOCKQUOTE>

<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000">�\��ꊇ�����̑I��</FONT></B></TD>
	</TR>
</TABLE>

<BR>

<A HREF="rsvAllFromPerson.asp">�l�����Q�Ƃ��ĂP�����f�̈ꊇ�\����s��</A><BR><BR>
<A HREF="rsvAllFromCsv.asp">CSV�f�[�^�����ƂɂP�����f�̈ꊇ�\����s��</A><BR><BR>
<A HREF="rsvAllFromResult.asp">���f���ʂ��Q�Ƃ��ĂQ�����f�̈ꊇ�\����s��</A><BR><BR>
<A HREF="rsvAllDelete.asp">�\��̈ꊇ�폜���s��</A><BR><BR>
<A HREF="rsvAllUpdateOption.asp">�w�肳�ꂽ��f���̃I�v�V����������W���ɖ߂�</A><BR><BR>
<A HREF="rsvAllUpdateBsd.asp">�w�肳�ꂽ��f���̎��ƕ��`�������ŐV�l�f�[�^�ōX�V</A><BR><BR>

</BLOCKQUOTE>
</BODY>
</HTML>