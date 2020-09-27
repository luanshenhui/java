<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'      �t�H���[�A�b�v�i�񎟌��f�^���t�@�[�\�����ʁj (Ver0.0.1)
'      AUTHER  : T.Yaguchi@orbsys.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/InterviewEditDropDown.inc" -->
<!-- #include virtual = "/webHains/includes/EditJudClassList.inc" -->
<!-- #include virtual = "/webHains/includes/editCsGrp.inc"   -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
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
Dim objFollowUp         '�t�H���[�A�b�v�A�N�Z�X�p
Dim objSentence         '���͏��A�N�Z�X�p

Dim strUpdMode          '�ۑ����[�h(INS,UPD)
Dim strAct              '�������
Dim strCmtMode          '�����R�����g�������[�h
Dim strWinMode          '�E�C���h�E�\�����[�h�i1:�ʃE�C���h�E�A0:���E�C���h�E�j
Dim strGrpCd            '�O���[�v�R�[�h

Dim lngRsvNo            '�\��ԍ��i���񕪁j
Dim strCsCd             '�R�[�X�R�[�h�i���񕪁j

Dim lngStrYear          '��f��(��)(�N)
Dim lngStrMonth         '��f��(��)(��)
Dim lngStrDay           '��f��(��)(��)

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

Dim strFollowUpFlg      '�t�H���[�Ώێ҃t���O
Dim strFollowCardFlg    '�͂����o�̓t���O
Dim strUpdDate          '�X�V����
Dim strUpdUserName      '�X�V�Җ�

Dim vntRsvNo            '�\��ԍ�
Dim vntJudClassCd       '���蕪�ރR�[�h
Dim vntJudClassName     '���蕪�ޖ���
Dim vntJudCd            '����R�[�h
Dim vntJudSName         '���藪��
Dim vntWeight           '����d��
Dim vntWebColor         '�\���F
Dim vntUpdUser          '�X�V��
Dim vntUpdFlg           '�X�V�t���O   
Dim vntResultDispMode   '�������ʕ\�����[�h
Dim vntJudCmtCd         '����R�����g�R�[�h
Dim vntJudCmtstc        '����R�����g����
Dim vntSecCslDate       '�񎟌�����f��
Dim vntComeFlg          '���@�t���O
Dim vntRsvInfoCd        '�\����R�[�h
Dim vntJudCd2           '����R�[�h�i�t�H���[�j
Dim vntQuestionCd       '�A���P�[�g�R�[�h
Dim vntFolNote          '�m�[�g
Dim vntDelFlg           '�폜�t���O
Dim vntSecItemCd        '�Ώی����R�[�h
Dim vntArrSecItemCd     '�Ώی����R�[�h
Dim lngArrSecItemCd     '�Ώی����R�[�h��

Dim lngJudClassCount    '���蕪�ތ���
Dim lngLastJudClassCd   '�O���蕪�ރR�[�h

Dim lngCount            '����
Dim lngAllCount         '����

Dim lngDspPoint         '�\���ʒu

'���茋�ʕҏW�p�̈�
Dim vntEditJudClassCd   '���蕪�ރR�[�h
Dim vntEditJudCd        '����R�[�h
Dim vntEditJudCmtCd     '����R�����g�R�[�h

'�X�V���O�̍��ڏ��
Dim vntUpdRsvNo         '�\��ԍ�
Dim vntUpdFollowUpFlg   '�t�H���[�Ώێ҃t���O
Dim vntUpdFollowCardFlg '�͂����o�̓t���O
Dim vntUpdJudClassCd    '���蕪�ރR�[�h
Dim vntUpdJudClassName  '���蕪�ޖ���
Dim vntUpdJudCd         '����R�[�h
Dim vntUpdSecCslDate    '�񎟌�����f��
Dim vntUpdComeFlg       '���@�t���O
Dim vntUpdRsvInfoCd     '�\����R�[�h
Dim vntUpdJudCd2        '����R�[�h�i�t�H���[�j
Dim vntUpdQuestionCd    '�A���P�[�g�R�[�h
Dim vntUpdFolNote       '�m�[�g
Dim vntUpdSecItemCd     '�Ώی����R�[�h
Dim vntUpdArrSecItemCd  '�Ώی����R�[�h
Dim lngUpdArrSecItemCd  '�Ώی����R�[�h��
Dim lngUpdCount         '�X�V���ڐ�

'�폜����̍��ڏ��
Dim vntDelRsvNo             '�\��ԍ�
Dim vntDelJudClassCd()      '���蕪�ރR�[�h
Dim vntDelSecItemCd()       '�Ώی����R�[�h
Dim vntDelArrSecItemCd()    '�Ώی����R�[�h
Dim lngDelArrSecItemCd      '�Ώی����R�[�h��
Dim lngDelCount             '�폜���ڐ�
Dim blnDelSecItemCd         '�Ώی����R�[�h�폜�t���O

'�O����R�[�X�R���{�{�b�N�X
Dim strArrLastCsGrp()       '�R�[�X�O���[�v�R�[�h
Dim strArrLastCsGrpName()   '�R�[�X�O���[�v����

'����R���{�{�b�N�X
Dim strArrJudCdSeq      '����A��
Dim strArrJudCd         '����R�[�h
Dim strArrWeight        '����p�d��
Dim lngJudListCnt       '���茏��

Dim strStcCd            '���̓R�[�h
Dim strShortStc         '����

Dim i               '���[�v�J�E���^
Dim j               '���[�v�J�E���^
Dim k               '���[�v�J�E���^
Dim l               '���[�v�J�E���^
Dim Ret             '���A�l

Dim strArrMessage   '�G���[���b�Z�[�W
Dim lngPageKey      '��������
Dim lngJudClKey     '��������

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objHainsUser    = Server.CreateObject("HainsHainsUser.HainsUser")
Set objInterview    = Server.CreateObject("HainsInterview.Interview")
Set objJud          = Server.CreateObject("HainsJud.Jud")
Set objJudgement    = Server.CreateObject("HainsJudgement.Judgement")
Set objFollowUp     = Server.CreateObject("HainsFollowUp.FollowUp")
Set objSentence     = Server.CreateObject("HainsSentence.Sentence")

'�����l�̎擾
strUpdMode      = Request("updMode")
strAct          = Request("action")
strCmtMode      = Request("cmtmode")

lngRsvNo        = Request("rsvno")
strCsCd         = Request("cscd")
strWinMode      = Request("winmode")
strGrpCd        = Request("grpcd")

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

'�����\�����̔���
strFollowUpFlg      = IIF(Request("followUpFlg")="", 0, Request("followUpFlg"))
strFollowCardFlg    = IIF(Request("followCardFlg")="", 0, Request("followCardFlg"))
vntJudClassCd       = ConvIStringToArray(Request("judClassCd"))
vntJudClassName     = ConvIStringToArray(Request("judClassName"))
vntJudCd            = ConvIStringToArray(Request("judCd"))
vntSecCslDate       = ConvIStringToArray(Request("secCslDate"))
vntComeFlg          = ConvIStringToArray(Request("comeFlg"))
vntSecItemCd        = ConvIStringToArray(Request("secItemCd"))
vntRsvInfoCd        = ConvIStringToArray(Request("rsvInfoCd"))
vntJudCd2           = ConvIStringToArray(Request("judCd2"))
vntQuestionCd       = ConvIStringToArray(Request("questionCd"))
vntFolNote          = ConvIStringToArray(Request("folNote"))
vntDelFlg           = ConvIStringToArray(Request("delFlg"))
lngCount            = CLng(Request("orgCount"))
lngPageKey          = Request("pageKey")
lngJudClKey         = Request("judClKey")

'����擾
Call EditJudListInfo

Do
    
    '�ۑ�
    If strAct = "save"  Then
        
        '�t�H���[�̕ۑ�
        If strArrMessage = ""  Then
            lngDelCount = 0
'           If strUpdMode = "UPD" Then
'               '��x�ۑ����Ă���ꍇ�͒��O�̃t�H���[�󋵊Ǘ��𒊏o����B
'               lngCount = objFollowUp.SelectFollow_I(lngRsvNo,           vntUpdJudCd,        _
'                                                 vntUpdJudClassCd,   vntUpdJudClassName, _
'                                                 vntUpdSecCslDate,   vntUpdComeFlg,      _
'                                                 vntUpdRsvInfoCd,    vntUpdJudCd2,       _
'                                                 vntUpdQuestionCd,   vntUpdFolNote,      _
'                                     vntUpdSecItemCd _
'                                                )
'               '�폜����ׂ��Ώی����R�[�h�𒊏o����B
'               '��ʏ�̍��ڂƒ��O�ɓǍ��񂾍��ڂŔ�r����B
'               i = 0
'               Do Until i > lngCount - 1
'                   '�Ώی����R�[�h�����݂���ꍇ�̂ݏ�������
'                   IF vntUpdSecItemCd(i) <> "" Then
'                       vntUpdArrSecItemCd = Split(vntUpdSecItemCd(i),"Z")
'                       lngUpdArrSecItemCd = Ubound(vntUpdArrSecItemCd)
'                       lngArrSecItemCd = -1
'                       j = 0
'                       Do Until j > Ubound(vntJudClassCd)
'                           If vntUpdJudClassCd(i) = vntJudClassCd(j) Then
'                               IF vntSecItemCd(j) <> "" Then
'                                   vntArrSecItemCd = Split(vntSecItemCd(j),"Z")
'                                   lngArrSecItemCd = Ubound(vntArrSecItemCd)
'                               End If
'                               Exit Do
'                           End If
'                           j = j + 1
'                       Loop
'                       lngDelArrSecItemCd = 0
'                       k = 0
'                       Do Until k > lngUpdArrSecItemCd
'                           blnDelSecItemCd = True
'                           l = 0
'                           Do Until l > lngArrSecItemCd
'                               If vntUpdArrSecItemCd(k) = vntArrSecItemCd(l) Then
'                                   blnDelSecItemCd = False
'                                   Exit Do
'                               End If
'                               l = l + 1
'                           Loop
'                           '���O�̍��ڂ���ʏ�̍��ڂɑ��݂��Ȃ��ꍇ�͍폜����B
'                           If blnDelSecItemCd = True Then
'                               Redim Preserve vntDelArrSecItemCd(lngDelArrSecItemCd)
'                               vntDelArrSecItemCd(lngDelArrSecItemCd) = vntUpdArrSecItemCd(k)
'                               lngDelArrSecItemCd = lngDelArrSecItemCd + 1
'                           End If
'                           k = k + 1
'                       Loop
'                       '�폜���ڂ��P���ȏ゠��ꍇ�͒ǉ��B
'                       If lngDelArrSecItemCd > 0 Then
'                           Redim Preserve vntDelJudClassCd(lngDelCount)
'                           Redim Preserve vntDelSecItemCd(lngDelCount)
'                           vntDelJudClassCd(lngDelCount) = vntUpdJudClassCd(i)
'                           vntDelSecItemCd(lngDelCount) = Join(vntDelArrSecItemCd, ",")
'                           lngDelCount = lngDelCount + 1
'                       End If
'                   End If
'                   i = i + 1
'               Loop
'           End If
'
'           '�X�V�Ώۃf�[�^�����݂���Ƃ��̂ݔ��茋�ʕۑ�
'           If ( lngUpdCount > 0 ) Then
                Ret = objFollowUp.SaveFollow(lngRsvNo, strFollowUpFlg, strFollowCardFlg, _
                                     vntJudClassCd, vntSecCslDate, vntComeFlg, _
                                     vntRsvInfoCd, vntJudCd2, vntQuestionCd, _
                                     vntFolNote, vntSecItemCd, vntDelFlg, _
                                     Session.Contents("userId"))
                If Ret = True Then
                    strAct = "saveend"
                Else
                    strArrMessage = "�ۑ��Ɏ��s���܂���"
                End If
'           Else
'               strAct = ""
'           End If
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

    '�t�H���[�ΏێҊǗ�����Ǎ���
    Ret = objFollowUp.SelectFollow(lngRsvNo, strFollowUpFlg, strFollowCardFlg, strUpdDate, , strUpdUserName)
    If Ret = True Then
        strUpdMode = "UPD"
        '��x�ۑ����Ă���ꍇ�̓t�H���[�󋵊Ǘ����璊�o����B
'        lngCount = objFollowUp.SelectFollow_I(lngRsvNo,        vntJudCd,        _
'                                          vntJudClassCd,   vntJudClassName, _
'                                          vntSecCslDate,   vntComeFlg,      _
'                                          vntRsvInfoCd,    vntJudCd2,       _
'                                          vntQuestionCd,   vntFolNote,      _
'                              vntSecItemCd _
'                                         )

        lngCount = objFollowUp.SelectJudClFollow_I(lngRsvNo,    lngJudClKey,    vntJudCd,        _
                                          vntJudClassCd,   vntJudClassName, _
                                          vntSecCslDate,   vntComeFlg,      _
                                          vntRsvInfoCd,    vntJudCd2,       _
                                          vntQuestionCd,   vntFolNote,      _
                              vntSecItemCd _
                                         )

        If lngPageKey = 1 Then
            lngAllCount = lngCount
            '���������ɏ]�����茋�ʈꗗ�𒊏o����
'            lngCount = objFollowUp.SelectJudHistoryRslList( _
'                                                        lngRsvNo, _
'                                                         , _
'                                                         , _
'                                                        vntUpdRsvNo, _
'                                                        vntUpdJudClassCd, _
'                                                        vntUpdJudClassName, _
'                                                        vntUpdJudCd, _
'                                                        , _
'                                                        , _
'                                                        , _
'                                                        , , _
'                                                        , _
'                                                        , _
'                                                        vntUpdSecCslDate, _
'                                                        vntUpdComeFlg, _
'                                                        vntUpdRsvInfoCd, _
'                                                        vntUpdJudCd2, _
'                                                        vntUpdQuestionCd, _
'                                                        vntUpdFolNote, _
'                                                        vntUpdSecItemCd _
'                                                        )

            lngCount = objFollowUp.SelectJudRslList( _
                                                        lngRsvNo, _
                                                        lngJudClKey, _
                                                         , _
                                                         , _
                                                        vntUpdRsvNo, _
                                                        vntUpdJudClassCd, _
                                                        vntUpdJudClassName, _
                                                        vntUpdJudCd, _
                                                        , _
                                                        , _
                                                        , _
                                                        , , _
                                                        , _
                                                        , _
                                                        vntUpdSecCslDate, _
                                                        vntUpdComeFlg, _
                                                        vntUpdRsvInfoCd, _
                                                        vntUpdJudCd2, _
                                                        vntUpdQuestionCd, _
                                                        vntUpdFolNote, _
                                                        vntUpdSecItemCd _
                                                        )

            i = 0
            Do Until i > lngCount - 1
                Ret = False
                j = 0
                Do Until j > lngAllCount - 1
'                   If vntUpdRsvNo(i) = vntRsvNo(j) And _
'                      vntUpdJudClassCd(i) = vntJudClassCd(j) Then
                    If vntUpdJudClassCd(i) = vntJudClassCd(j) Then

                        Ret = True
                        Exit Do
                    End If
                    j = j + 1
                Loop
                ''���蕪�ނ̏d�����̂��t�H���[�󋵊Ǘ��ɂȂ��ꍇ�͒ǉ�����B
                If Ret = False Then
                    '�t�H���[�󋵊Ǘ����P�����Ȃ��ꍇ�͋�ɂȂ��Ă���הz��^�ɂ���
                    If lngAllCount <= 0 Then
                        vntJudCd = Array()
                                vntJudClassCd = Array()
                        vntJudClassName = Array()
                        vntSecCslDate = Array()
                        vntComeFlg = Array()
                        vntRsvInfoCd = Array()
                        vntJudCd2 = Array()
                        vntQuestionCd = Array()
                        vntFolNote = Array()
                        vntSecItemCd = Array()
                    End If
                    Redim Preserve vntJudCd(lngAllCount)
                            Redim Preserve vntJudClassCd(lngAllCount)
                    Redim Preserve vntJudClassName(lngAllCount)
                    Redim Preserve vntSecCslDate(lngAllCount)
                    Redim Preserve vntComeFlg(lngAllCount)
                    Redim Preserve vntRsvInfoCd(lngAllCount)
                    Redim Preserve vntJudCd2(lngAllCount)
                    Redim Preserve vntQuestionCd(lngAllCount)
                    Redim Preserve vntFolNote(lngAllCount)
                    Redim Preserve vntSecItemCd(lngAllCount)

                    vntJudCd(lngAllCount) = vntUpdJudCd(i)
                            vntJudClassCd(lngAllCount) = vntUpdJudClassCd(i)
                    vntJudClassName(lngAllCount) = vntUpdJudClassName(i)
                    vntSecCslDate(lngAllCount) = vntUpdSecCslDate(i)
                    vntComeFlg(lngAllCount) = vntUpdComeFlg(i)
                    vntRsvInfoCd(lngAllCount) = vntUpdRsvInfoCd(i)
                    vntJudCd2(lngAllCount) = vntUpdJudCd2(i)
                    vntQuestionCd(lngAllCount) = vntUpdQuestionCd(i)
                    vntFolNote(lngAllCount) = vntUpdFolNote(i)
                    vntSecItemCd(lngAllCount) = vntSecItemCd(i)
                    lngAllCount = lngAllCount + 1
                End If
                i = i + 1
            Loop
            lngCount = lngAllCount
        End If

    Else
    '��x���ۑ����Ă��Ȃ��ꍇ�͔��茋�ʂ��画��̏d�����̂𒊏o����B
        strUpdMode = "INS"
        '���������ɏ]�����茋�ʈꗗ�𒊏o����
'        lngCount = objFollowUp.SelectJudHistoryRslList( _
'                                                    lngRsvNo, _
'                                                     , _
'                                                     , _
'                                                    vntRsvNo, _
'                                                    vntJudClassCd, _
'                                                    vntJudClassName, _
'                                                    vntJudCd, _
'                                                    vntJudSName, _
'                                                    vntWeight, _
'                                                    vntUpdUser, _
'                                                    vntJudCmtCd, , _
'                                                    vntResultDispMode, _
'                                                    vntUpdFlg, _
'                                                    vntSecCslDate, _
'                                                    vntComeFlg, _
'                                                    vntRsvInfoCd, _
'                                                    vntJudCd2, _
'                                                    vntQuestionCd, _
'                                                    vntFolNote, _
'                                                    vntSecItemCd _
'                                                    )

        lngCount = objFollowUp.SelectJudRslList( _
                                                    lngRsvNo, _
                                                    lngJudClKey, _
                                                     , _
                                                     , _
                                                    vntRsvNo, _
                                                    vntJudClassCd, _
                                                    vntJudClassName, _
                                                    vntJudCd, _
                                                    vntJudSName, _
                                                    vntWeight, _
                                                    vntUpdUser, _
                                                    vntJudCmtCd, , _
                                                    vntResultDispMode, _
                                                    vntUpdFlg, _
                                                    vntSecCslDate, _
                                                    vntComeFlg, _
                                                    vntRsvInfoCd, _
                                                    vntJudCd2, _
                                                    vntQuestionCd, _
                                                    vntFolNote, _
                                                    vntSecItemCd _
                                                    )
    End If
'   If lngCount <= 0 Then
'       Err.Raise 1000, , "���茋�ʂ�����܂���BRsvNo= " & lngRsvNo
'   End If
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
                                         , , strArrWeight	)

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
<TITLE>�񎟌��f�^���t�@�[�\����</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!-- #include virtual = "/webHains/includes/stcGuide.inc"    -->
<!-- #include virtual = "/webHains/includes/folGuide.inc"    -->
<!--
var lngSelectedIndex1;  // �K�C�h�\�����ɑI�����ꂽ�G�������g�̃C���f�b�N�X
var winRslFol;
// �t�H���[�K�C�h�Ăяo��
function callFolGuide( index ) {

    var myForm = document.resultList;

    // �I�����ꂽ�G�������g�̃C���f�b�N�X��ޔ�(���̓R�[�h�E�����͂̃Z�b�g�p�֐��ɂĎg�p����)
    lngSelectedIndex1 = index;

    // �K�C�h��ʂ̘A����ɔ��蕪�ރR�[�h��ݒ肷��
    if ( myForm.judClassCd.length != null ) {
        folGuide_JudClassCd = myForm.judClassCd[ index ].value;
    } else {
        folGuide_JudClassCd = myForm.judClassCd.value;
    }

    // �K�C�h��ʂ̘A����Ɍ��f���ڂ�ݒ肷��
    if ( myForm.judClassName.length != null ) {
        folGuide_JudClassName = myForm.judClassName[ index ].value;
    } else {
        folGuide_JudClassName = myForm.judClassName.value;
    }

    // �K�C�h��ʂ̘A����ɔ���i�W���j��ݒ肷��
    if ( myForm.judCd.length != null ) {
        folGuide_JudCd = myForm.judCd[ index ].value;
    } else {
        folGuide_JudCd = myForm.judCd.value;
    }

    // �K�C�h��ʂ̘A����ɓ񎟌������i�W���j��ݒ肷��
    if ( myForm.secCslDate.length != null ) {
        folGuide_SecCslDate = myForm.secCslDate[ index ].value;
    } else {
        folGuide_SecCslDate = myForm.secCslDate.value;
    }

    // �K�C�h��ʂ̘A����ɏ󋵁i�W���j��ݒ肷��
    if ( myForm.comeFlg.length != null ) {
        folGuide_ComeFlg = myForm.comeFlg[ index ].value;
    } else {
        folGuide_ComeFlg = myForm.comeFlg.value;
    }

    // �K�C�h��ʂ̘A����Ɍ������ځi�W���j��ݒ肷��
    if ( myForm.secItemCd.length != null ) {
        folGuide_SecItemCd = myForm.secItemCd[ index ].value;
    } else {
        folGuide_SecItemCd = myForm.secItemCd.value;
    }

    // �K�C�h��ʂ̘A����ɗ\����i�W���j��ݒ肷��
    if ( myForm.rsvInfoCd.length != null ) {
        folGuide_RsvInfoCd = myForm.rsvInfoCd[ index ].value;
    } else {
        folGuide_RsvInfoCd = myForm.rsvInfoCd.value;
    }

    // �K�C�h��ʂ̘A����Ɍ��ʁi�W���j��ݒ肷��
    if ( myForm.judCd2.length != null ) {
        folGuide_JudCd2 = myForm.judCd2[ index ].value;
    } else {
        folGuide_JudCd2 = myForm.judCd2.value;
    }

    // �K�C�h��ʂ̘A����ɃA���P�[�g�i�W���j��ݒ肷��
    if ( myForm.questionCd.length != null ) {
        folGuide_QuestionCd = myForm.questionCd[ index ].value;
    } else {
        folGuide_QuestionCd = myForm.questionCd.value;
    }

    // �K�C�h��ʂ̘A����ɔ��l�i�W���j��ݒ肷��
    if ( myForm.folNote.length != null ) {
        folGuide_FolNote = myForm.folNote[ index ].value;
    } else {
        folGuide_FolNote = myForm.folNote.value;
    }

    // �K�C�h��ʂ̘A����ɃK�C�h��ʂ���Ăяo����鎩��ʂ̊֐���ݒ肷��
    folGuide_CalledFunction = setFolInfo;

    // ���̓K�C�h�\��
    showGuideFol();
}

// ���̓R�[�h�E�����͂̃Z�b�g
function setFolInfo() {

    setFol( lngSelectedIndex1, folGuide_JudClassCd, folGuide_JudClassName, folGuide_JudCd, folGuide_SecCslDate, folGuide_ComeFlg, folGuide_SecItemCd, folGuide_RsvInfoCd, folGuide_JudCd2, folGuide_QuestionCd, folGuide_FolNote, folGuide_FolName1, folGuide_FolName2, folGuide_FolName3, folGuide_FolName4, folGuide_FolName5, folGuide_RsvInfoName, folGuide_QuestionName);

}

// ���͂̕ҏW
function setFol( index, judClassCd, judClassName, judCd, secCslDate, comeFlg, secItemCd, rsvInfoCd, judCd2, questionCd, folNote, folName1, folName2, folName3, folName4, folName5, rsvInfoName, questionName) {

    var myForm = document.resultList;   // ����ʂ̃t�H�[���G�������g
    var objSecCslDate, objComeFlg;      // �񎟌������E�󋵂̃G�������g
    var objSecItemCd, objRsvInfoCd;     // �������ځE�\����̃G�������g
    var objJudCd2, objQuestionCd;       // ���ʁE�A���P�[�g�̃G�������g
    var objFolNote;                     // ���l�̃G�������g
    var folNameElement;                 // �������ږ��̃G�������g
    var comeName;                       // �������ږ��̃G�������g

    // �ҏW�G�������g�̐ݒ�
    if ( myForm.judClassName.length != null ) {
        objSecCslDate = myForm.secCslDate[ index ];
        objComeFlg = myForm.comeFlg[ index ];
        objSecItemCd = myForm.secItemCd[ index ];
        objRsvInfoCd = myForm.rsvInfoCd[ index ];
        objJudCd2 = myForm.judCd2[ index ];
        objQuestionCd = myForm.questionCd[ index ];
        objFolNote = myForm.folNote[ index ];
    } else {
        objSecCslDate = myForm.secCslDate;
        objComeFlg = myForm.comeFlg;
        objSecItemCd = myForm.secItemCd;
        objRsvInfoCd = myForm.rsvInfoCd;
        objJudCd2 = myForm.judCd2;
        objQuestionCd = myForm.questionCd;
        objFolNote = myForm.folNote;
    }

    // �l�̕ҏW
    objSecCslDate.value = secCslDate;
    objComeFlg.value = comeFlg;
    objSecItemCd.value = secItemCd;
    objRsvInfoCd.value = rsvInfoCd;
    objJudCd2.value = judCd2;
    objQuestionCd.value = questionCd;
    objFolNote.value = folNote;

    folNameElement = 'secCslDateName' + judClassCd;
    if ( document.getElementById(folNameElement) ) {
        document.getElementById(folNameElement).innerHTML = secCslDate;
    }
    comeName = ''
    if ( comeFlg == '1' ) {
        comeName = '���@'
    }
    folNameElement = 'comeFlgName' + judClassCd;
    if ( document.getElementById(folNameElement) ) {
        document.getElementById(folNameElement).innerHTML = comeName;
    }
    folNameElement = 'judCd2Name' + judClassCd;
    if ( document.getElementById(folNameElement) ) {
        document.getElementById(folNameElement).innerHTML = judCd2;
    }
    folNameElement = 'folNoteName' + judClassCd;
    if ( document.getElementById(folNameElement) ) {
        document.getElementById(folNameElement).innerHTML = folNote;
    }


    folNameElement = 'folName' + judClassCd + '0';
    if ( document.getElementById(folNameElement) ) {
        document.getElementById(folNameElement).innerHTML = folName1;
    }
    folNameElement = 'folName' + judClassCd + '1';
    if ( document.getElementById(folNameElement) ) {
        document.getElementById(folNameElement).innerHTML = folName2;
    }
    folNameElement = 'folName' + judClassCd + '2';
    if ( document.getElementById(folNameElement) ) {
        document.getElementById(folNameElement).innerHTML = folName3;
    }
    folNameElement = 'folName' + judClassCd + '3';
    if ( document.getElementById(folNameElement) ) {
        document.getElementById(folNameElement).innerHTML = folName4;
    }
    folNameElement = 'folName' + judClassCd + '4';
    if ( document.getElementById(folNameElement) ) {
        document.getElementById(folNameElement).innerHTML = folName5;
    }

    folNameElement = 'rsvInfoName' + judClassCd;
    if ( document.getElementById(folNameElement) ) {
        document.getElementById(folNameElement).innerHTML = rsvInfoName;
    }
    folNameElement = 'questionName' + judClassCd;
    if ( document.getElementById(folNameElement) ) {
        document.getElementById(folNameElement).innerHTML = questionName;
    }

}

// �`�F�b�N�{�b�N�X�̒l����
function setCheck(index, selObj) {

    var myForm = document.resultList;	// ����ʂ̃t�H�[���G�������g

    if ( myForm.delFlg.length != null ) {
        if (selObj.checked) {
            myForm.delFlg[index].value = '1'
        } else {
            myForm.delFlg[index].value = '0'
        }
    } else {
        if (selObj.checked) {
            myForm.delFlg.value = '1'
        } else {
            myForm.delFlg.value = '0'
        }
    }

}

// �T�u��ʂ����
function closeWindow() {

    // �t�H���[�K�C�h�����
    closeGuideFol();

}

function showFollowRsl(rsvNo, index) {

    var opened = false; // ��ʂ��J����Ă��邩
    var url;            // URL������
    var myForm = document.resultList;
    var judClassCd;
    var judClassName;
    var judCd;

    // ���łɃK�C�h���J����Ă��邩�`�F�b�N
    if ( winRslFol != null ) {
        if ( !winRslFol.closed ) {
            opened = true;
        }
    }

    // �K�C�h��ʂ̘A����ɔ��蕪�ރR�[�h��ݒ肷��
    if ( myForm.judClassCd.length != null ) {
        judClassCd = myForm.judClassCd[ index ].value;
    } else {
        judClassCd = myForm.judClassCd.value;
    }

    // �K�C�h��ʂ̘A����Ɍ��f���ڂ�ݒ肷��
    if ( myForm.judClassName.length != null ) {
        judClassName = myForm.judClassName[ index ].value;
    } else {
        judClassName = myForm.judClassName.value;
    }

    // �K�C�h��ʂ̘A����ɔ���i�W���j��ݒ肷��
    if ( myForm.judCd.length != null ) {
        judCd = myForm.judCd[ index ].value;
    } else {
        judCd = myForm.judCd.value;
    }

    // ���̓K�C�h��URL�ҏW
    url = 'followupRslEditBody.asp?winmode=1&rsvno='+rsvNo+'&judClassCd=' + judClassCd+'&judClassName=' + judClassName+'&judCd=' + judCd;

    // �J����Ă���ꍇ�͉�ʂ�REPLACE���A�����Ȃ��ΐV�K��ʂ��J��
    if ( opened ) {
        winRslFol.focus();
        winRslFol.location.replace(url);
    } else {
        winRslFol = window.open(url, '', 'width=1000,height=700,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
    }
}


//-->
</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">
<FORM NAME="resultList" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">

    <INPUT TYPE="hidden" NAME="updMode"     VALUE="<%= strUpdMode %>">
    <INPUT TYPE="hidden" NAME="action"      VALUE="<%= strAct %>">
    <INPUT TYPE="hidden" NAME="cmtmode"     VALUE="<%= strCmtMode %>">
    <INPUT TYPE="hidden" NAME="rsvno"       VALUE="<%= lngRsvNo %>">
    <INPUT TYPE="hidden" NAME="cscd"        VALUE="<%= strCsCd %>">
    <INPUT TYPE="hidden" NAME="winmode"     VALUE="<%= strWinMode %>">
    <INPUT TYPE="hidden" NAME="grpcd"       VALUE="<%= strGrpCd %>">
    <INPUT TYPE="hidden" NAME="followUpFlg" VALUE="<%= strFollowUpFlg %>">
    <INPUT TYPE="hidden" NAME="followCardFlg" VALUE="<%= strFollowCardFlg %>">
    <INPUT TYPE="hidden" NAME="pageKey"     VALUE="<%= lngPageKey %>">

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
                        <TD NOWRAP COLSPAN="1" WIDTH="50">�폜</TD>
                        <TD NOWRAP COLSPAN="1" WIDTH="80">���f����</TD>
                        <TD NOWRAP COLSPAN="1" WIDTH="50">����</TD>
                        <TD NOWRAP COLSPAN="1" WIDTH="100">�񎟌�����</TD>
                        <TD NOWRAP COLSPAN="1" WIDTH="80">��</TD>
                        <TD NOWRAP COLSPAN="1" WIDTH="100">��������</TD>
                        <TD NOWRAP COLSPAN="1" WIDTH="100">�\����</TD>
                        <TD NOWRAP COLSPAN="1" WIDTH="40">����</TD>
                        <TD NOWRAP COLSPAN="1" WIDTH="100">�A���P�[�g</TD>
                        <TD NOWRAP COLSPAN="1" WIDTH="300">���l</TD>
                    </TR>
<%
                    lngJudClassCount = 0
                    lngLastJudClassCd = 0
                    lngDspPoint = 0
                    For i = 0 To lngCount - 1
%>
                        <TR>
                        <TD><INPUT TYPE="checkbox" NAME="delFlgChk" VALUE="1" ONCLICK="javascript:setCheck(<%= i %>,this)"><INPUT TYPE="hidden" NAME="delFlg"></TD>
                        <INPUT TYPE="hidden" NAME="judClassCd" VALUE="<%= vntJudClassCd(i) %>">
                        <!--TD><INPUT TYPE="hidden" NAME="judClassName" VALUE="<%= vntJudClassName(i) %>"><A HREF="javascript:callFolGuide(<%= i %>)"><%= vntJudClassName(i) %></A></TD-->
                        <TD><INPUT TYPE="hidden" NAME="judClassName" VALUE="<%= vntJudClassName(i) %>"><A HREF="javascript:showFollowRsl(<%= lngRsvNo %>, <%= i %>)"><%= vntJudClassName(i) %></A></TD>
                        <TD ALIGN="center"><INPUT TYPE="hidden" NAME="judCd" VALUE="<%= vntJudCd(i) %>"><%= vntJudCd(i) %></TD>
                        <TD><INPUT TYPE="hidden" NAME="secCslDate" VALUE="<%= vntSecCslDate(i) %>"><SPAN ID="secCslDateName<%= vntJudClassCd(i) %>"><%= vntSecCslDate(i) %></SPAN></TD>
                        <TD><INPUT TYPE="hidden" NAME="comeFlg" VALUE="<%= vntComeFlg(i) %>"><SPAN ID="comeFlgName<%= vntJudClassCd(i) %>"><%= IIf(vntComeFlg(i) = "1", "���@","") %></SPAN></TD>
<%
                        IF vntSecItemCd(i) <> "" Then
                            vntArrSecItemCd = Split(vntSecItemCd(i),"Z")
                            lngArrSecItemCd = Ubound(vntArrSecItemCd)
%>
                            <TD><INPUT TYPE="hidden" NAME="secItemCd" VALUE="<%= vntSecItemCd(i) %>">
                                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
<%
                                For j = 0 To lngArrSecItemCd
                                    strShortstc = ""
                                    Ret = objSentence.SelectSentence("89001", 0, vntArrSecItemCd(j), strShortstc)
%>
                                <TR><TD><SPAN ID="folName<%= vntJudClassCd(i) & j %>"><%= strShortstc %></SPAN></TD></TR>
<%
                                Next

                                For j = j To 4
%>
                                <TR><TD><SPAN ID="folName<%= vntJudClassCd(i) & j %>"></SPAN></TD></TR>
<%
                                Next
%>
                                </TABLE>
                            </TD>
<%
                        Else
%>
                            <TD><INPUT TYPE="hidden" NAME="secItemCd" VALUE="">
                                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
<%
                                For j = 0 To 4
%>
                                <TR><TD><SPAN ID="folName<%= vntJudClassCd(i) & j %>"></SPAN></TD></TR>
<%
                                Next
%>
                                </TABLE>
                            </TD>
<%
                        End If
                        strShortstc = ""
                        Ret 		= objSentence.SelectSentence("89002", 0, vntRsvInfoCd(i), strShortstc)
%>
                        <TD><INPUT TYPE="hidden" NAME="rsvInfoCd" VALUE="<%= vntRsvInfoCd(i) %>"><SPAN ID="rsvInfoName<%= vntJudClassCd(i) %>"><%= strShortstc %></SPAN></TD>
                        <TD><INPUT TYPE="hidden" NAME="judCd2" VALUE="<%= vntJudCd2(i) %>"><SPAN ID="judCd2Name<%= vntJudClassCd(i) %>"><%= vntJudCd2(i) %></SPAN></TD>
<%
                        strShortstc = ""
                        Ret = objSentence.SelectSentence("89003", 0, vntQuestionCd(i), strShortstc)
%>
                        <TD><INPUT TYPE="hidden" NAME="questionCd" VALUE="<%= vntQuestionCd(i) %>"><SPAN ID="questionName<%= vntJudClassCd(i) %>"><%= strShortstc %></SPAN></TD>
                        <TD><INPUT TYPE="hidden" NAME="folNote" VALUE="<%= vntFolNote(i) %>"><SPAN ID="folNoteName<%= vntJudClassCd(i) %>"><%= vntFolNote(i) %></SPAN></TD>
                        </TR>
<%
                    Next
%>
                    <INPUT TYPE="hidden" NAME="orgCount" VALUE="<%= lngCount %>">
                </TABLE>
            </TD>
        </TR>
    </TABLE>
</FORM>
<SCRIPT TYPE="text/javascript">
<!--
    var updUserName;
    var updDateName;
    updUserName = '<%= strUpdUserName %>';
    updDateName = '<%= strUpdDate %>';
    parent.updUserSet(updUserName, updDateName);
//	var titleForm  = document.titleForm;	// �w�b�_��ʂ̃t�H�[���G�������g
//	document.getElementById('updUserName').innerHTML = '<%= strUpdUserName %>';
//	document.getElementById('updDateName').innerHTML = '<%= strUpdDate %>';
//-->
</SCRIPT>
</BODY>
</HTML>
