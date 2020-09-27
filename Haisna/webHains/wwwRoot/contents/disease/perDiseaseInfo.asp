<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   ���a�x�Ə��̓��� (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/EditNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�萔�̒�`
Const MODE_INSERT     = "insert"	'�������[�h(�}��)
Const MODE_UPDATE     = "update"	'�������[�h(�X�V)
Const ACTMODE_SAVE    = "save"		'���샂�[�h(�ۑ�)
Const ACTMODE_SAVED   = "saved"		'���샂�[�h(�ۑ�����)
Const ACTMODE_DELETE  = "delete"	'���샂�[�h(�폜)
Const ACTMODE_DELETED = "deleted"	'���샂�[�h(�폜����)

'COM�R���|�[�l���g
Dim objCommon			'���ʃN���X
Dim objDisease			'�a�����A�N�Z�X�p
Dim objFree				'�ėp���A�N�Z�X�p
Dim objPerson			'�l���A�N�Z�X�p
Dim objPerDisease		'���a�x�Ə��A�N�Z�X�p

'�����l
Dim strMode				'�������[�h(�}��:"insert"�A�X�V:"update")
Dim strActMode			'�������(�ۑ��{�^��������:"save"�A�ۑ�������:"saveend")
Dim strPerId			'�l�h�c
Dim lngDataYear			'�f�[�^�N
Dim lngDataMonth		'�f�[�^��
Dim strDisCd			'�a���R�[�h
Dim lngOccurYear		'���a�N
Dim lngOccurMonth		'���a��
Dim strHoliday			'�x�ɓ���
Dim strAbsence			'���Γ���
Dim strContinues		'�p���敪
Dim strMedicalDiv		'�×{�敪

'�l���
Dim strLastName			'��
Dim strFirstName		'��
Dim strLastKName		'�J�i��
Dim strFirstKName		'�J�i��
Dim strBirth			'���N����
Dim strAge				'�N��
Dim strGender			'����
Dim strOrgCd1			'�c�̃R�[�h�P
Dim strOrgCd2			'�c�̃R�[�h�Q
Dim strOrgSName			'�c�̗���
Dim strOrgPostName		'��������
Dim strJobName			'�E��

'���a�x�Ə��
Dim strArrOccurDate		'���a�N��
Dim strArrHoliday		'�x�ɓ���
Dim strArrAbsence		'���Γ���
Dim strArrContinues		'�p���敪
Dim strArrMedicalDiv	'�×{�敪
Dim lngCount			'���R�[�h��

Dim dtmDataDate			'�f�[�^�N��
Dim dtmOccurDate		'���a�N��
Dim strDisName			'�a��
Dim strArrMessage		'�G���[���b�Z�[�W
Dim strURL				'�W�����v���URL
Dim Ret					'�֐��߂�l

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon     = Server.CreateObject("HainsCommon.Common")
Set objPerDisease = Server.CreateObject("HainsPerDisease.PerDisease")

'�����l�̎擾
strMode       = Request("mode")
strActMode    = Request("actMode")
strPerId      = Request("perId")
lngDataYear   = CLng("0" & Request("dataYear"))
lngDataMonth  = CLng("0" & Request("dataMonth"))
strDisCd      = Request("disCd")
lngOccurYear  = CLng("0" & Request("occurYear"))
lngOccurMonth = CLng("0" & Request("occurMonth"))
strHoliday    = Request("holiday")
strAbsence    = Request("absence")
strContinues  = Request("continues")
strMedicalDiv = Request("medicalDiv")

'�����ȗ����̃f�t�H���g�l�ݒ�
strMode = IIf(strMode = "", MODE_INSERT, strMode)

If lngDataYear = 0 Or lngDataMonth = 0 Then
	lngDataYear  = Year(DateAdd("m", -1, Date))
	lngDataMonth = Month(DateAdd("m", -1, Date))
End If

If lngOccurYear = 0 Or lngOccurMonth = 0 Then
	lngOccurYear  = Year(DateAdd("m", -1, Date))
	lngOccurMonth = Month(DateAdd("m", -1, Date))
End If

strContinues  = IIf(strContinues  = "", "0", strContinues)
strMedicalDiv = IIf(strMedicalDiv = "", "0", strMedicalDiv)

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do

	'�폜�{�^��������
	If strActMode = ACTMODE_DELETE Then

		'�f�[�^�N���̐ݒ�
		dtmDataDate = CDate(lngDataYear & "/" & lngDataMonth & "/1")

		'���a�x�Ə��e�[�u�����R�[�h�폜
		Ret = objPerDisease.DeletePerDisease(dtmDataDate, strPerId, strDisCd)

		'�폜�ɐ��������ꍇ�͑}�����[�h�Ŏ������g���Ăяo��
		strURL = Request.ServerVariables("SCRIPT_NAME")
		strURL = strURL & "?mode="    & MODE_INSERT
		strURL = strURL & "&actMode=" & ACTMODE_DELETED
		Response.Redirect strURL
		Response.End

	End If

	'�ۑ��{�^��������
	If strActMode = "save" Then

		'���̓`�F�b�N
		strArrMessage = CheckValue()
		If Not IsEmpty(strArrMessage) Then
			Exit Do
		End If

		'�f�[�^�N���E���a�N���̐ݒ�
		dtmDataDate = CDate(lngDataYear & "/" & lngDataMonth & "/1")
		dtmOccurDate = CDate(lngOccurYear & "/" & lngOccurMonth & "/1")

		'�X�V�̏ꍇ
		If strMode = MODE_UPDATE Then

			'���a�x�Ə��e�[�u�����R�[�h�X�V
			Ret = objPerDisease.UpdatePerDisease(dtmDataDate, strPerId, strDisCd, dtmDataDate, strPerId, strDisCd, dtmOccurDate, strHoliday, strAbsence, strContinues, strMedicalDiv)

			'���R�[�h�����݂��Ȃ��ꍇ�͐V�K���̏������s��
			If Ret = 0 Then
				strMode = MODE_INSERT
			End If

		End If

		'�}���̏ꍇ
		If strMode = MODE_INSERT Then

			'���a�x�Ə��e�[�u�����R�[�h�}��
			Ret = objPerDisease.InsertPerDisease(dtmDataDate, strPerId, strDisCd, dtmOccurDate, strHoliday, strAbsence, strContinues, strMedicalDiv)

			'�L�[�d�����̓G���[���b�Z�[�W��ҏW����
			If Ret = INSERT_DUPLICATE Then
				strArrMessage = Array("����l�A�f�[�^�N���A�a���̏��a�x�Ə�񂪂��łɑ��݂��܂��B")
				Exit Do
			End If

		End If

		'�ۑ��ɐ��������ꍇ�͍X�V���[�h�Ŏ������g���Ăяo��
		strURL = Request.ServerVariables("SCRIPT_NAME")
		strURL = strURL & "?mode="      & MODE_UPDATE
		strURL = strURL & "&actMode="   & ACTMODE_SAVED
		strURL = strURL & "&dataYear="  & lngDataYear
		strURL = strURL & "&dataMonth=" & lngDataMonth
		strURL = strURL & "&perId="     & strPerId
		strURL = strURL & "&disCd="     & strDisCd
		Response.Redirect strURL
		Response.End

	End If

	'�V�K���[�h�̏ꍇ�͓ǂݍ��݂��s��Ȃ�
	If strMode = MODE_INSERT Then
		Exit Do
	End If

	'�f�[�^�N���̐ݒ�
	dtmDataDate = CDate(lngDataYear & "/" & lngDataMonth & "/1")

	'���a�x�Ə��e�[�u�����R�[�h�ǂݍ���
	lngCount = objPerDisease.SelectPerDisease("", dtmDataDate, strPerId, "", "", "", "", "", "", strDisCd, , , , , , , , , , , , , , , , , strArrOccurDate, strArrHoliday, strArrAbsence, strArrContinues, strArrMedicalDiv)
	If lngCount <= 0 Then
		Err.Raise 1000, , "���a�x�Ə�񂪑��݂��܂���B"
	End If

	lngOccurYear  = Year(strArrOccurDate(0))
	lngOccurMonth = Month(strArrOccurDate(0))
	strHoliday    = strArrHoliday(0)
	strAbsence    = strArrAbsence(0)
	strContinues  = strArrContinues(0)
	strMedicalDiv = strArrMedicalDiv(0)

	Exit Do
Loop
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �l���e�l�̑Ó����`�F�b�N���s��
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
	Dim strMessage		'�G���[���b�Z�[�W
	Dim i				'�C���f�b�N�X

	'�e�l�`�F�b�N����
	With objCommon

		'�l�h�c
		If strPerId = "" Then
			.AppendArray vntArrMessage, "�l��I�����ĉ������B"
		End If

		'�a��
		If strDisCd = "" Then
			.AppendArray vntArrMessage, "�a����I�����ĉ������B"
		End If

		'�x�ɓ����A���Γ���
		.AppendArray vntArrMessage, .CheckNumeric("�x�ɓ���", strHoliday, 2, CHECK_NECESSARY)
		.AppendArray vntArrMessage, .CheckNumeric("���Γ���", strAbsence, 2, CHECK_NECESSARY)

	End With

	'�߂�l�̕ҏW
	If IsArray(vntArrMessage) Then
		CheckValue = vntArrMessage
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
<TITLE>���a�x�Ə��̓���</TITLE>
<!-- #include virtual = "/WebHains/includes/diseaseGuide.inc" -->
<!-- #include virtual = "/WebHains/includes/perGuide.inc"     -->
<SCRIPT TYPE="text/javascript">
<!--
// �l�����K�C�h�Ăяo��
function callPersonGuide() {

	// �l�K�C�h�\��
	perGuide_showGuidePersonal( null, null, null, setPersonInfo );

}

// �l���̕ҏW
function setPersonInfo( perInfo ) {

	var myForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g

	var perName     = '';				// ����
	var perKName    = '';				// �J�i����
	var birthName   = '';				// ���N����
	var ageName     = '';				// �N��
	var genderName  = '';				// ����
	var isrSignName = '';				// ���ۋL��
	var isrNoName   = '';				// ���۔ԍ�
	var isrName     = '';				// ���ۋL���E�ԍ�
	var orgName     = '';				// �c�̖�
	var orgPostName = '';				// ������
	var jobName     = '';				// �E��

	// �����̕ҏW
	perName = '<B>' + perInfo.perName + '</B>';

	// �J�i�����̕ҏW
	perKName = '�i' + perInfo.perKName + '�j';

	// ���N�����E�N��̕ҏW
	birthName  = perInfo.birthJpn + '��';
	ageName    = perInfo.age + '��';
	genderName = ( perInfo.gender == '1' ? '�j��' : '����' );

	// �c�̖��̕ҏW
	if ( perInfo.orgSName != '' ) {
		orgName = '�c�́F' + perInfo.orgSName;
	}

	// �������̕ҏW
	if ( perInfo.orgPostName != '' ) {
		orgPostName = '�����F' + perInfo.orgPostName;
	}

	// �E���̕ҏW
	if ( perInfo.jobName != '' ) {
		jobName = '�E��F' + perInfo.jobName;
	}

	// �l���̕ҏW
	document.entryForm.perId.value = perInfo.perId;
	document.getElementById('dspPerId').innerHTML       = perInfo.perId;
	document.getElementById('dspPerName').innerHTML     = perName;
	document.getElementById('dspPerKName').innerHTML    = perKName;
	document.getElementById('dspBirth').innerHTML       = birthName;
	document.getElementById('dspAge').innerHTML         = ageName;
	document.getElementById('dspGender').innerHTML      = genderName;
	document.getElementById('dspOrgName').innerHTML     = orgName;
	document.getElementById('dspOrgPostName').innerHTML = orgPostName;
	document.getElementById('dspJobName').innerHTML     = jobName;

}

// �a�������K�C�h�Ăяo��
function callDiseaseGuide() {

	disGuide_showGuideDisease( document.entryForm.disCd, 'disName', '' , '', 'disDivName', null, false );

}

// �a���N���A
function clearDisease() {

	disGuide_clearDiseaseInfo( document.entryForm.disCd, 'disName', '', '', '', '' );

}

// submit���̏���
function submitForm( actMode ) {

	// �폜���͊m�F���b�Z�[�W��\��
	if ( actMode == '<%= ACTMODE_DELETE %>' ) {
		if ( !confirm( '���̏��a�x�Ə����폜���܂��B��낵���ł����H' ) ) {
			return;
		}
	}

	// ���샂�[�h���w�肵��submit
	document.entryForm.actMode.value = actMode;
	document.entryForm.submit();

}

function closeWindow() {

	perGuide_closeGuidePersonal();
	disGuide_closeGuideDisease();

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.mnttab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY ONUNLOAD="JavaScript:closeWindow()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="mode"    VALUE="<%= strMode %>">
	<INPUT TYPE="hidden" NAME="actMode" VALUE="">

	<!-- �\�� -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">��</SPAN><FONT COLOR="#000000">���a�x�Ə��̓���</FONT></B></TD>
		</TR>
	</TABLE>

	<!-- ����{�^�� -->
	<TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="650">
		<TR>
			<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD ALIGN="right">
				<TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0">
					<TR>
						<TD><A HREF="perDiseaseList.asp"><IMG SRC="/webhains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="������ʂɖ߂�܂�"></A></TD>
						<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="7" HEIGHT="5"></TD>
<%
						If strMode = "update" Then
%>
							<TD><A HREF="javascript:submitForm('<%= ACTMODE_DELETE %>')"><IMG SRC="/webhains/images/delete.gif" WIDTH="77" HEIGHT="24" ALT="���̏��a�x�Ə����폜���܂�"></A></TD>
							<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="7" HEIGHT="5"></TD>
							<TD><A HREF="<%= Request.ServerVariables("SCRIPT_NAME") %>?mode=<%= MODE_INSERT %>"><IMG SRC="/webhains/images/newrsv.gif" WIDTH="77" HEIGHT="24" ALT="�V�������a�x�Ə���o�^���܂�"></A></TD>
							<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="7" HEIGHT="5"></TD>
<%
						End If
%>
						<TD><A HREF="javascript:submitForm('<%= ACTMODE_SAVE %>')"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="���͂����f�[�^��ۑ����܂�"></A></TD>
						<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="7" HEIGHT="5"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="15"></TD>
		</TR>
	</TABLE>
<%
	'�ۑ��A�폜�������͊����ʒm���s���A�����Ȃ��΃G���[���b�Z�[�W��ҏW����
	Select Case strActMode
		Case ACTMODE_SAVED
			EditMessage "�ۑ����������܂����B", MESSAGETYPE_NORMAL
		Case ACTMODE_DELETED
			EditMessage "�폜���������܂����B", MESSAGETYPE_NORMAL
		Case Else
			EditMessage strArrMessage, MESSAGETYPE_WARNING
	End Select

	If strPerId <> "" Then

		'�l�e�[�u�����R�[�h�ǂݍ���
		Set objPerson = Server.CreateObject("HainsPerson.Person")
		objPerson.SelectPerson strPerId, strLastName,  strFirstName, strLastKName,  strFirstKName, strBirth,  strGender, strOrgCd1, strOrgCd2, , , strOrgSName, , , , , , , , strOrgPostName, , , strJobName

		'�N��v�Z
		Set objFree = Server.CreateObject("HainsFree.Free")
		strAge = objFree.CalcAge(strBirth)

	End If
%>
	<BR>

	<INPUT TYPE="hidden" NAME="perId" VALUE="<%= strPerId %>">

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
<%
			'�V�K�Ȃ�΃K�C�h�{�^����\��
			If strMode = "insert" Then
%>
				<TD><A HREF="JavaScript:callPersonGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�l�����K�C�h��\��"></A></TD>
<%
			Else
%>
				<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="21" ALT=""></TD>
<%
			End If
%>
			<TD NOWRAP><SPAN ID="dspPerId"><%= strPerId %></SPAN></TD>
			<TD NOWRAP>
				<SPAN ID="dspPerName"><%= IIf(strLastName & strFirstName <> "", "<B>" & Trim(strLastName & "�@" & strFirstName) & "</B>", "<FONT COLOR=""#999999"">�i�l��I�����ĉ������j</FONT>") %></SPAN>
				<SPAN ID="dspPerKName"><%= IIf(strLastKName & strFirstKName <> "", "�i" & Trim(strLastKName & "�@" & strFirstKName) & "�j", "") %></SPAN>&nbsp;
				<SPAN ID="dspBirth"><%= IIf(strBirth <> "", objCommon.FormatString(strBirth, "ge.m.d") & "��", "") %></SPAN>&nbsp;
				<SPAN ID="dspAge"><%= IIf(strAge <> "", Int(strAge) & "��", "") %></SPAN>&nbsp;
				<SPAN ID="dspGender"><%= IIf(strGender = "1", "�j��", IIf(strGender = "2", "����", "")) %></SPAN>
			</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD></TD>
			<TD NOWRAP>
				<SPAN ID="dspOrgName"><%= IIf(strOrgSName <> "", "�c�́F" & strOrgSName, "") %></SPAN>&nbsp;&nbsp;
				<SPAN ID="dspOrgPostName"><%= IIf(strOrgPostName <> "", "�����F" & strOrgPostName, "") %></SPAN>&nbsp;&nbsp;
				<SPAN ID="dspJobName"><%= IIf(strJobName <> "", "�E��F" & strJobName, "") %></SPAN>
			</TD>
		</TR>
	</TABLE>

	<BR>

	<INPUT TYPE="hidden" NAME="disCd"  VALUE="<%= strDisCd %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD NOWRAP>�f�[�^�N��</TD>
			<TD>�F</TD>
<%
			If strMode = MODE_UPDATE Then
%>
				<TD HEIGHT="24" NOWRAP><INPUT TYPE="hidden" NAME="dataYear" VALUE="<%= lngDataYear %>"><INPUT TYPE="hidden" NAME="dataMonth" VALUE="<%= lngDataMonth %>"><%= lngDataYear & "�N" & lngDataMonth & "��" %></TD>
<%
			Else
%>
				<TD>
					<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
						<TR>
							<TD><%= EditNumberList("dataYear", YEARRANGE_MIN, YEARRANGE_MAX, lngDataYear, False) %></TD>
							<TD>�N</TD>
							<TD><%= EditNumberList("dataMonth", 1, 12, lngDataMonth, False) %></TD>
							<TD>��</TD>
						</TR>
					</TABLE>
				</TD>
<%
			End If
%>
		</TR>
<%
		'�a���ǂݍ���
		If strDisCd <> "" Then
			Set objDisease = Server.CreateObject("HainsDisease.Disease")
			objDisease.SelectDisease strDisCd, strDisName
		End If
%>
		<TR>
			<TD NOWRAP>�a��</TD>
			<TD>�F</TD>
<%
			If strMode = MODE_UPDATE Then
%>
				<TD HEIGHT="24" NOWRAP><%= strDisName %></TD>
<%
			Else
%>
				<TD>
					<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
						<TR>
							<TD><A HREF="javascript:callDiseaseGuide()"><IMG SRC="/webHains/images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="�a�������K�C�h��\��"></A></TD>
							<TD><A HREF="javascript:clearDisease()"><IMG SRC="/webHains/images/delicon.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="�a�����N���A"></A></TD>
							<TD><SPAN ID="disName"><%= strDisName %></TD>
						</TR>
					</TABLE>
				</TD>
<%
			End If
%>
		</TR>
		<TR>
			<TD NOWRAP>���a�N��</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><%= EditNumberList("occurYear", YEARRANGE_MIN, YEARRANGE_MAX, lngOccurYear ,False) %></TD>
						<TD>�N</TD>
						<TD><%= EditNumberList("occurMonth", 1, 12, lngOccurMonth, False) %></TD>
						<TD>��</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>�x�ɓ���</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><INPUT TYPE="text" NAME="holiday" SIZE="2" MAXLENGTH="2" VALUE="<%= strHoliday %>"></TD>
						<TD>��</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>���Γ���</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><INPUT TYPE="text" NAME="absence" SIZE="2" MAXLENGTH="2" VALUE="<%= strAbsence %>"></TD>
						<TD>��</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>�p���敪</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><INPUT TYPE="radio" NAME="continues" VALUE="0" <%= IIf(strContinues = "0", "CHECKED", "") %>></TD>
						<TD NOWRAP>�V�K</TD>
						<TD><INPUT TYPE="radio" NAME="continues" VALUE="1" <%= IIf(strContinues = "1", "CHECKED", "") %>></TD>
						<TD NOWRAP>�p��</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>�×{�敪</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><INPUT TYPE="radio" NAME="medicalDiv" VALUE="0" <%= IIf(strMedicalDiv = "0", "CHECKED", "") %>></TD>
						<TD NOWRAP>����×{</TD>
						<TD><INPUT TYPE="radio" NAME="medicalDiv" VALUE="1" <%= IIf(strMedicalDiv = "1", "CHECKED", "") %>></TD>
						<TD NOWRAP>�ʉ@</TD>
						<TD><INPUT TYPE="radio" NAME="medicalDiv" VALUE="2" <%= IIf(strMedicalDiv = "2", "CHECKED", "") %>></TD>
						<TD NOWRAP>���@</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>