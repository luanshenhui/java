<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'   ���ѕ\�`�F�b�N���X�g(Ver1.0.1)
'   AUTHER  :
'-------------------------------------------------------------------------------
'       �Ǘ��ԍ��FSL-UI-Y0101-220~230
'       �C����  �F2010.05.18
'       �S����  �FASC)�V��
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

'�����l
Dim strSSendDate,strSSendYear, strSSendMonth, strSSendDay, convStrSSendDate   '�J�n�N����
Dim strESendDate,strESendYear, strESendMonth, strESendDay, convStrESendDate   '�I���N����


Dim strOutPutCls                            '�o�͑Ώ�
Dim strArrOutputCls()                       '�o�͑Ώۋ敪
Dim strArrOutputClsName()                   '�o�͑Ώۋ敪��

'��Ɨp�ϐ�
Dim i, j            '�J�E���^
Dim strECslDate		'�I����

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
Set objCommon       = Server.CreateObject("HainsCommon.Common")

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
'�� �I���N����
	If IsEmpty(Request("endSendYear")) Then
      //  strESendYear   = Year(Now())             '�I���N
     //   strESendMonth  = Month(Now())            '�I����
      //  strESendDay    = Day(Now())              '�I����
	Else
        strESendYear   = Request("endSendYear")   '�I���N
        strESendMonth  = Request("endSendMonth")  '�I����
        strESendDay    = Request("endSendDay")    '�I����
	End If

    If Len(strSSendMonth) = 1 Then
        strSSendMonth = "0" + strSSendMonth 
    Else 
        strSSendMonth = strSSendMonth
    End If 

    If Len(strSSendDay) = 1 Then
        strSSendDay = "0" + strSSendDay 
    Else 
        strSSendDay = strSSendDay
    End If 

    If Len(strESendMonth) = 1 Then
        strESendMonth = "0" + strESendMonth 
    Else 
        strESendMonth = strESendMonth
    End If 

    If Len(strESendDay) = 1 Then
        strESendDay = "0" + strESendDay 
    Else 
        strESendDay = strESendDay
    End If 

    strSSendDate   = strSSendYear & strSSendMonth & strSSendDay
    convStrSSendDate   = strSSendYear & "/" & strSSendMonth & "/" & strSSendDay
    strESendDate   = strESendYear & strESendMonth & strESendDay
    convStrESendDate   = strESendYear & "/" & strESendMonth & "/" & strESendDay


'�� �o�͑Ώ�
    strOutputCls    = Request("outputCls")      '�`�F�b�N���X�g�Ώ�

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

            '�� �J�n�A�I���`�F�b�N
            If Not IsDate(convStrESendDate) Then
                convStrESendDate = convStrSSendDate
            End If

            If Not IsDate(convStrSSendDate) Then
                .AppendArray vntArrMessage, "�J�n��������������܂���B"
            End If
            If Not IsDate(convStrESendDate) Then
                .AppendArray vntArrMessage, "�I����������������܂���B"
            End If
            If IsDate(convStrSSendDate) Then 
               IF IsDate(convStrESendDate) Then  
                  If DateDiff("y",CDate(convStrSSendDate),CDate(convStrESendDate)) > 13 Then
                       .AppendArray vntArrMessage, "���t�͈͂�2�T�Ԃł��B���̈ȏ�̃f�[�^�̓V�X�e���Ǘ��҂ɂ��A�����������B" 
                  End If
                  If DateDiff("y",CDate(convStrSSendDate),CDate(convStrESendDate)) < 0 Then
                       .AppendArray vntArrMessage, "���t�͈͂�����������܂���B" 
                  End If
               End if
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

'#### 2010.05.18 SL-UI-Y0101-220~230 MOD START ####'
'        Set objCommon = Server.CreateObject("HainsCommon.Common")
'        strURL = "/webHains/contents/report_form/rd_35_prtReportCheckList.asp"
'        strURL = strURL & "?p_Uid=" & UID
'        strURL = strURL & "&p_strSendDate=" & objCommon.FormatString(CDate(convStrSSendDate), "yyyymmdd")
'        strURL = strURL & "&p_strESendDate=" & objCommon.FormatString(CDate(convStrESendDate), "yyyymmdd")
'        strURL = strURL & "&p_Option=" & strOutputCls
'        Set objCommon = Nothing
'        Response.Redirect strURL
'        Response.End

        '�I�u�W�F�N�g�̃C���X�^���X�쐬�i�v���W�F�N�g��.�N���X���j
		Select Case strOutputCls
			Case 0				'��������A���\�쐬�p
				Set objPrintCls = Server.CreateObject("HainsprtReportChecklist.prtRepChecklist")
			Case 1				'�w�l�ȃR�����g�`�F�b�N���X�g
'				Set objPrintCls = Server.CreateObject("HainsprtReport.prtReportGyneChecklist")
				Set objPrintCls = Server.CreateObject("HainsPrtGyneChk.prtReportGyneChecklist")
			Case 2				'���`�F�b�N���X�g
'				Set objPrintCls = Server.CreateObject("HainsprtReport.prtRepRetiphotoChecklist")
				Set objPrintCls = Server.CreateObject("HainsPrtRepRet.prtRepRetiphotoChecklist")
			Case 3				'���������g�`�F�b�N���X�g
'				Set objPrintCls = Server.CreateObject("HainsprtReport.prtRepAbdoEchoChecklist")
				Set objPrintCls = Server.CreateObject("HainsPrtAbdoEc.prtRepAbdoEchoChecklist")
			Case 4				'�����w���`�F�b�N���X�g
'				Set objPrintCls = Server.CreateObject("HainsprtReport.prtReportChestXChecklist")
				Set objPrintCls = Server.CreateObject("HainsprtChestX.prtReportChestXChecklist")
			Case 5				'�㕔�����ǁi�݂w���j�`�F�b�N���X�g
'				Set objPrintCls = Server.CreateObject("HainsprtReport.prtReportGastroChecklist")
				Set objPrintCls = Server.CreateObject("HainsprtGastro.prtReportGastroChecklist")
			Case 6				'�㕔�����ǁi�������j�`�F�b�N���X�g
'				Set objPrintCls = Server.CreateObject("HainsprtReport.prtReportEndoChecklist")
				Set objPrintCls = Server.CreateObject("HainsprtEndo.prtReportEndoChecklist")
			Case 7				'�����b�s�`�F�b�N���X�g
'				Set objPrintCls = Server.CreateObject("HainsprtReport.prtReportCTChecklist")
				Set objPrintCls = Server.CreateObject("HainsPrtCTChk.prtReportCTChecklist")
			Case 8				'���[�w���`�F�b�N���X�g
'				Set objPrintCls = Server.CreateObject("HainsprtReport.prtReportMammoChecklist")
				Set objPrintCls = Server.CreateObject("HainsPrtMammo.prtReportMammoChecklist")
			Case 9				'���[�����g�`�F�b�N���X�g
'				Set objPrintCls = Server.CreateObject("HainsprtReport.prtRepBreastsEchoChklist")
				Set objPrintCls = Server.CreateObject("HainsPrtBreast.prtRepBreastsEchoChklist")
			Case 11				'�S�d�}���菊�����X�g
'				Set objPrintCls = Server.CreateObject("HainsprtReport.prtReportECGlist")
				Set objPrintCls = Server.CreateObject("HainsPrtECG.prtReportECGlist")
			Case Else
				Exit Function 
'			Case 10				'���[�G�f�`�F�b�N���X�g
'			Case 12				'���^�{���b�N�V���h���[��
'			Case 13				'�����b�s�Č����Ώۃ��X�g
'			Case 14				'�f�e�������{�҃��X�g
'			Case 15				'�����x�`�F�b�N���X�g
		End Select

		'���R�����΍��p���O�����o��
		Call putPrivacyInfoLog("PH057", "���я��`�F�b�N���X�g �̈�����s����")

        '�h�L�������g�t�@�C���쐬�����i�I�u�W�F�N�g.���\�b�h��(����)�j
        PrintRet = objPrintCls.PrintOut(UID, _
                                       convStrSSendDate, _
                                       convStrESendDate)
        Print = PrintRet

'#### 2010.05.18 SL-UI-Y0101-220~230 MOD END ####'
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

    Redim Preserve strArrOutputCls(15)
    Redim Preserve strArrOutputClsName(15)

    strArrOutputCls(0) = "0":strArrOutputClsName(0) = "��������A���\�쐬�p"
    strArrOutputCls(1) = "1":strArrOutputClsName(1) = "�w�l�ȃR�����g�`�F�b�N���X�g"
    strArrOutputCls(2) = "2":strArrOutputClsName(2) = "���`�F�b�N���X�g"
    strArrOutputCls(3) = "3":strArrOutputClsName(3) = "���������g�`�F�b�N���X�g"
    strArrOutputCls(4) = "4":strArrOutputClsName(4) = "����X���`�F�b�N���X�g"
    strArrOutputCls(5) = "5":strArrOutputClsName(5) = "�㕔�����ǁi�݂w���j�`�F�b�N���X�g"
    strArrOutputCls(6) = "6":strArrOutputClsName(6) = "�㕔�����ǁi�������j�`�F�b�N���X�g"
    strArrOutputCls(7) = "7":strArrOutputClsName(7) = "����CT�`�F�b�N���X�g"
    strArrOutputCls(8) = "8":strArrOutputClsName(8) = "���[�w���`�F�b�N���X�g"
    strArrOutputCls(9) = "9":strArrOutputClsName(9) = "���[�����g�`�F�b�N���X�g"
    strArrOutputCls(10) = "10":strArrOutputClsName(10) = "���[�G�f�`�F�b�N���X�g"
    strArrOutputCls(11) = "11":strArrOutputClsName(11) = "�S�d�}���菊�����X�g"
    strArrOutputCls(12) = "12":strArrOutputClsName(12) = "���^�{���b�N�V���h���[��"
    strArrOutputCls(13) = "13":strArrOutputClsName(13) = "����CT�Č����Ώۃ��X�g"
    strArrOutputCls(14) = "14":strArrOutputClsName(14) = "GF�������{�҃��X�g"
    strArrOutputCls(15) = "15":strArrOutputClsName(15) = "�����x�`�F�b�N���X�g"

End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>���ѕ\�`�F�b�N���X�g</TITLE>
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
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">��</SPAN><FONT COLOR="#000000">���ѕ\�`�F�b�N���X�g(�������\�`�F�b�N�j</FONT></B></TD>
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
            <TD WIDTH="100" NOWRAP>�쐬��</TD>
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
			<TD><%= EditNumberList("endSendYear", YEARRANGE_MIN, YEARRANGE_MAX, strESendYear, True) %></TD>
			<TD>�N</TD>
			<TD><%= EditNumberList("endSendMonth", 1, 12, strESendMonth, True) %></TD>
			<TD>��</TD>
			<TD><%= EditNumberList("endSendDay", 1, 31, strESendDay, True) %></TD>
			<TD>��</TD>

        </TR>
    </TABLE>
<!--- �������ԍ� -->
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD><FONT COLOR="#ff0000">��</FONT></TD>
            <TD WIDTH="100" NOWRAP>�`�F�b�N���X�g�I��</TD>
            <TD>�F</TD>
            <TD><%= EditDropDownListFromArray("outputCls", strArrOutputCls, strArrOutputClsName , strOutputCls, NON_SELECTED_DEL) %></TD>
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