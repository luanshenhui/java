<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'       ���я� (Ver0.0.1)
'       AUTHER  : (NSC)birukawa
'-------------------------------------------------------------------------------
'�Ǘ��ԍ��FSL-UI-Y0101-105
'�C����  �F2010.06.25
'�S����  �FTCS)�c��
'�C�����e�F���C�A�E�g�ύX�Ή��i�y�[�W�W�`�P�O�ɑΉ��j
'�Ǘ��ԍ��FSL-SN-Y0101-004
'�C����  �F2011.08.25
'�S����  �FFJTH)���c
'�C�����e�F�N���p�����[�^�̃G���[�`�F�b�N�ǉ��i����ID�܂��͒c�̂f�܂��͒c�́@�K�{�j

Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/print.inc"                -->
<!-- #include virtual = "/webHains/includes/editOrgGrp_PList.inc"     -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim strMode             '������[�h
Dim vntMessage          '�ʒm���b�Z�[�W

'-------------------------------------------------------------------------------
' �ŗL�錾���i�e���[�ɉ����Ă��̃Z�N�V�����ɕϐ����`���ĉ������j
'-------------------------------------------------------------------------------
'COM�I�u�W�F�N�g
Dim objCommon                               '���ʃN���X
Dim objOrganization                         '�c�̏��A�N�Z�X�p
Dim objOrgBsd                               '���ƕ����A�N�Z�X�p
Dim objOrgRoom                              '�������A�N�Z�X�p
Dim objOrgPost                              '�������A�N�Z�X�p
Dim objPerson                               '�l���A�N�Z�X�p
Dim objReport                               '���[���A�N�Z�X�p
Dim objFree                                 '�ėp���A�N�Z�X�p

'�p�����[�^�l
Dim strSCslYear, strSCslMonth, strSCslDay   '�J�n�N����
Dim strECslYear, strECslMonth, strECslDay   '�I���N����
Dim strDayId                                '����ID
Dim strOrgGrpCd                             '�c�̃O���[�v�R�[�h
Dim strOrgCd11                              '�c�̃R�[�h�P�P
Dim strOrgCd12                              '�c�̃R�[�h�P�Q
Dim strOrgCd21                              '�c�̃R�[�h�Q�P
Dim strOrgCd22                              '�c�̃R�[�h�Q�Q
Dim strOrgCd31                              '�c�̃R�[�h�R�P
Dim strOrgCd32                              '�c�̃R�[�h�R�Q
Dim strOrgCd41                              '�c�̃R�[�h�S�P
Dim strOrgCd42                              '�c�̃R�[�h�S�Q
Dim strOrgCd51                              '�c�̃R�[�h�T�P
Dim strOrgCd52                              '�c�̃R�[�h�T�Q
Dim strOrgCd61                              '�c�̃R�[�h�U�P
Dim strOrgCd62                              '�c�̃R�[�h�U�Q
Dim strOrgCd71                              '�c�̃R�[�h�V�P
Dim strOrgCd72                              '�c�̃R�[�h�V�Q
Dim strReportOutDate                        '�o�͓�
Dim strReportOutput                         '�o�͗l��
Dim strHistoryPrint                         '�ߋ������
Dim strReportCd                             '���[�R�[�h
Dim UID                                     '���[�UID
Dim strsort                                 '�o�͏�
Dim strpage1                                '�o�͕�
Dim strpage2                                '�o�͕�
Dim strpage3                                '�o�͕�
Dim strpage4                                '�o�͕�
Dim strpage5                                '�o�͕�
Dim strpage6                                '�o�͕�
'### 2008.03.12 �� ���茒�f���ѕ\�Ή��̂��ߒǉ� Start ###
Dim strpage7                                '�o�͕�
'### 2008.03.12 �� ���茒�f���ѕ\�Ή��̂��ߒǉ� End   ###
'#### 2010.06.25 SL-UI-Y0101-105 ADD START ####'
Dim strpage8                                '�o�͕�
Dim strpage9                                '�o�͕�
Dim strpage10                               '�o�͕�
'#### 2010.06.25 SL-UI-Y0101-105 ADD END ####'

'��Ɨp�ϐ�
Dim strSCslDate                             '�J�n��
Dim strECslDate                             '�I����
Dim strOrgGrpName                           '�c�̃O���[�v����
Dim strOrgName1                             '�c�̂P����
Dim strOrgName2                             '�c�̂Q����
Dim strOrgName3                             '�c�̂R����
Dim strOrgName4                             '�c�̂S����
Dim strOrgName5                             '�c�̂T����
Dim strOrgName6                             '�c�̂U����
Dim strOrgName7                             '�c�̂V����

'���[���
Dim strArrReportCd                          '���[�R�[�h
Dim strArrReportName                        '���[��
Dim strArrHistoryPrint                      '�ߋ������
Dim lngReportCount                          '���R�[�h��

Dim i                   '���[�v�C���f�b�N�X
Dim j                   '���[�v�C���f�b�N�X

' 2005/12/14  Add by ��  --------------------
Dim strCslDivCd         '��f�敪�R�[�h
Dim strBillPrint        '�������o�͋敪�R�[�h

'�ėp���
Dim strFreeCd           '�ėp�R�[�h
Dim strFreeDate         '�ėp���t
Dim strFreeField1       '�t�B�[���h�P
Dim strFreeField2       '�t�B�[���h�Q

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objOrgBsd       = Server.CreateObject("HainsOrgBsd.OrgBsd")
Set objOrgRoom      = Server.CreateObject("HainsOrgRoom.OrgRoom")
Set objOrgPost      = Server.CreateObject("HainsOrgPost.OrgPost")
Set objPerson       = Server.CreateObject("HainsPerson.Person")

'���ʈ����l�̎擾
strMode = Request("mode")

'���[�o�͏�������
vntMessage = PrintControl(strMode)

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : URL�����l�̎擾
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ : URL�̈����l���擾���鏈�����L�q���ĉ�����
'
'-------------------------------------------------------------------------------
Sub GetQueryString()

'�� �J�n�N����
    If IsEmpty(Request("strCslYear")) Then
        strSCslYear   = Year(Now())             '�J�n�N
        strSCslMonth  = Month(Now())            '�J�n��
        strSCslDay    = Day(Now())              '�J�n��
    Else
        strSCslYear   = Request("strCslYear")   '�J�n�N
        strSCslMonth  = Request("strCslMonth")  '�J�n��
        strSCslDay    = Request("strCslDay")    '�J�n��
    End If
    strSCslDate   = strSCslYear & "/" & strSCslMonth & "/" & strSCslDay
'�� �I���N����
    If IsEmpty(Request("endCslYear")) Then
'       strECslYear   = Year(Now())             '�I���N
'       strECslMonth  = Month(Now())            '�J�n��
'       strECslDay    = Day(Now())              '�J�n��
    Else
        strECslYear   = Request("endCslYear")   '�I���N
        strECslMonth  = Request("endCslMonth")  '�J�n��
        strECslDay    = Request("endCslDay")    '�J�n��
    End If
    strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
'�� �J�n�N�����ƏI���N�����̑召����Ɠ���
'   �i���t�^�ɕϊ����ă`�F�b�N���Ȃ��͓̂��t�Ƃ��Č�����l�ł������Ƃ��̃G���[����ׁ̈j
'   If Right("0000" & Trim(CStr(strSCslYear)), 4) & _
'      Right("00" & Trim(CStr(strSCslMonth)), 2) & _
'      Right("00" & Trim(CStr(strSCslDay)), 2) _
'    > Right("0000" & Trim(CStr(strECslYear)), 4) & _
'      Right("00" & Trim(CStr(strECslMonth)), 2) & _
'      Right("00" & Trim(CStr(strECslDay)), 2) Then
'       strSCslYear   = strECslYear
'       strSCslMonth  = strECslMonth
'       strSCslDay    = strECslDay
'       strSCslDate   = strECslDate
'       strECslYear   = Request("strCslYear")   '�J�n�N
'       strECslMonth  = Request("strCslMonth")  '�J�n��
'       strECslDay    = Request("strCslDay")    '�J�n��
'       strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
'   End If

'�� ����ID
    strDayId        = Request("DayId")

'�� �c�̃O���[�v�R�[�h
    strOrgGrpCd     = Request("OrgGrpCd")
    strOrgGrpName   = Request("OrgGrpName")

'�� �c�̃R�[�h
    '�c�̂P
    strOrgCd11      = Request("OrgCd11")
    strOrgCd12      = Request("OrgCd12")
    strOrgName1     = Request("OrgName1")

    '�c�̂Q
    strOrgCd21      = Request("OrgCd21")
    strOrgCd22      = Request("OrgCd22")
    strOrgName2     = Request("OrgName2")
    '�c�̂R
    strOrgCd31      = Request("OrgCd31")
    strOrgCd32      = Request("OrgCd32")
    strOrgName3     = Request("OrgName3")
    '�c�̂S
    strOrgCd41      = Request("OrgCd41")
    strOrgCd42      = Request("OrgCd42")
    strOrgName4     = Request("OrgName4")
    '�c�̂T
    strOrgCd51      = Request("OrgCd51")
    strOrgCd52      = Request("OrgCd52")
    strOrgName5     = Request("OrgName5")
    '�c�̂U
    strOrgCd61      = Request("OrgCd61")
    strOrgCd62      = Request("OrgCd62")
    strOrgName6     = Request("OrgName6")
    '�c�̂V
    strOrgCd71      = Request("OrgCd71")
    strOrgCd72      = Request("OrgCd72")
    strOrgName7     = Request("OrgName7")

'�� �o�͓�
    strReportOutDate = Request("ReportOutDate")

'�� �o�͗l��
    strReportOutput = Request("ReportOutput")
    strHistoryPrint = Request("HistoryPrint")
    strReportCd     = Request("Reportcd")

'�� ���[�UID
    UID             = Session("USERID")

'�� �o�͏�
    strsort         = Request("sort")

'�� �o�͕�
    strpage1 = Request("checkpage1Val")
    strpage1 = IIf(strpage1 = "", 1, strpage1)
    strpage2 = Request("checkpage2Val")
    strpage2 = IIf(strpage2 = "", 1, strpage2)
    strpage3 = Request("checkpage3Val")
    strpage3 = IIf(strpage3 = "", 1, strpage3)
    strpage4 = Request("checkpage4Val")
    strpage4 = IIf(strpage4 = "", 1, strpage4)
    strpage5 = Request("checkpage5Val")
    strpage5 = IIf(strpage5 = "", 1, strpage5)
    strpage6 = Request("checkpage6Val")
    strpage6 = IIf(strpage6 = "", 1, strpage6)
'### 2008.03.12 �� ���茒�f���ѕ\�Ή��̂��ߒǉ� Start ###
    strpage7 = Request("checkpage7Val")
    strpage7 = IIf(strpage7 = "", 1, strpage7)
'### 2008.03.12 �� ���茒�f���ѕ\�Ή��̂��ߒǉ� End   ###
'#### 2010.06.25 SL-UI-Y0101-105 ADD START ####'
    strpage8 = Request("checkpage8Val")
    strpage8 = IIf(strpage8 = "", 1, strpage8)
    strpage9 = Request("checkpage9Val")
    strpage9 = IIf(strpage9 = "", 1, strpage9)
    strpage10= Request("checkpage10Val")
    strpage10= IIf(strpage10= "", 1, strpage10)
'#### 2010.06.25 SL-UI-Y0101-105 ADD END ####'

'�� ��f�敪�R�[�h
    strCslDivCd     = Request("cslDivCd")

'�� �������o�͋敪�R�[�h
    strBillPrint    = Request("billPrint")
    
End Sub

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

    Dim vntArrMessage	'�G���[���b�Z�[�W�̏W��
    Dim blnErrFlg
    Dim aryChkString
    Dim aryChkString2
    
    aryChkString = Array("1","2","3","4","5","6","7","8","9","0",",","-")
    aryChkString2 = Array("1","2","3","4","5","6","7","8","9","0")

    '�����Ƀ`�F�b�N�������L�q
    With objCommon
'��)	   .AppendArray vntArrMessage, �R�����g
        If strMode <> "" Then
            '��f���`�F�b�N
            If Not IsDate(strECslDate) Then
                strECslDate = strSCslDate
            End If
            If Not IsDate(strSCslDate) Then
                .AppendArray vntArrMessage, "�J�n���t������������܂���B"
            End If
            If Not IsDate(strECslDate) Then
                .AppendArray vntArrMessage, "�I�����t������������܂���B"
            End If

            '����ID�`�F�b�N
            If Trim(strDayId) <> "" Then
                blnErrFlg = 0
                For j = 0 to UBound(aryChkString2)
                    If Trim(Mid(strDayId, len(strDayId), 1)) = Trim(aryChkString2(j)) Then
                        blnErrFlg = 1
                        Exit For
                    End if
                Next
                If blnErrFlg = 0 Then
                    .AppendArray vntArrMessage, "����ID�̍Ō�̕���������������܂���B"
                End If
            End If
            If Trim(strDayId) <> "" Then
                For i = 1 To Len(strDayId)
                    blnErrFlg = 0
                    For j = 0 to UBound(aryChkString)
                        If Trim(Mid(strDayId, i, 1)) = Trim(aryChkString(j)) Then
                            blnErrFlg = 1
                            Exit For
                        End if
                    Next
                    If blnErrFlg = 0 Then
                        .AppendArray vntArrMessage, "����ID������������܂���B"
                        Exit For
                    End If
                Next
            End If
            
            '�o�͗l���̃`�F�b�N
            If strReportCd = "" Then
                objCommon.appendArray vntArrMessage, "�o�͗l����I�����ĉ������B"
            End If

            '�o�͗l���̃`�F�b�N
            '#### 2007/08/02 �� ���ѕ\�i��Ɨp����j�����t�`�F�b�N���ł���悤�ɏC�� ####
            'If Trim(strReportCd) >= "000305"  and trim(strReportCd) <= "000308" Then
            If (Trim(strReportCd) >= "000305"  and trim(strReportCd) <= "000308") or trim(strReportCd) = "000312" Then
'���t�^�Ń`�F�b�N����
'               if Trim(strSCslDate) < "2004/4/1" Then
                if Right("0000" & Trim(CStr(strSCslYear)), 4) & "/" & _
                   Right("00" & Trim(CStr(strSCslMonth)), 2) & "/" & _
                   Right("00" & Trim(CStr(strSCslDay)), 2) _
                 < "2004/04/01" Then
                    objCommon.appendArray vntArrMessage, "�J�n���� 2004�N3��31�� �ȑO�ł��B"
                End If
            End If


            '�o�͗l���̃`�F�b�N
            If Trim(strReportCd) >= "000301"  and trim(strReportCd) <= "000304" Then
'���t�^�Ń`�F�b�N����
'               if Trim(strSCslDate) > "2004/3/31" Then
                if Right("0000" & Trim(CStr(strSCslYear)), 4) & "/" & _
                   Right("00" & Trim(CStr(strSCslMonth)), 2) & "/" & _
                   Right("00" & Trim(CStr(strSCslDay)), 2) _
                 > "2004/03/31" Then
                    objCommon.appendArray vntArrMessage, "�J�n���� 2004�N4��1�� �ȍ~�ł��B"
                End If
            End If

'## 2007.04.01 �w�l�Ȕ��蕪�ނ̂��߁A���я��C��  START ############

            '�o�͗l���̃`�F�b�N
            '#### 2007/08/02 �� ���ѕ\�i��Ɨp����j�����t�`�F�b�N���ł���悤�ɏC�� ####
            'If Trim(strReportCd) >= "000305"  and trim(strReportCd) <= "000308" Then
            If (Trim(strReportCd) >= "000305"  and trim(strReportCd) <= "000308") or trim(strReportCd) = "000312" Then
                if Right("0000" & Trim(CStr(strSCslYear)), 4) & "/" & _
                   Right("00" & Trim(CStr(strSCslMonth)), 2) & "/" & _
                   Right("00" & Trim(CStr(strSCslDay)), 2) _
                 > "2007/03/31" Then
                    objCommon.appendArray vntArrMessage, "�J�n���� 2007�N4��1�� �ȍ~�ł��B"
                End If
            End If
            
            
            '�o�͗l���̃`�F�b�N
            If Trim(strReportCd) >= "000320"  and trim(strReportCd) <= "000324" Then
                if Right("0000" & Trim(CStr(strSCslYear)), 4) & "/" & _
                   Right("00" & Trim(CStr(strSCslMonth)), 2) & "/" & _
                   Right("00" & Trim(CStr(strSCslDay)), 2) _
                 < "2007/04/01" Then
                    objCommon.appendArray vntArrMessage, "�J�n���� 2007�N4��1�� �ȑO�ł��B"
                End If
            End If

'## 2007.04.01 �w�l�Ȕ��蕪�ނ̂��߁A���я��C��  END ############


'## 2008.03.27 ���茒�f���ʕ񍐏��ǉ��ɂ���āA���я��C��  START ############
            '�o�͗l���̃`�F�b�N
            If (Trim(strReportCd) >= "000320"  and trim(strReportCd) <= "000324") or trim(strReportCd) = "000311" Then
                if Right("0000" & Trim(CStr(strSCslYear)), 4) & "/" & _
                   Right("00" & Trim(CStr(strSCslMonth)), 2) & "/" & _
                   Right("00" & Trim(CStr(strSCslDay)), 2) _
                 > "2008/03/31" Then
                    objCommon.appendArray vntArrMessage, "�J�n���� 2008�N4��1�� �ȍ~�ł��B"
                End If
            End If

            '�o�͗l���̃`�F�b�N
            If Trim(strReportCd) >= "000330"  and trim(strReportCd) <= "000339" Then
                if Right("0000" & Trim(CStr(strSCslYear)), 4) & "/" & _
                   Right("00" & Trim(CStr(strSCslMonth)), 2) & "/" & _
                   Right("00" & Trim(CStr(strSCslDay)), 2) _
                 < "2008/04/01" Then
                    objCommon.appendArray vntArrMessage, "�J�n���� 2008�N4��1�� �ȑO�ł��B"
                End If
            End If
'## 2008.03.27 ���茒�f���ʕ񍐏��ǉ��ɂ���āA���я��C��  END   ############

            '����y�[�W�̃`�F�b�N
            If Trim(strReportCd) = "000303"  or trim(strReportCd) = "000307"  or trim(strReportCd) = "000324"  Then
                if strpage1 <> "1" and strpage2 <> "1" and strpage3 <> "1"  Then
                    objCommon.appendArray vntArrMessage, "����y�[�W���w�肵�Ă��������B"
                End If
            End If

            '����y�[�W�̃`�F�b�N
            If Trim(strReportCd) = "000304"  or trim(strReportCd) = "000308" or trim(strReportCd) = "000309"  or trim(strReportCd) = "000322" Then
                if strpage1 <> "1"  Then
                    objCommon.appendArray vntArrMessage, "����y�[�W���w�肵�Ă��������B"
                End If
            End If

'## 2011.08.25 SL-SN-Y0101-004 ADD START ##'
            If Trim(strDayId) = "" AND Trim(strOrgGrpCd) = "" AND Trim(strOrgCd11) = "" Then
                objCommon.appendArray vntArrMessage, "��f���͈͈ȊO�̏������w�肵�Ă��������B"
            End If
'## 2011.08.25 SL-SN-Y0101-004 ADD END ##'


        End If

    End With

    '�߂�l�̕ҏW
    If IsArray(vntArrMessage) Then
        CheckValue = vntArrMessage
    End If

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���[�h�L�������g�t�@�C���쐬����
'
' �����@�@ :
'
' �߂�l�@ : ������O���̃V�[�P���X�l
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function Print()

    Dim Ret             '�֐��߂�l
    Dim dtmStrCslDate   '�J�n��f��
    Dim dtmEndCslDate   '�I����f��
    Dim objFlexReport   '���я��o�͗p

    If Not IsArray(CheckValue()) Then

		'���R�����΍��p���O�����o��
		Call putPrivacyInfoLog("PH056", "���я��̈�����s����")

        dtmStrCslDate = CDate(strSCslDate)
        dtmEndCslDate = CDate(strECslDate)

        Set objFlexReport   = Server.CreateObject("HainsFlexReport.FlexReportControl")
        
        '���я��h�L�������g�t�@�C���쐬����
'       Ret = objFlexReport.PrintFlexReport(UID, strReportCd, dtmStrCslDate, dtmEndCslDate, strDayId, strOrgGrpCd, strOrgCd11, strOrgCd12, strOrgCd21, strOrgCd22, strOrgCd31, strOrgCd32, strOrgCd41, strOrgCd42, strOrgCd51, strOrgCd52, strOrgCd61, strOrgCd62, strOrgCd71, strOrgCd72)

'       Ret = objFlexReport.PrintFlexReport(UID, strReportCd, dtmStrCslDate, dtmEndCslDate, strDayId, strOrgGrpCd, strOrgCd11, strOrgCd12, strOrgCd21, strOrgCd22, strOrgCd31, strOrgCd32, strOrgCd41, strOrgCd42, strOrgCd51, strOrgCd52, strOrgCd61, strOrgCd62, strOrgCd71, strOrgCd72, strsort)

'#### 2010.06.25 SL-UI-Y0101-105 MOD START ####'
''''### 2008.03.12 �� ���茒�f���ѕ\�Ή��̂��ߒǉ� Start ###
''''        Ret = objFlexReport.PrintFlexReport(UID, strReportCd, dtmStrCslDate, dtmEndCslDate, strDayId, strOrgGrpCd, strOrgCd11, strOrgCd12, strOrgCd21, strOrgCd22, strOrgCd31, strOrgCd32, strOrgCd41, strOrgCd42, strOrgCd51, strOrgCd52, strOrgCd61, strOrgCd62, strOrgCd71, strOrgCd72, strsort, strpage1, strpage2, strpage3, strpage4, strpage5, strpage6, strCslDivCd, strBillPrint)
'''        Ret = objFlexReport.PrintFlexReport(UID, strReportCd, dtmStrCslDate, dtmEndCslDate, strDayId, strOrgGrpCd, strOrgCd11, strOrgCd12, strOrgCd21, strOrgCd22, strOrgCd31, strOrgCd32, strOrgCd41, strOrgCd42, strOrgCd51, strOrgCd52, strOrgCd61, strOrgCd62, strOrgCd71, strOrgCd72, strsort, strpage1, strpage2, strpage3, strpage4, strpage5, strpage6, strpage7, strCslDivCd, strBillPrint)
''''### 2008.03.12 �� ���茒�f���ѕ\�Ή��̂��ߒǉ� End   ###
        Ret = objFlexReport.PrintFlexReport(UID, strReportCd, dtmStrCslDate, dtmEndCslDate, strDayId, strOrgGrpCd, strOrgCd11, strOrgCd12, strOrgCd21, strOrgCd22, strOrgCd31, strOrgCd32, strOrgCd41, strOrgCd42, strOrgCd51, strOrgCd52, strOrgCd61, strOrgCd62, strOrgCd71, strOrgCd72, strsort, strpage1, strpage2, strpage3, strpage4, strpage5, strpage6, strpage7, strCslDivCd, strBillPrint, strpage8, strpage9, strpage10)
'#### 2010.06.25 SL-UI-Y0101-105 MOD END ####'

        Print = Ret
    End If

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>���я�</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// �c�̉�ʕ\��
function showGuideOrgGrp( Cd1, Cd2, CtrlName ) {

    // �c�̏��G�������g�̎Q�Ɛݒ�
    orgPostGuide_getElement( Cd1, Cd2, CtrlName );
    // ��ʕ\��
    orgPostGuide_showGuideOrg();

}

// �c�̏��폜
function clearGuideOrgGrp( Cd1, Cd2, CtrlName ) {

    // �c�̏��G�������g�̎Q�Ɛݒ�
    orgPostGuide_getElement( Cd1, Cd2, CtrlName );

    // �폜
    orgPostGuide_clearOrgInfo();

}

// �o�͕łP�`�F�b�N
function checkpage1Act() {

    with ( document.entryForm ) {
        checkpage1.value = (checkpage1.checked ? '1' : '0');
        checkpage1Val.value = (checkpage1.checked ? '1' : '0');
    }

}
// �o�͕łQ�`�F�b�N
function checkpage2Act() {

    with ( document.entryForm ) {
        checkpage2.value = (checkpage2.checked ? '1' : '0');
        checkpage2Val.value = (checkpage2.checked ? '1' : '0');
    }

}
// �o�͕łR�`�F�b�N
function checkpage3Act() {

    with ( document.entryForm ) {
        checkpage3.value = (checkpage3.checked ? '1' : '0');
        checkpage3Val.value = (checkpage3.checked ? '1' : '0');
    }

}
// �o�͕łS�`�F�b�N
function checkpage4Act() {

    with ( document.entryForm ) {
        checkpage4.value = (checkpage4.checked ? '1' : '0');
        checkpage4Val.value = (checkpage4.checked ? '1' : '0');
    }

}
// �o�͕łT�`�F�b�N
function checkpage5Act() {

    with ( document.entryForm ) {
        checkpage5.value = (checkpage5.checked ? '1' : '0');
        checkpage5Val.value = (checkpage5.checked ? '1' : '0');
    }

}
// �o�͕łU�`�F�b�N
function checkpage6Act() {

    with ( document.entryForm ) {
        checkpage6.value = (checkpage6.checked ? '1' : '0');
        checkpage6Val.value = (checkpage6.checked ? '1' : '0');
    }

}

/** 2008.03.12 �� ���茒�f���ѕ\�Ή��̂��ߒǉ� Start **/
// �o�͕łV�`�F�b�N
function checkpage7Act() {

    with ( document.entryForm ) {
        checkpage7.value = (checkpage7.checked ? '1' : '0');
        checkpage7Val.value = (checkpage7.checked ? '1' : '0');
    }
}
/** 2008.03.12 �� ���茒�f���ѕ\�Ή��̂��ߒǉ� End   **/

//'#### 2010.06.25 SL-UI-Y0101-105 MOD START ####'
function checkpage8Act() {

    with ( document.entryForm ) {
        checkpage8.value = (checkpage8.checked ? '1' : '0');
        checkpage8Val.value = (checkpage8.checked ? '1' : '0');
    }

}
function checkpage9Act() {

    with ( document.entryForm ) {
        checkpage9.value = (checkpage9.checked ? '1' : '0');
        checkpage9Val.value = (checkpage9.checked ? '1' : '0');
    }

}
function checkpage10Act() {

    with ( document.entryForm ) {
        checkpage10.value = (checkpage10.checked ? '1' : '0');
        checkpage10Val.value = (checkpage10.checked ? '1' : '0');
    }

}
//'#### 2010.06.25 SL-UI-Y0101-105 MOD END ####'


// submit���̏���
function submitForm() {

    document.entryForm.submit();

}

//function selectHistoryPrint( index ) {

//	document.entryForm.historyPrint.value = document.historyPrintForm.historyPrint[ index ].value;

//}

//-->
</SCRIPT>
<STYLE TYPE="text/css">
<!--
td.prttab { background-color:#ffffff }
-->
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" method="post">
    <BLOCKQUOTE>

    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">�����я�</SPAN></B></TD>
        </TR>
    </TABLE>
<%
    '�G���[���b�Z�[�W�\��
    Call EditMessage(vntMessage, MESSAGETYPE_WARNING)
%>
    <BR>
<%
    '���[�h�̓v���r���[�Œ�
%>
    <INPUT TYPE="hidden" NAME="mode" VALUE="0">

    <INPUT TYPE="hidden" NAME="OrgGrpName"    VALUE="<%= strOrgGrpName    %>">
    <INPUT TYPE="hidden" NAME="orgCd11"       VALUE="<%= strOrgCd11       %>">
    <INPUT TYPE="hidden" NAME="orgCd12"       VALUE="<%= strOrgCd12       %>">
    <INPUT TYPE="hidden" NAME="orgCd21"       VALUE="<%= strOrgCd21       %>">
    <INPUT TYPE="hidden" NAME="orgCd22"       VALUE="<%= strOrgCd22       %>">
    <INPUT TYPE="hidden" NAME="orgCd31"       VALUE="<%= strOrgCd31       %>">
    <INPUT TYPE="hidden" NAME="orgCd32"       VALUE="<%= strOrgCd32       %>">
    <INPUT TYPE="hidden" NAME="orgCd41"       VALUE="<%= strOrgCd41       %>">
    <INPUT TYPE="hidden" NAME="orgCd42"       VALUE="<%= strOrgCd42       %>">
    <INPUT TYPE="hidden" NAME="orgCd51"       VALUE="<%= strOrgCd51       %>">
    <INPUT TYPE="hidden" NAME="orgCd52"       VALUE="<%= strOrgCd52       %>">
    <INPUT TYPE="hidden" NAME="orgCd61"       VALUE="<%= strOrgCd61       %>">
    <INPUT TYPE="hidden" NAME="orgCd62"       VALUE="<%= strOrgCd62       %>">
    <INPUT TYPE="hidden" NAME="orgCd71"       VALUE="<%= strOrgCd71       %>">
    <INPUT TYPE="hidden" NAME="orgCd72"       VALUE="<%= strOrgCd72       %>">

    <!--- ���t -->
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD><FONT COLOR="#ff0000">��</FONT></TD>
            <TD WIDTH="90" NOWRAP>��f��</TD>
            <TD>�F</TD>
            <TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
            <TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strSCslYear, False) %></TD>
            <TD>�N</TD>
            <TD><%= EditNumberList("strCslMonth", 1, 12, strSCslMonth, False) %></TD>
            <TD>��</TD>
            <TD><%= EditNumberList("strCslDay", 1, 31, strSCslDay, False) %></TD>
            <TD>��</TD>
            <TD>�`</TD>
            <TD><A HREF="javascript:calGuide_showGuideCalendar('endCslYear', 'endCslMonth', 'endCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
            <TD><%= EditSelectNumberList("endCslYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strECslYear)) %></TD>
            <TD>�N</TD>
            <TD><%= EditSelectNumberList("endCslMonth", 1, 12, Clng("0" & strECslMonth)) %></TD>
            <TD>��</TD>
            <TD><%= EditSelectNumberList("endCslDay",   1, 31, Clng("0" & strECslDay  )) %></TD>
            <TD>��</TD>
        </TR>
    </TABLE>

    <!-- ����ID -->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
        <TR>
            <!--## 2011.08.25 SL-SN-Y0101-004 MOD START ##-->
            <!--## <TD>��</TD> ##-->
            <TD><FONT COLOR="#ff0000">��</FONT></TD>
            <!--## 2011.08.25 SL-SN-Y0101-004 MOD END ##-->
            <TD WIDTH="90" NOWRAP>����ID</TD>
            <TD>�F</TD>
            <TD>
                <INPUT TYPE="text" NAME="DayId" SIZE="100" VALUE="<%= strDayId %>">
            </TD>
        </TR>
    </TABLE>

    <!-- �c�̃O���[�v-->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
        <TR>
            <!--## 2011.08.25 SL-SN-Y0101-004 MOD START ##-->
            <!--## <TD>��</TD> ##-->
            <TD><FONT COLOR="#ff0000">��</FONT></TD>
            <!--## 2011.08.25 SL-SN-Y0101-004 MOD END ##-->
            <TD WIDTH="90" NOWRAP>�c�̃O���[�v</TD>
            <TD>�F</TD>
            <TD><%= EditOrgGrp_PList("OrgGrpCd", strOrgGrpCd, NON_SELECTED_ADD) %></TD>
        </TR>
    </TABLE>

    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <!--## 2011.08.25 SL-SN-Y0101-004 MOD START ##-->
            <!--## <TD>��</TD> ##-->
            <TD><FONT COLOR="#ff0000">��</FONT></TD>
            <!--## 2011.08.25 SL-SN-Y0101-004 MOD END ##-->
            <TD WIDTH="90" NOWRAP>�c�̂P</TD>
            <TD>�F</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd11, document.entryForm.orgCd12, 'OrgName1')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd11, document.entryForm.orgCd12, 'OrgName1')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName1"><% = strOrgName1 %></SPAN></TD>
        </TR>
        <TR>
            <TD>��</TD>
            <TD WIDTH="90" NOWRAP>�c�̂Q</TD>
            <TD>�F</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd21, document.entryForm.orgCd22, 'OrgName2')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd121, document.entryForm.orgCd22, 'OrgName2')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName2"><% = strOrgName2 %></SPAN></TD>
        </TR>
        <TR>
            <TD>��</TD>
            <TD WIDTH="90" NOWRAP>�c�̂R</TD>
            <TD>�F</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd31, document.entryForm.orgCd32, 'OrgName3')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd131, document.entryForm.orgCd32, 'OrgName3')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName3"><% = strOrgName3 %></SPAN></TD>
        </TR>
        <TR>
            <TD>��</TD>
            <TD WIDTH="90" NOWRAP>�c�̂S</TD>
            <TD>�F</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd41, document.entryForm.orgCd42, 'OrgName4')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd141, document.entryForm.orgCd42, 'OrgName4')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName4"><% = strOrgName4 %></SPAN></TD>
        </TR>
        <TR>
            <TD>��</TD>
            <TD WIDTH="90" NOWRAP>�c�̂T</TD>
            <TD>�F</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd51, document.entryForm.orgCd52, 'OrgName5')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd151, document.entryForm.orgCd52, 'OrgName5')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName5"><% = strOrgName5 %></SPAN></TD>
        </TR>
        <TR>
            <TD>��</TD>
            <TD WIDTH="90" NOWRAP>�c�̂U</TD>
            <TD>�F</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd61, document.entryForm.orgCd62, 'OrgName6')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd161, document.entryForm.orgCd62, 'OrgName6')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName6"><% = strOrgName6 %></SPAN></TD>
        </TR>
        <TR>
            <TD>��</TD>
            <TD WIDTH="90" NOWRAP>�c�̂V</TD>
            <TD>�F</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd71, document.entryForm.orgCd72, 'OrgName7')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd171, document.entryForm.orgCd72, 'OrgName7')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName7"><% = strOrgName7 %></SPAN></TD>
        </TR>
    </TABLE>
                <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
        <TR>
            <TD><FONT COLOR="#ff0000">��</FONT></TD>
            <TD WIDTH="90" NOWRAP>�o�͗l��</TD>
            <TD>�F</TD>
            <TD>
<!--
                <SELECT NAME="reportCd" ONCHANGE="javascript:selectHistoryPrint(this.selectedIndex)">
-->
                <SELECT NAME="reportCd">
                    <OPTION VALUE="">&nbsp;
<%
                    '���[�e�[�u���ǂݍ���
                    Set objReport = Server.CreateObject("HainsReport.Report")
'#### 2012.12.14 SL-SN-Y0101-611 MOD START ####
'                   lngReportCount = objReport.SelectReportList(strArrReportCd, strArrReportName, "1", , , , strArrHistoryPrint)
                    lngReportCount = objReport.SelectReportList(strArrReportCd, strArrReportName, "1", , , , strArrHistoryPrint, , , True)
'#### 2012.12.14 SL-SN-Y0101-611 MOD END ####
                    For i = 0 To lngReportCount - 1
%>
                        <OPTION VALUE="<%= strArrReportCd(i) %>" <%= IIf(strArrReportCd(i) = strReportCd, "SELECTED", "") %>><%= strArrReportName(i) %>
<%
                    Next
%>
                </SELECT>
            </TD>
        </TR>
    </TABLE>
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
                    <TR>
                        <TD><FONT COLOR="#ff0000">��</FONT></TD>
                        <TD WIDTH="90" NOWRAP>�o�͏�</TD>
                        <TD>�F</TD>
                        <TD>
                            <TABLE BORDER="0" CELLPADDING="5" CELLSPACING="0">
                                <TR>
                                    <TD><INPUT TYPE="Radio" NAME="sort" VALUE="0" <%= "CHECKED" %> checked>��f���{����ID</TD>
                                    <TD><INPUT TYPE="Radio" NAME="sort" VALUE="1" >�c�́{��f���{����ID</TD>
                                </TR>
                            </TABLE>
                        </TD>
                    </TR>
                </TABLE>
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
                    <TR>
                        <TD><FONT COLOR="#ff0000">��</FONT></TD>
                        <TD WIDTH="90" NOWRAP>����y�[�W</TD>
                        <TD>�F</TD>
                        <td>
                            <TABLE>
                                <TR>
                                    <INPUT TYPE="hidden" NAME="checkpage1Val" VALUE="<%= strpage1 %>">
                                    <TD NOWRAP><INPUT TYPE="CHECKBOX" NAME="checkpage1" VALUE="1" <%= Iif(strpage1 <> "0","CHECKED","") %> ONCLICK="javascript:checkpage1Act()" border="0">1page</TD>
                                </TR>
                            </TABLE>
                        </td>
                        <td>
                            <TABLE>
                                <TR>
                                    <INPUT TYPE="hidden" NAME="checkpage2Val" VALUE="<%= strpage2 %>">
                                    <TD NOWRAP><INPUT TYPE="CHECKBOX" NAME="checkpage2" VALUE="1" <%= Iif(strpage2 <> "0","CHECKED","") %> ONCLICK="javascript:checkpage2Act()" border="0">2page</TD>
                                </TR>
                            </TABLE>
                        </td>
                        <td>
                            <TABLE>
                                <TR>
                                    <INPUT TYPE="hidden" NAME="checkpage3Val" VALUE="<%= strpage3 %>">
                                    <TD NOWRAP><INPUT TYPE="CHECKBOX" NAME="checkpage3" VALUE="1" <%= Iif(strpage3 <> "0","CHECKED","") %> ONCLICK="javascript:checkpage3Act()" border="0">3page</TD>
                                </TR>
                            </TABLE>
                        </td>
                        <td>
                            <TABLE>
                                <TR>
                                    <INPUT TYPE="hidden" NAME="checkpage4Val" VALUE="<%= strpage4 %>">
                                    <TD NOWRAP><INPUT TYPE="CHECKBOX" NAME="checkpage4" VALUE="1" <%= Iif(strpage4 <> "0","CHECKED","") %> ONCLICK="javascript:checkpage4Act()" border="0">4page</TD>
                                </TR>
                            </TABLE>
                        </td>
                        <td>
                            <TABLE>
                                <TR>
                                    <INPUT TYPE="hidden" NAME="checkpage5Val" VALUE="<%= strpage5 %>">
                                    <TD NOWRAP><INPUT TYPE="CHECKBOX" NAME="checkpage5" VALUE="1" <%= Iif(strpage5 <> "0","CHECKED","") %> ONCLICK="javascript:checkpage5Act()" border="0">5page</TD>
                                </TR>
                            </TABLE>
                        </td>
                        <td>
                            <TABLE>
                                <TR>
                                    <INPUT TYPE="hidden" NAME="checkpage6Val" VALUE="<%= strpage6 %>">
                                    <TD NOWRAP><INPUT TYPE="CHECKBOX" NAME="checkpage6" VALUE="1" <%= Iif(strpage6 <> "0","CHECKED","") %> ONCLICK="javascript:checkpage6Act()" border="0">6page</TD>
                                </TR>
                            </TABLE>
                        </td>

                        <!--#### 2008.03.12 �� ���茒�f���ѕ\�Ή��̂��ߒǉ� Start ####-->
                        <td>
                            <TABLE>
                                <TR>
                                    <INPUT TYPE="hidden" NAME="checkpage7Val" VALUE="<%= strpage7 %>">
                                    <TD NOWRAP><INPUT TYPE="CHECKBOX" NAME="checkpage7" VALUE="1" <%= Iif(strpage7 <> "0","CHECKED","") %> ONCLICK="javascript:checkpage7Act()" border="0">7page</TD>
                                </TR>
                            </TABLE>
                        </td>
                        <!--#### 2008.03.12 �� ���茒�f���ѕ\�Ή��̂��ߒǉ� End   ####-->
                        <!--'#### 2010.06.25 SL-UI-Y0101-105 MOD START ####'-->
                        <td>
                            <TABLE>
                                <TR>
                                    <INPUT TYPE="hidden" NAME="checkpage8Val" VALUE="<%= strpage8 %>">
                                    <TD NOWRAP><INPUT TYPE="CHECKBOX" NAME="checkpage8" VALUE="1" <%= Iif(strpage8 <> "0","CHECKED","") %> ONCLICK="javascript:checkpage8Act()" border="0">8page</TD>
                                </TR>
                            </TABLE>
                        </td>
                        <td>
                            <TABLE>
                                <TR>
                                    <INPUT TYPE="hidden" NAME="checkpage9Val" VALUE="<%= strpage9 %>">
                                    <TD NOWRAP><INPUT TYPE="CHECKBOX" NAME="checkpage9" VALUE="1" <%= Iif(strpage9 <> "0","CHECKED","") %> ONCLICK="javascript:checkpage9Act()" border="0">9page</TD>
                                </TR>
                            </TABLE>
                        </td>
                        <td>
                            <TABLE>
                                <TR>
                                    <INPUT TYPE="hidden" NAME="checkpage10Val" VALUE="<%= strpage10 %>">
                                    <TD NOWRAP><INPUT TYPE="CHECKBOX" NAME="checkpage10" VALUE="1" <%= Iif(strpage10 <> "0","CHECKED","") %> ONCLICK="javascript:checkpage10Act()" border="0">10page</TD>
                                </TR>
                            </TABLE>
                        </td>
                        <!--'#### 2010.06.25 SL-UI-Y0101-105 MOD END ####'-->

                        <td></td>
                    </TR>
                </TABLE>


        <!-- �������o�͋敪 -->
        <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
            <TR>
                <TD>��</TD>
                <TD WIDTH="90" NOWRAP>��f�敪</TD>
                <TD>�F</TD>
    <%
                '�ėp�e�[�u�������f�敪��ǂݍ���
                Set objFree = Server.CreateObject("HainsFree.Free")
                objFree.SelectFree 1, "CSLDIV", strFreeCd, , , strFreeField1
                Set objFree = Nothing
    %>
                <TD><%= EditDropDownListFromArray("cslDivCd", strFreeCd, strFreeField1, strCslDivCd, NON_SELECTED_ADD) %></TD>
            </TR>
        </TABLE>

        
        <!-- �������o�͋敪 -->
        <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
            <TR>
                <TD>��</TD>
                <TD WIDTH="90" NOWRAP>�������o��</TD>
                <TD>�F</TD>
                <TD>
                    <SELECT NAME="billPrint">
                        <OPTION VALUE=""></OPTION>
                        <OPTION VALUE="1">�{�l</OPTION>
                        <OPTION VALUE="2">�Ƒ�</OPTION>
                    </SELECT>
                </TD>
             
            </TR>
        </TABLE>

        <BR>

    <!---2006.07.04 �����Ǘ� �ǉ� by ��  -->
    <% If Session("PAGEGRANT") = "4" Then   %>
        <A HREF="javascript:submitForm()"><IMG SRC="/webHains/images/print.gif" WIDTH="76" HEIGHT="23" ALT="�������"></A>
    <%  End if  %>

    </BLOCKQUOTE>
    <INPUT TYPE="hidden" NAME="orgname1" VALUE="<%= Server.HTMLEncode(strOrgName1) %>">
    <INPUT TYPE="hidden" NAME="orgname2" VALUE="<%= Server.HTMLEncode(strOrgName2) %>">
    <INPUT TYPE="hidden" NAME="orgname3" VALUE="<%= Server.HTMLEncode(strOrgName3) %>">
    <INPUT TYPE="hidden" NAME="orgname4" VALUE="<%= Server.HTMLEncode(strOrgName4) %>">
    <INPUT TYPE="hidden" NAME="orgname5" VALUE="<%= Server.HTMLEncode(strOrgName5) %>">
    <INPUT TYPE="hidden" NAME="orgname6" VALUE="<%= Server.HTMLEncode(strOrgName6) %>">
    <INPUT TYPE="hidden" NAME="orgname7" VALUE="<%= Server.HTMLEncode(strOrgName7) %>">
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
<!-- #include virtual = "/webHains/includes/orgGuideExtension.inc" -->
<script type="text/javascript">
var orgGuide_setLastOrgName = function(name, value)
{
	var form = document.entryForm;
	 
	if ( form[name] ) {
		form[name].value = value || '';
	}
};

document.body.onload = function()
{
	for ( var i = 1; i <= 7; i++ ) {
		document.getElementById('OrgName' + i).innerHTML = document.entryForm['orgname' + i].value;
	}
};
</script>
</BODY>
</HTML>