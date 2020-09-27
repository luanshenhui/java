<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�l�A�J���̓o�^ (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�萔�̒�`
Const MODE_INSERT           = "insert"	'�������[�h(�}��)
Const MODE_UPDATE           = "update"	'�������[�h(�X�V)
Const ACTMODE_SAVE          = "save"	'���샂�[�h(�ۑ�)
Const ACTMODE_DELETE        = "delete"	'���샂�[�h(�폜)
Const LENGTH_NIGHTWORKCOUNT = 2			'���ڒ�(��Ɖ�)
Const LENGTH_OVERTIMEINT    = 3			'���ڒ�(���ԊO�A�J����(������))
Const LENGTH_OVERTIMEDEC    = 1			'���ڒ�(���ԊO�A�J����(������))

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objPerson			'�l���A�N�Z�X�p
Dim objPerWorkInfo		'�l�A�J���A�N�Z�X�p

'������
Dim strMode				'�������[�h
Dim strActMode			'���샂�[�h(�ۑ�:"save"�A�ۑ�����:"saved")
Dim strPerId			'�l�h�c
Dim lngDataYear			'�f�[�^�N
Dim lngDataMonth		'�f�[�^��
Dim strNightWorkCount	'��Ɖ�
Dim strOverTimeInt		'���ԊO�A�J����(������)
Dim strOverTimeDec		'���ԊO�A�J����(������)

'�l���
Dim strLastName			'��
Dim strFirstName		'��
Dim strLastKName		'�J�i��	
Dim strFirstKName		'�J�i��
Dim strBirth			'���N����
Dim strAge				'�N��
Dim strGender			'����
Dim strGenderName		'���ʖ���

Dim dtmDataDate			'�f�[�^�N��
Dim lngNightWorkCount	'��Ɖ�
Dim dblOverTime			'���ԊO�A�J����
Dim strArrMessage		'�G���[���b�Z�[�W
Dim strHTML				'HTML������
Dim i					'�C���f�b�N�X

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon      = Server.CreateObject("HainsCommon.Common")
Set objPerWorkInfo = Server.CreateObject("HainsPerWorkInfo.PerWorkInfo")

'�����l�̎擾
strMode           = Request("mode")
strActMode        = Request("actMode")
strPerId          = Request("perId")
lngDataYear       = CLng("0" & Request("dataYear"))
lngDataMonth      = CLng("0" & Request("dataMonth"))
strNightWorkCount = Request("nightWorkCount")
strOverTimeInt    = Request("overTimeInt")
strOverTimeDec    = Request("overTimeDec")

'�f�t�H���g�l�̐ݒ�
lngDataYear  = IIf(lngDataYear  = 0, Year(Date),  lngDataYear )
lngDataMonth = IIf(lngDataMonth = 0, Month(Date), lngDataMonth)

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do

	'�폜���̏���
	If strActMode = ACTMODE_DELETE Then

		'�f�[�^�N���̐ݒ�
		dtmDataDate = lngDataYear & "/" & lngDataMonth & "/1"

		'�l�A�J���e�[�u�����R�[�h�폜
		objPerWorkInfo.DeletePerWorkInfo strPerId, dtmDataDate

		'�G���[���Ȃ���ΌĂь���ʂ������[�h���Ď��g�����
		strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
		strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
		strHTML = strHTML & "</BODY>"
		strHTML = strHTML & "</HTML>"
		Response.Write strHTML
		Response.End

	End If

	'�ۑ����̏���
	If strActMode = ACTMODE_SAVE Then

		'���̓`�F�b�N
		strArrMessage = CheckValue()
		If Not IsEmpty(strArrMessage) Then
			Exit Do
		End If

		'�f�[�^�N���̐ݒ�
		dtmDataDate = lngDataYear & "/" & lngDataMonth & "/1"

		'�}�����[�h�̏ꍇ
		If strMode = MODE_INSERT Then

			'�l�A�J���e�[�u�����R�[�h��ǂݍ��݁A���R�[�h�����݂���΃G���[
			If objPerWorkInfo.SelectPerWorkInfo(strPerId, dtmDataDate) = True Then
				strArrMessage = Array("����f�[�^�N���̌l�A�J��񂪂��łɑ��݂��܂��B")
				Exit Do
			End If

		End If

		'�o�^�l�̐ݒ�
		If strNightWorkCount <> "" Then
			lngNightWorkCount = CLng(strNightWorkCount)
		End If
		If strOverTimeInt <> "" Or strOverTimeDec <> "" Then
			dblOverTime = CDbl(strOverTimeInt & "." & strOverTimeDec)
		End If

		'�l�A�J���e�[�u�����R�[�h�o�^
		objPerWorkInfo.RegistPerWorkInfo strPerId, dtmDataDate, lngNightWorkCount, dblOverTime

		'�G���[���Ȃ���ΌĂь���ʂ������[�h���Ď��g�����
		strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
		strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
		strHTML = strHTML & "</BODY>"
		strHTML = strHTML & "</HTML>"
		Response.Write strHTML
		Response.End

	End If

	'�V�K�̏ꍇ�͓ǂݍ��݂��s��Ȃ�
	If strMode = MODE_INSERT Then
		Exit Do
	End If

	'�f�[�^�N���̐ݒ�
	dtmDataDate = lngDataYear & "/" & lngDataMonth & "/1"

	'�l�A�J���e�[�u�����R�[�h�ǂݍ���
	objPerWorkInfo.SelectPerWorkInfo strPerId, dtmDataDate, lngNightWorkCount, dblOverTime

	'�ǂݍ��ݒl�̐ݒ�
	strNightWorkCount = CStr(lngNightWorkCount)
	strOverTimeInt    = CStr(Int(dblOverTime))
	strOverTimeDec    = CStr((dblOverTime * 10) Mod 10)

	'�������[�h���X�V�Ƃ���
	strMode = MODE_UPDATE

	Exit Do
Loop

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �e�l�̑Ó����`�F�b�N���s��
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

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'�e�l�`�F�b�N����
	With objCommon

		'��Ɖ�
		.AppendArray vntArrMessage, .CheckNumeric("��Ɖ�", strNightWorkCount, LENGTH_NIGHTWORKCOUNT)

		'���ԊO�A�J����(������)
		.AppendArray vntArrMessage, .CheckNumeric("���ԊO�A�J���ԁi�������j", strOverTimeInt, LENGTH_OVERTIMEINT)

		'���ԊO�A�J����(������)
		.AppendArray vntArrMessage, .CheckNumeric("���ԊO�A�J���ԁi�������j", strOverTimeDec, LENGTH_OVERTIMEDEC)

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
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�l�A�J���̓o�^</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// submit���̏���
function submitForm( actMode ) {

	// �폜���͊m�F���b�Z�[�W��\��
	if ( actMode == '<%= ACTMODE_DELETE %>' ) {
		if ( !confirm( '���̌l�A�J�����폜���܂��B��낵���ł����H' ) ) {
			return;
		}
	}

	// ���샂�[�h���w�肵��submit
	document.entryForm.actMode.value = actMode;
	document.entryForm.submit();

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 15px 0 0 20px; }
	td.mnttab { background-color:#FFFFFF }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">

	<INPUT TYPE="hidden" NAME="mode"    VALUE="<%= strMode  %>">
	<INPUT TYPE="hidden" NAME="actMode" VALUE="">
	<INPUT TYPE="hidden" NAME="perId"   VALUE="<%= strPerId %>">

	<!-- �\�� -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">��</SPAN><FONT COLOR="#000000">�l�A�J���̓o�^</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'���b�Z�[�W�̕ҏW
	EditMessage strArrMessage, MESSAGETYPE_WARNING
%>
	<BR>
<%
	'�l���ǂݍ���
	Set objPerson = Server.CreateObject("HainsPerson.Person")
	objPerson.SelectPersonInf strPerId, strLastName, strFirstName, strLastKName, strFirstKName, strBirth, strGender, strGenderName, strAge
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD NOWRAP><%= strPerId %></TD>
			<TD NOWRAP><B><%= Trim(strLastName & "�@" & strFirstName) %></B> �i<FONT SIZE="-1"><%= Trim(strLastKName & "�@" & strFirstKName) %></FONT>�j</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD NOWRAP><%= objCommon.FormatString(strBirth, "gee.mm.dd") %>���@<%= strAge %>�΁@<%= strGenderName %></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD NOWRAP>�f�[�^�N��</TD>
			<TD>�F</TD>
<%
			If strMode = MODE_INSERT Then
%>
				<TD>
					<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
						<TR>
							<TD><%= EditNumberList("dataYear", YEARRANGE_MIN, YEARRANGE_MAX, lngDataYear, False) %></TD>
							<TD>&nbsp;�N&nbsp;</TD>
							<TD><%= EditNumberList("dataMonth", 1, 12, lngDataMonth, False) %></TD>
							<TD>&nbsp;��</TD>
						</TR>
					</TABLE>
				</TD>
<%
			Else
%>
				<TD NOWRAP><INPUT TYPE="hidden" NAME="dataYear" VALUE="<%= lngDataYear %>"><INPUT TYPE="hidden" NAME="dataMonth" VALUE="<%= lngDataMonth %>"><%= lngDataYear %>�N<%= lngDataMonth %>��</TD>
<%
			End If
%>
		</TR>
		<TR>
			<TD HEIGHT="1"></TD>
		</TR>
		<TR>
			<TD NOWRAP>��Ɖ�</TD>
			<TD>�F</TD>
			<TD NOWRAP><INPUT TYPE="text" NAME="nightWorkCount" SIZE="<%= LENGTH_NIGHTWORKCOUNT %>" MAXLENGTH="<%= LENGTH_NIGHTWORKCOUNT %>" VALUE="<%= strNightWorkCount %>">&nbsp;��</TD>
		</TR>
		<TR>
			<TD NOWRAP>���ԊO�A�J����</TD>
			<TD>�F</TD>
			<TD NOWRAP><INPUT TYPE="text" NAME="overTimeInt" SIZE="<%= LENGTH_OVERTIMEINT %>" MAXLENGTH="<%= LENGTH_OVERTIMEINT %>" VALUE="<%= strOverTimeInt %>">�D<INPUT TYPE="text" NAME="overTimeDec" SIZE="<%= LENGTH_OVERTIMEDEC %>" MAXLENGTH="<%= LENGTH_OVERTIMEDEC %>" VALUE="<%= strOverTimeDec %>">&nbsp;����</TD>
		</TR>
	</TABLE>

	<BR><BR>
<%
	If strMode = MODE_UPDATE Then
%>
		<A HREF="javascript:submitForm('<%= ACTMODE_DELETE %>')"><IMG SRC="/webHains/images/delete.gif" WIDTH="77" HEIGHT="24" ALT="���̌l�A�J�����폜���܂�"></A>
<%
	End If
%>
	<A HREF="JavaScript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z��"></A>
	<A HREF="javascript:submitForm('<%= ACTMODE_SAVE %>')"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="���͂����f�[�^��ۑ����܂�"></A>

</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
