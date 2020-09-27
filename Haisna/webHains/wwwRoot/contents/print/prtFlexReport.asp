<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'		���N�f�f���ʕ\ (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/print.inc"                -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const COUNT_PERID = 2	'�w��\�Ȍl�h�c�̐�

Dim strMode				'������[�h
Dim vntMessage			'�ʒm���b�Z�[�W

'-------------------------------------------------------------------------------
' �ŗL�錾���i�e���[�ɉ����Ă��̃Z�N�V�����ɕϐ����`���ĉ������j
'-------------------------------------------------------------------------------
'COM�I�u�W�F�N�g
Dim objOrganization	'�c�̏��A�N�Z�X�p
Dim objOrgBsd		'���ƕ����A�N�Z�X�p
Dim objOrgRoom		'�������A�N�Z�X�p
Dim objOrgPost		'�������A�N�Z�X�p
Dim objPerson		'�l���A�N�Z�X�p
Dim objReport		'���[���A�N�Z�X�p

'�����l
Dim lngStrCslYear		'�J�n��f�N
Dim lngStrCslMonth		'�J�n��f��
Dim lngStrCslDay		'�J�n��f��
Dim lngEndCslYear		'�I����f�N
Dim lngEndCslMonth		'�I����f��
Dim lngEndCslDay		'�I����f��
Dim strCsCd				'�R�[�X�R�[�h
Dim strSubCsCd			'�T�u�R�[�X�R�[�h
Dim strOrgCd1			'�c�̃R�[�h�P
Dim strOrgCd2			'�c�̃R�[�h�Q
Dim strOrgBsdCd			'���ƕ��R�[�h
Dim strOrgRoomCd		'�����R�[�h
Dim strStrOrgPostCd		'�J�n�����R�[�h
Dim strEndOrgPostCd		'�I�������R�[�h
Dim strPerId			'�l�h�c
Dim strSortOrder		'�o�͏�
Dim strInputKbn			'�����̓`�F�b�N
Dim strReportOutput		'�o�͕��@
Dim strHistoryPrint		'�ߋ������
Dim strReportCd			'���[�R�[�h

'�������
Dim strOrgName			'�c�̖���
Dim strOrgBsdName		'���ƕ�����
Dim strOrgRoomName		'��������
Dim strStrOrgPostName	'�J�n��������
Dim strEndOrgPostName	'�I����������

'�l���
Dim strEmpNo		'�]�ƈ��ԍ�
Dim strLastName		'��
Dim strFirstName	'��

'���[���
Dim strArrReportCd		'���[�R�[�h
Dim strArrReportName	'���[��
Dim strArrHistoryPrint	'�ߋ������
Dim lngReportCount		'���R�[�h��

Dim i					'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'���ʈ����l�̎擾
strMode = Request("mode")

'���[�o�͏�������
vntMessage = PrintControl(strMode)

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : URL�����l�̎擾
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ : URL�̈����l���擾���鏈�����L�q���ĉ�����
'
'-------------------------------------------------------------------------------
Sub GetQueryString()

	'�����l�̎擾
	lngStrCslYear   = CLng("0" & Request("strCslYear"))
	lngStrCslMonth  = CLng("0" & Request("strCslMonth"))
	lngStrCslDay    = CLng("0" & Request("strCslDay"))
	lngEndCslYear   = CLng("0" & Request("endCslYear"))
	lngEndCslMonth  = CLng("0" & Request("endCslMonth"))
	lngEndCslDay    = CLng("0" & Request("endCslDay"))
	strCsCd         = Request("csCd")
	strSubCsCd      = Request("subCsCd")
	strOrgCd1       = Request("orgCd1")
	strOrgCd2       = Request("orgCd2")
	strOrgBsdCd     = Request("orgBsdCd")
	strOrgRoomCd    = Request("orgRoomCd")
	strStrOrgPostCd = Request("strOrgPostCd")
	strEndOrgPostCd = Request("endOrgPostCd")
	strPerId        = ConvIStringToArray(Request("perId"))
	strSortOrder    = Request("sortOrder")
	strInputKbn     = Request("inputKbn")
	strReportOutput = Request("reportOutput")
	strHistoryPrint = Request("historyPrint")
	strReportCd     = Request("reportcd")

	'��f�J�n�E�I�����̃f�t�H���g�l�ݒ�
	'(��f�J�n�N���O�ɂȂ�P�[�X�͏����\�����ȊO�ɂȂ�)
	If lngStrCslYear = 0 Then
		lngStrCslYear  = Year(Date)
		lngStrCslMonth = Month(Date)
		lngStrCslDay   = Day(Date)
		lngEndCslYear  = lngStrCslYear
		lngEndCslMonth = lngStrCslMonth
		lngEndCslDay   = lngStrCslDay
	End If

	'�l�h�c���w�莞�͋�g��p�ӂ���
	If IsEmpty(strPerId) Then
		strPerId = Array()
		ReDim Preserve strPerId(COUNT_PERID - 1)
	End If

End Sub

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

	Dim objCommon		'���ʃN���X

	Dim strStrCslDate	'�J�n��f��
	Dim strEndCslDate	'�I����f��
	Dim strMessage		'�G���[���b�Z�[�W�̏W��

	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'�J�n��f���̃`�F�b�N
	strStrCslDate = lngStrCslYear & "/" & lngStrCslMonth & "/" & lngStrCslDay
	If Not IsDate(strStrCslDate) Then
		objCommon.appendArray strMessage, "�J�n��f���̓��͌`��������������܂���B"
	End If

	'�I����f���̃`�F�b�N
	strEndCslDate = lngEndCslYear & "/" & lngEndCslMonth & "/" & lngEndCslDay
	If Not IsDate(strEndCslDate) Then
		objCommon.appendArray strMessage, "�I����f���̓��͌`��������������܂���B"
	End If

	'�o�͗l���̃`�F�b�N
	If strReportCd = "" Then
		objCommon.appendArray strMessage, "�o�͗l����I�����ĉ������B"
	End If

	'�߂�l�̕ҏW
	If IsArray(strMessage) Then
		CheckValue = strMessage
	End If

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���[�h�L�������g�t�@�C���쐬����
'
' �����@�@ :
'
' �߂�l�@ : ������O���̃V�[�P���X�l
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function Print()

	Dim objFlexReport	'���я��o�͗p

	Dim dtmStrCslDate	'�J�n��f��
	Dim dtmEndCslDate	'�I����f��
	Dim Ret				'�֐��߂�l

	dtmStrCslDate = CDate(lngStrCslYear & "/" & lngStrCslMonth & "/" & lngStrCslDay)
	dtmEndCslDate = CDate(lngEndCslYear & "/" & lngEndCslMonth & "/" & lngEndCslDay)

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objFlexReport = Server.CreateObject("HainsFlexReport.FlexReportControl")

	'���я��h�L�������g�t�@�C���쐬����
'	Ret = objFlexReport.PrintFlexReport(Session("USERID"), strReportCd, dtmStrCslDate, dtmEndCslDate, strCsCd, strSubCsCd, strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strStrOrgPostCd, strEndOrgPostCd, strPerId, strInputKbn, strReportOutput, strHistoryPrint, , strSortOrder)
	Ret = objFlexReport.PrintFlexReport(Session("USERID"), strReportCd, dtmStrCslDate, dtmEndCslDate, strCsCd, strSubCsCd, strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strStrOrgPostCd, strEndOrgPostCd, strPerId, strInputKbn, "0", strHistoryPrint, , strSortOrder)

	Print = Ret

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>���N�f�f���ʕ\</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// �G�������g�̎Q�Ɛݒ�
function setElement() {

	with ( document.entryForm ) {

		orgPostGuide_getElement( orgCd1, orgCd2, 'orgName', orgBsdCd, 'orgBsdName', orgRoomCd, 'orgRoomName', strOrgPostCd, 'strOrgPostName', endOrgPostCd, 'endOrgPostName' );

		// �l���G�������g�̎Q�Ɛݒ�
		for ( var i = 0; i < perId.length; i++ ) {
			orgPostGuide_getPerElement( perId[ i ], 'perName' + i, i );
		}

	}

}

// �l�����K�C�h��ʕ\��
function showGuidePersonal( index ) {

	if ( index == 1 && document.entryForm.perId[ 0 ].value == '' ) {
		orgPostGuide_showGuidePersonal( 0 );
	} else {
		orgPostGuide_showGuidePersonal( index );
	}
}

// �l�̃N���A
function clearPerInfo( index ) {

	if ( index == 0 ) {
		orgPostGuide_clearPerInfo();
	} else {
		orgPostGuide_clearPerInfo( index );
	}

}

// submit���̏���
function submitForm() {

	document.entryForm.submit();

}

function selectHistoryPrint( index ) {

	document.entryForm.historyPrint.value = document.historyPrintForm.historyPrint[ index ].value;

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.prttab { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONLOAD="javascript:setElement()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">��</SPAN><FONT COLOR="#000000">���N�f�f���ʕ\</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'���b�Z�[�W�̕ҏW
	Call EditMessage(vntMessage, MESSAGETYPE_NORMAL)
%>
	<BR>
<%
	'���[�h�̓v���r���[�Œ�
%>
	<INPUT TYPE="hidden" NAME="mode" VALUE="0">

	<INPUT TYPE="hidden" NAME="orgCd1"       VALUE="<%= strOrgCd1       %>">
	<INPUT TYPE="hidden" NAME="orgCd2"       VALUE="<%= strOrgCd2       %>">
	<INPUT TYPE="hidden" NAME="orgBsdCd"     VALUE="<%= strOrgBsdCd     %>">
	<INPUT TYPE="hidden" NAME="orgRoomCd"    VALUE="<%= strOrgRoomCd    %>">
	<INPUT TYPE="hidden" NAME="strOrgPostCd" VALUE="<%= strStrOrgPostCd %>">
	<INPUT TYPE="hidden" NAME="endOrgPostCd" VALUE="<%= strEndOrgPostCd %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD><FONT COLOR="#ff0000">��</FONT></TD>
			<TD WIDTH="90" NOWRAP>��f��</TD>
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
		<TR>
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>�R�[�X</TD>
			<TD>�F</TD>
			<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd", strCsCd, NON_SELECTED_ADD, False) %></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>�T�u�R�[�X</TD>
			<TD>�F</TD>
			<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_SUB, "subCsCd", strSubCsCd, NON_SELECTED_ADD, False) %></TD>
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
		Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
		If objOrganization.SelectOrg(strOrgCd1, strOrgCd2, , strOrgName) = False Then
			Err.Raise 1000, , "�c�̏�񂪑��݂��܂���B"
		End If

		'���ƕ��R�[�h���w�莞�͉������Ȃ�
		If strOrgBsdCd = "" Then
			Exit Do
		End If

		'���ƕ����̂̓ǂݍ���
		Set objOrgBsd = Server.CreateObject("HainsOrgBsd.OrgBsd")
		If objOrgBsd.SelectOrgBsd(strOrgCd1, strOrgCd2, strOrgBsdCd, , strOrgBsdName) = False Then
			Err.Raise 1000, , "���ƕ���񂪑��݂��܂���B"
		End If

		'�����R�[�h���w�莞�͉������Ȃ�
		If strOrgRoomCd = "" Then
			Exit Do
		End If

		'�������̂̓ǂݍ���
		Set objOrgRoom = Server.CreateObject("HainsOrgRoom.OrgRoom")
		If objOrgRoom.SelectOrgRoom(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgRoomName) = False Then
			Err.Raise 1000, , "������񂪑��݂��܂���B"
		End If

		Set objOrgPost = Server.CreateObject("HainsOrgPost.OrgPost")

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
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>�c��</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrg()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
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

	<INPUT TYPE="hidden" NAME="perId" VALUE="<%= strPerId(0) %>">
	<INPUT TYPE="hidden" NAME="perId" VALUE="<%= strPerId(1) %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>�]�ƈ��w��</TD>
			<TD>�F</TD>
<%
			Set objPerson = Server.CreateObject("HainsPerson.Person")

			'�l���ǂݍ���
			strLastName  = Empty
			strFirstName = Empty
			strEmpNo     = Empty
			If strPerId(0) <> "" Then
				objPerson.SelectPerson strPerId(0), strLastName, strFirstName, , , , , , , , , , , , , , , , , , , , , , , , ,strEmpNo
			End If
%>
			<TD><A HREF="javascript:showGuidePersonal(0)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�l�����K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:clearPerInfo(0)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
			<TD NOWRAP><SPAN ID="perName0"><%= IIf(strEmpNo <> "", strEmpNo & "�F", "") & Trim(strLastName & "�@" & strFirstName) %></SPAN></TD>
			<TD>�`</TD>
<%
			'�l���ǂݍ���
			strLastName  = Empty
			strFirstName = Empty
			strEmpNo     = Empty
			If strPerId(1) <> "" Then
				objPerson.SelectPerson strPerId(1), strLastName, strFirstName, , , , , , , , , , , , , , , , , , , , , , , , ,strEmpNo
			End If
%>
			<TD><A HREF="javascript:showGuidePersonal(1)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�l�����K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:clearPerInfo(1)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
			<TD NOWRAP><SPAN ID="perName1"><%= IIf(strEmpNo <> "", strEmpNo & "�F", "") & Trim(strLastName & "�@" & strFirstName) %></SPAN></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD><FONT COLOR="#ff0000">��</FONT></TD>
			<TD WIDTH="90" NOWRAP>�o�͏�</TD>
			<TD>�F</TD>
			<TD><INPUT TYPE="radio" NAME="sortOrder" VALUE="1" <%= IIf(strSortOrder <> "0" And strSortOrder <> "2", "CHECKED", "") %>></TD>
			<TD NOWRAP>�����R�[�h��</TD>
			<TD><INPUT TYPE="radio" NAME="sortOrder" VALUE="2" <%= IIf(strSortOrder  = "2", "CHECKED", "") %>></TD>
			<TD NOWRAP>��f����</TD>
			<TD><INPUT TYPE="radio" NAME="sortOrder" VALUE="0" <%= IIf(strSortOrder  = "0", "CHECKED", "") %>></TD>
			<TD NOWRAP>�]�ƈ��ԍ���</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD><FONT COLOR="#ff0000">��</FONT></TD>
			<TD WIDTH="90" NOWRAP>���̓`�F�b�N</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><INPUT TYPE="radio" NAME="inputKbn" VALUE="0" <%= IIf(strInputKbn <> "1", "CHECKED", "") %>></TD>
						<TD>���̓`�F�b�N�͍s��Ȃ�</TD>
						<TD><INPUT TYPE="radio" NAME="inputKbn" VALUE="1" <%= IIf(strInputKbn  = "1", "CHECKED", "") %>></TD>
						<TD>���ׂĂ̌��ʂ����͂���Ă����f���̂ݏo��</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
<!--
		<TR>
			<TD><FONT COLOR="#ff0000">��</FONT></TD>
			<TD WIDTH="90" NOWRAP>�o�͑Ώ�</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><INPUT TYPE="radio" NAME="reportOutput" VALUE="0" <%= IIf(strReportOutput <> "1" And strReportOutput <> "2", "CHECKED", "") %>></TD>
						<TD>�w��Ȃ�</TD>
						<TD><INPUT TYPE="radio" NAME="reportOutput" VALUE="1" <%= IIf(strReportOutput  = "1", "CHECKED", "") %>></TD>
						<TD>�񍐍ς݃f�[�^�̂�</TD>
						<TD><INPUT TYPE="radio" NAME="reportOutput" VALUE="2" <%= IIf(strReportOutput  = "2", "CHECKED", "") %>></TD>
						<TD>���񍐃f�[�^�̂�</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
-->
		<TR>
			<TD><FONT COLOR="#ff0000">��</FONT></TD>
			<TD WIDTH="90" NOWRAP>�ߋ����̌���</TD>
			<TD>�F</TD>
			<TD>
				<SELECT NAME="historyPrint">
					<OPTION VALUE="0" <%= IIf(strHistoryPrint = "" Or strHistoryPrint = "0", "SELECTED", "") %>>�����Ȃ�
					<OPTION VALUE="1" <%= IIf(strHistoryPrint = "1", "SELECTED", "") %>>�Q�������E�Č����������S�ẴR�[�X
					<OPTION VALUE="2" <%= IIf(strHistoryPrint = "2", "SELECTED", "") %>>����R�[�X�̂�
					<OPTION VALUE="3" <%= IIf(strHistoryPrint = "3", "SELECTED", "") %>>������f�̂�
				</SELECT>
			</TD>
		</TR>
		<TR>
			<TD><FONT COLOR="#ff0000">��</FONT></TD>
			<TD WIDTH="90" NOWRAP>�o�͗l��</TD>
			<TD>�F</TD>
			<TD>
				<SELECT NAME="reportCd" ONCHANGE="javascript:selectHistoryPrint(this.selectedIndex)">
					<OPTION VALUE="">&nbsp;
<%
					'���[�e�[�u���ǂݍ���
					Set objReport = Server.CreateObject("HainsReport.Report")
					lngReportCount = objReport.SelectReportList(strArrReportCd, strArrReportName, "1", , , , strArrHistoryPrint)
					For i = 0 To lngReportCount - 1
%>
						<OPTION VALUE="<%= strArrReportCd(i) %>" <%= IIf(strArrReportCd(i) = strReportCd, "SELECTED", "") %>><%= strArrReportName(i) %>
<%
					Next
%>
				</SELECT>
			</TD>
		</TR>
	</TABLE>

	<BR>

	<!---2006.07.04 �����Ǘ� �ǉ� by ��  -->
    <% If Session("PAGEGRANT") = "4" Then   %>
		<A HREF="javascript:submitForm()"><IMG SRC="/webHains/images/print.gif" WIDTH="76" HEIGHT="23" ALT="�������"></A>
	<%  End if  %>

	</BLOCKQUOTE>
</FORM>
<FORM NAME="historyPrintForm" action="#">
<%
	'�ߋ����������@��hidden�f�[�^�ŕێ�
%>
	<INPUT TYPE="hidden" NAME="historyPrint" VALUE="">
<%
	For i = 0 To lngReportCount - 1
%>
		<INPUT TYPE="hidden" NAME="historyPrint" VALUE="<%= strArrHistoryPrint(i) %>">
<%
	Next
%>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
</BODY>
</HTML>