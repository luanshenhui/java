<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'       �c�̃_�C���N�g���[�� (Ver0.0.1)
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

'�p�����[�^�l
Dim strSCslYear, strSCslMonth, strSCslDay   '�J�n�N����
Dim strECslYear, strECslMonth, strECslDay   '�I���N����
Dim strOrgdiv
Dim strDm
Dim striti
Dim strbusu
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
Dim strOrgCd81                              '�c�̃R�[�h�W�P
Dim strOrgCd82                              '�c�̃R�[�h�W�Q
Dim strOrgCd91                              '�c�̃R�[�h�X�P
Dim strOrgCd92                              '�c�̃R�[�h�X�Q
Dim strOrgCd101                             '�c�̃R�[�h�P�O�P
Dim strOrgCd102                             '�c�̃R�[�h�P�O�Q
'### 2006/1/16 �� �c�̑I����12�c�̂܂ŏo����悤�ɒǉ� Start ###
Dim strOrgCd111                             '�c�̃R�[�h�P�P�P
Dim strOrgCd112                             '�c�̃R�[�h�P�P�Q
Dim strOrgCd121                             '�c�̃R�[�h�P�Q�P
Dim strOrgCd122                             '�c�̃R�[�h�P�Q�Q
'### 2006/1/16 �� �c�̑I����12�c�̂܂ŏo����悤�ɒǉ� End   ###

dim strOptResult
Dim ogc1
Dim ogc2
Dim ogc3
Dim ogc4
Dim ogc5
Dim ogc6
Dim ogc7
Dim ogc8
Dim ogc9
Dim ogc10
'### 2006/1/16 �� �c�̑I����12�c�̂܂ŏo����悤�ɒǉ� Start ###
Dim ogc11
Dim ogc12
'### 2006/1/16 �� �c�̑I����12�c�̂܂ŏo����悤�ɒǉ� End   ###

Dim strReportOutDate                        '�o�͓�
Dim strReportOutput                         '�o�͗l��
Dim strHistoryPrint                         '�ߋ������
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
Dim strOrgName8                             '�c�̂W����
Dim strOrgName9                             '�c�̂X����
Dim strOrgName10                            '�c�̂P�O����
'### 2006/1/16 �� �c�̑I����12�c�̂܂ŏo����悤�ɒǉ� Start ###
Dim strOrgName11                            '�c�̂P�P����
Dim strOrgName12                            '�c�̂P�Q����
'### 2006/1/16 �� �c�̑I����12�c�̂܂ŏo����悤�ɒǉ� End   ###


'���[���
Dim strArrReportCd                          '���[�R�[�h
Dim strArrReportName                        '���[��
Dim strArrHistoryPrint                      '�ߋ������
Dim lngReportCount                          '���R�[�h��

Dim i                   '���[�v�C���f�b�N�X
Dim j                   '���[�v�C���f�b�N�X

Dim strOutPutCls                            '�o�͑Ώ�
Dim strArrOutputCls()                       '�o�͑Ώۋ敪
Dim strArrOutputClsName()                   '�o�͑Ώۋ敪��

Dim strOutPutCls1                           '�o�͑Ώ�
Dim strArrOutputCls1()                      '�o�͑Ώۋ敪
Dim strArrOutputClsName1()                  '�o�͑Ώۋ敪��

Dim strOutPutCls2                           '�o�͑Ώ�
Dim strArrOutputCls2()                      '�o�͑Ώۋ敪
Dim strArrOutputClsName2()                  '�o�͑Ώۋ敪��

Dim strOutPutCls3                           '�o�͑Ώ�
Dim strArrOutputCls3()                      '�o�͑Ώۋ敪
Dim strArrOutputClsName3()                  '�o�͑Ώۋ敪��

Dim strOutPutCls4                           '�o�͑Ώ�
Dim strArrOutputCls4()                      '�o�͑Ώۋ敪
Dim strArrOutputClsName4()                  '�o�͑Ώۋ敪��

Dim strOutPutCls5                           '�o�͑Ώ�
Dim strArrOutputCls5()                      '�o�͑Ώۋ敪
Dim strArrOutputClsName5()                  '�o�͑Ώۋ敪��

Dim strOutPutCls6                           '�o�͑Ώ�
Dim strArrOutputCls6()                      '�o�͑Ώۋ敪
Dim strArrOutputClsName6()                  '�o�͑Ώۋ敪��

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

    strOutputCls    = Request("outputCls")
    strOutputCls1   = Request("outputCls1")
    strOutputCls2   = Request("outputCls2")
    strOutputCls3   = Request("outputCls3")
    strOutputCls4   = Request("outputCls4")
    strOutputCls5   = Request("outputCls5")
    strOutputCls6   = Request("outputCls6")

    strOptResult    = Request("OptResult")

'�R�[�X�R�[do
     strCsCd        = Request("csCd")
     strCsCd1       = Request("csCd1")
     strCsCd2       = Request("csCd2")
     strCsCd3       = Request("csCd3")
     strCsCd4       = Request("csCd4")
     strCsCd5       = Request("csCd5")
     strCsCd6       = Request("csCd6")
     strCsCd7       = Request("csCd7")
     strCsCd8       = Request("csCd8")
     strCsCd9       = Request("csCd9")


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

    '�c�̂U
    strOrgCd61  = Request("OrgCd61")
    strOrgCd62  = Request("OrgCd62")
    strOrgName6 = Request("OrgName6")

    '�c�̂V
    strOrgCd71  = Request("OrgCd71")
    strOrgCd72  = Request("OrgCd72")
    strOrgName7 = Request("OrgName7")

    '�c�̂W
    strOrgCd81  = Request("OrgCd81")
    strOrgCd82  = Request("OrgCd82")
    strOrgName8 = Request("OrgName8")

    '�c�̂X
    strOrgCd91  = Request("OrgCd91")
    strOrgCd92  = Request("OrgCd92")
    strOrgName9 = Request("OrgName9")

    '�c�̂P�O
    strOrgCd101 = Request("OrgCd101")
    strOrgCd102 = Request("OrgCd102")
    strOrgName10= Request("OrgName10")

'### 2006/1/16 �� �c�̑I����12�c�̂܂ŏo����悤�ɒǉ� Start ###
    '�c�̂P�P
    strOrgCd111 = Request("OrgCd111")
    strOrgCd112 = Request("OrgCd112")
    strOrgName11= Request("OrgName11")

    '�c�̂P�Q
    strOrgCd121 = Request("OrgCd121")
    strOrgCd122 = Request("OrgCd122")
    strOrgName12= Request("OrgName12")
'### 2006/1/16 �� �c�̑I����12�c�̂܂ŏo����悤�ɒǉ� End   ###

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

    Dim vntArrMessage   '�G���[���b�Z�[�W�̏W��
    Dim blnErrFlg

    '�����Ƀ`�F�b�N�������L�q(��ɕK�{�̃`�F�b�N�i�L�E���j
    With objCommon


    End With

    '�߂�l�̕ҏW
    If IsArray(vntArrMessage) Then
        CheckValue = vntArrMessage
    End If

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �o�͑ΏۂɊւ���z��𐶐�����
'
' �����@�@ : 
'
' �߂�l�@ : �Ȃ�
'
' ���l�@�@ : 
'
'-------------------------------------------------------------------------------
Sub CreateOutputInfo()
	
End Sub

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
    Dim objFlexReport

    If Not IsArray(CheckValue()) Then

        ogc1 = strOrgCd11 & strOrgCd12
        ogc2 = strOrgCd21 & strOrgCd22
        ogc3 = strOrgCd31 & strOrgCd32
        ogc4 = strOrgCd41 & strOrgCd42
        ogc5 = strOrgCd51 & strOrgCd52
        ogc6 = strOrgCd61 & strOrgCd62
        ogc7 = strOrgCd71 & strOrgCd72
        ogc8 = strOrgCd81 & strOrgCd82
        ogc9 = strOrgCd91 & strOrgCd92
        ogc10 = strOrgCd101 & strOrgCd102
'### 2006/1/16 �� �c�̑I����12�c�̂܂ŏo����悤�ɒǉ� Start ###
        ogc11 = strOrgCd111 & strOrgCd112
        ogc12 = strOrgCd121 & strOrgCd122
'### 2006/1/16 �� �c�̑I����12�c�̂܂ŏo����悤�ɒǉ� End   ###
        
        Set objFlexReport = Server.CreateObject("HainsDM.DM")
'### 2006/1/16 �� �c�̑I����12�c�̂܂ŏo����悤�ɏC�� Start ###
        'Ret = objFlexReport.PrintDM(Session("USERID"),strOutputCls,strOutputCls1,strOutputCls2,strOutputCls3,strOptResult,ogc1,ogc2,ogc3,ogc4,ogc5,ogc6,ogc7,ogc8,ogc9,ogc10,strCsCd,strCsCd1,strCsCd2,strCsCd3,strCsCd4,strCsCd5,strCsCd6,strCsCd7,strCsCd8,strCsCd9,strOutputCls4,strOutputCls5,strOutputCls6)
        Ret = objFlexReport.PrintDM(Session("USERID"),strOutputCls,strOutputCls1,strOutputCls2,strOutputCls3,strOptResult,ogc1,ogc2,ogc3,ogc4,ogc5,ogc6,ogc7,ogc8,ogc9,ogc10,ogc11,ogc12,strCsCd,strCsCd1,strCsCd2,strCsCd3,strCsCd4,strCsCd5,strCsCd6,strCsCd7,strCsCd8,strCsCd9,strOutputCls4,strOutputCls5,strOutputCls6)
'### 2006/1/16 �� �c�̑I����12�c�̂܂ŏo����悤�ɏC�� End   ###
        Print = Ret

    End If
End Function

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Microsoft FrontPage 4.0">
<TITLE>�c�̈��_�C���N�g���[��</TITLE>
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
<BODY ONLOAD="javascript:checkRunState();">
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" onsubmit="setRunState();">
	<INPUT TYPE="hidden" NAME="runstate" VALUE="">
    <BLOCKQUOTE>
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">��</SPAN>�c�̈��_�C���N�g���[��</B></TD>
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
    <INPUT TYPE="hidden" NAME="orgCd101"       VALUE="<%= strOrgCd101       %>">
    <INPUT TYPE="hidden" NAME="orgCd102"       VALUE="<%= strOrgCd102       %>">
<!--### 2006/1/16 �� �c�̑I����12�c�̂܂ŏo����悤�ɒǉ� Start ###-->
    <INPUT TYPE="hidden" NAME="orgCd111"       VALUE="<%= strOrgCd111       %>">
    <INPUT TYPE="hidden" NAME="orgCd112"       VALUE="<%= strOrgCd112       %>">
    <INPUT TYPE="hidden" NAME="orgCd121"       VALUE="<%= strOrgCd121       %>">
    <INPUT TYPE="hidden" NAME="orgCd122"       VALUE="<%= strOrgCd122       %>">
<!--### 2006/1/16 �� �c�̑I����12�c�̂܂ŏo����悤�ɒǉ� End   ###-->

<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <td><font color="#ff0000">��</font></td>
            <TD WIDTH="132" NOWRAP>����</TD>
            <TD>�F</TD>
            <TD>
                <select name="outputCls" size="1">
                    <option selected value="4">�c�l�K�p�Z��</option>
                    <option value="0">�������K�p�Z��</option>
                    <option value="1">�Z���P</option>
                    <option value="2">�Z��2</option>
                    <option value="3">�Z��3</option>
                </select>
            </TD>
        </TR>
</table>

<table border="0" cellpadding="1" cellspacing="2">
        <TR>
            <td><font color="#ff0000">��</font></td>
            <TD WIDTH="132" NOWRAP>�c�̎��</TD>
            <TD>�F</TD>
            <TD>
                <select name="outputCls1" size="1">
                    <option selected value="0">�S��</option>
                    <option value="1">���ۘA</option>
                    <option value="2">���ڌ_��</option>
                    <option value="3">���ڌ_��(�֘A���)</option>
                    <option value="4">�g�p����</option>
                </select>
            </TD>
            <!--TD>
                <select name="outputCls1" size="1">
                    <option selected value="0">�S��</option>
                    <option value="1">���ۘA</option>
                    <option value="2">�_��E��</option>
                    <option value="3">�_��E�֘A</option>
                    <option value="4">���_��E�֘A</option>
                </select>
            </TD-->
        </TR>
</table>
<table border="0" cellpadding="1" cellspacing="2">
        <tr>
            <TD>��</TD>
            <td width="132" nowrap>�N�n�E�����E�Ε�</td>
            <td>�F</td>
            <TD>
                <select name="outputCls2" size="1">
                    <option selected value="0">�S��</option>
                    <option value="1">�Ώۂ̂�</option>
                </select>
            </TD>
        </tr>
</table>
<!--table border="0" cellpadding="1" cellspacing="2">
        <tr>
            <TD>��</TD>
            <td width="132" nowrap>DM</td>
            <td>�F</td>
            <TD>
                <select name="outputCls3" size="1">
                    <option selected value="0">�S��</option>
                    <option value="1">�Ώۂ̂�</option>
                </select>
            </TD>
        </tr>
</table-->

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
        <TR>
            <td><font color="#ff0000">��</font></td>
            <td width="132" nowrap>�c�̎w����@</td>
            <td>�F</td>
            <TD><INPUT TYPE="radio" NAME="optResult" VALUE="0" <%= IIf(strOptResult = 0, "CHECKED", "") %>>�S��<INPUT TYPE="radio" NAME="optResult" VALUE="2"    <%= IIf(strOptResult = 2,    "CHECKED", "") %>>��</TD>
        </TR>
</table>

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
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd21, document.entryForm.orgCd22, 'OrgName2')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName2"><% = strOrgName2 %></SPAN></TD>
        </TR>
        <TR>
            <TD>��</TD>
            <TD WIDTH="90" NOWRAP>�c�̂R</TD>
            <TD>�F</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd31, document.entryForm.orgCd32, 'OrgName3')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd31, document.entryForm.orgCd32, 'OrgName3')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName3"><% = strOrgName3 %></SPAN></TD>
        </TR>
        <TR>
            <TD>��</TD>
            <TD WIDTH="90" NOWRAP>�c�̂S</TD>
            <TD>�F</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd41, document.entryForm.orgCd42, 'OrgName4')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd41, document.entryForm.orgCd42, 'OrgName4')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
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
            <TD NOWRAP><SPAN ID="OrgName10"><% = strOrgName10 %></SPAN></TD>
        </TR>
<!--### 2006/1/16 �� �c�̑I����12�c�̂܂ŏo����悤�ɒǉ� Start ###-->
        <TR>
            <TD>��</TD>
            <TD WIDTH="132" NOWRAP>�c��11</TD>
            <TD>�F</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd111, document.entryForm.orgCd112, 'OrgName11')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd111, document.entryForm.orgCd112, 'OrgName11')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName11"><% = strOrgName11 %></SPAN></TD>
        </TR>
        <TR>
            <TD>��</TD>
            <TD WIDTH="132" NOWRAP>�c��12</TD>
            <TD>�F</TD>
            <TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd121, document.entryForm.orgCd122, 'OrgName12')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
            <TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd121, document.entryForm.orgCd122, 'OrgName12')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
            <TD NOWRAP><SPAN ID="OrgName12"><% = strOrgName12 %></SPAN></TD>
        </TR>
<!--### 2006/1/16 �� �c�̑I����12�c�̂܂ŏo����悤�ɒǉ� End   ###-->
</TABLE>

    <table border="0" cellpadding="1" cellspacing="2">
        <tr>
            <td>��</td>
            <td width="132" nowrap>�R�[�X�R�[�h 1-2 </td>
            <td>�F</td>
            <td><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd", strCsCd, NON_SELECTED_ADD, False) %></td>
            <td><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd1", strCsCd1, NON_SELECTED_ADD, False) %></td>
        </tr>
     </table>
    <table border="0" cellpadding="1" cellspacing="2">
        <tr>
            <td>��</td>
            <td width="132" nowrap>�R�[�X�R�[�h 3-4</td>
            <td>�F</td>
            <td><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd2", strCsCd2, NON_SELECTED_ADD, False) %></td>
            <td><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd3", strCsCd3, NON_SELECTED_ADD, False) %></td>
        </tr>
    </table>
    <table border="0" cellpadding="1" cellspacing="2">
        <tr>
            <td>��</td>
            <td width="132" nowrap>�R�[�X�R�[�h 5-6</td>
            <td>�F</td>
            <td><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd4", strCsCd4, NON_SELECTED_ADD, False) %></td>
            <td><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd5", strCsCd5, NON_SELECTED_ADD, False) %></td>
        </tr>
    </table>
    <table border="0" cellpadding="1" cellspacing="2">
        <tr>
            <td>��</td>
            <td width="132" nowrap>�R�[�X�R�[�h 7-8</td>
            <td>�F</td>
            <td><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd6", strCsCd6, NON_SELECTED_ADD, False) %></td>
            <td><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd7", strCsCd7, NON_SELECTED_ADD, False) %></td>
        </tr>
    </table>
    <table border="0" cellpadding="1" cellspacing="2">
        <tr>
            <td>��</td>
            <td width="132" nowrap>�R�[�X�R�[�h 9-10</td>
            <td>�F</td>
            <td><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd8", strCsCd8, NON_SELECTED_ADD, False) %></td>
            <td><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd9", strCsCd9, NON_SELECTED_ADD, False) %></td>
        </tr>
    </table>
    <table border="0" cellpadding="1" cellspacing="2">
        <tr>
            <td><font color="#ff0000">��</font></td>
            <td width="132" nowrap>�\�[�g</td>
            <td>�F</td>
            <TD>
                <select name="outputCls4" size="1">
                    <option selected value="1">�c�̃R�[�h��</option>
                    <option value="2">�c�̃J�i��</option>
                </select>
            </TD>
        </tr>
    </table>
    <table border="0" cellpadding="1" cellspacing="2">
        <tr>
            <td><font color="#ff0000">��</font></td>
            <td width="132" nowrap>����J�n�ʒu</td>
            <td>�F</td>
            <TD>
                <select name="outputCls5" size="1">
                    <option selected value="1">1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                    <option value="6">6</option>
                    <option value="7">7</option>
                    <option value="8">8</option>
                    <option value="9">9</option>
                    <option value="10">10</option>
                    <option value="11">11</option>
                    <option value="12">12</option>
                </select>
            </TD>
        </tr>
    </table>

<table border="0" cellpadding="1" cellspacing="2">
        <tr>
            <td><font color="#ff0000">��</font></td>
            <td width="132" nowrap>�������</td>
            <td>�F</td>
            <TD>
                <select name="outputCls6" size="1">
                    <option selected value="1">1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                    <option value="6">6</option>
                    <option value="7">7</option>
                    <option value="8">8</option>
                    <option value="9">9</option>
                    <option value="10">10</option>
                    <option value="11">11</option>
                    <option value="12">12</option>
                </select>
            </TD>
        </tr>
</table>

<!--- ������[�h -->
<%
    '������[�h�̏����ݒ�
    strMode = IIf(strMode = "", PRINTMODE_PREVIEW, strMode)
%>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">

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