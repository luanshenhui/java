<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�\�񃁃j���[ (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
'----------------------------
'�C������
'----------------------------
'�Ǘ��ԍ��FSL-SN-Y0101-612
'�C�����@�F2013.3.5
'�S����  �FT.Takagi@RD
'�C�����e�F�\��m�F���[�����M�@�\�ǉ�

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
<TITLE>�\�񃁃j���[</TITLE>
<STYLE TYPE="text/css">
<!--
td.rsvtab  { background-color:#FFFFFF }
-->
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BLOCKQUOTE>

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2" WIDTH="650">
	<TR VALIGN="bottom">
		<TD><FONT SIZE="+2"><B>�\��</B></FONT></TD>
	</TR>
	<TR BGCOLOR="#cccccc">
		<TD HEIGHT="2"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1"></TD>
	</TR>
</TABLE>

<BR>

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
	<TR>
		<TD ROWSPAN="2"><A HREF="rsvMain.asp"><IMG SRC="/webHains/images/yoyaku.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2" WIDTH="20"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="rsvMain.asp">�V�K�\��</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">�V�������N�f�f�̗\���o�^���܂��B</TD>
	</TR>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="../frameReserve/fraRsvMain.asp"><IMG SRC="/webHains/images/schedule.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="../frameReserve/fraRsvMain.asp">�\��g�̌���</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">�w�肳�ꂽ��������A�\��\�ȓ��ɂ����������܂��B</TD>
	</TR>
<!--
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/reserveOrg/default.asp"><IMG SRC="/webHains/images/office.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/reserveOrg/default.asp">�c�̗l�̗\���o�^����</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">�c�̗l����̂܂Ƃ܂������\�����݂�o�^���܂��B</TD>
	</TR>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/reserveOrg/rsvOrgSchedule.asp"><IMG SRC="/webHains/images/calendar.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/reserveOrg/rsvOrgSchedule.asp">�c�̗\��X�P�W���[���̊m�F</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">�c�̗l����̗\��󋵂��ꗗ�ŕ\�����܂��B</TD>
	</TR>
-->
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="rsvAllFromCsv.asp"><IMG SRC="/webHains/images/csvplus.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="rsvAllFromCsv.asp">�b�r�u�t�@�C������̈ꊇ�\��</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">�b�r�u�t�@�C���̃f�[�^�����ƂɈꊇ�ŗ\�񏈗����s���܂��B</TD>
	</TR>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="rsvAllDelete.asp"><IMG SRC="/webHains/images/csvminus.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="rsvAllDelete.asp">�b�r�u�t�@�C������̗\��ꊇ�폜</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">�ꊇ�\�񏈗����ʂ̂b�r�u�f�[�^�����Ƃɗ\��̈ꊇ�폜���s���܂��B</TD>
	</TR>
<% '## 2005.03.04 Add By T.Takagi web�\���荞�� %>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/webReserve/webRsvSearch.asp"><IMG SRC="/webHains/images/web1.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/webReserve/webRsvSearch.asp">web�\���荞��</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">web����\�����܂ꂽ�\�����webHains�Ɏ�荞�݂܂��B</TD>
	</TR>
<% '## 2005.03.04 Add End %>
<% '## 2007.03.03 Add By �� web�c�̗\���荞�� %>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/webOrgReserve/webOrgRsvSearch.asp"><IMG SRC="/webHains/images/web2.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/webOrgReserve/webOrgRsvSearch.asp">web�c�̗\���荞��</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">web����\�����܂ꂽ�c�̗\�����webHains�Ɏ�荞�݂܂��B</TD>
	</TR>
<% '## 2007.03.03 Add End %>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
<!--
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/receipt/rptBarcode.asp"><IMG SRC="/webHains/images/barcode.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/receipt/rptBarcode.asp">�o�[�R�[�h��t</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">�o�[�R�[�h�ɂ���t��ʂ�\�����܂��B</TD>
	</TR>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/receipt/rptRequest.asp"><IMG SRC="/webHains/images/testtube.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/receipt/rptRequest.asp">�����˗�</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">�����V�X�e���ɑ��M����˗��t�@�C�����쐬���܂��B</TD>
	</TR>
-->
<% '## 2004.01.16 Add By T.Takagi �X�V����\�� %>
	<TR>
		<TD ROWSPAN="2"><A HREF="rsvLog.asp"><IMG SRC="/webHains/images/koushinrireki.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="rsvLog.asp">�X�V����</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">��f���̕ύX������\�����܂��B</TD>
	</TR>
<% '## 2004.01.16 Add End %>
<% '#### 2013.3.5 SL-SN-Y0101-612 ADD START #### %>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="rsvSendMail.asp"><IMG SRC="/webHains/images/mail.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="rsvSendMail.asp">�\��m�F���[�����M</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">�\����ɑ΂��A�m�F���[���𑗐M���܂��B</TD>
	</TR>
<% '#### 2013.3.5 SL-SN-Y0101-612 ADD END   #### %>
<% '## 2004.09.23 Add By T.Ito Failsafe�ǉ� %>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/failSafe/failSafe.asp?strYear=<%= Year(Date) %>&amp;strMonth=<%= Month(Date) %>&amp;strDay=<%= Day(Date) %>"><IMG SRC="/webHains/images/machine.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2" WIDTH="20"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/failSafe/failSafe.asp?strYear=<%= Year(Date) %>&amp;strMonth=<%= Month(Date) %>&amp;strDay=<%= Day(Date) %>">FailSafe</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">�_����Ƃ̐������`�F�b�N���s���܂��B</TD>
	</TR>
<% '## 2004.09.23 Add End %>
</TABLE>

</BLOCKQUOTE>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
