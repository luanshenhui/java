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
<% '## 2004/04/20 Add By T.Takagi@FSIT �߂���f���Ō��f��������ꍇ�̃��[�j���O�Ή� %>
<!-- #include virtual = "/webHains/includes/recentConsult.inc" -->
<% '## 2004/04/20 Add End %>
<%
'�Z�b�V�����E�����`�F�b�N
'Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

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

Const COLOR_NOTHING     = "#ffffff"	'�J�����_�[�\���F(�Ȃ�)
Const COLOR_NORMAL      = "#afeeee"	'�J�����_�[�\���F(�󂫂���)
Const COLOR_OVER        = "#ff6347"	'�J�����_�[�\���F(�I�[�o�����\��\)
Const COLOR_FULL        = "#ff6347"	'�J�����_�[�\���F(�󂫂Ȃ�)
Const COLOR_NO_RSVFRA   = "#ffcccc"	'�J�����_�[�\���F(�g�Ȃ�)
Const COLOR_NO_CONTRACT = "#cccccc"	'�J�����_�[�\���F(�_��Ȃ�)
Const COLOR_HOLIDAY     = "#90ee90"	'�J�����_�[�\���F(�x��)

Const MARK_OVER = "��"	'�I�[�o���̃}�[�N

Const IGNORE_EXCEPT_NO_RSVFRA = "1"	'�\��g��������(�g�Ȃ��̓��t�����������\�񂪉\)
Const IGNORE_ANY              = "2"	'�\��g��������(�����鋭���\�񂪉\)

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objConsult			'��f���A�N�Z�X�p
Dim objContract			'�_����A�N�Z�X�p
Dim objFree				'�ėp���A�N�Z�X�p
Dim objOrganization		'�c�̏��A�N�Z�X�p
Dim objPerson			'�l���A�N�Z�X�p
Dim objSchedule			'�X�P�W���[�����A�N�Z�X�p

'�����l
Dim strMode				'�������[�h(MODE_NORMAL:�ʏ�AMODE_SAME_RSVGRP:�����\��Q�Z�b�g�O���[�v�Ō���)
Dim strCalledFrom		'�Ăь�����(�Ȃ�:�\��g�����A����:��f���)
Dim lngCslYear			'��f�N
Dim lngCslMonth			'��f��
Dim lngCslDay			'��f��
Dim lngIgnoreFlg		'�\��g�����t���O

'## 2003.12.12 Add By T.Takagi@FSIT ���ݓ����󂯎��
Dim strCurCslYear		'���݂̎�f�N
Dim strCurCslMonth		'���݂̎�f��
Dim strCurCslDay		'���݂̎�f��
'## 2003.12.12 Add End

Dim strParaPerId		'�l�h�c
Dim strParaManCnt		'�l��
Dim strParaGender		'����
Dim strParaBirth		'���N����
Dim strParaAge			'��f���N��
Dim strParaRomeName		'���[�}����
Dim strParaOrgCd1		'�c�̃R�[�h�P
Dim strParaOrgCd2		'�c�̃R�[�h�Q
Dim strParaCsCd			'�R�[�X�R�[�h
Dim strParaCslDivCd		'��f�敪�R�[�h
Dim strParaRsvGrpCd		'�\��Q�R�[�h
Dim strParaCtrPtCd		'�_��p�^�[���R�[�h
Dim strParaRsvNo		'�p�����ׂ���f���̗\��ԍ�
Dim strParaOptCd		'�I�v�V�����R�[�h
Dim strParaOptBranchNo	'�I�v�V�����}��

Dim strPerId			'�l�h�c
Dim strManCnt			'�l��
Dim strGender			'����
Dim strBirth			'���N����
Dim strAge				'��f���N��
Dim strRomeName			'���[�}����
Dim strOrgCd1			'�c�̃R�[�h�P
Dim strOrgCd2			'�c�̃R�[�h�Q
Dim strCsCd				'�R�[�X�R�[�h
Dim strCslDivCd			'��f�敪�R�[�h
Dim strRsvGrpCd			'�\��Q�R�[�h
Dim strCtrPtCd			'�_��p�^�[���R�[�h
Dim strRsvNo			'�p�����ׂ���f���̗\��ԍ�
Dim strOptCd			'�I�v�V�����R�[�h
Dim strOptBranchNo		'�I�v�V�����}��

'�_����
Dim strAgeCalc			'�N��N�Z��
Dim strCsName			'�R�[�X��

'�I�v�V�������
Dim strSelOptCd			'�I�v�V�����R�[�h
Dim strSelOptBranchNo	'�I�v�V�����}��
Dim strArrOptCd			'�I�v�V�����R�[�h
Dim strArrOptBranchNo	'�I�v�V�����}��
Dim strArrOptSName		'�I�v�V��������
Dim lngOptCount			'�I�v�V������
Dim strSelOptName()		'�I�v�V�������̔z��
Dim lngSelOptCount		'�I�v�V������
Dim strDispOptName		'�I�v�V������

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

'### 2013.12.25 �c�̖��̃n�C���C�g�\���L�����`�F�b�N�̈גǉ��@Start ###
Dim strHighLight        ' �c�̖��̃n�C���C�g�\���敪
'### 2013.12.25 �c�̖��̃n�C���C�g�\���L�����`�F�b�N�̈גǉ��@End   ###

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
Dim Ret					'�֐��߂�l
Dim i, j				'�C���f�b�N�X

'## 2004/04/20 Add By T.Takagi@FSIT �߂���f���Ō��f��������ꍇ�̃��[�j���O�Ή�
Dim strArrCslDate		'��f���̔z��
Dim strArrRsvNo			'�\��ԍ��̔z��
'## 2004/04/20 Add End

'## 2005/10/19 Add By ��
Dim lntRsvChk
'## 2005/10/19 Add End

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�����l�̎擾
strMode            = Request("mode")
strCalledFrom      = Request("calledFrom")
lngCslYear         = CLng("0" & Request("cslYear"))
lngCslMonth        = CLng("0" & Request("cslMonth"))
lngCslDay          = CLng("0" & Request("cslDay"))
lngIgnoreFlg       = CLng("0" & Request("ignoreFlg"))
strParaPerId       = Request("perId")
strParaManCnt      = Request("manCnt")
strParaGender      = Request("gender")
strParaBirth       = Request("birth")
strParaAge         = Request("age")
strParaRomeName    = Request("romeName")
strParaOrgCd1      = Request("orgCd1")
strParaOrgCd2      = Request("orgCd2")
strParaCsCd        = Request("csCd")
strParaCslDivCd    = Request("cslDivCd")
strParaRsvGrpCd    = Request("rsvGrpCd")
strParaCtrPtCd     = Request("ctrPtCd")
strParaRsvNo       = Request("rsvNo")
strParaOptCd       = Request("optCd")
strParaOptBranchNo = Request("optBranchNo")

'## 2003.12.12 Add By T.Takagi@FSIT ���ݓ����󂯎��
strCurCslYear  = Request("curCslYear")
strCurCslMonth = Request("curCslMonth")
strCurCslDay   = Request("curCslDay")
'## 2003.12.12 Add End

'## 2005/10/19 Add By ��
lntRsvChk = CInt("0" & Request("chkRsv"))
'## 2005/10/19 Add End

'�Z�p���[�^�ŕ������A�z��
strPerId       = Split(strParaPerId,       Chr(1))
strManCnt      = Split(strParaManCnt,      Chr(1))
strGender      = Split(strParaGender,      Chr(1))
strBirth       = Split(strParaBirth,       Chr(1))
strAge         = Split(strParaAge,         Chr(1))
strRomeName    = Split(strParaRomeName,    Chr(1))
strOrgCd1      = Split(strParaOrgCd1,      Chr(1))
strOrgCd2      = Split(strParaOrgCd2,      Chr(1))
strCsCd        = Split(strParaCsCd,        Chr(1))
strCslDivCd    = Split(strParaCslDivCd,    Chr(1))
strRsvGrpCd    = Split(strParaRsvGrpCd,    Chr(1))
strCtrPtCd     = Split(strParaCtrPtCd,     Chr(1))
strRsvNo       = Split(strParaRsvNo,       Chr(1))
strOptCd       = Split(strParaOptCd,       Chr(1))
strOptBranchNo = Split(strParaOptBranchNo, Chr(1))

'����������P���w�肵���ꍇ�A�l�����݂��Ȃ��Ɣz��ƂȂ�Ȃ��B
'�����ł����ł͕K�����݂��鍀�ڂ̂P�ł���_��p�^�[���R�[�h�̔z�񐔂����Ƃɋ�̔z����쐬����B
If UBound(strCtrPtCd) = 0 Then
    If UBound(strPerId)       < 0 Then ReDim Preserve strPerId(0)
    If UBound(strManCnt)      < 0 Then ReDim Preserve strManCnt(0)
    If UBound(strGender)      < 0 Then ReDim Preserve strGender(0)
    If UBound(strBirth)       < 0 Then ReDim Preserve strBirth(0)
    If UBound(strAge)         < 0 Then ReDim Preserve strAge(0)
    If UBound(strRomeName)    < 0 Then ReDim Preserve strRomeName(0)
    If UBound(strOrgCd1)      < 0 Then ReDim Preserve strOrgCd1(0)
    If UBound(strOrgCd2)      < 0 Then ReDim Preserve strOrgCd2(0)
    If UBound(strCsCd)        < 0 Then ReDim Preserve strCsCd(0)
    If UBound(strCslDivCd)    < 0 Then ReDim Preserve strCslDivCd(0)
    If UBound(strRsvGrpCd)    < 0 Then ReDim Preserve strRsvGrpCd(0)
    If UBound(strRsvNo)       < 0 Then ReDim Preserve strRsvNo(0)
    If UBound(strOptCd)       < 0 Then ReDim Preserve strOptCd(0)
    If UBound(strOptBranchNo) < 0 Then ReDim Preserve strOptBranchNo(0)
End If

'�\�񏈗�����
Do

    '��f�����w�莞�͉������Ȃ�
    If lngCslDay = 0 Then
        Exit Do
    End If

    '��f�N�����̐ݒ�
    dtmCslDate = CDate(lngCslYear & "/" & lngCslMonth & "/" & lngCslDay)

    '��f���ڍ׉�ʂ���Ă΂ꂽ�ꍇ
    If strCalledFrom <> "" Then

        '�I�u�W�F�N�g�̃C���X�^���X�쐬
        Set objSchedule = Server.CreateObject("HainsSchedule.Calendar")

        '�w���f���̗\��g�󂫏󋵂��擾
        objSchedule.GetEmptyStatus strMode, dtmCslDate, strPerId, strManCnt, strGender, strBirth, strAge, strCsCd, strCslDivCd, strRsvGrpCd, strCtrPtCd, strOptCd, strOptBranchNo, strFindHoliday, strFindStatus, strFindRsvGrpCd

        '�Ăь��Ɏ�f������ї\��Q(�������ꂽ�ꍇ)���Z�b�g���A���g�����
        strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
        strHTML = strHTML & vbCrLf & "<SCRIPT TYPE=""text/javascript"">"
        strHTML = strHTML & vbCrLf & "<!--"
        strHTML = strHTML & vbCrLf & "if ( opener != null ) {"
        strHTML = strHTML & vbCrLf & "    if ( opener.setDate != null ) {"

        '���_����Ԃ���O�����t��I�������ꍇ�A���b�Z�[�W��\��
'		If strFindStatus = STATUS_NO_CONTRACT Then
'			strHTML = strHTML & vbCrLf & "        alert('���݂̌_����ƌ_��p�^�[�����قȂ邩�A�_����ԊO�̓��t���I������܂����B\n�����Z�b�g�̓��e�͕ύX����܂��B');"
'		End If

        strHTML = strHTML & vbCrLf & "        opener.setDate('" & lngCslYear & "','" & lngCslMonth & "','" & lngCslDay & "','" & strFindRsvGrpCd(0) & "'" & IIf(strFindStatus = STATUS_NO_CONTRACT, ",'1'", "") & ");"
        strHTML = strHTML & vbCrLf & "    }"
        strHTML = strHTML & vbCrLf & "}"
        strHTML = strHTML & vbCrLf & "close();"
        strHTML = strHTML & vbCrLf & "</SCRIPT>"
        strHTML = strHTML & vbCrLf & "</HTML>"
        Response.Write strHTML
        Response.End

        Exit Do
    End If
    

''## 2005.10.14 Add by �� ---------------------------------------------> START
''## �N�x���ɂQ��ڗ\����s���ꍇ�A���[�j���O�Ή�  
        If lngIgnoreFlg = 0 Then
            Set objConsult = Server.CreateObject("HainsConsult.Consult")
            strMessage = ""
            strMessage = objConsult.CheckConsult_Ctr(strPerId(0), dtmCslDate, strCsCd(0), strOrgCd1(0), strOrgCd2(0), "",lntRsvChk)
            Set objConsult = Nothing

            If strMessage <> "" Then
                Exit Do
            End If
        End If
''## 2005.10.14 Add by �� ---------------------------------------------> END


    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objConsult = Server.CreateObject("HainsConsult.ConsultAll")
    '�\�񏈗�
    Ret = objConsult.ReserveFromFrameReserve(strMode, Session("USERID"), lngIgnoreFlg, dtmCslDate, strPerId, strManCnt, strGender, strBirth, strAge, strRomeName, strOrgCd1, strOrgCd2, strCsCd, strCslDivCd, strRsvGrpCd, strCtrPtCd, strRsvNo, strOptCd, strOptBranchNo, strStrRsvNo, strEndRsvNo, strMessage)
    If Ret <= 0 Then
        Exit Do
    End If

    '���펞�͊����ʒm��ʂ�
    Response.Clear
    Response.Redirect "fraRsvCslList.asp?cslDate=" & dtmCslDate & "&strRsvNo=" & strStrRsvNo & "&endRsvNo=" & strEndRsvNo
    Response.End

    Exit Do
Loop

'�N��v�Z�ɍۂ��A��f���͎w��N���̐擪���Ƃ���
dtmCslDate = CDate(lngCslYear & "/" & lngCslMonth & "/1")

'�擪�̎�f��������e������擾

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objContract = Server.CreateObject("HainsContract.Contract")

'�N��N�Z���A�R�[�X���̎擾
objContract.SelectCtrPt strCtrPtcd(0), , , strAgeCalc, , strCsName

'�I�v�V�����R�[�h���w�肳��Ă���ꍇ
If strOptCd(0) <> "" Then

    '�I�v�V�����R�[�h�E�}�Ԃ�z��ɕϊ�
    strSelOptCd       = Split(strOptCd(0),       ",")
    strSelOptBranchNo = Split(strOptBranchNo(0), ",")

    '�w��_��p�^�[���̑S�I�v�V���������ǂݍ���
    lngOptCount = objContract.SelectCtrPtOptList(strCtrPtcd(0), strArrOptCd, strArrOptBranchNo, , strArrOptSName)

    '�I�v�V�����̌���
    For i = 0 To UBound(strSelOptCd)

        For j = 0 To lngOptCount - 1

            '�����w�肳�ꂽ�I�v�V�����ƈ�v�����ꍇ�A���̂�z��ɒǉ�
            If strArrOptCd(j) = strSelOptCd(i) And strArrOptBranchNo(j) = strSelOptBranchNo(i) Then
                ReDim Preserve strSelOptName(lngSelOptCount)
                strSelOptName(lngSelOptCount) = strArrOptSName(j)
                lngSelOptCount = lngSelOptCount + 1
                Exit For
            End If

        Next

    Next

    '�I�v�V�������̕ҏW
    If lngSelOptCount > 0 Then
        strDispOptName = "�@�i" & Join(strSelOptName, "�A") & "�j"
    End If

End If

Set objContract = Nothing

'�l�h�c�w��̏ꍇ
If strPerId(0) <> "" Then

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objPerson = Server.CreateObject("HainsPerson.Person")

    '�l���ǂݍ���
    objPerson.SelectPerson_lukes strPerId(0), strLastName, strFirstName, strLastKName, strFirstKName, , strPerBirth, strPerGender

    Set objPerson = Nothing

    '�����̕ҏW
    strPerName = "<B>" & Trim(strLastName  & "�@" & strFirstName) & "</B><FONT COLOR=""#999999"">�i" & Trim(strLastKName & "�@" & strFirstKName) & "�j</FONT>"

    '�N��v�Z
    Set objFree = Server.CreateObject("HainsFree.Free")
    strPerAge = objFree.CalcAge(strPerBirth, dtmCslDate, strAgeCalc)
    If strPerAge <> "" Then
        strPerAge = CStr(CInt(strPerAge))	'�����_�ȉ�������
    End If

'���ʁE���N�����E�N��w��̏ꍇ
Else

    '�����̕ҏW
    strPerName = IIf(strRomeName(0) <> "", strRomeName(0), "<FONT COLOR=""#999999"">�i��f�Җ��m��j</FONT>")

    '���N�����E�N��E���ʂ̎擾
    strPerBirth = strBirth(0)
    strPerAge = strAge(0)
    strPerGender = strGender(0)

    '��f�l���̕ҏW
    If CLng("0" & strManCnt(0)) > 1 Then
        strDispManCnt = "��" & CStr(CLng("0" & strManCnt(0)) - 1 ) & "��"
    End If

End If

'���N�����̕ҏW
If strPerBirth <> "" Then
    Set objCommon = Server.CreateObject("HainsCommon.Common")
    strPerBirthJpn = objCommon.FormatString(strPerBirth, "ge.m.d") & "���@"
    Set objCommon = Nothing
End If

'���ʂ̕ҏW
strPerGenderJpn = IIf(strPerGender = CStr(GENDER_MALE), "�j��", "����")

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

'�c�̏��ǂݍ���
'### 2013.12.25 �c�̖��̃n�C���C�g�\���L�����`�F�b�N�̈גǉ��@Start ###
'objOrganization.SelectOrg_Lukes strOrgCd1(0), strOrgCd2(0), , strOrgKName, strOrgName
objOrganization.SelectOrg_Lukes strOrgCd1(0), strOrgCd2(0), , strOrgKName, strOrgName,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,strHighLight
'### 2013.12.25 �c�̖��̃n�C���C�g�\���L�����`�F�b�N�̈גǉ��@End   ###


Set objOrganization = Nothing

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objSchedule = Server.CreateObject("HainsSchedule.Calendar")

'�w��N���̗\��󂫏󋵎擾
lngCount = objSchedule.GetEmptyCalendar(strMode, lngCslYear, lngCslMonth, strPerId, strManCnt, strGender, strBirth, strAge, strCsCd, strCslDivCd, strRsvGrpCd, strCtrPtCd, strOptCd, strOptBranchNo, strCslDate, strHoliday, strStatus)

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

        '�_��Ȃ��Ȃ�s�v
        If strStatus = STATUS_NO_CONTRACT Then
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
    if ( !confirm( '��f���F' + year + '�N' + month + '��' + day + '����' + ( force ? '����' : '' ) + '�\����s���܂��B��낵���ł����H' ) ) {
        return;
    }

// ## 2004/04/20 Add By T.Takagi@FSIT �߂���f���Ō��f��������ꍇ�̃��[�j���O�Ή�
    var msg = checkRecentConsult( year, month, day );
    if ( msg != '' ) {
        if ( !confirm( msg + '\n\n�\����s���܂����H' ) ) {
            return;
        }

        // ## 2005/10/19 Add By ��
        paraForm.chkRsv.value  = '1'
        // ## 2005/10/19 Add End
    }
// ## 2004/04/20 Add End

    // submit����
    paraForm.cslYear.value  = year;
    paraForm.cslMonth.value = month;
    paraForm.cslDay.value   = day;
    paraForm.submit();

}

// ���t�I��(��f���ڍׂ���Ă΂ꂽ�ꍇ)
function setDate( day ) {

    var paraForm = document.paramForm;
    var entForm  = document.entryForm;
    var year     = entForm.curCslYear.value;
    var month    = entForm.curCslMonth.value;

// ## 2003.12.12 Mod By T.Takagi@FSIT ���ݓ����󂯎��
//	if ( !confirm( '��f���F' + year + '�N' + month + '��' + day + '���ɐݒ肵�܂��B��낵���ł����H' ) ) {
    var curYear  = paraForm.curCslYear.value;
    var curMonth = paraForm.curCslMonth.value;
    var curDay   = paraForm.curCslDay.value;

    var msg = '��f����';

    if ( curYear != '' && curMonth != '' && curDay != '' ) {
        msg = msg + curYear + '�N' + curMonth + '��' + curDay + '������';
    }

    msg = msg + year + '�N' + month + '��' + day + '���ɐݒ肵�܂��B��낵���ł����H';

    if ( !confirm( msg ) ) {
// ## 2003.12.12 Mod End
        return;
    }

    // �\��Q���w�肳��Ă���ꍇ
    if ( paraForm.rsvGrpCd.value != '' ) {

        if ( opener != null ) {
            if ( opener.setDate != null ) {
                opener.setDate( '<%= lngCslYear %>', '<%= lngCslMonth %>', day, '' );
            }
        }

        close();

    // �\��Q���w��̏ꍇ
    } else {
    
        // submit����
        paraForm.cslYear.value  = year;
        paraForm.cslMonth.value = month;
        paraForm.cslDay.value   = day;
        paraForm.submit();

    }

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
<style type="text/css">
<!-- #include virtual = "/webHains/contents/css/calender.css" -->
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
If UBound(strPerId) > 0 Then
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
<%
        '�l�h�c�w��̏ꍇ
        If strPerId(0) <> "" Then
%>
            <TD NOWRAP><%= strPerId(0) %></TD>
            <TD>&nbsp;</TD>
            <TD NOWRAP><%= strPerName %></TD>
<%
        '���ʁE���N�����E�N��w��̏ꍇ
        Else
%>
            <TD NOWRAP><%= strPerName %></TD>
            <TD>&nbsp;&nbsp;</TD>
            <TD NOWRAP><FONT COLOR="#ff8c00"><%= strDispManCnt %></FONT></TD>
<%
        End If
%>
    </TR>
    <TR>
        <TD COLSPAN="<%= IIf(strPerId(0) <> "", "4", "2") %>"></TD>
        <TD NOWRAP><%= strPerBirthJpn %><%= strPerAge %>�΁@<%= strPerGenderJpn %></TD>
    </TR>
</TABLE>
<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
    <TR>
        <TD WIDTH="60" NOWRAP>�c�̖�</TD>
        <TD>�F</TD>
<% '### 2013.12.25 �� �c�̖��̃n�C���C�g�\���L�����`�F�b�N�̈גǉ��@Start ### %>
<%  If strHighLight = "1" Then           %>
        <TD NOWRAP><FONT style=' font-weight:bold; background-color:#00FFFF;'><B><%= strOrgCd1(0) %>-<%= strOrgCd2(0) %></B></FONT></TD>
        <TD>&nbsp;</TD>
        <TD NOWRAP><FONT style=' font-weight:bold; background-color:#00FFFF;'><B><%= strOrgName %></B></FONT><FONT style=' font-weight:bold; background-color:#00FFFF;' COLOR="#999999">�i<%= strOrgKName %>�j</FONT></TD>
<%  Else                                %>
        <TD NOWRAP><%= strOrgCd1(0) %>-<%= strOrgCd2(0) %></TD>
        <TD>&nbsp;</TD>
        <TD NOWRAP><B><%= strOrgName %></B><FONT COLOR="#999999">�i<%= strOrgKName %>�j</FONT></TD>
<%  End If                              %>
<% '### 2013.12.25 �� �c�̖��̃n�C���C�g�\���L�����`�F�b�N�̈גǉ��@End   ### %>

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
<!--## 2006.07.12 �� �x���A�j���̏ꍇ�A�g�󋵂Ɋ֌W�Ȃ����ׂāu�g�Ȃ��v�ŕ\������悤�ɕύX ##-->
<!--## �u�\��g�Ȃ��v�@�ˁ@�u�\��g�Ȃ��E�x�f���E�j���v                                   ##-->

<FONT COLOR="<%= COLOR_NORMAL %>">��</FONT>�F�󂫂���A<FONT COLOR="<%= COLOR_FULL %>">��</FONT>�F�󂫂Ȃ��A<FONT COLOR="<%= COLOR_NO_RSVFRA %>">��</FONT>�F�\��g�Ȃ��E�x�f���E�j���A<FONT COLOR="<%= COLOR_NO_CONTRACT %>">��</FONT>�F�_����ԊO<!--�A<FONT COLOR="<%= COLOR_HOLIDAY %>">��</FONT>�F�x��--><BR><BR>
<FONT COLOR="#cc9999">��</FONT>�I�[�o�ƂȂ邪�\��\�ȓ��ɂ�<%= MARK_OVER %>��\�����Ă��܂��B
<%
' ---------------------------------------- �}�� ----------------------------------------

If strCalledFrom <> "" Then
%>
    <BR><FONT COLOR="#cc9999">��</FONT>�_����ԊO�̓���I�������ꍇ�A���͂��ꂽ�����Z�b�g�̓��e�͕ύX����邱�Ƃ�����܂��B
<%
End If
%>
<FORM NAME="entryForm" ACTION="" STYLE="margin:0px;">
<INPUT TYPE="hidden" NAME="curCslYear"  VALUE="<%= lngCslYear  %>">
<INPUT TYPE="hidden" NAME="curCslMonth" VALUE="<%= lngCslMonth %>">
<%
'�\��g���������ɂ�鐧��
Do

    '��f���ڍ׉�ʂ���Ă΂ꂽ�ꍇ�͉������Ȃ�
    If strCalledFrom <> "" Then
        Response.Write "<BR>"
        Exit Do
    End If

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
'                                   If strEditHoliday(i) = "2" Then
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

                            '## 2006.07.12 �� �x�f���A�j���̏ꍇ�A�g�󋵂Ɋ֌W�Ȃ��I���ł��Ȃ��悤�ɕύX Start
''                            '�A���J�[�v�ۂ̐ݒ�(�\��ڍׂ���Ă΂ꂽ�ꍇ�͂��ׂđI���\)
''                            If strCalledFrom <> "" Then
''                                blnAnchor = True
''                            Else
''                                blnAnchor = NeedAnchor(strEditStatus(i))
''                            End If
                            If strEditHoliday(i) <>"" Then
                                blnAnchor = False
                            Else
                                If strCalledFrom <> "" Then
                                    '## 2006.07.12 �� �ߋ��̓��t�ȊO�͂��ׂđI���ł���悤�ɕύX
                                    If strEditStatus(i) = STATUS_PAST Then
                                        blnAnchor = False
                                    Else
                                        blnAnchor = True
                                    End If
                                Else
                                    '## 2006.07.12 �� �ߋ��̓��t�̏ꍇ�A�g�󋵂Ɋ֌W�Ȃ��I���ł��Ȃ��悤�ɕύX
                                    If strEditStatus(i) = STATUS_PAST Then
                                        blnAnchor = False
                                    Else
                                        blnAnchor = NeedAnchor(strEditStatus(i))
                                    End If
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
                                    If strCalledFrom <> "" Then
                                        strDay = "<A CLASS=""" & strClass & """ HREF=""javascript:setDate(" & strEditDay(i) & ")"">" & strDay &  "</A>"
                                    Else
                                        strDay = "<A CLASS=""" & strClass & """ HREF=""javascript:selDate(" & strEditDay(i) & IIf(strEditStatus(i) <> STATUS_NORMAL And strEditStatus(i) <> STATUS_OVER , ",true", "") & ")"">" & strDay &  "</A>"
                                    End If

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
    <INPUT TYPE="hidden" NAME="mode"       VALUE="<%= strMode       %>">
    <INPUT TYPE="hidden" NAME="calledFrom" VALUE="<%= strCalledFrom %>">
    <INPUT TYPE="hidden" NAME="cslYear">
    <INPUT TYPE="hidden" NAME="cslMonth">
    <INPUT TYPE="hidden" NAME="cslDay">
    <INPUT TYPE="hidden" NAME="ignoreFlg"   VALUE="<%= lngIgnoreFlg       %>">
    <INPUT TYPE="hidden" NAME="perId"       VALUE="<%= strParaPerId       %>">
    <INPUT TYPE="hidden" NAME="manCnt"      VALUE="<%= strParaManCnt      %>">
    <INPUT TYPE="hidden" NAME="gender"      VALUE="<%= strParaGender      %>">
    <INPUT TYPE="hidden" NAME="birth"       VALUE="<%= strParaBirth       %>">
    <INPUT TYPE="hidden" NAME="age"         VALUE="<%= strParaAge         %>">
    <INPUT TYPE="hidden" NAME="romeName"    VALUE="<%= strParaRomeName    %>">
    <INPUT TYPE="hidden" NAME="orgCd1"      VALUE="<%= strParaOrgCd1      %>">
    <INPUT TYPE="hidden" NAME="orgCd2"      VALUE="<%= strParaOrgCd2      %>">
    <INPUT TYPE="hidden" NAME="cslDivCd"    VALUE="<%= strParaCslDivCd    %>">
    <INPUT TYPE="hidden" NAME="csCd"        VALUE="<%= strParaCsCd        %>">
    <INPUT TYPE="hidden" NAME="rsvGrpCd"    VALUE="<%= strParaRsvGrpCd    %>">
    <INPUT TYPE="hidden" NAME="rsvNo"       VALUE="<%= strParaRsvNo       %>">
    <INPUT TYPE="hidden" NAME="ctrPtCd"     VALUE="<%= strParaCtrPtCd     %>">
    <INPUT TYPE="hidden" NAME="optCd"       VALUE="<%= strParaOptCd       %>">
    <INPUT TYPE="hidden" NAME="optBranchNo" VALUE="<%= strParaOptBranchNo %>">
<% '## 2003.12.12 Add By T.Takagi@FSIT ���ݓ����󂯎�� %>
    <INPUT TYPE="hidden" NAME="curCslYear"  VALUE="<%= strCurCslYear  %>">
    <INPUT TYPE="hidden" NAME="curCslMonth" VALUE="<%= strCurCslMonth %>">
    <INPUT TYPE="hidden" NAME="curCslDay"   VALUE="<%= strCurCslDay   %>">
<% '## 2003.12.12 Add End %>

<% '## 2005.10.19 Add By �� %>
    <INPUT TYPE="hidden" NAME="chkRsv">
<% '## 2005.10.19 Add End %>
</FORM>
<!--
<%
'for debug
for i = 0 to ubound(strperid)
Response.Write "����" & i + 1 & vbCrLf
Response.Write "prid=" & strPerid(i)       & vbCrLf
Response.Write "manc=" & strManCnt(i)      & vbCrLf
Response.Write "gend=" & strGender(i)      & vbCrLf
Response.Write "birt=" & strBirth(i)       & vbCrLf
Response.Write "cage=" & strAge(i)         & vbCrLf
Response.Write "rnam=" & strRomeName(i)    & vbCrLf
Response.Write "orgc=" & strOrgCd1(i) & "-" & strOrgCd2(i) & vbCrLf
Response.Write "cscd=" & strCsCd(i)        & vbCrLf
Response.Write "csdv=" & strCslDivCd(i)    & vbCrLf
Response.Write "rvgp=" & strRsvGrpCd(i)    & vbCrLf
Response.Write "ctpt=" & strCtrPtCd(i)     & vbCrLf
Response.Write "rvno=" & strRsvNo(i)       & vbCrLf
Response.Write "optc=" & strOptCd(i)       & vbCrLf
Response.Write "optb=" & strOptbranchNo(i) & vbCrLf
Next
%>
-->
<SCRIPT TYPE="text/javascript">
<!--
// �C�x���g�n���h���̐ݒ�
document.entryForm.cslYear.onchange  = onChangeDate;
document.entryForm.cslMonth.onchange = onChangeDate;
<%
'## 2004/04/20 Add By T.Takagi@FSIT �߂���f���Ō��f��������ꍇ�̃��[�j���O�Ή�
%>
// �ߔ͈͎�f�����̔z��
var recentConsults = new Array();

// �ߔ͈͎�f�����N���X
function recentConsult() {
    this.perId   = '';
    this.perName = '';
    this.csCd    = '';
    this.cslDate = new Array();
}
<%
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objPerson = Server.CreateObject("HainsPerson.Person")

For i = 0 To UBound(strPerId)

    '�N���X�̃C���X�^���X�쐬
%>
    recentConsults[<%= i %>] = new recentConsult();
<%
    '�l�h�c�w�莞�Ɋe������i�[����
    If strPerid(i) <> "" Then
%>
        recentConsults[<%= i %>].perId = '<%= strPerid(i) %>';
        recentConsults[<%= i %>].csCd  = '<%= strCsCd(i)  %>';
<%
        '�l���ǂݍ���
        objPerson.SelectPerson_lukes strPerId(i), strLastName, strFirstName
%>
        recentConsults[<%= i %>].perName  = '<%= Trim(strLastName  & "�@" & strFirstName) %>';
<%
        '�w��N���̎�f���A�����ȍ~�ōŌÂ̎�f���A�O���ȑO�ōŐV�̎�f�����擾
        Call RecentConsult_GetRecentConsultHistory(strPerId(i), lngCslYear, lngCslMonth, "", strArrCslDate, strArrRsvNo)

        '��f����񑶍ݎ�
        If IsArray(strArrCslDate) Then

            '���̓��e��ҏW
            For j = 0 To UBound(strArrCslDate)
%>
                recentConsults[<%= i %>].cslDate[<%= j %>] = '<%= strArrCslDate(j) %>';
<%
            Next
        End If

    End If

Next

Set objPerson = Nothing
%>
// �w���f���ɂĕۑ�����ہA���[�j���O�ΏۂƂȂ��f��񂪑��݂��邩�𔻒�
function checkRecentConsult( cslYear, cslMonth, cslDay ) {

    var warnCslDate;	// ���[�j���O�ΏۂƂȂ��f��

    var wkDate;			// ���t���[�N
    var msg = '';		// ���b�Z�[�W

    // �w�茎���O�̎�f���A�w�茎����̎�f�����Z�o
    var minCslDate = monthAdd( cslYear, cslMonth, cslDay, <%= RECENTCONSULT_RANGE_OF_MONTH * -1 %> );
    var maxCslDate = monthAdd( cslYear, cslMonth, cslDay, <%= RECENTCONSULT_RANGE_OF_MONTH      %> );

    for ( var ret = true, i = 0; i < recentConsults.length; i++ ) {

        // �l�h�c���w��Ȃ�΃X�L�b�v
        if ( recentConsults[ i ].perId == '' ) continue;

        // �h�b�N�A������f�������R�[�X�̏ꍇ�̓X�L�b�v
        if ( recentConsults[ i ].csCd != '100' && recentConsults[ i ].csCd != '110' ) continue;

        warnCslDate = new Array();

        // ��f��������
        for ( var j = recentConsults[ i ].cslDate.length - 1; j >= 0; j-- ) {

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
<%
'## 2004/04/20 Add End
%>
//-->
</SCRIPT>
</BODY>
</HTML>
