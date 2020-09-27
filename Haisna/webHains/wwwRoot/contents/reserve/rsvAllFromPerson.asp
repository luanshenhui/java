<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'		�l��񂩂�̈ꊇ�\�� (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
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
Dim objOrganization		'�c�̏��A�N�Z�X�p
Dim objOrgBsd			'���ƕ����A�N�Z�X�p
Dim objOrgPost			'�������A�N�Z�X�p
Dim objOrgRoom			'�������A�N�Z�X�p

'�����l
Dim strOrgCd1			'�c�̃R�[�h�P
Dim strOrgCd2			'�c�̃R�[�h�Q
Dim strOrgBsdCd			'���ƕ��R�[�h
Dim strOrgRoomCd		'�����R�[�h
Dim strStrOrgPostCd		'�J�n�����R�[�h
Dim strEndOrgPostCd		'�I�������R�[�h
Dim strCtrPtCd			'�_��p�^�[���R�[�h
Dim strCslYear			'��f�N
Dim strCslMonth			'��f��
Dim strCslDay			'��f��
Dim strOpMode			'�������[�h
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

Dim dtmCslDate			'��f��
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
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objOrgBsd       = Server.CreateObject("HainsOrgBsd.OrgBsd")
Set objOrgPost      = Server.CreateObject("HainsOrgPost.OrgPost")
Set objOrgRoom      = Server.CreateObject("HainsOrgRoom.OrgRoom")

'�X�V�҂̐ݒ�
strUpdUser = Session("USERID")

'�����l�̎擾
strOrgCd1       = Request("orgCd1")
strOrgCd2       = Request("orgCd2")
strOrgBsdCd     = Request("orgBsdCd")
strOrgRoomCd    = Request("orgRoomCd")
strStrOrgPostCd = Request("strOrgPostCd")
strEndOrgPostCd = Request("endOrgPostCd")
strCtrPtCd      = Request("ctrPtCd")
strCslYear      = Request("cslYear")
strCslMonth     = Request("cslMonth")
strCslDay       = Request("cslDay")
strOpMode       = Request("opMode")
strCount        = Request("count")

'�������[�h�̃f�t�H���g�l�ݒ�
strOpMode = IIf(strOpMode = "", "0", strOpMode)

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

	'��f���̐ݒ�
	If strCslYear & strCslMonth & strCslDay <> "" Then
		dtmCslDate = CDate(strCslYear & "/" & strCslMonth & "/" & strCslDay)
	End If

'	'�ꊇ�\�񏈗�
'	Ret = objConsult.InsertConsultFromPerson(strUpdUser, strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strStrOrgPostCd, strEndOrgPostCd, strCtrPtCd, dtmCslDate, strOpMode)

	strCommand = "cscript " & Server.MapPath("/webHains/script") & "\InsertConsultFromPerson.vbs"
	strCommand = strCommand & " " & strUpdUser
	strCommand = strCommand & " " & strOrgCd1
	strCommand = strCommand & " " & strOrgCd2
	strCommand = strCommand & " " & IIf(strOrgBsdCd     <> "", strOrgBsdCd,     """""")
	strCommand = strCommand & " " & IIf(strOrgRoomCd    <> "", strOrgRoomCd,    """""")
	strCommand = strCommand & " " & IIf(strStrOrgPostCd <> "", strStrOrgPostCd, """""")
	strCommand = strCommand & " " & IIf(strEndOrgPostCd <> "", strEndOrgPostCd, """""")
	strCommand = strCommand & " " & strCtrPtCd
	strCommand = strCommand & " " & IIf(dtmCslDate > 0, dtmCslDate, 0)
	strCommand = strCommand & " " & strOpMode

	'��荞�ݏ����N��
	Set objExec = Server.CreateObject("HainsCooperation.Exec")
	objExec.Run strCommand
	Ret = 0

	'����ʂ����_�C���N�g
	strURL = Request.ServerVariables("SCRIPT_NAME")
	strURL = strURL & "?orgCd1="       & strOrgCd1
	strURL = strURL & "&orgCd2="       & strOrgCd2
	strURL = strURL & "&orgBsdCd="     & strOrgBsdCd
	strURL = strURL & "&orgRoomCd="    & strOrgRoomCd
	strURL = strURL & "&strOrgPostCd=" & strStrOrgPostCd
	strURL = strURL & "&endOrgPostCd=" & strEndOrgPostCd
	strURL = strURL & "&ctrPtCd="      & strCtrPtCd
	strURL = strURL & "&cslYear="      & strCslYear
	strURL = strURL & "&cslMonth="     & strCslMonth
	strURL = strURL & "&cslDay="       & strCslDay
	strURL = strURL & "&opMode="       & strOpMode
	strURL = strURL & "&count="        & Ret
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

	Dim strCslDate	'��f��
	Dim strMessage	'�G���[���b�Z�[�W�̏W��
	Dim blnError	'�G���[�t���O

	'�c�̃R�[�h�̃`�F�b�N
	If strOrgCd1 = "" Or strOrgCd2 = "" Then
		objCommon.appendArray strMessage, "�c�̂��w�肵�ĉ������B"
	End If

	'�_��p�^�[���R�[�h�̃`�F�b�N
	If strCtrPtCd = "" Then
		objCommon.appendArray strMessage, "�_��p�^�[�����w�肵�ĉ������B"
	End If

	'��f���̃`�F�b�N
	Do

		'��f�������͎��̓X�L�b�v
		If strCslYear & strCslMonth & strCslDay = "" Then
			Exit Do
		End If

		'��f���̃`�F�b�N
		strCslDate = strCslYear & "/" & strCslMonth & "/" & strCslDay
		If Not IsDate(strCslDate) Then
			objCommon.appendArray strMessage, "��f���̓��͌`��������������܂���B"
			Exit Do
		End If

		'��f���͎w��_��p�^�[���̌_����ԓ��ɑ��݂��Ȃ���΂Ȃ�Ȃ�
		If strOrgCd1 <> "" And strOrgCd2 <> "" And strCtrPtCd <> "" Then
			If CDate(strCslDate) < dtmStrDate Or CDate(strCslDate) > dtmEndDate Then
				objCommon.appendArray strMessage, "��f���͌_����Ԃ͈͓̔��Ŏw�肵�Ă��������B"
				Exit Do
			End If
		End If

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
<TITLE>�l��񂩂�̈ꊇ�\��</TITLE>
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
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000">�l��񂩂�̈ꊇ�\��</FONT></B></TD>
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

'		'�P���ȏ㏈�����ꂽ�ꍇ
'		EditMessage strCount & "���̎�f��񂪍쐬����܂����B�ڍׂ̓V�X�e�����O���Q�Ƃ��ĉ������B", MESSAGETYPE_NORMAL

		EditMessage "�l��񂩂�̈ꊇ�\�񏈗����J�n����܂����B�ڍׂ̓V�X�e�����O���Q�Ƃ��ĉ������B", MESSAGETYPE_NORMAL

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
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>��f��</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('cslYear', 'cslMonth', 'cslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:calGuide_clearDate('cslYear', 'cslMonth', 'cslDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
			<TD><%= EditNumberList("cslYear", YEARRANGE_MIN, YEARRANGE_MAX, strCslYear, True) %></TD>
			<TD>�N</TD>
			<TD><%= EditNumberList("cslMonth", 1, 12, strCslMonth, True) %></TD>
			<TD>��</TD>
			<TD><%= EditNumberList("cslDay", 1, 31, strCslDay, True) %></TD>
			<TD>��</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD WIDTH="120"></TD>
			<TD><FONT COLOR="#999999">�i�ȗ����͌_��J�n������f���Ƃ��Ĉꊇ�\����s���܂��B�j</FONT></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD><FONT COLOR="#ff0000">��</FONT></TD>
			<TD WIDTH="90" NOWRAP>���̑�</TD>
			<TD>�F</TD>
			<TD COLSPAN="2" NOWRAP>����_��p�^�[���̖���t��f��񂪂��łɑ��݂���ꍇ�̏�����I�����Ă��������B</TD>
		</TR>
		<TR>
			<TD COLSPAN="3"></TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><INPUT TYPE="radio" NAME="opMode" VALUE="0" <%= IIf(strOpMode = "0", "CHECKED", "") %>></TD>
						<TD NOWRAP>�������Ȃ�</TD>
					</TR>
					<TR>
						<TD><INPUT TYPE="radio" NAME="opMode" VALUE="1" <%= IIf(strOpMode = "1", "CHECKED", "") %>></TD>
						<TD NOWRAP>�L�����Z������</TD>
					</TR>
					<TR>
						<TD><INPUT TYPE="radio" NAME="opMode" VALUE="2" <%= IIf(strOpMode = "2", "CHECKED", "") %>></TD>
						<TD NOWRAP>�폜����</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

	<BR><BR>

	<A HREF="rsvAllMenu.asp"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�߂�"></A>
	<INPUT TYPE="image" NAME="reserve" SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="���̏����ŗ\�񂷂�">

	<BR><BR>

	<A HREF="/webHains/contents/maintenance/hainslog/dispHainsLog.asp?mode=print&transactionDiv=LOGRSVPER"><IMG SRC="/webHains/images/prevlog.gif" WIDTH="77" HEIGHT="24" ALT="���O���Q�Ƃ���"></A>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>