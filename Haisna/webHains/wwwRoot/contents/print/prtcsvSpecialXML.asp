<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'	���茒�f����CSV�o�́iXML�p�j (Ver0.0.1)
'	AUTHER  :
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/print.inc"                -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<!-- #include virtual = "/webHains/includes/editOrgGrp_PList.inc"     -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim strMode         '������[�h
Dim vntMessage      '�ʒm���b�Z�[�W
Dim MSGMODE

'-------------------------------------------------------------------------------
' �ŗL�錾���i�e���[�ɉ����Ă��̃Z�N�V�����ɕϐ����`���ĉ������j
'-------------------------------------------------------------------------------
'COM�I�u�W�F�N�g
Dim objCommon       '���ʃN���X
Dim objOrganization '�c�̏��A�N�Z�X�p
Dim objOrgBsd       '���ƕ����A�N�Z�X�p
Dim objOrgRoom      '�������A�N�Z�X�p
Dim objOrgPost      '�������A�N�Z�X�p
Dim objPerson       '�l���A�N�Z�X�p

'### 2013/02/04 �� �o�͏����Ɏ�f�敪�ǉ��̈גǉ� ###
Dim objFree         '�ėp���A�N�Z�X�p

'�������������������� ��ʍ��ڂɂ��킹�ĕҏW
'�����l
Dim strSCslYear, strSCslMonth, strSCslDay   '�J�n�N����
Dim strECslYear, strECslMonth, strECslDay   '�I���N����
Dim strCsCd                                 '�R�[�X�R�[�h
Dim strOrgCd1, strOrgCd2                    '�c�̃R�[�h
Dim strOrgBsdCd, strOrgRoomCd               '���ƕ��R�[�h, �����R�[�h
Dim strSOrgPostCd, strEOrgPostCd            '�J�n�����R�[�h, �I�������R�[�h
Dim strPerId                                '�l�R�[�h
Dim strObject                               '�o�͑Ώ�
'��������������������

'��Ɨp�ϐ�
Dim strOrgName          '�c�̖�
Dim strBsdName          '���ƕ���
Dim strRoomName         '������
Dim strSPostName        '�J�n������
Dim strEPostName        '�I��������
Dim strLastName         '��
Dim strFirstName        '��
Dim strPerName          '����
Dim strSCslDate         '�J�n��
Dim strECslDate         '�I����

Dim strOrgGrpCd         '�c�̃O���[�v�R�[�h
Dim strOrgCd11          '�c�̃R�[�h�P�P
Dim strOrgCd12          '�c�̃R�[�h�P�Q
Dim strOrgCd21          '�c�̃R�[�h�Q�P
Dim strOrgCd22          '�c�̃R�[�h�Q�Q
Dim strOrgCd31          '�c�̃R�[�h�R�P
Dim strOrgCd32          '�c�̃R�[�h�R�Q
Dim strOrgCd41          '�c�̃R�[�h�S�P
Dim strOrgCd42          '�c�̃R�[�h�S�Q
Dim strOrgCd51          '�c�̃R�[�h�T�P
Dim strOrgCd52          '�c�̃R�[�h�T�Q

Dim strOrgGrpName           '�c�̃O���[�v����
Dim strOrgName1         '�c�̂P����
Dim strOrgName2         '�c�̂Q����
Dim strOrgName3         '�c�̂R����
Dim strOrgName4         '�c�̂S����
Dim strOrgName5         '�c�̂T����

'2009.03.03�i���j���f�R�[�X�敪�A�o�͍��ڋ敪
Dim strCourseCd         '���f�R�[�X�敪�R�[�h
Dim strSpItem           '���茒�f���ڂƈ�ʍ��ڋ敪

'### 2013/02/04 �� �o�͏����Ɏ�f�敪�ǉ� ###
Dim strCslDivCd         '��f�敪�R�[�h

'### 2017/02/03 �� �o�͏����ɐ������o�͋敪�ǉ�
Dim strBillPrint        '�������o�͋敪�R�[�h

'2009.06.01 (��) �c�̐����֘A�ϐ��ǉ�
Dim strOrgBill          '�c�̐����Ώ�


Dim strBillOrgCd1       '�����Ώےc�̃R�[�h�P
Dim strBillOrgCd2       '�����Ώےc�̃R�[�h�Q
Dim strBillOrgName      '�����Ώےc�̖���

'�ėp���
Dim strFreeCd           '�ėp�R�[�h
Dim strFreeDate         '�ėp���t
Dim strFreeField1       '�t�B�[���h�P
Dim strFreeField2       '�t�B�[���h�Q

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objOrgBsd       = Server.CreateObject("HainsOrgBsd.OrgBsd")
Set objOrgRoom      = Server.CreateObject("HainsOrgRoom.OrgRoom")
Set objOrgPost      = Server.CreateObject("HainsOrgPost.OrgPost")
Set objPerson       = Server.CreateObject("HainsPerson.Person")

'���ʈ����l�̎擾
strMode = Request("mode")

'���[�o�͏�������
vntMessage = PrintControl(strMode)

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : URL�����l�̎擾
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ : URL�̈����l���擾���鏈�����L�q���ĉ�����
'
'-------------------------------------------------------------------------------
Sub GetQueryString()
'�������������������� ��ʍ��ڂɂ��킹�ĕҏW
    '���ʓ��̕������HTML���ŋL�q�������ڂ̖��̂ƂȂ�܂�

'�� �J�n�N����
    If IsEmpty(Request("strCslYear")) Then
        strSCslYear   = Year(Now())             '�J�n�N
        strSCslMonth  = Month(Now())            '�J�n��
        strSCslDay    = Day(Now())              '�J�n��
    Else
        strSCslYear   = Request("strCslYear")   '�J�n�N
        strSCslMonth  = Request("strCslMonth")  '�J�n��
        strSCslDay    = Request("strCslDay")    '�J�n��
    End If
    strSCslDate   = strSCslYear & "/" & strSCslMonth & "/" & strSCslDay
'�� �I���N����
    If IsEmpty(Request("endCslYear")) Then
        strECslYear   = Year(Now())             '�I���N
        strECslMonth  = Month(Now())            '�J�n��
        strECslDay    = Day(Now())              '�J�n��
    Else
        strECslYear   = Request("endCslYear")   '�I���N
        strECslMonth  = Request("endCslMonth")  '�J�n��
        strECslDay    = Request("endCslDay")    '�J�n��
    End If
    strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay

'�� �J�n�N�����ƏI���N�����̑召����Ɠ���
'   �i���t�^�ɕϊ����ă`�F�b�N���Ȃ��͓̂��t�Ƃ��Č�����l�ł������Ƃ��̃G���[����ׁ̈j
    If Right("0000" & Trim(CStr(strSCslYear)), 4) & _
       Right("00" & Trim(CStr(strSCslMonth)), 2) & _
       Right("00" & Trim(CStr(strSCslDay)), 2) _
     > Right("0000" & Trim(CStr(strECslYear)), 4) & _
       Right("00" & Trim(CStr(strECslMonth)), 2) & _
       Right("00" & Trim(CStr(strECslDay)), 2) Then
        strSCslYear   = strECslYear
        strSCslMonth  = strECslMonth
        strSCslDay    = strECslDay
        strSCslDate   = strECslDate
        strECslYear   = Request("strCslYear")   '�J�n�N
        strECslMonth  = Request("strCslMonth")  '�J�n��
        strECslDay    = Request("strCslDay")    '�J�n��
        strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
    End If


'�� �c�̃O���[�v�R�[�h
    strOrgGrpCd = Request("OrgGrpCd")
    strOrgGrpName = Request("OrgGrpName")

'�� �c�̃R�[�h
    '�c�̂P
    strOrgCd11  = Request("OrgCd11")
    strOrgCd12  = Request("OrgCd12")
    strOrgName1 = Request("OrgName1")
    '�c�̂Q
    strOrgCd21  = Request("OrgCd21")
    strOrgCd22  = Request("OrgCd22")
    strOrgName2 = Request("OrgName2")
    '�c�̂R
    strOrgCd31  = Request("OrgCd31")
    strOrgCd32  = Request("OrgCd32")
    strOrgName3 = Request("OrgName3")
    '�c�̂S
    strOrgCd41  = Request("OrgCd41")
    strOrgCd42  = Request("OrgCd42")
    strOrgName4 = Request("OrgName4")
    '�c�̂T
    strOrgCd51  = Request("OrgCd51")
    strOrgCd52  = Request("OrgCd52")
    strOrgName5 = Request("OrgName5")
    '���f�R�[�X
    strCourseCd = Request("Course")
    '���f����
    strSpItem   = Request("SpItem")


'### 2012/10/30 �� 2012�N10��1������̖�f�[�ύX�ɔ������ڋ敪�ݒ�i2012�N10��1����jStart ###


'### 2013/03/08 �� 2013�N4��1������̓��茒�f�E����ی��w�������֘A�V�X�e���ύX Start ###
'    If CDate(GetVer201210()) <= CDate(strSCslDate)  Then
'        If strSpItem = "" Then
'            strSpItem = "1"
'        Else
'            strSpItem = "2"
'        End If
'    End If

    If CDate(GetVersion("CHG201304")) <= CDate(strSCslDate)  Then

        If strSpItem = "A" Then
            strSpItem = "A201304"
        Else
            strSpItem = "S201304"
        End If

    Elseif CDate(GetVersion("CHG201210")) <= CDate(strSCslDate)  Then

        If strSpItem = "A" Then
            strSpItem = "A201210"
        Else
            strSpItem = "S201210"
        End If

    End If
'### 2013/03/08 �� 2013�N4��1������̓��茒�f�E����ی��w�������֘A�V�X�e���ύX End   ###


'### 2012/10/30 �� 2012�N10��1������̖�f�[�ύX�ɔ������ڋ敪�ݒ�i2012�N10��1����jEnd   ###



'### 2013/02/04 �� �o�͏����Ɏ�f�敪�ǉ��̈גǉ� ###
'�� ��f�敪�R�[�h
    strCslDivCd     = Request("cslDivCd")

'### 2017/02/03 �� �o�͏����ɐ������o�͋敪�ǉ� STR ###
'�� �������o�͋敪�R�[�h
    strBillPrint    = Request("billPrint")
'### 2017/02/03 �� �o�͏����ɐ������o�͋敪�ǉ� END ###

    '�c�̐����Ώ�
    strOrgBill  = Request("orgBill")

    '�����Ώےc��
    strBillOrgCd1  = Request("billOrgCd1")
    strBillOrgCd2  = Request("billOrgCd2")
    strBillOrgName = Request("BillOrgName")



'��������������������
End Sub

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �����l�̑Ó����`�F�b�N���s��
'
' �����@�@ :
'
' �߂�l�@ : �G���[�l������ꍇ�A�G���[���b�Z�[�W�̔z���Ԃ�
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CheckValue()

    Dim vntArrMessage   '�G���[���b�Z�[�W�̏W��

'�������������������� ��ʍ��ڂɂ��킹�ĕҏW
    '�����Ƀ`�F�b�N�������L�q
    With objCommon
'��)		.AppendArray vntArrMessage, �R�����g

        If strMode <> "" Then
            If Not IsDate(strSCslDate) Then
                .AppendArray vntArrMessage, "�J�n���t������������܂���B"
            End If

            If Not IsDate(strECslDate) Then
                .AppendArray vntArrMessage, "�I�����t������������܂���B"
            End If
        End If

'### 2012/10/30 �� 2012�N10��1������̖�f�[�ύX�ɔ������ڋ敪�ݒ�i2012�N10��1����jStart ###
'        If CDate(strSCslDate) < CDate(GetVer201210()) and  CDate(strECslDate) >= CDate(GetVer201210()) Then
'            .AppendArray vntArrMessage, "2012�N10��1�����܂�������t�ݒ�͂ł��܂���B�i��f�[�ύX�ׁ̈j"
'        End If

        If CDate(strSCslDate) < CDate(GetVersion("CHG201210")) and  CDate(strECslDate) >= CDate(GetVersion("CHG201210")) Then
            .AppendArray vntArrMessage, "2012�N10��1�����܂�������t�ݒ�͂ł��܂���B�i��f�[�ύX�ׁ̈j"
        End If

'### 2012/10/30 �� 2012�N10��1������̖�f�[�ύX�ɔ������ڋ敪�ݒ�i2012�N10��1����jEnd   ###


'### 2013/03/08 �� 2013�N4��1������̓��茒�f�E����ی��w�������֘A�V�X�e���ύX Start ###
        If CDate(strSCslDate) < CDate(GetVersion("CHG201304")) and  CDate(strECslDate) >= CDate(GetVersion("CHG201304")) Then
            .AppendArray vntArrMessage, "2013�N4��1�����܂�������t�ݒ�͂ł��܂���B�i���茒�f�E����ی��w�������ׁ̈j"
        End If
'### 2013/03/08 �� 2013�N4��1������̓��茒�f�E����ی��w�������֘A�V�X�e���ύX End   ###

        If strOrgCd11 = "" and strOrgCd21 = "" and strOrgCd31 = "" and strOrgCd41 = "" and strOrgCd51 = "" and strOrgGrpCd = "" Then
            .AppendArray vntArrMessage, "�c�̂�I�����Ă��������B"
        End If

        If strOrgBill = "1" then
            If strBillOrgCd1 = "" then
                .AppendArray vntArrMessage, "�����Ώےc�̂�I��ł��������B"
            End If
        End If

    End With
'��������������������

    '�߂�l�̕ҏW
    If IsArray(vntArrMessage) Then
        CheckValue = vntArrMessage
    End If

End Function




'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���[�h�L�������g�t�@�C���쐬����
'
' �����@�@ :
'
' �߂�l�@ : ������O���̃V�[�P���X�l
'
' ���l�@�@ : ���[�h�L�������g�t�@�C���쐬���\�b�h���Ăяo���B���\�b�h���ł͎��̏������s����B
' �@�@�@�@   ?@������O���̍쐬
' �@�@�@�@   ?A���[�h�L�������g�t�@�C���̍쐬
' �@�@�@�@   ?B�����������͈�����O��񃌃R�[�h�̎�L�[�ł���v�����gSEQ��߂�l�Ƃ��ĕԂ��B
' �@�@�@�@   ����SEQ�l�����Ɉȍ~�̃n���h�����O���s���B
'
'-------------------------------------------------------------------------------
Function Print()

    Dim objCommon   '���ʃN���X
    Dim objPrintCls '�c�̈ꗗ�o�͗pCOM�R���|�[�l���g
    Dim Ret         '�֐��߂�l

    Dim strURL

    If Not IsArray(CheckValue()) Then

        '���R�����΍��p���O�����o��
        Call putPrivacyInfoLog("PH110", "���茒�f���ڌ��f����XML�ϊ��pCSV�o�͇@�B���t�@�C���o�͂��s����")

''''''''''''''''''�������������������� ��ʍ��ڂɂ��킹�ĕҏW
'''''''''''''''''       '�I�u�W�F�N�g�̃C���X�^���X�쐬�i�v���W�F�N�g��.�N���X���j
        Set objPrintCls = Server.CreateObject("HainsAbsenceListXML.AbsenceListXML")
'''''''''''''''''       '�v���W�F�N�g���̓\�[�X���J���Ċm�F�B
'''''''''''''''''
'''''''''''''''''       '�c�̈ꗗ�\�h�L�������g�t�@�C���쐬�����i�I�u�W�F�N�g.���\�b�h��(����)�j
''    Ret = objPrintCls.PrintAbsenceListXML(Session("USERID"), CDate(strSCslDate), CDate(strECslDate), strOrgGrpCd, strOrgCd11, strOrgCd12,strOrgCd21, strOrgCd22, strOrgCd31, strOrgCd32, strOrgCd41, strOrgCd42, strOrgCd51, strOrgCd52)

'''''''''''''''''       '2009.03.03 (��) ���f�R�[�X�敪�A�o�͍��ڋ敪�p�����[�^�[�ǉ�       
''    Ret = objPrintCls.PrintAbsenceListXML(Session("USERID"), CDate(strSCslDate), CDate(strECslDate), strOrgGrpCd, strOrgCd11, strOrgCd12,strOrgCd21, strOrgCd22, strOrgCd31, strOrgCd32, strOrgCd41, strOrgCd42, strOrgCd51, strOrgCd52, strCourseCd, strSpItem)

'''''''''''''''''       '2009.06.01 (��) �c�̐����Ώۂ̂ݏo�͂��邽�߃p�����[�^�[�ǉ�
''    Ret = objPrintCls.PrintAbsenceListXML(Session("USERID"), CDate(strSCslDate), CDate(strECslDate), strOrgGrpCd, strOrgCd11, strOrgCd12,strOrgCd21, strOrgCd22, strOrgCd31, strOrgCd32, strOrgCd41, strOrgCd42, strOrgCd51, strOrgCd52, strCourseCd, strSpItem, strOrgBill, strBillOrgCd1, strBillOrgCd2)

'### 2013/02/04 �� �o�͏����Ɏ�f�敪�ǉ��̈׃p�����[�^�ǉ� ###
'### 2017/02/03 �� �o�͏����ɐ������敪�istrBillPrint�j�ǉ��̈׃p�����[�^�ǉ� ###
'    Ret = objPrintCls.PrintAbsenceListXML(Session("USERID"), CDate(strSCslDate), CDate(strECslDate), strOrgGrpCd, strOrgCd11, strOrgCd12,strOrgCd21, strOrgCd22, strOrgCd31, strOrgCd32, strOrgCd41, strOrgCd42, strOrgCd51, strOrgCd52, strCourseCd, strSpItem, strCslDivCd, strOrgBill, strBillOrgCd1, strBillOrgCd2)
    Ret = objPrintCls.PrintAbsenceListXML(Session("USERID"), CDate(strSCslDate), CDate(strECslDate), strOrgGrpCd, strOrgCd11, strOrgCd12,strOrgCd21, strOrgCd22, strOrgCd31, strOrgCd32, strOrgCd41, strOrgCd42, strOrgCd51, strOrgCd52, strCourseCd, strSpItem, strCslDivCd, strBillPrint, strOrgBill, strBillOrgCd1, strBillOrgCd2)


''''''''''''''''''��������������������
'''''''''''''''''
      Print = Ret

    End If

End Function
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">

<!--- �� ��<Title>�̏C����Y��Ȃ��悤�� �� -->

<TITLE>���茒�f����CSV�o��</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
    // �c�̉�ʕ\��
    function showGuideOrgGrp( Cd1, Cd2, CtrlName ) {

        // �c�̏��G�������g�̎Q�Ɛݒ�
        orgPostGuide_getElement( Cd1, Cd2, CtrlName );
        // ��ʕ\��
        orgPostGuide_showGuideOrg();

    }

    // �c�̏��폜
    function clearGuideOrgGrp( Cd1, Cd2, CtrlName ) {

        // �c�̏��G�������g�̎Q�Ɛݒ�
        orgPostGuide_getElement( Cd1, Cd2, CtrlName );

        // �폜
        orgPostGuide_clearOrgInfo();

    }

    // �G�������g�̎Q�Ɛݒ�
    function setElement() {
    }

    function checkBillOrg(){
        with(document.entryForm)
        {
            if(orgBill.checked == true && billOrgCd1.value == ""){
                alert("�����c�̂�I�����Ă��������I�I�I");
            }else{
                submit();
            }
        }
    }

//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.prttab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONLOAD="javascript:setElement()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
    <BLOCKQUOTE>

<!--- �^�C�g�� -->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">��</SPAN>���茒�f����CSV�o�́iXML�p�j</B></TD>
        </TR>
    </TABLE>
<%
'�G���[���b�Z�[�W�\��

    Call EditMessage(vntMessage, MESSAGETYPE_WARNING)
%>
    <BR>

    <INPUT TYPE="hidden" NAME="orgCd11"       VALUE="<%= strOrgCd11 %>">
    <INPUT TYPE="hidden" NAME="orgCd12"       VALUE="<%= strOrgCd12 %>">
    <INPUT TYPE="hidden" NAME="orgCd21"       VALUE="<%= strOrgCd21 %>">
    <INPUT TYPE="hidden" NAME="orgCd22"       VALUE="<%= strOrgCd22 %>">
    <INPUT TYPE="hidden" NAME="orgCd31"       VALUE="<%= strOrgCd31 %>">
    <INPUT TYPE="hidden" NAME="orgCd32"       VALUE="<%= strOrgCd32 %>">
    <INPUT TYPE="hidden" NAME="orgCd41"       VALUE="<%= strOrgCd41 %>">
    <INPUT TYPE="hidden" NAME="orgCd42"       VALUE="<%= strOrgCd42 %>">
    <INPUT TYPE="hidden" NAME="orgCd51"       VALUE="<%= strOrgCd51 %>">
    <INPUT TYPE="hidden" NAME="orgCd52"       VALUE="<%= strOrgCd52 %>">
<!-- �����c�̑Ώۃ`�F�b�N -->
    <INPUT TYPE="hidden" NAME="billOrgCd1"       VALUE="<%= strBillOrgCd1 %>">
    <INPUT TYPE="hidden" NAME="billOrgCd2"       VALUE="<%= strBillOrgCd2 %>">

<!--- ���t -->
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD><FONT COLOR="#ff0000">��</FONT></TD>
            <TD WIDTH="90" NOWRAP>��f��</TD>
            <TD>�F</TD>
            <TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
            <TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strSCslYear, False) %></TD>
            <TD>�N</TD>
            <TD><%= EditNumberList("strCslMonth", 1, 12, strSCslMonth, False) %></TD>
            <TD>��</TD>
            <TD><%= EditNumberList("strCslDay", 1, 31, strSCslDay, False) %></TD>
            <TD>��</TD>

            <TD>�`</TD>
            <TD><A HREF="javascript:calGuide_showGuideCalendar('endCslYear', 'endCslMonth', 'endCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
            <TD><%= EditNumberList("endCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strECslYear, False) %></TD>
            <TD>�N</TD>
            <TD><%= EditNumberList("endCslMonth", 1, 12, strECslMonth, False) %></TD>
            <TD>��</TD>
            <TD><%= EditNumberList("endCslDay", 1, 31, strECslDay, False) %></TD>
            <TD>��</TD>
        </TR>
    </TABLE>
    <BR>

    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD>��</TD>
            <TD WIDTH="90" NOWRAP>�c�̂P</TD>
            <TD>�F</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd11, document.entryForm.orgCd12, 'OrgName1')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd11, document.entryForm.orgCd12, 'OrgName1')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName1"><% = strOrgName1 %></SPAN></TD>
        </TR>
        <TR>
            <TD>��</TD>
            <TD WIDTH="90" NOWRAP>�c�̂Q</TD>
            <TD>�F</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd21, document.entryForm.orgCd22, 'OrgName2')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd121, document.entryForm.orgCd22, 'OrgName2')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName2"><% = strOrgName2 %></SPAN></TD>
        </TR>
        <TR>
            <TD>��</TD>
            <TD WIDTH="90" NOWRAP>�c�̂R</TD>
            <TD>�F</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd31, document.entryForm.orgCd32, 'OrgName3')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd131, document.entryForm.orgCd32, 'OrgName3')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName3"><% = strOrgName3 %></SPAN></TD>
        </TR>
        <TR>
            <TD>��</TD>
            <TD WIDTH="90" NOWRAP>�c�̂S</TD>
            <TD>�F</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd41, document.entryForm.orgCd42, 'OrgName4')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd141, document.entryForm.orgCd42, 'OrgName4')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName4"><% = strOrgName4 %></SPAN></TD>
        </TR>
        <TR>
            <TD>��</TD>
            <TD WIDTH="90" NOWRAP>�c�̂T</TD>
            <TD>�F</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd51, document.entryForm.orgCd52, 'OrgName5')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd151, document.entryForm.orgCd52, 'OrgName5')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName5"><% = strOrgName5 %></SPAN></TD>
        </TR>
    </TABLE>

    <!-- �c�̃O���[�v -->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
        <TR>
            <TD>��</TD>
            <TD WIDTH="90" NOWRAP>�c�̃O���[�v</TD>
            <TD>�F</TD>
            <TD><%= EditOrgGrp_PList("OrgGrpCd", strOrgGrpCd, NON_SELECTED_ADD) %></TD>
        </TR>
    </TABLE> 
    <BR>

    <!-- ���f�R�[�X�敪 -->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
        <TR>
            <TD>��</TD>
            <TD WIDTH="90" NOWRAP>���f�R�[�X�敪</TD>
            <TD>�F</TD>
            <TD>
                <SELECT NAME="Course">
                    <OPTION VALUE=""></OPTION>
                    <OPTION VALUE="100">����l�ԃh�b�N</OPTION>
<!--### 2011.04.25 SL-SN-Y0101-002 ADD �� �E��������N�f�f�i�h�b�N�j�����o�Ώۂɂ���׎d�l�ύX Start ###-->
                    <OPTION VALUE="105">�E��������f�i�h�b�N�j</OPTION>
<!--### 2011.04.25 SL-SN-Y0101-002 ADD �� �E��������N�f�f�i�h�b�N�j�����o�Ώۂɂ���׎d�l�ύX End   ###-->
                    <OPTION VALUE="110">��ƌ��f</OPTION>
                </SELECT>
            </TD>
         
        </TR>
    </TABLE>

    <!-- �o�͍��ڋ敪 -->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
        <TR>
            <TD>��</TD>
            <TD WIDTH="90" NOWRAP>�o�͍��ڋ敪</TD>
            <TD>�F</TD>
            <TD>
                <SELECT NAME="SpItem">
                    <!--��ʌ��f���ڂƓ��茒�f���ڂ��敪���Č��ʎ擾-->
                    <!--OPTION VALUE="">���H���t�H�[�}�b�g</OPTION>
                    <OPTION VALUE="0">���茒�f����</OPTION-->
                    <OPTION VALUE="A">���H���t�H�[�}�b�g</OPTION>
                    <OPTION VALUE="S">���茒�f����</OPTION>
                </SELECT>
            </TD>  
        </TR>
    </TABLE>
    <BR>

<!-- 2009.06.01 �c�̐����Ώۂ̂ݏo�͂��邽�ߒǉ� START -->
    <!--  �c�̐����Ώێ� -->
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD>��</TD>
            <TD WIDTH="90" NOWRAP>�c�̐����Ώ�</TD>
            <TD>�F</TD>
            <TD>
                <TABLE BORDER="0" CELLPADDING="5" CELLSPACING="0">
                    <TR>
                        <TD><INPUT TYPE="CHECKBOX" NAME="orgBill" VALUE="1" <%= IIF(strOrgBill = "1","CHECKED","") %>>�c�̐����Ώێ҂̂�</TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>

    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD>��</TD>
            <TD WIDTH="90" NOWRAP>�����Ώےc��</TD>
            <TD>�F</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.billOrgCd1, document.entryForm.billOrgCd2, 'BillOrgName')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.billOrgCd1, document.entryForm.billOrgCd2, 'BillOrgName')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
            <TD NOWRAP><SPAN ID="BillOrgName"><% = strBillOrgName %></SPAN></TD>
        </TR>
    </TABLE>
<!-- 2009.06.01 �c�̐����Ώۂ̂ݏo�͂��邽�ߒǉ� END -->

<% '### 2013/02/04 �� �o�͏����Ɏ�f�敪�ǉ� Start ### %>
    <!-- ��f�敪 -->
    <BR>
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
        <TR>
            <TD>��</TD>
            <TD WIDTH="90" NOWRAP>��f�敪</TD>
            <TD>�F</TD>
<%
            '�ėp�e�[�u�������f�敪��ǂݍ���
            Set objFree = Server.CreateObject("HainsFree.Free")
            objFree.SelectFree 1, "CSLDIV", strFreeCd, , , strFreeField1
            Set objFree = Nothing
%>
            <TD><%= EditDropDownListFromArray("cslDivCd", strFreeCd, strFreeField1, strCslDivCd, NON_SELECTED_ADD) %></TD>
        </TR>
    </TABLE>
<% '### 2013/02/04 �� �o�͏����Ɏ�f�敪�ǉ� End   ### %>

<% '### 2017/02/03 �� �o�͏����ɐ������o�͋敪�ǉ� STR ### %>
    <!-- �������o�͋敪 -->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
        <TR>
            <TD>��</TD>
            <TD WIDTH="90" NOWRAP>�������o��</TD>
            <TD>�F</TD>
            <TD>
                <SELECT NAME="billPrint">
                    <OPTION VALUE=""></OPTION>
                    <OPTION VALUE="1">�{�l</OPTION>
                    <OPTION VALUE="2">�Ƒ�</OPTION>
                </SELECT>
            </TD>
        </TR>
    </TABLE>
<% '### 2017/02/03 �� �o�͏����ɐ������o�͋敪�ǉ� END ### %>

    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
    <INPUT TYPE="hidden" NAME="mode" VALUE="0">
    </TABLE>

    <BR><BR>

<!--- ����{�^�� -->
    <!---2006.07.04 �����Ǘ� �ǉ� by ��  -->
    <% If Session("PAGEGRANT") = "4" Then   %>
        <a href="javascript:checkBillOrg();"><img src="/webHains/images/print.gif"></a>
    <%  End if  %>

    </BLOCKQUOTE>
<!--
<%= strSCslDate %>
<BR>
<%= strECslDate %>
<br>
<%=  strCsCd %>
<BR>
<%= strOrgCd1 %>
<BR>
<%= strOrgCd2 %>
<BR>
-->


</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>

</BODY>
</HTML>