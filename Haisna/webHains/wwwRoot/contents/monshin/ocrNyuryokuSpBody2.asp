<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'      OCR���͌��ʊm�F�i�{�f�B�j  (Ver0.0.1)
'      AUTHER  :
'-----------------------------------------------------------------------------
'�Ǘ��ԍ��FSL-UI-Y0101-103
'�C����  �F2010.06.03�i�V�K�쐬�j
'�S����  �FTCS)�c��
'�C�����e�F�n�b�q�V�[�g�ύX�Ή�
'�Ǘ��ԍ��FSL-SN-Y0101-607
'�C����  �F2011.12.22
'�S����  �FSOAR)�|���
'�C�����e�F�O�񕡎ʃ{�^��

Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/InterviewEditDropDown.inc" -->
<!-- #include virtual = "/webHains/includes/EditJikakushoujyou.inc" -->
<%
'### �Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const GRPCD_OCRNYURYOKU2 = "X0341"   'OCR���͌��ʊm�F�O���[�v�R�[�h
Const GRPCD_ALLERGY = "X052"        '��A�����M�[�O���[�v�R�[�h

'### �擾�����������ʂ̐擪�ʒu[0�`]
Const OCRGRP_START1 =   0   '���a��������
Const OCRGRP_START2 =  90   '�����K����f�P
Const OCRGRP_START3 = 151   '�����K����f�Q
Const OCRGRP_START4 = 176   '�w�l�Ȗ�f
Const OCRGRP_START5 = 290   '�H�K����f
Const OCRGRP_START6 = 326   '���H
Const OCRGRP_START7 = 409   '���H
Const OCRGRP_START8 = 492   '�[�H
Const OCRGRP_START9 = 575   '���茒�f
Const OCRGRP_START10 = 577   'OCR���͒S����
Const OCRGRP_START_Z = 578   '�O�R�[�h�p�@�O��l�o�͗p(�ꕔ�̍���)

'### ���X�g�{�b�N�X�̐�
Const NOWDISEASE_COUNT  = 6         '���a���̌���
Const DISEASEHIST_COUNT = 6         '�������̌���
Const FAMILYHIST_COUNT  = 6         '�Ƒ����̌���


'### �f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon           '���ʃN���X
Dim objConsult          '��f�N���X
Dim objResult           '�������ʃA�N�Z�X�p
Dim objPerResult        '�l�������ʏ��A�N�Z�X�p
Dim objRslOcrSp         'OCR���͌��ʃA�N�Z�X�p
Dim objSentence         '���͏��A�N�Z�X�p
Dim objHainsUser        '���[�U�[���p

'�p�����[�^
Dim lngRsvNo            '�\��ԍ��i���񕪁j
Dim strAnchor           '�\���J�n�ʒu
Dim strAction           '�������(�ۑ��{�^��������:"check" �� "save")

'��f���p�ϐ�
Dim strPerId            '�lID
Dim lngAge              '�N��
Dim lngGender           '����

'�l�������ڏ��p�ϐ�
Dim vntPerItemCd        '�������ڃR�[�h
Dim vntPerSuffix        '�T�t�B�b�N�X
Dim vntPerItemName      '�������ږ�
Dim vntPerResult        '��������
Dim vntPerResultType    '���ʃ^�C�v
Dim vntPerItemType      '���ڃ^�C�v
Dim vntPerStcItemCd     '���͎Q�Ɨp���ڃR�[�h
Dim vntPerStcCd         '���̓R�[�h
Dim vntPerShortStc      '���͗���
Dim vntPerIspDate       '������
Dim lngPerRslCount      '�l�������ڏ��

'OCR���͌��ʏ��
Dim vntPerId            '�lID
Dim vntCslDate          '��f��
Dim vntRsvNo            '�\��ԍ�
Dim vntItemCd           '�������ڃR�[�h
Dim vntSuffix           '�T�t�B�b�N�X
Dim vntItemName         '�������ږ���
Dim vntRslFlg           '�������ʑ��݃t���O
Dim vntResult           '��������
Dim vntStopFlg          '�������~�t���O
Dim vntLstCslDate       '�O���f��
Dim vntLstRsvNo         '�O��\��ԍ�
Dim vntLstRslFlg        '�O�񌟍����ʑ��݃t���O
Dim vntLstResult        '�O�񌟍�����
Dim vntLstStopFlg       '�O�񌟍����~�t���O
Dim vntErrCount         '�G���[��
Dim vntErrNo            '�G���[No
Dim vntErrState         '�G���[���
Dim vntErrMsg           '�G���[���b�Z�[�W
Dim lngRslCnt           '�������ʐ�

'�������ʍX�V���
Dim strUpdUser          '�X�V��
Dim strIPAddress        'IP�A�h���X
Dim strArrMessage       '�G���[���b�Z�[�W

Dim lngErrCnt_E         '�G���[���i�G���[�j
Dim lngErrCnt_W         '�G���[���i�x���j
Dim lngIndex            '�C���f�b�N�X
Dim Ret                 '���A�l
Dim strHTML             'HTML������
Dim strLstRsl           '�O��l������
Dim i, j                '�J�E���^�[
Dim strLstDiffMsg       '�O��l�Ƃ̍������b�Z�[�W

Dim strOpeNameStcCd     'OCR���͒S���҃R�[�h
Dim strOpeNameStc       'OCR���͒S����

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objConsult      = Server.CreateObject("HainsConsult.Consult")
Set objPerResult    = Server.CreateObject("HainsPerResult.PerResult")
Set objRslOcrSp     = Server.CreateObject("HainsRslOcrSp2.OcrNyuryokuSp2")

'�����l�̎擾
lngRsvNo        = Request("rsvno")
strAnchor       = Request("anchor")
strAction       = Request("act")
vntItemCd       = ConvIStringToArray(Request("ItemCd"))
vntSuffix       = ConvIStringToArray(Request("Suffix"))
vntResult       = ConvIStringToArray(Request("ChgRsl"))
vntStopFlg      = ConvIStringToArray(Request("StopFlg"))

lngErrCnt_E = 0
lngErrCnt_W = 0

Do
    '��f��񌟍��i�\��ԍ����l���擾�j
    Ret = objConsult.SelectConsult(lngRsvNo, _
                                    , , _
                                    strPerId, _
                                    , , , , , , , _
                                    lngAge, _
                                    , , , , , , , , , , , , , , , _
                                    0, , , , , , , , , , , , , , , _
                                    , , , , , _
                                    lngGender _
                                    )

    '�I�u�W�F�N�g�̃C���X�^���X�폜
    Set objConsult = Nothing

    '��f��񂪑��݂��Ȃ��ꍇ�̓G���[�Ƃ���
    If Ret = False Then
        Err.Raise 1000, , "��f��񂪑��݂��܂���B�i�\��ԍ�= " & lngRsvNo & " )"
    End If

    '�l�������ʏ��擾�i��܁i�u�X�R�p���j�A�����M�[�j
    lngPerRslCount = objPerResult.SelectPerResultGrpList( strPerId, _
                                                        GRPCD_ALLERGY, _
                                                        0, 1, _
                                                        vntPerItemCd, _
                                                        vntPerSuffix, _
                                                        vntPerItemName, _
                                                        vntPerResult, _
                                                        vntPerResultType, _
                                                        vntPerItemType, _
                                                        vntPerStcItemCd, _
                                                        vntPerShortStc, _
                                                        vntPerIspDate _
                                                        )
    '�I�u�W�F�N�g�̃C���X�^���X�폜
    Set objPerResult = Nothing

    If lngPerRslCount < 0 Then
        Err.Raise 1000, , "�l�������ʏ�񂪑��݂��܂���B�i�lID= " & strPerId & " )"
    End If

    If strAction = "" Then
        'OCR���͌��ʂ��擾����
        lngRslCnt = objRslOcrSp.SelectOcrNyuryoku( _
                            lngRsvNo, _
                            GRPCD_OCRNYURYOKU2, _
                            2, _
                            "MONSHIN", _
                            vntPerId, _
                            vntCslDate, _
                            vntRsvNo, _
                            vntItemCd, _
                            vntSuffix, _
                            vntItemName, _
                            vntRslFlg, _
                            vntResult, _
                            vntStopFlg, _
                            vntLstCslDate, _
                            vntLstRsvNo, _
                            vntLstRslFlg, _
                            vntLstResult, _
                            vntLstStopFlg, _
                            vntErrCount, _
                            vntErrNo, _
                            vntErrState, _
                            vntErrMsg _
                            )
        If lngRslCnt < 0 Then
            Err.Raise 1000, , "OCR���͌��ʂ��擾�ł��܂���B�i�\��ԍ� = " & lngRsvNo & ")"
        End If
    Else
        '�`�F�b�N
        If strAction = "check" Then
            'OCR���͌��ʂ̓��̓`�F�b�N
            lngRslCnt = objRslOcrSp.CheckOcrNyuryoku( _
                                lngRsvNo, _
                                GRPCD_OCRNYURYOKU2, _
                                0, _
                                "", _
                                vntItemCd, _
                                vntSuffix, _
                                vntResult, _
                                vntStopFlg, _
                                vntErrCount, _
                                vntErrNo, _
                                vntErrState, _
                                vntErrMsg _
                                )
            If lngRslCnt < 0 Then
                Err.Raise 1000, , "OCR���͌��ʂ��擾�ł��܂���B�i�\��ԍ� = " & lngRsvNo & ")"
            End If

            If vntErrCount = 0 Then
                '�G���[�Ȃ��̂Ƃ��͈��������ۑ��������s��
                strAction = "save"
            Else
                '��ԕʃG���[���J�E���g
                For i=0 To vntErrCount - 1
                    Select Case vntErrState(i)
                    Case "1"    '�G���[
                        lngErrCnt_E = lngErrCnt_E + 1
                    Case "2"    '�x��
                        lngErrCnt_W = lngErrCnt_W + 1
                    End Select
                Next

                '�G���[������ꍇ�͂��̍��ڂ�擪�\������
                strAnchor = "Anchor-ErrInfo" & vntErrNo(0)

                'OCR���͌��ʂ��擾����(�������ʁA�������~�t���O�A�G���[���̓`�F�b�N���ʂ��g�p)
                lngRslCnt = objRslOcrSp.SelectOcrNyuryoku( _
                                    lngRsvNo, _
                                    GRPCD_OCRNYURYOKU2, _
                                    0, _
                                    "", _
                                    vntPerId, _
                                    vntCslDate, _
                                    vntRsvNo, _
                                    vntItemCd, _
                                    vntSuffix, _
                                    vntItemName, _
                                    vntRslFlg, _
                                    , _
                                    , _
                                    vntLstCslDate, _
                                    vntLstRsvNo, _
                                    vntLstRslFlg, _
                                    vntLstResult, _
                                    vntLstStopFlg _
                                    )
                If lngRslCnt < 0 Then
                    Err.Raise 1000, , "OCR���͌��ʂ��擾�ł��܂���B�i�\��ԍ� = " & lngRsvNo & ")"
                End If
            End If
        End If

        '�ۑ�
        If strAction = "save" Then
            '�X�V�҂̐ݒ�
            strUpdUser = Session("USERID")
            'IP�A�h���X�̎擾
            strIPAddress = Request.ServerVariables("REMOTE_ADDR")

            '�������ʍX�V
            Ret = objRslOcrSp.UpdateOcrNyuryoku( _
                                                lngRsvNo, _
                                                strIPAddress, _
                                                strUpdUser, _
                                                vntItemCd, _
                                                vntSuffix, _
                                                vntResult, _
                                                , , _
                                                strArrMessage, _
                                                vntStopFlg _
                                                )

            If Ret = False Then
                'OCR���͌��ʂ��擾����(�������ʁA�G���[���̓`�F�b�N���ʂ��g�p)
                lngRslCnt = objRslOcrSp.SelectOcrNyuryoku( _
                                    lngRsvNo, _
                                    GRPCD_OCRNYURYOKU2, _
                                    0, _
                                    "", _
                                    vntPerId, _
                                    vntCslDate, _
                                    vntRsvNo, _
                                    vntItemCd, _
                                    vntSuffix, _
                                    vntItemName, _
                                    vntRslFlg, _
                                    , _
                                    , _
                                    vntLstCslDate, _
                                    vntLstRsvNo, _
                                    vntLstRslFlg, _
                                    vntLstResult, _
                                    vntLstStopFlg _
                                    )
                If lngRslCnt < 0 Then
                    Err.Raise 1000, , "OCR���͌��ʂ��擾�ł��܂���B�i�\��ԍ� = " & lngRsvNo & ")"
                End If

                Exit Do
            Else
                '�I�u�W�F�N�g�̃C���X�^���X�폜
                Set objRslOcrSp = Nothing

                '�G���[���Ȃ���ĕ\��
                strHTML = "<HTML>"
                strHTML = strHTML & "<BODY ONLOAD=""javascript:top.params.nomsg=1; top.parent.location.reload()"">"
                strHTML = strHTML & "</BODY>"
                strHTML = strHTML & "</HTML>"
                Response.Write strHTML
                Response.End
            End If
        End If
    End If

    '�I�u�W�F�N�g�̃C���X�^���X�폜
    Set objRslOcrSp = Nothing

Exit Do
Loop

'-------------------------------------------------------------------------------
'�h���b�v�_�E�����X�g�i�Œ�l�j
'-------------------------------------------------------------------------------
Dim strArrCode1         '�R�[�h(�a��)
Dim strArrName1         '����(�a��)
Dim strArrCode2         '�R�[�h(���Ï�)
Dim strArrName2         '����(���Ï�)
Dim strArrCode3         '�R�[�h(����)
Dim strArrName3         '����(����)

'*** �a�� ***
'### 2010.12.18 MOD STR TCS)H.F
'strArrCode1 = Array( _
'                    "1",  "2",  "3",  "4",  "5",  "6",  "7",  "8",  "9",  "10", _
'                    "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", _
'                    "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", _
'                    "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", _
'                    "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", _
'                    "51", "52", "53", "54", "55", _
'                    "98", "99", _
'                    "101", "102", "103", "104", "105", "106", "107", "108", "109",_
'                    "201", "202", "203", "204", "205", "206", "207", "208", "209", "210", _
'                    "211", "212", "213", "214", "215", "216", "217", _
'                    "XXX" _
'                    )
'strArrName1 = Array( _
'                    "�]���", "�]�[��", "�N�������o��", "�]�o��", "��ߐ��]��������", "�Γ���", "������", "���A�a�Ԗ���", "���̑��̊�Ȏ���", "�b��B�@�\�ቺ��", _
'                    "�b��B�@�\���i��", "���j�E������", "�x����", "�x���ۏ�", "�x�C��", "�C�ǎx���񂻂�", "�C�ǎx�g����", "�����C�ǎx��", "������", "���S��", _
'                    "�S�؍[��", "�S�[���u������", "�S�����u������", "�S���ٖ���", "�s����", "�H������", "�݂���", "�ݒ��", "�݃|���[�v", "�\��w�����", _
'                    "�咰����", "�咰�|���[�v", "������", "��", "�_�Ώ�", "�_�̂��|���[�v", "�����X��", "�̂���", "�a�^�̉�", "�b�^�̉�", _
'                    "�̍d��", "�t���E�l�t���[�[", "�t����", "�A�H����", "�O���B����", "�O���B���", "�����ُ�ǁi�������ǁj", "���A�a", "���t����", "�n��", _
'                    "�ɕ��E���A�_����", "�_�o��", "���a", "�G���B��", "�����t�s�S", _
'                    "���̑�", "���̑��̂���", _
'                    "�q�{�z����", "�q�{�̂���", "�����X��i��ᇁj", "�q�{������", "�q�{�؎�", "�q�{�זE�f�ُ�", "������", "���B��", "�X�N����Q", _
'                    "�b��B����", "�P���a", "�}���X��", "�哮���", "����", "�t�s�S", "�O���B�o�r�`���l", "���̑��̐S����", "���̑��̐_�o�؎���", "���̑��̏㕔�����ǎ���", _
'                    "���̑��̑咰����", "���̑��̊̎���", "���̑��̑O���B����", "���̑��̓��[����", "�畆�Ȏ���", "���@�Ȏ���", "���`�O�Ȏ���", _
'                    "�����ُ͈�" _
'                    )
strArrCode1 = Array( _
                    "1",  "2",  "3",  "4",  "5",  "6",  "7",  "8",  "9",  "10", _
                    "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", _
                    "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", _
                    "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", _
                    "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", _
                    "51", "52", "53", "54", "55", _
                    "56", "57", "58", "59", "60", "61", "62", "63", "65", "66", _
                    "67", "68", "69", "70", "71", "72", "73", "74", "75", "76", _
                    "98", "99", _
                    "101", "102", "103", "104", "105", "106", "107", "108", "109",_
                    "110", "111", "112", "113", "114", "115",_
                    "201", "202", "203", "204", "205", "206", "207", "208", "209", "210", _
                    "211", "212", "213", "214", "215", "216", "217", _
                    "XXX" _
                    )
strArrName1 = Array( _
                    "�]���", "�]�[��", "�N�������o��", "�]�o��", "��ߐ��]��������", "�Γ���", "������", "���A�a�Ԗ���", "���̑��̊�Ȏ���", "�b��B�@�\�ቺ��", _
                    "�b��B�@�\���i��", "���j�E������", "�x����", "�x���ۏ�", "�x�C��", "�C�ǎx���񂻂�", "�C�ǎx�g����", "�����C�ǎx��", "������", "���S��", _
                    "�S�؍[��", "�S�[���u������", "�S�����u������", "�S���ٖ���", "�s����", "�H������", "�݂���", "�ݒ��", "�݃|���[�v", "�\��w�����", _
                    "�咰����", "�咰�|���[�v", "������", "��", "�_�Ώ�", "�_�̂��|���[�v", "�����X��", "�̂���", "�a�^�̉�", "�b�^�̉�", _
                    "�̍d��", "�t���E�l�t���[�[", "�t����", "�A�H����", "�O���B����", "�O���B���", "�����ُ�ǁi�������ǁj", "���A�a", "���t����", "�n��", _
                    "�ɕ��E���A�_����", "�_�o��", "���a", "�G���B��", "�����t�s�S", _
                    "�p�[�L���\��", "�x��", "�����ǐ��x�����iCOPD�j�F�x�C����܂�", "�Ԏ����x��", "�C��", "���������ċz�ǌ�Q", "���^�i�񌋊j���j�R�_�ۏ�", "���A�a�E������", "�H���Ö��", "�t�����H����", _
                    "�H���|���[�v", "�w���R�o�N�^�[�s����������", "��ᇐ�����", "�N���[���a", "����������", "�A���R�[�����̏�Q", "���b��", "�", "����", "���e���傤��", _
                    "���̑�", "���̑��̂���", _
                    "�q�{�z����", "�q�{�̂���", "�����X��i��ᇁj", "�q�{������", "�q�{�؎�", "�q�{�זE�f�ُ�", "������", "���B��", "�X�N����Q", _
                    "�q�{�򕔍זE�f�ُ�", "�q�{�̕��i�����j�זE�f�ُ�", "�����q�{�����ǁi�q�{�B�؏ǁj", "�O���q�{�����ǁi�����`���R���[�g�X��E�q�{�����ǂ�", "�������(�����E����E���ԌQ�E���E�^)", "������ᇁi�ǐ��j", _
                    "�b��B����", "�P���a", "�}���X��", "�哮���", "����", "�t�s�S", "�O���B�o�r�`���l", "���̑��̐S����", "���̑��̐_�o�؎���", "���̑��̏㕔�����ǎ���", _
                    "���̑��̑咰����", "���̑��̊̎���", "���̑��̑O���B����", "���̑��̓��[����", "�畆�Ȏ���", "���@�Ȏ���", "���`�O�Ȏ���", _
                    "�����ُ͈�" _
                    )
'### 2010.12.18 MOD END TCS)H.F

'*** ���Ï� ***
''### 2010.12.18 MOD STR TCS)H.F
'strArrCode2 = Array( _
'                    "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11",_
'                    "XXX" _
'                    )
'strArrName2 = Array( _
'                    "��p���܎��Ò�", _
'                    "��p���܂Ȃ���f��", _
'                    "���������؏����܎��Ò�", _
'                    "���������؏����܂Ȃ���f��", _
'                    "��܎��Ò�", _
'                    "��܂Ȃ���f��", _
'                    "��p�㎡�ÏI��", _
'                    "���������؏��㎡�ÏI��", _
'                    "���ÏI��", _
'                    "���u���邢�͎��Ò��f", _
'                    "���͎��Ò�", _
'                    "�����ُ͈�" _
'                    )
strArrCode2 = Array( _
                    "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11","12","13","14",_
                    "XXX" _
                    )
strArrName2 = Array( _
                    "��p���܎��Ò�", _
                    "��p���܂Ȃ���f��", _
                    "���������؏����܎��Ò�", _
                    "���������؏����܂Ȃ���f��", _
                    "��܎��Ò�", _
                    "��܂Ȃ���f��", _
                    "��p�㎡�ÏI��", _
                    "���������؏��㎡�ÏI��", _
                    "���ÏI��", _
                    "���u���邢�͎��Ò��f", _
                    "���͎��Ò�", _
                    "���o�����؏���E��܎��Ò�", _
                    "���o�����؏���E��܂Ȃ���f��", _
                    "���o�����؏���E���ÏI��", _
                    "�����ُ͈�" _
                    )
''### 2010.12.18 MOD END TCS)H.F
'*** ���� ***
''### 2010.12.18 MOD STR TCS)H.F
'strArrCode3 = Array( _
'                    "1", "2", "3", "4", _
'                    "XXX" _
'                    )
'strArrName3 = Array( _
'                    "���e", _
'                    "��e", _
'                    "�Z��E�o��", _
'                    "�c����", _
'                    "�����ُ͈�" _
'                    )
strArrCode3 = Array( _
                    "1", "2", "3", "4", "5", _
                    "XXX" _
                    )
strArrName3 = Array( _
                    "���e", _
                    "��e", _
                    "�Z��E�o��", _
                    "�c����", _
                    "�����E����", _
                    "�����ُ͈�" _
                    )
''### 2010.12.18 MOD END TCS)H.F

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �������ʂ̃^�O����
'
' �����@�@ : (In)     vntIndex          �擪�C���f�b�N�X
' �@�@�@�@   (In)     vntType           INPUT�̑���(TYPE)
' �@�@�@�@   (In)     vntName           INPUT�̑���(NAME)
' �@�@�@�@   (In)     vntSize           INPUT�̑���(SIZE)
' �@�@�@�@   (In)     vntOnValue        INPUT�̑���(VALUE) �����W�I�{�^���̂ݎg�p
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function EditRsl(vntIndex, vntType, vntName, vntSize, vntOnValue)
    Dim strFuncName
    Dim lngResult
    Dim strArrCode
    Dim strArrName

    Dim blnSearchFlg
    Dim i


    EditRsl = ""
    strFuncName = "javascript:document.entryForm.ChgRsl[" & vntIndex & "].value = this.value"

    Select Case vntType
    Case "text"         '�e�L�X�g
        EditRsl = "<INPUT TYPE=""text"" NAME=""" & vntName & """ SIZE=""" & vntSize & """  MAXLENGTH=""8"" STYLE=""text-align:right"" VALUE=""" & vntResult(vntIndex) & """"
        EditRsl = EditRsl & " ONCHANGE=""" & strFuncName & """>"

    Case "checkbox"     '�`�F�b�N�{�b�N�X
        EditRsl = "<INPUT TYPE=""checkbox"" NAME=""" & vntName & """ VALUE=""" & vntOnValue & """" & IIf(vntResult(lngIndex)=vntOnValue, " CHECKED", "")
        EditRsl = EditRsl & " ONCLICK=""javascript:clickRsl( this, " & vntIndex & ")"">"

    Case "radio"        '���W�I�{�^��
        EditRsl = "<INPUT TYPE=""radio"" NAME=""" & vntName & """ VALUE=""" & vntOnValue & """" & IIf(vntResult(lngIndex)=vntOnValue, " CHECKED", "")
        EditRsl = EditRsl & " ONCLICK=""javascript:clickRsl( this, " & vntIndex & ")"">"

    Case "list1"        '�h���b�v�_�E�����X�g�i�a���j
        '���̓R�[�h�̃`�F�b�N
        blnSearchFlg = False
        If vntResult(vntIndex) = "" Then
            blnSearchFlg = True
        Else
            For i=0 To UBound(strArrCode1)
                If vntResult(vntIndex) = strArrCode1(i) Then
                    blnSearchFlg = True
                    Exit For
                End If
            Next
        End If
        '�I�����ȊO�̏ꍇ�͒l�𖳌��Ƃ���
        If blnSearchFlg = False Then
            vntResult(vntIndex) = "XXX"
        End If

        EditRsl = EditDropDownListFromArray2(vntName, strArrCode1, strArrName1, vntResult(vntIndex), NON_SELECTED_ADD, strFuncName)

    Case "disease"      '�a���I��p�e�L�X�g
        EditRsl = "<INPUT TYPE=""text"" NAME=""disease"" SIZE=""" & vntSize & """  MAXLENGTH=""3"" STYLE=""text-align:right"" VALUE="""""
        EditRsl = EditRsl & " ONCHANGE=""javascript:SelectDiseaseList(document.entryForm." & vntName & ", this)"""
        EditRsl = EditRsl & " ONKEYPRESS=""javascript:Disease_KeyPress(document.entryForm." & vntName & ", this)"""
        EditRsl = EditRsl & ">"

    Case "list2"        '�h���b�v�_�E�����X�g�i���Ï󋵁j
        '���̓R�[�h�̃`�F�b�N
        blnSearchFlg = False
        If vntResult(vntIndex) = "" Then
            blnSearchFlg = True
        Else
            For i=0 To UBound(strArrCode2)
                If vntResult(vntIndex) = strArrCode2(i) Then
                    blnSearchFlg = True
                    Exit For
                End If
            Next
        End If
        '�I�����ȊO�̏ꍇ�͒l�𖳌��Ƃ���
        If blnSearchFlg = False Then
            vntResult(vntIndex) = "XXX"
        End If

        EditRsl = EditDropDownListFromArray2(vntName, strArrCode2, strArrName2, vntResult(vntIndex), NON_SELECTED_ADD, strFuncName)

    Case "list3"        '�h���b�v�_�E�����X�g�i�����j
        '���̓R�[�h�̃`�F�b�N
        blnSearchFlg = False
        If vntResult(vntIndex) = "" Then
            blnSearchFlg = True
        Else
            For i=0 To UBound(strArrCode3)
                If vntResult(vntIndex) = strArrCode3(i) Then
                    blnSearchFlg = True
                    Exit For
                End If
            Next
        End If
        '�I�����ȊO�̏ꍇ�͒l�𖳌��Ƃ���
        If blnSearchFlg = False Then
            vntResult(vntIndex) = "XXX"
        End If

        EditRsl = EditDropDownListFromArray2(vntName, strArrCode3, strArrName3, vntResult(vntIndex), NON_SELECTED_ADD, strFuncName)

    Case "listyear"     '�h���b�v�_�E�����X�g�i�N�j
        '���̓R�[�h�̃`�F�b�N
        If IsNumeric(vntResult(vntIndex)) Then
            lngResult = CLng(vntResult(vntIndex))
            '�I�����ȊO�̏ꍇ�͒l�𖳌��Ƃ���
            If lngResult < YEARRANGE_MIN Or YEARRANGE_MAX < lngResult Then
                lngResult = ""
            End If
        Else
            lngResult = ""
        End If
        vntResult(vntIndex) = lngResult

        EditRsl = EditSelectNumberList2(vntName, YEARRANGE_MIN, YEARRANGE_MAX, vntResult(vntIndex), strFuncName)

    Case "listmonth"    '�h���b�v�_�E�����X�g�i���j
        '���̓R�[�h�̃`�F�b�N
        If IsNumeric(vntResult(vntIndex)) Then
            lngResult = CLng(vntResult(vntIndex))
            '�I�����ȊO�̏ꍇ�͒l�𖳌��Ƃ���
            If lngResult < 1 Or 12 < lngResult Then
                lngResult = ""
            End If
        Else
            lngResult = ""
        End If
        vntResult(vntIndex) = lngResult

        EditRsl = EditSelectNumberList2(vntName, 1, 12, lngResult, strFuncName)

    Case "listday"      '�h���b�v�_�E�����X�g�i���j
        '���̓R�[�h�̃`�F�b�N
        If IsNumeric(vntResult(vntIndex)) Then
            lngResult = CLng(vntResult(vntIndex))
            '�I�����ȊO�̏ꍇ�͒l�𖳌��Ƃ���
            If lngResult < 1 Or 31 < lngResult Then
                lngResult = ""
            End If
        Else
            lngResult = ""
        End If
        vntResult(vntIndex) = lngResult

        EditRsl = EditSelectNumberList2(vntName, 1, 31, lngResult, strFuncName)

    End Select

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���̓R�[�h�̃`�F�b�N���s��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CheckStcCd(Result, ArrCode)
    Dim blnSearchFlg
    Dim i

    blnSearchFlg = False
    For i=0 To UBound(ArrCode)
        If Result = ArrCode(i) Then
            blnSearchFlg = True
            Exit For
        End If
    Next
    '�I�����ȊO�̏ꍇ�͒l�𖳌��Ƃ���
    If blnSearchFlg = False Then
        Result = ""
    End If

End Function

Dim ErrInfoNo	'�G���[No
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �G���[���̃^�O����
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function EditErrInfo()
    Dim strAnchor

    ErrInfoNo =ErrInfoNo + 1

    strAnchor = "Anchor-ErrInfo" & ErrInfoNo

    EditErrInfo = "<SPAN ID=""" &  strAnchor & """ STYLE=""position:relative""></SPAN>"

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �����̃^�O����
'
' �����@�@ : (In)     vntIndex          �擪�C���f�b�N�X
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub EditMenuList(vntIndex)

    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
'---�G���[���---
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & "<TABLE BORDER=""0"" CELLSPACING=""2"" CELLPADDING=""2"">" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""20""><TD>&nbsp;</TD></TR>" & vbLf
    For i=0 To 30
        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
        strHTML = strHTML & "<TD NOWRAP WIDTH=""16"">" & EditErrInfo & "</TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Next
    strHTML = strHTML & "</TABLE>" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'----------------
    strHTML = strHTML & "<TD NOWRAP WIDTH=""750"">" & vbLf
    strHTML = strHTML & "<TABLE BORDER=""0"" CELLSPACING=""2"" CELLPADDING=""2"">" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""20"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP COLSPAN=""3"">��H</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP><IMG SRC=""../../images/spacer.gif"" WIDTH=""21"" HEIGHT=""21""></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP COLSPAN=""3"">���</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP><IMG SRC=""../../images/spacer.gif"" WIDTH=""21"" HEIGHT=""21""></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP COLSPAN=""3"">����</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    '��ʏ�킩��ɂ����̂ŕ\��
    Select Case vntIndex
    Case OCRGRP_START6  '���H
        strHTML = strHTML & "<TD ROWSPAN=""31"" BGCOLOR=""#ffe4b5"" ALIGN=""center"">��</TD>" & vbLf
    Case OCRGRP_START7  '���H
        strHTML = strHTML & "<TD ROWSPAN=""31"" BGCOLOR=""#f0e68c"" ALIGN=""center"">��</TD>" & vbLf
    Case OCRGRP_START8  '�[�H
        strHTML = strHTML & "<TD ROWSPAN=""31"" BGCOLOR=""#add8e6"" ALIGN=""center"">�[</TD>" & vbLf
    End Select
lngIndex = vntIndex + 1
    strHTML = strHTML & "<TD ROWSPAN=""4"" BGCOLOR=""#eeeeee"" ALIGN=""center"">��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">���сi�����p���q�j</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�t</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 32
    strHTML = strHTML & "<TD ROWSPAN=""6"" BGCOLOR=""#e0ffff"" ALIGN=""center"">��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e0ffff"">�h�g���荇�킹</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e0ffff"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 63
    strHTML = strHTML & "<TD ROWSPAN=""13"" BGCOLOR=""#98fb98"" ALIGN=""center"">��ؗ���</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">��؃T���_</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�M</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 2
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">���сi�j���p���q�j</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�t</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 33
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e0ffff"">�ϋ��E�ċ�<FONT SIZE=""-1"">�i�Ԃ�A����܁A���킵���j</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e0ffff"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 64
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">�@�m���I�C���h���b�V���O</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�t</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 3
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">���сi�ǂ�Ԃ蒃�q�j</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�t</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 34
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e0ffff"">�ϋ��E�ċ�<FONT SIZE=""-1"">�i���ꂢ�A����A�Ђ�ߓ��j</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e0ffff"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 65
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">�@�}���l�[�Y</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�t</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 4
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">���ɂ���</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 35
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e0ffff"">���̃��j�G��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e0ffff"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 66
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">�@�h���b�V���O</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�t</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 5
    strHTML = strHTML & "<TD ROWSPAN=""9"" BGCOLOR=""#eee8aa"" ALIGN=""center"">�߂�</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">���΁E���ǂ�i�V�Ղ�j</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�t</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 36
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e0ffff"">�G�r�`��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e0ffff"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 67
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">�@��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�܂�</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 6
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">���΁E���ǂ�i���ʂ��j</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�t</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 37
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e0ffff"">�����</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e0ffff"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 68
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">�|�e�g�E�}�J���j�T���_</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 7
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">���΁E���ǂ�i����E�����j</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�t</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 38
    strHTML = strHTML & "<TD ROWSPAN=""9"" BGCOLOR=""#ffc0cb"" ALIGN=""center"">��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">�X�e�[�L(150g)</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 69
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">�ϕ��i�����j</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 8
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">���[����</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�t</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 39
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">�Ă���</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 70
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">�ϕ��i��؂̂݁j</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 9
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">�ܖڃ��[����</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�t</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 40
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">�Ƃ�̓��g</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 71
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">�ϕ��i�Ђ����E���z���j</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 10
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">�Ă�����</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�M</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 41
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">�n���o�[�O</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 72
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">�����Ⴊ</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 11
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">�X�p�Q�b�e�B�i�N���[���j</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 42
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">�V�`���[</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 73
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">����u�߁i���Ȃ��j</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 12
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">�X�p�Q�b�e�B�i���̑��j</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 43
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">������u��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 74
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">���Ђ���</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 13
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">�}�J���j�O���^��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 44
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">�L�q�E�V���E�}�C</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 75
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">�|�̕�</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#98fb98"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 14
    strHTML = strHTML & "<TD ROWSPAN=""8"" BGCOLOR=""#f5deb3"" ALIGN=""center"">�p��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f5deb3"">�H�p���U���؂�</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f5deb3"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 45
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">�n���E�E�B���i�[</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 76
    strHTML = strHTML & "<TD ROWSPAN=""3"" BGCOLOR=""#ffdead"" ALIGN=""center"">�`</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffdead"">���X�`</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffdead"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�t</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 15
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f5deb3"">�H�p���W���؂�</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f5deb3"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 46
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">�x�[�R��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 77
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffdead"">�R���\��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffdead"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�t</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 16
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f5deb3"">�@�o�^�[</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f5deb3"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�t</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 47
    strHTML = strHTML & "<TD ROWSPAN=""4"" BGCOLOR=""#f0e68c"" ALIGN=""center"">�g����</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">�t���C�i�R���b�P�j</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 78
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffdead"">�|�^�[�W��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffdead"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�t</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 17
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f5deb3"">�@�}�[�K����</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f5deb3"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�t</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 48
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">�t���C�i�g���J�c�j</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 79
    strHTML = strHTML & "<TD ROWSPAN=""4"" BGCOLOR=""#fffacd"" ALIGN=""center"">������i</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#fffacd"">�`�[�Y</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#fffacd"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "��</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 18
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f5deb3"">�@�W������</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f5deb3"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�t</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 49
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">�t���C�i���сj</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 80
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#fffacd"">�}��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#fffacd"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "��</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 19
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f5deb3"">�~�b�N�X�T���h�C�b�`</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f5deb3"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 50
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">�V�Ղ�</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 81
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#fffacd"">�ʕ�</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#fffacd"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "��</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 20
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f5deb3"">�َq�p��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f5deb3"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 51
    strHTML = strHTML & "<TD ROWSPAN=""3"" BGCOLOR=""#eee8aa"" ALIGN=""center"">��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">�����Ă��E����Ԃ���ԓ�</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 82
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#fffacd"">���Е�</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#fffacd"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 21
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f5deb3"">�����p��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f5deb3"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 52
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">���E���炿�蓙</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 22
    strHTML = strHTML & "<TD ROWSPAN=""7"" BGCOLOR=""#f0e68c"" ALIGN=""center"">����</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">�J�c��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�t</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 53
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">���ł�</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eee8aa"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 23
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">�e�q��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�t</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 54
    strHTML = strHTML & "<TD ROWSPAN=""5"" BGCOLOR=""#fffacd"" ALIGN=""center"">��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#fffacd"">�����E��ŗ�</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#fffacd"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 24
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">�V��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�t</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 55
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#fffacd"">�ڋʏĂ�</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#fffacd"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 25
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">���ؘ�</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�t</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 56
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#fffacd"">���Ă�</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#fffacd"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 26
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">�J���[���C�X</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 57
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#fffacd"">�X�N�����u��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#fffacd"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 27
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">�`���[�n���E�s���t</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 58
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#fffacd"">���ɋ�</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#fffacd"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 28
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">�ɂ���E���炵���i</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#f0e68c"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 59
    strHTML = strHTML & "<TD ROWSPAN=""4"" BGCOLOR=""#e6e6fa"" ALIGN=""center"">�����i</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e6e6fa"">��E������</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e6e6fa"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 29
    strHTML = strHTML & "<TD ROWSPAN=""4"" BGCOLOR=""#ffc0cb"" ALIGN=""center"">���̑�</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">���̓��ٓ�</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 60
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e6e6fa"">�[��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e6e6fa"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 30
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">�V���A����</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�M</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 61
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e6e6fa"">�}�[�{����</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e6e6fa"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = vntIndex + 31
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">�~�b�N�X�s�U</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#ffc0cb"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
lngIndex = vntIndex + 62
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e6e6fa"">�ܖړ�</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#e6e6fa"">" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�l�O</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "</TABLE>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    Response.Write strHTML

End Sub
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Adobe GoLive 5">
<TITLE>OCR���͌��ʊm�F�i�V�j</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!-- #include virtual = "/webHains/includes/stcGuide.inc"    -->
<!--
// �������ʂ̑I��������
function clickRsl( Obj, Index ) {

/*** �w�l�Ȗ�f�[��No.4�A13�A15�́u�Ȃ��v�̃`�F�b�N�����̍��ڂ�I���������Ɏ����I�ɏ����� ***/
var lngIndex; 

    // �G�������g�^�C�v���Ƃ̏�������
    switch ( Obj.type ) {
        case 'checkbox':    // �`�F�b�N�{�b�N�X
            if( Obj.checked ) {
                document.entryForm.ChgRsl[Index].value = Obj.value;
                /*** �w�l�Ȗ�f�[��No.7�́u�Ȃ��v�̃`�F�b�N�����̍��ڂ�I���������Ɏ����I�ɏ����� ***/
                lngIndex = <%= OCRGRP_START4 %>;
                if ( Index >= lngIndex + 19 && Index <= lngIndex + 33 ) {
                    document.entryForm.chk4_7_1.checked = false;
                    document.entryForm.ChgRsl[194].value = '';
                }
                ///*************************************************************************************/
            } else {
                document.entryForm.ChgRsl[Index].value = '';
            }
            break;

        case 'radio':       // ���W�I�{�^��
            // �I���ς݂�������x�N���b�N����ƑI������
            if( document.entryForm.ChgRsl[Index].value == Obj.value ) {
                Obj.checked = false;
                document.entryForm.ChgRsl[Index].value = '';
            } else {
                Obj.checked = true;
                document.entryForm.ChgRsl[Index].value = Obj.value;
            }
            break;

        default:
            break;
    }

}

// �a���ŃL�[�������̏���
function Disease_KeyPress( list_disease, text_disease ){

    // Enter�L�[
    if ( event.keyCode == 13 ) {
        // �a���̑I������
        SelectDiseaseList( list_disease, text_disease );
    }
}

// �a���̑I������
function SelectDiseaseList( list_disease, text_disease ) {

    if( text_disease.value == '' ) return;

    // �a������
    for( i=0; i < list_disease.options.length; i++ ) {
        if( list_disease.options[i].value == text_disease.value ) {
            list_disease.selectedIndex = i;
            list_disease.onchange();
            return;
        }
    }
    // ������Ȃ������Ƃ��́A���ُ͈�Ƃ���
    list_disease.selectedIndex = list_disease.options.length-1;
    list_disease.onchange();
}

var lngOpeIndex;  // �K�C�h�\�����ɑI�����ꂽ�G�������g�̃C���f�b�N�X

//OCR���͒S���ґI���E�C���h�E�\��
function showUserWindow(index, OpeItemCd) {

    // �I�����ꂽ�G�������g�̃C���f�b�N�X��ޔ�
    lngOpeIndex = index;

    // �K�C�h��ʂ̘A����Ɍ������ڃR�[�h��ݒ肷��
    stcGuide_ItemCd = OpeItemCd;

    // �K�C�h��ʂ̘A����ɍ��ڃ^�C�v�i�W���j��ݒ肷��
    stcGuide_ItemType = 0;

    // �K�C�h��ʂ̘A����ɃK�C�h��ʂ���Ăяo����鎩��ʂ̊֐���ݒ肷��
    stcGuide_CalledFunction = setOpeInfo;

    // ���̓K�C�h�\��
    showGuideStc();
}

// OCR���͒S���҂̕ҏW
function setOpeInfo( ) {

    document.entryForm.ChgRsl[lngOpeIndex].value = stcGuide_StcCd;

    if ( document.getElementById('OpeName') ) {
        document.getElementById('OpeName').innerHTML = stcGuide_ShortStc;
    }
}

//OCR���͒S���҃N���A
function clrUser(index) {

    document.entryForm.ChgRsl[index].value = '';

    if ( document.getElementById('OpeName') ) {
        document.getElementById('OpeName').innerHTML = '';
    }
}

// �W�����v
function JumpAnchor() {
    var PosY;

    if( document.entryForm.anchor.value != '' ) {
        PosY = document.all(document.entryForm.anchor.value).offsetTop;
        if( document.entryForm.anchor.value.indexOf('Anchor-ErrInfo') >= 0 ) {
            PosY = PosY - 28;
        }
        scrollTo(0, PosY);
    }
}

// SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� ADD STR
//�O�񕡎�
function copyOcrNyuryoku() {
    var myForm = document.entryForm;
    var i, j, n;
    var index;                    //�a���f�[�^�z��̃C���f�b�N�X
    var cntPreByoureki;           //�O��l�̌���
    var cntInputedByoreki;        //������͗��̌���
    var isOver;                   //������͗��̕a��������6�����ǂ����t���O
    var iconNo = 2;               //���b�Z�[�W��ʁi2=�x���j    
    var cntByoreki = new Array(); //���a���A�������A�ߋ����̓o�^�ł���a���̍ő吔
    var idxChgRsls = new Array(); //          �V          �̃C���f�b�N�X
    var arErrNo = new Array();    //          �V          �̃G���[�s�ԍ�
    var arErrMsg = new Array();   //          �V          �̃G���[���b�Z�[�W
    var arCopyByorekiIdx = new Array();//�O��l�z��̕��ʍς݂̕a���C���f�b�N�X
    var arCopyByorekiCd = new Array(); //���ʍςݕa���R�[�h

    //�a�𐔍ő�l
    cntByoreki = new Array(<%= NOWDISEASE_COUNT %>,<%= DISEASEHIST_COUNT %>,<%= FAMILYHIST_COUNT %>);
    //�a���f�[�^�z��̃C���f�b�N�X
    idxChgRsls = new Array(<%= OCRGRP_START1 %> + 5,<%= OCRGRP_START1 %> + 23,<%= OCRGRP_START1 %> + 41);
    //�G���[�s�ԍ�
    arErrNo = new Array(4,10,16);
    //�G���[���b�Z�[�W
    arErrMsg = new Array('�u���a���v��6����葽���o�^�ł��܂���B','�u�������v��6����葽���o�^�ł��܂���B','�u�Ƒ����v��6����葽���o�^�ł��܂���B');
    
    for(n = 0; n < cntByoreki.length; n++){

        //�a�𐔃I�[�o�[�̌x�����b�Z�[�W������΂��폜
        parent.delErrInfo(arErrNo[n], iconNo, arErrMsg[n]);
        document.getElementById("Anchor-ErrInfo"+arErrNo[n]).innerHTML = '';
        
        //�����p�ϐ���������
        index = idxChgRsls[n];
        isOver = new Boolean(false);
        cntInputedByoreki = 0;
        cntPreByoureki = 0;
        arCopyByorekiIdx = new Array();
        arCopyByorekiCd = new Array();

        //�O��l�̌������擾
        for( i=0; i< cntByoreki[n]; i++ ) {
            if( myForm.PreRsl[index+i*3+0].value != ''){
                cntPreByoureki++;
            }
        }

        //-----------------------------------------------------------------
        //���̓`�F�b�N
        //�E�O��l��0��
        //  ����������K�v�Ȃ�
        //�E�O��l��1���ȏ�
        //  ���ЂƂ��`�F�b�N���āA����
        //-----------------------------------------------------------------
        if (cntPreByoureki < 1) {
            //��������K�v�Ȃ�

        }else{

            //������͗� + �O��l = 12�񃋁[�v
            for(idxChgRsl = 0; idxChgRsl < cntByoreki[n] * 2; idxChgRsl++) { 

                //������͗������͂���Ă��邩����
                if((idxChgRsl < 6) && 
                   (myForm.ChgRsl[index+idxChgRsl*3+0].value != '' || 
                    myForm.ChgRsl[index+idxChgRsl*3+1].value != '' || 
                    myForm.ChgRsl[index+idxChgRsl*3+2].value != '')) {
                    //���̂܂܁A�a�𐔂��J�E���g�A�b�v
                    cntInputedByoreki ++;
                } else {

                    if(idxChgRsl < 6){
                        //ChgRsl��������
                        for( j=0; j<3; j++ ) {
                            myForm.ChgRsl[index+idxChgRsl*3+j].value = "";
                        }
                    }
                        
                    //�O��l�̐������[�v
                    for( idxPreRsl=0; idxPreRsl< cntByoreki[n]; idxPreRsl++ ) {

                        //�O��l�̗L�����`�F�b�N
                        if( myForm.PreRsl[index+idxPreRsl*3+0].value != '') {

                            //���L�̂����ꂩ�Ȃ畡�ʑΏۂƂȂ�
                            //�E�O��l��������͗��ɑ��݂��Ȃ�
                            //�E���łɕ��ʂ����O��l�Ɠ����a��
                            if(((myForm.ChgRsl[index+0*3+0].value != myForm.PreRsl[index+idxPreRsl*3+0].value) &&
                                (myForm.ChgRsl[index+1*3+0].value != myForm.PreRsl[index+idxPreRsl*3+0].value) &&
                                (myForm.ChgRsl[index+2*3+0].value != myForm.PreRsl[index+idxPreRsl*3+0].value) &&
                                (myForm.ChgRsl[index+3*3+0].value != myForm.PreRsl[index+idxPreRsl*3+0].value) &&
                                (myForm.ChgRsl[index+4*3+0].value != myForm.PreRsl[index+idxPreRsl*3+0].value) &&
                                (myForm.ChgRsl[index+5*3+0].value != myForm.PreRsl[index+idxPreRsl*3+0].value)) ||
                               ((arCopyByorekiCd.length > 0) &&
                                (arCopyByorekiIdx[0] != idxPreRsl) &&
                                (arCopyByorekiIdx[1] != idxPreRsl) &&
                                (arCopyByorekiIdx[2] != idxPreRsl) &&
                                (arCopyByorekiIdx[3] != idxPreRsl) &&
                                (arCopyByorekiIdx[4] != idxPreRsl) &&
                                (arCopyByorekiIdx[5] != idxPreRsl) &&
                                (arCopyByorekiCd[0] == myForm.PreRsl[index+idxPreRsl*3+0].value ||
                                 arCopyByorekiCd[1] == myForm.PreRsl[index+idxPreRsl*3+0].value ||
                                 arCopyByorekiCd[2] == myForm.PreRsl[index+idxPreRsl*3+0].value ||
                                 arCopyByorekiCd[3] == myForm.PreRsl[index+idxPreRsl*3+0].value ||
                                 arCopyByorekiCd[4] == myForm.PreRsl[index+idxPreRsl*3+0].value ||
                                 arCopyByorekiCd[5] == myForm.PreRsl[index+idxPreRsl*3+0].value))){

                                 //���łɕa����6���o�^����Ă��邩����
                                 if(cntInputedByoreki == 6){
                                     isOver = true;
                                     //��ʉ����̃G���[���b�Z�[�W�X�y�[�X�ɕ\��
                                     parent.addErrInfo(arErrNo[n], iconNo, arErrMsg[n]);
                                     //�e�L�X�g�{�b�N�X�̂������Ɍx���A�C�R���\��
                                     document.getElementById("Anchor-ErrInfo"+arErrNo[n]).innerHTML = '<IMG SRC="../../images/ico_w.gif" WIDTH="16" HEIGHT="16" ALT="'+arErrMsg[n]+'" BORDER="0">';

                                 }else{
                                 
                                     //���ʏ���
                                     for( j=0; j < 3; j++ ) {
                                         //�����ϐ�ChgRsl�ɃR�s�[
                                         myForm.ChgRsl[index+idxChgRsl*3+j].value =  myForm.PreRsl[index+idxPreRsl*3+j].value;

                                         if(j==0) {
                                             //�a��
                                             myForm['list1_'+(n+1)+'_1'+(cntInputedByoreki+1)].value=myForm.ChgRsl[index+idxChgRsl*3+j].value;
                                             //�R���g���[���̃t�H���g��Ԏ��ɂ���
                                             myForm['list1_'+(n+1)+'_1'+(cntInputedByoreki+1)].style.color = 'red';
                                             
                                             //���ʂ����a����ێ����Ă��� ���C���f�b�N�X��
                                             arCopyByorekiIdx.push(idxPreRsl);
                                             arCopyByorekiCd.push(myForm.PreRsl[index+idxPreRsl*3+j].value);

                                         } else if(j==1) {
                                             //�N��
                                             document.getElementsByName('Rsl')[cntInputedByoreki+(6*n)].value = myForm.ChgRsl[index+idxChgRsl*3+j].value;

                                         } else {
                                             //�Ǐ�E����
                                             myForm['list1_'+(n+1)+'_2'+(cntInputedByoreki+1)].value=myForm.ChgRsl[index+idxChgRsl*3+j].value;
                                         }
                                     }
                                     //�a���R�[�h�����󔒂ɂ���B
                                     document.getElementsByName('disease')[cntInputedByoreki+(6*n)].value = '';
                                     //�a�𐔂��J�E���g�A�b�v
                                     cntInputedByoreki ++;
                                 }
                                 break;//���[�v�𔲂���
                            } else {
                                //���łɃ��[�U������͂œo�^�����a��
                                //���������Ȃ�
                            }
                        } else {
                            //������͗��ƑO��l�̗�������
                            //���������Ȃ�
                        }
                    }
                    
                    //�a���I�[�o�[�Ȃ�A���[�v�𔲂���
                    if(isOver == true) break;
                }
            }
        }
    }
    
    //�Q�D�݌������󂯂���͂�����������
    //�i�P�j��p�����ꂽ����
    //�i�Q�j�w���R�o�N�^�[�E�s�����Ɋւ���
    errNoEx = 22;
    arErrMsg = new Array('�u�Q�|�i�P�j��p�����ꂽ���� �v�͍���l�����͍ς݂̂��߁A�O��l�𕡎ʂ��܂���ł����B',
                         '�u�Q�|�i�Q�j�w���R�o�N�^�[�E�s�����Ɋւ��� �v�͍���l�����͍ς݂̂��߁A�O��l�𕡎ʂ��܂���ł����B');
    index = <%= OCRGRP_START1 %> + 59;
    for(i = 0; i < 2; i ++){
        //�x�����b�Z�[�W��������
        parent.delErrInfo((errNoEx+i), iconNo, arErrMsg[i]);
        document.getElementById("Anchor-ErrInfo"+(errNoEx+i)).innerHTML = '';    
    
        name = 'opt1_4_' + (i+1);
        //������͗������`�F�b�N��Ԃ�����
        if(myForm.ChgRsl[i + index].value == ''){
            for(j = 0; j < document.getElementsByName(name).length; j ++){
                if(myForm.PreRsl[i + index].value==document.getElementsByName(name)[j].value){
                    document.getElementsByName(name)[j].checked=true;
                    myForm.ChgRsl[i + index].value=myForm.PreRsl[i + index].value;
                    //���x���J���[��Ԃɂ���
                    document.getElementById('STOMACH'+(i+1)+'_'+(j+1)).style.color='red';
                    break;
                }
            }
        } else if (myForm.PreRsl[i + index].value == myForm.ChgRsl[i + index].value){
            //����l�ƑO��l�������l
            //���������Ȃ�
        } else if (myForm.PreRsl[i + index].value != ''){
            //������͗������͍ς݂��A�O��l������
            //���x�����b�Z�[�W��\��
            parent.addErrInfo((errNoEx+i), iconNo, arErrMsg[i]);
            //�e�L�X�g�{�b�N�X�̂������Ɍx���A�C�R���\��
            document.getElementById("Anchor-ErrInfo"+(errNoEx+i)).innerHTML = '<IMG SRC="../../images/ico_w.gif" WIDTH="16" HEIGHT="16" ALT="'+arErrMsg[i]+'" BORDER="0">';
        }
    }

    //�R�D�ȑO���@�Ŏw�E���󂯂����̂�����΁A���L���������B
    var idName;
    
    index = <%= OCRGRP_START1 %> + 61;
    for( i=0; i< 28; i++ ) {
        idName="";

        //�O��l������A������͗������`�F�b�N��Ԃ�����
        if(myForm.PreRsl[i + index].value != '' &&
           myForm.ChgRsl[i + index].value == '') {
           
            if (i < 7) {
                //�i�P�j�㕔�����ǌ���
                name = 'chk1_5_1_' + (i + 1);
                idName='OTHER_HOSPITAL1_'+ (i + 1);
            } else if (i < 18) {
                //�i�Q�j�㕠�������g����
                name = 'chk1_5_2_' + (i - 6);
                idName='OTHER_HOSPITAL2_'+ (i - 6);
            } else if (i < 24) {
                //�i�R�j�S�d�}����
                name = 'chk1_5_3_' + (i - 17);
                idName='OTHER_HOSPITAL3_'+ (i - 17);
            } else {
                //�i�S�j���[����
                name = 'chk1_5_4_' + (i - 23);
                idName='OTHER_HOSPITAL4_'+ (i - 23);
            }
            //�`�F�b�N��Ԃɂ���
            document.getElementsByName(name)[0].checked=true;
            //���x���L���v�V������ԐF�ɂ���
            document.getElementById(idName).style.color='red';
            //�����p�z��ɔ��f
            myForm.ChgRsl[i + index].value = myForm.PreRsl[i + index].value;
        }
    }

    //���̃t���[���̃G���[���X�g������
    //parent.lngErrCount = 0;
    parent.error.document.entryForm.selectState.selectedIndex = 2;
    parent.error.chgSelect();

    return;
}
// SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� ADD END

//�ۑ�
function saveOcrNyuryoku() {
    var myForm = 	document.entryForm;
    var index;
    var count;
    var buff	= new Array();
    var i, j;

    //**************
    // �ݒ�l�̎擾
    //**************
    if( <%= lngGender %> ==  2 ) {
        // �J�����_�[�K�C�h����ݒ肳�ꂽ�l���擾
        index = <%= OCRGRP_START4 %>;
        myForm.ChgRsl[index + 75].value = myForm.year14_1.value;
        myForm.ChgRsl[index + 76].value = myForm.month14_1.value;
        myForm.ChgRsl[index + 77].value = myForm.day14_1.value;
        myForm.ChgRsl[index + 78].value = myForm.month14_2.value;
        myForm.ChgRsl[index + 79].value = myForm.day14_2.value;
        myForm.ChgRsl[index + 80].value = myForm.year14_3.value;
        myForm.ChgRsl[index + 81].value = myForm.month14_3.value;
        myForm.ChgRsl[index + 82].value = myForm.day14_3.value;
        myForm.ChgRsl[index + 83].value = myForm.month14_4.value;
        myForm.ChgRsl[index + 84].value = myForm.day14_4.value;




    }

    //********
    // �O�l��
    //********
    // ���a��
    index = <%= OCRGRP_START1 %> + 5;
    count = 0;
    for( i=0; i< <%= NOWDISEASE_COUNT %>; i++ ) {
        if( myForm.ChgRsl[index+i*3+0].value != ''
          || myForm.ChgRsl[index+i*3+1].value != ''
          || myForm.ChgRsl[index+i*3+2].value != '' ) {
            for( j=0; j < 3; j++ ) {
                buff[count*3+j] =  myForm.ChgRsl[index+i*3+j].value;
            }
            count ++;
        }
    }
    for( i=0; i< <%= NOWDISEASE_COUNT %>; i++ ) {
        if( i < count ) {
            for( j=0; j < 3; j++ ) {
                myForm.ChgRsl[index+i*3+j].value = buff[i*3+j];
            }
        } else {
            for( j=0; j < 3; j++ ) {
                myForm.ChgRsl[index+i*3+j].value = "";
            }
        }
    }
    // ������
    index = <%= OCRGRP_START1 %> + 23;
    count = 0;
    for( i=0; i< <%= DISEASEHIST_COUNT %>; i++ ) {
        if( myForm.ChgRsl[index+i*3+0].value != ''
          || myForm.ChgRsl[index+i*3+1].value != ''
          || myForm.ChgRsl[index+i*3+2].value != '' ) {
            for( j=0; j < 3; j++ ) {
                buff[count*3+j] =  myForm.ChgRsl[index+i*3+j].value;
            }
            count ++;
        }
    }
    for( i=0; i< <%= DISEASEHIST_COUNT %>; i++ ) {
        if( i < count ) {
            for( j=0; j < 3; j++ ) {
                myForm.ChgRsl[index+i*3+j].value = buff[i*3+j];
            }
        } else {
            for( j=0; j < 3; j++ ) {
                myForm.ChgRsl[index+i*3+j].value = "";
            }
        }
    }
    // �Ƒ���
    index = <%= OCRGRP_START1 %> + 41;
    count = 0;
    for( i=0; i< <%= NOWDISEASE_COUNT %>; i++ ) {
        if( myForm.ChgRsl[index+i*3+0].value != ''
          || myForm.ChgRsl[index+i*3+1].value != ''
          || myForm.ChgRsl[index+i*3+2].value != '' ) {
            for( j=0; j < 3; j++ ) {
                buff[count*3+j] =  myForm.ChgRsl[index+i*3+j].value;
            }
            count ++;
        }
    }
    for( i=0; i< <%= FAMILYHIST_COUNT %>; i++ ) {
        if( i < count ) {
            for( j=0; j < 3; j++ ) {
                myForm.ChgRsl[index+i*3+j].value = buff[i*3+j];
            }
        } else {
            for( j=0; j < 3; j++ ) {
                myForm.ChgRsl[index+i*3+j].value = "";
            }
        }
    }
    // ���o�Ǐ�
    index = <%= OCRGRP_START2 %> + 37;
    count = 0;
    for( i=0; i< <%= JIKAKUSHOUJYOU_COUNT %>; i++ ) {
        if( myForm.ChgRsl[index+i*4+0].value != ''
          || myForm.ChgRsl[index+i*4+1].value != ''
          || myForm.ChgRsl[index+i*4+2].value != ''
          || myForm.ChgRsl[index+i*4+3].value != '' ) {
            for( j=0; j < 4; j++ ) {
                buff[count*4+j] =  myForm.ChgRsl[index+i*4+j].value;
            }
            count ++;
        }
    }
    for( i=0; i< <%= JIKAKUSHOUJYOU_COUNT %>; i++ ) {
        if( i < count ) {
            for( j=0; j < 4; j++ ) {
                myForm.ChgRsl[index+i*4+j].value = buff[i*4+j];
            }
        } else {
            for( j=0; j < 4; j++ ) {
                myForm.ChgRsl[index+i*4+j].value = "";
            }
        }
    }


    //���̃t���[���̃G���[���X�g������
    parent.lngErrCount = 0;
    parent.error.document.entryForm.selectState.selectedIndex = 2;
    parent.error.chgSelect();

    // ���[�h���w�肵��submit
    document.entryForm.act.value = 'check';
    document.entryForm.submit();

    return;
}

// �E�B���h�E�����
function windowClose() {

    // ���t�K�C�h�E�C���h�E�����
    calGuide_closeGuideCalendar();

}
//-->
</SCRIPT>
<%
'-----�\���O����----- 
%>
<SCRIPT TYPE="text/javascript">
<!--
    // �G���[���̏�����
    parent.initErrInfo();

    // �G���[���ǉ�
<%
    For i=0 To vntErrCount - 1
%>
        parent.addErrInfo( <%= vntErrNo(i) %>, <%= vntErrState(i) %>, '<%= vntErrMsg(i) %>' );
<%
    Next
%>
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 20px 0 0 0; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:windowClose()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
    <!-- �����l -->
    <INPUT TYPE="hidden" NAME="rsvno"   VALUE="<%= lngRsvNo %>">
    <INPUT TYPE="hidden" NAME="anchor"  VALUE="<%= strAnchor %>">
    <INPUT TYPE="hidden" NAME="act"     VALUE="<%= strAction %>">
<%
    If Not IsEmpty(strArrMessage) Then
        '�G���[���b�Z�[�W��ҏW
        Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
    End If

    '���������b�Z�[�W��\��
    strHTML = ""
    strHTML = strHTML & "<SPAN ID=""LoadindMessage"">"
    strHTML = strHTML & "<TABLE HEIGHT=""100%"" WIDTH=""100%"">"
    strHTML = strHTML & "<TR ALIGN=""center"" VALIGN=""center""><TD>"
    strHTML = strHTML & "<IMG SRC=""../../images/zzz.gif"">�@<B>�������ł��D�D�D</B>"
    strHTML = strHTML & "</TD></TR>"
    strHTML = strHTML & "</TABLE>"
    strHTML = strHTML & "</SPAN>"
    Response.Write strHTML
    Response.Flush
%>
<!-- 
******************************************************
    ���a��������
******************************************************
 -->
<!-- �Z���^�[�g�p�� -->
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
        <TR HEIGHT="20">
            <TD NOWRAP WIDTH="20"></TD>
            <TD NOWRAP BGCOLOR="#98fb98" WIDTH="730"><SPAN ID="Anchor-DiseaseHistory" STYLE="position:relative">���a���E�������f�[</SPAN></TD>
            <TD NOWRAP BGCOLOR="#98fb98" WIDTH="220">�O��l<%= IIf(vntLstCslDate(0)="", "", "(" & vntLstCslDate(0) & ")") %></TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">�Z���^�[�g�p��</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>

<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START1 + 0
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�h�b�N�S��" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_0_1", , "1") & "�͂��@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_0_1", , "2") & "������" & vbLf
    strHTML = strHTML & "�@�@�@�@" & vbLf
lngIndex = OCRGRP_START1 + 1
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_0_1", , "1") & "�f�e" & vbLf
lngIndex = OCRGRP_START1 + 2
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_0_2", , "1") & "�g�o�u" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    '---�O��l---
    strLstRsl = ""
lngIndex = OCRGRP_START1 + 0
    ' �Z���^�[�g�p��
    Select Case vntLstResult(lngIndex)
    	Case "1"
        	strLstRsl = "�͂�"
    	Case "2"
        	strLstRsl = "������"
    End Select
lngIndex = OCRGRP_START1 + 1
    If vntLstResult(lngIndex)<> "" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", "�@") & "�f�e"
    End If
lngIndex = OCRGRP_START1 + 2
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", "�@") & "�g�o�u"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>

        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">�u�X�R�p����</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START1 + 3
    '��A�����M�[���u����v�̂Ƃ��̓u�X�R�p���ۂ��u�ہv�Ƃ���i�u�v�͑I��s�j
    If vntPerResult(0) = "2" Then
        vntResult(lngIndex) = "2"
        strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
        strHTML = strHTML & "<TD NOWRAP>" & vbLf
        strHTML = strHTML & "�@�@" & "�@�@�@" & vbLf
        strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_0_2", , "2") & "��" & vbLf
        strHTML = strHTML & "</TD>" & vbLf
    Else
        strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
        strHTML = strHTML & "<TD NOWRAP>" & vbLf
        strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_0_2", , "1") & "�@�@�@" & vbLf
        strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_0_2", , "2") & "��" & vbLf
        strHTML = strHTML & "</TD>" & vbLf
    End If
'---�O��l---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "��"
    Case "2"
        strLstRsl = "��"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">���H�ێ�̗L��</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START1 + 4
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_0_3", , "1") & "�͂��@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_0_3", , "2") & "������" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�͂�"
    Case "2"
        strLstRsl = "������"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
<!-- '#### 2010.12.18 MOD STR TCS)H.F ####' -->
<!--
            <TD NOWRAP BGCOLOR="#eeeeee">�P�D���ݎ��Ò����͒���I�Ɏ�f���̕a�C�ɂ���</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
-->
            <TD NOWRAP BGCOLOR="#eeeeee">�P�|a�D���ݎ��Ò����͒���I�Ɏ�f���̕a�C�ɂ���</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
<!-- '#### 2010.12.18 MOD STR TCS)H.F ####' -->
        </TR>
        <TR>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
                <TR><TD>&nbsp;</TD></TR>
<%
    strHTML = ""
    For i=0 To NOWDISEASE_COUNT - 1
        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
        strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Next
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
                    <TR>
                        <TD NOWRAP BGCOLOR="#eeeeee">�a��</TD>
                        <TD NOWRAP BGCOLOR="#eeeeee">���ǔN��</TD>
                        <TD NOWRAP BGCOLOR="#eeeeee">���Ï�</TD>
                        <TD NOWRAP WIDTH="100%" BGCOLOR="#eeeeee">���b�Z�[�W</TD>
                    </TR>
<%
    strHTML = ""
    For i=0 To NOWDISEASE_COUNT - 1
        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START1 + 5 + i*3
        strHTML = strHTML & "<TD NOWRAP>" & vbLf
        strHTML = strHTML & EditRsl(lngIndex, "disease", "list1_1_1" & (i+1), 3, "") & vbLf
        strHTML = strHTML & EditRsl(lngIndex, "list1", "list1_1_1" & (i+1), , "") & vbLf
        strHTML = strHTML & "</TD>" & vbLf
lngIndex = OCRGRP_START1 + 6 + i*3
        strHTML = strHTML & "<TD NOWRAP  ALIGN=""right"">" & EditRsl(lngIndex, "text", "Rsl", 3, "") & "��" & "</TD>" & vbLf
lngIndex = OCRGRP_START1 + 7 + i*3
        strHTML = strHTML & "<TD NOWRAP>" & vbLf
        strHTML = strHTML & EditRsl(lngIndex, "list2", "list1_1_2" & (i+1), , "") & vbLf
        strHTML = strHTML & "</TD>" & vbLf

        '�O��l�Ɣ�r���ă��b�Z�[�W���쐬
        strLstDiffMsg = ""
        For j=0 To NOWDISEASE_COUNT - 1
            If vntResult(OCRGRP_START1 + 5 + i*3) <> "" Then
                '�����a��������
                If vntResult(OCRGRP_START1 + 5 + i*3) = vntLstResult(OCRGRP_START1 + 5 + j*3) Then
                    '�N��Ⴄ
                    If vntResult(OCRGRP_START1 + 6 + i*3) <> vntLstResult(OCRGRP_START1 + 6 + j*3) Then
                        strLstDiffMsg = strLstDiffMsg & IIf(strLstDiffMsg<>"","�A","") & "�N��"
                    End If
                    '���Ï�Ԃ��Ⴄ
                    If vntResult(OCRGRP_START1 + 7 + i*3) <> vntLstResult(OCRGRP_START1 + 7 + j*3) Then
                        strLstDiffMsg = strLstDiffMsg & IIf(strLstDiffMsg<>"","�A","") & "���Ï��"
                    End If
                    Exit For
                End If
            End If
        Next
        If strLstDiffMsg <> "" Then
            strLstDiffMsg = "<FONT COLOR=""red""><B>�@��" & strLstDiffMsg & "�Ⴂ</B></FONT>"
        End If
        strHTML = strHTML & "<TD NOWRAP>" & strLstDiffMsg & "</TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Next
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
                    <TR>
                        <TD NOWRAP>�@</TD>
                    </TR>
<%
'---�O��l---
    strHTML = ""
    For i=0 To NOWDISEASE_COUNT - 1
        strLstRsl = ""
lngIndex = OCRGRP_START1 + 5 + i*3
        For j=0 To UBound(strArrCode1)
            If vntLstResult(lngIndex) = strArrCode1(j) Then
                strLstRsl = strLstRsl & IIf(strLstRsl="", "", "�@") & strArrName1(j)
                Exit For
            End If
        Next
lngIndex = OCRGRP_START1 + 6 + i*3
        strLstRsl =  strLstRsl & IIf(strLstRsl="", "", "�@") & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "��")
lngIndex = OCRGRP_START1 + 7 + i*3
        For j=0 To UBound(strArrCode2)
            If vntLstResult(lngIndex) = strArrCode2(j) Then
                strLstRsl = strLstRsl & IIf(strLstRsl="", "", "�@") & strArrName2(j)
                Exit For
            End If
        Next
        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
        strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Next
    Response.Write strHTML
'------------
%>
                </TABLE>
            </TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
<!-- '#### 2010.12.18 MOD STR TCS)H.F ####' -->
<!--
            <TD NOWRAP BGCOLOR="#eeeeee">�Q�D���Ɏ��Â����I�Ȏ�f���I�������a�C�ɂ���</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
-->
            <TD NOWRAP BGCOLOR="#eeeeee">�P�|���D���Ɏ��Â����I�Ȏ�f���I�������a�C�ɂ���</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
<!-- '#### 2010.12.18 MOD END TCS)H.F ####' -->
        </TR>
        <TR>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
                <TR><TD>&nbsp;</TD></TR>
<%
    strHTML = ""
    For i=0 To DISEASEHIST_COUNT - 1
        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
        strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Next
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
                    <TR>
                        <TD NOWRAP BGCOLOR="#eeeeee">�a��</TD>
                        <TD NOWRAP BGCOLOR="#eeeeee">���ǔN��</TD>
                        <TD NOWRAP BGCOLOR="#eeeeee">���Ï�</TD>
                        <TD NOWRAP WIDTH="100%" BGCOLOR="#eeeeee">���b�Z�[�W</TD>
                    </TR>
<%
    strHTML = ""
    For i=0 To DISEASEHIST_COUNT - 1
        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START1 + 23 + i*3
        strHTML = strHTML & "<TD NOWRAP>" & vbLf
        strHTML = strHTML & EditRsl(lngIndex, "disease", "list1_2_1" & (i+1), 3, "") & vbLf
        strHTML = strHTML & EditRsl(lngIndex, "list1", "list1_2_1" & (i+1), , "") & vbLf
        strHTML = strHTML & "</TD>" & vbLf
lngIndex = OCRGRP_START1 + 24 + i*3
        strHTML = strHTML & "<TD NOWRAP  ALIGN=""right"">" & EditRsl(lngIndex, "text", "Rsl", 3, "") & "��" & "</TD>" & vbLf
lngIndex = OCRGRP_START1 + 25 + i*3
        strHTML = strHTML & "<TD NOWRAP>" & vbLf
        strHTML = strHTML & EditRsl(lngIndex, "list2", "list1_2_2" & (i+1), , "") & vbLf
        strHTML = strHTML & "</TD>" & vbLf

        '�O��l�Ɣ�r���ă��b�Z�[�W���쐬
        strLstDiffMsg = ""
        For j=0 To NOWDISEASE_COUNT - 1
            If vntResult(OCRGRP_START1 + 23 + i*3) <> "" Then
                '�����a��������
                If vntResult(OCRGRP_START1 + 23 + i*3) = vntLstResult(OCRGRP_START1 + 23 + j*3) Then
                    '�N��Ⴄ
                    If vntResult(OCRGRP_START1 + 24 + i*3) <> vntLstResult(OCRGRP_START1 + 24 + j*3) Then
                        strLstDiffMsg = strLstDiffMsg & IIf(strLstDiffMsg<>"","�A","") & "�N��"
                    End If
                    '���Ï�Ԃ��Ⴄ
                    If vntResult(OCRGRP_START1 + 25 + i*3) <> vntLstResult(OCRGRP_START1 + 25 + j*3) Then
                        strLstDiffMsg = strLstDiffMsg & IIf(strLstDiffMsg<>"","�A","") & "���Ï��"
                    End If
                    Exit For
                End If
            End If
        Next
        If strLstDiffMsg <> "" Then
            strLstDiffMsg = "<FONT COLOR=""red""><B>�@��" & strLstDiffMsg & "�Ⴂ</B></FONT>"
        End If
        strHTML = strHTML & "<TD NOWRAP>" & strLstDiffMsg & "</TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Next
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
                    <TR>
                        <TD NOWRAP>�@</TD>
                    </TR>
<%
'---�O��l---
    strHTML = ""
    For i=0 To NOWDISEASE_COUNT - 1
        strLstRsl = ""
lngIndex = OCRGRP_START1 + 23 + i*3
        For j=0 To UBound(strArrCode1)
            If vntLstResult(lngIndex) = strArrCode1(j) Then
                strLstRsl = strLstRsl & IIf(strLstRsl="", "", "�@") & strArrName1(j)
                Exit For
            End If
        Next
lngIndex = OCRGRP_START1 + 24 + i*3
        strLstRsl =  strLstRsl & IIf(strLstRsl="", "", "�@") & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "��")
lngIndex = OCRGRP_START1 + 25 + i*3
        For j=0 To UBound(strArrCode2)
            If vntLstResult(lngIndex) = strArrCode2(j) Then
                strLstRsl = strLstRsl & IIf(strLstRsl="", "", "�@") & strArrName2(j)
                Exit For
            End If
        Next
        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
        strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Next
    Response.Write strHTML
'------------
%>
                </TABLE>
            </TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
<!-- '#### 2010.12.18 MOD STR TCS)H.F ####' -->
<!--
            <TD NOWRAP BGCOLOR="#eeeeee">�R�D���Ƒ��i�����j�̕��ł��������a�C�ɂ���</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
-->
            <TD NOWRAP BGCOLOR="#eeeeee">�P�|���D���Ƒ��i�����j�̕��ł��������a�C�ɂ���</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
<!-- '#### 2010.12.18 MOD END TCS)H.F ####' -->
        </TR>
        <TR>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
                <TR><TD>&nbsp;</TD></TR>
<%
    strHTML = ""
    For i=0 To FAMILYHIST_COUNT - 1
        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
        strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Next
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
                    <TR>
                        <TD NOWRAP BGCOLOR="#eeeeee">�a��</TD>
                        <TD NOWRAP BGCOLOR="#eeeeee">���ǔN��</TD>
                        <TD NOWRAP BGCOLOR="#eeeeee">����</TD>
                        <TD NOWRAP WIDTH="100%" BGCOLOR="#eeeeee">���b�Z�[�W</TD>
                    </TR>
<%
    strHTML = ""
    For i=0 To FAMILYHIST_COUNT - 1
        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START1 + 41 + i*3
        strHTML = strHTML & "<TD NOWRAP>" & vbLf
        strHTML = strHTML & EditRsl(lngIndex, "disease", "list1_3_1" & (i+1), 3, "") & vbLf
        strHTML = strHTML & EditRsl(lngIndex, "list1", "list1_3_1" & (i+1), , "") & vbLf
        strHTML = strHTML & "</TD>" & vbLf
lngIndex = OCRGRP_START1 + 42 + i*3
        strHTML = strHTML & "<TD NOWRAP  ALIGN=""right"">" & EditRsl(lngIndex, "text", "Rsl", 3, "") & "��" & "</TD>" & vbLf
lngIndex = OCRGRP_START1 + 43 + i*3
        strHTML = strHTML & "<TD NOWRAP>" & vbLf
        strHTML = strHTML & EditRsl(lngIndex, "list3", "list1_3_2" & (i+1), , "") & vbLf
        strHTML = strHTML & "</TD>" & vbLf

        '�O��l�Ɣ�r���ă��b�Z�[�W���쐬
        strLstDiffMsg = ""
        For j=0 To NOWDISEASE_COUNT - 1
            If vntResult(OCRGRP_START1 + 41 + i*3) <> "" Then
                '�����a��������
                If vntResult(OCRGRP_START1 + 41 + i*3) = vntLstResult(OCRGRP_START1 + 41 + j*3) Then
                    '���ǔN��Ⴄ
                    If vntResult(OCRGRP_START1 + 42 + i*3) <> vntLstResult(OCRGRP_START1 + 42 + j*3) Then
                        strLstDiffMsg = strLstDiffMsg & IIf(strLstDiffMsg<>"","�A","") & "���ǔN��"
                    End If
                    '�������Ⴄ
                    If vntResult(OCRGRP_START1 + 43 + i*3) <> vntLstResult(OCRGRP_START1 + 43 + j*3) Then
                        strLstDiffMsg = strLstDiffMsg & IIf(strLstDiffMsg<>"","�A","") & "����"
                    End If
                    Exit For
                End If
            End If
        Next
        If strLstDiffMsg <> "" Then
            strLstDiffMsg = "<FONT COLOR=""red""><B>�@��" & strLstDiffMsg & "�Ⴂ</B></FONT>"
        End If
        strHTML = strHTML & "<TD NOWRAP>" & strLstDiffMsg & "</TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Next
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
                    <TR>
                        <TD NOWRAP>�@</TD>
                    </TR>
<%
'---�O��l---
    strHTML = ""
    For i=0 To NOWDISEASE_COUNT - 1
        strLstRsl = ""
lngIndex = OCRGRP_START1 + 41 + i*3
        For j=0 To UBound(strArrCode1)
            If vntLstResult(lngIndex) = strArrCode1(j) Then
                strLstRsl = strLstRsl & IIf(strLstRsl="", "", "�@") & strArrName1(j)
                Exit For
            End If
        Next
lngIndex = OCRGRP_START1 + 42 + i*3
        strLstRsl =  strLstRsl & IIf(strLstRsl="", "", "�@") & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "��")
lngIndex = OCRGRP_START1 + 43 + i*3
        For j=0 To UBound(strArrCode3)
            If vntLstResult(lngIndex) = strArrCode3(j) Then
                strLstRsl = strLstRsl & IIf(strLstRsl="", "", "�@") & strArrName3(j)
                Exit For
            End If
        Next
        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
        strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Next
    Response.Write strHTML
'------------
%>
                </TABLE>
            </TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
<!-- '#### 2010.12.18 MOD STR TCS)H.F ####' -->
<!--
            <TD NOWRAP BGCOLOR="#eeeeee">�S�D�݌������󂯂���͂�����������</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
-->
            <TD NOWRAP BGCOLOR="#eeeeee"><SPAN ID="Anchor-Stomach" STYLE="position:relative">�Q�D�݌������󂯂���͂�����������</SPAN></TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
<!-- '#### 2010.12.18 MOD END TCS)H.F ####' -->
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>�@�@�i�P�j��p�����ꂽ����</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START1 + 59
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4_1", , "1") & "�ݑS�E��p�@" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4_1", , "2") & "�ݕ����؏��@" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4_1", , "3") & "���������Ái�S���؏��p�Ȃǁj�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4_1", , "1") & "<SPAN ID=""STOMACH1_1"">�ݑS�E��p</SPAN>�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4_1", , "2") & "<SPAN ID=""STOMACH1_2"">�ݕ����؏�</SPAN>�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4_1", , "3") & "<SPAN ID=""STOMACH1_3"">���������Ái�S���؏��p�Ȃǁj</SPAN>�@" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD END
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�ݑS�E��p"
    Case "2"
        strLstRsl = "�ݕ����؏�"
    Case "3"
        strLstRsl = "���������Ái�S���؏��p�Ȃǁj"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>




        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>�@�@�i�Q�j�w���R�o�N�^�[�E�s�����Ɋւ���</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START1 + 60
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf

''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@�@�s�������ۗ�" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4_2", , "2") & "����F���ې����@" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4_2", , "3") & "����F���ەs�����@" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4_2", , "4") & "����F���ۂł������s���@" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4_2", , "1") & "�Ȃ�" & vbLf
'    strHTML = strHTML & "</TD>" & vbLf

    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@�@�s�������ۗ��@" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4_2", , "1") & "���ۗ��Ȃ��@" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4_2", , "2") & "����F���ې����@" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4_2", , "3") & "����F���ەs�����@" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4_2", , "4") & "����F���ۂł������s���@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4_2", , "1") & "<SPAN ID=""STOMACH2_1"">���ۗ��Ȃ�</SPAN>�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4_2", , "2") & "<SPAN ID=""STOMACH2_2"">����F���ې���</SPAN>�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4_2", , "3") & "<SPAN ID=""STOMACH2_3"">����F���ەs����</SPAN>�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_4_2", , "4") & "<SPAN ID=""STOMACH2_4"">����F���ۂł������s��</SPAN>�@" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD END
    strHTML = strHTML & "</TD>" & vbLf
''### 2010.12.18 MOD END TCS)H.F
'---�O��l---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�s�����ہF���ۗ��Ȃ�"
    Case "2"
        strLstRsl = "�s�����ہF���ۗ�����A����"
    Case "3"
        strLstRsl = "�s�����ہF���ۗ�����A�s����"
    Case "4"
        strLstRsl = "�s�����ہF���ۗ�����A���ۂł������s��"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
<!-- '#### 2010.12.18 MOD STR TCS)H.F ####' -->
<!--
            <TD NOWRAP BGCOLOR="#eeeeee">�T�D�ȑO���@�Ŏw�E���󂯂����̂�����΁A���L���������B</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
-->
            <TD NOWRAP BGCOLOR="#eeeeee">�R�D�ȑO���@�Ŏw�E���󂯂����̂�����΁A���L���������B</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
<!-- '#### 2010.12.18 MOD END TCS)H.F ####' -->
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>�@�@�i�P�j�㕔�����ǌ���</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@" & vbLf
lngIndex = OCRGRP_START1 + 61
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_1", , "1") & "�H���|���[�v" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_1", , "1") & "�H���|���[�v�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_1", , "1") & "<SPAN ID=""OTHER_HOSPITAL1_1"">�H���|���[�v</SPAN>�@" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 62
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_2", , "2") & "�݂���" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_2", , "2") & "�݂���@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_2", , "2") & "<SPAN ID=""OTHER_HOSPITAL1_2"">�݂���</SPAN>�@" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 63
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_3", , "3") & "�����݉�" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_3", , "3") & "�����݉��@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_3", , "3") & "<SPAN ID=""OTHER_HOSPITAL1_3"">�����݉�</SPAN>�@" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 64
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_4", , "4") & "�݃|���[�v" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_4", , "4") & "�݃|���[�v�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_4", , "4") & "<SPAN ID=""OTHER_HOSPITAL1_4"">�݃|���[�v</SPAN>�@" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 65
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_5", , "5") & "�ݒ��ፍ�" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_5", , "5") & "�ݒ��ፍ��@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_5", , "5") & "<SPAN ID=""OTHER_HOSPITAL1_5"">�ݒ��ፍ�</SPAN>�@" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 66
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_6", , "6") & "�\��w��" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_6", , "6") & "�\��w���@" & vbLf
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 67
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_7", , "7") & "���̑�" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_7", , "7") & "���̑��@" & vbLf
''### 2010.12.23 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
lngIndex = OCRGRP_START1 + 61
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�H���|���[�v"
    End If
lngIndex = OCRGRP_START1 + 62
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�݂���"
    End If
lngIndex = OCRGRP_START1 + 63
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�����݉�"
    End If
lngIndex = OCRGRP_START1 + 64
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�݃|���[�v"
    End If
lngIndex = OCRGRP_START1 + 65
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�ݒ��ፍ�"
    End If
lngIndex = OCRGRP_START1 + 66
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�\��w��"
    End If
lngIndex = OCRGRP_START1 + 67
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "���̑�"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML

''### 2010.12.23 ADD STR TCS)H.F
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & "" & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@" & vbLf
lngIndex = OCRGRP_START1 + 66
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_6", , "6") & "�\��w�����ፍ��@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_6", , "6") & "<SPAN ID=""OTHER_HOSPITAL1_6"">�\��w�����ፍ�</SPAN>�@" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD END
lngIndex = OCRGRP_START1 + 67
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_7", , "7") & "���̑��@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_1_7", , "7") & "<SPAN ID=""OTHER_HOSPITAL1_7"">���̑�</SPAN>�@" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD END
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
''### 2010.12.23 ADD END TCS)H.F
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>�@�@�i�Q�j�㕠�������g����</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@" & vbLf
lngIndex = OCRGRP_START1 + 68
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_1", , "1") & "�_�̂��|���[�v" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_1", , "1") & "�_�̂��|���[�v�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_1", , "1") & "<SPAN ID=""OTHER_HOSPITAL2_1"">�_�̂��|���[�v</SPAN>�@" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 69
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_2", , "2") & "�_��" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_2", , "2") & "�_�΁@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_2", , "2") & "<SPAN ID=""OTHER_HOSPITAL2_2"">�_��</SPAN>�@" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 70
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_3", , "3") & "�̌��ǎ�" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_3", , "3") & "�̌��ǎ�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_3", , "3") & "<SPAN ID=""OTHER_HOSPITAL2_3"">�̌��ǎ�</SPAN>�@" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 71
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_4", , "4") & "�̂̂��E" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_4", , "4") & "�̂̂��E�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_4", , "4") & "<SPAN ID=""OTHER_HOSPITAL2_4"">�̂̂��E</SPAN>�@" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 72
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_5", , "5") & "���b��" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_5", , "5") & "���b�́@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_5", , "5") & "<SPAN ID=""OTHER_HOSPITAL2_5"">���b��</SPAN>�@" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD END
''### 2010.12.23 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
lngIndex = OCRGRP_START1 + 68
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�_�̂��|���[�v"
    End If
lngIndex = OCRGRP_START1 + 69
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�_��"
    End If
lngIndex = OCRGRP_START1 + 70
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�̌��ǎ�"
    End If
lngIndex = OCRGRP_START1 + 71
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�̔X�E"
    End If
lngIndex = OCRGRP_START1 + 72
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "���b��"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>

<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@" & vbLf
lngIndex = OCRGRP_START1 + 73
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_6", , "6") & "�t����" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_6", , "6") & "�t���΁@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_6", , "6") & "<SPAN ID=""OTHER_HOSPITAL2_6"">�t����</SPAN>�@" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 74
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_7", , "7") & "�t�̂��E" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_7", , "7") & "�t�̂��E�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_7", , "7") & "<SPAN ID=""OTHER_HOSPITAL2_7"">�t�̂��E</SPAN>�@" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 75
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_8", , "9") & "���t��" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_8", , "9") & "���t�ǁ@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_8", , "9") & "<SPAN ID=""OTHER_HOSPITAL2_8"">���t��</SPAN>�@" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 76
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_9", , "10") & "���t���" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_9", , "10") & "���t��ᇁ@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_9", , "10") & "<SPAN ID=""OTHER_HOSPITAL2_9"">���t���</SPAN>�@" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 77
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_10", , "11") & "�����p�ߎ��" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_10", , "11") & "�����p�ߎ��@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_10", , "11") & "<SPAN ID=""OTHER_HOSPITAL2_10"">�����p�ߎ��</SPAN>�@" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 78
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_11", , "8") & "���̑�" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_11", , "8") & "���̑��@" & vbLf
''### 2010.12.23 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
lngIndex = OCRGRP_START1 + 73
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�t����"
    End If
lngIndex = OCRGRP_START1 + 74
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�t�̂��E"
    End If
lngIndex = OCRGRP_START1 + 75
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "���t��"
    End If
lngIndex = OCRGRP_START1 + 76
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "���t���"
    End If
lngIndex = OCRGRP_START1 + 77
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�����p�ߎ��"
    End If
lngIndex = OCRGRP_START1 + 78
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "���̑�"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
''### 2010.12.23 ADD STR TCS)H.F
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & "" & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@" & vbLf
lngIndex = OCRGRP_START1 + 78
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_11", , "8") & "���̑��@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_2_11", , "8") & "<SPAN ID=""OTHER_HOSPITAL2_11"">���̑�</SPAN>�@" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD END
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
''### 2010.12.23 ADD END TCS)H.F
%>


        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>�@�@�i�R�j�S�d�}����</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@" & vbLf
lngIndex = OCRGRP_START1 + 79
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_1", , "1") & "�v�o�v�ǌ�Q" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_1", , "1") & "�v�o�v�ǌ�Q�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_1", , "1") & "<SPAN ID=""OTHER_HOSPITAL3_1"">�v�o�v�ǌ�Q</SPAN>�@" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD END
''### 2010.12.23 MOD STR TCS)H.F
lngIndex = OCRGRP_START1 + 80
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_2", , "2") & "���S�E�r�u���b�N" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_2", , "2") & "���S�E�r�u���b�N�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_2", , "2") & "<SPAN ID=""OTHER_HOSPITAL3_2"">���S�E�r�u���b�N</SPAN>�@" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 81
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_3", , "3") & "�s���S�E�r�u���b�N" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_3", , "3") & "�s���S�E�r�u���b�N�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_3", , "3") & "<SPAN ID=""OTHER_HOSPITAL3_3"">�s���S�E�r�u���b�N</SPAN>�@" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 82
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_4", , "4") & "�s����" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_4", , "4") & "�s�����@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_4", , "4") & "<SPAN ID=""OTHER_HOSPITAL3_4"">�s����</SPAN>�@" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 83
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_5", , "6") & "�E���S" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_5", , "6") & "�E���S�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_5", , "6") & "<SPAN ID=""OTHER_HOSPITAL3_5"">�E���S</SPAN>�@" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 84
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_6", , "5") & "���̑�" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_6", , "5") & "���̑��@" & vbLf
''### 2010.12.23 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
lngIndex = OCRGRP_START1 + 79
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�v�o�v�ǌ�Q"
    End If
lngIndex = OCRGRP_START1 + 80
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "���S�E�r�u���b�N"
    End If
lngIndex = OCRGRP_START1 + 81
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�s���S�E�r�u���b�N"
    End If
lngIndex = OCRGRP_START1 + 82
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�s����"
    End If
lngIndex = OCRGRP_START1 + 83
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�E���S"
    End If
lngIndex = OCRGRP_START1 + 84
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "���̑�"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
''### 2010.12.23 ADD STR TCS)H.F
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & "" & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@" & vbLf
lngIndex = OCRGRP_START1 + 84
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_6", , "5") & "���̑��@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_3_6", , "5") & "<SPAN ID=""OTHER_HOSPITAL3_6"">���̑�</SPAN>�@" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD END
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
''### 2010.12.23 ADD END TCS)H.F
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>�@�@�i�S�j���[����</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@" & vbLf
lngIndex = OCRGRP_START1 + 85
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_4_1", , "1") & "���B��" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_4_1", , "1") & "���B�ǁ@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_4_1", , "1") & "<SPAN ID=""OTHER_HOSPITAL4_1"">���B��</SPAN>�@" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 86
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_4_2", , "2") & "�@�ې���" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_4_2", , "2") & "�@�ې���@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_4_2", , "2") & "<SPAN ID=""OTHER_HOSPITAL4_2"">�@�ې���</SPAN>�@" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 87
''### 2010.12.23 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_4_3", , "4") & "���[�`���p" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_4_3", , "4") & "���[�`���p�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_4_3", , "4") & "<SPAN ID=""OTHER_HOSPITAL4_3"">���[�`���p�@" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD END
''### 2010.12.23 MOD END TCS)H.F
lngIndex = OCRGRP_START1 + 88
''### 2010.12.23 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_4_4", , "3") & "���̑�" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD STR
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_4_4", , "3") & "���̑��@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk1_5_4_4", , "3") & "<SPAN ID=""OTHER_HOSPITAL4_4"">���̑�</SPAN>�@" & vbLf
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� MOD END
''### 2010.12.23 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
lngIndex = OCRGRP_START1 + 85
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "���B��"
    End If
lngIndex = OCRGRP_START1 + 86
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�@�ې���"
    End If
lngIndex = OCRGRP_START1 + 87
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "���[�`���p"
    End If
lngIndex = OCRGRP_START1 + 88
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "���̑�"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>



<!-- '#### 2010.12.18 MOD STR TCS)H.F ####' -->
<!--
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>�@�@�i�T�j�����̕��́A���L�̎���ɂ��������������B</TD>
            <TD NOWRAP></TD>
        </TR>
-->
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">�S�D�����̕��́A���L�̎���ɂ��������������B</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<!-- '#### 2010.12.18 MOD END TCS)H.F ####' -->

<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"" ROWSPAN=""2"" VALIGN=""MIDDLE"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@" & vbLf
lngIndex = OCRGRP_START1 + 89
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_5_5", , "1") & "�͂�" & vbLf
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & "�i�D�P���̕��͌��f�͂��������Ă���܂���A�܂��\���̂�����́A�w�����͎󂯂��܂���B�j</TD>" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt1_5_5", , "2") & "������" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�͂�"
    Case "2"
        strLstRsl = "������"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>











    </TABLE>
<!-- 
******************************************************
    �����K����f�P
******************************************************
 -->
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
        <TR HEIGHT="20" >
            <TD NOWRAP WIDTH="20"></TD>
            <TD NOWRAP WIDTH="730" BGCOLOR="#98fb98"><SPAN ID="Anchor-LifeHabit1" STYLE="position:relative">�����K���a��f�[�i�P�j</SPAN></TD>
            <TD NOWRAP WIDTH="220" BGCOLOR="#98fb98"></TD>
        </TR>

<!-- '#### 2010.12.18 MOD STR TCS)H.F ####' -->
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">�P�D�̏d�ɂ���</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<!-- '#### 2010.12.18 MOD END TCS)H.F ####' -->

        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>�@�@�i�P�j�P�W�`�Q�O�΂̑̏d�͉������ł������B</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 0
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@�@" & EditRsl(lngIndex, "text", "Rsl", 4, "") & "����" & "</TD>" & vbLf
'---�O��l---
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "����")
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
<% '#### 2011/01/22 MOD STA TCS)Y.T #### %>
<!--            <TD NOWRAP>�@�@�i�Q�j���̔��N�ł̑̏d�̕ϓ��͂ǂ��ł����B</TD>-->
            <TD NOWRAP>�@�@�i�Q�j���̂P�N�ł̑̏d�̕ϓ��͂ǂ��ł����B</TD>
<% '#### 2011/01/22 MOD END TCS)Y.T #### %>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 1
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_1_2", , "4") & "3�����ȏ㑝�������@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_1_2", , "2") & "�ϓ��Ȃ��@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_1_2", , "5") & "3�����ȏ㌸�������@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "2�����ȏ㑝������"
    Case "2"
        strLstRsl = "�ϓ��Ȃ�"
    Case "3"
        strLstRsl = "2�����ȏ㌸������"
    Case "4"
        strLstRsl = "3�����ȏ㑝������"
    Case "5"
        strLstRsl = "3�����ȏ㌸������"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">�Q�D�����ɂ���</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>�@�@�i�P�j�T�ɉ������݂܂����B</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 2
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_2_1", , "1") & "�K���I�Ɉ��ށ@" & vbLf
lngIndex = OCRGRP_START2 + 3
    strHTML = strHTML & "�i�T" & EditRsl(lngIndex, "text", "Rsl", 5, "") & "���j�@" & vbLf
lngIndex = OCRGRP_START2 + 2
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_2_1", , "2") & "�Ƃ��ǂ����ށ@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_2_1", , "3") & "���܂Ȃ��@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
lngIndex = OCRGRP_START2 + 2
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�K���I�Ɉ���"
lngIndex = OCRGRP_START2 + 3
        If vntLstResult(lngIndex) <> "" Then
            strLstRsl = strLstRsl & "�i�T" & vntLstResult(lngIndex) & "���j"
        End If
    Case "2"
        strLstRsl = "�Ƃ��ǂ�����"
    Case "3"
        strLstRsl = "���܂Ȃ�"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
<!-- '#### 2010.12.18 MOD STR TCS)H.F ####' -->
<!--
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">�R�D�P���̈���ʂ͂ǂ̂��炢�ł����B</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
-->
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>�@�@�i�Q�j�P���̈���ʂ͂ǂ̂��炢�ł����B</TD>
            <TD NOWRAP></TD>
        </TR>
<!-- '#### 2010.12.18 MOD END TCS)H.F ####' -->
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 4
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@�@" & EditRsl(lngIndex, "text", "Rsl", 5, "") & "�{�i�r�[����r�j</TD>" & vbLf
'---�O��l---
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "�{�i�r�[����r�j")
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 5
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@�@" & EditRsl(lngIndex, "text", "Rsl", 5, "") & "�{�i�r�[���R�T�Oml�ʁj</TD>" & vbLf
'---�O��l---
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "�{�i�r�[���R�T�Oml�ʁj")
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 6
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@�@" & EditRsl(lngIndex, "text", "Rsl", 5, "") & "�{�i�r�[���T�O�Oml�ʁj</TD>" & vbLf
'---�O��l---
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "�{�i�r�[���T�O�Oml�ʁj")
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 7
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@�@" & EditRsl(lngIndex, "text", "Rsl", 5, "") & "���i���{���j</TD>" & vbLf
'---�O��l---
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "�{�i���{���j")
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 8
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@�@" & EditRsl(lngIndex, "text", "Rsl", 5, "") & "�t�i�Ē��j</TD>" & vbLf
'---�O��l---
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "�{�i�Ē��j")
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 9
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@�@" & EditRsl(lngIndex, "text", "Rsl", 5, "") & "�t�i���C���j</TD>" & vbLf
'---�O��l---
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "�{�i���C���j")
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 10
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@�@" & EditRsl(lngIndex, "text", "Rsl", 5, "") & "�t�i�E�C�X�L�[�E�u�����f�[�j</TD>" & vbLf
'---�O��l---
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "�{�i�E�C�X�L�[�E�u�����f�[�j")
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 11
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@�@" & EditRsl(lngIndex, "text", "Rsl", 5, "") & "�t�i���̑��j</TD>" & vbLf
'---�O��l---
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "�{�i���̑��j")
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">�R�D���΂��ɂ���</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>�@�@�i�P�j���݂̋i���ɂ���</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 12
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_3_1", , "1") & "�z���Ă���@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_3_1", , "2") & "�z��Ȃ��@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_3_1", , "3") & "�ߋ��ɋz���Ă����@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�z���Ă���"
    Case "2"
        strLstRsl = "�z��Ȃ�"
    Case "3"
        strLstRsl = "�ߋ��ɋz���Ă���"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>�@�@�i�Q�j�z���n�߂��N��</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@" & vbLf
lngIndex = OCRGRP_START2 + 13
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 5, "") & "�΁i�z���n�߂��N��j�@" & vbLf
lngIndex = OCRGRP_START2 + 14
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 5, "") & "�΁i��߂��N��j�@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
lngIndex = OCRGRP_START2 + 13
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "�΁i�z���n�߂��N��j")
lngIndex = OCRGRP_START2 + 14
    strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "�΁i��߂��N��j")
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>�@�@�i�R�j�P���̋i���{��</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@" & vbLf
lngIndex = OCRGRP_START2 + 15
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 5, "") & "�{" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "�{")
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">�S�D�^���ɂ���</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>�@�@�i�P�j�^���s���Ǝv���܂����B</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 16
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_1", , "1") & "�v���@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_1", , "2") & "�v��Ȃ��@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�v��"
    Case "2"
        strLstRsl = "�v��Ȃ�"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>�@�@�i�Q�j�P���̂��悻�������炢�����Ă܂����B</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 17
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 5, "") & "��" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "��")
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>�@�@�i�R�j����ɂ�����g�̊����͂ǂ̂��炢�ł����B</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 18
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_3", , "1") & "�悭�̂𓮂����@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_3", , "2") & "���ʂɓ����Ă���@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_3", , "3") & "���܂芈���I�łȂ��@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_3", , "4") & "�قƂ�Ǒ̂𓮂����Ȃ��@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�悭�̂𓮂���"
    Case "2"
        strLstRsl = "���ʂɓ����Ă���"
    Case "3"
        strLstRsl = "���܂芈���I�łȂ�"
    Case "4"
        strLstRsl = "�قƂ�Ǒ̂𓮂����Ȃ�"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>�@�@�i�S�j�^���K����</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 19
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_4", , "1") & "�قƂ�ǖ����@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_4", , "2") & "�T�R�`�T���@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_4", , "3") & "�T�P�`�Q���@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_4", , "4") & "�قƂ�ǂ��Ȃ��@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�قƂ�ǖ���"
    Case "2"
        strLstRsl = "�T�R�`�T��"
    Case "3"
        strLstRsl = "�T�P�`�Q��"
    Case "4"
        strLstRsl = "�قƂ�ǂ��Ȃ�"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">�T�D�����ɂ���</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>�@�@�����͏\���ł����B</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 20
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_5", , "1") & "�͂��@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_5", , "2") & "�Q�s����������@" & vbLf
lngIndex = OCRGRP_START2 + 21
    strHTML = strHTML & "�@�@�@�@" & vbLf
    strHTML = strHTML & "�������ԁi" & EditRsl(lngIndex, "text", "Rsl", 5, "") & "���ԁj�@" & vbLf
lngIndex = OCRGRP_START2 + 22
    strHTML = strHTML & "�A�Q�����i" & EditRsl(lngIndex, "text", "Rsl", 5, "") & "���j�@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
lngIndex = OCRGRP_START2 + 20
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�͂�"
    Case "2"
        strLstRsl = "�Q�s����������"
    End Select
lngIndex = OCRGRP_START2 + 21
    strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & IIf(vntLstResult(lngIndex)="", "", "�������ԁi" & vntLstResult(lngIndex) & "���ԁj")
lngIndex = OCRGRP_START2 + 22
    strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & IIf(vntLstResult(lngIndex)="", "", "�A�Q�����i" & vntLstResult(lngIndex) & "���j")
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">�U�D�������ɂ���</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>�@�@�������ɂ���</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 23
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_6", , "1") & "���H��ɖ����@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_6", , "4") & "�P���P�`�Q��͖����@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_6", , "3") & "�P��������Ȃ��@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "���H��ɖ���"
    Case "2"
        strLstRsl = "�P���P��͖���"
    Case "3"
        strLstRsl = "�P��������Ȃ�"
    Case "4"
        strLstRsl = "�P���P�`�Q��͖���"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">�V�D���̑��̎���</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>�@�@�i�P�j���Ȃ��̌��݂̐E�Ƃ�</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 24
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_1", , "1") & "���̓��]��v���J���@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_1", , "2") & "��ɓ��̓I�ȘJ���@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_1", , "3") & "��ɓ��]�I�ȘJ���@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_1", , "4") & "��ɍ���d���@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "���̓��]��v���J��"
    Case "2"
        strLstRsl = "��ɓ��̓I�ȘJ��"
    Case "3"
        strLstRsl = "��ɓ��]�I�ȘJ��"
    Case "4"
        strLstRsl = "��ɍ���d��"
    Case "5"
        strLstRsl = "���Ɏd���������Ă��Ȃ�"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_71", , "5") & "���Ɏd���������Ă��Ȃ��@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>�@�@�i�Q�j�x���͉����Ƃ�܂����B</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 25
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_2", , "1") & "�T3���ȏ�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_2", , "2") & "�T2���ȏ�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_2", , "3") & "�T1���@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_2", , "4") & "��3���ȉ��@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�T3���ȏ�"
    Case "2"
        strLstRsl = "�T2���ȏ�"
    Case "3"
        strLstRsl = "�T1��"
    Case "4"
        strLstRsl = "��3���ȉ�"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>�@�@�i�R�j�E�ꓙ�ւ̎�Ȉړ���i</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 26
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_3", , "1") & "�k���@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_3", , "2") & "���]�ԁ@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_3", , "3") & "�����ԁi�Q�ւ��܂ށj�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_3", , "4") & "�d�ԁE�o�X�@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�k��"
    Case "2"
        strLstRsl = "���]��"
    Case "3"
        strLstRsl = "���]�ԁi�Q�ւ��܂ށj"
    Case "4"
        strLstRsl = "�d�ԁE�o�X"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>�@�@�i�S�j�E�ꓙ�܂ł̕Г��ړ����ԁ^�k�����Ԃ�</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 27
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@" & vbLf
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 5, "") & "���i�Г��̒ʋΎ��ԁj�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 5, "") & "���i�Г��̈ړ����ԁj�@�@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START2 + 28
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 5, "") & "���i�Г��̕��s���ԁj�@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
lngIndex = OCRGRP_START2 + 27
''### 2010.12.18 MOD STR TCS)H.F
'    strLstRsl = IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "���i�Г��̒ʋΎ��ԁj")
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "���i�Г��̈ړ����ԁj")
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START2 + 28
    strLstRsl = strLstRsl & IIf(strLstRsl="","",", ") & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "���i�Г��̕��s���ԁj")
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>�@�@�i�T�j�z��҂�</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 29
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_5", , "1") & "����@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_5", , "2") & "�Ȃ��@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "����"
    Case "2"
        strLstRsl = "�Ȃ�"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>�@�@�i�U�j�ꏏ�ɂ��炵�Ă���̂�</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 30
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@" & vbLf
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk2_4_7_6_1", , "1") & "�e" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk2_4_7_6_1", , "1") & "�e�@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START2 + 31
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk2_4_7_6_2", , "2") & "�z���" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk2_4_7_6_2", , "2") & "�z��ҁ@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START2 + 32
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk2_4_7_6_3", , "3") & "�q��" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk2_4_7_6_3", , "3") & "�q���@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START2 + 33
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk2_4_7_6_4", , "4") & "�Ƌ�" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk2_4_7_6_4", , "4") & "�Ƌ��@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START2 + 34
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk2_4_7_6_5", , "5") & "���̑�" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
lngIndex = OCRGRP_START2 + 30
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�e"
    End If
lngIndex = OCRGRP_START2 + 31
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�z���"
    End If
lngIndex = OCRGRP_START2 + 32
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�q��"
    End If
lngIndex = OCRGRP_START2 + 33
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�Ƌ�"
    End If
lngIndex = OCRGRP_START2 + 34
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "���̑�"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>�@�@�i�V�j���݂̐����ɖ������Ă��܂����B</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 35
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_7", , "1") & "�������Ă���@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_7", , "2") & "��▞�����Ă���@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_7", , "3") & "���s���@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_7", , "4") & "�s�����@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�������Ă���"
    Case "2"
        strLstRsl = "��▞�����Ă���"
    Case "3"
        strLstRsl = "���s��"
    Case "4"
        strLstRsl = "�s����"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>�@�@�i�W�j�P�N�ȓ��ɑ�ς炢�v�����������Ƃ�</TD>
            <TD NOWRAP></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START2 + 36
    strHTML = strHTML & "<TD NOWRAP>�@�@�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_8", , "1") & "�S�����������@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_8", , "2") & "���炢���Ƃ��������@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_8", , "3") & "�炢���Ƃ��������@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt2_4_7_8", , "4") & "��ς炩�����@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�S����������"
    Case "2"
        strLstRsl = "���炢���Ƃ�������"
    Case "3"
        strLstRsl = "�炢���Ƃ�������"
    Case "4"
        strLstRsl = "��ς炩����"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
                <TR><TD>&nbsp;</TD></TR>
<%
    strHTML = ""
    For i=0 To 5
        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
        strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Next
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
<%
lngIndex = OCRGRP_START2 + 37
    '���o�Ǐ�̕\��
    Call EditJikakushoujyou( lngIndex )

%>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
                    <TR>
                        <TD NOWRAP>�@</TD>
                    </TR>
<%
'---�O��l---
    strHTML = ""
    For i=0 To JIKAKUSHOUJYOU_COUNT - 1
        strLstRsl = ""
lngIndex = OCRGRP_START2 + 37 + i*4
        For j=0 To UBound(strArrCodeJikaku1)
            If vntLstResult(lngIndex) = strArrCodeJikaku1(j) Then
                strLstRsl = strLstRsl & IIf(strLstRsl="", "", "�@") & strArrNameJikaku1(j)
                Exit For
            End If
        Next
lngIndex = OCRGRP_START2 + 38 + i*4
        If vntLstResult(lngIndex) <> "" Then
            strLstRsl =  strLstRsl & IIf(strLstRsl="", "", "�@") & vntLstResult(lngIndex)
        End If
lngIndex = OCRGRP_START2 + 39 + i*4
        For j=0 To UBound(strArrCodeJikaku3)
            If vntLstResult(lngIndex) = strArrCodeJikaku3(j) Then
                strLstRsl = strLstRsl & IIf(strLstRsl="", "", "�@") & strArrNameJikaku3(j)
                Exit For
            End If
        Next
lngIndex = OCRGRP_START2 + 40 + i*4
        For j=0 To UBound(strArrCodeJikaku4)
            If vntLstResult(lngIndex) = strArrCodeJikaku4(j) Then
                strLstRsl = strLstRsl & IIf(strLstRsl="", "", "�@") & strArrNameJikaku4(j)
                Exit For
            End If
        Next
        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
        strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Next
    Response.Write strHTML
'------------
%>
                </TABLE>
            </TD>
        </TR>
    </TABLE>

<!-- 
******************************************************
    �����K����f�Q
******************************************************
 -->
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
        <TR HEIGHT="20">
            <TD NOWRAP WIDTH="20"></TD>
            <TD NOWRAP WIDTH="730" BGCOLOR="#98FB98"><SPAN ID="Anchor-LifeHabit2" STYLE="position:relative">�����K���a��f�[�i�Q�j</SPAN></TD>
            <TD NOWRAP WIDTH="220" BGCOLOR="#98FB98"></TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">�P�D�`�^�s���p�^�[���E�e�X�g</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
        <TR HEIGHT="20">
<%
    strHTML = ""
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
lngIndex = OCRGRP_START3 + 0
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk3_1_1", , "1") & "<B>�{�l��]�ɂ�薢��</B>" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", "�{�l��]�ɂ�薢��")
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    Response.Write strHTML
%>
        </TR>
        <TR>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
<%
    strHTML = ""
    For i=0 To 10
        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
        strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Next
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 1
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">1)�X�g���X,�ْ����㕠���ɒɂ�</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_1", , "1") & "<FONT COLOR=""gray"">�S���Ȃ�</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_1", , "2") & "<FONT COLOR=""gray"">���ɂ͂���</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_1", , "3") & "<FONT COLOR=""gray"">���΂��΂���</FONT></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 2
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">2)�C���͌��������ł����</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_2", , "1") & "<FONT COLOR=""gray"">���₩�ȕ�</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_2", , "2") & "<FONT COLOR=""gray"">����</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_2", , "3") & "<FONT COLOR=""gray"">����������</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_2", , "4") & "<FONT COLOR=""gray"">���Ɍ�����</FONT></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 3
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">3)�ӔC���������ƌ���ꂽ</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_3", , "1") & "<FONT COLOR=""gray"">�S���Ȃ�</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_3", , "2") & "<FONT COLOR=""gray"">���X����</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_3", , "3") & "<FONT COLOR=""gray"">���΂��΂���</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_3", , "4") & "<FONT COLOR=""gray"">��������</FONT></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 4
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">4)�d���Ɏ��M�������Ă���</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_4", , "1") & "<FONT COLOR=""gray"">�S���Ȃ�</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_4", , "2") & "<FONT COLOR=""gray"">���܂�Ȃ�</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_4", , "3") & "<FONT COLOR=""gray"">����</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_4", , "4") & "<FONT COLOR=""gray"">���ɂ���</FONT></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 5
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">5)���ʂɑ��N�����ĐE��ɍs��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_5", , "1") & "<FONT COLOR=""gray"">�S���Ȃ�</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_5", , "2") & "<FONT COLOR=""gray"">���X����</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_5", , "3") & "<FONT COLOR=""gray"">���΂��΂���</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_5", , "4") & "<FONT COLOR=""gray"">��ɂ���</FONT></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 6
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">6)�񑩂̎��Ԃɒx����</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_6", , "1") & "<FONT COLOR=""gray"">�悭�x���</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_6", , "2") & "<FONT COLOR=""gray"">���X�x���</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_6", , "3") & "<FONT COLOR=""gray"">�����Ēx��Ȃ�</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_6", , "4") & "<FONT COLOR=""gray"">30���O�ɍs��</FONT></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 7
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">7)�������Ǝv�����Ƃ͊т�</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_7", , "1") & "<FONT COLOR=""gray"">�S���Ȃ�</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_7", , "2") & "<FONT COLOR=""gray"">���X����</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_7", , "3") & "<FONT COLOR=""gray"">���΂��΂���</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_7", , "4") & "<FONT COLOR=""gray"">��ɂ���</FONT></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 8
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">8)�����ԗ��s����Ɖ���</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_8", , "1") & "<FONT COLOR=""gray"">����s���C��</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_8", , "2") & "<FONT COLOR=""gray"">1���P�ʂɌv��</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_8", , "3") & "<FONT COLOR=""gray"">���ԒP�ʂɌv��</FONT></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 9
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">9)���l����w�����ꂽ�ꍇ</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_9", , "1") & "<FONT COLOR=""gray"">�C���y���Ǝv��</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_9", , "2") & "<FONT COLOR=""gray"">�C�ɂƂ߂Ȃ�</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_9", , "3") & "<FONT COLOR=""gray"">���ȋC������</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_9", , "4") & "<FONT COLOR=""gray"">�{����o����</FONT></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 10
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">10)�Ԃ�ǂ������ꂽ�ꍇ</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_10", , "1") & "<FONT COLOR=""gray"">�}�C�y�[�X</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_10", , "2") & "<FONT COLOR=""gray"">�ǉz���Ԃ�</FONT></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 11
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">11)�A������b�N�X�����C��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_11", , "1") & "<FONT COLOR=""gray"">�����ɂȂ��</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_11", , "2") & "<FONT COLOR=""gray"">��r�I����</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_11", , "3") & "<FONT COLOR=""gray"">�����C���C��</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt3_1_11", , "4") & "<FONT COLOR=""gray"">��������</FONT></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
<%
'---�O��l---
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 1
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�S���Ȃ�"
    Case "2"
        strLstRsl = "���ɂ͂���"
    Case "3"
        strLstRsl = "���΂��΂���"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 2
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "���₩�ȕ�"
    Case "2"
        strLstRsl = "����"
    Case "3"
        strLstRsl = "����������"
    Case "4"
        strLstRsl = "���Ɍ�����"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 3
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�S���Ȃ�"
    Case "2"
        strLstRsl = "���X����"
    Case "3"
        strLstRsl = "���΂��΂���"
    Case "4"
        strLstRsl = "��������"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 4
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�S���Ȃ�"
    Case "2"
        strLstRsl = "���܂�Ȃ�"
    Case "3"
        strLstRsl = "����"
    Case "4"
        strLstRsl = "���ɂ���"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 5
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�S���Ȃ�"
    Case "2"
        strLstRsl = "���X����"
    Case "3"
        strLstRsl = "���X����"
    Case "4"
        strLstRsl = "��ɂ���"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 6
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�悭�x���"
    Case "2"
        strLstRsl = "���X�x���"
    Case "3"
        strLstRsl = "�����Ēx��Ȃ�"
    Case "4"
        strLstRsl = "30���O�ɍs��"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 7
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�S���Ȃ�"
    Case "2"
        strLstRsl = "���X����"
    Case "3"
        strLstRsl = "���΂��΂���"
    Case "4"
        strLstRsl = "��ɂ���"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 8
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "����s���C��"
    Case "2"
        strLstRsl = "1���P�ʂɌv��"
    Case "3"
        strLstRsl = "���ԒP�ʂɌv��"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 9
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�C���y���Ǝv��"
    Case "2"
        strLstRsl = "�C�ɂƂ߂Ȃ�"
    Case "3"
        strLstRsl = "���ȋC������"
    Case "4"
        strLstRsl = "�{����o����"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 10
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�}�C�y�[�X"
    Case "2"
        strLstRsl = "�ǉz���Ԃ�"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 11
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�����ɂȂ��"
    Case "2"
        strLstRsl = "��r�I����"
    Case "3"
        strLstRsl = "�����C���C��"
    Case "4"
        strLstRsl = "��������"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
'------------
%>
                </TABLE>
            </TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">�Q�D�X�g���X�E�R�[�s���O�e�X�g</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
        <TR HEIGHT="20">
<%
    strHTML = ""
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
lngIndex = OCRGRP_START3 + 12
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk3_2", , "1") & "<B>�{�l��]�ɂ�薢��</B></TD>" & vbLf
'---�O��l---
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", "�{�l��]�ɂ�薢��")
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    Response.Write strHTML
%>
        </TR>
        <TR>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
                    <TR HEIGHT="28"><TD></TD></TR>
<%
    strHTML = ""
    For i=0 To 11
        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
        strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Next
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="1" CELLSPACING="2" CELLPADDING="0">
                    <TR HEIGHT="28">
                        <TD NOWRAP>�@</TD>
                        <TD NOWRAP ALIGN="center">�S�����Ȃ�</TD>
                        <TD NOWRAP ALIGN="center">���ɂ͂���</TD>
                        <TD NOWRAP ALIGN="center">���΂��΂���</TD>
                        <TD NOWRAP ALIGN="center">��ɂ���</TD>
                    </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 13
    strHTML = strHTML & "<TD NOWRAP> 1)�ϋɓI�ɉ������悤�Ɠw�͂���</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_1", , "1") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_1", , "2") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_1", , "3") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_1", , "4") & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 14
    strHTML = strHTML & "<TD NOWRAP> 2)�����ւ̒���Ǝ󂯎~�߂� </TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_2", , "1") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_2", , "2") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_2", , "3") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_2", , "4") & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 15
    strHTML = strHTML & "<TD NOWRAP> 3)��x�݂�����撣�낤�Ƃ��� </TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_3", , "1") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_3", , "2") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_3", , "3") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_3", , "4") & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 16
    strHTML = strHTML & "<TD NOWRAP> 4)�Փ������⍂���Ȕ��������� </TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_4", , "1") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_4", , "2") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_4", , "3") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_4", , "4") & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 17
    strHTML = strHTML & "<TD NOWRAP> 5)������Ƒ��Əo����������ݐH������ </TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_5", , "1") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_5", , "2") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_5", , "3") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_5", , "4") & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 18
    strHTML = strHTML & "<TD NOWRAP> 6)�����V���������n�߂悤�Ƃ��� </TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_6", , "1") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_6", , "2") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_6", , "3") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_6", , "4") & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 19
    strHTML = strHTML & "<TD NOWRAP> 7)���̏󋵂��甲���o�鎖�͖������Ǝv�� </TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_7", , "1") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_7", , "2") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_7", , "3") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_7", , "4") & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 20
    strHTML = strHTML & "<TD NOWRAP> 8)�y�����������Ƃ��{�������l���� </TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_8", , "1") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_8", , "2") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_8", , "3") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_8", , "4") & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 21
    strHTML = strHTML & "<TD NOWRAP> 9)�ǂ�����Ηǂ������̂����v���Y�� </TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_9", , "1") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_9", , "2") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_9", , "3") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_9", , "4") & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 22
    strHTML = strHTML & "<TD NOWRAP>10)���݂̏󋵂ɂ��čl���Ȃ��悤�ɂ��� </TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_10", , "1") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_10", , "2") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_10", , "3") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_10", , "4") & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 23
    strHTML = strHTML & "<TD NOWRAP>11)�̂̒��q�̈������ɂ͕a�@�ɍs�������Ǝv�� </TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_11", , "1") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_11", , "2") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_11", , "3") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_11", , "4") & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 24
    strHTML = strHTML & "<TD NOWRAP>12)�ȑO���^�o�R�E���E�H���̗ʂ������� </TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_12", , "1") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_12", , "2") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_12", , "3") & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP ALIGN=""center"">" & EditRsl(lngIndex, "radio", "opt3_2_12", , "4") & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
<%
'---�O��l---
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD>�@</TD>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 13
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�S�����Ȃ�"
    Case "2"
        strLstRsl = "���ɂ͂���"
    Case "3"
        strLstRsl = "���΂��΂���"
    Case "4"
        strLstRsl = "��ɂ���"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 14
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�S�����Ȃ�"
    Case "2"
        strLstRsl = "���ɂ͂���"
    Case "3"
        strLstRsl = "���΂��΂���"
    Case "4"
        strLstRsl = "��ɂ���"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 15
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�S�����Ȃ�"
    Case "2"
        strLstRsl = "���ɂ͂���"
    Case "3"
        strLstRsl = "���΂��΂���"
    Case "4"
        strLstRsl = "��ɂ���"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 16
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�S�����Ȃ�"
    Case "2"
        strLstRsl = "���ɂ͂���"
    Case "3"
        strLstRsl = "���΂��΂���"
    Case "4"
        strLstRsl = "��ɂ���"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 17
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�S�����Ȃ�"
    Case "2"
        strLstRsl = "���ɂ͂���"
    Case "3"
        strLstRsl = "���΂��΂���"
    Case "4"
        strLstRsl = "��ɂ���"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 18
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�S�����Ȃ�"
    Case "2"
        strLstRsl = "���ɂ͂���"
    Case "3"
        strLstRsl = "���΂��΂���"
    Case "4"
        strLstRsl = "��ɂ���"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 19
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�S�����Ȃ�"
    Case "2"
        strLstRsl = "���ɂ͂���"
    Case "3"
        strLstRsl = "���΂��΂���"
    Case "4"
        strLstRsl = "��ɂ���"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 20
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�S�����Ȃ�"
    Case "2"
        strLstRsl = "���ɂ͂���"
    Case "3"
        strLstRsl = "���΂��΂���"
    Case "4"
        strLstRsl = "��ɂ���"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 21
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�S�����Ȃ�"
    Case "2"
        strLstRsl = "���ɂ͂���"
    Case "3"
        strLstRsl = "���΂��΂���"
    Case "4"
        strLstRsl = "��ɂ���"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 22
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�S�����Ȃ�"
    Case "2"
        strLstRsl = "���ɂ͂���"
    Case "3"
        strLstRsl = "���΂��΂���"
    Case "4"
        strLstRsl = "��ɂ���"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 23
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�S�����Ȃ�"
    Case "2"
        strLstRsl = "���ɂ͂���"
    Case "3"
        strLstRsl = "���΂��΂���"
    Case "4"
        strLstRsl = "��ɂ���"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START3 + 24
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�S�����Ȃ�"
    Case "2"
        strLstRsl = "���ɂ͂���"
    Case "3"
        strLstRsl = "���΂��΂���"
    Case "4"
        strLstRsl = "��ɂ���"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
'------------
%>
                </TABLE>
            </TD>
        </TR>
    </TABLE>

<!-- 
******************************************************
    �w�l�Ȗ�f
******************************************************
 -->
<% 
    '�w�l�Ȗ�f�͏����̂ݕ\��
    If lngGender = 2 Then
%>
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
        <TR HEIGHT="20" >
            <TD NOWRAP WIDTH="20"></TD>
            <TD NOWRAP WIDTH="730" BGCOLOR="#98fb98"><SPAN ID="Anchor-Fujinka" STYLE="position:relative">�w�l�Ȗ�f�[</SAPN></TD>
            <TD NOWRAP WIDTH="220" BGCOLOR="#98fb98"></TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
<!-- '#### 2010.12.18 MOD STR TCS)H.F ####' -->
<!--
            <TD NOWRAP BGCOLOR="#eeeeee">1.�q�{��K���̌��f���󂯂����Ƃ�</TD>
-->
            <TD NOWRAP BGCOLOR="#eeeeee">1.�q�{�򂪂�̌��f���󂯂����Ƃ�</TD>
<!-- '#### 2010.12.18 MOD END TCS)H.F ####' -->
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 0
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & "<TD NOWRAP>�@�@" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_1", , "6") & "1�N�����@" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_1", , "7") & "1�`3�N�O�@" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_1", , "8") & "3�N�ȏ�O�@" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_1", , "5") & "�󂯂����ƂȂ��@" & vbLf
'    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_1", , "5") & "�󂯂����ƂȂ��@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
''### 2010.12.18 MOD END TCS)H.F
'---�O��l---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "6"
        strLstRsl = "1�N����"
    Case "7"
        strLstRsl = "1�`3�N�O"
    Case "8"
        strLstRsl = "3�N�ȏ�O"
    Case "5"
        strLstRsl = "�󂯂����ƂȂ�"
	'�O�R�[�h
    Case "1"
        strLstRsl = "6�P���ȓ�"
    Case "2"
        strLstRsl = "6�P���`1�N�ȓ�"
    Case "3"
        strLstRsl = "1�`2�N�ȓ�"
    Case "4"
        strLstRsl = "3�N�O�ȏ�"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML

''### 2010.12.18 ADD STR TCS)H.F
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & "" & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_1", , "6") & "1�N�����@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_1", , "7") & "1�`3�N�O�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_1", , "8") & "3�N�ȏ�O�@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML

''### 2010.12.18 ADD END TCS)H.F

%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">2.���f�̌��ʂ�</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 1
    strHTML = strHTML & "<TD NOWRAP>�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_2_1", , "1") & "�ُ�Ȃ��@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_2_1", , "2") & "�ٌ^���" & vbLf
    strHTML = strHTML & "�i�N���X" & vbLf
lngIndex = OCRGRP_START4 + 2
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_2_2", , "1") & "�Va�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_2_2", , "2") & "�Vb�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_2_2", , "3") & "�V�@" & vbLf
    strHTML = strHTML & "�j" & vbLf
'---�O��l---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�ُ�Ȃ�"
    Case "2"
        strLstRsl = "�ٌ^���"
		lngIndex = OCRGRP_START4 + 2
        Select Case  vntLstResult(lngIndex) 
        	Case  "1"
		        strLstRsl = strLstRsl & "�i�N���X�F�Va�j"
        	Case  "2"
		        strLstRsl = strLstRsl & "�i�N���X�F�Vb�j"
        	Case  "3"
		        strLstRsl = strLstRsl & "�i�N���X�F�V�j"
        End Select
	'�O�R�[�h
    Case "3"
        strLstRsl = "�ُ킠��"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & "�@" & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@�@" & vbLf
'#### 2010.07.09 SL-UI-Y0101-113 ADD START ####'
lngIndex = OCRGRP_START4 + 1
'#### 2010.07.09 SL-UI-Y0101-113 ADD END ####'
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_2_1", , "4") & "���̋^���@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_2_1", , "4") & "�q�{�򂪂�̋^���@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_2_1", , "9") & "���̑��@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "4"
''### 2010.12.18 MOD STR TCS)H.F
'        strLstRsl = "���̋^��"
        strLstRsl = "�q�{�򂪂�̋^��"
''### 2010.12.18 MOD END TCS)H.F
    Case "9"
        strLstRsl = "���̑�"

    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">3.���f���󂯂��{�݂�</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 3
    strHTML = strHTML & "<TD NOWRAP>�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_3", , "4") & "���Z���^�[�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_3", , "5") & "���a�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_3", , "6") & "���{�݁@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "4"
        strLstRsl = "���Z���^�["
    Case "5"
        strLstRsl = "���a�@"
    Case "6"
        strLstRsl = "���{��"
	'�O�R�[�h
    Case "1"
        strLstRsl = "���@"
    Case "2"
        strLstRsl = "���W�c���f"
    Case "3"
        strLstRsl = "����@�E���a�@"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>

        <TR HEIGHT="20">
            <TD NOWRAP></TD>
<!-- '#### 2010.12.18 MOD STR TCS)H.F ####' -->
<!--
            <TD NOWRAP BGCOLOR="#eeeeee">4.�ߋ��̎q�{��K�������ňُ��</TD>
-->
            <TD NOWRAP BGCOLOR="#eeeeee">4.�ߋ��̎q�{�򂪂񌟍��ňُ��</TD>
<!-- '#### 2010.12.18 MOD END TCS)H.F ####' -->
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 4
    strHTML = strHTML & "<TD NOWRAP>�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_4_1", , "1") & "�������@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_4_1", , "2") & "�͂��@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "������"
    Case "2"
        strLstRsl = "�͂�"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">�@</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@�@�u�͂��v�̏ꍇ" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML

    strHTML = ""
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD>" & vbLf

    strHTML = strHTML & "<TABLE BORDER=""0"" CELLSPALING=""0"">"
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 5
    strHTML = strHTML & "<TD NOWRAP>�@�@���ʁF</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_4_2", , "1") & "�ٌ^���" & vbLf
    strHTML = strHTML & "�i�N���X" & vbLf
lngIndex = OCRGRP_START4 + 6
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_4_3", , "1") & "�Va�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_4_3", , "2") & "�Vb�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_4_3", , "3") & "�V�@" & vbLf
    strHTML = strHTML & "�j" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & "�@" & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
lngIndex = OCRGRP_START4 + 5
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_4_2", , "2") & "���̋^���@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_4_2", , "2") & "�q�{�򂪂�̋^���@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_4_2", , "9") & "���̑��@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf

    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 7
    strHTML = strHTML & "<TD NOWRAP>�@�@�����F</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_4_4", , "1") & "1�N�����@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_4_4", , "2") & "1�`3�N�O�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_4_4", , "3") & "3�N�ȏ�O�@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf

'------------
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 8
    strHTML = strHTML & "<TD NOWRAP>�@�@�{�݁F</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_4_5", , "1") & "���Z���^�[�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_4_5", , "2") & "���a�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_4_5", , "3") & "���{�݁@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "</TABLE>"
    strHTML = strHTML & "</TD>" & vbLf

    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & "<TABLE BORDER=""0"" CELLSPALING=""0"">"
'---�O��l---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 5
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�ٌ^���"
		lngIndex = OCRGRP_START4 + 6
	    Select Case vntLstResult(lngIndex)
	    Case "1"
	        strLstRsl = strLstRsl & "�i�N���X�F�Va�j"
	    Case "2"
	        strLstRsl = strLstRsl & "�i�N���X�F�Vb�j"
	    Case "3"
	        strLstRsl = strLstRsl & "�i�N���X�F�V�j"
	    End Select
    End Select
    If strLstRsl = "" Then
        strLstRsl = "�@"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf

    strLstRsl = ""
lngIndex = OCRGRP_START4 + 5
    Select Case vntLstResult(lngIndex)
    Case "2"
''### 2010.12.18 MOD STR TCS)H.F
        strLstRsl = "�q�{�򂪂�̋^��"
''### 2010.12.18 MOD END TCS)H.F
    Case "9"
        strLstRsl = "���̑�"
    End Select
    If strLstRsl = "" Then
        strLstRsl = "�@"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf

    strLstRsl = ""
lngIndex = OCRGRP_START4 + 7
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "1�N����"
    Case "2"
        strLstRsl = "1�`3�N�O"
    Case "3"
        strLstRsl = "3�N�ȏ�O"
    End Select
    If strLstRsl = "" Then
        strLstRsl = "�@"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 8
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "���Z���^�["
    Case "2"
        strLstRsl = "���a�@"
    Case "3"
        strLstRsl = "���{��"
    End Select
    If strLstRsl = "" Then
        strLstRsl = "�@"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "</TABLE>" & vbLf

    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">5.�g�o�u(�q�g�p�s���[�}�E�B���X�j�������󂯂����Ƃ�</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 9
    strHTML = strHTML & "<TD NOWRAP>�@�@" & vbLf
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_5_1", , "1") & "�󂯂����ƂȂ��@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_5_1", , "1") & "�������@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_5_1", , "2") & "�͂��@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "������"
    Case "2"
        strLstRsl = "�͂�"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">�@</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@�@�u�͂��v�̏ꍇ" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML

    strHTML = ""
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD>" & vbLf
    strHTML = strHTML & "<TABLE BORDER=""0"" CELLSPALING=""0"">"  & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 10
    strHTML = strHTML & "<TD NOWRAP>�@�@���ʁF</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_5_2", , "1") & "�A���@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_5_2", , "2") & "�z��" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 11
    strHTML = strHTML & "<TD NOWRAP>�@�@�����F</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_5_3", , "1") & "1�N�����@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_5_3", , "2") & "1�`3�N�O�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_5_3", , "3") & "3�N�ȏ�O�@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 12
    strHTML = strHTML & "<TD NOWRAP>�@�@�{�݁F</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_5_4", , "1") & "���Z���^�[�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_5_4", , "2") & "���a�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_5_4", , "3") & "���{�݁@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "</TABLE>"
    strHTML = strHTML & "</TD>" & vbLf

'---�O��l---
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & "<TABLE BORDER=""0"" CELLSPALING=""0"">"
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 10
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�A��"
    Case "2"
        strLstRsl = "�z��"
    End Select
    If strLstRsl = "" Then
        strLstRsl = "�@"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf

    strLstRsl = ""
lngIndex = OCRGRP_START4 + 11
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "1�N����"
    Case "2"
        strLstRsl = "1�`3�N�O"
    Case "3"
        strLstRsl = "3�N�ȏ�O"
    End Select
    If strLstRsl = "" Then
        strLstRsl = "�@"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf

    strLstRsl = ""
lngIndex = OCRGRP_START4 + 12
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "���Z���^�["
    Case "2"
        strLstRsl = "���a�@"
    Case "3"
        strLstRsl = "���{��"
    End Select
    If strLstRsl = "" Then
        strLstRsl = "�@"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "</TABLE>" & vbLf
    strHTML = strHTML & "</TD>" & vbLf

    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>

        <TR HEIGHT="20">
            <TD NOWRAP></TD>
<!-- '#### 2010.12.18 MOD STR TCS)H.F ####' -->
<!--
            <TD NOWRAP BGCOLOR="#eeeeee">6.�q�{�̃K���������󂯂����Ƃ�</TD>
-->
            <TD NOWRAP BGCOLOR="#eeeeee">6.�q�{�̂��񌟍����󂯂����Ƃ�</TD>
<!-- '#### 2010.12.18 MOD END TCS)H.F ####' -->
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">"  & EditErrInfo &  "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 13
    strHTML = strHTML & "<TD NOWRAP>�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6_1", , "1") & "�������@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6_1", , "2") & "�͂��@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "������"
    Case "2"
        strLstRsl = "�͂�"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & "�@" & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@�@�u�͂��v�̏ꍇ" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML

    strHTML = ""
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD>" & vbLf
    strHTML = strHTML & "<TABLE BORDER=""0"" CELLSPALING=""0"">"
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 14
    strHTML = strHTML & "<TD NOWRAP>�@�@���ʁF</TD>" & vbLf
'### 2010.10.19 ADD STR TCS)H.F ���ُ�Ȃ��������Ă���
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6_2", , "1") & "�ُ�Ȃ�" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & "�@" & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'### 2010.10.19 ADD END TCS)H.F 
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6_2", , "2") & "�[�z��" & vbLf
    strHTML = strHTML & "�i�N���X" & vbLf
lngIndex = OCRGRP_START4 + 15
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6_3", , "1") & "�Va�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6_3", , "2") & "�Vb�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6_3", , "3") & "�V�@" & vbLf
    strHTML = strHTML & "�j" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & "�@" & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
lngIndex = OCRGRP_START4 + 14
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6_2", , "3") & "���̋^���@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6_2", , "3") & "�q�{�̂���̋^���@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6_2", , "9") & "���̑��@" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 16
    strHTML = strHTML & "<TD NOWRAP>�@�@�����F</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6_4", , "1") & "1�N�����@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6_4", , "2") & "1�`3�N�O�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6_4", , "3") & "3�N�ȏ�O�@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

'------------
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 17
    strHTML = strHTML & "<TD NOWRAP>�@�@�{�݁F</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6_5", , "1") & "���Z���^�[�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6_5", , "2") & "���a�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_6_5", , "3") & "���{�݁@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "</TABLE>"
    strHTML = strHTML & "</TD>" & vbLf

    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & "<TABLE BORDER=""0"" CELLSPALING=""0"">"

lngIndex = OCRGRP_START4 + 14
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�ُ�Ȃ�"
    Case "2"
        strLstRsl = "�[�z��"
		lngIndex = OCRGRP_START4 + 15
	    Select Case vntLstResult(lngIndex)
	    Case "1"
	        strLstRsl = strLstRsl & "�i�N���X�F�Va�j"
	    Case "2"
	        strLstRsl = strLstRsl & "�i�N���X�F�Vb�j"
	    Case "3"
	        strLstRsl = strLstRsl & "�i�N���X�F�V�j"
	    End Select
    Case "3"
        strLstRsl = "�ُ킠��"
    End Select
    If strLstRsl = "" Then
        strLstRsl = "�@"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf

lngIndex = OCRGRP_START4 + 14
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "3"
''### 2010.12.18 MOD STR TCS)H.F
'        strLstRsl = "���̋^��"
        strLstRsl = "�q�{�̂���̋^��"
''### 2010.12.18 MOD END TCS)H.F
    Case "9"
        strLstRsl = "���̑�"
    End Select
    If strLstRsl = "" Then
        strLstRsl = "�@"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf

lngIndex = OCRGRP_START4 + 16
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "1�N����"
    Case "2"
        strLstRsl = "1�`3�N�O"
    Case "3"
        strLstRsl = "3�N�ȏ�O"
    End Select
    If strLstRsl = "" Then
        strLstRsl = "�@"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    
lngIndex = OCRGRP_START4 + 17
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "���Z���^�["
    Case "2"
        strLstRsl = "���a�@"
    Case "3"
        strLstRsl = "���{��"
    End Select
    If strLstRsl = "" Then
        strLstRsl = "�@"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "</TABLE>" & vbLf
    strHTML = strHTML & "</TD>" & vbLf

    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>

        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">7.�w�l�Ȃ̕a�C���������Ƃ�</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@�@" & vbLf
lngIndex = OCRGRP_START4 + 18
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_1", , "1") & "�Ȃ�" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_1", , "1") & "�Ȃ��@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 19
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_2", , "2") & "�q�{�؎�" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_2", , "2") & "�q�{�؎�@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 20
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_3", , "11") & "�q�{��ǃ|���[�v" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_3", , "11") & "�q�{��ǃ|���[�v�@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 18
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�Ȃ�"
    End If
lngIndex = OCRGRP_START4 + 19
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�q�{�؎�"
    End If
lngIndex = OCRGRP_START4 + 20
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�q�{��ǃ|���[�v"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@�@" & vbLf
lngIndex = OCRGRP_START4 + 21
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_4", , "13") & "�����q�{�����ǁi�q�{�B�؏ǁj" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_4", , "13") & "�����q�{�����ǁi�q�{�B�؏ǁj�@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 22
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_5", , "14") & "�O���q�{�����ǁi�`���R���[�g�̂���Ȃǁj" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_5", , "14") & "�O���q�{�����ǁi�`���R���[�g�̂��E�Ȃǁj�@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 21
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�����q�{�����ǁi�q�{�B�؏ǁj"
    End If
lngIndex = OCRGRP_START4 + 22
    If vntLstResult(lngIndex)<>"" Then
''### 2010.12.18 MOD STR TCS)H.F
'        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�O���q�{�����ǁi�`���R���[�g�̂���Ȃǁj"
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�O���q�{�����ǁi�`���R���[�g�̂��E�Ȃǁj"
''### 2010.12.18 MOD END TCS)H.F
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@�@" & vbLf
lngIndex = OCRGRP_START4 + 23
''### 20100.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_6", , "15") & "�q�{��K��" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_6", , "15") & "�q�{�򂪂�@" & vbLf
''### 20100.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 24
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_7", , "16") & "�q�{�̃K��" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_7", , "16") & "�q�{�̂���@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 25
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_8", , "17") & "�����K��" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_8", , "17") & "��������" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 23
    If vntLstResult(lngIndex)<>"" Then
''### 2010.12.18 MOD STR TCS)H.F
'        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�q�{��K��"
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�q�{�򂪂�"
''### 2010.12.18 MOD END TCS)H.F
    End If
lngIndex = OCRGRP_START4 + 24
    If vntLstResult(lngIndex)<>"" Then
''### 2010.12.18 MOD STR TCS)H.F
'        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�q�{�̃K��"
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�q�{�̂���"
''### 2010.12.18 MOD END TCS)H.F
    End If
lngIndex = OCRGRP_START4 + 25
    If vntLstResult(lngIndex)<>"" Then
''### 2010.12.18 MOD STR TCS)H.F
'        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�����K��"
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "��������"
''### 2010.12.18 MOD END TCS)H.F
    End If
'�O�R�[�h
lngIndex = OCRGRP_START_Z + 4
    If vntLstResult(lngIndex)<>"" Then
''### 2010.12.18 MOD STR TCS)H.F
'        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�q�{��K��"
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�q�{�򂪂�"
''### 2010.12.18 MOD END TCS)H.F
    End If


    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@�@" & vbLf
lngIndex = OCRGRP_START4 + 26
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_9", , "18") & "�ǐ�������ᇁi�E�j" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_9", , "18") & "�ǐ�������ᇁi�E�j�@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 27
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_10", , "19") & "�ǐ�������ᇁi���j" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_10", , "19") & "�ǐ�������ᇁi���j�@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 28
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_11", , "22") & "�@�ѐ�����" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_11", , "22") & "�@�ѐ������@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 26
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�ǐ�������ᇁi�E�j"
    End If
lngIndex = OCRGRP_START4 + 27
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�ǐ�������ᇁi���j"
    End If
lngIndex = OCRGRP_START4 + 28
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�@�ѐ�����"
    End If
'�O�R�[�h
lngIndex = OCRGRP_START_Z + 0
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "������ᇁi�E�j"
    End If
lngIndex = OCRGRP_START_Z + 2
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "������ᇁi���j"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@�@" & vbLf
lngIndex = OCRGRP_START4 + 29
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_12", , "20") & "�t���퉊" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_12", , "20") & "�t���퉊�@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 30
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_13", , "4") & "�S��" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_13", , "4") & "�S���@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 31
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_14", , "21") & "�N���q�{�E" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_14", , "21") & "�N���q�{�E�@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 29
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�t���퉊"
    End If
lngIndex = OCRGRP_START4 + 30
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�S��"
    End If
lngIndex = OCRGRP_START4 + 31
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�N���q�{�E"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@�@" & vbLf
lngIndex = OCRGRP_START4 + 32
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_15", , "9") & "���K��" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_15", , "9") & "������@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 33
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_16", , "90") & "���̑�" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_7_16", , "90") & "���̑��@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 32
    If vntLstResult(lngIndex)<>"" Then
''### 2010.12.18 MOD STR TCS)H.F
'        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "���K��"
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "������"
''### 2010.12.18 MOD END TCS)H.F
    End If
lngIndex = OCRGRP_START4 + 33
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "���̑�"
    End If
'�O�R�[�h
lngIndex = OCRGRP_START_Z + 3
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "���o�ُ�"
    End If
lngIndex = OCRGRP_START_Z + 5
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�s�D"
    End If
lngIndex = OCRGRP_START_Z + 1
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�q�{������"
    End If
lngIndex = OCRGRP_START_Z + 6
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�т��"
    End If

    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    Response.Write strHTML

%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">8.���܂łɃz�������Ö@���󂯂����Ƃ�</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 34
    strHTML = strHTML & "<TD NOWRAP>�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_8", , "1") & "�󂯂����ƂȂ�" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 34
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�󂯂����ƂȂ�"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 34
    strHTML = strHTML & "<TD NOWRAP>�@�@" & vbLf
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_8", , "2") & "����" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_8", , "2") & "����@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 35
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 5, "") & "�΂���" & vbLf
lngIndex = OCRGRP_START4 + 36
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 5, "") & "�N��" & vbLf

    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 34
    Select Case vntLstResult(lngIndex)
    Case "2"
        strLstRsl = "���遨�@"
lngIndex = OCRGRP_START4 + 35
        strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "�΂���")
lngIndex = OCRGRP_START4 + 36
        strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "�N��")
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
 
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP><BR>�@�@" & vbLf
lngIndex = OCRGRP_START4 + 37
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_8", , "1") & "���ݕs�D���Ò�" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 37
    Select Case vntLstResult(lngIndex)
    Case "2"
        strLstRsl = "���ݕs�D���Ò�"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    Response.Write strHTML
%>

        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">9.���܂łɕa�C�ŕw�l�Ȃ̎�p����������</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 38
    strHTML = strHTML & "<TD NOWRAP>�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9", , "1") & "�󂯂����ƂȂ��@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9", , "2") & "�͂��@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�󂯂����ƂȂ�"
    Case "2"
        strLstRsl = "�͂�"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="0">
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
<%
'    strHTML = ""
'    For i=0 To 2
'        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
'        strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
'        strHTML = strHTML & "</TR>" & vbLf
'    Next
'    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP CELLSPACING="0" VALIGN="top">
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & "�@" & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�u�͂��v�̏ꍇ" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 39
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""100"">" & vbLf
''### 2010.12.18 MOD END TCS)H.F
''### 2010.12.18 MOD STR TCS)H.F
''    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_9_1", , "1") & "�E�����@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_9_1", , "1") & "�E�����@�@�@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & "<TD NOWRAP >" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""150"">" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 41
''## 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_1_1", , "1") & "�S�E" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_1_1", , "2") & "�����؏�" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_1_1", , "1") & "�S�E�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_1_1", , "2") & "�����؏�" & vbLf
''## 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP >" & vbLf
lngIndex = OCRGRP_START4 + 40
'### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_1_2", , "1") & "�ǐ��@" & 	vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_1_2", , "2") & "���E���@" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_1_2", , "3") & "�����@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_1_2", , "1") & "�ǐ��@�@" & 	vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_1_2", , "2") & "���E�^�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_1_2", , "3") & "�����@�@" & vbLf
'### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP><IMG SRC=""../../images/spacer.gif"" HEIGHT=""10"" WIDTH=""40""></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP >" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP >" & vbLf
lngIndex = OCRGRP_START4 + 42
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "��" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "�΁@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 43
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_1_3", , "1") & "���@�@" & vbLf
'#### 2010.07.09 SL-UI-Y0101-113 MOD START ####'
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_1_2", , "2") & "���@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_1_3", , "2") & "���@�@" & vbLf
'#### 2010.07.09 SL-UI-Y0101-113 MOD END ####'

    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 44
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_9_2", , "1") & "�������@�@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & "<TD NOWRAP >" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""150"">" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 46
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_2_1", , "1") & "�S�E" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_2_1", , "2") & "�����؏�" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_2_1", , "1") & "�S�E�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_2_1", , "2") & "�����؏�" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP >" & vbLf
lngIndex = OCRGRP_START4 + 45
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_2_2", , "1") & "�ǐ��@" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_2_2", , "2") & "���E���@" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_2_2", , "3") & "�����@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_2_2", , "1") & "�ǐ��@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_2_2", , "2") & "���E�^�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_2_2", , "3") & "�����@�@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP><IMG SRC=""../../images/spacer.gif"" HEIGHT=""10"" WIDTH=""40""></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP >" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP >" & vbLf
lngIndex = OCRGRP_START4 + 47
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "��" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "�΁@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 48
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_2_3", , "1") & "���@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_2_3", , "2") & "���@�@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 49
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
'#### 2010.07.05 SL-UI-Y0101-113 MOD START ####'
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_9_3", , "1") & "�q�{�S�E�p�@�@" & vbLf
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_9_3", , "3") & "�q�{�S�E�p�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_9_3", , "3") & "�q�{�S�E�p�@�@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
'#### 2010.07.05 SL-UI-Y0101-113 MOD END ####'

    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP >" & vbLf
lngIndex = OCRGRP_START4 + 50
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_3_1", , "1") & "�S���@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_3_1", , "2") & "����" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP >" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_3_1", , "3") & "���̑�" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP><IMG SRC=""../../images/spacer.gif"" HEIGHT=""10"" WIDTH=""40""></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP >" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP >" & vbLf
lngIndex = OCRGRP_START4 + 51
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "��" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "�΁@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 52
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_3_2", , "1") & "���@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_3_2", , "2") & "���@�@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 53
    strHTML = strHTML & "<TD NOWRAP COLSPAN=""2"">" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_9_4", , "1") & "�L�Ďq�{�S�E�p�@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP >" & vbLf
lngIndex = OCRGRP_START4 + 54
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "��" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "�΁@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 55
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_4_1", , "1") & "���@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_4_1", , "2") & "���@�@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 56
    strHTML = strHTML & "<TD NOWRAP COLSPAN=""2"">" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_9_5", , "1") & "�q�{�򕔉~���؏��p�@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP >" & vbLf
lngIndex = OCRGRP_START4 + 57
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "��" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "�΁@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 58
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_5_1", , "1") & "���@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_5_1", , "2") & "���@�@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 59
    strHTML = strHTML & "<TD NOWRAP COLSPAN=""2"">" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_9_6", , "1") & "�q�{�؎�j�o�p�@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP >" & vbLf
lngIndex = OCRGRP_START4 + 60
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "��" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "�΁@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 61
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_6_1", , "1") & "���@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_6_1", , "2") & "���@�@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 62
    strHTML = strHTML & "<TD NOWRAP COLSPAN=""2"">" & vbLf
''### 2011.01.04 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_9_7", , "1") & "�q�{�㕔�؏��p�i�q�{�򕔎c���j" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_9_7", , "1") & "�q�{�S�㕔�ؒf�p�i�q�{�򕔎c���j" & vbLf
''### 2011.01.04 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP >" & vbLf
lngIndex = OCRGRP_START4 + 63
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "��" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "�΁@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 64
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_7_1", , "1") & "���@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_7_1", , "2") & "���@�@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 65
    strHTML = strHTML & "<TD NOWRAP COLSPAN=""2"">" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_9_8", , "1") & "���̑��̎�p" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP >" & vbLf
lngIndex = OCRGRP_START4 + 66
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "��" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "�΁@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 67
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_8_1", , "1") & "���@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_9_8_1", , "2") & "���@�@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
<%
'---�O��l---
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28""><TD>�@</TD></TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START4 + 39
    strLstRsl = ""
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = "�E����"
    End If
'�O�R�[�h
lngIndex = OCRGRP_START_Z + 18
    If (vntLstResult(lngIndex) = "4") AND ( (vntLstResult(lngIndex + 2 ) = "7") OR (vntLstResult(lngIndex + 2 ) = "9") )  Then
        strLstRsl = "�E����"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 40
    strLstRsl = ""
    If vntLstResult(lngIndex)<>"" Then
        Select Case vntLstResult(lngIndex)
        Case "1"
            strLstRsl = strLstRsl & "�@�ǐ�"
        Case "2"
            strLstRsl = strLstRsl & "�@���E�^"
        Case "3"
            strLstRsl = strLstRsl & "�@����"
        End Select
    End If
lngIndex = OCRGRP_START4 + 41
    If vntLstResult(lngIndex)<>"" Then
        Select Case vntLstResult(lngIndex)
        Case "1"
            strLstRsl = strLstRsl & "�@�S�E"
        Case "2"
            strLstRsl = strLstRsl & "�@�����؏�"
        End Select
    End If
lngIndex = OCRGRP_START4 + 42
        strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", "�@" & vntLstResult(lngIndex) & "��")
'�O�R�[�h
lngIndex = OCRGRP_START_Z + 18
    If (vntLstResult(lngIndex) = "4") AND ( (vntLstResult(lngIndex + 2 ) = "7") OR (vntLstResult(lngIndex + 2 ) = "9") )  Then
		lngIndex = OCRGRP_START_Z + 19
        strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", "�@" & vntLstResult(lngIndex) & "��")
    End If

lngIndex = OCRGRP_START4 + 43
    If vntLstResult(lngIndex)<>"" Then
        Select Case vntLstResult(lngIndex)
        Case "1"
            strLstRsl = strLstRsl & "�@���@"
        Case "2"
            strLstRsl = strLstRsl & "�@���@"
        End Select
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28""><TD>�@</TD></TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START4 + 44
    strLstRsl = ""
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = "������"
    End If
'�O�R�[�h
lngIndex = OCRGRP_START_Z + 18
    If (vntLstResult(lngIndex) = "4") AND ( (vntLstResult(lngIndex + 2 ) = "8") OR (vntLstResult(lngIndex + 2 ) = "9") )  Then
        strLstRsl = "������"
    End If
    If strLstRsl = "" Then
       strLstRsl = "�@"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 45
    strLstRsl = ""
    If vntLstResult(lngIndex)<>"" Then
        Select Case vntLstResult(lngIndex)
        Case "1"
            strLstRsl = strLstRsl & "�@�ǐ�"
        Case "2"
            strLstRsl = strLstRsl & "�@���E�^"
        Case "3"
            strLstRsl = strLstRsl & "�@����"
        End Select
    End If
lngIndex = OCRGRP_START4 + 46
    If vntLstResult(lngIndex)<>"" Then
        Select Case vntLstResult(lngIndex)
        Case "1"
            strLstRsl = strLstRsl & "�@�S�E"
        Case "2"
            strLstRsl = strLstRsl & "�@�����؏�"
        End Select
    End If
lngIndex = OCRGRP_START4 + 47
        strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", "�@" & vntLstResult(lngIndex) & "��")
'�O�R�[�h
lngIndex = OCRGRP_START_Z + 18
    If (vntLstResult(lngIndex) = "4") AND ( (vntLstResult(lngIndex + 2 ) = "8") OR (vntLstResult(lngIndex + 2 ) = "9") )  Then
		lngIndex = OCRGRP_START_Z + 19
        strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", "�@" & vntLstResult(lngIndex) & "��")
    End If

lngIndex = OCRGRP_START4 + 48
    If vntLstResult(lngIndex)<>"" Then
        Select Case vntLstResult(lngIndex)
        Case "1"
            strLstRsl = strLstRsl & "�@���@"
        Case "2"
            strLstRsl = strLstRsl & "�@���@"
        End Select
    End If
    If strLstRsl = "" Then
       strLstRsl = "�@"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28""><TD>�@</TD></TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START4 + 49
    strLstRsl = ""
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = "�q�{�S�E�p"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 50
    strLstRsl = ""
    If vntLstResult(lngIndex)<>"" Then
        Select Case vntLstResult(lngIndex)
        Case "1"
            strLstRsl = strLstRsl & "�@�S��"
        Case "2"
            strLstRsl = strLstRsl & "�@����"
        Case "3"
            strLstRsl = strLstRsl & "�@���̑�"
        End Select
    End If
lngIndex = OCRGRP_START4 + 51
    strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", "�@" & vntLstResult(lngIndex) & "��")
'�O�R�[�h
    If (vntLstResult(lngIndex) = "4") AND ( (vntLstResult(lngIndex + 2 ) = "8") OR (vntLstResult(lngIndex + 2 ) = "9") )  Then
		lngIndex = OCRGRP_START_Z + 17
        strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", "�@" & vntLstResult(lngIndex) & "��")
    End If
lngIndex = OCRGRP_START4 + 52
    If vntLstResult(lngIndex)<>"" Then
        Select Case vntLstResult(lngIndex)
        Case "1"
            strLstRsl = strLstRsl & "�@���@"
        Case "2"
            strLstRsl = strLstRsl & "�@���@"
        End Select
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28""><TD>�@</TD></TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START4 + 53
    strLstRsl = ""
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = "�L�Ďq�{�S�E�p"
    End If
    If strLstRsl = "" Then
       strLstRsl = "�@"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 54
        strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", "�@" & vntLstResult(lngIndex) & "��")
lngIndex = OCRGRP_START4 + 55
    If vntLstResult(lngIndex)<>"" Then
        Select Case vntLstResult(lngIndex)
        Case "1"
            strLstRsl = strLstRsl & "�@���@"
        Case "2"
            strLstRsl = strLstRsl & "�@���@"
        End Select
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START4 + 56
    strLstRsl = ""
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = "�q�{�򕔉~���؏��p"
    End If
    If strLstRsl = "" Then
       strLstRsl = "�@"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 57
        strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", "�@" & vntLstResult(lngIndex) & "��")
lngIndex = OCRGRP_START4 + 58
    If vntLstResult(lngIndex)<>"" Then
        Select Case vntLstResult(lngIndex)
        Case "1"
            strLstRsl = strLstRsl & "�@���@"
        Case "2"
            strLstRsl = strLstRsl & "�@���@"
        End Select
    End If

    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START4 + 59
    strLstRsl = ""
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = "�q�{�؎�j�o�p"
    End If
'�O�R�[�h
lngIndex = OCRGRP_START_Z + 16
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = "�q�{�؎�j�o�p"
    End If
    If strLstRsl = "" Then
       strLstRsl = "�@"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 60
    strLstRsl = ""
    strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", "�@" & vntLstResult(lngIndex) & "��")
'�O�R�[�h
lngIndex = OCRGRP_START_Z + 17
    strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", "�@" & vntLstResult(lngIndex) & "��")
lngIndex = OCRGRP_START4 + 61
    If vntLstResult(lngIndex)<>"" Then
        Select Case vntLstResult(lngIndex)
        Case "1"
            strLstRsl = strLstRsl & "�@���@"
        Case "2"
            strLstRsl = strLstRsl & "�@���@"
        End Select
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START4 + 62
    strLstRsl = ""
    If vntLstResult(lngIndex)<>"" Then
''### 2011.01.04 ADD MOD STR TCS)H.F
''        strLstRsl = "�q�{�㕔�؏��p�i�q�{�򕔎c���j"
        strLstRsl = "�q�{�S�㕔�ؒf�p�i�q�{�򕔎c���j"
''### 2011.01.04 ADD MOD END TCS)H.F
    End If
    If strLstRsl = "" Then
       strLstRsl = "�@"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 63
        strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", "�@" & vntLstResult(lngIndex) & "��")
lngIndex = OCRGRP_START4 + 64
    If vntLstResult(lngIndex)<>"" Then
        Select Case vntLstResult(lngIndex)
        Case "1"
            strLstRsl = strLstRsl & "�@���@"
        Case "2"
            strLstRsl = strLstRsl & "�@���@"
        End Select
    End If

    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START4 + 65
    strLstRsl = ""
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = "���̑��̎�p"
    End If
    If strLstRsl = "" Then
       strLstRsl = "�@"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 66
        strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", "�@" & vntLstResult(lngIndex) & "��")
lngIndex = OCRGRP_START4 + 67
    If vntLstResult(lngIndex)<>"" Then
        Select Case vntLstResult(lngIndex)
        Case "1"
            strLstRsl = strLstRsl & "�@���@"
        Case "2"
            strLstRsl = strLstRsl & "�@���@"
        End Select
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    Response.Write strHTML
'------------
%>
                </TABLE>
            </TD>
        </TR>

        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">10.���̌���</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START4 + 68
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_10_1", , "1") & "�Ȃ��@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_10_1", , "2") & "����" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�Ȃ�"
    Case "2"
        strLstRsl = "����"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">11�D�D�P���Ă���\����</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START4 + 69
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_11_1", , "1") & "�Ȃ��@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_11_1", , "2") & "����" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�Ȃ�"
    Case "2"
        strLstRsl = "����"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">12�D�D�P����</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 70
    strHTML = strHTML & "<TD NOWRAP>�@�@�D�P�̉�" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "��" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "��")
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 71
    strHTML = strHTML & "<TD NOWRAP>�@�@���؂̉�" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "��i���̂����鉤�؊J" & vbLf
lngIndex = OCRGRP_START4 + 72
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "��j" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 71
    If vntLstResult(lngIndex) <> "" Then
        strLstRsl = strLstRsl & vntLstResult(lngIndex) & "��"
    End If
lngIndex = OCRGRP_START4 + 72
    If vntLstResult(lngIndex) <> "" Then
        strLstRsl = strLstRsl & "�i�鉤�؊J�F" & vntLstResult(lngIndex) & "��j"
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    Response.Write strHTML
%>

        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">13�D�o���܂�����</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 73
    strHTML = strHTML & "<TD NOWRAP>�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_13_1", , "1") & "������" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 73
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "������"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 73
    strHTML = strHTML & "<TD NOWRAP>�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_13_1", , "2") & "�͂�" & vbLf
lngIndex = OCRGRP_START4 + 74
    strHTML = strHTML & EditRsl(lngIndex, "text", "Rsl", 3, "") & "��" & vbLf

    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 73
    Select Case vntLstResult(lngIndex)
    Case "2"
        strLstRsl = "�͂���"
lngIndex = OCRGRP_START4 + 74
        strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "��")
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    Response.Write strHTML
%>

        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">14�D���o</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>

        <TR HEIGHT="20">
            <TD NOWRAP>
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & "<TD>�@�@�@�ŏI���o�@�@�@�@</TD>" & vbLf
    strHTML = strHTML & "<TD WIDTH=""110"">�@�@�@�ŏI���o�@�@�@�@</TD>" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "<TD>�@�@<A HREF=""javascript:calGuide_showGuideCalendar('year14_1', 'month14_1', 'day14_1')""><IMG SRC=""../../images/question.gif"" WIDTH=""21"" HEIGHT=""21"" ALT=""���t�K�C�h��\��"" BORDER=""0""></A></TD>" & vbLf
lngIndex = OCRGRP_START4 + 75
    strHTML = strHTML & "<TD>" & EditRsl(lngIndex, "listyear", "year14_1", , "") & "</TD>" & vbLf
    strHTML = strHTML & "<TD>�N</TD>" & vbLf
lngIndex = OCRGRP_START4 + 76
    strHTML = strHTML & "<TD>" & EditRsl(lngIndex, "listmonth", "month14_1", , "") & "</TD>" & vbLf
    strHTML = strHTML & "<TD>��</TD>" & vbLf
lngIndex = OCRGRP_START4 + 77
    strHTML = strHTML & "<TD>" & EditRsl(lngIndex, "listday", "day14_1", , "") & "</TD>" & vbLf
    strHTML = strHTML & "<TD>��</TD>" & vbLf
    strHTML = strHTML & "<TD>�`</TD>" & vbLf
    strHTML = strHTML & "<TD><A HREF=""javascript:calGuide_showGuideCalendar('', 'month14_2', 'day14_2')""><IMG SRC=""../../images/question.gif"" WIDTH=""21"" HEIGHT=""21"" ALT=""���t�K�C�h��\��"" BORDER=""0""></A></TD>" & vbLf
    strHTML = strHTML & "<TD></TD>" & vbLf
    strHTML = strHTML & "<TD></TD>" & vbLf
lngIndex = OCRGRP_START4 + 78
    strHTML = strHTML & "<TD>" & EditRsl(lngIndex, "listmonth", "month14_2", , "") & "</TD>" & vbLf
    strHTML = strHTML & "<TD>��</TD>" & vbLf
lngIndex = OCRGRP_START4 + 79
    strHTML = strHTML & "<TD>" & EditRsl(lngIndex, "listday", "day14_2", , "") & "</TD>" & vbLf
    strHTML = strHTML & "<TD>��</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
<%
'---�O��l---
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 75
    strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "�N")
lngIndex = OCRGRP_START4 + 76
    strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "��")
lngIndex = OCRGRP_START4 + 77
    strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "��")
    strLstRsl = strLstRsl & "�`"
lngIndex = OCRGRP_START4 + 78
    strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "��")
lngIndex = OCRGRP_START4 + 79
    strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "��")
    If strLstRsl = "�`" Then
        strLstRsl = ""
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
'------------
%>
                </TABLE>
            </TD>
        </TR>

        <TR HEIGHT="20">
            <TD NOWRAP>
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & "<TD>�@�@�A���̑O�̌��o�@�@�@�@</TD>" & vbLf
    strHTML = strHTML & "<TD WIDTH=""110"">�@�@�A���̑O�̌��o�@�@�@�@</TD>" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "<TD>�@�@<A HREF=""javascript:calGuide_showGuideCalendar('year14_3', 'month14_3', 'day14_3')""><IMG SRC=""../../images/question.gif"" WIDTH=""21"" HEIGHT=""21"" ALT=""���t�K�C�h��\��"" BORDER=""0""></A></TD>" & vbLf
lngIndex = OCRGRP_START4 + 80
    strHTML = strHTML & "<TD>" & EditRsl(lngIndex, "listyear", "year14_3", , "") & "</TD>" & vbLf
    strHTML = strHTML & "<TD>�N</TD>" & vbLf
lngIndex = OCRGRP_START4 + 81
    strHTML = strHTML & "<TD>" & EditRsl(lngIndex, "listmonth", "month14_3", , "") & "</TD>" & vbLf
    strHTML = strHTML & "<TD>��</TD>" & vbLf
lngIndex = OCRGRP_START4 + 82
    strHTML = strHTML & "<TD>" & EditRsl(lngIndex, "listday", "day14_3", , "") & "</TD>" & vbLf
    strHTML = strHTML & "<TD>��</TD>" & vbLf
    strHTML = strHTML & "<TD>�`</TD>" & vbLf
    strHTML = strHTML & "<TD><A HREF=""javascript:calGuide_showGuideCalendar('', 'month14_4', 'day14_4')""><IMG SRC=""../../images/question.gif"" WIDTH=""21"" HEIGHT=""21"" ALT=""���t�K�C�h��\��"" BORDER=""0""></A></TD>" & vbLf
    strHTML = strHTML & "<TD></TD>" & vbLf
    strHTML = strHTML & "<TD></TD>" & vbLf
lngIndex = OCRGRP_START4 + 83
    strHTML = strHTML & "<TD>" & EditRsl(lngIndex, "listmonth", "month14_4", , "") & "</TD>" & vbLf
    strHTML = strHTML & "<TD>��</TD>" & vbLf
lngIndex = OCRGRP_START4 + 84
    strHTML = strHTML & "<TD>" & EditRsl(lngIndex, "listday", "day14_4", , "") & "</TD>" & vbLf
    strHTML = strHTML & "<TD>��</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
<%
'---�O��l---
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 80
    strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "�N")
lngIndex = OCRGRP_START4 + 81
    strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "��")
lngIndex = OCRGRP_START4 + 82
    strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "��")
    strLstRsl = strLstRsl & "�`"
lngIndex = OCRGRP_START4 + 83
    strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "��")
lngIndex = OCRGRP_START4 + 84
    strLstRsl = strLstRsl & IIf(vntLstResult(lngIndex)="", "", vntLstResult(lngIndex) & "��")
    If strLstRsl = "�`" Then
        strLstRsl = ""
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
'------------
%>
                </TABLE>
            </TD>
        </TR>

        <TR HEIGHT="20">
            <TD NOWRAP>
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START4 + 85
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & "<TD NOWRAP>�@�@�B�o����" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_14_1", , "1") & "���Ȃ��@" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_14_1", , "2") & "�ӂ�" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_14_1", , "3") & "����" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@�@�B�o���ʁ@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_14_1", , "1") & "���Ȃ��@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_14_1", , "2") & "�ӂ��@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_14_1", , "3") & "����" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
                </TABLE>
            </TD>
<%
    strHTML = ""
'---�O��l---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "���Ȃ�"
    Case "2"
        strLstRsl = "�ӂ�"
    Case "3"
        strLstRsl = "����"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>

        <TR HEIGHT="20">
            <TD NOWRAP>
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START4 + 86
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & "<TD NOWRAP>�@�@�C���o��" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_14_2", , "4") & "�y���@" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_14_2", , "5") & "�ӂ�" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_14_2", , "6") & "����" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@�@�C���o�Ɂ@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_14_2", , "4") & "�y���@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_14_2", , "5") & "�ӂ��@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_14_2", , "6") & "�����@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
                </TABLE>
            </TD>
<%
    strHTML = ""
'---�O��l---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "4"
        strLstRsl = "�y��"
    Case "5"
        strLstRsl = "�ӂ�"
    Case "6"
        strLstRsl = "����"
'�O�R�[�h
    Case "1"
        strLstRsl = "�Ȃ��A���͌y���ɂ�"
    Case "2"
        strLstRsl = "�����ɂ݂����X����"
    Case "3"
        strLstRsl = "����Ђǂ��ɂ݂�����"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl &  "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">15�D6�����ȓ��Ɍ��o�ȊO�ɏo���������Ƃ�</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 87
    strHTML = strHTML & "<TD NOWRAP>�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_15_1", , "1") & "�Ȃ�" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 87
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�Ȃ�"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 87
    strHTML = strHTML & "<TD NOWRAP>�@�@" & vbLf
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_15_1", , "4") & "����" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_15_1", , "4") & "����@�@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 88
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_15_2", , "1") & "�o��o��" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_15_2", , "2") & "�������o��" & vbLf
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_15_2", , "3") & "���̑��̏o��" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_15_2", , "1") & "�o��o���@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_15_2", , "2") & "�������o���@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_15_2", , "3") & "���̑��̏o���@" & vbLf
''### 2010.12.18 MOD END TCS)H.F

    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 87
    Select Case vntLstResult(lngIndex)
    Case "2", "3","4"
        strLstRsl = "����"
'�O�R�[�h
		Select Case vntLstResult(lngIndex)
	    Case "2"
	        strLstRsl = strLstRsl & "�i�P�N�ȓ��ɂ���j"
	    Case "3"
	        strLstRsl = strLstRsl & "�i�P�N�ȏ�O�ɂ���j"
		End Select

		lngIndex = OCRGRP_START4 + 88
	    Select Case vntLstResult(lngIndex)
	    Case "1"
	        strLstRsl = "��" & "�o��o��"
	    Case "2"
	        strLstRsl = "��" & "�������o��"
	    Case "3"
	        strLstRsl = "��" & "���̑��̏o��"
	    End Select
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    Response.Write strHTML
%>

        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">16�D���̑��C�ɂȂ�Ǐ�͂���܂���</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 89
    strHTML = strHTML & "<TD NOWRAP>�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_16_1", , "1") & "�Ȃ�" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 89
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�Ȃ�"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 89
    strHTML = strHTML & "<TD NOWRAP>�@�@" & vbLf
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_16_1", , "10") & "����" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_16_1", , "10") & "����@�@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 90
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_16_1", , "1") & "�������Ɂi���o�ɈȊO�Łj" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_16_1", , "1") & "�������Ɂi���o�ɈȊO�Łj�@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 91
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_16_1", , "1") & "������́i���l���j" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_16_1", , "1") & "������́i���l���j�@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 92
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_16_1", , "1") & "������́i���t�A���F�܂ށj" & vbLf

    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
lngIndex = OCRGRP_START4 + 89
    Select Case vntLstResult(lngIndex)
    Case "4"
	lngIndex = OCRGRP_START4 + 90
	    If vntLstResult(lngIndex)<>"" Then
	        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�������Ɂi���o�ɈȊO�Łj"
	    End If
	lngIndex = OCRGRP_START4 + 91
	    If vntLstResult(lngIndex)<>"" Then
	        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "������́i���l���j"
	    End If
	lngIndex = OCRGRP_START4 + 92
	    If vntLstResult(lngIndex)<>"" Then
	        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "������́i���t�A���F�܂ށj"
	    End If
    End Select
'�O�R�[�h
	lngIndex = OCRGRP_START_Z + 7
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "������̂��C�ɂȂ�"
    End If
	lngIndex = OCRGRP_START_Z + 8
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�A�������䂢"
    End If
	lngIndex = OCRGRP_START_Z + 9
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "���������ɂ�"
    End If
	lngIndex = OCRGRP_START_Z + 10
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�X�N���Ǐ󂪂炢"
    End If
	lngIndex = OCRGRP_START_Z + 11
    If vntLstResult(lngIndex)<>"" Then
        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "�������ɏo������"
    End If
    If strLstRsl = "" Then
        strLstRsl = "�@"
    Else
        strLstRsl = "�͂���" & strLstRsl 
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    Response.Write strHTML
%>

        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">17.���Ƒ��ŕw�l�Ȍn�̃K���ɂ�����ꂽ����</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>

<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
lngIndex = OCRGRP_START4 + 93
    strHTML = strHTML & "<TD NOWRAP>�@�@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_17_1", , "1") & "���Ȃ��@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt4_17_1", , "10") & "����@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "���Ȃ�"
    Case "10"
        strLstRsl = "����"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & "�@" & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@�@�u����v�̏ꍇ" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML

    strHTML = ""
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD>" & vbLf

    strHTML = strHTML & "<TABLE BORDER=""0"" CELLSPALING=""0"">"
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & "<TD NOWRAP>�@�@" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""170"">�@�@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 94
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_1", , "1") & "�q�{��K��" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_1", , "1") & "�q�{�򂪂�" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""60"">" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 95
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_2", , "1") & "����@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_2", , "1") & "����@�@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""70"">" & vbLf
''### 2010.12.18 MOD END TCS)H.F
lngIndex = OCRGRP_START4 + 96
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_3", , "2") & "���o���@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_3", , "2") & "���o���@�@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
lngIndex = OCRGRP_START4 + 97
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_4", , "3") & "���̑������@" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_4", , "3") & "���̑������@�@" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@�@" & vbLf
lngIndex = OCRGRP_START4 + 98
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_5", , "5") & "�q�{�̃K��" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_5", , "5") & "�q�{�̂���" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
lngIndex = OCRGRP_START4 + 99
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_6", , "1") & "����@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
lngIndex = OCRGRP_START4 + 100
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_7", , "2") & "���o���@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
lngIndex = OCRGRP_START4 + 101
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_8", , "3") & "���̑������@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@�@" & vbLf
lngIndex = OCRGRP_START4 + 102
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_9", , "7") & "�����K��" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_9", , "7") & "��������" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
lngIndex = OCRGRP_START4 + 103
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_10", , "1") & "����@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
lngIndex = OCRGRP_START4 + 104
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_11", , "2") & "���o���@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
lngIndex = OCRGRP_START4 + 105
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_12", , "3") & "���̑������@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@�@" & vbLf
lngIndex = OCRGRP_START4 + 106
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_13", , "9") & "���̑��̕w�l�ȃK��" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_13", , "9") & "���̑��̕w�l�Ȃ���" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
lngIndex = OCRGRP_START4 + 107
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_14", , "1") & "����@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
lngIndex = OCRGRP_START4 + 108
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_15", , "2") & "���o���@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
lngIndex = OCRGRP_START4 + 109
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_16", , "3") & "���̑������@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    Response.Write strHTML

    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@�@" & vbLf
lngIndex = OCRGRP_START4 + 110
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_17", , "8") & "���K��" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_17", , "8") & "������" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
lngIndex = OCRGRP_START4 + 111
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_18", , "1") & "����@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
lngIndex = OCRGRP_START4 + 112
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_19", , "2") & "���o���@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
lngIndex = OCRGRP_START4 + 113
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk4_17_20", , "3") & "���̑������@" & vbLf
    strHTML = strHTML & "</TD>" & vbLf

'------------
    strHTML = strHTML & "</TR>" & vbLf
    strHTML = strHTML & "</TABLE>"
    strHTML = strHTML & "</TD>" & vbLf

    strHTML = strHTML & "<TD NOWRAP>" & vbLf
'�O��l
    strHTML = strHTML & "  <TABLE BORDER=""0"" CELLSPALING=""0"">"

    strLstRsl = ""
    strHTML = strHTML & "  <TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START4 + 94
    Select Case vntLstResult(lngIndex)
    Case "1"
		lngIndex = OCRGRP_START4 + 95
	    If vntLstResult(lngIndex)<>"" Then
	        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "����"
	    End If
		lngIndex = OCRGRP_START4 + 96
	    If vntLstResult(lngIndex)<>"" Then
	        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "���o��"
	    End If
		lngIndex = OCRGRP_START4 + 97
	    If vntLstResult(lngIndex)<>"" Then
	        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "���̑�����"
	    End If
    End Select
'�O�R�[�h
lngIndex = OCRGRP_START_Z + 12
    Select Case vntLstResult(lngIndex)
    Case "6"
		lngIndex = OCRGRP_START_Z + 13
		    If vntLstResult(lngIndex)<>"" Then
		        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "����"
		    End If
		lngIndex = OCRGRP_START_Z + 14
		    If vntLstResult(lngIndex)<>"" Then
		        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "���o��"
		    End If
		lngIndex = OCRGRP_START_Z + 15
		    If vntLstResult(lngIndex)<>"" Then
		        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "���̑�"
		    End If
    End Select
    If strLstRsl = "" Then
       strLstRsl = "�@"
    Else
''### 2010.12.18 MOD STR TCS)H.F
'        strLstRsl = "�q�{��K����" & strLstRsl
        strLstRsl = "�q�{�򂪂�" & strLstRsl
''### 2010.12.18 MOD END TCS)H.F
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "  </TR>" & vbLf

    strLstRsl = ""
    strHTML = strHTML & "  <TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START4 + 98
    Select Case vntLstResult(lngIndex)
    Case "5"
		lngIndex = OCRGRP_START4 + 99
	    If vntLstResult(lngIndex)<>"" Then
	        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "����"
	    End If
		lngIndex = OCRGRP_START4 + 100
	    If vntLstResult(lngIndex)<>"" Then
	        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "���o��"
	    End If
		lngIndex = OCRGRP_START4 + 101
	    If vntLstResult(lngIndex)<>"" Then
	        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "���̑�����"
	    End If
		lngIndex = OCRGRP_START_Z + 13
		    If vntLstResult(lngIndex)<>"" Then
		        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "����"
		    End If
		lngIndex = OCRGRP_START_Z + 14
		    If vntLstResult(lngIndex)<>"" Then
		        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "���o��"
		    End If
		lngIndex = OCRGRP_START_Z + 15
		    If vntLstResult(lngIndex)<>"" Then
		        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "���̑�"
		    End If
    End Select
    If strLstRsl = "" Then
       strLstRsl = "�@"
    Else
''### 2010.12.18 MOD STR TCS)H.F
'        strLstRsl = "�q�{�̃K����" & strLstRsl
        strLstRsl = "�q�{�̂���" & strLstRsl
''### 2010.12.18 MOD END TCS)H.F
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "  </TR>" & vbLf

    strLstRsl = ""
    strHTML = strHTML & "  <TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START4 + 102
    Select Case vntLstResult(lngIndex)
    Case "7"
		lngIndex = OCRGRP_START4 + 103
	    If vntLstResult(lngIndex)<>"" Then
	        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "����"
	    End If
		lngIndex = OCRGRP_START4 + 104
	    If vntLstResult(lngIndex)<>"" Then
	        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "���o��"
	    End If
		lngIndex = OCRGRP_START4 + 105
	    If vntLstResult(lngIndex)<>"" Then
	        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "���̑�����"
	    End If
		lngIndex = OCRGRP_START_Z + 13
		    If vntLstResult(lngIndex)<>"" Then
		        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "����"
		    End If
		lngIndex = OCRGRP_START_Z + 14
		    If vntLstResult(lngIndex)<>"" Then
		        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "���o��"
		    End If
		lngIndex = OCRGRP_START_Z + 15
		    If vntLstResult(lngIndex)<>"" Then
		        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "���̑�"
		    End If
    End Select
    If strLstRsl = "" Then
       strLstRsl = "�@"
    Else
''### 2010.12.18 MOD STR TCS)H.F
'        strLstRsl =  "�����K����" & strLstRsl
        strLstRsl =  "��������" & strLstRsl
''### 2010.12.18 MOD END TCS)H.F
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "  </TR>" & vbLf

    strLstRsl = ""
    strHTML = strHTML & "  <TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START4 + 106
    Select Case vntLstResult(lngIndex)
    Case "9"
		lngIndex = OCRGRP_START4 + 107
	    If vntLstResult(lngIndex)<>"" Then
	        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "����"
	    End If
		lngIndex = OCRGRP_START4 + 108
	    If vntLstResult(lngIndex)<>"" Then
	        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "���o��"
	    End If
		lngIndex = OCRGRP_START4 + 109
	    If vntLstResult(lngIndex)<>"" Then
	        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "���̑�����"
	    End If
		lngIndex = OCRGRP_START_Z + 13
		    If vntLstResult(lngIndex)<>"" Then
		        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "����"
		    End If
		lngIndex = OCRGRP_START_Z + 14
		    If vntLstResult(lngIndex)<>"" Then
		        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "���o��"
		    End If
		lngIndex = OCRGRP_START_Z + 15
		    If vntLstResult(lngIndex)<>"" Then
		        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "���̑�"
		    End If
    End Select
    If strLstRsl = "" Then
       strLstRsl = "�@"
    Else
''### 2010.12.18 MOD STR TCS)H.F
'        strLstRsl =  "���̑��̕w�l�ȃK����" & strLstRsl
        strLstRsl =  "���̑��̕w�l�Ȃ���" & strLstRsl
''### 2010.12.18 MOD END TCS)H.F
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "  </TR>" & vbLf

    strLstRsl = ""
    strHTML = strHTML & "  <TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START4 + 110
    Select Case vntLstResult(lngIndex)
    Case "8"
		lngIndex = OCRGRP_START4 + 111
	    If vntLstResult(lngIndex)<>"" Then
	        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "����"
	    End If
		lngIndex = OCRGRP_START4 + 112
	    If vntLstResult(lngIndex)<>"" Then
	        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "���o��"
	    End If
		lngIndex = OCRGRP_START4 + 113
	    If vntLstResult(lngIndex)<>"" Then
	        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "���̑�����"
	    End If

		lngIndex = OCRGRP_START_Z + 13
		    If vntLstResult(lngIndex)<>"" Then
		        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "����"
		    End If
		lngIndex = OCRGRP_START_Z + 14
		    If vntLstResult(lngIndex)<>"" Then
		        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "���o��"
		    End If
		lngIndex = OCRGRP_START_Z + 15
		    If vntLstResult(lngIndex)<>"" Then
		        strLstRsl = strLstRsl & IIf(strLstRsl="", "", ", ") & "���̑�"
		    End If

    End Select
    If strLstRsl = "" Then
       strLstRsl = "�@"
    Else
''### 2010.12.18 MOD STR TCS)H.F
'        strLstRsl =  "���K����" & strLstRsl
        strLstRsl =  "������" & strLstRsl
''### 2010.12.18 MOD END TCS)H.F
    End If
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
    strHTML = strHTML & "  </TR>" & vbLf

    strHTML = strHTML & "  </TABLE>"

'------------
    strHTML = strHTML & "</TD>" & vbLf

    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>

    </TABLE>
<%
    Else
        strHTML = ""
''### 2011.01.04 MOD STR TCS)H.F
''        For i = 1 To 54
        For i = 1 To 53
''### 2011.01.04 MOD END TCS)H.F
            strHTML = strHTML & EditErrInfo
        Next
        Response.Write strHTML
    End If
%>
<!-- 
******************************************************
    �H�K����f
******************************************************
 -->
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
        <TR HEIGHT="20">
            <TD NOWRAP WIDTH="20"></TD>
            <TD NOWRAP WIDTH="956" BGCOLOR="#98FB98"><SPAN ID="Anchor-Syokusyukan" STYLE="position:relative">�H�K����f�[</SPAN></TD>
        </TR>
        <TR HEIGHT="20">
<%
    strHTML = ""
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
lngIndex = OCRGRP_START5 + 0
    strHTML = strHTML & EditRsl(lngIndex, "checkbox", "chk5_1", , "1") & "<B>�{�l��]�ɂ�薢��</B></TD>" & vbLf
    Response.Write strHTML
%>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">�P�D�ێ�G�l���M�[�ɂ���</TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>�@�@�J�����[�������󂯂Ă��܂���</TD>
        </TR>
        <TR HEIGHT="20">
<%
    strHTML = ""
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP >�@" & vbLf
lngIndex = OCRGRP_START5 + 1
    strHTML = strHTML & "�@" & EditRsl(lngIndex, "radio", "opt5_1", , "1") & "�͂�" & vbLf
lngIndex = OCRGRP_START5 + 2
    strHTML = strHTML & "�@" & EditRsl(lngIndex, "text", "Rsl", 5, "") & "kcal" & vbLf
lngIndex = OCRGRP_START5 + 1
    strHTML = strHTML & "�@" & EditRsl(lngIndex, "radio", "opt5_1", , "2") & "������" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    Response.Write strHTML
%>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">�Q�D�H�K���ɓ��Ă͂܂����</TD>
        </TR>
        <TR>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
<%
    strHTML = ""
    For i=0 To 8
        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
        strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Next
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 3
    strHTML = strHTML & "<TD NOWRAP>1)�H���̑��x�͑����ق��ł���</TD>" & vbLf
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_1", , "1") & "�����ق��ł���</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""120"">" & EditRsl(lngIndex, "radio", "opt5_2_1", , "1") & "�����ق��ł���</TD>" & vbLf
''### 2010.12.18 MOD END TCS)H.F
''### 2010.12.18 MOD STR TCS)H.F
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_1", , "2") & "����قǂł��Ȃ�</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""130"">" & EditRsl(lngIndex, "radio", "opt5_2_1", , "2") & "����قǂł��Ȃ�</TD>" & vbLf
''### 2010.12.18 MOD END TCS)H.F
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 4
    strHTML = strHTML & "<TD NOWRAP>2)�����ɂȂ�܂ŐH�ׂ�ق��ł���</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_2", , "1") & "�����ł���</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_2", , "2") & "����قǂł��Ȃ�</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 5
    strHTML = strHTML & "<TD NOWRAP>3)�H���̋K������</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_3", , "1") & "�K��������</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_3", , "2") & "����قǂł��Ȃ�</TD>" & vbLf
lngIndex = OCRGRP_START5 + 6
    strHTML = strHTML & "<TD NOWRAP>�i�P�T�Ԃ̕��ό��H��" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "��j</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 7
    strHTML = strHTML & "<TD NOWRAP>4)�o�����X���l���ĐH�ׂĂ��܂���</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_4", , "1") & "�l���Ă���</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_4", , "2") & "����قǂł��Ȃ�</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 8
    strHTML = strHTML & "<TD NOWRAP>5)�Â����̂͂悭�H�ׂ܂���</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_5", , "1") & "�悭�H�ׂ�</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_5", , "2") & "����قǂł��Ȃ�</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 9
    strHTML = strHTML & "<TD NOWRAP>6)���b���̑����H���͍D��ŐH�ׂ܂���</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_6", , "1") & "�D��ŐH�ׂ�</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_6", , "2") & "����قǂł��Ȃ�</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 10
    strHTML = strHTML & "<TD NOWRAP>7)���t���͔Z���ق��ł���</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_7", , "1") & "�Z�����ł���</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_7", , "2") & "�ӂ�</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_7", , "3") & "�����ɂ��Ă���</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 11
    strHTML = strHTML & "<TD NOWRAP>8)�ԐH���Ƃ邱�Ƃ�����܂���</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_8", , "1") & "�H�ׂȂ�</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_8", , "2") & "�H�ׂ�</TD>" & vbLf
lngIndex = OCRGRP_START5 + 12
    strHTML = strHTML & "<TD NOWRAP>�i�P�T�Ԃ̕��ϊԐH��" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "��j</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 13
    strHTML = strHTML & "<TD NOWRAP>9)�����ݖ��͂��g���ł���</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_9", , "1") & "�g���Ă���</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt5_2_9", , "2") & "�g���Ă��Ȃ�</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
                </TABLE>
            </TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">�R�D�P���̚n�D�i�ێ��</TD>
        </TR>
        <TR>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
<%
    strHTML = ""
    For i=0 To 8
        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
        strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Next
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 14
    strHTML = strHTML & "<TD NOWRAP>�R�[�q�[�E�g��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�t</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP><IMG SRC=""../../images/spacer.gif"" WIDTH=""21"" HEIGHT=""21""></TD>" & vbLf
lngIndex = OCRGRP_START5 + 23
    strHTML = strHTML & "<TD NOWRAP>����</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "��</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 15
    strHTML = strHTML & "<TD NOWRAP>�@�����i�������j</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�t</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP><IMG SRC=""../../images/spacer.gif"" WIDTH=""21"" HEIGHT=""21""></TD>" & vbLf
lngIndex = OCRGRP_START5 + 24
    strHTML = strHTML & "<TD NOWRAP>�`���R���[�g</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "��</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 16
    strHTML = strHTML & "<TD NOWRAP>�@�~���N�i�������j</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�t</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP><IMG SRC=""../../images/spacer.gif"" WIDTH=""21"" HEIGHT=""21""></TD>" & vbLf
lngIndex = OCRGRP_START5 + 25
    strHTML = strHTML & "<TD NOWRAP>�X�i�b�N�َq</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�M</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 17
    strHTML = strHTML & "<TD NOWRAP>�W���[�X�i�X�|�[�c�������܂ށj</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "00ml</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP><IMG SRC=""../../images/spacer.gif"" WIDTH=""21"" HEIGHT=""21""></TD>" & vbLf
lngIndex = OCRGRP_START5 + 26
    strHTML = strHTML & "<TD NOWRAP>�i�b�c</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "�M�i�ЂƂ��݁j</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 18
    strHTML = strHTML & "<TD NOWRAP>�ʏ`�E��؃W���[�X</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "00ml</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP><IMG SRC=""../../images/spacer.gif"" WIDTH=""21"" HEIGHT=""21""></TD>" & vbLf
lngIndex = OCRGRP_START5 + 27
    strHTML = strHTML & "<TD NOWRAP>�a�َq�i�܂񂶂イ�Ȃǁj</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "��</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 19
    strHTML = strHTML & "<TD NOWRAP>�Y�_����</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "00ml</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP><IMG SRC=""../../images/spacer.gif"" WIDTH=""21"" HEIGHT=""21""></TD>" & vbLf
lngIndex = OCRGRP_START5 + 28
    strHTML = strHTML & "<TD NOWRAP>�m�َq�i�P�[�L�Ȃǁj</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "��</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 20
    strHTML = strHTML & "<TD NOWRAP>�A�C�X</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP><IMG SRC=""../../images/spacer.gif"" WIDTH=""21"" HEIGHT=""21""></TD>" & vbLf
lngIndex = OCRGRP_START5 + 29
    strHTML = strHTML & "<TD NOWRAP>�h�[�i�c</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "��</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 21
    strHTML = strHTML & "<TD NOWRAP>�V���[�x�b�g</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP><IMG SRC=""../../images/spacer.gif"" WIDTH=""21"" HEIGHT=""21""></TD>" & vbLf
lngIndex = OCRGRP_START5 + 30
    strHTML = strHTML & "<TD NOWRAP>�[���[</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "��</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 22
    strHTML = strHTML & "<TD NOWRAP>�N�b�L�[</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP><IMG SRC=""../../images/spacer.gif"" WIDTH=""21"" HEIGHT=""21""></TD>" & vbLf
lngIndex = OCRGRP_START5 + 31
    strHTML = strHTML & "<TD NOWRAP>����ׂ��i�����j</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "���i�ЂƂ��݁j</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
                </TABLE>
            </TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">�S�D�����i�̂P���ێ��</TD>
        </TR>
        <TR>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
<%
    strHTML = ""
    For i=0 To 1
        strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
        strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Next
    Response.Write strHTML
%>
                </TABLE>
            </TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 32
    strHTML = strHTML & "<TD NOWRAP>���ʋ���</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "00ml</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP><IMG SRC=""../../images/spacer.gif"" WIDTH=""21"" HEIGHT=""21""></TD>" & vbLf
lngIndex = OCRGRP_START5 + 34
    strHTML = strHTML & "<TD NOWRAP>�ᎉ�b����</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "00ml</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START5 + 33
    strHTML = strHTML & "<TD NOWRAP>���ʃ��[�O���g</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "00ml</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP><IMG SRC=""../../images/spacer.gif"" WIDTH=""21"" HEIGHT=""21""></TD>" & vbLf
lngIndex = OCRGRP_START5 + 35
    strHTML = strHTML & "<TD NOWRAP>�ᎉ�b���[�O���g</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "text", "Rsl", 2, "") & "00ml</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
    
<!-- 
******************************************************
    ���H
******************************************************
 -->
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
        <TR HEIGHT="20">
            <TD NOWRAP WIDTH="20"></TD>
            <TD NOWRAP WIDTH="956" BGCOLOR="#98FB98"><SPAN ID="Anchor-Morning" STYLE="position:relative">���H�ɂ���</SPAN></TD>
        </TR>
        <TR HEIGHT="20">	
            <TD NOWRAP></TD>
            <TD NOWRAP>�@�@�i�P�j�����H�ׂĂ��܂���</TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>�@�@" & vbLf
lngIndex = OCRGRP_START6 + 0
    strHTML = strHTML & "�@" & EditRsl(lngIndex, "radio", "opt6_1", , "1") & "�H�ׂ�" & vbLf
    strHTML = strHTML & "�@" & EditRsl(lngIndex, "radio", "opt6_1", , "2") & "���X�H�ׂ�" & vbLf
    strHTML = strHTML & "�@" & EditRsl(lngIndex, "radio", "opt6_1", , "3") & "�H�ׂȂ�" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML

    '�����̕ҏW
    Call EditMenuList( OCRGRP_START6 )
%>
    </TABLE>

<!-- 
******************************************************
    ���H
******************************************************
 -->
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
        <TR HEIGHT="20">
            <TD NOWRAP WIDTH="20"></TD>
            <TD NOWRAP WIDTH="956" BGCOLOR="#98FB98"><SPAN ID="Anchor-Lunch" STYLE="position:relative">���H�ɂ���</SPAN></TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP>�@�@�i�P�j�����H�ׂĂ��܂���</TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""950"">�@�@" & vbLf
lngIndex = OCRGRP_START7 + 0
    strHTML = strHTML & "�@" & EditRsl(lngIndex, "radio", "opt7_1", , "1") & "�H�ׂ�" & vbLf
    strHTML = strHTML & "�@" & EditRsl(lngIndex, "radio", "opt7_1", , "2") & "���X�H�ׂ�" & vbLf
    strHTML = strHTML & "�@" & EditRsl(lngIndex, "radio", "opt7_1", , "3") & "�H�ׂȂ�" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML

    '�����̕ҏW
    Call EditMenuList( OCRGRP_START7 )
%>
    </TABLE>

<!-- 
******************************************************
    �[�H
******************************************************
 -->
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
        <TR HEIGHT="20">
            <TD NOWRAP WIDTH="20"></TD>
            <TD NOWRAP WIDTH="956" BGCOLOR="#98FB98"><SPAN ID="Anchor-Dinner" STYLE="position:relative">�[�H�ɂ���</SPAN></TD>
        </TR>
        <TR HEIGHT="20">	
            <TD NOWRAP></TD>
            <TD NOWRAP>�@�@�i�P�j�����H�ׂĂ��܂���</TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP WIDTH=""950"">�@�@" & vbLf
lngIndex = OCRGRP_START8 + 0
    strHTML = strHTML & "�@" & EditRsl(lngIndex, "radio", "opt8_1", , "1") & "�H�ׂ�" & vbLf
    strHTML = strHTML & "�@" & EditRsl(lngIndex, "radio", "opt8_1", , "2") & "���X�H�ׂ�" & vbLf
    strHTML = strHTML & "�@" & EditRsl(lngIndex, "radio", "opt8_1", , "3") & "�H�ׂȂ�" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML

    '�����̕ҏW
    Call EditMenuList( OCRGRP_START8 )
%>
    </TABLE>


<!-- 
******************************************************
    ���茒�f
******************************************************
 -->
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
        <TR HEIGHT="20">
            <TD NOWRAP WIDTH="20"></TD>
            <TD NOWRAP WIDTH="956" BGCOLOR="#98FB98"><SPAN ID="Anchor-Special" STYLE="position:relative">���茒�f��f�[</SPAN></TD>
        </TR>
        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">�^����H�������̐����K�������P���Ă݂悤�Ǝv���܂���</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START9 + 0
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt9_1", , "1") & "�@���P�������͂Ȃ�<br>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt9_1", , "2") & "�A���P�������ł���i�T��6�����ȓ��j<br>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt9_1", , "3") & "�B�߂������Ɂi�T��1�����ȓ��j���P�������ł���A�������͂��߂Ă���<br>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt9_1", , "4") & "�C���ɉ��P�Ɏ��g��ł���i6���������j<br>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt9_1", , "5") & "�D���ɉ��P�Ɏ��g��ł���i6�����ȏ�j<br>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt9_1", , "6") & "����" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�@���P�������͂Ȃ�"
    Case "2"
        strLstRsl = "�A���P�������ł���i�T��6�����ȓ��j"
    Case "3"
        strLstRsl = "�B�߂������Ɂi�T��1�����ȓ��j���P�������ł���A�������͂��߂Ă���"
    Case "4"
        strLstRsl = "�C���ɉ��P�Ɏ��g��ł���i6���������j"
    Case "5"
        strLstRsl = "�D���ɉ��P�Ɏ��g��ł���i6�����ȏ�j"
    Case "6"
        strLstRsl = "����"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>

        <TR HEIGHT="20">
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">�����K���̉��P�ɂ��ĕی��w�����󂯂�@�����΁A���p���܂���</TD>
            <TD NOWRAP BGCOLOR="#eeeeee"></TD>
        </TR>
<%
    strHTML = ""
    strHTML = strHTML & "<TR HEIGHT=""28"">" & vbLf
lngIndex = OCRGRP_START9 + 1
    strHTML = strHTML & "<TD NOWRAP WIDTH=""20"">" & EditErrInfo & "</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt9_2", , "1") & "�@�͂�" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt9_2", , "2") & "�A������" & vbLf
    strHTML = strHTML & EditRsl(lngIndex, "radio", "opt9_2", , "3") & "����" & vbLf
    strHTML = strHTML & "</TD>" & vbLf
'---�O��l---
    strLstRsl = ""
    Select Case vntLstResult(lngIndex)
    Case "1"
        strLstRsl = "�@���P�������͂Ȃ�"
    Case "2"
        strLstRsl = "�A���P�������ł���i�T��6�����ȓ��j"
    Case "3"
        strLstRsl = "����"
    End Select
    strHTML = strHTML & "<TD NOWRAP>" & strLstRsl & "</TD>" & vbLf
'------------
    strHTML = strHTML & "</TR>" & vbLf
    Response.Write strHTML
%>
    
    </TABLE>

<!-- 
******************************************************
    OCR���͒S����
******************************************************
 -->
    <BR><BR>
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
        <TR HEIGHT="20">
            <TD NOWRAP WIDTH="20"></TD>
            <TD NOWRAP><SPAN ID="Anchor-Operator" STYLE="position:relative">OCR���͒S����</SPAN></TD>
<%
lngIndex = OCRGRP_START10 + 0

    '���ݒ�̏ꍇ�̓��O�C�����[�U���f�t�H���g�Ƃ���
    If vntResult(lngIndex) = "" Then
        Set objHainsUser = Server.CreateObject("HainsHainsUser.HainsUser")
        objHainsUser.SelectHainsUser Session("USERID"), strOpeNameStc, _
                                     , , , , , , , , , , _
                                     , , , , , , , , , , _
                                     , , , , , , strOpeNameStcCd
        Set objHainsUser = Nothing

        vntResult(lngIndex) = strOpeNameStcCd
    End If

    If vntResult(lngIndex) <> "" Then
        'OCR���͒S���҂̖��̎擾
        Set objSentence = Server.CreateObject("HainsSentence.Sentence")
        objSentence.SelectSentence vntItemCd(lngIndex), 0, vntResult(lngIndex), strOpeNameStc, _
                                    , , , , , , , , , 1, "00"

        Set objSentence = Nothing
    Else
        strOpeNameStc = "���ݒ�Ȃ�"
    End If
%>
            <TD><A HREF="javascript:showUserWindow(<%= lngIndex %>, '30960')"><IMG SRC="../../images/question.gif" ALT="" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
            <TD><A HREF="javascript:clrUser(<%= lngIndex %>)"><IMG SRC="../../images/delicon.gif" ALT="" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
            <TD NOWRAP><IMG SRC="../../images/spacer.gif" WIDTH="5" HEIGHT="1"></TD>
            <TD NOWRAP><SPAN ID="OpeName"><%= strOpeNameStc %></SPAN></TD>
        </TR>
    </TABLE>

<%
    '�ۑ��p
    strHtml = ""
    For i=0 To lngRslCnt-1
        strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""ItemCd"" VALUE=""" & vntItemCd(i) & """>"
        strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""Suffix"" VALUE=""" & vntSuffix(i) & """>"
        strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""OrgRsl"" VALUE=""" & vntResult(i) & """>"
        strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""ChgRsl"" VALUE=""" & vntResult(i) & """>"
        strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""StopFlg"" VALUE=""" & vntStopFlg(i) & """>"
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� ADD STR
        strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""PreRsl"" VALUE=""" & vntLstResult(i) & """>"
' SL-UI-Y0101-607 �O�񕡎ʃ{�^���ǉ� ADD END
    Next
    Response.Write(strHtml)
%>
</FORM>
</BODY>
</HTML>
<%
'-----�\����������----- 
%>
<SCRIPT TYPE="text/javascript">
<!--
    var myForm =    document.entryForm;
    var ElementId;
    var strHtml;
    var i;

    // �G���[���̕\��
    if( !isNaN(parent.lngErrCount) ) {
        for( i=0; i<parent.lngErrCount; i++ ) {
            if( parent.varErrNo[i] > 0 ) {

                switch ( parent.varErrState[i] ) {
                case 1:     // �G���[
                    strHtml = '<IMG SRC="../../images/ico_e.gif" WIDTH="16" HEIGHT="16" ALT="' + parent.varErrMessage[i] + '" BORDER="0">';
                    break;
                case 2:     // �x��
                    strHtml = '<IMG SRC="../../images/ico_w.gif" WIDTH="16" HEIGHT="16" ALT="' + parent.varErrMessage[i] + '" BORDER="0">';
                    break;
                default:
                    strHtml = '&nbsp;';
                }

                // �}�[�N��\��
                ElementId = "Anchor-ErrInfo" + parent.varErrNo[i];
                if( document.all ) {
                    document.all(ElementId).innerHTML = strHtml;
                }else if( document.getElementById ) {
                    document.getElementById(ElementId).innerHTML = strHtml;
                }
            }
        }
    }

    // ���̃t���[���̃G���[���X�g�\��
    if( document.entryForm.act.value != '' ) {
        parent.error.document.entryForm.selectState.selectedIndex = 2;
        parent.error.chgSelect();
    }

    // ���������b�Z�[�W�̏���
    if( document.getElementById ) {
        document.getElementById('LoadindMessage').innerHTML = '';
    }

    
    // �\���J�n�ʒu�ɃW�����v
    JumpAnchor();

    if( document.entryForm.act.value == 'check' && <%= lngErrCnt_E %> == 0 && <%= lngErrCnt_W %> > 0 ) {

        if( confirm('�x��������܂����A���̂܂ܕۑ����܂����H') ) {
            // ���[�h���w�肵��submit
            document.entryForm.act.value = 'save';
            document.entryForm.submit();
        }
    }
//-->
</SCRIPT>
