<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�f�[�^���o���j���[ (Ver0.0.1)
'		AUTHER  : Toyonobu Manabe@takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

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
<TITLE>�f�[�^���o</TITLE>
<STYLE TYPE="text/css">
<!--
td.datatab  { background-color:#ffffff }
-->
</STYLE>
</HEAD>

<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2" WIDTH="635">
		<TR VALIGN="bottom">
			<TD><FONT SIZE="+2"><B>�f�[�^���o</B></FONT></TD>
		</TR>
		<TR HEIGHT="2">
			<TD BGCOLOR="#CCCCCC"><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="2" BORDER="0"></TD>
		</TR>
	</TABLE>

	<BR>

	
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">


	<TR>
		<TD ROWSPAN="2"><A HREF="datSelectItem.asp?step=1"><IMG SRC="/webHains/images/dock.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2" WIDTH="20"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="datSelectItem.asp?step=1">���ʁA���蒊�o</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">�w�肵�����t�A�������ʒl�Ȃǂ���f�[�^��CSV�`���Œ��o���܂��B</TD>
	</TR>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	
	
	<TR>
		<TD ROWSPAN="2"><A HREF="datPersonal.asp"><IMG SRC="/webHains/images/person.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2" WIDTH="20"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="datPersonal.asp">�l���</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">�o�^����Ă���l����CSV�`���ŏo�͂��܂��B</TD>
	</TR>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>

	<TR>
		<TD ROWSPAN="2"><A HREF="datOrganization.asp"><IMG SRC="/webHains/images/office.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="datOrganization.asp">�c�̏��</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">�o�^����Ă���c�̏���CSV�`���ŏo�͂��܂��B</TD>
	</TR>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	
	<TR>
		<TD ROWSPAN="2"><A HREF="datDemandAllMenu.asp"><IMG SRC="/webHains/images/money.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="datDemandAllMenu.asp">�������</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">�w�肳�ꂽ�����𖞂�����������CSV�`���ŏo�͂��܂��B</TD>
	</TR>
<!--
	<TR>
		<TD ROWSPAN="2"><A HREF="datDemandAllMenu.asp"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="datDemandAllMenu.asp">_</A></B></SPAN></TD>
	</TR>
-->		
</TABLE>



</BLOCKQUOTE>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
