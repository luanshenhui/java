<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�Q�����f�̑I��(Ver0.0.1)
'		AUTHER  : Yamamoto yk-mix@kjps.net
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->

<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim objCommon			'���ʃN���X
Dim objAfterCare		'�A�t�^�[�P�A���
Dim objPerson			'�l���p
Dim objFree				'�ėp���p

'-----------------------------------------------------------------------------
' �ϐ��錾
'-----------------------------------------------------------------------------
Dim strPerId			'�l�h�c

'��f���擾�i�A�t�^�[�P�A�j
Dim strSecondCslDate	'��f��
Dim strRsvNo			'�\��ԍ�

'�l���
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

Dim strDispPerName		'�l���́i�����j
Dim strDispPerKName		'�l���́i�J�i�j
Dim strDispAge			'�N��i�\���p�j
Dim strDispBirth		'���N�����i�\���p�j

Dim lngSecondCslDate	'��f�����R�[�h�J�E���g
Dim i					'���[�v�J�E���g

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon    = Server.CreateObject("HainsCommon.Common")
Set objPerson    = Server.CreateObject("HainsPerson.Person")

strPerId = Request("perId")

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
Set objFree = Server.CreateObject("HainsFree.Free")
strDispAge = objFree.CalcAge(strBirth, Date, "")
Set objFree = Nothing

'�a��ҏW
strDispBirth = objCommon.FormatString(strBirth, "gee.mm.dd")

'����
strGender = IIf(strGender = CStr(GENDER_MALE), "�j��", "����")

'�\�����e�̕ҏW
strDispBirth = strDispBirth & "���@" & strDispAge & "�΁@" & strGender

'�I�u�W�F�N�g�̃C���X�^���X�̉��
Set objPerson = Nothing
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�Q�����f�̑I��</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
function goNextPage() {

	var objForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g
	var contactDate, secRsvNo;			// �Q�����f��f���Ƃ��̗\��ԍ�
	var url;							// URL������

	if ( objForm.cslDate.length != null ) {
		for ( var i = 0; i < objForm.cslDate.length; i++ ) {
			if ( objForm.cslDate[ i ].checked ) {
				contactDate = objForm.cslDate[ i ].value;
				secRsvNo    = objForm.rsvNo[ i ].value;
				break;
			}
		}
	} else {
		contactDate = objForm.cslDate.value;
		secRsvNo    = objForm.rsvNo.value;
	}

	url = '/webHains/contents/aftercare/AfterCareInterview.asp';
	url = url + '?disp='        + '0';
	url = url + '&perId='       + '<%= strPerId %>';
	url = url + '&contactDate=' + contactDate;
	url = url + '&rsvNo='       + secRsvNo;
	location.href = url;

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 0; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="" METHOD="get">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">��</SPAN><FONT COLOR="#000000">�Q�����f�̑I��</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD NOWRAP>0010005</TD>
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
<%
	Do

		'�Q����f���̎擾
		Set objAfterCare = Server.CreateObject("HainsAfterCare.AfterCare")
		lngSecondCslDate = objAfterCare.SelectSecondCslDate(strPerId, strSecondCslDate, strRsvNo)
		If lngSecondCslDate <= 0 Then
%>
			<SPAN STYLE="color:#ff9900;font-weight:bolder;font-size:12px;">����[�u���͑ΏۂƂȂ�Q�����f�����݂��܂���B</SPAN><BR><BR>
<%
			Exit Do
		End If
%>
		<FONT COLOR="#cc9999">��</FONT>����Ǘ��w�����s���Q�����f�̎�f����I�����ĉ������B<BR><BR>

		<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
<%
			For i = 0 to lngSecondCslDate - 1
%>
				<TR>
					<TD><INPUT TYPE="radio" NAME="cslDate" VALUE="<%= strSecondCslDate(i) %>"<%= IIf(i = 0, " CHECKED", "") %>><INPUT TYPE="hidden" NAME="rsvNo" VALUE="<%= strRsvNo(i) %>"></TD>
					<TD NOWRAP><%= objCommon.FormatString(strSecondCslDate(i), "yyyy�Nmm��dd��") %></TD>
				</TR>
<%
			Next
%>
		</TABLE>

		<BR>
<%
		Exit Do
	Loop
%>
	<A HREF="JavaScript:history.back()"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z��"></A>
<%
	If lngSecondCslDate > 0 Then
%>
		<A HREF="JavaScript:goNextPage()"><IMG SRC="/webHains/images/next.gif" WIDTH="77" HEIGHT="24" ALT="����"></A>
<%
	End If
%>
	</BLOCKQUOTE>
</FORM>
</BODY>
</HTML>

