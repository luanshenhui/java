<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'       �t�H���[�K�C�h (Ver0.0.1)
'       AUTHER  :
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objFollow               '�t�H���[�A�b�v�A�N�Z�X�p 
Dim objJud                  '������A�N�Z�X�p

Dim strMode                 '�������[�h(�}��:"insert"�A�X�V:"update")
Dim strAction               '�������(�ۑ��{�^��������:"save"�A�ۑ�������:"saveend")
Dim strTarget               '�^�[�Q�b�g���URL

'�p�����[�^
Dim lngRsvNo                '�\��ԍ�
Dim lngJudClassCd           '���蕪�ރR�[�h
Dim strJudClassName         '���蕪�ޖ�
Dim strJudCd                '����R�[�h�i�t�H���[�m�莞���茋�ʁj
Dim strRslJudCd             '����R�[�h�i�J�����g�i���݁j���茋�ʁj
Dim strSecEquipDiv          '�񎟌������{�i�{�݁j�敪

Dim strAddDate              '�X�V����
Dim strAddUser              '�X�V��ID
Dim strAddUserName          '�X�V�Ҏ���
Dim strUpdDate              '�X�V����
Dim strUpdUser              '�X�V��ID
Dim strUpdUserName          '�X�V�Ҏ���
Dim strStatusCd             '�X�e�[�^�X
Dim strSecEquipName         '�a��@��
Dim strSecEquipCourse       '�f�É�
Dim strSecDoctor            '�S����t
Dim strSecEquipAddr         '�a��@�Z��
Dim strSecEquipTel          '�a��@�d�b�ԍ�
Dim strSecPlanDate          '�񎟌����\���
Dim strSecPlanYear          '�񎟌����\����i�N�j
Dim strSecPlanMonth         '�񎟌����\����i���j
Dim strSecPlanDay           '�񎟌����\����i���j

'�񎟌����\�񍀖ڒǉ��@�F2009/12/21 yhlee ---------------
Dim strRsvTestUS               '�񎟌�������US
Dim strRsvTestCT               '�񎟌�������CT
Dim strRsvTestMRI              '�񎟌�������MRI
Dim strRsvTestBF               '�񎟌�������BF
Dim strRsvTestGF               '�񎟌�������GF
Dim strRsvTestCF               '�񎟌�������CF
Dim strRsvTestEM               '�񎟌������ڒ���
Dim strRsvTestTM               '�񎟌������ڎ�ᇃ}�[�J�[
Dim strRsvTestETC              '�񎟌������ڂ��̑�
Dim strRsvTestRemark           '�񎟌������ڂ��̑��R�����g
Dim strRsvTestRefer            '�񎟌������ڃ��t�@�[
Dim strRsvTestReferText        '�񎟌������ڃ��t�@�[��
Dim strRsvTestName             '
'�񎟌������ڒǉ� (End) --------------------------------

Dim strReqSendDate          '�˗��󔭑���
Dim strReqSendUser          '�˗��󔭑���ID
Dim strReqSendUserName      '�˗��󔭑��Ҏ���
Dim strReqCheckDate1        '��ꊩ����
Dim strReqCheckDate2        '��񊩏���
Dim strReqCheckDate3        '��O�������i�\���j
Dim strReqCancelDate        '�������~��
Dim strReqConfirmDate       '���ʏ��F��
Dim strReqConfirmUser       '���ʏ��F��ID
Dim strReqConfirmUserName   '���ʏ��F�Ҏ���
Dim strReqConfirmFlg        '���ʏ��F�����敪�i0�F���F����A1�F���F�j
Dim strSecRemark            '���l
Dim strSecCslDate           '�񎟎��{��
Dim strSecCslYear           '�񎟎��{���i�N�j
Dim strSecCslMonth          '�񎟎��{���i���j
Dim strSecCslDay            '�񎟎��{���i���j

Dim vntRsvNo                '�\��ԍ�
Dim vntJudClassCd           '�������ځi���蕪�ށj
Dim vntSeq                  '��A�ԍ�
Dim vntSecCslDate           '�񎟎��{��
Dim vntTestUS               '�񎟌�������US
Dim vntTestCT               '�񎟌�������CT
Dim vntTestMRI              '�񎟌�������MRI
Dim vntTestBF               '�񎟌�������BF
Dim vntTestGF               '�񎟌�������GF
Dim vntTestCF               '�񎟌�������CF
Dim vntTestEM               '�񎟌������ڒ���
Dim vntTestTM               '�񎟌������ڎ�ᇃ}�[�J�[
Dim vntTestETC              '�񎟌������ڂ��̑�
Dim vntTestRemark           '�񎟌������ڂ��̑��R�����g
'�񎟌������ڒǉ��@�F2009/12/21 yhlee ---------------
Dim vntTestRefer            '�񎟌������ڃ��t�@�[
Dim vntTestReferText        '�񎟌������ڃ��t�@�[��
'�񎟌������ڒǉ��@(End)-----------------------------
Dim vntResultDiv            '�񎟌������ʋ敪
Dim vntDisRemark            '�񎟌������ʂ��̑�����
Dim vntPolWithout           '���u�s�v�i���Õ��j�j�F���ÂȂ�
Dim vntPolFollowup          '�o�ߊώ@�F���ÂȂ�
Dim vntPolMonth             '�o�ߊώ@���ԁi�����j�F���ÂȂ�
Dim vntPolReExam            '1�N�㌒�f�F���ÂȂ�
Dim vntPolDiagSt            '�{�@�Љ�i�����j�F���ÂȂ�
Dim vntPolDiag              '���@�Љ�i�����j�F���ÂȂ�
Dim vntPolEtc1              '���̑��F���ÂȂ�
Dim vntPolRemark1           '���̑����́F���ÂȂ�
Dim vntPolSugery            '�O�Ȏ��ÁF���Â���
Dim vntPolEndoscope         '�������I���ÁF���Â���
Dim vntPolChemical          '���w�Ö@�F���Â���
Dim vntPolRadiation         '���ː����ÁF���Â���
Dim vntPolReferSt           '�{�@�Љ�F���Â���
Dim vntPolRefer             '���@�Љ�F���Â���
Dim vntPolEtc2              '���̑��F���Â���
Dim vntPolRemark2           '���̑����́F���Â���
Dim vntAddDate              '�쐬���t
Dim vntAddUser              '�쐬��ID
Dim vntAddUserName          '�쐬�Ҏ���
Dim vntUpdDate              '�X�V���t
Dim vntUpdUser              '�X�V��ID
Dim vntUpdUserName          '�X�V�Ҏ���

'�e�񎟌������ʏ��ʐf�f���擾�z
Dim vntGrpName              '�������ڃO���[�v���́i��ʁj
Dim vntItemCd               '�������ڃR�[�h
Dim vntSuffix               '�T�t�B�N�X
Dim vntItemName             '�������ږ��i���툽�͕��ʁj
Dim vntResult               '�����R�[�h�i���̓R�[�h�j
Dim vntShortStc             '�������i���͖��́j

'��ʕ\������p��������
Dim strBeforeGrpName        '�O�s�̃O���[�v����
Dim strWebGrpName           '�O���[�v���̉�ʕ\���p

Dim lngCount                '���R�[�h����
Dim lngAllCount             '������
Dim lngStcCount             '�擾�f�f������

'����R���{�{�b�N�X
Dim strArrJudCdSeq          '����A��
Dim strArrJudCd             '����R�[�h
Dim strArrWeight            '����p�d��
Dim lngJudListCnt           '���茏��

Dim i                       '�C���f�b�N�X
Dim j                       '�C���f�b�N�X
Dim Ret                     '���A�l
Dim rslCnt                  '���ʓ��͗��C���f�b�N�X

Dim strArrMessage           '�G���[���b�Z�[�W

'��ʕ\������p
Dim strWebResultDivName     '�񎟌������ʋ敪�i���́j
Dim strWebTestItem          '�񎟌�������
Dim strWebPolicy1           '���ÂȂ����j
Dim strWebPolicy2           '���Â�����j

Dim lngPolCount1            '���j�i���ÂȂ��j���J�E���g�p
Dim lngPolCount2            '���j�i���Â���j���J�E���g�p
Dim lngTestCount            '�������ڐ��J�E���g�p


'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objFollow       = Server.CreateObject("HainsFollow.Follow")
Set objJud          = Server.CreateObject("HainsJud.Jud")

'�p�����[�^�l�̎擾
strMode                 = Request("mode")
strAction               = Request("act")
strTarget               = Request("target")

lngRsvNo                = Request("rsvno")
lngJudClassCd           = Request("judClassCd")
strJudClassName         = Request("judClassName")
strJudCd                = Request("judCd")
strRslJudCd             = Request("rslJudCd")
strSecEquipDiv          = Request("secEquipDiv")
strUpdDate              = Request("updDate")
strUpdUser              = Request("updUser")
strUpdUserName          = Request("updUserName")
strStatusCd             = Request("statusCd")
strSecEquipName         = Request("secEquipName")
strSecEquipCourse       = Request("secEquipCourse")
strSecDoctor            = Request("secDoctor")
strSecEquipAddr         = Request("secEquipAddr")
strSecEquipTel          = Request("secEquipTel")
strSecPlanDate          = Request("secPlanDate")
strSecPlanYear          = Request("secPlanYear")
strSecPlanMonth         = Request("secPlanMonth")
strSecPlanDay           = Request("secPlanDay")

'�񎟌����\�񍀖ڒǉ��@�F2009/12/21 yhlee ---------------
strRsvTestUS               = Request("rsvTestUS")
strRsvTestCT               = Request("rsvTestCT")
strRsvTestMRI              = Request("rsvTestMRI")
strRsvTestBF               = Request("rsvTestBF")
strRsvTestGF               = Request("rsvTestGF")
strRsvTestCF               = Request("rsvTestCF")
strRsvTestEM               = Request("rsvTestEM")
strRsvTestTM               = Request("rsvTestTM")
strRsvTestETC              = Request("rsvTestETC")
strRsvTestRemark           = Request("rsvTestRemark")
strRsvTestRefer            = Request("rsvTestRefer")
strRsvTestReferText        = Request("rsvTestReferText")
'�񎟌������ڒǉ��@(End)-----------------------------

strReqSendDate          = Request("reqSendDate")
strReqSendUser          = Request("reqSendUser")
strReqSendUserName      = Request("reqSendUserName")
strReqCheckDate1        = Request("reqCheckDate1")
strReqCheckDate2        = Request("reqCheckDate2")
strReqCheckDate3        = Request("reqCheckDate3")
strReqCancelDate        = Request("reqCancelDate")
strReqConfirmDate       = Request("reqConfirmDate")
strReqConfirmUser       = Request("reqConfirmUser")
strReqConfirmUserName   = Request("ReqConfirmUserName")
strReqConfirmFlg        = Request("ReqConfirmFlg")
strSecRemark            = Request("secRemark")

'����R�[�h���X�g�擾
Call EditJudListInfo

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do

    '�ۑ��{�^��������
    If strAction = "save" Then

        '���̓`�F�b�N
        strArrMessage = CheckValue()
        If Not IsEmpty(strArrMessage) Then
            Exit Do
        End If

'        response.write "lngRsvNo            --> " & lngRsvNo            & "<br>"
'        response.write "lngJudClassCd       --> " & lngJudClassCd       & "<br>"
'        response.write "strSecEquipDiv      --> " & strSecEquipDiv      & "<br>"
'        response.write "updUser             --> " & Session.Contents("userId")      & "<br>"
'        response.write "strJudCd            --> " & strJudCd            & "<br>"
'        response.write "strStatusCd         --> " & strStatusCd         & "<br>"
'        response.write "strSecEquipName     --> " & strSecEquipName     & "<br>"
'        response.write "strSecDoctor        --> " & strSecDoctor        & "<br>"
'        response.write "strSecEquipAddr     --> " & strSecEquipAddr     & "<br>"
'        response.write "strSecEquipTel      --> " & strSecEquipTel      & "<br>"
'        response.write "strSecPlanDate      --> " & strSecPlanDate      & "<br>"
'        response.write "strSecRemark        --> " & strSecRemark        & "<br>"
'        response.end


        '### �t�H���[�A�b�v���X�V����
'2009.11.26 ��
'        Ret = objFollow.UpdateFollow_Info(lngRsvNo, lngJudClassCd, _
'                                          strSecEquipDiv, Session.Contents("userId"), strJudCd, _
'                                          strStatusCd, strSecEquipName, strSecDoctor, _
'                                          strSecEquipAddr, strSecEquipTel, strSecPlanDate, _
'                                          strSecRemark)

'2009.12.22 yhlee
'        Ret = objFollow.UpdateFollow_Info(lngRsvNo, lngJudClassCd, _
'                                          strSecEquipDiv, Session.Contents("userId"), strJudCd, _
'                                          strStatusCd, strSecEquipName, strSecEquipCourse, strSecDoctor, _
'                                          strSecEquipAddr, strSecEquipTel, strSecPlanDate, _
'                                          strSecRemark)

'2009.12.22 yhlee�@�F�񎟌����\�񍀖ڒǉ�
        Ret = objFollow.UpdateFollow_Info(lngRsvNo, lngJudClassCd, _
                                          strSecEquipDiv, Session.Contents("userId"), strJudCd, _
                                          strStatusCd, strSecEquipName, strSecEquipCourse, strSecDoctor, _
                                          strSecEquipAddr, strSecEquipTel, strSecPlanDate, _
                                          strRsvTestUS, strRsvTestCT, strRsvTestMRI, _
                                          strRsvTestBF, strRsvTestGF, strRsvTestCF, _
                                          strRsvTestEM, strRsvTestTM, strRsvTestETC, _
                                          strRsvTestRemark, strRsvTestRefer, strRsvTestReferText, _
                                          strSecRemark)
        If Ret Then
            strAction = "saveend"
        Else
            strArrMessage = Array("�t�H���[�A�b�v���X�V�Ɏ��s���܂����B")
            Exit Do
        End If

    ElseIf strAction = "delete" Then

        '�t�H���[�A�b�v���폜����
        Ret = objFollow.DeleteFollow_Info( lngRsvNo, lngJudClassCd, Session.Contents("userId"))

        If Ret Then
            strAction = "deleteend"
        Else
            strArrMessage = Array("�t�H���[�A�b�v���폜�Ɏ��s���܂����B")
            Exit Do
        End If

    ElseIf strAction = "confirm" Then

        '### �t�H���[�A�b�v��񏳔F�i���͏��F�����j����
        Ret = objFollow.UpdateFollow_Info_Confirm(lngRsvNo, lngJudClassCd, strReqConfirmFlg, Session.Contents("userId"))
        If Ret Then
            strAction = "saveend"
        Else
            strArrMessage = Array("�t�H���[�A�b�v���X�V�Ɏ��s���܂����B")
            Exit Do
        End If

    End If

    '### �t�H���[�A�b�v���擾
'    objFollow.SelectFollow_Info lngRsvNo,           lngJudClassCd, _
'                                strJudClassName,    strJudCd,               strRslJudCd, _
'                                strSecEquipDiv,     strUpdDate,             strUpdUser, _
'                                strUpdUserName,     strStatusCd,            strSecEquipName, _
'                                strSecDoctor,       strSecEquipAddr,        strSecEquipTel, _
'                                strSecPlanDate,     strReqSendDate,         strReqSendUser, _
'                                strReqSendUserName, strReqCheckDate1,       strReqCheckDate2, _
'                                strReqCheckDate3,   strReqCancelDate,       strReqConfirmDate, _
'                                strReqConfirmUser,  strReqConfirmUserName,  strSecRemark

'2009.11.26 ��
'    objFollow.SelectFollow_Info lngRsvNo,           lngJudClassCd, _
'                                strJudClassName,    strJudCd,               strRslJudCd, _
'                                strSecEquipDiv,     strUpdDate,             strUpdUser, _
'                                strUpdUserName,     strStatusCd,            strSecEquipName, _
'                                strSecDoctor,       strSecEquipAddr,        strSecEquipTel, _
'                                strSecPlanDate,     strReqSendDate,         strReqSendUser, _
'                                strReqSendUserName, strReqCheckDate1,       strReqCheckDate2, _
'                                strReqCheckDate3,   strReqCancelDate,       strReqConfirmDate, _
'                                strReqConfirmUser,  strReqConfirmUserName,  strSecRemark, _
'                                strAddDate,         strAddUser,             strAddUserName

'2009.12.24 ��
'    objFollow.SelectFollow_Info lngRsvNo,           lngJudClassCd, _
'                                strJudClassName,    strJudCd,               strRslJudCd, _
'                                strSecEquipDiv,     strUpdDate,             strUpdUser, _
'                                strUpdUserName,     strStatusCd,            strSecEquipName,      strSecEquipCourse, _
'                                strSecDoctor,       strSecEquipAddr,        strSecEquipTel, _
'                                strSecPlanDate,     strReqSendDate,         strReqSendUser, _
'                                strReqSendUserName, strReqCheckDate1,       strReqCheckDate2, _
'                                strReqCheckDate3,   strReqCancelDate,       strReqConfirmDate, _
'                                strReqConfirmUser,  strReqConfirmUserName,  strSecRemark, _
'                                strAddDate,         strAddUser,             strAddUserName

'2009.12.24 �񎟌������ڒǉ� : �� 
    objFollow.SelectFollow_Info lngRsvNo,           lngJudClassCd, _
                                strJudClassName,    strJudCd,               strRslJudCd, _
                                strSecEquipDiv,     strUpdDate,             strUpdUser, _
                                strUpdUserName,     strStatusCd,            strSecEquipName,      strSecEquipCourse, _
                                strSecDoctor,       strSecEquipAddr,        strSecEquipTel, _
                                strSecPlanDate,     strReqSendDate,         strReqSendUser, _
                                strReqSendUserName, strReqCheckDate1,       strReqCheckDate2, _
                                strReqCheckDate3,   strReqCancelDate,       strReqConfirmDate, _
                                strReqConfirmUser,  strReqConfirmUserName,  strSecRemark, _
                                strRsvTestName, _
                                strRsvTestUS,       strRsvTestCT,           strRsvTestMRI, _
                                strRsvTestBF,       strRsvTestGF,           strRsvTestCF, _
                                strRsvTestEM,       strRsvTestTM,           strRsvTestEtc, _
                                strRsvTestRemark,   strRsvTestRefer,        strRsvTestReferText, _ 
                                strAddDate,         strAddUser,             strAddUserName

    If strSecPlanDate <> "" Then
        strSecPlanYear   = Year(strSecPlanDate)
        strSecPlanMonth  = Month(strSecPlanDate)
        strSecPlanDay    = Day(strSecPlanDate)
    End If

    '### �t�H���[�A�b�v���ʃ��X�g�擾
'2009.11.26 ��
'    lngAllCount = objFollow.SelectFollowRslList(lngRsvNo,            lngJudClassCd, _
'                                                vntRsvNo,            vntJudClassCd,      vntSeq, _
'                                                vntSecCslDate,       vntTestUS,          vntTestCT, _
'                                                vntTestMRI,          vntTestBF,          vntTestGF, _
'                                                vntTestCF,           vntTestEM,          vntTestTM, _
'                                                vntTestEtc,          vntTestRemark,      vntResultDiv, _
'                                                vntDisRemark,        vntPolWithout,      vntPolFollowup, _
'                                                vntPolMonth,         vntPolReExam,       vntPolDiagSt,      vntPolDiag, _
'                                                vntPolEtc1,          vntPolRemark1,      vntPolSugery, _
'                                                vntPolEndoscope,     vntPolChemical,     vntPolRadiation, _
'                                                vntPolReferSt,       vntPolRefer,        vntPolEtc2,        vntPolRemark2, _
'                                                vntUpdDate,          vntUpdUser,         vntUpdUserName _
'                                                )

    lngAllCount = objFollow.SelectFollowRslList(lngRsvNo,            lngJudClassCd, _
                                                vntRsvNo,            vntJudClassCd,      vntSeq, _
                                                vntSecCslDate,       vntTestUS,          vntTestCT, _
                                                vntTestMRI,          vntTestBF,          vntTestGF, _
                                                vntTestCF,           vntTestEM,          vntTestTM, _
                                                vntTestRefer,        vntTestReferText, _
                                                vntTestEtc,          vntTestRemark,      vntResultDiv, _
                                                vntDisRemark,        vntPolWithout,      vntPolFollowup, _
                                                vntPolMonth,         vntPolReExam,       vntPolDiagSt,      vntPolDiag, _
                                                vntPolEtc1,          vntPolRemark1,      vntPolSugery, _
                                                vntPolEndoscope,     vntPolChemical,     vntPolRadiation, _
                                                vntPolReferSt,       vntPolRefer,        vntPolEtc2,        vntPolRemark2, _
                                                vntUpdDate,          vntUpdUser,         vntUpdUserName _
                                                )

    Exit Do
Loop


'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ����̔z��쐬
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub EditJudListInfo()

    '����ꗗ�擾
    lngJudListCnt = objJud.SelectJudList( strArrJudCd, , , strArrWeight)

    strArrJudCdSeq = Array()
    Redim Preserve strArrJudCdSeq(lngJudListCnt-1)
    For i = 0 To lngJudListCnt-1
        strArrJudCdSeq(i) = i
    Next

End Sub


'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �t�H���[�A�b�v���e�l�̑Ó����`�F�b�N���s��
'
' �����@�@ :
'
' �߂�l�@ : �G���[�l������ꍇ�A�G���[���b�Z�[�W�̔z���Ԃ�
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CheckValue()

    Dim objCommon       '���ʃN���X

    Dim vntArrMessage   '�G���[���b�Z�[�W�̏W��
    Dim strMessage      '�G���[���b�Z�[�W
    Dim i               '�C���f�b�N�X

    '���ʃN���X�̃C���X�^���X�쐬
    Set objCommon = Server.CreateObject("HainsCommon.Common")

    '�e�l�`�F�b�N����
    With objCommon

        '�񎟌����\���
        .AppendArray vntArrMessage, .CheckDate("�񎟌����\���", strSecPlanYear, strSecPlanMonth, strSecPlanDay, strSecPlanDate)


        '�a��@��
        strMessage = .CheckWideValue("�a��@��", strSecEquipName, 50)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "�i���s�������܂݂܂��j"
        End If

        '�f�É�
        strMessage = .CheckWideValue("�f�É�", strSecEquipCourse, 50)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "�i���s�������܂݂܂��j"
        End If

        '�S����t
        strMessage = .CheckWideValue("�S����t", strSecDoctor, 40)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "�i���s�������܂݂܂��j"
        End If

        '�Z��
        strMessage = .CheckLength("�Z��", strSecEquipAddr, 120)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "�i���s�������܂݂܂��j"
        End If

        '�Z��
        strMessage = .CheckLength("�d�b�ԍ�", strSecEquipTel, 15)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "�i���s�������܂݂܂��j"
        End If

        '���l(���s������1���Ƃ��Ċ܂ގ|��ʒB)
        strMessage = .CheckWideValue("���l", strSecRemark, 400)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "�i���s�������܂݂܂��j"
        End If

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
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>�񎟌��f���o�^</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<%
    '### �ۑ������A�폜������e��ʂ��ŐV���ŕ\��
    If strAction = "saveend" Then
%>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
        //�e��ʂ������Ă��Ȃ������ꍇ�A�e��ʃ��t���b�V��
        if (!opener.closed) {
            opener.replaceForm();
        }
//-->
</SCRIPT>
<%
    ElseIf strAction = "deleteend" Then
%>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
        //�e��ʂ������Ă��Ȃ������ꍇ�A�e��ʃ��t���b�V��
        if (!opener.closed) {
            opener.replaceForm();
        }
        window.close();
//-->
</SCRIPT>
<%
    End If
%>

<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--

    var winRslFol;          // �t�H���[���ʓo�^�E�B���h�E�n���h��


    /** ���蕪�ޕʃt�H���[�A�b�v���ۑ� **/
    function saveData() {

        if ( !confirm( '�t�H���[�A�b�v����ύX���܂��B��낵���ł����H' ) ) {
            return;
        }
        with ( document.entryForm ) {
            act.value = 'save';
            submit();
        }

        //�e��ʂ������Ă��Ȃ������ꍇ�A�e��ʃ��t���b�V��
        //if (!opener.closed) {
        //    opener.replaceForm();
        //}
        return false;

    }


    /** ���蕪�ޕʃt�H���[�A�b�v���폜 **/
    function deleteData() {

        if ( !confirm( '�t�H���[�A�b�v�����폜���܂��B\n�t�H���[�A�b�v���͍폜����ƌ��ɖ߂������o���܂���B\n\n�폜���Ă�낵���ł��傤���H' ) ) {
            return;
        }

        // ���[�h���w�肵��submit
        with ( document.entryForm ) {
            act.value = 'delete';
            submit();
        }
        return false;
    }

    /** �t�H���[�A�b�v���ʏ��F���͏��F������� **/
    function followRslConfirm(confirmFlg,statusCd) {
        var confirmMsg;
        var scnt ;

        if (confirmFlg == '1') {
            if(statusCd==''){
                 alert("�w�X�e�[�^�X�x�͕K�{���ڂł��̂ŁA��Ɂw�X�e�[�^�X�x��o�^���Ă��������B");
                return false;
            }

            confirmMsg = '�񎟌������ʂ����F���܂��B                 \n\n���F���Ă�낵���ł��傤���H';
        } else {
            confirmMsg = '���F����Ă���񎟌������ʂ����F������܂��B\n\n���F������Ă�낵���ł��傤���H';
        }

        if ( !confirm( confirmMsg ) ) {
            return;
        }
        with ( document.entryForm ) {
            reqConfirmFlg.value = confirmFlg;
            act.value = 'confirm';
            submit();
        }
        return false;
    }



    function showFollowRsl(rsvNo, judClassCd, seq) {

        var opened = false; // ��ʂ��J����Ă��邩
        var url;            // URL������
        var myForm = document.entryFollowInfo;

        // ���łɉ�ʂ��J����Ă��邩�`�F�b�N
        if ( winRslFol != null ) {
            if ( !winRslFol.closed ) {
                opened = true;
            }
        }

        // �t�H���[���ʓo�^��ʌĂяo��
        url = 'followRslEdit.asp?winmode=1&rsvno='+rsvNo+'&judClassCd=' + judClassCd+'&seq=' + seq;

        // �J����Ă���ꍇ�͉�ʂ�REPLACE���A�����Ȃ��ΐV�K��ʂ��J��
        if ( opened ) {
            winRslFol.focus();
            winRslFol.location.replace(url);
        } else {
            /** 2016.09.13 �� ���ʓ��͉�ʏ����\���T�C�Y�ύX **/
            //winRslFol = window.open(url, '', 'width=1040,height=700,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
            winRslFol = window.open(url, '', 'width=1140,height=800,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
        } 
    }

    // �{�^���N���b�N
    function replaceForm() {

        with ( document.entryForm ) {
            action.value = "";
            submit();
        }
        return false;
    }

    function chkWrite(chkBox, txtArea) {

        if(chkBox.checked) {
            txtArea.disabled = false;
            txtArea.focus();
        } else {
            txtArea.value = "";
            txtArea.disabled = true;
        }
    }

    function onLoad(){
        with (document.entryForm){

            if(rsvTestETC.checked) {
                rsvTestRemark.disabled = false;
            } else {
                rsvTestRemark.disabled = true;
            }

            if(rsvTestRefer.checked) {
                rsvTestReferText.disabled = false;
            } else {
                rsvTestReferText.disabled = true;
            }
        }
    }

    function replace(){
    }

//-->
</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
</HEAD>
<BODY BGCOLOR="#ffffff"  ONLOAD="onLoad();">

<!-- #include virtual = "/webHains/includes/followupHeader.inc" -->
<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
    <TR>
        <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">�t�H���[�A�b�v���o�^</FONT></B></TD>
    </TR>
</TABLE>
<TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="500">
    <TR>
        <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
    </TR>
</TABLE>
<%
    '## ��f�Ҍl���\��
    Call followupHeader(lngRsvNo)
%>
    <!--BR-->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
    <INPUT TYPE="hidden"    NAME="mode"         VALUE="<%= strMode %>"      >
    <INPUT TYPE="hidden"    NAME="act"          VALUE=""                    >
    <INPUT TYPE="hidden"    NAME="target"       VALUE="<%= strTarget %>"    >
    <INPUT TYPE="hidden"    NAME="rsvno"        VALUE="<%= lngRsvNo %>"     >
    <INPUT TYPE="hidden"    NAME="judClassCd"   VALUE="<%= lngJudClassCd %>">

<%
    '���b�Z�[�W�̕ҏW
    If strAction <> "" Then

        Select Case strAction

            '�ۑ��������́u�ۑ������v�̒ʒm
            Case "saveend"
                Call EditMessage("�ۑ����������܂����B", MESSAGETYPE_NORMAL)

            '�����Ȃ��΃G���[���b�Z�[�W��ҏW
            Case Else
                Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)

        End Select

End If
%>
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
        <TR ALIGN="left">
            <TD width="*">
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                    <TR align="center">
                        <TD NOWRAP BGCOLOR="#cccccc" width="120" HEIGHT="22">���f����</TD>
                        <TD NOWRAP BGCOLOR="#eeeeee" width="120"><B><%= strJudClassName %></B></TD>
                        <TD width="20">&nbsp;</TD>
                        <TD NOWRAP BGCOLOR="#cccccc" width="120">����</TD>
                        <TD NOWRAP BGCOLOR="#eeeeee" width="100"><%= EditDropDownListFromArray("judCd", strArrJudCd, strArrJudCd, strJudCd, NON_SELECTED_ADD) %></TD>
                        <TD NOWRAP><B>&nbsp;�ŏI����&nbsp;�F&nbsp;<%= strRslJudCd %></B></TD>
                    </TR>
                </TABLE>
            </TD>
            
            <% '2010.01.12 �����Ǘ� �ǉ� by ��
                If Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" Then %>
            <TD width="300" align="right">
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                    <TR align="right">
                        <TD NOWRAP ALIGN="right">&nbsp;
                        <% If strReqConfirmDate = "" Then %>
                            <A HREF="javascript:function voi(){};voi()" ONCLICK="return saveData()"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="�񎟌������ʏ��ۑ�"></A>
                            <A HREF="javascript:function voi(){};voi()" ONCLICK="return deleteData()"><IMG SRC="/webHains/images/delete.gif" WIDTH="77" HEIGHT="24" ALT="�t�H���[�A�b�v���폜"></A>
                        <% Else  %>
                            <IMG SRC="/webHains/images/confirm_complete.gif" border="0">
                        <% End If %>
                        </TD>
                    </TR>
                </TABLE>
            </TD>
            <% End If %>
        </TR>
    </TABLE>

    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="100%">
        <TR>
            <TD NOWRAP WIDTH="120" HEIGHT="25" BGCOLOR="#cccccc" ALIGN="left">&nbsp;�񎟌����{��</TD>
            <TD NOWRAP>
                <INPUT TYPE="radio" NAME="secEquipDiv" VALUE="0" BORDER="0" <%= IIf(strSecEquipDiv = "0", " CHECKED", "") %>><%= IIf(strSecEquipDiv = "0", "<B>�񎟌����ꏊ����</B>", "�񎟌����ꏊ����") %>&nbsp;&nbsp;
                <INPUT TYPE="radio" NAME="secEquipDiv" VALUE="1" BORDER="0" <%= IIf(strSecEquipDiv = "1", " CHECKED", "") %>><%= IIf(strSecEquipDiv = "1", "<B>���Z���^�[</B>", "���Z���^�[") %>&nbsp;&nbsp;
                <%'### 2016.09.13 �� �{�@���{�@�E���f�B���[�J�X�ɕύX ###%>
                <INPUT TYPE="radio" NAME="secEquipDiv" VALUE="2" BORDER="0" <%= IIf(strSecEquipDiv = "2", " CHECKED", "") %>><%= IIf(strSecEquipDiv = "2", "<B>�{�@�E���f�B���[�J�X</B>", "�{�@�E���f�B���[�J�X") %>&nbsp;&nbsp;
                <INPUT TYPE="radio" NAME="secEquipDiv" VALUE="3" BORDER="0" <%= IIf(strSecEquipDiv = "3", " CHECKED", "") %>><%= IIf(strSecEquipDiv = "3", "<B>���@</B>", "���@") %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <INPUT TYPE="radio" NAME="secEquipDiv" VALUE="9" BORDER="0" <%= IIf(strSecEquipDiv = "9", " CHECKED", "") %>><%= IIf(strSecEquipDiv = "9", "<B>�ΏۊO</B>", "�ΏۊO") %>
            </TD>
        </TR>
        <TR>
            <TD NOWRAP WIDTH="120" BGCOLOR="#cccccc" ALIGN="left">&nbsp;�񎟌����\���</TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                    <TR>
                        <TD NOWRAP ID="gdeDate"><A HREF="javascript:calGuide_showGuideCalendar('secPlanYear', 'secPlanMonth', 'secPlanDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\�����܂�"></A></TD>
                        <TD NOWRAP><A HREF="javascript:calGuide_clearDate('secPlanYear', 'secPlanMonth', 'secPlanDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
                        <TD>
                            <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="100%">
                                <TR>
                                    <TD><%= EditNumberList("secPlanYear", YEARRANGE_MIN, YEARRANGE_MAX, strSecPlanYear, True) %></TD>
                                    <TD>�N</TD>
                                    <TD><%= EditNumberList("secPlanMonth", 1, 12, strSecPlanMonth, True) %></TD>
                                    <TD>��</TD>
                                    <TD><%= EditNumberList("secPlanDay", 1, 31, strSecPlanDay, True) %></TD>
                                    <TD>��</TD>
                                </TR>
                            </TABLE>
                        </TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>

        <TR>
            <TD NOWRAP BGCOLOR="#cccccc">&nbsp;�񎟌����\�񍀖�</TD>
            <TD NOWRAP>
                <INPUT TYPE="checkbox" NAME="rsvTestUS"     VALUE="1" <%= IIf( strRsvTestUS = "1", "CHECKED", "") %>>US&nbsp;&nbsp;
                <INPUT TYPE="checkbox" NAME="rsvTestCT"     VALUE="1" <%= IIf( strRsvTestCT = "1", "CHECKED", "") %>>CT&nbsp;&nbsp;
                <INPUT TYPE="checkbox" NAME="rsvTestMRI"    VALUE="1" <%= IIf( strRsvTestMRI = "1", "CHECKED", "") %>>MRI&nbsp;&nbsp;
                <INPUT TYPE="checkbox" NAME="rsvTestBF"     VALUE="1" <%= IIf( strRsvTestBF = "1", "CHECKED", "") %>>BF&nbsp;&nbsp;
                <INPUT TYPE="checkbox" NAME="rsvTestGF"     VALUE="1" <%= IIf( strRsvTestGF = "1", "CHECKED", "") %>>GF&nbsp;&nbsp;
                <INPUT TYPE="checkbox" NAME="rsvTestCF"     VALUE="1" <%= IIf( strRsvTestCF = "1", "CHECKED", "") %>>CF&nbsp;&nbsp;
                <INPUT TYPE="checkbox" NAME="rsvTestEM"     VALUE="1" <%= IIf( strRsvTestEM = "1", "CHECKED", "") %>>����&nbsp;&nbsp;
                <INPUT TYPE="checkbox" NAME="rsvTestTM"     VALUE="1" <%= IIf( strRsvTestTM = "1", "CHECKED", "") %>>��ᇃ}�[�J�[&nbsp;&nbsp;

                <INPUT TYPE="checkbox" NAME="rsvTestRefer"  VALUE="1" <%= IIf( strRsvTestRefer = "1", "CHECKED", "") %>     ONCLICK="chkWrite(this,rsvTestReferText);">���t�@�[&nbsp;
                <INPUT TYPE="text" NAME="rsvTestReferText" SIZE="10" MAXLENGTH="40" VALUE="<%= strRsvTestReferText %>" STYLE="ime-mode:active;">

                <INPUT TYPE="checkbox" NAME="rsvTestETC"    VALUE="1" <%= IIf( strRsvTestETC = "1", "CHECKED", "") %> ONCLICK="chkWrite(this, rsvTestRemark);">���̑�&nbsp;
                <INPUT TYPE="text" NAME="rsvTestRemark" SIZE="30" MAXLENGTH="45" VALUE="<%= strRsvTestRemark %>" STYLE="ime-mode:active;">
            </TD>
        </TR>




    </TABLE>
    <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="500">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
        </TR>
    </TABLE>

    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%">
        <TR>
            <TD>
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
                    <TR>
                        <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">��������</FONT></B></TD>
                    </TR>
                </TABLE>
            </TD>
            <% '2010.01.12 �����Ǘ� �ǉ� by ��
                If Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" Then %>
            <TD WIDTH="150">
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" WIDTH="100%">
                    <TR>
                        <TD NOWRAP HEIGHT="15">
                        <% If strReqConfirmDate = "" Then %>
                            <IMG SRC="../../images/spacer.gif" WIDTH="10">
                            <A HREF="javascript:function voi(){};voi()" ONCLICK="return showFollowRsl('<%= lngRsvNo %>', '<%= lngJudClassCd %>', '0')">
                            <IMG SRC="/webHains/images/b_append.gif" WIDTH="77" HEIGHT="24" ALT="�������ʒǉ��o�^">
                            </A>
                        <% End If  %>
                        </TD>
                    </TR>
                </TABLE>
            </TD>
            <% End If %>
        </TR>
    <TABLE>
    <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="500">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
        </TR>
    </TABLE>
<%
    '#### �񎟌������ʏ��ҏW
    If lngAllCount > 0 Then

        For i = 0 To UBound(vntRsvNo)

            lngPolCount1 = 0
            lngPolCount2 = 0
            lngTestCount = 0

            If vntSecCslDate(i) <> "" Then
                strSecCslYear   = Year(vntSecCslDate(i))
                strSecCslMonth  = Month(vntSecCslDate(i))
                strSecCslDay    = Day(vntSecCslDate(i))
            End If
%>

    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" BGCOLOR="#999999" WIDTH="95%">
        <TR>
            <TD BGCOLOR="#ffffff" WIDTH="100%">
                <TABLE>
                    <TR>
                        <TD WIDTH="120" HEIGHT="22" NOWRAP BGCOLOR="#cccccc">&nbsp;�����i���Áj���{��</TD>
                        <TD>
                            <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                                <TR>
                                    <TD NOWRAP WIDTH="150"><FONT COLOR="#ff6600"><B><%= vntSecCslDate(i) %></B></FONT></TD>
                                    <% '2010.01.12 �����Ǘ� �ǉ� by ��
                                        If Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" Then %>
                                    <TD NOWRAP>
                                    <% If strReqConfirmDate = "" Then %>
                                        <A HREF="javascript:function voi(){};voi()" ONCLICK="return showFollowRsl('<%= vntRsvNo(i) %>', '<%= vntJudClassCd(i) %>', '<%= vntSeq(i) %>')">
                                        <IMG SRC="/webHains/images/change.gif" WIDTH="77" HEIGHT="24" ALT="�񎟌������ʕύX">
                                        </A>
                                    <% End If %>
                                    </TD>
                                    <% End If %>
                                </TR>
                            </TABLE>
                        </TD>
                    </TR>
                    <TR>
                        <TD NOWRAP BGCOLOR="#cccccc">&nbsp;�񎟌�������</TD>
                        <TD>
                            <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                                <TR>
                                    <TD NOWRAP>
                                    <%
                                        strWebTestItem = ""
                                        If vntTestUS(i) = "1"  Then
                                            strWebTestItem = strWebTestItem & "US&nbsp;&nbsp;" 
                                            lngTestCount = lngTestCount + 1
                                        End If

                                        If vntTestCT(i) = "1"  Then
                                            If lngTestCount > 0 Then
                                                strWebTestItem = strWebTestItem & "/&nbsp;&nbsp;CT&nbsp;&nbsp;"
                                            Else
                                                strWebTestItem = strWebTestItem & "CT&nbsp;&nbsp;"
                                            End If
                                            lngTestCount = lngTestCount + 1
                                        End If

                                        If vntTestMRI(i) = "1" Then
                                            If lngTestCount > 0 Then
                                                strWebTestItem = strWebTestItem & "/&nbsp;&nbsp;MRI&nbsp;&nbsp;"
                                            Else
                                                strWebTestItem = strWebTestItem & "MRI&nbsp;&nbsp;"
                                            End If
                                            lngTestCount = lngTestCount + 1
                                        End If

                                        If vntTestBF(i) = "1"  Then
                                            If lngTestCount > 0 Then
                                                strWebTestItem = strWebTestItem & "/&nbsp;&nbsp;BF&nbsp;&nbsp;"
                                            Else
                                                strWebTestItem = strWebTestItem & "BF&nbsp;&nbsp;"
                                            End If
                                            lngTestCount = lngTestCount + 1
                                        End If

                                        If vntTestGF(i) = "1"  Then
                                            If lngTestCount > 0 Then
                                                strWebTestItem = strWebTestItem & "/&nbsp;&nbsp;GF&nbsp;&nbsp;"
                                            Else
                                                strWebTestItem = strWebTestItem & "GF&nbsp;&nbsp;"
                                            End If
                                            lngTestCount = lngTestCount + 1
                                        End If

                                        If vntTestCF(i) = "1"  Then
                                            If lngTestCount > 0 Then
                                                strWebTestItem = strWebTestItem & "/&nbsp;&nbsp;CF&nbsp;&nbsp;"
                                            Else
                                                strWebTestItem = strWebTestItem & "CF&nbsp;&nbsp;"
                                            End If
                                            lngTestCount = lngTestCount + 1
                                        End If

                                        If vntTestEM(i) = "1"  Then
                                            If lngTestCount > 0 Then
                                                strWebTestItem = strWebTestItem & "/&nbsp;&nbsp;����&nbsp;&nbsp;"
                                            Else
                                                strWebTestItem = strWebTestItem & "����&nbsp;&nbsp;"
                                            End If
                                            lngTestCount = lngTestCount + 1
                                        End If

                                        If vntTestTM(i) = "1"  Then
                                            If lngTestCount > 0 Then
                                                strWebTestItem = strWebTestItem & "/&nbsp;&nbsp;��ᇃ}�[�J�[&nbsp;&nbsp;"
                                            Else
                                                strWebTestItem = strWebTestItem & "��ᇃ}�[�J�[&nbsp;&nbsp;"
                                            End If
                                            lngTestCount = lngTestCount + 1
                                        End If
                                        
                                        If vntTestRefer(i) = "1" Then 
                                            If lngTestCount > 0 Then
                                                strWebTestItem = strWebTestItem & "/&nbsp;&nbsp;���t�@�[&nbsp;"
                                            Else
                                                strWebTestItem = strWebTestItem & "���t�@�[&nbsp;"
                                            End If
                                            If vntTestReferText(i) <> "" Then
                                                strWebTestItem = strWebTestItem & "(&nbsp;" & vntTestReferText(i) & "&nbsp;)"
                                            End If
                                        End If

                                        If vntTestETC(i) = "1" Then 
                                            If lngTestCount > 0 Then
                                                strWebTestItem = strWebTestItem & "/&nbsp;&nbsp;���̑�&nbsp;"
                                            Else
                                                strWebTestItem = strWebTestItem & "���̑�&nbsp;"
                                            End If
                                            If vntTestRemark(i) <> "" Then
                                                strWebTestItem = strWebTestItem & "(&nbsp;" & vntTestRemark(i) & "&nbsp;)"
                                            End If
                                        End If


                                    %><%= strWebTestItem %>
                                    </TD>
                                </TR>
                            </TABLE>
                        </TD>
                    </TR>
                    <TR>
                        <TD WIDTH="120" HEIGHT="22" NOWRAP BGCOLOR="#cccccc">&nbsp;�񎟌�������</TD>
                        <TD>
                            <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                                <TR>
                                    <TD NOWRAP>
                                    <%
                                        strWebResultDivName = ""
                                        Select Case vntResultDiv(i)
                                           Case "1"
                                                strWebResultDivName = "�ُ�Ȃ�"
                                           Case "2"
                                                strWebResultDivName = "�s��"
                                           Case "3"
                                                strWebResultDivName = "�f�f������"
                                        End Select
                                    %><%= strWebResultDivName %>
                                    </TD>
                                </TR>
                            </TABLE>
                        </TD>
                    </TR>
                    <TR>
                        <TD WIDTH="120" HEIGHT="22" NOWRAP BGCOLOR="#cccccc">&nbsp;�f�f��</TD>
                        <TD WIDTH="100%">
                            <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" BGCOLOR="#999999">
                                <TR ALIGN="center" BGCOLOR="#cccccc">
                                    <TD NOWRAP WIDTH="130">����</TD>
                                    <TD NOWRAP WIDTH="160">����i���ʁj</TD>
                                    <TD NOWRAP WIDTH="100%">�f�f��</TD>
                                </TR>
                <%
                    '�񎟌������ʏ��ʎ����i�f�f���j���擾�i�o�^����Ă��鎾�����̂ݎ擾�j
                    lngStcCount = objFollow.SelectFollowRslItemList(vntRsvNo(i) ,   vntJudClassCd(i),   vntSeq(i), _
                                                                    vntGrpName,     vntItemCd,          vntSuffix, _
                                                                    vntItemName,    vntResult,          vntShortStc, True _
                                                                   )
                    strBeforeGrpName = ""
                    If lngStcCount > 0 Then
                        For j = 0 To UBound(vntGrpName)
                            strWebGrpName = ""
                            If strBeforeGrpName <> vntGrpName(j) Then
                                strWebGrpName = vntGrpName(j)
                            End If
                %>
                                <TR ALIGN="left" BGCOLOR="#ffffff">
                                    <TD NOWRAP WIDTH="130"><%= strWebGrpName %></TD>
                                    <TD NOWRAP WIDTH="160"><%= vntItemName(j) %></TD>
                                    <TD NOWRAP WIDTH="100%"><%= vntShortStc(j) %></TD>
                                </TR>
                <%
                            strBeforeGrpName = vntGrpName(j)
                        Next
                    Else
                %>
                                <TR ALIGN="center" BGCOLOR="#ffffff">
                                    <TD NOWRAP COLSPAN="3"HEIGHT="40">�o�^����Ă���f�f��������܂���B</TD>
                                </TR>
                <%
                    End If
                %>
                            </TABLE>
                        </TD>
                    </TR>
                    <TR>
                        <TD WIDTH="120" HEIGHT="22" NOWRAP BGCOLOR="#cccccc">&nbsp;���̑�����</TD>
                        <TD>
                            <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                                <TR>
                                    <TD><pre><%= vntDisRemark(i) %></pre></TD>
                                </TR>
                            </TABLE>
                        </TD>
                    </TR>
                    <TR>
                        <TD NOWRAP BGCOLOR="#cccccc">���j�i���ÂȂ��j</TD>
                        <TD>
                            <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                                <TR>
                                    <TD NOWRAP>
                                    <%
                                        strWebPolicy1 = ""
                                        If vntPolWithout(i) = "1" Then
                                            strWebPolicy1 = strWebPolicy1 & "���u�s�v&nbsp;&nbsp;"
                                            lngPolCount1 = lngPolCount1 + 1
                                        End If

                                        If vntPolFollowup(i) = "1" Then
                                            If lngPolCount1 > 0 Then
                                                strWebPolicy1 = strWebPolicy1 & "/&nbsp;&nbsp;�o�ߊώ@&nbsp;"
                                            Else
                                                strWebPolicy1 = strWebPolicy1 & "�o�ߊώ@&nbsp;"
                                            End If
                                            If vntPolMonth(i) <> "" Then
                                                strWebPolicy1 = strWebPolicy1 & "(&nbsp;" & vntPolMonth(i) & "&nbsp;����&nbsp;)&nbsp;&nbsp;"
                                            Else
                                                strWebPolicy1 = strWebPolicy1 & "&nbsp;"
                                            End If
                                            lngPolCount1 = lngPolCount1 + 1
                                        End If

                                        If vntPolReExam(i) = "1" Then
                                            If lngPolCount1 > 0 Then
                                                strWebPolicy1 = strWebPolicy1 & "/&nbsp;&nbsp;1�N�㌒�f&nbsp;&nbsp;"
                                            Else
                                                strWebPolicy1 = strWebPolicy1 & "1�N�㌒�f&nbsp;&nbsp;"
                                            End If
                                            lngPolCount1 = lngPolCount1 + 1
                                        End If

                                        If vntPolDiagSt(i) = "1" Then
                                            If lngPolCount1 > 0 Then
                                                '### 2016.09.13 �� �{�@���{�@�E���f�B���[�J�X�ɕύX ###
                                                'strWebPolicy1 = strWebPolicy1 & "/&nbsp;&nbsp;�{�@�Љ�i�����j&nbsp;&nbsp;"
                                                strWebPolicy1 = strWebPolicy1 & "/&nbsp;&nbsp;�{�@�E���f�B���[�J�X�Љ�i�����j&nbsp;&nbsp;"
                                            Else
                                                '### 2016.09.13 �� �{�@���{�@�E���f�B���[�J�X�ɕύX ###
                                                'strWebPolicy1 = strWebPolicy1 & "�{�@�Љ�i�����j&nbsp;&nbsp;"
                                                strWebPolicy1 = strWebPolicy1 & "�{�@�E���f�B���[�J�X�Љ�i�����j&nbsp;&nbsp;"
                                            End If
                                            lngPolCount1 = lngPolCount1 + 1
                                        End If

                                        If vntPolDiag(i) = "1" Then
                                            If lngPolCount1 > 0 Then
                                                strWebPolicy1 = strWebPolicy1 & "/&nbsp;&nbsp;���@�Љ�i�����j&nbsp;&nbsp;"
                                            Else
                                                strWebPolicy1 = strWebPolicy1 & "���@�Љ�i�����j&nbsp;&nbsp;"
                                            End If
                                            lngPolCount1 = lngPolCount1 + 1
                                        End If

                                        If vntPolEtc1(i) = "1" Then
                                            If lngPolCount1 > 0 Then
                                                strWebPolicy1 = strWebPolicy1 & "/&nbsp;&nbsp;���̑�&nbsp;"
                                            Else
                                                strWebPolicy1 = strWebPolicy1 & "���̑�&nbsp;"
                                            End If
                                            If vntPolRemark1(i) <> "" Then
                                                strWebPolicy1 = strWebPolicy1 & "(&nbsp;" & vntPolRemark1(i) & "&nbsp;)&nbsp;"
                                            End If
                                        End If
                                    %><%= strWebPolicy1 %>
                                    </TD>
                                </TR>
                            </TABLE>
                        </TD>
                    </TR>
                    <TR>
                        <TD NOWRAP BGCOLOR="#cccccc">���j�i���Â���j</TD>
                        <TD>
                            <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                                <TR>
                                    <TD NOWRAP>
                                    <%
                                        strWebPolicy2 = ""
                                        If vntPolSugery(i) = "1" Then
                                            strWebPolicy2 = strWebPolicy2 & "�O�Ȏ���&nbsp;&nbsp;&nbsp;&nbsp;"
                                            lngPolCount2 = lngPolCount2 + 1
                                        End If

                                        If vntPolEndoscope(i)   = "1" Then
                                            If lngPolCount2 > 0 Then
                                                strWebPolicy2 = strWebPolicy2 & "/&nbsp;&nbsp;�������I����&nbsp;&nbsp;"
                                            Else
                                                strWebPolicy2 = strWebPolicy2 & "�������I����&nbsp;&nbsp;"
                                            End If
                                            lngPolCount2 = lngPolCount2 + 1
                                        End If

                                        If vntPolChemical(i) = "1" Then
                                            If lngPolCount2 > 0 Then
                                                strWebPolicy2 = strWebPolicy2 & "/&nbsp;&nbsp;���w�Ö@&nbsp;&nbsp;"
                                            Else
                                                strWebPolicy2 = strWebPolicy2 & "���w�Ö@&nbsp;&nbsp;"
                                            End If
                                            lngPolCount2 = lngPolCount2 + 1
                                        End If

                                        If vntPolRadiation(i) = "1" Then
                                            If lngPolCount2 > 0 Then
                                                strWebPolicy2 = strWebPolicy2 & "/&nbsp;&nbsp;���ː�����&nbsp;&nbsp;"
                                            Else
                                                strWebPolicy2 = strWebPolicy2 & "���ː�����&nbsp;&nbsp;"
                                            End If
                                            lngPolCount2 = lngPolCount2 + 1
                                        End If

                                        If vntPolReferSt(i) = "1" Then
                                            If lngPolCount2 > 0 Then
                                                '### 2016.09.13 �� �{�@���{�@�E���f�B���[�J�X�ɕύX ###
                                                'strWebPolicy2 = strWebPolicy2 & "/&nbsp;&nbsp;�{�@�Љ�&nbsp;&nbsp;"
                                                strWebPolicy2 = strWebPolicy2 & "/&nbsp;&nbsp;�{�@�E���f�B���[�J�X�Љ�&nbsp;&nbsp;"
                                            Else
                                                '### 2016.09.13 �� �{�@���{�@�E���f�B���[�J�X�ɕύX ###
                                                'strWebPolicy2 = strWebPolicy2 & "�{�@�Љ�&nbsp;&nbsp;"
                                                strWebPolicy2 = strWebPolicy2 & "�{�@�E���f�B���[�J�X�Љ�&nbsp;&nbsp;"
                                            End If
                                            lngPolCount2 = lngPolCount2 + 1
                                        End If

                                        If vntPolRefer(i) = "1" Then
                                            If lngPolCount2 > 0 Then
                                                strWebPolicy2 = strWebPolicy2 & "/&nbsp;&nbsp;���@�Љ�&nbsp;&nbsp;"
                                            Else
                                                strWebPolicy2 = strWebPolicy2 & "���@�Љ�&nbsp;&nbsp;"
                                            End If
                                            lngPolCount2 = lngPolCount2 + 1
                                        End If

                                        If vntPolEtc2(i) = "1" Then
                                            If lngPolCount2 > 0 Then
                                                strWebPolicy2 = strWebPolicy2 & "/&nbsp;&nbsp;���̑�&nbsp;"
                                            Else
                                                strWebPolicy2 = strWebPolicy2 & "���̑�&nbsp;"
                                            End If
                                            If vntPolRemark2(i) <> "" Then
                                                strWebPolicy2 = strWebPolicy2 & "(&nbsp;" & vntPolRemark2(i) & "&nbsp;)&nbsp;"
                                            End If

                                        End If
                                    %><%= strWebPolicy2 %>
                                    </TD>
                                </TR>
                            </TABLE>
                        </TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>

<%
        Next
    Else
%>

    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" BGCOLOR="#999999" WIDTH="100%" HEIGHT="200">
        <TR>
            <TD BGCOLOR="#ffffff" WIDTH="100%" ALIGN="center">�񎟌������ʃf�[�^�����o�^��Ԃł��B<BR>�y�ǉ��z�{�^�����N���b�N���ē񎟌������ʓo�^���ł��܂��B
            </TD>
        </TR>
    </TABLE>

<%
    End If
%>

    <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="500">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD BGCOLOR="#ffffff" WIDTH="100%">
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                    <TR>
                        <TD NOWRAP BGCOLOR="#cccccc">&nbsp;�X�e�[�^�X</TD>
                        <TD>
                            <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                                <!--TR>
                                    <TD NOWRAP>
                                        <INPUT TYPE="radio" NAME="statusCd" VALUE="1" BORDER="0" <%= IIf(strStatusCd = "1", " CHECKED", "") %>>�ُ�Ȃ�&nbsp;&nbsp;&nbsp;&nbsp;
                                        <INPUT TYPE="radio" NAME="statusCd" VALUE="2" BORDER="0" <%= IIf(strStatusCd = "2", " CHECKED", "") %>>�ُ킠��i�t�H���[�Ȃ��j&nbsp;&nbsp;&nbsp;&nbsp;
                                        <INPUT TYPE="radio" NAME="statusCd" VALUE="3" BORDER="0" <%= IIf(strStatusCd = "3", " CHECKED", "") %>>�ُ킠��i�p���t�H���[�j&nbsp;&nbsp;&nbsp;&nbsp;
                                        <INPUT TYPE="radio" NAME="statusCd" VALUE="4" BORDER="0" <%= IIf(strStatusCd = "4", " CHECKED", "") %>>���̑��I���i�A���Ƃꂸ�j
                                    </TD>
                                </TR-->
                                <TR>
                                    <TD WIDTH="150" NOWRAP ALIGN="RIGHT" BGCOLOR="#eeeeee">�f�f�m��&nbsp;�F&nbsp;</TD>
                                    <TD NOWRAP>
                                        <INPUT TYPE="radio" NAME="statusCd" VALUE="11" BORDER="0" <%= IIf(strStatusCd = "11", " CHECKED", "") %>>�ُ�Ȃ�&nbsp;&nbsp;&nbsp;&nbsp;
                                        <INPUT TYPE="radio" NAME="statusCd" VALUE="12" BORDER="0" <%= IIf(strStatusCd = "12", " CHECKED", "") %>>�ُ킠��
                                    </TD>
                                </TR>
                                <TR>
                                    <TD WIDTH="150" NOWRAP ALIGN="RIGHT" BGCOLOR="#eeeeee">�f�f���m��(��f�{��)&nbsp;�F&nbsp;</TD>
                                    <TD NOWRAP>
                                        <INPUT TYPE="radio" NAME="statusCd" VALUE="21" BORDER="0" <%= IIf(strStatusCd = "21", " CHECKED", "") %>>�Z���^�[&nbsp;&nbsp;&nbsp;&nbsp;
                                        <%'### 2016.09.13 �� �{�@���{�@�E���f�B���[�J�X�ɕύX ###%>
                                        <INPUT TYPE="radio" NAME="statusCd" VALUE="22" BORDER="0" <%= IIf(strStatusCd = "22", " CHECKED", "") %>>�{�@�E���f�B���[�J�X&nbsp;&nbsp;&nbsp;&nbsp;
                                        <INPUT TYPE="radio" NAME="statusCd" VALUE="23" BORDER="0" <%= IIf(strStatusCd = "23", " CHECKED", "") %>>���@&nbsp;&nbsp;&nbsp;&nbsp;
                                        <INPUT TYPE="radio" NAME="statusCd" VALUE="29" BORDER="0" <%= IIf(strStatusCd = "29", " CHECKED", "") %>>���̑�(����E�s��)
                                    </TD>
                                </TR>
                                <TR>
                                    <TD WIDTH="150" NOWRAP>&nbsp;</TD>
                                    <TD NOWRAP>
                                        <INPUT TYPE="radio" NAME="statusCd" VALUE="99" BORDER="0" <%= IIf(strStatusCd = "99", " CHECKED", "") %>>���̑�(�t�H���[�A�b�v�o�^�I��)
                                    </TD>
                                </TR>
                            </TABLE>
                        </TD>
                    </TR>
                    <TR>
                        <TD NOWRAP WIDTH="120" BGCOLOR="#cccccc">&nbsp;���l</TD>
                        <TD COLSPAN="7"><TEXTAREA NAME="secRemark" style="ime-mode:active"  COLS="70" ROWS="4"><%= strSecRemark %></TEXTAREA></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
    <BR>

    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">��Ë@��</FONT></B></TD>
        </TR>
    </TABLE>
    <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="500">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD BGCOLOR="#ffffff" WIDTH="100%">
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                    <TR>
                        <TD NOWRAP BGCOLOR="#cccccc">&nbsp;�a��@��</TD>
                        <TD><INPUT TYPE="text" NAME="secEquipName" SIZE="70" MAXLENGTH="50" VALUE="<%= strSecEquipName %>" STYLE="ime-mode:active;"></TD>
                    </TR>
                    <TR>
                        <TD NOWRAP BGCOLOR="#cccccc">&nbsp;�f�É�</TD>
                        <TD><INPUT TYPE="text" NAME="secEquipCourse" SIZE="70" MAXLENGTH="50" VALUE="<%= strSecEquipCourse %>" STYLE="ime-mode:active;"></TD>
                    </TR>
                    <TR>
                        <TD NOWRAP WIDTH="120" BGCOLOR="#cccccc">&nbsp;�S����t</TD>
                        <TD><INPUT TYPE="text" NAME="secDoctor" SIZE="50" MAXLENGTH="40" VALUE="<%= strSecDoctor %>" STYLE="ime-mode:active;"></TD>
                    </TR>
                    <TR>
                        <TD NOWRAP WIDTH="120" BGCOLOR="#cccccc">&nbsp;�Z��</TD>
                        <TD><INPUT TYPE="text" NAME="secEquipAddr" SIZE="100" MAXLENGTH="120" VALUE="<%= strSecEquipAddr %>" STYLE="ime-mode:active;"></TD>
                    </TR>
                    <TR>
                        <TD NOWRAP WIDTH="120" BGCOLOR="#cccccc">&nbsp;�d�b�ԍ�</TD>
                        <TD><INPUT TYPE="text" NAME="secEquipTel" SIZE="50" MAXLENGTH="15" VALUE="<%= strSecEquipTel %>" STYLE="ime-mode:inactive;"></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD BGCOLOR="#ffffff" WIDTH="100%">
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                    <TR>
                        <TD HEIGHT="22" WIDTH="120" NOWRAP BGCOLOR="#cccccc">&nbsp;�ŏ��o�^����</TD>
                        <TD HEIGHT="22" WIDTH="140" NOWRAP ><%= strAddDate %></TD>
                        <TD HEIGHT="22" WIDTH="120" NOWRAP BGCOLOR="#cccccc">&nbsp;�ŏI�X�V����</TD>
                        <TD HEIGHT="22" WIDTH="140" NOWRAP ><%= strUpdDate %></TD>
                        <TD HEIGHT="22" WIDTH="120" NOWRAP BGCOLOR="#cccccc">&nbsp;���ʏ��F����</TD>
                        <TD HEIGHT="22" WIDTH="140" NOWRAP ><%= strReqConfirmDate %></TD>
                        <% '2010.01.12 �����Ǘ� �ǉ� by ��
                            if Session("PAGEGRANT") = "4" then %>
                            <TD ROWSPAN="2" VALIGN="TOP">
                            <% If strReqConfirmDate <> "" Then %>
                                <A HREF="javascript:function voi(){};voi()" ONCLICK="return followRslConfirm('0','<%= strStatusCd %>')">
                                <IMG SRC="/webHains/images/follow_confirm_up.gif" WIDTH="77" HEIGHT="24" ALT="���ʏ��F���">
                                </A>
                            <% Else %>
                                <A HREF="javascript:function voi(){};voi()" ONCLICK="return followRslConfirm('1','<%= strStatusCd %>')">
                                <IMG SRC="/webHains/images/follow_confirm.gif" WIDTH="77" HEIGHT="24" ALT="���ʏ��F">
                                </A>
                            <% End If %>
                                <INPUT TYPE="hidden"    NAME="reqConfirmFlg"   VALUE="">
                            </TD>
                        <% End If %>  
                    </TR>

                    <TR>
                        <TD HEIGHT="22" NOWRAP BGCOLOR="#cccccc">&nbsp;�ŏ��o�^��</TD>
                        <TD><%= strAddUserName %></TD>
                        <TD HEIGHT="22" NOWRAP BGCOLOR="#cccccc">&nbsp;�ŏI�X�V��</TD>
                        <TD><%= strUpdUserName %></TD>
                        <TD HEIGHT="22" NOWRAP BGCOLOR="#cccccc">&nbsp;���ʏ��F��</TD>
                        <TD><%= strReqConfirmUserName %></TD>
                        <TD>&nbsp;</TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>

</FORM>
</BODY>
</HTML>
