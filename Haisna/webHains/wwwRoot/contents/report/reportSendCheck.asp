<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   ���я������m�F  (Ver0.2)
'	   AUTHER  : H.Ishihara@FSIT
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objReportSendDate	'���я��쐬�N���X
Dim objFree				'�ėp���A�N�Z�X�p
Dim objConsult			'��f���

'�p�����[�^
Dim strAction			'�������
Dim lngRsvNo			'�\��ԍ�

'��f���p�ϐ�
Dim strPerId			'�lID
Dim strCslDate			'��f��
Dim strCsCd				'�R�[�X�R�[�h
Dim strCsName			'�R�[�X��
Dim strLastName			'��
Dim strFirstName		'��
Dim strLastKName		'�J�i��
Dim strFirstKName		'�J�i��
Dim strBirth			'���N����
Dim strAge				'�N��
Dim strGender			'����
Dim strGenderName		'���ʖ���
Dim strDayId			'����ID
Dim strOrgName			'�c�̖���

Dim strEraBirth			'���N����(�a��)
Dim strRealAge			'���N��

Dim blnCslInfoFlg		'��f���\���t���O(True:�\��)
Dim strHtml				'HTML������
Dim Ret					'�֐��߂�l
Dim strArrMessage		'�G���[���b�Z�[�W

'���ɔ����m�F�ς݂̏ꍇ�A���̏��
Dim strSeq          	'SEQ
Dim strInsDate          '�o�^����
Dim strInsUser          '�o�^���[�U
Dim strInsUserName      '�o�^���[�U��
Dim strReportSendDate   '���я�������
Dim strChargeUser       '���я��������[�U
Dim strChargeUserName   '���я��������[�U��

Dim vntDayID			'����ID
Dim vntComeDate			'���@����

'�폜�p�o���A���g�z��
Dim vntRsvNo			'�\��ԍ�
Dim vntSeq				'SEQ

'SUBMIT������ϗp
Dim strOnSubmit

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon         = Server.CreateObject("HainsCommon.Common")
Set objReportSendDate = Server.CreateObject("HainsReportSendDate.ReportSendDate")
Set objConsult        = Server.CreateObject("HainsConsult.Consult")


'�����l�̎擾

'### 2005.08.05 �� ���я��������w�肵�ď����ł���悤�Ɉ����ǉ�
Dim strSSendDate,strSSendYear, strSSendMonth, strSSendDay   '�����N����

strAction		= Request("act")
lngRsvNo		= Request("rsvno")


'### 2005.08.05 �� ���я��������w�肵�ď����ł���悤�Ɉ����ǉ�
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
'�� �J�n�N����
    If IsEmpty(Request("strSendYear")) Then
        strSSendYear   = Year(Now())             '�����N
        strSSendMonth  = Month(Now())            '������
        strSSendDay    = Day(Now())              '������
    Else
        strSSendYear   = Request("strSendYear")   '�����N
        strSSendMonth  = Request("strSendMonth")  '������
        strSSendDay    = Request("strSendDay")    '������
    End If
    strSSendDate   = strSSendYear & "/" & strSSendMonth & "/" & strSsendDay




Do

    blnCslInfoFlg = False

    If strAction <> "" Then

        '�l�̃`�F�b�N(�\��ԍ�)
        strArrMessage = objCommon.CheckNumeric("�\��ԍ�", lngRsvNo, LENGTH_CONSULT_RSVNO, CHECK_NECESSARY)

        If strArrMessage <> "" Then
            strAction = "checkerr"
        End If

        '���͗\��ԍ��̑Ó����`�F�b�N
        If strAction <> "checkerr" Then

            '��f���̎擾
            Ret = objConsult.SelectWelComeInfo(lngRsvNo, _
                                                , _
                                                , _
                                                , _
                                                , _
                                                , _
                                                , _
                                                , _
                                                , _
                                                , _
                                                , _
                                                , _
                                                , _
                                                , _
                                                , _
                                                , _
                                                , _
                                                , _
                                                , _
                                                , _
                                                vntDayID, _
                                                vntComeDate)
    
            '��f��񂪑��݂��Ȃ��ꍇ�̓G���[�Ƃ���
            If Ret = False Then
                Err.Raise 1000, , "��f��񂪑��݂��܂���B�i�\��ԍ�= " & lngRsvNo & " )"
            End If
    
            '����t�̏ꍇ�̓G���[�Ƃ���
            If Trim(vntDayID) = "" Then
                Err.Raise 1000, , "�w�肳�ꂽ�\��ԍ��̎�f���͖���t�ł��B�i�\��ԍ�= " & lngRsvNo & " )"
            End If
    
            '�����@�̏ꍇ�̓G���[�Ƃ���
            If Trim(vntComeDate) = "" Then
                Err.Raise 1000, , "�w�肳�ꂽ�\��ԍ��̎�f���͖����@�ł��B�i�\��ԍ�= " & lngRsvNo & " )"
            End If

        End If

        '�����m�F�i�V�K�j
        If strAction = "save" Then

            '�����f�[�^�̑��݃`�F�b�N
            If objReportSendDate.SelectConsult_ReptSendLast(lngRsvNo, _
                                                            strSeq, _
                                                            strInsDate, _
                                                            strInsUser, _
                                                            strInsUserName, _
                                                            strReportSendDate, _
                                                            strChargeUser, _
                                                            strChargeUserName) Then

                '���݂���Ȃ�A����ɐV�K���A�X�V���L�����Z������I��������
                strAction = "choisemode"
                blnCslInfoFlg = True

            Else

                '���я��������X�V
'### 2005.08.05 �� ���я��������w�肵�ď����ł���悤�Ɉ����ǉ�
'               Ret = objReportSendDate.UpdateReportSendDate("INS", lngRsvNo, Server.HTMLEncode(Session("USERID")))
                Ret = objReportSendDate.UpdateReportSendDate("INS", lngRsvNo, Server.HTMLEncode(Session("USERID")), strSSendDate)

                If Ret = INSERT_NORMAL Then
                    strAction = "saveend"
                    blnCslInfoFlg = True
                Else
                    strAction = "saveerr"
                End If

            End If

        End If

        '�����m�F�i�ǉ��}�����[�h�j
        If strAction = "forceins" Then

            '���я��������ǉ�
'### 2005.08.05 �� ���я��������w�肵�ď����ł���悤�Ɉ����ǉ�
'            Ret = objReportSendDate.UpdateReportSendDate("INS", lngRsvNo, Server.HTMLEncode(Session("USERID")))
            Ret = objReportSendDate.UpdateReportSendDate("INS", lngRsvNo, Server.HTMLEncode(Session("USERID")),strSSendDate)
            If Ret = INSERT_NORMAL Then
                strAction = "saveend"
                blnCslInfoFlg = True
            Else
                strAction = "saveerr"
            End If

        End If

        '�����m�F�i�X�V���[�h�j
        If strAction = "upd" Then

            '���я��������X�V
'### 2005.08.05 �� ���я��������w�肵�ď����ł���悤�Ɉ����ǉ�
'            Ret = objReportSendDate.UpdateReportSendDate("UPD", lngRsvNo, Server.HTMLEncode(Session("USERID")))
            Ret = objReportSendDate.UpdateReportSendDate("UPD", lngRsvNo, Server.HTMLEncode(Session("USERID")),strSSendDate)

            If Ret = INSERT_NORMAL Then
                strAction = "saveend"
                blnCslInfoFlg = True
            Else
                strAction = "saveerr"
            End If

        End If

        '�����m�F���폜
        If strAction = "clear" Then

            '�֐��p�ɔz��
            vntRsvNo = Array()
            vntSeq   = Array()
            Redim Preserve vntRsvNo(0)
            Redim Preserve vntSeq(0)
            vntRsvNo(0) = lngRsvNo
            vntSeq(0)   = 0

            '�����m�F���폜�i�ŐV���̂ݍ폜���[�h�j
            If objReportSendDate.DeleteConsult_ReptSend("MAX", vntRsvNo, vntSeq) Then
                strAction = "clearend"
            Else
                strAction = "clearerr"
            End If

            blnCslInfoFlg = True

        End If

    End If

    '��f����\������H
    If 	blnCslInfoFlg = True Then

        '��f��񌟍�
        Ret = objConsult.SelectConsult(lngRsvNo, _
                                        , _
                                        strCslDate,    _
                                        strPerId,      _
                                        strCsCd,       _
                                        strCsName,     _
                                        , , _
                                        strOrgName,    _
                                        , , _
                                        strAge,        _
                                        , , , , , , , , , , , , _
                                        strDayId,   _
                                        , , 0, , , , , , , , , , , , , , , _
                                        strLastName,   _
                                        strFirstName,  _
                                        strLastKName,  _
                                        strFirstKName, _
                                        strBirth,      _
                                        strGender _
                                        )

        '��f��񂪑��݂��Ȃ��ꍇ�̓G���[�Ƃ���
        If Ret = False Then
            Err.Raise 1000, , "��f��񂪑��݂��܂���B�i�\��ԍ�= " & lngRsvNo & " )"
        End If

        '���N����(����{�a��)�̕ҏW
        strEraBirth = objCommon.FormatString(CDate(strBirth), "ge�iyyyy�j.m.d")

        '���N��̌v�Z
        If strBirth <> "" Then
            Set objFree = Server.CreateObject("HainsFree.Free")
            strRealAge = objFree.CalcAge(strBirth)
            Set objFree = Nothing
        Else
            strRealAge = ""
        End If

        '�����_�ȉ��̐؂�̂�
        If IsNumeric(strRealAge) Then
            strRealAge = CStr(Int(strRealAge))
        End If
    End If

    Exit Do
Loop

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>���я������m�F</TITLE>

<SCRIPT TYPE="text/javascript">
<!--
// �t�H�[�J�X�Z�b�g
function setFocus() {
<%
    If strAction ="choisemode" Then
    '���ɔ����������݂���ꍇ
%>
    return;
<%
    Else
%>
    document.entryForm.key.focus();
    document.entryForm.key.value = '';
    document.entryForm.act.value = '';
<%
    End If
%>
}

// ���я�����������
function executeReportSendDate( mode ) {

    // �ʏ�X�V
    if ( mode == 1 ) {
        document.entryForm.act.value = 'save';
        document.entryForm.rsvno.value = document.entryForm.key.value;
    }

    // �ǉ��}��
    if ( mode == 2 ) {
        if( !confirm('����̔�������V�����ǉ����܂��B��낵���ł����H' ) ) return;
        document.entryForm.act.value = 'forceins';
        document.entryForm.submit();
    }

    // �㏑���X�V
    if ( mode == 3 ) {
        if( !confirm('�����̔�����������̔������ŏ㏑�����܂��B��낵���ł����H' ) ) return;
        document.entryForm.act.value = 'upd';
        document.entryForm.submit();
    }

    // �L�����Z��
    if ( mode == 4 ) {
        if( !confirm('��ʂ��N���A���ď�����ʂ�\�����܂��B��낵���ł����H' ) ) return;
        document.entryForm.act.value = '';
        document.entryForm.key.value = '';
        document.entryForm.submit();
    }

    // �������N���A
    if ( mode == 5 ) {
        if( !confirm('���я����������N���A���܂��B��낵���ł����H' ) ) return;
        document.entryForm.act.value = 'clear';
        document.entryForm.submit();
    }

    return;
}

//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<STYLE TYPE="text/css">
td.mnttab { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONLOAD="javascript:setFocus()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BLOCKQUOTE>
<BASEFONT SIZE="2">
<%
    '���ɔ����������݂���ꍇ
    If strAction ="choisemode" Then
        strOnSubmit = "javascript:return false;"
    Else
        strOnSubmit = "javascript:executeReportSendDate(1)"
    End If
%>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post" ONSUBMIT="<%= strOnSubmit %>">

    <INPUT TYPE="hidden" NAME="act"   VALUE="<%= strAction %>">
    <INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">

    <!-- �^�C�g���̕\�� -->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="90%">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">��</SPAN><FONT COLOR="#000000">���я������m�F</FONT></B></TD>
        </TR>
    </TABLE>
    <BR>
    <IMG SRC="../../images/barcode.jpg" WIDTH="171" HEIGHT="172" ALIGN="left" ONCLICK="javascript:document.entryForm.key.focus()">
    <IMG SRC="../../images/spacer.gif" WIDTH="10" HEIGHT="320" ALIGN="left"><BR>
    <BR>
    <BR>
<%
    If strAction ="" Then
' ### 2016.01.26 �� ���я��ƈ˗���̋敪���ł���悤�Ƀ��b�Z�[�W�C�� STR #########################
'        strHtml = "�o�[�R�[�h��ǂݍ���ł��������B"
        strHtml = "<FONT COLOR=""#ff6600"">���я��̃o�[�R�[�h</FONT>��ǂݍ���ł��������B"
' ### 2016.01.26 �� ���я��ƈ˗���̋敪���ł���悤�Ƀ��b�Z�[�W�C�� END #########################
    Else
        Select Case strAction
        Case "saveend"
            strHtml = "���я������m�F���������܂����B"
        Case "saveerr"
            strHtml = "��f�҂�������܂���B" & "�iBarCode:" & lngRsvNo & "�j"
        Case "clearend"
            strHtml = "���я����������N���A���܂����B"
        Case "clearerr"
            strHtml = "���я����������N���A�Ɏ��s���܂����B"
        Case "checkerr"
            If Not IsEmpty(strArrMessage) Then
                '�G���[���b�Z�[�W��ҏW
                Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
            End If
        Case "choisemode"
            strHtml = "<FONT COLOR=""RED"">���ɔ����m�F�ς݂ł��B������I�����Ă��������B</FONT>"
        End Select
    End If
%>
    <FONT SIZE="6"><%= strHtml %></FONT>


<%
    If strAction ="choisemode" Then
    '���ɔ����������݂���ꍇ

%>

    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="2">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
        </TR>
        <TR>
            <TD>�ŐV�o�^�ԍ�</TD><TD><B><%= strSeq %></B></TD>
            <TD>�����m�F����</TD><TD><B><%= strReportSendDate %></B></TD>
            <TD>�����m�F�S����</TD><TD><B><%= strChargeUserName %></B></TD>
        </TR>
        <TR>
            <TD></TD><TD></TD>
            <TD><FONT COLOR="#999999">�o�^����</FONT></TD><TD><FONT COLOR="#999999"><%= strInsDate %></FONT></TD>
            <TD><FONT COLOR="#999999">�o�^�S����</FONT></TD><TD><FONT COLOR="#999999"><%= strInsUserName %></FONT></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="2">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
        </TR>
        <TR>
            <TD><INPUT TYPE="BUTTON" VALUE="�V������������ǉ�" STYLE="width:150px;height:50px" ALT="" ONCLICK="javascript:executeReportSendDate(2)"></TD>
            <TD><INPUT TYPE="BUTTON" VALUE="�����̔��������X�V" STYLE="width:150px;height:50px" ALT="" ONCLICK="javascript:executeReportSendDate(3)"></TD>
            <TD><INPUT TYPE="BUTTON" VALUE="�L�����Z��"         STYLE="width:150px;height:50px" ALT="" ONCLICK="javascript:executeReportSendDate(4)"></TD>
        </TR>
    </TABLE>
    <INPUT TYPE="hidden" NAME="key" VALUE="<%= lngRsvNo %>">

    <INPUT TYPE="hidden" NAME="strSendYear" VALUE="<%= strSSendYear %>">
    <INPUT TYPE="hidden" NAME="strSendMonth" VALUE="<%= strSSendMonth %>">
    <INPUT TYPE="hidden" NAME="strSendDay" VALUE="<%= strSSendDay %>">
<%
    Else
%>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
        <TR>
            <TD COLSPAN="7"><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
        </TR>
        <TR>
            <TD NOWRAP>BarCode�F</TD>
<%' ### 2016.01.26 �� �t�H���[�A�b�v�˗���̃o�[�R�[�h�ȂǂŔ����������o���Ȃ��悤�C�� STR #########################%>
            <!--TD COLSPAN="7"><INPUT TYPE="text" NAME="key" SIZE="30" MAXLENGTH="9" STYLE="ime-mode:disabled"></TD-->
            <TD COLSPAN="7"><INPUT TYPE="text" NAME="key" SIZE="30" MAXLENGTH="18" STYLE="ime-mode:disabled"></TD>
<%' ### 2016.01.26 �� �t�H���[�A�b�v�˗���̃o�[�R�[�h�ȂǂŔ����������o���Ȃ��悤�C�� END #########################%>
        </TR>
<!-- ### 2005.08.05 �� ���я��������w�肵�ď����ł���悤�Ɉ����ǉ� -->
        <TR><TD COLSPAN="7">&nbsp;</TD></TR>
        <TR>
            <TD NOWRAP>�������F</TD>
            <TD><A HREF="javascript:calGuide_showGuideCalendar('strSendYear', 'strSendMonth', 'strSendDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
            <TD><%= EditNumberList("strSendYear", YEARRANGE_MIN, YEARRANGE_MAX, strSSendYear, False) %></TD>
            <TD>�N</TD>
            <TD><%= EditNumberList("strSendMonth", 1, 12, strSSendMonth, False) %></TD>
            <TD>��</TD>
            <TD><%= EditNumberList("strSendDay", 1, 31, strSSendDay, False) %></TD>
            <TD>��</TD>
            <INPUT TYPE="hidden" NAME="strSSendDate" VALUE="<%= strSSendDate %>">
        </TR>
        <TR><TD COLSPAN="7">&nbsp;</TD></TR>
<!--================================================================-->
    </TABLE>
<%
    End If
%>

<%
    '��f�ҏ���\��
    If blnCslInfoFlg = True Then
%>
    <TABLE BORDER="0" CELLPADDING="3" CELLSPACING="0" WIDTH="450">
        <TR>
<%
        If strAction = "saveend" Then
'### 2005.08.05 �� ���я��������w�肵�ď����ł���悤�Ɉ����ǉ�
'            strHtml = objCommon.FormatString(Now(), "yyyy/mm/dd hh:mmam/pm") & "�@�����m�F����"
            strHtml = strSSendDate & " " & objCommon.FormatString(Now(), "hh:mmam/pm") & "�@�����m�F����"
        Else
            strHtml = "&nbsp;"
        End If
%>
            <TD NOWRAP><B><FONT COLOR="#ff0000"><%= strHtml %></FONT></B></TD>
        </TR>
    </TABLE>
    <BR>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
        <TR>
            <TD NOWRAP>��f���F</TD>
            <TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCslDate %></B></FONT></TD>
            <TD NOWRAP>�@�R�[�X�F</TD>
            <TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCsName %></B></FONT></TD>
            <TD NOWRAP>�@�����h�c�F</TD>
            <TD NOWRAP><FONT COLOR="#ff6600"><B><%= strDayId %></B></FONT></TD>
            <TD NOWRAP>�@�c�́F</TD>
            <TD NOWRAP><%= strOrgName %></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
        <TR>
            <TD NOWRAP><%= strPerId %></TD>
            <TD NOWRAP>�@<B><%= strLastName & " " & strFirstName %></B> �i<FONT SIZE="-1"><%= strLastKname & "�@" & strFirstKName %></FONT>�j</TD>
            <TD NOWRAP>�@<%= strEraBirth %>���@<%= strRealAge %>�΁i<%= Int(strAge) %>�΁j�@<%= IIf(strGender = "1", "�j��", "����") %></TD>
        </TR>
    </TABLE>
    <BR>
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0" WIDTH="450">
        <TR>
            <TD>
                <A HREF="/webHains/contents/reserve/rsvMain.asp?rsvno=<%= lngRsvNo %>" TARGET="_blank">�\������Q��</A>�@�@
<%
        If strAction <> "clearend" Then
%>
                <A HREF="javascript:javascript:executeReportSendDate(5)">���̎�f�҂̐��я����������N���A����</A>
<%
        End If
%>
            </TD>
        </TR>
    </TABLE>
<%
    End If
%>
</FORM>
</BLOCKQUOTE>
</BODY>
</HTML>
