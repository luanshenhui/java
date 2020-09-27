<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'		�\��g�R�s�[(�R�s�[�������̎w��) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Dim objSchedule			'�X�P�W���[�����A�N�Z�X�p

'�����l
Dim strCslYear			'��f�N
Dim strCslMonth			'��f��
Dim strCslDay			'��f��
Dim strCsCd				'�R�[�X�R�[�h
Dim strRsvGrpCd			'�\��Q�R�[�h
Dim strNext				'�u���ցv�{�^�������̗L��
Dim strNoRec			'����ʂɂ����ă��R�[�h�Ȃ��Ɣ��f���ꂽ�ꍇ�ɒl���i�[�����

Dim strArrCsCd			'�R�[�X�R�[�h
Dim strArrCsName		'�R�[�X����
Dim lngCsCount			'�R�[�X��

Dim strArrRsvGrpCd		'�\��Q�R�[�h
Dim strArrRsvGrpName	'�\��Q����
Dim lngRsvGrpCount		'�\��Q��

Dim strCslDate			'��f�N����
Dim strMessage			'�G���[���b�Z�[�W
Dim strURL				'�W�����v���URL

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�����l�̎擾
strCslYear  = Request("cslYear")
strCslMonth = Request("cslMonth")
strCslDay   = Request("cslDay")
strCsCd     = Request("csCd")
strRsvGrpCd = Request("rsvGrpCd")
strNext     = Request("next.x")
strNoRec    = Request("noRec")

'��f�N�����̃f�t�H���g�ݒ�
strCslYear  = IIf(strCslYear  <> "", strCslYear,  Year(Date))
strCslMonth = IIf(strCslMonth <> "", strCslMonth, Month(Date))
strCslDay   = IIf(strCslDay   <> "", strCslDay,   Day(Date))

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do

	'����ʂɂ����ă��R�[�h�Ȃ��Ɣ��f���ꂽ�ꍇ
	If strNoRec <> "" Then
		strMessage = "���̏����𖞂����\��l�����͓o�^����Ă��܂���B"
		Exit Do
	End If

	'�u���ցv�{�^���������ȊO�͉������Ȃ�
	If strNext = "" Then
		Exit Do
	End If

	'��f���`�F�b�N
	strCslDate = strCslYear & "/" & strCslMonth & "/" & strCslDay
	If Not IsDate(strCslDate) Then
		strMessage = "�R�s�[����f���̓��͌`��������������܂���B"
		Exit Do
	End If

	'����ʂփ��_�C���N�g
	strURL = "rsvFraCopy2.asp"
	strURL = strURL & "?cslYear="  & strCslYear
	strURL = strURL & "&cslMonth=" & strCslMonth
	strURL = strURL & "&cslDay="   & strCslDay
	strURL = strURL & "&csCd="     & strCsCd
	strURL = strURL & "&rsvGrpCd=" & strRsvGrpCd
	Response.Redirect strURL
	Response.End

	Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�\��g�R�s�[</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<STYLE TYPE="text/css">
td.mnttab { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY >

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" action="#">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">��</SPAN><FONT COLOR="#000000">�\��g�R�s�[</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'�G���[���b�Z�[�W�̕ҏW
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)
%>
	<BR>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD><FONT COLOR="#ff0000">��</FONT></TD>
			<TD WIDTH="110" NOWRAP>�R�s�[����f��</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('cslYear','cslMonth','cslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
			<TD><%= EditNumberList("cslYear", YEARRANGE_MIN, YEARRANGE_MAX, strCslYear, False) %></TD>
			<TD>�N</TD>
			<TD><%= EditNumberList("cslMonth", 1, 12, strCslMonth, False) %></TD>
			<TD>��</TD>
			<TD><%= EditNumberList("cslDay", 1, 31, strCslDay, False) %></TD>
			<TD>��</TD>
		</TR>
	</TABLE>
<%
	Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")

	'�\��Q�Ǘ��R�[�X���̓ǂݍ���
	lngCsCount = objSchedule.SelectCourseListRsvGrpManaged(strArrCsCd, strArrCsName)
%>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD>��</TD>
			<TD WIDTH="110" NOWRAP>�R�[�X�R�[�h</TD>
			<TD>�F</TD>
			<TD><%= EditDropDownListFromArray("csCd", strArrCsCd, strArrCsName, strCsCd, NON_SELECTED_ADD) %></TD>
		</TR>
	</TABLE>
<%
	'�\��Q���ǂݍ���
	lngRsvGrpCount = objSchedule.SelectRsvGrpList(0, strArrRsvGrpCd, strArrRsvGrpName)

	Set objSchedule = Nothing
%>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD>��</TD>
			<TD WIDTH="110" NOWRAP>�\��Q</TD>
			<TD>�F</TD>
			<TD><%= EditDropDownListFromArray("rsvGrpCd", strArrRsvGrpCd, strArrRsvGrpName, strRsvGrpCd, NON_SELECTED_ADD) %></TD>
		</TR>
	</TABLE>

	<BR><BR>

	<% If Session("PAGEGRANT") = "4" Then %>
        <INPUT TYPE="image" NAME="next" SRC="/webHains/images/next.gif" WIDTH="77" HEIGHT="24" ALT="����">
    <% End IF %>

	</BLOCKQUOTE>
</FORM>
</BODY>
</HTML>