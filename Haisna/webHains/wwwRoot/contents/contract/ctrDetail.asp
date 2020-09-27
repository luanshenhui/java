<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       �_����̎Q�ƁE�o�^ (Ver0.0.1)
'       AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editCourseList.inc"       -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editOrgHeader.inc"        -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<!-- #include virtual = "/webHains/includes/EditSetClassList.inc"     -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const MODE_INSERT    = "INS"    '�������[�h(�}��)
Const MODE_UPDATE    = "UPD"    '�������[�h(�X�V)
Const ACTMODE_DELETE = "delete" '���샂�[�h(�폜)

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon           '���ʃN���X
Dim objContract         '�_����A�N�Z�X�p
Dim objContractControl  '�_����A�N�Z�X�p
Dim objCourse           '�R�[�X���A�N�Z�X�p
Dim objFree             '�ėp���A�N�Z�X�p
DIm objOrganization     '�c�̏��A�N�Z�X�p

'�����l
Dim strActMode          '���샂�[�h
Dim strOrgCd1           '�c�̃R�[�h1
Dim strOrgCd2           '�c�̃R�[�h2
Dim strCsCd             '�R�[�X�R�[�h
Dim lngCtrPtCd          '�_��p�^�[���R�[�h
Dim strSubCsCd          '�i�T�u�j�R�[�X�R�[�h
Dim strSetClassCd       '�Z�b�g���ރR�[�h
Dim strCslDivCd         '��f�敪�R�[�h
Dim lngGender           '��f�\����
Dim strStrAge           '�J�n�N��
Dim strEndAge           '�I���N��

'### 2016.08.04 �� ���x�z�ݒ�L���`�F�b�N�̈גǉ� STR ###
Dim strLimitRate        '���x��
Dim lngLimitTaxFlg      '���x�z����Ńt���O
Dim strLimitPrice       '������z
Dim strExceptLimit      '���x�z�ݒ菜�O

Dim strLimitButton      '���x�z�ݒ�{�^���C���[�W�t�@�C���ݒ�
Dim strLimitCheck       '���x�z�ݒ菜�O�}�[�N
'### 2016.08.04 �� ���x�z�ݒ�L���`�F�b�N�̈גǉ� END ###

'�_��Ǘ����
Dim strCsName           '�R�[�X��
Dim strCtrCsName        '(�_����ɂ�����)�R�[�X��
Dim strWebColor         'web�J���[
Dim strStrDate          '�_��J�n��
Dim strEndDate          '�_��I����
Dim strAgeCalc          '�N��N�Z��
Dim strCslMethod        '�\����@

'���S�����
Dim strApDiv            '�K�p���敪
Dim strOrgSName         '�c�̗���
Dim lngCount            '���S�c�̐�

'�I�v�V�����������
Dim strOptCd            '�I�v�V�����R�[�h
Dim strOptBranchNo      '�I�v�V�����}��
Dim strArrWebColor      'web�J���[
Dim strArrSubCsName     '�Ǘ��R�[�X��
Dim strOptName          '�I�v�V������
Dim strSetColor         '�Z�b�g�J���[
Dim strAgeName          '�N�����
Dim strAddCondition     '�ǉ�����
Dim strCslDivName       '��f�敪
Dim strGender           '��f�\����
Dim strSetClassName     '�Z�b�g���ޖ�
Dim strSeq              '�r�d�p
Dim strPrice            '���S���z
Dim strOrgDiv           '�c�̎��
'2005/10/21 Add by ��
Dim strTax              '�����
'2005/10/21 Add End

'### 2016.08.03 �� �Z�b�g�ʍ��v���z�\���̈גǉ� STR ###
Dim lngTotPrice         '�Z�b�g���S���z
Dim lngTotTax           '�Z�b�g�����
'### 2016.08.03 �� �Z�b�g�ʍ��v���z�\���̈גǉ� END ###

Dim lngOptCount         '�I�v�V����������

'�ėp���
Dim strFreeCd           '�ėp�R�[�h
Dim strFreeField1       '�t�B�[���h�P

Dim strMyOrgSName       '���c�̗���
Dim strMessage          '�G���[���b�Z�[�W
Dim strURL              '�W�����v���URL
Dim Ret                 '�֐��߂�l
Dim i, j                '�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon          = Server.CreateObject("HainsCommon.Common")
Set objContract        = Server.CreateObject("HainsContract.Contract")
Set objContractControl = Server.CreateObject("HainsContract.ContractControl")
Set objCourse          = Server.CreateObject("HainsCourse.Course")
Set objOrganization    = Server.CreateObject("HainsOrganization.Organization")

'�����l�̎擾
strActMode    = Request("actMode")
strOrgCd1     = Request("orgCd1")
strOrgCd2     = Request("orgCd2")
strCsCd       = Request("csCd")
lngCtrPtCd    = CLng("0" & Request("ctrPtCd"))
strSubCsCd    = Request("subCsCd")
strSetClassCd = Request("setClassCd")
strCslDivCd   = Request("cslDivCd")
lngGender     = CLng("0" & Request("gender"))
strStrAge     = Request("strAge")
strEndAge     = Request("endAge")

'�폜�����̐���
Do

    '�폜�w�莞�ȊO�͉������Ȃ�
    If strActMode <> ACTMODE_DELETE Then
        Exit Do
    End If

    '�w��_��p�^�[���̌_������폜
    Ret = objContractControl.DeleteContract(strOrgCd1, strOrgCd2, lngCtrPtCd)
    Select Case Ret
        Case 0
        Case 1
            strMessage = "���̌_����͑��c�̂���Q�Ƃ���Ă��܂��B�폜�ł��܂���B"
            Exit Do
        Case 2
            strMessage = "���̌_������Q�Ƃ��Ă����f��񂪑��݂��܂��B�폜�ł��܂���B"
            Exit Do
        Case Else
            Exit Do
    End Select

    '�G���[���Ȃ���Ό_��R�[�X�ꗗ�֖߂�
    strURL = "ctrCourseList.asp"
    strURL = strURL & "?orgCd1=" & strOrgCd1
    strURL = strURL & "&orgCd2=" & strOrgCd2
    Response.Redirect strURL
    Response.End

    Exit Do
Loop

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �N��N�Z�����̕ҏW
'
' �����@�@ : (In)     strAgeCalc  �N��N�Z��
'
' �߂�l�@ : �N��N�Z���ɑ΂��閼��
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function AgeCalcName(strAgeCalc)

    '�N��N�Z���ɂ�鐧��
    Select Case Len(strAgeCalc)
        Case 8
            AgeCalcName = "<B>" & CLng(Left(strAgeCalc, 4)) & "�N" & CLng(Mid(strAgeCalc, 5, 2)) & "��" & CLng(Right(strAgeCalc, 2)) & "��</B>"
        Case 4
            AgeCalcName = "<B>" & CLng(Left(strAgeCalc, 2)) & "��" & CLng(Right(strAgeCalc, 2)) & "��</B>"
        Case Else
            AgeCalcName = "<FONT COLOR=""#666666"">�i��f�����_�̔N��ŋN�Z�j</FONT>"
    End Select

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �\����@�̕ҏW
'
' �����@�@ : (In)     strCslMethod  �\����@
'
' �߂�l�@ : �\����@�ɑ΂��閼��
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CslMethodName(strCslMethod)

'## 2004.01.19 Mod By T.Takagi@FSIT ���e���S���قȂ�
'   '�N��N�Z���ɂ�鐧��
'   Select Case strCslMethod
'       Case "0"
'           CslMethodName = "�l����̓d�b"
'       Case "1"
'           CslMethodName = "�l�i���p���j"
'       Case "2"
'           CslMethodName = "�c�̂���̓d�b"
'       Case Else
'           CslMethodName = ""
'   End Select
    Select Case strCslMethod
        Case "1"
            CslMethodName = "�{�lTEL(�S��)"
        Case "2"
            CslMethodName = "�{�lTEL(FAX�L��)"
        Case "3"
            CslMethodName = "�{�lE-MAIL"
        Case "4"
            CslMethodName = "�S����TEL(�S��)"
        Case "5"
            CslMethodName = "�S���҉��g(FAX)"
        Case "6"
            CslMethodName = "�S���҃��X�g"
        Case "7"
            CslMethodName = "�S����E-MAIL"
        '## 2009.04.20 �� �\����@���ڒǉ��u8�F�S���҉��g(�X��)�v
        Case "8"
            CslMethodName = "�S���҉��g(�X��)"
        Case Else
            CslMethodName = ""
    End Select
'## 2004.01.19 Mod End

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ :�ǉ��������疼�̂ւ̕ϊ�
'
' �����@�@ : (In)     strAddCondition  �ǉ�����
'
' �߂�l�@ : �ǉ������ɑ΂��閼��
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function AddConditionName(strAddCondition)

    '�R�[�h���疼�̂ւ̕ϊ�
    Select Case strAddCondition
        Case "1"
            AddConditionName = "�C��"
        Case Else
            AddConditionName = "&nbsp;"
    End Select

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���ʂ��疼�̂ւ̕ϊ�
'
' �����@�@ : (In)     strGender  ����
'
' �߂�l�@ : ���ʂɑ΂��閼��
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function GenderName(strGender)

    '�R�[�h���疼�̂ւ̕ϊ�
    Select Case strGender
        Case CStr(GENDER_MALE)
            GenderName = "�j��"
        Case CStr(GENDER_FEMALE)
            GenderName = "����"
        Case Else
            GenderName = "&nbsp;"
    End Select

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ��f�N������̎擾����ѕҏW
'
' �����@�@ : (In)     lngCtrPtCd      �_��p�^�[���R�[�h
' �@�@�@�@   (In)     strOptCd        �I�v�V�����R�[�h
' �@�@�@�@   (In)     lngOptBranchNo  �I�v�V�����}��
'
' �߂�l�@ : �ҏW��̎�f�N�����
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function AgeName(lngCtrPtCd, strOptCd, lngOptBranchNo)

    Dim strBuffer   '������ҏW�o�b�t�@

    Dim strStrAge   '��f�ΏۊJ�n�N��
    Dim strEndAge   '��f�ΏۏI���N��
    Dim lngCount    '���R�[�h��
    Dim i           '�C���f�b�N�X

    '�_��p�^�[���I�v�V�����N�������ǂݍ���
    lngCount = objContract.SelectCtrPtOptAge(lngCtrPtCd, strOptCd, lngOptBranchNo, strStrAge, strEndAge)
    If lngCount <= 0 Then
        AgeName = "&nbsp;"
        Exit Function
    End If

    '�S�N��w������������ꍇ�͉����\�������Ȃ�
    If lngCount = 1 Then
        If Int(strStrAge(0)) = 0 And Int(strEndAge(0)) = 999 Then
            Exit Function
        End If
    End If

    '�ő�R�����̕ҏW
    i = 0
    Do Until i >= 3

        '�z����Ō�܂Ō��������ꍇ�͏I��
        If i >= lngCount Then
            Exit Do
        End If

        Do
            '��f�ΏۊJ�n�E�I���N��l���������ꍇ
            If Int(strStrAge(i)) = Int(strEndAge(i)) Then
                strBuffer = strBuffer & IIf(strBuffer <> "", "�A", "") & Int(strStrAge(i)) & "��"
                Exit Do
            End If

            '��f�ΏۊJ�n�N��ŏ��l�̏ꍇ
            If Int(strStrAge(i)) = CInt(AGE_MINVALUE) Then
                strBuffer = strBuffer & IIf(strBuffer <> "", "�A", "") & Int(strEndAge(i)) & "�Έȉ�"
                Exit Do
            End If

            '��f�ΏۏI���N��ŏ��l�̏ꍇ
            If Int(strEndAge(i)) = CInt(AGE_MAXVALUE) Then
                strBuffer = strBuffer & IIf(strBuffer <> "", "�A", "") & Int(strStrAge(i)) & "�Έȏ�"
                Exit Do
            End If

            '��L�ȊO
            strBuffer = strBuffer & IIf(strBuffer <> "", "�A", "") & Int(strStrAge(i)) & "�`" & Int(strEndAge(i)) & "��"

            Exit Do
        Loop

        i = i + 1
    Loop

    '�z����Ō�܂Ō������Ă��Ȃ��ꍇ�́A�Ō���Ɂu���v�ƒǉ�
    If i < lngCount Then
        strBuffer = strBuffer & "��"
    End If

    AgeName = strBuffer

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�_����̎Q�ƁE�o�^</TITLE>
<!-- #include virtual = "/webHains/includes/noteGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
var style = 'status=yes,directories=no,menubar=no,resizable=yes,scrollbars=yes,toolbar=no,location=no';

var winStandard;    // ��{���E�B���h�E�I�u�W�F�N�g
var winLimit;       // ���x�z�ݒ�E�B���h�E�I�u�W�F�N�g
var winPeriod;      // �_����Ԏw��E�B���h�E�I�u�W�F�N�g
var winSplit;       // �_����ԕ����E�B���h�E�I�u�W�F�N�g
var winDemand;      // ���S���E���S���z�ݒ�E�B���h�E�I�u�W�F�N�g
var winOption;      // �I�v�V���������o�^�E�B���h�E�I�u�W�F�N�g
var winOther;       // �_��O��f���ڕ��S���w��E�B���h�E�I�u�W�F�N�g

// ���x�z�ݒ��ʂ�\��
function showStandardWindow() {

    var opened = false; // ��ʂ��J����Ă��邩
    var url;            // ��{����ʂ�URL

    var dialogWidth = 780, dialogHeight = 400;
    var dialogTop, dialogLeft;

    // ���łɃK�C�h���J����Ă��邩�`�F�b�N
    if ( winStandard != null ) {
        if ( !winStandard.closed ) {
            opened = true;
        }
    }

    // ��{����ʂ�URL�ҏW
    url = 'ctrStandard.asp?orgCd1=<%= strOrgCd1 %>&orgCd2=<%= strOrgCd2 %>&ctrPtCd=<%= lngCtrPtCd %>';

    // ��ʂ𒆉��ɕ\�����邽�߂̌v�Z
    dialogTop  = ( screen.height - 80 - dialogHeight ) / 2;
    dialogLeft = ( screen.width  - 5  - dialogWidth  ) / 2;

    // �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
    if ( opened ) {
        winStandard.focus();
    } else {
        winStandard = window.open( url, '', 'width=' + dialogWidth + ',height=' + dialogHeight + ',top=' + dialogTop + ',left=' + dialogLeft + ',' + style);
    }

}

// ���x�z�ݒ��ʂ�\��
function showLimitWindow() {

    var opened = false; // ��ʂ��J����Ă��邩
    var url;            // ���x�z�ݒ��ʂ�URL

    var dialogWidth = 650, dialogHeight = 300;
    var dialogTop, dialogLeft;

    // ���łɃK�C�h���J����Ă��邩�`�F�b�N
    if ( winLimit != null ) {
        if ( !winLimit.closed ) {
            opened = true;
        }
    }

    // ���x�z�ݒ��ʂ�URL�ҏW
    url = 'ctrLimitPrice.asp?orgCd1=<%= strOrgCd1 %>&orgCd2=<%= strOrgCd2 %>&ctrPtCd=<%= lngCtrPtCd %>';

    // ��ʂ𒆉��ɕ\�����邽�߂̌v�Z
    dialogTop  = ( screen.height - 80 - dialogHeight ) / 2;
    dialogLeft = ( screen.width  - 5  - dialogWidth  ) / 2;

    // �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
    if ( opened ) {
        winLimit.focus();
    } else {
        winLimit = window.open( url, '', 'width=' + dialogWidth + ',height=' + dialogHeight + ',top=' + dialogTop + ',left=' + dialogLeft + ',' + style);
    }

}

// ���S���E���S���z�ݒ��ʂ�\��
function showDemandWindow() {

    var opened = false; // ��ʂ��J����Ă��邩
    var url;            // ���S���E���S���z�ݒ��ʂ�URL

    var dialogWidth = 800, dialogHeight = 650;
    var dialogTop, dialogLeft;

    // ���łɃK�C�h���J����Ă��邩�`�F�b�N
    if ( winDemand != null ) {
        if ( !winDemand.closed ) {
            opened = true;
        }
    }

    // ���S���E���S���z�ݒ��ʂ�URL�ҏW
    url = 'ctrDemand.asp?orgCd1=<%= strOrgCd1 %>&orgCd2=<%= strOrgCd2 %>&ctrPtCd=<%= lngCtrPtCd %>';

    // ��ʂ𒆉��ɕ\�����邽�߂̌v�Z
    dialogTop  = ( screen.height - 80 - dialogHeight ) / 2;
    dialogLeft = ( screen.width  - 5  - dialogWidth  ) / 2;

    // �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
    if ( opened ) {
        winDemand.focus();
    } else {
        winDemand = window.open( url, '', 'width=' + dialogWidth + ',height=' + dialogHeight + ',top=' + dialogTop + ',left=' + dialogLeft + ',' + style);
    }

}

// �_����Ԏw���ʂ�\��
function showPeriodWindow() {

    var opened = false; // ��ʂ��J����Ă��邩
    var url;            // �_����Ԏw���ʂ�URL

    var dialogWidth = 800, dialogHeight = 650;
    var dialogTop, dialogLeft;

    // ���łɃK�C�h���J����Ă��邩�`�F�b�N
    if ( winPeriod != null ) {
        if ( !winPeriod.closed ) {
            opened = true;
        }
    }

    // �_����Ԏw���ʂ�URL�ҏW
    url = 'ctrPeriod.asp?orgCd1=<%= strOrgCd1 %>&orgCd2=<%= strOrgCd2 %>&csCd=<%= strCsCd %>&ctrPtCd=<%= lngCtrPtCd %>';

    // ��ʂ𒆉��ɕ\�����邽�߂̌v�Z
    dialogTop  = ( screen.height - 80 - dialogHeight ) / 2;
    dialogLeft = ( screen.width  - 5  - dialogWidth  ) / 2;

    // �J����Ă���ꍇ�͉�ʂ�REPLACE���A�����Ȃ��ΐV�K��ʂ��J��
    if ( opened ) {
        winPeriod.focus();
        winPeriod.location.replace( url );
    } else {
        winPeriod = window.open( url, '', 'width=' + dialogWidth + ',height=' + dialogHeight + ',top=' + dialogTop + ',left=' + dialogLeft + ',' + style);
    }

}

// �_����ԕ�����ʂ�\��
function showSplitWindow() {

    var opened = false; // ��ʂ��J����Ă��邩
    var url;            // �_����ԕ�����ʂ�URL

    var dialogWidth = 600, dialogHeight = 400;
    var dialogTop, dialogLeft;

    // ���łɃK�C�h���J����Ă��邩�`�F�b�N
    if ( winSplit != null ) {
        if ( !winSplit.closed ) {
            opened = true;
        }
    }

    // �_����Ԏw���ʂ�URL�ҏW
    url = 'ctrSplitPeriod.asp?orgCd1=<%= strOrgCd1 %>&orgCd2=<%= strOrgCd2 %>&ctrPtCd=<%= lngCtrPtCd %>';

    // ��ʂ𒆉��ɕ\�����邽�߂̌v�Z
    dialogTop  = ( screen.height - 80 - dialogHeight ) / 2;
    dialogLeft = ( screen.width  - 5  - dialogWidth  ) / 2;

    // �J����Ă���ꍇ�͉�ʂ�REPLACE���A�����Ȃ��ΐV�K��ʂ��J��
    if ( opened ) {
        winSplit.focus();
        winSplit.location.replace( url );
    } else {
        winSplit = window.open( url, '', 'width=' + dialogWidth + ',height=' + dialogHeight + ',top=' + dialogTop + ',left=' + dialogLeft + ',' + style);
    }

}

// �����Z�b�g�o�^��ʂ�\��
function showSetWindow( optCd, optBranchNo ) {

    var opened = false; // ��ʂ��J����Ă��邩
    var url;            // �����Z�b�g�o�^��ʂ�URL

    var dialogWidth = 950, dialogHeight = 688;
    var dialogTop, dialogLeft;

    // ���łɃK�C�h���J����Ă��邩�`�F�b�N
    if ( winOption != null ) {
        if ( !winOption.closed ) {
            opened = true;
        }
    }

    // �����Z�b�g�o�^��ʂ�URL�ҏW
    url = 'ctrSet.asp?orgCd1=<%= strOrgCd1 %>&orgCd2=<%= strOrgCd2 %>&ctrPtCd=<%= lngCtrPtCd %>';
    if ( optCd ) {
        url = url + '&mode='        + '<%= MODE_UPDATE %>';
        url = url + '&optCd='       + optCd;
        url = url + '&optBranchNo=' + optBranchNo;
    } else {
        url = url + '&mode='        + '<%= MODE_INSERT %>';
    }

    // ��ʂ𒆉��ɕ\�����邽�߂̌v�Z
    dialogTop  = ( screen.height - 80 - dialogHeight ) / 2;
    dialogLeft = ( screen.width  - 5  - dialogWidth  ) / 2;

    // �J����Ă���ꍇ�͉�ʂ�REPLACE���A�����Ȃ��ΐV�K��ʂ��J��
    if ( opened ) {
        winOption.focus();
        winOption.location.replace( url );
    } else {
        winOption = window.open( url, '', 'width=' + dialogWidth + ',height=' + dialogHeight + ',top=' + dialogTop + ',left=' + dialogLeft + ',' + style );
    }

}

// �_��O��f���ڕ��S���w���ʂ�\��
function showOtherWindow() {

    var opened = false; // ��ʂ��J����Ă��邩
    var url;            // �_��O��f���ڕ��S���w���ʂ�URL

    var dialogWidth = 800, dialogHeight = 650;
    var dialogTop, dialogLeft;

    // ���łɃK�C�h���J����Ă��邩�`�F�b�N
    if ( winOther != null ) {
        if ( !winOther.closed ) {
            opened = true;
        }
    }

    // �_��O��f���ڕ��S���w���ʂ�URL�ҏW
    url = 'ctrOther.asp?orgCd1=<%= strOrgCd1 %>&orgCd2=<%= strOrgCd2 %>&ctrPtCd=<%= lngCtrPtCd %>';

    // ��ʂ𒆉��ɕ\�����邽�߂̌v�Z
    dialogTop  = ( screen.height - 80 - dialogHeight ) / 2;
    dialogLeft = ( screen.width  - 5  - dialogWidth  ) / 2;

    // �J����Ă���ꍇ�͉�ʂ�REPLACE���A�����Ȃ��ΐV�K��ʂ��J��
    if ( opened ) {
        winOther.focus();
        winOther.location.replace( url );
    } else {
        winOther = window.open( url, '', 'width=' + dialogWidth + ',height=' + dialogHeight + ',top=' + dialogTop + ',left=' + dialogLeft + ',' + style );
    }

}

// �T�u��ʂ����
function closeWindow() {

    // ��{����ʂ����
    if ( winStandard != null ) {
        if ( !winStandard.closed ) {
            winStandard.close();
        }
    }

    // ���x�z�ݒ��ʂ����
    if ( winLimit != null ) {
        if ( !winLimit.closed ) {
            winLimit.close();
        }
    }

    // �_����Ԏw���ʂ����
    if ( winPeriod != null ) {
        if ( !winPeriod.closed ) {
            winPeriod.close();
        }
    }

    // �_����ԕ�����ʂ����
    if ( winSplit != null ) {
        if ( !winSplit.closed ) {
            winSplit.close();
        }
    }

    // ���S���E���S���z�ݒ��ʂ�\��
    if ( winDemand != null ) {
        if ( !winDemand.closed ) {
            winDemand.close();
        }
    }

    // �I�v�V���������o�^��ʂ�\��
    if ( winOption != null ) {
        if ( !winOption.closed ) {
            winOption.close();
        }
    }

    // �_��O��f���ڕ��S���w���ʂ����
    if ( winOther != null ) {
        if ( !winOther.closed ) {
            winOther.close();
        }
    }

    winStandard = null;
    winLimit    = null;
    winPeriod   = null;
    winSplit    = null;
    winDemand   = null;
    winOption   = null;
    winOther    = null;
}
//-->
</SCRIPT>
<style type="text/css">
<!--
    td.mnttab { background-color:#FFFFFF }
-->
</style>
</HEAD>
<BODY ONUNLOAD="JavaScript:closeWindow()">
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
    <BLOCKQUOTE>

    <INPUT TYPE="hidden" NAME="orgCd1"  VALUE="<%= strOrgCd1  %>">
    <INPUT TYPE="hidden" NAME="orgCd2"  VALUE="<%= strOrgCd2  %>">
    <INPUT TYPE="hidden" NAME="csCd"    VALUE="<%= strCsCd    %>">
    <INPUT TYPE="hidden" NAME="ctrPtCd" VALUE="<%= lngCtrPtCd %>">

    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999" WIDTH="85%">
        <TR>
            <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="contract">��</SPAN><FONT COLOR="#000000">�_����̎Q�ƁE�o�^</FONT></B></TD>
        </TR>
    </TABLE>
<%
    '�G���[���b�Z�[�W�̕ҏW
    Call EditMessage(strMessage, MESSAGETYPE_WARNING)
%>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="85%">
        <TR>
            <TD HEIGHT="6"></TD>
        </TR>
        <TR>
            <TD ROWSPAN="3" VALIGN="top">
<%
                '�c�̏��̕ҏW
                Call EditOrgHeader(strOrgCd1, strOrgCd2)
%>
            </TD>
        </TR>
    </TABLE>

    <BR>

    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999" WIDTH="85%">
        <TR>
            <TD NOWRAP BGCOLOR="#eeeeee" HEIGHT="15"><B><FONT COLOR="#333333">���݂̌_����</FONT></B></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" WIDTH="85%">
        <TR><TD HEIGHT="2"></TD></TR>
<%
        '�_��p�^�[�����ǂݍ���

'### 2016.08.04 �� ���x�z�ݒ�L���ɂ���ă{�^���F�ύX STR ########################################################################################################

'        If Not objContract.SelectCtrPt(lngCtrPtCd, strStrDate, strEndDate, strAgeCalc, , strCtrCsName, , strCslMethod) Then
'            Err.Raise 1000, ,"�_���񂪑��݂��܂���B"
'        End If

        If Not objContract.SelectCtrPt(lngCtrPtCd, strStrDate, strEndDate, strAgeCalc, , strCtrCsName, , strCslMethod, strLimitRate, lngLimitTaxFlg, strLimitPrice) Then
            Err.Raise 1000, ,"�_���񂪑��݂��܂���B"
        End If

        If CLng(strLimitRate) > 0 or CLng(strLimitPrice) then
            strLimitButton = "ctr_limit_blue.gif"
        Else
            strLimitButton = "ctr_limit.gif"
        End If
'### 2016.08.04 �� ���x�z�ݒ�L���ɂ���ă{�^���F�ύX STR ########################################################################################################

        '�R�[�X���ǂݍ���
        objCourse.SelectCourse strCsCd, strCsName, , , , , strWebColor
%>
        <TR>
            <TD NOWRAP>��f�R�[�X</TD>
            <TD>�F</TD>
            <TD WIDTH="100%">
                <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">
                    <TR>
                        <TD NOWRAP><FONT COLOR="#<%= strWebColor %>">��</FONT><B><%= strCsName %></B>&nbsp;&nbsp;<FONT COLOR="#999999">�i<%= strCtrCsName %>�j</FONT></TD>
<%
                        '�폜�����pURL�̕ҏW
                        strURL = Request.ServerVariables("SCRIPT_NAME")
                        strURL = strURL & "?actMode=" & ACTMODE_DELETE
                        strURL = strURL & "&orgCd1="  & strOrgCd1
                        strURL = strURL & "&orgCd2="  & strOrgCd2
                        strURL = strURL & "&csCd="    & strCsCd
                        strURL = strURL & "&ctrPtCd=" & lngCtrPtCd

                        '�폜�p�A���J�[��ҏW
%>
                        <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                            <TD ALIGN="right"><A HREF="<%= strURL %>" ONCLICK="javascript:return confirm('���̌_������폜���܂��B��낵���ł����H')"><IMG SRC="/webHains/images/delete.gif" BORDER="0" HEIGHT="24" WIDTH="77" ALT="���̌_������폜���܂�"></A></TD>
                         <%  end if  %>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD>�_�����</TD>
            <TD>�F</TD>
            <TD NOWRAP>
                <B><%= objCommon.FormatString(strStrDate, "yyyy�Nm��d��") %>�`<%= objCommon.FormatString(strEndDate, "yyyy�Nm��d��") %></B><IMG SRC="/webHains/images.spacer.gif" WIDTH="15" HEIGHT="1" ALT="">
                �p�^�[��No.�F<B><%= lngCtrPtCd %></B><IMG SRC="/webHains/images.spacer.gif" WIDTH="15" HEIGHT="1" ALT="">
                �N��N�Z���F<%= AgeCalcName(strAgeCalc) %>
            </TD>
        </TR>
        <TR><TD HEIGHT="2"></TD></TR>
        <TR>
            <TD>�\����@</TD>
            <TD>�F</TD>
            <TD><B><%= CslMethodName(strCslMethod) %></B></TD>
        </TR>
    </TABLE>

    <TABLE WIDTH="85%" BORDER="0" CELLSPACING="5" CELLPADDING="1">
        <TR>
            <TD><A HREF="javascript:showStandardWindow()"><IMG SRC="/webHains/images/ctr_basic.gif" HEIGHT="24" WIDTH="110" ALT="��{����ҏW���܂�"></A></TD>
<%'### 2016.08.04 �� ���x�z�ݒ�L���ɂ���ă{�^���F�ύX STR ########################################################################################################%>
            <!--TD><A HREF="javascript:showLimitWindow()"><IMG SRC="/webHains/images/ctr_limit.gif" HEIGHT="24" WIDTH="110" ALT="���x�z��ݒ肵�܂�"></A></TD-->
            <TD><A HREF="javascript:showLimitWindow()"><IMG SRC="/webHains/images/<%=strLimitButton%>" HEIGHT="24" WIDTH="110" ALT="���x�z��ݒ肵�܂�"></A></TD>
<%'### 2016.08.04 �� ���x�z�ݒ�L���ɂ���ă{�^���F�ύX END ########################################################################################################%>
            <TD WIDTH="110"><A HREF="javascript:showDemandWindow()"><IMG SRC="/webHains/images/burden.gif" BORDER="0" HEIGHT="24" WIDTH="110" ALT="���S������ҏW���܂�"></A></TD>
            <TD WIDTH="110"><A HREF="javascript:showPeriodWindow()"><IMG SRC="/webHains/images/changectr.gif" BORDER="0" HEIGHT="24" WIDTH="110" ALT="�_����Ԃ�ύX���܂�"></A></TD>
            <TD WIDTH="110"><A HREF="javascript:showSplitWindow()"><IMG SRC="/webHains/images/splitctr.gif" BORDER="0" HEIGHT="24" WIDTH="110" ALT="�_����Ԃ𕪊����܂�"></A></TD>
<!--
            <TD WIDTH="110"><A HREF="javascript:showOtherWindow()"><IMG SRC="/webHains/images/noctr.gif" BORDER="0" HEIGHT="24" WIDTH="110" ALT="�_��O���ڂ̕��S���@��ݒ肵�܂�"></A></TD>
-->
            <TD WIDTH="110"><A HREF="javascript:noteGuide_showGuideNote('4', '0,0,0,1', '', '', '<%= strOrgCd1 %>', '<%= strOrgCd2 %>','<%= lngCtrPtCd %>')"><IMG SRC="/webHains/images/ctr_comment.gif" HEIGHT="24" WIDTH="110" ALT="�R�����g��o�^���܂�"></A></TD>
            <TD WIDTH="100%" ALIGN="RIGHT"><A HREF="ctrCourseList.asp?orgCd1=<%= strOrgCd1 %>&orgCd2=<%= strOrgCd2 %>"><IMG SRC="/webHains/images/gotoctrlist.gif" BORDER="0" HEIGHT="24" WIDTH="110" ALT="�_��R�[�X�ꗗ�֖߂�܂�"></A></TD>
        </TR>
    </TABLE>

    <TABLE WIDTH="85%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
        <TR>
            <TD NOWRAP BGCOLOR="#eeeeee" HEIGHT="15"><B><FONT COLOR="#333333">�����Z�b�g�̈ꗗ</FONT></B></TD>
        </TR>
    </TABLE>

    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="85%">
        <TR>
            <TD HEIGHT="5"></TD>
        </TR>
        <TR>
            <TD>
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                    <TR>
                        <TD NOWRAP>�Ǘ��R�[�X�F</TD>
                        <TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_SUB, "subCsCd", strSubCsCd, SELECTED_ALL, False) %></TD>
                        <TD NOWRAP>�Z�b�g���ށF</TD>
                        <TD><%= EditSetClassList("setClassCd", strSetClassCd, SELECTED_ALL) %></TD>
                        <TD NOWRAP>��f�敪�F</TD>
<%
                        '�ėp�e�[�u�������f�敪��ǂݍ���
                        Set objFree = Server.CreateObject("HainsFree.Free")
                        objFree.SelectFree 1, "CSLDIV", strFreeCd, , , strFreeField1
%>
                        <TD><%= EditDropDownListFromArray("cslDivCd", strFreeCd, strFreeField1, strCslDivCd, SELECTED_ALL) %></TD>
                    </TR>
                </TABLE>
            </TD>
            <TD ROWSPAN="2" VALIGN="bottom"><INPUT TYPE="image" NAME="display" SRC="/webHains/images/b_prev.gif" BORDER="0" HEIGHT="28" WIDTH="53" ALT="�\��"></TD>

            <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                <TD ROWSPAN="2" ALIGN="right" VALIGN="top" WIDTH="100%"><A HREF="JavaScript:showSetWindow()"><IMG SRC="/webHains/images/newrsv.gif" BORDER="0" HEIGHT="24" WIDTH="77" ALT="�V���������Z�b�g���쐬���܂�"></A></TD>
            <%  end if  %>

        </TR>
        <TR>
            <TD>
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                    <TR>
                        <TD NOWRAP>���ʁF</TD>
                        <TD>
                            <SELECT NAME="gender">
                                <OPTION VALUE="<%= GENDER_BOTH   %>" <%= IIf(lngGender = GENDER_BOTH,   "SELECTED", "") %>>�j������
                                <OPTION VALUE="<%= GENDER_MALE   %>" <%= IIf(lngGender = GENDER_MALE,   "SELECTED", "") %>>�j���̂�
                                <OPTION VALUE="<%= GENDER_FEMALE %>" <%= IIf(lngGender = GENDER_FEMALE, "SELECTED", "") %>>�����̂�
                            </SELECT>
                        </TD>
                        <TD NOWRAP>�N��F</TD>
                        <TD><%= EditSelectNumberList("strAge", 1, 150, CLng("0" & strStrAge)) %></TD>
                        <TD>�`</TD>
                        <TD><%= EditSelectNumberList("endAge", 1, 150, CLng("0" & strEndAge)) %></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>

    <BR>
<%
    Do
        '�I�v�V�����������ǂݍ���
'       lngOptCount = objContract.SelectCtrPtPriceOptAll(lngCtrPtCd, strSubCsCd, strSetClassCd, strCslDivCd, lngGender, strStrAge, strEndAge, strOptCd, strOptBranchNo, strArrWebColor, strArrSubCsName, strOptName, strSetColor, strAgeName, strAddCondition, strCslDivName, strGender, strSetClassName, strSeq, strPrice, strOrgDiv)

        '2005/10/21 ����Œǉ��BAdd by ��
        lngOptCount = objContract.SelectCtrPtPriceOptAll(lngCtrPtCd, strSubCsCd, strSetClassCd, strCslDivCd, lngGender, strStrAge, strEndAge, strOptCd, strOptBranchNo, strArrWebColor, strArrSubCsName, strOptName, strSetColor, strAgeName, strAddCondition, strCslDivName, strGender, strSetClassName, strSeq, strPrice, strOrgDiv, strTax)
        '2005/10/21 Add End.

        If lngOptCount <= 0 Then
%>
            ���������𖞂��������Z�b�g�͑��݂��܂���B
<%
            Exit Do
        End If
%>
        <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2">
            <TR ALIGN="center" BGCOLOR="#cccccc">
                <TD ROWSPAN="2" COLSPAN="3" NOWRAP>�����Z�b�g��</TD>
                <TD ROWSPAN="2" NOWRAP>���x�z<BR>�ΏۊO</TD>
                <TD COLSPAN="4" NOWRAP>��f����</TD>
<%
                '���c�̗��̂̓ǂݍ���
                objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2, , , , , strMyOrgSName

                '���S���ǂݍ���
                lngCount = objContract.SelectCtrPtOrgPrice(lngCtrPtCd, , , , strApDiv, , , , strOrgSName)

                For i = 0 To lngCount - 1
%>
                    <!--<TD ROWSPAN="2" NOWRAP WIDTH="65"><%= IIf(strApDiv(i) = CStr(APDIV_MYORG), strMyOrgSName, strOrgSName(i)) %></TD>-->
                    <TD COLSPAN="2" NOWRAP><%= IIf(strApDiv(i) = CStr(APDIV_MYORG), strMyOrgSName, strOrgSName(i)) %></TD>
<%
                Next
%>
<%'### 2016.08.04 �� �Z�b�g�ʍ��v���z�\���̈׏C�� STR #######################################################%>
                    <TD COLSPAN="2" NOWRAP BGCOLOR="#C6DBF7">���v�z</TD>
<%'### 2016.08.04 �� �Z�b�g�ʍ��v���z�\���̈׏C�� END #######################################################%>
            </TR>

            <TR ALIGN="center" BGCOLOR="#cccccc">
                <TD NOWRAP>��f�Ώ�</TD>
                <TD NOWRAP>�敪</TD>
                <TD NOWRAP>����</TD>
                <TD NOWRAP>�N��</TD>
<%
                For i = 0 To lngCount - 1
%>
                    <TD NOWRAP>���S���z</TD>
                    <TD NOWRAP>�����</TD>
<%
                Next
%>
<%'### 2016.08.04 �� �Z�b�g�ʍ��v���z�\���̈׏C�� STR #######################################################%>
                <TD NOWRAP BGCOLOR="#C6DBF7">���S���z</TD>
                <TD NOWRAP BGCOLOR="#C6DBF7">�����</TD>
<%'### 2016.08.04 �� �Z�b�g�ʍ��v���z�\���̈׏C�� END #######################################################%>

            </TR>
<%
            '�I�v�V���������̕ҏW
            For i = 0 To lngOptCount - 1


'### 2016.08.04 �� ���x�z�ݒ�ΏۊO�`�F�b�N�ǉ� STR #######################################################
                If Not objContract.SelectCtrPtOpt(lngCtrPtCd, strOptCd(i), Clng(strOptBranchNo(i)),,,,,,,,,strExceptLimit) Then
                    Err.Raise 1000, ,"�_���񂪑��݂��܂���B"
                End If
'### 2016.08.04 �� ���x�z�ݒ�ΏۊO�`�F�b�N�ǉ� END #######################################################

%>
                <TR BGCOLOR="#eeeeee">
                    <TD ALIGN="right" NOWRAP><%= strOptCd(i) %></TD>
                    <TD NOWRAP>-<%= strOptBranchNo(i) %></TD>
                    <TD NOWRAP><FONT COLOR="#<%= strSetColor(i) %>">��</FONT><A HREF="javascript:showSetWindow('<%= strOptCd(i) %>','<%= strOptBranchNo(i) %>')"><%= strOptName(i) %></A></TD>
<%'### 2016.08.04 �� ���x�z�ݒ�ΏۊO�`�F�b�N�ǉ� STR #######################################################%>
                    <TD ALIGN="center" NOWRAP>
<%              If strExceptLimit = "1" Then    %>
                        <IMG SRC="/webHains/images/check.gif" WIDTH="20" HEIGHT="20" ALT="���x�z�ݒ�̑ΏۂƂ��Ȃ�">
<%              End If  %>
                    </TD>
<%'### 2016.08.04 �� ���x�z�ݒ�ΏۊO�`�F�b�N�ǉ� END #######################################################%>
                    <TD ALIGN="center" NOWRAP><%= AddConditionName(strAddCondition(i)) %></TD>
                    <TD NOWRAP><%= strCslDivName(i) %></TD>
                    <TD ALIGN="center" NOWRAP><%= GenderName(strGender(i)) %></TD>
                    <TD NOWRAP><%= strAgeName(i) %></TD>
<%
'### 2016.08.04 �� �Z�b�g�ʍ��v���z�\���̈׏C�� STR #######################################################
                    lngTotPrice = 0
                    lngTotTax   = 0
'### 2016.08.04 �� �Z�b�g�ʍ��v���z�\���̈׏C�� END #######################################################
                    For j = 0 To UBound(strPrice, 1)
%>
                        <TD ALIGN="right" NOWRAP><%= FormatCurrency(strPrice(j, i)) %></TD>
                        <TD ALIGN="right" NOWRAP><%= FormatCurrency(strTax(j, i)) %></TD>
<%
'### 2016.08.04 �� �Z�b�g�ʍ��v���z�\���̈׏C�� STR #######################################################
                        lngTotPrice = lngTotPrice + CLng(strPrice(j, i))
                        lngTotTax   = lngTotTax + CLng(strTax(j, i))
'### 2016.08.04 �� �Z�b�g�ʍ��v���z�\���̈׏C�� END #######################################################
                    Next
%>
<%'### 2016.08.04 �� �Z�b�g�ʍ��v���z�\���̈׏C�� STR #######################################################%>
                    <TD ALIGN="right" NOWRAP BGCOLOR="#EFF3FF"><%= FormatCurrency(CStr(lngTotPrice)) %></TD>
                    <TD ALIGN="right" NOWRAP BGCOLOR="#EFF3FF"><%= FormatCurrency(CStr(lngTotTax)) %></TD>
<%'### 2016.08.04 �� �Z�b�g�ʍ��v���z�\���̈׏C�� END #######################################################%>

                </TR>
<%
            Next
%>
        </TABLE>
<%
        Exit Do
    Loop
%>
    </BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>