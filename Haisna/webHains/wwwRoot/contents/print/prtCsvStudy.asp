<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'   ���O�`���[�g�X�^�f�B�p��f�҃��X�gCSV�o�� (Ver0.0.1)
'   AUTHER  :
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
Dim objPerson       '�l���A�N�Z�X�p

'�������������������� ��ʍ��ڂɂ��킹�ĕҏW
'�����l
Dim strSCslYear, strSCslMonth, strSCslDay   '�J�n�N����
Dim strECslYear, strECslMonth, strECslDay   '�I���N����
Dim strCsCd                                 '�R�[�X�R�[�h
Dim strObject                               '�o�͑Ώ�
'��������������������

'��Ɨp�ϐ�
Dim strSCslDate         '�J�n��
Dim strECslDate         '�I����

Dim strCourseCd         '���f�R�[�X�敪�R�[�h
Dim strSpItem           '���茒�f���ڂƈ�ʍ��ڋ敪

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
    If Not IsEmpty(Request("endCslYear")) Then
        strECslYear   = Request("endCslYear")   '�I���N
        strECslMonth  = Request("endCslMonth")  '�J�n��
        strECslDay    = Request("endCslDay")    '�J�n��
    End If
    strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay


    '���f�R�[�X
    strCourseCd = Request("Course")

    '���f����
    strSpItem   = Request("SpItem")


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
'��)    .AppendArray vntArrMessage, �R�����g

        If strMode <> "" Then

            If Not IsDate(strECslDate) Then
                strECslDate = strSCslDate
            End If

            If Not IsDate(strSCslDate) Then
                .AppendArray vntArrMessage, "�J�n���t������������܂���B"
            End If

            If Not IsDate(strECslDate) Then
                .AppendArray vntArrMessage, "�I�����t������������܂���B"
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
'-------------------------------------------------------------------------------
Function Print()

    Dim objCommon   '���ʃN���X
    Dim objPrintCls '�c�̈ꗗ�o�͗pCOM�R���|�[�l���g
    Dim Ret         '�֐��߂�l

    Dim strURL

    If Not IsArray(CheckValue()) Then

        '���R�����΍��p���O�����o��
        Call putPrivacyInfoLog("PH107", "���O�`���[�g�X�^�f�B�p��f�҃��X�gCSV�o�͂��t�@�C���o�͂��s����")

        Set objPrintCls = Server.CreateObject("HainsAbsenceListStudy.AbsenceListStudy")
        Ret = objPrintCls.PrintAbsenceListStudy(Session("USERID"), CDate(strSCslDate), CDate(strECslDate), strCourseCd, strSpItem)

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

<TITLE>���O�`���[�g�X�^�f�B�p��f�҃��X�gCSV�o��</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// �G�������g�̎Q�Ɛݒ�
function setElement() {


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
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">�����O�`���[�g�X�^�f�B�p��f�҃��X�gCSV�o�� </SPAN></B></TD>
        </TR>
    </TABLE>
<%
'�G���[���b�Z�[�W�\��

    Call EditMessage(vntMessage, MESSAGETYPE_WARNING)
%>
    <BR>

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
            <TD><%= EditNumberList("endCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strECslYear, True) %></TD>
            <TD>�N</TD>
            <TD><%= EditNumberList("endCslMonth", 1, 12, strECslMonth, True) %></TD>
            <TD>��</TD>
            <TD><%= EditNumberList("endCslDay", 1, 31, strECslDay, True) %></TD>
            <TD>��</TD>
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
                    <OPTION VALUE="105">�E��������f�i�h�b�N�j</OPTION>
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
                    <OPTION VALUE="A">�i�[�X�`�F�b�N�p</OPTION>
                </SELECT>
            </TD>  
        </TR>
    </TABLE>
    <BR>

    <BR><BR>

<!--- ������[�h -->
    <INPUT TYPE="hidden" NAME="mode" VALUE="0">
<!--- ����{�^�� -->
    <% If Session("PAGEGRANT") = "4" Then   %>
        <INPUT TYPE="image" NAME="print" SRC="/webHains/images/print.gif" WIDTH="77" HEIGHT="24" ALT="�������"><br>
    <%  End if  %>


    </BLOCKQUOTE>

</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>

</BODY>
</HTML>