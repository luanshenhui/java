<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�c�̏�񃁃��e�i���X(�c�̏��̍폜) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@FSIT
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objOrganization	'�c�̏��A�N�Z�X�p

Dim strOrgCd1		'�c�̃R�[�h1
Dim strOrgCd2		'�c�̃R�[�h2
Dim strOrgKName		'�c�̃J�i��
Dim strOrgName		'�c�̖�
Dim strOrgSName		'�c�̗���
Dim strZipCd1		'�X�֔ԍ�1
Dim strZipCd2		'�X�֔ԍ�2
Dim strPrefCd		'�s���{���R�[�h
Dim strPrefName		'�s���{����
Dim strCityName		'�s�撬����
Dim strAddress1		'�Z��1
Dim strAddress2		'�Z��2
Dim strTel1			'�d�b�ԍ���\�|�s�O�ǔ�
Dim strTel2			'�d�b�ԍ���\�|�ǔ�
Dim strTel3			'�d�b�ԍ���\�|�ԍ�
Dim strDirectTel1	'�d�b�ԍ����ʁ|�s�O�ǔ�
Dim strDirectTel2	'�d�b�ԍ����ʁ|�ǔ�
Dim strDirectTel3	'�d�b�ԍ����ʁ|�ԍ�
Dim strExtension	'����
Dim strFax1			'�e�`�w�|�s�O�ǔ�
Dim strFax2			'�e�`�w�|�ǔ�
Dim strFax3			'�e�`�w�|�ԍ�
Dim strChargeName	'�S���Ҏ���
Dim strChargeKName	'�S���҃J�i����
Dim strChargeEMail	'�S����E-Mail�A�h���X
Dim strChargePost	'�S���ҕ�����
Dim strGovMngCd		'���{�Ǐ��R�[�h
Dim strIsrNo		'�ی��Ҕԍ�
Dim strIsrSign		'���ۋL��(�L��)
Dim strIsrMark		'���ۋL��(����)
Dim strHeIsrNo		'���۔ԍ�
Dim strIsrDiv		'�ی��敪
Dim strBank			'��s��
Dim strBranch		'�x�X��
Dim strAccountKind	'�������
Dim strAccountNo	'�����ԍ�
Dim strNotes		'���L����
Dim strSpare1		'�\��1
Dim strSpare2		'�\��2
Dim strSpare3		'�\��3
Dim strUpdDate		'�X�V����
Dim strUpdUser		'�X�V��
Dim strUserName		'�X�V�Җ�

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

'�����l�̎擾
strOrgCd1 = Request("orgCd1")
strOrgCd2 = Request("orgCd2")

'�c�̃e�[�u�����R�[�h�ǂݍ���
objOrganization.SelectOrg strOrgCd1, strOrgCd2, _
						  strOrgKName, strOrgName, strOrgSName, _
						  strZipCd1, strZipCd2, _
						  strPrefCd, strPrefName, strCityName, _
						  strAddress1, strAddress2, _
						  strTel1, strTel2, strTel3, _
						  strDirectTel1, strDirectTel2, strDirectTel3, strExtension, _
						  strFax1, strFax2, strFax3, _
						  strChargeName, strChargeKName, strChargeEmail, strChargePost, _
						  strGovMngCd, _
						  strIsrNo, strIsrSign, strIsrMark, strHeIsrNo, strIsrDiv, _
						  strBank, strBranch, strAccountKind, strAccountNo, _
						  strNotes, _
						  strSpare1, strSpare2, strSpare3, _
						  strUpdDate, strUpdUser, strUserName
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�c�̏��̍폜</TITLE>
<STYLE TYPE="text/css">
td.mnttab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BLOCKQUOTE>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">��</SPAN><FONT COLOR="#000000">�c�̏��̍폜</FONT></B></TD>
	</TR>
</TABLE>

<BR>

���̒c�̏����폜���܂��B��낵����΍폜�{�^�����N���b�N���ĉ������B<BR><BR>

<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�c�̃R�[�h</TD>
		<TD WIDTH="5"></TD>
		<TD><%= strOrgCd1 & "-" & strOrgCd2 %></TD>
	</TR>
	<TR>
		<TD HEIGHT="12"></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�c�̃J�i����</TD>
		<TD></TD>
		<TD><%= strOrgKName %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�c�̖���</TD>
		<TD></TD>
		<TD><%= strOrgName %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�c�̗���</TD>
		<TD></TD>
		<TD><%= strOrgSName %></TD>
	</TR>
	<TR>
		<TD HEIGHT="12"></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�X�֔ԍ�</TD>
		<TD></TD>
		<TD><%= strZipCd1 & IIf(strZipCd2 <> "", "-", "") & strZipCd2 %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�s���{��</TD>
		<TD></TD>
		<TD><%= strPrefName %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�s�撬��</TD>
		<TD></TD>
		<TD><%= strCityName %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�Z���P</TD>
		<TD></TD>
		<TD><%= strAddress1 %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�Z���Q</TD>
		<TD></TD>
		<TD><%= strAddress2 %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�d�b�ԍ���\</TD>
		<TD></TD>
		<TD><%= strTel1 & IIf(strTel2 <> "", "-", "") & strTel2 & IIf(strTel3 <> "", "-", "") & strTel3 %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�d�b�ԍ�����</TD>
		<TD></TD>
		<TD><%= strDirectTel1 & IIf(strDirectTel2 <> "", "-", "") & strDirectTel2 & IIf(strDirectTel3 <> "", "-", "") & strDirectTel3 %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">����</TD>
		<TD></TD>
		<TD><%= strExtension %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">FAX�ԍ�</TD>
		<TD></TD>
		<TD><%= strFax1 & IIf(strFax2 <> "", "-", "") & strFax2 & IIf(strFax3 <> "", "-", "") & strFax3 %></TD>
	</TR>
	<TR>
		<TD HEIGHT="12"></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�S���҃J�i��</TD>
		<TD></TD>
		<TD><%= strChargeKName %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�S���Җ�</TD>
		<TD></TD>
		<TD><%= strChargeName %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�S����E-Mail�A�h���X</TD>
		<TD></TD>
		<TD><%= strChargeEMail %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�S��������</TD>
		<TD></TD>
		<TD><%= strChargePost %></TD>
	</TR>
	<TR>
		<TD HEIGHT="12"></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�X�V����</TD>
		<TD></TD>
		<TD><%= strUpdDate %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�X�V��</TD>
		<TD></TD>
		<TD><%= strUserName %></TD>
	</TR>
</TABLE>

<BR>

<A HREF="mntDeleteOrg.asp?orgCd1=<%= strOrgcd1 %>&orgCd2=<%= strOrgcd2 %>&orgName=<%= Server.URLEncode(strOrgName) %>"><IMG SRC="/webhains/images/delete.gif" WIDTH="77" HEIGHT="24" ALT="���̒c�̏����폜���܂�"></A>

</BLOCKQUOTE>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
