<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�����e�i���X���j���[ (Ver0.0.1)
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
<STYLE TYPE="text/css">
<!--
td.mnttab  { background-color:#FFFFFF }
-->
</STYLE>
<TITLE>�����e�i���X</TITLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BLOCKQUOTE>

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2" WIDTH="650">
	<TR VALIGN="bottom">
		<TD><FONT SIZE="+2"><B>�����e�i���X</B></FONT></TD>
	</TR>
	<TR BGCOLOR="#cccccc">
		<TD HEIGHT="2"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1" BORDER="0"></TD>
	</TR>
</TABLE>

<BR>

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/maintenance/personal/mntSearchPerson.asp"><IMG SRC="/webHains/images/person.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2" WIDTH="20"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/maintenance/personal/mntSearchPerson.asp">�l���</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">�l���Ƃ��Đݒ肵�Ă�����e�m�F�B�y�т��̓��e�̕ύX�͂����炩��B</TD>
	</TR>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
<!--
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/disease/perDiseaseList.asp"><IMG SRC="/webHains/images/person.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2" WIDTH="20"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/disease/perDiseaseList.asp">���a�x�Ə��</A></B>/</SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">�]�ƈ��̕��̏��a�x�Ə���o�^���܂�</TD>
	</TR>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
-->
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/maintenance/organization/mntSearchOrg.asp"><IMG SRC="/webHains/images/office.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/maintenance/organization/mntSearchOrg.asp">�c�̏��</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">�c�̏��Ƃ��Đݒ肵�Ă�����e�m�F�B�y�т��̓��e�̕ύX�͂����炩��B</TD>
	</TR>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/contract/ctrSearchOrg.asp"><IMG SRC="/webHains/images/money.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/contract/ctrSearchOrg.asp">�_����̎Q�ƁA�o�^</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">�c�̖��Ɏw�肳�ꂽ���ꂼ��̌_����e�m�F�A�y�ѐV�K�_����̓o�^�͂����炩��B</TD>
	</TR>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/rsvFra/rsvFraSearch.asp"><IMG SRC="/webHains/images/telephone.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/rsvFra/rsvFraSearch.asp">�\��g�o�^�A�m�F</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">�e�R�[�X�A�ݔ����̗\��\�l���̐ݒ���s���܂��B</TD>
	</TR>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/maintenance/capacity/mntCapacity.asp"><IMG SRC="/webHains/images/telephone.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/maintenance/capacity/mntCapacity.asp">�x�f���ݒ�</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">�j���A�x�f���̐ݒ���s���܂��B</TD>
	</TR>
<!--
	<TR>
		<TD></TD><TD></TD><TD><A HREF="/webHains/contents/maintenance/capacity/mntCapacity.asp">���\��g�o�^</A></TD>
	</TR>
-->
<!-- ## 2004.03.10 Add By T.Takgi@FSIT �\��g�R�s�[�@�\ -->
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/rsvFra/rsvFraCopy1.asp"><IMG SRC="/webHains/images/telephone.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/rsvFra/rsvFraCopy1.asp">�\��g�̃R�s�[</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">���łɓo�^����Ă���\��g�����R�s�[���A�V�����\��g���쐬���܂��B</TD>
	</TR>
<!-- ## 2004.03.10 Add End -->
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>

		<TR>
			<TD ROWSPAN="2"><A HREF="/webHains/contents/report/reportSendCheck.asp"><IMG SRC="/webHains/images/barcode.jpg" WIDTH="80" HEIGHT="60"></A></TD>
			<TD ROWSPAN="2" WIDTH="15"></TD>
			<TD COLSPAN="4"><SPAN STYLE="font-size:16px;font-weight:bolder"><A HREF="/webHains/contents/report/reportSendCheck.asp">���я������m�F</A></SPAN></TD>
		</TR>
		<TR>
			<TD COLSPAN="4" VALIGN="top">���я��̔����m�F���s���܂��B</TD>
		</TR>
		<TR>
			<TD HEIGHT="15"></TD>
		</TR>
		<TR>
			<TD ROWSPAN="2"><A HREF="/webHains/contents/report/inqReportsInfo.asp"><IMG SRC="/webHains/images/barcode.jpg" WIDTH="80" HEIGHT="60"></A></TD>
			<TD ROWSPAN="2" WIDTH="15"></TD>
			<TD COLSPAN="4"><SPAN STYLE="font-size:16px;font-weight:bolder"><A HREF="/webHains/contents/report/inqReportsInfo.asp">���я������i���m�F</A></SPAN></TD>
		</TR>
		<TR>
			<TD COLSPAN="4" VALIGN="top">���я��쐬�̐i���m�F���s���܂��B</TD>
		</TR>
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/maintenance/hainslog/dispHainsLog.asp"><IMG SRC="/webHains/images/machine.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/maintenance/hainslog/dispHainsLog.asp">���O�Q��</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">�ꊇ�\��A�������ߏ����Ȃǂ̎��s���O���Q�Ƃ��܂��B</TD>
	</TR>

<!--
	<TR>
		<TD HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/maintenance/import/mntImportPersonStep1.asp"><IMG SRC="/webHains/images/mo.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/maintenance/import/mntImportPersonStep1.asp">���ۃf�[�^�̎�荞��</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">���ۂ���󂯎�����b�r�u�f�[�^����荞�݁A�l���Ƃ��ēo�^���܂��B</TD>
	</TR>
-->
	<TR>
		<TD HEIGHT="50"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2"><A HREF="/webHains/contents/maintenance/mntDownLoad.asp"><IMG SRC="/webHains/images/keyboard.jpg" WIDTH="80" HEIGHT="60"></A></TD>
		<TD ROWSPAN="2"></TD>
		<TD><SPAN STYLE="font-size:16px"><B><A HREF="/webHains/contents/maintenance/mntDownLoad.asp">�_�E�����[�h</A></B></SPAN></TD>
	</TR>
	<TR>
		<TD VALIGN="top">webHains�V�X�e���Ǘ��A�v���P�[�V�������̃_�E�����[�h</TD>
	</TR>
</TABLE>

<BR><BR><BR><BR>
<BR><BR><BR><BR>

<!--
<A HREF="/webHains/contents/mngAccuracy/mngAccuracyInfo.asp"><IMG SRC="/webHains/images/moa.jpg" WIDTH="10" HEIGHT="10" ALT="���x�Ǘ�"></A>
-->
<BR><BR>
<!--
<A HREF="/webHains/contents/rsvFra/rsvFraCopy1.asp"><IMG SRC="/webHains/images/moa.jpg" WIDTH="10" HEIGHT="10" ALT="�\��g�R�s�["></A>
-->
<BR>

</BLOCKQUOTE>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>