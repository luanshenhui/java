<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'      web�c�̗\����o�^(��{���) (Ver1.0.0)
'      AUTHER  : 
'-----------------------------------------------------------------------------
'�Ǘ��ԍ��FSL-UI-Y0101-108
'�C����  �F2010.08.06�i�C���j
'�S����  �FTCS)����
'�C�����e�Fweb�c�̗\����L�����Z���̎捞���\�Ƃ���B
'-------------------------
'�Ǘ��ԍ��FSL-SN-Y0101-612
'�C�����@�F2013.3.11
'�S����  �FT.Takagi@RD
'�C�����e�Fweb�\���f�I�v�V�����̎擾���@�ύX

Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/editCourseList.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/recentConsult.inc"  -->
<!-- #include virtual = "/webHains/includes/webRsv.inc"         -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const MODE_CANCEL        = "cancel"         '�������[�h(�\��L�����Z��)
Const CANCEL_FIX         = 1                '�L�����Z�����R�Œ�i�b��F�@���s���j

Const FREECD_CANCEL      = "CANCEL"         '�ėp�R�[�h(�L�����Z�����R)
Const FREECD_RSVINTERVAL = "RSVINTERVAL"    '�ėp�R�[�h(�͂������瑗�t�ē��ւ̐؂�ւ����s������)

Const PRTONSAVE_INDEXNONE = 0       '�ۑ������(�Ȃ�)
Const PRTONSAVE_INDEXCARD = 1       '�ۑ������(�͂���)
Const PRTONSAVE_INDEXFORM = 2       '�ۑ������(���t�ē�)

Const IGNORE_EXCEPT_NO_RSVFRA = "1" '�\��g��������(�g�Ȃ��̓��t�����������\�񂪉\)
Const IGNORE_ANY              = "2" '�\��g��������(�����鋭���\�񂪉\)

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon           '���ʃN���X

'�����l(web�\����̎�L�[)
Dim dtmCslDate          '��f�N����
Dim lngWebNo            'webNo.
Dim lngCRsvNo           'web�\��o�^���}�b�`���O���ꂽHains�\����̗\��ԍ��i�L�����Z���Ώہj

'�����l(�����p)
Dim blnSave             '�ۑ��̗v��
Dim blnNext             '���\����\���̗v��
Dim lngIgnoreFlg        '�����o�^�t���O
Dim blnSaved            '�ۑ������t���O

'�����l(���\���񌟍��p)
Dim dtmStrCslDate       '�J�n��f�N����
Dim dtmEndCslDate       '�I����f�N����
Dim strKey              '�����L�[
Dim dtmStrOpDate        '�J�n�����N����
Dim dtmEndOpDate        '�I�������N����
Dim lngOpMode           '�������[�h(1:�\�����Ō����A2:�\�񏈗����Ō���)
Dim lngRegFlg           '�{�o�^�t���O(0:�w��Ȃ��A1:���o�^�ҁA2:�ҏW�ςݎ�f��)
Dim lngOrder            '�o�͏�(1:��f�����A2:�lID��)
'#### 2010.10.28 SL-UI-Y0101-108 ADD START ####'
Dim lngMosFlg		'�\���敪(0:�w��Ȃ��A1:�V�K�A2:�L�����Z��)
'#### 2010.10.28 SL-UI-Y0101-108 ADD END ####'

'�����l(web�\����A��f��񋤒�)
Dim strCsCd             '�R�[�X�R�[�h
Dim strRsvGrpCd         '�\��Q�R�[�h
Dim strPerId            '�lID
Dim strLastName         '��
Dim strFirstName        '��
Dim strLastKName        '�J�i��
Dim strFirstKName       '�J�i��
Dim strGender           '����
Dim strBirth            '���N����

'�����l(web�\����)
Dim strOptionStomac     '�݌���(0:�݂Ȃ��A1:��X���A2:�ݓ�����)
Dim strOptionBreast     '���[����(0:���[�Ȃ��A1:���[X���A2:���[�����g�A3:���[X���{���[�����g)
'#### 2013.3.11 SL-SN-Y0101-612 ADD START ####
Dim strCslOptions		'��f�I�v�V����
'#### 2013.3.11 SL-SN-Y0101-612 ADD END   ####

'�����l(��f���)
Dim strOrgCd1           '�c�̃R�[�h1
Dim strOrgCd2           '�c�̃R�[�h2
Dim strOrgName          '�c�̖���
Dim strAge              '��f���N��
Dim strCslDivCd         '��f�敪�R�[�h
Dim strCtrPtCd          '�_��p�^�[���R�[�h

'�����l(�l���)
Dim strRomeName         '���[�}����
Dim strZipCd            '�X�֔ԍ�
Dim strPrefCd           '�s���{���R�[�h
Dim strPrefName         '�s���{����
Dim strCityName         '�s�撬����
Dim strAddress1         '�Z���P
Dim strAddress2         '�Z���Q
Dim strTel1             '�d�b�ԍ�1
Dim strPhone            '�g�єԍ�
Dim strTel2             '�d�b�ԍ�2
Dim strExtension        '����
Dim strFax              'FAX
Dim strEMail            'e-Mail
Dim strNationCd         '���ЃR�[�h
Dim strNationName       '���Ж�

'�����l(��f�t�����)
Dim strRsvStatus        '�\���
Dim strPrtOnSave        '�ۑ������
Dim strCardAddrDiv      '�m�F�͂�������
Dim strCardOutEng       '�m�F�͂����p���o��
Dim strFormAddrDiv      '�ꎮ��������
Dim strFormOutEng       '�ꎮ�����p���o��
Dim strReportAddrDiv    '���я�����
Dim strReportOutEng     '���я��p���o��
Dim strVolunteer        '�{�����e�B�A
Dim strVolunteerName    '�{�����e�B�A��
Dim strCollectTicket    '���p�����
Dim strIssueCslTicket   '�f�@�����s
Dim strBillPrint        '�������o��
Dim strIsrSign          '�ی��؋L��
Dim strIsrNo            '�ی��ؔԍ�
Dim strIsrManNo         '�ی��Ҕԍ�
Dim strEmpNo            '�Ј��ԍ�
Dim strIntroductor      '�Љ��
Dim strLastCslDate      '�O���f��

'�����l(�I�v�V����)
Dim strOptCd            '�I�v�V�����R�[�h
Dim strOptBranchNo      '�I�v�V�����}��

'web�\����(�����\�����݂̂����g�p���Ȃ�����)
Dim strRegFlg           '�{�o�^�t���O(1:���o�^�ҁA2:�ҏW�ςݎ�f��)
Dim strRsvNo            '�\��ԍ�

'��f���(�����\�����݂̂����g�p���Ȃ�����)
Dim strCancelFlg        '�L�����Z���t���O
Dim strCslDate          '��f�N����
Dim strCardPrintDate    '�m�F�͂����o�͓���
Dim strFormPrintDate    '�ꎮ�����o�͓���

'web�\��Z�����(�V�K�\�����ݎ҂̃f�t�H���g�l�ƂȂ�)
Dim strDefZipNo         '�X�֔ԍ�
Dim strDefAddress1      '�Z��1
Dim strDefAddress2      '�Z��2
Dim strDefAddress3      '�Z��3
Dim strDefTel           '�d�b�ԍ�
Dim strDefEMail         'e-mail
Dim strDefOfficeTel     '�Ζ���d�b�ԍ�

Dim dtmNextCslDate      '��web�\����̎�f�N����
Dim lngNextWebNo        '��web�\�����webNo.
Dim strMessage          '���b�Z�[�W
Dim strMessage2         '���b�Z�[�W2
Dim Ret                 '�֐��߂�l
Dim i                   '�C���f�b�N�X

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾(web�\����̎�L�[)
dtmCslDate      = CDate(Request("cslDate"))
lngWebNo        = CLng("0" & Request("webNo"))
lngCRsvNo       = CLng("0" & Request("cRsvNo"))

'�����l�̎擾(�����p)
blnSave         = (Request("save")  <> "")
blnNext         = (Request("next")  <> "")
lngIgnoreFlg    = CLng("0" & Request("ignore"))
blnSaved        = (Request("saved") <> "")

'�����l�̎擾(���\���񌟍��p)
dtmStrCslDate   = Request("strCslDate")
dtmEndCslDate   = Request("endCslDate")
strKey          = Request("key")
dtmStrOpDate    = CDate("0" & Request("strOpDate"))
dtmEndOpDate    = CDate("0" & Request("endOpDate"))
lngOpMode       = CLng("0" & Request("opMode"))
lngRegFlg       = CLng("0" & Request("regFlg"))
lngOrder        = CLng("0" & Request("order"))
'#### 2010.10.28 SL-UI-Y0101-108 ADD START ####'
'�\���敪�̓��͂��Ȃ����1:�V�K���f�t�H���g��
lngMosFlg      = IIf(Request("mousi") = "", 1, CLng("0" & Request("mousi")))
'#### 2010.10.28 SL-UI-Y0101-108 ADD END ####'

'�����l(web�\����A��f��񋤒�)
strCsCd         = Request("csCd")
strRsvGrpCd     = Request("rsvGrpCd")
strPerId        = Request("perId")
strLastName     = Request("lastName")
strFirstName    = Request("firstName")
strLastKName    = Request("lastKName")
strFirstKName   = Request("firstKName")
strGender       = Request("gender")
strBirth        = Request("birth")

'�����l�̎擾(web�\����)
strOptionStomac = Request("stomac")
strOptionBreast = Request("breast")
'#### 2013.3.11 SL-SN-Y0101-612 ADD START ####
strCslOptions = Request("csloptions")
'#### 2013.3.11 SL-SN-Y0101-612 ADD END   ####

'�����l�̎擾(��f���)
strOrgCd1       = Request("orgCd1")
strOrgCd2       = Request("orgCd2")
strOrgName      = Request("orgName")
strAge          = Request("age")
strCslDivCd     = Request("cslDivCd")
strCtrPtCd      = Request("ctrPtCd")

'�����l(�l���)
strRomeName     = Request("romeName")
strZipCd        = ConvIStringToArray(Request("zipCd"))
strPrefCd       = ConvIStringToArray(Request("prefCd"))
strPrefName     = ConvIStringToArray(Request("prefName"))
strCityName     = ConvIStringToArray(Request("cityName"))
strAddress1     = ConvIStringToArray(Request("address1"))
strAddress2     = ConvIStringToArray(Request("address2"))
strTel1         = ConvIStringToArray(Request("tel1"))
strPhone        = ConvIStringToArray(Request("phone"))
strTel2         = ConvIStringToArray(Request("tel2"))
strExtension    = ConvIStringToArray(Request("extension"))
strFax          = ConvIStringToArray(Request("fax"))
strEMail        = ConvIStringToArray(Request("eMail"))
strNationCd     = Request("nationCd")
strNationName   = Request("nationName")

'�����l�̎擾(��f�t�����)
strRsvStatus      = Request("rsvStatus")
strPrtOnSave      = Request("prtOnSave")
strCardAddrDiv    = Request("cardAddrDiv")
strCardOutEng     = Request("cardOutEng")
strFormAddrDiv    = Request("formAddrDiv")
strFormOutEng     = Request("formOutEng")
strReportAddrDiv  = Request("reportAddrDiv")
strReportOutEng   = Request("reportOutEng")
strVolunteer      = Request("volunteer")
strVolunteerName  = Request("volunteerName")
strCollectTicket  = Request("collectTicket")
strIssueCslTicket = Request("issueCslTicket")
strBillPrint      = Request("billPrint")
strIsrSign        = Request("isrSign")
strIsrNo          = Request("isrNo")
strIsrManNo       = Request("isrManNo")
strEmpNo          = Request("empNo")
strIntroductor    = Request("introductor")
strLastCslDate    = Request("lastCslDate")

'�����l�̎擾(�I�v�V����)
strOptCd        = Request("optCd")
strOptBranchNo  = Request("optBNo")

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do

    '���炩�̏������s���ꍇ
     If blnSave Or blnNext Then

        '�ҏW�p�̎�f���̓L�[�l�̂���Ƃ���
        strCslDate = CStr(dtmCslDate)

        '��web�\����̃L�[�擾
        If blnNext Then
            SelectWebOrgRsvNext dtmCslDate, lngWebNo, dtmNextCslDate, lngNextWebNo
        Else
            dtmNextCslDate = dtmCslDate
            lngNextWebNo   = lngWebNo
        End If

        '�ۑ����s���ꍇ
        If blnSave Then

            '�߂���f���Ō��f��������ꍇ�̃��[�j���O�Ή�
            If strPerId <> "" And lngIgnoreFlg = 0 Then
                strMessage = RecentConsult_CheckRecentConsult(strPerId, dtmCslDate, strCsCd, "")
                If strMessage <> "" Then
                    Exit Do
                End If
            End If

            '�L�����Z���Ώۗ\���񑶍ݗL�����`�F�b�N���A�L�����Z���������s
            Ret = Cancel()

            'web�\����̓o�^
            Ret = Regist()
            If Ret <= 0 Then
                'web�\����o�^���A�G���[���������Đ���ɓo�^����Ȃ������ꍇ�A
                '�L�����Z�������g��蕪�̗\����𕜊�����
                Ret = Restore()
                Exit Do
            End If

        End If

        '�y�[�W�J��
        Response.Write CreateHTMLForControlAfterSaved(Ret, dtmNextCslDate, lngNextWebNo)
        Response.End

    End If

    'web�\����ǂݍ���
    SelectWebOrgRsv dtmCslDate, lngWebNo

    '���o�^�ҁA�܂��͕ҏW�ςݎ�f�҂ŗ\��ԍ��������Ȃ��ꍇ
    If strRegFlg = REGFLG_UNREGIST Or (strRegFlg = REGFLG_REGIST And strRsvNo = "") Then

        '�ҏW�p�̎�f���̓L�[�l�̂���Ƃ���
        strCslDate = CStr(dtmCslDate)

        '��f�t�����̃f�t�H���g�l�ҏW
        SetDefaultPersonalInfo dtmCslDate, strPerId

    '�ҏW�ς݂ł��\��ԍ������ꍇ
    Else

        '��f���ǂݍ���
        SelectConsult CLng(strRsvNo)

    End If

    '�l�Z�����i�[��̏�����
    InitializePerAddr

    If strPerId = "" Then

        '�lID�����݂��Ȃ��ꍇ��web�\����̏Z�����l�Z�����̃f�t�H���g�l�Ƃ��ēK�p����
        SetDefaultPerAddr

    Else

        '�lID���ݎ��́A�l���̕s����(���[�}����)�ƏZ�����Ƃ�ǂ�
        SelectPerson strPerId

    End If

    Exit Do
Loop

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : web�\����Ɏw�肳��Ă���Hains�\����L�����Z��
'
' �����@�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function Cancel()

    Dim objConsult          '��f���A�N�Z�X�p
    Dim objWebOrgRsv        'web�\����A�N�Z�X�p
    Dim Ret                 '�֐��߂�l
    Dim RetBl               '�֐��߂�l

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objConsult = Server.CreateObject("HainsConsult.Consult")
    Set objWebOrgRsv = Server.CreateObject("HainsWebOrgRsv.WebOrgRsv")

    'web�\����ҏW���A�L�����Z���Ώێҗ\����L���`�F�b�N
    RetBl = objWebOrgRsv.SelectConsultCheck(lngCRsvNo, strOrgCd1, strOrgCd2)

    if RetBl = True Then
        'web�\�񎞐ݒ肳�ꂽ�\����L�����Z��
        '�L�����Z�����R(�Œ�j�F�@���s��(�Վ��j�A��f���ʂ��o�^���ꂽ�ꍇ�A�L�����Z�����������Ȃ�
        Ret = objConsult.CancelConsult(lngCRsvNo, Session("USERID"), CANCEL_FIX, strMessage, False)
    Else
        Ret = 0
    End If

    '�߂�l�̕ҏW
    Cancel = Ret

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �L�����Z�������g���\����𕜌�����
'
' �����@�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function Restore()

    Dim objConsult          '��f���A�N�Z�X�p
    Dim objWebOrgRsv        'web�\����A�N�Z�X�p
    Dim Ret                 '�֐��߂�l

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objConsult = Server.CreateObject("HainsConsult.Consult")

    '���������i�\��g�𖳎������������j
    Ret = objConsult.RestoreConsult(lngCRsvNo, Session("USERID"), strMessage2, 2)
    If Ret <= 0 Then
'        strArrMessage = Array(strMessage2)
    End If

    '�߂�l�̕ҏW
    Restore = Ret

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : web�\����̓o�^
'
' �����@�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function Regist()

    Dim objWebOrgRsv        'web�\����A�N�Z�X�p
    Dim strAddrDiv          '�Z���敪
    Dim strWkOptCd          '�I�v�V�����R�[�h
    Dim strWkOptBranchNo    '�I�v�V�����}��
    Dim Ret                 '�֐��߂�l

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objWebOrgRsv = Server.CreateObject("HainsWebOrgRsv.WebOrgRsv")

    '�Z���敪�̔z����쐬
    strAddrDiv = Array("1", "2", "3")

    '�I�v�V�����̔z��
    strWkOptCd       = Split(strOptCd,       ",")
    strWkOptBranchNo = Split(strOptBranchNo, ",")

    Ret = objWebOrgRsv.Regist(      _
              dtmCslDate,        _
              lngWebNo,          _
              Session("USERID"), _
              strCsCd,           _
              strRsvGrpCd,       _
              strPerId,          _
              strLastName,       _
              strFirstName,      _
              strLastKName,      _
              strFirstKName,     _
              strGender,         _
              strBirth,          _
              strOrgCd1,         _
              strOrgCd2,         _
              strAge,            _
              strCslDivCd,       _
              strCtrPtCd,        _
              strRomeName,       _
              strNationCd,       _
              strAddrDiv,        _
              strZipCd,          _
              strPrefCd,         _
              strCityName,       _
              strAddress1,       _
              strAddress2,       _
              strTel1,           _
              strPhone,          _
              strEMail,          _
              strRsvStatus,      _
              strPrtOnSave,      _
              strCardAddrDiv,    _
              strCardOutEng,     _
              strFormAddrDiv,    _
              strFormOutEng,     _
              strReportAddrDiv,  _
              strReportOutEng,   _
              strVolunteer,      _
              strVolunteerName,  _
              strCollectTicket,  _
              strIssueCslTicket, _
              strBillPrint,      _
              strIsrSign,        _
              strIsrNo,          _
              strIsrManNo,       _
              strEmpNo,          _
              strIntroductor,    _
              strWkOptCd,        _
              strWkOptBranchNo,  _
              lngIgnoreFlg,      _
              strMessage         _
          )

    '�߂�l�̕ҏW
    Regist = Ret

End Function
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : web�\����ǂݍ���
'
' �����@�@ : (In)     dtmParaCslDate  ��f�N����
' �@�@�@�@   (In)     lngParaWebNo    webNo.
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub SelectWebOrgRsv(dtmParaCslDate, lngParaWebNo)

    Dim objWebOrgRsv    'web�\����A�N�Z�X�p
    Dim strFullName     '����
    Dim strKanaName     '�J�i����

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objWebOrgRsv = Server.CreateObject("HainsWebOrgRsv.WebOrgRsv")

    'web�\����ǂݍ���
'#### 2013.3.11 SL-SN-Y0101-612 UPD START ####
'	'#### 2010.08.06 SL-UI-Y0101-108 MOD START ####
'	'��CanDate�̑Ή��ŁARsvNo�̑O�ɃJ���}�P�ǉ�
'	'objWebOrgRsv.SelectWebOrgRsv dtmParaCslDate,  _
'	'                             lngParaWebNo,    _
'	'                             strRegFlg,       _
'	'                             strCsCd,         _
'	'                             strRsvGrpCd,     _
'	'                             strPerId,        _
'	'                             strFullName,     _
'	'                             strKanaName,     _
'	'                             strRomeName,     _
'	'                             strLastName,     _
'	'                             strFirstName,    _
'	'                             strLastKName,    _
'	'                             strFirstKName,   _
'	'                             strGender,       _
'	'                             strBirth,        _
'	'                             strDefZipNo,     _
'	'                             strDefAddress1,  _
'	'                             strDefAddress2,  _
'	'                             strDefAddress3,  _
'	'                             strDefTel,       _
'	'                             strDefEMail,     _
'	'                             ,                _
'	'                             strDefOfficeTel, _
'	'                             strOrgCd1,       _
'	'                             strOrgCd2,       _
'	'                             strOrgName, ,    _
'	'                             strOptionStomac, _
'	'                             strOptionBreast, _
'	'                             , , ,            _
'	'                             strRsvNo,        _
'	'                             strIsrSign,      _
'	'                             strIsrNo,        _
'	'                             strVolunteer,    _
'	'                             strCardOutEng,   _
'	'                             strFormOutEng,   _
'	'                             strReportOutEng, _
'	'                             lngCRsvNo, _
'	'                             strNationName
'	objWebOrgRsv.SelectWebOrgRsv dtmParaCslDate,  _
'	                             lngParaWebNo,    _
'	                             strRegFlg,       _
'	                             strCsCd,         _
'	                             strRsvGrpCd,     _
'	                             strPerId,        _
'	                             strFullName,     _
'	                             strKanaName,     _
'	                             strRomeName,     _
'	                             strLastName,     _
'	                             strFirstName,    _
'	                             strLastKName,    _
'	                             strFirstKName,   _
'	                             strGender,       _
'	                             strBirth,        _
'	                             strDefZipNo,     _
'	                             strDefAddress1,  _
'	                             strDefAddress2,  _
'	                             strDefAddress3,  _
'	                             strDefTel,       _
'	                             strDefEMail,     _
'	                             ,                _
'	                             strDefOfficeTel, _
'	                             strOrgCd1,       _
'	                             strOrgCd2,       _
'	                             strOrgName, ,    _
'	                             strOptionStomac, _
'	                             strOptionBreast, _
'	                             , , , ,          _
'	                             strRsvNo,        _
'	                             strIsrSign,      _
'	                             strIsrNo,        _
'	                             strVolunteer,    _
'	                             strCardOutEng,   _
'	                             strFormOutEng,   _
'	                             strReportOutEng, _
'	                             lngCRsvNo, _
'	                             strNationName
'	'#### 2010.08.06 SL-UI-Y0101-108 MOD END ####
    objWebOrgRsv.SelectWebOrgRsv dtmParaCslDate,  _
                                 lngParaWebNo,    _
                                 strRegFlg,       _
                                 strCsCd,         _
                                 strRsvGrpCd,     _
                                 strPerId,        _
                                 strFullName,     _
                                 strKanaName,     _
                                 strRomeName,     _
                                 strLastName,     _
                                 strFirstName,    _
                                 strLastKName,    _
                                 strFirstKName,   _
                                 strGender,       _
                                 strBirth,        _
                                 strDefZipNo,     _
                                 strDefAddress1,  _
                                 strDefAddress2,  _
                                 strDefAddress3,  _
                                 strDefTel,       _
                                 strDefEMail,     _
                                 ,                _
                                 strDefOfficeTel, _
                                 strOrgCd1,       _
                                 strOrgCd2,       _
                                 strOrgName, ,    _
                                 strOptionStomac, _
                                 strOptionBreast, _
                                 , , , ,          _
                                 strRsvNo,        _
                                 strIsrSign,      _
                                 strIsrNo,        _
                                 strVolunteer,    _
                                 strCardOutEng,   _
                                 strFormOutEng,   _
                                 strReportOutEng, _
                                 lngCRsvNo,       _
                                 strNationName,   _
                                 strCslOptions
'#### 2013.3.11 SL-SN-Y0101-612 UPD END   ####

    '�lID�����݂���ꍇ
    If strPerId <> "" Then

        If strLastName = "" And strFirstName = "" Then
            SplitName strFullName, strLastName,  strFirstName
        End If

        If strLastKName = "" And strFirstKName = "" Then
            SplitName strKanaName, strLastKName, strFirstKName
        End If

    '�lID�����݂��Ȃ��ꍇ
    Else

        SplitName strFullName, strLastName,  strFirstName
        SplitName strKanaName, strLastKName, strFirstKName

    End If

End Sub
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ��������
'
' �����@�@ : (In)     strParaName      ����
' �@�@�@�@   (Out)    strParaLastName  ��
' �@�@�@�@   (Out)    strParaLastName  ��
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub SplitName(strParaName, strParaLastName, strParaFirstName)

    Dim lngPos  '�󔒌����ʒu

    strParaLastName  = ""
    strParaFirstName = ""

    '�ŏ��̋󔒂�����
    lngPos = InStr(1, strParaName, "�@")

    '����Ε����A�Ȃ���ΐ��ɃZ�b�g
    If lngPos > 0 Then
        strParaLastName  = Trim(Left(strParaName, lngPos))
        strParaFirstName = Trim(Right(strParaName, Len(strParaName) - lngPos))
    Else
        strParaLastName = strParaName
    End If

End Sub
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ��f���ǂݍ���
'
' �����@�@ : (In)     lngParaRsvNo  �\��ԍ�
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub SelectConsult(lngParaRsvNo)

    Dim objConsult          '��f���A�N�Z�X�p
    Dim strWkOptCd          '�I�v�V�����R�[�h
    Dim strWkOptBranchNo    '�I�v�V�����}��

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objConsult = Server.CreateObject("HainsConsult.Consult")

    '��f���ǂݍ���
    objConsult.SelectConsult lngParaRsvNo, strCancelFlg, strCslDate, strPerId, strCsCd, , strOrgCd1, strOrgCd2, strOrgName, , , strAge, , , , , , , , , , , , , , , , , , , , , , , , , , , , , _
                             strCtrPtCd, , strLastName, strFirstName, strLastKName, strFirstKName, strBirth, strGender, , , , , strCslDivCd, strRsvGrpCd


    '��f�t�����ǂݍ���
    objConsult.SelectConsultDetail lngParaRsvNo,      strRsvStatus,     strPrtOnSave,   _
                                   strCardAddrDiv,    strCardOutEng,    strFormAddrDiv, _
                                   strFormOutEng,     strReportAddrDiv, strReportOutEng, _
                                   strVolunteer,      strVolunteerName, strCollectTicket, _
                                   strIssueCslTicket, strBillPrint,     strIsrSign, _
                                   strIsrNo,          strIsrManNo,      strEmpNo, _
                                   strIntroductor, ,  strLastCslDate

    '������̓ǂݍ���
    objConsult.SelectConsultPrintStatus lngParaRsvNo, strCardPrintDate, strFormPrintDate

    '��f�I�v�V�����̓ǂݍ���
    objConsult.SelectConsult_O lngParaRsvNo, strWkOptCd, strWkOptBranchNo
    strOptCd       = Join(strWkOptCd, ",")
    strOptBranchNo = Join(strWkOptBranchNo, ",")

    '�ۑ�������̐���
    strPrtOnSave = CStr(ControlPrtOnSave(CDate(strCslDate), False))

End Sub
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ��f�t�����̏����l�ҏW
'
' �����@�@ : (In)     dtmParaCslDate  ��f�N����
' �@�@�@�@   (In)     strParaPerId    �lID
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub SetDefaultPersonalInfo(dtmParaCslDate, strParaPerId)

    '�\��󋵂͌lID�����݂���Ίm��A�Ȃ���Εۗ�(�Ȃ��ꍇ�A�ۑ����ɉ�ID�ō쐬����邽��)
    strRsvStatus = IIf(strParaPerId <> "", "0", "1")

    '�ۑ�������̐���
    strPrtOnSave = CStr(ControlPrtOnSave(dtmParaCslDate, True))

    '�X�����Đ�́u�Z��(����)�v���f�t�H���g�Őݒ�
    strCardAddrDiv    = "1"
    strFormAddrDiv    = "1"
    strReportAddrDiv  = "1"

    '�f�@�����s�͌lID�����݂���Ί����A�Ȃ���ΐV�K(�Ȃ��ꍇ�A�ۑ����ɉ�ID�ō쐬����邽��)
    strIssueCslTicket = IIf(strParaPerId <> "", "2", "1")

End Sub
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �l���̏����l�ҏW
'
' �����@�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub SetDefaultPerAddr()

    '������̃f�t�H���g�l�ҏW
    strZipCd(0)    = strDefZipNo
    strCityName(0) = strDefAddress1
    strAddress1(0) = strDefAddress2
    strAddress2(0) = strDefAddress3
    strTel1(0)     = strDefTel
    strEMail(0)    = strDefEMail

    '�Ζ�����̃f�t�H���g�l�ҏW
    strTel1(1) = strDefOfficeTel

End Sub
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �ۑ����������
'
' �����@�@ : (In)     dtmParaCslDate  ��f�N����
' �@�@�@�@   (In)     blnParaNew      �V�K�t���O(True:�V�K�AFalse:�o�^�ς�)
'
' �߂�l�@ : �ۑ�������̒l
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function ControlPrtOnSave(dtmParaCslDate, blnParaNew)

    Dim objFree             '�ėp���A�N�Z�X�p
    Dim strLastFormCslDate  '���t�ē��ŐV�o�͎�f��
    Dim dtmLastFormCslDate  '���t�ē��ŐV�o�͎�f��
    Dim Ret                 '�֐��߂�l

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objFree = Server.CreateObject("HainsFree.Free")

    '���t�ē��ŐV�o�͎�f���̓ǂݍ���
    objFree.SelectFree 0, FREECD_RSVINTERVAL, , , strLastFormCslDate

    '���t��r���s�����߁ADate�^�ɕϊ�
    dtmLastFormCslDate = CDate(strLastFormCslDate)

    Do

        '�V�K�̏ꍇ�A��f�������t�ē��o�͍ŐV��f����薢���Ȃ�͂����o�́A�����Ȃ��Α��t�ē����o��
        If blnParaNew Then
            Ret = IIf(dtmParaCslDate > dtmLastFormCslDate, PRTONSAVE_INDEXCARD, PRTONSAVE_INDEXFORM)
            Exit Do
        End If

        '�X�V���̐��䃍�W�b�N

        '(1)�͂����A���t�ē����ɖ��o�͂̏ꍇ�A��f���̏�ԂɊւ�炸�V�K�̏ꍇ�Ɠ���
        If strCardPrintDate = "" And strFormPrintDate = "" Then
            Ret = IIf(dtmParaCslDate > dtmLastFormCslDate, PRTONSAVE_INDEXCARD, PRTONSAVE_INDEXFORM)
            Exit Do
        End If

        '(2)�͂����̂ݏo�͍ς݂̏ꍇ
        If strCardPrintDate <> "" And strFormPrintDate = "" Then

            '��f�������t�ē��o�͍ŐV��f����薢���Ȃ�Ȃ�
            If dtmParaCslDate > dtmLastFormCslDate Then
                Ret = PRTONSAVE_INDEXNONE
                Exit Do
            End If

            '�����Ȃ��Α��t�ē�
            Ret = PRTONSAVE_INDEXFORM

            Exit Do
        End If

        '(3)���t�ē��̂ݏo�͍ς݂̏ꍇ�A�܂���(4)�����Ƃ��o�͍ς݂̏ꍇ(�������t�ē��o�͍ς݂̏ꍇ)�͂Ȃ��Ƃ���
        Ret = PRTONSAVE_INDEXNONE
        Exit Do
    Loop

    '�߂�l�̐ݒ�
    ControlPrtOnSave = Ret

End Function
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ��web�\����̃L�[�擾
'
' �����@�@ : (In)     dtmParaCslDate      ��f�N����
' �@�@�@�@   (In)     lngParaWebNo        webNo.
' �@�@�@�@   (Out)    dtmParaNextCslDate  (��web�\�����)��f�N����
' �@�@�@�@   (Out)    lngParaNextWebNo    (��web�\�����)webNo.
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub SelectWebOrgRsvNext(dtmParaCslDate, lngParaWebNo, dtmParaNextCslDate, lngParaNextWebNo)

    Dim objWebOrgRsv        'web�\����A�N�Z�X�p
    Dim strNextCslDate      '��web�\����̎�f�N����
    Dim strNextWebNo        '��web�\�����webNo.
    Dim Ret                 '�֐��߂�l

    '��web�\����̃L�[����web�\����̃f�t�H���g�L�[�Ƃ��Đݒ�
    dtmParaNextCslDate = dtmParaCslDate
    lngParaNextWebNo   = lngParaWebNo

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objWebOrgRsv = Server.CreateObject("HainsWebOrgRsv.WebOrgRsv")

    'web�\�����ǂ݁A���L�[�����߂�
'#### 2010.10.28 SL-UI-Y0101-107 MOD START ####'
    'Ret = objWebOrgRsv.SelectWebOrgRsvNext( _
    '          dtmStrCslDate,          _
    '          dtmEndCslDate,          _
    '          strKey,                 _
    '          dtmStrOpDate,           _
    '          dtmEndOpDate,           _
    '          strOrgCd1,              _
    '          strOrgCd2,              _
    '          lngOpMode,              _
    '          lngRegFlg,              _
    '          lngOrder,               _
    '          dtmParaCslDate,         _
    '          lngParaWebNo,           _
    '          strNextCslDate,         _
    '          strNextWebNo            _
    '      )
    Ret = objWebOrgRsv.SelectWebOrgRsvNext( _
              dtmStrCslDate,          _
              dtmEndCslDate,          _
              strKey,                 _
              dtmStrOpDate,           _
              dtmEndOpDate,           _
              strOrgCd1,              _
              strOrgCd2,              _
              lngOpMode,              _
              lngRegFlg,              _
              lngMosFlg,              _
              lngOrder,               _
              dtmParaCslDate,         _
              lngParaWebNo,           _
              strNextCslDate,         _
              strNextWebNo            _
          )
'#### 2010.10.28 SL-UI-Y0101-107 MOD END ####'

    '�I�u�W�F�N�g�̉��
    Set objWebOrgRsv = Nothing

    '���L�[���ݎ��͒l���X�V
    If Ret = True Then
        dtmParaNextCslDate = CDate(strNextCslDate)
        lngParaNextWebNo   = CLng(strNextWebNo)
    End If

End Sub
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �ۑ���y�[�W����
'
' �����@�@ : (In)     lngParaRsvNo        �\��ԍ�
' �@�@�@�@   (In)     dtmParaNextCslDate  (��web�\�����)��f�N����
' �@�@�@�@   (In)     lngParaNextWebNo    (��web�\�����)webNo.
'
' �߂�l�@ : HTML������
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CreateHTMLForControlAfterSaved(lngParaRsvNo, dtmParaNextCslDate, lngParaNextWebNo)

    Dim strHTML     'HTML������
    Dim strURL      '�W�����v���URL

    'HTML�̕ҏW�J�n
    strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
    strHTML = strHTML & vbCrLf & "<SCRIPT TYPE=""text/javascript"">"
    strHTML = strHTML & vbCrLf & "<!--"

    '�������
    Do

        '�ۑ����łȂ���Εs�v
        If Not blnSave Then
            Exit Do
        End If

        '�\��󋵂��ۗ��Ȃ�Εs�v
        '#### 2007/04/04 �� �\��󋵋敪�ǉ��̂��ߏC�� Start ####
        'If strRsvStatus = "1" Then
        If strRsvStatus = "1" or strRsvStatus = "2" Then
        '#### 2007/04/04 �� �\��󋵋敪�ǉ��̂��ߏC�� End   ####
            
            Exit Do
        End If

        '����p���\�b�h�̎���
        Select Case strPrtOnSave
            Case "1"
                strHTML = strHTML & vbCrLf & "top.showPrintCardDialog('" & lngParaRsvNo & "','0','" & strCardAddrDiv & "','" & strCardOutEng & "');"
            Case "2"
                strHTML = strHTML & vbCrLf & "top.showPrintFormDialog('" & lngParaRsvNo & "','0','" & strFormAddrDiv & "','" & strFormOutEng & "');"
        End Select

        Exit Do
    Loop

    'URL�̕ҏW
    strURL = "webOrgRsvMain.asp"
    strURL = strURL & "?cslDate="    & dtmParaNextCslDate
    strURL = strURL & "&webNo="      & lngParaNextWebNo
    strURL = strURL & "&strCslDate=" & dtmStrCslDate
    strURL = strURL & "&endCslDate=" & dtmEndCslDate
    strURL = strURL & "&key="        & strKey
    strURL = strURL & "&strOpDate="  & IIf(dtmStrOpDate > 0, dtmStrOpDate, "")
    strURL = strURL & "&endOpDate="  & IIf(dtmEndOpDate > 0, dtmEndOpDate, "")
    strURL = strURL & "&orgCd1="     & strOrgCd1
    strURL = strURL & "&orgCd2="     & strOrgCd2
    strURL = strURL & "&opMode="     & lngOpMode
    strURL = strURL & "&regFlg="     & lngRegFlg
    strURL = strURL & "&order="      & lngOrder
'#### 2010.10.28 SL-UI-Y0101-108 MOD START ####'
	strURL = strURL & "&mousi="      & lngMosFlg
'#### 2010.10.28 SL-UI-Y0101-108 MOD END ####'

    '�u�m��v�{�^���������͕ۑ������t���O����
    If Not blnNext Then
        strURL = strURL & "&saved=1"
    End If

    '�쐬����URL�Őe�t���[����replace
    strHTML = strHTML & vbCrLf & "top.location.replace('" & strURL & "');"
    strHTML = strHTML & vbCrLf & "//-->"
    strHTML = strHTML & vbCrLf & "</SCRIPT>"
    strHTML = strHTML & vbCrLf & "</HTML>"

    '�߂�l�̐ݒ�
    CreateHTMLForControlAfterSaved = strHTML

End Function
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �l�Z�����i�[��̏�����
'
' �����@�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub InitializePerAddr()

    '�Z�����i�[�p�ϐ���z��Ƃ��ď�����
    strZipCd     = Array()
    strPrefCd    = Array()
    strPrefName  = Array()
    strCityName  = Array()
    strAddress1  = Array()
    strAddress2  = Array()
    strTel1      = Array()
    strPhone     = Array()
    strTel2      = Array()
    strExtension = Array()
    strFax       = Array()
    strEMail     = Array()

    '����A�Ζ���A���̑��̂R�Z�������i�[���邽�߁A�z����g��
    ReDim Preserve strZipCd(2)
    ReDim Preserve strPrefCd(2)
    ReDim Preserve strPrefName(2)
    ReDim Preserve strCityName(2)
    ReDim Preserve strAddress1(2)
    ReDim Preserve strAddress2(2)
    ReDim Preserve strTel1(2)
    ReDim Preserve strPhone(2)
    ReDim Preserve strTel2(2)
    ReDim Preserve strExtension(2)
    ReDim Preserve strFax(2)
    ReDim Preserve strEMail(2)

End Sub
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �l���ǂݍ���
'
' �����@�@ : (In)     strParaPerId  �lID
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub SelectPerson(strParaPerId)

    Dim objPerson       '�l���A�N�Z�X�p

    Dim strArrAddrDiv   '�Z���敪
    Dim strArrZipCd     '�X�֔ԍ�
    Dim strArrPrefCd    '�s���{���R�[�h
    Dim strArrPrefName  '�s���{����
    Dim strArrCityName  '�s�撬����
    Dim strArrAddress1  '�Z���P
    Dim strArrAddress2  '�Z���Q
    Dim strArrTel1      '�d�b�ԍ�1
    Dim strArrPhone     '�g�єԍ�
    Dim strArrTel2      '�d�b�ԍ�2
    Dim strArrExtension '����
    Dim strArrFax       'FAX
    Dim strArrEMail     'e-Mail
    Dim lngCount        '�Z�����

    Dim lngIndex        '�i�[�p�̃C���f�b�N�X
    Dim i               '�C���f�b�N�X

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objPerson = Server.CreateObject("HainsPerson.Person")

    '�l���ǂݍ���
    objPerson.SelectPerson_lukes strPerId, , , , , strRomeName, , , , , strNationCd 

    '�l�Z�����ǂݍ���
    lngCount = objPerson.SelectPersonAddr( _
        strParaPerId,                      _
        strArrAddrDiv,                     _
        strArrZipCd,                       _
        strArrPrefCd,                      _
        strArrPrefName,                    _
        strArrCityName,                    _
        strArrAddress1,                    _
        strArrAddress2,                    _
        strArrTel1,                        _
        strArrPhone,                       _
        strArrTel2,                        _
        strArrExtension,                   _
        strArrFax,                         _
        strArrEMail                        _
    )

    '�I�u�W�F�N�g�̉��
    Set objPerson = Nothing

    '�ǂݍ��񂾏Z����������
    For i = 0 To lngCount - 1

        '�Z���敪�l�����ƂɊi�[��̃C���f�b�N�X���`
        Select Case strArrAddrDiv(i)
            Case "1"
                lngIndex = 0
            Case "2"
                lngIndex = 1
            Case "3"
                lngIndex = 2
            Case Else
                lngIndex = -1
        End Select

        '�ǂݍ��񂾏Z�������i�[�p�ϐ���
        If lngIndex >= 0 Then
            strZipCd(lngIndex)     = strArrZipCd(i)
            strPrefCd(lngIndex)    = strArrPrefCd(i)
            strPrefName(lngIndex)  = strArrPrefName(i)
            strCityName(lngIndex)  = strArrCityName(i)
            strAddress1(lngIndex)  = strArrAddress1(i)
            strAddress2(lngIndex)  = strArrAddress2(i)
            strTel1(lngIndex)      = strArrTel1(i)
            strPhone(lngIndex)     = strArrPhone(i)
            strTel2(lngIndex)      = strArrTel2(i)
            strExtension(lngIndex) = strArrExtension(i)
            strFax(lngIndex)       = strArrFax(i)
            strEMail(lngIndex)     = strArrEMail(i)
        End If

    Next

End Sub
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���N��v�Z
'
' �����@�@ : (In)     dtmParaBirth    ���N����
' �@�@�@�@   (In)     dtmParaCslDate  ��f�N����
'
' �߂�l�@ : ��f�����_�ł̔N��
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CalcRealAge(dtmParaBirth, dtmParaCslDate)

    Dim objFree     '�ėp���A�N�Z�X�p
    Dim strRealAge  '��f�����_�ł̎��N��

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objFree = Server.CreateObject("HainsFree.Free")

    '���N��̌v�Z
    strRealAge = objFree.CalcAge(dtmParaBirth, dtmParaCslDate)

    '�����_�ȉ��̏���
    If InStr(strRealAge, ".") > 0 Then
        strRealAge = Left(strRealAge, InStr(strRealAge, ".") - 1)
    End If

    '�߂�l�̐ݒ�
    CalcRealAge = strRealAge

End Function
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �\��Q�Z���N�V�����{�b�N�X�̕ҏW
'
' �����@�@ : (In)     strParaRsvGrpCd  �I�����ׂ��\��Q�R�[�h
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub EditRsvGrpList(strParaRsvGrpCd)

    Dim objSchedule         '�X�P�W���[�����A�N�Z�X�p
    Dim strArrRsvGrpCd      '�\��Q�R�[�h
    Dim strArrRsvGrpName    '�\��Q����
    Dim lngRsvGrpCount      '�\��Q��
    Dim i                   '�C���f�b�N�X
%>
    <SELECT NAME="rsvGrpCd">
<%
        '�I�u�W�F�N�g�̃C���X�^���X�쐬
        Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")

        '�w��R�[�X�ɂ�����L���ȗ\��Q�R�[�X��f�\��Q�������ɓǂݍ���
        lngRsvGrpCount = objSchedule.SelectCourseRsvGrpListSelCourse(strCsCd, 0, strArrRsvGrpCd, strArrRsvGrpName)

        '�I�u�W�F�N�g�̉��
        Set objSchedule = Nothing

        '�z��Y�������̃��X�g��ǉ�
        For i = 0 To lngRsvGrpCount - 1
%>
            <OPTION VALUE="<%= strArrRsvGrpCd(i) %>"<%= IIf(strArrRsvGrpCd(i) = strParaRsvGrpCd, " SELECTED", "") %>><%= strArrRsvGrpName(i) %>
<%
        Next
%>
    </SELECT>
<%
End Sub
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �L�����Z�����R�ǂݍ���
'
' �����@�@ : (In)     strParaCancelFlg  �L�����Z���t���O
'
' �߂�l�@ : �L�����Z�����R
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function GetReason(strParaCancelFlg)

    Dim objFree     '�ėp���A�N�Z�X�p
    Dim strReason   '�L�����Z�����R
    Dim strHTML     'HTML������

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objFree = Server.CreateObject("HainsFree.Free")

    '�L�����Z�����R��ǂݍ���
    objFree.SelectFree 0, FREECD_CANCEL & strParaCancelFlg, , , ,strReason

    If strReason = "" Then
        strReason = strParaCancelFlg
    End If

    'HTML�̕ҏW�J�n
    strHTML = "<TABLE BORDER=""0"" CELLPADDING=""1"" CELLSPACING=""0"">"
    strHTML = strHTML & "<TR>"
    strHTML = strHTML & "<TD HEIGHT=""5""></TD>"
    strHTML = strHTML & "</TR>"
    strHTML = strHTML & "<TR>"
    strHTML = strHTML & "<TD NOWRAP><FONT COLOR=""#ff6600""><B>���̎�f���̓L�����Z������Ă��܂��B</B></FONT>&nbsp;&nbsp;�L�����Z�����R�F<FONT COLOR=""#ff6600""><B>" & strReason & "</B></FONT></TD>"
    strHTML = strHTML & "</TR>"
    strHTML = strHTML & "</TABLE>"

    '�߂�l�̐ݒ�
    GetReason = strHTML

End Function
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �_�u���N�H�[�e�[�V�����u��
'
' �����@�@ : (In)     strStream  �Ώە�����
'
' �߂�l�@ : �u����̕�����
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function RepQuot(strStream)

    RepQuot = Replace(strStream, """", "&quot;")

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�\����(�c��)�ڍ�</TITLE>
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<!-- #include virtual = "/webHains/includes/perGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
var winPerson;  // �E�B���h�E�n���h��

var curOrgCd1, curOrgCd2;   // �c�̌����K�C�h�Ăяo�����O�̒c�̑ޔ�p�ϐ�

// �c�̌����K�C�h�Ăяo��
function callOrgGuide() {

    // ���T�u��ʂ����
    top.closeWindow( 4 );

    // �K�C�h�Ăяo�����O�̓��t��ޔ�
    curOrgCd1 = document.paramForm.orgCd1.value;
    curOrgCd2 = document.paramForm.orgCd2.value;

    // �c�̌����K�C�h�\��
    orgGuide_showGuideOrg( document.paramForm.orgCd1, document.paramForm.orgCd2, 'dispOrgName', null, null, changeOrg );

}

// �l�����K�C�h�Ăяo��
function callPersonGuide() {

    // ���T�u��ʂ����
    top.closeWindow( 2 );

    // �ҏW�p�̊֐���`
    perGuide_CalledFunction = setPersonInfo;

    // URL�̕ҏW
    var url = '/webHains/contents/guide/gdePersonal.asp';
    url = url + '?mode='      + '1';
    url = url + '&defPerId='  + document.paramForm.perId.value;
    url = url + '&defGender=' + document.paramForm.gender.value;

    // �l�����K�C�h��ʂ�\��
    perGuide_openWindow( url );

}

// �h�b�N�\�����݌l����ʌĂяo��
function callEditPersonWindow() {

    var opened = false; // ��ʂ��J����Ă��邩
    var url;            // �h�b�N�\�����݌l����ʂ�URL

    // ���T�u��ʂ����
    top.closeWindow( 3 );

    // ���łɃK�C�h���J����Ă��邩�`�F�b�N
    if ( winPerson != null ) {
        if ( !winPerson.closed ) {
            opened = true;
        }
    }

    // �h�b�N�\�����݌l����ʂ�URL�ҏW
    url = 'webOrgRsvEditPerson.asp';
    url = url + '?cslDate=' + '<%= dtmCslDate %>';
    url = url + '&webNo='   + '<%= lngWebNo   %>';
    url = url + '&birth='   + '<%= strBirth   %>';
<%
    '�o�^�ς݂̏ꍇ�A�ǂݍ��ݐ�p�t���O�𑗂�
    If strRegFlg = REGFLG_REGIST Then
%>
        url = url + '&readOnly=1';
<%
End If
%>
    // �J����Ă���ꍇ�͉�ʂ�FOCUS���A�����Ȃ��ΐV�K��ʂ��J��
    if ( opened ) {
        winPerson.focus();
    } else {
        winPerson = window.open( url, '', 'width=750,height=700,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
    }

}

// �h�b�N�\�����݌l����ʂ����
function closeEditPersonalWindow() {

    if ( winPerson != null ) {
        if ( !winPerson.closed ) {
            winPerson.close();
        }
    }

    winPerson = null;
}

// ��f�敪�ύX���̏���
function changeCslDiv() {

    // ��f�敪�R�[�h�̊i�[
    document.paramForm.cslDivCd.value = document.entryForm.cslDivCd.value;

    // �I�v�V����������ʂ̍X�V
    top.replaceOptionFrame();

}

// �c�̕ύX���̏���
function changeOrg() {

    // �c�̖��̂̊i�[
    document.paramForm.orgName.value = document.getElementById('dispOrgName').innerHTML;

    // �ޔ����Ă����c�̂ƈقȂ�ꍇ�A�I�v�V����������ʂ��X�V����
    if ( document.paramForm.orgCd1.value != curOrgCd1 || document.paramForm.orgCd2.value != curOrgCd2 ) {
        top.replaceOptionFrame();
    }

    // �������A���я��{�l�Ƒ��敪������������w��̏ꍇ�A�������o�͒l���N���A����
    if ( orgGuide_BillCslDiv == '' && orgGuide_ReptCslDiv == '' ) {
        document.paramForm.billPrint.value = '';
    }

}

// �l���̃Z�b�g
function setPersonInfo( perInfo ) {

    var replaceOpt = false; // �I�v�V����������ʍX�V�̕K�v��

    var paramForm    = document.paramForm;
    var personalForm = top.personal.document.entryForm;

    // ���݂̌l����ޔ�
    var curPerId  = paramForm.perId.value;
    var curBirth  = paramForm.birth.value;
    var curGender = paramForm.gender.value;

    // �l���̊i�[
    paramForm.perId.value      = perInfo.perId;
    paramForm.lastName.value   = perInfo.lastName;
    paramForm.firstName.value  = perInfo.firstName;
    paramForm.lastKName.value  = perInfo.lastKName;
    paramForm.firstKName.value = perInfo.firstKName;
    paramForm.birth.value      = perInfo.birth;
    paramForm.gender.value     = perInfo.gender;
    paramForm.romeName.value   = perInfo.romeName;

    // �l���̕ҏW
    top.editPerson(
        perInfo.perId,
        perInfo.lastName,
        perInfo.firstName,
        perInfo.lastKName,
        perInfo.firstKName,
        perInfo.birthFull,
        null,
        null,
        perInfo.gender
    );

    // ��f�t�����̏Z����ҏW
    for ( var i = 0; i < paramForm.zipCd.length; i++ ) {
        var objAddr = perInfo.addresses[ i ];
        paramForm.zipCd[ i ].value     = objAddr.zipCd;
        paramForm.prefCd[ i ].value    = objAddr.prefCd;
        paramForm.prefName[ i ].value  = objAddr.prefName;
        paramForm.cityName[ i ].value  = objAddr.cityName;
        paramForm.address1[ i ].value  = objAddr.address1;
        paramForm.address2[ i ].value  = objAddr.address2;
        paramForm.tel1[ i ].value      = objAddr.tel1;
        paramForm.phone[ i ].value     = objAddr.phone;
        paramForm.tel2[ i ].value      = objAddr.tel2;
        paramForm.extension[ i ].value = objAddr.extension;
        paramForm.fax[ i ].value       = objAddr.fax;
        paramForm.eMail[ i ].value     = objAddr.eMail;
    }

    // �l���̕ύX�`�F�b�N
    for ( ; ; ) {

        // �l�h�c���ύX���ꂽ�ꍇ
        if ( perInfo.perId != curPerId ) {

            // �\��󋵂͉�ID�łȂ���Ίm��A�����Ȃ��Εۗ�
            personalForm.rsvStatus.value = perInfo.perId.substring(0, 1) == '@' ? '1' : '0';

            // �f�@�����s�͉�ID�łȂ���Ί����A�����Ȃ��ΐV�K
            personalForm.issueCslTicket.value = perInfo.perId.substring(0, 1) == '@' ? '1' : '2';

            // �I�v�V����������ʂ̍X�V���K�v
            replaceOpt = true;
            break;

        }

        // �l�h�c�͓��ꂾ�����N�����E���ʂ̂����ꂩ���ς�����ꍇ�̓I�v�V����������ʂ̍X�V���K�v
        if ( perInfo.birth != curBirth || perInfo.gender != curGender ) {
            replaceOpt = true;
        }

        break;
    }

    // ��f�����I�����ꂽ�ꍇ
    if ( perInfo.csCd != null ) {

        // �R�[�X�R�[�h�͖{��ʂł͌Œ�Ȃ̂Ōp�����Ȃ�

        // �c�̂��ύX���ꂽ�ꍇ�͍X�V���A���I�v�V����������ʂ̍X�V���K�v
        if ( perInfo.lastOrgCd1 != paramForm.orgCd1.value || perInfo.lastOrgCd2 != paramForm.orgCd2.value ) {
            paramForm.orgCd1.value  = perInfo.lastOrgCd1;
            paramForm.orgCd2.value  = perInfo.lastOrgCd2;
            paramForm.orgName.value = perInfo.lastOrgName;
            document.getElementById('dispOrgName').innerHTML = perInfo.lastOrgName;
            replaceOpt = true;
        }

        // ��f�敪���ύX���ꂽ�ꍇ�͍X�V���A���I�v�V����������ʂ̍X�V���K�v
        if ( perInfo.cslDivCd != paramForm.cslDivCd.value ) {
            paramForm.cslDivCd.value = perInfo.cslDivCd;
            replaceOpt = true;
        }

        // �p�����ׂ����ڂ̕ҏW(��f�t�����)
        personalForm.cardAddrDiv.value   = perInfo.cardAddrDiv;     // �m�F�͂�������
        personalForm.formAddrDiv.value   = perInfo.formAddrDiv;     // �ꎮ��������
        personalForm.reportAddrDiv.value = perInfo.reportAddrDiv;   // ���я�����

        // �p�����ׂ����ڂ̕ҏW(submit�p�t�H�[��)
        paramForm.cardAddrDiv.value   = perInfo.cardAddrDiv;        // �m�F�͂�������
        paramForm.formAddrDiv.value   = perInfo.formAddrDiv;        // �ꎮ��������
        paramForm.reportAddrDiv.value = perInfo.reportAddrDiv;      // ���я�����
        paramForm.volunteer.value     = perInfo.volunteer;          // �{�����e�B�A
        paramForm.volunteerName.value = perInfo.volunteerName;      // �{�����e�B�A��
        paramForm.isrSign.value       = perInfo.isrSign;            // �ی��؋L��
        paramForm.isrNo.value         = perInfo.isrNo;              // �ی��ؔԍ�
        paramForm.isrManNo.value      = perInfo.isrManNo;           // �ی��Ҕԍ�
        paramForm.empNo.value         = perInfo.empNo;              // �Ј��ԍ�

    }

    // �I�v�V����������ʂ̍X�V
    if ( replaceOpt ) {
        top.replaceOptionFrame();
    }

}

// ��ʂ����
function closeWindow() {
    perGuide_closeGuidePersonal();
    closeEditPersonalWindow();
    orgGuide_closeGuideOrg();
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 0 0 20px 10px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">
<FORM NAME="entryForm" action="#">
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="464">
        <TR>
            <TD BGCOLOR="#eeeeee" NOWRAP><B><FONT COLOR="#333333">��{���</FONT></B></TD>
        </TR>
    </TABLE>

    <SPAN ID="errMsg">
<%
    '�G���[���b�Z�[�W�̕ҏW
    Call EditMessage(strMessage, MESSAGETYPE_WARNING)
%>
    </SPAN>

    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
        <TR>
            <TD HEIGHT="2"></TD>
        </TR>
        <TR VALIGN="bottom">
            <TD>�l��</TD>
            <TD>�F</TD>
            <TD ROWSPAN="2" VALIGN="middle" ID="perGuide"><A HREF="JavaScript:callPersonGuide()"><IMG SRC="/webhains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�l�����K�C�h��\�����܂�"></A></TD>
            <TD WIDTH="100%">
                <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="1">
                    <TR VALIGN="bottom">
                        <TD NOWRAP ID="perPerId"></TD>
                        <TD>&nbsp;&nbsp;</TD>
                        <TD NOWRAP><FONT ID="kanaName" SIZE="1"></FONT><BR><B ID="fullName"></B></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD COLSPAN="2"></TD>
            <TD>
                <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                    <TR>
                        <TD NOWRAP><SPAN ID="perBirth"></SPAN>��</TD>
                        <TD>&nbsp;&nbsp;</TD>
                        <TD NOWRAP><SPAN ID="perRealAge"></SPAN><SPAN ID="perAge"></SPAN></TD>
                        <TD>&nbsp;&nbsp;</TD>
                        <TD NOWRAP ID="perGender"></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD HEIGHT="5"></TD>
        </TR>
        <TR>
            <TD>�c��</TD>
            <TD>�F</TD>
            <!--## �c�̌����K�C�h�͕\�����Ȃ��iweb�\���񂩂�f�t�H���g�\�����Œ�)�F�C���t��   ##-->
            <TD COLSPAN="2" NOWRAP ID="dispOrgName"></TD>
        </TR>
        <TR>
            <TD HEIGHT="2"></TD>
        </TR>
        <TR>
            <TD>�R�[�X</TD>
            <TD>�F</TD>
            <TD COLSPAN="2">
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
                    <TR>
                        <TD><%= EditCourseList("csCd", strCsCd, NON_SELECTED_DEL) %></TD>
                        </TD>
                        <TD NOWRAP>&nbsp;��f�敪�F</TD>
                        <TD><SELECT NAME="cslDivCd" STYLE="width:85;" ONCHANGE="javascript:changeCslDiv()"></SELECT></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD HEIGHT="2"></TD>
        </TR>
        <TR>
            <TD NOWRAP>��f����</TD>
            <TD>�F</TD>
            <TD COLSPAN="2">
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
                    <TR>
                        <TD><%= EditNumberList("cslYear", YEARRANGE_MIN, YEARRANGE_MAX, Year(CDate(strCslDate)), False) %></TD>
                        <TD>�N</TD>
                        <TD><%= EditNumberList("cslMonth", 1, 12, Month(CDate(strCslDate)), False) %></TD>
                        <TD>��</TD>
                        <TD><%= EditNumberList("cslDay", 1, 31, Day(CDate(strCslDate)), False) %></TD>
                        <TD>��&nbsp;&nbsp;</TD>
                        <TD><% EditRsvGrpList(strRsvGrpCd) %></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
<%
    '���o�^���\��g�����t���O�ɂċ����o�^�����������[�U�̏ꍇ�A�����o�^�p�̃`�F�b�N�{�b�N�X��\��
    If strRegFlg <> REGFLG_REGIST And (Session("IGNORE") = IGNORE_EXCEPT_NO_RSVFRA Or Session("IGNORE") = IGNORE_ANY) Then
%>
        <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
            <TR>
                <TD HEIGHT="35"><INPUT TYPE="checkbox"<%= IIf(lngIgnoreFlg = CLng(Session("IGNORE")), " CHECKED", "") %> ONCLICK="javascript:document.paramForm.ignore.value = ( this.checked ? '<%= Session("IGNORE") %>' : '' )"></TD>
                <TD NOWRAP><FONT SIZE="-1">�����o�^���s��</FONT></TD>
            </TR>
        </TABLE>
<%
    End If
%>
</FORM>
<FORM NAME="paramForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<%
    'web�\����̎�L�[
%>
    <INPUT TYPE="hidden" NAME="cslDate" VALUE="<%= strCslDate %>">
    <INPUT TYPE="hidden" NAME="webNo"   VALUE="<%= lngWebNo   %>">
    <INPUT TYPE="hidden" NAME="cRsvNo"  VALUE="<%= lngCRsvNo  %>">
<%
    '��������p
%>
    <INPUT TYPE="hidden" NAME="save"   VALUE="">
    <INPUT TYPE="hidden" NAME="next"   VALUE="">
    <INPUT TYPE="hidden" NAME="ignore" VALUE="">
<%
    '���\���񌟍��p
%>
    <INPUT TYPE="hidden" NAME="strCslDate" VALUE="<%= dtmStrCslDate   %>">
    <INPUT TYPE="hidden" NAME="endCslDate" VALUE="<%= dtmEndCslDate   %>">
    <INPUT TYPE="hidden" NAME="key"        VALUE="<%= RepQuot(strKey) %>">

    <INPUT TYPE="hidden" NAME="strOpDate"  VALUE="<%= IIf(dtmStrOpDate > 0, dtmStrOpDate, "") %>">
    <INPUT TYPE="hidden" NAME="endOpDate"  VALUE="<%= IIf(dtmEndOpDate > 0, dtmEndOpDate, "") %>">

    <INPUT TYPE="hidden" NAME="opMode" VALUE="<%= lngOpMode %>">
    <INPUT TYPE="hidden" NAME="regFlg" VALUE="<%= lngRegFlg %>">
    <INPUT TYPE="hidden" NAME="order"  VALUE="<%= lngOrder  %>">
<%
    'web�\����A��f��񋤒�
%>
    <INPUT TYPE="hidden" NAME="csCd"       VALUE="<%= RepQuot(strCsCd)       %>">
    <INPUT TYPE="hidden" NAME="rsvGrpCd"   VALUE="<%= strRsvGrpCd            %>">
    <INPUT TYPE="hidden" NAME="perId"      VALUE="<%= RepQuot(strPerId)      %>">
    <INPUT TYPE="hidden" NAME="lastName"   VALUE="<%= RepQuot(strLastName)   %>">
    <INPUT TYPE="hidden" NAME="firstName"  VALUE="<%= RepQuot(strFirstName)  %>">
    <INPUT TYPE="hidden" NAME="lastKName"  VALUE="<%= RepQuot(strLastKName)  %>">
    <INPUT TYPE="hidden" NAME="firstKName" VALUE="<%= RepQuot(strFirstKName) %>">
    <INPUT TYPE="hidden" NAME="gender"     VALUE="<%= strGender              %>">
    <INPUT TYPE="hidden" NAME="birth"      VALUE="<%= strBirth               %>">
<%
    'web�\����
%>
    <INPUT TYPE="hidden" NAME="stomac" VALUE="<%= strOptionStomac %>">
    <INPUT TYPE="hidden" NAME="breast" VALUE="<%= strOptionBreast %>">
<% '#### 2013.3.11 SL-SN-Y0101-612 ADD START #### %>
    <INPUT TYPE="hidden" NAME="csloptions" VALUE="<%= strCslOptions %>">
<% '#### 2013.3.11 SL-SN-Y0101-612 ADD END   #### %>
<%
    '��f���
%>
    <INPUT TYPE="hidden" NAME="orgCd1"   VALUE="<%= RepQuot(strOrgCd1)   %>">
    <INPUT TYPE="hidden" NAME="orgCd2"   VALUE="<%= RepQuot(strOrgCd2)   %>">
    <INPUT TYPE="hidden" NAME="orgName"  VALUE="<%= RepQuot(strOrgName)  %>">
    <INPUT TYPE="hidden" NAME="age"      VALUE="<%= strAge               %>">
    <INPUT TYPE="hidden" NAME="cslDivCd" VALUE="<%= RepQuot(strCslDivCd) %>">
    <INPUT TYPE="hidden" NAME="ctrPtCd"  VALUE="<%= strCtrPtCd           %>">
<%
    '�l���
%>
    <INPUT TYPE="hidden" NAME="romeName" VALUE="<%= RepQuot(strRomeName) %>">
<%
    For i = 0 To UBound(strZipCd)
%>
        <INPUT TYPE="hidden" NAME="zipCd"     VALUE="<%= RepQuot(strZipCd(i))     %>">
        <INPUT TYPE="hidden" NAME="prefCd"    VALUE="<%= RepQuot(strPrefCd(i))    %>">
        <INPUT TYPE="hidden" NAME="prefName"  VALUE="<%= RepQuot(strPrefName(i))  %>">
        <INPUT TYPE="hidden" NAME="cityName"  VALUE="<%= RepQuot(strCityName(i))  %>">
        <INPUT TYPE="hidden" NAME="address1"  VALUE="<%= RepQuot(strAddress1(i))  %>">
        <INPUT TYPE="hidden" NAME="address2"  VALUE="<%= RepQuot(strAddress2(i))  %>">
        <INPUT TYPE="hidden" NAME="tel1"      VALUE="<%= RepQuot(strTel1(i))      %>">
        <INPUT TYPE="hidden" NAME="phone"     VALUE="<%= RepQuot(strPhone(i))     %>">
        <INPUT TYPE="hidden" NAME="tel2"      VALUE="<%= RepQuot(strTel2(i))      %>">
        <INPUT TYPE="hidden" NAME="extension" VALUE="<%= RepQuot(strExtension(i)) %>">
        <INPUT TYPE="hidden" NAME="fax"       VALUE="<%= RepQuot(strFax(i))       %>">
        <INPUT TYPE="hidden" NAME="eMail"     VALUE="<%= RepQuot(strEMail(i))     %>">
<%
    Next

    '
%>
    <INPUT TYPE="hidden" NAME="nationCd"    VALUE="<%= RepQuot(strNationCd)     %>">
    <INPUT TYPE="hidden" NAME="nationName"  VALUE="<%= RepQuot(strNationName)   %>">
<%

    '��f�t�����
%>
    <INPUT TYPE="hidden" NAME="rsvStatus"      VALUE="<%= strRsvStatus              %>">
    <INPUT TYPE="hidden" NAME="prtOnSave"      VALUE="<%= strPrtOnSave              %>">
    <INPUT TYPE="hidden" NAME="cardAddrDiv"    VALUE="<%= strCardAddrDiv            %>">
    <INPUT TYPE="hidden" NAME="cardOutEng"     VALUE="<%= strCardOutEng             %>">
    <INPUT TYPE="hidden" NAME="formAddrDiv"    VALUE="<%= strFormAddrDiv            %>">
    <INPUT TYPE="hidden" NAME="formOutEng"     VALUE="<%= strFormOutEng             %>">
    <INPUT TYPE="hidden" NAME="reportAddrDiv"  VALUE="<%= strReportAddrDiv          %>">
    <INPUT TYPE="hidden" NAME="reportOutEng"   VALUE="<%= strReportOutEng           %>">
    <INPUT TYPE="hidden" NAME="volunteer"      VALUE="<%= strVolunteer              %>">
    <INPUT TYPE="hidden" NAME="volunteerName"  VALUE="<%= RepQuot(strVolunteerName) %>">
    <INPUT TYPE="hidden" NAME="collectTicket"  VALUE="<%= strCollectTicket          %>">
    <INPUT TYPE="hidden" NAME="issueCslTicket" VALUE="<%= strIssueCslTicket         %>">
    <INPUT TYPE="hidden" NAME="billPrint"      VALUE="<%= strBillPrint              %>">
    <INPUT TYPE="hidden" NAME="isrSign"        VALUE="<%= RepQuot(strIsrSign)       %>">
    <INPUT TYPE="hidden" NAME="isrNo"          VALUE="<%= RepQuot(strIsrNo)         %>">
    <INPUT TYPE="hidden" NAME="isrManNo"       VALUE="<%= RepQuot(strIsrManNo)      %>">
    <INPUT TYPE="hidden" NAME="empNo"          VALUE="<%= RepQuot(strEmpNo)         %>">
    <INPUT TYPE="hidden" NAME="introductor"    VALUE="<%= RepQuot(strIntroductor)   %>">
    <INPUT TYPE="hidden" NAME="lastCslDate"    VALUE="<%= strLastCslDate            %>">
<%
    '�I�v�V����
%>
    <INPUT TYPE="hidden" NAME="optCd"  VALUE="<%= strOptCd       %>">
    <INPUT TYPE="hidden" NAME="optBNo" VALUE="<%= strOptBranchNo %>">
</FORM>
<SCRIPT TYPE="text/javascript">
<!--
<%
Set objCommon = Server.CreateObject("HainsCommon.Common")

'�l���̕ҏW
%>
top.editPerson(
    document.paramForm.perId.value,
    document.paramForm.lastName.value,
    document.paramForm.firstName.value,
    document.paramForm.lastKName.value,
    document.paramForm.firstKName.value,
    '<%= objCommon.FormatString(CDate(strBirth), "ge�iyyyy�j.m.d") %>',
    document.paramForm.age.value,
    '<%= CalcRealAge(CDate(strBirth), CDate(strCslDate)) %>',
    document.paramForm.gender.value
);
<%
Set objCommon = Nothing

'�c�̏��̕ҏW
%>
document.getElementById('dispOrgName').innerHTML = document.paramForm.orgName.value;
<%
'�R�[�X�A��f���A�\��Q�͏펞�g�p�s�\�Ƃ���
%>
document.entryForm.csCd.disabled     = true;
document.entryForm.cslYear.disabled  = true;
document.entryForm.cslMonth.disabled = true;
document.entryForm.cslDay.disabled   = true;
document.entryForm.rsvGrpCd.disabled = true;
<%
'�X�ɓo�^�ς݂̏ꍇ
If strRegFlg = REGFLG_REGIST Then

    '�K�C�h�{�^���͕\�����Ȃ�
%>
    document.getElementById('perGuide').innerHTML = '';
<%
    '��f�敪���I��s�Ƃ���
%>
    document.entryForm.cslDivCd.disabled = true;
<%
End If

'��f�t�����̕\��

'�o�^�ς݂̏ꍇ�A�ǂݍ��ݐ�p�t���O�𑗂�
If strRegFlg = REGFLG_REGIST Then
%>
    top.personal.location.replace( 'webOrgRsvPersonal.asp?readOnly=1' );
<%
Else
%>
    top.personal.location.replace( 'webOrgRsvPersonal.asp' );
<%
End If

'�I�v�V����������ʂ̕\��
%>
top.replaceOptionFrame( document.paramForm.ctrPtCd.value, document.paramForm.optCd.value, document.paramForm.optBNo.value );
<%
'���b�Z�[�W����

Do

    '�ۑ�������
    If blnSaved Then

        'Cookie�l�̎擾
%>
        var searchStr = 'rsvDetailOnSaving=';
        var strCookie = document.cookie;
        var startPos  = strCookie.indexOf(searchStr) + searchStr.length;
        var onSaveVal = strCookie.substring(startPos, startPos + 1);

<%      '�m�菈���ɂ�Cookie��������A���t���O�������A�ۑ��������b�Z�[�W���o�� %>
        if ( onSaveVal == '1' ) {
            top.editMessage( document.getElementById('errMsg'), new Array('�ۑ����������܂����B'), false );
        }
<%
        Exit Do
    End If

    '�L�����Z���҂̏ꍇ
    If strCancelFlg <> "" And strCancelFlg <> CStr(CONSULT_USED) Then
%>
        document.getElementById('errMsg').innerHTML = '<%= GetReason(strCancelFlg) %>';
<%
    End If

    Exit Do
Loop
%>
document.cookie = 'rsvDetailOnSaving=0';
//-->
</SCRIPT>
</BODY>
</HTML>
