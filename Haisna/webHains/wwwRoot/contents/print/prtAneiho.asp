<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'       �J����ē����v (Ver0.0.1)
'       AUTHER  : (NSC)birukawa
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/print.inc"                -->
<!-- #include virtual = "/webHains/includes/editOrgGrp_PList.inc"     -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim strMode             '������[�h
Dim vntMessage          '�ʒm���b�Z�[�W

'-------------------------------------------------------------------------------
' �ŗL�錾���i�e���[�ɉ����Ă��̃Z�N�V�����ɕϐ����`���ĉ������j
'-------------------------------------------------------------------------------
'COM�I�u�W�F�N�g
Dim objCommon                               '���ʃN���X
Dim objOrganization                         '�c�̏��A�N�Z�X�p
Dim objOrgBsd                               '���ƕ����A�N�Z�X�p
Dim objOrgRoom                              '�������A�N�Z�X�p
Dim objOrgPost                              '�������A�N�Z�X�p
Dim objPerson                               '�l���A�N�Z�X�p
Dim objReport                               '���[���A�N�Z�X�p

Dim strCsCd                                 '�R�[�X�R�[�h
Dim strCsCd1                                '�R�[�X�R�[�h
Dim strCsCd2                                '�R�[�X�R�[�h
Dim strCsCd3                                '�R�[�X�R�[�h
Dim strCsCd4                                '�R�[�X�R�[�h
Dim strCsCd5                                '�R�[�X�R�[�h
Dim strCsCd6                                '�R�[�X�R�[�h
Dim strCsCd7                                '�R�[�X�R�[�h
Dim strCsCd8                                '�R�[�X�R�[�h
Dim strCsCd9                                '�R�[�X�R�[�h
Dim strOutPutCls                            '�o�͑Ώ�
'�p�����[�^�l
Dim strSCslYear, strSCslMonth, strSCslDay   '�J�n�N����
Dim strECslYear, strECslMonth, strECslDay   '�I���N����
Dim strDayId                                '����ID
Dim strOrgGrpCd                             '�c�̃O���[�v�R�[�h
Dim strOrgCd11                              '�c�̃R�[�h�P�P
Dim strOrgCd12                              '�c�̃R�[�h�P�Q
Dim strOrgCd21                              '�c�̃R�[�h�Q�P
Dim strOrgCd22                              '�c�̃R�[�h�Q�Q
Dim strOrgCd31                              '�c�̃R�[�h�R�P
Dim strOrgCd32                              '�c�̃R�[�h�R�Q
Dim strOrgCd41                              '�c�̃R�[�h�S�P
Dim strOrgCd42                              '�c�̃R�[�h�S�Q
Dim strOrgCd51                              '�c�̃R�[�h�T�P
Dim strOrgCd52                              '�c�̃R�[�h�T�Q
Dim strOrgCd61                              '�c�̃R�[�h�U�P
Dim strOrgCd62                              '�c�̃R�[�h�U�Q
Dim strOrgCd71                              '�c�̃R�[�h�V�P
Dim strOrgCd72                              '�c�̃R�[�h�V�Q
Dim strOrgCd81                              '�c�̃R�[�h�V�P
Dim strOrgCd82                              '�c�̃R�[�h�V�Q
Dim strOrgCd91                              '�c�̃R�[�h�V�P
Dim strOrgCd92                              '�c�̃R�[�h�V�Q
Dim strOrgCd101                             '�c�̃R�[�h�V�P
Dim strOrgCd102                             '�c�̃R�[�h�V�Q
Dim strReportOutDate                        '�o�͓�
Dim strReportCd                             '���[�R�[�h
Dim UID                                     '���[�UID

'��Ɨp�ϐ�
Dim strSCslDate                             '�J�n��
Dim strECslDate                             '�I����
Dim strOrgGrpName                           '�c�̃O���[�v����
Dim strOrgName1                             '�c�̂P����
Dim strOrgName2                             '�c�̂Q����
Dim strOrgName3                             '�c�̂R����
Dim strOrgName4                             '�c�̂S����
Dim strOrgName5                             '�c�̂T����
Dim strOrgName6                             '�c�̂U����
Dim strOrgName7                             '�c�̂V����
Dim strOrgName8                             '�c�̂V����
Dim strOrgName9                             '�c�̂V����
Dim strOrgName10                            '�c�̂V����

'���[���
Dim strArrReportCd                          '���[�R�[�h
Dim strArrReportName                        '���[��
Dim strArrHistoryPrint                      '�ߋ������
Dim lngReportCount                          '���R�[�h��

Dim i                   '���[�v�C���f�b�N�X
Dim j                   '���[�v�C���f�b�N�X

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

    strOutputCls    = Request("outputCls")

'�� �c�̃R�[�h
If strOutputCls = "0" Then
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
    '�c�̂U
    strOrgCd61  = Request("OrgCd61")
    strOrgCd62  = Request("OrgCd62")
    strOrgName6 = Request("OrgName6")
    '�c�̂V
    strOrgCd71  = Request("OrgCd71")
    strOrgCd72  = Request("OrgCd72")
    strOrgName7 = Request("OrgName7")
    strOrgCd81  = Request("OrgCd81")
    strOrgCd82  = Request("OrgCd82")
    strOrgName8 = Request("OrgName8")
    strOrgCd91  = Request("OrgCd91")
    strOrgCd92  = Request("OrgCd92")
    strOrgName9 = Request("OrgName9")
    strOrgCd101 = Request("OrgCd101")
    strOrgCd102 = Request("OrgCd102")
    strOrgName10 = Request("OrgName10")
Else
    strOrgCd11  = Request("OrgCd1")
    strOrgCd21  = Request("OrgCd2")
    strOrgCd31  = Request("OrgCd3")
    strOrgCd41  = Request("OrgCd4")
    strOrgCd51  = Request("OrgCd5")
    strOrgCd61  = Request("OrgCd6")
    strOrgCd71  = Request("OrgCd7")
    strOrgCd81  = Request("OrgCd8")
    strOrgCd91  = Request("OrgCd9")
    strOrgCd101 = Request("OrgCd10")
    strOrgCd12  = ""
    strOrgCd22  = ""
    strOrgCd32  = ""
    strOrgCd42  = ""
    strOrgCd52  = ""
    strOrgCd62  = ""
    strOrgCd72  = ""
    strOrgCd82  = ""
    strOrgCd92  = ""
    strOrgCd102 = ""
End If
    strCsCd     = Request("csCd")
    strCsCd1    = Request("csCd1")
    strCsCd2    = Request("csCd2")
    strCsCd3    = Request("csCd3")
    strCsCd4    = Request("csCd4")
    strCsCd5    = Request("csCd5")
    strCsCd6    = Request("csCd6")
    strCsCd7    = Request("csCd7")
    strCsCd8    = Request("csCd8")
    strCsCd9    = Request("csCd9")

     
'�� ���[�UID
    UID = Session("USERID")

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

    Dim vntArrMessage	'�G���[���b�Z�[�W�̏W��

    '�����Ƀ`�F�b�N�������L�q
    With objCommon
'��)        .AppendArray vntArrMessage, �R�����g
        If strMode <> "" Then
            '��f���`�F�b�N
            If Not IsDate(strSCslDate) Then
                .AppendArray vntArrMessage, "�J�n���t������������܂���B"
            End If
            If Not IsDate(strECslDate) Then
                .AppendArray vntArrMessage, "�I�����t������������܂���B"
            End If

             If strOrgCd11 = "" Then
                .AppendArray vntArrMessage, "�c�̃R�[�h�����ݒ�ł�"
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
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function Print()



    Dim objCommon   '���ʃN���X
    Dim Ret         '�֐��߂�l
    Dim strURL
    Dim objPrintCls

    If Not IsArray(CheckValue()) Then

        '�I�u�W�F�N�g�̃C���X�^���X�쐬�i�v���W�F�N�g��.�N���X���j
        Set objPrintCls = Server.CreateObject("HainsprtAneiho.prtAneiho")

        '�h�L�������g�t�@�C���쐬�����i�I�u�W�F�N�g.���\�b�h��(����)�j
        Ret = objPrintCls.PrintOut(Server.HTMLEncode(Session("USERID")), strSCslDate, strECslDate, stroutputCls, strOrgCd11 & strOrgCd12, strOrgCd21 & strOrgCd22, strOrgCd31 & strOrgCd32, strOrgCd41 & strOrgCd42, strOrgCd51 & strOrgCd52, strOrgCd61 & strOrgCd62, strOrgCd71 & strOrgCd72, strOrgCd81 & strOrgCd82, strOrgCd91 & strOrgCd92, strOrgCd101 & strOrgCd102, strCsCd, strCsCd1, strCsCd2, strCsCd3, strCsCd4, strCsCd5, strCsCd6, strCsCd7, strCsCd8, strCsCd9)

        print=Ret

'		Set objCommon = Server.CreateObject("HainsCommon.Common")
'		strURL= ""
'		strURL = "http://192.168.100.182/webhains/contents/report_form/prtAneihoics_mrd.asp"
''	     strURL = "/webHains/contents/prtAneihoStatistics_mrd.asp"
'		strURL = strURL & "?p_Uid=" & UID
'		strURL = strURL & "&p_startDate=" & objCommon.FormatString(CDate(strSCslDate), "yyyy/mm/dd")
'		strURL = strURL & "&p_endDate=" & objCommon.FormatString(CDate(strECslDate), "yyyy/mm/dd")		
'		strURL = strURL & "&p_OrgMethod=" & stroutputCls
'		strURL = strURL & "&p_Orgcd1=" & strOrgCd11 & strOrgCd12 
'		strURL = strURL & "&p_Orgcd2=" & strOrgCd21 & strOrgCd22
'		strURL = strURL & "&p_Orgcd3=" & strOrgCd31 & strOrgCd32
'		strURL = strURL & "&p_Orgcd4=" & strOrgCd41 & strOrgCd42
'		strURL = strURL & "&p_Orgcd5=" & strOrgCd51 & strOrgCd52
'		strURL = strURL & "&p_Orgcd6=" & strOrgCd61 & strOrgCd62
'		strURL = strURL & "&p_Orgcd7=" & strOrgCd71 & strOrgCd72
'		strURL = strURL & "&p_Orgcd8=" & strOrgCd81 & strOrgCd82
'		strURL = strURL & "&p_Orgcd9=" & strOrgCd91 & strOrgCd92
'		strURL = strURL & "&p_Orgcd10=" & strOrgCd101 & strOrgCd102
'		strURL = strURL & "&p_Cscd1=" & strCsCd
'		strURL = strURL & "&p_Cscd2=" & strCsCd1
'		strURL = strURL & "&p_Cscd3=" & strCsCd2
'		strURL = strURL & "&p_Cscd4=" & strCsCd3
'		strURL = strURL & "&p_Cscd5=" & strCsCd4
'		strURL = strURL & "&p_Cscd6=" & strCsCd5
'		strURL = strURL & "&p_Cscd7=" & strCsCd6
'		strURL = strURL & "&p_Cscd8=" & strCsCd7
'		strURL = strURL & "&p_Cscd9=" & strCsCd8
'		strURL = strURL & "&p_Cscd10=" & strCsCd9
'		Set objCommon = Nothing
'		Response.Redirect strURL
'		Response.End

    End If
End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Microsoft FrontPage 4.0">
<TITLE>�J����ē����v</TITLE>
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
// submit���̏���
function submitForm() {
    document.entryForm.submit();
}
//function selectHistoryPrint( index ) {
//  document.entryForm.historyPrint.value = document.historyPrintForm.historyPrint[ index ].value;
//}
-->
</SCRIPT>
<script TYPE="text/javascript" src="/webHains/js/checkRunState.js?v=1.2"></script>
<STYLE TYPE="text/css">
<!--
td.prttab { background-color:#ffffff }
-->
</STYLE>
</HEAD>
<BODY ONLOAD="checkRunState();">
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" onsubmit="setRunState();">
<INPUT TYPE="hidden" NAME="runstate" VALUE="">
<BLOCKQUOTE>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
	    <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">���J����ē����v</SPAN></B></TD>
	</TR>
</TABLE>
<BR>
<%
    '�G���[���b�Z�[�W�\��
    Call EditMessage(vntMessage, MESSAGETYPE_WARNING)
%>
<%
    '���[�h�̓v���r���[�Œ�
%>
    <INPUT TYPE="hidden" NAME="mode" VALUE="0">	

    <INPUT TYPE="hidden" NAME="OrgGrpName"    VALUE="<%= strOrgGrpName    %>">
    <INPUT TYPE="hidden" NAME="orgCd11"       VALUE="<%= strOrgCd11       %>">
    <INPUT TYPE="hidden" NAME="orgCd12"       VALUE="<%= strOrgCd12       %>">
    <INPUT TYPE="hidden" NAME="orgCd21"       VALUE="<%= strOrgCd21       %>">
    <INPUT TYPE="hidden" NAME="orgCd22"       VALUE="<%= strOrgCd22       %>">
    <INPUT TYPE="hidden" NAME="orgCd31"       VALUE="<%= strOrgCd31       %>">
    <INPUT TYPE="hidden" NAME="orgCd32"       VALUE="<%= strOrgCd32       %>">
    <INPUT TYPE="hidden" NAME="orgCd41"       VALUE="<%= strOrgCd41       %>">
    <INPUT TYPE="hidden" NAME="orgCd42"       VALUE="<%= strOrgCd42       %>">
    <INPUT TYPE="hidden" NAME="orgCd51"       VALUE="<%= strOrgCd51       %>">
    <INPUT TYPE="hidden" NAME="orgCd52"       VALUE="<%= strOrgCd52       %>">
    <INPUT TYPE="hidden" NAME="orgCd61"       VALUE="<%= strOrgCd61       %>">
    <INPUT TYPE="hidden" NAME="orgCd62"       VALUE="<%= strOrgCd62       %>">
    <INPUT TYPE="hidden" NAME="orgCd71"       VALUE="<%= strOrgCd71       %>">
    <INPUT TYPE="hidden" NAME="orgCd72"       VALUE="<%= strOrgCd72       %>">
    <INPUT TYPE="hidden" NAME="orgCd81"       VALUE="<%= strOrgCd81       %>">
    <INPUT TYPE="hidden" NAME="orgCd82"       VALUE="<%= strOrgCd82       %>">
    <INPUT TYPE="hidden" NAME="orgCd91"       VALUE="<%= strOrgCd91       %>">
    <INPUT TYPE="hidden" NAME="orgCd92"       VALUE="<%= strOrgCd92       %>">
    <INPUT TYPE="hidden" NAME="orgCd101"      VALUE="<%= strOrgCd101      %>">
    <INPUT TYPE="hidden" NAME="orgCd102"      VALUE="<%= strOrgCd102      %>">

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

    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <tr>
            <td><FONT COLOR="#ff0000">��</FONT></td>
            <td width="96" nowrap>�c�̃R�[�h�I��</td>
            <td>�F</td>
            <TD>
                <select name="outputCls" size="1">
                    <option selected value="0">�c�̃R�[�h�@1-2</option>
                    <option value="1">�c�̃R�[�h�@1�@�̂�</option>
                </select>
            </TD>
            <td></td>
        </tr>
    </TABLE>
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
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd51, document.entryForm.orgCd52, 'OrgName5')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName5"><% = strOrgName5 %></SPAN></TD>
        </TR>
        <TR>
            <TD>��</TD>
            <TD WIDTH="90" NOWRAP>�c�̂U</TD>
            <TD>�F</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd61, document.entryForm.orgCd62, 'OrgName6')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd61, document.entryForm.orgCd62, 'OrgName6')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName6"><% = strOrgName6 %></SPAN></TD>
        </TR>
        <TR>
            <TD>��</TD>
            <TD WIDTH="90" NOWRAP>�c�̂V</TD>
            <TD>�F</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd71, document.entryForm.orgCd72, 'OrgName7')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd71, document.entryForm.orgCd72, 'OrgName7')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName7"><% = strOrgName7 %></SPAN></TD>
        </TR>
        <TR>
            <TD>��</TD>
            <TD WIDTH="132" NOWRAP>�c��8</TD>
            <TD>�F</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd81, document.entryForm.orgCd82, 'OrgName8')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd81, document.entryForm.orgCd82, 'OrgName8')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName8"><% = strOrgName8 %></SPAN></TD>
        </TR>
        <TR>
            <TD>��</TD>
            <TD WIDTH="132" NOWRAP>�c��9</TD>
            <TD>�F</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd91, document.entryForm.orgCd92, 'OrgName9')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd91, document.entryForm.orgCd92, 'OrgName9')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName9"><% = strOrgName9 %></SPAN></TD>
        </TR>		
        <TR>
            <TD>��</TD>
            <TD WIDTH="132" NOWRAP>�c��10</TD>
            <TD>�F</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd101, document.entryForm.orgCd102, 'OrgName10')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd101, document.entryForm.orgCd102, 'OrgName10')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName10"><% = strOrgName10 %></TD>
        </TR>	
    </TABLE>

    <table border="0" cellpadding="1" cellspacing="2">
                    <tr>
                        <TD>��</TD>
                        <td width="150" nowrap>�c�̃R�[�h�i����́j 1-5</td>
                        <td>�F</td>
                        <td><input type="text" name="orgCd1" size="15" value="" maxlength="5"> <input type="text" name="orgCd2" size="15" value="" maxlength="5"> <input type="text" name="orgCd3" size="15" value="" maxlength="5"> <input type="text" name="orgCd4" size="15" value="" maxlength="5"> <input type="text" name="orgCd5" size="15" value="" maxlength="5"> </td>
                    </tr>
                    <tr>
                            <TD>��</TD>
                        <td width="150" nowrap>�c�̃R�[�h�i����́j 6-10</td>
                        <td>�F</td>
                        <td><input type="text" name="orgCd6" size="15" value="" maxlength="5"> <input type="text" name="orgCd7" size="15" value="" maxlength="5"> <input type="text" name="orgCd8" size="15" value="" maxlength="5"> <input type="text" name="orgCd9" size="15" value="" maxlength="5"> <input type="text" name="orgCd10" size="15" value="" maxlength="5"></td>
                    </tr>
</table>

<table border="0" cellpadding="1" cellspacing="2">

<%
    '## 2013/1/4 �� �f�t�H���g�R�[�X�ݒ�ׁ̈A�R�����g�ǉ� Start ##########################################
%>
                    <tr><td colspan="5">&nbsp;</td></tr>
                    <tr>
                        <td colspan="5"><font color="red">�� �R�[�X�R�[�h���w��̏ꍇ�A�u1���l�ԃh�b�N�v�A�u�E��������N�f�f�i�h�b�N�j�v�A�u��ƌ��f�v�̂ݑΏۂƂ��܂��B</font></td>
                    </tr>
<%
    '## 2013/1/4 �� �f�t�H���g�R�[�X�ݒ�ׁ̈A�R�����g�ǉ� Start ##########################################
%>

                    <tr>
                        <td>��</td>
                        <td width="120" nowrap>�R�[�X�R�[�h 1-2</td>
                        <td>�F</td>
                        <td><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd", strCsCd, NON_SELECTED_ADD, False) %></td>
                              <td><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd1", strCsCd1, NON_SELECTED_ADD, False) %></td>
                    </tr>
                    <tr>
                        <td>��</td>
                        <td width="120" nowrap>�R�[�X�R�[�h 3-4</td>
                        <td>�F</td>
                              <td><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd2", strCsCd2, NON_SELECTED_ADD, False) %></td>
                              <td><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd3", strCsCd3, NON_SELECTED_ADD, False) %></td>
                    </tr>
                    <tr>
                        <td>��</td>
                        <td width="120" nowrap>�R�[�X�R�[�h 5-6</td>
                        <td>�F</td>
                        <td><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd4", strCsCd4, NON_SELECTED_ADD, False) %></td>
                              <td><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd5", strCsCd5, NON_SELECTED_ADD, False) %></td>
                    </tr>
                    <tr>
                        <td>��</td>
                        <td width="120" nowrap>�R�[�X�R�[�h 7-8</td>
                        <td>�F</td>
                        <td><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd6", strCsCd6, NON_SELECTED_ADD, False) %></td>
                              <td><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd7", strCsCd7, NON_SELECTED_ADD, False) %></td>
                    </tr>
                    <tr>
                        <td>��</td>
                        <td width="120" nowrap>�R�[�X�R�[�h 9-10</td>
                        <td>�F</td>
                              <td><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd8", strCsCd8, NON_SELECTED_ADD, False) %></td>
                              <td><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd9", strCsCd9, NON_SELECTED_ADD, False) %></td>
                    </tr>
</table>

<!--- ������[�h -->
<%
    '������[�h�̏����ݒ�
    strMode = IIf(strMode = "", PRINTMODE_PREVIEW, strMode)
%>
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