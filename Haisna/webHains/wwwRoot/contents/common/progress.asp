<%@ LANGUAGE="VBScript" %>
<%
'########################################
'�Ǘ��ԍ��FSL-HS-Y0101-004
'�C����  �F2010.09.15
'�S����  �FFJTH)KOMURO
'�C�����e�F�A�g�c�[���G���[���@�����ύX
'########################################
'-----------------------------------------------------------------------------
'        ��f�i���� (Ver0.0.1)
'        AUTHER  : Sogawa Satomi@takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/EditNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/EditPageNavi.inc" -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon               '���ʃN���X
Dim objConsult              '��f���A�N�Z�X�p
Dim objCourse               '�R�[�X���A�N�Z�X�p
Dim objJudgement            '������A�N�Z�X�p
Dim objProgress             '�i�����A�N�Z�X�p
Dim objSchedule             '�X�P�W���[�����A�N�Z�X�p

'�O��ʂ��瑗�M�����p�����[�^�l
Dim strActMode              '���샂�[�h
Dim lngCslYear              '��f��(�N)
Dim lngCslMonth             '��f��(��)
Dim lngCslDay               '��f��(��)
Dim strKeyCsCd              '�R�[�X
Dim strMode                 '�\�����[�h
Dim strRsvNo                '�\��ԍ�
Dim lngStartPos             '�����J�n�ʒu
Dim strRsvGrpCd             '�\��Q�R�[�h

'�\�����[�h
Dim vntArrCd(1)             '�\�����[�h
Dim vntArrName(1)           '�\�����[�h�̖���

'�i���Ǘ����ޏ��
Dim strProgressCd           '�i�����ރR�[�h
Dim strProgressSName        '�i�����ޗ���
Dim lngProgressCount        '�i�����ސ�

'��f���
Dim strArrRsvNo             '�\��ԍ�
Dim strArrCancelFlg         '�L�����Z���t���O
Dim strArrCslDate           '��f��
Dim strArrPerId             '�l�h�c
Dim strArrDayId             '�����h�c
Dim strArrWebColor          'web�J���[
Dim strArrCsCd              '�R�[�X�R�[�h
Dim strArrCsName            '�R�[�X��
Dim strArrLastName          '��
Dim strArrFirstName         '��
Dim strArrGender            '����
Dim strArrBirth             '���N����
Dim strArrAge               '�N��
Dim strArrEntriedJud        '������͏��
Dim strArrEntriedJudManual  '������͏��(�蓮�j
Dim strArrRsvGrpName        '�\��Q����
'## 2016.08.12 �� �������菈�����{�L���ǉ� STR ##
Dim strArrMensetsuState     '�������菈�����{�L���i�����ς݁F�\�A�������F�s�\�j
'## 2016.08.12 �� �������菈�����{�L���ǉ� END ##

Dim lngCount                '���R�[�h����

'�i����
Dim strRslProgressCd        '�i�����ރR�[�h
Dim strRslStatus            '���͏��("2":���͊����A"1":�����́A"0":�˗��Ȃ�)
Dim lngRslProgressCount     '���R�[�h����

Dim dtmCslDate              '��f��
Dim lngGetCount             '�擾����
Dim strPageMaxLIne          '�P�y�[�W�\���s��
Dim strMessage              '�G���[���b�Z�[�W
Dim strMessage2             '�G���[���b�Z�[�W
Dim lngFoundIndex           '�������ꂽ�C���f�b�N�X
Dim strURL                  'URL������
Dim Ret                     '�֐��߂�l
Dim i, j, k                 '�C���f�b�N�X

'�\��Q���
Dim strAllRsvGrpCd          '�\��Q�R�[�h
Dim strAllRsvGrpName        '�\��Q����
Dim lngRsvGrpCount          '�\��Q��

Dim strWkRsvGrpCd           '�\��Q�R�[�h

'### 2004/06/04 Added by Ishihara@FSIT ����i���Ǘ��Ɋ��S�����̓��[�h�ǉ�
'����i���Ǘ��}�[�N
Dim strJudgementMark
Dim strJudgementMarkManual
'## 2016.08.12 �� �������菈�����{�L���ǉ� STR ##
Dim strMensetsuStateColor   '�������菈�����{�L���F�w��i�����ς݁F�\�A�������F�s�\�j
'## 2016.08.12 �� �������菈�����{�L���ǉ� END ##

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon   = Server.CreateObject("HainsCommon.Common")
Set objConsult  = Server.CreateObject("HainsConsult.Consult")
Set objCourse   = Server.CreateObject("HainsCourse.Course")
Set objProgress = Server.CreateObject("HainsProgress.Progress")

'�����l�̎擾
strActMode  = Request("actMode")
lngCslYear  = CLng("0" & Request("syear"))
lngCslMonth = CLng("0" & Request("smonth"))
lngCslDay   = CLng("0" & Request("sday"))
strKeyCsCd  = Request("course")
strMode     = Request("mode")
strRsvNo    = Request("rsvNo")
lngStartPos = CLng("0" & Request("startPos"))
strRsvGrpCd = Request("rsvGrpCd")

'�����J�n�ʒu���w�莞�͐擪���猟������
lngStartPos = IIf(lngStartPos = 0, 1, lngStartPos)

'�\���`����z��ɃZ�b�g
vntArrCd(0)   = "1"
vntArrCd(1)   = "2"
vntArrName(0) = "�����������݂����f�҂̂�"
vntArrName(1) = "�S�Ċ������Ă����f�҂̂�"

'��f���̏����l�ݒ�
If lngCslYear = 0 and lngCslMonth = 0  and lngCslDay = 0 Then
    lngCslYear  = Year(Now)
    lngCslMonth = Month(Now)
    lngCslDay   = Day(Now)
End If

'��f�i���󋵕\���s���i�f�t�H���g�l�j���擾
strPageMaxLine = objCommon.SelectProgressPageMaxLine

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")

'���ׂĂ̗\��Q��ǂݍ���
lngRsvGrpCount = objSchedule.SelectRsvGrpList(0, strAllRsvGrpCd, strAllRsvGrpName)

Set objSchedule = Nothing

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do

    '���샂�[�h���w�莞�͉������Ȃ�
    If strActMode = "" Then
        Exit Do
    End If

    '�\��ԍ������͂��ꂽ�ꍇ�A���̏����͎g�p���Ȃ�
    If strRsvNo <> "" Then

        '���l�`�F�b�N
        strMessage2 = objCommon.CheckNumeric("�\��ԍ�", strRsvNo, LENGTH_CONSULT_RSVNO)
        If strMessage2 <> "" Then
            strMessage = strMessage2
            Exit Do
        End If

        '�擪���̃[������菜��
        strRsvNo = CStr(CLng(strRsvNo))

        '��f���ǂݍ���
        Ret = objConsult.SelectConsult( _
                  strRsvNo, _
                  strArrCancelFlg, strArrCslDate, strArrPerId, _
                  strArrCsCd, strArrCsName , , , , , , _
                  strArrAge , , , , , , , , , , , , , _
                  strArrDayId, , , , , , , , , , , , , , , , , , _
                  strArrLastName, strArrFirstName, , , _
                  strArrBirth, strArrGender, , , , , , strWkRsvGrpCd _
              )

        '��f��񂪑��݂��Ȃ��ꍇ
        If Ret = False Then
            strMessage = "�w�肳�ꂽ�\��ԍ��̎�f���͑��݂��܂���B"
            Exit Do
        End If

        For i = 0 To lngRsvGrpCount - 1
            If strAllRsvGrpCd(i) = strWkRsvGrpCd Then
                strArrRsvGrpName = strAllRsvGrpName(i)
                Exit For
            End If
        Next

        strMessage2 = "����=" & Trim(strArrLastName & "�@" & strArrFirstName) & "�i" & strArrPerId & "�j�A�R�[�X=" & strArrCsName & "�i" & strArrCsCd & "�j"

        '�L�����Z������Ă���ꍇ
        If CLng(strArrCancelFlg) <> CONSULT_USED Then
            strMessage = "�w�肳�ꂽ�\��ԍ��̎�f���̓L�����Z������Ă��܂��B " & strMessage2
            Exit Do
        End If

        '����t�̏ꍇ
        If strArrDayId = "" Then
            strMessage = "�w�肳�ꂽ�\��ԍ��̎�f���͎�t����Ă��܂���B " & strMessage2
            Exit Do
        End If

        '�R�[�X�e�[�u������web�J���[���擾
        objCourse.SelectCourse strArrCsCd, , , , , , strArrWebColor

        '������͏�Ԃ��擾
        Set objJudgement = Server.CreateObject("HainsJudgement.Judgement")

        '### �蓮���荀�ڂƎ������荀�ڂ𕪂��ĕ\�����邽�ߏC�� STR ##############
        'objJudgement.SelectJudgementStatus strRsvNo, strArrEntriedJud
        objJudgement.SelectJudgementStatusAuto strRsvNo, strArrEntriedJud
        objJudgement.SelectJudgementStatusManual strRsvNo, strArrEntriedJudManual
        '### �蓮���荀�ڂƎ������荀�ڂ𕪂��ĕ\�����邽�ߏC�� END ##############

        '��f���̕ҏW
        dtmCslDate = CDate(strArrCslDate)

        '��f���w��Ƌ��ʂ̕ҏW���W�b�N���g�p���邽�߁A���炩���ߔz��ɕϊ�
        strArrRsvNo      = Array(strRsvNo)
        strArrDayId      = Array(strArrDayId)
        strArrWebColor   = Array(strArrWebColor)
        strArrCsName     = Array(strArrCsName)
        strArrRsvGrpName = Array(strArrRsvGrpName)
        strArrLastName   = Array(strArrLastName)
        strArrFirstName  = Array(strArrFirstName)
        strArrGender     = Array(strArrGender)
        strArrBirth      = Array(strArrBirth)
        strArrAge        = Array(strArrAge)
        strArrEntriedJud = Array(strArrEntriedJud)
        strArrEntriedJudManual = Array(strArrEntriedJudManual)
        strArrMensetsuState = Array(strArrMensetsuState)

    '�\��ԍ������͎��͎�f���w��
    Else

        '���t�`�F�b�N
        If Not IsDate(lngCslYear & "/" & lngCslMonth & "/" & lngCslDay) Then
            strMessage = "��f���̓��͌`��������������܂���B"
            Exit Do
        End If

    End If

    '�S�Ă̐i�����ޏ����擾����
    lngProgressCount = objProgress.SelectProgressList(strProgressCd, , strProgressSName)
    If lngProgressCount <= 0 Then
        strMessage = "�i�����ޏ�񂪑��݂��܂���B"
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
<TITLE>��f�i����</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<style>
table.progresstb td {
    border-bottom: 1px solid #ccc;
    padding: 2px 3px 2px;
    border-right: 1px solid #fff;
}

p.progress-cap {
    margin: 2px 0 4px 2px;
    font-size: 12px;
    color: #666;
}
</style>
</HEAD>
<BODY>
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
    <BLOCKQUOTE>

    <INPUT TYPE="hidden" NAME="actMode" VALUE="select">

    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">��f�i����</FONT></B></TD>
        </TR>
    </TABLE>
<%
    '�G���[���b�Z�[�W�̕ҏW
    Call EditMessage(strMessage, MESSAGETYPE_WARNING)
%>
    <BR>

    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
        <TR>
            <TD>��f��</TD>
            <TD>�F</TD>
            <TD>
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
                    <TR>
                        <TD><A HREF="javascript:calGuide_showGuideCalendar('syear', 'smonth', 'sday')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
                        <TD><%= EditNumberList("syear", YEARRANGE_MIN, YEARRANGE_MAX, lngCslYear, False) %></TD>
                        <TD>�N</TD>
                        <TD><%= EditNumberList("smonth", 1, 12, lngCslMonth, False) %></TD>
                        <TD>��</TD>
                        <TD><%= EditNumberList("sday", 1, 31, lngCslDay, False) %></TD>
                        <TD>��</TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD>�R�[�X</TD>
            <TD>�F</TD>
            <TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "course", strKeyCsCd, SELECTED_ALL, False) %></TD>
            <TD NOWRAP>�\���`��</TD>
            <TD>�F</TD>
            <TD><%= EditDropDownListFromArray("mode", vntArrCd, vntArrName, strMode, SELECTED_ALL) %></TD>
        </TR>
        <TR>
            <TD NOWRAP>�\��Q</TD>
            <TD>�F</TD>
            <TD><%= EditDropDownListFromArray("rsvGrpCd", strAllRsvGrpCd, strAllRsvGrpName, strRsvGrpCd, SELECTED_ALL) %></TD>
            <TD NOWRAP>�\��ԍ�</TD>
            <TD>�F</TD>
            <TD><INPUT TYPE="text" NAME="rsvNo" SIZE="11" MAXLENGTH="<%= LENGTH_CONSULT_RSVNO %>" VALUE="<%= strRsvNo %>"></TD>
            <TD ROWSPAN="5" VALIGN="bottom"><INPUT TYPE="image" SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="�\��"></A></TD>
        </TR>
    </TABLE>

    <BR>
<%
    '��f�҈ꗗ�̕ҏW
    Do
        '���샂�[�h���w�莞�͉������Ȃ�
        If strActMode = "" Then
            Exit Do
        End If

        '�G���[���͉������Ȃ�
        If strMessage <> "" Then
            Exit Do
        End If

        '�\��ԍ������͂���Ă��Ȃ��ꍇ
        If strRsvNo = "" Then

            '��f���̐ݒ�
            dtmCslDate = CDate(lngCslYear & "/" & lngCslMonth & "/" & lngCslDay)

            '�擾�����̐ݒ�
            lngGetCount = 0
            If IsNumeric(strPageMaxLine) Then
                lngGetCount = CLng(strPageMaxLine)
            End If

            '���������𖞂������R�[�h�������擾
            'lngCount = objConsult.SelectConsultList(dtmCslDate, 0, strKeyCsCd, , , , lngStartPos, lngGetCount, , , , , strMode, strArrRsvNo, strArrDayId, strArrWebColor, strArrCsName, , strArrLastName, strArrFirstName, , , strArrGender, strArrBirth, , strArrAge, , , , , , strArrEntriedJud, , , strRsvGrpCd, strArrRsvGrpName)
'## 2016.08.12 �� �������菈�����{�L���ǉ� STR ##
'            lngCount = objConsult.SelectConsultListProgress(dtmCslDate, 0, strKeyCsCd, , , , lngStartPos, lngGetCount, , , , , strMode, strArrRsvNo, strArrDayId, strArrWebColor, strArrCsName, , strArrLastName, strArrFirstName, , , strArrGender, strArrBirth, , strArrAge, , , , , , strArrEntriedJud, strArrEntriedJudManual, , , strRsvGrpCd, strArrRsvGrpName)
            lngCount = objConsult.SelectConsultListProgress(dtmCslDate, 0, strKeyCsCd, , , , lngStartPos, lngGetCount, , , , , strMode, strArrRsvNo, strArrDayId, strArrWebColor, strArrCsName, , strArrLastName, strArrFirstName, , , strArrGender, strArrBirth, , strArrAge, , , , , , strArrEntriedJud, strArrEntriedJudManual, , , strRsvGrpCd, strArrRsvGrpName, strArrMensetsuState)
'## 2016.08.12 �� �������菈�����{�L���ǉ� END ##

%>
            �u<FONT COLOR="#ff6600"><B><%= lngCslYear %>�N<%= lngCslMonth %>��<%= lngCslDay %>��</B></FONT>�v�̎�f�҈ꗗ��\�����Ă��܂��B<BR>
            ��f�Ґ��� <FONT COLOR="#FF6600"><B><%= lngCount %></B></FONT>�l�ł��B<BR><BR>
<%
        End If

        '## 2005.3.24 ADD ST FJTH)C.M

        Dim objErrLog           '�G���[���O���A�N�Z�X�p
        Dim lngErrLog           '�G���[���O�X�e�[�^�X
        Dim vntFileName         '�G���[���O�t�@�C����
        Dim vntErrDate          '�G���[���O�X�V����
        
        '�A�g�G���[���O�����擾
        Set objErrLog = Server.CreateObject("HainsErrLog.ErrLog")
        lngErrLog = objErrLog.SelectErrLog( vntFileName, vntErrDate )

        If lngErrLog = -3 Then
            strMessage = "�ėp�}�X�^�ݒ�m�F�BERRFILE��񂪂���܂���I"
        End If

        If lngErrLog = -2 Then
            strMessage = "���L�t�H���_��������܂���I"
        End If
        
        '�G���[���b�Z�[�W�̕ҏW
        Call EditMessage(strMessage, MESSAGETYPE_WARNING)
        
        If lngErrLog = 1 Then
            If vntFileName <> "" Then
%>
                <table width="600" border="0" cellspacing="2" cellpadding="0">
<%
                    With Response
                        .Write "<tr>"
                        .Write "<td><IMG SRC=/webHains/images/ico_w.gif WIDTH=16 HEIGHT=16 ALT=></td>"
'#### 2010.09.15 SL-HS-Y0101-004 MOD START ####
'                        .Write "<td><font color=red><b>�G���[���������Ă��܂��I(RayPax�A�g) �V�X�e���S���֘A�����ĉ������B</b></font></td>"
                        .Write "<td><font color=red><b>�G���[���������Ă��܂��I(���͘A�g) �V�X�e���S���֘A�����ĉ������B</b></font></td>"
'#### 2010.09.15 SL-HS-Y0101-004 MOD END ####
                        .Write "<td>�ŏI�X�V�����F" & vntErrDate & "</td>"
                        .Write "</tr>"
                    End With
%>
                </table>
                <BR>
<%
            End If
        End If

        '## 2005.3.24 ADD ED

        '### 2013/11/21 Added by ishihara@flip-logic.com �A�g���O�Ď��p�t�@�C�������m�����ꍇ�A�x�����b�Z�[�W���o��
        lngErrLog = ""
        strMessage = ""

        lngErrLog = objErrLog.SelectErrLog( vntFileName, vntErrDate, "ERRFILE2" )
        Response.Write "<!-- SendOrder.log�Ď�File Status=" & lngErrLog & " vntFileName=" & vntFileName & "-->"

        If lngErrLog = 1 And vntFileName <> "" Then
            lngErrLog = -9
        End iF
        Select Case lngErrLog
            Case -2
            strMessage = "SendOrder.log�̋��L�t�H���_��������܂���"
            Case -9
            'strMessage = "�A�g�T�[�o��COM+�����t���b�V�����Ă��������B" 
            strMessage = "�A�g�T�[�oCOM+�̃��t���b�V�����K�v�ł��̂ŃV�X�e���S���֘A�����ĉ������B"
        End Select

        If strMessage <> "" Then
            '�G���[���b�Z�[�W�̕ҏW
            Call EditMessage(strMessage, MESSAGETYPE_WARNING)
        End If
        '### 2013/11/21 Added End


        '�Ώۃf�[�^�����݂��Ȃ��ꍇ�͕ҏW�𔲂���
        If IsEmpty(strArrRsvNo) Then
            Exit Do
        End If
%>
<p class="progress-cap">���F��������&nbsp;&nbsp;���F�ꕔ�����͂���&nbsp;&nbsp;���F������&nbsp;&nbsp;�󔒁F�˗��Ȃ� <FONT COLOR="#999999">�i��f�i�������N���b�N����ƑΏێ�f���̌��ʓ��͉�ʂɃW�����v���܂��j</p>
<p class="progress-cap"><IMG SRC="/webHains/images/check.gif" WIDTH="20" HEIGHT="20" ALT="�������菈�����{">&nbsp;�F&nbsp;�������菈���ɂ�锻�茋�ʓo�^����i�������菈�����{�ς݁j</p>
        <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" class="progresstb">
            <TR BGCOLOR="#cccccc">
                <!--���X�g�ɓ���ID�A�����A���ʁA�N�����\������悤�ɕύX-->
                <!--TD NOWRAP>��f��</TD-->
                <TD NOWRAP>�����h�c</TD>
                <!--TD NOWRAP>��f�R�[�X</TD-->
                <!--TD NOWRAP>�\��Q</TD-->
                <TD NOWRAP>����</TD>
                <TD NOWRAP>����</TD>
                <!--TD NOWRAP>���N����</TD-->
                <TD NOWRAP>�N��</TD>
                <TD WIDTH="22" ALIGN="center">�蔻</TD>
                <TD WIDTH="22" ALIGN="center">����</TD>
                <TD WIDTH="22" ALIGN="center" colspan="2">����</TD>
                <TD WIDTH="22" ALIGN="center">����</TD>
<%
                '�i�����ޏ��̕ҏW
                For i = 0 To lngProgressCount - 1
%>
                    <TD WIDTH="22" ALIGN="center"><%= strProgressSName(i) %></TD>
<%
                Next
%>
            </TR>
<%
            For i = 0 To UBound(strArrRsvNo)
%>
<!--                <tr onmouseover=this.style.backgroundColor='E8EEFC'; onmouseout=this.style.backgroundColor='#<%= IIf(i Mod 2 = 0, "ffffff", "eeeeee") %>' BGCOLOR="#<%= IIf(i Mod 2 = 0, "ffffff", "eeeeee") %>">-->
                <tr onmouseover=this.style.backgroundColor='E8EEFC'; onmouseout=this.style.backgroundColor='#FFFFFF'>
                    <!--���X�g�ɓ���ID�A�����A���ʁA�N�����\������悤�ɕύX-->
                    <!--TD NOWRAP><%'= dtmCslDate %></TD-->
                    <TD NOWRAP><%= objCommon.FormatString(strArrDayId(i), "0000") %></TD>
                    <!--TD NOWRAP><FONT COLOR="#<%'= strArrWebColor(i) %>">��</FONT><%'= strArrCsName(i) %></TD-->
                    <!--TD NOWRAP><%'= strArrRsvGrpName(i) %></TD-->
                    <TD NOWRAP><%= Trim(strArrLastName(i) & "�@" & strArrFirstName(i)) %></TD>
                    <TD NOWRAP><%= IIf(strArrGender(i) ="1", "�j��", "����") %></TD>
                    <!--TD NOWRAP><%'= objCommon.FormatString(strArrBirth(i), "gee.mm.dd") %></TD-->
                    <TD ALIGN="right" NOWRAP><%= Int(strArrAge(i)) %>��</TD>
<%
'                    '������͉�ʂւ�URL�ҏW
'                    strURL = "/webHains/contents/judgement/judMain.asp"
'                    strURL = strURL & "?cslYear="  & Year(dtmCslDate)
'                    strURL = strURL & "&cslMonth=" & Month(dtmCslDate)
'                    strURL = strURL & "&cslDay="   & Day(dtmCslDate)
'                    strURL = strURL & "&dayId="    & strArrDayId(i)
'                    strURL = strURL & "&noPrevNext=1"
                    strURL = "/webHains/contents/interview/interviewTop.asp?rsvNo=" & strArrRsvNo(i)

'### 2004/06/04 Added by Ishihara@FSIT ����i���Ǘ��Ɋ��S�����̓��[�h�ǉ�
                strJudgementMark = ""
                Select Case Trim(strArrEntriedJud(i))
                    Case "0"
                        strJudgementMark = "��"
                    Case "1"
                        strJudgementMark = "��"
                    Case "2"
                        strJudgementMark = ""
                    Case "3"
                        strJudgementMark = "��"
                    Case Else
                        strJudgementMark = strArrEntriedJud(i)
                End Select
'### 2004/06/04 Added End

'### 2004/06/04 Added by Ishihara@FSIT ����i���Ǘ��Ɋ��S�����̓��[�h�ǉ�
                strJudgementMarkManual = ""
                Select Case Trim(strArrEntriedJudManual(i))
                    Case "0"
                        strJudgementMarkManual = "��"
                    Case "1"
                        strJudgementMarkManual = "��"
                    Case "2"
                        strJudgementMarkManual = ""
                    Case "3"
                        strJudgementMarkManual = "��"
                    Case Else
                        strJudgementMarkManual = strArrEntriedJudManual(i)
                End Select
'### 2004/06/04 Added End

'## 2016.08.12 �� �������菈�����{�L���ǉ� STR ##
'Dim strMensetsuStateColor   '�������菈�����{�L���F�w��i�����ς݁F�\�A�������F�s�\�j
                Select Case Trim(strArrMensetsuState(i))
                    Case "�\"
                        strMensetsuStateColor = "#ff6600"
                    Case Else
                        strMensetsuStateColor = ""
                End Select
'## 2016.08.12 �� �������菈�����{�L���ǉ� END ##
%>
                    <TD ALIGN="center"><A HREF="<%= strURL %>" TARGET="_blank"><%= strJudgementMarkManual %></A></TD>
                    <TD ALIGN="center"><A HREF="<%= strURL %>" TARGET="_blank"><IMG SRC="/webHains/images/jud.gif" WIDTH="20" HEIGHT="20" ALT="�������"></A></TD>
                    <TD ALIGN="center"><A HREF="<%= strURL %>" TARGET="_blank"><%= strJudgementMark %></A></TD>
<%'## 2016.08.12 �� �������菈�����{�L���ǉ� STR ##%>
                    <TD ALIGN="center">
<%              If Trim(strArrMensetsuState(i)) = "�\" Then    %>
                        <IMG SRC="/webHains/images/check.gif" WIDTH="20" HEIGHT="20" ALT="�������菈�����{">
<%              End If  %>
                    </TD>
<%'## 2016.08.12 �� �������菈�����{�L���ǉ� END ##%>
                    <TD ALIGN="center"><A HREF="/webHains/contents/result/rslMain.asp?rsvNo=<%= strArrRsvNo(i) %>&cslYear=<%= DatePart("yyyy", dtmCslDate) %>&cslMonth=<%= DatePart("m", dtmCslDate) %>&cslDay=<%= DatePart("d", dtmCslDate) %>&dayId=<%= strArrDayId(i) %>&noPrevNext=1"><IMG SRC="/webHains/images/result.gif" WIDTH="20" HEIGHT="20" ALT="���ʓ���"></A></TD>
<%
                    '����f���̐i���󋵂�ǂݍ���
                    lngRslProgressCount = objProgress.SelectProgressRsl(strArrRsvNo(i), strRslProgressCd, strRslStatus)

                    '�i�����ޏ��̕ҏW
                    For j = 0 To lngProgressCount - 1

                        lngFoundIndex = -1

                        '����f���̐i���󋵂�����
                        For k = 0 To lngRslProgressCount - 1
                            If strRslProgressCd(k) = strProgressCd(j) Then
                                lngFoundIndex = k
                                Exit For
                            End If
                        Next

                        '�������ꂽ�ꍇ
                        If lngFoundIndex >= 0 Then

                            '���ʓ��͉�ʂ�URL�ҏW
                            strURL = "/webHains/contents/result/rslMain.asp"
                            strURL = strURL & "?rsvNo="      & strArrRsvNo(i)
                            strURL = strURL & "&mode="       & "2"
                            strURL = strURL & "&code="       & strProgressCd(j)
                            strURL = strURL & "&cslYear="    & Year(dtmCslDate)
                            strURL = strURL & "&cslMonth="   & Month(dtmCslDate)
                            strURL = strURL & "&cslDay="     & Day(dtmCslDate)
                            strURL = strURL & "&dayId="      & strArrDayId(i)
                            strURL = strURL & "&noPrevNext=" & "1"
%>
                            <TD ALIGN="center"><A HREF="<%= strURL %>"><%= IIf(strRslStatus(lngFoundIndex) = "2", "��", IIf(strRslStatus(lngFoundIndex) = "3", "��", "��")) %></A></TD>
<%
                        '��������Ȃ������ꍇ�͈˗��Ȃ��Ƃ���
                        Else
%>
                            <TD ALIGN="center">&nbsp;</TD>
<%
                        End If

                    Next
%>
                </TR>
<%
            Next
%>
        </TABLE>
<%
        '�擾�������w�莞�̓y�[�W���O�i�r�Q�[�^�s�p
        If lngGetCount = 0 Then
            Exit Do
        End If

        'URL������̕ҏW
        strURL = Request.ServerVariables("SCRIPT_NAME")
        strURL = strURL & "?actMode=" & "select"
        strURL = strURL & "&syear="   & lngCslYear
        strURL = strURL & "&smonth="  & lngCslMonth
        strURL = strURL & "&sday="    & lngCslDay
        strURL = strURL & "&course="  & strKeyCsCd
        strURL = strURL & "&mode="    & strMode
'### 2004/06/11 Added by Ishihara@FSIT �\��Q�̎w�肪�y�[�W���O�i�r���ɏ�����
        strURL = strURL & "&rsvGrpCd="  & strRsvGrpCd

        '�y�[�W���O�i�r�Q�[�^�̕ҏW
        Response.Write EditPageNavi(strURL, lngCount, lngStartPos, lngGetCount)

        Exit Do
    Loop
%>
    </BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
