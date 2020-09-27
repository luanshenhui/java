<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		���t�̑I�� (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<%
'�Z�b�V�����`�F�b�N
'Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objSchedule 	'�X�P�W���[�����A�N�Z�X�p

'�����l
Dim lngYear			'�N
Dim lngMonth		'��
Dim strEntryDate	'���͂��ꂽ���t

'�a�@�X�P�W���[�����
Dim dtmStrDate		'�ǂݍ��݊J�n���t
Dim dtmEndDate		'�ǂݍ��ݏI�����t
Dim vntCslDate		'��f��
Dim vntHoliday		'�x�f��
Dim lngCount		'���R�[�h��

Dim strYear			'���͂��ꂽ���t(�N)
Dim strMonth		'���͂��ꂽ���t(��)
Dim strDay			'���͂��ꂽ���t(��)
Dim lngCurYear		'���ݕҏW���̔N
Dim lngCurMonth		'���ݕҏW���̌�
Dim lngDateArray	'�J�����_�[���t�z��
Dim dtmDate			'��Ɨp�̓��t
Dim strHTML			'HTML������
Dim i, j, k			'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")

'�����̎擾
lngYear      = CLng("0" & Request("year") )
lngMonth     = CLng("0" & Request("month"))
strEntryDate = Request("entryDate")

'�ȗ����̓V�X�e���N�����g�p
lngYear  = IIf(lngYear  = 0, Year(Now()),  lngYear )
lngMonth = IIf(lngMonth = 0, Month(Now()), lngMonth)

'�O���̐擪������̃X�P�W���[�������擾
dtmStrDate = DateAdd("m", -1, CDate(lngYear & "/" & lngMonth & "/1"))

'�����̖����܂ł̃X�P�W���[�������擾
dtmEndDate = DateAdd("d", -1, DateAdd("m", 3, dtmStrDate))

'�a�@�X�P�W���[���擾
lngCount = objSchedule.SelectSchedule_h(dtmStrDate, dtmEndDate, vntCslDate, vntHoliday)

'���t�����͂��ꂽ�ꍇ
If strEntryDate <> "" Then

	'�N�E���E���ɕ���
	strYear  = Mid(strEntryDate, 1, 4)
	strMonth = Mid(strEntryDate, 5, 2)
	strDay   = Mid(strEntryDate, 7, 2)

	'�Ăь���ʂɔN�������Z�b�g���ĉ�ʂ����
	strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
	strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.calGuide_setDate(" & strYear & ", " & strMonth & ", " & strDay & "); close()"">"
	strHTML = strHTML & "</BODY>"
	strHTML = strHTML & "</HTML>"
	Response.Write strHTML
	Response.End

End If

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �J�����_�[�p�̓��t�z��쐬
'
' �����@�@ : (In)     lngYear   �N
' �@�@�@�@   (In)     lngMonth  ��
'
' �߂�l�@ : �w��N���̃J�����_�[���t�z��(6�s�~7��)
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CalendarArray(lngYear, lngMonth)

	Dim lngDateArray(5, 6)	'���t�e�[�u��
	Dim dtmDate				'���ݕҏW���̓��t(�|�C���^)
	Dim i, j				'�C���f�b�N�X

	For i = 0 To UBound(lngDateArray, 1)
		For j = 0 To UBound(lngDateArray, 2)
			lngDateArray(i, j) = 0
		Next
	Next

	'�ҏW�N���̐擪����ҏW
	dtmDate = CDate(lngYear & "/" & lngMonth & "/1")

	'���t�|�C���^���T�̐擪(���j)�ɂȂ�܂Ń|�C���^��߂�
	Do Until Weekday(dtmDate) = 1
		dtmDate = DateAdd("d", -1, dtmDate)
	Loop

	'�z���ҏW
	For i = 0 To UBound(lngDateArray, 1)
		For j = 0 To UBound(lngDateArray, 2)

			'���t�|�C���^�̌����ҏW���Ɠ���̏ꍇ�̂ݓ���ҏW
			If Month(dtmDate) = lngMonth Then
				lngDateArray(i, j) = Day(dtmDate)
			End If

			'���t�|�C���^��i�߂�
			dtmDate = DateAdd("d", 1, dtmDate)

		Next
	Next

	CalendarArray = lngDateArray

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���t�\���F�̐ݒ�
'
' �����@�@ : (In)     lngYear   �N
' �@�@�@�@   (In)     lngMonth  ��
' �@�@�@�@   (In)     lngDay    ��
'
' �߂�l�@ : �\���F
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function DateColor(lngYear, lngMonth, lngDay)

	Dim dtmDate		'��Ɨp�̓��t
	Dim lngWeekDay	'�j��(1:���j�`7:�y�j)
	Dim strColor	'�\���F
	Dim i			'�C���f�b�N�X

	'�����l�̓��e����t�^�ϐ��ɕҏW
	dtmDate = CDate(lngYear & "/" & lngMonth & "/" & lngDay)

	Do
		'�����l���V�X�e�����t�Ɠ��l�̏ꍇ
		If dtmDate = Date() Then
			strColor = "today"
			Exit Do
		End If

		'�w����̗j�������߂�
		lngWeekDay = Weekday(dtmDate)

		'���j�̏ꍇ
		If lngWeekDay = 1 Then
			strColor = "holiday"
			Exit Do
		End If

		'�y�j�̏ꍇ
		If lngWeekDay = 7 Then
			strColor = "saturday"
			Exit Do
		End If

		'����ȊO�͕a�@�X�P�W���[����������
		For i = 0 To lngCount - 1

			If CDate(vntCslDate(i)) = dtmDate Then

				'�j���̏ꍇ
				If vntHoliday(i) = "2" Then
					strColor = "holiday"
					Exit Do
				End If

				'�x�f���̏ꍇ
				If vntHoliday(i) = "1" Then
					strColor = "kyusin"
					Exit Do
				End If

				Exit For
			End If

		Next

		'�ǂ̏����ɂ��Y�����Ȃ��ꍇ
		strColor = "weekday"

		Exit Do
	Loop

	DateColor = strColor

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���l��SELECT�^�O����
'
' �����@�@ : (In)     strElementName    �G�������g
' �@�@�@�@   (In)     lngStartValue     �J�n�l
' �@�@�@�@   (In)     lngEndValue       �I���l
' �@�@�@�@   (In)     lngSelectedValue  �f�t�H���g�̑I��l
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub EditNumberList(strElementName, lngStartValue, lngEndValue, lngSelectedValue)

	Dim strHTML	'HTML������
	Dim i		'�C���f�b�N�X
%>
	<SELECT NAME="<%= strElementName %>" ONCHANGE="javascript:changeDate(document.dateSelector.year.value, document.dateSelector.month.value)">
<%
	'OPTION�^�O��ҏW
	For i = lngStartValue To lngEndValue
		strHTML = strHTML & "<OPTION VALUE=""" & i & """" & IIf(lngSelectedValue = i, " SELECTED", "") & ">" & i
	Next

	Response.Write strHTML
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
<TITLE>���t�̑I��</TITLE>
<SCRIPT TYPE="text/javascript">
<!-- #include virtual = "/webHains/includes/date.inc" -->
<!--
// �N���ύX���̏���
function changeDate( year, month ) {

	document.entryForm.year.value  = year;
	document.entryForm.month.value = month;
	document.entryForm.submit();

}

// ���t�`�F�b�N
function checkDate() {

	var myForm = document.dateSelector;	// ����ʂ̃t�H�[���G�������g
	var year, month, day;				// �N�E���E��

	// 8�����͎��ȊO��submit���Ȃ�
	if ( myForm.entryDate.value.length != 8 ) {
		return false;
	}

	// ���t�`�F�b�N
	year  = myForm.entryDate.value.substring(0, 4);
	month = myForm.entryDate.value.substring(4, 6);
	day   = myForm.entryDate.value.substring(6, 8);
	return isDate( year, month, day );

}

// �N�����I�����̏���
function selectDate( year, month, day ) {

	var buffer;	// �N�����ҏW�o�b�t�@

	// �N��ҏW
	buffer = year;

	// ����A��
	if ( month < 10 ) {
		buffer = buffer + '0';
	}
	buffer = buffer + '' + month;

	// ����A��
	if ( day < 10 ) {
		buffer = buffer + '0';
	}
	buffer = buffer + '' + day;

	// submit
	document.entryForm.entryDate.value = buffer;
	document.entryForm.submit();

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
<!-- #include virtual = "/webHains/contents/css/calender.css" -->
</STYLE>
<style type="text/css">
	body { margin: 10px 0 0 10px; }
</style>
</HEAD>
<BODY ONLOAD="document.dateSelector.entryDate.focus()">
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
	<TR>
<%
		'�ҏW�J�n�N����O���ɐݒ肷��
		dtmDate = DateAdd("m", -1, CDate(lngYear & "/" & lngMonth & "/1"))
		lngCurYear  = Year(dtmDate)
		lngCurMonth = Month(dtmDate)

		'�w��N���̑O������3�������̃J�����_�[��ҏW
		For i = 1 To 3
%>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
					<TR>
						<TD HEIGHT="20" ALIGN="center" VALIGN="bottom" COLSPAN="7"><B><%= lngCurYear %></B>�N<B><%= lngCurMonth %></B>��</TD>
					</TR>
					<TR ALIGN="center">
						<TD WIDTH="13" CLASS="holiday" ><B>��</B></TD>
						<TD WIDTH="13" CLASS="weekday" ><B>��</B></TD>
						<TD WIDTH="13" CLASS="weekday" ><B>��</B></TD>
						<TD WIDTH="13" CLASS="weekday" ><B>��</B></TD>
						<TD WIDTH="13" CLASS="weekday" ><B>��</B></TD>
						<TD WIDTH="13" CLASS="weekday" ><B>��</B></TD>
						<TD WIDTH="13" CLASS="saturday"><B>�y</B></TD>
					</TR>
<%
					'�J�����_�[���t�z��̎擾
					lngDateArray = CalendarArray(lngCurYear, lngCurMonth)

					'�Ώ۔N���̃J�����_�[��ҏW
					strHTML = ""
					For j = 0 To UBound(lngDateArray, 1)

						strHTML = strHTML & "<TR ALIGN=""right"" BGCOLOR=""#ffffff"">"

						For k = 0 To UBound(lngDateArray, 2)

							'���t�����݂���ꍇ�̂ݕҏW
							If lngDateArray(j, k) > 0 Then
								strHTML = strHTML & "<TD><A HREF=""javascript:selectDate(" & lngCurYear & ", " & lngCurMonth & ", " & lngDateArray(j, k) & ")"" CLASS=""" & DateColor(lngCurYear, lngCurMonth, lngDateArray(j, k)) & """>" & lngDateArray(j, k) & "</A></TD>"
							Else
								strHTML = strHTML & "<TD>&nbsp;</TD>"
							End If

						Next

						strHTML = strHTML & "</TR>"
					Next

					Response.Write strHTML
%>
				</TABLE>
			</TD>
<%
			If i <> 3 Then
%>
				<TD WIDTH="15"></TD>
<%
			End If

			'�ҏW�N���������ɐݒ肷��
			dtmDate = DateAdd("m", 1, CDate(lngCurYear & "/" & lngCurMonth & "/1"))
			lngCurYear  = Year(dtmDate)
			lngCurMonth = Month(dtmDate)

		Next
%>
	</TR>
</TABLE>

<FORM NAME="dateSelector" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get" ONSUBMIT="javascript:return checkDate()">
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0" BGCOLOR="#cccccc" WIDTH="369">
		<TR>
			<TD>
				<TABLE WIDTH="100%" BORDER="0" CELLPADDING="2" CELLSPACING="0" BGCOLOR="#006699">
					<TR>
						<TD ALIGN="center" BGCOLOR="#ffffff">
							<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
								<TR>
<%
									'�ҏW�N����3�����O�ɐݒ肷��
									dtmDate = DateAdd("m", -3, CDate(lngYear & "/" & lngMonth & "/1"))
									lngCurYear  = Year(dtmDate)
									lngCurMonth = Month(dtmDate)
%>
									<TD><A HREF="javascript:changeDate(<%= lngCurYear %>, <%= lngCurMonth %>)"><IMG SRC="/webHains/images/review.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="�O�̂R������\��"></A></TD>
<%
									'�ҏW�N����O���ɐݒ肷��
									dtmDate = DateAdd("m", -1, CDate(lngYear & "/" & lngMonth & "/1"))
									lngCurYear  = Year(dtmDate)
									lngCurMonth = Month(dtmDate)
%>
									<TD><A HREF="javascript:changeDate(<%= lngCurYear %>, <%= lngCurMonth %>)"><IMG SRC="/webHains/images/replay.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="�O����\��"></A></TD>
									<TD><% Call EditNumberList("year", YEARRANGE_MIN, YEARRANGE_MAX, lngYear) %></TD>
									<TD>�N</TD>
									<TD><% Call EditNumberList("month", 1, 12, lngMonth) %></TD>
									<TD>��</TD>
<%
									'�ҏW�N���������ɐݒ肷��
									dtmDate = DateAdd("m", 1, CDate(lngYear & "/" & lngMonth & "/1"))
									lngCurYear  = Year(dtmDate)
									lngCurMonth = Month(dtmDate)
%>
									<TD><A HREF="javascript:changeDate(<%= lngCurYear %>, <%= lngCurMonth %>)"><IMG SRC="/webHains/images/play.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="������\��"></A></TD>
<%
									'�ҏW�N����3������ɐݒ肷��
									dtmDate = DateAdd("m", 3, CDate(lngYear & "/" & lngMonth & "/1"))
									lngCurYear  = Year(dtmDate)
									lngCurMonth = Month(dtmDate)
%>
									<TD><A HREF="javascript:changeDate(<%= lngCurYear %>, <%= lngCurMonth %>)"><IMG SRC="/webHains/images/cue.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="���̂R������\��"></A></TD>
									<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="30" HEIGHT="1"></TD>
									<TD><INPUT TYPE="text" NAME="entryDate" SIZE="10" MAXLENGTH="8"></TD>
									<TD><INPUT TYPE="image" SRC="/webHains/images/go.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="���t�����"></TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
</FORM>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<INPUT TYPE="hidden" NAME="year"      VALUE="">
	<INPUT TYPE="hidden" NAME="month"     VALUE="">
	<INPUT TYPE="hidden" NAME="entryDate" VALUE="">
</FORM>
</BODY>
</HTML>