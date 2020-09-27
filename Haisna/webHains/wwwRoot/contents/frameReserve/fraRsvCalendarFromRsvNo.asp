<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�\��g����(�J�����_�[����) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/recentConsult.inc"  -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const CALENDAR_HEIGHT = 23	'�J�����_�[�̍s������̍���

Const STATUS_PAST        = "0"	'�J�����_�[���t���(�ߋ��E�����\��\)
Const STATUS_NORMAL      = "1"	'�J�����_�[���t���(�󂫂���)
Const STATUS_OVER        = "2"	'�J�����_�[���t���(�I�[�o�����\��\)
Const STATUS_FULL        = "3"	'�J�����_�[���t���(�󂫂Ȃ��E�����\��\)
Const STATUS_NO_RSVFRA   = "4"	'�J�����_�[���t���(�g�Ȃ��E�g�Ȃ������\��Ȃ�\)
Const STATUS_NO_CONTRACT = "5"	'�J�����_�[���t���(�_��Ȃ��E�\��s�\)
Const STATUS_DIFFER_SET  = "6"	'�J�����_�[���t���(�Z�b�g���ق���E�\��s�\)

Const COLOR_NOTHING     = "#ffffff"	'�J�����_�[�\���F(�Ȃ�)
Const COLOR_NORMAL      = "#afeeee"	'�J�����_�[�\���F(�󂫂���)
Const COLOR_OVER        = "#ff6347"	'�J�����_�[�\���F(�I�[�o�����\��\)
Const COLOR_FULL        = "#ff6347"	'�J�����_�[�\���F(�󂫂Ȃ�)
Const COLOR_NO_RSVFRA   = "#ffcccc"	'�J�����_�[�\���F(�g�Ȃ�)
Const COLOR_NO_CONTRACT = "#cccccc"	'�J�����_�[�\���F(�_��Ȃ�)
Const COLOR_HOLIDAY     = "#90ee90"	'�J�����_�[�\���F(�x��)
Const COLOR_DIFFER_SET  = "#ffff99"	'�J�����_�[�\���F(�Z�b�g����)

Const MARK_OVER = "��"	'�I�[�o���̃}�[�N

Const IGNORE_EXCEPT_NO_RSVFRA = "1"	'�\��g��������(�g�Ȃ��̓��t�����������\�񂪉\)
Const IGNORE_ANY              = "2"	'�\��g��������(�����鋭���\�񂪉\)

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objConsult			'��f���A�N�Z�X�p
Dim objConsultAll		'��f���A�N�Z�X�p
Dim objContract			'�_����A�N�Z�X�p
Dim objFree				'�ėp���A�N�Z�X�p
Dim objOrganization		'�c�̏��A�N�Z�X�p
Dim objPerson			'�l���A�N�Z�X�p
Dim objSchedule			'�X�P�W���[�����A�N�Z�X�p

'�����l
Dim strMode				'�������[�h(MODE_NORMAL:�ʏ�AMODE_SAME_RSVGRP:�����\��Q�Z�b�g�O���[�v�Ō���)
Dim lngCslYear			'��f�N
Dim lngCslMonth			'��f��
Dim lngCslDay			'��f��
Dim lngIgnoreFlg		'�\��g�����t���O

Dim strParaRsvNo		'�\��ԍ�
Dim strParaRsvGrpCd		'�\��Q�R�[�h

Dim strRsvNo			'�\��ԍ�
Dim strRsvGrpCd			'�\��Q�R�[�h

'�I�v�V�������
Dim strArrOptCd			'�I�v�V�����R�[�h
Dim strArrOptBranchNo	'�I�v�V�����}��
Dim strArrOptSName		'�I�v�V��������
Dim lngOptCount			'�I�v�V������
Dim strDispOptName		'�I�v�V������

'��f���
Dim strPerId			'�l�h�c
Dim strOrgCd1			'�c�̃R�[�h�P
Dim strOrgCd2			'�c�̃R�[�h�Q
Dim strCtrPtCd			'�_��p�^�[���R�[�h
Dim strCsCd				'�R�[�X�R�[�h
Dim strCsName			'�R�[�X��
Dim strCurCslDate		'���݂̎�f��

'�l���
Dim strLastName			'��
Dim strFirstName		'��
Dim strLastKName		'�J�i��
Dim strFirstKName		'�J�i��
Dim strPerBirth			'���N����
Dim strPerGender		'����
Dim strPerAge			'��f���N��

'�ҏW�p�̌l���
Dim strPerName			'����
Dim strPerBirthJpn		'���N����
Dim strPerGenderJpn		'����
Dim strDispManCnt		'��������

'�c�̏��
Dim strOrgName			'�c�̖���
Dim strOrgKName			'�c�̃J�i����

'�J�����_�[���
Dim strCslDate			'��f��
Dim strHoliday			'�x�f��
Dim strStatus			'���
Dim lngCount			'����

'�J�����_�[�ҏW�p(�V���~�\���ɗv����ő�T���U���S�Q�̔z��)
Dim strEditDay(41)		'���t
Dim strEditHoliday(41)	'�x�f��
Dim strEditStatus(41)	'�x�f��

'�󂫗\��Q�������
Dim strFindHoliday		'�x�f��
Dim strFindStatus		'���
Dim strFindRsvGrpCd		'�������ꂽ�\��Q

Dim lngWeekDay			'�j��(1:���j�`7:�y�j)
Dim lngPtr				'�ҏW�p�z��̃|�C���^
Dim strHeight			'HEIGHT�v���p�e�B�p
Dim strClass			'CLASS�v���p�e�B�p
Dim strColor			'�Z���F
Dim strDay				'���t

Dim strStrRsvNo			'�J�n�\��ԍ�
Dim strEndRsvNo			'�I���\��ԍ�

Dim dtmCslDate			'��f��
Dim lngYear				'�N
Dim lngMonth			'��
Dim blnAnchor			'�A���J�[�v��
Dim strMessage			'���b�Z�[�W
Dim strHTML				'HTML������
Dim strURL				'URL������
Dim Ret					'�֐��߂�l
Dim i, j				'�C���f�b�N�X

Dim strArrCslDate		'��f���̔z��
Dim strArrRsvNo			'�\��ԍ��̔z��

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�����l�̎擾
strMode         = Request("mode")
lngCslYear      = CLng("0" & Request("cslYear"))
lngCslMonth     = CLng("0" & Request("cslMonth"))
lngCslDay       = CLng("0" & Request("cslDay"))
lngIgnoreFlg    = CLng("0" & Request("ignoreFlg"))
strParaRsvNo    = Request("rsvNo")
strParaRsvGrpCd = Request("rsvGrpCd")

'�Z�p���[�^�ŕ������A�z��
strRsvNo    = Split(strParaRsvNo,    Chr(1))
strRsvGrpCd = Split(strParaRsvGrpCd, Chr(1))

'����������P���w�肵���ꍇ�A�l�����݂��Ȃ��Ɣz��ƂȂ�Ȃ��B
'�����ł����ł͕K�����݂��鍀�ڂ̂P�ł���\��ԍ��̔z�񐔂����Ƃɋ�̔z����쐬����B
If UBound(strRsvNo) = 0 Then
	If UBound(strRsvGrpCd) < 0 Then
		ReDim Preserve strRsvGrpCd(0)
	End If
End If

'�\�񏈗�����
Do

	'��f�����w�莞�͉������Ȃ�
	If lngCslDay = 0 Then
		Exit Do
	End If

	'��f�N�����̐ݒ�
	dtmCslDate = CDate(lngCslYear & "/" & lngCslMonth & "/" & lngCslDay)

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objConsultAll = Server.CreateObject("HainsConsult.ConsultAll")

	'�ꊇ��f���ύX����
	Ret = objConsultAll.ChangeDate(strMode, Session("USERID"), lngIgnoreFlg, dtmCslDate, strRsvNo, strRsvGrpCd, strMessage)

	Set objConsultAll = Nothing

	'��f���̕ύX�ɂ���ăG���[�����������ꍇ�̓J�����_�[�������̂��ł��Ȃ��Ȃ邽�߁A���̏ꍇ��Raise���ɂ��G���[���b�Z�[�W�Ƃ���
	If Ret = -2 Then
		Err.Raise 1000, , strMessage
	End If

	'�g�֘A�Ɋւ���G���[�̏ꍇ�͒ʏ�̏����Ɉς˂�
	If Ret < 0 Then
		Exit Do
	End If

	'���펞�͂܂������ʒm��ʗp��URL���쐬����
	strURL = "fraRsvCslListChangedDate.asp?cslDate=" & dtmCslDate
	For i = 0 To UBound(strRsvNo)
		strURL = strURL & "&rsvNo=" & strRsvNo(i)
	Next

	'�e���(��f���ꊇ�ύX���)�����_�C���N�g����
	strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
	strHTML = strHTML & vbCrLf & "<SCRIPT TYPE=""text/javascript"">"
	strHTML = strHTML & vbCrLf & "<!--"
	strHTML = strHTML & vbCrLf & "if ( opener ) {"
	strHTML = strHTML & vbCrLf & "    opener.location.href = '" & strURL & "';"
	strHTML = strHTML & vbCrLf & "}"
	strHTML = strHTML & vbCrLf & "//-->"
	strHTML = strHTML & vbCrLf & "</SCRIPT>"
	strHTML = strHTML & vbCrLf & "</HTML>"
	Response.Clear
	Response.Write strHTML
	Response.End

	Exit Do
Loop

'�擪�̎�f��������e������擾

Set objConsult = Server.CreateObject("HainsConsult.Consult")

'��f���ǂݍ���
If objConsult.SelectConsult(strRsvNo(0), , , strPerId, , , strOrgCd1, strOrgCd2, , , , strPerAge, , , , , , , , , , , , , , , , , , , , , , , , , , , , , strCtrPtCd, , strLastName, strFirstName, strLastKName, strFirstKName, strPerBirth, strPerGender) = False Then
	Err.Raise 1000, , "��f��񂪑��݂��܂���B"
End If

'�I�v�V�������ǂݍ���
lngOptCount = objConsult.SelectConsult_O(strRsvNo(0), strArrOptCd, strArrOptBranchNo, , , strArrOptSName)

'�I�v�V�������̕ҏW
If lngOptCount > 0 Then
	strDispOptName = "�@�i" & Join(strArrOptSName, "�A") & "�j"
End If

Set objConsult = Nothing

'�����̕ҏW
strPerName = "<B>" & Trim(strLastName  & "�@" & strFirstName) & "</B><FONT COLOR=""#999999"">�i" & Trim(strLastKName & "�@" & strFirstKName) & "�j</FONT>"

'�N��̏����_�ȉ�������
strPerAge = CStr(CInt(strPerAge))

Set objCommon = Server.CreateObject("HainsCommon.Common")

'���N�����̕ҏW
strPerBirthJpn = objCommon.FormatString(strPerBirth, "ge.m.d") & "���@"

Set objCommon = Nothing

'���ʂ̕ҏW
strPerGenderJpn = IIf(strPerGender = CStr(GENDER_MALE), "�j��", "����")

Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

'�c�̏��ǂݍ���
objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2, , strOrgKName, strOrgName

Set objOrganization = Nothing

Set objContract = Server.CreateObject("HainsContract.Contract")

'�R�[�X���̎擾
objContract.SelectCtrPt strCtrPtCd, , , , , strCsName

Set objContract = Nothing

'��f�l���̕ҏW
If UBound(strRsvNo) > 0 Then
	strDispManCnt = "��" & UBound(strRsvNo) & "��"
End If

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objSchedule = Server.CreateObject("HainsSchedule.Calendar")

'�w��N���̗\��󂫏󋵎擾
lngCount = objSchedule.GetEmptyCalendarFromRsvNo(strMode, lngCslYear, lngCslMonth, strRsvNo, strRsvGrpCd, strCslDate, strHoliday, strStatus)

Set objSchedule = Nothing

'�擪���̗j�������߂�
lngWeekDay = WeekDay(strCslDate(0))

'�擪���ɒB����܂Ń|�C���^���ړ�
lngPtr = lngWeekDay - 1

'�ҏW�p�z��ւ̊i�[
For i = 0 To lngCount - 1
	strEditDay(lngPtr)     = Day(strCslDate(i))
	strEditHoliday(lngPtr) = strHoliday(i)
	strEditStatus(lngPtr)  = strStatus(i)
	lngPtr = lngPtr + 1
Next

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �Z���F�̐ݒ�
'
' �����@�@ : (In)     strDay      ���t
' �@�@�@�@   (In)     strHoliday  �x�f��
' �@�@�@�@   (In)     strStatus   ���
'
' �߂�l�@ : �Z���F(�ڍׂ�Const��`���Q��)
'
'-------------------------------------------------------------------------------
Function CellColor(strDay, strHoliday, strStatus)

    Dim strColor	'�Z���F

    '�Z���F(�󂫏�Ԃ̐F)�̐ݒ�
    If strDay <> "" Then

        '���t���ݎ�
        Select Case strStatus

            Case STATUS_PAST	'�ߋ�

                'strColor = IIf(strHoliday > 0, COLOR_HOLIDAY, COLOR_NOTHING)
                strColor = COLOR_NOTHING

            Case STATUS_NORMAL  '�g����

                '## 2006.07.12 �� �x���A�j���̏ꍇ�A�g�󋵂Ɋ֌W�Ȃ����ׂāu�g�Ȃ��v�ŕ\������悤�ɕύX
                'strColor = COLOR_NORMAL
                strColor = IIf(strHoliday <> "", COLOR_NO_RSVFRA, COLOR_NORMAL)

            Case STATUS_OVER    '�g�I�[�o

                '## 2006.07.12 �� �x���A�j���̏ꍇ�A�g�󋵂Ɋ֌W�Ȃ����ׂāu�g�Ȃ��v�ŕ\������悤�ɕύX
                'strColor = COLOR_OVER
                strColor = IIf(strHoliday <> "", COLOR_NO_RSVFRA, COLOR_OVER)

            Case STATUS_FULL    '�󂫂Ȃ�

                '## 2006.07.12 �� �x���A�j���̏ꍇ�A�g�󋵂Ɋ֌W�Ȃ����ׂāu�g�Ȃ��v�ŕ\������悤�ɕύX
                'strColor = COLOR_FULL
                strColor = IIf(strHoliday <> "", COLOR_NO_RSVFRA, COLOR_FULL)

            Case STATUS_NO_RSVFRA   '�g�Ȃ�

                'strColor = IIf(strHoliday > 0, COLOR_HOLIDAY, COLOR_NO_RSVFRA)
                strColor = COLOR_NO_RSVFRA

            Case STATUS_NO_CONTRACT '�_��Ȃ�

                strColor = COLOR_NO_CONTRACT

            Case Else	'���̑�(�ꉞ)

                '## 2006.07.12 �� �x���A�j���̏ꍇ�A�g�󋵂Ɋ֌W�Ȃ����ׂāu�g�Ȃ��v�ŕ\������悤�ɕύX
                'strColor = COLOR_NORMAL
                strColor = IIf(strHoliday <> "", COLOR_NO_RSVFRA, COLOR_NORMAL)

        End Select

    '���t���Ȃ���ΐݒ肵�Ȃ�
    Else
        strColor = COLOR_NOTHING
    End If

    CellColor = strColor

End Function
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �\��Q���w�茟�������̑��݂��`�F�b�N
'
' �����@�@ :
'
' �߂�l�@ : True   ����
' �@�@�@�@   False  �Ȃ�
'
'-------------------------------------------------------------------------------
Function ExistsNoRsvFra()

	Dim Ret	'�֐��߂�l
	Dim i	'�C���f�b�N�X

	'�\��Q���w�茟�������̑��݂��`�F�b�N
	Ret = False
	For i = 0 To UBound(strRsvGrpCd)
		If strRsvGrpCd(i) = "" Then
			Ret = True
			Exit For
		End If
	Next

	ExistsNoRsvFra = Ret

End Function
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �A���J�[�v��(�\���)�̔���
'
' �����@�@ : (In)     strStatus  ���
'
' �߂�l�@ : True   �K�v
' �@�@�@�@   False  �s�v
'
'-------------------------------------------------------------------------------
Function NeedAnchor(strStatus)

	Dim Ret	'�֐��߂�l

	Do

		Ret = True

		'�_��Ȃ��A�Z�b�g���قȂ�s�v
		If strStatus = STATUS_NO_CONTRACT Or strStatus = STATUS_DIFFER_SET Then
			Ret = False
			Exit Do
		End If

		'�\��Q���w�茟�����������݂���ꍇ�A�����\��͂ł��Ȃ�(�����\�񎞂ɋ󂫂̂���\��Q���������邱�Ƃ�������s�\)
		If ExistsNoRsvFra() Then
			Ret = (strStatus = STATUS_NORMAL Or strStatus = STATUS_OVER)
			Exit Do
		End If

		'�\��Q���w�茟�����������݂��Ȃ���΁A�����ɂ�鋭���\��ې�����s��
		Select Case Session("IGNORE")

			Case IGNORE_ANY	'�����鋭���\��\
				Exit Do

			Case IGNORE_EXCEPT_NO_RSVFRA	'�g�Ȃ��ȊO�̋����\��\

				'�g�Ȃ��Ȃ�s�v
				If strStatus = STATUS_NO_RSVFRA Then
					Ret = False
					Exit Do
				End If

			Case Else	'�ʏ�

				'�󂫂���A�I�[�o�ȊO�Ȃ�s�v
				If strStatus <> STATUS_NORMAL And strStatus <> STATUS_OVER Then
					Ret = False
					Exit Do
				End If

		End Select

		Exit Do
	Loop

	NeedAnchor = Ret

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�J�����_�[����</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// ���t�I��
function selDate( day, force ) {

	var entForm  = document.entryForm;
	var paraForm = document.paramForm;

	// �����\�񎞂͋����\��`�F�b�N���K�v�ƂȂ�
	if ( force ) {
		if ( paraForm.ignoreFlg.value == '0' ) {
			alert('�����\�񎞂͕K���u�����\����s���v���`�F�b�N��A���{���Ă��������B');
			return;
		}
	}

	var year  = entForm.curCslYear.value;
	var month = entForm.curCslMonth.value;

	// ���b�Z�[�W�̕\��
	if ( !confirm( '��f����' + year + '�N' + month + '��' + day + '����' + ( force ? '����' : '' ) + '�ύX���܂��B��낵���ł����H' ) ) {
		return;
	}

	// �߂���f���Ō��f��������ꍇ�̓��[�j���O�\�����s��
	var msg = checkRecentConsult( year, month, day );
	if ( msg != '' ) {
		if ( !confirm( msg + '\n\n�\����s���܂����H' ) ) {
			return;
		}
	}

	// submit����
	paraForm.cslYear.value  = year;
	paraForm.cslMonth.value = month;
	paraForm.cslDay.value   = day;
	paraForm.submit();

}

// �N���̕ύX
function changeDate( year, month ) {

	var objForm  = document.paramForm;
	var objYear  = objForm.cslYear;
	var objMonth = objForm.cslMonth;

	// �N���̐ݒ�
	if ( year != null ) {
		objYear.value  = year;
		objMonth.value = month;
	} else {
		objYear.value  = document.entryForm.cslYear.value;
		objMonth.value = document.entryForm.cslMonth.value;
	}

	objForm.submit();

}

function onChangeDate()
{
    changeDate();
}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
<!-- #include virtual = "/webHains/contents/css/calender.css" -->
</STYLE>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY>
<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
	<TR>
		<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000">�J�����_�[����</FONT></B></TD>
	</TR>
</TABLE>
<%
'�G���[���b�Z�[�W�̕ҏW
If strMessage <> "" Then
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)
End If
%>
<BR>
<%
'�����������������݂���ꍇ�̃��b�Z�[�W
If UBound(strRsvNo) > 0 Then
%>
	<FONT COLOR="#cc9999">��</FONT>�擪�̌��������̂ݕ\�����Ă��܂��B<BR><BR>
<%
End If

'�擪�̌���������ҏW
%>
<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
	<TR>
		<TD WIDTH="60" NOWRAP>�l��</TD>
		<TD>�F</TD>
		<TD NOWRAP><%= strPerId %></TD>
		<TD>&nbsp;</TD>
		<TD NOWRAP><%= strPerName %></TD>
		<TD NOWRAP><FONT COLOR="#ff8c00"><%= strDispManCnt %></FONT></TD>
	</TR>
	<TR>
		<TD COLSPAN="4"></TD>
		<TD NOWRAP><%= strPerBirthJpn %><%= strPerAge %>�΁@<%= strPerGenderJpn %></TD>
	</TR>
</TABLE>
<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
	<TR>
		<TD WIDTH="60" NOWRAP>�c�̖�</TD>
		<TD>�F</TD>
		<TD NOWRAP><%= strOrgCd1 %>-<%= strOrgCd2 %></TD>
		<TD>&nbsp;</TD>
		<TD NOWRAP><B><%= strOrgName %></B><FONT COLOR="#999999">�i<%= strOrgKName %>�j</FONT></TD>
	</TR>
</TABLE>
<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
	<TR>
		<TD WIDTH="60" NOWRAP>�R�[�X</TD>
		<TD>�F</TD>
		<TD NOWRAP><%= strCsName & strDispOptName %></TD>
	</TR>
</TABLE>
<BR>
<%
' ---------------------------------------- �}�� ----------------------------------------
%>
<FONT COLOR="<%= COLOR_NORMAL %>">��</FONT>�F�󂫂���A<FONT COLOR="<%= COLOR_FULL %>">��</FONT>�F�󂫂Ȃ��A<FONT COLOR="<%= COLOR_NO_RSVFRA %>">��</FONT>�F�\��g�Ȃ��E�x�f���E�j���A<FONT COLOR="<%= COLOR_NO_CONTRACT %>">��</FONT>�F�_����ԊO�A<FONT COLOR="<%= COLOR_DIFFER_SET %>">��</FONT>�F�Z�b�g�ύX�̕K�v������<!--�A<FONT COLOR="<%= COLOR_HOLIDAY %>">��</FONT>�F�x��--><BR><BR>
<FONT COLOR="#cc9999">��</FONT>�I�[�o�ƂȂ邪�\��\�ȓ��ɂ�<%= MARK_OVER %>��\�����Ă��܂��B
<%
' ---------------------------------------- �}�� ----------------------------------------
%>
<FORM NAME="entryForm" ACTION="" STYLE="margin:0px;">
<INPUT TYPE="hidden" NAME="curCslYear"  VALUE="<%= lngCslYear  %>">
<INPUT TYPE="hidden" NAME="curCslMonth" VALUE="<%= lngCslMonth %>">
<%
'�\��g���������ɂ�鐧��
Do

	'�����\�񌠌����Ȃ��ꍇ�͉������Ȃ�
	Select Case Session("IGNORE")
		Case IGNORE_ANY
		Case IGNORE_EXCEPT_NO_RSVFRA
		Case Else
			Response.Write "<BR>"
			Exit Do
	End Select

	'�\��Q���w�茟�����������݂���ꍇ�A�����\��͂ł��Ȃ�
	If ExistsNoRsvFra() Then
%>
		<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
			<TR>
				<TD HEIGHT="35"><IMG SRC="/webHains/images/ico_w.gif" WIDTH="16" HEIGHT="16" ALIGN="left" ALT=""></TD>
				<TD NOWRAP><FONT COLOR="#ff9900"><B>�\��Q�̎w�肳��Ă��Ȃ���������������܂��B�����\��͂ł��܂���B</B></FONT></TD>
			</TR>
		</TABLE>
<%
		Exit Do
	End If
%>
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD HEIGHT="35"><INPUT TYPE="checkbox"<%= IIf(lngIgnoreFlg > 0, " CHECKED", "") %> ONCLICK="javascript:document.paramForm.ignoreFlg.value = this.checked ? '<%= Session("IGNORE") %>' : '0'"></TD>
			<TD NOWRAP>�����\����s��</TD>
		</TR>
	</TABLE>
<%
	Exit Do
Loop
%>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
	<TR>
		<TD>
			<TABLE BORDER="1" CELLSPACING="0" CELLPADDING="1">
				<TR>
					<TD COLSPAN="7" ALIGN="center" VALIGN="bottom" HEIGHT="20"><B><%= lngCslYear %></B>�N<B><%= lngCslMonth %></B>��</TD>
				</TR>
				<TR ALIGN="center">
					<TD CLASS="holiday"  WIDTH="35"><B>��</B></TD>
					<TD CLASS="weekday"  WIDTH="35"><B>��</B></TD>
					<TD CLASS="weekday"  WIDTH="35"><B>��</B></TD>
					<TD CLASS="weekday"  WIDTH="35"><B>��</B></TD>
					<TD CLASS="weekday"  WIDTH="35"><B>��</B></TD>
					<TD CLASS="weekday"  WIDTH="35"><B>��</B></TD>
					<TD CLASS="saturday" WIDTH="35"><B>�y</B></TD>
				</TR>
<%
				'�J�����_�ҏW�J�n
				i = 0
				Do Until i >= UBound(strEditDay)
%>
					<TR ALIGN="right">
<%
						'�P��ڂ̂�HEIGHT�v���p�e�B�̐ݒ���s��
						strHeight = " HEIGHT=""" & CALENDAR_HEIGHT & """"

						Do

							'CLASS�v���p�e�B(���t�̐F)�̐ݒ�(index�l�Ŕ��f�Aweekday�֐��̒l�Ƃ͈قȂ�)
							Select Case i Mod 7

								Case 0	'���j

									strClass = "holiday"

								Case 6	'�y�j

									strClass = "saturday"

									'�j���͂����D��
'### 2004/09/06 Updated by Takagi@FSIT ���؂̘l��
'									If strEditHoliday(i) = "2" Then
									If strEditHoliday(i) <> "" Then
'### 2004/09/06 Updated End
										strClass = "holiday"
									End If

								Case Else	'����

									strClass = "weekday"

									'�x�f���A�j���͂����D��
									If strEditHoliday(i) <> "" Then
										strClass = "holiday"
									End If

							End Select

							'�Z���F(�󂫏�Ԃ̐F)�̐ݒ�
							strColor = CellColor(strEditDay(i), strEditHoliday(i), strEditStatus(i))


							'�A���J�[�v�ۂ̐ݒ�
							'blnAnchor = NeedAnchor(strEditStatus(i))

                            '## 2006.07.12 �� �x�f���A�j���̏ꍇ�A�g�󋵂Ɋ֌W�Ȃ��I���ł��Ȃ��悤�ɕύX Start
                            If strEditHoliday(i) <>"" Then
                                blnAnchor = False
                            Else
								'## 2006.07.12 �� �ߋ��̓��t�̏ꍇ�A�g�󋵂Ɋ֌W�Ȃ��I���ł��Ȃ��悤�ɕύX
								If strEditStatus(i) = STATUS_PAST Then
									blnAnchor = False
								Else
									blnAnchor = NeedAnchor(strEditStatus(i))
								End If        
                            End If
                            '## 2006.07.12 �� �x�f���A�j���̏ꍇ�A�g�󋵂Ɋ֌W�Ȃ��I���ł��Ȃ��悤�ɕύX End



							'�Z���l�̐ݒ�
							Do

								If strEditDay(i) = "" Then
									strDay = "&nbsp;"
									Exit Do
								End If

								'�ҏW�����񎩑̂̕ҏW
								strDay = IIf(strEditStatus(i) = STATUS_OVER, MARK_OVER, "") & strEditDay(i)

								'�A���J�[��v����ꍇ
								If blnAnchor Then

									'javascript�̕ҏW(�������͑�Q�������ҏW)
									strDay = "<A CLASS=""" & strClass & """ HREF=""javascript:selDate(" & strEditDay(i) & IIf(strEditStatus(i) <> STATUS_NORMAL And strEditStatus(i) <> STATUS_OVER , ",true", "") & ")"">" & strDay &  "</A>"

									Exit Do
								End If

								'�ʏ�
								strDay = "<SPAN CLASS=""" & strClass & """>" & strDay & "</SPAN>"

								Exit Do
							Loop
%>
							<TD<%= strHeight %> BGCOLOR="<%= strColor %>"><%= strDay %></TD>
<%
							'HEIGHT�v���p�e�B�̃N���A
							strHeight = ""

							i = i + 1
						Loop Until i Mod 7 = 0
%>
					</TR>
<%
				Loop
%>
			</TABLE>
		</TD>
	</TR>
	<TR><TD HEIGHT="5"></TD></TR>
	<TR>
		<TD>
			<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="0" WIDTH="100%" BGCOLOR="#666666">
				<TR>
					<TD BGCOLOR="#ffffff" ALIGN="center">
						<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
							<TR>
<%
								lngYear  = lngCslYear - IIf(lngCslMonth = 1, 1, 0)
								lngMonth = IIf(lngCslMonth = 1, 12, lngCslMonth - 1)
%>
								<TD><A HREF="javascript:changeDate(<%= lngYear %>, <%= lngMonth %>)"><IMG SRC="../../images/replay.gif" ALT="�O����\��" HEIGHT="21" WIDTH="21"></A></TD>
								<TD><%= EditNumberList("cslYear", YEARRANGE_MIN, YEARRANGE_MAX, lngCslYear, False) %></TD>
								<TD>�N</TD>
								<TD><%= EditNumberList("cslMonth", 1, 12, lngCslMonth, False) %></TD>
								<TD>��</TD>
<%
								lngYear  = lngCslYear + IIf(lngCslMonth = 12, 1, 0)
								lngMonth = IIf(lngCslMonth = 12, 1, lngCslMonth + 1)
%>
								<TD><A HREF="javascript:changeDate(<%= lngYear %>, <%= lngMonth %>)"><IMG SRC="../../images/play.gif" ALT="������\��" HEIGHT="21" WIDTH="21"></A></TD>
							</TR>
						</TABLE>
					</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
</TABLE>
</FORM>
<FORM NAME="paramForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<INPUT TYPE="hidden" NAME="mode" VALUE="<%= strMode %>">
	<INPUT TYPE="hidden" NAME="cslYear">
	<INPUT TYPE="hidden" NAME="cslMonth">
	<INPUT TYPE="hidden" NAME="cslDay">
	<INPUT TYPE="hidden" NAME="ignoreFlg" VALUE="<%= lngIgnoreFlg    %>">
	<INPUT TYPE="hidden" NAME="rsvNo"     VALUE="<%= strParaRsvNo    %>">
	<INPUT TYPE="hidden" NAME="rsvGrpCd"  VALUE="<%= strParaRsvGrpCd %>">
</FORM>
<SCRIPT TYPE="text/javascript">
<!--
// �C�x���g�n���h���̐ݒ�
document.entryForm.cslYear.onchange  = onChangeDate;
document.entryForm.cslMonth.onchange = onChangeDate;

// �ߔ͈͎�f�����̔z��
var recentConsults = new Array();

// �ߔ͈͎�f�����N���X
function recentConsult() {
	this.rsvNo      = '';
	this.curCslDate = '';
	this.perId      = '';
	this.perName    = '';
	this.csCd       = '';
	this.cslDate    = new Array();
	this.cslRsvNo   = new Array();
}
<%
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objConsult = Server.CreateObject("HainsConsult.Consult")

For i = 0 To UBound(strRsvNo)

	'�N���X�̃C���X�^���X�쐬
%>
	recentConsults[<%= i %>] = new recentConsult();
	recentConsults[<%= i %>].rsvNo = <%= strRsvNo(i) %>;
<%
	'��f���ǂݍ���
	objConsult.SelectConsult strRsvNo(i), , strCurCslDate, strPerId, strCsCd, , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , strLastName, strFirstName
%>
	recentConsults[<%= i %>].curCslDate = '<%= strCurCslDate %>';
	recentConsults[<%= i %>].perId      = '<%= strPerid      %>';
	recentConsults[<%= i %>].csCd       = '<%= strCsCd       %>';
	recentConsults[<%= i %>].perName    = '<%= Trim(strLastName  & "�@" & strFirstName) %>';
<%
	'�w��N���̎�f���A�����ȍ~�ōŌÂ̎�f���A�O���ȑO�ōŐV�̎�f�����擾
	Call RecentConsult_GetRecentConsultHistory(strPerId, lngCslYear, lngCslMonth, strRsvNo(i), strArrCslDate, strArrRsvNo)

	'��f����񑶍ݎ�
	If IsArray(strArrCslDate) Then

		'���̓��e��ҏW
		For j = 0 To UBound(strArrCslDate)
%>
			recentConsults[<%= i %>].cslDate[<%= j %>]  = '<%= strArrCslDate(j) %>';
			recentConsults[<%= i %>].cslRsvNo[<%= j %>] =  <%= strArrRsvNo(j)   %>;
<%
		Next
	End If

Next

Set objConsult = Nothing
%>
// �w���f���ɂĕۑ�����ہA���[�j���O�ΏۂƂȂ��f��񂪑��݂��邩�𔻒�
function checkRecentConsult( cslYear, cslMonth, cslDay ) {

	var warnCslDate;	// ���[�j���O�ΏۂƂȂ��f��

	var wkDate;			// ���t���[�N
	var msg = '';		// ���b�Z�[�W

	// �w���f�����[���A�X���b�V���t�����t������`���ŕҏW
	var curCslDate = cslYear + '/' + ( '0' + parseInt( cslMonth, 10 ) ).slice( -2 ) + '/' + ( '0' + parseInt( cslDay, 10 ) ).slice( -2 );

	// �w�茎���O�̎�f���A�w�茎����̎�f�����Z�o
	var minCslDate = monthAdd( cslYear, cslMonth, cslDay, <%= RECENTCONSULT_RANGE_OF_MONTH * -1 %> );
	var maxCslDate = monthAdd( cslYear, cslMonth, cslDay, <%= RECENTCONSULT_RANGE_OF_MONTH      %> );

	for ( var ret = true, i = 0; i < recentConsults.length; i++ ) {

		// �h�b�N�A������f�������R�[�X�̏ꍇ�̓X�L�b�v
		if ( recentConsults[ i ].csCd != '100' && recentConsults[ i ].csCd != '110' ) continue;

		// ���݂̎�f���ƕύX���Ȃ��ꍇ�̓X�L�b�v
		if ( curCslDate == recentConsults[ i ].curCslDate ) continue;

		warnCslDate = new Array();

		// ��f��������
		for ( var j = recentConsults[ i ].cslDate.length - 1; j >= 0; j-- ) {

			// ���\��ԍ��̎�f���̓X�L�b�v
			if ( recentConsults[ i ].cslRsvNo[ j ] == recentConsults[ i ].rsvNo ) continue;

			// �w�茎���O�̎�f���A�w�茎����̎�f���͈̔͊O�Ȃ�ΑΏۊO
			if ( recentConsults[ i ].cslDate[ j ] < minCslDate || recentConsults[ i ].cslDate[ j ] > maxCslDate ) continue;

			// ��L���O�����ɊY�����Ȃ��ꍇ�̓��[�j���O�ΏۂƂȂ��f���̂��߁A�X�^�b�N
			wkDate = recentConsults[ i ].cslDate[ j ].split( '/' );
			warnCslDate[ warnCslDate.length ] = parseInt( wkDate[ 0 ], 10 ) + '�N' + parseInt( wkDate[ 1 ], 10 ) + '��' + parseInt( wkDate[ 2 ], 10 ) + '��';

		}

		// ���[�j���O�ΏۂƂȂ��f�����ݎ��̓��b�Z�[�W��ҏW
		if ( warnCslDate.length > 0 ) {
			msg = msg + ( msg != '' ? '\n' : '');
			msg = msg + recentConsults[ i ].perId   + '�F';
			msg = msg + recentConsults[ i ].perName + '�@';
			msg = msg + warnCslDate.join( '�A' ) + '�ɂ��̎�f�҂̎�f��񂪂��łɑ��݂��܂��B';
		}

	}

	return msg;

}

// ���̉��Z
function monthAdd( cslYear, cslMonth, cslDay, addMonth ) {

	var wkDate;	// ���t���[�N

	// �w��N���̐擪���ɑ΂���Date�N���X�𗍂߂����Z���s���A�܂��N�E�������߂�
	wkDate = new Date( parseInt( cslYear, 10 ), parseInt( cslMonth, 10 ) - 1 + addMonth, 1 );
	var calcYear  = wkDate.getFullYear();
	var calcMonth = wkDate.getMonth();

	var calcDay = parseInt( cslDay, 10 );

	for ( ; ; ) {

		// ���߂�ꂽ�N�E���ɑ΂��Ďw�肳�ꂽ����t������Date�N���X���\���B
		wkDate = new Date( calcYear, calcMonth, calcDay );

		// ���̌��ʁA(�����̊֌W��)���̒l���ς��ꍇ�͓��t���f�N�������g���A�ēx�\���B���������������߂�B
		if ( wkDate.getMonth() == calcMonth ) {
			break;
		}

		calcDay--;
	}

	// ����1�`12�̌`���ɕϊ�
	calcMonth++;

	// �[���A�X���b�V���t�����t������`���ŕԂ�
	return calcYear + '/' + ('0' + calcMonth).slice( -2 ) + '/' + ('0' + calcDay).slice( -2 );

}
//-->
</SCRIPT>
</BODY>
</HTML>
