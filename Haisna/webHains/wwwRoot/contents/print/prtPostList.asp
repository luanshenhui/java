<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'   �X�֕���̏�(�������A���ѕ\�j (Ver0.0.1)
'   AUTHER  :
'-------------------------------------------------------------------------------
'       �Ǘ��ԍ��FSL-UI-Y0101-231~232
'       �C����  �F2010.05.11
'       �S����  �FASC)�O�Y
'       �C�����e�FReport Designer��Co Reports�ɕύX
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/print.inc"                -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc"   -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseTable.inc"  -->
<!-- #include virtual = "/webHains/includes/tokyu_editReportList.inc"   -->
<!-- #include virtual = "/webHains/includes/tokyu_editDmdClassList.inc" -->
<!-- #include virtual = "/webHains/includes/tokyu_editJudClassList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim strMode         '������[�h
Dim vntMessage      '�ʒm���b�Z�[�W
Dim strURL          'URL
Dim UID
'-------------------------------------------------------------------------------
' �ŗL�錾���i�e���[�ɉ����Ă��̃Z�N�V�����ɕϐ����`���ĉ������j
'-------------------------------------------------------------------------------
'COM�I�u�W�F�N�g
Dim objCommon       '���ʃN���X
Dim objOrganization '�c�̏��A�N�Z�X�p

'�����l
Dim strSSendDate,strSSendYear, strSSendMonth, strSSendDay   '�J�n�N����
Dim strESendDate,strESendYear, strESendMonth, strESendDay   '�I���N����

Dim strLoginId                              '���s�������s�����S����(���O�C���jID

Dim strOutPutCls                            '�o�͑Ώ�
Dim strOutPutCscd                           '�o�͑Ώ�

'##�X�֕��敪
Dim strArrOutputCls()                       '�o�͑Ώۋ敪
Dim strArrOutputClsName()                   '�o�͑Ώۋ敪��

'##�R�[�X�敪
Dim strArrOutputCscd()                      '�o�͑Ώۋ敪
Dim strArrOutputCscdName()                  '�o�͑Ώۋ敪��

'��Ɨp�ϐ�
Dim i, j            '�J�E���^

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

'���ʈ����l�̎擾
strMode = Request("mode")

'�o�͑Ώۋ敪�C���̂̐���
Call CreateOutputInfo()

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
    If IsEmpty(Request("strSendYear")) Then
        strSSendYear   = Year(Now())             '�J�n�N
        strSSendMonth  = Month(Now())            '�J�n��
        strSSendDay    = Day(Now())              '�J�n��
    Else
        strSSendYear   = Request("strSendYear")   '�J�n�N
        strSSendMonth  = Request("strSendMonth")  '�J�n��
        strSSendDay    = Request("strSendDay")    '�J�n��
    End If
    strSSendDate   = strSSendYear & "/" & strSSendMonth & "/" & strSsendDay

'�� �I���N����
    If IsEmpty(Request("endSendYear")) Then
'       strESendYear   = Year(Now())             '�I���N
'       strESendMonth  = Month(Now())            '�J�n��
'       strESendDay    = Day(Now())              '�J�n��
    Else
        strESendYear   = Request("endSendYear")   '�I���N
        strESendMonth  = Request("endSendMonth")  '�J�n��
        strESendDay    = Request("endSendDay")    '�J�n��
    End If
    strESendDate   = strESendYear & "/" & strESendMonth & "/" & strESendDay

'�� �o�͑Ώ�
    strOutputCls    = Request("outputCls")      '�ΏۗX�֕�
    strOutputCscd   = Request("outputCscd")     '�ΏۃR�[�X
    strLoginId      = Request("LoginId")        '�Ώ۔��s�S����ID

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

    '�����Ƀ`�F�b�N�������L�q
    With objCommon
        If strMode <> "" Then

            '�� �������`�F�b�N
            If Not IsDate(strESendDate) Then
                strESendDate = strSSendDate
            End If
            '�� �J�n���t�������`�F�b�N
            If Not IsDate(strSSendDate) Then
                .AppendArray vntArrMessage, "�J�n��������������܂���B"
            End If

            If Not IsDate(strESendDate) Then
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

    Dim objPrintCls '�c�̈ꗗ�o�͗pCOM�R���|�[�l���g
    Dim objBill     '�������e�[�u���pCOM�R���|�[�l���g
    Dim PrintRet    '�֐��߂�l
    Dim UpdateRet   '�֐��߂�l
    Dim objCommon
    If Not IsArray(CheckValue()) Then

		'���R�����΍��p���O�����o��
		Call putPrivacyInfoLog("PH034", "�X�֕���̏� �̈�����s����")

'#### 2010.05.11 SL-UI-Y0101-231~232 MOD START ####'
'        Set objCommon = Server.CreateObject("HainsCommon.Common")
'        strURL = "/webHains/contents/report_form/rd_33_prtPostList.asp"
'        strURL = strURL & "?p_Uid=" & UID
'        strURL = strURL & "&p_strSendDate=" & objCommon.FormatString(CDate(strSSendDate), "yyyy/mm/dd")
'        strURL = strURL & "&p_endSendDate=" & objCommon.FormatString(CDate(strESendDate), "yyyy/mm/dd")
'        strURL = strURL & "&p_strCscd=" & strOutputCscd
'        strURL = strURL & "&p_Option=" & strOutputCls
'        strURL = strURL & "&p_strLoginId=" & strLoginId
'        Set objCommon = Nothing
'        Response.Redirect strURL
'        Response.End

		Dim Ret			'�֐��߂�l
		'�I�u�W�F�N�g�̃C���X�^���X�쐬�i�v���W�F�N�g��.�N���X���j
		if strOutputCls = "0" then
			Set objPrintCls = Server.CreateObject("HainsprtPostBill.prtPostBill")
		else
			Set objPrintCls = Server.CreateObject("HainsprtPostReport.prtPostReport")
		end if
		'�h�L�������g�t�@�C���쐬�����i�I�u�W�F�N�g.���\�b�h��(����)�j
		Ret = objPrintCls.PrintOut(UID, _
								   strSSendDate, _
							       strESendDate, _
							       strOutputCscd, _
							       strOutputCls, _
							       strLoginId)
		Print = Ret

'#### 2010.05.11 SL-UI-Y0101-231~232 MOD END ####'

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

    Redim Preserve strArrOutputCls(1)
    Redim Preserve strArrOutputClsName(1)

    strArrOutputCls(0) = "0":strArrOutputClsName(0) = "(�c��)������"
    strArrOutputCls(1) = "1":strArrOutputClsName(1) = "���ѕ\"

    Redim Preserve strArrOutputCscd(4)
    Redim Preserve strArrOutputCscdName(4)

    strArrOutputCscd(0) = "100":strArrOutputCscdName(0) = "1���l�ԃh�b�N"
    strArrOutputCscd(1) = "110":strArrOutputCscdName(1) = "��ƌ��f"
    strArrOutputCscd(2) = "170":strArrOutputCscdName(2) = "�n�q����"
    strArrOutputCscd(3) = "150":strArrOutputCscdName(3) = "�x�h�b�N"
    strArrOutputCscd(4) = "999":strArrOutputCscdName(4) = "���̑�"

End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�X�֕��������X�g</TITLE>
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
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">��</SPAN><FONT COLOR="#000000">�X�֕���̏�(�c�̐������A���ѕ\�j</FONT></B></TD>
        </TR>
    </TABLE>
<%
'�G���[���b�Z�[�W�\��

    '���b�Z�[�W�̕ҏW
    If( strMode <> "" )Then

        '�ۑ��������́u�ۑ������v�̒ʒm
        Call EditMessage(vntMessage, MESSAGETYPE_WARNING)

    End If
%>
    <BR>

<!--- ���t -->
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD><FONT COLOR="#ff0000">��</FONT></TD>
            <TD WIDTH="90" NOWRAP>������</TD>
<!--- ���t -->
            <TD>�F</TD>
            <TD><A HREF="javascript:calGuide_showGuideCalendar('strSendYear', 'strSendMonth', 'strSendDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
            <TD><%= EditNumberList("strSendYear", YEARRANGE_MIN, YEARRANGE_MAX, strSSendYear, False) %></TD>
            <TD>�N</TD>
            <TD><%= EditNumberList("strSendMonth", 1, 12, strSSendMonth, False) %></TD>
            <TD>��</TD>
            <TD><%= EditNumberList("strSendDay", 1, 31, strSSendDay, False) %></TD>
            <TD>��</TD>
            <TD>�`</TD>
            <TD><A HREF="javascript:calGuide_showGuideCalendar('endSendYear', 'endSendMonth', 'endSendDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
            <TD><%= EditSelectNumberList("endSendYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strESendYear)) %></TD>
            <TD>�N</TD>
            <TD><%= EditSelectNumberList("endSendMonth", 1, 12, Clng("0" & strESendMonth)) %></TD>
            <TD>��</TD>
            <TD><%= EditSelectNumberList("endSendDay",   1, 31, Clng("0" & strESendDay  )) %></TD>
            <TD>��</TD>

        </TR>
    </TABLE>
<!--- �X�֕��I�� -->
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD><FONT COLOR="#ff0000">��</FONT></TD>
            <TD WIDTH="90" NOWRAP>�X�֕��I��</TD>
            <TD>�F</TD>
            <TD><%= EditDropDownListFromArray("outputCls", strArrOutputCls, strArrOutputClsName , strOutputCls, NON_SELECTED_DEL) %></TD>
        </TR>
    </TABLE>
<!--- �R�[�X�I�� -->
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD><FONT>��</FONT></TD>
            <TD WIDTH="90" NOWRAP>�R�[�X�I��</TD>
            <TD>�F</TD>
            <TD><%= EditDropDownListFromArray("outputCscd", strArrOutputCscd, strArrOutputCscdName , strOutputCscd, NON_SELECTED_ADD) %>&nbsp;&nbsp;���ѕ\�̂ݑΉ�</TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR><TD COLSPAN="4">���󗓂̏ꍇ�A���ׂẴR�[�X���Ώ�</TD></TR>
        <TR><TD COLSPAN="4">�����̑��̏ꍇ�A1���l�ԃh�b�N�A��ƌ��f�A�n�q���ȁA�x�h�b�N�ȊO�̃R�[�X���Ώ�</TD></TR>
    </TABLE>
    <BR>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD>��</TD>
            <TD WIDTH="90" NOWRAP>������ID</TD>
            <TD>�F</TD>
            <TD><INPUT TYPE="text" NAME="LoginId" SIZE="20" VALUE="" MAXLENGTH="10">&nbsp;&nbsp;�����������s�����S����ID����́i ��F425XXX �j</TD>
        </TR>
    </TABLE>
    <p><BR><BR><BR>
<!--- ������[�h -->
    <INPUT TYPE="hidden" NAME="mode" VALUE="0">
<!--- ����{�^�� -->
	<!---2006.07.04 �����Ǘ� �ǉ� by ��  -->
    <% If Session("PAGEGRANT") = "4" Then   %>
	    <INPUT TYPE="image" NAME="print" SRC="/webHains/images/print.gif" WIDTH="77" HEIGHT="24" ALT="�������"><br>
	<%  End if  %>

</FORM></p>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>

</BODY>
</HTML>