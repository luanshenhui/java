<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'        �l�����K�C�h(�e��ʂւ̌l���ҏW) (Ver0.0.1)
'        AUTHER  : Tsutomu Takagi@FSIT
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon           '���ʃN���X
Dim objConsult          '��f���A�N�Z�X�p
Dim objFree             '�ėp���A�N�Z�X�p
Dim objPerson           '�l���A�N�Z�X�p

'�����l
Dim strPerId            '�l�h�c
Dim strRsvNo            '�\��ԍ�

'�l���
Dim strLastName         '��
Dim strFirstName        '��
Dim strLastKName        '�J�i��
Dim strFirstKName       '�J�i��
Dim strBirth            '���N����
Dim strGender           '����
Dim strOrgCd1           '�����c�̃R�[�h�P
Dim strOrgCd2           '�����c�̃R�[�h�Q
Dim strOrgName          '�c�̊�������
Dim strOrgSName         '�c�̗���
Dim strOrgPostName      '��������
Dim strEmpNo            '�]�ƈ��ԍ�
Dim strJobName          '�E��
Dim strAge              '�N��
'## 2003.12.12 Add By T.Takagi@FSIT ���h�c�t���O��Ԃ�
Dim strVidFlg           '���h�c�t���O
'## 2003.12.12 Add End
'## 2005.03.09 Add By T.Takagi@FSIT web�\���荞��(���[�}�����ǉ�)
Dim strRomeName         '���[�}����
'## 2005.03.09 Add End

'�l�Z�����
Dim strAddrDiv          '�Z���敪
Dim strZipCd            '�X�֔ԍ�
Dim strPrefCd           '�s���{���R�[�h
Dim strPrefName         '�s���{����
Dim strCityName         '�s�撬����
Dim strAddress1         '�Z���P
Dim strAddress2         '�Z���Q
Dim strTel1             '�d�b�ԍ��P
Dim strPhone            '�g��
Dim strTel2             '�d�b�ԍ��Q
Dim strExtension        '�����P
Dim strFax              '�e�`�w
Dim strEMail            'e-Mail
'### 2016.09.16 �� �l���̓��L�����\���ǉ� STR ###
Dim strNotes            '���L����
'### 2016.09.16 �� �l���̓��L�����\���ǉ� END ###

'��f���
Dim strCsCd             '�R�[�X�R�[�h
Dim strLastOrgCd1       '�c�̃R�[�h�P
Dim strLastOrgCd2       '�c�̃R�[�h�Q
Dim strLastOrgName      '�c�̖���
Dim strCslDivCd         '��f�敪�R�[�h

'��f�t�����
Dim strCardAddrDiv      '�m�F�͂�������
Dim strFormAddrDiv      '�ꎮ��������
Dim strReportAddrDiv    '���я�����
Dim strVolunteer        '�{�����e�B�A
Dim strVolunteerName    '�{�����e�B�A��
Dim strIsrSign          '�ی��؋L��
Dim strIsrNo            '�ی��ؔԍ�
Dim strIsrManNo         '�ی��Ҕԍ�
'#### 2013.3.1 SL-SN-Y0101-612 ADD START ####
Dim strSendMailDiv      '�\��m�F���[�����M�@�\
'#### 2013.3.1 SL-SN-Y0101-612 ADD END   ####

Dim strPerName          '����
Dim strPerKName         '�J�i����
Dim strEraBirth         '�N��i�a��j
Dim strFullBirth        '�N��i�a��{����j
Dim strAddress          '�Z��
'### 2016.09.16 �� �d�b�ԍ��擾�E�ҏW�̈גǉ� STR ###
Dim strTel              '�d�b�ԍ�
'### 2016.09.16 �� �d�b�ԍ��擾�E�ҏW�̈גǉ� END ###
Dim i                   '�C���f�b�N�X

'## 2005.03.09 Add By T.Takagi@FSIT web�\���荞��(�Z���g��)
Dim lngIndex                '�C���f�b�N�X
'## 2005.03.09 Add End

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon = Server.CreateObject("HainsCommon.Common")
Set objFree   = Server.CreateObject("HainsFree.Free")
Set objPerson = Server.CreateObject("HainsPerson.Person")

'�����l�̎擾
strPerId = Request("perId")
strRsvNo = Request("rsvNo")

'�l�h�c�����݂���ꍇ
If strPerId <> "" Then

    '�l���ǂݍ���
'## 2003.12.12 Mod By T.Takagi@FSIT ���h�c�t���O��Ԃ�
'    objPerson.SelectPerson_Lukes strPerId, strLastName, strFirstName, strLastKName, strFirstKName, , strBirth, strGender
'## 2005.03.09 Mod By T.Takagi@FSIT web�\���荞��(���[�}�����ǉ�)
'    objPerson.SelectPerson_Lukes strPerId, strLastName, strFirstName, strLastKName, strFirstKName, , strBirth, strGender, , , , , , , strVidFlg
    objPerson.SelectPerson_Lukes strPerId, strLastName, strFirstName, strLastKName, strFirstKName, strRomeName, strBirth, strGender, , , , , , , strVidFlg
'## 2005.03.09 Mod End
'## 2003.12.12 Mod End

    '�l�Z�����ǂݍ���
    objPerson.SelectPersonAddr strPerId, strAddrDiv, strZipCd, strPrefCd, strPrefName, strCityName, strAddress1, strAddress2, strTel1, strPhone, strTel2, strExtension, strFax, strEMail

    '�N��v�Z
    strAge = objFree.CalcAge(strBirth)
    If IsNumeric(strAge) Then
        strAge = Int(strAge)
    End If

    '�����̕ҏW
    strPerName  = Trim(strLastName  & "�@" & strFirstName)
    strPerKName = Trim(strLastKName & "�@" & strFirstKName)

    '���N�����̊e�`���ҏW
    strEraBirth  = objCommon.FormatString(strBirth, "ge.m.d")
    strFullBirth = objCommon.FormatString(strBirth, "ge�iyyyy�j.m.d")

'### 2016.09.16 �� �l���̓��L�����\���ǉ� STR ###
    '�l�ڍ׏��ǂݍ���
    objPerson.SelectPersonDetail_lukes strPerId, , , , , strNotes
'### 2016.09.14 �� �l���̓��L�����\���ǉ� END ###

End If

'�\��ԍ������݂���ꍇ
If strRsvNo <> "" Then

    Set objConsult = Server.CreateObject("HainsConsult.Consult")

    '��f���ǂݍ���
    objConsult.SelectConsult strRsvNo, , , , strCsCd, , strLastOrgCd1, strLastOrgCd2, strLastOrgName, , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , strCslDivCd

    '�p�����ڂ̓ǂݍ���
'#### 2013.3.1 SL-SN-Y0101-612 UPD START ####
'    objConsult.SelectConsultDetail strRsvNo, , , strCardAddrDiv, , strFormAddrDiv, , strReportAddrDiv, , strVolunteer, strVolunteerName, , , , strIsrSign, strIsrNo, strIsrManNo, strEmpNo
    objConsult.SelectConsultDetail strRsvNo, , , strCardAddrDiv, , strFormAddrDiv, , strReportAddrDiv, , strVolunteer, strVolunteerName, , , , strIsrSign, strIsrNo, strIsrManNo, strEmpNo, , , , strSendMailDiv
'#### 2013.3.1 SL-SN-Y0101-612 UPD END   ####

    Set objConsult = Nothing

End If
%>
<SCRIPT TYPE="text/javascript">
<!--
<% '## 2005.03.09 Add By T.Takagi@FSIT web�\���荞��(�Z���g��) %>
function PerAddr() {
    this.zipCd     = '';    // �X�֔ԍ�
    this.prefCd    = '';    // �s���{���R�[�h
    this.prefName  = '';    // �s���{����
    this.cityName  = '';    // �s�撬����
    this.address1  = '';    // �Z���P
    this.address2  = '';    // �Z���Q
    this.tel1      = '';    // �d�b�ԍ�1
    this.phone     = '';    // �g�єԍ�
    this.tel2      = '';    // �d�b�ԍ�2
    this.extension = '';    // ����
    this.fax       = '';    // FAX
    this.eMail     = '';    // e-Mail
}
<% '## 2005.03.09 Add End %>

// �Ăь���ʂɏ���n�����߂̌l���N���X��`
function Person() {

    this.perId       = '';    // �l�h�c
    this.lastName    = '';    // ��
    this.firstName   = '';    // ��
    this.perName     = '';    // ����
    this.lastKName   = '';    // �J�i��
    this.firstKName  = '';    // �J�i��
    this.perKName    = '';    // �J�i����
    this.birth       = '';    // ���N����
    this.birthJpn    = '';    // ���N����(�a��)
    this.birthFull   = '';    // ���N����(�a��{����)
    this.gender      = '';    // ����
    this.orgCd1      = '';    // �����c�̃R�[�h�P
    this.orgCd2      = '';    // �����c�̃R�[�h�Q
    this.orgName     = '';    // �c�̊�������
    this.orgSName    = '';    // �c�̗���
    this.empNo       = '';    // �]�ƈ��ԍ�
    this.age         = '';    // �N��
    this.orgPostName = '';    // ������
    this.jobName     = '';    // �E��
// ## 2003.12.12 Add By T.Takagi@FSIT ���h�c�t���O��Ԃ�
    this.vidFlg      = '';    // ���h�c�t���O
// ## 2003.12.12 Add End
<% '## 2005.03.09 Add By T.Takagi@FSIT web�\���荞��(���[�}�����ǉ�) %>
    this.romeName    = '';    // ���[�}����
<% '## 2005.03.09 Add End %>

    this.address = new Array(3);    // �Z��

/** 2016.09.16 �� �d�b�ԍ��A���L�����擾�E�ҏW�̈גǉ� STR **/
    this.tel     = new Array(3);    // �d�b�ԍ�
    this.notes   = '';              // ���L����
/** 2016.09.16 �� �d�b�ԍ��A���L�����擾�E�ҏW�̈גǉ� END **/

<% '## 2005.03.09 Add By T.Takagi@FSIT web�\���荞��(�Z���g��) %>
    this.addresses = new Array(3);
    for ( var i = 0; i < this.addresses.length; i++ ) {
        this.addresses[ i ] = new PerAddr();
    }
<% '## 2005.03.09 Add End %>
<%
    '�\��ԍ������݂���ꍇ�A�N���X�ɗv�f��ǉ�
    If strRsvNo <> "" Then
%>
        this.rsvNo         = '';    // �\��ԍ�
        this.csCd          = '';    // �R�[�X�R�[�h
        this.lastOrgCd1    = '';    // �c�̃R�[�h�P
        this.lastOrgCd2    = '';    // �c�̃R�[�h�P
        this.lastOrgName   = '';    // �c�̖���
        this.cslDivCd      = '';    // ��f�敪�R�[�h
        this.cardAddrDiv   = '';    // �m�F�͂�������
        this.formAddrDiv   = '';    // �ꎮ��������
        this.reportAddrDiv = '';    // ���я�����
        this.volunteer     = '';    // �{�����e�B�A
        this.volunteerName = '';    // �{�����e�B�A��
        this.isrSign       = '';    // �ی��؋L��
        this.isrNo         = '';    // �ی��ؔԍ�
        this.isrManNo      = '';    // �ی��Ҕԍ�
<% '#### 2013.3.1 SL-SN-Y0101-612 ADD START #### %>
        this.sendMailDiv   = '';    // �\��m�F���[�����M��
<% '#### 2013.3.1 SL-SN-Y0101-612 ADD END   #### %>
<%
    End If
%>
}

if ( !opener ) {
    close();
}
var perInfo = new Person();
perInfo.perId       = '<%= Replace(strPerId,       "'", "\'") %>';    // �lID
perInfo.lastName    = '<%= Replace(strLastName,    "'", "\'") %>';    // ��
perInfo.firstName   = '<%= Replace(strFirstName,   "'", "\'") %>';    // ��
perInfo.perName     = '<%= Replace(strPerName,     "'", "\'") %>';    // ����
perInfo.lastKName   = '<%= Replace(strLastKName,   "'", "\'") %>';    // �J�i��
perInfo.firstKName  = '<%= Replace(strFirstKName,  "'", "\'") %>';    // �J�i��
perInfo.perKName    = '<%= Replace(strPerKName,    "'", "\'") %>';    // �J�i����
perInfo.birth       = '<%= Replace(strBirth,       "'", "\'") %>';    // ���N����
perInfo.birthJpn    = '<%= Replace(strEraBirth,    "'", "\'") %>';    // ���N����(�a��)
perInfo.birthFull   = '<%= Replace(strFullBirth,   "'", "\'") %>';    // ���N����(�a��{����)
perInfo.gender      = '<%= Replace(strGender,      "'", "\'") %>';    // ����
perInfo.orgCd1      = '<%= Replace(strOrgCd1,      "'", "\'") %>';    // �����c�̃R�[�h�P
perInfo.orgCd2      = '<%= Replace(strOrgCd2,      "'", "\'") %>';    // �����c�̃R�[�h�Q
perInfo.orgName     = '<%= Replace(strOrgName,     "'", "\'") %>';    // �c�̊�������
perInfo.orgSName    = '<%= Replace(strOrgSName,    "'", "\'") %>';    // �c�̗���
perInfo.orgPostName = '<%= Replace(strOrgPostName, "'", "\'") %>';    // �E��
perInfo.empNo       = '<%= Replace(strEmpNo,       "'", "\'") %>';    // �]�ƈ��ԍ�
perInfo.age         = '<%= Replace(strAge,         "'", "\'") %>';    // �N��
perInfo.jobName     = '<%= Replace(strJobName,     "'", "\'") %>';    // �E��
// ## 2003.12.12 Add By T.Takagi@FSIT ���h�c�t���O��Ԃ�
perInfo.vidFlg      = '<%= strVidFlg %>';    // ���h�c�t���O
// ## 2003.12.12 Add End
<% '## 2005.03.09 Add By T.Takagi@FSIT web�\���荞��(���[�}�����ǉ�) %>
perInfo.romeName    = '<%= Replace(strRomeName, "'", "\'") %>';    // ���[�}����
<% '## 2005.03.09 Add End %>

<% '## 2016.09.16 �� �d�b�ԍ��A���L�����擾�E�ҏW�̈גǉ� STR ### %>
perInfo.notes    = '<%= Replace(Replace(strNotes, vbCrLf, ""), "'", "\'") %>';    // ���L����
<% '## 2016.09.16 �� �d�b�ԍ��A���L�����擾�E�ҏW�̈גǉ� END ### %>

<%
'�Z����񂪑��݂���ꍇ
If IsArray(strAddrDiv) Then

    i = 0

    Do Until i > UBound(strAddrDiv) Or i > 2

        '�X�֔ԍ��𕪊����ĕҏW
        strAddress = Left(strZipCd(i), 3)
        If Len(strZipCd(i)) > 3 Then
            strAddress = strAddress & "-" & Right(strZipCd(i), Len(strZipCd(i)) - 3)
        End If

        '�Z����A��
        strAddress = strAddress & "�@" & strPrefName(i)
        strAddress = strAddress & strCityName(i)
        strAddress = Trim(strAddress & strAddress1(i))
        strAddress = strAddress & Trim(strAddress2(i))

'## 2004.07.09 Mod By T.Takagi@FSIT �Z���ɃA�v�X�g���t�B�΍􂪑��݂��Ȃ��������ߏC��
%>
        perInfo.address[<%= i %>] = '<%= Replace(strAddress, "'", "\'") %>';
<%
        i = i + 1
    Loop
'## 2005.03.30 Add By T.Takagi@FSIT �Z����������������
%>
        perInfo.address[0] = '';
        perInfo.address[1] = '';
        perInfo.address[2] = '';

//### 2016.09.16 �� �d�b�ԍ��擾�E�ҏW�̈גǉ� STR ###
        perInfo.tel[0] = '';
        perInfo.tel[1] = '';
        perInfo.tel[2] = '';
//### 2016.09.16 �� �d�b�ԍ��擾�E�ҏW�̈גǉ� END ###

<%
'## 2005.03.30 Add End
'## 2005.03.09 Add By T.Takagi@FSIT web�\���荞��(�Z���g��)
%>
var objAddr;
<%
    For i = 0 To UBound(strAddrDiv)

        '�Z���敪�l�����ƂɊi�[��̃C���f�b�N�X���`
        Select Case strAddrDiv(i)
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
%>
            objAddr = perInfo.addresses[<%= lngIndex %>];
            objAddr.zipCd     = '<%= Replace(strZipCd(i),     "'", "\'") %>';    // �X�֔ԍ�
            objAddr.prefCd    = '<%= Replace(strPrefCd(i),    "'", "\'") %>';    // �s���{���R�[�h
            objAddr.prefName  = '<%= Replace(strPrefName(i),  "'", "\'") %>';    // �s���{����
            objAddr.cityName  = '<%= Replace(strCityName(i),  "'", "\'") %>';    // �s�撬����
            objAddr.address1  = '<%= Replace(strAddress1(i),  "'", "\'") %>';    // �Z���P
            objAddr.address2  = '<%= Replace(strAddress2(i),  "'", "\'") %>';    // �Z���Q
            objAddr.tel1      = '<%= Replace(strTel1(i),      "'", "\'") %>';    // �d�b�ԍ�1
            objAddr.phone     = '<%= Replace(strPhone(i),     "'", "\'") %>';    // �g�єԍ�
            objAddr.tel2      = '<%= Replace(strTel2(i),      "'", "\'") %>';    // �d�b�ԍ�2
            objAddr.extension = '<%= Replace(strExtension(i), "'", "\'") %>';    // ����
            objAddr.fax       = '<%= Replace(strFax(i),       "'", "\'") %>';    // FAX
            objAddr.eMail     = '<%= Replace(strEMail(i),     "'", "\'") %>';    // e-Mail
<%
'## 2005.03.30 Add By T.Takagi@FSIT �Z����������������
            '�X�֔ԍ��𕪊����ĕҏW
            strAddress = Left(strZipCd(i), 3)
            If Len(strZipCd(i)) > 3 Then
                strAddress = strAddress & "-" & Right(strZipCd(i), Len(strZipCd(i)) - 3)
            End If

            '�Z����A��
            strAddress = strAddress & "�@" & strPrefName(i)
            strAddress = strAddress & strCityName(i)
            strAddress = Trim(strAddress & strAddress1(i))
            strAddress = strAddress & Trim(strAddress2(i))

'### 2016.09.16 �� �d�b�ԍ��擾�E�ҏW�̈גǉ� STR ###
        '�d�b�ԍ��ҏW
        strTel = ""
        If strTel1(i) <> "" or strPhone(i) <> "" or strTel2(i) <> "" Then
            strTel = "�i"
            If strTel1(i) <> "" Then
                strTel = strTel & "�d�b1�F" & strTel1(i)
            End If
            If strPhone(i) <> "" Then
                strTel = strTel & "�@�g�сF" & strPhone(i)
            End If
            If strTel2(i) <> "" Then
                strTel = strTel & "�@�d�b2�F" & strTel2(i)
            End If
            strTel = strTel & "�j"
        End If
'### 2016.09.16 �� �d�b�ԍ��擾�E�ҏW�̈גǉ� END ###

%>
            perInfo.address[<%= lngIndex %>] = '<%= Replace(strAddress, "'", "\'") %>';
            perInfo.tel[<%= lngIndex %>] = '<%= Replace(strTel, "'", "\'") %>';
<%
'## 2005.03.30 Add End
        End If

    Next
'## 2005.03.09 Add End

End If

'�\��ԍ������݂���ꍇ�A�N���X�ɗv�f��ҏW
If strRsvNo <> "" Then
%>
    perInfo.rsvNo       = '<%= Replace(strRsvNo,       "'", "\'") %>';    // �\��ԍ�
    perInfo.csCd        = '<%= Replace(strCsCd,        "'", "\'") %>';    // �R�[�X�R�[�h
    perInfo.lastOrgCd1  = '<%= Replace(strLastOrgCd1,  "'", "\'") %>';    // �c�̃R�[�h�P
    perInfo.lastOrgCd2  = '<%= Replace(strLastOrgCd2,  "'", "\'") %>';    // �c�̃R�[�h�Q
    perInfo.lastOrgName = '<%= Replace(strLastOrgName, "'", "\'") %>';    // �c�̖���
    perInfo.cslDivCd    = '<%= Replace(strCslDivCd,    "'", "\'") %>';    // ��f�敪�R�[�h

    perInfo.cardAddrDiv   = '<%= Replace(strCardAddrDiv,   "'", "\'") %>';    // �m�F�͂�������
    perInfo.formAddrDiv   = '<%= Replace(strFormAddrDiv,   "'", "\'") %>';    // �ꎮ��������
    perInfo.reportAddrDiv = '<%= Replace(strReportAddrDiv, "'", "\'") %>';    // ���я�����
    perInfo.volunteer     = '<%= Replace(strVolunteer,     "'", "\'") %>';    // �{�����e�B�A
    perInfo.volunteerName = '<%= Replace(strVolunteerName, "'", "\'") %>';    // �{�����e�B�A��
    perInfo.isrSign       = '<%= Replace(strIsrSign,       "'", "\'") %>';    // �ی��؋L��
    perInfo.isrNo         = '<%= Replace(strIsrNo,         "'", "\'") %>';    // �ی��ؔԍ�
    perInfo.isrManNo      = '<%= Replace(strIsrManNo,      "'", "\'") %>';    // �ی��Ҕԍ�
<% '#### 2013.3.1 SL-SN-Y0101-612 ADD START #### %>
    perInfo.sendMailDiv   = '<%= Replace(strSendMailDiv, "'", "\'") %>';    // �\��m�F���[�����M��
<% '#### 2013.3.1 SL-SN-Y0101-612 ADD END   #### %>
<%
End If
%>
// �e��ʂ̒c�̕ҏW�֐��Ăяo��
if ( opener.perGuide_setPerInfo ) {
    opener.perGuide_setPerInfo( perInfo );
}

// ����ʂ����
if ( !opener.perGuide_closeGuidePersonal ) {
    close();
}

opener.perGuide_closeGuidePersonal();
//-->
</SCRIPT>
