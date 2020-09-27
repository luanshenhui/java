<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'		�\��g�R�s�[(�R�s�[������̎w��) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Dim objCourse			'�R�[�X���A�N�Z�X�p
Dim objSchedule			'�X�P�W���[�����A�N�Z�X�p

'�����l
Dim strCslYear			'�R�s�[����f�N
Dim strCslMonth			'�R�s�[����f��
Dim strCslDay			'�R�s�[����f��
Dim strCsCd				'�R�[�X�R�[�h
Dim strRsvGrpCd			'�\��Q�R�[�h

Dim strStrCslYear		'�R�s�[��J�n��f�N
Dim strStrCslMonth		'�R�s�[��J�n��f��
Dim strStrCslDay		'�R�s�[��J�n��f��
Dim strEndCslYear		'�R�s�[��I����f�N
Dim strEndCslMonth		'�R�s�[��I����f��
Dim strEndCslDay		'�R�s�[��I����f��
Dim strWeekday			'�j���t���O
Dim strUpdFlg			'�㏑���t���O
Dim strCopy				'�u�R�s�[�v�{�^�������̗L��
Dim strCount			'���R�[�h����

'�\��l�����
Dim strArrCsName		'�R�[�X��
Dim strWebColor			'web�J���[
Dim strArrRsvGrpName	'�\��Q����
Dim strMaxCnt			'�\��\�l���i���ʁj
Dim strMaxCnt_M			'�\��\�l���i�j�j
Dim strMaxCnt_F			'�\��\�l���i���j
Dim strOverCnt			'�I�[�o�\�l���i���ʁj
Dim strOverCnt_M		'�I�[�o�\�l���i�j�j
Dim strOverCnt_F		'�I�[�o�\�l���i���j
Dim strRsvCnt_M			'�\��ςݐl���i�j�j
Dim strRsvCnt_F			'�\��ςݐl���i���j
Dim lngRsvFraCount		'�\��l����񃌃R�[�h��

Dim strCsName			'�R�[�X��
Dim strRsvGrpName		'�\��Q����
Dim dtmCslDate			'�R�s�[����f�N����
Dim dtmStrCslDate		'�R�s�[��J�n��f�N����
Dim dtmEndCslDate		'�R�s�[��J�n��f�N����
Dim strMessage			'�G���[���b�Z�[�W
Dim lngMessageType		'���b�Z�[�W���
Dim strURL				'�W�����v���URL
Dim Ret					'�֐��߂�l
Dim i					'�C���f�b�N�X
Dim strDmy(6)			'�_�~�[�ϐ�

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
ReDim strWeekday(6)

'�����l�̎擾
strCslYear     = Request("cslYear")
strCslMonth    = Request("cslMonth")
strCslDay      = Request("cslDay")
strCsCd        = Request("csCd")
strRsvGrpCd    = Request("rsvGrpCd")

strStrCslYear  = Request("strCslYear")
strStrCslMonth = Request("strCslMonth")
strStrCslDay   = Request("strCslDay")
strEndCslYear  = Request("endCslYear")
strEndCslMonth = Request("endCslMonth")
strEndCslDay   = Request("endCslDay")
strWeekDay(0)  = Request("mon")
strWeekDay(1)  = Request("tue")
strWeekDay(2)  = Request("wed")
strWeekDay(3)  = Request("thu")
strWeekDay(4)  = Request("fri")
strWeekDay(5)  = Request("sat")
strWeekDay(6)  = Request("sun")
strUpdFlg      = Request("upd")
strCopy        = Request("copy.x")
strCount       = Request("count")

'��f�N�����̃f�t�H���g�ݒ�
strStrCslYear  = IIf(strStrCslYear  <> "", strStrCslYear,  Year(Date))
strStrCslMonth = IIf(strStrCslMonth <> "", strStrCslMonth, Month(Date))
strStrCslDay   = IIf(strStrCslDay   <> "", strStrCslDay,   Day(Date))
strEndCslYear  = IIf(strEndCslYear  <> "", strEndCslYear,  Year(Date))
strEndCslMonth = IIf(strEndCslMonth <> "", strEndCslMonth, Month(Date))
strEndCslDay   = IIf(strEndCslDay   <> "", strEndCslDay,   Day(Date))

'�R�s�[����f���̕ҏW
dtmCslDate = CDate(strCslYear & "/" & strCslMonth & "/" & strCslDay)

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do

	'���R�[�h�ϐ����n����Ă���ꍇ�̓��b�Z�[�W��ҏW
	If strCount <> "" Then
		If CLng(strCount) > 0 Then
			strMessage = strCount & "���̗\��g��񂪍쐬�^�X�V����܂����B"
		Else
			strMessage = "�\��g�͍쐬����܂���ł����B"
		End If
		lngMessageType = MESSAGETYPE_NORMAL
		Exit Do
	End If

	'�u�R�s�[�v�{�^���������ȊO�͉������Ȃ�
	If strCopy = "" Then
		Exit Do
	End If

	'���̓`�F�b�N
	strMessage = CheckValue()
	If Not IsEmpty(strMessage) Then
		lngMessageType = MESSAGETYPE_WARNING
		Exit Do
	End If

	'�R�s�[���f�N�����̕ҏW
	dtmStrCslDate = CDate(strStrCslYear & "/" & strStrCslMonth & "/" & strStrCslDay)
	dtmEndCslDate = CDate(strEndCslYear & "/" & strEndCslMonth & "/" & strEndCslDay)

	Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")

	'�R�s�[
	Ret = objSchedule.CopyRsvFraMng(dtmCslDate, strCsCd, strRsvGrpCd, dtmStrCslDate, dtmEndCslDate, strWeekday, (strUpdFlg <> ""))

	Set objSchedule = Nothing

	'����ʂ����_�C���N�g
	strURL = Request.ServerVariables("SCRIPT_NAME")
	strURL = strURL & "?cslYear="     & strCslYear
	strURL = strURL & "&cslMonth="    & strCslMonth
	strURL = strURL & "&cslDay="      & strCslDay
	strURL = strURL & "&csCd="        & strCsCd
	strURL = strURL & "&rsvGrpCd="    & strRsvGrpCd
	strURL = strURL & "&strCslYear="  & strStrCslYear
	strURL = strURL & "&strCslMonth=" & strStrCslMonth
	strURL = strURL & "&strCslDay="   & strStrCslDay
	strURL = strURL & "&endCslYear="  & strEndCslYear
	strURL = strURL & "&endCslMonth=" & strEndCslMonth
	strURL = strURL & "&endCslDay="   & strEndCslDay
	strURL = strURL & "&mon="         & strWeekday(0)
	strURL = strURL & "&tue="         & strWeekday(1)
	strURL = strURL & "&wed="         & strWeekday(2)
	strURL = strURL & "&thu="         & strWeekday(3)
	strURL = strURL & "&fri="         & strWeekday(4)
	strURL = strURL & "&sat="         & strWeekday(5)
	strURL = strURL & "&sun="         & strWeekday(6)
	strURL = strURL & "&upd="         & strUpdFlg
	strURL = strURL & "&count="       & Ret
	Response.Redirect strURL
	Response.End

	Exit Do
Loop

Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")

'�\��l���Ǘ����R�[�h�ǂݍ���
lngRsvFraCount = objSchedule.SelectRsvFraMngList(dtmCslDate, dtmCslDate, strCsCd, strRsvGrpCd, , , strArrCsName, strWebColor, , strArrRsvGrpName, , strMaxCnt, strMaxCnt_M, strMaxCnt_F, strOverCnt, strOverCnt_M, strOverCnt_F, strRsvCnt_M, strRsvCnt_F)

Set objSchedule = Nothing

'�R�s�[���ƂȂ�ׂ��\��l����񂪑��݂��Ȃ��ꍇ
If lngRsvFraCount <= 0 Then

	'�O��ʂɖ߂�
	strURL = "rsvFraCopy1.asp"
	strURL = strURL & "?cslYear="  & strCslYear
	strURL = strURL & "&cslMonth=" & strCslMonth
	strURL = strURL & "&cslDay="   & strCslDay
	strURL = strURL & "&csCd="     & strCsCd
	strURL = strURL & "&rsvGrpCd=" & strRsvGrpCd
	strURL = strURL & "&noRec="    & "1"
	Response.Redirect strURL
	Response.End

End If
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���̓`�F�b�N
'
' �����@�@ :
'
' �߂�l�@ : �G���[���b�Z�[�W�̔z��
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CheckValue()

	Dim objCommon		'���ʃN���X

	Dim strStrCslDate	'�J�n��f�N����
	Dim strEndCslDate	'�I����f�N����
	Dim strArrMessage	'�G���[���b�Z�[�W�̔z��
	Dim strMessage		'�G���[���b�Z�[�W
	Dim blnDateError	'���t�ɃG���[�����邩
	Dim blnCheckWeekday	'�j���`�F�b�N�̗v��
	Dim blnChecked		'�Ώۗj�����`�F�b�N����Ă����True
	Dim i				'�C���f�b�N�X

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'�R�s�[��J�n��f���`�F�b�N
	strStrCslDate = strStrCslYear & "/" & strStrCslMonth & "/" & strStrCslDay
	If Not IsDate(strStrCslDate) Then
		objCommon.AppendArray strArrMessage, "�R�s�[���J�n��f���̓��͌`��������������܂���B"
		blnDateError = True
	End If

	'�R�s�[��I����f���`�F�b�N
	strEndCslDate = strEndCslYear & "/" & strEndCslMonth & "/" & strEndCslDay
	If Not IsDate(strEndCslDate) Then
		objCommon.AppendArray strArrMessage, "�R�s�[���I����f���̓��͌`��������������܂���B"
		blnDateError = True
	End If

	'�j���`�F�b�N�v�ۂ̔���

	'���t�G���[���̓`�F�b�N�ΏۂƂ��A���t���펞�͓��t���͈͂Ŏw�肳��Ă���ꍇ�̂݃`�F�b�N�ΏۂƂ���
	If blnDateError Then
		blnCheckWeekday = True
	Else
		blnCheckWeekday = (strStrCslDate <> strEndCslDate)
	End If

	'�j���`�F�b�N
	If blnCheckWeekday Then

		'�Ώۗj�����w�肳��Ă��邩���`�F�b�N
		blnChecked = False
		For i = 0 To UBound(strWeekday)
			If strWeekday(i) <> "" Then
				blnChecked = True
			End If
		Next

		'���ׂĖ��`�F�b�N�̏ꍇ
		If Not blnChecked Then
			objCommon.AppendArray strArrMessage, "�Ώۗj����I�����Ă��������B"
		End If

	End If

	'�`�F�b�N���ʂ�Ԃ�
	CheckValue = strArrMessage

	Set objCommon = Nothing

End Function
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
</HEAD>
<STYLE TYPE="text/css">
td.mnttab { background-color:#ffffff }
</STYLE>
<BODY >
<BASEFONT SIZE="2">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ONSUBMIT="javascript:return confirm('���̓��e�ŗ\��g�̃R�s�[���s���܂��B��낵���ł����H')" action="#">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="cslYear"  VALUE="<%= strCslYear  %>">
	<INPUT TYPE="hidden" NAME="cslMonth" VALUE="<%= strCslMonth %>">
	<INPUT TYPE="hidden" NAME="cslDay"   VALUE="<%= strCslDay   %>">
	<INPUT TYPE="hidden" NAME="csCd"     VALUE="<%= strCsCd     %>">
	<INPUT TYPE="hidden" NAME="rsvGrpCd" VALUE="<%= strRsvGrpCd %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="635">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">��</SPAN><FONT COLOR="#000000">�\��g�̃R�s�[</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'�G���[���b�Z�[�W�̕ҏW
	Call EditMessage(strMessage, lngMessageType)
%>
	<BR>

	<FONT SIZE="+1"><FONT COLOR="#cc9999">��</FONT>�R�s�[�����ݒ肵�Ă��������B</FONT><BR>

	<BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD NOWRAP>�R�s�[��͈�</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
					<TR>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear','strCslMonth','strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
						<TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strStrCslYear, False) %></TD>
						<TD>�N</TD>
						<TD><%= EditNumberList("strCslMonth", 1, 12, strStrCslMonth, False) %></TD>
						<TD>��</TD>
						<TD><%= EditNumberList("strCslDay", 1, 31, strStrCslDay, False) %></TD>
						<TD>��</TD>
						<TD>�`</TD>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('endCslYear','endCslMonth','endCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
						<TD><%= EditNumberList("endCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strEndCslYear, False) %></TD>
						<TD>�N</TD>
						<TD><%= EditNumberList("endCslMonth", 1, 12, strEndCslMonth, False) %></TD>
						<TD>��</TD>
						<TD><%= EditNumberList("endCslDay", 1, 31, strEndCslDay, False) %></TD>
						<TD>��</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD>�Ώۗj��</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
					<TR>
						<TD><INPUT TYPE="checkbox" NAME="mon" VALUE="1"<%= IIf(strWeekDay(0) <> "", " CHECKED", "") %>></TD><TD>��<IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
						<TD><INPUT TYPE="checkbox" NAME="tue" VALUE="1"<%= IIf(strWeekDay(1) <> "", " CHECKED", "") %>></TD><TD>��<IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
						<TD><INPUT TYPE="checkbox" NAME="wed" VALUE="1"<%= IIf(strWeekDay(2) <> "", " CHECKED", "") %>></TD><TD>��<IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
						<TD><INPUT TYPE="checkbox" NAME="thu" VALUE="1"<%= IIf(strWeekDay(3) <> "", " CHECKED", "") %>></TD><TD>��<IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
						<TD><INPUT TYPE="checkbox" NAME="fri" VALUE="1"<%= IIf(strWeekDay(4) <> "", " CHECKED", "") %>></TD><TD>��<IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
						<TD><INPUT TYPE="checkbox" NAME="sat" VALUE="1"<%= IIf(strWeekDay(5) <> "", " CHECKED", "") %>></TD><TD>�y<IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
						<TD><INPUT TYPE="checkbox" NAME="sun" VALUE="1"<%= IIf(strWeekDay(6) <> "", " CHECKED", "") %>></TD><TD>��</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD></TD>
			<TD NOWRAP><FONT COLOR="#999999">�i�R�s�[��͈͂��P����̏ꍇ�A���̎w��͖�������܂��B�j</FONT></TD>
		</TR>
		<TR>
			<TD>�������[�h</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
					<TR>
						<TD><INPUT TYPE="checkbox" NAME="upd" VALUE="1"<%= IIf(strUpdFlg <> "", " CHECKED", "") %>></TD>
						<TD NOWRAP>���ɘg��񂪑��݂���ꍇ�A�㏑������</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

	<BR>
<%
	'�O��ʂ�URL�ҏW
	strURL = "rsvFraCopy1.asp"
	strURL = strURL & "?cslYear="  & strCslYear
	strURL = strURL & "&cslMonth=" & strCslMonth
	strURL = strURL & "&cslDay="   & strCslDay
	strURL = strURL & "&csCd="     & strCsCd
	strURL = strURL & "&rsvGrpCd=" & strRsvGrpCd
%>
	<A HREF="<%= strURL %>"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�R�s�[�������w��ɖ߂�"></A>
	
    <% If Session("PAGEGRANT") = "4" Then %>
        <INPUT TYPE="image" NAME="copy" SRC="/webHains/images/copy.gif" WIDTH="77" HEIGHT="24" ALT="���̓��e�ŗ\��g�̃R�s�[���s��">
    <% End IF %>

	</BLOCKQUOTE>
</FORM>

<BLOCKQUOTE>

<FONT SIZE="+1"><FONT COLOR="#cc9999">��</FONT>�i�R�s�[�����j�u<FONT COLOR="#ff6600"><B><%= strCslYear %>�N<%= strCslMonth %>��<%= strCslDay %>��</B></FONT>�v
<%
'�R�[�X�w�莞�͖��̂��擾
If strCsCd <> "" Then

	Set objCourse = Server.CreateObject("HainsCourse.Course")
	objCourse.SelectCourse strCsCd, strCsName
	Set objCourse = Nothing
%>
	�u<FONT COLOR="#ff6600"><B><%= strCsName %></B></FONT>�v
<%
End If

'�\��Q�w�莞�͖��̂��擾
If strRsvGrpCd <> "" Then

	Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")
	objSchedule.SelectRsvGrp strRsvGrpCd, strRsvGrpName, strDmy(0), strDmy(1), strDmy(2), strDmy(3), strDmy(4), strDmy(5), strDmy(6)	'�V���b�N�BOptional�w�肪�Ȃ������̂ł��B
	Set objSchedule = Nothing
%>
	�u<FONT COLOR="#ff6600"><B><%= strRsvGrpName %></B></FONT>�v
<%
End If
%>
�̗\��g�ꗗ</FONT><BR><BR>

<FONT SIZE="+1"><FONT COLOR="#ff6600"><B><%= lngRsvFraCount %></B></FONT>���̃��R�[�h������܂��B</FONT><BR><BR>

<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2">
	<TR BGCOLOR="#cccccc" ALIGN="center">
		<TD ROWSPAN="2" NOWRAP>��f��</TD>
		<TD ROWSPAN="2" NOWRAP>��f�R�[�X</TD>
		<TD ROWSPAN="2" NOWRAP>�\��Q</TD>
		<TD COLSPAN="3" NOWRAP>�\��\�l��</TD>
		<TD COLSPAN="3" NOWRAP>�I�[�o�\�l��</TD>
		<TD COLSPAN="2" NOWRAP>�\��ςݐl��</TD>
	</TR>
	<TR BGCOLOR="cccccc" ALIGN="center">
		<TD WIDTH="50" NOWRAP>����</TD>
		<TD WIDTH="50" NOWRAP>�j</TD>
		<TD WIDTH="50" NOWRAP>��</TD>
		<TD WIDTH="50" NOWRAP>����</TD>
		<TD WIDTH="50" NOWRAP>�j</TD>
		<TD WIDTH="50" NOWRAP>��</TD>
		<TD WIDTH="50" NOWRAP>�j</TD>
		<TD WIDTH="50" NOWRAP>��</TD>
	</TR>
<%
	For i = 0 To lngRsvFraCount - 1
%>
		<TR BGCOLOR="#<%= IIf(i Mod 2 = 0, "ffffff", "eeeeee") %>" ALIGN="right">
			<TD ALIGN="left" NOWRAP><%= dtmCslDate %></TD>
			<TD ALIGN="left" NOWRAP><FONT COLOR="#<%= strWebColor(i) %>">��</FONT><%= strArrCsName(i) %></TD>
			<TD ALIGN="left" NOWRAP><%= strArrRsvGrpName(i) %></TD>
			<TD NOWRAP><%= strMaxCnt(i)    %></TD> 
			<TD NOWRAP><%= strMaxCnt_M(i)  %></TD>
			<TD NOWRAP><%= strMaxCnt_F(i)  %></TD>
			<TD NOWRAP><%= strOverCnt(i)   %></TD>
			<TD NOWRAP><%= strOverCnt_M(i) %></TD>
			<TD NOWRAP><%= strOverCnt_F(i) %></TD>
			<TD NOWRAP><%= strRsvCnt_M(i)  %></TD>
			<TD NOWRAP><%= strRsvCnt_F(i)  %></TD>
		</TR>
<%
	Next
%>
</TABLE>

</BLOCKQUOTE>
</BODY>
</HTML>