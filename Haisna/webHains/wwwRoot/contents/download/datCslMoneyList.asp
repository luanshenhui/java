<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'		�l��f���z�ꗗ (Ver0.0.1)
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
Dim strMode			'������[�h
Dim vntMessage		'�ʒm���b�Z�[�W

'-------------------------------------------------------------------------------
' �ŗL�錾��
'-------------------------------------------------------------------------------
'�����l
Dim lngGetMode			'���o���[�h(0:��f���w��A1:���ߓ��w��)
Dim lngStrCslYear		'�J�n��f�N
Dim lngStrCslMonth		'�J�n��f��
Dim lngStrCslDay		'�J�n��f��
Dim lngEndCslYear		'�I����f�N
Dim lngEndCslMonth		'�I����f��
Dim lngEndCslDay		'�I����f��
Dim strCsCd				'�R�[�X�R�[�h
Dim strOrgCd1			'�c�̃R�[�h�P
Dim strOrgCd2			'�c�̃R�[�h�Q
Dim strOrgBsdCd		'���ƕ��R�[�h 
Dim strOrgRoomCd		'�����R�[�h
Dim strStrOrgPostCd		'�J�n�����R�[�h
Dim strEndOrgPostCd		'�I�������R�[�h
Dim strAllowUnReceipt	'"1":����t�f�[�^�𒊏o���Ȃ�
Dim lngStrCloseYear		'�J�n���ߔN
Dim lngStrCloseMonth	'�J�n���ߌ�
Dim lngStrCloseDay		'�J�n���ߓ�
Dim lngEndCloseYear		'�I�����ߔN
Dim lngEndCloseMonth	'�I�����ߌ�
Dim lngEndCloseDay		'�I�����ߓ�
Dim strBdnOrgCd1		'���S���c�̃R�[�h�P
Dim strBdnOrgCd2		'���S���c�̃R�[�h�Q
Dim strBillNo			'�������ԍ�

'��Ɨp�ϐ�
Dim strOrgName			'�c�̖���
Dim strBsdName			'���ƕ�����
Dim strRoomName			'��������
Dim	strStrOrgPostName	'�J�n��������
Dim strEndOrgPostName	'�I����������
Dim strStrCslDate		'�J�n��f�N����
Dim strEndCslDate		'�I����f�N����
Dim strStrCloseDate		'�J�n���ߔN����
Dim strEndCloseDate		'�I�����ߔN����
Dim strBdnOrgName		'���S���c�̖���

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
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub GetQueryString()

	Dim objOrganization	'�c�̏��A�N�Z�X�p
	Dim objOrgBsd		'���ƕ����A�N�Z�X�p
	Dim objOrgRoom		'�������A�N�Z�X�p
	Dim objOrgPost		'�������A�N�Z�X�p

	'���o���[�h
	lngGetMode = CLng("0" & Request("getMode"))

	'�J�n��f�N����
	lngStrCslYear  = CLng("0" & Request("strCslYear"))
	lngStrCslMonth = CLng("0" & Request("strCslMonth"))
	lngStrCslDay   = CLng("0" & Request("strCslDay"))
	lngStrCslYear  = IIf(lngStrCslYear  <> 0, lngStrCslYear,  Year(Date))
	lngStrCslMonth = IIf(lngStrCslMonth <> 0, lngStrCslMonth, Month(Date))
	lngStrCslDay   = IIf(lngStrCslDay   <> 0, lngStrCslDay,   Day(Date))
	strStrCslDate  = lngStrCslYear & "/" & lngStrCslMonth & "/" & lngStrCslDay

	'�I����f�N����
	lngEndCslYear  = CLng("0" & Request("endCslYear"))
	lngEndCslMonth = CLng("0" & Request("endCslMonth"))
	lngEndCslDay   = CLng("0" & Request("endCslDay"))
	lngEndCslYear  = IIf(lngEndCslYear  <> 0, lngEndCslYear,  Year(Date))
	lngEndCslMonth = IIf(lngEndCslMonth <> 0, lngEndCslMonth, Month(Date))
	lngEndCslDay   = IIf(lngEndCslDay   <> 0, lngEndCslDay,   Day(Date))
	strEndCslDate  = lngEndCslYear & "/" & lngEndCslMonth & "/" & lngEndCslDay

	'�R�[�X�R�[�h
	strCsCd = Request("csCd")

	'�Ώۃf�[�^
	strAllowUnReceipt = IIf(strMode <> "", Request("allowUnReceipt"), "1")

	'�J�n���ߔN����
	lngStrCloseYear  = CLng("0" & Request("strCloseYear"))
	lngStrCloseMonth = CLng("0" & Request("strCloseMonth"))
	lngStrCloseDay   = CLng("0" & Request("strCloseDay"))
	lngStrCloseYear  = IIf(lngStrCloseYear  <> 0, lngStrCloseYear,  Year(Date))
	lngStrCloseMonth = IIf(lngStrCloseMonth <> 0, lngStrCloseMonth, Month(Date))
	lngStrCloseDay   = IIf(lngStrCloseDay   <> 0, lngStrCloseDay,   Day(Date))
	strStrCloseDate  = lngStrCloseYear & "/" & lngStrCloseMonth & "/" & lngStrCloseDay

	'�I�����ߔN����
	lngEndCloseYear  = CLng("0" & Request("endCloseYear"))
	lngEndCloseMonth = CLng("0" & Request("endCloseMonth"))
	lngEndCloseDay   = CLng("0" & Request("endCloseDay"))
	lngEndCloseYear  = IIf(lngEndCloseYear  <> 0, lngEndCloseYear,  Year(Date))
	lngEndCloseMonth = IIf(lngEndCloseMonth <> 0, lngEndCloseMonth, Month(Date))
	lngEndCloseDay   = IIf(lngEndCloseDay   <> 0, lngEndCloseDay,   Day(Date))
	strEndCloseDate  = lngEndCloseYear & "/" & lngEndCloseMonth & "/" & lngEndCloseDay

	'�������ԍ�
	strBillNo = Request("billNo")

	'���S���c��
	strBdnOrgCd1 = Request("bdnOrgCd1")
	strBdnOrgCd2 = Request("bdnOrgCd2")

	'�c�̖��̓ǂݍ���
	Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
	If strBdnOrgCd1 <> "" And strBdnOrgCd2 <> "" Then
'## 2004/06/28 MOD STR ORB)T.YAGUCHI ���H���őΉ�
'		objOrganization.SelectOrg strBdnOrgCd1, strBdnOrgCd2, , strBdnOrgName
		objOrganization.SelectOrgName strBdnOrgCd1, strBdnOrgCd2, strBdnOrgName
'## 2004/06/28 MOD END
	End If

	'�c�́A���ƕ��A�����A����
	strOrgCd1       = Request("orgCd1")
	strOrgCd2       = Request("orgCd2")
'## 2004/06/28 DEL STR ORB)T.YAGUCHI ���H���őΉ�
'	strOrgBsdCd     = Request("orgBsdCd")
'	strOrgRoomCd    = Request("orgRoomCd")
'	strStrOrgPostCd = Request("strOrgPostCd")
'	strEndOrgPostCd = Request("endOrgPostCd")
'## 2004/06/28 DEL END

	If strOrgCd1 = "" Or strOrgCd2 = "" Then
		Exit Sub
	End If

	'�c�̖��̓ǂݍ���
'## 2004/06/28 MOD STR ORB)T.YAGUCHI ���H���őΉ�
'	objOrganization.SelectOrg strOrgCd1, strOrgCd2, , strOrgName
	objOrganization.SelectOrgName strOrgCd1, strOrgCd2, strOrgName
'## 2004/06/28 MOD END

'## 2004/06/28 DEL STR ORB)T.YAGUCHI ���H���őΉ�
'	If strOrgBsdCd = "" Then
'		Exit Sub
'	End If
'
'	'���ƕ����̓ǂݍ���
'	Set objOrgBsd = Server.CreateObject("HainsOrgBsd.OrgBsd")
'	objOrgBsd.SelectOrgBsd strOrgCd1, strOrgCd2, strOrgBsdCd, , strBsdName
'
'	If strOrgRoomCd = "" Then
'		Exit Sub
'	End If
'
'	'�������̓ǂݍ���
'	Set objOrgRoom = Server.CreateObject("HainsOrgRoom.OrgRoom")
'	objOrgRoom.SelectOrgRoom strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strRoomName
'
'	Set objOrgPost = Server.CreateObject("HainsOrgPost.OrgPost")
'
'	'�������̓ǂݍ���
'	If strStrOrgPostCd <> "" Then
'		objOrgPost.SelectOrgPost strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strStrOrgPostCd, strStrOrgPostName
'	End If
'
'	If strEndOrgPostCd <> "" Then
'		objOrgPost.SelectOrgPost strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strEndOrgPostCd, strEndOrgPostName
'	End If
'## 2004/06/28 DEL END

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
	Dim vntArrMessage	'�G���[���b�Z�[�W�̏W��

	Set objCommon = Server.CreateObject("HainsCommon.Common")

	With objCommon

		'��f���w��̏ꍇ
		If lngGetMode = 0 Then

			If Not IsDate(strStrCslDate) Then
				.AppendArray vntArrMessage, "�J�n��f���̓��͌`��������������܂���B"
			End If

			If Not IsDate(strEndCslDate) Then
				.AppendArray vntArrMessage, "�I����f���̓��͌`��������������܂���B"
			End If

		'���ߓ��w��̏ꍇ
		Else

			If Not IsDate(strStrCloseDate) Then
				.AppendArray vntArrMessage, "�J�n���ߓ��̓��͌`��������������܂���B"
			End If

			If Not IsDate(strEndCloseDate) Then
				.AppendArray vntArrMessage, "�I�����ߓ��̓��͌`��������������܂���B"
			End If

'## 2004/06/28 MOD STR ORB)T.YAGUCHI ���H���őΉ�
'			.AppendArray vntArrMessage, .CheckNumeric("�������ԍ�", strBillNo, 9)
			.AppendArray vntArrMessage, .CheckNumeric("�������ԍ�", strBillNo, 14)
'## 2004/06/28 MOD END

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

	Dim objCslMoneyList	'�l��f���z�ꗗ�o�͗pCOM�R���|�[�l���g

	Dim dtmStrCslDate	'�J�n��f���܂��͒��ߓ�
	Dim dtmEndCslDate	'�I����f���܂��͒��ߓ�
	Dim strParaOrgCd1	'�c�̃R�[�h�P
	Dim strParaOrgCd2	'�c�̃R�[�h�Q
	Dim Ret				'�֐��߂�l

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objCslMoneyList = Server.CreateObject("HainsCslMoneyList.CslMoneyList")

	'���o���[�h���Ƃ̈����ݒ�
	If lngGetMode = 0 Then
		dtmStrCslDate = CDate(strStrCslDate)
		dtmEndCslDate = CDate(strEndCslDate)
		strParaOrgCd1 = strOrgCd1
		strParaOrgCd2 = strOrgCd2
	Else
		dtmStrCslDate = CDate(strStrCloseDate)
		dtmEndCslDate = CDate(strEndCloseDate)
		strParaOrgCd1 = strBdnOrgCd1
		strParaOrgCd2 = strBdnOrgCd2
	End If

	'���R�����΍��p���O�����o��
	Call putPrivacyInfoLog("PH102", "�f�[�^���o �l��f���z�ꗗ���o���t�@�C���o�͂��s����")

'## 2004/06/28 MOD STR ORB)T.YAGUCHI ���H���őΉ�
'	'�l��f���z�ꗗ�h�L�������g�t�@�C���쐬����
'	Ret = objCslMoneyList.PrintCslMoneyList(Session("USERID"), lngGetMode, dtmStrCslDate, dtmEndCslDate, strParaOrgCd1, strParaOrgCd2, strOrgBsdCd, strOrgRoomCd, strStrOrgPostCd, strEndOrgPostCd, strCsCd, strBillNo, (strAllowUnReceipt <> "1"))
	'�l��f���z�ꗗ�h�L�������g�t�@�C���쐬����
	Ret = objCslMoneyList.PrintCslMoneyList(Session("USERID"), lngGetMode, dtmStrCslDate, dtmEndCslDate, strParaOrgCd1, strParaOrgCd2, strCsCd, strBillNo, (strAllowUnReceipt <> "1"))
'## 2004/06/28 MOD END

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
<TITLE>�l��f���z�ꗗ</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
//'## 2004/06/28 DEL STR ORB)T.YAGUCHI ���H���őΉ�
//// �G�������g�̎Q�Ɛݒ�
//function setElement() {
//
//	// �c�́E�������G�������g�̎Q�Ɛݒ�
//	with ( document.entryForm ) {
//		orgPostGuide_getElement( orgCd1, orgCd2, 'orgName', orgBsdCd, 'orgBsdName', orgRoomCd, 'orgRoomName', strOrgPostCd, 'strOrgPostName', endOrgPostCd, 'endOrgPostName' );
//	}
//
//}
//'## 2004/06/28 DEL END

// �c�̌����K�C�h�\��
function showGuideOrg() {

//'## 2004/06/28 MOD STR ORB)T.YAGUCHI ���H���őΉ�
//	setElement();
//	orgPostGuide_showGuideOrg();
	with ( document.entryForm ) {
		orgGuide_showGuideOrg( orgCd1, orgCd2, 'orgName' );
	}
//'## 2004/06/28 MOD END

}

// �c�̈ȍ~�̃N���A
function clearOrgInfo() {

//'## 2004/06/28 MOD STR ORB)T.YAGUCHI ���H���őΉ�
//	setElement();
//	orgPostGuide_clearOrgInfo();
	with ( document.entryForm ) {
		orgGuide_clearOrgInfo( orgCd1, orgCd2, 'orgName' );
	}
//'## 2004/06/28 MOD END

}

//'## 2004/06/28 DEL STR ORB)T.YAGUCHI ���H���őΉ�
//// ���ƕ������K�C�h�\��
//function showGuideOrgBsd() {
//
//	setElement();
//	orgPostGuide_showGuideOrgBsd();
//
//}
//
//// ���ƕ��ȍ~�̃N���A
//function clearOrgBsdInfo() {
//
//	setElement();
//	orgPostGuide_clearOrgBsdInfo();
//
//}
//
//// ���������K�C�h�\��
//function showGuideOrgRoom() {
//
//	setElement();
//	orgPostGuide_showGuideOrgRoom();
//
//}
//
//// �����ȍ~�̃N���A
//function clearOrgRoomInfo() {
//
//	setElement();
//	orgPostGuide_clearOrgRoomInfo();
//
//}
//
//// ���������K�C�h�\��
//function showGuideOrgPost( index ) {
//
//	setElement();
//	orgPostGuide_showGuideOrgPost( index );
//
//}
//
//// �����̃N���A
//function clearOrgPostInfo( index ) {
//
//	setElement();
//	orgPostGuide_clearOrgPostInfo( index );
//
//}
//'## 2004/06/28 DEL END

// ���S���c�̌����K�C�h�\��
function showGuideBdnOrg() {

	with ( document.entryForm ) {
		orgGuide_showGuideOrg( bdnOrgCd1, bdnOrgCd2, 'bdnOrgName' );
	}

}

// ���S���c�̂̃N���A
function clearBdnOrgInfo() {

	with ( document.entryForm ) {
		orgGuide_clearOrgInfo( bdnOrgCd1, bdnOrgCd2, 'bdnOrgName' );
	}

}

// submit���̏���
function submitForm() {

	document.entryForm.submit();

}

// �K�C�h��ʂ����
function closeWindow() {

	calGuide_closeGuideCalendar();
	orgGuide_closeGuideOrg();

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.datatab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="mode" VALUE="0">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">��</SPAN><FONT COLOR="#000000">�l��f���z�ꗗ</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'�G���[���b�Z�[�W�\��
	Call EditMessage(vntMessage, MESSAGETYPE_WARNING)
%>
	<BR>

	<INPUT TYPE="hidden" NAME="orgCd1"       VALUE="<%= strOrgCd1       %>">
	<INPUT TYPE="hidden" NAME="orgCd2"       VALUE="<%= strOrgCd2       %>">
<% '## 2004/06/28 MOD STR ORB)T.YAGUCHI ���H���őΉ� %>
<!--
	<INPUT TYPE="hidden" NAME="orgBsdCd"     VALUE="<%= strOrgBsdCd     %>">
	<INPUT TYPE="hidden" NAME="orgRoomCd"    VALUE="<%= strOrgRoomCd    %>">
	<INPUT TYPE="hidden" NAME="strOrgPostCd" VALUE="<%= strStrOrgPostCd %>">
	<INPUT TYPE="hidden" NAME="endOrgPostCd" VALUE="<%= strEndOrgPostCd %>">
-->
<% '## 2004/06/28 MOD END %>

	<INPUT TYPE="hidden" NAME="bdnOrgCd1" VALUE="<%= strBdnOrgCd1 %>">
	<INPUT TYPE="hidden" NAME="bdnOrgCd2" VALUE="<%= strBdnOrgCd2 %>">

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><INPUT TYPE="radio" NAME="getMode" VALUE="0" <%= IIf(lngGetMode = 0, "CHECKED", "") %>></TD>
			<TD NOWRAP>��f���ԂŒ��o</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
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
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
					<TR>
						<TD>��</TD>
						<TD WIDTH="90" NOWRAP>�R�[�X</TD>
						<TD>�F</TD>
						<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd", strCsCd, NON_SELECTED_ADD, False) %></TD>
					</TR>
				</TABLE>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
					<TR>
						<TD>��</TD>
						<TD WIDTH="90" NOWRAP>�c��</TD>
						<TD>�F</TD>
						<TD><A HREF="javascript:showGuideOrg()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
						<TD><A HREF="javascript:clearOrgInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
						<TD NOWRAP><SPAN ID="orgName"><% = strOrgName %></SPAN></TD>
					</TR>
				</TABLE>
<% '## 2004/06/28 DEL STR ORB)T.YAGUCHI ���H���őΉ� %>
<!--
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
					<TR>
						<TD>��</TD>
						<TD WIDTH="90" NOWRAP>���ƕ�</TD>
						<TD>�F</TD>
						<TD><A HREF="javascript:showGuideOrgBsd()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���ƕ������K�C�h��\��"></A></TD>
						<TD><A HREF="javascript:clearOrgBsdInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
						<TD NOWRAP><SPAN ID="orgBsdName"><% = strBsdName %></SPAN></TD>
					</TR>
				</TABLE>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
					<TR>
						<TD>��</TD>
						<TD WIDTH="90" NOWRAP>����</TD>
						<TD>�F</TD>
						<TD><A HREF="javascript:showGuideOrgRoom()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���������K�C�h��\��"></A></TD>
						<TD><A HREF="javascript:clearOrgRoomInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
						<TD NOWRAP><SPAN ID="orgRoomName"><% = strRoomName %></SPAN></TD>
					</TR>
				</TABLE>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
					<TR>
						<TD>��</TD>
						<TD WIDTH=90" NOWRAP>����</TD>
						<TD>�F</TD>
						<TD><A HREF="javascript:showGuideOrgPost(1)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���������K�C�h��\��"></A></TD>
						<TD><A HREF="javascript:clearOrgPostInfo(1)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
						<TD NOWRAP><SPAN ID="strOrgPostName"><% = strStrOrgPostName %></SPAN></TD>
						<TD>�`</TD>
						<TD><A HREF="javascript:showGuideOrgPost(2)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���������K�C�h��\��"></A></TD>
						<TD><A HREF="javascript:clearOrgPostInfo(2)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
						<TD NOWRAP><SPAN ID="endOrgPostName"><% = strEndOrgPostName %></SPAN></TD>
					</TR>
				</TABLE>
-->
<% '## 2004/06/28 DEL END %>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
					<TR>
						<TD><FONT COLOR="#ff0000">��</FONT></TD>
						<TD WIDTH="90" NOWRAP>�Ώۃf�[�^</TD>
						<TD>�F</TD>
						<TD><INPUT TYPE="checkbox" NAME="allowUnReceipt" VALUE="1" <%= IIf(strAllowUnReceipt <> "", "CHECKED", "") %>></TD>
<% '## 2004/06/28 MOD STR ORB)T.YAGUCHI ���H���őΉ� %>
<!--						<TD>����t�̃f�[�^�͏o�͂��Ȃ�</TD>-->
						<TD>�����@�̃f�[�^�͏o�͂��Ȃ�</TD>
<% '## 2004/06/28 MOD END %>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD><INPUT TYPE="radio" NAME="getMode" VALUE="1" <%= IIf(lngGetMode = 1, "CHECKED", "") %>></TD>
			<TD NOWRAP>���ߓ��͈͂Œ��o</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
					<TR>
						<TD><FONT COLOR="#ff0000">��</FONT></TD>
						<TD WIDTH="90" NOWRAP>���ߓ�</TD>
						<TD>�F</TD>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('strCloseYear', 'strCloseMonth', 'strCloseDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
						<TD><%= EditNumberList("strCloseYear", YEARRANGE_MIN, YEARRANGE_MAX, lngStrCloseYear, False) %></TD>
						<TD>�N</TD>
						<TD><%= EditNumberList("strCloseMonth", 1, 12, lngStrCloseMonth, False) %></TD>
						<TD>��</TD>
						<TD><%= EditNumberList("strCloseDay", 1, 31, lngStrCloseDay, False) %></TD>
						<TD>��</TD>
						<TD>�`</TD>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('endCloseYear', 'endCloseMonth', 'endCloseDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
						<TD><%= EditNumberList("endCloseYear", YEARRANGE_MIN, YEARRANGE_MAX, lngEndCloseYear, False) %></TD>
						<TD>�N</TD>
						<TD><%= EditNumberList("endCloseMonth", 1, 12, lngEndCloseMonth, False) %></TD>
						<TD>��</TD>
						<TD><%= EditNumberList("endCloseDay", 1, 31, lngEndCloseDay, False) %></TD>
						<TD>��</TD>
					</TR>
				</TABLE>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
					<TR>
						<TD>��</TD>
						<TD WIDTH="90" NOWRAP>���S���c��</TD>
						<TD>�F</TD>
						<TD><A HREF="javascript:showGuideBdnOrg()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
						<TD><A HREF="javascript:clearBdnOrgInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
						<TD NOWRAP><SPAN ID="bdnOrgName"><% = strBdnOrgName %></SPAN></TD>
					</TR>
				</TABLE>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
					<TR>
						<TD>��</TD>
						<TD WIDTH="90" NOWRAP>�������ԍ�</TD>
						<TD>�F</TD>
<% '## 2004/06/28 MOD STR ORB)T.YAGUCHI ���H���őΉ� %>
<!--						<TD><INPUT TYPE="text" NAME="billNo" SIZE="12" MAXLENGTH="9" VALUE="<%= strBillNo %>"></TD>-->
						<TD><INPUT TYPE="text" NAME="billNo" SIZE="20" MAXLENGTH="14" VALUE="<%= strBillNo %>"></TD>
<% '## 2004/06/28 MOD END %>
						<TD><FONT COLOR="#999999">���������ԍ����w�肵���ꍇ�A���ߓ��͈́A���S���͖�������܂��B</FONT></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

	<BR><BR>

	<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
        <A HREF="javascript:submitForm()"><IMG SRC="/webHains/images/DataSelect.gif"></A>
    <%  end if  %>

	</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>

</BODY>
</HTML>