<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       �\����ڍ�(��{���) (Ver0.0.1)
'       AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<% '## 2004/04/20 Add By T.Takagi@FSIT �߂���f���Ō��f��������ꍇ�̃��[�j���O�Ή� %>
<!-- #include virtual = "/webHains/includes/recentConsult.inc" -->
<% '## 2004/04/20 Add End %>
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const MODE_SAVE               = "save"                  '�������[�h(�ۑ�)
Const MODE_CANCEL             = "cancel"                '�������[�h(�\��L�����Z��)
Const MODE_CANCELRECEIPT      = "cancelreceipt"         '�������[�h(��t������)
Const MODE_CANCELRECEIPTFORCE = "cancelreceiptforce"    '�������[�h(������t������)
Const MODE_DELETE             = "delete"                '�������[�h(�폜)
Const MODE_RESTORE            = "restore"               '�������[�h(����)

Const FREECD_CANCEL = "CANCEL"          '�ėp�R�[�h(�L�����Z�����R)
Const ORG_DUMMY     = "0000000000"      '�_�~�[�p�c�̎��ƕ��E�����E�����R�[�h

Const IGNORE_EXCEPT_NO_RSVFRA = "1"     '�\��g��������(�g�Ȃ��̓��t�����������\�񂪉\)
Const IGNORE_ANY              = "2"     '�\��g��������(�����鋭���\�񂪉\)

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon           '���ʃN���X
Dim objConsult          '��f���A�N�Z�X�p
Dim objContract         '�_����A�N�Z�X�p
Dim objFree             '�ėp���A�N�Z�X�p
Dim objSchedule         '�X�P�W���[�����A�N�Z�X�p
'### 2013.12.25 �c�̖��̃n�C���C�g�\���L�����`�F�b�N�̈גǉ��@Start ###
Dim objOrganization    '�c�̏��A�N�Z�X�p
'### 2013.12.25 �c�̖��̃n�C���C�g�\���L�����`�F�b�N�̈גǉ��@End   ###


'### 2013.08.03 ����ی��w���Ώێ҃`�F�b�N�̈גǉ��@Start ###
Dim objSpecialInterview '����ی��w���`�F�b�N�p
'### 2013.08.03 ����ی��w���Ώێ҃`�F�b�N�̈גǉ��@End   ###

'�O��ʂ��瑗�M�����p�����[�^�l(�X�V�̂�)
Dim strRsvNo            '�\��ԍ�

'�O��ʂ��瑗�M�����p�����[�^�l(�������[�h)
Dim strMode             '�������[�h

'�O��ʂ��瑗�M�����p�����[�^�l(���̑�)
Dim lngIgnoreFlg        '�\��g�����t���O

'��f���
Dim strPerId            '�l�h�c
Dim strAge              '��f���N��
Dim strOrgCd1           '�c�̃R�[�h�P
Dim strOrgCd2           '�c�̃R�[�h�Q
Dim strOrgName          '�c�̖���
Dim strCsCd             '�R�[�X�R�[�h
Dim strCslDivCd         '��f�敪�R�[�h
Dim strCslYear          '��f�N
Dim strCslMonth         '��f��
Dim strCslDay           '��f��
Dim strRsvGrpCd         '�\��Q�R�[�h
Dim strFirstRsvNo       '�P�����f�\��ԍ�
Dim strFirstCslDate     '�P�����f��f��
Dim strFirstCsName      '�P�����f�R�[�X��
Dim strCtrPtCd          '�_��p�^�[���R�[�h
Dim strReceiptMode      '��t�������[�h
Dim strReceiptDayId     '���Ԃ��s�������h�c
Dim lngCurDayId         '���݂̓����h�c
Dim strCancelFlg        '�L�����Z���t���O
Dim lngCurCancelFlg     '���݂̃L�����Z���t���O
'## 2004.10.13 Add By T.Takagi@FSIT ���l�h�c�����l�h�c�X�V
Dim strBefPerId         '���݂̌l�h�c
'## 2004.10.13 Add End

'�l���
Dim strLastName         '��
Dim strFirstName        '��
Dim strLastKName        '�J�i��
Dim strFirstKName       '�J�i��
Dim strBirth            '���N����(����)
Dim strEraBirth         '���N����(�a��)
Dim strGender           '����

'��f�t�����
Dim lngRsvStatus        '�\���
Dim	lngPrtOnSave        '�ۑ������
Dim	strCardAddrDiv      '�m�F�͂�������
Dim	lngCardOutEng       '�m�F�͂����p���o��
Dim	strFormAddrDiv      '�ꎮ��������
Dim	lngFormOutEng       '�ꎮ�����p���o��
Dim	strReportAddrDiv    '���я�����
Dim	lngReportOutEng     '���я��p���o��
Dim	strVolunteer        '�{�����e�B�A
Dim	strVolunteerName    '�{�����e�B�A��
Dim	strCollectTicket    '���p�����
Dim	lngIssueCslTicket   '�f�@�����s
Dim	strBillPrint        '�������o��
Dim	strIsrSign          '�ی��؋L��
Dim	strIsrNo            '�ی��ؔԍ�
Dim	strIsrManNo         '�ی��Ҕԍ�
Dim	strEmpNo            '�Ј��ԍ�
Dim	strIntroductor      '�Љ��
'#### 2013.3.1 SL-SN-Y0101-612 ADD START ####
Dim strSendMailDiv      '�\��m�F���[�����M��
'#### 2013.3.1 SL-SN-Y0101-612 ADD END   ####

'�I�v�V�����������
Dim strOptCd            '�I�v�V�����R�[�h
Dim strOptBranchNo      '�I�v�V�����}��

'�R�[�X���
Dim strArrCsCd          '�R�[�X�R�[�h
Dim strArrCsName        '�R�[�X��
Dim lngCsCount          '�R�[�X��

'��f�敪���
Dim strArrCslDivCd      '��f�敪�R�[�h
Dim strArrCslDivName    '��f�敪��
Dim lngCslDivCount      '��f�敪��

'�\��Q���
Dim strArrRsvGrpCd      '�\��Q�R�[�h
Dim strArrRsvGrpName    '�\��Q����
Dim lngRsvGrpCount      '�\��Q��

'�ėp���
Dim strFreeCd           '�ėp�R�[�h
Dim strFreeField1       '�ėp�t�B�[���h�P

Dim strUpdUser          '�X�V��
Dim dtmCslDate          '��f�N����
Dim strDayId            '�����h�c
Dim strEditOptCd        '�I�v�V�����R�[�h(hidden�^�O�ҏW�p)
Dim strEditOptBranchNo  '�I�v�V�����}��(hidden�^�O�ҏW�p)
Dim strHTML             'HTML������
Dim strMessage          '�G���[���b�Z�[�W
Dim strArrMessage       '�G���[���b�Z�[�W�̔z��
Dim Ret                 '�֐��߂�l
Dim i                   '�C���f�b�N�X

'### 2013.08.03 ����ی��w���Ώێ҃`�F�b�N�̈גǉ��@Start ###
Dim lngSpCheck    '����ی��w���Ώۂ��`�F�b�N
'### 2013.08.03 ����ی��w���Ώێ҃`�F�b�N�̈גǉ��@End   ###

Dim strWkCslDate        '��f��
Dim strRealAge          '���N��

'### 2013.12.25 �c�̖��̃n�C���C�g�\���L�����`�F�b�N�̈גǉ��@Start ###
Dim strHighLight    ' �c�̖��̃n�C���C�g�\���敪
'### 2013.12.25 �c�̖��̃n�C���C�g�\���L�����`�F�b�N�̈גǉ��@End   ###


'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objConsult = Server.CreateObject("HainsConsult.Consult")
'### 2013.12.25 �c�̖��̃n�C���C�g�\���L�����`�F�b�N�̈גǉ��@Start ###
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
'### 2013.12.25 �c�̖��̃n�C���C�g�\���L�����`�F�b�N�̈גǉ��@End   ###

'### 2013.08.03 ����ی��w���Ώێ҃`�F�b�N�̈גǉ��@Start ###
Set objSpecialInterview     = Server.CreateObject("HainsSpecialInterview.SpecialInterview")
'### 2013.08.03 ����ی��w���Ώێ҃`�F�b�N�̈גǉ��@End   ###

'�X�V�҂̐ݒ�
strUpdUser = Session("USERID")

'�����l�̎擾(��f���)
strRsvNo        = Request("rsvNo")
strMode         = Request("mode")
lngIgnoreFlg    = CLng("0" & Request("ignoreFlg"))
strPerId        = Request("perId")
strAge          = Request("age")
strOrgCd1       = Request("orgCd1")
strOrgCd2       = Request("orgCd2")
strOrgName      = Request("orgName")
strCsCd         = Request("csCd")
strCslDivCd     = Request("cslDivCd")
strCslYear      = Request("cslYear")
strCslMonth     = Request("cslMonth")
strCslDay       = Request("cslDay")
strRsvGrpCd     = Request("rsvGrpCd")
strFirstRsvNo   = Request("firstRsvNo")
strFirstCslDate = Request("firstCslDate")
strFirstCsName  = Request("firstCsName")
strCtrPtCd      = Request("ctrPtCd")
strReceiptMode  = Request("receiptMode")
strReceiptDayId = Request("dayId")
lngCurDayId     = CLng("0" & Request("curDayId"))
strCancelFlg    = Request("cancelFlg")
lngCurCancelFlg = CLng("0" & Request("curCancelFlg"))
'## 2004.10.13 Add By T.Takagi@FSIT ���l�h�c�����l�h�c�X�V
strBefPerId     = Request("befPerId")
'## 2004.10.13 Add End

'�����l�̎擾(�l���)
strLastName      = Request("lastName")
strFirstName     = Request("firstName")
strLastKName     = Request("lastKName")
strFirstKName    = Request("firstKName")
strBirth         = Request("birth")
strEraBirth      = Request("eraBirth")
strGender        = Request("gender")

'�����l�̎擾(��f�t�����)
lngRsvStatus      = CLng("0" & Request("rsvStatus"))
lngPrtOnSave      = CLng("0" & Request("prtOnSave"))
strCardAddrDiv    = Request("cardAddrDiv")
lngCardOutEng     = CLng("0" & Request("cardOutEng"))
strFormAddrDiv    = Request("formAddrDiv")
lngFormOutEng     = CLng("0" & Request("formOutEng"))
strReportAddrDiv  = Request("reportAddrDiv")
lngReportOutEng   = CLng("0" & Request("reportOutEng"))
strVolunteer      = Request("volunteer")
strVolunteerName  = Request("volunteerName")
strCollectTicket  = Request("collectTicket")
lngIssueCslTicket = CLng("0" & Request("issueCslTicket"))
strBillPrint      = Request("billPrint")
strIsrSign        = Request("isrSign")
strIsrNo          = Request("isrNo")
strIsrManNo       = Request("isrManNo")
strEmpNo          = Request("empNo")
strIntroductor    = Request("introductor")
'#### 2013.3.1 SL-SN-Y0101-612 ADD START ####
strSendMailDiv    = Request("sendMailDiv")
'#### 2013.3.1 SL-SN-Y0101-612 ADD END   ####

'�����l�̎擾(�I�v�V�����������)
strOptCd        = IIf(Request("optCd")       <> "", ConvIStringToArray(Request("optCd")),       Empty)
strOptBranchNo  = IIf(Request("optBranchNo") <> "", ConvIStringToArray(Request("optBranchNo")), Empty)

'��f�N�������n����Ă��Ȃ��ꍇ�A�V�X�e���N������K�p����
If strCslYear = "" Then
    strCslYear  = CStr(Year(Now))
    strCslMonth = CStr(Month(Now))
    strCslDay   = CStr(Day(Now))
End If

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do

    '�e���[�h���Ƃ̍X�V��������
    Select Case strMode

        '�ۑ���
        Case MODE_SAVE

            '���̓`�F�b�N
            strArrMessage = CheckValue()
            If Not IsEmpty(strArrMessage) Then
                Exit Do
            End If

            '��f���̕ҏW
            dtmCslDate = CDate(strCslYear & "/" & strCslMonth & "/" & strCslDay)

'## 2004/04/20 Add By T.Takagi@FSIT �߂���f���Ō��f��������ꍇ�̃��[�j���O�Ή�
            If lngIgnoreFlg = 0 Then
                strMessage = RecentConsult_CheckRecentConsult(strPerId, dtmCslDate, strCsCd, strRsvNo)
                If strMessage <> "" Then
                    strArrMessage = Array(strMessage)
                    Exit Do
                End If

'## 2005/09/08 Add By ���@�N�x���ɂQ��ڗ\����s���ꍇ�A���[�j���O�Ή��@�@
                strMessage = ""
                strMessage = objConsult.CheckConsult_Ctr(strPerId, dtmCslDate, strCsCd, strOrgCd1, strOrgCd2, strRsvNo)
                If strMessage <> "" Then
                    strArrMessage = Array(strMessage)
                    Exit Do
                End If
'## 2005/09/08 Add End  ---------------------------------------------

            End If
'## 2004/04/20 Add End


            '�\��ԍ����w�肳��Ă���ꍇ
            If strRsvNo <> "" Then

                '��f���̍X�V
'#### 2013.3.1 SL-SN-Y0101-612 UPD START ####
'## 2004.10.13 Mod By T.Takagi@FSIT ���l�h�c�����l�h�c�X�V
''				Ret = objConsult.UpdateConsult( _
''						  strRsvNo,         dtmCslDate,         strPerId,         _
''						  strCsCd,          strOrgCd1,          strOrgCd2,        _
''						  strRsvGrpCd,      strAge,             strUpdUser,       _
''						  strCtrPtCd,       strFirstRsvNo,      "",               _
''						  "",               strCslDivCd,        lngRsvStatus,     _
''						  lngPrtOnSave,     strCardAddrDiv,     lngCardOutEng,    _
''						  strFormAddrDiv,   lngFormOutEng,      strReportAddrDiv, _
''						  lngReportOutEng,  strVolunteer,       strVolunteerName, _
''						  strCollectTicket, lngIssueCslTicket,  strBillPrint,     _
''						  strIsrSign,       strIsrNo,           strIsrManNo,      _
''						  strEmpNo,         strIntroductor,     lngCurDayId,      _
''						  strOptCd,         strOptBranchNo,     strReceiptMode,   _
''						  strReceiptDayId,  strMessage,         lngIgnoreFlg,     _
''						  Request.ServerVariables("REMOTE_ADDR")                  _
''				)
'                Ret = objConsult.UpdateConsult( _
'                          strRsvNo,         dtmCslDate,         strPerId,         _
'                          strCsCd,          strOrgCd1,          strOrgCd2,        _
'                          strRsvGrpCd,      strAge,             strUpdUser,       _
'                          strCtrPtCd,       strFirstRsvNo,      "",               _
'                          "",               strCslDivCd,        lngRsvStatus,     _
'                          lngPrtOnSave,     strCardAddrDiv,     lngCardOutEng,    _
'                          strFormAddrDiv,   lngFormOutEng,      strReportAddrDiv, _
'                          lngReportOutEng,  strVolunteer,       strVolunteerName, _
'                          strCollectTicket, lngIssueCslTicket,  strBillPrint,     _
'                          strIsrSign,       strIsrNo,           strIsrManNo,      _
'                          strEmpNo,         strIntroductor,     lngCurDayId,      _
'                          strOptCd,         strOptBranchNo,     strReceiptMode,   _
'                          strReceiptDayId,  strMessage,         lngIgnoreFlg,     _
'                          Request.ServerVariables("REMOTE_ADDR"),                 _
'                          strBefPerId                                             _
'                )
''## 2004.10.13 Mod End
                Ret = objConsult.UpdateConsult( _
                          strRsvNo,         dtmCslDate,         strPerId,         _
                          strCsCd,          strOrgCd1,          strOrgCd2,        _
                          strRsvGrpCd,      strAge,             strUpdUser,       _
                          strCtrPtCd,       strFirstRsvNo,      "",               _
                          "",               strCslDivCd,        lngRsvStatus,     _
                          lngPrtOnSave,     strCardAddrDiv,     lngCardOutEng,    _
                          strFormAddrDiv,   lngFormOutEng,      strReportAddrDiv, _
                          lngReportOutEng,  strVolunteer,       strVolunteerName, _
                          strCollectTicket, lngIssueCslTicket,  strBillPrint,     _
                          strIsrSign,       strIsrNo,           strIsrManNo,      _
                          strEmpNo,         strIntroductor,     lngCurDayId,      _
                          strOptCd,         strOptBranchNo,     strReceiptMode,   _
                          strReceiptDayId,  strMessage,         lngIgnoreFlg,     _
                          Request.ServerVariables("REMOTE_ADDR"),                 _
                          strBefPerId,      strSendMailDiv                        _
                )
'#### 2013.3.1 SL-SN-Y0101-612 UPD END   ####

            '�\��ԍ����w�肳��Ă��Ȃ��ꍇ
            Else

                '��f���̑}��
'#### 2013.3.1 SL-SN-Y0101-612 UPD START ####
'                Ret = objConsult.InsertConsult( _
'                          dtmCslDate,        strPerId,         strCsCd,          _
'                          strOrgCd1,         strOrgCd2,        strRsvGrpCd,      _
'                          strAge,            strUpdUser,       strCtrPtCd,       _
'                          strFirstRsvNo,     "",               "",               _
'                          strCslDivCd,       lngRsvStatus,     lngPrtOnSave,     _
'                          strCardAddrDiv,    lngCardOutEng,    strFormAddrDiv,   _
'                          lngFormOutEng,     strReportAddrDiv, lngReportOutEng,  _
'                          strVolunteer,      strVolunteerName, strCollectTicket, _
'                          lngIssueCslTicket, strBillPrint,     strIsrSign,       _
'                          strIsrNo,          strIsrManNo,      strEmpNo,         _
'                          strIntroductor,    strOptCd,         strOptBranchNo,   _
'                          strReceiptMode,    strReceiptDayId,  strMessage,       _
'                          lngIgnoreFlg,                                          _
'                          Request.ServerVariables("REMOTE_ADDR")                 _
'                )
                Ret = objConsult.InsertConsult( _
                          dtmCslDate,        strPerId,         strCsCd,          _
                          strOrgCd1,         strOrgCd2,        strRsvGrpCd,      _
                          strAge,            strUpdUser,       strCtrPtCd,       _
                          strFirstRsvNo,     "",               "",               _
                          strCslDivCd,       lngRsvStatus,     lngPrtOnSave,     _
                          strCardAddrDiv,    lngCardOutEng,    strFormAddrDiv,   _
                          lngFormOutEng,     strReportAddrDiv, lngReportOutEng,  _
                          strVolunteer,      strVolunteerName, strCollectTicket, _
                          lngIssueCslTicket, strBillPrint,     strIsrSign,       _
                          strIsrNo,          strIsrManNo,      strEmpNo,         _
                          strIntroductor,    strOptCd,         strOptBranchNo,   _
                          strReceiptMode,    strReceiptDayId,  strMessage,       _
                          lngIgnoreFlg,                                          _
                          Request.ServerVariables("REMOTE_ADDR"),                _
                          strSendMailDiv                                         _
                )
'#### 2013.3.1 SL-SN-Y0101-612 UPD END   ####

            End If

            '�G���[���̃��b�Z�[�W�ҏW����
            If Ret <= 0 Then
                strArrMessage = Array(strMessage)
                Exit Do
            End If

            '�G���[���Ȃ���Η\��ԍ��t���Őe�t���[����URL��REPLACE�B�K�v�ɉ����Ĉ���_�C�A���O��\���B
            strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
            strHTML = strHTML & vbCrLf & "<SCRIPT TYPE=""text/javascript"">"
            strHTML = strHTML & vbCrLf & "<!--"

            '�u�͂����v�u���t�ē��v�̂����ꂩ�̈����v����ꍇ
            If lngRsvStatus = 0 Then

                Select Case lngPrtOnSave
                    Case 1
                        strHTML = strHTML & vbCrLf & "top.showPrintCardDialog('" & Ret & "','0','" & strCardAddrDiv & "','" & lngCardOutEng & "');"
                    Case 2
                        strHTML = strHTML & vbCrLf & "top.showPrintFormDialog('" & Ret & "','0','" & strFormAddrDiv & "','" & lngFormOutEng & "');"
                End Select

            End If

            strHTML = strHTML & vbCrLf & "top.location.replace('rsvMain.asp?rsvNo=" & Ret & "');"
            strHTML = strHTML & vbCrLf & "//-->"
            strHTML = strHTML & vbCrLf & "</SCRIPT>"
            strHTML = strHTML & vbCrLf & "</HTML>"
            Response.Write strHTML
            Response.End

        '�L�����Z����
        Case MODE_CANCEL

            '��f���̃L�����Z��
'## 2004.01.03 Mod By T.Takagi@FSIT �X�V�ґΉ�
'			Ret = objConsult.CancelConsult(strRsvNo, strCancelFlg, strMessage, (Request("cancelForce") <> ""))
            Ret = objConsult.CancelConsult(strRsvNo, strUpdUser, strCancelFlg, strMessage, (Request("cancelForce") <> ""))
'## 2004.01.03 Mod End
            If Ret <= 0 Then
                strArrMessage = Array(strMessage)
                Exit Do
            End If

            '�G���[���Ȃ���ΐe�t���[����URL��RELOAD����
            strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
            strHTML = strHTML & "<BODY ONLOAD=""JavaScript:top.location.reload()"">"
            strHTML = strHTML & "</BODY>"
            strHTML = strHTML & "</HTML>"
            Response.Write strHTML
            Response.End

        '��t��������
        Case MODE_CANCELRECEIPT

            '��t����������
'## 2004.01.03 Mod By T.Takagi@FSIT �X�V�ґΉ�
'			Ret = objConsult.CancelReceipt(strRsvNo, strCslYear, strCslMonth, strCslDay, strMessage)
            Ret = objConsult.CancelReceipt(strRsvNo, strUpdUser, strCslYear, strCslMonth, strCslDay, strMessage)
'## 2004.01.03 Mod End
            If Ret <= 0 Then
                strArrMessage = Array(strMessage)
                Exit Do
            End If

            '�G���[���Ȃ���ΐe�t���[����URL��RELOAD����
            strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
            strHTML = strHTML & "<BODY ONLOAD=""JavaScript:top.location.reload()"">"
            strHTML = strHTML & "</BODY>"
            strHTML = strHTML & "</HTML>"
            Response.Write strHTML
            Response.End

        '������t��������
        Case MODE_CANCELRECEIPTFORCE

            '��t����������
'## 2004.01.03 Mod By T.Takagi@FSIT �X�V�ґΉ�
'			Ret = objConsult.CancelReceipt(strRsvNo, strCslYear, strCslMonth, strCslDay, strMessage, True)
            Ret = objConsult.CancelReceipt(strRsvNo, strUpdUser, strCslYear, strCslMonth, strCslDay, strMessage, True)
'## 2004.01.03 Mod End
            If Ret <= 0 Then
                strArrMessage = Array(strMessage)
                Exit Do
            End If

            '�G���[���Ȃ���ΐe�t���[����URL��RELOAD����
            strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
            strHTML = strHTML & "<BODY ONLOAD=""JavaScript:top.location.reload()"">"
            strHTML = strHTML & "</BODY>"
            strHTML = strHTML & "</HTML>"
            Response.Write strHTML
            Response.End

        '�폜��
        Case MODE_DELETE

            '�폜����
'## 2004.01.03 Mod By T.Takagi@FSIT �X�V�ґΉ�
'			Ret = objConsult.DeleteConsult(strRsvNo, strMessage)
            Ret = objConsult.DeleteConsult(strRsvNo, strUpdUser, strMessage)
'## 2004.01.03 Mod End
            If Ret <= 0 Then
                strArrMessage = Array(strMessage)
                Exit Do
            End If

            '�G���[���Ȃ���ΐe�t���[����URL��REPLACE����
            strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
            strHTML = strHTML & "<BODY ONLOAD=""JavaScript:top.location.replace('rsvMain.asp')"">"
            strHTML = strHTML & "</BODY>"
            strHTML = strHTML & "</HTML>"
            Response.Write strHTML
            Response.End

        '������
        Case MODE_RESTORE

'## 2005/09/08 Add By ���@�N�x���ɂQ��ڗ\����s���ꍇ�A���[�j���O�Ή��@�@
            If lngIgnoreFlg = 0 Then
                strMessage = ""
                strMessage = objConsult.CheckConsult_Ctr(strPerId, dtmCslDate, strCsCd, strOrgCd1, strOrgCd2, strRsvNo)
                If strMessage <> "" Then
                    strArrMessage = Array(strMessage)
                    Exit Do
                End If
            End If
'## 2005/09/08 Add End  ---------------------------------------------

            '��������
            Ret = objConsult.RestoreConsult(strRsvNo, strUpdUser, strMessage, lngIgnoreFlg)
            If Ret <= 0 Then
                strArrMessage = Array(strMessage)
                Exit Do
            End If

            '�G���[���Ȃ���ΐe�t���[����URL��RELOAD����
            strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
            strHTML = strHTML & "<BODY ONLOAD=""JavaScript:top.location.reload()"">"
            strHTML = strHTML & "</BODY>"
            strHTML = strHTML & "</HTML>"
            Response.Write strHTML
            Response.End

    End Select

    '�\��ԍ����w�肳��Ă���ꍇ
    If strRsvNo <> "" Then

        '��f���ǂݍ���
        If objConsult.SelectConsult( _
               strRsvNo,      strCancelFlg,    dtmCslDate,           _
               strPerId,      strCsCd, ,       strOrgCd1,            _
               strOrgCd2,     strOrgName, , ,  strAge, , , , , , , , _
               strFirstRsvNo, strFirstCslDate, strFirstCsName, , ,   _
               strDayId, , , , , , , , , , , , , , , ,               _
               strCtrPtCd, ,  strLastName,     strFirstName,         _
               strLastKName,  strFirstKName,   strBirth,             _
               strGender, , , , , strCslDivCd, strRsvGrpCd           _
           ) = False Then
            Err.Raise 1000, ,"��f��񂪑��݂��܂���B"
        End If

        '��f�N�����̕ҏW
        dtmCslDate = CDate(dtmCslDate)
        strCslYear  = CStr(Year(dtmCslDate))
        strCslMonth = CStr(Month(dtmCslDate))
        strCslDay   = CStr(Day(dtmCslDate))

        '���N����(����{�a��)�̕ҏW
        strEraBirth = objCommon.FormatString(CDate(strBirth), "ge�iyyyy�j.m.d")

        '�������h�c����уL�����Z���t���O�̑ޔ�
        lngCurDayId     = CLng("0" & strDayId)
        lngCurCancelFlg = CLng("0" & strCancelFlg)

'## 2004.10.13 Add By T.Takagi@FSIT ���l�h�c�����l�h�c�X�V
        '���l�h�c�̑ޔ�
        strBefPerId = strPerId
'## 2004.10.13 Add End

        '�I�v�V�����������̓ǂݍ���
        objConsult.SelectConsult_O strRsvNo, strOptCd, strOptBranchNo

        '### 2013.08.03 ����ی��w���Ώێ҃`�F�b�N�̈גǉ��@Start ###
        '����ی��w���Ώێ҃`�F�b�N
        lngSpCheck = objSpecialInterview.CheckSpecialTarget(strRsvNo)
        '### 2013.08.03 ����ی��w���Ώێ҃`�F�b�N�̈גǉ��@End   ###

        '### 2013.12.25 �c�̖��̃n�C���C�g�\���L�����`�F�b�N�̈גǉ��@Start ###
        objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,strHighLight
        '### 2013.12.25 �c�̖��̃n�C���C�g�\���L�����`�F�b�N�̈גǉ��@End   ###

    End If

    Exit Do
Loop

Set objConsult = Nothing

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���̓`�F�b�N
'
' �����@�@ :
'
' �߂�l�@ : �G���[���b�Z�[�W�̔z��
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CheckValue()

    Dim objCourse       '�R�[�X���A�N�Z�X�p

    Dim strSecondFlg    '�Q�����f�t���O
    Dim strMessage      '�G���[���b�Z�[�W
    Dim i, j            '�C���f�b�N�X

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objCourse = Server.CreateObject("HainsCourse.Course")

    '�w��R�[�X���Q�����f���𔻒�
    objCourse.SelectCourse strCsCd, , , , , , , strSecondFlg

    '�Q�����f�̏ꍇ�A�P�����f�\��ԍ��͕K�{
    If strSecondFlg = "1" And strFirstRsvNo = "" Then
        objCommon.AppendArray strMessage, "�֘A���f���w�肵�Ă��������B"
    End If

    '�ۗ���Ԃł̎�t�͂ł��Ȃ�
    '#### 2007/04/04 �� �\��󋵋敪�ǉ��ɂ���ďC�� Start ####
    'If CLng(strReceiptMode) > 0 And lngRsvStatus = 1 Then
    '    objCommon.AppendArray strMessage, "���̎�f���͕ۗ�����Ă��܂��B��t�ł��܂���B"
    'End If
    If CLng(strReceiptMode) > 0 And lngRsvStatus <> 0 Then
        objCommon.AppendArray strMessage, "���̎�f���́y�ۗ��z���́y���m��z��Ԃł��B��t�ł��܂���B"
    End If
    '#### 2007/04/04 �� �\��󋵋敪�ǉ��ɂ���ďC�� End   ####

    '�{�����e�B�A���A�ی��؋L���E�ԍ��A�ی��Ҕԍ��A�Ј��ԍ�
    objCommon.AppendArray strMessage, objCommon.CheckWideValue("�{�����e�B�A��", strVolunteerName, 50)

'#### 2008/11/28 �� �ی��؋L���E�ԍ����ɑS�p�������o�^�ł���悤�ɏC�� Start   ####
'    objCommon.AppendArray strMessage, objCommon.CheckNarrowValue("�ی��؋L��",   strIsrSign,  16)
'    objCommon.AppendArray strMessage, objCommon.CheckNarrowValue("�ی��ؔԍ�",   strIsrNo,    16)
    objCommon.AppendArray strMessage, objCommon.CheckLength("�ی��؋L��",   strIsrSign,  16)
    objCommon.AppendArray strMessage, objCommon.CheckLength("�ی��ؔԍ�",   strIsrNo,    16)
'#### 2008/11/28 �� �ی��؋L���E�ԍ����ɑS�p�������o�^�ł���悤�ɏC�� End     ####

'#### 2008/09/22 �� �ی��Ҕԍ������R�����g���ɗp�r�ύX�i�S�p�������o�^�ł���悤�ɏC���j Start   ####
'###### 2010/05/26 �� �R�����g�������̕ی��Ҕԍ����ɖ߂� Start   ####
    objCommon.AppendArray strMessage, objCommon.CheckNarrowValue("�ی��Ҕԍ�",   strIsrManNo, 16)
'    objCommon.AppendArray strMessage, objCommon.CheckLength("�R�����g",   strIsrManNo, 16)
'###### 2010/05/26 �� �R�����g�������̕ی��Ҕԍ����ɖ߂� End     ####
'#### 2008/09/22 �� �ی��Ҕԍ������R�����g���ɗp�r�ύX�i�S�p�������o�^�ł���悤�ɏC���j End     ####

    objCommon.AppendArray strMessage, objCommon.CheckNarrowValue("�Ј��ԍ�",     strEmpNo,    12)

    '�G���[���b�Z�[�W�����݂���ꍇ�͂��̓��e��Ԃ�
    If Not IsEmpty(strMessage) Then
        CheckValue = strMessage
    End If

    set objCourse = Nothing

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type" content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�\����ڍ�</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<!-- #include virtual = "/webHains/includes/perGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
var winConsult;                 // ���f���ꗗ���

var curYear, curMonth, curDay;  // ���t�K�C�h�Ăяo�����O�̓��t�ޔ�p�ϐ�
var curOrgCd1, curOrgCd2;       // �c�̌����K�C�h�Ăяo�����O�̒c�̑ޔ�p�ϐ�

// ���ݓ��̎擾
function getCurrentDate() {

    var myForm = document.entryForm;
    curYear  = myForm.cslYear.value;
    curMonth = myForm.cslMonth.value;
    curDay   = myForm.cslDay.value;

}

// ���t�K�C�h�܂��̓J�����_�[������ʌĂяo��
function callCalGuide() {

    var mainForm = top.main.document.entryForm; // ���C����ʂ̃t�H�[���G�������g
    var optForm  = top.opt.document.entryForm;  // �I�v�V����������ʂ̃t�H�[���G�������g

    // �J�����_�[�����ɕK�v�ȍ��ڂ̃`�F�b�N
    for ( var ret = false; ; ) {
        if ( mainForm.perId.value == '' ) break;
        if ( mainForm.orgCd1.value == '' || mainForm.orgCd2.value == '' ) break;
        if ( mainForm.csCd.value == '' ) break;
        if ( mainForm.cslDivCd.value == '' ) break;
        if ( !top.isDate( mainForm.cslYear.value, mainForm.cslMonth.value, mainForm.cslDay.value ) ) break;
        if ( optForm == null ) break;
        if ( optForm.ctrPtCd.value == '' ) break;
        if ( mainForm.age.value == '' ) break;
        ret = true;
        break;
    }

    // �K�C�h�Ăяo�����O�̓��t��ޔ�
    getCurrentDate();

    // ���̓`�F�b�N
    if ( !ret ) {

        // �`�F�b�N�G���[�A���Ȃ킿�J�����_�[�����ł��Ȃ��ꍇ�͓��t�K�C�h���Ă�

        // ���t�K�C�h�\��
        calGuide_showGuideCalendar( 'cslYear', 'cslMonth', 'cslDay', checkDateChanged );

    // �����Ȃ��΃J�����_�[������ʂ��Ă�
    } else {

        top.header.callCalendar();

    }

}

// ���f���ꗗ��ʌĂяo��
function callConsultWindow() {

    var opened = false;     // ��ʂ��J����Ă��邩
    var url;                // ���f���ꗗ��ʂ�URL

    // ���̓`�F�b�N
    if ( !top.checkValue( 2 ) ) {
        return;
    }

    // ���łɃK�C�h���J����Ă��邩�`�F�b�N
    if ( winConsult != null ) {
        if ( !winConsult.closed ) {
            opened = true;
        }
    }

    // ���f���ꗗ��ʂ�URL�ҏW
    url = 'rsvConsultList.asp';
    url = url + '?perId='    + document.entryForm.perId.value;
    url = url + '&cslYear='  + document.entryForm.cslYear.value;
    url = url + '&cslMonth=' + document.entryForm.cslMonth.value;
    url = url + '&cslDay='   + document.entryForm.cslDay.value;
    url = url + '&rsvNo='    + document.entryForm.rsvNo.value;

    // �J����Ă���ꍇ�͉�ʂ�REPLACE���A�����Ȃ��ΐV�K��ʂ��J��
    if ( opened ) {
        winConsult.focus();
        winConsult.location.replace( url );
    } else {
        winConsult = open( url, '', 'toolbar=no,directories=no,menubar=no,resizable=no,scrollbars=yes,width=300,height=400' );
    }

}

// �c�̌����K�C�h�Ăяo��
function callOrgGuide() {

    // �K�C�h�Ăяo�����O�̓��t��ޔ�
    curOrgCd1 = document.entryForm.orgCd1.value;
    curOrgCd2 = document.entryForm.orgCd2.value;

    // �c�̌����K�C�h�\��
//    orgGuide_showGuideOrg( document.entryForm.orgCd1, document.entryForm.orgCd2, 'dspOrgName', null, null, changeOrg );

    orgGuide_showGuideOrg( document.entryForm.orgCd1, document.entryForm.orgCd2, 'dspOrgName', null, null, changeOrg, null, null, null, null, null, null, null, null, null, null, null, null, null, null, document.entryForm.sendComment);



}

// �l�����K�C�h�Ăяo��
function callPersonGuide() {

    // �ҏW�p�̊֐���`
    perGuide_CalledFunction = setPersonInfo;

    // �K�C�h��ʂ�\��
    var url = '/webHains/contents/guide/gdePersonal.asp?mode=1&defPerId=' + document.entryForm.perId.value;
<%
    If strRsvNo <> "" Then
%>
        url = url + '&defGender=' + document.entryForm.gender.value;
<%
    End If
%>
    perGuide_openWindow( url );

}

// �R�[�X�ύX���̏���
function changeCourse() {

    document.entryForm.csCd.value = document.entryForm.ctrCsCd.value;

    // �P�����f�����̐���
    controlFirstCslInfo();

    // �I�v�V����������ʂ̍X�V
    replaceOptionFrame( false, false, false );
}

// ��f���ύX���̏���
function changeDate() {

    // �P�����f���̓��e���N���A����
    clearFirstCslInfo();

    // ���\�����̌��f���ꗗ��ʂ����
    closeConsultWindow();

    // �I�v�V����������ʂ̍X�V
    replaceOptionFrame( false, false, true );

// ## 2003.01.13 Add By T.Takagi �ۑ������������@�ύX
    // �ۑ����������
    top.controlPrtOnSave();
// ## 2003.01.13 Add end

}

// ��f���ύX�`�F�b�N
function checkDateChanged() {

    // �ޔ����Ă������t�ƈقȂ�ꍇ�A��f���ύX���̏������Ăяo��
    if ( document.entryForm.cslYear.value != curYear || document.entryForm.cslMonth.value != curMonth || document.entryForm.cslDay.value != curDay ) {
        changeDate();
    }

}

// ��f�敪�ύX���̏���
function changeCslDiv() {

    document.entryForm.cslDivCd.value = document.entryForm.ctrCslDivCd.value;

    // �I�v�V����������ʂ̍X�V
    replaceOptionFrame( false, false, false );
}

// �\��Q�ύX���̏���
function changeRsvGrp() {

    document.entryForm.rsvGrpCd.value = document.entryForm.selRsvGrpCd.value;

}

// �c�̕ύX���̏���
function changeOrg() {

    // �c�̖��̂̊i�[
    document.entryForm.orgName.value = document.getElementById('dspOrgName').innerHTML;

    // �ޔ����Ă����c�̂ƈقȂ�ꍇ�A�I�v�V����������ʂ��X�V����
    if ( document.entryForm.orgCd1.value != curOrgCd1 || document.entryForm.orgCd2.value != curOrgCd2 ) {
        replaceOptionFrame( false, false, false );
    }

    // ��f�t�����̐������o�͐���
// ## 2004.01.29 Mod By T.Takagi@FSIT ���ڒǉ�
//  top.other.setBillPrintVisibility( ( orgGuide_BillCslDiv != '' ) );
    top.other.setBillPrintVisibility( ( orgGuide_BillCslDiv != '' || orgGuide_ReptCslDiv != '' ) );
// ## 2004.01.29 Mod End

/** 2016.09.19 �� �c�̏�񑗕t�ē��R�����g�ǉ� STR **/
    top.other.document.getElementById('sendCommentVal').innerHTML = document.entryForm.sendComment.value;
/** 2016.09.19 �� �c�̏�񑗕t�ē��R�����g�ǉ� END **/

}

// ���f���ꗗ��ʂ����
function closeConsultWindow() {

    // ���f���ꗗ��ʂ����
    if ( winConsult != null ) {
        if ( !winConsult.closed ) {
            winConsult.close();
        }
    }

    winConsult = null;
}

// �T�u��ʂ����
function closeWindow() {
    perGuide_closeGuidePersonal();  // �l�����K�C�h
    orgGuide_closeGuideOrg();       // �c�̌����K�C�h
    calGuide_closeGuideCalendar();  // ���t�K�C�h
    closeConsultWindow();           // ���f���ꗗ�K�C�h
}

// �P�����f���̃N���A
function clearFirstCslInfo() {
    top.setFirstCslInfo( '', '', '' );
}

// �P�����f�����̐���
function controlFirstCslInfo() {

    // �ύX��̃R�[�X���Q�����f�R�[�X�łȂ��ꍇ
    if ( !top.isSecondCourse( document.entryForm.csCd.value ) ) {

        // �P�����f���̓��e���N���A����
        clearFirstCslInfo();

        // ���\�����̌��f���ꗗ��ʂ����
        closeConsultWindow();

    }

}

// �l���̕ҏW
function editPerson() {

    var perName    = '';    // ����
    var perKName   = '';    // �J�i����
    var birthName  = '';    // ���N����
    var ageName    = '';    // �N��
    var genderName = '';    // ����

    // �����̕ҏW
    perName = document.entryForm.lastName.value;
    if ( document.entryForm.firstName.value != '' ) {
        perName = perName + '�@' + document.entryForm.firstName.value;
    }

    // ���������݂���ꍇ�̓A���J�[�𒣂�
    if ( perName != '' ) {
        perName = '<A HREF="/webHains/contents/maintenance/personal/mntPersonal.asp?mode=update&perid=' + document.entryForm.perId.value + '" TARGET="_blank"><B>' + perName + '<\/B><\/A>';
    }

    // �J�i�����̕ҏW
    perKName = document.entryForm.lastKName.value;
    if ( document.entryForm.firstKName.value != '' ) {
        perKName = perKName + '�@' + document.entryForm.firstKName.value;
    }

    // �J�i���������݂���ꍇ�͊��ʂł�����
    if ( perName != '' ) {
        perKName = '<FONT SIZE=\"1\">' + perKName + '</FONT>';
    }

    // ���N�����̕ҏW
    if ( document.entryForm.eraBirth.value != '' ) {
        birthName = document.entryForm.eraBirth.value + '��';
    }

    // ���N��̕ҏW
    if ( document.entryForm.realAge.value != '' ) {
        ageName = document.entryForm.realAge.value + '��';
    }

    // ��f���̎�f���N��ҏW
    if ( document.entryForm.age.value != '' ) {
        ageName = ageName + '�i' + document.entryForm.age.value.substring(0, document.entryForm.age.value.indexOf('.')) + '�΁j';
    }

    // ���ʂ̕ҏW
    switch ( document.entryForm.gender.value ) {
        case '<%= GENDER_MALE %>':
            genderName = '�j��';
            break;
        case '<%= GENDER_FEMALE %>':
            genderName = '����';
        default:
    }

    // �l���̕ҏW
    document.getElementById('dspPerId').innerHTML   = document.entryForm.perId.value;
    document.getElementById('dspPerName').innerHTML = perKName + '<BR>' + perName;
    document.getElementById('dspBirth').innerHTML   = birthName;
    document.getElementById('dspAge').innerHTML     = ageName;
    document.getElementById('dspGender').innerHTML  = genderName;

}

// �I�v�V����������ʓǂݍ���
function replaceOptionFrame( initFlg, perChanged, dateChanged ) {

    var myForm  = document.entryForm;           // ����ʂ̃t�H�[���G�������g
    var optForm = document.optionForm;          // ��f�I�v�V���������ێ��p�̃t�H�[���G�������g
    var setForm = top.opt.document.entryForm;   // �I�v�V����������ʂ̃t�H�[���G�������g

    // ��t��ʂ��J�����܂܃I�v�V������ʂɃ����[�h����������ƁA�ڍ׉�ʂƎ�t��ʂƂ̐��������Ƃ�Ȃ��Ȃ邽�߁A�����ŕ���
    if ( top.header.closeReceiptWindow ) {
        top.header.closeReceiptWindow();
    }

    // �I�v�V�����������ǂݍ���
    var url = '/webHains/contents/reserve/rsvOption.asp';
    url = url + '?rsvNo='     + myForm.rsvNo.value;
    url = url + '&cancelFlg=' + myForm.curCancelFlg.value;
    url = url + '&perId='     + myForm.perId.value;
    url = url + '&gender='    + myForm.gender.value;
    url = url + '&birth='     + myForm.birth.value;
    url = url + '&orgCd1='    + myForm.orgCd1.value;
    url = url + '&orgCd2='    + myForm.orgCd2.value;
    url = url + '&csCd='      + myForm.csCd.value;
    url = url + '&cslDate='   + myForm.cslYear.value + '/' + myForm.cslMonth.value + '/' + myForm.cslDay.value;
    url = url + '&cslDivCd='  + myForm.cslDivCd.value;
    url = url + '&rsvGrpCd='  + myForm.rsvGrpCd.value;

    // �ǂݍ��ݒ���̃Z�b�g���
    url = url + '&ctrPtCd='   + optForm.ctrPtCd.value;
    url = url + '&optCd='     + optForm.optCd.value;
    url = url + '&optBNo='    + optForm.optBranchNo.value;

    // �I�v�V����������ʂɂăZ�b�g��񂪕\������Ă���ꍇ
    if ( setForm ) {

        // �I�v�V����������ʂ̌��`�F�b�N��Ԃ��擾����
        var arrOptCd       = new Array();
        var arrOptBranchNo = new Array();
        top.convOptCd( top.opt.document.optList, arrOptCd, arrOptBranchNo );

        // �����ɒǉ�
        url = url + '&nowCtrPtCd=' + setForm.ctrPtCd.value;
        url = url + '&nowOptCd='   + arrOptCd;
        url = url + '&notOptBNo='  + arrOptBranchNo;

    }

    url = url + '&showAll=' + optForm.showAll.value;

    // �����ǂݍ��݂�
    if ( initFlg ) {
        url = url + '&init=1';
    }

// ## 2004.10.27 Add By T.Takagi@FSIT ���t�ύX���̓Z�b�g��r��ʂ������\��
    if ( dateChanged ) {
        url = url + '&dateChanged=1';
    }
// ## 2004.10.27 Add End

    // �I�v�V����������ʂ̓ǂݍ���
    top.opt.location.replace( url );

}

// �l���̃Z�b�g
function setPersonInfo( perInfo, calledMaintenance ) {

    var curPerId;   // �l�h�c
    var curBirth;   // ���N����
    var curGender;  // ����

    var replaceOpt = false; // �I�v�V����������ʍX�V�̕K�v��
    var perChanged = false;

    var myForm = document.entryForm;

    // ���݂̌l����ޔ�
    curPerId  = myForm.perId.value;
    curBirth  = myForm.birth.value;
    curGender = myForm.gender.value;

    // �l��񃁃��e�i���X��ʂ���Ă΂ꂽ�ꍇ
    if ( calledMaintenance ) {

        // �l�h�c���{��ʂƈقȂ�ꍇ�͉������Ȃ�
        if ( perInfo.perId != curPerId ) {
            return;
        }

    }

    // hidden�G�������g�̕ҏW
    myForm.perId.value      = perInfo.perId;
    myForm.lastName.value   = perInfo.lastName;
    myForm.firstName.value  = perInfo.firstName;
    myForm.lastKName.value  = perInfo.lastKName;
    myForm.firstKName.value = perInfo.firstKName;
    myForm.birth.value      = perInfo.birth;
    myForm.eraBirth.value   = perInfo.birthFull;
    myForm.gender.value     = perInfo.gender;

    // �l���̕ҏW
    editPerson();

    // ��f�t�����̏Z����ҏW
    top.other.document.getElementById('addr1').innerHTML = perInfo.address[0];
    top.other.document.getElementById('addr2').innerHTML = perInfo.address[1];
    top.other.document.getElementById('addr3').innerHTML = perInfo.address[2];

/** 2016.09.16 �� �d�b�ԍ��A���L�����擾�E�ҏW�̈גǉ� STR **/
    top.other.document.getElementById('tel1').innerHTML = perInfo.tel[0];
    top.other.document.getElementById('tel2').innerHTML = perInfo.tel[1];
    top.other.document.getElementById('tel3').innerHTML = perInfo.tel[2];

    top.other.document.getElementById('notes').innerHTML = perInfo.notes;
/** 2016.09.16 �� �d�b�ԍ��A���L�����擾�E�ҏW�̈גǉ� END **/

    // �l���̕ύX�`�F�b�N
    for ( ; ; ) {

        perChanged = false;

        // �l�h�c���ύX���ꂽ�ꍇ
        if ( perInfo.perId != curPerId ) {

// ## 2003.12.12 Add By T.Takagi@FSIT ���h�c���ŗ\��󋵂𐧌�
// ## 2004.10.13 Mod By T.Takagi@FSIT ���l�h�c�����l�h�c�X�V(���h�c���f���@�����ꂳ��Ă��Ȃ�)
//          top.other.document.entryForm.rsvStatus.value = perInfo.vidFlg == '1' ? '1' : '0';
            top.other.document.entryForm.rsvStatus.value = perInfo.perId.substring(0, 1) == '@' ? '1' : '0';
// ## 2004.10.13 Mod End
// ## 2003.12.12 Add End

            // ���݂̂P�����f����e���N���A
            clearFirstCslInfo();

            // ���f���ꗗ��ʂ��J���Ă���ꍇ�͕���
            closeConsultWindow();

            // �I�v�V����������ʂ̍X�V���K�v
            replaceOpt = true;
            perChanged = true;
            break;

        }

        // �l�h�c�͓��ꂾ�����N�����E���ʂ̂����ꂩ���ς�����ꍇ�̓I�v�V����������ʂ̍X�V���K�v
        if ( perInfo.birth != curBirth || perInfo.gender != curGender ) {
            replaceOpt = true;
            perChanged = false;
        }

        break;
    }

    // ��f�����I�����ꂽ�ꍇ
    if ( perInfo.csCd != null ) {

        // �R�[�X���ύX���ꂽ�ꍇ
        if ( perInfo.csCd != myForm.csCd.value ) {

            // �l�̍X�V
            myForm.csCd.value = perInfo.csCd;

            // �P�����f�����̐���
            controlFirstCslInfo();

            // �I�v�V����������ʂ̍X�V���K�v
            replaceOpt = true;

        }

        // �c�̂��ύX���ꂽ�ꍇ
        if ( perInfo.lastOrgCd1 != myForm.orgCd1.value || perInfo.lastOrgCd2 != myForm.orgCd2.value ) {

            // �ĕҏW
            myForm.orgCd1.value  = perInfo.lastOrgCd1;
            myForm.orgCd2.value  = perInfo.lastOrgCd2;
            myForm.orgName.value = perInfo.lastOrgName;
            document.getElementById('dspOrgName').innerHTML = perInfo.lastOrgName;

            // �I�v�V����������ʂ̍X�V���K�v
            replaceOpt = true;

        }

        // ��f�敪���ύX���ꂽ�ꍇ�͍X�V���A���I�v�V����������ʂ̍X�V���K�v
        if ( perInfo.cslDivCd != myForm.cslDivCd.value ) {
            myForm.cslDivCd.value = perInfo.cslDivCd;
            replaceOpt = true;
        }

        // �p�����ׂ����ڂ̕ҏW
        var otherForm = top.other.document.entryForm;
        otherForm.cardAddrDiv.value   = perInfo.cardAddrDiv;    // �m�F�͂�������
        otherForm.formAddrDiv.value   = perInfo.formAddrDiv;    // �ꎮ��������
        otherForm.reportAddrDiv.value = perInfo.reportAddrDiv;  // ���я�����
        otherForm.volunteer.value     = perInfo.volunteer;      // �{�����e�B�A
        otherForm.volunteerName.value = perInfo.volunteerName;  // �{�����e�B�A��
        otherForm.isrSign.value       = perInfo.isrSign;        // �ی��؋L��
        otherForm.isrNo.value         = perInfo.isrNo;          // �ی��ؔԍ�
        otherForm.isrManNo.value      = perInfo.isrManNo;       // �ی��Ҕԍ�
        otherForm.empNo.value         = perInfo.empNo;          // �Ј��ԍ�
<% '#### 2013.3.1 SL-SN-Y0101-612 ADD START #### %>
        otherForm.sendMailDiv.value   = perInfo.sendMailDiv;    // �\��m�F���[�����M��
<% '#### 2013.3.1 SL-SN-Y0101-612 ADD END   #### %>

    }

    // �I�v�V����������ʂ̍X�V���K�v�ȏꍇ
    if ( replaceOpt ) {

        // ���݂̔N��l���N���A
        myForm.age.value = '';
        document.getElementById('dspAge').innerHTML = '';

        // �I�v�V����������ʂ̍X�V
        replaceOptionFrame( false, perChanged, false );

    }

}

// �����\�����̕ҏW����
function setValue() {
    editPerson();                               // �l���ҏW
    replaceOptionFrame( true, false, false );   // �I�v�V����������ʓǂݍ���
    top.setFirstCslInfo('<%= strFirstRsvNo %>','<%= strFirstCslDate %>','<%= strFirstCsName %>');	// �P�����f���ҏW
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 0 0 20px 10px; }
</style>
</HEAD>
<BODY ONLOAD="javascript:setValue()" ONUNLOAD="JavaScript:closeWindow()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<INPUT TYPE="hidden" NAME="mode"       VALUE="">
<INPUT TYPE="hidden" NAME="rsvNo"      VALUE="<%= strRsvNo      %>">
<INPUT TYPE="hidden" NAME="perId"      VALUE="<%= strPerId      %>">
<INPUT TYPE="hidden" NAME="orgCd1"     VALUE="<%= strOrgCd1     %>">
<INPUT TYPE="hidden" NAME="orgCd2"     VALUE="<%= strOrgCd2     %>">
<INPUT TYPE="hidden" NAME="orgName"    VALUE="<%= strOrgName    %>">
<INPUT TYPE="hidden" NAME="lastName"   VALUE="<%= strLastName   %>">
<INPUT TYPE="hidden" NAME="firstName"  VALUE="<%= strFirstName  %>">
<INPUT TYPE="hidden" NAME="lastKName"  VALUE="<%= strLastKName  %>">
<INPUT TYPE="hidden" NAME="firstKName" VALUE="<%= strFirstKName %>">
<INPUT TYPE="hidden" NAME="birth"      VALUE="<%= strBirth      %>">
<INPUT TYPE="hidden" NAME="eraBirth"   VALUE="<%= strEraBirth   %>">
<INPUT TYPE="hidden" NAME="age"        VALUE="<%= strAge        %>">
<INPUT TYPE="hidden" NAME="gender"     VALUE="<%= strGender     %>">
<%'### 2016.09.19 �� %>
<INPUT TYPE="hidden" NAME="sendComment"     VALUE="">

<%
    '���N��̌v�Z
    strWkCslDate = strCslYear & "/" & strCslMonth & "/" & strCslDay
    If IsDate(strWkCslDate) And strBirth <> "" Then
        Set objFree = Server.CreateObject("HainsFree.Free")
        strRealAge = objFree.CalcAge(strBirth, strWkCslDate)
        Set objFree = Nothing
    Else
        strRealAge = ""
    End If

    '�����_�ȉ��̐؂�̂�
    If IsNumeric(strRealAge) Then
        strRealAge = CStr(Int(strRealAge))
    End If
%>
    <INPUT TYPE="hidden" NAME="realAge" VALUE="<%= strRealAge %>">

    <INPUT TYPE="hidden" NAME="firstRsvNo"   VALUE="">
    <INPUT TYPE="hidden" NAME="firstCslDate" VALUE="">
    <INPUT TYPE="hidden" NAME="firstCsName"  VALUE="">
<%
    '�������h�c�A���L�����Z���t���O��ێ�����
%>
    <INPUT TYPE="hidden" NAME="curDayId"     VALUE="<%= lngCurDayId     %>">
    <INPUT TYPE="hidden" NAME="curCancelFlg" VALUE="<%= lngCurCancelFlg %>">
<%
    '�ŐV�̎�f�I�v�V�����������i�[���邽�߂̃G�������g
%>
    <INPUT TYPE="hidden" NAME="ctrPtCd"     VALUE="">
    <INPUT TYPE="hidden" NAME="optCd"       VALUE="">
    <INPUT TYPE="hidden" NAME="optBranchNo" VALUE="">
<%
    '��t�����̂��߂̃G�������g
%>
    <INPUT TYPE="hidden" NAME="receiptMode" VALUE="0">
    <INPUT TYPE="hidden" NAME="dayId"       VALUE="0">
<%
    '�L�����Z�������̂��߂̃G�������g
%>
    <INPUT TYPE="hidden" NAME="cancelFlg"   VALUE="<%= strCancelFlg %>">
    <INPUT TYPE="hidden" NAME="cancelForce" VALUE="">
<%
    '���̑�������ʂ̍X�V���ڂ��i�[���邽�߂̃G�������g
%>
    <INPUT TYPE="hidden" NAME="rsvStatus"      VALUE="">
    <INPUT TYPE="hidden" NAME="prtOnSave"      VALUE="">
    <INPUT TYPE="hidden" NAME="cardAddrDiv"    VALUE="">
    <INPUT TYPE="hidden" NAME="cardOutEng"     VALUE="">
    <INPUT TYPE="hidden" NAME="formAddrDiv"    VALUE="">
    <INPUT TYPE="hidden" NAME="formOutEng"     VALUE="">
    <INPUT TYPE="hidden" NAME="reportAddrDiv"  VALUE="">
    <INPUT TYPE="hidden" NAME="reportOutEng"   VALUE="">
    <INPUT TYPE="hidden" NAME="volunteer"      VALUE="">
    <INPUT TYPE="hidden" NAME="volunteerName"  VALUE="">
    <INPUT TYPE="hidden" NAME="collectTicket"  VALUE="">
    <INPUT TYPE="hidden" NAME="issueCslTicket" VALUE="">
    <INPUT TYPE="hidden" NAME="billPrint"      VALUE="">
    <INPUT TYPE="hidden" NAME="isrSign"        VALUE="">
    <INPUT TYPE="hidden" NAME="isrNo"          VALUE="">
    <INPUT TYPE="hidden" NAME="isrManNo"       VALUE="">
    <INPUT TYPE="hidden" NAME="empNo"          VALUE="">
    <INPUT TYPE="hidden" NAME="introductor"    VALUE="">
<% '#### 2013.3.1 SL-SN-Y0101-612 ADD START #### %>
    <INPUT TYPE="hidden" NAME="sendMailDiv"    VALUE="">
<% '#### 2013.3.1 SL-SN-Y0101-612 ADD END   #### %>
<%
'## 2004.10.13 Add By T.Takagi@FSIT ���l�h�c�����l�h�c�X�V

    '�ǂݍ��ݒ���̌l�h�c��ێ�
%>
    <INPUT TYPE="hidden" NAME="befPerId" VALUE="<%= strBefPerId %>">
<%
'## 2004.10.13 Add End
%>
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#eeeeee" NOWRAP><B><FONT COLOR="#333333">��{���</FONT></B></TD>
        </TR>
    </TABLE>
    <SPAN ID="msgArea"></SPAN>
<%
    '�G���[���b�Z�[�W�̕ҏW
    If Not IsEmpty(strArrMessage) Then

        Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
%>
        <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0"><TR><TD HEIGHT="5"></TD></TR></TABLE>
<%
    End If

    '�L�����Z���҂̏ꍇ
    If lngCurCancelFlg <> CONSULT_USED Then

        Set objFree = Server.CreateObject("HainsFree.Free")

        '�L�����Z�����R��ǂݍ���
        objFree.SelectFree 0, FREECD_CANCEL & lngCurCancelFlg, , , ,strFreeField1

        Set objFree = Nothing
%>
        <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
            <TR>
                <TD HEIGHT="5"></TD>
            </TR>
            <TR>
                <TD NOWRAP><FONT COLOR="#ff6600"><B>���̎�f���̓L�����Z������Ă��܂��B</B></FONT>&nbsp;&nbsp;�L�����Z�����R�F<FONT COLOR="#ff6600"><B><%= strFreeField1 %></B></FONT></TD>
            </TR>
        </TABLE>
<%
    End If
%>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0" WIDTH="100%">
        <TR>
            <TD HEIGHT="5"></TD>
        </TR>
        <TR>
            <TD HEIGHT="25" WIDTH="70" NOWRAP>�l��</TD>
            <TD>�F</TD>
            <TD ID="gdePerson"><A HREF="JavaScript:callPersonGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�l�����K�C�h��\�����܂�"></A></TD>
            <TD NOWRAP ID="dspPerId"></TD>
            <TD>&nbsp;</TD>
            <TD NOWRAP ID="dspPerName"></TD>
            <TD>&nbsp;</TD>
            <TD NOWRAP ID="dspBirth"></TD>
            <TD>&nbsp;</TD>
            <TD NOWRAP ID="dspAge"></TD>
            <TD>&nbsp;</TD>
            <TD WIDTH="100%" NOWRAP ID="dspGender"></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0" WIDTH="100%">
        <TR>
            <TD HEIGHT="2"></TD>
        </TR>
        <TR>
            <TD HEIGHT="25" WIDTH="70" NOWRAP>�c��</TD>
            <TD>�F</TD>
            <TD ID="gdeOrg"><A HREF="javascript:callOrgGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\�����܂�"></A></TD>
            <TD WIDTH="100%" NOWRAP ID="dspOrgName"><%'= strOrgName %>

<%          If strHighLight = "1" Then  %>
                <font style='font-weight:bold; background-color:#00FFFF;'><b><%= strOrgName %></b></font>
<%          Else                        %>
                <%= strOrgName %>
<%          End If                      %>

<%          If lngSpCheck > 0 Then      %>
                <IMG SRC="../../images/physical10.gif"  HEIGHT="22" WIDTH="22" BORDER="0" ALT="����ی��w���Ώ�"><IMG SRC="../../images/spacer.gif" WIDTH="10" HEIGHT="1" ALT="">
<%          End If                      %>
            </TD>

        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0" WIDTH="100%">
        <TR>
            <TD HEIGHT="2"></TD>
        </TR>
        <TR>
            <TD WIDTH="70" NOWRAP>�R�[�X</TD>
            <TD>�F</TD>
            <TD COLSPAN="2">
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
                    <TR>
                        <TD>
                            <INPUT TYPE="hidden" NAME="csCd" VALUE="<%= strCsCd %>">
                            <SELECT NAME="ctrCsCd" STYLE="width:140;" ONCHANGE="javascript:changeCourse()">
<%
                                '�V�K���ȊO(�V�K�̏ꍇ�̓Z���N�V�����{�b�N�X����ɂ���)
                                If strRsvNo <> "" Then

                                    Set objContract = Server.CreateObject("HainsContract.Contract")

                                    '�w��c�̂ɂ������f�����_�ŗL���ȃR�[�X���_��Ǘ��������ɓǂݍ���
                                    lngCsCount = objContract.SelectAllCtrMng(strOrgCd1, strOrgCd2, "", dtmCslDate, dtmCslDate, , strArrCsCd, , strArrCsName)

                                    Set objContract = Nothing

                                    '�z��Y�������̃��X�g��ǉ�
                                    For i = 0 To lngCsCount - 1
%>
                                        <OPTION VALUE="<%= strArrCsCd(i) %>"<%= IIf(strArrCsCd(i) = strCsCd, " SELECTED", "") %>><%= strArrCsName(i) %>
<%
                                    Next

                                End If
%>
                            </SELECT>
                        </TD>
                        <TD NOWRAP>&nbsp;��f�敪�F</TD>
<%
                        Set objFree = Server.CreateObject("HainsFree.Free")

                        '�ėp�e�[�u�������f�敪��ǂݍ���
                        objFree.SelectFree 1, "CSLDIV", strFreeCd, , , strFreeField1

                        Set objFree = Nothing
%>
                        <TD>
                            <INPUT TYPE="hidden" NAME="cslDivCd" VALUE="<%= strCslDivCd %>">
                            <SELECT NAME="ctrCslDivCd" STYLE="width:85;" ONCHANGE="javascript:changeCslDiv()">
<%
                                '�V�K���ȊO(�V�K�̏ꍇ�̓Z���N�V�����{�b�N�X����ɂ���)
                                If strRsvNo <> "" Then

                                    Set objContract = Server.CreateObject("HainsContract.Contract")

                                    '�w��c�̂ɂ������f�����_�ŗL���Ȏ�f�敪���_��Ǘ��������ɓǂݍ���(�R�[�X�w�莞�͂���ɂ��̃R�[�X�ŗL���Ȃ���)
                                    lngCslDivCount = objContract.SelectAllCslDiv(strOrgCd1, strOrgCd2, strCsCd, dtmCslDate, dtmCslDate, strArrCslDivCd, strArrCslDivName)

                                    Set objContract = Nothing

                                    '�z��Y�������̃��X�g��ǉ�
                                    For i = 0 To lngCslDivCount - 1
%>
                                        <OPTION VALUE="<%= strArrCslDivCd(i) %>"<%= IIf(strArrCslDivCd(i) = strCslDivCd, " SELECTED", "") %>><%= strArrCslDivName(i) %>
<%
                                    Next

                                End If
%>
                            </SELECT>
                        </TD>
                    </TR>
                </TABLE>
            </TD>
            <TD ID="dspRsvNo" NOWRAP>�\��ԍ�</TD>
            <TD ID="dspRsvNoColon">�F</TD>
            <TD ALIGN="right" NOWRAP><B><%= strRsvNo %></B></TD>
        </TR>
        <TR>
            <TD HEIGHT="2"></TD>
        </TR>
        <TR>
            <TD>��f����</TD>
            <TD>�F</TD>
<!--
            <TD ID="gdeDate"><A HREF="javascript:callCalGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\�����܂�"></A></TD>
-->
            <TD ID="gdeDate"><A HREF="javascript:callCalGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="��f����I�����܂�"></A></TD>
            <TD WIDTH="100%">
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
                    <TR>
                        <TD><%= EditNumberList("cslYear", YEARRANGE_MIN, YEARRANGE_MAX, strCslYear, False) %></TD>
                        <TD>�N</TD>
                        <TD><%= EditNumberList("cslMonth", 1, 12, strCslMonth, False) %></TD>
                        <TD>��</TD>
                        <TD><%= EditNumberList("cslDay", 1, 31, strCslDay, False) %></TD>
                        <TD>��</TD>
                        <TD>
                            <INPUT TYPE="hidden" NAME="rsvGrpCd" VALUE="<%= strRsvGrpCd %>">
                            <!--SELECT NAME="selRsvGrpCd" STYLE="width:115;" ONCHANGE="javascript:changeRsvGrp()"-->
                            <!--SELECT NAME="selRsvGrpCd" STYLE="width:140;" ONCHANGE="javascript:changeRsvGrp()"-->
                            <SELECT NAME="selRsvGrpCd" STYLE="width:160;" ONCHANGE="javascript:changeRsvGrp()">
<%
                                '�V�K���ȊO(�V�K�̏ꍇ�̓Z���N�V�����{�b�N�X����ɂ���)
                                If strRsvNo <> "" Then

                                    '�I�u�W�F�N�g�̃C���X�^���X�쐬
                                    Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")

                                    '���t���V�X�e�����t���܂ވȍ~�̏ꍇ�̓R�[�X�ŗL���ȌQ���A�ߋ����̏ꍇ�͂��ׂĂ̌Q���擾
                                    If dtmCslDate >= Date() Then

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

                                End If
%>
                            </SELECT>
                        </TD>
                    </TR>
                </TABLE>
            </TD>
            <TD ID="dspDayId" NOWRAP>�����h�c</TD>
            <TD ID="dspDayIdColon">�F</TD>
            <TD ALIGN="right" NOWRAP><B><%= IIf(lngCurDayId > 0, objCommon.FormatString(lngCurDayId, "0000"), "") %></B></TD>
        </TR>
    </TABLE>
<% '## 2003.12.12 Add By T.Takagi@FSIT �ύX�O�̓��t���o�� %>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0" WIDTH="100%">
        <TR>
            <TD HEIGHT="5"></TD>
        </TR>
        <TR>
            <TD WIDTH="70" NOWRAP>����f��</TD>
            <TD>�F</TD>
<%'### 2016.09.14 �� ��f���̗j���\�� STR ###%>
            <!--TD WIDTH="100%"><B><%= objCommon.FormatString(dtmCslDate, "yyyy�Nmm��dd��") %></B></TD-->
            <TD WIDTH="100%"><B><%= objCommon.FormatString(dtmCslDate, "yyyy�Nmm��dd�� �iaaa�j") %></B></TD>
<%'### 2016.09.14 �� ��f���̗j���\�� END ###%>
        </TR>
    </TABLE>
<% '## 2003.12.12 Add End %>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0" WIDTH="100%">
        <TR>
            <TD HEIGHT="5"></TD>
        </TR>
        <TR>
            <TD WIDTH="70" NOWRAP>�֘A���f</TD>
            <TD>�F</TD>
            <TD ID="gdeConsult"><A HREF="javascript:callConsultWindow()"><IMG SRC="/webHains/images/question.gif" ALT="�P�����f���K�C�h��\�����܂�" HEIGHT="21" WIDTH="21"></A></TD>
            <TD ID="delConsult"><A HREF="javascript:clearFirstCslInfo()"><IMG SRC="/webHains/images/delicon.gif" HEIGHT="21" WIDTH="21" ALT="�P�����f�����N���A���܂�"></A></TD>
            <TD WIDTH="100%"><SPAN ID="dspFirstCslDate"></SPAN>&nbsp;<SPAN ID="dspFirstCsName"></SPAN></TD>
        </TR>
    </TABLE>
<%
'## 2004.01.27 Mod By T.Takagi@FSIT
'	'����t�A���\��g�����t���O�ɂċ����o�^�����������[�U�̏ꍇ�A�����o�^�p�̃`�F�b�N�{�b�N�X��\��
'	If lngCurDayId = 0 And (Session("IGNORE") = IGNORE_EXCEPT_NO_RSVFRA Or Session("IGNORE") = IGNORE_ANY) Then
    '�\��g�����t���O�ɂċ����o�^�����������[�U�̏ꍇ�A�����o�^�p�̃`�F�b�N�{�b�N�X��\��
    If Session("IGNORE") = IGNORE_EXCEPT_NO_RSVFRA Or Session("IGNORE") = IGNORE_ANY Then
'## 2004.01.27 Mod End
%>
        <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
            <TR>
                <TD HEIGHT="35"><INPUT TYPE="checkbox" NAME="ignoreFlg" VALUE="<%= Session("IGNORE") %>"<%= IIf(lngIgnoreFlg = CLng(Session("IGNORE")), " CHECKED", "") %>></TD>
                <TD NOWRAP>�����o�^���s��</TD>
            </TR>
        </TABLE>
<%
    End If
%>
</FORM>
<%
'�ǂݍ��ݒ���̎�f�I�v�V����������񓙁X
%>
<FORM NAME="optionForm" action="#">

    <% '�ǂݍ��ݒ���̊�{��� %>
    <INPUT TYPE="hidden" NAME="perId"    VALUE="<%= strPerId    %>">
    <INPUT TYPE="hidden" NAME="gender"   VALUE="<%= strGender   %>">
    <INPUT TYPE="hidden" NAME="birth"    VALUE="<%= strBirth    %>">
    <INPUT TYPE="hidden" NAME="orgCd1"   VALUE="<%= strOrgCd1   %>">
    <INPUT TYPE="hidden" NAME="orgCd2"   VALUE="<%= strOrgCd2   %>">
    <INPUT TYPE="hidden" NAME="csCd"     VALUE="<%= strCsCd     %>">
    <INPUT TYPE="hidden" NAME="cslDivCd" VALUE="<%= strCslDivCd %>">
    <INPUT TYPE="hidden" NAME="ctrPtCd"  VALUE="<%= strCtrPtCd  %>">
<%
    '�J���}�t��������ɕϊ�
    If Not IsEmpty(strOptCd) Then
        strEditOptCd = Join(strOptCd, ",")
    End If

    If Not IsEmpty(strOptBranchNo) Then
        strEditOptBranchNo = Join(strOptBranchNo, ",")
    End If
%>
    <INPUT TYPE="hidden" NAME="optCd" VALUE="<%= strEditOptCd %>">
    <INPUT TYPE="hidden" NAME="optBranchNo" VALUE="<%= strEditOptBranchNo %>">

    <% '�I�v�V�����ꗗ�̕\�����@(�I�v�V�����ꗗ��ʂŃZ�b�g�����l���{�G�������g�ɂ����f�����) %>
    <INPUT TYPE="hidden" NAME="showAll" VALUE="">
</FORM>
<%
'���\���_��̃��s�[�^�����Z�b�g�̗L������т��̎�f��Ԃ��Ǘ�
%>
<FORM NAME="repInfo" action="#">
    <INPUT TYPE="hidden" NAME="hasRepeaterSet"  VALUE="">
    <INPUT TYPE="hidden" NAME="repeaterConsult" VALUE="">
</FORM>
<SCRIPT TYPE="text/javascript">
<!--
var myForm = document.entryForm;
var wkNode;

<% '�C�x���g�n���h���̐ݒ� %>
myForm.cslYear.onchange  = changeDate;
myForm.cslMonth.onchange = changeDate;
myForm.cslDay.onchange   = changeDate;
<%
'If strRsvNo <> "" Then
%>
    myForm.cslYear.disabled  = true;
    myForm.cslMonth.disabled = true;
    myForm.cslDay.disabled   = true;
<%
'End If

'�L�����Z���҂̏ꍇ
If lngCurCancelFlg <> CONSULT_USED Then
%>
    myForm.ctrCsCd.disabled = true;
    myForm.ctrCslDivCd.disabled = true;

    document.getElementById('gdeOrg').innerHTML     = '';
    document.getElementById('gdeConsult').innerHTML = '';
    document.getElementById('delConsult').innerHTML = '';
<%
End If

'�L�����Z���ҁA�܂��͎�t�ς݂̏ꍇ
If lngCurCancelFlg <> CONSULT_USED Or lngCurDayId <> 0 Then
%>
//	myForm.cslYear.disabled     = true;
//	myForm.cslMonth.disabled    = true;
//	myForm.cslDay.disabled      = true;
    myForm.selRsvGrpCd.disabled = true;
    myForm.ctrCsCd.disabled     = true;

    document.getElementById('gdePerson').innerHTML  = '';
    document.getElementById('gdeDate').innerHTML    = '';
<%
End If

'�\��ԍ��̕\����
If strRsvNo = "" Then
%>
    wkNode = document.getElementById('dspRsvNo').innerHTML = '';
    wkNode = document.getElementById('dspRsvNoColon').innerHTML = '';
<%
End If

'�����h�c���̕\����
If lngCurDayId = 0 Then
%>
    wkNode = document.getElementById('dspDayId').innerHTML = '';
    wkNode = document.getElementById('dspDayIdColon').innerHTML = '';
<%
End If
%>
<%
'## 2003.12.12 Add By T.Takagi@FSIT �ۑ��������b�Z�[�W�Ή�
'�G���[�����݂��Ȃ��ꍇ
If IsEmpty(strArrMessage) Then
%>
    // cookie�l�̎擾
    var searchStr = 'rsvDetailOnSaving=';
    var strCookie = document.cookie;
    var startPos  = strCookie.indexOf(searchStr) + searchStr.length;
    var onSaveVal = strCookie.substring(startPos, startPos + 1);

    // �ۑ��n�����ɂ�cookie��������A���t���O�������A�ۑ��������b�Z�[�W���o��
    if ( onSaveVal == '1' ) {
        var html = '';
        html = html + '<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">';
        html = html + '<TR>';
        html = html + '<TD HEIGHT="5"><\/TD>';
        html = html + '<\/TR>';
        html = html + '<TR>';
        html = html + '<TD><IMG SRC="/webHains/images/ico_i.gif" WIDTH="16" HEIGHT="16" ALIGN="left"><\/TD>';
        html = html + '<TD VALIGN="bottom"><SPAN STYLE="color:#ff9900;font-weight:bolder;font-size:14px;">�ۑ����������܂����B<\/SPAN><\/TD>';
        html = html + '<\/TR>';
        html = html + '	</\TABLE>';
        document.getElementById('msgArea').innerHTML = html;
    }

    // �Ȍ�o�Ȃ��悤�A�t���O���N���A
    document.cookie = 'rsvDetailOnSaving=0';
<%
End If
'## 2003.12.12 Add End
'## 2004/04/20 Add By T.Takagi@FSIT �G���[���Ƀt���O���c������
%>
document.cookie = 'rsvDetailOnSaving=0';
<%
'## 2004/04/20 Add End
%>
//-->
</SCRIPT>
</BODY>
</HTML>

