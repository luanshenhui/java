<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'	�l�[ (Ver0.0.1)
'	AUTHER  :
'-------------------------------------------------------------------------------
'       �Ǘ��ԍ��FSL-UI-Y0101-213
'       �C����  �F2010.04.26
'       �S����  �FASC)���n
'       �C�����e�FReport Designer��Co Reports�ɕύX
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"          -->
<!-- #include virtual = "/webHains/includes/common.inc"                -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"           -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"        -->
<!-- #include virtual = "/webHains/includes/print.inc"                 -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc"  -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseTable.inc" -->
<!-- #include virtual = "/webHains/includes/tokyu_editReportList.inc"  -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim strMode			'������[�h
Dim vntMessage		'�ʒm���b�Z�[�W
Dim strURL			'URL
Dim UID
'-------------------------------------------------------------------------------
' �ŗL�錾���i�e���[�ɉ����Ă��̃Z�N�V�����ɕϐ����`���ĉ������j
'-------------------------------------------------------------------------------
'COM�I�u�W�F�N�g
Dim objCommon           '���ʃN���X
Dim objOrganization     '�c�̏��A�N�Z�X�p

'�������������������� ��ʍ��ڂɂ��킹�ĕҏW
'�����l
Dim strSCslYear, strSCslMonth, strSCslDay   '��f��
Dim strDayId                                '����ID

'��������������������

'��Ɨp�ϐ�

Dim strSCslDate         '��f��
Dim strArrSubCourse     '�T�u�R�[�X�R�[�h
Dim i, j                '�J�E���^

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

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
        strSCslYear     = Year(Now())               '��f�N
        strSCslMonth    = Month(Now())              '��f��
        strSCslDay      = Day(Now())                '��f��
    Else
        strSCslYear     = Request("strCslYear")     '��f�N
        strSCslMonth    = Request("strCslMonth")    '��f��
        strSCslDay      = Request("strCslDay")      '��f��
    End If
    strSCslDate   = strSCslYear & "/" & strSCslMonth & "/" & strSCslDay

'�� ����ID
    strDayId    = Request("DayId")

    UID = Session("USERID")

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

    Dim vntArrMessage	'�G���[���b�Z�[�W�̏W��

'�������������������� ��ʍ��ڂɂ��킹�ĕҏW
    '�����Ƀ`�F�b�N�������L�q
    With objCommon
        If strMode <> "" Then

            '�� ��f���t�������`�F�b�N
            If Not IsDate(strSCslDate) Then
                .AppendArray vntArrMessage, "�J�n���t������������܂���B"
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

    Dim objPrintCls     'COM�R���|�[�l���g
    Dim Ret             '�֐��߂�l
    Dim objCommon
    If Not IsArray(CheckValue()) Then

		'���R�����΍��p���O�����o��
		Call putPrivacyInfoLog("PH029", "�l�[�̈�����s����")

'#### 2010.04.26 SL-UI-Y0101-213 MOD START ####'
'        Set objCommon = Server.CreateObject("HainsCommon.Common")
'
'        strURL = "/webHains/contents/report_form/rd_37_prtPatient.asp"
'        strURL = strURL & "?p_Uid=" & UID
'        strURL = strURL & "&p_ScslDate=" & objCommon.FormatString(CDate(strSCslDate), "yyyy/mm/dd")
'        strURL = strURL & "&p_DayID=" & strDayId
'
'        Set objCommon = Nothing
'        Response.Redirect strURL
'        Response.End

		'�I�u�W�F�N�g�̃C���X�^���X�쐬�i�v���W�F�N�g��.�N���X���j
		Set objPrintCls = Server.CreateObject("HainsprtPatient.prtPatient")
		'�h�L�������g�t�@�C���쐬�����i�I�u�W�F�N�g.���\�b�h��(����)�j
		Ret = objPrintCls.PrintOut(UID, _
								   strSCslDate, _
							       strDayId)
		Print = Ret

'#### 2010.04.26 SL-UI-Y0101-213 MOD END ####'

    End If

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>�l�[</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
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
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">���l�[</SPAN></B></TD>
        </TR>
    </TABLE>
    <BR>

<!--- ���t -->
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD><FONT COLOR="#ff0000">��</FONT></TD>
            <TD WIDTH="90" NOWRAP>��f��</TD>
            <TD> �F</TD>
            <TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
            <TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strSCslYear, False) %></TD>
            <TD>�N</TD>
            <TD><%= EditNumberList("strCslMonth", 1, 12, strSCslMonth, False) %></TD>
            <TD>��</TD>
            <TD><%= EditNumberList("strCslDay", 1, 31, strSCslDay, False) %></TD>
            <TD>��</TD>
        </TR>
    </TABLE>
    <!-- ����ID -->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
        <TR>
            <TD><font color="black">��</font></TD>
            <TD WIDTH="90" NOWRAP>����ID</TD>
            <TD>�F</TD>
            <TD><INPUT TYPE="text" NAME="DayId" MAXLENGTH="4" SIZE="10" VALUE="<%= strDayId %>"></TD>
        </TR>
    </TABLE>
    <!--- ������[�h -->
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
        <TR>
            <INPUT TYPE="hidden" NAME="mode" VALUE="0">
        </TR>
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