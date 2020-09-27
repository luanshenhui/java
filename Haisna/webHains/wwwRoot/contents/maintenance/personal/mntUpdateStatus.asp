<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'		��������f�҂̍폜 (Ver0.0.1)
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

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'COM�I�u�W�F�N�g
'Dim objCooperation		'�A�g�E�ꊇ�����p
Dim objOrganization		'�c�̏��A�N�Z�X�p

'�����l
Dim strOrgCd1			'�c�̃R�[�h�P
Dim strOrgCd2			'�c�̃R�[�h�Q
Dim lngStrCslYear		'�J�n��f�N
Dim lngStrCslMonth		'�J�n��f��
Dim lngStrCslDay		'�J�n��f��
Dim lngEndCslYear		'�I����f�N
Dim lngEndCslMonth		'�I����f��
Dim lngEndCslDay		'�I����f��
Dim strDelFlg			'�g�p���t���O
Dim strCount			'�폜����

Dim strOrgName			'�c�̖���
Dim dtmStrCslDate		'�J�n��f�N����
Dim dtmEndCslDate		'�I����f�N����
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

'�����l�̎擾
strOrgCd1      = Request("orgCd1")
strOrgCd2      = Request("orgCd2")
lngStrCslYear  = CLng("0" & Request("strCslYear"))
lngStrCslMonth = CLng("0" & Request("strCslMonth"))
lngStrCslDay   = CLng("0" & Request("strCslDay"))
lngEndCslYear  = CLng("0" & Request("endCslYear"))
lngEndCslMonth = CLng("0" & Request("endCslMonth"))
lngEndCslDay   = CLng("0" & Request("endCslDay"))
strDelFlg      = Request("delFlg")
strCount       = Request("count")

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do

	'�u�m��v�{�^���������ȊO�͉������Ȃ�
	If IsEmpty(Request("delete.x")) Then
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

	'�l���ꊇ�X�V����
'	Set objCooperation = Server.CreateObject("HainsCooperation.PersonAll")
'	Ret = objCooperation.UpdateStatus(strOrgCd1, strOrgCd2, dtmStrCslDate, dtmEndCslDate, strDelFlg)

	strCommand = "cscript " & Server.MapPath("/webHains/script") & "\UpdatePersonalStatus.vbs"
	strCommand = strCommand & " " & strOrgCd1
	strCommand = strCommand & " " & strOrgCd2
	strCommand = strCommand & " " & dtmStrCslDate
	strCommand = strCommand & " " & dtmEndCslDate
	strCommand = strCommand & " " & strDelFlg

	'�X�N���[�j���O�����N��
	Set objExec = Server.CreateObject("HainsCooperation.Exec")
	objExec.Run strCommand
	Ret = 0

	'����ʂ����_�C���N�g
	strURL = Request.ServerVariables("SCRIPT_NAME")
	strURL = strURL & "?orgCd1="      & strOrgCd1
	strURL = strURL & "&orgCd2="      & strOrgCd2
	strURL = strURL & "&strCslYear="  & lngStrCslYear
	strURL = strURL & "&strCslMonth=" & lngStrCslMonth
	strURL = strURL & "&strCslDay="   & lngStrCslDay
	strURL = strURL & "&endCslYear="  & lngEndCslYear
	strURL = strURL & "&endCslMonth=" & lngEndCslMonth
	strURL = strURL & "&endCslDay="   & lngEndCslDay
	strURL = strURL & "&delFlg="      & strDelFlg
	strURL = strURL & "&count="       & Ret
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

	Dim objCommon	'���ʃN���X
	Dim strDate		'���t
	Dim strMessage	'�G���[���b�Z�[�W�̏W��

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'�J�n��f���`�F�b�N
	Do

		'�K�{�`�F�b�N
		If lngStrCslYear + lngStrCslMonth + lngStrCslDay = 0 Then
			objCommon.appendArray strMessage, "�J�n��f������͂��ĉ������B"
			Exit Do
		End If

		'�J�n��f���̕ҏW
		strDate = lngStrCslYear & "/" & lngStrCslMonth & "/" & lngStrCslDay
		If Not IsDate(strDate) Then
			objCommon.appendArray strMessage, "�J�n��f���̓��͌`��������������܂���B"
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

	'�g�p��ԃ`�F�b�N
	If strDelFlg = "" Then
		objCommon.appendArray strMessage, "�g�p��Ԃ�I�����ĉ������B"
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
<TITLE>��������f�҂̍폜</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<STYLE TYPE="text/css">
td.mnttab { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" ONSUBMIT="javascript:return confirm('���̏����Œ�������f�҂̍폜�������s���܂��B��낵���ł����H')">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
	<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">��</SPAN><FONT COLOR="#000000">��������f�҂̍폜</FONT></B></TD>
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

		EditMessage "�l���̍X�V�������J�n���܂����B�ڍׂ̓V�X�e�����O���Q�Ƃ��ĉ������B", MESSAGETYPE_NORMAL
		Exit Do

		'�O���̏ꍇ
		If strCount = "0" Then
			EditMessage "�X�V�ΏۂƂȂ�l���͂���܂���ł����B", MESSAGETYPE_NORMAL
			Exit Do
		End If

		'�P���ȏ㏈�����ꂽ�ꍇ
		EditMessage strCount & "���̌l��񂪍X�V����܂����B�ڍׂ̓V�X�e�����O���Q�Ƃ��ĉ������B", MESSAGETYPE_NORMAL
		Exit Do
	Loop
%>
	<BR>
<%
	'�c�̖��̂̓ǂݍ���
	Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
	If objOrganization.SelectOrg_Lukes(strOrgCd1, strOrgCd2, , , strOrgName) = False Then
		Err.Raise 1000, , "�c�̏�񂪑��݂��܂���B"
	End If
%>
	�Ώےc�́F<B><%= strOrgName %></B><BR><BR>
	<FONT COLOR="#cc9999">��</FONT>�w�肳�ꂽ��f���Ԃɂ����Ė���f�ł���l���̎g�p��Ԃ��X�V���܂��B<BR><BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD NOWRAP>���������f����</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
					<TR>
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
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>�X�V����g�p���</TD>
			<TD>�F</TD>
			<TD>
				<SELECT NAME="delFlg">
					<OPTION VALUE="">&nbsp;
					<OPTION VALUE="0" <%= IIf(strDelFlg = "0", "SELECTED", "") %>>�g�p��
					<OPTION VALUE="1" <%= IIf(strDelFlg = "1", "SELECTED", "") %>>�폜�ρi�ސE�����j
					<OPTION VALUE="2" <%= IIf(strDelFlg = "2", "SELECTED", "") %>>�x�E��
				</SELECT>
			</TD>
		</TR>
	</TABLE>

	<BR><BR>

	<A HREF="../organization/mntOrganization.asp?mode=update&orgCd1=<%= strOrgCd1 %>&orgCd2=<%= strOrgCd2 %>"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�߂�"></A>
	<INPUT TYPE="image" NAME="delete" SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="���̏����ō폜����">

	<BR><BR>

	<A HREF="/webHains/contents/maintenance/hainslog/dispHainsLog.asp?mode=print&transactionDiv=LOGUPDSTA"><IMG SRC="/webHains/images/prevlog.gif" WIDTH="77" HEIGHT="24" ALT="���O���Q�Ƃ���"></A>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>