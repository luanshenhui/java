<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'       �������`�F�b�N���X�g (Ver0.0.1)
'       AUTHER  : (NSC)birukawa
'-------------------------------------------------------------------------------
'       �Ǘ��ԍ��FSL-UI-Y0101-218
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
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim strMode             '������[�h
Dim vntMessage          '�ʒm���b�Z�[�W
Dim strURL              'URL

'-------------------------------------------------------------------------------
' �ŗL�錾���i�e���[�ɉ����Ă��̃Z�N�V�����ɕϐ����`���ĉ������j
'-------------------------------------------------------------------------------
'COM�I�u�W�F�N�g
Dim objCommon                               '���ʃN���X

'�p�����[�^�l
Dim strSCslYear, strSCslMonth, strSCslDay   '��f�J�n�N����
Dim strDayId                                '����ID
Dim UID                                     '���[�UID
'#### 2010.04.26 SL-UI-Y0101-218 MOD START ####'
Dim strPrintmode                            '0:���ڈ��  1:�v���r���[���
Dim strIPAddress                            '�U���p�ɂ��A������j���[�̏ꍇ�͖��ݒ�
'#### 2010.04.26 SL-UI-Y0101-218 MOD END ####'

'��Ɨp�ϐ�
Dim strSCslDate                             '�J�n��

Dim i                   '���[�v�C���f�b�N�X
Dim j                   '���[�v�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
Set objCommon       = Server.CreateObject("HainsCommon.Common")

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

'�� ����ID
    strDayId = Request("DayId")

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
    Dim aryChkString
    
    aryChkString = Array("1","2","3","4","5","6","7","8","9","0")

    '�����Ƀ`�F�b�N�������L�q
    With objCommon
'��)        .AppendArray vntArrMessage, �R�����g
        If strMode <> "" Then
            '��f���`�F�b�N
            If Not IsDate(strSCslDate) Then
                .AppendArray vntArrMessage, "�J�n���t������������܂���B"
            End If

            '����ID�`�F�b�N
            If Trim(strDayId) = "" then
                .AppendArray vntArrMessage, "����ID����͂��Ă��������B"
            End If

            For i = 1 To Len(strDayId)
                blnErrFlg = 0
                For j = 0 to UBound(aryChkString)
                    If Trim(Mid(strDayId, i, 1)) = Trim(aryChkString(j)) Then
                        blnErrFlg = 1
                        Exit For
                    End if
                Next
                If blnErrFlg = 0 Then
                    .AppendArray vntArrMessage, "����ID������������܂���B"
                    Exit For
                End If
            Next

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

    Dim Ret         '�֐��߂�l
    Dim objCommon
    Dim objPrintCls

    If Not IsArray(CheckValue()) Then

		'���R�����΍��p���O�����o��
		Call putPrivacyInfoLog("PH054", "(����������)�������`�F�b�N���X�g�̈�����s����")

'#### 2010.04.26 SL-UI-Y0101-218 MOD START ####'
'    '#### 2007/09/06 �� �������`�F�b�N�V�[�g�V�K�쐬�ɂ��ύX(CoReport �� ReportDesigner) Start ####
'       Set objCommon = Server.CreateObject("HainsCommon.Common")
'       strURL = "/webHains/contents/report_form/rd_30_prtEndoscopeCheck.asp"
'       strURL = strURL & "?p_Uid=" & UID
'       strURL = strURL & "&p_DayID=" & strDayId
'       strURL = strURL & "&p_ScslDate=" & objCommon.FormatString(CDate(strSCslDate), "yyyy/mm/dd")
'       Set objCommon = Nothing
'       Response.Redirect strURL
'       Response.End
'
'''        '�I�u�W�F�N�g�̃C���X�^���X�쐬�i�v���W�F�N�g��.�N���X���j
'''        Set objPrintCls = Server.CreateObject("HainsprtEndoscopeCheck.prtEndoscpCheck")
'''        '�h�L�������g�t�@�C���쐬�����i�I�u�W�F�N�g.���\�b�h��(����)�j
'''        Ret = objPrintCls.PrintOut(UID, _
'''                                   strSCslDate, _
'''                                   strDayId)
'''        Print = Ret
'
'    '#### 2007/09/06 �� �������`�F�b�N�V�[�g�V�K�쐬�ɂ��ύX(CoReport �� ReportDesigner) Start ####

		'�I�u�W�F�N�g�̃C���X�^���X�쐬�i�v���W�F�N�g��.�N���X���j
		Set objPrintCls = Server.CreateObject("HainsprtEndoscopeCheck2.prtEndoscpChk2")
		'�h�L�������g�t�@�C���쐬�����i�I�u�W�F�N�g.���\�b�h��(����)�j
        strPrintmode = "1"

		Ret = objPrintCls.PrintOut(UID, _
                                   strSCslDate, _
                                   strDayId, _
                                   strPrintmode, _
                                   strIPAddress)
		Print = Ret

'#### 2010.04.26 SL-UI-Y0101-218 MOD END ####'

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
<TITLE>�������`�F�b�N�V�[�g�i���ӏ��j</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--

//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.prttab { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
    <BLOCKQUOTE>

    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">���������`�F�b�N�V�[�g�i���ӏ��j</SPAN></B></TD>
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
        </TR>
    </TABLE>

    <!-- ����ID -->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
        <TR>
            <TD><FONT COLOR="#ff0000">��</FONT></TD>
            <TD WIDTH="90" NOWRAP>����ID</TD>
            <TD>�F</TD>
            <TD>
                <INPUT TYPE="text" NAME="DayId" MAXLENGTH="4" SIZE="10" VALUE="<%= strDayId %>">
            </TD>
        </TR>
    </TABLE>

                <!--- ������[�h -->
<%
    '������[�h�̏����ݒ�
    strMode = IIf(strMode = "", PRINTMODE_PREVIEW, strMode)
%>
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