<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       �l��񃁃��e�i���X (Ver0.0.1)
'       AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
'---------------------------------------------------------------------
'-- �Ǘ��ԍ��FSL-UI-Y0101-109
'-- �C����  �F2010.06.11
'-- �S����  �FTCS)�V�c
'-- �C�����e�F���[�}�������J�i�����ɕύX����
'---------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"    -->
<!-- #include virtual = "/webHains/includes/common.inc"          -->
<!-- #include virtual = "/webHains/includes/EditEraYearList.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"     -->
<!-- #include virtual = "/webHains/includes/EditPrefList.inc"    -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon                   '���ʃN���X
Dim objFree                     '�ėp���A�N�Z�X�p
Dim objHainsUser                '���[�U���A�N�Z�X�p
Dim objPerson                   '�l���A�N�Z�X�p
Dim objPref                     '�s���{�����A�N�Z�X�p

Dim strMode                     '�������[�h(�}��:"insert"�A�X�V:"update")
Dim strAction                   '�������(�ۑ��{�^��������:"save"�A�ۑ�������:"saveend")
Dim strTarget                   '�^�[�Q�b�g���URL
Dim strPerId                    '�l�h�c
Dim strVidFlg                   '���h�c�t���O
Dim strLastName                 '��
Dim strFirstName                '��
Dim strLastKName                '�J�i��
Dim strFirstKName               '�J�i��
Dim strRomeName                 '���[�}����
Dim strMaidenName               '����
Dim strBirth                    '���N����
Dim strBirthYear                '���N����(�N)
Dim strBirthMonth               '���N����(��)
Dim strBirthDay                 '���N����(��)
Dim strGender                   '����
Dim strCompPerId                '�����Ҍl�h�c
Dim strCompName                 '�����Җ�
Dim strCompLastName             '�����Җ��@��
Dim strCompFirstName            '�����Җ��@��
Dim strMedRName                 '�㎖�A�g���[�}����
Dim strMedName                  '�㎖�A�g��������
Dim strMedBirth                 '�㎖�A�g���N����
Dim strMedGender                '�㎖�A�g����
Dim strMedUpdDate               '�㎖�A�g�X�V����

Dim strSpare(6)                 '�\��(�l�\��1, 2�A�l���ڍח\��1�`5)
Dim strDelFlg                   '�폜�t���O
Dim strUpdDate                  '�X�V���t
Dim strUpdUser                  '�X�V��

'�l�Z�����
Dim strAddrDiv                  '�Z���敪
Dim strTel                      '�d�b�ԍ�
Dim strExtension                '����
Dim strSubTel                   '�d�b�ԍ�
Dim strFax                      '�e�`�w�ԍ�
Dim strPhone                    '�g��
Dim strEMail                    'e-Mail
Dim strZipCd                    '�X�֔ԍ�
Dim strPrefCd                   '�s���{���R�[�h
Dim strCityName                 '�s�撬����
Dim strAddress1                 '�Z���P
Dim strAddress2                 '�Z���Q
Dim lngAddrCount                '�Z�����

Dim strMarriage                 '�����敪
Dim strNationCd                 '���ЃR�[�h
Dim strPostCardAddr             '�P�N�ڂ͂�������
Dim strResidentNo               '�Z���ԍ�
Dim strUnionNo                  '�g���ԍ�
Dim strKarte                    '�J���e�ԍ�
Dim strNotes                    '���L����
'## 2004.02.10 Add By T.Takagi@FSIT ��f�񐔂����݂��Ȃ�
Dim strCslCount                 '��f��
'## 2004.02.10 Add End

Dim strSpareName(6)             '�\���̕\������
Dim strSelectedDate             '�N����
Dim strFreeName                 '�ėp��
Dim strUserName                 '���[�U��
Dim strArrMessage               '�G���[���b�Z�[�W
Dim strHTML                     'HTML������
Dim Ret                         '�֐��߂�l
Dim Ret2                        '�֐��߂�l
Dim i, j                        '�C���f�b�N�X

Dim strArrGender()              '����
Dim strArrGenderName()          '���ʖ���

Dim strArrMarriage              '�����敪
Dim strArrMarriageName          '�����敪����

Dim strArrPostCardAddr()        '�P�N�ڂ͂�������
Dim strArrPostCardAddrName()    '�P�N�ڂ͂������於��

Dim strArrDelFlg()              '�폜�t���O�R�[�h
Dim strArrDelFlgName()          '�폜�t���O��

'�ėp���
Dim strFreeCd                   '�ėp�R�[�h
Dim strFreeField1               '�t�B�[���h�P

'�ҏW�p�̌l�Z�����
Dim strEditAddrDiv              '�Z���敪
Dim strEditTel                  '�d�b�ԍ�
Dim strEditExtension            '����
Dim strEditSubTel               '�d�b�ԍ�
Dim strEditFax                  '�e�`�w�ԍ�
Dim strEditPhone                '�g��
Dim strEditEMail                'e-Mail
Dim strEditZipCd                '�X�֔ԍ�
Dim strEditPrefCd               '�s���{���R�[�h
Dim strEditCityName             '�s�撬����
Dim strEditAddress1             '�Z���P
Dim strEditAddress2             '�Z���Q

Dim strPrefName                 '�s���{����
Dim strBuffer                   '������o�b�t�@

'�X�V�p�̌l�Z�����
Dim strUpdAddrDiv()             '�Z���敪
Dim strUpdTel()                 '�d�b�ԍ�
Dim strUpdExtension()           '����
Dim strUpdSubTel()              '�d�b�ԍ�
Dim strUpdFax()                 '�e�`�w�ԍ�
Dim strUpdPhone()               '�g��
Dim strUpdEMail()               'e-Mail
Dim strUpdZipCd()               '�X�֔ԍ�
Dim strUpdPrefCd()              '�s���{���R�[�h
Dim strUpdCityName()            '�s�撬����
Dim strUpdAddress1()            '�Z���P
Dim strUpdAddress2()            '�Z���Q

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
strMode       = Request("mode")
strAction     = Request("act")
strTarget     = Request("target")
strPerId      = Request("perId")
strVidFlg     = Request("vidFlg")
strLastName   = Request("lastName")
strFirstName  = Request("firstName")
strLastKName  = Request("lastKName")
strFirstKName = Request("firstKName")
strRomeName   = Request("romeName")
strMaidenName = Request("maidenname")
strBirthYear  = Request("bYear")
strBirthMonth = Request("bMonth")
strBirthDay   = Request("bDay")
strGender     = Request("gender")
strCompPerId  = Request("compPerId")
strCompName   = Request("compName")
strDelFlg     = Request("delFlg")
strUpdDate    = Request("updDate")
strUpdUser    = Session.Contents("userId")
strMedRName   = Request("medRName")
strMedName    = Request("medName")
strMedBirth   = Request("medBirth")
strMedGender  = Request("medGender")
strMedUpdDate = Request("medUpdDate")

strAddrDiv    = ConvIStringToArray(Request("addrDiv"))
strTel        = ConvIStringToArray(Request("directTel"))
strExtension  = ConvIStringToArray(Request("extension"))
strSubTel     = ConvIStringToArray(Request("subTel"))
strFax        = ConvIStringToArray(Request("fax"))
strPhone      = ConvIStringToArray(Request("phone"))
strEMail      = ConvIStringToArray(Request("eMail"))
strZipCd      = ConvIStringToArray(Request("zipCd"))
strPrefCd     = ConvIStringToArray(Request("prefCd"))
strCityName   = ConvIStringToArray(Request("cityName"))
strAddress1   = ConvIStringToArray(Request("address1"))
strAddress2   = ConvIStringToArray(Request("address2"))

strMarriage     = Request("marriage")
strPostCardAddr = Request("postcardaddr")
strNationCd     = Request("nationcd")
strResidentNo   = Request("residentNo")
strUnionNo      = Request("unionNo")
strKarte        = Request("karte")
strNotes        = Request("notes")
strSpare(0)     = Request("spare1")
strSpare(1)     = Request("spare2")
strSpare(2)     = Request("spare3")
strSpare(3)     = Request("spare4")
strSpare(4)     = Request("spare5")
strSpare(5)     = Request("spare6")
strSpare(6)     = Request("spare7")
'## 2004.02.10 Add By T.Takagi@FSIT ��f�񐔂����݂��Ȃ�
strCslCount     = Request("cslCount")
'## 2004.02.10 Add End

'���ʂ̔z��쐬
Call CreateGenderInfo()

'�폜�t���O�̔z��쐬
Call CreateDelFlgInfo()

'�P�N�ڂ͂������Đ�R�[�h�E���̂̔z��쐬
Call CreatePostCardAddrInfo()

'�\���̕\�����̎擾
For i = 0 To UBound(strSpare)

    '�ėp���ǂݍ���
    Set objFree = Server.CreateObject("HainsFree.Free")
    objFree.SelectFree 0, "PERSPARE" & (i + 1), , strFreeName
    Set objFree = Nothing

    '���̂��ݒ肳��Ă���ꍇ�͂��̓��e��ێ�
    strSpareName(i) = IIf(strFreeName <> "", strFreeName, "�ėp�L�[(" & (i + 1) & ")")

Next

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do

    '�폜�{�^��������
    If strAction = "delete" Then

        Set objPerson = Server.CreateObject("HainsPerson.Person")

        '�l���̍폜
        Ret2 = objPerson.DeletePerson(strPerId)

        Set objPerson = Nothing

        '�߂�l���Ƃ̔���
        Select Case Ret2
            Case  0
            Case -1
                strArrMessage = ("�A�t�^�[�P�A��񂪑��݂��܂��B�폜�ł��܂���B")
            Case -2
                strArrMessage = ("��f��񂪑��݂��܂��B�폜�ł��܂���B")
            Case -3
                strArrMessage = ("���a�x�Ə�񂪑��݂��܂��B�폜�ł��܂���B")
            Case -4
                strArrMessage = ("�A�J��񂪑��݂��܂��B�폜�ł��܂���B")
            Case Else
                strArrMessage = ("���̑��̃G���[���������܂����i�G���[�R�[�h��" & Ret & "�j�B")
        End Select

        If Ret2 <> 0 Then
            Exit Do
        End If

        Response.Redirect Request.ServerVariables("SCRIPT_NAME") & "?mode=insert&act=deleteend"

    End If

    '�ۑ��{�^��������
    If strAction = "save" Then

        '�Z����񐔂̐ݒ�
        lngAddrCount = UBound(strAddrDiv) + 1

        '���̓`�F�b�N
        strArrMessage = CheckValue()
        If Not IsEmpty(strArrMessage) Then
            Exit Do
        End If

        '�㎖�Z���ȊO�̏Z�������X�V�ΏۂƂ���
        j = 0
        For i = 0 To lngAddrCount - 1
            If strAddrDiv(i) <> "4" Then
                ReDim Preserve strUpdAddrDiv(j)
                ReDim Preserve strUpdTel(j)
                ReDim Preserve strUpdExtension(j)
                ReDim Preserve strUpdSubTel(j)
                ReDim Preserve strUpdFax(j)
                ReDim Preserve strUpdPhone(j)
                ReDim Preserve strUpdEMail(j)
                ReDim Preserve strUpdZipCd(j)
                ReDim Preserve strUpdPrefCd(j)
                ReDim Preserve strUpdCityName(j)
                ReDim Preserve strUpdAddress1(j)
                ReDim Preserve strUpdAddress2(j)
                strUpdAddrDiv(j)   = strAddrDiv(i)
                strUpdTel(j)       = strTel(i)
                strUpdExtension(j) = strExtension(i)
                strUpdSubTel(j)    = strSubTel(i)
                strUpdFax(j)       = strFax(i)
                strUpdPhone(j)     = strPhone(i)
                strUpdEMail(j)     = strEMail(i)
                strUpdZipCd(j)     = strZipCd(i)
                strUpdPrefCd(j)    = strPrefCd(i)
                strUpdCityName(j)  = strCityName(i)
                strUpdAddress1(j)  = strAddress1(i)
                strUpdAddress2(j)  = strAddress2(i)
                j = j + 1
            End If
        Next

        '���h�c�t���O�̐ݒ�
        strVidFlg = "1"

        Set objPerson = Server.CreateObject("HainsPerson.Person")

        '�ۑ�����
'## 2004.02.10 Mod By T.Takagi@FSIT ��f�񐔂����݂��Ȃ�
'        strArrMessage = objPerson.UpdateAllPersonInfo_lukes( _
'                            strMode, _
'                            strPerId,        strVidFlg,      strLastName,    _
'                            strFirstName,    strLastKName,   strFirstKName,  _
'                            strRomeName,     strBirth,       strGender,      _
'                            strSpare(0),     strSpare(1),    strUpdUser,     _
'                            strPostCardAddr, strMaidenName,  strNationCd,    _
'                            strCompPerId,    strUpdAddrDiv,  strUpdTel,      _
'                            strUpdExtension, strUpdSubTel,   strUpdFax,      _
'                            strUpdPhone,     strUpdEMail,    strUpdZipCd,    _
'                            strUpdPrefCd,    strUpdCityName, strUpdAddress1, _
'                            strUpdAddress2,  strMarriage,    strResidentNo,  _
'                            strUnionNo,      strKarte,       strNotes,       _
'                            strSpare(2),     strSpare(3),    strSpare(4),    _
'                            strSpare(5),     strSpare(6),    strDelFlg       _
'                        )
        strArrMessage = objPerson.UpdateAllPersonInfo_lukes( _
                            strMode, _
                            strPerId,        strVidFlg,      strLastName,    _
                            strFirstName,    strLastKName,   strFirstKName,  _
                            strRomeName,     strBirth,       strGender,      _
                            strSpare(0),     strSpare(1),    strUpdUser,     _
                            strPostCardAddr, strMaidenName,  strNationCd,    _
                            strCompPerId,    strUpdAddrDiv,  strUpdTel,      _
                            strUpdExtension, strUpdSubTel,   strUpdFax,      _
                            strUpdPhone,     strUpdEMail,    strUpdZipCd,    _
                            strUpdPrefCd,    strUpdCityName, strUpdAddress1, _
                            strUpdAddress2,  strMarriage,    strResidentNo,  _
                            strUnionNo,      strKarte,       strNotes,       _
                            strSpare(2),     strSpare(3),    strSpare(4),    _
                            strSpare(5),     strSpare(6),    strDelFlg,      _
                            strCslCount                                      _
                        )
'## 2004.02.10 Mod End

        Set objPerson = Nothing

        '�X�V�G���[���͏����𔲂���
        If Not IsEmpty(strArrMessage) Then
            Exit Do
        End If

        '�ۑ��ɐ��������ꍇ�A�^�[�Q�b�g�w�莞�͎w����URL�փW�����v���A���w�莞�͍X�V���[�h�Ń��_�C���N�g
        If strTarget <> "" Then
            Response.Redirect strTarget & "?perid=" & strPerID
        Else
            Response.Redirect Request.ServerVariables("SCRIPT_NAME") & "?mode=update&act=saveend&perid=" & strPerID
        End If
        Response.End

    End If

    '�V�K���[�h�̏ꍇ�͓ǂݍ��݂��s��Ȃ�
    If strMode = "insert" Then
'### 2004/1/30 Added by Ishihara@FSIT �V�K���[�h�̏ꍇ�̃n�K�L�̓f�t�H���g�Ŏ���
        strPostCardAddr = "1"
        Exit Do
    End If

    Set objPerson = Server.CreateObject("HainsPerson.Person")

    '�l�e�[�u�����R�[�h�ǂݍ���
'## 2004.02.10 Mod By T.Takagi@FSIT ��f�񐔂����݂��Ȃ�
'    objPerson.SelectPerson_lukes strPerId,        strLastName,      strFirstName,    _
'                                 strLastKName,    strFirstKName,    strRomeName,     _
'                                 strBirth,        strGender,        strPostCardAddr, _
'                                 strMaidenName,   strNationCd,      strCompPerId,    _
'                                 strCompLastName, strCompFirstName, strVidflg,       _
'                                 strDelFlg,       strUpdDate,       strUpdUser,      _
'                                 strUserName,     strSpare(0),      strSpare(1),     _
'                                 strMedRName,     strMedName,       strMedBirth,     _
'                                 strMedGender,    strMedUpdDate
    objPerson.SelectPerson_lukes strPerId,        strLastName,      strFirstName,    _
                                 strLastKName,    strFirstKName,    strRomeName,     _
                                 strBirth,        strGender,        strPostCardAddr, _
                                 strMaidenName,   strNationCd,      strCompPerId,    _
                                 strCompLastName, strCompFirstName, strVidflg,       _
                                 strDelFlg,       strUpdDate,       strUpdUser,      _
                                 strUserName,     strSpare(0),      strSpare(1),     _
                                 strMedRName,     strMedName,       strMedBirth,     _
                                 strMedGender,    strMedUpdDate,    strCslCount
'## 2004.02.10 Mod End

    strBirthYear = Year(strBirth)
    strBirthMonth = Month(strBirth)
    strBirthDay = Day(strBirth)

    strCompName = Trim(strCompLastName & "�@" &  strCompFirstName)

    '�l�ڍ׏��ǂݍ���
    objPerson.SelectPersonDetail_lukes strPerId, strMarriage, strResidentNo, strUnionNo, strKarte, strNotes, strSpare(2), strSpare(3), strSpare(4), strSpare(5), strSpare(6)

    '�l�Z�����ǂݍ���
    lngAddrCount = objPerson.SelectPersonAddr(strPerId, strAddrDiv, strZipCd, strPrefCd, , strCityName, strAddress1, strAddress2, strTel, strPhone, strSubTel, strExtension, strFax, strEMail)

    Set objPerson = Nothing

    Exit Do
Loop

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���ʃR�[�h�E���̂̔z��쐬
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub CreateGenderInfo()

    Redim Preserve strArrGender(1)
    Redim Preserve strArrGenderName(1)

    strArrGender(0) = "1":strArrGenderName(0) = "�j��"
    strArrGender(1) = "2":strArrGenderName(1) = "����"

End Sub

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �߂��URL�ҏW
'
' �����@�@ :
'
' �߂�l�@ : �߂���URL
'
' ���l�@�@ : �e�Ɩ����Ƃɖ߂��(�������)��URL���قȂ邽�߁A����𐧌�
'
'-------------------------------------------------------------------------------
Function EditURLForReturning()

    Dim strURL        '�߂��URL

    Do
        '�^�[�Q�b�g��URL�����݂��Ȃ��ꍇ
        If strTarget = "" Then

            '�ʏ�̃����e�i���X�Ɩ��Ƃ݂Ȃ��A���ꉼ�z�t�H���_�̌�����ʂ�
            strURL = "mntSearchPerson.asp"
            Exit Do

        End If

        Exit Do
    Loop

    EditURLForReturning = strURL

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �l���e�l�̑Ó����`�F�b�N���s��
'
' �����@�@ :
'
' �߂�l�@ : �G���[�l������ꍇ�A�G���[���b�Z�[�W�̔z���Ԃ�
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CheckValue()

    Const LENGTH_PERSON_ROMENAME = 60
    Const LENGTH_TEL             = 15

    Dim strColumn        '���ږ�
    Dim vntArrMessage    '�G���[���b�Z�[�W�̏W��
    Dim strMessage        '�G���[���b�Z�[�W
    Dim i                '�C���f�b�N�X

    Set objCommon = Server.CreateObject("HainsCommon.Common")

    '�e�l�`�F�b�N����
    With objCommon

'## 2003.12.17 Mod By T.Takagi@FSIT No Check
'        '�J�i��
'        strMessage = .CheckWideValue("�J�i��", strLastKName,  LENGTH_PERSON_LASTKNAME, CHECK_NECESSARY)
'        If strMessage = "" Then
'            If .CheckKana(strLastKName) = False Then
'                strMessage = "�J�i���ɕs���ȕ������܂܂�܂��B"
'            End If
'        End If
'        .AppendArray vntArrMessage, strMessage
'
'        '�J�i��
'        strMessage = .CheckWideValue("�J�i��", strFirstKName,  LENGTH_PERSON_FIRSTKNAME)
'        If strMessage = "" Then
'            If .CheckKana(strFirstKName) = False Then
'                strMessage = "�J�i���ɕs���ȕ������܂܂�܂��B"
'            End If
'        End If
'        .AppendArray vntArrMessage, strMessage
'
'        '����
'        .AppendArray vntArrMessage, .CheckWideValue("��", strLastName,  LENGTH_PERSON_LASTNAME, CHECK_NECESSARY)
'        .AppendArray vntArrMessage, .CheckWideValue("��", strFirstName, LENGTH_PERSON_FIRSTNAME)
'
'        '���[�}����
'        .AppendArray vntArrMessage, .CheckNarrowValue("���[�}����", strRomeName, LENGTH_PERSON_ROMENAME)



'## 2015.03.04 �� ���[�}�������K�{���ڃ`�F�b�N�ǉ� START ###################################################

        '���[�}����
        .AppendArray vntArrMessage, .CheckNarrowValue("���[�}����", strRomeName, LENGTH_PERSON_ROMENAME)

        '���[�}����
        If left(strPerId, 1) <> "@" and strRomeName = "" Then
            .AppendArray vntArrMessage, "���[�}��������͂��ĉ������B"
        End If

'## 2015.03.04 �� ���[�}�������K�{���ڃ`�F�b�N�ǉ� END   ###################################################



        '�J�i��
        If strLastKName = "" Then
            .AppendArray vntArrMessage, "�J�i������͂��ĉ������B"
        End If

        '��
        If strLastName = "" Then
            .AppendArray vntArrMessage, "������͂��ĉ������B"
        End If
'## 2003.12.17 Mod End

        '����
        If strGender = "" Then
            .AppendArray vntArrMessage, "���ʂ���͂��ĉ������B"
        End If

        '���N����
        .AppendArray vntArrMessage, .CheckDate("���N����", strBirthYear, strBirthMonth, strBirthDay, strBirth, CHECK_NECESSARY)

'## 2004.03.24 Updated By T.Takagi@FSIT �����O�X�`�F�b�N�̂ݕ���
'## 2003.12.17 Del By T.Takagi@FSIT No Check
'       '�Z�����
'       For i = 0 To lngAddrCount - 1
'
'            '�㎖���͕\���݂̂Ȃ̂Ń`�F�b�N��Ώ�
'            If strAddrDiv(i) <> "4" Then
'
'                '�G���[���ɕ\�����邽�߂̍��ږ��ݒ�
'                Select Case strAddrDiv(i)
'                    Case "1"
'                        strColumn = "�i����j"
'                    Case "2"
'                        strColumn = "�i�Ζ���j"
'                    Case "3"
'                        strColumn = "�i���̑��j"
'                End Select
'
'                '�Z��
'                .AppendArray vntArrMessage, .CheckWideValue("�s�撬��" & strColumn, strCityName(i), LENGTH_CITYNAME)
'                .AppendArray vntArrMessage, .CheckWideValue("�Ԓn"     & strColumn, strAddress1(i), LENGTH_ADDRESS)
'                .AppendArray vntArrMessage, .CheckWideValue("����"     & strColumn, strAddress2(i), LENGTH_ADDRESS)
'
'                '�d�b�ԍ��P
'                .AppendArray vntArrMessage, .CheckNarrowValue("�d�b�ԍ��P" & strColumn, strTel(i), LENGTH_TEL)
'
'                '�g�єԍ�
'                .AppendArray vntArrMessage, .CheckNarrowValue("�g�єԍ�" & strColumn, strPhone(i), LENGTH_TEL)
'
'                '�d�b�ԍ��Q
'                .AppendArray vntArrMessage, .CheckNarrowValue("�d�b�ԍ��Q" & strColumn, strSubTel(i), LENGTH_TEL)
'
'                '����
'                .AppendArray vntArrMessage, .CheckNarrowValue("����" & strColumn, strExtension(i), LENGTH_PERSONDETAIL_EXTENSION)
'
'                '�e�`�w�ԍ�
'                .AppendArray vntArrMessage, .CheckNarrowValue("�e�`�w�ԍ�" & strColumn, strFax(i), LENGTH_TEL)
'
'                'E-Mail
'                strMessage = .CheckNarrowValue("E-Mail�A�h���X" & strColumn, strEMail(i), LENGTH_EMAIL)
'                If strMessage = "" Then
'                    strMessage = .CheckEMail("E-Mail�A�h���X" & strColumn, strEMail(i))
'                End If
'                .AppendArray vntArrMessage, strMessage
'
'            End If
'
'        Next
'## 2003.12.17 Del End
        '�Z�����
        For i = 0 To lngAddrCount - 1

            '�㎖���͕\���݂̂Ȃ̂Ń`�F�b�N��Ώ�
            If strAddrDiv(i) <> "4" Then

                '�G���[���ɕ\�����邽�߂̍��ږ��ݒ�
                Select Case strAddrDiv(i)
                    Case "1"
                        strColumn = "�i����j"
                    Case "2"
                        strColumn = "�i�Ζ���j"
                    Case "3"
                        strColumn = "�i���̑��j"
                End Select

                '�Z��
                .AppendArray vntArrMessage, .CheckLength("�s�撬��" & strColumn, strCityName(i), LENGTH_CITYNAME)
                .AppendArray vntArrMessage, .CheckLength("�Z���P"   & strColumn, strAddress1(i), LENGTH_ADDRESS)
                .AppendArray vntArrMessage, .CheckLength("�Z���Q"   & strColumn, strAddress2(i), LENGTH_ADDRESS)

                '�d�b�ԍ��P
                .AppendArray vntArrMessage, .CheckLength("�d�b�ԍ��P" & strColumn, strTel(i), LENGTH_TEL)

                '�g�єԍ�
                .AppendArray vntArrMessage, .CheckLength("�g�єԍ�" & strColumn, strPhone(i), LENGTH_TEL)

                '�d�b�ԍ��Q
                .AppendArray vntArrMessage, .CheckLength("�d�b�ԍ��Q" & strColumn, strSubTel(i), LENGTH_TEL)

                '����
                .AppendArray vntArrMessage, .CheckLength("����" & strColumn, strExtension(i), LENGTH_PERSONDETAIL_EXTENSION)

                '�e�`�w�ԍ�
                .AppendArray vntArrMessage, .CheckLength("�e�`�w�ԍ�" & strColumn, strFax(i), LENGTH_TEL)

                'E-Mail
                strMessage = .CheckNarrowValue("E-Mail�A�h���X" & strColumn, strEMail(i), LENGTH_EMAIL)
                If strMessage = "" Then
                    strMessage = .CheckEMail("E-Mail�A�h���X" & strColumn, strEMail(i))
                End If
                .AppendArray vntArrMessage, strMessage

            End If

        Next
'## 2004.03.24 Updated End

'## 2004.02.10 Add By T.Takagi@FSIT ��f�񐔂����݂��Ȃ�
        .AppendArray vntArrMessage, .CheckNumeric("��f��", strCslCount, 3)
'## 2004.02.10 Add End

        '�Z���ԍ�
        .AppendArray vntArrMessage, .CheckNarrowValue("�Z���ԍ�", strResidentNo, LENGTH_PERSONDETAIL_RESIDENTNO)

        '�g���ԍ�
        .AppendArray vntArrMessage, .CheckNarrowValue("�g���ԍ�", strUnionNo, LENGTH_PERSONDETAIL_UNIONNO)

        '�J���e�ԍ�
        .AppendArray vntArrMessage, .CheckNarrowValue("�J���e�ԍ�", strKarte, LENGTH_PERSONDETAIL_KARTE)

        '�ėp�L�[
        For i = 0 To UBound(strSpare)

            '�����񒷃`�F�b�N
            .AppendArray vntArrMessage, .CheckLength(strSpareName(i), strSpare(i), IIf(i < 2, LENGTH_PERSON_SPARE, LENGTH_PERSONDETAIL_SPARE))

        Next

        '���L����
        strMessage = .CheckWideValue("���L����", strNotes, LENGTH_PERSONDETAIL_NOTES)

        '���s������1���Ƃ��Ċ܂ގ|��ʒB
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "�i���s�������܂݂܂��j"
        End If

    End With

    Set objCommon = Nothing

    '�߂�l�̕ҏW
    If IsArray(vntArrMessage) Then
        CheckValue = vntArrMessage
    End If

End Function
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �폜�R�[�h�E�폜�t���O���̂̔z��쐬
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub CreateDelFlgInfo()

    Redim Preserve strArrDelFlg(1)
    Redim Preserve strArrDelFlgName(1)

    strArrDelFlg(0) = "0":strArrDelFlgName(0) = "�g�p��"
    strArrDelFlg(1) = "1":strArrDelFlgName(1) = "�폜�ς�"

End Sub

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �P�N�ڂ͂������Đ�R�[�h�E���̂̔z��쐬
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub CreatePostCardAddrInfo()

'### 2004/1/30 Modified by Ishihara@FSIT �P�N�ڂ͂������Đ�ɂ�NULL�������ł�����
'   Redim Preserve strArrPostCardAddr(2)
'   Redim Preserve strArrPostCardAddrName(2)
    Redim Preserve strArrPostCardAddr(3)
    Redim Preserve strArrPostCardAddrName(3)
'### 2004/1/30 Modified End

    strArrPostCardAddr(0) = "1":strArrPostCardAddrName(0) = "�Z���i����j"
    strArrPostCardAddr(1) = "2":strArrPostCardAddrName(1) = "�Z���i�Ζ���j"
    strArrPostCardAddr(2) = "3":strArrPostCardAddrName(2) = "�Z���i���̑��j"
'### 2004/1/30 Modified by Ishihara@FSIT �P�N�ڂ͂������Đ�ɂ�NULL�������ł�����
    strArrPostCardAddr(3) = "" :strArrPostCardAddrName(3) = "�Ȃ�"
'### 2004/1/30 Modified End

End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�l��񃁃��e�i���X</TITLE>
<!-- #include virtual = "/webHains/includes/orgGuide.inc"  -->
<!-- #include virtual = "/webHains/includes/perGuide.inc"  -->
<!-- #include virtual = "/webHains/includes/zipGuide.inc"  -->
<SCRIPT TYPE="text/javascript">
<!--
// �X�֔ԍ��K�C�h�Ăяo��
function callZipGuide( index ) {
    var objForm = document.perdata;
    zipGuide_showGuideZip(objForm.prefCd[ index ].value, objForm.zipCd[ index ], objForm.prefCd[ index ], objForm.cityName[ index ], objForm.address1[ index ] );
}

// �X�֔ԍ��̃N���A
function clearZipInfo( index ) {
    zipGuide_clearZipInfo( document.perdata.zipCd[ index ] );
}

// �l�h�c�t���ւ��y�[�W�Ăяo��
function ChangePerID() {

    var Url = '/webHains/contents/maintenance/personal/mntChangePerID.asp';
    Url = Url + '?fromPerID=<%= strPerID %>&lastname=<%= Server.UrlEncode(strLastName) %>&firstname=<%= Server.UrlEncode(strFirstName) %>';
    winUpdateProgress = window.open(Url , '', 'width=450,height=200,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no');
}

// �c�̌����K�C�h�Ăяo��
function callOrgGuide( index ) {

    var url = '/webHains/contents/guide/gdeOrganization.asp?dispMode=1';    // �c�̌����K�C�h��ʂ�URL

    // �K�C�h��ʂƂ̘A������g�p���ď���������s��
    var objForm = document.perdata;
    orgGuide_ZipCd     = objForm.zipCd[ index ];
    orgGuide_PrefCd    = objForm.prefCd[ index ];
    orgGuide_CityName  = objForm.cityName[ index ];
    orgGuide_Address1  = objForm.address1[ index ];
    orgGuide_Address2  = objForm.address2[ index ];
    orgGuide_DirectTel = objForm.directTel[ index ];
    orgGuide_Tel       = objForm.subtel[ index ];
    orgGuide_Extension = objForm.extension[ index ];
    orgGuide_Fax       = objForm.fax[ index ];
    orgGuide_EMail     = objForm.email[ index ];

    orgGuide_openWindow( url );

}

// 2004.02.17 Add by Ishihara@FSIT
// ������ID�̖����I�ȕ\��
function editCompPerID_OnClose() {
    
    document.getElementById( 'dispCompID' ).innerHTML = document.perdata.compPerId.value;
}

// 2004.02.17 Add by Ishihara@FSIT
// ������ID�̖����I�ȕ\��
function editCompPerID_Clear() {
    
    perGuide_clearPerInfo(document.perdata.compPerId, 'compName')
    document.getElementById( 'dispCompID' ).innerHTML = document.perdata.compPerId.value;
}

function saveData() {
    document.perdata.submit();
}

function deleteData() {

    if ( !confirm( '���̌l�����폜���܂��B��낵���ł����H' ) ) {
        return;
    }

    // ���[�h���w�肵��submit
    document.perdata.act.value = 'delete';
    document.perdata.submit();

}

// �T�u��ʂ����
function closeWindow() {
    orgGuide_closeGuideOrg();
    zipGuide_closeGuideZip();
}

// '2004.06.01 ADD STR ORB)T.YAGUCHI
// �㎖���𕡎ʂ���
function hopeDataCopy() {

    var objForm = document.perdata;
    var s1,s2,s3;

<%
    Set objCommon = Server.CreateObject("HainsCommon.Common")
%>

    s1=objForm.medName.value;
    if ( s1.indexOf('�@')>=0 ) {
        s2 = s1.substring(0, s1.indexOf('�@'));
        s3 = s1.substring(s1.indexOf('�@') + 1);
        objForm.lastname.value = s2;
        objForm.firstname.value = s3;
    } else {
        objForm.lastname.value = s1;
        objForm.firstname.value = '';
    }

    <% '#### 2010.06.11 SL-UI-Y0101-109 ADD START #### %>
    s1=objForm.medRName.value;
    if ( s1.indexOf('�@')>=0 ) {
        s2 = s1.substring(0, s1.indexOf('�@'));
        s3 = s1.substring(s1.indexOf('�@') + 1);
        objForm.lastkname.value     = s2;
        objForm.firstkname.value    = s3;
    } else {
        objForm.lastkname.value     = s1;
        objForm.firstkname.value    = '';
    }
    <% '#### 2010.06.11 SL-UI-Y0101-109 ADD END   #### %>

    <% '#### 2010.06.11 SL-UI-Y0101-109 DEL START #### %>
    // objForm.romeName.value = objForm.medRName.value;
    <% '#### 2010.06.11 SL-UI-Y0101-109 DEL END   #### %>
    objForm.gender.value        = objForm.medGender.value;
    objForm.byear.value         = '<%= objCommon.FormatString(strMedBirth, "ge") %>';
    objForm.bmonth.value        = '<%= objCommon.FormatString(strMedBirth, "m") %>';
    objForm.bday.value          = '<%= objCommon.FormatString(strMedBirth, "d") %>';

    objForm.zipCd[0].value      = objForm.zipCd[1].value;
    objForm.cityName[0].value   = objForm.cityName[1].value;
    objForm.address1[0].value   = objForm.address1[1].value;
    objForm.address2[0].value   = objForm.address2[1].value;
    objForm.directTel[0].value  = objForm.directTel[1].value;
    objForm.phone[0].value      = objForm.phone[1].value;
    objForm.subtel[0].value     = objForm.subtel[1].value;
    objForm.extension[0].value  = objForm.extension[1].value;
    objForm.fax[0].value        = objForm.fax[1].value;
    objForm.email[0].value      = objForm.email[1].value;

<%
    Set objCommon = Nothing
%>

}
// '2004.06.01 ADD END

//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.mnttab { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="perdata" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<BLOCKQUOTE>
<INPUT TYPE="hidden" NAME="mode"   VALUE="<%= strMode %>">
<INPUT TYPE="hidden" NAME="act"    VALUE="save">
<INPUT TYPE="hidden" NAME="target" VALUE="<%= strTarget %>">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
    <TR>
        <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">��</SPAN><FONT COLOR="#000000">�l��񃁃��e�i���X</FONT></B></TD>
    </TR>
</TABLE>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="3" WIDTH="650">
    <TR>
        <TD WIDTH="100%"></TD>
        <TD><A HREF="<%= EditURLForReturning() %>"><IMG SRC="../../../images/back.gif" WIDTH="77" HEIGHT="24" ALT="������ʂɖ߂�܂�"></A></TD>
        <TD><A HREF="mntPerInspection.asp?perId=<%= strPerID %>"><IMG SRC="../../../images/insinfo_b.gif" WIDTH="77" HEIGHT="24" ALT="�l���������C�����܂�"></A></TD>
        
        <TD>
        <% '2005.08.22 �����Ǘ� Add by ���@--- START %>
        <%  if Session("PAGEGRANT") = "3" or Session("PAGEGRANT") = "4" then   %>
            <A HREF="javascript:deleteData()"><IMG SRC="../../../images/delete.gif" WIDTH="77" HEIGHT="24" ALT="���̌l�����폜���܂�"></A>

        <%  end if  %>
        <% '2005.08.22 �����Ǘ� Add by ���@--- END %>
        </TD>
        
        <%  if Session("PAGEGRANT") = "3" or Session("PAGEGRANT") = "4" then   %>
            <TD><A HREF="/webHains/contents/maintenance/personal/mntPersonal.asp?mode=insert"><IMG SRC="../../../images/newrsv.gif" WIDTH="77" HEIGHT="24" ALT="�V�K�o�^���܂�"></A></TD>
        <% End If  %>


        <% '2005.08.22 �����Ǘ� Add by ���@--- START %>
        <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
        <TD>
            <A HREF="javascript:saveData()"><IMG SRC="../../../images/save.gif" WIDTH="77" HEIGHT="24" ALT="���͂����f�[�^��ۑ����܂�"></A>    
        </TD>
    
        <TD><A HREF="javascript:ChangePerID()"><IMG SRC="../../../images/idChange.gif" WIDTH="77" HEIGHT="24" ALT="�l�h�c�t���ւ�"></A></TD>

        <%  else    %>
             &nbsp;
        <%  end if  %>
        <% '2005.08.22 �����Ǘ� Add by ���@--- END %>

    </TR>
</TABLE>
<BR>
<%
    '���b�Z�[�W�̕ҏW
    Select Case strAction

        Case ""

        '�ۑ��������́u�ۑ������v�̒ʒm
        Case "saveend"
            Call EditMessage("�ۑ����������܂����B", MESSAGETYPE_NORMAL)

        '�폜�������́u�폜�����v�̒ʒm
        Case "deleteend"
            Call EditMessage("�폜���������܂����B", MESSAGETYPE_NORMAL)

        '�����Ȃ��΃G���[���b�Z�[�W��ҏW
        Case Else
            Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)

    End Select
%>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
    <TR>
        <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�l�h�c</TD>
        <TD NOWRAP><INPUT TYPE="hidden" NAME="perid" VALUE="<%= strPerID %>"><INPUT TYPE="hidden" NAME="vidflg" VALUE="0"><%= strPerID %></TD>
    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right">�t���K�i</TD>
        <TD>
            <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                <TR>
                    <TD>��&nbsp;</TD>
                    <TD><INPUT TYPE="text" NAME="lastkname"  SIZE="50" MAXLENGTH="25" VALUE="<%= strLastKName  %>" STYLE="ime-mode:active;"></TD>
                    <TD>&nbsp;��&nbsp;</TD>
                    <TD><INPUT TYPE="text" NAME="firstkname" SIZE="50" MAXLENGTH="25" VALUE="<%= strFirstKName %>" STYLE="ime-mode:active;"></TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right">���O</TD>
        <TD>
            <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                <TR>
                    <TD>��&nbsp;</TD>
                    <TD><INPUT TYPE="text" NAME="lastname"  SIZE="50" MAXLENGTH="25" VALUE="<%= strLastName  %>" STYLE="ime-mode:active;"></TD>
                    <TD>&nbsp;��&nbsp;</TD>
                    <TD><INPUT TYPE="text" NAME="firstname" SIZE="50" MAXLENGTH="25" VALUE="<%= strFirstName %>" STYLE="ime-mode:active;"></TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right">���[�}����</td>
        <TD><INPUT TYPE="text" NAME="romeName" SIZE="111" MAXLENGTH="60" VALUE="<%= strRomeName %>" STYLE="ime-mode:disabled;width:627px;"></TD>
    <TR>
        <TD HEIGHT="10"></TD>
    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right">����</TD>
        <TD><%= EditDropDownListFromArray("gender", strArrGender, strArrGenderName, strGender, IIf(strMode = "insert", NON_SELECTED_ADD, NON_SELECTED_DEL)) %></TD>
    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right">���N����</TD>
<%
        '�N�����̌`�����쐬����
        strSelectedDate = strBirthYear & "/" & strBirthMonth & "/" & strBirthDay

        '���t�F���s�\���͌��������̂܂܊֐��ɓn��
        If Not IsDate(strSelectedDate) Then
            strSelectedDate = strBirthYear
        End If
%>
        <TD>
            <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                <TR>
                    <TD><%= EditEraYearList("byear", strSelectedDate, (strMode = "insert")) %></TD>
                    <TD>&nbsp;�N&nbsp;</TD>
                    <TD><%= EditSelectNumberList("bmonth", 1, 12, CLng("0" & strBirthMonth)) %></TD>
                    <TD>&nbsp;��&nbsp;</TD>
                    <TD><%= EditSelectNumberList("bday",   1, 31, CLng("0" & strBirthDay  )) %></TD>
                    <TD>&nbsp;��</TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
    <TR>
        <TD HEIGHT="10"></TD>
    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right">�g�p���</TD>
        <TD><%= EditDropDownListFromArray("delFlg", strArrDelFlg, strArrDelFlgName, strDelFlg, NON_SELECTED_DEL) %></TD>
    </TR>
    <TR>
        <TD HEIGHT="10"></TD>
    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right" NOWRAP>�����Җ�</TD>
        <TD>
            <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
                <TR>
                
                    <TD><A HREF="javascript:perGuide_showGuidePersonal(document.perdata.compPerId, 'compName', null, editCompPerID_OnClose)"><IMG SRC="../../../images/question.gif" ALT="�l�����K�C�h��\��" HEIGHT="21" WIDTH="21"></A></TD>
                    <!-- 2004.02.17 Mod by Ishihara@FSIT -->
<!--                    <TD><A HREF="javascript:perGuide_clearPerInfo(document.perdata.compPerId, 'compName')"><IMG SRC="../../../images/delicon.gif" ALT="�ݒ肵���l���N���A" HEIGHT="21" WIDTH="21"></TD>-->
                    <TD><A HREF="javascript:editCompPerID_Clear()"><IMG SRC="../../../images/delicon.gif" ALT="�ݒ肵���l���N���A" HEIGHT="21" WIDTH="21"></TD>
                    <TD>
                        <INPUT TYPE="hidden" NAME="compPerId" VALUE="<%= strCompPerId %>">
                        <SPAN ID="compName"><%= strCompName %></SPAN>
                    </TD>
                    <!-- 2004.02.17 Added by Ishihara@FSIT -->
                    <TD WIDTH="5"></TD>
                    <TD>
                        <FONT COLOR="#999999"><SPAN ID="dispCompID"><%= strCompPerId %></SPAN></FONT>
                    </TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
    <TR>
        <TD HEIGHT="10"></TD>
    </TR>
    <TR>
        <% '2004.06.01 ADD STR ORB)T.YAGUCHI %>
        <!--<TD>�㎖���</TD>-->
        <!--<TD>�㎖���</TD><TD><IMG SRC="../../../images/spacer.gif" WIDTH="30" HEIGHT="1" ALT=""></TD><TD><IMG SRC="../../../images/hopeCopy.gif" WIDTH="120" HEIGHT="24" ALT=""></TD>-->
        
        <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
            <TD>�㎖���</TD><TD><IMG SRC="../../../images/spacer.gif" WIDTH="200" HEIGHT="1" ALT=""><A HREF="javascript:hopeDataCopy()"><IMG SRC="../../../images/hopeCopy.gif" WIDTH="120" HEIGHT="24" ALT=""></A></TD>
            <% '2004.06.01 ADD END %>
        <%  end if  %>

    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right" NOWRAP>��������</TD>
        <TD><INPUT TYPE="hidden" NAME="medName" VALUE="<%= strMedName %>"><%= strMedName %></TD>
    </TR>
    <TR>
        <% '#### 2010.06.11 SL-UI-Y0101-109 ADD START #### %>
        <TD BGCOLOR="#eeeeee" ALIGN="right" NOWRAP>�J�i����</TD>
        <% '#### 2010.06.11 SL-UI-Y0101-109 ADD END   #### %>
        <% '#### 2010.06.11 SL-UI-Y0101-109 DEL START #### %>
        <!-- <TD BGCOLOR="#eeeeee" ALIGN="right" NOWRAP>���[�}����</TD> -->
        <% '#### 2010.06.11 SL-UI-Y0101-109 DEL END   #### %>
        <TD><INPUT TYPE="hidden" NAME="medRName" VALUE="<%= strMedRName %>"><%= strMedRName %></TD>
    </TR>
<%
    Set objCommon = Server.CreateObject("HainsCommon.Common")
%>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right" NOWRAP>���N����</TD>
        <TD><INPUT TYPE="hidden" NAME="medBirth" VALUE="<%= strMedBirth %>"><%= objCommon.FormatString(strMedBirth, "ggge(yyyy)�Nm��d��") %></TD>
    </TR>
<%
    Set objCommon = Nothing

    Select Case strMedGender
        Case CStr(GENDER_MALE)
            strBuffer = "�j��"
        Case CStr(GENDER_FEMALE)
            strBuffer = "����"
        Case Else
            strBuffer = ""
    End Select
%>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right" NOWRAP>����</TD>
        <TD><INPUT TYPE="hidden" NAME="medGender" VALUE="<%= strMedGender %>"><%= strBuffer %></TD>
    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right" NOWRAP>�X�V����</TD>
        <TD><INPUT TYPE="hidden" NAME="medUpdDate" VALUE="<%= strMedUpdDate %>"><%= strMedUpdDate %></TD>
    </TR>
    <TR>
        <TD HEIGHT="10"></TD>
    </TR>
<%
    '�l�Z�����̕ҏW�J�n
    For j = 0 To 3

        '�ҏW�p�ϐ��̏�����
        strEditTel       = ""
        strEditExtension = ""
        strEditSubTel    = ""
        strEditFax       = ""
        strEditPhone     = ""
        strEditEMail     = ""
        strEditZipCd     = ""
        strEditPrefCd    = ""
        strEditCityName  = ""
        strEditAddress1  = ""
        strEditAddress2  = ""

        '�����p�̏Z���敪��ݒ�
        Select Case j
            Case 0
                strEditAddrDiv = "1"
            Case 1
                strEditAddrDiv = "4"
            Case 2
                strEditAddrDiv = "2"
            Case 3
                strEditAddrDiv = "3"
        End Select

        '�ǂݍ��񂾌l�Z����񂩂�ҏW���ׂ��Z���敪������
        For i = 0 To lngAddrCount - 1
            If strAddrDiv(i) = strEditAddrDiv Then
                strEditTel       = strTel(i)
                strEditExtension = strExtension(i)
                strEditSubTel    = strSubTel(i)
                strEditFax       = strFax(i)
                strEditPhone     = strPhone(i)
                strEditEMail     = strEMail(i)
                strEditZipCd     = strZipCd(i)
                strEditPrefCd    = strPrefCd(i)
                strEditCityName  = strCityName(i)
                strEditAddress1  = strAddress1(i)
                strEditAddress2  = strAddress2(i)
                Exit For
            End If
        Next
%>
        <TR>
<%
            Select Case j

                Case 0
%>
                    <TD>�Z���i����j</TD>
<%
                Case 1
%>
                    <TD>�Z���i�㎖�j</TD>
<%
                Case 2
%>
                    <TD>�Z���i�Ζ���j</TD>
                    <TD><A HREF="javascript:callOrgGuide(<%= j %>)">�c�̏Z������</A></TD>
<%
                Case 3
%>
                    <TD>�Z���i���̑��j</TD>
<%
            End Select
%>
        </TR>
<%
        '�㎖�Z���ȊO�͓��͌`���ŕҏW
        If j <> 1 Then
%>
            <TR>
                <TD BGCOLOR="#eeeeee" ALIGN="right"><INPUT TYPE="hidden" NAME="addrDiv" VALUE="<%= strEditAddrDiv %>">�X�֔ԍ�</TD>
                <TD>
                    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
                        <TD><A HREF="javascript:callZipGuide(<%= j %>)"><IMG SRC="../../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="�X�֔ԍ��K�C�h�\��"></A></TD>
                        <TD><A HREF="javascript:clearZipInfo(<%= j %>)"><IMG SRC="../../../images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�X�֔ԍ����폜���܂�"></A></TD>
                        <TD><INPUT TYPE="text" NAME="zipCd" VALUE="<%= strEditZipCd %>" SIZE="9" MAXLENGTH="7" STYLE="ime-mode:disabled;"></TD>
                    </TABLE>
                </TD>
            </TR>
            <TR>
                <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�s���{��</TD>
                <TD><%= EditPrefList("prefCd", strEditPrefCd) %></TD>
            </TR>
            <TR>
                <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�s�撬��</TD>
                <TD><INPUT TYPE="text" NAME="cityName" SIZE="65" MAXLENGTH="50" VALUE="<%= strEditCityName %>" STYLE="ime-mode:active;"></TD>
            </TR>
            <TR>
                <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�Z���P</TD>
                <TD><INPUT TYPE="text" NAME="address1" SIZE="78" MAXLENGTH="60" VALUE="<%= strEditAddress1 %>" STYLE="ime-mode:active;"></TD>
            </TR>
            <TR>
                <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�Z���Q</TD>
                <TD><INPUT TYPE="text" NAME="address2" SIZE="78" MAXLENGTH="60" VALUE="<%= strEditAddress2 %>" STYLE="ime-mode:active;"></TD>
            </TR>
            <TR>
                <TD HEIGHT="10"></TD>
            </TR>
            <TR>
                <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�d�b�ԍ��P</TD>
                <TD><INPUT TYPE="text" NAME="directTel" SIZE="19" MAXLENGTH="15" VALUE="<%= strEditTel %>" STYLE="ime-mode:disabled;"></TD>
            </TR>
            <TR>
                <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�g�єԍ�</TD>
                <TD><INPUT TYPE="text" NAME="phone" SIZE="19" MAXLENGTH="15" VALUE="<%= strEditPhone %>" STYLE="ime-mode:disabled;"></TD>
            </TR>
            <TR>
                <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�d�b�ԍ��Q</TD>
                <TD>
                    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                        <TR>
                            <TD><INPUT TYPE="text" NAME="subtel" SIZE="19" MAXLENGTH="15" VALUE="<%= strEditSubTel %>" STYLE="ime-mode:disabled;"></TD>
                            <TD><IMG SRC="../../../images/spacer.gif" WIDTH="50" HEIGHT="1" ALT=""></TD>
                            <TD>����</TD>
                            <TD>�F&nbsp;</TD>
                            <TD><INPUT TYPE="text" NAME="extension" SIZE="15" MAXLENGTH="10" VALUE="<%= strEditExtension %>" STYLE="ime-mode:disabled;"></TD>
                        </TR>
                    </TABLE>
                </TD>
            </TR>
            <TR>
                <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">FAX�ԍ�</TD>
                <TD><INPUT TYPE="text" NAME="fax" SIZE="19" MAXLENGTH="15" VALUE="<%= strEditFax %>" STYLE="ime-mode:disabled;"></TD>
            </TR>
            <TR>
                <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">E-mail�A�h���X</TD>
                <TD><INPUT TYPE="text" NAME="email" SIZE="52" MAXLENGTH="40" VALUE="<%= strEditEmail %>" STYLE="ime-mode:disabled;"></TD>
            </TR>
            <TR>
                <TD HEIGHT="10"></TD>
            </TR>
<%
        Else

            '�s���{�����ǂݍ���
            Set objPref = Server.CreateObject("HainsPref.Pref")
            objPref.SelectPref strEditPrefCd, strPrefName
            Set objPref = Nothing
%>
            <TR>
                <TD BGCOLOR="#eeeeee" ALIGN="right"><INPUT TYPE="hidden" NAME="addrDiv" VALUE="<%= strEditAddrDiv %>">�X�֔ԍ�</TD>
                <TD><INPUT TYPE="hidden" NAME="zipCd" VALUE="<%= strEditZipCd %>"><%= strEditZipCd %></TD>
            </TR>
            <TR>
                <TD BGCOLOR="#eeeeee" ALIGN="right">�s���{��</TD>
                <TD><INPUT TYPE="hidden" NAME="prefCd" VALUE="<%= strEditPrefCd %>"><%= strPrefName %></TD>
            </TR>
            <TR>
                <TD BGCOLOR="#eeeeee" ALIGN="right">�s�撬��</TD>
                <TD><INPUT TYPE="hidden" NAME="cityName" VALUE="<%= strEditCityName %>"><%= strEditCityName %></TD>
            </TR>
            <TR>
                <TD BGCOLOR="#eeeeee" ALIGN="right">�Z���P</TD>
                <TD><INPUT TYPE="hidden" NAME="address1" VALUE="<%= strEditAddress1 %>"><%= strEditAddress1 %></TD>
            </TR>
            <TR>
                <TD BGCOLOR="#eeeeee" ALIGN="right">�Z���Q</TD>
                <TD><INPUT TYPE="hidden" NAME="address2" VALUE="<%= strEditAddress2 %>"><%= strEditAddress2 %></TD>
            </TR>
            <TR>
                <TD HEIGHT="10"></TD>
            </TR>
            <TR>
                <TD BGCOLOR="#eeeeee" ALIGN="right">�d�b�ԍ��P</TD>
                <TD><INPUT TYPE="hidden" NAME="directTel" VALUE="<%= strEditTel %>"><%= strEditTel %></TD>
            </TR>
            <TR>
                <TD BGCOLOR="#eeeeee" ALIGN="right">�g�єԍ�</TD>
                <TD><INPUT TYPE="hidden" NAME="phone" VALUE="<%= strEditPhone %>"><%= strEditPhone %></TD>
            </TR>
            <TR>
                <TD BGCOLOR="#eeeeee" ALIGN="right">�d�b�ԍ��Q</TD>
                <TD><INPUT TYPE="hidden" NAME="subtel" VALUE="<%= strEditSubTel %>"><INPUT TYPE="hidden" NAME="extension" VALUE="<%= strEditExtension %>">
                    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                        <TR>
                            <TD><%= strEditSubTel %></TD>
                            <TD><IMG SRC="../../../images/spacer.gif" WIDTH="50" HEIGHT="1" ALT=""></TD>
                            <TD>����</TD>
                            <TD>�F&nbsp;</TD>
                            <TD><%= strEditExtension %></TD>
                        </TR>
                    </TABLE>
                </TD>
            </TR>
            <TR>
                <TD BGCOLOR="#eeeeee" ALIGN="right">FAX�ԍ�</TD>
                <TD><INPUT TYPE="hidden" NAME="fax" VALUE="<%= strEditFax %>"><%= strEditFax %></TD>
            </TR>
            <TR>
                <TD BGCOLOR="#eeeeee" ALIGN="right">E-mail�A�h���X</TD>
                <TD><INPUT TYPE="hidden" NAME="email" VALUE="<%= strEditEmail %>"><%= strEditEmail %></TD>
            </TR>
            <TR>
                <TD HEIGHT="10"></TD>
            </TR>
<%
        End If

    Next
%>
    <TR>
        <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right" NOWRAP>����i��N�ڂ̂͂����j</TD>
        <TD><%= EditDropDownListFromArray("postcardaddr", strArrPostCardAddr, strArrPostCardAddrName, strPostCardAddr, NON_SELECTED_DEL) %></TD>
    </TR>
    <TR>
        <TD HEIGHT="10"></TD>
    </TR>
    <TR>
        <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�����敪</TD>
        <TD>
<%
            Set objCommon = Server.CreateObject("HainsCommon.Common")

            '�������̓ǂݍ���
            If objCommon.SelectMarriageList(strArrMarriage, strArrMarriageName) > 0 Then
%>
                <%= EditDropDownListFromArray("marriage", strArrMarriage, strArrMarriageName, strMarriage, NON_SELECTED_ADD) %>
<%
            End If

            Set objCommon = Nothing
%>
        </TD>
    </TR>
        <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">����</TD>
        <TD><INPUT TYPE="text" NAME="maidenname"  SIZE="41" MAXLENGTH="16" VALUE="<%= strMaidenName %>" STYLE="ime-mode:active;"></TD>
    <TR>
        <TD HEIGHT="10"></TD>
    </TR>
<!-- 2004.02.10 Add By T.Takagi@FSIT ��f�񐔂����݂��Ȃ� -->
    </TR>
        <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">��f��</TD>
        <TD><INPUT TYPE="text" NAME="cslCount" SIZE="3" MAXLENGTH="3" VALUE="<%= strCslCount %>" STYLE="ime-mode:disabled;"></TD>
    <TR>
    <TR>
        <TD HEIGHT="10"></TD>
    </TR>
<!-- 2004.02.10 Add End -->
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right">����</TD>
<%
        '�ėp�e�[�u�������f�敪��ǂݍ���
        Set objFree = Server.CreateObject("HainsFree.Free")
        objFree.SelectFree 1, "NATION", strFreeCd, , , strFreeField1
        Set objFree = Nothing
%>
        <TD><%= EditDropDownListFromArray("nationcd", strFreeCd, strFreeField1, strNationCd, NON_SELECTED_ADD) %></TD>
    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right">�Z���ԍ�</TD>
        <TD><INPUT TYPE="text" NAME="residentno" SIZE="19" MAXLENGTH="15" VALUE="<%= strResidentNo %>" STYLE="ime-mode:disabled;"></TD>
    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right">�g���ԍ�</TD>
        <TD><INPUT TYPE="text" NAME="unionno" SIZE="19" MAXLENGTH="15" VALUE="<%= strUnionNo %>" STYLE="ime-mode:disabled;"></TD>
    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right">�J���e�ԍ�</TD>
        <TD><INPUT TYPE="text" NAME="karte" SIZE="19" MAXLENGTH="15" VALUE="<%= strKarte %>" STYLE="ime-mode:disabled;"></TD>
    </TR>
<%
    For i = 0 To UBound(strSpare)
%>
        <TR>
            <TD BGCOLOR="#eeeeee" ALIGN="right"><%= strSpareName(i) %></TD>
            <TD><INPUT TYPE="text" NAME="spare<%= (i + 1) %>" SIZE="<%= IIf(i <= 1, "20", "26") %>" MAXLENGTH="<%= IIf(i <= 1, "16", "20") %>" VALUE="<%= strSpare(i) %>" STYLE="ime-mode:active;"></TD>
        </TR>
<%
    Next
%>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right">���L����</TD>
        <TD><TEXTAREA NAME="notes" COLS="50" ROWS="2" STYLE="ime-mode:active;"><%= strNotes %></TEXTAREA></TD>
    </TR>
    <TR>
        <TD HEIGHT="10"></TD>
    </TR>
    <TR>
        <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�X�V����</TD>
        <TD><INPUT TYPE="hidden" NAME="upddate" VALUE="<%= strUpdDate %>"><%= strUpdDate %></TD>
    </TR>
    <TR>
        <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�X�V��</TD>
<%
        '���[�U���ǂݍ���
        If strUpdUser <> "" Then
            Set objHainsUser = Server.CreateObject("HainsHainsUser.HainsUser")
            objHainsUser.SelectHainsUser strUpdUser, strUserName
            Set objHainsUser = Nothing
        End If
%>
        <TD><%= strUserName %></TD>
    </TR>
</TABLE>
</BLOCKQUOTE>
</FORM>
<%
If strAction = "saveend" Then
%>
<SCRIPT TYPE="text/javascript">
<!--
// �Ăь�(��f���ڍ�)��ʂɏ���n�����߂̌l���N���X��`
function Person() {

    this.perId       = '';    // �l�h�c
    this.lastName    = '';    // ��
    this.firstName   = '';    // ��
    this.lastKName   = '';    // �J�i��
    this.firstKName  = '';    // �J�i��
    this.birth       = '';    // ���N����
    this.birthFull   = '';    // ���N����(�a��{����)
    this.gender      = '';    // ����

    this.address = new Array(3);    // �Z��

}

for ( ; ; ) {

    // �Ăь���ʎ��́A�܂��͌Ăь���ʂ̌l���ҏW�֐������݂��Ȃ��ꍇ�͉������Ȃ�
    if ( !opener ) break;

    if ( !opener.setPersonInfo ) break;

    var myForm  = document.perdata;
    var perInfo = new Person();
    var address, zipCd, prefName;

    // �Ăь���ʂɒl��n�����߂̃N���X�v�f��ҏW
    perInfo.perId       = myForm.perid.value;           // �lID
    perInfo.lastName    = myForm.lastname.value;        // ��
    perInfo.firstName   = myForm.firstname.value;       // ��
    perInfo.lastKName   = myForm.lastkname.value;       // �J�i��
    perInfo.firstKName  = myForm.firstkname.value;      // �J�i��
    perInfo.birth       = '<%= strBirth %>';            // ���N����
    perInfo.gender      = myForm.gender.value;          // ����
<%
    Set objCommon = Server.CreateObject("HainsCommon.Common")
%>
    perInfo.birthFull   = '<%= objCommon.FormatString(strBirth, "ge�iyyyy�j.m.d") %>';    // ���N����(�a��{����)
<%
    Set objCommon = Nothing
%>
    for ( var i = 0, j = 0; i < myForm.zipCd.length; i++ ) {

        // �㎖���̓X�L�b�v
        if ( i == 1 ) continue;

        // �X�֔ԍ��𕪊����ĕҏW
        zipCd = myForm.zipCd[ i ].value;
        address = zipCd.substring(0, 3);
        if ( zipCd.length > 3 ) {
            address = address + '-' + zipCd.substring(3, zipCd.length);
        }

        prefName = myForm.prefCd[ i ].options[ myForm.prefCd[ i ].selectedIndex ].text;
        if ( prefName != '' ) {
            address = address + ( address != '' ? '�@' : '' ) + prefName;
        }

        address = address + myForm.cityName[ i ].value + myForm.address1[ i ].value + myForm.address2[ i ].value;
        perInfo.address[ j ] = address;

        j++;
    }

    opener.setPersonInfo( perInfo, true );
    break;

}
//-->
</SCRIPT>
<%
End If
%>
</BODY>
</HTML>
