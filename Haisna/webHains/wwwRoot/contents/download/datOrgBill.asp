<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'        ���������ג��o (Ver0.0.1)
'        AUTHER  : S.D.JANG
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/bill_print.inc"           -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<!-- #include virtual = "/webHains/includes/editOrgGrp_PList.inc"     -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim strMode            '������[�h
Dim vntMessage        '�ʒm���b�Z�[�W

'-------------------------------------------------------------------------------
' �ŗL�錾��
'-------------------------------------------------------------------------------
'�����l
Dim lngStrCloseYear         '�J�n���ߔN
Dim lngStrCloseMonth        '�J�n���ߌ�
Dim lngStrCloseDay          '�J�n���ߓ�
Dim lngEndCloseYear         '�I�����ߔN
Dim lngEndCloseMonth        '�I�����ߌ�
Dim lngEndCloseDay          '�I�����ߓ�
Dim strOrgCd1               '���S���c�̃R�[�h�P
Dim strOrgCd2               '���S���c�̃R�[�h�Q
Dim strBillNo               '�������ԍ�

'��Ɨp�ϐ�
Dim strOrgName              '�c�̖���
Dim strStrCloseDate         '�J�n���ߔN����
Dim strEndCloseDate         '�I�����ߔN����

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
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
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub GetQueryString()

    Dim objOrganization    '�c�̏��A�N�Z�X�p

    '�J�n���ߔN����
    lngStrCloseYear  = CLng("0" & Request("strCloseYear"))
    lngStrCloseMonth = CLng("0" & Request("strCloseMonth"))
    lngStrCloseDay   = CLng("0" & Request("strCloseDay"))
    lngStrCloseYear  = IIf(lngStrCloseYear  <> 0, lngStrCloseYear,  Year(Date))
    lngStrCloseMonth = IIf(lngStrCloseMonth <> 0, lngStrCloseMonth, Month(Date))
    lngStrCloseDay   = IIf(lngStrCloseDay   <> 0, lngStrCloseDay,   Day(Date))
    strStrCloseDate  = lngStrCloseYear & "/" & lngStrCloseMonth & "/" & lngStrCloseDay

    '�I�����ߔN����
    lngEndCloseYear  = CLng("0" & Request("endCloseYear"))
    lngEndCloseMonth = CLng("0" & Request("endCloseMonth"))
    lngEndCloseDay   = CLng("0" & Request("endCloseDay"))
    lngEndCloseYear  = IIf(lngEndCloseYear  <> 0, lngEndCloseYear,  Year(Date))
    lngEndCloseMonth = IIf(lngEndCloseMonth <> 0, lngEndCloseMonth, Month(Date))
    lngEndCloseDay   = IIf(lngEndCloseDay   <> 0, lngEndCloseDay,   Day(Date))
    strEndCloseDate  = lngEndCloseYear & "/" & lngEndCloseMonth & "/" & lngEndCloseDay

    '�������ԍ�
    strBillNo = Request("billNo")

    '�c��
    strOrgCd1       = Request("orgCd1")
    strOrgCd2       = Request("orgCd2")

    If strOrgCd1 = "" Or strOrgCd2 = "" Then
        Exit Sub
    End If

    '�c�̖��̓ǂݍ���
    Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
    objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2, , , strOrgName

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

    Dim objCommon        '���ʃN���X
    Dim vntArrMessage    '�G���[���b�Z�[�W�̏W��

    Set objCommon = Server.CreateObject("HainsCommon.Common")

    With objCommon

        If Not IsDate(strStrCloseDate) Then
            .AppendArray vntArrMessage, "�J�n���ߓ��̓��͌`��������������܂���B"
        End If

        If Not IsDate(strEndCloseDate) Then
            .AppendArray vntArrMessage, "�I�����ߓ��̓��͌`��������������܂���B"
        End If

        .AppendArray vntArrMessage, .CheckNumeric("�������ԍ�", strBillNo, 14)

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
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function Print()

    Dim objOrgBill              '�������׏��o�͗pCOM�R���|�[�l���g

    Dim dtmStrCslDate           '�J�n���ߓ�
    Dim dtmEndCslDate           '�I�����ߓ�
    Dim strParaOrgCd1           '�c�̃R�[�h�P
    Dim strParaOrgCd2           '�c�̃R�[�h�Q

    Dim Ret                     '�֐��߂�l

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objOrgBill = Server.CreateObject("HainsAbsenceOrgBill.AbsenceOrgBill")

    dtmStrCslDate = CDate(strStrCloseDate)
    dtmEndCslDate = CDate(strEndCloseDate)
    strParaOrgCd1 = strOrgCd1
    strParaOrgCd2 = strOrgCd2

    '���R�����΍��p���O�����o��
    Call putPrivacyInfoLog("PH106", "�f�[�^���o ���������׏�񒊏o�i�O�䕨�Y�t�H�[�}�b�g�j���t�@�C���o�͂��s����")

    '�������׏��h�L�������g�t�@�C���쐬����
    Ret = objOrgBill.PrintAbsenceOrgBill(Session("USERID"), dtmStrCslDate, dtmEndCslDate, strBillNo, strParaOrgCd1, strParaOrgCd2)

    Print = Ret

End Function

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>���������ג��o�i�O�䕨�Y���ی����j</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--

// �c�̌����K�C�h�\��
function showGuideOrg() {

    with ( document.entryForm ) {
        orgGuide_showGuideOrg( orgCd1, orgCd2, 'orgName' );
    }

}

// �c�̂̃N���A
function clearOrgInfo() {

    with ( document.entryForm ) {
        orgGuide_clearOrgInfo( orgCd1, orgCd2, 'orgName' );
    }

}

// submit���̏���
function submitForm() {

    document.entryForm.submit();

}

// �K�C�h��ʂ����
function closeWindow() {

    calGuide_closeGuideCalendar();
    orgGuide_closeGuideOrg();

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.datatab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
    <BLOCKQUOTE>

    <INPUT TYPE="hidden" NAME="mode" VALUE="0">

    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">��</SPAN><FONT COLOR="#000000">���������ג��o�i�O�䕨�Y���ۃt�H�[�}�b�g�j</FONT></B></TD>
        </TR>
    </TABLE>
<%
    '�G���[���b�Z�[�W�\��
    Call EditMessage(vntMessage, MESSAGETYPE_WARNING)
%>
    <BR>
    <INPUT TYPE="hidden" NAME="orgCd1"       VALUE="<%= strOrgCd1 %>">
    <INPUT TYPE="hidden" NAME="orgCd2"       VALUE="<%= strOrgCd2 %>">

    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD></TD>
            <TD>
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
                    <TR>
                        <TD><FONT COLOR="#ff0000">��</FONT></TD>
                        <TD WIDTH="90" NOWRAP>���ߓ�</TD>
                        <TD>�F</TD>
                        <TD><A HREF="javascript:calGuide_showGuideCalendar('strCloseYear', 'strCloseMonth', 'strCloseDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
                        <TD><%= EditNumberList("strCloseYear", YEARRANGE_MIN, YEARRANGE_MAX, lngStrCloseYear, False) %></TD>
                        <TD>�N</TD>
                        <TD><%= EditNumberList("strCloseMonth", 1, 12, lngStrCloseMonth, False) %></TD>
                        <TD>��</TD>
                        <TD><%= EditNumberList("strCloseDay", 1, 31, lngStrCloseDay, False) %></TD>
                        <TD>��</TD>
                        <TD>�`</TD>
                        <TD><A HREF="javascript:calGuide_showGuideCalendar('endCloseYear', 'endCloseMonth', 'endCloseDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
                        <TD><%= EditNumberList("endCloseYear", YEARRANGE_MIN, YEARRANGE_MAX, lngEndCloseYear, False) %></TD>
                        <TD>�N</TD>
                        <TD><%= EditNumberList("endCloseMonth", 1, 12, lngEndCloseMonth, False) %></TD>
                        <TD>��</TD>
                        <TD><%= EditNumberList("endCloseDay", 1, 31, lngEndCloseDay, False) %></TD>
                        <TD>��</TD>
                    </TR>
                </TABLE>
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
                    <TR>
                        <TD>��</TD>
                        <TD WIDTH="90" NOWRAP>�������ԍ�</TD>
                        <TD>�F</TD>
                        <TD><INPUT TYPE="text" NAME="billNo" SIZE="20" MAXLENGTH="14" VALUE="<%= strBillNo %>"></TD>
                        <TD><FONT COLOR="#999999">���������ԍ����w�肵���ꍇ�A���ߓ��͈͖͂�������܂��B</FONT></TD>
                    </TR>
                </TABLE>

                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
                    <TR>
                        <TD>��</TD>
                        <TD WIDTH="90" NOWRAP>���S���c��</TD>
                        <TD>�F</TD>
                        <TD><A HREF="javascript:showGuideOrg()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
                        <TD><A HREF="javascript:clearOrgInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
                        <TD NOWRAP><SPAN ID="orgName"><% = strOrgName %></SPAN></TD>
                    </TR>
                </TABLE>

            </TD>
        </TR>
    </TABLE>

    <BR><BR>

    <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
        <A HREF="javascript:submitForm()"><IMG SRC="/webHains/images/DataSelect.gif"></A>
    <%  end if  %>

    </BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>

</BODY>
</HTML>