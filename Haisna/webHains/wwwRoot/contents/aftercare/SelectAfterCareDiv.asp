<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		����[�u�敪�̑I��(Ver0.0.1)
'		AUTHER  : Yamamoto yk-mix@kjps.net
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/editButtonCol.inc"  -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->

<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim objCommon			'���ʃN���X
Dim objPerson			'�l���p
Dim objFree				'�ėp���p

'-----------------------------------------------------------------------------
' �ϐ��錾
'-----------------------------------------------------------------------------

'�l���
Dim strPerId			'�l�h�c
Dim strLastName			'��
Dim strFirstName		'��
Dim strLastKName		'�J�i��
Dim strFirstKName		'�J�i��
Dim strBirth			'���N����
Dim strGender			'����
Dim strOrgCd1			'�c�̃R�[�h�P
Dim strOrgCd2			'�c�̃R�[�h2
Dim strOrgKName			'�c�̃J�i����
Dim strOrgName			'�c�̊�������
Dim strOrgSName			'�c�̗���
Dim strOrgBsdCd			'���Ə��R�[�h
Dim strOrgBsdKName		'���ƕ��J�i����
Dim strOrgBsdName		'���ƕ�����
Dim strOrgRoomCd		'�����R�[�h
Dim strOrgRoomName		'��������
Dim strOrgRoomKName		'�����J�i����
Dim strOrgPostCd		'���������R�[�h
Dim strOrgPostName		'��������
Dim strOrgPostKName		'�����J�i����
Dim strJobName			'�E��
Dim strEmpNo			'�]�ƈ��ԍ�

Dim strToday			'�{�����t�i�V�X�e�����t�j
Dim strDispPerName		'�l���́i�����j
Dim strDispPerKName		'�l���́i�J�i�j
Dim strDispAge			'�N��i�\���p�j
Dim strDispBirth		'���N�����i�\���p�j

Dim strArrSochiDiv
strArrSochiDiv = Array("����Ǘ��w�� �i�Q�������w���j","�ی��w�� �i�K��w���j")

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon	 	= Server.CreateObject("HainsCommon.Common")

strPerId			= Request("perId")

'�l���̌���
If( strPerId <> "" ) Then
	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objPerson 	= Server.CreateObject("HainsPerson.Person")
	Set objFree		= Server.CreateObject("HainsFree.Free")

	'�l���ǂݍ���
	objPerson.SelectPerson strPerId,     strLastName,    strFirstName,    _
						   strLastKName, strFirstKName,  strBirth,        _
						   strGender,    strOrgCd1,      strOrgCd2,       _
						   strOrgKName,  strOrgName,     strOrgSName,     _
						   strOrgBsdCd,  strOrgBsdKName, strOrgBsdName,   _
						   strOrgRoomCd, strOrgRoomName, strOrgRoomKName, _
						   strOrgPostCd, strOrgPostName, strOrgPostKName, _
						   , strJobName, , , , , _
						   strEmpNo, Empty, Empty

	'�\���p���̂̕ҏW
	strDispPerName 	= Trim(strLastName & "�@" & strFirstName)
	strDispPerKName = Trim(strLastKName & "�@" & strFirstKName)

	'�N��̎Z�o
	strToday = Year(now) & "/" & Month(now) & "/" & Day(now)
	strDispAge = objFree.CalcAge( strBirth , strToday , "" )

	'�a��ҏW
	strDispBirth = objCommon.FormatString(strBirth, "gee.mm.dd")

	'����
	strGender = IIf(strGender = CStr(GENDER_MALE), "�j��", "����")

	'�\�����e�̕ҏW
	strDispBirth = strDispBirth & "���@" & strDispAge & "�΁@" & strGender

	'�I�u�W�F�N�g�̃C���X�^���X�̊J��
	Set objPerson = Nothing

End If


%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>����[�u�敪�̑I��</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
function goNextPage() {

	if ( document.entryForm.sochiDiv[0].checked ) {
		location.href = 'SecondCslList.asp?perId=' + '<%= strPerId %>' ;
	}

	if ( document.entryForm.sochiDiv[1].checked ) {
		location.href = 'AfterCareEntryDate.asp?perId=' + '<%= strPerId %>' ;
	}

}

//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="default.css">
<style type="text/css">
	body { margin: 20px 0 0 0; }
</style>
</HEAD>
<BODY>
<BASEFONT SIZE="2">
<FORM NAME="entryForm" ACTION="" METHOD="get">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">��</SPAN><FONT COLOR="#000000">����[�u�敪�̑I��</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD NOWRAP><%= strEmpNo %></TD>
			<TD NOWRAP><B><%= strDispPerName %></B> (<FONT SIZE="-1"><%= strDispPerKName %></FONT>)</TD>
		<TR>
		<TR>
			<TD></TD>
			<TD NOWRAP><%= strDispBirth %></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD ALIGN="right" NOWRAP>�c�́F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD NOWRAP><%= strOrgName %></TD>
						<TD NOWRAP>&nbsp;&nbsp;�����F</TD>
						<TD NOWRAP><%= strOrgPostName %></TD>
						<TD NOWRAP>&nbsp;&nbsp;�E��F</TD>
						<TD NOWRAP><%= strJobName %></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

	<BR>

	<FONT COLOR="#cc9999">��</FONT>����[�u�敪��I�����ĉ������B<BR><BR>

	<TABLE BORDER="0" CELLPADDING="" CELLSPACING="2">
		<TR>
			<TD NOWRAP>����[�u�敪�F</TD>
			<TD><INPUT TYPE="radio" NAME="sochiDiv" VALUE="0" CHECKED></TD>
			<TD NOWRAP><%= strArrSochiDiv(0) %></TD>
		</TR>
		<TR>
			<TD></TD>
			<TD><INPUT TYPE="radio" NAME="sochiDiv" VALUE="1"></TD>
			<TD NOWRAP><%= strArrSochiDiv(1) %></TD>
		</TR>
	</TABLE>

	<BR>

	<A HREF="JavaScript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z��"></A>
	<A HREF="javascript:goNextPage()"><IMG SRC="/webHains/images/next.gif" WIDTH="77" HEIGHT="24" ALT="����"></A>

	</BLOCKQUOTE>
</FORM>
</BODY>
</HTML>

