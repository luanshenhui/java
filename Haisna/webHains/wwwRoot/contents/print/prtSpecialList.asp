<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'   ���茒�f��f�҃��X�g (Ver0.0.1)
'   AUTHER  :
'-------------------------------------------------------------------------------
'       �Ǘ��ԍ��FSL-UI-Y0101-215
'       �C����  �F2010.04.26
'       �S����  �FASC)���n
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
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objFree         '�ėp���A�N�Z�X�p
Dim objCommon       '���ʃN���X
Dim objOrganization '�c�̏��A�N�Z�X�p

'�����l
Dim strSSendDate,strSSendYear, strSSendMonth, strSSendDay   '�J�n�N����
Dim strESendDate,strESendYear, strESendMonth, strESendDay   '�I���N����

Dim strOutPutCls                            '�o�͑Ώ�
Dim strArrOutputCls()                       '�o�͑Ώۋ敪
Dim strArrOutputClsName()                   '�o�͑Ώۋ敪��

'��Ɨp�ϐ�
Dim i, j            '�J�E���^

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objFree         = Server.CreateObject("HainsFree.Free")

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

            '�� �J�n���t�������`�F�b�N
            If Not IsDate(strSSendDate) Then
                .AppendArray vntArrMessage, "��f��������������܂���B"
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

'#### 2010.04.26 SL-UI-Y0101-215 ADD START ####'
	Dim objPrintCls	'COM�R���|�[�l���g
	Dim Ret			'�֐��߂�l
'#### 2010.04.26 SL-UI-Y0101-215 ADD END ####'
    Dim objCommon
    If Not IsArray(CheckValue()) Then

		'���R�����΍��p���O�����o��
		Call putPrivacyInfoLog("PH031", "���茒�f��f�҃��X�g�̈�����s����")

'#### 2010.04.26 SL-UI-Y0101-215 MOD START ####'
'        Set objCommon = Server.CreateObject("HainsCommon.Common")
'        strURL = "/webHains/contents/report_form/rd_38_prtSpecialList.asp"
'        strURL = strURL & "?p_Uid=" & UID
'        strURL = strURL & "&p_strSendDate=" & objCommon.FormatString(CDate(strSSendDate), "yyyy/mm/dd")
'        Set objCommon = Nothing
'
'        Response.Redirect strURL
'        Response.End

		'�I�u�W�F�N�g�̃C���X�^���X�쐬�i�v���W�F�N�g��.�N���X���j
		Set objPrintCls = Server.CreateObject("HainsprtSpecialList.prtSpecialList")
		'�h�L�������g�t�@�C���쐬�����i�I�u�W�F�N�g.���\�b�h��(����)�j
		Ret = objPrintCls.PrintOut(UID, _
								   strSSendDate)
		Print = Ret

'#### 2010.04.26 SL-UI-Y0101-215 MOD END ####'

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
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>���茒�f��f�҃��X�g</TITLE>
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
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">��</SPAN><FONT COLOR="#000000">���茒�f��f�҃��X�g</FONT></B></TD>
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
            <TD WIDTH="90" NOWRAP>��f��</TD>
<!--- ���t -->
            <TD>�F</TD>
            <TD><A HREF="javascript:calGuide_showGuideCalendar('strSendYear', 'strSendMonth', 'strSendDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
            <TD><%= EditNumberList("strSendYear", YEARRANGE_MIN, YEARRANGE_MAX, strSSendYear, False) %></TD>
            <TD>�N</TD>
            <TD><%= EditNumberList("strSendMonth", 1, 12, strSSendMonth, False) %></TD>
            <TD>��</TD>
            <TD><%= EditNumberList("strSendDay", 1, 31, strSSendDay, False) %></TD>
            <TD>��</TD>

        </TR>
    </TABLE>
    <p><BR><BR><BR>
<!--- ������[�h -->
    <INPUT TYPE="hidden" NAME="mode" VALUE="0">
<!--- ����{�^�� -->
	<!---2008.03.01 �����Ǘ��͂Ƃ肠��������  -->
    <%' If Session("PAGEGRANT") = "4" Then   %>
	    <INPUT TYPE="image" NAME="print" SRC="/webHains/images/print.gif" WIDTH="77" HEIGHT="24" ALT="�������"><br>
	<%'  End if  %>

</FORM></p>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>

</BODY>
</HTML>