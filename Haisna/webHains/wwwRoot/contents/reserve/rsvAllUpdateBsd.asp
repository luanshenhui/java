<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'		��f��񏊑��̈ꊇ�X�V (Ver0.0.1)
'		AUTHER  : Hiroki Ishihara@fsit.fujitsu.com
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'COM�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objConsult			'��f���ꊇ�����p
Dim objContract			'�_����A�N�Z�X�p
Dim objOrganization		'�c�̏��A�N�Z�X�p

'�����l
Dim lngStrCslYear		'�J�n��f�N
Dim lngStrCslMonth		'�J�n��f��
Dim lngStrCslDay		'�J�n��f��
Dim lngEndCslYear		'�I����f�N
Dim lngEndCslMonth		'�I����f��
Dim lngEndCslDay		'�I����f��
Dim strOrgCd1			'�c�̃R�[�h�P
Dim strOrgCd2			'�c�̃R�[�h�Q
Dim strCount			'�X�V����

'�_����
Dim strCsCd				'�R�[�X�R�[�h
Dim strCsName			'�R�[�X��

Dim strUpdUser			'�X�V��

Dim strOrgName			'�c�̖���
Dim dtmStrCslDate		'�J�n��f�N����
Dim dtmEndCslDate		'�I����f�N����
Dim strMessage			'�G���[���b�Z�[�W
Dim strURL				'�W�����v���URL
Dim Ret					'�֐��߂�l
Dim i					'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

'�X�V�҂̐ݒ�
strUpdUser = Session("USERID")

'�����l�̎擾
lngStrCslYear    = CLng("0" & Request("strCslYear"))
lngStrCslMonth   = CLng("0" & Request("strCslMonth"))
lngStrCslDay     = CLng("0" & Request("strCslDay"))
lngEndCslYear    = CLng("0" & Request("endCslYear"))
lngEndCslMonth   = CLng("0" & Request("endCslMonth"))
lngEndCslDay     = CLng("0" & Request("endCslDay"))
strOrgCd1        = Request.QueryString("orgCd1")
strOrgCd2        = Request.QueryString("orgCd2")
strCsCd          = Request("CsCd")
strCount         = Request("count")

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

	'��f�N�����̕ҏW
	dtmStrCslDate = CDate(lngStrCslYear & "/" & lngStrCslMonth & "/" & lngStrCslDay)
	dtmEndCslDate = CDate(lngEndCslYear & "/" & lngEndCslMonth & "/" & lngEndCslDay)

	'�ꊇ�\��폜����
	Set objConsult      = Server.CreateObject("HainsConsult.Consult")
	Ret = objConsult.UpdateConsultBsd(Session("USERID"), dtmStrCslDate, dtmEndCslDate, strOrgCd1, strOrgCd2, strCsCd)
	Set objConsult      = Nothing
	If Ret Then
		strCount = "1"
	Else
		strCount = "-1"
	End If

	'����ʂ����_�C���N�g
	strURL = Request.ServerVariables("SCRIPT_NAME")
	strURL = strURL & "?strCslYear="    & lngStrCslYear
	strURL = strURL & "&strCslMonth="   & lngStrCslMonth
	strURL = strURL & "&strCslDay="     & lngStrCslDay
	strURL = strURL & "&endCslYear="    & lngEndCslYear
	strURL = strURL & "&endCslMonth="   & lngEndCslMonth
	strURL = strURL & "&endCslDay="     & lngEndCslDay
	strURL = strURL & "&orgCd1="        & strOrgCd1
	strURL = strURL & "&orgCd2="        & strOrgCd2
	strURL = strURL & "&CsCd="          & strCsCd
	strURL = strURL & "&count="         & strCount
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

	Dim strDate		'���t
	Dim strMessage	'�G���[���b�Z�[�W�̏W��

	'�J�n��f���`�F�b�N
	Do

		'�K�{�`�F�b�N
		If lngStrCslYear + lngStrCslMonth + lngStrCslDay = 0 Then
			objCommon.AppendArray strMessage, "�J�n��f������͂��ĉ������B"
			Exit Do
		End If

		'�J�n��f���̕ҏW
		strDate = lngStrCslYear & "/" & lngStrCslMonth & "/" & lngStrCslDay
		If Not IsDate(strDate) Then
			objCommon.AppendArray strMessage, "�J�n��f���̓��͌`��������������܂���B"
		End If

		Exit Do
	Loop

	'�I����f���`�F�b�N
	Do

		'�K�{�`�F�b�N
		If lngEndCslYear + lngEndCslMonth + lngEndCslDay = 0 Then
			objCommon.appendArray strMessage, "�I����f������͂��ĉ������B"
			Exit Do
		End If

		'�I����f���̕ҏW
		strDate = lngEndCslYear & "/" & lngEndCslMonth & "/" & lngEndCslDay
		If Not IsDate(strDate) Then
			objCommon.appendArray strMessage, "�I����f���̓��͌`��������������܂���B"
		End If

		Exit Do
	Loop

	'�c�̃R�[�h�̃`�F�b�N
	If strOrgCd1 = "" Or strOrgCd2 = "" Then
		objCommon.appendArray strMessage, "�c�̂��w�肵�ĉ������B"
	End If

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
<TITLE>��f��񏊑��̈ꊇ�X�V</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<!-- #include virtual = "/webHains/includes/ptnGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// �c�̌����K�C�h��ʂ�\��
function showGuideOrg() {

	// �c�̌����K�C�h��ʂ�\��
	with ( document.entryForm ) {
		ptnGuide_Val_OrgCd1 = orgCd1.value;
		ptnGuide_Val_OrgCd2 = orgCd2.value;
		orgGuide_showGuideOrg( orgCd1, orgCd2, 'orgName', null, null, checkClearSelectOrg, false, null, '0' );
	}

}

// �c�̑I�����̌_��p�^�[���N���A�̃`�F�b�N
function checkClearSelectOrg() {

	// ��ɑޔ������c�̂ƌ��݂̒c�̂�����ȏꍇ�͉������Ȃ�
	if ( orgGuide_OrgCd1.value == ptnGuide_Val_OrgCd1 && orgGuide_OrgCd2.value == ptnGuide_Val_OrgCd2 ) {
		return;
	}

	// �_��p�^�[���̃N���A
	ptnGuide_clearPatternInfo( document.entryForm.ctrPtCd, 'csName', 'strDate', 'endDate' );

}

// �_��p�^�[�������K�C�h��ʂ�\��
function showGuidePattern() {

	// �_��p�^�[�������K�C�h��ʂ�\��
	with ( document.entryForm ) {
		orgGuide_OrgCd1  = orgCd1;
		orgGuide_OrgCd2  = orgCd2;
		orgGuide_OrgName = document.getElementById( 'orgName' );
		ptnGuide_showGuidePattern( ctrPtCd, 'csName', 'strDate', 'endDate', setOrgInfo, orgCd1, orgCd2, '1' );
	}

}

// �_��p�^�[���I�����̏���
function setOrgInfo() {

	// �c�̏��̕ҏW
	orgGuide_setOrgInfo( ptnGuide_Val_OrgCd1, ptnGuide_Val_OrgCd2, ptnGuide_Val_OrgName );

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.rsvtab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" ONSUBMIT="javascript:return confirm('���̓��e�ňꊇ�X�V�������s���܂��B��낵���ł����H')">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000">�����i��f���j�̈ꊇ�X�V</FONT></B></TD>
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

		'�O���̏ꍇ
		If strCount = "0" Then
			EditMessage "�X�V�ΏۂƂȂ��f���͂���܂���ł����B", MESSAGETYPE_NORMAL
			Exit Do
		End If

		'�P���ȏ㏈�����ꂽ�ꍇ
'		EditMessage strCount & "���̎�f��񂪍X�V����܂����B�ڍׂ̓V�X�e�����O���Q�Ƃ��ĉ������B", MESSAGETYPE_NORMAL
		EditMessage "��f��񂪍X�V����܂����B", MESSAGETYPE_NORMAL
		Exit Do
	Loop
%>
	<BR>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD><FONT COLOR="#ff0000">��</FONT></TD>
			<TD NOWRAP>��f��</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
			<TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, lngStrCslYear, True) %></TD>
			<TD>�N</TD>
			<TD><%= EditNumberList("strCslMonth", 1, 12, lngStrCslMonth, True) %></TD>
			<TD>��</TD>
			<TD><%= EditNumberList("strCslDay", 1, 31, lngStrCslDay, True) %></TD>
			<TD NOWRAP>���`</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('endCslYear', 'endCslMonth', 'endCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
			<TD><%= EditNumberList("endCslYear", YEARRANGE_MIN, YEARRANGE_MAX, lngEndCslYear, True) %></TD>
			<TD>�N</TD>
			<TD><%= EditNumberList("endCslMonth", 1, 12, lngEndCslMonth, True) %></TD>
			<TD>��</TD>
			<TD><%= EditNumberList("endCslDay", 1, 31, lngEndCslDay, True) %></TD>
			<TD>��</TD>
		</TR>
<%
	'�c�̖��̂̓ǂݍ���
	If strOrgCd1 <> "" And strOrgCd2 <> "" Then
		If objOrganization.SelectOrg_Lukes(strOrgCd1, strOrgCd2, , , strOrgName) = False Then
			Err.Raise 1000, , "�c�̏�񂪑��݂��܂���B"
		End If
	End If
%>
		<TR>
			<TD><FONT COLOR="#ff0000">��</FONT></TD>
			<TD NOWRAP>�c��</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:showGuideOrg()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
			<TD NOWRAP COLSPAN="5"><SPAN ID="orgName"><%= strOrgName %></SPAN></TD>
		</TR>
		<TR>
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>�R�[�X</TD>
			<TD>�F</TD>
			<TD COLSPAN="5"><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd", strCsCd, NON_SELECTED_ADD, False) %></TD>
		</TR>
	</TABLE>

	<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
	<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">

	<BR><BR>

	<A HREF="rsvAllMenu.asp"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�߂�"></A>
	<INPUT TYPE="image" NAME="reserve" SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="���̏����ōX�V����">

	<BR><BR>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>