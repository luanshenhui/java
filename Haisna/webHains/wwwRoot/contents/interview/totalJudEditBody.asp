<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   ��������i����C����ʁj (Ver0.0.1)
'	   AUTHER  : keiko fujii@ffcs.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/InterviewEditDropDown.inc" -->
<!-- #include virtual = "/webHains/includes/editCsGrp.inc"   -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
'Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const AUTOJUD_USER = "AUTOJUD"      '�������胆�[�U

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon           '���ʃN���X
Dim objHainsUser        '���[�U�[���A�N�Z�X�p
Dim objInterview        '�ʐڏ��A�N�Z�X�p
Dim objJud              '������A�N�Z�X�p
Dim objJudgement        '���茋�ʃA�N�Z�X�p

Dim strAct              '�������
Dim strCmtMode          '�����R�����g�������[�h
Dim strWinMode          '�E�C���h�E�\�����[�h�i1:�ʃE�C���h�E�A0:���E�C���h�E�j
Dim strGrpCd            '�O���[�v�R�[�h

Dim lngRsvNo            '�\��ԍ��i���񕪁j
Dim strCsCd             '�R�[�X�R�[�h�i���񕪁j

Dim blnUpdated          'TRUE:�ύX����AFALSE:�ύX�Ȃ�

Dim lngEditFlg          '�C���L��

'��f���擾�p
Dim vntCslRsvNo         '�\��ԍ�
Dim vntCslCslDate       '��f��
Dim vntCslCsCd          '�R�[�X�R�[�h
Dim vntCslCsName        '�R�[�X����
Dim vntCslCsSName       '�R�[�X������

'Dim strPerId           '�l�h�c
'Dim dtmCslDate         '��f��
Dim lngLastDspMode      '�O���\�����[�h�i0:���ׂāA1:����R�[�X�A2:�C�ӎw��j
Dim vntCsGrp            '�R�[�X�R�[�h �܂��́@�R�[�X�O���[�v�R�[�h
Dim lngGetSeqMode       '�擾�� 0:�\�����{���t�@1:���t�{�\����
Dim vntRsvNo            '�\��ԍ�
Dim vntSeq              '�\���ʒu
Dim vntJudClassCd       '���蕪�ރR�[�h
Dim vntJudClassName     '���蕪�ޖ���
Dim vntJudCd            '����R�[�h
Dim vntJudSName         '���藪��
Dim vntWeight           '����d��
Dim vntWebColor         '�\���F
Dim vntUpdUser          '�X�V��
Dim vntUpdFlg           '�X�V�t���O   2003.12.26 add
Dim vntResultDispMode   '�������ʕ\�����[�h
Dim vntJudCmtCd         '����R�����g�R�[�h
Dim vntJudCmtstc        '����R�����g����

'eGFR�v�Z���ʎ擾�p
Dim vntHisNo            '�\���ʒu
Dim vntHisCslDate       '��f��
Dim vntEGFR             'eGFR�v�Z����
Dim vntMDRD             'eGFR(MDRD��)�v�Z����
Dim vntNewGFR           'GFR(�V�������{�l�̐��Z��)�v�Z����


Dim lngJudClassCount    '���蕪�ތ���
Dim lngLastJudClassCd   '�O���蕪�ރR�[�h

Dim lngCount            '����

Dim lngDspPoint         '�\���ʒu

Dim lngEGFRCount        'EGFR�擾����
Dim lngMDRDCount        'EGFR(MDRD��)�擾����
Dim lngNewGFRCount      'GFR(�V�������{�l�̐��Z��)�擾����

'���茋�ʕҏW�p�̈�
Dim vntEditJudClassCd   '���蕪�ރR�[�h
Dim vntEditJudCd        '����R�[�h
Dim vntEditJudCmtCd     '����R�����g�R�[�h

'���ۂɍX�V���鍀�ڏ��
Dim strUpdRsvNo         '�\��ԍ�
Dim strUpdJudClassCd    '���蕪�ރR�[�h
Dim strUpdJudCd         '����R�[�h
Dim strUpdJudCmtCd      '����R�����g�R�[�h
Dim lngUpdCount         '�X�V���ڐ�

'�ۑ����O�̃T�[�o���f�[�^
Dim vntNewRsvNo         '�\��ԍ�
Dim vntNewSeq           '�\���ʒu
Dim vntNewJudClassCd    '���蕪�ރR�[�h
Dim vntNewJudClassName  '���蕪�ޖ���
Dim vntNewJudCd         '����R�[�h
Dim vntNewJudSName      '���藪��
Dim vntNewWeight        '����d��
Dim vntNewUpdUser       '�X�V��
Dim vntNewUpdFlg        '�X�V�t���O 2003.12.26
Dim vntNewUpdJudCmtCd   '����R�����g�R�[�h
Dim lngNewCount         '�X�V���ڐ�

'�����R�����g�i�ҏW�J�n���j
Dim vntCmtSeq           '�\����
Dim vntTtlJudCmtCd      '����R�����g�R�[�h
Dim vntTtlJudCmtstc     '����R�����g����
Dim vntTtlJudClassCd    '���蕪�ރR�[�h
Dim vntTtlJudCd         '����R�[�h
Dim vntTtlWeight        '����d��
Dim lngTtlCmtCnt        '�s��

'�����R�����g�ҏW�p�̈�
Dim vntEditCmtSeq           '�\����
Dim vntEditTtlCmtCd         '����R�����g�R�[�h
Dim vntEditJudCmtstc        '����R�����g����
Dim vntEditJudCmtClassCd    '���蕪�ރR�[�h
Dim vntEditTtlJudCd         '����R�[�h
Dim vntEditTtlWeight        '����d��
Dim lngEditCmtCnt           '�s��

'�����R�����g��r�p�̈�i�ۑ����O�j
Dim vntNewCmtSeq        '�\����
Dim vntNewTtlCmtCd      '����R�����g�R�[�h
Dim vntNewJudCmtstc     '����R�����g����
Dim vntNewTtlClassCd    '���蕪�ރR�[�h
Dim vntNewTtlJudCd      '����R�[�h
Dim vntNewTtlWeight     '����d��
Dim lngNewCmtCnt        '�s��

Dim strJudClassCd       '���蕪�ރR�[�h�i�����R�����g�\���p�j

'UpdateResult_tk �p�����[�^
Dim vntItemCd           '�������ڃR�[�h
Dim vntSuffix           '�T�t�B�b�N�X
Dim vntResult           '��������
Dim vntRslCmtCd1        '���ʃR�����g�P
Dim vntRslCmtCd2        '���ʃR�����g�Q

'�O����R�[�X�R���{�{�b�N�X
Dim strArrLastCsGrp()           '�R�[�X�O���[�v�R�[�h
Dim strArrLastCsGrpName()       '�R�[�X�O���[�v����

'����R���{�{�b�N�X
Dim strArrJudCdSeq      '����A��
Dim strArrJudCd         '����R�[�h
Dim strArrWeight        '����p�d��
Dim lngJudListCnt       '���茏��

Dim i                   '���[�v�J�E���^
Dim j                   '���[�v�J�E���^

Dim strArrMessage       '�G���[���b�Z�[�W

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objHainsUser    = Server.CreateObject("HainsHainsUser.HainsUser")
Set objInterview    = Server.CreateObject("HainsInterview.Interview")
Set objJud          = Server.CreateObject("HainsJud.Jud")
Set objJudgement    = Server.CreateObject("HainsJudgement.Judgement")

'�����l�̎擾
strAct           = Request("action")
strCmtMode       = Request("cmtmode")

lngRsvNo         = Request("rsvno")
strCsCd          = Request("cscd")
strWinMode       = Request("winmode")
strGrpCd         = Request("grpcd")

'�����\�����̔���
vntSeq          = ConvIStringToArray(Request("orgSeq"))
vntJudClassCd   = ConvIStringToArray(Request("orgJudClassCd"))
vntJudCd        = ConvIStringToArray(Request("orgJudCd"))
lngCount        = CLng(Request("orgCount"))

vntEditJudClassCd   = ConvIStringToArray(Request("editJudclass"))
vntEditJudCd        = ConvIStringToArray(Request("editJudcd"))
vntEditJudCmtCd     = ConvIStringToArray(Request("editJudCmtCd"))

vntCmtSeq        = ConvIStringToArray(Request("orgCmtSeq"))
vntTtlJudCmtCd   = ConvIStringToArray(Request("orgTtlJudCmtCd"))
vntTtlJudCmtstc  = ConvIStringToArray(Request("orgTtlJudCmtstc"))
vntTtlJudClassCd    = ConvIStringToArray(Request("orgTtlJudClassCd"))
lngTtlCmtCnt     = CLng(Request("orgCmtCnt"))

vntEditCmtSeq    = ConvIStringToArray(Request("editCmtSeq"))
vntEditTtlCmtCd  = ConvIStringToArray(Request("editTtlCmtCd"))
vntEditJudCmtstc = ConvIStringToArray(Request("editJudCmtstc"))
vntEditJudCmtClassCd= ConvIStringToArray(Request("editJudCmtClassCd"))
lngEditCmtCnt    = CLng(Request("editTtlCnt"))

strSelCsGrp     = Request("csgrp")
strSelCsGrp     = IIf( strSelCsGrp="", "0", strSelCsGrp)

Select Case strSelCsGrp
    '���ׂẴR�[�X
    Case "0"
        lngLastDspMode = 0
        vntCsGrp = ""
    '����R�[�X
    Case "1"
        lngLastDspMode = 1
        vntCsGrp = strCsCd
    Case Else
        lngLastDspMode = 2
        vntCsGrp = strSelCsGrp
End Select

'����擾
Call EditJudListInfo

Do
    
    '�ۑ�
    If strAct = "save"  Then
        
        '���茋�ʂ̕ۑ�
        ' ## UPDFLG �ǉ��@2003.12.26
        '�ŐV�̔��茋�ʍĎ擾
        lngNewCount = objInterview.SelectJudHistoryRslList( _
                                                lngRsvNo, _
                                                3, _
                                                lngLastDspMode, _
                                                vntCsGrp, _
                                                1, _
                                                 , _
                                                 , _
                                                vntNewRsvNo, _
                                                vntNewSeq, _
                                                vntNewJudClassCd, _
                                                vntNewJudClassName, _
                                                vntNewJudCd, _
                                                vntNewJudSName, _
                                                vntNewWeight, _
                                                vntNewUpdUser, _
                                                vntNewUpdJudCmtCd _
                                                )
        strArrMessage = ""
        '�C���O�ƃT�[�o�[���̏�Ԃ��ς���Ă��邩�`�F�b�N
        If lngNewCount <> lngCount Then
            strArrMessage = "����f�[�^�����̐l�ɂ���čX�V����Ă��邽�ߕۑ��ł��܂���B"
        Else
            For i = 0 To lngNewCount-1
                If  vntNewSeq(i) = 1 And _
                    vntNewJudCd(i) <> vntJudCd(i)  Then
                    strArrMessage = "����f�[�^�����̐l�ɂ���čX�V����Ă��邽�ߕۑ��ł��܂���B"
                    Exit For
                End If
            Next
        End If

        If strArrMessage = ""  Then
            '���ۂɍX�V���s�����ڂ݂̂𒊏o(�����\���f�[�^�ƈقȂ�f�[�^���X�V�Ώ�)
            lngUpdCount = 0
            strUpdRsvNo       = Array()
            strUpdJudClassCd  = Array()
            strUpdJudCd       = Array()
            strUpdJudCmtCd    = Array()

            For i = 0 To UBound(vntEditJudClassCd)

                '���肪�X�V����Ă�����f�[�^�X�V
                blnUpdated = False
                If vntEditJudClassCd(i) <> "" Then
                    For j = 0 To lngNewCount-1
                        If vntNewSeq(j) = 1 And _
                           vntNewJudClassCd(j) = vntEditJudClassCd(i) And _
                           vntNewJudCd(j) <> vntEditJudCd(i) Then
                            blnUpdated = True
                            Exit For
                        End If
                    Next
                End If
            

                '�f�[�^�X�V��ԂȂ�z����g�����ĕۑ���Ԃ��Z�b�g
                If blnUpdated = True Then

                    ReDim Preserve strUpdRsvNo(lngUpdCount)
                    ReDim Preserve strUpdJudClassCd(lngUpdCount)
                    ReDim Preserve strUpdJudCd(lngUpdCount)
                    ReDim Preserve strUpdJudCmtCd(lngUpdCount)

                    strUpdRsvNo(lngUpdCount)  = lngRsvNo
                    strUpdJudClassCd(lngUpdCount)  = vntEditJudClassCd(i)
                    strUpdJudCd(lngUpdCount)       = vntEditJudCd(i)
                    strUpdJudCmtCd(lngUpdCount)    = vntNewUpdJudCmtCd(j)


                    lngUpdCount = lngUpdCount + 1

                End If
            Next


            '�X�V�Ώۃf�[�^�����݂���Ƃ��̂ݔ��茋�ʕۑ�
            If ( lngUpdCount > 0 ) Then
                objJudgement.InsertJudRslWithUpdate strUpdRsvNo, _
                                                strUpdJudClassCd, _
                                                strUpdJudCd, _
                                                strUpdJudCmtCd, _
                                                Session.Contents("userId"), 1
                strAct = "saveend"
            Else
                strAct = ""
            End If
        End If


        If strArrMessage = "" And strCmtMode = "save" Then

            '�ŐV�̑����R�����g�Ď擾
'** #### 2011.11.17 SL-SN-Y0101-006 MOD START #### **
'            lngNewCmtCnt = objInterview.SelectTotalJudCmt( _
'                                        lngRsvNo, 1, _
'                                        1, 0,  , 0, _
'                                        vntNewCmtSeq, _
'                                        vntNewTtlCmtCd, _
'                                        vntNewJudCmtstc, _
'                                        vntNewTtlClassCd, _
'                                        , , , , _
'                                        vntNewTtlJudCd, _
'                                        vntNewTtlWeight _
'                                        )
            lngNewCmtCnt = objInterview.SelectTotalJudCmt( _
                                        lngRsvNo, 1, _
                                        1, 1, strCsCd, 0, _
                                        vntNewCmtSeq, _
                                        vntNewTtlCmtCd, _
                                        vntNewJudCmtstc, _
                                        vntNewTtlClassCd, _
                                        , , , , _
                                        vntNewTtlJudCd, _
                                        vntNewTtlWeight _
                                        )
'** #### 2011.11.17 SL-SN-Y0101-006 MOD END #### **


            strArrMessage = ""
            '�C���O�ƃT�[�o�[���̏�Ԃ��ς���Ă��邩�`�F�b�N
            If lngNewCmtCnt <> lngTtlCmtCnt Then
                strArrMessage = "�����R�����g�����̐l�ɂ���čX�V����Ă��邽�ߕۑ��ł��܂���B"
            Else
                For i = 0 To lngNewCmtCnt-1
                    If  CLng(vntNewCmtSeq(i)) <> CLng(vntCmtSeq(i)) Or _
                        vntNewTtlCmtCd(i) <> vntTtlJudCmtCd(i) Then
                        strArrMessage = "�����R�����g�����̐l�ɂ���čX�V����Ă��邽�ߕۑ��ł��܂���B"
                        Exit For
                    End If
                Next
            End If

            blnUpdated = False
            If lngEditCmtCnt <> lngNewCmtCnt Then
                blnUpdated = True
            Else
                For i = 0 To lngEditCmtCnt-1
                    If vntEditTtlCmtCd(i) <> vntNewTtlCmtCd(i) Then
                        blnUpdated = True
                        Exit For
                    End If
                Next
            End If
            If strArrMessage = ""   And blnUpdated = True Then
                '�����R�����g�̕ۑ�
                '## 2004.01.07 �X�V����p�ɕ��͂ƃ��[�U�h�c�ǉ�
                objInterview.UpdateTotalJudCmt _
                                        lngRsvNo, 1, _
                                        vntEditCmtSeq, _
                                        vntEditTtlCmtCd, _
                                        vntEditJudCmtstc, _
                                        Session.Contents("userId")
                strAct = "saveend"
                strCmtMode = ""
            End If
        End If
    End If

    '���������ɏ]����f���ꗗ�𒊏o����
    lngCount = objInterview.SelectConsultHistory( _
                                lngRsvNo, _
                                 , _
                                lngLastDspMode, _
                                vntCsGrp, _
                                3, _
                                 ,  , _
                                vntCslRsvNo, _
                                vntCslCslDate, _
                                vntCslCsCd, _
                                vntCslCsName, _
                                vntCslCsSName _
                                )

    If lngCount <= 0 Then
        Err.Raise 1000, , "��f��񂪂���܂���BRsvNo= " & lngRsvNo
    End If

    '����R�[�X�R�[�h�ޔ�
    strCsCd = vntCslCsCd(0)

    '���������ɏ]�����茋�ʈꗗ�𒊏o����
    ' ## UPDFLG �ǉ��@2003.12.26
    lngCount = objInterview.SelectJudHistoryRslList( _
                                                lngRsvNo, _
                                                3, _
                                                lngLastDspMode, _
                                                vntCsGrp, _
                                                1, _
                                                 , _
                                                 , _
                                                vntRsvNo, _
                                                vntSeq, _
                                                vntJudClassCd, _
                                                vntJudClassName, _
                                                vntJudCd, _
                                                vntJudSName, _
                                                vntWeight, _
                                                vntUpdUser, _
                                                vntJudCmtCd, , _
                                                vntResultDispMode, _
                                                vntUpdFlg _
                                                )
    If lngCount <= 0 Then
        Err.Raise 1000, , "���茋�ʂ�����܂���BRsvNo= " & lngRsvNo
    End If

    vntEditJudCd = vntJudCd

'#### 2008.07.01 �� �u�V�������{�l��GFR���Z���v�K�p�ׁ̈A�폜 Start ####
'    '���������ɏ]��eGFR�v�Z���ʈꗗ�𒊏o����
'    lngEGFRCount = objInterview.SelectEGFRHistory( _
'                                                lngRsvNo, _
'                                                3, _
'                                                vntCsGrp, _
'                                                vntHisNo, _
'                                                vntHisCslDate, _
'                                                vntEGFR _
'                                                )
'#### 2008.07.01 �� �u�V�������{�l��GFR���Z���v�K�p�ׁ̈A�폜 End   ####

    '���������ɏ]��eGFR(MDRD���j�v�Z���ʈꗗ�𒊏o����
    lngMDRDCount = objInterview.SelectMDRDHistory( _
                                                lngRsvNo, _
                                                3, _
                                                vntCsGrp, _
                                                vntHisNo, _
                                                vntHisCslDate, _
                                                vntMDRD _
                                                )

'#### 2008.07.01 �� �u�V�������{�l��GFR���Z���v�K�p�ׁ̈A�ǉ� Start ####
    '���������ɏ]��GFR(���{�l���Z���j�v�Z���ʈꗗ�𒊏o����
    lngNewGFRCount = objInterview.SelectNewGFRHistory( _
                                                lngRsvNo, _
                                                3, _
                                                vntCsGrp, _
                                                vntHisNo, _
                                                vntHisCslDate, _
                                                vntNewGFR _
                                                )
'#### 2008.07.01 �� �u�V�������{�l��GFR���Z���v�K�p�ׁ̈A�ǉ� End   ####

    '�����R�����g�擾
'** #### 2011.11.17 SL-SN-Y0101-006 MOD START #### **
'    lngTtlCmtCnt = objInterview.SelectTotalJudCmt( _
'                                        lngRsvNo, 1, _
'                                        1, 0,  , 0, _
'                                        vntCmtSeq, _
'                                        vntTtlJudCmtCd, _
'                                        vntTtlJudCmtstc, _
'                                        vntTtlJudClassCd, _
'                                        , , , , _
'                                        vntTtlJudCd, _
'                                        vntTtlWeight _
'                                        )
    lngTtlCmtCnt = objInterview.SelectTotalJudCmt( _
                                        lngRsvNo, 1, _
                                        1, 1, strCsCd, 0, _
                                        vntCmtSeq, _
                                        vntTtlJudCmtCd, _
                                        vntTtlJudCmtstc, _
                                        vntTtlJudClassCd, _
                                        , , , , _
                                        vntTtlJudCd, _
                                        vntTtlWeight _
                                        )
'** #### 2011.11.17 SL-SN-Y0101-006 MOD END #### **

    '�ҏW�̈�փZ�b�g
    lngEditCmtCnt = lngTtlCmtCnt
    vntEditCmtSeq = vntCmtSeq
    vntEditTtlCmtCd = vntTtlJudCmtCd
    vntEditJudCmtstc = vntTtlJudCmtstc
    vntEditJudCmtClassCd = vntTtlJudClassCd
    vntEditTtlJudCd = vntTtlJudCd
    vntEditTtlWeight = vntTtlWeight

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
    lngJudListCnt = objJud.SelectJudList( _
                                        strArrJudCd, _
                                         , , strArrWeight)

    strArrJudCdSeq = Array()
    Redim Preserve strArrJudCdSeq(lngJudListCnt-1)
    For i = 0 To lngJudListCnt-1
        strArrJudCdSeq(i) = i
    Next


End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�����������</TITLE>
<SCRIPT TYPE="text/javascript">
<!-- #include virtual = "/webHains/includes/stcGuide.inc"    -->
<!--
var winMenResult;               // �E�B���h�E�n���h��
//�������ʉ�ʌĂяo��
function callMenResult( classgrpno ) {

    var url;            // URL������
    var opened = false; // ��ʂ����łɊJ����Ă��邩


    // ���łɃK�C�h���J����Ă��邩�`�F�b�N
    if ( winMenResult != null ) {
        if ( !winMenResult.closed ) {
            opened = true;
        }
    }

    url = '/WebHains/contents/interview/MenResult.asp?grpno=' + classgrpno;
    url = url + '&winmode=1';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';
    url = url + '&grpcd=' + '<%= strGrpCd %>';
    url = url + '&cscd=' + '<%= strCsCd %>';

    // �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
    if ( opened ) {
        winMenResult.focus();
        winMenResult.location.replace( url );
    } else {
        winMenResult = window.open( url, '', 'width=1000,height=500,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
    }

}


var winJudComment;              // �E�B���h�E�n���h��
var lngSelectedIndex1;          // �K�C�h�\�����ɑI�����ꂽ�G�������g�̃C���f�b�N�X
var jcmGuide_CalledFunction;
var jcmGuide_CmtMode;

var varEditCmtSeq;
var varEditCmtCd;
var varEditCmtstc;
var varEditClassCd;
var varEditJudCd;
var varEditWeight;

var editcnt;

var orgSetFlg;
//�����R�����g�E�C���h�E�Ăяo��
function showJudCommentWindow(index, judclscd, cmtmode) {

    var url;            // URL������
    var opened = false; // ��ʂ����łɊJ����Ă��邩

    var i;

    if ( cmtmode == 'insert' || cmtmode == 'edit' ){
        if ( index == 0 ){
            alert( "�ҏW����s���I������Ă��܂���B" );
            return;
        }
    }

    if ( index == 0 ){
        index = document.resultList.editTtlCnt.value;
    }

    lngSelectedIndex1 = index;

    // �K�C�h��ʂ̘A����ɃK�C�h��ʂ���Ăяo����鎩��ʂ̊֐���ݒ肷��
    jcmGuide_CalledFunction = setTotalCmt;
    // ���샂�[�h��ݒ肷��
    jcmGuide_CmtMode = cmtmode;

    if ( orgSetFlg != 1 ) {
        editCmtSet();
    }

    // ���łɃK�C�h���J����Ă��邩�`�F�b�N
    if ( winJudComment != null ) {
        if ( !winJudComment.closed ) {
            opened = true;
        }
    }

    url = '/WebHains/contents/guide/gdeJudComment.asp?cmtdspmode=1';
    // ���蕪�ގw��
    if ( judclscd != 0 ) {
        url = url + '&judClassCd=' + judclscd;
    }

    url = url + '&selCmtCnt=' + editcnt;
    for( i = 0; i < editcnt; i++ ){
        if ( i == 0 ){
            url = url + '&selCmtCd=' + varEditCmtCd[i];
        } else {
            url = url + ',' + varEditCmtCd[i];
        }
    }


    // �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
    if ( opened ) {
        winJudComment.focus();
        winJudComment.location.replace( url );
    } else {
        winJudComment = window.open( url, '', 'width=600,height=280,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
    }

}

var varSelCmtCd = new Array();
var varSelCmtStc = new Array();
var varSelClassCd = new Array();
var varSelJudCd = new Array();
var varSelWeight = new Array();

// �����R�����g�Z�b�g
function setTotalCmt() {

    var i, j;

    var optList;    // SELECT�I�u�W�F�N�g

    var varBack1CmtSeq = new Array();
    var varBack1CmtCd = new Array();
    var varBack1Cmtstc = new Array();
    var varBack1ClassCd = new Array();
    var varBack1JudCd = new Array();
    var varBack1Weight = new Array();
    
    var varBack2CmtSeq = new Array();
    var varBack2CmtCd = new Array();
    var varBack2Cmtstc = new Array();
    var varBack2ClassCd = new Array();
    var varBack2JudCd = new Array();
    var varBack2Weight = new Array();
    

    optList = document.resultList.selectLine;

    if ( jcmGuide_CmtMode == 'add' ) {
        startline = (lngSelectedIndex1-0) + 1;
    } else {
        startline = lngSelectedIndex1;
    }
    
    editcnt = document.resultList.editTtlCnt.value;

    j = 0;
    //�Ώۍs���O�ޔ�
    for ( i = 0; i < startline-1; i++ ) {
        varBack1CmtSeq.length ++;
        varBack1CmtCd.length ++;
        varBack1Cmtstc.length ++;
        varBack1ClassCd.length ++;
        varBack1JudCd.length ++;
        varBack1Weight.length ++;

        varBack1CmtSeq[j] = varEditCmtSeq[i];
        varBack1CmtCd[j] = varEditCmtCd[i];
        varBack1Cmtstc[j] = varEditCmtstc[i];
        varBack1ClassCd[j] = varEditClassCd[i];
        varBack1JudCd[j] = varEditJudCd[i];
        varBack1Weight[j] = varEditWeight[i];
        j++;
    }

    j = 0;
    //�Ώۍs�ȍ~�ޔ�
    /** 2007.07.03 �� �����R�����g��10�ȏ�̏ꍇ�������Ă���s��Ή� **/
    for ( i = startline-1; i < eval(editcnt); i++ ) {
        // �C���̂Ƃ��͒u�������Ȃ̂ŊY���s�͑ޔ����Ȃ�
        if (jcmGuide_CmtMode == 'edit' && 
            i == startline - 1 ) {
            continue;
        }
        varBack2CmtSeq.length ++;
        varBack2CmtCd.length ++;
        varBack2Cmtstc.length ++;
        varBack2ClassCd.length ++;
        varBack2JudCd.length ++;
        varBack2Weight.length ++;

        varBack2CmtSeq[j] = varEditCmtSeq[i];
        varBack2CmtCd[j] = varEditCmtCd[i];
        varBack2Cmtstc[j] = varEditCmtstc[i];
        varBack2ClassCd[j] = varEditClassCd[i];
        varBack2JudCd[j] = varEditJudCd[i];
        varBack2Weight[j] = varEditWeight[i];
        j++;
    }

    // �I�u�W�F�N�g�̏�����
    while ( optList.length > 0 ) {
        optList.options[0] = null;
    }

    varEditCmtSeq = new Array();
    varEditCmtCd = new Array();
    varEditCmtstc = new Array();
    varEditClassCd = new Array();
    varEditJudCd = new Array();
    varEditWeight = new Array();

    varEditCmtSeq.length = 0;
    varEditCmtCd.length = 0;
    varEditCmtstc.length = 0;
    varEditClassCd.length = 0;
    varEditJudCd.length = 0;
    varEditWeight.length = 0;

    j = 0;
    for ( i = 0; i < varBack1CmtSeq.length; i++ ){
        varEditCmtSeq.length ++;
        varEditCmtCd.length ++;
        varEditCmtstc.length ++;
        varEditClassCd.length ++;
        varEditJudCd.length ++;
        varEditWeight.length ++;

        optList.options[ optList.length] = new Option( varBack1Cmtstc[i], j+1 );
        varEditCmtSeq[j] = j + 1;
        varEditCmtCd[j] = varBack1CmtCd[i];
        varEditCmtstc[j] = varBack1Cmtstc[i];
        varEditClassCd[j] = varBack1ClassCd[i];
        varEditJudCd[j] = varBack1JudCd[i];
        varEditWeight[j] = varBack1Weight[i];
        j++;

    }
    for ( i = 0; i < varSelCmtStc.length; i++ ){
        varEditCmtSeq.length ++;
        varEditCmtCd.length ++;
        varEditCmtstc.length ++;
        varEditClassCd.length ++;
        varEditJudCd.length ++;
        varEditWeight.length ++;

        optList.options[ optList.length] = new Option( varSelCmtStc[i], j+1 );
        varEditCmtSeq[j] = j + 1;
        varEditCmtCd[j] = varSelCmtCd[i];
        varEditCmtstc[j] = varSelCmtStc[i];
        varEditClassCd[j] = varSelClassCd[i];
        varEditJudCd[j] = varSelJudCd[i];
        varEditWeight[j] = varSelWeight[i];
        j++;
    }

    for ( i = 0; i < varBack2CmtSeq.length; i++ ){
        varEditCmtSeq.length ++;
        varEditCmtCd.length ++;
        varEditCmtstc.length ++;
        varEditClassCd.length ++;
        varEditJudCd.length ++;
        varEditWeight.length ++;

        optList.options[ optList.length] = new Option( varBack2Cmtstc[i], j+1 );
        varEditCmtSeq[j] = j + 1;
        varEditCmtCd[j] = varBack2CmtCd[i];
        varEditCmtstc[j] = varBack2Cmtstc[i];
        varEditClassCd[j] = varBack2ClassCd[i];
        varEditJudCd[j] = varBack2JudCd[i];
        varEditWeight[j] = varBack2Weight[i];
        j++;
    }

    if ( jcmGuide_CmtMode != 'edit' ){
        editcnt = (editcnt-0) + (varSelCmtStc.length-0);
    } else {
        editcnt = (editcnt-0) - 1 + (varSelCmtStc.length-0);
    }
    document.resultList.editTtlCnt.value = editcnt;

}

//����`�F�b�N
function JudCheck( judclass, judcdElement, classindex ) {

    var myForm;

    var i, j;

    var selJudCd;
    
    myForm = document.resultList;

    selJudCd = judcdElement.value;

    myForm.editJudclass[classindex-1].value = judclass;
    myForm.editJudcd[classindex-1].value = selJudCd;
    
    for ( i = 0; i < myForm.tblJudcd.length; i++ ){
        if ( myForm.tblJudcd[i].value == selJudCd ){
            //����̏d�݂��@20�@����
            if( myForm.tblWeight[i].value > 20 ){
                //�����R�����g�K�C�h��\������
                showJudCommentWindow(myForm.editTtlCnt.value, judclass, 'add')
            } else {
                // �ҏW�G���A�ɖ��Z�b�g�Ȃ�Z�b�g
                if ( orgSetFlg != 1 ) {
                    editCmtSet();
                }
                for ( j = 0; j < editcnt; j++ ){
                    // ���蕪�ވ�v�Ŕ���̏d���R�����g�͍폜
                    if ( varEditClassCd[j] == judclass && varEditWeight[j] > 20){
                        deleteJudComment( j+1, 0 );
                        j = j - 1;
                    }
                }
            }
            break;
        }
    }
}

//�����R�����g�폜
function deleteJudComment( index, msgflg ) {

    var optList;	// SELECT�I�u�W�F�N�g

    if ( index == 0 ){
        alert( "�ҏW����s���I������Ă��܂���B" );
        return;
    }

    if ( msgflg == 1 ){
        if ( !confirm('�I�����ꂽ�R�����g���폜���܂��B��낵���ł����H')) {
            return;
        }
    }
    if ( orgSetFlg != 1 ) {
        editCmtSet();
    }

    var varBack1CmtSeq = new Array();
    var varBack1CmtCd = new Array();
    var varBack1Cmtstc = new Array();
    var varBack1ClassCd = new Array();
    var varBack1JudCd = new Array();
    var varBack1Weight = new Array();
    
    var varBack2CmtSeq = new Array();
    var varBack2CmtCd = new Array();
    var varBack2Cmtstc = new Array();
    var varBack2ClassCd = new Array();
    var varBack2JudCd = new Array();
    var varBack2Weight = new Array();
    

    optList = document.resultList.selectLine;
    
    editcnt = document.resultList.editTtlCnt.value;


    j = 0;
    //�Ώۍs���O�ޔ�
    /** 2007.07.03 �� �����R�����g��10�ȏ�̏ꍇ�������Ă���s��Ή� **/
    //for ( i = 0; i < index-1; i++ ) {
    for ( i = 0; i < eval(index)-1; i++ ) {
        varBack1CmtSeq.length ++;
        varBack1CmtCd.length ++;
        varBack1Cmtstc.length ++;
        varBack1ClassCd.length ++;
        varBack1JudCd.length ++;
        varBack1Weight.length ++;

        varBack1CmtSeq[j] = varEditCmtSeq[i];
        varBack1CmtCd[j] = varEditCmtCd[i];
        varBack1Cmtstc[j] = varEditCmtstc[i];
        varBack1ClassCd[j] = varEditClassCd[i];
        varBack1JudCd[j] = varEditJudCd[i];
        varBack1Weight[j] = varEditWeight[i];
        j++;
    }

    j = 0;
    //�Ώۍs����ޔ�
    /** 2007.07.03 �� �����R�����g��10�ȏ�̏ꍇ�������Ă���s��Ή� **/
    //for ( i = index; i < editcnt; i++ ) {
    for ( i = eval(index); i < eval(editcnt); i++ ) {
        varBack2CmtSeq.length ++;
        varBack2CmtCd.length ++;
        varBack2Cmtstc.length ++;
        varBack2ClassCd.length ++;
        varBack2JudCd.length ++;
        varBack2Weight.length ++;

        varBack2CmtSeq[j] = varEditCmtSeq[i];
        varBack2CmtCd[j] = varEditCmtCd[i];
        varBack2Cmtstc[j] = varEditCmtstc[i];
        varBack2ClassCd[j] = varEditClassCd[i];
        varBack2JudCd[j] = varEditJudCd[i];
        varBack2Weight[j] = varEditWeight[i];
        j++;
    }

    // �I�u�W�F�N�g�̏�����
    while ( optList.length > 0 ) {
        optList.options[0] = null;
    }

    varEditCmtSeq = new Array();
    varEditCmtCd = new Array();
    varEditCmtstc = new Array();
    varEditClassCd = new Array();
    varEditJudCd = new Array();
    varEditWeight = new Array();

    varEditCmtSeq.length = 0;
    varEditCmtCd.length = 0;
    varEditCmtstc.length = 0;
    varEditClassCd.length = 0;
    varEditJudCd.length = 0;
    varEditWeight.length = 0;

    j = 0;
    for ( i = 0; i < varBack1CmtSeq.length; i++ ){
        varEditCmtSeq.length ++;
        varEditCmtCd.length ++;
        varEditCmtstc.length ++;
        varEditClassCd.length ++;
        varEditJudCd.length ++;
        varEditWeight.length ++;

        optList.options[ optList.length] = new Option( varBack1Cmtstc[i], j+1 );
        varEditCmtSeq[j] = j + 1;
        varEditCmtCd[j] = varBack1CmtCd[i];
        varEditCmtstc[j] = varBack1Cmtstc[i];
        varEditClassCd[j] = varBack1ClassCd[i];
        varEditJudCd[j] = varBack1JudCd[i];
        varEditWeight[j] = varBack1Weight[i];
        j++;

    }

    for ( i = 0; i < varBack2CmtSeq.length; i++ ){
        varEditCmtSeq.length ++;
        varEditCmtCd.length ++;
        varEditCmtstc.length ++;
        varEditClassCd.length ++;
        varEditJudCd.length ++;
        varEditWeight.length ++;

        optList.options[ optList.length] = new Option( varBack2Cmtstc[i], j+1 );
        varEditCmtSeq[j] = j + 1;
        varEditCmtCd[j] = varBack2CmtCd[i];
        varEditCmtstc[j] = varBack2Cmtstc[i];
        varEditClassCd[j] = varBack2ClassCd[i];
        varEditJudCd[j] = varBack2JudCd[i];
        varEditWeight[j] = varBack2Weight[i];
        j++;
    }

    document.resultList.editTtlCnt.value = (editcnt-0) - 1;
    
}

//�����R�����g�̏�����Ԃ�ҏW�G���A�ɃZ�b�g
function editCmtSet() {

    var i;

    varEditCmtSeq = new Array();
    varEditCmtCd = new Array();
    varEditCmtstc = new Array();
    varEditClassCd = new Array();
    varEditJudCd = new Array();
    varEditWeight = new Array();

    varEditCmtSeq.length = 0;
    varEditCmtCd.length = 0;
    varEditCmtstc.length = 0;
    varEditClassCd.length = 0;
    varEditJudCd.length = 0;
    varEditWeight.length = 0;

    for ( i = 0; i < document.resultList.orgCmtCnt.value; i++ ){
        varEditCmtSeq.length ++;
        varEditCmtCd.length ++;
        varEditCmtstc.length ++;
        varEditClassCd.length ++;
        varEditJudCd.length ++;
        varEditWeight.length ++;

        if ( document.resultList.orgCmtCnt.value == 1 ){
            varEditCmtSeq[i] = document.resultList.orgCmtSeq.value;
            varEditCmtCd[i] = document.resultList.orgTtlJudCmtCd.value;
            varEditCmtstc[i] = document.resultList.orgTtlJudCmtstc.value;
            varEditClassCd[i] = document.resultList.orgTtlJudClassCd.value;
            varEditJudCd[i] = document.resultList.orgTtlJudCd.value;
            varEditWeight[i] = document.resultList.orgTtlWeight.value;
        } else {
            varEditCmtSeq[i] = document.resultList.orgCmtSeq[i].value;
            varEditCmtCd[i] = document.resultList.orgTtlJudCmtCd[i].value;
            varEditCmtstc[i] = document.resultList.orgTtlJudCmtstc[i].value;
            varEditClassCd[i] = document.resultList.orgTtlJudClassCd[i].value;
            varEditJudCd[i] = document.resultList.orgTtlJudCd[i].value;
            varEditWeight[i] = document.resultList.orgTtlWeight[i].value;
        }
    }

    editcnt = document.resultList.orgCmtCnt.value;
    orgSetFlg = 1;

}

function saveJud() {

    if ( orgSetFlg == 1 ){
        document.resultList.cmtmode.value = "save";
    }

    //hidden �f�[�^�Ɋi�[
    document.resultList.editCmtSeq.value = varEditCmtSeq;
    document.resultList.editTtlCmtCd.value = varEditCmtCd;
    document.resultList.editJudCmtstc.value = varEditCmtstc;
    document.resultList.editJudCmtClassCd.value = varEditClassCd;
    document.resultList.editTtlJudCd.value = varEditJudCd;
    document.resultList.editTtlWeight.value = varEditWeight;

    document.resultList.action.value = "save";
    document.resultList.submit();

}

function windowClose() {

    // �����R�����g�K�C�h�����
    if ( winJudComment != null ) {
        if ( !winJudComment.closed ) {
            winJudComment.close();
        }
    }

    winJudComment = null;

    // �������ʃE�C���h�E�����
    if ( winMenResult != null ) {
        if ( !winMenResult.closed ) {
            winMenResult.close();
        }
    }

    winMenResult = null;

}
//��������Q�Ɖ�ʌĂяo��
function calltotalJudView() {
    var url;    // URL������

    url = '/WebHains/contents/interview/totalJudView.asp';
    url = url + '?winmode=' + '<%= strWinMode %>';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';
    url = url + '&grpcd=' + '<%= strGrpCd %>';
    url = url + '&cscd=' + '<%= strCsCd %>';

    parent.location.href(url);

}

//-->
</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:windowClose()">
<FORM NAME="resultList" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">

    <INPUT TYPE="hidden" NAME="action"  VALUE="<%= strAct %>">
    <INPUT TYPE="hidden" NAME="cmtmode" VALUE="<%= strCmtMode %>">
    <INPUT TYPE="hidden" NAME="rsvno"   VALUE="<%= lngRsvNo %>">
    <INPUT TYPE="hidden" NAME="cscd"    VALUE="<%= strCsCd %>">
    <INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">
    <INPUT TYPE="hidden" NAME="grpcd"   VALUE="<%= strGrpCd %>">
    <INPUT TYPE="hidden" NAME="csgrp"   VALUE="<%= strSelCsGrp %>">

<%
    '����e�[�u����ޔ�
    For i = 0 To lngJudListCnt-1
%>
        <INPUT TYPE="hidden" NAME="tblJudcd"    VALUE="<%= strArrJudCd(i) %>">
        <INPUT TYPE="hidden" NAME="tblWeight"   VALUE="<%= strArrWeight(i) %>">
<%
    Next
%>
<%
    '���b�Z�[�W�̕ҏW
    If strAct <> "" Then

        Select Case strAct

            '�ۑ��������́u�ۑ������v�̒ʒm
            Case "saveend"
                Call EditMessage("�ۑ����������܂����B", MESSAGETYPE_NORMAL)

            '�����Ȃ��΃G���[���b�Z�[�W��ҏW
            Case Else
                Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)

        End Select

    End If
%>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
        <TR>
            <TD>
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2">
                    <TR BGCOLOR="#cccccc" ALIGN="center">
                        <TD ROWSPAN="2" WIDTH="150">����</TD>
                        <TD COLSPAN="3" WIDTH="182">���茋��</TD>
                        <TD ROWSPAN="2" WIDTH="150">����</TD>
                        <TD COLSPAN="3" WIDTH="182">���茋��</TD>
                    </TR>
                    <TR BGCOLOR="#cccccc" ALIGN="center">
                        <TD WIDTH="60">����</TD>
                        <TD WIDTH="60">�O��</TD>
                        <TD WIDTH="60">�O�X��</TD>
                        <TD WIDTH="60">����</TD>
                        <TD WIDTH="60">�O��</TD>
                        <TD WIDTH="60">�O�X��</TD>
                    </TR>
<%
                    lngJudClassCount = 0
                    lngLastJudClassCd = 0
                    lngDspPoint = 0
                    For i = 0 To lngCount - 1
                        '���蕪�ނ��ς�����H
                        If lngLastJudClassCd <> vntJudClassCd(i) Then
                            lngJudClassCount = lngJudClassCount + 1
                            lngLastJudClassCd = vntJudClassCd(i)
                        End If
                        
                        If (CLng(lngDspPoint) Mod 6) = 0 Then
%>
                            <TR BGCOLOR="#eeeeee" HEIGHT="18">
<%
                        End If

%>
<%
                        If (CLng(lngDspPoint) Mod 3) = 0 Then
                            If IsNumeric( vntResultDispMode(i) ) = True Then
%>
                                <TD WIDTH="119"><A HREF="javascript:callMenResult(<%= vntResultDispMode(i) %>)"><%= vntJudClassName(i) %></A></TD>
<%
                            Else
%>
                                <TD WIDTH="119"><%= vntJudClassName(i) %></A></TD>
<%
                            End If
                        End If

                        If vntSeq(i) = 1 Then
                            
                            '�˗�����
                            If vntRsvNo(i) = "" Then
%>
                                <TD ALIGN="center" ><B>***</B></TD>
<%
                            Else
%>
                                <TD><%= EditDropDownListFromArray2("judcd" & vntJudClassCd(i), strArrJudCd, strArrJudCd, vntEditJudCd(i), NON_SELECTED_ADD, "javascript:JudCheck(" & vntJudClassCd(i) & ", document.resultList.judcd" & vntJudClassCd(i) & "," & lngJudClassCount & ")") %></TD>
<%
                            End If
%>
                            <INPUT TYPE="hidden" NAME="editJudclass">
                            <INPUT TYPE="hidden" NAME="editJudcd">
                            <INPUT TYPE="hidden" NAME="editJudCmtCd" VALUE="<%= vntJudCmtCd(i) %>">
<%
                        Else
                            '�˗�����
                            If vntRsvNo(i) = "" Then
%>
                                <TD ALIGN="center" WIDTH="60"><B>***</B></TD>
<%
                            Else
                                '�C�����ꂽ�H
                                '## �X�V�t���O�Ō��� 2003.12.26
                                'If Trim(vntUpdUser(i)) <> Trim(AUTOJUD_USER) And _
                                If Trim(vntUpdFlg(i)) = "1" And _
                                   vntRsvNo(i) <> "" And _
                                   vntJudCd(i) <> "" Then
%>
                                    <!--### 2006.03.08 �� �ύX����ɑ΂���w�i�F�ύX�i�s���N�F�ˊD�F) Start ###-->
                                    <!--TD BGCOLOR="#ffc0cb" ALIGN="center" WIDTH="60"><B><%= vntJudCd(i) %></B></TD-->
                                    <TD BGCOLOR="#cccccc" ALIGN="center" WIDTH="60"><B><%= vntJudCd(i) %></B></TD>
                                    <!--### 2006.03.08 �� �ύX����ɑ΂���w�i�F�ύX�i�s���N�F�ˊD�F) End   ###-->
<%
                                Else
%>
                                    <TD ALIGN="center" WIDTH="60"><B><%= vntJudCd(i) %></B></TD>
<%
                                End If
                            End If
                        End If

                        lngDspPoint = CLng(lngDspPoint) + 1
                    Next
%>
                    <INPUT TYPE="hidden" NAME="orgCount" VALUE="<%= lngCount %>">
<%
                    '�����\�����̔���f�[�^�ޔ�
                    For i = 0 To lngCount - 1
%>
                    <INPUT TYPE="hidden" NAME="orgSeq" VALUE="<%= vntSeq(i) %>">
                    <INPUT TYPE="hidden" NAME="orgJudClass" VALUE="<%= vntJudClassCd(i) %>">
                    <INPUT TYPE="hidden" NAME="orgJudCd" VALUE="<%= vntJudCd(i) %>">
<%
                    Next

%>
                            <TR BGCOLOR="#eeeeee" HEIGHT="18">
<%'#### 2008.07.01 �� �u�V�������{�l��GFR���Z���v�K�p�ׁ̈A�C�� Start ####%>
                                <!--TD WIDTH="119" bgcolor="#cccccc">eGFR</TD-->
<%
'                    For i = 0 To 2
'                        If i <= (lngEGFRCount - 1) Then
%>
                                <!--TD ALIGN="right" WIDTH="50"><B><%'= vntEGFR(i) %></B></TD-->
<%
'                        Else
%>
                                <!--TD ALIGN="center" WIDTH="60"><FONT COLOR="999999"><B>***</B></FONT></TD-->
<%
'                        End If
'                    Next
%>
                                <TD WIDTH="119" bgcolor="#cccccc">eGFR(MDRD��)</TD>
<%
                    For i = 0 To 2
                        If i <= (lngMDRDCount - 1) Then
%>
                                <TD ALIGN="right" WIDTH="50"><B><%= vntMDRD(i) %></B></TD>
<%
                        Else
%>
                                <TD ALIGN="center" WIDTH="60"><FONT COLOR="999999"><B>***</B></FONT></TD>
<%
                        End If
                    Next
%>

                                <TD WIDTH="119" bgcolor="#cccccc">GFR(���{�l���Z��)</TD>
<%
                    For i = 0 To 2
                        If i <= (lngNewGFRCount - 1) Then
%>
                                <TD ALIGN="right" WIDTH="50"><B><%= vntNewGFR(i) %></B></TD>
<%
                        Else
%>
                                <TD ALIGN="center" WIDTH="60"><FONT COLOR="999999"><B>***</B></FONT></TD>
<%
                        End If
                    Next
%>

<%'#### 2008.07.01 �� �u�V�������{�l��GFR���Z���v�K�p�ׁ̈A�C�� End   ####%>

                            </TR>
                
                </TABLE>
            </TD>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="30" HEIGHT="1" ALT=""></TD>
                <TD VALIGN="top">
                <TABLE>
                    <TR>
                        <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                            <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:saveJud()"><IMAGE SRC="/webHains/images/save.gif" ALT="���͓��e��ۑ����܂�" HEIGHT="24" WIDTH="77" BORDER="0"></A></TD>
                        <%  end if  %>
                    </TR>
                    <TR>
                        <TD ALIGN="right" BGCOLOR="white"><A HREF="javascript:calltotalJudView()">�Q�Ɛ�p��ʂ�</A></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
    <BR>
    <TABLE WIDTH="366" BORDER="0" CELLSPACING="2" CELLPADDING="0">
        <TR>
            <TD>�����R�����g</TD>
            <TD VALIGN="top"></TD>
        </TR>
        <TR>
            <INPUT TYPE="hidden" NAME="editTtlCnt" VALUE="<%= lngEditCmtCnt %>">
            <INPUT TYPE="hidden" NAME="orgCmtCnt" VALUE="<%= lngTtlCmtCnt %>">
            <INPUT TYPE="hidden" NAME="editCmtSeq">
            <INPUT TYPE="hidden" NAME="editTtlCmtCd" >
            <INPUT TYPE="hidden" NAME="editJudCmtstc">
            <INPUT TYPE="hidden" NAME="editJudCmtClassCd">
            <INPUT TYPE="hidden" NAME="editTtlJudCd" >
            <INPUT TYPE="hidden" NAME="editTtlWeight" >
            <TD>
            <SELECT STYLE="width:600px" NAME="selectLine" SIZE="20">

<%
            For i = 0 To lngTtlCmtCnt - 1
%>
<!-- SEQ�͕K�������A�Ԃł͂Ȃ� 2004.01.13
            <OPTION VALUE="<%= vntCmtSeq(i) %>"><%= vntTtlJudCmtstc(i) %></OPTION>
-->
            <OPTION VALUE="<%= i + 1 %>"><%= vntTtlJudCmtstc(i) %></OPTION>
<%
            Next
%>
            </SELECT></TD>
<%
            For i = 0 To lngTtlCmtCnt - 1
%>
            <INPUT TYPE="hidden" NAME="orgCmtSeq" VALUE="<%= vntCmtSeq(i) %>">
            <INPUT TYPE="hidden" NAME="orgTtlJudCmtCd" VALUE="<%= vntTtlJudCmtCd(i) %>">
            <INPUT TYPE="hidden" NAME="orgTtlJudCmtstc" VALUE="<%= vntTtlJudCmtstc(i) %>">
            <INPUT TYPE="hidden" NAME="orgTtlJudClassCd" VALUE="<%= vntTtlJudClassCd(i) %>">
            <INPUT TYPE="hidden" NAME="orgTtlJudCd" VALUE="<%= vntTtlJudCd(i) %>">
            <INPUT TYPE="hidden" NAME="orgTtlWeight" VALUE="<%= vntTtlWeight(i) %>">
<%
            Next

%>
            <TD VALIGN="top">
                <TABLE WIDTH="64" BORDER="1" CELLSPACING="2" CELLPADDING="0">
                    <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                        <TR>
                            <TD ALIGN="center"><A HREF="javascript:showJudCommentWindow(document.resultList.selectLine.value,0,'add')">�ǉ�</A></TD>
                        </TR>
                        <TR>
                            <TD ALIGN="center"><A HREF="javascript:showJudCommentWindow(document.resultList.selectLine.value,0,'insert')">�}��</A></TD>
                        </TR>
                        <TR>
                            <TD ALIGN="center"><A HREF="javascript:showJudCommentWindow(document.resultList.selectLine.value,0,'edit')">�C��</A></TD>
                        </TR>
                        <TR>
                            <TD ALIGN="center"><A HREF="javascript:deleteJudComment(document.resultList.selectLine.value, 1)">�폜</A></TD>
                        </TR>
                    <%  end if  %>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
</FORM>
<SCRIPT TYPE="text/javascript">
<!--
    if ( orgSetFlg != 1 ) {
        editCmtSet();
    }

//-->
</SCRIPT>
</BODY>
</HTML>
