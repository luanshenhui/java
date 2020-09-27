<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'   ��f�ΏێҖ��� (Ver0.0.1)
'   AUTHER  :
'-------------------------------------------------------------------------------
'       �Ǘ��ԍ��FSL-UI-Y0101-201
'       �C����  �F2010.05.11
'       �S����  �FASC)����
'       �C�����e�FReport Designer��Co Reports�ɕύX
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/print.inc"                -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim strMode         '������[�h
Dim vntMessage      '�ʒm���b�Z�[�W
Dim strURL          'URL
'-------------------------------------------------------------------------------
' �ŗL�錾���i�e���[�ɉ����Ă��̃Z�N�V�����ɕϐ����`���ĉ������j
'-------------------------------------------------------------------------------
'COM�I�u�W�F�N�g
Dim objCommon           '���ʃN���X
Dim objOrganization     '�c�̏��A�N�Z�X�p
Dim objOrgBsd           '���ƕ����A�N�Z�X�p
Dim objOrgRoom          '�������A�N�Z�X�p
Dim objOrgPost          '�������A�N�Z�X�p
Dim objPerson           '�l���A�N�Z�X�p

'�����l
Dim strSCslYear, strSCslMonth, strSCslDay       '�J�n�N����
Dim strECslYear, strECslMonth, strECslDay       '�I���N����
Dim YstrSCslYear, YstrSCslMonth, YstrSCslDay    '�\��J�n�N����
Dim YstrECslYear, YstrECslMonth, YstrECslDay    '�\��I���N����

Dim strCsCd                                 '�R�[�X�R�[�h
Dim strOrgCd1, strOrgCd2                    '�c�̃R�[�h
Dim strNotes                                '�R�����g
Dim strOrgBsdCd, strOrgRoomCd               '���ƕ��R�[�h, �����R�[�h
Dim strSOrgPostCd, strEOrgPostCd            '�J�n�����R�[�h, �I�������R�[�h
Dim strPerId                                '�l�R�[�h
Dim strObject                               '�o�͑Ώ�
Dim UID

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

Dim YstrSCslDate        '�\��J�n��
Dim YstrECslDate        '�\��I����
Dim WYstrSCslDate       '�\��J�n��
Dim WYstrECslDate       '�\��I����
Dim WstrSCslDate        '�J�n��
Dim WstrECslDate        '�I����

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

'�� �J�n�N����
    If IsEmpty(Request("strCslYear")) Then
        WstrSCslDate = DateAdd("M", -9, Now)
        strSCslYear     = Mid(WstrSCslDate, 1, 4)   '�J�n�N
        strSCslMonth    = Mid(WstrSCslDate, 6, 2)   '�J�n��
        strSCslDay      = Mid(WstrSCslDate, 10, 2)  '�J�n��
    Else
        strSCslYear     = Request("strCslYear")     '�J�n�N
        strSCslMonth    = Request("strCslMonth")    '�J�n��
        strSCslDay      = Request("strCslDay")      '�J�n��
    End If

   strSCslDate   = strSCslYear & "/" & strSCslMonth & "/" & strSCslDay

'�� �I���N����
    If IsEmpty(Request("endCslYear")) Then
        WstrECslDate    = DateAdd("M", -9, Now)
        strECslYear     = Mid(WstrSCslDate, 1, 4)   '�I���N
        strECslMonth    = Mid(WstrSCslDate, 6, 2)   '�J�n��
        strECslDay      = Mid(WstrSCslDate, 10, 2)  '�J�n��
    Else
        strECslYear     = Request("endCslYear")     '�I���N
        strECslMonth    = Request("endCslMonth")    '�J�n��
        strECslDay      = Request("endCslDay")      '�J�n��
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

        strSCslYear     = strECslYear
        strSCslMonth    = strECslMonth
        strSCslDate     = strECslDate
        strECslYear     = Request("strCslYear")     '�J�n�N
        strECslMonth    = Request("strCslMonth")    '�J�n��
        strECslDay      = Request("strCslDay")      '�J�n��

        strECslDate     = strECslYear & "/" & strECslMonth & "/" & strECslDay

    End If


'���\�� �J�n�N����
    If IsEmpty(Request("YstrCslYear")) Then
        WYstrSCslDate   = DateAdd("M", -4, Now)
        YstrSCslYear    = Mid(WYstrSCslDate, 1, 4)  '�J�n�N
        YstrSCslMonth   = Mid(WYstrSCslDate, 6, 2)  '�J�n��
    Else
        YstrSCslYear    = Request("YstrCslYear")    '�J�n�N
        YstrSCslMonth   = Request("YstrCslMonth")   '�J�n��
    End If
    YstrSCslDate        = YstrSCslYear & "/" & YstrSCslMonth 

'�� �\��I���N����
    If IsEmpty(Request("YendCslYear")) Then
        WYstrECslDate   = DateAdd("M", +4, Now)
        YstrECslYear    = Mid(WYstrECslDate, 1, 4)
        YstrECslMonth   = Mid(WYstrECslDate, 6, 2)
    Else
        YstrECslYear    = Request("YendCslYear")    '�I���N
        YstrECslMonth   = Request("YendCslMonth")   '�J�n��
    End If
    YstrECslDate        = YstrECslYear & "/" & YstrECslMonth 

'�� �\��J�n�N�����Ɨ\��I���N�����̑召����Ɠ���
'   �i���t�^�ɕϊ����ă`�F�b�N���Ȃ��͓̂��t�Ƃ��Č�����l�ł������Ƃ��̃G���[����ׁ̈j
    If Right("0000" & Trim(CStr(YstrSCslYear)), 4) & _
       Right("00" & Trim(CStr(YstrSCslMonth)), 2) _
     > Right("0000" & Trim(CStr(YstrECslYear)), 4) & _
       Right("00" & Trim(CStr(YstrECslMonth)), 2) Then
        YstrSCslYear    = YstrECslYear
        YstrSCslMonth   = YstrECslMonth
        YstrSCslDate    = YstrECslDate
        YstrECslYear    = Request("YstrCslYear")    '�J�n�N
        YstrECslMonth   = Request("YstrCslMonth")   '�J�n��
        YstrECslDate    = YstrECslYear & "/" & YstrECslMonth
    End If

    strCsCd         = Request("csCd")         '�R�[�X�R�[�h

'�� �c��
    strOrgCd1       = Request("orgCd1")       '�c�̃R�[�h�P
    strOrgCd2       = Request("orgCd2")       '�c�̃R�[�h�Q
    If strOrgCd1 <> "" And strOrgCd2 <> "" Then
        objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2, , strOrgName
    End If

'�� �R�����g
    strNotes        = Request("notes")         '�R�����g

    UID             = Session("USERID")

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

    Dim vntArrMessage    '�G���[���b�Z�[�W�̏W��

    '�����Ƀ`�F�b�N�������L�q
    With objCommon
'��)        .AppendArray vntArrMessage, �R�����g

        If strMode <> "" Then
'## 2003/12/27 Del NSC@Itoh
'            If Not IsDate(strSCslDate) Then
'                .AppendArray vntArrMessage, "�J�n���t������������܂���B"
'            End If
'            If Not IsDate(strECslDate) Then
'                .AppendArray vntArrMessage, "�I�����t������������܂���B"
'            End If
'##2004/07/23 ���� stLuke@sdjang
            If Not IsDate(strSCslDate) Then
                .AppendArray vntArrMessage, "�J�n���t������������܂���B"
            End If
            If Not IsDate(strECslDate) Then
                .AppendArray vntArrMessage, "�I�����t������������܂���B"
            End If
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
    Dim objPrintCls     '1�N�ڂ͂����o�͗pCOM�R���|�[�l���g
    Dim Ret             '�֐��߂�l

    If Not IsArray(CheckValue()) Then

        '���R�����΍��p���O�����o��
        Call putPrivacyInfoLog("PH015", "��N�ڂ͂����̈�����s����")

          Set objCommon = Server.CreateObject("HainsCommon.Common")

        '�I�u�W�F�N�g�̃C���X�^���X�쐬�i�v���W�F�N�g��.�N���X���j
        Set objPrintCls = Server.CreateObject("HainsprtAfterPostcard.prtAfterPostcard")

        '�h�L�������g�t�@�C���쐬�����i�I�u�W�F�N�g.���\�b�h��(����)�j
'## 2015/06/17 �� ��ʂ���ҏW�����ē����͂�ǉ� #####################################################################
'        Ret = objPrintCls.PrintOut(UID, strSCslDate, strECslDate, YstrSCslDate, YstrECslDate, strOrgCd1, strOrgCd2)
        Ret = objPrintCls.PrintOut(UID, strSCslDate, strECslDate, YstrSCslDate, YstrECslDate, strOrgCd1, strOrgCd2, strNotes)
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
<TITLE>1�N�ڂ͂���</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// �G�������g�̎Q�Ɛݒ�
function setNote() {

    var wk_Note;

    with ( document.entryForm ) {
        wk_Note = ''
        wk_Note = wk_Note + '���̌ア�������߂����ł��傤���B\n';
        wk_Note = wk_Note + '�O�񂲎�f�������������P�N�ƂȂ�܂��B\n';
        wk_Note = wk_Note + '���\��͗��ʂ̓d�b�܂��̓C���^�[�l�b�g�ɂ�\n';
        wk_Note = wk_Note + '�����Ă���܂��B\n';
        wk_Note = wk_Note + '�F�l����̂��\������҂����Ă���܂��B\n';
        notes.value = wk_Note;
    }
}


function setElement() {

    with ( document.entryForm ) {
        // �c�́E�������G�������g�̎Q�Ɛݒ�i���͍��ڂɒc�́E�����������ꍇ�͕s�v�j
        orgPostGuide_getElement( orgCd1, orgCd2, 'orgName' );
    }
}

//-->
</SCRIPT>
<script TYPE="text/javascript" src="/webHains/js/checkRunState.js?v=1.2"></script>
<STYLE TYPE="text/css">
td.prttab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONLOAD="javascript:setElement();setNote();checkRunState();">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" onsubmit="setRunState();">
	<INPUT TYPE="hidden" NAME="runstate" VALUE="">
    <BLOCKQUOTE>

<!--- �^�C�g�� -->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">����N�ڂ͂���</SPAN></B></TD>
        </TR>
    </TABLE>
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
            <TD><%= EditNumberList("endCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strECslYear, False) %></TD>
            <TD>�N</TD>
            <TD><%= EditNumberList("endCslMonth", 1, 12, strECslMonth, False) %></TD>
            <TD>��</TD>
            <TD><%= EditNumberList("endCslDay", 1, 31, strECslDay, False) %></TD>
            <TD>��</TD>
        </TR>
    </TABLE>
<!--- ���t -->
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD><FONT COLOR="#ff0000">��</FONT></TD>
            <TD WIDTH="90" NOWRAP>�\��N��</TD>
            <TD>�F</TD>
            <TD><A HREF="javascript:calGuide_showGuideCalendar('YstrCslYear', 'YstrCslMonth', 'YstrCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
            <TD><%= EditNumberList("YstrCslYear", YEARRANGE_MIN, YEARRANGE_MAX, YstrSCslYear, False) %></TD>
            <TD>�N</TD>
            <TD><%= EditNumberList("YstrCslMonth", 1, 12, YstrSCslMonth, False) %></TD>
            <TD>��</TD>
            <TD>�`</TD>
            <TD><A HREF="javascript:calGuide_showGuideCalendar('YendCslYear', 'YendCslMonth', 'YendCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
            <TD><%= EditNumberList("YendCslYear", YEARRANGE_MIN, YEARRANGE_MAX, YstrECslYear, False) %></TD>
            <TD>�N</TD>
            <TD><%= EditNumberList("YendCslMonth", 1, 12, YstrECslMonth, False) %></TD>
            <TD>��</TD>
        </TR>
    </TABLE>

<!--- �c�� -->
    <INPUT TYPE="hidden" NAME="orgCd1" VALUE="<% = strOrgCd1 %>">
    <INPUT TYPE="hidden" NAME="orgCd2" VALUE="<% = strOrgCd2 %>">

    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD>��</TD>
            <TD WIDTH="90" NOWRAP>�c��</TD>
            <TD>�F</TD>
            <TD><A HREF="javascript:orgPostGuide_showGuideOrg()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
            <TD><A HREF="javascript:orgPostGuide_clearOrgInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
            <TD NOWRAP><SPAN ID="orgName"><% = strOrgName %></SPAN></TD>
        </TR>
    </TABLE>
    <!--- �R�����g -->
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD>��</TD>
            <TD WIDTH="90" NOWRAP>�R�����g</TD>
            <TD>�F</TD>
            <TD><TEXTAREA NAME="notes" COLS="60" ROWS="7" STYLE="ime-mode:active;"></TEXTAREA></TD>
        </TR>
    </TABLE>
<!--- �o�͑Ώ� --><BR>
<!--- ������[�h -->
<%
    '������[�h�̏����ݒ�
    strMode = IIf(strMode = "", PRINTMODE_PREVIEW, strMode)
%>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
        <INPUT TYPE="hidden" NAME="mode" VALUE="0">
    </TABLE>

    <BR><BR>

<!--- ����{�^�� -->
    <!---2006.07.04 �����Ǘ� �ǉ� by ��  -->
    <% If Session("PAGEGRANT") = "4" Then   %>
        <INPUT TYPE="image" NAME="print" SRC="/webHains/images/print.gif" WIDTH="77" HEIGHT="24" ALT="�������">
    <%  End if  %>

    </BLOCKQUOTE>

</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>

</BODY>
</HTML>