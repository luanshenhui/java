<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�T�ԗ\��g�󋵕\�� (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const CSCOUNT_PER_ROW = 7	'�P�s�ӂ�̕\���R�[�X��
'## 2004.03.01 Add By T.Takagi@FSIT �\��l�����ő�l���ɂăO���[�\��
Const CSCD_GI = "W001"		'�f�h�g�Ǘ��R�[�X
'## 2004.03.01 Add End

Dim objSchedule			'�X�P�W���[�����A�N�Z�X�p

'�����l
Dim lngCslYear			'��f�N
Dim lngCslMonth			'��f��
Dim lngCslDay			'��f��
Dim strCsCd				'�R�[�X�R�[�h
Dim strGender			'����
Dim strMode				'�������[�h

'�R�[�X���
Dim strSelCsCd			'�R�[�X�R�[�h
Dim strSelCsName		'�R�[�X��
Dim lngSelCsCount		'�R�[�X��

'�\��l�����
Dim strArrCslDate		'��f��
Dim strArrHoliday		'�x�f��
Dim strArrRsvGrpCd		'�\��Q�R�[�h
Dim strArrRsvGrpName	'�\��Q����
Dim strArrStrTime		'�J�n����
Dim strArrCsCd			'�R�[�X�R�[�h
Dim strArrCsName		'�R�[�X��
Dim strArrCsSName		'�R�[�X����
Dim strArrWebColor		'web�J���[
Dim strArrMngGender		'�j���ʘg�Ǘ�
Dim strArrMaxCnt		'�\��\�l���i���ʁj
Dim strArrMaxCnt_M		'�\��\�l���i�j�j
Dim strArrMaxCnt_F		'�\��\�l���i���j
Dim strArrOverCnt		'�I�[�o�\�l���i���ʁj
Dim strArrOverCnt_M		'�I�[�o�\�l���i�j�j
Dim strArrOverCnt_F		'�I�[�o�\�l���i���j
Dim strArrRsvCnt_M		'�\��ςݐl���i�j�j
Dim strArrRsvCnt_F		'�\��ςݐl���i���j
Dim lngCount			'���R�[�h��

Dim strChecked			'�`�F�b�N�̗v��
Dim strCslDate			'��f��
Dim dtmStrCslDate		'�J�n��f��
Dim dtmEndCslDate		'�I����f��
Dim strPrevRsvGrpCd		'���O���R�[�h�̗\��Q�R�[�h
Dim lngRowSpan			'ROWSPAN�l
Dim lngColSpan			'COLSPAN�l
Dim lngCourseCount		'�R�[�X��
Dim lngRsvGrpCount		'�\��Q��
Dim lngWeekday			'�j��(Weekday�֐��̖߂�l)
Dim lngRsvCount			'�\��l��
Dim lngMaxCount			'(�I�[�o�l�����܂�)�ő�l��
Dim strClass			'�j���̐F
Dim blnExists			'�\��l�����̗L��
Dim strColor			'�Z���F
Dim strRsvCount			'�ҏW�p�\��l��
Dim i, j, k				'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�����l�̎擾
lngCslYear  = Request("cslYear")
lngCslMonth = Request("cslMonth")
lngCslDay   = Request("cslDay")
strCsCd     = ConvIStringToArray(Request("csCd"))
strGender   = Request("gender")
strMode     = Request("mode")

'�f�t�H���g�l�ݒ�
lngCslYear  = IIf(lngCslYear  = 0, Year(Date),  lngCslYear)
lngCslMonth = IIf(lngCslMonth = 0, Month(Date), lngCslMonth)
lngCslDay   = IIf(lngCslDay   = 0, Day(Date),   lngCslDay)

'��f���̕ҏW
strCslDate = lngCslYear & "/" & lngCslMonth & "/" & lngCslDay

'���[�h���Ƃ̏���
Select Case UCase(strMode)

	'�S�R�[�X
	Case UCase("all")

		'�R�[�X���w�莞
		If Not IsArray(strCsCd) Then

			'�R�[�X����ǂ݁A�S�R�[�X��ΏۂƂ�����
			Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")
			objSchedule.SelectCourseListRsvGrpManaged strCsCd
			Set objSchedule = Nothing

		End If

	'�O�T
	Case UCase("prev")
		strCslDate = CDate(strCslDate) - 7

	'���T
	Case UCase("next")
		strCslDate = CDate(strCslDate) + 7

End Select

'�����l�̍ĕҏW
lngCslYear  = Year(strCslDate)
lngCslMonth = Month(strCslDate)
lngCslDay   = Day(strCslDate)

'�g�Ǘ����@�̎擾
Function ManageGender(strParaMngGender, strParaMaxCnt, strParaMaxCnt_M, strParaMaxCnt_F)

	Dim Ret	'�֐��߂�l

	Do
		Ret = ""

		'�g�Ǘ����@�w�莞�͂��̕��@�ɏ]��
		If strParaMngGender <> "" Then
			Ret = strParaMngGender
			Exit Do
		End If

		'�g�Ǘ����@�����݂��Ȃ��ꍇ(�g���̂��Ȃ����A�R�[�X��f�\��Q���Ȃ����g�͑��݂���ꍇ)

		'�\��l����񎩑̂����݂��Ȃ��ꍇ�͕s���Ƃ���
		If strParaMaxCnt = "" Then
			Exit Do
		End If

		'�\��l����񎩑̂͑��݂���ꍇ

		'�j���̂����ꂩ�ɐl�����i�[����Ă���ꍇ�A�j���ʘg�Ǘ��Ƃ݂Ȃ�
		If CLng(strArrMaxCnt_M(i)) <> 0 Or CLng(strArrMaxCnt_F(i)) <> 0 Then
			Ret = "1"
			Exit Do
		End If

		'�����Ȃ��Βj���ʘg�Ǘ��͂��Ȃ����̂Ƃ݂Ȃ�
		Ret = "0"
		Exit Do
	Loop

	ManageGender = Ret

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�T�ԗ\��g�󋵕\��</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!-- #include virtual = "/webHains/includes/Date.inc" -->
<!--
function submitForm( mode ) {

	var year  = parseInt(document.entryForm.cslYear.value,  10);
	var month = parseInt(document.entryForm.cslMonth.value, 10);
	var day   = parseInt(document.entryForm.cslDay.value,   10);

	if ( !isDate( year, month, day ) ) {
		alert('��f���̌`��������������܂���B');
		return;
	}

	// ���[�h���w�肵��submit
	document.entryForm.mode.value = mode;
	document.entryForm.submit();

}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/mensetsutable.css">
<STYLE TYPE="text/css">
<!-- #include virtual = "/webHains/contents/css/calender.css" -->
	td.mnttab { background-color:#FFFFFF }
	div.maindiv { margin: 10px 10px 0 10px; }
	table.mensetsu-tb { margin: 10px 0; border-top: 1px solid #ccc;}
</STYLE>
</HEAD>
<BODY>
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<div class="maindiv">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">��</SPAN>�T�ԗ\��g�󋵕\��</B></TD>
	</TR>
</TABLE>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get" STYLE="margin:0px;">
	<INPUT TYPE="hidden" NAME="mode" VALUE="">
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR><TD HEIGHT="5"></TD></TR>
		<TR>
			<TD><A HREF="javascript:submitForm('prev')"><IMG SRC="../../../images/replay.gif" WIDTH="21" HEIGHT="21" ALT="��T��\��"></A></TD>
			<TD NOWRAP>��f��</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
					<TR>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('cslYear','cslMonth','cslDay')"><IMG SRC="/webHains/images/question.gif" ALT="���t�K�C�h��\��" HEIGHT="21" WIDTH="21"></A></TD>
						<TD><%= EditNumberList("cslYear", YEARRANGE_MIN, YEARRANGE_MAX, lngCslYear, False) %></TD>
						<TD>�N</TD>
						<TD><%= EditNumberList("cslMonth", 1, 12, lngCslMonth, False) %></TD>
						<TD>��</TD>
						<TD><%= EditNumberList("cslDay", 1, 31, lngCslDay, False) %></TD>
						<TD NOWRAP>������P�T��&nbsp;</TD>
						<TD><A HREF="javascript:submitForm('next')"><IMG SRC="../../../images/play.gif" WIDTH="21" HEIGHT="21" ALT="���T��\��"></A></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR><TD HEIGHT="5"></TD></TR>
<%
		'�I�u�W�F�N�g�̃C���X�^���X�쐬
		Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")

		'�R�[�X���̓ǂݍ���
		lngSelCsCount = objSchedule.SelectCourseListRsvGrpManaged(strSelCsCd, , strSelCsName)

		'�R�[�X�����P�s�ӂ�̍s���̔{���ɂȂ�܂Ŕz����g�����A���Ƃ̕\��������e�Ղɂ���
		Do UNTIL lngSelCsCount Mod CSCOUNT_PER_ROW = 0
			ReDim Preserve strSelCsCd(lngSelCsCount)
			ReDim Preserve strSelCsName(lngSelCsCount)
			lngSelCsCount = lngSelCsCount + 1
		Loop
%>
		<TR>
			<TD></TD>
			<TD VALIGN="top" NOWRAP>�R�[�X</TD>
			<TD VALIGN="top">�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
<%
					'�g�Ǘ��R�[�X�̃e�[�u���\��
					j = 0
					Do Until j >= lngSelCsCount
%>
						<TR>
<%
							For i = 1 To CSCOUNT_PER_ROW

								If strSelCsCd(j) <> "" Then

									'���[�h�w�莞�͑I���R�[�X�݂̂��`�F�b�N��Ԃɂ���
									If strMode <> "" Then

										strChecked = ""
										If IsArray(strCsCd) Then
											For k = 0 To UBound(strCsCd)
												If strCsCd(k) = strSelCsCd(j) Then
													strChecked = " CHECKED"
													Exit For
												End If
											Next
										End If

									'���[�h���w�莞�͂��ׂẴR�[�X���`�F�b�N��Ԃɂ���
									Else
										strChecked = " CHECKED"
									End If
%>
									<TD><INPUT TYPE="checkbox" NAME="csCd" VALUE="<%= strSelCsCd(j) %>"<%= strChecked %>></TD>
									<TD NOWRAP><%= strSelCsName(j) %></TD>
<%
								End If

								j = j + 1
							Next
%>
						</TR>
<%
					Loop
%>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD NOWRAP>����</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
					<TR>
						<TD><INPUT TYPE="radio" NAME="gender" VALUE=""<%= IIf(strGender <> "1" And strGender <> "2", " CHECKED", "") %>></TD>
						<TD NOWRAP>�S��
						<TD><INPUT TYPE="radio" NAME="gender" VALUE="1"<%= IIf(strGender = "1", " CHECKED", "") %>></TD>
						<TD NOWRAP>�j���̂�</TD>
						<TD><INPUT TYPE="radio" NAME="gender" VALUE="2"<%= IIf(strGender = "2", " CHECKED", "") %>></TD>
						<TD NOWRAP>�����̂�</TD>
						<TD><A HREF="javascript:submitForm('disp')"><IMG SRC="../../../images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="�w������ŕ\��"></A>&nbsp;</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
</FORM>
<BR>
<%
'���[�h���w�莞�͈ȉ��̏������s��Ȃ�
If strMode = "" Then
	Response.End
End If

'���t�`�F�b�N
If Not IsDate(strCslDate) Then
	Response.Write "��f���̌`��������������܂���B"
	Response.End
End If

If Not IsArray(strCsCd) Then
	Response.Write "�R�[�X��I�����Ă��������B"
	Response.End
End If

'�J�n�E�I����f���̐ݒ�
dtmStrCslDate = CDate(strCslDate)
dtmEndCslDate = dtmStrCslDate + 6

'�\��l�����ǂݍ���
lngCount = objSchedule.SelectRsvFraMngList_Capacity( _
               dtmStrCslDate,    _
               dtmEndCslDate,    _
               strCsCd, ,        _
               strArrCslDate,    _
               strArrHoliday,    _
               strArrRsvGrpCd,   _
               strArrRsvGrpName, _
               strArrStrTime,    _
               strArrCsCd,       _
               strArrCsName,     _
               strArrCsSName,    _
               strArrWebColor,   _
               strArrMngGender,  _
               strArrMaxCnt,     _
               strArrMaxCnt_M,   _
               strArrMaxCnt_F,   _
               strArrOverCnt,    _
               strArrOverCnt_M,  _
               strArrOverCnt_F,  _
               strArrRsvCnt_M,   _
               strArrRsvCnt_F    _
           )

Set objSchedule = Nothing

If lngCount <= 0 Then
	Response.Write "�w�肳�ꂽ�R�[�X�̗\��l�����͑��݂��܂���B"
	Response.End
End If
%>
�i�o�^�l���^�ő�l���j<BR>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" class="mensetsu-tb">
<%
	'�擪�s��ROWSPAN�l����(���ʎw�莞�͂P�A�����Ȃ��΂Q)
	lngRowSpan = IIf(strGender = "1" Or strGender = "2", 1, 2)

	'�擪�s��COLSPAN�l����(���ʎw�莞�͂P�A�����Ȃ��΂Q)
	lngColSpan = IIf(strGender = "1" Or strGender = "2", 1, 2)
%>
	<TR ALIGN="center" BGCOLOR="#eeeeee">
		<TD ROWSPAN="<%= lngRowSpan %>" NOWRAP>���t</TD>
		<TD ROWSPAN="<%= lngRowSpan %>" NOWRAP>�j��</TD>
		<TD ROWSPAN="<%= lngRowSpan %>" NOWRAP>�\��Q</TD>
<%
		'�ŏ��̓��t�̍ŏ��̗\��Q�̃��R�[�h�݂̂��������A�R�[�X����ҏW����
		i = 0
		Do
%>
			<TD COLSPAN="<%= lngColSpan %>"<%= IIf(lngColSpan = 1, " WIDTH=""80""", "") %> NOWRAP><%= strArrCsSName(i) %></TD>
<%
			'�R�[�X�����J�E���g(���s�ŗp����)
			lngCourseCount = lngCourseCount + 1

			'���̃��R�[�h������
			i = i + 1

			'���R�[�h���Ō�܂Ō�������ΏI��
			If i >= lngCount Then
				Exit Do
			End If

			'���O���R�[�h�Ǝ�f���܂��͗\��Q���قȂ�ꍇ�͏I��
			If strArrCslDate(i) <> strArrCslDate(i - 1) Or strArrRsvGrpCd(i) <> strArrRsvGrpCd(i - 1) Then
				Exit Do
			End If

		Loop
%>
	</TR>
<%
	'�����̐��ʂ�\������ꍇ
	If strGender <> "1" And strGender <> "2" Then

		'���ʗp�̗��ҏW����
%>
		<TR ALIGN="center" BGCOLOR="#eeeeee">
<%
			'�R�[�X�����j�����ҏW
			For i = 0 To lngCourseCount - 1
%>
				<TD WIDTH="55" NOWRAP>�j</TD>
				<TD WIDTH="55" NOWRAP>��</TD>
<%
			Next
%>
		</TR>
<%
	End If

	'�ŏ��̓��t�݂̂��������A�\��Q�����J�E���g
	i = 0
	lngRsvGrpCount = 0
	strPrevRsvGrpCd = 0
	Do Until i >= lngCount

		'�Q���R�[�h�ڈȍ~�̏ꍇ
		If i > 0 Then

			'���O���R�[�h�Ǝ�f�����قȂ�ꍇ�͏I��
			If strArrCslDate(i) <> strArrCslDate(i - 1) Then
				Exit Do
			End If

			'���O���R�[�h�Ɨ\��Q���قȂ�ꍇ�͗\��Q�����J�E���g
			If strArrRsvGrpCd(i) <> strArrRsvGrpCd(i - 1) Then
				lngRsvGrpCount = lngRsvGrpCount + 1
			End If

		'�擪���R�[�h�̏ꍇ
		Else

			'�擪���R�[�h�̏ꍇ�̓J�E���g
			lngRsvGrpCount = lngRsvGrpCount + 1

		End If

		i = i + 1
	Loop

	'�\��l�����̕ҏW�J�n
	i = 0
	Do Until i >= lngCount

		'�j�������߂�
		lngWeekday = Weekday(strArrCslDate(i))

		'CLASS�v���p�e�B(�j���̐F)�̐ݒ�
		Select Case lngWeekDay

			Case 1	'���j

				strClass = "holiday"

			Case 7	'�y�j

				strClass = "saturday"

				'�j���͂����D��
				If strArrHoliday(i) = "2" Then
					strClass = "holiday"
				End If

			Case Else	'����

				strClass = "weekday"

				'�x�f���A�j���͂����D��
				If strArrHoliday(i) <> "" Then
					strClass = "holiday"
				End If

		End Select

		'�\��l�����̗L��������
		j = i
		blnExists = False
		Do

			'����Ό����I��
			If strArrMaxCnt(j) <> "" Then
				blnExists = True
				Exit Do
			End If

			'���̃��R�[�h������
			j = j + 1

			'���R�[�h���Ō�܂Ō�������ΏI��
			If j >= lngCount Then
				Exit Do
			End If

			'���O���R�[�h�Ǝ�f�����قȂ�ꍇ�͏I��
			If strArrCslDate(j) <> strArrCslDate(j - 1) Then
				Exit Do
			End If

		Loop

		'�\��l����񂪑��݂���ꍇ
		If blnExists Then

			'�e�\��Q���Ƃ̕ҏW
			For j = 1 To lngRsvGrpCount
%>
				<TR>
<%
					'�擪�̏ꍇ�̂ݓ��t��ҏW
					If j = 1 Then
%>
						<TD ROWSPAN="<%= lngRsvGrpCount %>" VALIGN="top" NOWRAP><%= strArrCslDate(i) %></TD>
						<TD ROWSPAN="<%= lngRsvGrpCount %>" VALIGN="top" NOWRAP ALIGN="center" CLASS="<%= strClass %>"><B><%= Left(WeekdayName(lngWeekday), 1) %></B></TD>
<%
					End If
%>
					<TD NOWRAP><%= strArrRsvGrpName(i) %></TD>
<%
					'�e�R�[�X���Ƃ̕ҏW
					For k = 1 To lngCourseCount

						'�g�Ǘ����@���Ƃ̏�������
						Select Case ManageGender(strArrMngGender(i), strArrMaxCnt(i), strArrMaxCnt_M(i), strArrMaxCnt_F(i))

							'�j���ʘg�Ǘ����s��Ȃ��ꍇ
							Case "0"

								'�\��l�����̕ҏW(�j���ʂ̕\�����@�Ɉˑ����Ȃ�)
								If strArrMaxCnt(i) <> "" Then

									'�\��l�����v�Z
									lngRsvCount = CLng(strArrRsvCnt_M(i)) + CLng(strArrRsvCnt_F(i))

									'�ő�l�����v�Z
									lngMaxCount = CLng(strArrMaxCnt(i)) + CLng(strArrOverCnt(i))
'## 2004.03.01 Mod By T.Takagi@FSIT �\��l�����ő�l���ɂăO���[�\��
'									lngMaxCount = CLng(strArrMaxCnt(i)) + CLng(strArrOverCnt(i))
									lngMaxCount = CLng(strArrMaxCnt(i)) + IIf(strArrCsCd(i) = CSCD_GI, 0, CLng(strArrOverCnt(i)))	'GI�g�̏ꍇ�A�I�[�o�g�𖳎�
'## 2004.03.01 Mod End

									'�\��l���ƍő�l�����r���A�Z���F��ݒ�
'## 2004.03.01 Mod By T.Takagi@FSIT �\��l�����ő�l���ɂăO���[�\��
'									strColor = IIf(lngRsvCount > lngMaxCount, "cccccc", "ffffff")
									If lngRsvCount <> 0 Or lngMaxCount <> 0 Then
										strColor = IIf(lngRsvCount >= lngMaxCount, "cccccc", "ffffff")
									Else
										strColor = "ffffff"
									End If
'## 2004.03.01 Mod End

									'�ҏW�p�̗\��l���ҏW
									If lngRsvCount <> 0 Or lngMaxCount <> 0 Then
										strRsvCount = lngRsvCount & "/" & strArrMaxCnt(i)
										If CLng(strArrOverCnt(i)) <> 0 Then
											strRsvCount = strRsvCount & "(" & strArrOverCnt(i) & ")"
										End If
									Else
										strRsvCount = "&nbsp;"
									End If

								'�\��l����񂪑��݂��Ȃ��ꍇ
								Else

									strColor    = "ffffff"
									strRsvCount = "&nbsp;"

								End If

								'COLSPAN�l�̐���
								lngColSpan = IIf(strGender <> "1" And strGender <> "2", 2, 1)
%>
								<TD COLSPAN="<%= lngColSpan %>" ALIGN="center" BGCOLOR="#<%= strColor %>"><%= strRsvCount %></TD>
<%
							'�j���ʘg�Ǘ����s���ꍇ
							Case "1"

								'�\��l�����̕ҏW
								If strArrMaxCnt(i) <> "" Then

									'�����̐l����\�����Ȃ��ꍇ
									If strGender <> "2" Then

										'�\��l�����v�Z
										lngRsvCount = CLng(strArrRsvCnt_M(i))

										'�ő�l�����v�Z
'## 2004.03.01 Mod By T.Takagi@FSIT �\��l�����ő�l���ɂăO���[�\��
'										lngMaxCount = CLng(strArrMaxCnt_M(i)) + CLng(strArrOverCnt_M(i))
										lngMaxCount = CLng(strArrMaxCnt_M(i)) + IIf(strArrCsCd(i) = CSCD_GI, 0, CLng(strArrOverCnt_M(i)))	'GI�g�̏ꍇ�A�I�[�o�g�𖳎�
'## 2004.03.01 Mod End

										'�\��l���ƍő�l�����r���A�Z���F��ݒ�
'## 2004.03.01 Mod By T.Takagi@FSIT �\��l�����ő�l���ɂăO���[�\��
'										strColor = IIf(lngRsvCount > lngMaxCount, "cccccc", "ffffff")
										If lngRsvCount <> 0 Or lngMaxCount <> 0 Then
											strColor = IIf(lngRsvCount >= lngMaxCount, "cccccc", "ffffff")
										Else
											strColor = "ffffff"
										End If
'## 2004.03.01 Mod End
										'�ҏW�p�̗\��l���ҏW
										If lngRsvCount <> 0 Or lngMaxCount <> 0 Then
											strRsvCount = lngRsvCount & "/" & strArrMaxCnt_M(i)
											If CLng(strArrOverCnt_M(i)) <> 0 Then
												strRsvCount = strRsvCount & "(" & strArrOverCnt_M(i) & ")"
											End If
										Else
											strRsvCount = "&nbsp;"
										End If
%>
										<TD ALIGN="center" BGCOLOR="#<%= strColor %>" NOWRAP><%= strRsvCount %></TD>
<%
									End If

									'�j���̐l����\�����Ȃ��ꍇ
									If strGender <> "1" Then

										'�\��l�����v�Z
										lngRsvCount = CLng(strArrRsvCnt_F(i))

										'�ő�l�����v�Z
'## 2004.03.01 Mod By T.Takagi@FSIT �\��l�����ő�l���ɂăO���[�\��
'										lngMaxCount = CLng(strArrMaxCnt_F(i)) + CLng(strArrOverCnt_F(i))
										lngMaxCount = CLng(strArrMaxCnt_F(i)) + IIf(strArrCsCd(i) = CSCD_GI, 0, CLng(strArrOverCnt_F(i)))	'GI�g�̏ꍇ�A�I�[�o�g�𖳎�
'## 2004.03.01 Mod End
										'�\��l���ƍő�l�����r���A�Z���F��ݒ�
'## 2004.03.01 Mod By T.Takagi@FSIT �\��l�����ő�l���ɂăO���[�\��
'										strColor = IIf(lngRsvCount > lngMaxCount, "cccccc", "ffffff")
										If lngRsvCount <> 0 Or lngMaxCount <> 0 Then
											strColor = IIf(lngRsvCount >= lngMaxCount, "cccccc", "ffffff")
										Else
											strColor = "ffffff"
										End If
'## 2004.03.01 Mod End
										'�ҏW�p�̗\��l���ҏW
										If lngRsvCount <> 0 Or lngMaxCount <> 0 Then
											strRsvCount = lngRsvCount & "/" & strArrMaxCnt_F(i)
											If CLng(strArrOverCnt_F(i)) <> 0 Then
												strRsvCount = strRsvCount & "(" & strArrOverCnt_F(i) & ")"
											End If
										Else
											strRsvCount = "&nbsp;"
										End If
%>
										<TD ALIGN="center" BGCOLOR="#<%= strColor %>" NOWRAP><%= strRsvCount %></TD>
<%
									End If

								'�\��l����񂪑��݂��Ȃ��ꍇ
								Else

									If strGender <> "1" And strGender <> "2" Then
%>
										<TD BGCOLOR="#ffffff">&nbsp;</TD>
										<TD BGCOLOR="#ffffff">&nbsp;</TD>
<%
									Else
%>
										<TD BGCOLOR="#ffffff">&nbsp;</TD>
<%
									End If

								End If

							'�j���ʂ̘g�Ǘ����@���ʂ��ł��Ȃ��ꍇ
							Case Else

								'COLSPAN�l�̐���
								lngColSpan = IIf(strGender <> "1" And strGender <> "2", 2, 1)
%>
								<TD COLSPAN="<%= lngColSpan %>" BGCOLOR="#ffffff">&nbsp;</TD>
<%
						End Select

						i = i + 1
					Next
%>
				</TR>
<%
			Next

		'�\��l����񂪑��݂��Ȃ��ꍇ
		Else
%>
			<TR>
				<TD NOWRAP><%= strArrCslDate(i) %></TD>
				<TD NOWRAP ALIGN="center" CLASS="<%= strClass %>"><B><%= Left(WeekdayName(lngWeekday), 1) %></B></TD>
				<TD COLSPAN="<%= lngCourseCount * IIf(strGender <> "1" And strGender <> "2", 2, 1) + 1 %>">
<%
					Select Case strArrHoliday(i)
						Case "1"
							Response.Write "�x��"
						Case "2"
							Response.Write "�x��"
						Case Else
							Response.Write "�\��g�Ȃ�"
					End Select
%>
				</TD>
			</TR>
<%
			'��f�����ς�邩���R�[�h���Ō�܂Ō�������܂ŃC���f�b�N�X��i�߂�
			Do

				i = i + 1

				'���R�[�h���Ō�܂Ō�������ΏI��
				If i >= lngCount Then
					Exit Do
				End If

				'���O���R�[�h�Ǝ�f�����قȂ�ꍇ�͏I��
				If strArrCslDate(i) <> strArrCslDate(i - 1) Then
					Exit Do
				End If

			Loop

		End If

	Loop
%>
</TABLE>
</div>
</BODY>
</HTML>
