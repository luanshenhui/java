<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       �l���̍폜 (Ver0.0.1)
'       AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon		'���ʃN���X
Dim objFree			'�ėp���A�N�Z�X�p
Dim objHainsUser	'���[�U���A�N�Z�X�p
Dim objPerson		'�l���A�N�Z�X�p

Dim strPerID		'�l�h�c
Dim strVidFlg		'���h�c�t���O
Dim strLastName		'��
Dim strFirstName	'��
Dim strLastKName	'�J�i��
Dim strFirstKName	'�J�i��
Dim strBirth		'���N����
Dim strGender		'����
Dim strSpare(6)		'�\��
Dim strDelFlg		'�폜�t���O
Dim strUpdDate		'�X�V���t
Dim strUpdUser		'�X�V��
Dim strOrgCd1		'�c�̃R�[�h�P
Dim strOrgCd2		'�c�̃R�[�h�Q
Dim strOrgPostCd	'���������R�[�h
Dim strTel1			'�d�b�ԍ��P-�s�O�ǔ�
Dim strTel2			'�d�b�ԍ��P-�ǔ�
Dim strTel3			'�d�b�ԍ��P-�ԍ�
Dim strExtension	'����
Dim strSubTel1		'�d�b�ԍ��Q-�s�O�ǔ�
Dim strSubTel2		'�d�b�ԍ��Q-�ǔ�
Dim strSubTel3		'�d�b�ԍ��Q-�ԍ�
Dim strFax1			'�e�`�w�ԍ�-�s�O�ǔ�
Dim strFax2			'�e�`�w�ԍ�-�ǔ�
Dim strFax3			'�e�`�w�ԍ�-�ԍ�
Dim strPhone1		'�g��-�s�O�ǔ�
Dim strPhone2		'�g��-�ǔ�
Dim strPhone3		'�g��-�ԍ�
Dim strEMail		'e-Mail
Dim strZipCd1		'�X�֔ԍ��P
Dim strZipCd2		'�X�֔ԍ��Q
Dim strPrefCd		'�s���{���R�[�h
Dim strCityName		'�s�撬����
Dim strAddress1		'�Z���P
Dim strAddress2		'�Z���Q
Dim strIsrNo		'�ی��Ҕԍ�
Dim strMarriage		'�����敪
Dim strIsrSign		'���ۋL���i�L���j
Dim strIsrMark		'���ۋL���i�����j
Dim strHeIsrNo		'���۔ԍ�
Dim strIsrDiv		'�ی��敪
Dim strResidentNo	'�Z���ԍ�
Dim strUnionNo		'�g���ԍ�
Dim strKarte		'�J���e�ԍ�
Dim strEmpNo		'�]�ƈ��ԍ�
Dim strNotes		'���L����
Dim strGenderName	'����(����)
Dim strPrefName		'�s���{������

Dim strOrgName			'�c�̖���
Dim strOrgBsdName		'���ƕ�����
Dim strOrgRoomName		'��������
Dim strOrgPostName		'��������
Dim strTransferDiv		'�o���敪
Dim strJobName			'�E��
Dim strDutyName			'�E�Ӗ���
Dim strQualifyName		'���i����
Dim strWorkMeasureDivName	'�A�Ƒ[�u�敪����
Dim strEmpDiv				'�]�ƈ��敪
Dim strOverTimeDiv		'���ߋΖ��敪

Dim strRelationCd		'�����R�[�h
Dim strBranchNo			'�}��
Dim strLostDate			'���i�r�����t
Dim strHireDate			'���Г��t
Dim strNightDutyFlg		'��ΎҌ��f�Ώۃt���O

Dim strSpareName(6)	'�\���̕\������
Dim strFreeName		'�ėp��
Dim strUserName		'���[�U��

Dim strDelFlgName		'�폜�t���O����
Dim strEmpDivName				'�]�ƈ��敪����

Dim strHTML			'HTML������
Dim i				'�C���f�b�N�X

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
strPerID = Request("perid")

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon    = Server.CreateObject("HainsCommon.Common")
Set objFree      = Server.CreateObject("HainsFree.Free")
Set objHainsUser = Server.CreateObject("HainsHainsUser.HainsUser")
Set objPerson    = Server.CreateObject("HainsPerson.Person")

'�\���̕\�����̎擾
For i = 0 To UBound(strSpare)

	'�ėp���ǂݍ���
	objFree.SelectFree 0, "PERSPARE" & (i + 1), , strFreeName

	'���̂��ݒ肳��Ă���ꍇ�͂��̓��e��ێ�
	strSpareName(i) = IIf(strFreeName <> "", strFreeName, "�ėp�L�[(" & (i + 1) & ")")

Next

'�l�e�[�u�����R�[�h�ǂݍ���
'objPerson.SelectPerson_old strPerID, _
'						   strVidFlg,     strLastName,   strFirstName,      _
'						   strLastKName,  strFirstKName, strBirth,          _
'						   strGender,     strSupportFlg, strSpare(0),       _
'						   strSpare(1),   strUpdDate,    strUpdUser,        _
'						   strOrgCd1,     strOrgCd2,     strOrgPostCd,      _
'						   strTel1,       strTel2,       strTel3,           _
'						   strExtension,  strSubTel1,    strSubTel2,        _
'						   strSubTel3,    strFax1,       strFax2,           _
'						   strFax3,       strPhone1,     strPhone2,         _
'						   strPhone3,     strEMail,      strZipCd1,         _
'						   strZipCd2,     strPrefCd,     strCityName,       _
'						   strAddress1,   strAddress2,   strMarriage,       _
'						   strIsrNo,      strIsrSign,    strIsrMark,        _
'						   strHeIsrNo,    strIsrDiv,     strResidentNo,     _
'						   strUnionNo,    strKarte,      strEmpNo,          _
'						   strNotes,      strSpare(2),   strSpare(3),       _
'						   strSpare(4),   strSpare(5),   strSpare(6), , , , _
'						   strGenderName, strPrefName

	objPerson.SelectPerson strPerId, _
     strLastName,  strFirstName, _
     strLastKName,  strFirstKName, _
     strBirth,  strGender, _
     ,  , _
     , ,  strOrgName, _
     ,  ,  strOrgBsdName, _
     ,  strOrgRoomName,  , _
     ,  strOrgPostName,  , _
     , strJobName , _
     , strDutyName  , _
     , strQualifyName  , _
     strEmpNo,  strIsrSign,  strIsrNo, _
     strRelationCd,  , strBranchNo , _
     strTransferDiv , _
     , _
     strLostDate, strHireDate , _
     strEmpDiv ,  , _
     , strWorkMeasureDivName  , _
     strOverTimeDiv , strNightDutyFlg , _
     strVidflg, strDelFlg , ,_
     strUpdDate,  strUpdUser,  strUserName, _
     strSpare(0),  strSpare(1)


%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�l���̍폜</TITLE>
<STYLE TYPE="text/css">
td.mnttab  { background-color:#FFFFFF }
</STYLE>
</HEAD>

<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BLOCKQUOTE>

<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">��</SPAN><FONT COLOR="#000000">�l���̍폜</FONT></B></TD>
	</TR>
</TABLE>

<BR>

���̌l�����폜���܂��B��낵����΍폜�{�^�����N���b�N���ĉ������B<BR><BR>

<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right" WIDTH="138">�lID</TD>
		<TD WIDTH="5"></TD>
		<TD><%= strPerID %></TD>
	</TR>
	<TR>
		<TD HEIGHT="12"></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�t���K�i</TD>
		<TD></TD>
		<TD><%= strLastKName & "�@" & strFirstKName %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">���O</TD>
		<TD></TD>
		<TD><%= strLastName & "�@" & strFirstName %></TD>
   	</TR>
	<TR>
		<TD HEIGHT="12"></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">����</TD>
		<TD></TD>
		<TD><%= IIf(strGender = "1", "�j��", "����") %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">���N����</TD>
		<TD></TD>
		<TD><%= objCommon.FormatString(strBirth, "ggge�Nm��d��") %></TD>
	</TR>
	<TR>
		<TD HEIGHT="12"></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�c��</TD>
		<TD></TD>
		<TD><%= strOrgName %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">���ƕ�</TD>
		<TD></TD>
		<TD><%= strOrgBsdName %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">����</TD>
		<TD></TD>
		<TD><%= strOrgRoomName %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">����</TD>
		<TD></TD>
		<TD><%= strOrgPostName %></TD>
	</TR>
	<TR>
		<TD HEIGHT="12"></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�]�ƈ��ԍ�</TD>
		<TD></TD>
		<TD><%= strEmpNo %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�폜�t���O</TD>
		<TD></TD>
<%
		Select Case strDelFlg
			Case "0": strDelFlgName = "�g�p��"
			Case "1": strDelFlgName = "�폜�ρi�ސE�����j"
			Case "2": strDelFlgName = "�x�E��"
		End Select
%>
		<TD><%= strDelFlgName %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�o���敪</TD>
		<TD></TD>
		<TD><%= IIf(strTransferDiv = "0", "�o���Ȃ�", "�o����") %></TD>
	</TR>
	<TR>
		<TD HEIGHT="12"></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�E��</TD>
		<TD></TD>
		<TD><%= strJobName %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�E��</TD>
		<TD></TD>
		<TD><%= strDutyName %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">���i</TD>
		<TD></TD>
		<TD><%= strQualifyName %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�A�Ƒ[�u�敪</TD>
		<TD></TD>
		<TD><%= strWorkMeasureDivName %></TD>
	</TR>
<%
	'�]�ƈ��敪�擾
	objFree.SelectFree 0, strEmpDiv, , , , strEmpDivName
%>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�]�ƈ��敪</TD>
		<TD></TD>
		<TD><%= strEmpDivName %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">���ߋΖ��敪</TD>
		<TD></TD>
		<TD><%= IIf(strOverTimeDiv = "0", "�Ȃ�", "����") %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">��ΎҌ��f</TD>
		<TD></TD>
		<TD><%= IIf(strNightDutyFlg <> "", "����", "") %></TD>
	</TR>
	<TR>
		<TD HEIGHT="12"></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�d�b�ԍ��P</TD>
		<TD></TD>
		<TD><%= strTel1 & IIf(strTel2 <> "", "-", "") & strTel2 & IIf(strTel3 <> "", "-", "") & strTel3 %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">����</TD>
		<TD></TD>
		<TD><%= strExtension %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�d�b�ԍ��Q</TD>
		<TD></TD>
		<TD><%= strSubTel1 & IIf(strSubTel2 <> "", "-", "") & strSubTel2 & IIf(strSubTel3 <> "", "-", "") & strSubTel3 %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">FAX�ԍ�</TD>
		<TD></TD>
		<TD><%= strFax1 & IIf(strFax2 <> "", "-", "") & strFax2 & IIf(strFax3 <> "", "-", "") & strFax3 %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�g�єԍ�</TD>
		<TD></TD>
		<TD><%= strPhone1 & IIf(strPhone2 <> "", "-", "") & strPhone2 & IIf(strPhone3 <> "", "-", "") & strPhone3 %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">E-mail�A�h���X</TD>
		<TD></TD>
		<TD><%= strEMail %></TD>
	</TR>
	<TR>
		<TD HEIGHT="12"></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�X�֔ԍ�</TD>
		<TD></TD>
		<TD><%= strZipCd1 & IIf(strZipCd2 <> "", "-" & strZipCd2, "") %></TD>
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
		<TD BGCOLOR="#eeeeee" ALIGN="right">�Ԓn</TD>
		<TD></TD>
		<TD><%= strAddress1 %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">����</TD>
		<TD></TD>
		<TD><%= strAddress2 %></TD>
	</TR>
	<TR>
		<TD HEIGHT="12"></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�����敪</TD>
		<TD></TD>
		<TD><%= objCommon.SelectMarriageName(strMarriage) %></TD>
	</TR>
	<TR>
		<TD HEIGHT="12"></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�ی��Ҕԍ�</TD>
		<TD></TD>
		<TD><%= strIsrNo %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">���ۋL��</TD>
		<TD></TD>
<%
		strHTML = IIf(strIsrSign <> "", "(�L��)", "") & strIsrSign
		If strHTML <> "" Then
			strHTML = strHTML & "�@"
		End If
		strHTML = strHTML & IIf(strIsrMark <> "", "(����)", "") & strIsrMark
%>
		<TD><%= strHTML %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">���۔ԍ�</TD>
		<TD></TD>
		<TD><%= strHeIsrNo %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�ی��敪</TD>
		<TD></TD>
		<TD><%= objCommon.SelectIsrDivName(strIsrDiv) %></TD>
	</TR>
	<TR>
		<TD HEIGHT="12"></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�Z���ԍ�</TD>
		<TD></TD>
		<TD><%= strResidentNo %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�g���ԍ�</TD>
		<TD></TD>
		<TD><%= strUnionNo %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�J���e�ԍ�</TD>
		<TD></TD>
		<TD><%= strKarte %></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">�]�ƈ��ԍ�</TD>
		<TD></TD>
		<TD><%= strEmpNo %></TD>
	</TR>
<%
	For i = 0 To UBound(strSpare)
%>
		<TR>
			<TD BGCOLOR="#eeeeee" ALIGN="right"><%= strSpareName(i) %></TD>
			<TD></TD>
			<TD><%= strSpare(i) %></TD>
		</TR>
<%
	Next
%>
	<TR>
		<TD BGCOLOR="#eeeeee" ALIGN="right">���L����</TD>
		<TD></TD>
		<TD><%= strNotes %></TD>
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
<%
		'���[�U���ǂݍ���
		If strUpdUser <> "" Then
			objHainsUser.SelectHainsUser strUpdUser, strUserName
		End If
%>
		<TD><%= strUserName %></TD>
	</TR>

</TABLE>

<BR><BR>

<A HREF="mntDeletePerson.asp?perid=<%= strPerID %>&lastname=<%= Server.URLEncode(strLastName) %>&firstname=<%= Server.URLEncode(strFirstName) %>"><IMG SRC="/webhains/images/delete.gif" WIDTH="77" HEIGHT="24" ALT="�폜"></A>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>