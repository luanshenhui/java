<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�ʐړ��̓���(Ver0.0.1)
'		AUTHER  : Yamamoto yk-mix@kjps.net
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"    -->
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
Dim objAfterCare		'�A�t�^�[�P�A�p

'-----------------------------------------------------------------------------
' �ϐ��錾
'-----------------------------------------------------------------------------
Dim strPerId			'�l�h�c
Dim lngDataYear			'�ʐڔN
Dim lngDataMonth 		'�ʐڌ�
Dim lngDataDay			'�ʐړ�

'�l���
Dim strLastName			'��
Dim strFirstName		'��
Dim strLastKName		'�J�i��
Dim strFirstKName		'�J�i��
Dim strBirth			'���N����
Dim strGender			'����
Dim strOrgCd1			'�c�̃R�[�h�P
Dim strOrgCd2			'�c�̃R�[�h�Q
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

Dim strArrContactDate	'�ʐړ�
Dim strArrRsvNo			'�\��ԍ�

Dim strDispPerName		'�l���́i�����j
Dim strDispPerKName		'�l���́i�J�i�j
Dim strDispAge			'�N��i�\���p�j
Dim strDispBirth		'���N�����i�\���p�j
Dim strDate				'�`�F�b�N�p���t���[�N

Dim lngAfteCareCount	'�A�t�^�[�P�A�����J�E���g

Dim strMessage			'���b�Z�[�W
Dim strURL				'URL������

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon    = Server.CreateObject("HainsCommon.Common")
Set objAfterCare = Server.CreateObject("HainsAfterCare.AfterCare")

strPerId     = Request("perId")
lngDataYear  = CLng("0" & Request("dataYear"))
lngDataMonth = CLng("0" & Request("dataMonth"))
lngDataDay   = CLng("0" & Request("dataDay"))

'�f�t�H���g�l�̐ݒ�
lngDataYear  = IIf(lngDataYear  = 0, Year(Date),  lngDataYear )
lngDataMonth = IIf(lngDataMonth = 0, Month(Date), lngDataMonth)
lngDataDay   = IIf(lngDataDay   = 0, Day(Date),   lngDataDay  )

Do

	'�u���ցv�{�^���������ꂽ�ꍇ�ȊO�͉������Ȃ�
	If Request("next.x") = "" Then
		Exit Do
	End If

	'�ʐڔN�����̕ҏW
	strDate = lngDataYear & "/" & lngDataMonth & "/" & lngDataDay

	'�ʐڔN�����̓��t�`�F�b�N
	If Not IsDate(strDate) Then
		strMessage = "�ʐړ��̓��͌`��������������܂���B"
		Exit Do
	End If

	'�w��l�h�c�A�ʐړ��̃A�t�^�[�P�A��񂪑��݂��邩���`�F�b�N
	strArrContactDate = strDate
	lngAfteCareCount = objAfterCare.SelectAfterCare(strPerId, strArrContactDate, , , strArrRsvNo)

	'�ʐڏ��̓o�^��ʂ�
	strURL = "/webHains/contents/aftercare/AfterCareInterview.asp"
	strURL = strURL & "?disp="        & "1"
	strURL = strURL & "&perId="       & strPerId
	strURL = strURL & "&contactDate=" & strDate
	Response.Redirect strURL
	Response.End

	Exit Do
Loop

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objPerson = Server.CreateObject("HainsPerson.Person")
Set objFree   = Server.CreateObject("HainsFree.Free")

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
strDispAge = objFree.CalcAge(strBirth, Date, "")

'�a��ҏW
strDispBirth = objCommon.FormatString(strBirth, "gee.mm.dd")

'����
strGender = IIf(strGender = CStr(GENDER_MALE), "�j��", "����")

'�\�����e�̕ҏW
strDispBirth = strDispBirth & "���@" & strDispAge & "�΁@" & strGender

'�I�u�W�F�N�g�̃C���X�^���X�̊J��
Set objPerson = Nothing
Set objFree = Nothing
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type" content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�ʐړ��̓���</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<style type="text/css">
	body { margin: 20px 0 0 0; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<BLOCKQUOTE>
	<INPUT TYPE="hidden" NAME="perId" VALUE="<%= strPerId %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">��</SPAN><FONT COLOR="#000000">�ʐړ��̓���</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'�G���[���b�Z�[�W�̕ҏW
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)
%>
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

	<BR><FONT COLOR="#cc9999">��</FONT>&nbsp;�ʐړ�����͂��ĉ������B<BR><BR>

	<TABLE BORDER="0" CELLPADDING="" CELLSPACING="2">
		<TR>
			<TD NOWRAP>�ʐړ��F</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('dataYear', 'dataMonth', 'dataDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
			<TD><%= EditNumberList("dataYear", YEARRANGE_MIN, YEARRANGE_MAX, lngDataYear , false) %></TD>
			<TD>�N</TD>
			<TD><%= EditNumberList("dataMonth", 1, 12, lngDataMonth, false) %></TD>
			<TD>��</TD>
			<TD><%= EditNumberList("dataDay", 1, 31, lngDataDay, false) %></TD>
			<TD>��</TD>
		</TR>
	</TABLE>

	<BR>

	<A HREF="JavaScript:history.back()"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z��"></A>
	<INPUT TYPE="image" NAME="next" SRC="/webHains/images/next.gif" WIDTH="77" HEIGHT="24" ALT="����">

	</BLOCKQUOTE>
</FORM>
</BODY>
</HTML>