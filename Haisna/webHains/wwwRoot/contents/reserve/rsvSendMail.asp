<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�\��m�F���[�����M (Ver1.0.0)
'		AUTHER  : Tsutomu Takagi@RD
'-----------------------------------------------------------------------------
'----------------------------
'�C������
'----------------------------
'�Ǘ��ԍ��FSL-SN-Y0101-612
'�C�����@�F2013.3.5
'�S����  �FT.Takagi@RD
'�C�����e�F�V�K�쐬

Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objConsult			'��f���A�N�Z�X�p
Dim objOrganization		'�c�̏��A�N�Z�X�p
Dim objPerson			'�l���A�N�Z�X�p
Dim objSender			'���[�����M�R���|�[�l���g
Dim objTemplate			'���[���e���v���[�g���A�N�Z�X�p

'�����l
Dim strMode				'���샂�[�h
Dim lngStrYear			'��f�J�n�N
Dim lngStrMonth			'��f�J�n��
Dim lngStrDay			'��f�J�n��
Dim lngEndYear			'��f�I���N
Dim lngEndMonth			'��f�I����
Dim lngEndDay			'��f�I����
Dim strCsCd				'�R�[�X�R�[�h
Dim strOrgCd1			'�c�̃R�[�h1
Dim strOrgCd2			'�c�̃R�[�h2
Dim strPerId			'�lID
Dim lngStatus			'���(0:���ׂāA1:�����M�A2:���M�ς�)
Dim strTemplateCd		'�e���v���[�g�R�[�h
Dim strRsvNo			'�\��ԍ�
Dim lngSendCount		'���M����

'��f���
Dim strArrRsvNo			'�\��ԍ��̔z��
Dim strArrCslDate		'��f���̔z��
Dim strArrCsName		'�R�[�X���̂̔z��
Dim strArrWebColor		'web�J���[�̔z��
Dim strArrRsvGrpName	'�\��Q���̂̔z��
Dim strArrPerId			'�lID�̔z��
Dim strArrLastName		'���̔z��
Dim strArrFirstName		'���̔z��
Dim strArrLastKName		'�J�i���̔z��
Dim strArrFirstKName	'�J�i���̔z��
Dim strArrGender		'���ʂ̔z��
Dim strArrBirth			'���N�����̔z��
Dim strArrAge			'��f���N��̔z��
Dim strArrOrgSName		'�c�̗��̂̔z��
Dim strArrSendMailDiv	'�\��m�F���[�����M��̔z��
Dim strArrEmail			'e-Mail�̔z��
Dim strArrSendMailDate	'�\��m�F���[�����M�����̔z��
Dim lngCount			'���R�[�h����

'���[���e���v���[�g���
Dim strArrTemplateCd	'�e���v���[�g�R�[�h�̔z��
Dim strArrTemplateName	'�e���v���[�g���̔z��

Dim strOrgSName			'�c�̗���
Dim strLastName			'��
Dim strFirstName		'��
Dim strPerName			'�l����
Dim dtmStrCslDate		'�J�n��f�N����
Dim dtmEndCslDate		'�I����f�N����
Dim strSendMailDivName	'�\��m�F���[�����M�於
Dim blnEnabled			'��f���̑I����
Dim strUrl				'URL
Dim strMessage			'�G���[���b�Z�[�W
Dim strWkMessage		'���b�Z�[�W
Dim i					'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�����l�̎擾
strMode      = Request("mode")
lngStrYear   = CLng("0" & Request("strYear"))
lngStrMonth  = CLng("0" & Request("strMonth"))
lngStrDay    = CLng("0" & Request("strDay"))
lngEndYear   = CLng("0" & Request("endYear"))
lngEndMonth  = CLng("0" & Request("endMonth"))
lngEndDay    = CLng("0" & Request("endDay"))
strCsCd      = Request("csCd")
strOrgCd1    = Request("orgCd1")
strOrgCd2    = Request("orgCd2")
strPerId     = Request("perId")
lngStatus    = CLng("0" & Request("status"))
lngSendCount = CLng("0" & Request("count"))

'�����l�̎擾(�e���v���[�g�R�[�h�A�\��ԍ�)
strTemplateCd = Request("templateCd")
strRsvNo      = IIf(Request("rsvNo") <> "", ConvIStringToArray(Request("rsvNo")), Empty)

'��f�J�n�A�I�����̃f�t�H���g�l�ݒ�
lngStrYear  = IIf(lngStrYear  = 0, Year(Date),  lngStrYear)
lngStrMonth = IIf(lngStrMonth = 0, Month(Date), lngStrMonth)
lngStrDay   = IIf(lngStrDay   = 0, Day(Date),   lngStrDay)
lngEndYear  = IIf(lngEndYear  = 0, Year(Date),  lngEndYear)
lngEndMonth = IIf(lngEndMonth = 0, Month(Date), lngEndMonth)
lngEndDay   = IIf(lngEndDay   = 0, Day(Date),   lngEndDay)

'�c�̖��̂̎擾
If strOrgCd1 <> "" And strOrgCd2 <> "" Then
	Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
	objOrganization.SelectOrgSName strOrgCd1, strOrgCd2, strOrgSName
	Set objOrganization = Nothing
End If

'�l�����̎擾
If strPerId <> "" Then
	Set objPerson = Server.CreateObject("HainsPerson.Person")
	objPerson.SelectPerson_lukes strPerId, strLastName, strFirstName
	strPerName = strLastName & "�@" & strFirstName
End If

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do

	'���[�h���w�莞�͉������Ȃ�
	If strMode <> "search" And strMode <> "send" And strMode <> "complete" Then
		strMode = ""
		Exit Do
	End If

	'���t�`�F�b�N
	If Not IsDate(lngStrYear & "/" & lngStrMonth & "/" & lngStrDay) Or Not IsDate(lngEndYear & "/" & lngEndMonth & "/" & lngEndDay) Then
		strMessage = "��f��������������܂���B"
		Exit Do
	End If

	'���M��
	If strMode = "send" Then

		'�\��m�F���[�����M����
		Set objSender = Server.CreateObject("HainsMail.Sender")
		lngSendCount = objSender.Send(Session("USERID"), strTemplateCd, strRsvNo)

		'���_�C���N�g
		strUrl = Request.ServerVariables("SCRIPT_NAME") & _
		         "?mode=complete" & _
		         "&orgCd1="   & strOrgCd1   & _
		         "&orgCd2="   & strOrgCd1   & _
		         "&perId="    & strPerId    & _
		         "&strYear="  & lngStrYear  & _
		         "&strMonth=" & lngStrMonth & _
		         "&strDay="   & lngStrDay   & _
		         "&endYear="  & lngEndYear  & _
		         "&endMonth=" & lngEndMonth & _
		         "&endDay="   & lngEndDay   & _
		         "&csCd="     & strCsCd     & _
		         "&status="   & lngStatus   & _
		         "&count="    & lngSendCount
		Response.Redirect strUrl
		Response.End

	End If

	'�e��N�����̕ҏW
	dtmStrCslDate = CDate(lngStrYear & "/" & lngStrMonth & "/" & lngStrDay)
	dtmEndCslDate = CDate(lngEndYear & "/" & lngEndMonth & "/" & lngEndDay)

	Set objConsult = Server.CreateObject("HainsMail.Consult")

	'��f���̌���
	lngCount = objConsult.SelectConsultList( _
		dtmStrCslDate,     _
		dtmEndCslDate,     _
		strCsCd,           _
		strOrgCd1,         _
		strOrgCd2,         _
		strPerId,          _
		lngStatus,         _
		strArrRsvNo,       _
		strArrCslDate,     _
		strArrCsName,      _
		strArrWebColor,    _
		strArrRsvGrpName,  _
		strArrPerId,       _
		strArrLastName,    _
		strArrFirstName,   _
		strArrLastKName,   _
		strArrFirstKName,  _
		strArrGender,      _
		strArrBirth,       _
		strArrAge,         _
		strArrOrgSName,    _
		strArrSendMailDiv, _
		strArrEmail,       _
		strArrSendMailDate _
	)

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
<TITLE>�\��m�F���[�����M</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<!-- #include virtual = "/webHains/includes/perGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// �c�̃K�C�h��ʌĂяo��
function callOrgGuide() {

	orgGuide_showGuideOrg( document.entryForm.orgCd1, document.entryForm.orgCd2, null, 'orgname', null, null, null, null, '0' );

}

// �c�̃N���A
function clearOrgCd() {

	orgGuide_clearOrgInfo(document.entryForm.orgCd1, document.entryForm.orgCd2, 'orgname');

}

// �l�K�C�h��ʌĂяo��
function callPersonalGuide() {

	perGuide_showGuidePersonal(document.entryForm.perId, 'perName');

}

// �l�N���A
function clearPerId() {

	perGuide_clearPerInfo(document.entryForm.perId, 'perName');

}

// ��ʂ����
function closeWindow() {

	// ���t�K�C�h�����
	calGuide_closeGuideCalendar();

	// �c�̌����K�C�h�����
	orgGuide_closeGuideOrg();

	// �l�����K�C�h�����
	perGuide_closeGuidePersonal();

}

function selectList(checkbox) {

	var rsvNo = document.listForm.rsvNo;

	if ( rsvNo.length !== undefined ) {
		for ( var i = 0; i < rsvNo.length; i++ ) {
			if ( !rsvNo[i].disabled ) {
				rsvNo[i].checked = checkbox.checked;
			}
		}
	} else {
		rsvNo.checked = checkbox.checked;
	}

}

function sendMail() {

	var form = document.listForm;
	var count = 0;
	var message;

	while ( true ) {

		// �e���v���[�g�I����Ԃ𔻒�
		if ( form.templateCd.selectedIndex < 0 ) {
			message = '�e���v���[�g���I������Ă��܂���B';
			break;
		}

		var rsvNo = form.rsvNo;

		// �I�����ꂽ��f��񐔂��J�E���g
		if ( rsvNo.length !== undefined ) {
			for ( var i = 0; i < rsvNo.length; i++ ) {
				if ( rsvNo[i].checked ) {
					count++;
				}
			}
		} else {
			if ( rsvNo.checked ) {
				count = 1;
			}
		}

		// ���I���ł���Ύ��s�s�Ƃ���
		if ( count <= 0 ) {
			message = '��f��񂪑I������Ă��܂���B';
			break;
		}

		break;

	}

	if ( message ) {
		alert(message);
		return false;
	}

	// �m�F���b�Z�[�W�̕\��
	if ( !confirm('�I�����ꂽ' + count + '���̎�f���ɑ΂��Ċm�F���[���𑗐M���܂��B\n��낵���ł����H') ) {
		return false;
	}

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.rsvtab { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BLOCKQUOTE>
	<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
		<INPUT TYPE="hidden" NAME="mode" VALUE="search">
		<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
		<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">
		<INPUT TYPE="hidden" NAME="perId" VALUE="<%= strPerId %>">
		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="70%">
			<TR>
				<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000">�\��m�F���[�����M</FONT></B></TD>
			</TR>
		</TABLE>
<%
		'���b�Z�[�W�̕ҏW
		If strMode = "complete" Then
			If lngSendCount > 0 Then
				strWkMessage = lngSendCount & "���̗\��m�F���[�������M����܂����B"
			Else
				strWkMessage = "�\��m�F���[���͑��M����܂���ł����B"
			End If
			EditMessage "���M�������������܂����B" & strWkMessage, MESSAGETYPE_NORMAL
		Else
			EditMessage strMessage, MESSAGETYPE_WARNING
		End If
%>
		<BR>

		<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
			<TR>
				<TD>��f��</TD>
				<TD>�F</TD>
				<TD>
					<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
						<TR>
							<TD><A HREF="javascript:calGuide_showGuideCalendar('strYear', 'strMonth', 'strDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
							<TD><%= EditNumberList("strYear", YEARRANGE_MIN, YEARRANGE_MAX, lngStrYear, False) %></TD>
							<TD>�N</TD>
							<TD><%= EditNumberList("strMonth", 1, 12, lngStrMonth, False) %></TD>
							<TD>��</TD>
							<TD><%= EditNumberList("strDay", 1, 31, lngStrDay, False) %></TD>
							<TD NOWRAP>���`</TD>
							<TD><A HREF="javascript:calGuide_showGuideCalendar('endYear', 'endMonth', 'endDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
							<TD><%= EditNumberList("endYear", YEARRANGE_MIN, YEARRANGE_MAX, lngEndYear, False) %></TD>
							<TD>�N</TD>
							<TD><%= EditNumberList("endMonth", 1, 12, lngEndMonth, False) %></TD>
							<TD>��</TD>
							<TD><%= EditNumberList("endDay", 1, 31, lngEndDay, False) %></TD>
							<TD>��</TD>
						</TR>
					</TABLE>
				</TD>
				<TD ROWSPAN="5" STYLE="vertical-align:bottom"><INPUT TYPE="image" SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="�\��"></A></TD>
			</TR>
			<TR>
				<TD>�R�[�X</TD>
				<TD>�F</TD>
				<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd", strCsCd, SELECTED_ALL, False) %></TD>
			</TR>
			<TR>
				<TD NOWRAP>�c��</TD>
				<TD>�F</TD>
				<TD>
					<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
						<TR>
							<TD><A HREF="javascript:callOrgGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
							<TD><A HREF="javascript:clearOrgCd()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
							<TD NOWRAP><SPAN ID="orgname"><%= strOrgSName %></SPAN></TD>
						</TR>
					</TABLE>
				</TD>
			</TR>
			<TR>
				<TD NOWRAP>�lID</TD>
				<TD>�F</TD>
				<TD>
					<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
						<TR>
							<TD><A HREF="javascript:callPersonalGuide()"><IMG SRC="/webHains/images/question.gif" ALT="�l�����K�C�h��\��" HEIGHT="21" WIDTH="21"></A></TD>
							<TD><A HREF="javascript:clearPerId()"><IMG SRC="/webHains/images/delicon.gif" ALT="�ݒ肵���l���N���A" HEIGHT="21" WIDTH="21"></TD>
							<TD NOWRAP><SPAN ID="perName"><%= strPerName %></SPAN></TD>
						</TR>
					</TABLE>
				<TD>
			</TR>
			<TR>
				<TD NOWRAP>���</TD>
				<TD>�F</TD>
				<TD>
					<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
						<TR>
							<TD><INPUT TYPE="radio" NAME="status" VALUE="0" <%= IIf(lngStatus = 0, " CHECKED", "") %>></TD>
							<TD NOWRAP>���ׂ�</TD>
							<TD><INPUT TYPE="radio" NAME="status" VALUE="1" <%= IIf(lngStatus = 1, " CHECKED", "") %>></TD>
							<TD NOWRAP>�����M</TD>
							<TD><INPUT TYPE="radio" NAME="status" VALUE="2" <%= IIf(lngStatus = 2, " CHECKED", "") %>></TD>
							<TD NOWRAP>���M�ς�</TD>
						</TR>
					</TABLE>
				<TD>
			</TR>
		</TABLE>
	</FORM>
<%
	Do

		'���[�h���w�莞�͉������Ȃ�
		If strMode = "" Then
			Exit Do
		End If

		'�G���[���͉������Ȃ�
		If Not IsEmpty(strMessage) Then
			Exit Do
		End If

		'���R�[�h�����݂��Ȃ��ꍇ
		If lngCount <= 0 Then
%>
			<BR>���������𖞂�����f���͑��݂��܂���B
<%
			Exit Do
		End If

		'���[���e���v���[�g�ꗗ�ǂݍ���
		Set objTemplate = Server.CreateObject("HainsMail.Template")
		objTemplate.SelectMailTemplateList strArrTemplateCd, strArrTemplateName

		Set objCommon = Server.CreateObject("HainsCommon.Common")
%>
		�u<FONT COLOR="#ff6600"><B><%= objCommon.FormatString(dtmStrCslDate, "yyyy�Nm��d��") %>�`<%= objCommon.FormatString(dtmEndCslDate, "yyyy�Nm��d��") %></B></FONT>�v�̎�f�҈ꗗ��\�����Ă��܂��B<BR>
		��f�Ґ��� <FONT COLOR="#FF6600"><B><%= lngCount %></B></FONT>�l�ł��B<BR>
		<FORM NAME="listForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post" ONSUBMIT="javascript:return sendMail();">
			<INPUT TYPE="hidden" NAME="mode" VALUE="send">
			<INPUT TYPE="hidden" NAME="strYear" VALUE="<%= lngStrYear %>">
			<INPUT TYPE="hidden" NAME="strMonth" VALUE="<%= lngStrMonth %>">
			<INPUT TYPE="hidden" NAME="strDay" VALUE="<%= lngStrDay %>">
			<INPUT TYPE="hidden" NAME="endYear" VALUE="<%= lngEndYear %>">
			<INPUT TYPE="hidden" NAME="endMonth" VALUE="<%= lngEndMonth %>">
			<INPUT TYPE="hidden" NAME="endDay" VALUE="<%= lngEndDay %>">
			<INPUT TYPE="hidden" NAME="csCd" VALUE="<%= strCsCd %>">
			<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
			<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">
			<INPUT TYPE="hidden" NAME="perId" VALUE="<%= strPerId %>">
			<INPUT TYPE="hidden" NAME="status" VALUE="<%= lngStatus %>">
			<TABLE>
				<TR>
					<TD COLSPAN="14">
						<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0" WIDTH="100%">
							<TR>
								<TD NOWRAP>���[���e���v���[�g��I���F</TD>
								<TD><%= EditDropDownListFromArray("templateCd", strArrTemplateCd, strArrTemplateName, strTemplateCd, NON_SELECTED_DEL) %></TD>
								<td  WIDTH="100%" >�@<a href="/webHains/contents/maintenance/hainslog/dispHainsLog.asp?startPos=1&mode=print&transactionDiv=LOGRSVSEND&Year=<%= Year(Date) %>&Month=<%= Month(Date) %>&Day=<%= Day(Date) %>&transactionID=&searchChar=&informationDiv=&OrderByOld=&pageMaxLine=50
" target="_blank">���[�����M���O��\������</a><td>
								<TD ALIGN="right"><INPUT TYPE="image" SRC="/webHains/images/send.gif" ALT="���M"></TD>
							</TR>
						</TABLE>
					</TD>
				</TR>
				<TR BGCOLOR="#cccccc">
					<TD><INPUT TYPE="checkbox" ONCLICK="javascript:selectList(this)"></TD>
					<TD>��f��</TD>
					<TD>�R�[�X</TD>
					<TD>�\��Q</TD>
					<TD>�\��ԍ�</TD>
					<TD>�lID</TD>
					<TD>�l����</TD>
					<TD>��</TD>
					<TD>���N����</TD>
					<TD>�N��</TD>
					<TD>�c��</TD>
					<TD>���M�Ώ�</TD>
					<TD>���[���A�h���X</TD>
					<TD>�ŏI���M����</TD>
				</TR>
<%
				For i = 0 To lngCount - 1

					blnEnabled = True

					'�\��m�F���[�����M��̖��̕ϊ��A�y�ю�f���̑I���۔���
					Select Case strArrSendMailDiv(i)
						Case 1
							strSendMailDivName = "�Z���i����j"
						Case 2
							strSendMailDivName = "�Z���i�Ζ���j"
						Case 3
							strSendMailDivName = "�Z���i���̑��j"
						Case Else
							strSendMailDivName = "�Ȃ�"
							blnEnabled = False
					End Select

					'���[���A�h���X�����݂��Ȃ��ꍇ�͎�f���I��s��
					If strArrEmail(i) = "" Then
						blnEnabled = False
					End If
%>
					<TR BGCOLOR="#<%= IIf(i Mod 2 = 0, "ffffff", "eeeeee") %>" VALIGN="top">
						<TD><INPUT TYPE="checkbox" NAME="rsvNo" VALUE="<%= strArrRsvNo(i) %>"<%= IIf(Not blnEnabled, " DISABLED", "") %>></TD>
<%
						strUrl = "/webHains/contents/reserve/rsvMain.asp?rsvNo=" & strArrRsvNo(i)
%>
						<TD NOWRAP><A HREF="<%= strUrl %>" TARGET="_blank"><%= strArrCslDate(i) %></A></TD>
						<TD NOWRAP><FONT COLOR="#<%= strArrWebColor(i) %>">��</FONT><%= strArrCsName(i) %></TD>
						<TD NOWRAP><%= strArrRsvGrpName(i) %></TD>
						<TD NOWRAP><a href="<%= strUrl %>" target="_blank"><%= strArrRsvNo(i) %></a></TD>
<%
						strUrl = "/webHains/contents/maintenance/personal/mntPersonal.asp?mode=update&perid=" & strArrPerId(i)
%>
						<TD NOWRAP><A HREF="<%= strUrl %>" TARGET="_blank"><%= strArrPerId(i) %></A></TD>
						<TD NOWRAP><SPAN STYLE="font-size:9px;"><%= Trim(strArrLastKName(i) & "�@" & strArrFirstKName(i)) %><BR></SPAN><%= Trim(strArrLastName(i) & "�@" & strArrFirstName(i)) %></TD>
						<TD NOWRAP><%= IIf(strArrGender(i) ="1", "�j", "��") %></TD>
						<TD NOWRAP><%= objCommon.FormatString(strArrBirth(i), "gee.mm.dd") %></TD>
						<TD NOWRAP ALIGN="right"><%= Int(strArrAge(i)) %>��</TD>
						<TD NOWRAP><%= strArrOrgSName(i) %></TD>
						<TD><%= strSendMailDivName %></TD>
						<TD><%= strArrEmail(i) %></TD>
						<TD><%= strArrSendMailDate(i) %></TD>
					</TR>
<%
				Next
%>
			</TABLE>
		</FORM>
<%
		Exit Do
	Loop
%>
</BLOCKQUOTE>
</BODY>
</HTML>
