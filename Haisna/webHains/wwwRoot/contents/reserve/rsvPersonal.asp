<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       �\����ڍ�(��f�t�����) (Ver0.0.1)
'       AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const FREECD_RSVINTERVAL = "RSVINTERVAL"    '�ėp�R�[�h(�͂������瑗�t�ē��ւ̐؂�ւ����s������)

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objConsult          '��f���A�N�Z�X�p
Dim objFree             '�ėp���A�N�Z�X�p
Dim objOrganization     '�c�̏��A�N�Z�X�p
Dim objPerson           '�l���A�N�Z�X�p
'## 2004.01.13 Add By T.Takagi �ۑ������������@�ύX
Dim objCommon           '���ʃN���X
'## 2004.01.13 Add End

'�O��ʂ��瑗�M�����p�����[�^�l(�X�V�̂�)
Dim strRsvNo            '�\��ԍ�

'��f���
Dim strCancelFlg        '�L�����Z���t���O
Dim strCslDate          '��f��
Dim strOrgCd1           '�c�̃R�[�h�P
Dim strOrgCd2           '�c�̃R�[�h�Q
Dim strDayId            '�����h�c

'��f�t�����
Dim strRsvStatus        '�\���
Dim	strPrtOnSave        '�ۑ������
Dim	strCardAddrDiv      '�m�F�͂�������
Dim	strCardOutEng       '�m�F�͂����p���o��
Dim	strFormAddrDiv      '�ꎮ��������
Dim	strFormOutEng       '�ꎮ�����p���o��
Dim	strReportAddrDiv    '���я�����
Dim	strReportOutEng     '���я��p���o��
Dim	strVolunteer        '�{�����e�B�A
Dim	strVolunteerName    '�{�����e�B�A��
Dim	strCollectTicket    '���p�����
Dim	strIssueCslTicket   '�f�@�����s
Dim	strBillPrint        '�������o��
Dim	strIsrSign          '�ی��؋L��
Dim	strIsrNo            '�ی��ؔԍ�
Dim	strIsrManNo         '�ی��Ҕԍ�
Dim	strEmpNo            '�Ј��ԍ�
Dim	strIntroductor      '�Љ��
Dim	strUpdDate          '�X�V����
Dim	strUpdUserName      '�X�V��
Dim strCardPrintDate    '�m�F�͂����o�͓���
Dim strFormPrintDate    '�ꎮ�����o�͓���
'## 2004.11.04 Add By T.Takagi@FSIT �O���f���ǉ�
Dim strLastCslDate      '�O���f��
'## 2004.11.04 Add End
'#### 2013.3.1 SL-SN-Y0101-612 ADD START ####
Dim strSendMailDiv      '�\��m�F���[�����M��
Dim strSendMailDate     '�\��m�F���[�����M����
Dim strSendMailUserName '�\��m�F���[�����M�Җ�
'#### 2013.3.1 SL-SN-Y0101-612 ADD END   ####

'�l�Z�����
Dim strPerId            '�l�h�c
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
'### 2016.09.14 �� �l���̓��L�����\���ǉ� STR ###
Dim strNotes            '���L����
'### 2016.09.14 �� �l���̓��L�����\���ǉ� END ###

'�c�̏��
Dim strBillCslDiv       '�������{�l�Ƒ��敪�o��
'### 2016.09.14 �� �c�̏��̑��t�ē��R�����g�\���ǉ� STR ###
Dim strSendComment      '���t�ē��R�����g
'### 2016.09.14 �� �c�̏��̑��t�ē��R�����g�\���ǉ� END ###

Dim strInterval         '�͂������瑗�t�ē��ւ̐؂�ւ����s������
Dim lngInterval         '�͂������瑗�t�ē��ւ̐؂�ւ����s������
Dim strLastName         '��
Dim strFirstName        '��
Dim strName             '����
Dim strAddress(2)       '�Z��

'### 2016.07.28 �� ��f�Ҍl�d�b�ԍ��ǉ��\���̈׏C�� STR ###
Dim strArrTel1(2)       '�d�b�ԍ�1
Dim strArrPhone(2)      '�g�єԍ�
Dim strArrTel2(2)       '�d�b�ԍ�2
'### 2016.07.28 �� ��f�Ҍl�d�b�ԍ��ǉ��\���̈׏C�� END ###

Dim i                   '�C���f�b�N�X

'## 2004.01.13 Add By T.Takagi �ۑ������������@�ύX
Dim strCslYear          '��f�N
Dim strCslMonth         '��f��
Dim strCslDay           '��f��
Dim strLastFormCslDate  '���t�ē��ŐV�o�͎�f��
'## 2004.01.13 Add End

'## 2004.01.29 Add By T.Takagi@FSIT ���ڒǉ�
Dim strReptCslDiv       '���я��{�l�Ƒ��敪�o��
'## 2004.01.29 Add End

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objFree = Server.CreateObject("HainsFree.Free")

'�����ݒ����ėp�e�[�u������擾
'## 2004.01.13 Mod By T.Takagi �ۑ������������@�ύX
'objFree.SelectFree 0, FREECD_RSVINTERVAL, , , , strInterval
objFree.SelectFree 0, FREECD_RSVINTERVAL, , , strLastFormCslDate, strInterval
'## 2004.01.13 Mod End

Set objFree = Nothing

'�؂�ւ������̐ݒ�
If IsNumeric(strInterval) Then
    If CLng(strInterval) >= 0 Then
        lngInterval = CLng(strInterval)
    End If
End If

'�����l�̎擾
strRsvNo = Request("rsvNo")
'## 2004.01.13 Add By T.Takagi �ۑ������������@�ύX
strCslYear  = Request("cslYear")
strCslMonth = Request("cslMonth")
strCslDay   = Request("cslDay")

'��f�N�������n����Ă��Ȃ��ꍇ�A�V�X�e���N������K�p����
If strCslYear = "" Then
    strCslYear  = CStr(Year(Now))
    strCslMonth = CStr(Month(Now))
    strCslDay   = CStr(Day(Now))
End If
'## 2004.01.13 Add End

'�\��ԍ��w�莞
If strRsvNo <> "" Then

    Set objConsult = Server.CreateObject("HainsConsult.Consult")

    '��f���ǂݍ���
    objConsult.SelectConsult strRsvNo,     strCancelFlg, strCslDate, strPerId, , , _
                             strOrgCd1,    strOrgCd2, , , , ,                      _
                             strUpdDate, , strUpdUserName, , , , , , , , , ,       _
                             strDayId

    '��f�t�����ǂݍ���
'#### 2013.3.1 SL-SN-Y0101-612 ADD START ####
''## 2004.11.04 Mod By T.Takagi@FSIT �O���f���ǉ�
''	objConsult.SelectConsultDetail strRsvNo,          strRsvStatus,     strPrtOnSave,   _
''								   strCardAddrDiv,    strCardOutEng,    strFormAddrDiv, _
''								   strFormOutEng,     strReportAddrDiv, strReportOutEng, _
''								   strVolunteer,      strVolunteerName, strCollectTicket, _
''								   strIssueCslTicket, strBillPrint,     strIsrSign, _
''								   strIsrNo,          strIsrManNo,      strEmpNo, _
''								   strIntroductor
'    objConsult.SelectConsultDetail strRsvNo,          strRsvStatus,     strPrtOnSave,   _
'                                   strCardAddrDiv,    strCardOutEng,    strFormAddrDiv, _
'                                   strFormOutEng,     strReportAddrDiv, strReportOutEng, _
'                                   strVolunteer,      strVolunteerName, strCollectTicket, _
'                                   strIssueCslTicket, strBillPrint,     strIsrSign, _
'                                   strIsrNo,          strIsrManNo,      strEmpNo, _
'                                   strIntroductor, ,  strLastCslDate
''## 2004.11.04 Mod End
    objConsult.SelectConsultDetail strRsvNo,          strRsvStatus,     strPrtOnSave,   _
                                   strCardAddrDiv,    strCardOutEng,    strFormAddrDiv, _
                                   strFormOutEng,     strReportAddrDiv, strReportOutEng, _
                                   strVolunteer,      strVolunteerName, strCollectTicket, _
                                   strIssueCslTicket, strBillPrint,     strIsrSign, _
                                   strIsrNo,          strIsrManNo,      strEmpNo, _
                                   strIntroductor, ,  strLastCslDate, _
                                   strSendMailDiv,    strSendMailDate,  strSendMailUserName
'#### 2013.3.1 SL-SN-Y0101-612 ADD END   ####

    Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

'## 2004.01.29 Mod By T.Takagi@FSIT ���ڒǉ�
'	'�������{�l�Ƒ��敪�̎擾
'	objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2, , , , , , , , , , , , , , , , , , , , , , , , , , , strBillCslDiv
    '�������A���я��{�l�Ƒ��敪�̎擾
'### 2016.09.14 �� �c�̏��̑��t�ē��R�����g�\���ǉ� STR ###
'    objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2, , , , , , , , , , , , , , , , , , , , , , , , , , , strBillCslDiv, , , , , , , , , , , , , , , , , , , , , , , strReptCslDiv
    objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2, , , , , , , , , , , , , , , , , , , , , , , , , , , strBillCslDiv, , , , , strSendComment, , , , , , , , , , , , , , , , , , strReptCslDiv
'### 2016.09.14 �� �c�̏��̑��t�ē��R�����g�\���ǉ� STR ###
'## 2004.01.29 Mod End

    Set objOrganization = Nothing

    '�͂����A�ꎮ�����̏o�͏��ǂݍ���
    objConsult.SelectConsultPrintStatus strRsvNo, strCardPrintDate, strFormPrintDate

    '�ۑ�����������̐���
    strPrtOnSave = "0"

    Do

        '�͂������o�͂���Ă���ꍇ�͑��t�ē��̏o�͏�ԂɈˑ�
        If strCardPrintDate <> "" Then
            strPrtOnSave = IIf(strFormPrintDate <> "", "0", "2")
            Exit Do
        End If

        '�͂������o�͂���Ă��Ȃ��ꍇ

        '���t�ē����o�͂���Ă���ꍇ�͕K�v�Ȃ�
        If strFormPrintDate <> "" Then
            Exit Do
        End If

        '�V�X�e�����t����f�����(�؂�ւ�����)�ȓ��ł���Α��t�ē����A�����Ȃ��΂͂�����I��
        strPrtOnSave = IIf(CDate(strCslDate) - Date <= lngInterval, "2", "1")
        Exit Do
    Loop

    Set objConsult = Nothing

    Set objPerson = Server.CreateObject("HainsPerson.Person")

    '�l�Z�����ǂݍ���
    objPerson.SelectPersonAddr strPerId, strAddrDiv, strZipCd, strPrefCd, strPrefName, strCityName, strAddress1, strAddress2, strTel1, strPhone, strTel2, strExtension, strFax, strEMail

    '�Z����񂪑��݂���ꍇ
    If IsArray(strAddrDiv) Then
    
        i = 0
        Do Until i > UBound(strAddrDiv) Or i > 2
    
            '�X�֔ԍ��𕪊����ĕҏW
            strAddress(i) = Left(strZipCd(i), 3)
            If Len(strZipCd(i)) > 3 Then
                strAddress(i) = strAddress(i) & "-" & Right(strZipCd(i), Len(strZipCd(i)) - 3)
            End If
    
            '�Z����A��
            strAddress(i) = strAddress(i) & "�@" & strPrefName(i)
            strAddress(i) = strAddress(i) & strCityName(i)
            strAddress(i) = Trim(strAddress(i) & strAddress1(i))
            strAddress(i) = strAddress(i) & Trim(strAddress2(i))

            '### 2016.07.28 �� ��f�Ҍl�d�b�ԍ��ǉ��\���̈׏C�� STR ###
            strArrTel1(i) = Trim(strTel1(i))
            strArrPhone(i)= Trim(strPhone(i))
            strArrTel2(i) = Trim(strTel2(i))
            '### 2016.07.28 �� ��f�Ҍl�d�b�ԍ��ǉ��\���̈׏C�� END ###

            i = i + 1
        Loop
    
    End If

    '�l���ǂݍ���
    If strIntroductor <> "" Then
        objPerson.SelectPerson_Lukes strIntroductor, strLastName, strFirstName
        strName = Trim(strLastName & "�@" & strFirstName)
    End If

'### 2016.09.14 �� �l���̓��L�����\���ǉ� STR ###
    '�l�ڍ׏��ǂݍ���
    objPerson.SelectPersonDetail_lukes strPerId, , , , , strNotes
'### 2016.09.14 �� �l���̓��L�����\���ǉ� END ###

    Set objPerson = Nothing

'�\��ԍ����w�莞
Else

    '�����l�̐ݒ�
    strRsvStatus      = "0"
    strPrtOnSave      = "1"
    strCardAddrDiv    = "1"
    strCardOutEng     = "0"
    strFormAddrDiv    = "1"
    strFormOutEng     = "0"
    strReportAddrDiv  = "1"
    strReportOutEng   = "0"
    strVolunteer      = "0"
    strIssueCslTicket = "1"
'#### 2013.3.1 SL-SN-Y0101-612 ADD START ####
	strSendMailDiv    = "0"
'#### 2013.3.1 SL-SN-Y0101-612 ADD END   ####

    '�������o�͕͂\�����Ȃ�
    strBillCslDiv = ""
'## 2004.01.29 Add By T.Takagi@FSIT ���ڒǉ�
    strReptCslDiv = ""
'## 2004.01.29 Add End

'## 2004.01.13 Add By T.Takagi �ۑ������������@�ύX
    '��f���̕ҏW
    strCslDate = CDate(strCslYear & "/" & strCslMonth & "/" & strCslDay)
'## 2004.01.13 Add End

End If
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Adobe GoLive 6">
<TITLE>�\����ڍ�(��f�t�����)</TITLE>
<STYLE TYPE="text/css">
table#maincontents {
	margin: 5px 0 0 0;
}

table#maincontents tr {
	height: 1.4em;
}

td.tbl_spacer { height: 10px; }

</style>
<!-- #include virtual = "/webHains/includes/perGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
var winStatus;  // �E�B���h�E�n���h��
// ## 2004.10.27 Add By T.Takagi@FSIT �X�V�����ւ̑J�ڒǉ�
var winRsvLog;  // �E�B���h�E�n���h��
// ## 2004.10.27 Add End

// �l�����K�C�h�Ăяo��
function callPersonGuide() {
    perGuide_showGuidePersonal(document.entryForm.introductor, 'introductorName');
}

// ����󋵉�ʌĂяo��
function callPrintStatusWindow() {

    var opened = false; // ��ʂ��J����Ă��邩
    var url;            // ����󋵉�ʂ�URL

    // ���łɃK�C�h���J����Ă��邩�`�F�b�N
    if ( winStatus != null ) {
        if ( !winStatus.closed ) {
            opened = true;
        }
    }

    // ����󋵉�ʂ�URL�ҏW
    url = 'rsvPrintStatus.asp?rsvNo=<%= strRsvNo %>';

    // �J����Ă���ꍇ�͉�ʂ�REPLACE���A�����Ȃ��ΐV�K��ʂ��J��
    if ( opened ) {
        winStatus.focus();
        winStatus.location.replace( url );
    } else {
        winStatus = open( url, '', 'width=400,height=180,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
    }

}

// �l���̃N���A
function clearPerInfo() {
    perGuide_clearPerInfo(document.entryForm.introductor, 'introductorName');
}

// �T�u��ʂ����
function closeWindow() {

    // �l�����K�C�h�����
    perGuide_closeGuidePersonal();

    // ����󋵉�ʂ����
    if ( winStatus != null ) {
        if ( !winStatus.closed ) {
            winStatus.close();
        }
    }

    winStatus = null;

// ## 2004.10.27 Add By T.Takagi@FSIT �X�V�����ւ̑J�ڒǉ�
    // �X�V������ʂ����
    if ( winRsvLog != null ) {
        if ( !winRsvLog.closed ) {
            winRsvLog.close();
        }
    }

    winRsvLog = null;
// ## 2004.10.27 Add End
}

// �͂������
function showPrintCardDialog() {

    var cardAddrDiv = document.entryForm.cardAddrDiv.value;
    for ( i = 0; i < document.entryForm.cardOutEng.length; i++ ) {
        if ( document.entryForm.cardOutEng[ i ].checked ) {
            var cardOutEng = document.entryForm.cardOutEng[ i ].value;
            break;
        }
    }

    top.showPrintCardDialog( '<%= strRsvNo %>', '1', cardAddrDiv, cardOutEng );

}

// �ꎮ�������
function showPrintFormDialog() {

    var formAddrDiv = document.entryForm.formAddrDiv.value;
    for ( i = 0; i < document.entryForm.formOutEng.length; i++ ) {
        if ( document.entryForm.formOutEng[ i ].checked ) {
            var formOutEng = document.entryForm.formOutEng[ i ].value;
            break;
        }
    }

    top.showPrintFormDialog( '<%= strRsvNo %>', '1', formAddrDiv, formOutEng );

}

// �u�������o�́v�̕\������
function setBillPrintVisibility( visible ) {

    // ���݂̕\����Ԃ��擾
    var currentVisibility = document.getElementById('dspBillPrint1').style.visibility ? 'visible' : 'hidden';

    // ���݂̕\����ԂƓ���w��Ȃ牽�����Ȃ�
    if ( visible == currentVisibility ) {
        return;
    }

    // �\������
    var visibility = visible ? 'visible' : 'hidden';
    document.getElementById('dspBillPrint1').style.visibility = visibility;
    document.getElementById('dspBillPrint2').style.visibility = visibility;
    document.getElementById('dspBillPrint3').style.visibility = visibility;

    // ��\���̏ꍇ
    if ( !visible ) {

        // �ێ����e�̃N���A
        document.entryForm.billPrint.value = '';

        // �w��Ȃ���I����Ԃɂ���
        document.entryForm.billPrintCntl.selectedIndex = 0;

    }

}
// ## 2004.10.27 Add By T.Takagi@FSIT �X�V�����ւ̑J�ڒǉ�
// �X�V������ʌĂяo��
function callConsultLogWindow() {

    var opened = false; // ��ʂ��J����Ă��邩
    var url;            // �X�V������ʂ�URL

    // ���łɃK�C�h���J����Ă��邩�`�F�b�N
    if ( winRsvLog != null ) {
        if ( !winRsvLog.closed ) {
            opened = true;
        }
    }

    // �X�V������ʂ�URL�ҏW
    url = 'rsvLogBody.asp';
    url = url + '?strYear='     + '1970';
    url = url + '&strMonth='    + '1';
    url = url + '&strDay='      + '1';
    url = url + '&endYear='     + '2200';
    url = url + '&endMonth='    + '12';
    url = url + '&endDay='      + '31';
    url = url + '&rsvNo='       + '<%= strRsvNo %>';
    url = url + '&orderByItem=' + '0';  // �X�V����
    url = url + '&orderByMode=' + '0';  // ������
    url = url + '&startPos='    + '1';  // �擪����
    url = url + '&getCount='    + '0';  // �S���\��
    url = url + '&margin='      + '20';

    // �J����Ă���ꍇ�͉�ʂ�REPLACE���A�����Ȃ��ΐV�K��ʂ��J��
    if ( opened ) {
        winRsvLog.focus();
        winRsvLog.location.replace( url );
    } else {
        winRsvLog = open( url, '', 'width=400,height=300,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
    }

}
// ## 2004.10.27 Add End
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 0 0 0 10px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">
<FORM NAME="entryForm" action="#">
    <INPUT TYPE="hidden" NAME="billPrint" VALUE="<%= strBillPrint %>">
    <TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
        <TR>
            <TD NOWRAP BGCOLOR="#eeeeee" HEIGHT="15"><B><FONT COLOR="#333333">��f�t�����</FONT></B></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0" id="maincontents">
        <tr>
            <TD>�\���</TD>
            <TD>�F</TD>
            <TD>
                <SELECT NAME="rsvStatus">
                    <OPTION VALUE="0"<%= IIf(strRsvStatus = "0", " SELECTED", "") %>>�m��
                    <OPTION VALUE="1"<%= IIf(strRsvStatus = "1", " SELECTED", "") %>>�ۗ�
                    <!--#### 2007/04/04 �� �\��󋵋敪�ǉ� Start ####-->
                    <OPTION VALUE="2"<%= IIf(strRsvStatus = "2", " SELECTED", "") %>>���m��
                    <!--#### 2007/04/04 �� �\��󋵋敪�ǉ� End   ####-->
                </SELECT>
            </TD>
        </TR>
        <TR>
            <TD class="tbl_spacer"></TD>
        </TR>
        <TR>
            <TD>�ۑ������</TD>
            <TD>�F</TD>
            <TD>
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                    <TR>
<% '## 2004.01.13 Mod By T.Takagi �ۑ������������@�ύX %>
<!--
                        <TD><INPUT TYPE="radio" NAME="prtOnSave" VALUE="0"<%= IIf(strPrtOnSave = "0", " CHECKED", "") %>></TD>
                        <TD NOWRAP>�Ȃ�</TD>
                        <TD><INPUT TYPE="radio" NAME="prtOnSave" VALUE="1"<%= IIf(strPrtOnSave = "1", " CHECKED", "") %>></TD>
                        <TD NOWRAP>�͂���</TD>
                        <TD><INPUT TYPE="radio" NAME="prtOnSave" VALUE="2"<%= IIf(strPrtOnSave = "2", " CHECKED", "") %>></TD>
                        <TD NOWRAP>���t�ē�</TD>
-->
                        <TD><INPUT TYPE="radio" NAME="prtOnSave" VALUE="0"></TD>
                        <TD NOWRAP>�Ȃ�</TD>
                        <TD><INPUT TYPE="radio" NAME="prtOnSave" VALUE="1"></TD>
                        <TD NOWRAP>�͂���</TD>
                        <TD><INPUT TYPE="radio" NAME="prtOnSave" VALUE="2"></TD>
                        <TD NOWRAP>���t�ē�</TD>
<% '## 2004.01.13 Mod End %>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD class="tbl_spacer"></TD>
        </TR>
        <TR>
            <TD NOWRAP>����i�m�F�͂����j</TD>
            <TD>�F</TD>
            <TD>
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                    <TR>
                        <TD>
                            <SELECT NAME="cardAddrDiv">
                                <OPTION VALUE="1"<%= IIf(strCardAddrDiv = "1", " SELECTED", "") %>>�Z���i����j
                                <OPTION VALUE="2"<%= IIf(strCardAddrDiv = "2", " SELECTED", "") %>>�Z���i�Ζ���j
                                <OPTION VALUE="3"<%= IIf(strCardAddrDiv = "3", " SELECTED", "") %>>�Z���i���̑��j
                            </SELECT>
                        </TD>
                        <!--#### 2008.03.10 �� �R�[���Z���^�[����̈˗��ɂ���ďC�� ####-->
                        <!--TD ID="print1" NOWRAP>�@<A HREF="javascript:showPrintCardDialog()">���</A></TD-->
                        <TD ID="print1" NOWRAP>�@<FONT COLOR="#ffffff">&nbsp;</FONT></TD>
                        <TD NOWRAP>�@�p���o��</TD>
                        <TD><INPUT TYPE="radio" NAME="cardOutEng" VALUE="1"<%= IIf(strCardOutEng = "1", " CHECKED", "") %>></TD>
                        <TD>�L</TD>
                        <TD><INPUT TYPE="radio" NAME="cardOutEng" VALUE="0"<%= IIf(strCardOutEng = "0", " CHECKED", "") %>></TD>
                        <TD>��</TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD>����i�ꎮ�����j</TD>
            <TD>�F</TD>
            <TD>
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                    <TR>
                        <TD>
                            <SELECT NAME="formAddrDiv">
                                <OPTION VALUE="1"<%= IIf(strFormAddrDiv = "1", " SELECTED", "") %>>�Z���i����j
                                <OPTION VALUE="2"<%= IIf(strFormAddrDiv = "2", " SELECTED", "") %>>�Z���i�Ζ���j
                                <OPTION VALUE="3"<%= IIf(strFormAddrDiv = "3", " SELECTED", "") %>>�Z���i���̑��j
                            </SELECT>
                        </TD>
                        <!--#### 2008.03.10 �� �R�[���Z���^�[����̈˗��ɂ���ďC�� ####-->
                        <!--TD ID="print2" NOWRAP>�@<A HREF="javascript:showPrintFormDialog()">���</A></TD-->
                        <TD ID="print2" NOWRAP>�@<FONT COLOR="#ffffff">&nbsp;</FONT></TD>
                        <TD NOWRAP>�@�p���o��</TD>
                        <TD><INPUT TYPE="radio" NAME="formOutEng" VALUE="1"<%= IIf(strFormOutEng = "1", " CHECKED", "") %>></TD>
                        <TD>�L</TD>
                        <TD><INPUT TYPE="radio" NAME="formOutEng" VALUE="0"<%= IIf(strFormOutEng = "0", " CHECKED", "") %>></TD>
                        <TD>��</TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD NOWRAP>����i���ѕ\�j</TD>
            <TD>�F</TD>
            <TD>
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                    <TR>
                        <TD>
                            <SELECT NAME="reportAddrDiv">
                                <OPTION VALUE="1"<%= IIf(strReportAddrDiv = "1", " SELECTED", "") %>>�Z���i����j
                                <OPTION VALUE="2"<%= IIf(strReportAddrDiv = "2", " SELECTED", "") %>>�Z���i�Ζ���j
                                <OPTION VALUE="3"<%= IIf(strReportAddrDiv = "3", " SELECTED", "") %>>�Z���i���̑��j
                            </SELECT>
                        </TD>
                        <TD ID="print3" NOWRAP>�@<FONT COLOR="#ffffff">&nbsp;</FONT></TD>
                        <TD NOWRAP>�@�p���o��</TD>
                        <TD><INPUT TYPE="radio" NAME="reportOutEng" VALUE="1"<%= IIf(strReportOutEng = "1", " CHECKED", "") %>></TD>
                        <TD>�L</TD>
                        <TD><INPUT TYPE="radio" NAME="reportOutEng" VALUE="0"<%= IIf(strReportOutEng <> "1", " CHECKED", "") %>></TD>
                        <TD>��</TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD HEIGHT="30" ID="prtStatus" NOWRAP><A HREF="javascript:callPrintStatusWindow()">����󋵂�����</A></TD>
        </TR>
        <TR>
            <TD HEIGHT="3" colspan=3><hr></TD>
        </TR>
<%'### 2016.07.28 �� ��f�Ҍl�d�b�ԍ��ǉ��\���̈׏C�� STR ###%>
        <!--TR>
            <TD>�Z���i����j</TD>
            <TD>�F</TD>
            <TD ID="addr1"><%= strAddress(0) %></TD>
        </TR>
        <TR>
            <TD>�Z���i�Ζ���j</TD>
            <TD>�F</TD>
            <TD ID="addr2"><%= strAddress(1) %></TD>
        </TR>
        <TR>
            <TD>�Z���i���̑��j</TD>
            <TD>�F</TD>
            <TD ID="addr3"><%= strAddress(2) %></TD>
        </TR-->

<%'### �d�b�ԍ����o�^����Ă��鎞�����\�� %>
        <TR>
            <TD rowspan="2" valign="top">�Z���i����j</TD>
            <TD rowspan="2" valign="top">�F</TD>
            <TD ID="addr1"><%= strAddress(0) %></TD>
        </TR>
        <TR>
            <TD ID="tel1">
<%  If strArrTel1(0) <> "" or strArrPhone(0) <> "" or strArrTel2(0) <> "" Then   %>
            �i<%= IIf(strArrTel1(0) <> "", "�@�d�b1�F" & strArrTel1(0), "")%><%= IIf(strArrPhone(0) <> "", "�@�g�сF" & strArrPhone(0), "")%><%= IIf(strArrTel2(0) <> "", "�@�d�b2�F" & strArrTel2(0), "")%>&nbsp;&nbsp;�j
<%  End If  %>
            </TD>
        </TR>

        <TR>
            <TD rowspan="2" valign="top">�Z���i�Ζ���j</TD>
            <TD rowspan="2" valign="top">�F</TD>
            <TD ID="addr2"><%= strAddress(1) %></TD>
        </TR>
        <TR>
            <TD ID="tel2">
<%  If strArrTel1(1) <> "" or strArrPhone(1) <> "" or strArrTel2(1) <> "" Then   %>
            �i<%= IIf(strArrTel1(1) <> "", "�@�d�b1�F" & strArrTel1(1), "")%><%= IIf(strArrPhone(1) <> "", "�@�g�сF" & strArrPhone(1), "")%><%= IIf(strArrTel2(1) <> "", "�@�d�b2�F" & strArrTel2(1), "")%>&nbsp;&nbsp;�j
<%  End If  %>
            </TD>
        </TR>

        <TR>
            <TD rowspan="2" valign="top">�Z���i���̑��j</TD>
            <TD rowspan="2" valign="top">�F</TD>
            <TD ID="addr3"><%= strAddress(2) %></TD>
        </TR>
        <TR>
            <TD ID="tel3">
<%  If strArrTel1(2) <> "" or strArrPhone(2) <> "" or strArrTel2(2) <> "" Then   %>
            �i<%= IIf(strArrTel1(2) <> "", "�@�d�b1�F" & strArrTel1(2), "")%><%= IIf(strArrPhone(2) <> "", "�@�g�сF" & strArrPhone(2), "")%><%= IIf(strArrTel2(2) <> "", "�@�d�b2�F" & strArrTel2(2), "")%>&nbsp;&nbsp;�j
<%  End If  %>
            </TD>
        </TR>
<%'### 2016.07.28 �� ��f�Ҍl�d�b�ԍ��ǉ��\���̈׏C�� END ###%>

<%'### 2016.09.19 �� �l���̓��L�����E�c�̏��̑��t�ē��R�����g�\���ǉ� STR ###%>
        <TR>
            <TD valign="top">���L����</TD>
            <TD valign="top">�F</TD>
            <TD ID="notes"><%= strNotes %></TD>
        </TR>

        <TR>
            <TD HEIGHT="3" colspan=3><hr></TD>
        </TR>
        <TR>
            <TD NOWRAP valign="top">���t�ē��R�����g</TD>
            <TD valign="top">�F</TD>
            <TD ID="sendCommentVal"><%= strSendComment %></TD>
        </TR>
        <TR>
            <TD HEIGHT="3" colspan=3><hr></TD>
        </TR>
<%'### 2016.09.19 �� �l���̓��L�����E�c�̏��̑��t�ē��R�����g�\���ǉ� END ###%>

        <TR>
            <TD>�{�����e�B�A</TD>
            <TD>�F</TD>
            <TD>
                <SELECT NAME="volunteer" ID="hoge">
                    <OPTION VALUE="0"<%= IIf(strVolunteer = "0", " SELECTED", "") %>>���p�Ȃ�
                    <OPTION VALUE="1"<%= IIf(strVolunteer = "1", " SELECTED", "") %>>�ʖ�v
                    <OPTION VALUE="2"<%= IIf(strVolunteer = "2", " SELECTED", "") %>>���v
                    <OPTION VALUE="3"<%= IIf(strVolunteer = "3", " SELECTED", "") %>>�ʖ󁕉��v
                    <OPTION VALUE="4"<%= IIf(strVolunteer = "4", " SELECTED", "") %>>�Ԉ֎q�v
                </SELECT>
            </TD>
        </TR>
        <TR>
            <TD>�{�����e�B�A��</TD>
            <TD>�F</TD>
            <%'###### 2010/05/26 �� �R�����g������邱�Ƃɂ���ĐԎ��ŕ\���i�f�[�^�x�[�X�ύX�Ȃ��j Start ####%>
            <!--TD><INPUT TYPE="text" NAME="volunteerName" SIZE="50" MAXLENGTH="25" VALUE="<%= strVolunteerName %>"></TD-->
            <TD><INPUT TYPE="text" NAME="volunteerName" SIZE="50" MAXLENGTH="25" VALUE="<%= strVolunteerName %>"  style="FONT-WEIGHT: bold;COLOR:red;ime-mode:active;"></TD>
            <%'###### 2010/05/26 �� �R�����g������邱�Ƃɂ���ĐԎ��ŕ\���i�f�[�^�x�[�X�ύX�Ȃ��j End   ####%>
        </TR>
        <TR>
            <TD>���p�����</TD>
            <TD>�F</TD>
            <TD>
                <SELECT NAME="collectTicket">
                    <OPTION VALUE=""<%=  IIf(strCollectTicket <> "1", " SELECTED", "") %>>�����
                    <OPTION VALUE="1"<%= IIf(strCollectTicket  = "1", " SELECTED", "") %>>�����
                </SELECT>
            </TD>
        </TR>
        <TR>
            <TD>�f�@�����s</TD>
            <TD>�F</TD>
            <TD>
                <SELECT NAME="issueCslTicket">
                    <OPTION VALUE="">&nbsp;
                    <OPTION VALUE="1"<%= IIf(strIssueCslTicket = "1", " SELECTED", "") %>>�V�K
                    <OPTION VALUE="2"<%= IIf(strIssueCslTicket = "2", " SELECTED", "") %>>����
                    <OPTION VALUE="3"<%= IIf(strIssueCslTicket = "3", " SELECTED", "") %>>�Ĕ��s
                </SELECT>
            </TD>
        </TR>
        <TR>
            <TD HEIGHT="3" colspan=3><hr></TD>
        </TR>
        <TR>
            <TD><SPAN ID="dspBillPrint1"><FONT COLOR="red"><B>�������o��</B></FONT></SPAN></TD>
            <TD><SPAN ID="dspBillPrint2">�F</SPAN></TD>
            <TD><SPAN ID="dspBillPrint3">
                <SELECT NAME="billPrintCntl" ONCHANGE="javascript:document.entryForm.billPrint.value = this.value">
                    <OPTION VALUE="">�w��Ȃ�
                    <OPTION VALUE="1">�{�l
                    <OPTION VALUE="2">�Ƒ�
                </SELECT>
                </SPAN>
            </TD>
        </TR>
        <TR style="height:3px">
            <TD HEIGHT="3"></TD>
        </TR>
        <TR>
            <TD>�ی��؋L��</TD>
            <TD>�F</TD>
            <TD><INPUT TYPE="text" NAME="isrSign" SIZE="28" MAXLENGTH="16" VALUE="<%= strIsrSign %>"></TD>
        </TR>
        <TR>
            <TD>�ی��ؔԍ�</TD>
            <TD>�F</TD>
            <TD><INPUT TYPE="text" NAME="isrNo" SIZE="28" MAXLENGTH="16" VALUE="<%= strIsrNo %>"></TD>
        </TR>
        <TR>
            <%'#### 2008/09/22 �� �ی��Ҕԍ������R�����g�Ƃ��Ďg�����߂Ƀ^�C�g���ύX�i�f�[�^�x�[�X�ύX�Ȃ��j Start ####%>
            <%'###### 2010/05/26 �� �R�����g�����̕ی��Ҕԍ����ɖ߂��i�f�[�^�x�[�X�ύX�Ȃ��j Start ####%>
            <TD>�ی��Ҕԍ�</TD>
            <!--TD style="FONT-WEIGHT: bold;COLOR:red;">�R�����g</TD-->
            <TD>�F</TD>
            <TD><INPUT TYPE="text" NAME="isrManNo" SIZE="28" MAXLENGTH="16" VALUE="<%= strIsrManNo %>" style="ime-mode:inactive;"></TD>
            <!--TD><INPUT TYPE="text" NAME="isrManNo" SIZE="28" MAXLENGTH="16" VALUE="<%= strIsrManNo %>" style="FONT-WEIGHT: bold;COLOR:red;ime-mode:active;"></TD-->
            <%'###### 2010/05/26 �� �R�����g�����̕ی��Ҕԍ����ɖ߂��i�f�[�^�x�[�X�ύX�Ȃ��j End   ####%>
            <%'#### 2008/09/22 �� �ی��Ҕԍ������R�����g�Ƃ��Ďg�����߂Ƀ^�C�g���ύX�i�f�[�^�x�[�X�ύX�Ȃ��j End   ####%>
        </TR>
        <TR style="height:4px">
            <TD HEIGHT="4"></TD>
        </TR>
        <TR>
            <TD>�Ј��ԍ�</TD>
            <TD>�F</TD>
            <TD><INPUT TYPE="text" NAME="empNo" SIZE="20" MAXLENGTH="12" VALUE="<%= strEmpNo %>"></TD>
        </TR>
        <TR style="height:4px">
            <TD HEIGHT="4"></TD>
        </TR>
        <TR>
            <TD>�Љ�Җ�</TD>
            <TD>�F</TD>
            <TD>
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
                    <TR>
                        <TD ID="gdeIntro"><A HREF="javascript:callPersonGuide()"><IMG SRC="/webHains/images/question.gif" HEIGHT="21" WIDTH="21" ALT=""></A></TD>
                        <TD ID="delIntro"><A HREF="javascript:clearPerInfo()"><IMG SRC="/webHains/images/delicon.gif" HEIGHT="21" WIDTH="21" ALT=""></A></TD>
                        <TD NOWRAP><INPUT TYPE="hidden" NAME="introductor" VALUE="<%= strIntroductor %>"><SPAN ID="introductorName"><%= strName %></SPAN></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <!--TR style="height:4px">
            <TD HEIGHT="4"></TD>
        </TR-->

<% '#### 2013.3.1 SL-SN-Y0101-612 ADD START #### %>
        <TR>
            <TD HEIGHT="3" colspan=3><hr></TD>
        </TR>
        <TR>
            <TD NOWRAP>�\��m�F���[��</TD>
            <TD>�F</TD>
            <TD>
                <SELECT NAME="sendMailDiv">
                    <OPTION VALUE="0"<%= IIf(strSendMailDiv = "0", " SELECTED", "") %>>�Ȃ�
                    <OPTION VALUE="1"<%= IIf(strSendMailDiv = "1", " SELECTED", "") %>>�Z���i����j
                    <OPTION VALUE="2"<%= IIf(strSendMailDiv = "2", " SELECTED", "") %>>�Z���i�Ζ���j
                    <OPTION VALUE="3"<%= IIf(strSendMailDiv = "3", " SELECTED", "") %>>�Z���i���̑��j
                </SELECT>
            </TD>
        </TR>
        <TR>
            <TD>���[�����M����</TD>
            <TD>�F</TD>
            <TD><%= strSendMailDate %></TD>
        </TR>
        <TR>
            <TD>���[�����M��</TD>
            <TD>�F</TD>
            <TD><%= strSendMailUserName %></TD>
        </TR>
        <TR>
            <TD HEIGHT="3" colspan=3><hr></TD>
        </TR>
<% '#### 2013.3.1 SL-SN-Y0101-612 ADD END   #### %>

<% '## 2004.11.04 Add By T.Takagi@FSIT �O���f���ǉ� %>
        <!--TR style="height:5px">
            <TD HEIGHT="5"></TD>
        </TR-->
        <TR>
            <TD>�ύX�O�\���</TD>
            <TD>�F</TD>
<%
            If strLastCslDate <> "" Then

                '�I�u�W�F�N�g�̃C���X�^���X�쐬
                Set objCommon = Server.CreateObject("HainsCommon.Common")
%>
                <TD><%= objCommon.FormatString(CDate(strLastCslDate), "yyyy�Nm��d��") %></TD>
<%
                Set objCommon = Nothing

            End If
%>
        </TR>
        <TR style="height:10px">
            <TD HEIGHT="10"></TD>
        </TR>
<% '## 2004.11.04 Add End %>
        <TR>
            <TD>�X�V����</TD>
            <TD>�F</TD>
            <TD><%= strUpdDate %></TD>
        </TR>
        <TR>
            <TD>�X�V��</TD>
            <TD>�F</TD>
            <TD><%= strUpdUserName %></TD>
        </TR>
<%
'## 2004.10.27 Add By T.Takagi@FSIT �X�V�����ւ̑J�ڒǉ�
        '�\��ԍ��w�莞
        If strRsvNo <> "" Then
%>
            <TR>
                <TD><A HREF="javascript:callConsultLogWindow()">�X�V����������</A></TD>
            </TR>
<%
        End If
'## 2004.10.27 Add End
%>
    </TABLE>
</FORM>
<%
'�C�l�[�u������
%>
<SCRIPT TYPE="text/javascript">
<!--
<%
'�V�K�A�L�����Z���ҁA�܂��͕ۗ���Ԃ̏ꍇ�u�������v�A���J�[�͕s�v
'#### 2007/04/04 �� �\��󋵋敪�ǉ��ɂ���ďC�� Start ####
'If strRsvNo = "" Or CLng("0" & strCancelFlg) <> CONSULT_USED Or strRsvStatus = "1" Then
If strRsvNo = "" Or CLng("0" & strCancelFlg) <> CONSULT_USED Or strRsvStatus <> "0" Then
'#### 2007/04/04 �� �\��󋵋敪�ǉ��ɂ���ďC�� End   ####
%>
    document.getElementById('print1').innerHTML = '';
    document.getElementById('print2').innerHTML = '';
    document.getElementById('print3').innerHTML = '';
<%
End If

'�V�K�̏ꍇ�u����󋵂�����v�A���J�[�͕s�v
If strRsvNo = "" Then
%>
    document.getElementById('prtStatus').innerHTML = '';
<%
End If

'�L�����Z���҂̏ꍇ�A���ׂĂ̓��͗v�f���g�p�s�\�ɂ���
If CLng("0" & strCancelFlg) <> CONSULT_USED Then
%>
    var elem = document.entryForm.elements;
    for ( var i = 0; i < elem.length; i++ ) {
        elem[i].disabled = true;
    }

    document.getElementById('gdeIntro').innerHTML = '';
    document.getElementById('delIntro').innerHTML = '';
<%
End If

'��t�ς݂̏ꍇ�A�\��󋵂͎g�p�s�\�ɂ���
If strDayId <> "" Then
%>
    document.entryForm.rsvStatus.disabled = true;
<%
End If

'�������o�͂�\�����Ȃ��ꍇ
'## 2004.01.29 Mod By T.Takagi@FSIT ���ڒǉ�
'If strBillCslDiv = "" Then
If strBillCslDiv = "" And strReptCslDiv = "" Then
'## 2004.01.29 Mod End
%>
    setBillPrintVisibility( false );
<%
'�������o�͂�\������ꍇ
Else
%>
    for ( var i = 0; i < document.entryForm.billPrintCntl.length; i++ ) {
        if ( document.entryForm.billPrintCntl[ i ].value == document.entryForm.billPrint.value ) {
            document.entryForm.billPrintCntl.selectedIndex = i;
            break;
        }
    }
<%
End If

'## 2004.01.13 Add By T.Takagi �ۑ������������@�ύX
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon = Server.CreateObject("HainsCommon.Common")

'���t�ē��ŐV�o�͎�f���Ǝ�f���ǂݍ��ݒ���̎�f���A�y�т͂����A���t�ē��̏o�͏�Ԃ��t���[���e�ɓn��
%>
top.lastFormCslDate = '<%= objCommon.FormatString(strLastFormCslDate, "yyyymmdd") %>';
top.originCslDate   = '<%= objCommon.FormatString(strCslDate,         "yyyymmdd") %>';
top.cardPrinted     = <%= IIf(strCardPrintDate <> "", "true", "false") %>;
top.formPrinted     = <%= IIf(strFormPrintDate <> "", "true", "false") %>;
<%
Set objCommon = Nothing

'�ۑ����������
%>
top.controlPrtOnSave( top.originCslDate );
<%
'## 2004.01.13 Add End
%>
//-->
</SCRIPT>
</BODY>
</HTML>

