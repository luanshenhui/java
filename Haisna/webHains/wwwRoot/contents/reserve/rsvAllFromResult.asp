<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'		���f���ʂ���̂Q���ꊇ�\�� (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'COM�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
'Dim objConsult			'��f���ꊇ�����p
Dim objContract			'�_����A�N�Z�X�p
Dim objCourse			'�R�[�X���A�N�Z�X�p
Dim objOrganization		'�c�̏��A�N�Z�X�p
Dim objOrgBsd			'���ƕ����A�N�Z�X�p
Dim objOrgPost			'�������A�N�Z�X�p
Dim objOrgRoom			'�������A�N�Z�X�p

'�����l
Dim lngStrCslYear		'�J�n��f�N
Dim lngStrCslMonth		'�J�n��f��
Dim lngStrCslDay		'�J�n��f��
Dim lngEndCslYear		'�I����f�N
Dim lngEndCslMonth		'�I����f��
Dim lngEndCslDay		'�I����f��
Dim strOrgCd1			'�c�̃R�[�h�P
Dim strOrgCd2			'�c�̃R�[�h�Q
Dim strArrCsCd 			'�R�[�X�R�[�h
Dim strOrgBsdCd			'���ƕ��R�[�h
Dim strOrgRoomCd		'�����R�[�h
Dim strStrOrgPostCd		'�J�n�����R�[�h
Dim strEndOrgPostCd		'�I�������R�[�h
Dim strCtrPtCd			'�_��p�^�[���R�[�h
Dim lngSecStrCslYear	'���蓖�ĊJ�n�N
Dim lngSecStrCslMonth	'���蓖�ĊJ�n��
Dim lngSecStrCslDay		'���蓖�ĊJ�n��
Dim lngSecEndCslYear	'���蓖�ďI���N
Dim lngSecEndCslMonth	'���蓖�ďI����
Dim lngSecEndCslDay		'���蓖�ďI����
Dim strCount			'�}������

'�������
Dim strOrgName			'�c�̖���
Dim strOrgBsdName		'���ƕ�����
Dim strOrgRoomName		'��������
Dim strStrOrgPostName	'�J�n��������
Dim strEndOrgPostName	'�I����������

'�_����
Dim strCsCd				'�R�[�X�R�[�h
Dim strCsName			'�R�[�X��
Dim dtmStrDate			'�_��J�n��
Dim dtmEndDate			'�_��I����

'�l���
Dim strPerId			'�l�h�c
Dim lngCount			'���R�[�h��

Dim dtmDate				'��Ɨp�̓��t
Dim dtmStrCslDate		'�J�n��f��
Dim dtmEndCslDate		'�I����f��
Dim dtmSecStrCslDate	'���蓖�ĊJ�n��
Dim dtmSecEndCslDate	'���蓖�ďI����
Dim strUpdUser			'�X�V��
Dim strMessage			'�G���[���b�Z�[�W
Dim strURL				'�W�����v���URL
Dim Ret					'�֐��߂�l
Dim i					'�C���f�b�N�X

Dim objExec				'��荞�ݏ������s�p
Dim strCommand			'�R�}���h���C��������

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
'Set objConsult      = Server.CreateObject("HainsCooperation.ConsultAll")
Set objContract     = Server.CreateObject("HainsContract.Contract")
Set objCourse       = Server.CreateObject("HainsCourse.Course")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objOrgBsd       = Server.CreateObject("HainsOrgBsd.OrgBsd")
Set objOrgPost      = Server.CreateObject("HainsOrgPost.OrgPost")
Set objOrgRoom      = Server.CreateObject("HainsOrgRoom.OrgRoom")

'�X�V�҂̐ݒ�
strUpdUser = Session("USERID")

'�����l�̎擾
lngStrCslYear     = CLng("0" & Request("strCslYear"))
lngStrCslMonth    = CLng("0" & Request("strCslMonth"))
lngStrCslDay      = CLng("0" & Request("strCslDay"))
lngEndCslYear     = CLng("0" & Request("endCslYear"))
lngEndCslMonth    = CLng("0" & Request("endCslMonth"))
lngEndCslDay      = CLng("0" & Request("endCslDay"))
strOrgCd1         = Request("orgCd1")
strOrgCd2         = Request("orgCd2")
strArrCsCd        = ConvIStringToArray(Request("csCd"))
strOrgBsdCd       = Request("orgBsdCd")
strOrgRoomCd      = Request("orgRoomCd")
strStrOrgPostCd   = Request("strOrgPostCd")
strEndOrgPostCd   = Request("endOrgPostCd")
strCtrPtCd        = Request("ctrPtCd")
lngSecStrCslYear  = CLng("0" & Request("secStrCslYear"))
lngSecStrCslMonth = CLng("0" & Request("secStrCslMonth"))
lngSecStrCslDay   = CLng("0" & Request("secStrCslDay"))
lngSecEndCslYear  = CLng("0" & Request("secEndCslYear"))
lngSecEndCslMonth = CLng("0" & Request("secEndCslMonth"))
lngSecEndCslDay   = CLng("0" & Request("secEndCslDay"))
strCount          = Request("count")

'��f�J�n�E�I�����̃f�t�H���g�l�ݒ�
'(��f�J�n�N���O�ɂȂ�P�[�X�͏����\�����ȊO�ɂȂ�)
If lngStrCslYear = 0 Then

	'�V�X�e�����t�ɑ΂��A��T�̌��j�܂œ��t��߂�
	dtmDate = DateAdd("d", (Weekday(Date()) + 5) * -1, Date())

	lngStrCslYear  = Year(dtmDate)
	lngStrCslMonth = Month(dtmDate)
	lngStrCslDay   = Day(dtmDate)

	'��T�̌��j������j�܂œ��t��i�߂�
	dtmDate = DateAdd("d", 4, dtmDate)

	lngEndCslYear  = Year(dtmDate)
	lngEndCslMonth = Month(dtmDate)
	lngEndCslDay   = Day(dtmDate)

End If

'���蓖�Ċ��Ԃ̃f�t�H���g�l�ݒ�
'(���蓖�Ċ��Ԃ��O�ɂȂ�P�[�X�͏����\�����ȊO�ɂȂ�)
If lngSecStrCslYear = 0 Then
	dtmDate = DateAdd("d", 1, Date())	'�Ƃ肠��������
	lngSecStrCslYear  = Year(dtmDate)
	lngSecStrCslMonth = Month(dtmDate)
	lngSecStrCslDay   = Day(dtmDate)
	lngSecEndCslYear  = Year(dtmDate)
	lngSecEndCslMonth = Month(dtmDate)
	lngSecEndCslDay   = Day(dtmDate)
End If

'�_����̓ǂݍ���(�`�F�b�N���ƕ\�����̗����Ŏg�p���邽�߁A�����ŗ\�ߓǂݍ���
If strOrgCd1 <> "" And strOrgCd2 <> "" And strCtrPtCd <> "" Then
	If objContract.SelectCtrMng(strOrgCd1, strOrgCd2, strCtrPtCd, strOrgName, strCsCd, strCsName, dtmStrDate, dtmEndDate) = False Then
		Err.Raise 1000, ,"�_���񂪑��݂��܂���B"
	End If
End If

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do

	'�u�m��v�{�^���������ȊO�͉������Ȃ�
	If IsEmpty(Request("reserve.x")) Then
		Exit Do
	End If

	'���̓`�F�b�N
	strMessage = CheckValue()
	If Not IsEmpty(strMessage) Then
		Exit Do
	End If

	'��f���̕ҏW
	dtmStrCslDate = CDate(lngStrCslYear & "/" & lngStrCslMonth & "/" & lngStrCslDay)
	dtmEndCslDate = CDate(lngEndCslYear & "/" & lngEndCslMonth & "/" & lngEndCslDay)
	dtmSecStrCslDate = CDate(lngSecStrCslYear & "/" & lngSecStrCslMonth & "/" & lngSecStrCslDay)
	dtmSecEndCslDate = CDate(lngSecEndCslYear & "/" & lngSecEndCslMonth & "/" & lngSecEndCslDay)

	'�ꊇ�\�񏈗�
'	Ret = objConsult.InsertConsultFromResult(strUpdUser, dtmStrCslDate, dtmEndCslDate, strArrCsCd, strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strStrOrgPostCd, strEndOrgPostCd, strCtrPtCd, dtmSecStrCslDate, dtmSecEndCslDate)

	strCommand = "cscript " & Server.MapPath("/webHains/script") & "\InsertConsultFromResult.vbs"
	strCommand = strCommand & " " & strUpdUser
	strCommand = strCommand & " " & dtmStrCslDate
	strCommand = strCommand & " " & dtmEndCslDate
	strCommand = strCommand & " " & Join(strArrCsCd, ",")
	strCommand = strCommand & " " & strOrgCd1
	strCommand = strCommand & " " & strOrgCd2
	strCommand = strCommand & " " & IIf(strOrgBsdCd     <> "", strOrgBsdCd,     """""")
	strCommand = strCommand & " " & IIf(strOrgRoomCd    <> "", strOrgRoomCd,    """""")
	strCommand = strCommand & " " & IIf(strStrOrgPostCd <> "", strStrOrgPostCd, """""")
	strCommand = strCommand & " " & IIf(strEndOrgPostCd <> "", strEndOrgPostCd, """""")
	strCommand = strCommand & " " & strCtrPtCd
	strCommand = strCommand & " " & dtmSecStrCslDate
	strCommand = strCommand & " " & dtmSecEndCslDate

	'��荞�ݏ����N��
	Set objExec = Server.CreateObject("HainsCooperation.Exec")
	objExec.Run strCommand
	Ret = 0

	'����ʂ����_�C���N�g
	strURL = Request.ServerVariables("SCRIPT_NAME")
	strURL = strURL & "?strCslYear="  & lngStrCslYear
	strURL = strURL & "&strCslMonth=" & lngStrCslMonth
	strURL = strURL & "&strCslDay="   & lngStrCslDay
	strURL = strURL & "&endCslYear="  & lngEndCslYear
	strURL = strURL & "&endCslMonth=" & lngEndCslMonth
	strURL = strURL & "&endCslDay="   & lngEndCslDay

	For i = 0 To UBound(strArrCsCd)
		strURL = strURL & "&csCd=" & strArrCsCd(i)
	Next

	strURL = strURL & "&orgCd1="         & strOrgCd1
	strURL = strURL & "&orgCd2="         & strOrgCd2
	strURL = strURL & "&orgBsdCd="       & strOrgBsdCd
	strURL = strURL & "&orgRoomCd="      & strOrgRoomCd
	strURL = strURL & "&strOrgPostCd="   & strStrOrgPostCd
	strURL = strURL & "&endOrgPostCd="   & strEndOrgPostCd
	strURL = strURL & "&ctrPtCd="        & strCtrPtCd
	strURL = strURL & "&secStrCslYear="  & lngSecStrCslYear
	strURL = strURL & "&secStrCslMonth=" & lngSecStrCslMonth
	strURL = strURL & "&secStrCslDay="   & lngSecStrCslDay
	strURL = strURL & "&secEndCslYear="  & lngSecEndCslYear
	strURL = strURL & "&secEndCslMonth=" & lngSecEndCslMonth
	strURL = strURL & "&secEndCslDay="   & lngSecEndCslDay
	strURL = strURL & "&count="          & Ret
	Response.Redirect strURL
	Response.End

	Exit Do
Loop

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �����l�̑Ó����`�F�b�N���s��
'
' �����@�@ :
'
' �߂�l�@ : �G���[�l������ꍇ�A�G���[���b�Z�[�W�̔z���Ԃ�
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CheckValue()

	Dim strStrCslDate		'�J�n��f��
	Dim strEndCslDate		'�I����f��
	Dim strSecStrCslDate	'���蓖�ĊJ�n��
	Dim strSecEndCslDate	'���蓖�ďI����
	Dim strMessage			'�G���[���b�Z�[�W�̏W��
	Dim blnError			'�G���[�t���O

	Dim strAllCsCd			'�R�[�X�R�[�h
	Dim strAllCsName		'�R�[�X��
	Dim strAllSecondFlg		'�Q�����f�t���O
	Dim lngCsCount			'�R�[�X��

	Dim blnIsSecond			'�Q�����f�R�[�X��
	Dim i, j				'�C���f�b�N�X

	blnError = False

	'�J�n��f���̃`�F�b�N
	strStrCslDate = lngStrCslYear & "/" & lngStrCslMonth & "/" & lngStrCslDay
	If Not IsDate(strStrCslDate) Then
		objCommon.appendArray strMessage, "�J�n��f���̓��͌`��������������܂���B"
		blnError = True
	End If

	'�I����f���̃`�F�b�N
	strEndCslDate = lngEndCslYear & "/" & lngEndCslMonth & "/" & lngEndCslDay
	If Not IsDate(strEndCslDate) Then
		objCommon.appendArray strMessage, "�I����f���̓��͌`��������������܂���B"
		blnError = True
	End If

	'�V�X�e�����t�ȏ�̓��t�͈͎͂w��ł��Ȃ�
	If Not blnError Then
		If CDate(strStrCslDate) >= Date() Or CDate(strEndCslDate) >= Date() Then
			objCommon.appendArray strMessage, "�{���ȍ~�i�{�����܂ށj�̎�f���͎w��ł��܂���B"
		End If
	End If

	'�c�̃R�[�h�̃`�F�b�N
	If strOrgCd1 = "" Or strOrgCd2 = "" Then
		objCommon.appendArray strMessage, "�c�̂��w�肵�ĉ������B"
	End If

	'�R�[�X�R�[�h�̃`�F�b�N
	If IsEmpty(strArrCsCd) Then
		objCommon.appendArray strMessage, "�R�[�X���w�肵�ĉ������B"
	End If

	'�_��p�^�[���R�[�h�̃`�F�b�N
	If strCtrPtCd = "" Then
		objCommon.appendArray strMessage, "�_��p�^�[�����w�肵�ĉ������B"
	End If

	'���蓖�ĊJ�n���̃`�F�b�N
	strSecStrCslDate = lngSecStrCslYear & "/" & lngSecStrCslMonth & "/" & lngSecStrCslDay
	If Not IsDate(strSecStrCslDate) Then
		objCommon.appendArray strMessage, "���蓖�ĊJ�n���̓��͌`��������������܂���B"
		blnError = True
	End If

	'���蓖�ďI�����̃`�F�b�N
	strSecEndCslDate = lngSecEndCslYear & "/" & lngSecEndCslMonth & "/" & lngSecEndCslDay
	If Not IsDate(strSecEndCslDate) Then
		objCommon.appendArray strMessage, "���蓖�ďI�����̓��͌`��������������܂���B"
		blnError = True
	End If

	'���蓖�Ċ��Ԃ͂P����f�����Ԃ�薢���łȂ���΂Ȃ�Ȃ�
	If Not blnError Then
		If CDate(strSecStrCslDate) <= CDate(strStrCslDate) Or CDate(strSecStrCslDate) <= CDate(strEndCslDate) Or _
		   CDate(strSecEndCslDate) <= CDate(strStrCslDate) Or CDate(strSecEndCslDate) <= CDate(strEndCslDate) Then
			objCommon.appendArray strMessage, "���蓖�Ċ��Ԃ͂P����f�����Ԃ�薢���̓��t���w�肵�Ă��������B"
		End If
	End If

	'�Q����f���͎w��_��p�^�[���̌_����ԓ��ɑ��݂��Ȃ���΂Ȃ�Ȃ�
	If (Not blnError) And strOrgCd1 <> "" And strOrgCd2 <> "" And strCtrPtCd <> "" Then
		If CDate(strSecStrCslDate) < dtmStrDate Or CDate(strSecStrCslDate) > dtmEndDate Or _
		   CDate(strSecEndCslDate) < dtmStrDate Or CDate(strSecEndCslDate) > dtmEndDate Then
			objCommon.appendArray strMessage, "���蓖�Ċ��Ԃ͌_����Ԃ͈͓̔��Ŏw�肵�Ă��������B"
		End If
	End If

	'�_��R�[�X�Ǝw��R�[�X�Ƃ̊֘A�`�F�b�N
	Do

		'�R�[�X�A�_��p�^�[�����w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
		If IsEmpty(strArrCsCd) Or strOrgCd1 = "" Or strOrgCd2 = "" Or strCtrPtCd = "" Then
			Exit Do
		End If

		'�S�Ă̎�R�[�X���擾
		lngCsCount = objCourse.SelectCourseList(strAllCsCd, strAllCsName, strAllSecondFlg, 1)

		'�_��R�[�X���Q�����f�̂��̂��𒲍�
		blnIsSecond = False
		For i = 0 To lngCsCount - 1
			If strCsCd = strAllCsCd(i) And strAllSecondFlg(i) = "1" Then
				blnIsSecond = True
				Exit For
			End If
		Next

		'�Q�����f�R�[�X�łȂ���Ζ��Ȃ�
		If Not blnIsSecond Then
			Exit Do
		End If

		'�Q�����f�R�[�X�ł���Ύw��R�[�X�͕K���P�����f�łȂ���΂Ȃ�Ȃ�
		'(�Q�����f�R�[�X�ɂ͕K���P����f�����֘A�t������K�v�����邽��)
		For i = 0 To UBound(strArrCsCd)
			For j = 0 To lngCsCount - 1
				If strArrCsCd(i) = strAllCsCd(j) And strAllSecondFlg(j) <> "0" Then
					objCommon.appendArray strMessage, "�Q�����f�̈ꊇ�\����s���ꍇ�A�I���\�ȃR�[�X�͂P�����f�݂̂ł��B"
					Exit Do
				End If
			Next
		Next

		Exit Do
	Loop

	'�߂�l�̕ҏW
	If IsArray(strMessage) Then
		CheckValue = strMessage
	End If

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>���f���ʂ���̂Q���ꊇ�\��</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// �G�������g�̎Q�Ɛݒ�
function setElement() {

	with ( document.entryForm ) {
		orgPostGuide_getElement( orgCd1, orgCd2, 'orgName', orgBsdCd, 'orgBsdName', orgRoomCd, 'orgRoomName', strOrgPostCd, 'strOrgPostName', endOrgPostCd, 'endOrgPostName' );
		orgPostGuide_getPatternElement( ctrPtCd, 'csName', 'strDate', 'endDate');
	}

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.rsvtab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONLOAD="javascript:setElement()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" ONSUBMIT="javascript:return confirm('���̓��e�ňꊇ�\�񏈗����s���܂��B��낵���ł����H')">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000">���f���ʂ���̂Q���ꊇ�\��</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'���b�Z�[�W�̕ҏW
	Do

		'�������w�莞�͒ʏ�̃��b�Z�[�W�ҏW
		If strCount = "" then
			EditMessage strMessage, MESSAGETYPE_WARNING
			Exit Do
		End If

'		'�O���̏ꍇ
'		If strCount = "0" Then
'			EditMessage "��f���͍쐬����܂���ł����B�ڍׂ̓V�X�e�����O���Q�Ƃ��ĉ������B", MESSAGETYPE_NORMAL
'			Exit Do
'		End If
'
'		'�P���ȏ㏈�����ꂽ�ꍇ
'		EditMessage strCount & "���̎�f��񂪍쐬����܂����B�ڍׂ̓V�X�e�����O���Q�Ƃ��ĉ������B", MESSAGETYPE_NORMAL

		EditMessage "���f���ʂ���̂Q���ꊇ�\�񏈗����J�n����܂����B�ڍׂ̓V�X�e�����O���Q�Ƃ��ĉ������B", MESSAGETYPE_NORMAL
		Exit Do
	Loop
%>
	<BR>

	<INPUT TYPE="hidden" NAME="orgCd1"       VALUE="<%= strOrgCd1       %>">
	<INPUT TYPE="hidden" NAME="orgCd2"       VALUE="<%= strOrgCd2       %>">
	<INPUT TYPE="hidden" NAME="orgBsdCd"     VALUE="<%= strOrgBsdCd     %>">
	<INPUT TYPE="hidden" NAME="orgRoomCd"    VALUE="<%= strOrgRoomCd    %>">
	<INPUT TYPE="hidden" NAME="strOrgPostCd" VALUE="<%= strStrOrgPostCd %>">
	<INPUT TYPE="hidden" NAME="endOrgPostCd" VALUE="<%= strEndOrgPostCd %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD><FONT COLOR="#ff0000">��</FONT></TD>
			<TD WIDTH="90" NOWRAP>�P����f��</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
			<TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, lngStrCslYear, False) %></TD>
			<TD>�N</TD>
			<TD><%= EditNumberList("strCslMonth", 1, 12, lngStrCslMonth, False) %></TD>
			<TD>��</TD>
			<TD><%= EditNumberList("strCslDay", 1, 31, lngStrCslDay, False) %></TD>
			<TD>��</TD>
			<TD>�`</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('endCslYear', 'endCslMonth', 'endCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
			<TD><%= EditNumberList("endCslYear", YEARRANGE_MIN, YEARRANGE_MAX, lngEndCslYear, False) %></TD>
			<TD>�N</TD>
			<TD><%= EditNumberList("endCslMonth", 1, 12, lngEndCslMonth, False) %></TD>
			<TD>��</TD>
			<TD><%= EditNumberList("endCslDay", 1, 31, lngEndCslDay, False) %></TD>
			<TD>��</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR VALIGN="top">
			<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="3" ALT=""><BR><FONT COLOR="#ff0000">��</FONT></TD>
			<TD WIDTH="90" NOWRAP><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="3" ALT=""><BR>�R�[�X</TD>
			<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="3" ALT=""><BR>�F</TD>
			<TD><% Tokyu_EditCourseTable 1, "csCd", strArrCsCd, 2 %></TD>
		</TR>
	</TABLE>
<%
	'�e�햼�̂̎擾
	Do

		'�c�̃R�[�h���w�莞�͉������Ȃ�
		If strOrgCd1 = "" Or strOrgCd2 = "" Then
			Exit Do
		End If

		'�c�̖��̂̓ǂݍ���
		If objOrganization.SelectOrg_Lukes(strOrgCd1, strOrgCd2, , , strOrgName) = False Then
			Err.Raise 1000, , "�c�̏�񂪑��݂��܂���B"
		End If

		'���ƕ��R�[�h���w�莞�͉������Ȃ�
		If strOrgBsdCd = "" Then
			Exit Do
		End If

		'���ƕ����̂̓ǂݍ���
		If objOrgBsd.SelectOrgBsd(strOrgCd1, strOrgCd2, strOrgBsdCd, , strOrgBsdName) = False Then
			Err.Raise 1000, , "���ƕ���񂪑��݂��܂���B"
		End If

		'�����R�[�h���w�莞�͉������Ȃ�
		If strOrgRoomCd = "" Then
			Exit Do
		End If

		'�������̂̓ǂݍ���
		If objOrgRoom.SelectOrgRoom(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgRoomName) = False Then
			Err.Raise 1000, , "������񂪑��݂��܂���B"
		End If

		'�J�n�������̂̓ǂݍ���
		If strStrOrgPostCd <> "" Then
			If objOrgPost.SelectOrgPost(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strStrOrgPostCd, strStrOrgPostName) = False Then
				Err.Raise 1000, , "������񂪑��݂��܂���B"
			End If
		End If

		'�I���������̂̓ǂݍ���
		If strEndOrgPostCd <> "" Then
			If objOrgPost.SelectOrgPost(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strEndOrgPostCd, strEndOrgPostName) = False Then
				Err.Raise 1000, , "������񂪑��݂��܂���B"
			End If
		End If

		Exit Do
	Loop
%>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD><FONT COLOR="#ff0000">��</FONT></TD>
			<TD WIDTH="90" NOWRAP>�c��</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrg()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
<!--
			<TD><A HREF="javascript:orgPostGuide_clearOrgInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
-->
			<TD></TD>
			<TD NOWRAP><SPAN ID="orgName"><%= strOrgName %></SPAN></TD>
		</TR>
		<TR>
			<TD>��</TD>
			<TD NOWRAP>���ƕ�</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgBsd()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���ƕ������K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgBsdInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
			<TD NOWRAP><SPAN ID="orgBsdName"><%= strOrgBsdName %></SPAN></TD>
		</TR>
		<TR>
			<TD>��</TD>
			<TD NOWRAP>����</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgRoom()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���������K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgRoomInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
			<TD NOWRAP><SPAN ID="orgRoomName"><%= strOrgRoomName %></SPAN></TD>
		</TR>
	</TABLE>
	
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD>��</TD>
			<TD WIDTH=90" NOWRAP>����</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgPost(1)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���������K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgPostInfo(1)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
			<TD NOWRAP><SPAN ID="strOrgPostName"><%= strStrOrgPostName %></SPAN></TD>
			<TD>�`</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgPost(2)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���������K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgPostInfo(2)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
			<TD NOWRAP><SPAN ID="endOrgPostName"><%= strEndOrgPostName %></SPAN></TD>
		</TR>
	</TABLE>

	<INPUT TYPE="hidden" NAME="ctrPtCd" VALUE="<%= strCtrPtCd %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD><FONT COLOR="#ff0000">��</FONT></TD>
			<TD WIDTH="90" NOWRAP>�_��p�^�[��</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuidePattern()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�_��p�^�[�������K�C�h��\��"></A></TD>
			<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="21" ALT=""></TD>
			<TD NOWRAP>
				<SPAN ID="csName"><%= strCsName %></SPAN>&nbsp;
				<SPAN ID="strDate"><%= IIf(Not IsEmpty(dtmStrDate), objCommon.FormatString(dtmStrDate, "yyyy�Nm��d��"), "") %></SPAN><SPAN ID="endDate"><%= IIf(Not IsEmpty(dtmEndDate), objCommon.FormatString(dtmEndDate, "�`yyyy�Nm��d��"), "") %></SPAN>
			</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD><FONT COLOR="#ff0000">��</FONT></TD>
			<TD WIDTH="90" NOWRAP>���蓖�Ċ���</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('secStrCslYear', 'secStrCslMonth', 'secStrCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
			<TD><%= EditNumberList("secStrCslYear", YEARRANGE_MIN, YEARRANGE_MAX, lngSecStrCslYear, False) %></TD>
			<TD>�N</TD>
			<TD><%= EditNumberList("secStrCslMonth", 1, 12, lngSecStrCslMonth, False) %></TD>
			<TD>��</TD>
			<TD><%= EditNumberList("secStrCslDay", 1, 31, lngSecStrCslDay, False) %></TD>
			<TD>��</TD>
			<TD>�`</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('secEndCslYear', 'secEndCslMonth', 'secEndCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
			<TD><%= EditNumberList("secEndCslYear", YEARRANGE_MIN, YEARRANGE_MAX, lngSecEndCslYear, False) %></TD>
			<TD>�N</TD>
			<TD><%= EditNumberList("secEndCslMonth", 1, 12, lngSecEndCslMonth, False) %></TD>
			<TD>��</TD>
			<TD><%= EditNumberList("secEndCslDay", 1, 31, lngSecEndCslDay, False) %></TD>
			<TD>��</TD>
		</TR>
	</TABLE>

	<BR><BR>

	<A HREF="rsvAllMenu.asp"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�߂�"></A>
	<INPUT TYPE="image" NAME="reserve" SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="���̏����ŗ\�񂷂�">

	<BR><BR>

	<A HREF="/webHains/contents/maintenance/hainslog/dispHainsLog.asp?mode=print&transactionDiv=LOGRSVCON"><IMG SRC="/webHains/images/prevlog.gif" WIDTH="77" HEIGHT="24" ALT="���O���Q�Ƃ���"></A>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>