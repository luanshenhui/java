<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'        �c�̌����K�C�h(�e��ʂւ̒c�̏��ҏW) (Ver0.0.1)
'        AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objOrganization    '�c�̏��A�N�Z�X�p

'�����l
Dim strOrgCd1        '�c�̃R�[�h�P
Dim strOrgCd2        '�c�̃R�[�h�Q
Dim lngAddrDiv       '�Z���敪

'�c�̏��
Dim strOrgName       '�c�̖���
Dim strOrgSName      '����
Dim strOrgKName      '�c�̃J�i����
Dim strBillCslDiv    '�������{�l�Ƒ��敪�o��

'�c�̏Z�����
Dim strZipCd         '�X�֔ԍ�
Dim strPrefCd        '�s���{���R�[�h
Dim strCityName      '�s�撬����
Dim strAddress1      '�Z���P
Dim strAddress2      '�Z���Q
Dim strDirectTel     '�d�b�ԍ��P
Dim strTel           '�d�b�ԍ��Q
Dim strExtension     '�����P
Dim strFax           '�e�`�w
Dim strEMail         'e-Mail
Dim strUrl           'URL

'## 2004.01.29 Add By T.Takagi@FSIT ���ڒǉ�
Dim strReptCslDiv    '���я��{�l�Ƒ��敪�o��
'## 2004.01.29 Add End

'### 2016.09.19 �� ���t�ē��R�����g�\���ǉ� STR ###
Dim strSendComment   '���t�ē��R�����g
'### 2016.09.19 �� ���t�ē��R�����g�\���ǉ� END ###


'## 2013.12.24 Add By �� ���ڒǉ�
Dim strBillAge    ' �c�̖��̃n�C���C�g�\���敪
Dim strBillSpecial  ' �c�̖��̃n�C���C�g�\���敪
Dim strHighLight    ' �c�̖��̃n�C���C�g�\���敪
'## 2013.12.24 Add End

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

'�����l�̎擾
strOrgCd1  = Request("orgCd1")
strOrgCd2  = Request("orgCd2")
lngAddrDiv = CLng("0" & Request("addrDiv"))

'�c�̏��ǂݍ���
'## 2004.01.29 Mod By T.Takagi@FSIT ���ڒǉ�
'objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2, , strOrgKName, strOrgName, , strOrgSName, , , , , , , , , , , , , , , , , , , , , , strBillCslDiv

'## �c�̖��̃n�C���C�g�\���敪(highLight)�ǉ� 2013.12.24 ��
'objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2, , strOrgKName, strOrgName, , strOrgSName, , , , , , , , , , , , , , , , , , , , , , strBillCslDiv, , , , , , , , , , , , , , , , , , , , , , strReptCslDiv

'### 2016.09.19 �� ���t�ē��R�����g�\���ǉ� STR ###
'objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2, , strOrgKName, strOrgName, , strOrgSName, , , , , , , , , , , , , , , , , , , , , , strBillCslDiv, , , , , , , , , , , , , , , , , , , , , , ,strReptCslDiv,strBillSpecial,strBillAge,strHighLight
objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2, , strOrgKName, strOrgName, , strOrgSName, , , , , , , , , , , , , , , , , , , , , , strBillCslDiv, , , , , strSendComment, , , , , , , , , , , , , , , , , ,strReptCslDiv,strBillSpecial,strBillAge,strHighLight
'### 2016.09.19 �� ���t�ē��R�����g�\���ǉ� END ###
'## 2004.01.29 Mod End

'�c�̏Z�����ǂݍ���
objOrganization.SelectOrgAddr strOrgCd1, strOrgCd2, lngAddrDiv, strZipCd, strPrefCd, strCityName, strAddress1, strAddress2, strDirectTel, strTel, strExtension, strFax, strEMail, strUrl

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�c�̂̌���</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// �c�̃R�[�h�E���̂̃Z�b�g
function selectOrg() {

    // �Ăь��E�B���h�E�����݂���ꍇ
    /** �擾�f�[�^�m�F�̈�              **/
    /**************************************
    alert('<%= strOrgSName %>');
    alert('<%= strReptCslDiv %>');
    alert('<%= strBillSpecial %>');
    alert('<%= strBillAge %>');
    alert('<%= strHighLight %>');
    **************************************/

    if ( opener != null ) {

        // �e��ʂ̒c�̕ҏW�֐��Ăяo��
        if ( opener.orgGuide_setOrgInfo ) {
            opener.orgGuide_setOrgInfo(
                '<%= Replace(strOrgCd1,   "'", "\'") %>',
                '<%= Replace(strOrgCd2,   "'", "\'") %>',
                '<%= Replace(strOrgName,  "'", "\'") %>',
                '<%= Replace(strOrgSName, "'", "\'") %>',
                '<%= Replace(strOrgKName, "'", "\'") %>',
                '',
                '<%= Replace(strZipCd,      "'", "\'") %>',
                '<%= Replace(strPrefCd,     "'", "\'") %>',
                '<%= Replace(strCityName,   "'", "\'") %>',
                '<%= Replace(strAddress1,   "'", "\'") %>',
                '<%= Replace(strAddress2,   "'", "\'") %>',
                '<%= Replace(strDirectTel,  "'", "\'") %>',
                '<%= Replace(strTel,        "'", "\'") %>',
                '<%= Replace(strExtension,  "'", "\'") %>',
                '<%= Replace(strFax,        "'", "\'") %>',
                '<%= Replace(strEMail,      "'", "\'") %>',
                '<%= Replace(strUrl,        "'", "\'") %>',
                '<%= Replace(strBillCslDiv, "'", "\'") %>'
// ## 2004.01.29 Add By T.Takagi@FSIT ���ڒǉ�
                ,'<%= Replace(strReptCslDiv, "'", "\'") %>'
// ## 2004.01.29 Add End
// ## �c�̖��̃n�C���C�g�\���敪(highLight)�ǉ� 2013.12.24 �� Start
                ,'<%= Replace(strHighLight, "'", "\'") %>'
// ## �c�̖��̃n�C���C�g�\���敪(highLight)�ǉ� 2013.12.24 �� End
                ,'<%= Replace(Replace(strSendComment, vbCrLf, ""), "'", "\'") %>'

            );
        }

        // �e��ʂ̊֐��Ăяo��
        if ( opener.orgGuide_CalledFunction != null ) {
            opener.orgGuide_CalledFunction();
        }

        opener.winGuideOrg = null;
    }

    // ����ʂ����
    close();
}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
    body { margin: 10px 0 0 0; }
</style>
</HEAD>
<BODY ONLOAD="JavaScript:selectOrg()">
</BODY>
</HTML>
