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
Dim objFollow           '�t�H���[�A�b�v�A�N�Z�X�p
Dim objJud              '������A�N�Z�X�p

Dim strMode             '�������[�h(�}��:"insert"�A�X�V:"update")
Dim strAction           '�������(�ۑ��{�^��������:"save"�A�ۑ�������:"saveend")
Dim strTarget           '�^�[�Q�b�g���URL

'���ʏ��ύX�y�ѐV�K�o�^��ŐV���\���p
Dim lngNewSeq               '��A�ԍ�

'�p�����[�^
Dim lngRsvNo                '�\��ԍ�
Dim lngJudClassCd           '���蕪�ރR�[�h
Dim lngSeq                  '��A�ԍ�

Dim strJudClassName         '���蕪�ޖ�
Dim strJudCd                '����R�[�h�i�t�H���[�m�莞���茋�ʁj
Dim strRslJudCd             '����R�[�h�i�J�����g�i���݁j���茋�ʁj
Dim strSecEquipDiv          '�񎟌������{�i�{�݁j�敪
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
Dim strSecRemark            '���l

Dim strSecEquipDivName      '�񎟌������{�i�{�݁j�敪���̕\���p

Dim strSecCslDate           '�񎟎��{��
Dim strSecCslYear           '�񎟎��{���i�N�j
Dim strSecCslMonth          '�񎟎��{���i���j
Dim strSecCslDay            '�񎟎��{���i���j

Dim strTestUpdDate          '�X�V����
Dim strTestUpdUser          '�X�V��ID
Dim strTestUpdUserName      '�X�V�Ҏ���

Dim strTestUS               '�񎟌�������US
Dim strTestCT               '�񎟌�������CT
Dim strTestMRI              '�񎟌�������MRI
Dim strTestBF               '�񎟌�������BF
Dim strTestGF               '�񎟌�������GF
Dim strTestCF               '�񎟌�������CF
Dim strTestEM               '�񎟌������ڒ���
Dim strTestTM               '�񎟌������ڎ�ᇃ}�[�J�[
Dim strTestETC              '�񎟌������ڂ��̑�
Dim strTestRemark           '�񎟌������ڂ��̑��R�����g
'�񎟌������ڒǉ��@�F2009/12/21 yhlee ---------------
Dim strTestRefer              '�񎟌������ڂ�t�@�[
Dim strTestReferText          '�񎟌������ڂ�t�@�[��
Dim strRsvTestName            '�񎟌����\�񍀖ږ�
'�񎟌������ڒǉ� (End) --------------------------------

Dim strResultDiv            '�񎟌������ʋ敪
Dim strDisRemark            '�񎟌������ʂ��̑�����
Dim strPolWithout           '���u�s�v�i���Õ��j�j�F���ÂȂ�
Dim strPolFollowup          '�o�ߊώ@�F���ÂȂ�
Dim strPolMonth             '�o�ߊώ@���ԁi�����j�F���ÂȂ�
Dim strPolReExam            '1�N�㌒�f�F���ÂȂ�
Dim strPolDiagSt            '�{�@�Љ�i�����j�F���ÂȂ�
Dim strPolDiag              '���@�Љ�i�����j�F���ÂȂ�
Dim strPolEtc1              '���̑��F���ÂȂ�
Dim strPolRemark1           '���̑����́F���ÂȂ�
Dim strPolSugery            '�O�Ȏ��ÁF���Â���
Dim strPolEndoscope         '�������I���ÁF���Â���
Dim strPolChemical          '���w�Ö@�F���Â���
Dim strPolRadiation         '���ː����ÁF���Â���
Dim strPolReferSt           '�{�@�Љ�F���Â���
Dim strPolRefer             '���@�Љ�F���Â���
Dim strPolEtc2              '���̑��F���Â���
Dim strPolRemark2           '���̑����́F���Â���

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

'����R���{�{�b�N�X
Dim strArrJudCdSeq          '����A��
Dim strArrJudCd             '����R�[�h
Dim strArrWeight            '����p�d��
Dim lngJudListCnt           '���茏��
Dim lngAllCount             '������

Dim i                       '�C���f�b�N�X
Dim Ret                     '���A�l
Dim rslCnt                  '���ʓ��͗��C���f�b�N�X
Dim blnFollowRsl            '���A�l�i���ʎ擾�L���j

Dim strArrMessage           '�G���[���b�Z�[�W

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objFollow       = Server.CreateObject("HainsFollow.Follow")
Set objJud          = Server.CreateObject("HainsJud.Jud")

'�p�����[�^�l�̎擾
strMode        = Request("mode")
strAction      = Request("act")
strTarget      = Request("target")

lngRsvNo                = Request("rsvno")
lngJudClassCd           = Request("judClassCd")
lngSeq                  = Request("seq")

strSecCslDate           = Request("secCslDate")
strSecCslYear           = Request("secCslYear")
strSecCslMonth          = Request("secCslMonth")
strSecCslDay            = Request("secCslDay")
strTestUS               = Request("testUS")
strTestCT               = Request("testCT")
strTestMRI              = Request("testMRI")
strTestBF               = Request("testBF")
strTestGF               = Request("testGF")
strTestCF               = Request("testCF")
strTestEM               = Request("testEM")
strTestTM               = Request("testTM")
strTestETC              = Request("testETC")
strTestRemark           = Request("testRemark")

strTestRefer            = Request("testRefer")
strTestReferText        = Request("testReferText")

strResultDiv            = Request("resultDiv")
strDisRemark            = Request("disRemark")
strPolWithout           = Request("polWithout")
strPolFollowup          = Request("polFollowup")
strPolMonth             = Request("polMonth")
strPolReExam            = Request("polReExam")
strPolDiagSt            = Request("polDiagSt")
strPolDiag              = Request("polDiag")
strPolEtc1              = Request("polEtc1")
strPolRemark1           = Request("polRemark1")
strPolSugery            = Request("polSugery")
strPolEndoscope         = Request("polEndoscope")
strPolChemical          = Request("polChemical")
strPolRadiation         = Request("polRadiation")
strPolReferSt           = Request("polReferSt")
strPolRefer             = Request("polRefer")
strPolEtc2              = Request("polEtc2")
strPolRemark2           = Request("polRemark2")

vntGrpName              = ConvIStringToArray(Request("arrGrpName"))
vntItemName             = ConvIStringToArray(Request("arrItemName"))
vntItemCd               = ConvIStringToArray(Request("arrItemCd"))
vntSuffix               = ConvIStringToArray(Request("arrSuffix"))
vntResult               = ConvIStringToArray(Request("arrResult"))
vntShortStc             = ConvIStringToArray(Request("arrShortStc"))

strSecCslDate           = Request("secCslDate")
If strSecCslDate <> "" Then
    strSecCslYear   = Year(strSecCslDate)
    strSecCslMonth  = Month(strSecCslDate)
    strSecCslDay    = Day(strSecCslDate)
End If


'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do

    '�ۑ��{�^��������
    If strAction = "save" Then

        '���̓`�F�b�N
        strArrMessage = CheckValue()
        If Not IsEmpty(strArrMessage) Then
            Exit Do
        End If

'        response.write "lngSeq               --> " & lngSeq               & "<br>"
'        response.write "strSecCslDate        --> " & strSecCslDate        & "<br>"
'        response.write "strSecCslYear        --> " & strSecCslYear        & "<br>"
'        response.write "strSecCslMonth       --> " & strSecCslMonth       & "<br>"
'        response.write "strSecCslDay         --> " & strSecCslDay         & "<br>"
'        response.write "strTestUS            --> " & strTestUS            & "<br>"
'        response.write "strTestCT            --> " & strTestCT            & "<br>"
'        response.write "strTestMRI           --> " & strTestMRI           & "<br>"
'        response.write "strTestBF            --> " & strTestBF            & "<br>"
'        response.write "strTestGF            --> " & strTestGF            & "<br>"
'        response.write "strTestCF            --> " & strTestCF            & "<br>"
'        response.write "strTestEM            --> " & strTestEM            & "<br>"
'        response.write "strTestTM            --> " & strTestTM            & "<br>"
'        response.write "strTestETC           --> " & strTestETC           & "<br>"
'        response.write "strTestRemark        --> " & strTestRemark        & "<br>"
'        response.write "strResultDiv         --> " & strResultDiv         & "<br>"
'        response.write "strDisRemark         --> " & strDisRemark         & "<br>"
'        response.write "strPolWithout        --> " & strPolWithout        & "<br>"
'        response.write "strPolFollowup       --> " & strPolFollowup       & "<br>"
'        response.write "strPolMonth          --> " & strPolMonth          & "<br>"
'        response.write "strPolReExam         --> " & strPolReExam         & "<br>"
'        response.write "strPolDiag           --> " & strPolDiag           & "<br>"
'        response.write "strPolEtc1           --> " & strPolEtc1           & "<br>"
'        response.write "strPolRemark1        --> " & strPolRemark1        & "<br>"
'        response.write "strPolSugery         --> " & strPolSugery         & "<br>"
'        response.write "strPolEndoscope      --> " & strPolEndoscope      & "<br>"
'        response.write "strPolChemical       --> " & strPolChemical       & "<br>"
'        response.write "strPolRadiation      --> " & strPolRadiation      & "<br>"
'        response.write "strPolRefer          --> " & strPolRefer          & "<br>"
'        response.write "strPolEtc2           --> " & strPolEtc2           & "<br>"
'        response.write "strPolRemark2        --> " & strPolRemark2        & "<br>"
'        response.end

'2009.11.26 ��
'        Ret = objFollow.UpdateFollow_Rsl( lngRsvNo,         lngJudClassCd,      lngSeq, _
'                                          strSecCslDate,    Session.Contents("userId"), strTestUS, _
'                                          strTestCT,        strTestMRI,         strTestBF, _
'                                          strTestGF,        strTestCF,          strTestEM, _
'                                          strTestTM,        strTestETC,         strTestRemark, _
'                                          strResultDiv,     strDisRemark,       strPolWithout, _
'                                          strPolFollowup,   strPolMonth,        strPolReExam, _
'                                          strPolDiag,       strPolEtc1,         strPolRemark1, _
'                                          strPolSugery,     strPolEndoscope,    strPolChemical, _
'                                          strPolRadiation,  strPolRefer,        strPolEtc2, _
'                                          strPolRemark2,    vntItemCd,          vntSuffix, _
'                                          vntResult,        lngNewSeq )

        Ret = objFollow.UpdateFollow_Rsl( lngRsvNo,         lngJudClassCd,      lngSeq, _
                                          strSecCslDate,    Session.Contents("userId"), _
                                          strTestUS,        strTestCT,_
                                          strTestMRI,       strTestBF, _
                                          strTestGF,        strTestCF,          strTestEM, _
                                          strTestTM,        strTestETC,         strTestRemark, _
                                          strTestRefer,     strTestReferText, _
                                          strResultDiv,     strDisRemark,       strPolWithout, _
                                          strPolFollowup,   strPolMonth,        strPolReExam, _
                                          strPolDiagSt,     strPolDiag,         strPolEtc1,         strPolRemark1, _
                                          strPolSugery,     strPolEndoscope,    strPolChemical, _
                                          strPolRadiation,  strPolReferSt,      strPolRefer,        strPolEtc2, _
                                          strPolRemark2,    vntItemCd,          vntSuffix, _
                                          vntResult,        lngNewSeq )

        If Ret Then
            strAction = "saveend"
            lngSeq = lngNewSeq
        Else
            strArrMessage = Array("�t�H���[�A�b�v���ʏ��o�^�Ɏ��s���܂����B")
            Exit Do
        End If

    ElseIf strAction = "delete" Then

        Ret = objFollow.DeleteFollow_Rsl( lngRsvNo, lngJudClassCd, lngSeq, Session.Contents("userId"))

        If Ret Then
            strAction = "deleteend"
        Else
            strArrMessage = Array("�t�H���[�A�b�v���ʏ��폜�Ɏ��s���܂����B")
            Exit Do
        End If

    End If

'2009.11.26 ��
'    objFollow.SelectFollow_Info lngRsvNo,           lngJudClassCd, _
'                                strJudClassName,    strJudCd,               strRslJudCd, _
'                                strSecEquipDiv,     strUpdDate,             strUpdUser, _
'                                strUpdUserName,     strStatusCd,            strSecEquipName, _
'                                strSecDoctor,       strSecEquipAddr,        strSecEquipTel, _
'                                strSecPlanDate,     strReqSendDate,         strReqSendUser, _
'                                strReqSendUserName, strReqCheckDate1,       strReqCheckDate2, _
'                                strReqCheckDate3,   strReqCancelDate,       strReqConfirmDate, _
'                                strReqConfirmUser,  strReqConfirmUserName,  strSecRemark

    objFollow.SelectFollow_Info lngRsvNo,           lngJudClassCd, _
                                strJudClassName,    strJudCd,               strRslJudCd, _
                                strSecEquipDiv,     strUpdDate,             strUpdUser, _
                                strUpdUserName,     strStatusCd,            strSecEquipName,        strSecEquipCourse, _
                                strSecDoctor,       strSecEquipAddr,        strSecEquipTel, _
                                strSecPlanDate,     strReqSendDate,         strReqSendUser, _
                                strReqSendUserName, strReqCheckDate1,       strReqCheckDate2, _
                                strReqCheckDate3,   strReqCancelDate,       strReqConfirmDate, _
                                strReqConfirmUser,  strReqConfirmUserName,  strSecRemark, _
                                strRsvTestName

    Select Case strSecEquipDiv
       Case 0
            strSecEquipDivName = "�񎟌����ꏊ����"
       Case 1
            strSecEquipDivName = "���Z���^�["
       Case 2
            '### 2016.09.13 �� �{�@���{�@�E���f�B���[�J�X�ɕύX ###
            'strSecEquipDivName = "�{�@"
            strSecEquipDivName = "�{�@�E���f�B���[�J�X"
       Case 3
            strSecEquipDivName = "���@"
    End Select

    If strSecPlanDate <> "" Then
        strSecPlanYear   = Year(strSecPlanDate)
        strSecPlanMonth  = Month(strSecPlanDate)
        strSecPlanDay    = Day(strSecPlanDate)
    End If

'    If strAction = "saveend" Then
'        response.write "lngSeq               --> " & lngSeq               & "<br>"
'        response.end
'    End If

'2009.11.26 ��
'    blnFollowRsl = objFollow.SelectFollow_Rsl(lngRsvNo,            lngJudClassCd,      lngSeq, _
'                                              strSecCslDate,       strTestUpdDate,     strTestUpdUser, _
'                                              strTestUpdUserName,  strTestUS,          strTestCT, _
'                                              strTestMRI,          strTestBF,          strTestGF, _
'                                              strTestCF,           strTestEM,          strTestTM, _
'                                              strTestEtc,          strTestRemark,      strResultDiv, _
'                                              strDisRemark,        strPolWithout,      strPolFollowup, _
'                                              strPolMonth,         strPolReExam,       strPolDiag, _
'                                              strPolEtc1,          strPolRemark1,      strPolSugery, _
'                                              strPolEndoscope,     strPolChemical,     strPolRadiation, _
'                                              strPolRefer,         strPolEtc2,         strPolRemark2)

    blnFollowRsl = objFollow.SelectFollow_Rsl(lngRsvNo,            lngJudClassCd,      lngSeq, _
                                              strSecCslDate,       strTestUpdDate,     strTestUpdUser, _
                                              strTestUpdUserName,  strTestUS,          strTestCT, _
                                              strTestMRI,          strTestBF,          strTestGF, _
                                              strTestCF,           strTestEM,          strTestTM, _
                                              strTestEtc,          strTestRemark, _     
                                              strTestRefer,        strTestReferText, _  
                                              strResultDiv, _
                                              strDisRemark,        strPolWithout,      strPolFollowup, _
                                              strPolMonth,         strPolReExam,       strPolDiagSt,        strPolDiag, _
                                              strPolEtc1,          strPolRemark1,      strPolSugery, _
                                              strPolEndoscope,     strPolChemical,     strPolRadiation, _
                                              strPolReferSt,       strPolRefer,        strPolEtc2,          strPolRemark2)

    If strSecCslDate <> "" Then
        strSecCslYear   = Year(strSecCslDate)
        strSecCslMonth  = Month(strSecCslDate)
        strSecCslDay    = Day(strSecCslDate)
    End If
    '�ΏۑS���ʁi����j�ʐf�f���i�����j����Ɏ��������擾�j
    lngAllCount = objFollow.SelectFollowRslItemList(lngRsvNo,            lngJudClassCd,      lngSeq, _
                                                    vntGrpName,          vntItemCd,          vntSuffix, _
                                                    vntItemName,         vntResult,          vntShortStc)



    Exit Do
Loop


'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �t�H���[�A�b�v���ʊe�l�̑Ó����`�F�b�N���s��
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

        '�񎟌������{��
        .AppendArray vntArrMessage, .CheckDate("�񎟌������{��", strSecCslYear, strSecCslMonth, strSecCslDay, strSecCslDate)

        '�o�ߊώ@����
        .AppendArray vntArrMessage, .CheckNumeric("�o�ߊώ@����", strPolMonth, 2)

        '���̑��R�����g�i�������@�j
        strMessage = .CheckLength("���̑��R�����g�i�������@�j", strTestRemark, 200)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "�i���s�������܂݂܂��j"
        End If

        '���̑�����
        strMessage = .CheckLength("���̑�����", strDisRemark, 200)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "�i���s�������܂݂܂��j"
        End If

        '���̑��R�����g�i���ÂȂ��j
        strMessage = .CheckLength("���̑��R�����g�i���ÂȂ��j", strPolRemark1, 200)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "�i���s�������܂݂܂��j"
        End If

        '���̑��R�����g�i���Â���j
        strMessage = .CheckLength("���̑��R�����g�i���Â���j", strPolRemark2, 200)
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
<TITLE>�񎟌��f���ʓo�^</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<%
    '### �ۑ������A�폜������e��ʂ��ŐV���ŕ\�����A�����̉�ʂ����
    If strAction = "saveend" Or strAction = "deleteend" Then
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
<!-- #include virtual = "/webHains/includes/stcGuide.inc"    -->
<!--
    var lngSelectedIndex1;  // �K�C�h�\�����ɑI�����ꂽ�G�������g�̃C���f�b�N�X

    // ���̓K�C�h�Ăяo��
    function callStcGuide( index ) {

        var myForm = document.entryForm;

        // �I�����ꂽ�G�������g�̃C���f�b�N�X��ޔ�(���̓R�[�h�E�����͂̃Z�b�g�p�֐��ɂĎg�p����)
        lngSelectedIndex1 = index;

        if ( myForm.arrItemcd.length != null ) {
            stcGuide_ItemCd = myForm.arrItemcd[ index ].value;
        } else {
            stcGuide_ItemCd = myForm.arrItemcd.value;
        }

        // �K�C�h��ʂ̘A����ɍ��ڃ^�C�v�i�W���j��ݒ肷��
        stcGuide_ItemType = '0';

        // �K�C�h��ʂ̘A����ɃK�C�h��ʂ���Ăяo����鎩��ʂ̊֐���ݒ肷��
        stcGuide_CalledFunction = setStcInfo;

        // ���̓K�C�h�\��
        showGuideStc();
    }

    // ���̓R�[�h�E�����͂̃Z�b�g
    function setStcInfo() {
        setStc( lngSelectedIndex1, stcGuide_StcCd, stcGuide_ShortStc );
    }

    // ���ʎ����i���́j�̕ҏW
    function setStc( index, stcCd, shortStc ) {

        var myForm = document.entryForm;    // ����ʂ̃t�H�[���G�������g

        // �l�̕ҏW
        if ( myForm.arrItemcd.length != null ) {
            myForm.arrResult[ index ].value = stcCd;
            myForm.arrLongStc[ index ].value = shortStc;
        } else {
            myForm.arrResult.value = stcCd;
            myForm.arrLongStc.value = shortStc;
        }

        if ( document.getElementById('sentence' + index) ) {
            document.getElementById('sentence' + index).innerHTML = shortStc;
        }

    }


    // ���ʎ����i���́j�̃N���A
    function callStcClr( index ) {

        var myForm = document.entryForm;    // ����ʂ̃t�H�[���G�������g

        // �l�̕ҏW
        if ( myForm.arrItemcd.length != null ) {
            myForm.arrResult[ index ].value = '';
            myForm.arrLongStc[ index ].value = '';
        } else {
            myForm.arrResult.value = '';
            myForm.arrLongStc.value = '';
        }

        if ( document.getElementById('sentence' + index) ) {
            document.getElementById('sentence' + index).innerHTML = '';
        }

    }




    /** ���蕪�ޕʃt�H���[�A�b�v���ۑ� **/
    function saveData() {

        var myForm = document.entryForm;    // ����ʂ̃t�H�[���G�������g

        if ( !confirm( '�t�H���[�A�b�v����ύX���܂��B��낵���ł����H' ) ) {
            return;
        }

        with ( myForm ) {
            if (secCslYear.value == "" || secCslMonth.value == "" || secCslDay.value == ""){
                alert("�w�񎟌������{���x�͕K�{���ڂł��̂Ő��������͂��Ă��������B");
                return false;
            }
            act.value = 'save';
            submit();
        }

        //�e��ʂ������Ă��Ȃ������ꍇ�A�e��ʃ��t���b�V��
//        if (!opener.closed) {
//            opener.replaceForm();
//        }

//        close();

        return false;

    }

    /** ���蕪�ޕʃt�H���[�A�b�v���폜 **/
    function deleteData() {

        var myForm = document.entryForm;    // ����ʂ̃t�H�[���G�������g

        if ( !confirm( '�t�H���[�A�b�v�����폜���܂��B��낵���ł����H' ) ) {
            return;
        }

        // ���[�h���w�肵��submit
        with ( myForm ) {
            act.value = 'delete';
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

            if(testETC.checked) {
                testRemark.disabled = false;
            } else {
                testRemark.disabled = true;
            }

            if(polFollowup.checked) {
                polMonth.disabled = false;
            } else {
                polMonth.disabled = true;
            }

            if(polETC1.checked) {
                polRemark1.disabled = false;
            } else {
                polRemark1.disabled = true;
            }

            if(polETC2.checked) {
                polRemark2.disabled = false;
            } else {
                polRemark2.disabled = true;
            }

        }
    }

//-->
</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
</HEAD>
<BODY BGCOLOR="#ffffff"  ONLOAD="onLoad();">

<!-- #include virtual = "/webHains/includes/followupHeader.inc" -->
<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
    <TR>
        <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">�t�H���[�A�b�v���ʓo�^</FONT></B></TD>
    </TR>
</TABLE>
<TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="500">
    <TR>
        <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
    </TR>
</TABLE>
<%
    '��f�Ҍl���\��
    Call followupHeader(lngRsvNo)
%>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
    <INPUT TYPE="hidden"    NAME="mode"         VALUE="<%= strMode %>"      >
    <INPUT TYPE="hidden"    NAME="act"          VALUE=""                    >
    <INPUT TYPE="hidden"    NAME="target"       VALUE="<%= strTarget %>"    >
    <INPUT TYPE="hidden"    NAME="rsvno"        VALUE="<%= lngRsvNo %>"     >
    <INPUT TYPE="hidden"    NAME="judClassCd"   VALUE="<%= lngJudClassCd %>">
    <INPUT TYPE="hidden"    NAME="seq"          VALUE="<%= lngSeq %>"       >

<%
    '���b�Z�[�W�̕ҏW
    If strAction <> "" Then

        Select Case strAction

            '�ۑ��������́u�ۑ������v�̒ʒm
            Case "saveend"
                Call EditMessage("�ۑ����������܂����B", MESSAGETYPE_NORMAL)

            '�폜�������́u�폜�����v�̒ʒm
            Case "deleteend"
                Call EditMessage("�폜�������܂����B", MESSAGETYPE_NORMAL)

            '�����Ȃ��΃G���[���b�Z�[�W��ҏW
            Case Else
                Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)

        End Select

End If
%>
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
        <TR ALIGN="left">
            <TD width="*">
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2">
                    <TR align="left">
                        <TD NOWRAP BGCOLOR="#cccccc" width="120" HEIGHT="22">&nbsp;���f����</TD>
                        <TD NOWRAP BGCOLOR="#eeeeee" width="160" ><B>&nbsp;<%= strJudClassName %></B></TD>
                        <TD>&nbsp;</TD>
                        <TD NOWRAP BGCOLOR="#cccccc" width="120">&nbsp;����</TD>
                        <TD NOWRAP BGCOLOR="#eeeeee" width="160"><B>&nbsp;<%= strJudCd %>&nbsp;(&nbsp;�ŏI����&nbsp;�F&nbsp;<%= strRslJudCd %>&nbsp;)</B></TD>
                        <TD></TD>
                        <TD></TD>
                        <TD></TD>
                    </TR>
                    <TR align="left">
                        <TD NOWRAP BGCOLOR="#cccccc" width="120" HEIGHT="22">&nbsp;�񎟌����{��</TD>
                        <TD NOWRAP BGCOLOR="#eeeeee" width="160"><B>&nbsp;<%= strSecEquipDivName %></B></TD>
                        <TD>&nbsp;</TD>
                        <TD NOWRAP BGCOLOR="#cccccc" width="120">&nbsp;�񎟌����\���</TD>
                        <TD NOWRAP BGCOLOR="#eeeeee" width="160"><B>&nbsp;<%= strSecPlanDate %></B></TD>
                        <TD>&nbsp;</TD>
                        <TD NOWRAP BGCOLOR="#cccccc" width="120">&nbsp;�񎟌����\�荀��</TD>
                        <TD NOWRAP BGCOLOR="#eeeeee" width="180"><B>&nbsp;<%= strRsvTestName %></B></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
    <BR>
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
            <TD WIDTH="200">
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" WIDTH="100%">
                    <TR>
                        <TD NOWRAP HEIGHT="15">
                            <IMG SRC="../../images/spacer.gif" WIDTH="10">
                            <A HREF="javascript:function voi(){};voi()" ONCLICK="return saveData()"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="�񎟌������ʕۑ�"></A>
                        <% If blnFollowRsl Then %>
                            <A HREF="javascript:function voi(){};voi()" ONCLICK="return deleteData()"><IMG SRC="/webHains/images/delete.gif" WIDTH="77" HEIGHT="24" ALT="�񎟌������ʍ폜"></A>
                        <% End If %>
                        </TD>
                    </TR>
                </TABLE>
            </TD>
            <% End If %>
        </TR>
    <TABLE>

    
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="100%">
        <TR>
            <TD WIDTH="100%">
                <TABLE>
                <TR>
                    <TD WIDTH="120" HEIGHT="22" NOWRAP BGCOLOR="#cccccc">&nbsp;�����i���Áj���{��&nbsp;</TD>
                    <TD>
                        <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                            <TR>
                                <TD NOWRAP ID="gdeDate"><A HREF="javascript:calGuide_showGuideCalendar('secCslYear', 'secCslMonth', 'secCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\�����܂�"></A></TD>
                                <TD NOWRAP><A HREF="javascript:calGuide_clearDate('secCslYear', 'secCslMonth', 'secCslDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
                                <TD>
                                    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="100%">
                                        <TR>
                                            <TD><%= EditNumberList("secCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strSecCslYear, True) %></TD>
                                            <TD>�N</TD>
                                            <TD><%= EditNumberList("secCslMonth", 1, 12, strSecCslMonth, True) %></TD>
                                            <TD>��</TD>
                                            <TD><%= EditNumberList("secCslDay", 1, 31, strSecCslDay, True) %></TD>
                                            <TD>��</TD>
                                        </TR>
                                    </TABLE>
                                </TD>
                                <TD><IMG SRC="../../images/spacer.gif" WIDTH="10"><FONT COLOR="RED">���K�{����</FONT></TD>
                            </TR>
                        </TABLE>
                    </TD>
                </TR>
                <TR>
                    <TD NOWRAP BGCOLOR="#cccccc">&nbsp;�񎟌�������</TD>
                    <TD NOWRAP>
                        <INPUT TYPE="checkbox" NAME="testUS"     VALUE="1" <%= IIf( strTestUS = "1", "CHECKED", "") %>>US&nbsp;&nbsp;
                        <INPUT TYPE="checkbox" NAME="testCT"     VALUE="1" <%= IIf( strTestCT = "1", "CHECKED", "") %>>CT&nbsp;&nbsp;
                        <INPUT TYPE="checkbox" NAME="testMRI"    VALUE="1" <%= IIf( strTestMRI = "1", "CHECKED", "") %>>MRI&nbsp;&nbsp;
                        <INPUT TYPE="checkbox" NAME="testBF"     VALUE="1" <%= IIf( strTestBF = "1", "CHECKED", "") %>>BF&nbsp;&nbsp;
                        <INPUT TYPE="checkbox" NAME="testGF"     VALUE="1" <%= IIf( strTestGF = "1", "CHECKED", "") %>>GF&nbsp;&nbsp;
                        <INPUT TYPE="checkbox" NAME="testCF"     VALUE="1" <%= IIf( strTestCF = "1", "CHECKED", "") %>>CF&nbsp;&nbsp;
                        <INPUT TYPE="checkbox" NAME="testEM"     VALUE="1" <%= IIf( strTestEM = "1", "CHECKED", "") %>>����&nbsp;&nbsp;
                        <INPUT TYPE="checkbox" NAME="testTM"     VALUE="1" <%= IIf( strTestTM = "1", "CHECKED", "") %>>��ᇃ}�[�J�[&nbsp;&nbsp;
                        
                        <INPUT TYPE="checkbox" NAME="testRefer"  VALUE="1" <%= IIf( strTestRefer = "1", "CHECKED", "") %> ONCLICK="chkWrite(this,testReferText);">���t�@�[&nbsp;
                        <INPUT TYPE="text" NAME="testReferText" SIZE="10" MAXLENGTH="40" VALUE="<%= strTestReferText %>" STYLE="ime-mode:active;">
                        
                        <INPUT TYPE="checkbox" NAME="testETC"    VALUE="1" <%= IIf( strTestETC = "1", "CHECKED", "") %> ONCLICK="chkWrite(this, testRemark);">���̑�&nbsp;
                        <INPUT TYPE="text" NAME="testRemark" SIZE="30" MAXLENGTH="45" VALUE="<%= strTestRemark %>" STYLE="ime-mode:active;">
                    </TD>
                </TR>
                <TR>
                    <TD WIDTH="120" HEIGHT="22" NOWRAP BGCOLOR="#cccccc">&nbsp;�񎟌�������</TD>
                    <TD NOWRAP>
                        <INPUT TYPE="radio" NAME="resultDiv" VALUE="1" BORDER="0" <%= IIf(strResultDiv = "1", " CHECKED", "") %>>�ُ�Ȃ�&nbsp;&nbsp;
                        <INPUT TYPE="radio" NAME="resultDiv" VALUE="2" BORDER="0" <%= IIf(strResultDiv = "2", " CHECKED", "") %>>�s��&nbsp;&nbsp;
                        <INPUT TYPE="radio" NAME="resultDiv" VALUE="3" BORDER="0" <%= IIf(strResultDiv = "3", " CHECKED", "") %>>�f�f������F���L�̐f�f�����I��
                    </TD>
                </TR>
                <TR>
                    <TD WIDTH="120" HEIGHT="22" NOWRAP BGCOLOR="#cccccc">&nbsp;�f�f��</TD>
                    <TD>
                        <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" BGCOLOR="#999999" WIDTH="100%">
                            <TR ALIGN="center" BGCOLOR="#cccccc">
                                <TD NOWRAP WIDTH="130">����</TD>
                                <TD NOWRAP WIDTH="160">����i���ʁj</TD>
                                <TD NOWRAP COLSPAN="3" WIDTH="100%">�f�f��</TD>
                            </TR>


<%
        lngCount = UBound(vntItemCd)
        
        If lngCount > 0 Then
            strBeforeGrpName = ""

            For i = 0 To lngCount
                strWebGrpName = ""
                If strBeforeGrpName <> vntGrpName(i) Then
                    strWebGrpName = vntGrpName(i)
                End If
%>
                            <TR BGCOLOR="#ffffff">
                                <TD NOWRAP ALIGN="left">&nbsp;<%= strWebGrpName %></TD>
                                <TD NOWRAP ALIGN="left"><SPAN ID="itemname<%=i%>">&nbsp;<%= vntItemName(i) %></SPAN></TD>
                                <TD NOWRAP><A HREF="JavaScript:callStcGuide(<%=i%>)"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="�����I���K�C�h��\�����܂�"></A></TD>
                                <TD NOWRAP><A HREF="JavaScript:callStcClr(<%=i%>)"><IMG SRC="../../images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�������폜���܂�"></A></TD>
                                <TD NOWRAP ALIGN="left" WIDTH="100%"><SPAN ID="sentence<%=i%>"><%= vntShortStc(i) %></SPAN></TD>
                                <INPUT TYPE="hidden" NAME="arrGrpName"  VALUE="<%= vntGrpName(i) %>">
                                <INPUT TYPE="hidden" NAME="arrItemName" VALUE="<%= vntItemName(i) %>">
                                <INPUT TYPE="hidden" NAME="arrItemcd"   VALUE="<%= vntItemCd(i) %>">
                                <INPUT TYPE="hidden" NAME="arrSuffix"   VALUE="<%= vntSuffix(i) %>">
                                <INPUT TYPE="hidden" NAME="arrResult"   VALUE="<%= vntResult(i) %>">
                                <INPUT TYPE="hidden" NAME="arrLongStc"  VALUE="<%= vntShortStc(i) %>">
                            </TR>
<%
                strBeforeGrpName = vntGrpName(i)
            Next
        End If
%>
                        </TABLE>
                    </TD>
                </TR>

                <TR>
                    <TD NOWRAP BGCOLOR="#cccccc">&nbsp;���̑�����</TD>
                    <TD COLSPAN="7"><TEXTAREA NAME="disRemark" style="ime-mode:active"  COLS="70" ROWS="4"><%= strDisRemark %></TEXTAREA></TD>
                </TR>
                <TR>
                    <TD NOWRAP BGCOLOR="#cccccc">&nbsp;���j�i���ÂȂ��j</TD>
                    <TD NOWRAP>
                        <INPUT TYPE="checkbox" NAME="polWithout"    VALUE="1" <%= IIf( strPolWithout    = "1", "CHECKED", "") %>>���u�s�v&nbsp;&nbsp;
                        <INPUT TYPE="checkbox" NAME="polFollowup"   VALUE="1" <%= IIf( strPolFollowup   = "1", "CHECKED", "") %> ONCLICK="chkWrite(this, polMonth);">�o�ߊώ@&nbsp;(
                        <INPUT TYPE="text"     NAME="polMonth" STYLE="text-align:right" SIZE="3" MAXLENGTH="3" VALUE="<%= strPolMonth %>" STYLE="ime-mode:inactive;">&nbsp;)����&nbsp;&nbsp;
                        <INPUT TYPE="checkbox" NAME="polReExam"     VALUE="1" <%= IIf( strPolReExam     = "1", "CHECKED", "") %>>1�N�㌒�f&nbsp;&nbsp;
                        <%'### 2016.09.13 �� �{�@���{�@�E���f�B���[�J�X�ɕύX ###%>
                        <INPUT TYPE="checkbox" NAME="polDiagSt"     VALUE="1" <%= IIf( strPolDiagSt     = "1", "CHECKED", "") %>>�{�@�E���f�B���[�J�X�Љ�i�����j&nbsp;&nbsp;
                        <INPUT TYPE="checkbox" NAME="polDiag"       VALUE="1" <%= IIf( strPolDiag       = "1", "CHECKED", "") %>>���@�Љ�i�����j&nbsp;&nbsp;
                        <INPUT TYPE="checkbox" NAME="polETC1"       VALUE="1" <%= IIf( strPolETC1       = "1", "CHECKED", "") %> ONCLICK="chkWrite(this, polRemark1);">���̑�&nbsp;
                        <INPUT TYPE="text" NAME="polRemark1" SIZE="40" MAXLENGTH="50" VALUE="<%= strPolRemark1 %>" STYLE="ime-mode:active;">
                    </TD>
                </TR>

                <TR>
                    <TD NOWRAP BGCOLOR="#cccccc">&nbsp;���j�i���Â���j</TD>
                    <TD NOWRAP>
                        <INPUT TYPE="checkbox" NAME="polSugery"     VALUE="1" <%= IIf( strPolSugery     = "1", "CHECKED", "") %>>�O�Ȏ���&nbsp;&nbsp;
                        <INPUT TYPE="checkbox" NAME="polEndoscope"  VALUE="1" <%= IIf( strPolEndoscope  = "1", "CHECKED", "") %>>�������I����&nbsp;&nbsp;
                        <INPUT TYPE="checkbox" NAME="polChemical"   VALUE="1" <%= IIf( strPolChemical   = "1", "CHECKED", "") %>>���w�Ö@&nbsp;&nbsp;
                        <INPUT TYPE="checkbox" NAME="polRadiation"  VALUE="1" <%= IIf( strPolRadiation  = "1", "CHECKED", "") %>>���ː�����&nbsp;&nbsp;
                        <%'### 2016.09.13 �� �{�@���{�@�E���f�B���[�J�X�ɕύX ###%>
                        <INPUT TYPE="checkbox" NAME="polReferSt"    VALUE="1" <%= IIf( strPolReferSt    = "1", "CHECKED", "") %>>�{�@�E���f�B���[�J�X�Љ�&nbsp;&nbsp;
                        <INPUT TYPE="checkbox" NAME="polRefer"      VALUE="1" <%= IIf( strPolRefer      = "1", "CHECKED", "") %>>���@�Љ�&nbsp;&nbsp;
                        <INPUT TYPE="checkbox" NAME="polETC2"       VALUE="1" <%= IIf( strPolETC2       = "1", "CHECKED", "") %> ONCLICK="chkWrite(this, polRemark2);">���̑�&nbsp;
                        <INPUT TYPE="text" NAME="polRemark2" SIZE="40" MAXLENGTH="50" VALUE="<%= strPolRemark2 %>" STYLE="ime-mode:active;">
                    </TD>
                </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>


</FORM>
</BODY>
</HTML>
