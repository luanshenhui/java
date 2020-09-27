<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'   �c�̕ʌ_��Z�b�g���CSV�o�� (Ver0.0.1)
'   AUTHER  : ��
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
Dim strMode             '������[�h
Dim vntMessage          '�ʒm���b�Z�[�W
Dim MSGMODE

'-------------------------------------------------------------------------------
' �ŗL�錾���i�e���[�ɉ����Ă��̃Z�N�V�����ɕϐ����`���ĉ������j
'-------------------------------------------------------------------------------
'COM�I�u�W�F�N�g
Dim objCommon           '���ʃN���X
Dim objOrganization     '�c�̏��A�N�Z�X�p
Dim objPerson           '�l���A�N�Z�X�p

Dim objFree             '�ėp���A�N�Z�X�p


'�������������������� ��ʍ��ڂɂ��킹�ĕҏW
'�����l
Dim strSCslYear, strSCslMonth, strSCslDay   '�J�n�N����
Dim strCsCd                                 '�R�[�X�R�[�h
Dim strOrgCd1, strOrgCd2                    '�c�̃R�[�h
Dim strPerId                                '�l�R�[�h
Dim strObject                               '�o�͑Ώ�
'��������������������

'��Ɨp�ϐ�
Dim strOrgName          '�c�̖�
Dim strSCslDate         '�J�n��

Dim strCourseCd         '���f�R�[�X�敪�R�[�h
Dim strPriceCheck       '�u0�v���z�Z�b�g�o�͋敪

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
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


'�� �c�̃R�[�h
    strOrgCd1       = Request("OrgCd1")
    strOrgCd2       = Request("OrgCd2")
    strOrgName      = Request("OrgName")


    '���f�R�[�X
    strCourseCd = Request("Course")


'�� ��f���ڏo�͋敪�t���O(Y�F�o��)
    strPriceCheck = Request("priceFlg")


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

    With objCommon
'��)    .AppendArray vntArrMessage, �R�����g

        If strMode <> "" Then
            If Not IsDate(strSCslDate) Then
                .AppendArray vntArrMessage, "���������������܂���B"
            End If
        End If

        if strOrgCd1 = "" and strOrgCd2 = "" Then
            .AppendArray vntArrMessage, "�c�̂�I�����Ă��������B"
        End If

    End With

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

    Dim objCommon       '���ʃN���X
    Dim objPrintCls     '�c�̈ꗗ�o�͗pCOM�R���|�[�l���g
    Dim Ret             '�֐��߂�l

    Dim strURL

    If Not IsArray(CheckValue()) Then

'''�������������������� ��ʍ��ڂɂ��킹�ĕҏW
'''�I�u�W�F�N�g�̃C���X�^���X�쐬�i�v���W�F�N�g��.�N���X���j
        Set objPrintCls = Server.CreateObject("HainsAbsenceCompany.AbsenceCompany")

        Ret = objPrintCls.PrintAbsenceListCompany(Session("USERID"), CDate(strSCslDate), strOrgCd1, strOrgCd2, strCourseCd, strPriceCheck)

'''��������������������

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

<TITLE>�c�̕ʌ_��Z�b�g���CSV�o��</TITLE>
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

    function check(){
        with(document.entryForm)
        {
            if(orgCd1.value == "" && orgCd2.value == "") {
                alert("�c�̂�I�����Ă��������I�I�I");
                return;
            }
            submit();
        }
    }

//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.prttab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
    <BLOCKQUOTE>

<!--- �^�C�g�� -->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">���c�̕ʌ_��Z�b�g���CSV�o��</SPAN></B></TD>
        </TR>
    </TABLE>
<%
'�G���[���b�Z�[�W�\��

    Call EditMessage(vntMessage, MESSAGETYPE_WARNING)
%>
    <BR>

    <INPUT TYPE="hidden" NAME="orgCd1"      VALUE="<%= strOrgCd1 %>">
    <INPUT TYPE="hidden" NAME="orgCd2"      VALUE="<%= strOrgCd2 %>">

<!--- ���t -->
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD><FONT COLOR="#ff0000">��</FONT></TD>
            <TD WIDTH="120" NOWRAP>���</TD>
            <TD>�F</TD>
            <TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
            <TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strSCslYear, False) %></TD>
            <TD>�N</TD>
            <TD><%= EditNumberList("strCslMonth", 1, 12, strSCslMonth, False) %></TD>
            <TD>��</TD>
            <TD><%= EditNumberList("strCslDay", 1, 31, strSCslDay, False) %></TD>
            <TD>��</TD>

        </TR>
    </TABLE>

    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD><FONT COLOR="#ff0000">��</FONT></TD>
            <TD WIDTH="120" NOWRAP>�c��</TD>
            <TD>�F</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd1, document.entryForm.orgCd2, 'OrgName')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd1, document.entryForm.orgCd2, 'OrgName')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
            <TD NOWRAP><% = strOrgName %><SPAN ID="OrgName"></SPAN></TD>
        </TR>

    <!-- ���f�R�[�X�敪 -->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
        <TR>
            <TD><FONT COLOR="#ff0000">��</FONT></TD>
            <TD WIDTH="120" NOWRAP>���f�R�[�X</TD>
            <TD>�F</TD>
            <TD>
                <SELECT NAME="Course">
                    <OPTION VALUE="100">����l�ԃh�b�N</OPTION>
                    <OPTION VALUE="105">�E��������N�f�f�i�h�b�N�j</OPTION>
                    <OPTION VALUE="110">��ƌ��f</OPTION>
                </SELECT>
            </TD>
        </TR>
    </TABLE>

    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD><FONT COLOR="#ff0000">��</FONT></TD>
            <TD WIDTH="120" NOWRAP>�u0�v���z�Z�b�g�o��</TD>
            <TD>�F</TD>
            <TD>
                <TABLE BORDER="0" CELLPADDING="5" CELLSPACING="0">
                    <TR>
                        <TD><INPUT TYPE="Radio" NAME="priceFlg" VALUE="N" checked>���Ȃ�</TD>
                        <TD><INPUT TYPE="Radio" NAME="priceFlg" VALUE="Y">����</TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>

    <!--- ������[�h -->
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
        <INPUT TYPE="hidden" NAME="mode" VALUE="0">
    </TABLE>

    <BR><BR>

<!--- ����{�^�� -->
    <!---### ���[�U�O���[�v�ʑ��쌠���Ǘ� ###-->
    <% If Session("PAGEGRANT") = "4" Then   %>
        <a href="javascript:check();"><img src="/webHains/images/DataSelect.gif"></a>
    <%  End if  %>

    </BLOCKQUOTE>

</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>

</BODY>
</HTML>