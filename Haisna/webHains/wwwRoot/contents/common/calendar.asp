<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�J�����_�[ (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@FSIT
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'�Z�b�V�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim lngDspYear		'��N
Dim lngDspMonth		'���
Dim i
Dim j
Dim k
Dim l
Dim strHtml

'�J�����_�[�쐬�p
Dim strEditYear		'�N
Dim strEditMonth	'��
Dim strEditDay		'��
Dim strEndDay		'������

'�\�����ύX�{�^���쐬�p
Dim strNextYear		'�����̔N
Dim strNextMonth	'�����̌�
Dim strPrevYear		'�O���̔N
Dim strPrevMonth	'�O���̌�
Dim strNext3Year	'���R�����̔N
Dim strNext3Month	'���R�����̌�
Dim strPrev3Year	'�O�R�����̔N
Dim strPrev3Month	'�O�R�����̌�

'�a�@�X�P�[�W���[���p
Dim strStrDate		'�ǂݍ��݊J�n���t
Dim strEndDate		'�ǂݍ��ݏI�����t
Dim vntCslDate		'��f��
Dim vntHoliday		'�x�f��
Dim lngCount		'���R�[�h��

'INI�t�@�C��
Dim vntLocate

Dim strClass

Dim objSchedule 	'�b�n�l�I�u�W�F�N�g

Dim objCommon 	'�b�n�l�I�u�W�F�N�g

Dim strHoliday		'�x�f��

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�C���X�^���X�쐬
Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")

'�I�u�W�F�N�g�C���X�^���X�쐬
Set objCommon = Server.CreateObject("HainsCommon.Common")

'�����l�̎擾
lngDspYear   = Clng("0" & Request("selectYear"))
lngDspMonth  = Clng("0" & Request("selectMonth"))

vntLocate = objCommon.SelectCalenderLocate()

Do
	If Clng(lngDspYear) = 0 Then
		Select Case vntLocate
			Case 1
				lngDspYear = Year(Now)
			Case 2
				lngDspYear = Year(DateAdd("m",-1,Now))
		End Select
	End If

	If Clng(lngDspMonth) = 0 Then
		Select Case vntLocate
			Case 1
				lngDspMonth = Month(Now)
			Case 2
				lngDspMonth = Month(DateAdd("m",-1,Now))
		End Select
	End If

	strStrDate = lngDspYear & "/" & lngDspMonth & "/1"
	strEndDate = Year(DateAdd("m",3,lngDspYear & "/" & lngDspMonth & "/1")) & "/" & _
				Month(DateAdd("m",3,lngDspYear & "/" & lngDspMonth & "/1")) & "/" & _
				Day(DateAdd("d",-1,DateAdd("m",4,lngDspYear & "/" & lngDspMonth & "/1")))

	'�a�@�X�P�W���[���擾
	lngCount = objSchedule.SelectSchedule_h(strStrDate, strEndDate, vntCslDate, vntHoliday)

	Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>webHains �J�����_�[ Locate=<%= vntLocate %></TITLE>
<STYLE TYPE="text/css">
<!-- #include virtual = "/webHains/contents/css/calender.css" -->
</STYLE>
<style type="text/css">
body { 
	margin: 3px 0 0 8px; 
	background-color: #eee;
}
</style>
</HEAD>
<BODY>
<!-- ���o�� -->
<TABLE border=0 width=112 cellpadding=0 cellspacing=0>
	<TR HEIGHT="12">
		<TD HEIGHT="10"><IMG SRC="/webHains/images/spacer.gif" HEIGHT="10"></TD>
	</TR>
	<TR HEIGHT="12" BGCOLOR="#CCCCCC">
		<TD width="100%" ALIGN="CENTER" HEIGHT="12">
			<SPAN STYLE="font-size:12px;color:#ffffff"><B>Calendar</B></SPAN>
		</TD>
	</TR>
</TABLE>
<!-- �J�����_ -->
<%
strHtml = ""
l = 0

For i = 0 To 2

	strEditYear		=	Year(DateAdd("m",i,lngDspYear & "/" & lngDspMonth & "/1"))
	strEditMonth	=	Month(DateAdd("m",i,lngDspYear & "/" & lngDspMonth & "/1"))

	strHtml = strHtml & "<TABLE BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"">"
	strHtml = strHtml & "<TR HEIGHT=""7"">"
	strHtml = strHtml & "<TD HEIGHT=""7""><IMG SRC=""/webHains/images/spacer.gif"" HEIGHT=""7""></TD>"
	strHtml = strHtml & "</TR>"
	strHtml = strHtml & "<TR>"
	strHtml = strHtml & "<TD HEIGHT=""20"" VALIGN=""BOTTOM"">"
	strHtml = strHtml & "<SPAN STYLE=""font-size:12px;""><B>" & strEditYear & "</B>�N<B>" & strEditMonth & "</B>��</SPAN>"
	strHtml = strHtml & "</TD>"
	strHtml = strHtml & "</TR>"


	strHtml = strHtml & "<TR>"
	strHtml = strHtml & "<TD>"
	strHtml = strHtml & "<TABLE BORDER=""0"" CELLPADDING=""1"" CELLSPACING=""1"">"
	strHtml = strHtml & "<TR ALIGN=""right"" BGCOLOR=""#EEEEEE"" HEIGHT=""14"">"
	strHtml = strHtml & "<TD WIDTH=""13"" CLASS=""holiday""><SPAN STYLE=""font-size:12px""><B>��</B></SPAN></TD>"
	strHtml = strHtml & "<TD WIDTH=""13"" CLASS=""weekday""><SPAN STYLE=""font-size:12px""><B>��</B></SPAN></TD>"
	strHtml = strHtml & "<TD WIDTH=""13"" CLASS=""weekday""><SPAN STYLE=""font-size:12px""><B>��</B></SPAN></TD>"
	strHtml = strHtml & "<TD WIDTH=""13"" CLASS=""weekday""><SPAN STYLE=""font-size:12px""><B>��</B></SPAN></TD>"
	strHtml = strHtml & "<TD WIDTH=""13"" CLASS=""weekday""><SPAN STYLE=""font-size:12px""><B>��</B></SPAN></TD>"
	strHtml = strHtml & "<TD WIDTH=""13"" CLASS=""weekday""><SPAN STYLE=""font-size:12px""><B>��</B></SPAN></TD>"
	strHtml = strHtml & "<TD WIDTH=""13"" CLASS=""saturday""><SPAN STYLE=""font-size:12px""><B>�y</B></SPAN></TD>"
	strHtml = strHtml & "</TR>"

	'�X�^�[�g���i�擪�����j�������擾�j
	strEditDay = 1 - Weekday(strEditYear & "/" & strEditMonth & "/1")
	'������
	strEndDay  = Day(DateAdd("d",-1,DateAdd("m",1,strEditYear & "/" & strEditMonth & "/1")))
	
	'�J�����_�[�쐬�i�ő�U�T����̂Łj
	For j = 1 to 6
		strHtml = strHtml & "				<TR ALIGN=""right"" BGCOLOR=""#ffffff"" HEIGHT=""14"">" & vbCrLf

		'�T���ƂɌv�Z
		For k = 1 to 7

			strEditDay = strEditDay + 1

			If strEditDay >= 1 And strEditDay <= strEndDay Then

				strHtml = strHtml & "					<TD WIDTH=""13""><SPAN STYLE=""font-size:12px""><A HREF=""/webHains/contents/common/dailyList.asp?"
				strHtml = strHtml & "strYear=" & strEditYear & "&amp;strMonth=" & strEditMonth & "&amp;strDay=" & strEditDay & """"

				'���t�̕\���F�ݒ�
				Do
					strClass = ""

					'�����̐F�w��
					If strEditYear = Year(Now) And strEditMonth = Month(Now) And strEditDay = Day(Now) Then
						strClass = "today"
						Exit Do
					End If

					'�j���Ȃ̂��x�f���Ȃ̂�������
					strHoliday = ""
					For l = 0 To lngCount - 1
						If DateValue(vntCslDate(l)) = DateValue(strEditYear & "/" & strEditMonth & "/" & strEditDay) Then
							strHoliday = vntHoliday(l)
							Exit For
						End If
					Next

					'�j���̐F�ݒ�
					If strHoliday = "2" Then
						strClass = "holiday"
						Exit Do
					End If

					'�y�j���̐F�w��
					If k = vbSaturday Then
						strClass = "saturday"
						Exit Do
					End If

					'���j���̐F�w��
					If k = vbSunday Then
						strClass = "holiday"
						Exit Do
					End If

					'�x�f���̐F�w��
					If strHoliday = "1" Then
						strClass = "kyusin"
						Exit Do
					End If

					'�����̐F�w��
					strClass = "weekday"

					Exit Do
				Loop

				strHtml = strHtml & " CLASS=""" & strClass & """"

				strHtml = strHtml & "  TARGET=""Main"">" 
				If Len(strEditDay) = 1 Then
					strHtml = strHtml & "&nbsp;"
				End If
					strHtml = strHtml & strEditDay & "</A></SPAN></TD>" & vbCrLf
			Else
				strHtml = strHtml & "<TD WIDTH=""13""><SPAN STYLE=""font-size:12px"">&nbsp;</SPAN></TD>"
			End If
		Next 
	
		strHtml = strHtml & "				</TR>" & vbCrLf
	Next

	strHtml = strHtml & "			</TABLE>"
	strHtml = strHtml & "		</TD>"
	strHtml = strHtml & "	</TR>"
	strHtml = strHtml & "</TABLE>"

	Next

	Response.Write 	strHtml
%>

<FORM NAME="changedate" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR VALIGN="top" ALIGN="center">
			<TD HEIGHT="10"></TD>
		</TR>
		<TR VALIGN="top" ALIGN="center">
			<TD>
				<TABLE BORDER="0" WIDTH="112" CELLPADDING="1" CELLSPACING="0" BGCOLOR="#cccccc">
					<TR>
						<TD WIDTH="100%" ALIGN="center"><SPAN STYLE="font-size:12px;color:#ffffff;font-weight:bolder">�\�����ύX</SPAN></TD>
					</TR>
					<TR>
						<TD WIDTH="100%">
							<TABLE WIDTH="100%" BORDER="0" CELLPADDING="2" CELLSPACING="0" BGCOLOR="#006699">
								<TR>
									<TD BGCOLOR="#ffffff" VALIGN="bottom" ALIGN="center" width="100%">
<%
										strNextYear   = Year(DateAdd( "m",  1,lngDspYear & "/" & lngDspMonth & "/1"))
										strNextMonth  = Month(DateAdd("m",  1,lngDspYear & "/" & lngDspMonth & "/1"))
										strPrevYear   = Year(DateAdd( "m", -1,lngDspYear & "/" & lngDspMonth & "/1"))
										strPrevMonth  = Month(DateAdd("m", -1,lngDspYear & "/" & lngDspMonth & "/1"))
										strNext3Year  = Year(DateAdd( "m",  3,lngDspYear & "/" & lngDspMonth & "/1"))
										strNext3Month = Month(DateAdd("m",  3,lngDspYear & "/" & lngDspMonth & "/1"))
										strPrev3Year  = Year(DateAdd( "m", -3,lngDspYear & "/" & lngDspMonth & "/1"))
										strPrev3Month = Month(DateAdd("m", -3,lngDspYear & "/" & lngDspMonth & "/1"))
%>
										<A HREF="<%= Request.ServerVariables("SCRIPT_NAME") %>?selectYear=<%= strPrev3Year %>&amp;selectMonth=<%= strPrev3Month %>"><IMG SRC="/webHains/images/review.gif" WIDTH="21" HEIGHT="21" ALT="�O�̂R������\��"></A>
										<A HREF="<%= Request.ServerVariables("SCRIPT_NAME") %>?selectYear=<%= strPrevYear  %>&amp;selectMonth=<%= strPrevMonth  %>"><IMG SRC="/webHains/images/replay.gif" WIDTH="21" HEIGHT="21" ALT="�O����\��"></A>
										<A HREF="<%= Request.ServerVariables("SCRIPT_NAME") %>?selectYear=<%= strNextYear  %>&amp;selectMonth=<%= strNextMonth  %>"><IMG SRC="/webHains/images/play.gif"   WIDTH="21" HEIGHT="21" ALT="������\��"></A>
										<A HREF="<%= Request.ServerVariables("SCRIPT_NAME") %>?selectYear=<%= strNext3Year %>&amp;selectMonth=<%= strNext3Month %>"><IMG SRC="/webHains/images/cue.gif"    WIDTH="21" HEIGHT="21" ALT="���̂R������\��"></A>
									</TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
</FORM>
<script type="text/javascript">
document.onclick = function(event)
{
	if ( !event.target ) {
		return;
	}

	var target = event.target
	if ( !target.tagName ) {
		return;
	}

	if ( target.tagName.toLowerCase() != 'a' ) {
		return;
	}

	document.body.style.cursor = 'wait';

	if ( !target.target ) {
		return;
	}

	var targetFrame = top.frames[target.target];
	if ( targetFrame ) {
		targetFrame.document.body.style.cursor = 'wait';
	}
};
</script>
</BODY>
</HTML>
