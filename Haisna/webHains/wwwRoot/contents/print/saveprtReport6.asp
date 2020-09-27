<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'		���я� (Ver0.0.1)
'		AUTHER  : (NSC)birukawa
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/print.inc"                -->
<!-- #include virtual = "/webHains/includes/editOrgGrp_PList.inc"     -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim strMode				'������[�h
Dim vntMessage			'�ʒm���b�Z�[�W

'-------------------------------------------------------------------------------
' �ŗL�錾���i�e���[�ɉ����Ă��̃Z�N�V�����ɕϐ����`���ĉ������j
'-------------------------------------------------------------------------------
'COM�I�u�W�F�N�g
Dim objCommon								'���ʃN���X
Dim objOrganization							'�c�̏��A�N�Z�X�p
Dim objOrgBsd								'���ƕ����A�N�Z�X�p
Dim objOrgRoom								'�������A�N�Z�X�p
Dim objOrgPost								'�������A�N�Z�X�p
Dim objPerson								'�l���A�N�Z�X�p
Dim objReport								'���[���A�N�Z�X�p

'�p�����[�^�l
Dim strSCslYear, strSCslMonth, strSCslDay	'�J�n�N����
Dim strECslYear, strECslMonth, strECslDay	'�I���N����
Dim strDayId								'����ID
Dim strOrgGrpCd								'�c�̃O���[�v�R�[�h
Dim strOrgCd11								'�c�̃R�[�h�P�P
Dim strOrgCd12								'�c�̃R�[�h�P�Q
Dim strOrgCd21								'�c�̃R�[�h�Q�P
Dim strOrgCd22								'�c�̃R�[�h�Q�Q
Dim strOrgCd31								'�c�̃R�[�h�R�P
Dim strOrgCd32								'�c�̃R�[�h�R�Q
Dim strOrgCd41								'�c�̃R�[�h�S�P
Dim strOrgCd42								'�c�̃R�[�h�S�Q
Dim strOrgCd51								'�c�̃R�[�h�T�P
Dim strOrgCd52								'�c�̃R�[�h�T�Q
Dim strOrgCd61								'�c�̃R�[�h�U�P
Dim strOrgCd62								'�c�̃R�[�h�U�Q
Dim strOrgCd71								'�c�̃R�[�h�V�P
Dim strOrgCd72								'�c�̃R�[�h�V�Q
Dim strReportOutDate						'�o�͓�
Dim strReportOutput							'�o�͗l��
Dim strHistoryPrint							'�ߋ������
Dim strReportCd								'���[�R�[�h
Dim UID										'���[�UID

'��Ɨp�ϐ�
Dim strSCslDate								'�J�n��
Dim strECslDate								'�I����
Dim strOrgGrpName							'�c�̃O���[�v����
Dim strOrgName1								'�c�̂P����
Dim strOrgName2								'�c�̂Q����
Dim strOrgName3								'�c�̂R����
Dim strOrgName4								'�c�̂S����
Dim strOrgName5								'�c�̂T����
Dim strOrgName6								'�c�̂U����
Dim strOrgName7								'�c�̂V����

'���[���
Dim strArrReportCd							'���[�R�[�h
Dim strArrReportName						'���[��
Dim strArrHistoryPrint						'�ߋ������
Dim lngReportCount							'���R�[�h��

Dim i					'���[�v�C���f�b�N�X
Dim j					'���[�v�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objOrgBsd       = Server.CreateObject("HainsOrgBsd.OrgBsd")
Set objOrgRoom      = Server.CreateObject("HainsOrgRoom.OrgRoom")
Set objOrgPost      = Server.CreateObject("HainsOrgPost.OrgPost")
Set objPerson       = Server.CreateObject("HainsPerson.Person")

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

'�� �J�n�N����
	If IsEmpty(Request("strCslYear")) Then
		strSCslYear   = Year(Now())				'�J�n�N
		strSCslMonth  = Month(Now())			'�J�n��
		strSCslDay    = Day(Now())				'�J�n��
	Else
		strSCslYear   = Request("strCslYear")	'�J�n�N
		strSCslMonth  = Request("strCslMonth")	'�J�n��
		strSCslDay    = Request("strCslDay")	'�J�n��
	End If
	strSCslDate   = strSCslYear & "/" & strSCslMonth & "/" & strSCslDay
'�� �I���N����
	If IsEmpty(Request("endCslYear")) Then
		strECslYear   = Year(Now())				'�I���N
		strECslMonth  = Month(Now())			'�J�n��
		strECslDay    = Day(Now())				'�J�n��
	Else
		strECslYear   = Request("endCslYear")	'�I���N
		strECslMonth  = Request("endCslMonth")	'�J�n��
		strECslDay    = Request("endCslDay")	'�J�n��
	End If
	strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
'�� �J�n�N�����ƏI���N�����̑召����Ɠ���
'   �i���t�^�ɕϊ����ă`�F�b�N���Ȃ��͓̂��t�Ƃ��Č�����l�ł������Ƃ��̃G���[����ׁ̈j
	If Right("0000" & Trim(CStr(strSCslYear)), 4) & _
	   Right("00" & Trim(CStr(strSCslMonth)), 2) & _
	   Right("00" & Trim(CStr(strSCslDay)), 2) _
	 > Right("0000" & Trim(CStr(strECslYear)), 4) & _
	   Right("00" & Trim(CStr(strECslMonth)), 2) & _
	   Right("00" & Trim(CStr(strECslDay)), 2) Then
		strSCslYear   = strECslYear
		strSCslMonth  = strECslMonth
		strSCslDay    = strECslDay
		strSCslDate   = strECslDate
		strECslYear   = Request("strCslYear")	'�J�n�N
		strECslMonth  = Request("strCslMonth")	'�J�n��
		strECslDay    = Request("strCslDay")	'�J�n��
		strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
	End If

'�� ����ID
	strDayId = Request("DayId")

'�� �c�̃O���[�v�R�[�h
	strOrgGrpCd = Request("OrgGrpCd")
	strOrgGrpName = Request("OrgGrpName")

'�� �c�̃R�[�h
	'�c�̂P
	strOrgCd11	= Request("OrgCd11")
	strOrgCd12	= Request("OrgCd12")
	strOrgName1 = Request("OrgName1")

	'�c�̂Q
	strOrgCd21	= Request("OrgCd21")
	strOrgCd22	= Request("OrgCd22")
	strOrgName2 = Request("OrgName2")
	'�c�̂R
	strOrgCd31	= Request("OrgCd31")
	strOrgCd32	= Request("OrgCd32")
	strOrgName3 = Request("OrgName3")
	'�c�̂S
	strOrgCd41	= Request("OrgCd41")
	strOrgCd42	= Request("OrgCd42")
	strOrgName4 = Request("OrgName4")
	'�c�̂T
	strOrgCd51	= Request("OrgCd51")
	strOrgCd52	= Request("OrgCd52")
	strOrgName5 = Request("OrgName5")
	'�c�̂U
	strOrgCd61	= Request("OrgCd61")
	strOrgCd62	= Request("OrgCd62")
	strOrgName6 = Request("OrgName6")
	'�c�̂V
	strOrgCd71	= Request("OrgCd71")
	strOrgCd72	= Request("OrgCd72")
	strOrgName7 = Request("OrgName7")

'�� �o�͓�
	strReportOutDate = Request("ReportOutDate")

'�� �o�͗l��
	strReportOutput = Request("ReportOutput")
	strHistoryPrint = Request("HistoryPrint")
	strReportCd     = Request("Reportcd")

'�� ���[�UID
	UID = Session("USERID")

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

	Dim vntArrMessage	'�G���[���b�Z�[�W�̏W��
	Dim blnErrFlg
	Dim aryChkString
	Dim aryChkString2
	
	aryChkString = Array("1","2","3","4","5","6","7","8","9","0",",","-")
	aryChkString2 = Array("1","2","3","4","5","6","7","8","9","0")

	'�����Ƀ`�F�b�N�������L�q
	With objCommon
'��)		.AppendArray vntArrMessage, �R�����g
		If strMode <> "" Then
			'��f���`�F�b�N
			If Not IsDate(strSCslDate) Then
				.AppendArray vntArrMessage, "�J�n���t������������܂���B"
			End If
			If Not IsDate(strECslDate) Then
				.AppendArray vntArrMessage, "�I�����t������������܂���B"
			End If

			'����ID�`�F�b�N
			If Trim(strDayId) <> "" Then
				blnErrFlg = 0
				For j = 0 to UBound(aryChkString2)
					If Trim(Mid(strDayId, len(strDayId), 1)) = Trim(aryChkString2(j)) Then
						blnErrFlg = 1
						Exit For
					End if
				Next
				If blnErrFlg = 0 Then
					.AppendArray vntArrMessage, "����ID�̍Ō�̕���������������܂���B"
				End If
			End If
			If Trim(strDayId) <> "" Then
				For i = 1 To Len(strDayId)
					blnErrFlg = 0
					For j = 0 to UBound(aryChkString)
						If Trim(Mid(strDayId, i, 1)) = Trim(aryChkString(j)) Then
							blnErrFlg = 1
							Exit For
						End if
					Next
					If blnErrFlg = 0 Then
						.AppendArray vntArrMessage, "����ID������������܂���B"
						Exit For
					End If
				Next
			End If
			
			'�o�͗l���̃`�F�b�N
			If strReportCd = "" Then
				objCommon.appendArray vntArrMessage, "�o�͗l����I�����ĉ������B"
			End If

			'�o�͗l���̃`�F�b�N
			If Trim(strReportCd) >= "000305"  and trim(strReportCd) <= "000308" Then
				if Trim(strSCslDate) < "2004/4/1" Then
					objCommon.appendArray vntArrMessage, "�J�n���� 2004�N3��31�� �ȑO�ł��B"
				End If
			End If

		End If

	End With

	'�߂�l�̕ҏW
	If IsArray(vntArrMessage) Then
		CheckValue = vntArrMessage
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

	Dim Ret				'�֐��߂�l
	Dim dtmStrCslDate	'�J�n��f��
	Dim dtmEndCslDate	'�I����f��
	Dim objFlexReport	'���я��o�͗p

	If Not IsArray(CheckValue()) Then
		dtmStrCslDate = CDate(strSCslDate)
		dtmEndCslDate = CDate(strECslDate)

		Set objFlexReport	= Server.CreateObject("HainsFlexReport.FlexReportControl")
		
		'���я��h�L�������g�t�@�C���쐬����
		Ret = objFlexReport.PrintFlexReport(UID, strReportCd, dtmStrCslDate, dtmEndCslDate, strDayId, strOrgGrpCd, strOrgCd11, strOrgCd12, strOrgCd21, strOrgCd22, strOrgCd31, strOrgCd32, strOrgCd41, strOrgCd42, strOrgCd51, strOrgCd52, strOrgCd61, strOrgCd62, strOrgCd71, strOrgCd72)

		Print = Ret
	End If

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Microsoft FrontPage 4.0">
<TITLE>���я�</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// �c�̉�ʕ\��
function showGuideOrgGrp( Cd1, Cd2, CtrlName ) {

	// �c�̏��G�������g�̎Q�Ɛݒ�
	orgPostGuide_getElement( Cd1, Cd2, CtrlName );
	// ��ʕ\��
	orgPostGuide_showGuideOrg();

}

// �c�̏��폜
function clearGuideOrgGrp( Cd1, Cd2, CtrlName ) {

	// �c�̏��G�������g�̎Q�Ɛݒ�
	orgPostGuide_getElement( Cd1, Cd2, CtrlName );

	// �폜
	orgPostGuide_clearOrgInfo();

}

// submit���̏���
function submitForm() {

	document.entryForm.submit();

}

//function selectHistoryPrint( index ) {

//	document.entryForm.historyPrint.value = document.historyPrintForm.historyPrint[ index ].value;

//}

//-->
</SCRIPT>
<STYLE TYPE="text/css">
<!--
td.prttab { background-color:#ffffff }
-->
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">�����я�</SPAN></B></TD>
		</TR>
	</TABLE>
<%
	'�G���[���b�Z�[�W�\��
	Call EditMessage(vntMessage, MESSAGETYPE_WARNING)
%>
	<BR>
<%
	'���[�h�̓v���r���[�Œ�
%>
	<INPUT TYPE="hidden" NAME="mode" VALUE="0">

	<INPUT TYPE="hidden" NAME="OrgGrpName"    VALUE="<%= strOrgGrpName    %>">
	<INPUT TYPE="hidden" NAME="orgCd11"       VALUE="<%= strOrgCd11       %>">
	<INPUT TYPE="hidden" NAME="orgCd12"       VALUE="<%= strOrgCd12       %>">
	<INPUT TYPE="hidden" NAME="orgCd21"       VALUE="<%= strOrgCd21       %>">
	<INPUT TYPE="hidden" NAME="orgCd22"       VALUE="<%= strOrgCd22       %>">
	<INPUT TYPE="hidden" NAME="orgCd31"       VALUE="<%= strOrgCd31       %>">
	<INPUT TYPE="hidden" NAME="orgCd32"       VALUE="<%= strOrgCd32       %>">
	<INPUT TYPE="hidden" NAME="orgCd41"       VALUE="<%= strOrgCd41       %>">
	<INPUT TYPE="hidden" NAME="orgCd42"       VALUE="<%= strOrgCd42       %>">
	<INPUT TYPE="hidden" NAME="orgCd51"       VALUE="<%= strOrgCd51       %>">
	<INPUT TYPE="hidden" NAME="orgCd52"       VALUE="<%= strOrgCd52       %>">
	<INPUT TYPE="hidden" NAME="orgCd61"       VALUE="<%= strOrgCd61       %>">
	<INPUT TYPE="hidden" NAME="orgCd62"       VALUE="<%= strOrgCd62       %>">
	<INPUT TYPE="hidden" NAME="orgCd71"       VALUE="<%= strOrgCd71       %>">
	<INPUT TYPE="hidden" NAME="orgCd72"       VALUE="<%= strOrgCd72       %>">

	<!--- ���t -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><FONT COLOR="#ff0000">��</FONT></TD>
			<TD WIDTH="90" NOWRAP>��f��</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
			<TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strSCslYear, False) %></TD>
			<TD>�N</TD>
			<TD><%= EditNumberList("strCslMonth", 1, 12, strSCslMonth, False) %></TD>
			<TD>��</TD>
			<TD><%= EditNumberList("strCslDay", 1, 31, strSCslDay, False) %></TD>
			<TD>��</TD>
			<TD>�`</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('endCslYear', 'endCslMonth', 'endCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
			<TD><%= EditNumberList("endCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strECslYear, False) %></TD>
			<TD>�N</TD>
			<TD><%= EditNumberList("endCslMonth", 1, 12, strECslMonth, False) %></TD>
			<TD>��</TD>
			<TD><%= EditNumberList("endCslDay", 1, 31, strECslDay, False) %></TD>
			<TD>��</TD>
		</TR>
	</TABLE>

	<!-- ����ID -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>����ID</TD>
			<TD>�F</TD>
			<TD>
				<INPUT TYPE="text" NAME="DayId" SIZE="100" VALUE="<%= strDayId %>">
			</TD>
		</TR>
	</TABLE>

	<!-- �c�̃O���[�v-->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>�c�̃O���[�v</TD>
			<TD>�F</TD>
			<TD><%= EditOrgGrp_PList("OrgGrpCd", strOrgGrpCd, NON_SELECTED_ADD) %></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>�c�̂P</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd11, document.entryForm.orgCd12, 'OrgName1')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd11, document.entryForm.orgCd12, 'OrgName1')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
			<TD NOWRAP><SPAN ID="OrgName1"><% = strOrgName1 %></SPAN></TD>
		</TR>
		<TR>
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>�c�̂Q</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd21, document.entryForm.orgCd22, 'OrgName2')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd121, document.entryForm.orgCd22, 'OrgName2')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
			<TD NOWRAP><SPAN ID="OrgName2"><% = strOrgName2 %></SPAN></TD>
		</TR>
		<TR>
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>�c�̂R</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd31, document.entryForm.orgCd32, 'OrgName3')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd131, document.entryForm.orgCd32, 'OrgName3')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
			<TD NOWRAP><SPAN ID="OrgName3"><% = strOrgName3 %></SPAN></TD>
		</TR>
		<TR>
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>�c�̂S</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd41, document.entryForm.orgCd42, 'OrgName4')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd141, document.entryForm.orgCd42, 'OrgName4')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
			<TD NOWRAP><SPAN ID="OrgName4"><% = strOrgName4 %></SPAN></TD>
		</TR>
		<TR>
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>�c�̂T</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd51, document.entryForm.orgCd52, 'OrgName5')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd151, document.entryForm.orgCd52, 'OrgName5')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
			<TD NOWRAP><SPAN ID="OrgName5"><% = strOrgName5 %></SPAN></TD>
		</TR>
		<TR>
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>�c�̂U</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd61, document.entryForm.orgCd62, 'OrgName6')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd161, document.entryForm.orgCd62, 'OrgName6')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
			<TD NOWRAP><SPAN ID="OrgName6"><% = strOrgName6 %></SPAN></TD>
		</TR>
		<TR>
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>�c�̂V</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd71, document.entryForm.orgCd72, 'OrgName7')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd171, document.entryForm.orgCd72, 'OrgName7')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
			<TD NOWRAP><SPAN ID="OrgName7"><% = strOrgName7 %></SPAN></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD><FONT COLOR="#ff0000">��</FONT></TD>
			<TD WIDTH="90" NOWRAP>�o�͗l��</TD>
			<TD>�F</TD>
			<TD>
<!--
				<SELECT NAME="reportCd" ONCHANGE="javascript:selectHistoryPrint(this.selectedIndex)">
-->
				<SELECT NAME="reportCd">
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
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
</BODY>
</HTML>