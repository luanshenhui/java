<%@ LANGUAGE="VBScript" %>
<%
'========================================
'�Ǘ��ԍ��FSL-SN-Y0101-007
'�C����  �F2011.11.17
'�S����  �FFJTH)MURTA
'�C�����e�F�ʐڎx����ʁ@�\���s��Ή�
'========================================
'-----------------------------------------------------------------------------
'      ��������i�Q�Ɛ�p��ʁj (Ver0.0.1)
'      AUTHER  : keiko fujii@ffcs.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editCsGrp.inc"   -->
<%
'�Z�b�V�����E�����`�F�b�N
'Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const JUDDOC_GRPCD          = "X049"    '�����O���[�v�R�[�h

'## 2006.01.04  Add By ��  STR) -------------------------------------->
Const GRPCD_DISEASEHISTORY  = "X026"    '�a���O���[�v�R�[�h
Const GRPCD_JIKAKUSYOUJYOU  = "X025"    '���o�Ǐ�O���[�v�R�[�h
'## 2006.01.04  Add By ��  END) -------------------------------------->

Const AUTOJUD_USER      = "AUTOJUD"     '�������胆�[�U
Const CHART_NOTEDIV     = "500"         '�`���[�g���m�[�g���ރR�[�h
Const CAUTION_NOTEDIV   = "100"         '���ӎ����m�[�g���ރR�[�h
Const PUBNOTE_DISPKBN   = 1             '�\���敪�����
Const PUBNOTE_SELINFO   = 0             '������񁁌l�{��f���

'## 2009.10.03 �� �t�H���[�A�b�v���o�^�L���`�F�b�N�̂��ߒǉ�
Const FOLLOW_JUDCLASS   = 999           '�t�H���[�A�b�v���J�E���g�p���蕪�ގqd-��

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon           '���ʃN���X
Dim objHainsUser        '���[�U�[���A�N�Z�X�p
Dim objInterview        '�ʐڏ��A�N�Z�X�p
Dim objResult           '�������ʏ��A�N�Z�X�p
Dim objPubNote          '�m�[�g�N���X
'2004.11.08 ADD STR ORB)T.Yaguchi �t�H���[�ǉ�
Dim objFollowUp         '�t�H���[�A�b�v�A�N�Z�X�p
'2004.11.08 ADD END

Dim objFollow           '�t�H���[�A�b�v�A�N�Z�X�p

'*** 2008.02.26 ���茒�f�ǉ��@STR
Dim objSpecialInterview         '���茒�f���A�N�Z�X�p
'*** 2008.02.26 ���茒�f�ǉ��@END

Dim strAct              '�������
Dim strWinMode          '�E�C���h�E�\�����[�h�i1:�ʃE�C���h�E�A0:���E�C���h�E�j
Dim strGrpCd            '�O���[�v�R�[�h

Dim lngRsvNo            '�\��ԍ��i���񕪁j
Dim strCsCd             '�R�[�X�R�[�h�i���񕪁j

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
Dim vntUpdUser          '�X�V��
Dim vntUpdFlg           '�X�V�t���O�@�@2003.12.26
Dim vntResultDispMode   '�������ʕ\�����[�h
Dim vntJudCmtCd         '����R�����g�R�[�h
Dim vntJudCmtstc        '����R�����g����

'�m�[�g��񌏐��l���p
Dim vntNoteSeq          'seq
Dim vntPubNoteDivCd     '��f���m�[�g���ރR�[�h
Dim vntPubNoteDivName   '��f���m�[�g���ޖ���
Dim vntDefaultDispKbn   '�\���Ώۋ敪�����l
Dim vntOnlyDispKbn      '�\���Ώۋ敪���΂�
Dim vntDispKbn          '�\���Ώۋ敪
Dim vntUpdDate          '�o�^����
Dim vntNoteUpdUser      '�o�^��
Dim vntUserName         '�o�^�Җ�
Dim vntBoldFlg          '�����敪
Dim vntPubNote          '�m�[�g
Dim vntDispColor        '�\���F

Dim lngJudClassCount    '���蕪�ތ���
Dim lngLastJudClassCd   '�O���蕪�ރR�[�h

Dim lngCount            '����

Dim lngDspPoint         '�\���ʒu

Dim vntDocSeq           '�����@����ԍ�
Dim vntDocRsvNo         '�����@�\��ԍ�
Dim vntDocSuffix        '�����@�T�t�B�b�N�X
Dim vntDocItemType      '�����@���ڃR�[�h
Dim vntDocItemName      '�����@���ږ�
Dim vntDocItemCd        '�����R�[�h�i�������ڃR�[�h�j
Dim vntDocterName       '����㎁��
Dim strDocStcCd         '�����R�[�h�i���̓R�[�h�j

Dim lngJudDocCnt        '�����@����

Dim lngDocIndex         '�����o�^�ʒu

'�����R�����g
Dim vntCmtSeq           '�\����
Dim vntTtlJudCmtCd      '����R�����g�R�[�h
Dim vntTtlJudCmtstc     '����R�����g����
Dim vntTtlJudClassCd    '���蕪�ރR�[�h
Dim lngTtlCmtCnt        '�s��

Dim lngChartCnt         '�`���[�g��񌏐�
Dim lngCautionCnt       '���ӎ�������

'2004.11.21 ADD STR ORB)T.Yaguchi �t�H���[�ǉ�
Dim blnFollowFlg        '�t�H���[���݃t���O
'2004.11.21 ADD END

'#### 2008.12.01 �� �t�H���[�A�b�v�Ώێ҃`�F�b�N���W�b�N�ǉ� Start ####
Dim blnFollowTarget     '�t�H���[�Ώێ҃t���O
'#### 2008.12.01 �� �t�H���[�A�b�v�Ώێ҃`�F�b�N���W�b�N�ǉ� End   ####

'#### 2009.10.03 �� �t�H���[�A�b�v�Ώێ҃`�F�b�N���W�b�N�ǉ� Start ####
Dim lngFollowTarget     '�t�H���[�Ώێ҃t���O
'#### 2009.10.03 �� �t�H���[�A�b�v�Ώێ҃`�F�b�N���W�b�N�ǉ� End   ####

'#### 2009.10.03 �� �O��t�H���[���擾�p
Dim lngFolRsvNo         '�t�H���[�O��\��ԍ�
Dim dtmFolCslDate       '�t�H���[�O���f��
Dim strFolCsCd          '�t�H���[�O��R�[�X�R�[�h
Dim blnFollowBefore     '�t�H���[�O�񑶍݃t���O

'UpdateResult_tk �p�����[�^
Dim vntItemCd           '�������ڃR�[�h
Dim vntSuffix           '�T�t�B�b�N�X
Dim vntResult           '��������
Dim vntRslCmtCd1        '���ʃR�����g�P
Dim vntRslCmtCd2        '���ʃR�����g�Q
Dim strUpdUser          '�X�V��
Dim strIPAddress        'IP�A�h���X

'�O����R�[�X�R���{�{�b�N�X
Dim strArrLastCsGrp()           '�R�[�X�O���[�v�R�[�h
Dim strArrLastCsGrpName()       '�R�[�X�O���[�v����

Dim i                   '���[�v�J�E���^
Dim j                   '���[�v�J�E���^

Dim strMessage          '���ʓo�^���A�l

'2006.01.04  Add By ���@STR) ----------------------->
Dim lngDisCnt           '�a�����̌���
Dim lngJikakuCnt        '���o�Ǐ���̌���
'2006.01.04  Add By ���@END) ----------------------->

'*** 2008.02.26�@ ���茒�f�ǉ��@STR
Dim blnSpCheck    '���茒�f�Ώۂ��`�F�b�N
'*** 2008.02.26�@ ���茒�f�ǉ��@END

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objHainsUser    = Server.CreateObject("HainsHainsUser.HainsUser")
Set objInterview    = Server.CreateObject("HainsInterview.Interview")
Set objResult       = Server.CreateObject("HainsResult.Result")
Set objPubNote      = Server.CreateObject("HainsPubNote.PubNote")
'2004.11.21 ADD STR ORB)T.Yaguchi �t�H���[�ǉ�
Set objFollowUp     = Server.CreateObject("HainsFollowUp.FollowUp")
'2004.11.21 ADD END

Set objFollow       = Server.CreateObject("HainsFollow.Follow")

'2008.02.26 ���茒�f�ǉ� STR
Set objSpecialInterview     = Server.CreateObject("HainsSpecialInterview.SpecialInterview")
'2008.02.26 ���茒�f�ǉ� END

'�����l�̎擾
strAct          = Request("action")

lngRsvNo        = Request("rsvno")
strCsCd         = Request("cscd")
strWinMode      = Request("winmode")
strGrpCd        = Request("grpcd")

lngDocIndex     = Request("docIndex")

vntDocItemCd    = ConvIStringToArray(Request("docItemCd"))
vntDocSuffix    = ConvIStringToArray(Request("docSuffix"))
strDocStcCd     = Request("docStcCd")

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

strUpdUser        = Session.Contents("userId")
strIPAddress      = Request.ServerVariables("REMOTE_ADDR")

Do
    
    '�����Z�b�g�܂��̓N���A
    If strAct = "setAuther"  Or strAct = "clrAuther" Then
        
        vntItemCd = Array()
        Redim Preserve vntItemCd(0)
        vntItemCd(0) = vntDocItemCd(lngDocIndex-1)

        vntSuffix  = Array()
        Redim Preserve vntSuffix(0)
        vntSuffix(0) = vntDocSuffix(lngDocIndex-1)

        If strAct = "clrAuther" Then
            strDocStcCd = ""
        End If
        vntResult  = Array()
        Redim Preserve vntResult(0)
        vntResult(0) = strDocStcCd

        vntRslCmtCd1  = Array()
        Redim Preserve vntRslCmtCd1(0)
        vntRslCmtCd2  = Array()
        Redim Preserve vntRslCmtCd2(0)
'## 2003.11.16 Mod By T.Takagi@FSIT
'       strMessage = objResult.UpdateRsl_tk( _
'                           strUpdUser, _
'                           strIPAddress, _
'                           lngRsvNo, _
'                           vntItemCd, _
'                           vntSuffix, _
'                           vntResult, _
'                           vntRslCmtCd1, _
'                           vntRslCmtCd2 _
'                         ) 
        objResult.UpdateResult lngRsvNo, strIPAddress, strUpdUser, vntItemCd, vntSuffix, vntResult, vntRslCmtCd1, vntRslCmtCd2, strMessage
'## 2003.11.16 Mod End
        strAct = ""
    
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
        Err.Raise 1000, , "��f��񂪂���܂���BRsvNo= " & lngLastDspMode & "(" & lngRsvNo 
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
                                                 ,  ,  _
                                                vntResultDispMode, _
                                                vntUpdFlg _
                                                )
    If lngCount <= 0 Then
        Err.Raise 1000, , "���茋�ʂ�����܂���BRsvNo= " & lngRsvNo
    End If


''## 2006.05.10 Mod by ��  *****************************
' Parameter - lngLastDspMode , vntCsGrp �ǉ�

    '����㌟��
'    lngJudDocCnt = objInterview.SelectHistoryRslList( _
'                        lngRsvNo, _
'                        1, _
'                        JUDDOC_GRPCD, _
'                        0, _
'                        "", _
'                        0, _
'                        , , _
'                        , , _
'                        vntDocSeq, _
'                        vntDocRsvNo, _
'                        vntDocItemCd, _
'                        vntDocSuffix, _
'                         , _
'                        vntDocItemType, _
'                        vntDocItemName, _
'                        vntDocterName _
'                        )

    lngJudDocCnt = objInterview.SelectHistoryRslList( _
                        lngRsvNo, _
                        1, _
                        JUDDOC_GRPCD, _
                        lngLastDspMode, _
                        vntCsGrp, _
                        0, _
                        , , _
                        , , _
                        vntDocSeq, _
                        vntDocRsvNo, _
                        vntDocItemCd, _
                        vntDocSuffix, _
                         , _
                        vntDocItemType, _
                        vntDocItemName, _
                        vntDocterName _
                        )
''## 2006.05.10 Mod End. *********************************



''## 2006/01/04 Add By ��  STR) ---------------------->

'''#### 2013.02.01 �� ���������\�񂪑��݂����ꍇ�̕s��Ή��@MOD START #### **
'''## �a������ 
'    lngDisCnt = objInterview.SelectHistoryRslList( _
'                        lngRsvNo, _
'                        1, _
'                        GRPCD_DISEASEHISTORY, _
'                        0, _
'                        "", _
'                        0 )
'
'''## ���o�Ǐ󌟍� 
'    lngJikakuCnt = objInterview.SelectHistoryRslList( _
'                        lngRsvNo, _
'                        1, _
'                        GRPCD_JIKAKUSYOUJYOU, _
'                        0, _
'                        "", _
'                        0 , 0 , 0 )

''## �a������ 
    lngDisCnt = objInterview.SelectHistoryRslList( _
                        lngRsvNo, _
                        1, _
                        GRPCD_DISEASEHISTORY, _
                        1, _
                        strCsCd, _
                        0 )

''## ���o�Ǐ󌟍� 
    lngJikakuCnt = objInterview.SelectHistoryRslList( _
                        lngRsvNo, _
                        1, _
                        GRPCD_JIKAKUSYOUJYOU, _
                        1, _
                        strCsCd, _
                        0 , 0 , 0 )

'''#### 2013.02.01 �� ���������\�񂪑��݂����ꍇ�̕s��Ή��@MOD END   #### **



''## 2006/01/04 Add By �� END) ---------------------->


    '�����R�����g�擾
'** #### 2011.11.17 SL-SN-Y0101-007 MOD START #### **
'    lngTtlCmtCnt = objInterview.SelectTotalJudCmt( _
'                                        lngRsvNo, 1, _
'                                        1, 0,  , 0, _
'                                        vntCmtSeq, _
'                                        vntTtlJudCmtCd, _
'                                        vntTtlJudCmtstc, _
'                                        vntTtlJudClassCd _
'                                        )
    

    lngTtlCmtCnt = objInterview.SelectTotalJudCmt( _
                                        lngRsvNo, 1, _
                                        1, 1, strCsCd, 0, _
                                        vntCmtSeq, _
                                        vntTtlJudCmtCd, _
                                        vntTtlJudCmtstc, _
                                        vntTtlJudClassCd _
                                        )
'** #### 2011.11.17 SL-SN-Y0101-007 MOD END #### **

    '�`���[�g���̌����擾
    lngChartCnt = objPubNote.SelectPubNote(PUBNOTE_SELINFO,  _
                                        0, "", "",           _
                                        lngRsvNo,            _
                                        "", "", "", "", 0,   _
                                        CHART_NOTEDIV,       _
                                        PUBNOTE_DISPKBN,   	 _
                                        strUpdUser,          _
                                        vntNoteSeq,          _
                                        vntPubNoteDivCd,     _
                                        vntPubNoteDivName,   _
                                        vntDefaultDispKbn,   _
                                        vntOnlyDispKbn,      _
                                        vntDispKbn,          _
                                        vntUpdDate,          _
                                        vntNoteUpdUser,      _
                                        vntUserName,         _
                                        vntBoldFlg,          _
                                        vntPubNote,          _
                                        vntDispColor )
    '���ӎ����̌����擾
    lngCautionCnt = objPubNote.SelectPubNote(PUBNOTE_SELINFO,  _
                                        0, "", "",           _
                                        lngRsvNo,            _
                                        "", "", "", "", 0,   _
                                        CAUTION_NOTEDIV,     _
                                        PUBNOTE_DISPKBN,   	 _
                                        strUpdUser,          _
                                        vntNoteSeq,          _
                                        vntPubNoteDivCd,     _
                                        vntPubNoteDivName,   _
                                        vntDefaultDispKbn,   _
                                        vntOnlyDispKbn,      _
                                        vntDispKbn,          _
                                        vntUpdDate,          _
                                        vntNoteUpdUser,      _
                                        vntUserName,         _
                                        vntBoldFlg,          _
                                        vntPubNote,          _
                                        vntDispColor )


'2004.11.08 ADD STR ORB)T.Yaguchi �t�H���[�ǉ�
    '�t�H���[�A�b�v�擾
'    blnFollowFlg = objFollowUp.SelectFollow(lngRsvNo)
'2004.11.08 ADD END

'#### 2009.10.03 �� �t�H���[�A�b�v�֘A���W�b�N�ǉ� Start ####

    '�O��t�H���[���o�^�L���`�F�b�N�y�уL�[�f�[�^�擾
    blnFollowBefore = objFollow.SelectFollow_Before(lngRsvNo, lngFolRsvNo, dtmFolCslDate, strFolCsCd)

    '�t�H���[�A�b�v���o�^�L���`�F�b�N
    blnFollowFlg = objFollow.SelectFollow_Info(lngRsvNo, FOLLOW_JUDCLASS)

    '�t�H���[�A�b�v�Ώێ҃`�F�b�N
    blnFollowTarget = objFollowUp.SelectTargetFollow(lngRsvNo)

    '�t�H���[�A�b�v�Ώێ҃`�F�b�N
    '### 2009.12.16 �� COM+���W���[���d�l�ύX�ɂ���ďC�� Start ###
    'lngFollowTarget = objFollow.SelectTargetFollow(lngRsvNo, , , , , , , , , _
    '                                               , , , , , , , , , , , , , , , , , , True)

    '### 2016.02.18 �� �q�{�򕔍זE�f�t�H���[�A�b�v�ǉ��ɔ����d�l�ύX START ###
    'lngFollowTarget = objFollow.SelectTargetFollow(lngRsvNo, , , , , , , , , _
    '                                               , , , , , , , , , , , , , , , , , , , True)
    lngFollowTarget = objFollow.SelectTargetFollow(lngRsvNo, , , , , , , , , _
                                                   , , , , , , , , , , , , , , , , , , , , , True)
    '### 2016.02.18 �� �q�{�򕔍זE�f�t�H���[�A�b�v�ǉ��ɔ����d�l�ύX START ###

    '### 2009.12.16 �� COM+���W���[���d�l�ύX�ɂ���ďC�� End   ###

'#### 2009.10.03 �� �t�H���[�A�b�v�֘A���W�b�N�ǉ� Start ####


'*** 2008.02.26 ���茒�f�ǉ��@STR
    '���茒�f�Ώۋ敪
    blnSpCheck = objSpecialInterview.SelectSetClassCd(lngRsvNo)
'*** 2008.02.26 ���茒�f�ǉ��@END

    Exit Do
Loop

Set objHainsUser    = Nothing
Set objInterview    = Nothing
Set objResult       = Nothing
Set objPubNote      = Nothing
Set objFollowUp     = Nothing

Set objSpecialInterview      = Nothing

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
var winFollow;                  // �E�B���h�E�n���h��

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
        //winMenResult = window.open( url, '', 'width=1000,height=750,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
        winMenResult = window.open( url, '', 'width=1000,height=750,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
    }

}

//����������͉�ʌĂяo��
function calltotalJudEdit() {
    var url;                            // URL������

    url = '/WebHains/contents/interview/totalJudEdit.asp';
    url = url + '?winmode=' + '<%= strWinMode %>';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';
    url = url + '&grpcd=' + '<%= strGrpCd %>';
    url = url + '&cscd=' + '<%= strCsCd %>';

    parent.location.href(url);

}

//�������S�����w���\�p�^�[���Ăяo��
function callMenKyoketsu() {
    var url;                            // URL������

    url = '/WebHains/contents/interview/MenKyoketsu.asp?grpno=13';
    url = url + '&winmode=' + '<%= strWinMode %>';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';
    url = url + '&grpcd=' + '<%= strGrpCd %>';
    url = url + '&cscd=' + '<%= strCsCd %>';

    parent.location.href(url);

}

//�h�{�w���Ăяo��
function callMenEiyoShido() {
    var url;                            // URL������

    url = '/WebHains/contents/interview/MenEiyoShido.asp?';
    url = url + 'winmode=' + '<%= strWinMode %>';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';
    url = url + '&grpcd=' + '<%= strGrpCd %>';
    url = url + '&cscd=' + '<%= strCsCd %>';

    parent.location.href(url);

}
<% '## 2012.09.11 Add by T.Takagi@RD �ؑ֓��t�ɂ���ʐؑ� %>
// �H�K���Ăяo��
function callShokushukan() {

    var url;                            // URL������

    url = '/WebHains/contents/interview/Shokusyukan.asp?';
    url = url + 'winmode=' + '<%= strWinMode %>';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';
    url = url + '&grpcd=' + '<%= strGrpCd %>';
    url = url + '&cscd=' + '<%= strCsCd %>';

    parent.location.href(url);

}
<% '## 2012.09.11 Add End %>
//�b�t�o�N�ω��Ăяo��
function callCUSelectItemsMain() {
    var url;                            // URL������

    url = '/WebHains/contents/interview/CUSelectItemsMain.asp?';
    url = url + 'winmode=' + '<%= strWinMode %>';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';
    url = url + '&grpcd=' + '<%= strGrpCd %>';
    url = url + '&cscd=' + '<%= strCsCd %>';

    parent.location.href(url);

}

//�a�����Ăяo��
function callDiseaseHistory() {
    var url;                            // URL������

    url = '/WebHains/contents/interview/DiseaseHistory.asp?';
    url = url + 'winmode=' + '<%= strWinMode %>';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';
    url = url + '&grpcd=' + '<%= strGrpCd %>';
    url = url + '&cscd=' + '<%= strCsCd %>';

    parent.location.href(url);

}
//** 2009.10.27 �R�����g�ꗗ�̃f�B�t�H���g�\�����Ԃ���f������Ƃ��A�ߋ�5�N�O����ɕύX Start **//
//�R�����g�ꗗ�i�`���[�g���A���ӎ����j�Ăяo��
function callCommentList( noteDiv ) {
    var url;                            // URL������

    url = '/WebHains/contents/comment/commentMainFlame.asp?';
    url = url + 'winmode=' + '<%= strWinMode %>';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';
    url = url + '&grpcd=' + '<%= strGrpCd %>';
    url = url + '&PubNoteDivCd=' + noteDiv;
    url = url + '&DispMode=2';
    url = url + '&DispKbn=1';
    url = url + '&cmtMode=1,1,0,0';
    url = url + '&cscd=' + '<%= strCsCd %>';
    url = url + '&strYear=' + '<%= Year(DateAdd("yyyy",-5,vntCslCslDate(0))) %>';
    url = url + '&strMonth=' + '<%= Month(DateAdd("yyyy",-5,vntCslCslDate(0))) %>';
    url = url + '&strDay=' + '<%= Day(DateAdd("yyyy",-5,vntCslCslDate(0))) %>';
    url = url + '&endYear=' + '<%= Year(vntCslCslDate(0)) %>';
    url = url + '&endMonth=' + '<%= Month(vntCslCslDate(0)) %>';
    url = url + '&endDay=' + '<%= Day(vntCslCslDate(0)) %>';

    parent.location.href(url);

}

////�R�����g�ꗗ�i�`���[�g���A���ӎ����j�Ăяo��
//function callCommentList( noteDiv ) {
//    var url;                            // URL������
//
//    url = '/WebHains/contents/comment/commentMainFlame.asp?';
//    url = url + 'winmode=' + '<%= strWinMode %>';
//    url = url + '&rsvno=' + '<%= lngRsvNo %>';
//    url = url + '&grpcd=' + '<%= strGrpCd %>';
//    url = url + '&PubNoteDivCd=' + noteDiv;
//    url = url + '&DispMode=2';
//    url = url + '&DispKbn=1';
//    url = url + '&cmtMode=1,1,0,0';
//    url = url + '&cscd=' + '<%= strCsCd %>';
//    url = url + '&strYear=' + '<%= Year(vntCslCslDate(0)) %>';
//    url = url + '&strMonth=' + '<%= Month(vntCslCslDate(0)) %>';
//    url = url + '&strDay=' + '<%= Day(vntCslCslDate(0)) %>';
//    url = url + '&endYear=' + '<%= Year(vntCslCslDate(0)) %>';
//    url = url + '&endMonth=' + '<%= Month(vntCslCslDate(0)) %>';
//    url = url + '&endDay=' + '<%= Day(vntCslCslDate(0)) %>';
//
//    parent.location.href(url);
//
//}
//** 2009.10.27 �R�����g�ꗗ�̃f�B�t�H���g�\�����Ԃ���f������Ƃ��A�ߋ�5�N�O����ɕύX End **//

//��f��ʌĂяo��
function callMonshinNyuryoku() {
    var url;                            // URL������

    url = '/WebHains/contents/interview/MonshinNyuryoku.asp?grpno=24';
    url = url + '&winmode=' + '<%= strWinMode %>';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';
    url = url + '&grpcd=' + '<%= strGrpCd %>';
    url = url + '&cscd=' + '<%= strCsCd %>';

    parent.location.href(url);

}
//���茒�f��p�ʐډ�ʌĂяo��
var winSpecialResult; 

function callSpecialKenshin() {
    
    var url;               //URL������
    var opened = false;    //��ʂ����łɊJ����Ă��邩

    //���łɃK�C�h���J����Ă��邩�`�F�b�N
    if ( winSpecialResult != null ) {
        if ( !winSpecialResult.closed ) {
            opened = true;
        }
    }

//    url = '/WebHains/contents/interview/specialJudView.asp?';
    url = '/WebHains/contents/interview/specialInterviewTop.asp?';
    url = url + 'winmode=1';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';

    //�J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
    if ( opened ) {
        winSpecialResult.focus();
        winSpecialResult.location.replace( url );
    } else {
        winSpecialResult = window.open( url,'','width=1000,height=750,location=yes,status=yes,directories=yes,menubar=yes,resizable=yes,toolbar=yes,scrollbars=yes');
    }
}

//���茒�f��p�ʐډ�ʌĂяo��
/*�@function showSpecialKenshin() {
    var url;	// URL������

    url = '/WebHains/contents/interview/specialJudView.asp?';
    url = url + 'winmode=' + '<%= strWinMode %>';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';

    parent.location.href(url);
}
*/

// '2004.10.21 MOD STR ORB)T.Yaguchi 
//�t�H���[�A�b�v���͉�ʌĂяo��
//function callfollowupNyuryoku( noteDiv ) {
//    var url;                            // URL������
//
//    url = '/WebHains/contents/followup/followupTop.asp';
//    url = url + '?winmode=' + '<%= strWinMode %>';
//    url = url + '&PubNoteDivCd=' + noteDiv;
//    url = url + '&DispMode=2';
//    url = url + '&DispKbn=1';
//    url = url + '&cmtMode=1,1,0,0';
//    url = url + '&cscd=' + '<%= strCsCd %>';
//    url = url + '&strYear=' + '<%= Year(vntCslCslDate(0)) %>';
//    url = url + '&strMonth=' + '<%= Month(vntCslCslDate(0)) %>';
//    url = url + '&strDay=' + '<%= Day(vntCslCslDate(0)) %>';
//    url = url + '&endYear=' + '<%= Year(vntCslCslDate(0)) %>';
//    url = url + '&endMonth=' + '<%= Month(vntCslCslDate(0)) %>';
//    url = url + '&endDay=' + '<%= Day(vntCslCslDate(0)) %>';
//    url = url + '&rsvno=' + '<%= lngRsvNo %>';
//    url = url + '&grpcd=' + '<%= strGrpCd %>';
//
//    parent.location.href(url);
//
//}
// '2004.10.21 MOD END

// 2009.10.03 �� �t�H���[�A�b�v�o�^��ʌĂяo��
function callfollowupNyuryoku( noteDiv ) {
    var url;                            // URL������

    url = '/WebHains/contents/follow/followInfoTop.asp';
    url = url + '?winmode=' + '<%= strWinMode %>';
    url = url + '&PubNoteDivCd=' + noteDiv;
    url = url + '&DispMode=2';
    url = url + '&DispKbn=1';
    url = url + '&cmtMode=1,1,0,0';
    url = url + '&cscd=' + '<%= strCsCd %>';
    url = url + '&strYear=' + '<%= Year(vntCslCslDate(0)) %>';
    url = url + '&strMonth=' + '<%= Month(vntCslCslDate(0)) %>';
    url = url + '&strDay=' + '<%= Day(vntCslCslDate(0)) %>';
    url = url + '&endYear=' + '<%= Year(vntCslCslDate(0)) %>';
    url = url + '&endMonth=' + '<%= Month(vntCslCslDate(0)) %>';
    url = url + '&endDay=' + '<%= Day(vntCslCslDate(0)) %>';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';
    url = url + '&grpcd=' + '<%= strGrpCd %>';

    parent.location.href(url);

}

// 2009.10.03 �� �O��t�H���[�A�b�v����ʌĂяo��
function callfollowupBefore( noteDiv ) {
    var url;                // URL������
    var opened = false;     // ��ʂ����łɊJ����Ă��邩

    // ���łɃK�C�h���J����Ă��邩�`�F�b�N
    if (winFollow != null ) {
        if ( !winFollow.closed ) {
            opened = true;
        }
    }

    url = '/WebHains/contents/follow/followInfoTop.asp';
    url = url + '?winmode=' + '1';
    url = url + '&PubNoteDivCd=' + noteDiv;
    url = url + '&DispMode=2';
    url = url + '&DispKbn=1';
    url = url + '&cmtMode=1,1,0,0';
    url = url + '&cscd=' + '<%= strFolCsCd %>';
    url = url + '&strYear=' + '<%= Year(dtmFolCslDate) %>';
    url = url + '&strMonth=' + '<%= Month(dtmFolCslDate) %>';
    url = url + '&strDay=' + '<%= Day(dtmFolCslDate) %>';
    url = url + '&endYear=' + '<%= Year(dtmFolCslDate) %>';
    url = url + '&endMonth=' + '<%= Month(dtmFolCslDate) %>';
    url = url + '&endDay=' + '<%= Day(dtmFolCslDate) %>';
    url = url + '&rsvno=' + '<%= lngFolRsvNo %>';

    // �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
    if ( opened ) {
        winFollow.focus();
        winFollow.location.replace( url );
    } else {
        winFollow = window.open( url, '', 'width=1000,height=600,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
    }

}


/** 2008.04.10 �� �R�삳�񂩂�̈˗��ɂ���Ēǉ��i�b�菈���j Start **/
/** �t�H���[�A�b�v��ʌĂяo�� **/
function callfollowupNew( noteDiv ) {
    var url;                            // URL������

    url = 'http://157.104.16.154/Dock/FollowUp/SummaryFH.asp';
    url = url + '?rsvno=' + '<%= lngRsvNo %>';
    url = url + '&userid=' + '<%= strUpdUser %>';

    parent.location.href(url);

}
/** 2008.04.10 �� �R�삳�񂩂�̈˗��ɂ���Ēǉ��i�b�菈���j End   **/


//�ύX������ʌĂяo��
function callrslUpdateHistory() {
    var url;                            // URL������

    url = '/WebHains/contents/interview/rslUpdateHistory.asp?grpno=20';
    url = url + '&winmode=' + '<%= strWinMode %>';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';

    parent.location.href(url);

}

//�ߋ������R�����g�ꗗ��ʌĂяo��
function callOldJudComment() {
    var url;                            // URL������

    url = '/WebHains/contents/interview/viewOldJudComment.asp?';
    url = url + 'winmode=0';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';
    url = url + '&grpcd=' + '<%= strGrpCd %>';
    url = url + '&cscd=' + '<%= strCsCd %>';

    parent.location.href(url);

}

var winEntryAuther;                     // �E�B���h�E�n���h��
//�S���ғo�^�E�C���h�E�Ăяo��
function showTantouWindow() {

    var url;            // URL������
    var opened = false; // ��ʂ����łɊJ����Ă��邩


    // ���łɃK�C�h���J����Ă��邩�`�F�b�N
    if ( winEntryAuther != null ) {
        if ( !winEntryAuther.closed ) {
            opened = true;
        }
    }
    url = '/WebHains/contents/interview/EntryAuther.asp?rsvno=' + <%= lngRsvNo %>;

    // �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
    if ( opened ) {
        winEntryAuther.focus();
        winEntryAuther.location.replace( url );
    } else {
        winEntryAuther = window.open( url, '', 'width=500,height=200,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
    }
}


// 2006.01.04 Add By ��  STR. -------------------------------------->
//���o�Ǐ�E�C���h�E�Ăяo��
var winJikakushoujyou;                  // �E�B���h�E�n���h��
function showJikakushoujyou() {

    var url;            // URL������
    var opened = false; // ��ʂ����łɊJ����Ă��邩


    // ���łɃK�C�h���J����Ă��邩�`�F�b�N
    if ( winJikakushoujyou != null ) {
        if ( !winJikakushoujyou.closed ) {
            opened = true;
        }
    }
    url = '/WebHains/contents/interview/jikakushoujyou.asp?rsvno=' + <%= lngRsvNo %>;

    // �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
    if ( opened ) {
        winJikakushoujyou.focus();
        winJikakushoujyou.location.replace( url );
    } else {
        winJikakushoujyou = window.open( url, '', 'width=900,height=500,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
    }
}
// 2006.01.04 Add By ��  END. -------------------------------------->


var lngSelectedIndex1;  // �K�C�h�\�����ɑI�����ꂽ�G�������g�̃C���f�b�N�X

//�����I���E�C���h�E�\��
function showUserWindow(index, docItemCd) {

    var objForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g

    // �I�����ꂽ�G�������g�̃C���f�b�N�X��ޔ�(�萫���ʂ̃Z�b�g�p�֐��ɂĎg�p����)
    lngSelectedIndex1 = index;


    // �K�C�h��ʂ̘A����Ɍ������ڃR�[�h�i�����j��ݒ肷��
    stcGuide_ItemCd = docItemCd;

    // �K�C�h��ʂ̘A����ɍ��ڃ^�C�v�i�W���j��ݒ肷��
    stcGuide_ItemType = 0;

    // �K�C�h��ʂ̘A����ɃK�C�h��ʂ���Ăяo����鎩��ʂ̊֐���ݒ肷��
    stcGuide_CalledFunction = setStcInfo;

    // ���̓K�C�h�\��
    showGuideStc();
}
// ���̓R�[�h�E�����͂̃Z�b�g
function setStcInfo() {

    setStc( lngSelectedIndex1, stcGuide_StcCd, stcGuide_ShortStc );

}

// ���͂̕ҏW
function setStc( index, stcCd, shortStc ) {

    var myForm = document.entryForm;    // ����ʂ̃t�H�[���G�������g
    var objDocCd, objDocName;           // ���ʁE���͂̃G�������g
    var stcNameElement;                 // ���͂̃G�������g

    // �ҏW�G�������g�̐ݒ�
    objDocCd   = myForm.docStcCd;
    objDocName = myForm.docName[ index-1 ];

    stcNameElement = 'docName' + index;

    // �l�̕ҏW
    objDocCd.value   = stcCd;
    objDocName.value = shortStc;


//  if ( document.getElementById(stcNameElement) ) {
//      document.getElementById(stcNameElement).innerHTML = shortStc;
//  }

    myForm.docIndex.value = index;
    myForm.action.value = "setAuther";
    myForm.submit();

}

//�����N���A
function clrUser(index, docname) {

    var myForm = document.entryForm;    // ����ʂ̃t�H�[���G�������g

    if ( !confirm( docname + "���N���A���܂����H" )){
        return;
    }
    myForm.docIndex.value = index;
    myForm.action.value = "clrAuther";
    myForm.submit();

}

function windowClose() {

    // �S���ғo�^�E�C���h�E�����
    if ( winEntryAuther != null ) {
        if ( !winEntryAuther.closed ) {
            winEntryAuther.close();
        }
    }
    winEntryAuther = null;

    // �������ʃE�C���h�E�����
    if ( winMenResult != null ) {
        if ( !winMenResult.closed ) {
            winMenResult.close();
        }
    }
    winMenResult = null;

    // 2006.01.04 Add By ���@STR) --------------->
    // ���o�Ǐ�E�C���h�E�����
    if ( winJikakushoujyou != null ) {
        if ( !winJikakushoujyou.closed ) {
            winJikakushoujyou.close();
        }
    }
    winJikakushoujyou = null;
    // 2006.01.04 Add By ���@END) --------------->


    //���̓K�C�h�����
    closeGuideStc();
}

//-->
</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:windowClose()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">

    <INPUT TYPE="hidden" NAME="action" VALUE="<%= strAct %>">
    <INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">
    <INPUT TYPE="hidden" NAME="cscd" VALUE="<%= strCsCd %>">
    <INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">
    <INPUT TYPE="hidden" NAME="grpcd" VALUE="<%= strGrpCd %>">
    <INPUT TYPE="hidden" NAME="docIndex" VALUE="<%= lngDocIndex %>">
    <INPUT TYPE="hidden" NAME="docStcCd" VALUE="<%= strDocStcCd %>">

    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
        <TR>
            <TD VALIGN="TOP">
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2">
                    <TR BGCOLOR="#cccccc" ALIGN="center">
                        <TD ROWSPAN="2" WIDTH="119">����</TD>
                        <TD COLSPAN="3" WIDTH="180">���茋��</TD>
                        <TD ROWSPAN="2" WIDTH="106">����</TD>
                        <TD COLSPAN="3" WIDTH="190">���茋��</TD>
                    </TR>
                    <TR BGCOLOR="#cccccc" ALIGN="center">
                        <TD WIDTH="50">����</TD>
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
                                <TD ALIGN="center" WIDTH="50"><FONT COLOR="999999"><B>***</B></FONT></TD>
<%
                            Else
                                '�C�����ꂽ�H
                                ' ## �X�V�t���O�Ō��� 2003.12.26
'''                             If Trim(vntUpdUser(i)) <> Trim(AUTOJUD_USER) And _
                                If Trim(vntUpdFlg(i)) = "1" And _
                                   vntRsvNo(i) <> "" And _
                                   vntJudCd(i) <> "" Then
%>
                                    <!--### 2006.03.08 �� �ύX����ɑ΂���w�i�F�ύX�i�s���N�F�ˊD�F) Start ###-->
                                    <!--TD BGCOLOR="#ffc0cb" ALIGN="center" WIDTH="50"><B><%= vntJudCd(i) %></B></TD-->
                                    <TD BGCOLOR="#cccccc" ALIGN="center" WIDTH="50"><B><%= vntJudCd(i) %></B></TD>
                                    <!--### 2006.03.08 �� �ύX����ɑ΂���w�i�F�ύX�i�s���N�F�ˊD�F) End   ###-->
<%
                                Else
%>
                                    <TD ALIGN="center" WIDTH="50"><B><%= vntJudCd(i) %></B></TD>
<%
                                End If
                            End If
                        Else
                            '�˗�����
                            If vntRsvNo(i) = "" Then
%>
                                <TD ALIGN="center" WIDTH="60"><FONT COLOR="999999"><B>***</B></FONT></TD>
<%
                            Else
                                '�C�����ꂽ�H
                                ' ## �X�V�t���O�Ō��� 2003.12.26
'                               If Trim(vntUpdUser(i)) <> Trim(AUTOJUD_USER)  And _
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
                </TABLE>
            </TD>

            
            <!--## �S���ҕ\���̈� �a�����A�`���[�g���A���ӎ����A��f���e�{�^�������̃G���A�Ɉڂ� Start ##-->
            <!--## 2006/02/16 ��                                                                     ##-->
            <TD height="1">
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="3" height="100%">

                    <TR height="40%">
                        <TD align="center" VALIGN="top">
                            <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="2">
                            
                                <TR>
            <%
                                    '�a����񂠂�H
                                    If lngDisCnt > 0 Then
            %>
                                        <TD ALIGN="center" BGCOLOR="ffffff">
                                            <A HREF="javascript:callDiseaseHistory()"><FONT  SIZE="+1" COLOR="FF00FF">�a�����</FONT></A></TD>
            <%
                                    Else
            %>
                                        <TD ALIGN="center" BGCOLOR="ffffff">
                                            <A HREF="javascript:callDiseaseHistory()"><IMAGE SRC="/webHains/images/diseasehistory.gif" ALT="�a������ʂ�\�����܂�" BORDER="0"></A></TD>
            <%
                                    End If
            %>
                                </TR>

                                <TR>
            <%
                                    '�`���[�g��񂠂�H
                                    If lngChartCnt > 0 Then
            %>
                                        <TD ALIGN="center" BGCOLOR="ffffff">
                                            <A HREF="javascript:callCommentList( '<%= CHART_NOTEDIV %>' )"><FONT  SIZE="+1" COLOR="FF00FF">�`���[�g���</FONT></A></TD>
            <%
                                    Else
            %>
                                        <TD ALIGN="center" BGCOLOR="ffffff">
                                            <A HREF="javascript:callCommentList( '<%= CHART_NOTEDIV %>')"><IMAGE SRC="/webHains/images/chartinfo.gif" ALT="�`���[�g����\�����܂�" BORDER="0"></A></TD>
            <%
                                    End If
            %>
                                </TR>
                                <TR>
            <%
                                    '���ӎ�������H
                                    If lngCautionCnt > 0 Then
            %>
                                        <TD ALIGN="center" BGCOLOR="ffffff">
                                            <A HREF="javascript:callCommentList( '<%= CAUTION_NOTEDIV %>' )"><FONT SIZE="+1" COLOR="FF00FF">���ӎ���</FONT></A></TD>
            <%
                                    Else
            %>
                                        <TD ALIGN="center" BGCOLOR="ffffff">
                                            <A HREF="javascript:callCommentList( '<%= CAUTION_NOTEDIV %>' )"><IMAGE SRC="/webHains/images/caution.gif" ALT="���ӎ�����\�����܂�" BORDER="0"></A></TD>
            <%
                                    End If
            %>
                                </TR>
                                
                                <TR>
                                    <TD ALIGN="center" BGCOLOR="ffffff">
                                        <A HREF="javascript:callMonshinNyuryoku()"><IMAGE SRC="/webHains/images/monshin.gif" ALT="��f��\�����܂�" BORDER="0"></A></TD>
                                </TR>
                                <TR>
            <%
                                    '���o�Ǐ󂠂�H
                                    If lngJikakuCnt > 0 Then
            %>
                                        <TD ALIGN="center" BGCOLOR="ffffff" WIDTH="150">
                                            <A HREF="javascript:showJikakushoujyou()"><FONT SIZE="+1" COLOR="FF00FF">���o�Ǐ�</FONT></A></TD>
            <%
                                    Else
            %>
                                    <TD ALIGN="center" NOWRAP>�@</TD>
            <%
                                    End If
            %>
                                </TR>

                                <TR>
            <%
                                  '���茒�f�Ώ�
                                  IF blnSpCheck = true  Then
            %>
                                    <TD ALIGN="center" BGCOLOR="ffffff">
                                        <A HREF="javascript:callSpecialKenshin()"><IMAGE SRC="/webHains/images/special.gif" ALT="���茒�f�Ώۂ̂ݕ\�����܂�" BORDER="0"></A></TD>
            <%                    
                                  Else
            %>
                                    <TD ALIGN="center" NOWRAP>  </TD>
            <%                       
                                  End IF
            %>
                                </TR>

                            </TABLE>
                        </TD>
                    </TR>


                    <TR HEIGHT="60%">
                        <TD VALIGN="bottom">
                            <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="2">

        <%
                            If lngJudDocCnt > 0 Then
                                For i = 1 To lngJudDocCnt
        %>
                                    <INPUT TYPE="hidden" NAME="docItemCd" VALUE="<%= vntDocItemCd(i-1) %>">
                                    <INPUT TYPE="hidden" NAME="docSuffix" VALUE="<%= vntDocSuffix(i-1) %>">
                                    <INPUT TYPE="hidden" NAME="docName" VALUE="<%= vntDocterName(i-1) %>">
                                
                                    <TR BGCOLOR="#eeeeee" HEIGHT="21">
                                        <TD NOWRAP><%= vntDocItemName(i-1) %></TD>
        <!--
                                        <TD><A HREF="javascript:showUserWindow(<%= i %>, <%= vntDocItemCd(i-1) %>)"><IMG SRC="../../images/question.gif" ALT="" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
                                        <TD><A HREF="javascript:clrUser(<%= i %>, '<%= vntDocItemName(i-1) %>')"><IMG SRC="../../images/delicon.gif" ALT="" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
        -->
                                        <TD NOWRAP><SPAN ID="docName<%= i %>"><%= vntDocterName(i-1) %></SPAN></TD>
                                    </TR>
        <%
                                Next
                            End If
        %>
                            </TABLE>
                        </TD>
                    </TR>

                </TABLE>
            </TD>
            <!--## 2006/02/16 ��                                                                     ##-->
            <!--## �S���ҕ\���̈� �a�����A�`���[�g���A���ӎ����A��f���e�{�^�������̃G���A�Ɉڂ� End   ##-->

            
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="30" HEIGHT="1" ALT=""></TD>

            <!--## �e�{�^���̗̈� Start ########################################################-->
            <TD ROWSPAN="2" height="1">
                <TABLE WIDTH="64" BORDER="0" CELLSPACING="3" CELLPADDING="2" height="100%">

                    <TR HEIGHT="70%">
                        <TD VALIGN="top">
                            <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="3">


                                <TR>
                                    <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                                        <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:calltotalJudEdit()"><IMAGE SRC="/webHains/images/judedit.gif" ALT="����C����ʂ�\�����܂�" HEIGHT="24" WIDTH="100" BORDER="0"></A></TD>
                                    <%  end if  %>
                                </TR>
                                <TR>
                                    <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:callMenKyoketsu()"><IMAGE SRC="/webHains/images/kyoketsu.gif" ALT="�������S������ʂ�\�����܂�" HEIGHT="24" WIDTH="100" BORDER="0"></A></TD>
                                </TR>
                                <TR>
<%
'## 2012.09.11 Add by T.Takagi@RD �ؑ֓��t�ɂ���ʐؑ�
								'�ؑ֓��ȍ~�̎�f���ł���ΐH�K���{�^����\��
								If IsVer201210(lngRsvNo) Then
'## 2012.09.11 Add End
%>
                                    <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:callShokushukan()"><IMAGE SRC="/webHains/images/shokushukan.gif" ALT="�H�K����ʂ�\�����܂�" HEIGHT="24" WIDTH="100" BORDER="0"></A></TD>
<%
'## 2012.09.11 Add by T.Takagi@RD �ؑ֓��t�ɂ���ʐؑ�
								Else
'## 2012.09.11 Add End
%>
                                    <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:callMenEiyoShido()"><IMAGE SRC="/webHains/images/eiyoshido.gif" ALT="�h�{�w����ʂ�\�����܂�" HEIGHT="24" WIDTH="100" BORDER="0"></A></TD>
<%
'## 2012.09.11 Add by T.Takagi@RD �ؑ֓��t�ɂ���ʐؑ�
								End If
'## 2012.09.11 Add End
%>
                                </TR>
                                <TR>
                                    <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:callCUSelectItemsMain()"><IMAGE SRC="/webHains/images/cuselect.gif" ALT="CU�o�N�ω���ʂ�\�����܂�" HEIGHT="24" WIDTH="100" BORDER="0"></A></TD>
                                </TR>
                                <TR>
                                    <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:callrslUpdateHistory()"><IMAGE SRC="/webHains/images/updatehistory.gif" ALT="�ύX������ʂ�\�����܂�" HEIGHT="24" WIDTH="100" BORDER="0"></A></TD>
                                </TR>
                                
            <!--## �S���ҕ\���̈� �a�����A�`���[�g���A���ӎ����A��f���e�{�^�������̃G���A�Ɉڂ� Start ##-->
            <!--## 2006/02/16 ��                                                                     ##-->
                                <!--TR>
            <%
                                    '�a����񂠂�H
                                    If lngDisCnt > 0 Then
            %>
                                        <TD ALIGN="center" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:callDiseaseHistory()"><FONT  SIZE="+1" COLOR="FF00FF">�a�����</FONT></A></TD>
            <%
                                    Else
            %>
                                        <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:callDiseaseHistory()"><IMAGE SRC="/webHains/images/diseasehistory.gif" ALT="�a������ʂ�\�����܂�" HEIGHT="24" WIDTH="100" BORDER="0"></A></TD>
            <%
                                    End If
            %>
                                </TR>

                                <TR>
            <%
                                    '�`���[�g��񂠂�H
                                    If lngChartCnt > 0 Then
            %>
                                        <TD ALIGN="center" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:callCommentList( '<%= CHART_NOTEDIV %>' )"><FONT  SIZE="+1" COLOR="FF00FF">�`���[�g���</FONT></A></TD>
            <%
                                    Else
            %>
                                        <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:callCommentList( '<%= CHART_NOTEDIV %>')"><IMAGE SRC="/webHains/images/chartinfo.gif" ALT="�`���[�g����\�����܂�" HEIGHT="24" WIDTH="100" BORDER="0"></A></TD>
            <%
                                    End If
            %>
                                </TR>
                                <TR>
            <%
                                    '���ӎ�������H
                                    If lngCautionCnt > 0 Then
            %>
                                        <TD ALIGN="center" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:callCommentList( '<%= CAUTION_NOTEDIV %>' )"><FONT SIZE="-1" COLOR="FF00FF">���ӎ���</FONT></A></TD>
            <%
                                    Else
            %>
                                        <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:callCommentList( '<%= CAUTION_NOTEDIV %>' )"><IMAGE SRC="/webHains/images/caution.gif" ALT="���ӎ�����\�����܂�" HEIGHT="24" WIDTH="100" BORDER="0"></A></TD>
            <%
                                    End If
            %>
                                </TR>
                                
                                <TR>
                                    <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:callMonshinNyuryoku()"><IMAGE SRC="/webHains/images/monshin.gif" ALT="��f��\�����܂�" HEIGHT="24" WIDTH="100" BORDER="0"></A></TD>
                                </TR>
                                
                                <TR>
            <%
                                    '���o�Ǐ󂠂�H
                                    If lngJikakuCnt > 0 Then
            %>
                                        <TD ALIGN="center" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:showJikakushoujyou()"><FONT SIZE="+1" COLOR="FF00FF">���o�Ǐ�</FONT></A></TD>
            <%
                                    Else
            %>
                                    <TD ALIGN="center" NOWRAP>�@</TD>
            <%
                                    End If
            %>
                                </TR-->
            <!--## 2006/02/16 ��                                                                     ##-->
            <!--## �S���ҕ\���̈� �a�����A�`���[�g���A���ӎ����A��f���e�{�^�������̃G���A�Ɉڂ� End   ##-->

                            </TABLE>
                        </TD>
                    </TR>


                    <TR HEIGHT="30%">
                        <TD VALIGN="bottom">
                            <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="3">

                                    <% '2004.10.21 MOD STR ORB)T.Yaguchi %>
                                <!--TR>
                                    <TD><IMAGE SRC="/webHains/images/spacer.gif" HEIGHT="10" WIDTH="1"></TD>-->
                                </TR>

            <!--## 2009/10/03 �� �O��t�H���[�A�b�v��ʂɃ����N Start ##-->
            <%
                            '#### 2009.10.03 �� �O��t�H���[��񂪓o�^����Ă���ꍇ�A�{�^���\��
                            If blnFollowBefore = True Then
            %>
                                <TR>
                                    <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:callfollowupBefore( '<%= CHART_NOTEDIV %>' )"><IMAGE SRC="/webHains/images/followup_before.gif" ALT="�O��t�H���[�A�b�v��ʂ�\�����܂�" HEIGHT="24" WIDTH="100" BORDER="0"></A></TD>
                                </TR>
            <%
                            End If
            %>
            <!--## 2009/10/03 �� �O��t�H���[�A�b�v��ʂɃ����N End   ##-->

                                <TR>
            <%
                                    '�t�H���|����H
                            If blnFollowFlg = True Then
            %>
                                        <TD ALIGN="center" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:callfollowupNyuryoku( '<%= CHART_NOTEDIV %>' )"><IMAGE SRC="/webHains/images/followup_up.gif" ALT="�t�H���[�A�b�v��ʂ�\�����܂�" HEIGHT="24" WIDTH="100" BORDER="0"></A></TD>
            <%
                            Else
                                '#### 2008.12.01 �� �t�H���[�A�b�v�o�^����Ă��Ȃ������ꍇ�A�t�H���[�Ώۊ�ɓ��Ă͂܂��f�҂̂݃{�^���\��
                                'If blnFollowTarget = True Then
                                '#### 2008.10.03 �� �d�l�ύX
                                If lngFollowTarget > 0 Then
            %>
                                        <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:callfollowupNyuryoku( '<%= CHART_NOTEDIV %>' )"><IMAGE SRC="/webHains/images/followup.gif" ALT="�t�H���[�A�b�v��ʂ�\�����܂�" HEIGHT="24" WIDTH="100" BORDER="0"></A></TD>
            <%
                                End If
                            End If
            %>
                                    <% '2004.10.21 MOD END %>

                                </TR>

            <!--## 2008/04/10 �� �t�H���[�A�b�v�V�K��ʂɃ����N��ύX Start ##-->
            <%
                            '#### 2008.12.01 �� �t�H���[�A�b�v�o�^����Ă��Ȃ������ꍇ�A�t�H���[�Ώۊ�ɓ��Ă͂܂��f�҂̂݃{�^���\��
                            'If blnFollowTarget = True Then
                            '#### 2008.10.03 �� �d�l�ύX
                            If lngFollowTarget > 0 Then
            %>
                                <!--TR>
                                    <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:callfollowupNew()"><IMAGE SRC="/webHains/images/followupSec.gif" ALT="�t�H���[�A�b�v��ʁi�J���o�[�W�����j��\�����܂�" HEIGHT="24" WIDTH="100" BORDER="0"></A></TD>
                                </TR-->
            <%
                            End If
            %>
            <!--## 2008/04/10 �� �t�H���[�A�b�v�V�K��ʂɃ����N��ύX End   ##-->

                                <TR><TD><IMG SRC="../../images/spacer.gif" WIDTH="30" HEIGHT="10" ALT=""></TD></TR>
                                <TR>
                                    <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:showTantouWindow()"><IMAGE SRC="/webHains/images/tantou.gif" ALT="�S���ғo�^�K�C�h��\�����܂�" HEIGHT="24" WIDTH="100" BORDER="0"></A></TD>
                                </TR>

                            </TABLE>
                        </TD>
                    </TR>

                </TABLE>
            </TD>
            <!--## �e�{�^���̗̈� Start ########################################################-->

        </TR>

        
        
        <TR>
            <TD COLSPAN="2"></TD>
        </TR>
    </TABLE>
    <BR>
    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="835">
        <TR>
            <TD>
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" BGCOLOR="#999999" WIDTH="700">
                    <TD NOWRAP BGCOLOR="#eeeeee" HEIGHT="15"><B><FONT COLOR="#333333">�����R�����g</FONT></B></TD>
                </TABLE>
            </TD>
            <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="150"><A HREF="javascript:callOldJudComment()"><IMAGE SRC="/webHains/images/oldjudcmnt.gif" ALT="�ߋ������R�����g�ꗗ��\�����܂�" HEIGHT="24" WIDTH="100" BORDER="0"></A></TD>
        </TR>
    </TABLE>
    <BR>
    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="835">
<%
        For i = 0 To lngTtlCmtCnt - 1
%>
            <TR>
                <TD><%= vntTtlJudCmtstc(i) %></TD>
            </TR>
<%
        Next
%>
    </TABLE>
    <BR>
</FORM>
</BODY>
</HTML>