<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'      �˗��󔭑��m�F(2010.1.5) 
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
Dim objCommon           '���ʃN���X
Dim objReqSendCheck     '�˗���쐬�N���X
Dim objFree             '�ėp���A�N�Z�X�p
Dim objConsult          '��f���
Dim objJudClass         '���蕪�ރA�N�Z�X�p

'�p�����[�^
Dim strAction           '�������
Dim lngRequestNo        '�˗���R�[�h�ԍ�

Dim blnCslInfoFlg       '��f���\���t���O(True:�\��)
Dim strHtml             'HTML������
Dim Ret                 '�֐��߂�l
Dim strArrMessage       '�G���[���b�Z�[�W

Dim lngCount            '�߂�l
Dim i                   '���ޯ��

'���ɔ����m�F�ς݂̏ꍇ�A�S�Ă̔��������擾
Dim vntSeq              '�˗���ԍ��z��
Dim vntJudClassName     '�˗���t�@�C�����z��
Dim vntFileName         '�˗���t�@�C�����z��
Dim vntAddDate          '�˗���o�^�����z��
Dim vntAddUser          '�˗���o�^�Ҕz��
Dim vntReqSendDate      '�˗��󔭑����z��
Dim vntReqSendUser      '�˗��󔭑��Ҕz��

'��f���p�ϐ�
Dim strPerId            '�lID
Dim strCslDate          '��f��
Dim strCsCd             '�R�[�X�R�[�h
Dim strCsName           '�R�[�X��
Dim strLastName         '��
Dim strFirstName        '��
Dim strLastKName        '�J�i��
Dim strFirstKName       '�J�i��
Dim strBirth            '���N����
Dim strAge              '�N��
Dim strGender           '����
Dim strGenderName       '���ʖ���
Dim strDayId            '����ID
Dim strOrgName          '�c�̖���

Dim strEraBirth         '���N����(�a��)
Dim strRealAge          '���N��
Dim strJudClassName     '���蕪�ޖ�

'�o�[�R�[�h��������l�擾
Dim lngRsvNo            '�\��ԍ�
Dim lngJudClassCd       '�������ڃR�[�h
Dim lngPrtDiv           '�l������
Dim lngSeq              '�˗���ԍ�

'�폜�p�o���A���g�z��
Dim vntCRsvNo           '�\��ԍ�
Dim vntCJudClassCd      '���蕪�ރR�[�h
Dim vntCPrtDiv          '�l������
Dim vntCSeq             'SEQ

'SUBMIT������ϗp
Dim strOnSubmit
Dim vntSSendDate        '�������߂�l
'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon         = Server.CreateObject("HainsCommon.Common")
Set objReqSendCheck   = Server.CreateObject("HainsReqSendCheck.ReqSendCheck")
Set objConsult        = Server.CreateObject("HainsConsult.Consult")

'�����l�̎擾
Dim strSSendDate,strSSendYear, strSSendMonth, strSSendDay   '(�w��)�����N����

strAction    = Request("act")
lngRequestNo = Request("requestNo")

    '### �J�n�N����
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

    '�����m�F�i�V�K�j
    If strAction <> "" Then

        '�o�[�R�[�h�m�F
        If lngRequestNo = "" Then
            strArrMessage = Array("�˗���R�[�h�ԍ����w�肵�Ă�������")
            Exit Do
        End If
        If Len(lngRequestNo) <> 17 Then
            strArrMessage = Array("�˗���R�[�h�ԍ����s���ł�")
            lngRequestNo = ""
            Exit Do
        Else 
            If Not IsNumeric(lngRequestNo) Then
                strArrMessage = Array("�˗���R�[�h�ԍ����s���ł�")
                lngRequestNo = ""
                Exit Do
            End If
        End If
    
        lngRsvNo      = CLng("0" & Mid(lngRequestNo, 1, 9))
        lngJudClassCd = CLng("0" & Mid(lngRequestNo, 10, 3))
        lngPrtDiv     = CLng("0" & Mid(lngRequestNo, 13, 1))
        lngSeq        = CLng("0" & Mid(lngRequestNo, 14, 4))



        If strAction = "save" Then
            '�����f�[�^�̑��݃`�F�b�N
            lngCount = objReqSendCheck.SelectAll_SendDate(lngRsvNo, _
                                                          lngJudClassCd, _
                                                          lngPrtDiv, _
                                                          vntSeq, _
                                                          vntJudClassName, _
                                                          vntFileName, _
                                                          vntAddDate, _
                                                          vntAddUser, _
                                                          vntReqSendDate, _
                                                          vntReqSendUser _
                                                         )

                If lngCount > 0 Then

                    '���݂���Ȃ�A����ɐV�K���A�X�V���L�����Z������I��������
                    strAction = "choisemode"
                    blnCslInfoFlg = True

                Else
                    '�������X�V
                    Ret = objReqSendCheck.UpdateReqSendDate("UPD", lngRsvNo, lngJudClassCd, lngPrtDiv, lngSeq, Server.HTMLEncode(Session("USERID")), strSSendDate)

                    If Ret = INSERT_NORMAL Then
                        strAction = "saveend"
                        blnCslInfoFlg = True
                    Else
                        strAction = "saveerr"
                    End If
                End If
        End If

            '�����m�F�i�X�V�j
        If strAction = "upd" Then

                '�������X�V
            Ret = objReqSendCheck.UpdateReqSendDate("UPD", lngRsvNo, lngJudClassCd, lngPrtDiv, lngSeq, Server.HTMLEncode(Session("USERID")), strSSendDate)

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
            vntCRsvNo = Array()
            vntCJudClassCd = Array()
            vntCPrtDiv = Array()
            vntCSeq   = Array()

            Redim Preserve vntCRsvNo(0)
            Redim Preserve vntCJudClassCd(0)
            Redim Preserve vntCPrtDiv(0)
            Redim Preserve vntCSeq(0)
            vntCRsvNo(0) = lngRsvNo
            vntCJudClassCd(0) = lngJudClassCd
            vntCPrtDiv(0) = lngPrtDiv
            vntCSeq(0)   = lngSeq

            '�����m�F���폜�i�ŐV���̂ݍ폜�j
            If objReqSendCheck.DeleteReqSendDate("DEL", vntCRsvNo, vntCJudClassCd, vntCPrtDiv, vntCSeq) Then
                strAction = "clearend"
            Else
                strAction = "clearerr"
            End If

            blnCslInfoFlg = True
        End If
    End If

        '��f����\��
    If  blnCslInfoFlg = True Then

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
        
        Set objJudClass = Server.CreateObject("HainsJudClass.JudClass")
            If objJudClass.SelectJudClassName(lngJudClassCd, strJudClassName) Then
                strJudClassName = strJudClassName
            End If
        Set objJudClass = Nothing

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
<TITLE>�˗��󔭑��m�F</TITLE>

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

// �˗��󔭑�������
function executeRequestSendDate( mode ) {

    // �ʏ�X�V
    if ( mode == 1 ) {
        document.entryForm.act.value = 'save';
        document.entryForm.requestNo.value = document.entryForm.key.value;
    }

    // �㏑���X�V
    if ( mode == 2 ) {
        if( !confirm('�����̔�����������̔������ōX�V���܂��B��낵���ł����H' ) ) return;
        document.entryForm.act.value = 'upd';
        document.entryForm.submit();
    }

    // �L�����Z��
    if ( mode == 3 ) {
        if( !confirm('��ʂ��N���A���ď�����ʂ�\�����܂��B��낵���ł����H' ) ) return;
        document.entryForm.act.value = '';
        document.entryForm.key.value = '';
        document.entryForm.submit();
    }

    // �������N���A
    if ( mode == 4 ) {
        if( !confirm('�˗��󔭑������N���A���܂��B��낵���ł����H' ) ) return;
        document.entryForm.act.value = 'clear';
        document.entryForm.submit();
    }

    return;
}

//-->
</SCRIPT>
<STYLE TYPE="text/css">
<!--
td.flwtab { background-color:#ffffff }
-->
</STYLE>
</HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<BODY ONLOAD="javascript:setFocus()">
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BLOCKQUOTE>
<BASEFONT SIZE="2">
<%
    '���ɔ����������݂���ꍇ
    If strAction ="choisemode" Then
        strOnSubmit = "javascript:return false;"
    Else
        strOnSubmit = "javascript:executeRequestSendDate(1)"
    End If
%>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post" ONSUBMIT="<%= strOnSubmit %>">

    <INPUT TYPE="hidden" NAME="act"          VALUE="<%= strAction %>">
    <INPUT TYPE="hidden" NAME="requestNo"    VALUE="<%= lngRequestNo %>">

<!-- �G���[���b�Z�[�W -->
<%
    '���b�Z�[�W�̕ҏW
    If Not IsEmpty(strArrMessage) Then

        Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)

    End If
%>

    <!-- �^�C�g���̕\�� -->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="90%">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">��</SPAN><FONT COLOR="#000000">�˗��󔭑��m�F</FONT></B></TD>
        </TR>
    </TABLE>
    <BR>
    <IMG SRC="../../images/barcode.jpg" WIDTH="171" HEIGHT="172" ALIGN="left" ONCLICK="javascript:document.entryForm.key.focus()">
    <IMG SRC="../../images/spacer.gif" WIDTH="10" HEIGHT="400" ALIGN="left"><BR>
    <BR>
    <BR>

<%
    If strAction ="" Then

' ### 2016.01.26 �� ���я��ƈ˗���̋敪���ł���悤�Ƀ��b�Z�[�W�C�� STR #########################
'        strHtml = "�o�[�R�[�h��ǂݍ���ł��������B"
        strHtml = "<FONT COLOR=""#0080FF"">�˗���̃o�[�R�[�h</FONT>��ǂݍ���ł��������B"
' ### 2016.01.26 �� ���я��ƈ˗���̋敪���ł���悤�Ƀ��b�Z�[�W�C�� END #########################

    Else
        Select Case strAction
        Case "saveend"
            strHtml = "�˗��󔭑��m�F���������܂����B"
        Case "saveerr"
            strHtml = "�t�H���[�A�b�v��񂪌�����܂���B" & "�i�\��ԍ�:" & lngRsvNo & "�j"
        Case "clearend"
            strHtml = "�˗��󔭑������N���A���܂����B"
        Case "clearerr"
            strHtml = "�˗��󔭑������N���A�Ɏ��s���܂����B"
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
<%
        For i = 0 To lngCount - 1
%>
        <TR>
            <TD>��������</TD><TD><B><%= vntJudClassName(i) %></B></TD>
            <TD>�˗���ԍ�</TD><TD><B>�˗���&nbsp;_&nbsp;<%= vntSeq(i) %>��</B></TD>
        </TR>
        <TR>
            <TD>�˗��󔭑�����</TD><TD><B>&nbsp;<%=vntReqSendDate(i)%></B></TD>
            <TD>�˗��󔭑���</TD><TD><B>&nbsp;<%=vntReqSendUser(i)%></B></TD>
        </TR>
<%
        Next
%>
    </TABLE>
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="2">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
        </TR>
        <TR>
             <TD><FONT COLOR="#ff0000"><B>���݈˗���ԍ��F�˗���&nbsp;_&nbsp;<%= lngSeq %>��</B></FONT></TD>
        </TR>
        <TR>
            <TD><INPUT TYPE="BUTTON" VALUE="���������X�V" STYLE="width:150px;height:50px" ALT="" ONCLICK="javascript:executeRequestSendDate(2)"></TD>
            <TD><INPUT TYPE="BUTTON" VALUE="�L�����Z��"   STYLE="width:150px;height:50px" ALT="" ONCLICK="javascript:executeRequestSendDate(3)"></TD>
        </TR>
    </TABLE>
    <INPUT TYPE="hidden" NAME="key" VALUE="<%= lngRequestNo %>">

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
            <TD COLSPAN="7"><INPUT TYPE="text" NAME="key" SIZE="30" STYLE="ime-mode:disabled"></TD>
        </TR>
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
    </TABLE>

<%
    End If

    '��f�ҏ���\��
    If blnCslInfoFlg = True Then
%>
    <TABLE BORDER="0" CELLPADDING="3" CELLSPACING="0" WIDTH="450">

        <TR>
<%
        If strAction = "saveend" Then
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
            <TD NOWRAP>�@�����h�c�F</TD>
            <TD NOWRAP><FONT COLOR="#ff6600"><B><%= strDayId %></B></FONT></TD>
            <TD NOWRAP>�@�������ځF</TD>
            <TD NOWRAP><FONT COLOR="#ff6600"><B><%= strJudClassName %></B></FONT></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
        <TR>
            <TD NOWRAP><%= strPerId %></TD>
            <TD NOWRAP>�@<B><%= strLastName & " " & strFirstName %></B> �i<FONT SIZE="-1"><%= strLastKname & " " & strFirstKName %></FONT>�j</TD>
            <TD NOWRAP>�@<%= strEraBirth %>���@<%= strRealAge %>�΁i<%= Int(strAge) %>�΁j�@<%= IIf(strGender = "1", "�j��", "����") %></TD>
        </TR>
    </TABLE>
    <BR>

    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0" WIDTH="450">
        <TR>     
            <TD>
                <!--<A HREF="/webHains/contents/reserve/rsvMain.asp?rsvno=<%= lngRsvNo %>" TARGET="_blank">�\������Q��</A>-->
<%
        If strAction <> "clearend" Then
%>    
                <A HREF="javascript:javascript:executeRequestSendDate(4)">���݈˗��󔭑������N���A����</A>
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