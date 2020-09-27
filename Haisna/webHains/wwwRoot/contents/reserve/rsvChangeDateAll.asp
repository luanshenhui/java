<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   ��f���ꊇ�ύX (Ver0.0.1)
'	   AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const DEFAULT_ROW    = 0	'�f�t�H���g�\���s��
Const INCREASE_COUNT = 5	'�\���s���̑����P��

Const MODE_NORMAL      = "0"	'�\��l���ċA�������[�h(�ʏ팟��)
Const MODE_SAME_RSVGRP = "1"	'�\��l���ċA�������[�h(�����\��Q�O���[�v�Ō���)

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objConsult			'��f���A�N�Z�X�p

'�����l
Dim strRsvNo			'�\��ԍ�

'���A��l���
Dim strFriCslDate		'��f��
Dim strFriSeq			'�r�d�p
Dim strFriRsvNo			'�\��ԍ�
Dim strFriPerId			'�l�h�c
Dim strFriCsCd			'�R�[�X�R�[�h
Dim strFriCsName		'�R�[�X��
Dim strFriOrgSName		'�c�̗���
Dim strFriLastName		'��
Dim strFriFirstName		'��
Dim strFriLastKName		'�J�i��
Dim strFriFirstKName	'�J�i��
Dim strFriDayId			'�����h�c
Dim strFriRsvGrpCd		'�\��Q�R�[�h
Dim strFriRsvGrpName	'�\��Q����
Dim strFriCancelFlg		'�L�����Z���t���O
Dim lngFriCount			'���A��l���R�[�h��

Dim strCslDate			'��f��
Dim Ret					'�֐��߂�l
Dim i					'�C���f�b�N�X

dim lngdispcnt

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
strRsvNo = Request("rsvNo")

Set objConsult = Server.CreateObject("HainsConsult.Consult")

'��f����ǂ݁A���݂̎�f�����擾
Ret = objConsult.SelectConsult(strRsvNo, , strCslDate)

Set objConsult = Nothing

If Ret = False Then
	Err.Raise 1000, , "��f��񂪑��݂��܂���B"
End If

Sub EditRsvGrp(strCsCd, strRsvGrpCd)

	Dim objSchedule			'�X�P�W���[�����A�N�Z�X�p

	Dim strArrRsvGrpCd		'�\��Q�R�[�h
	Dim strArrRsvGrpName	'�\��Q����
	Dim lngRsvGrpCount		'�\��Q��

	Dim i					'�C���f�b�N�X
%>
	<SELECT NAME="rsvGrpCd">
		<OPTION VALUE="">&nbsp;
<%
		'�I�u�W�F�N�g�̃C���X�^���X�쐬
		Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")

		'���t���V�X�e�����t���܂ވȍ~�̏ꍇ�̓R�[�X�ŗL���ȌQ���A�ߋ����̏ꍇ�͂��ׂĂ̌Q���擾
		If CDate(strCslDate) >= Date() Then

			'�w��R�[�X�ɂ�����L���ȗ\��Q�R�[�X��f�\��Q�������ɓǂݍ���
			lngRsvGrpCount = objSchedule.SelectCourseRsvGrpListSelCourse(strCsCd, 0, strArrRsvGrpCd, strArrRsvGrpName)

		Else

			'���ׂĂ̗\��Q��ǂݍ���
			lngRsvGrpCount = objSchedule.SelectRsvGrpList(0, strArrRsvGrpCd, strArrRsvGrpName)

		End If

		Set objSchedule = Nothing

		'�z��Y�������̃��X�g��ǉ�
		For i = 0 To lngRsvGrpCount - 1
%>
			<OPTION VALUE="<%= strArrRsvGrpCd(i) %>"<%= IIf(strArrRsvGrpCd(i) = strRsvGrpCd, " SELECTED", "") %>><%= strArrRsvGrpName(i) %>
<%
		Next
%>
	</SELECT>
<%
End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>��f���ꊇ�ύX</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
var winCalendar;		// �J�����_�[�������

// �J�����_�[������ʌĂяo��
function callCalendar() {

	// �p�����[�^�ҏW�J�n
	var objForm  = document.entryForm;
	var rsvNo    = '';
	var rsvGrpCd = '';
	var sep      = '';

	var rsvGrpCount   = 0;
	var noRsvGrpCount = 0;

	// �����\�ȏ��������݂��Ȃ��ꍇ�͏I��(�G�������g���̂����݂��Ȃ��ꍇ)
	if ( objForm.rsvNo == null ) {
		alert('�����\�ȏ��������݂��܂���B');
		return;
	}

	// �v�f�̒ǉ�
	if ( objForm.rsvNo.length != null ) {

		// �z��̌���
		for ( var i = 0; i < objForm.rsvNo.length; i++ ) {

			// �ύX�Ώۂ̎�f���ł����
			if ( objForm.rsvNo[ i ].checked ) {

				// �ǉ�
				rsvNo    = rsvNo    + sep + objForm.rsvNo[ i ].value;
				rsvGrpCd = rsvGrpCd + sep + objForm.rsvGrpCd[ i ].value;
				sep      = '\x01';

				// �\��Q�w�萔�E���w�萔���J�E���g
				if ( objForm.rsvGrpCd[ i ].value != '' ) {
					rsvGrpCount++;
				} else {
					noRsvGrpCount++;
				}

			}
		}

	} else {

		rsvNo    = objForm.rsvNo.value;
		rsvGrpCd = objForm.rsvGrpCd.value;

	}

	// �����\�ȏ��������݂��Ȃ��ꍇ�͏I��(�I�����ꂽ�v�f�����݂��Ȃ��ꍇ)
	if ( rsvNo == '' ) {
		alert('�����\�ȏ��������݂��܂���B');
		return;
	}

	// ���߂����Ԙg�Ō�������ꍇ
	if ( objForm.nearly.checked ) {

		// �\��Q�w�萔�E���w�萔���Ƃ��ɑ��݂���ꍇ�͌����ł��Ȃ�
		if ( rsvGrpCount > 0 && noRsvGrpCount > 0 ) {
			alert('���߂����Ԙg�Ō�������ꍇ�A�\��Q�͑S�Đݒ肷�邩�A�������͑S�Ė��w���ԂŌ������Ă��������B');
			return;
		}

	}

	var opened = false;	// ��ʂ��J����Ă��邩

	// ���łɉ�ʂ��J����Ă��邩�`�F�b�N
	if ( winCalendar != null ) {
		if ( !winCalendar.closed ) {
			opened = true;
		}
	}

	// �J����Ă���ꍇ
	if ( opened ) {

		// �t�H�[�J�X�ړ�
		winCalendar.focus();

	// �J����Ă��Ȃ��ꍇ
	} else {

		// ��΂ɏd�����Ȃ��E�B���h�E�������ݎ��Ԃ���쐬
		var d = new Date();
		var windowName = 'W' + d.getHours() + d.getMinutes() + d.getSeconds() + d.getMilliseconds();

		// �V�K��ʂ��J��
		winCalendar = open('', windowName, 'status=yes,directories=no,menubar=no,resizable=yes,scrollbars=yes,toolbar=no,location=no,width=700,height=500');

	}

	// �G�������g�ւ̕ҏW
	var paraForm = document.paramForm;

	// �������[�h�̌���
	if ( objForm.nearly.checked ) {
		paraForm.mode.value = '<%= MODE_SAME_RSVGRP %>';
	} else {
		paraForm.mode.value = '<%= MODE_NORMAL %>';
	}

	paraForm.cslYear.value  = objForm.cslYear.value;
	paraForm.cslMonth.value = objForm.cslMonth.value;
	paraForm.rsvNo.value    = rsvNo;
	paraForm.rsvGrpCd.value = rsvGrpCd;

	// �^�[�Q�b�g���w�肵��submit
	document.paramForm.target = winCalendar.name;
	document.paramForm.submit();

}

// �{��ʂ����ۂ̏���
function closeWindow() {

	// �J�����_�[������ʂ��J����Ă���ꍇ�͓����ɕ���
	if ( winCalendar != null ) {
		if ( !winCalendar.closed ) {
			winCalendar.close();
		}
	}

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><SPAN CLASS="reserve">��</SPAN><B>��f���ꊇ�ύX</B></TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
	<TR>
		<TD NOWRAP>����f���F</TD>
		<TD NOWRAP COLSPAN="7"><B><%= Year(strCslDate) %>�N<%= Month(strCslDate) %>��<%= Day(strCslDate) %>��</B></TD>
	</TR>
	<TR>
		<TD HEIGHT="5"></TD>
	</TR>
	<TR>
		<TD NOWRAP>�����N���F</TD>
		<TD><%= EditNumberList("cslYear", YEARRANGE_MIN, YEARRANGE_MAX, Year(strCslDate), False) %></TD>
		<TD>�N</TD>
		<TD><%= EditNumberList("cslMonth", 1, 12, Month(strCslDate), False) %></TD>
		<TD>��</TD>
		<TD>&nbsp;&nbsp;<INPUT TYPE="checkbox" NAME="nearly" CHECKED></TD>
		<TD NOWRAP>���߂����Ԙg�Ō���</TD>
		<TD>&nbsp;&nbsp;<A HREF="javascript:callCalendar()"><IMG SRC="/webHains/images/findrsv.gif" WIDTH="77" HEIGHT="24" ALT="���̏����Ŋm��"></A></TD>
	</TR>
</TABLE>
<%
Set objConsult = Server.CreateObject("HainsConsult.Consult")

'���A��l���ǂݍ���
lngFriCount = objConsult.SelectFriends(strCslDate, strRsvNo, strFriCslDate, strFriSeq, strFriRsvNo, , , , strFriPerId, strFriCsCd, strFriCsName, , , , strFriOrgSName, strFriLastName, strFriFirstName, strFriLastKName, strFriFirstKName, strFriDayId, strFriRsvGrpName, , strFriCancelFlg, strFriRsvGrpCd)

Set objConsult = Nothing

'���A��l��񂪂Ȃ��Ƃ��A�ʏ�A��f�Җ{�l�̃��R�[�h���P���K���Ԃ�B����Ă��ꂷ��Ȃ��ꍇ�̓G���[�B
If lngFriCount <= 0 Then
	Err.Raise 1000, , "��f��񂪑��݂��܂���B"
End If
%>
<BR>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
	<TR>
		<TD NOWRAP><FONT COLOR="#cc9999">��</FONT>�܂Ƃ߂Ď�f���ύX���s����f�҂������Ŏw�肵�Ă��������B</TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLSPACING="3" CELLPADDING="0">
	<TR>
		<TD NOWRAP>����^���</TD>
		<TD NOWRAP WIDTH="10"></TD>
		<TD NOWRAP>�l�h�c</TD>
		<TD NOWRAP WIDTH="10"></TD>
		<TD NOWRAP>����</TD>
		<TD NOWRAP WIDTH="10"></TD>
		<TD NOWRAP>�\��ԍ�</TD>
		<TD NOWRAP WIDTH="10"></TD>
		<TD NOWRAP>��f�c��</TD>
		<TD NOWRAP WIDTH="10"></TD>
		<TD NOWRAP>��f�R�[�X</TD>
		<TD NOWRAP WIDTH="10"></TD>
		<TD NOWRAP>�\��Q</TD>
	</TR>
	<TR>
		<TD COLSPAN="13" BGCOLOR="#999999"><IMG SRC="/webHains/images/spacer.gif" ALT="" HEIGHT="1" WIDTH="1"></TD>
	</TR>
<%
	'��f�Җ{�l���ŏ��ɕҏW
	For i = 0 To lngFriCount - 1

		'��f�Җ{�l���ŏ��ɕҏW
		If strFriRsvNo(i) = strRsvNo Then
%>
			<TR>
<%
				Select Case True

					Case strFriDayId(i) <> ""
%>
						<TD NOWRAP>��t�ς�</TD>
<%
					Case strFriCancelFlg(i) <> CStr(CONSULT_USED)
%>
						<TD NOWRAP>�L�����Z��</TD>
<%
					Case Else
%>
						<TD>
							<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
								<TR>
									<TD><INPUT TYPE="checkbox" NAME="rsvNo" VALUE="<%= strFriRsvNo(i) %>" CHECKED ONCLICK="javascript:this.checked = true"></TD>
									<TD NOWRAP>�ύX����</TD>
								</TR>
							</TABLE>
						</TD>
<%
				End Select
%>
				<TD></TD>
				<TD NOWRAP><%= strFriPerId(i) %></TD>
				<TD></TD>
				<TD NOWRAP><B><%= Trim(strFriLastName(i) & "�@" & strFriFirstName(i)) %></B><FONT SIZE="-1">�i<%= Trim(strFriLastKname(i) & "�@" & strFriFirstKName(i)) %>�j</FONT></TD>
				<TD></TD>
				<TD NOWRAP><%= strFriRsvNo(i) %></TD>
				<TD></TD>
				<TD NOWRAP><%= strFriOrgSName(i) %></TD>
				<TD></TD>
				<TD NOWRAP><%= strFriCsName(i) %></TD>
				<TD></TD>
				<TD><% EditRsvGrp strFriCsCd(i), strFriRsvGrpCd(i) %></TD>
			</TR>
<%
			Exit For
		End If

	Next

	'���g�ȊO�̏��A�������A��l�����݂���ꍇ
	If lngFriCount > 1 Then
%>
		<TR>
			<TD COLSPAN="13" NOWRAP><BR>���A��l�̈ꗗ</TD>
		</TR>
		<TR>
			<TD COLSPAN="13" BGCOLOR="#999999"><IMG SRC="/webHains/images/spacer.gif" ALT="" HEIGHT="1" WIDTH="1"></TD>
		</TR>
<%
		'���A��l�ꗗ�̕ҏW
		For i = 0 To lngFriCount - 1

			'��f�Җ{�l�̏��͏����ҏW
			If strFriRsvNo(i) <> strRsvNo Then
%>
				<TR>
<%
					Select Case True

						Case strFriDayId(i) <> ""
%>
							<TD NOWRAP>��t�ς�</TD>
<%
						Case strFriCancelFlg(i) <> CStr(CONSULT_USED)
%>
							<TD NOWRAP>�L�����Z��</TD>
<%
						Case Else
%>
							<TD>
								<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
									<TR>
										<TD><INPUT TYPE="checkbox" NAME="rsvNo" VALUE="<%= strFriRsvNo(i) %>" CHECKED></TD>
										<TD NOWRAP>�ύX����</TD>
									</TR>
								</TABLE>
							</TD>
<%
					End Select
%>
					<TD></TD>
					<TD NOWRAP><%= strFriPerId(i) %></TD>
					<TD></TD>
					<TD NOWRAP><B><%= Trim(strFriLastName(i) & "�@" & strFriFirstName(i)) %></B><FONT SIZE="-1">�i<%= Trim(strFriLastKname(i) & "�@" & strFriFirstKName(i)) %>�j</FONT></TD>
					<TD></TD>
					<TD NOWRAP><%= strFriRsvNo(i) %></TD>
					<TD></TD>
					<TD NOWRAP><%= strFriOrgSName(i) %></TD>
					<TD></TD>
					<TD NOWRAP><%= strFriCsName(i) %></TD>
					<TD></TD>
					<TD><% EditRsvGrp strFriCsCd(i), strFriRsvGrpCd(i) %></TD>
				</TR>
<%
			End If

		Next

	End If
%>
</TABLE>
</FORM>
<FORM NAME="paramForm" ACTION="/webHains/contents/frameReserve/fraRsvCalendarFromRsvNo.asp" METHOD="post">
	<INPUT TYPE="hidden" NAME="mode">
	<INPUT TYPE="hidden" NAME="cslYear">
	<INPUT TYPE="hidden" NAME="cslMonth">
	<INPUT TYPE="hidden" NAME="rsvNo">
	<INPUT TYPE="hidden" NAME="rsvGrpCd">
</FORM>
</BODY>
</HTML>
