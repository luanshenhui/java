<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       web�\��̌��� (Ver1.0.0)
'       AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
'�Ǘ��ԍ��FSL-UI-Y0101-107
'�C����  �F2010.06.15�i�C���j
'�S����  �FTCS)����
'�C�����e�Fweb�\����L�����Z���̎捞���\�Ƃ���B
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/editPageNavi.inc"   -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const GETCOUNT_DEFAULT_VALUE = 20    '�\�������̃f�t�H���g�l

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon        '���ʃN���X
Dim objWebRsv        'web�\����A�N�Z�X�p

'�����l
Dim lngStrCslYear       '�J�n��f�N
Dim lngStrCslMonth      '�J�n��f��
Dim lngStrCslDay        '�J�n��f��
Dim lngEndCslYear       '�I����f�N
Dim lngEndCslMonth      '�I����f��
Dim lngEndCslDay        '�I����f��
Dim strKey              '�����L�[
Dim lngStrOpYear        '�J�n�����N
Dim lngStrOpMonth       '�J�n������
Dim lngStrOpDay         '�J�n������
Dim lngEndOpYear        '�I�������N
Dim lngEndOpMonth       '�I��������
Dim lngEndOpDay         '�I��������
Dim lngOpMode           '�������[�h(1:�\�����Ō����A2:�\�񏈗����Ō���)
Dim lngRegFlg           '�{�o�^�t���O(0:�w��Ȃ��A1:���o�^�ҁA2:�ҏW�ςݎ�f��)
Dim lngOrder            '�o�͏�(1:��f�����A2:�lID��)
'#### 2010.06.15 SL-UI-Y0101-107 ADD START ####'
Dim lngMosFlg           '�\���敪(0:�w��Ȃ��A1:�V�K�A2:�L�����Z��)
'#### 2010.06.15 SL-UI-Y0101-107 ADD END ####'
Dim lngStartPos         '�\���J�n�ʒu
Dim lngGetCount         '�\������
Dim blnSearch           '�����{�^�������̗L��

Dim strCslDate          '��f�N����
Dim strWebNo            'webNo.
Dim strStartTime        '��t�J�n����
Dim strRsvGrpName       '�\��Q����
Dim strPerId            '�lID
Dim strFullName         '����
Dim strKanaName         '�J�i����
Dim strLastName         '(�l����)��
Dim strFirstName        '(�l����)��
Dim strLastKName        '(�l����)�J�i��
Dim strFirstKName       '(�l����)�J�i��
Dim strGender           '����
Dim strBirth            '���N����
Dim strOrgName          '�c�̖�
Dim strInsDate          '�\�����ݔN����
'#### 2010.06.15 SL-UI-Y0101-107 ADD START ####'
Dim strCanDate          '�\�������
'#### 2010.06.15 SL-UI-Y0101-107 ADD END ####'
Dim strUpdDate          '�\�񏈗��N����
Dim strRegFlg           '�{�o�^�t���O(1:���o�^�ҁA2:�ҏW�ςݎ�f��)
Dim strRsvNo            '�\��ԍ�
Dim lngCount            '���R�[�h����

Dim dtmStrCslDate       '�J�n��f�N����
Dim dtmEndCslDate       '�I����f�N����
Dim dtmStrOpDate        '�J�n�����N����
Dim dtmEndOpDate        '�I�������N����

Dim strArrMessage       '�G���[���b�Z�[�W�̔z��
Dim dtmDate             '���t
Dim strName             '����
Dim strURL              '�W�����v���URL
Dim blnExists           '�ꗗ�̗L��
Dim i                   '�C���f�b�N�X

''### 2010.09.03 ADD STR TCS)H.F    ���L�����Z�����{�ς݂𕪂���悤�ɂ���
Dim strCancelFlg    '�\��̃L�����Z���t���O
Dim objConsult
Dim strEditDisp         '�ҏW��Ԃ̕\��
''### 2010.09.03 ADD END TCS)H.F


'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
lngStrCslYear  = CLng("0" & Request("strCslYear"))
lngStrCslMonth = CLng("0" & Request("strCslMonth"))
lngStrCslDay   = CLng("0" & Request("strCslDay"))
strKey         = Request("key")
lngEndCslYear  = CLng("0" & Request("endCslYear"))
lngEndCslMonth = CLng("0" & Request("endCslMonth"))
lngEndCslDay   = CLng("0" & Request("endCslDay"))
lngStrOpYear   = CLng("0" & Request("strOpYear"))
lngStrOpMonth  = CLng("0" & Request("strOpMonth"))
lngStrOpDay    = CLng("0" & Request("strOpDay"))
lngEndOpYear   = CLng("0" & Request("endOpYear"))
lngEndOpMonth  = CLng("0" & Request("endOpMonth"))
lngEndOpDay    = CLng("0" & Request("endOpDay"))
lngOpMode      = CLng("0" & Request("opMode"))
lngRegFlg      = CLng("0" & Request("regFlg"))
lngOrder       = CLng("0" & Request("order"))
lngStartPos    = CLng("0" & Request("startPos"))
lngGetCount    = CLng("0" & Request("getCount"))
blnSearch      = Not IsEmpty(Request("act"))
'#### 2010.08.07 SL-UI-Y0101-107 ADD START ####'
'�\���敪�̓��͂��Ȃ����1:�V�K���f�t�H���g��
lngMosFlg      = IIf(Request("mousi") = "", 1, CLng("0" & Request("mousi")))
'#### 2010.08.07 SL-UI-Y0101-107 ADD END ####'

'��f�J�n�A�I�����̃f�t�H���g�l�ݒ�
dtmDate = Date()
lngStrCslYear  = IIf(lngStrCslYear  = 0, Year(Date),  lngStrCslYear)
lngStrCslMonth = IIf(lngStrCslMonth = 0, Month(Date), lngStrCslMonth)
lngStrCslDay   = IIf(lngStrCslDay   = 0, Day(Date),   lngStrCslDay)
lngEndCslYear  = IIf(lngEndCslYear  = 0, Year(Date),  lngEndCslYear)
lngEndCslMonth = IIf(lngEndCslMonth = 0, Month(Date), lngEndCslMonth)
lngEndCslDay   = IIf(lngEndCslDay   = 0, Day(Date),   lngEndCslDay)

'�\���J�n�ʒu�A�\�������̃f�t�H���g�l�ݒ�
lngStartPos = IIf(lngStartPos = 0, 1, lngStartPos)
lngGetCount = IIf(blnSearch = False And lngGetCount = 0, GETCOUNT_DEFAULT_VALUE, lngGetCount)

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do

    '�����{�^���������ȊO�͉������Ȃ�
    If Not blnSearch Then
        Exit Do
    End If

    '���̓`�F�b�N
    strArrMessage = CheckValue()
    If Not IsEmpty(strArrMessage) Then
        Exit Do
    End If

    '�e��N�����̕ҏW
    dtmStrCslDate = CDate(lngStrCslYear & "/" & lngStrCslMonth & "/" & lngStrCslDay)
    dtmEndCslDate = CDate(lngEndCslYear & "/" & lngEndCslMonth & "/" & lngEndCslDay)
    If lngStrOpYear + lngStrOpMonth + lngStrOpDay > 0 Then
        dtmStrOpDate = CDate(lngStrOpYear & "/" & lngStrOpMonth & "/" & lngStrOpDay)
    End If
    If lngEndOpYear + lngEndOpMonth + lngEndOpDay > 0 Then
        dtmEndOpDate = CDate(lngEndOpYear & "/" & lngEndOpMonth & "/" & lngEndOpDay)
    End If

    Set objWebRsv = Server.CreateObject("HainsWebRsv.WebRsv")

    'web�\��̌���
'#### 2010.08.07 SL-UI-Y0101-107 MOD START #### 
'lngMosFlg �ǉ�
''#### 2010.06.17 SL-UI-Y0101-107 MOD START ####'
''    lngCount = objWebRsv.SelectWebRsvList( _
''        dtmStrCslDate, _
''        dtmEndCslDate, _
''        strKey,        _
''        dtmStrOpDate,  _
''        dtmEndOpDate,  _
''        lngOpMode,     _
''        lngRegFlg,     _
''        lngOrder,      _
''        lngStartPos,   _
''        lngGetCount,   _
''        strCslDate,    _
''        strWebNo,      _
''        strStartTime,  _
''        strRsvGrpName, _
''        strPerId,      _
''        strFullName,   _
''        strKanaName,   _
''        strLastName,   _
''        strFirstName,  _
''        strLastKName,  _
''        strFirstKName, _
''        strGender,     _
''        strBirth,      _
''        strOrgName,    _
''        strInsDate,    _
''        strUpdDate,    _
''        strRegFlg,     _
''        strRsvNo       _
''    )
'    lngCount = objWebRsv.SelectWebRsvList( _
'        dtmStrCslDate, _
'        dtmEndCslDate, _
'        strKey,        _
'        dtmStrOpDate,  _
'        dtmEndOpDate,  _
'        lngOpMode,     _
'        lngRegFlg,     _
'        lngOrder,      _
'        lngStartPos,   _
'        lngGetCount,   _
'        strCslDate,    _
'        strWebNo,      _
'        strStartTime,  _
'        strRsvGrpName, _
'        strPerId,      _
'        strFullName,   _
'        strKanaName,   _
'        strLastName,   _
'        strFirstName,  _
'        strLastKName,  _
'        strFirstKName, _
'        strGender,     _
'        strBirth,      _
'        strOrgName,    _
'        strInsDate,    _
'        strCanDate,    _
'        strUpdDate,    _
'        strRegFlg,     _
'        strRsvNo       _
'    )
''#### 2010.06.15 SL-UI-Y0101-107 MOD END ####'
    lngCount = objWebRsv.SelectWebRsvList( _
        dtmStrCslDate, _
        dtmEndCslDate, _
        strKey,        _
        dtmStrOpDate,  _
        dtmEndOpDate,  _
        lngOpMode,     _
        lngRegFlg,     _
        lngMosFlg,     _
        lngOrder,      _
        lngStartPos,   _
        lngGetCount,   _
        strCslDate,    _
        strWebNo,      _
        strStartTime,  _
        strRsvGrpName, _
        strPerId,      _
        strFullName,   _
        strKanaName,   _
        strLastName,   _
        strFirstName,  _
        strLastKName,  _
        strFirstKName, _
        strGender,     _
        strBirth,      _
        strOrgName,    _
        strInsDate,    _
        strCanDate,    _
        strUpdDate,    _
        strRegFlg,     _
        strRsvNo       _
    )
'#### 2010.08.07 SL-UI-Y0101-107 MOD END ####'

    Exit Do
Loop

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���̓`�F�b�N
'
' �����@�@ :
'
' �߂�l�@ : �G���[���b�Z�[�W�̔z��
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CheckValue()

    Dim objCommon    '���ʃN���X
    Dim strDate        '���t
    Dim strMessage    '�G���[���b�Z�[�W

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objCommon = Server.CreateObject("HainsCommon.Common")

    '�J�n��f���̃`�F�b�N
    strDate = lngStrCslYear & "/" & lngStrCslMonth & "/" & lngStrCslDay
    If Not IsDate(strDate) Then
        objCommon.appendArray strMessage, "�J�n��f���̓��͌`��������������܂���B"
    End If

    '�I����f���̃`�F�b�N
    strDate = lngEndCslYear & "/" & lngEndCslMonth & "/" & lngEndCslDay
    If Not IsDate(strDate) Then
        objCommon.appendArray strMessage, "�I����f���̓��͌`��������������܂���B"
    End If

    '�J�n�������̃`�F�b�N
    If lngStrOpYear + lngStrOpMonth + lngStrOpDay > 0 Then
        strDate = lngStrOpYear & "/" & lngStrOpMonth & "/" & lngStrOpDay
        If Not IsDate(strDate) Then
            objCommon.appendArray strMessage, "�J�n�������̓��͌`��������������܂���B"
        End If
    End If

    '�I���������̃`�F�b�N
    If lngEndOpYear + lngEndOpMonth + lngEndOpDay > 0 Then
        strDate = lngEndOpYear & "/" & lngEndOpMonth & "/" & lngEndOpDay
        If Not IsDate(strDate) Then
            objCommon.appendArray strMessage, "�I���������̓��͌`��������������܂���B"
        End If
    End If

    '�G���[���b�Z�[�W�����݂���ꍇ�͂��̓��e��Ԃ�
    If Not IsEmpty(strMessage) Then
        CheckValue = strMessage
    End If

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META http-equiv="Content-Type" content="text/html; charset=Shift_JIS">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE>web�\�񌟍�</TITLE>
<STYLE TYPE="text/css">
<!--
td.rsvtab { background-color:#FFFFFF }
-->
</STYLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
var winWebRsv;            // web�\����o�^���

var strCslDate = '';    // �J�n��f�N����
var endCslDate = '';    // �I����f�N����
var strOpDate  = '';    // �J�n�����N����
var endOpDate  = '';    // �I�������N����

// web�\����o�^��ʌĂяo��
function callWebRsvWindow( cslDate, webNo ) {

    var opened = false;    // ��ʂ��J����Ă��邩

    // ���łɃK�C�h���J����Ă��邩�`�F�b�N
    if ( winWebRsv != null ) {
        if ( !winWebRsv.closed ) {
            opened = true;
        }
    }

    // web�\����o�^��ʂ�URL�ҏW
    var url = 'webRsvMain.asp';
    url = url + '?cslDate='    + cslDate;
    url = url + '&webNo='      + webNo;
    url = url + '&strCslDate=' + strCslDate;
    url = url + '&endCslDate=' + endCslDate;
    url = url + '&key='        + '<%= strKey %>';
    url = url + '&strOpDate='  + strOpDate;
    url = url + '&endOpDate='  + endOpDate;
    url = url + '&opMode='     + '<%= lngOpMode %>';
    url = url + '&regFlg='     + '<%= lngRegFlg %>';
    url = url + '&order='      + '<%= lngOrder  %>';
'#### 2010.10.28 SL-UI-Y0101-107 MOD START ####'
    url = url + '&mousi='      + '<%= lngMosFlg  %>';
'#### 2010.10.28 SL-UI-Y0101-107 MOD END ####'

    // �J����Ă���ꍇ�͉�ʂ�REPLACE���A�����Ȃ��ΐV�K��ʂ��J��
    if ( opened ) {
        winWebRsv.focus();
        winWebRsv.location.replace( url );
    } else {
/* ### 2016.06.24 �� �ꕔ�B��Č����Ȃ���񂪂��邽�߃T�C�Y�ύX STR ### */
//        winWebRsv = open( url, '', 'width=1000,height=680,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no' );
        winWebRsv = open( url, '', 'width=1000,height=800,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no' );
/* ### 2016.06.24 �� �ꕔ�B��Č����Ȃ���񂪂��邽�߃T�C�Y�ύX END ### */
//        winWebRsv = open( url );
    }

}

// ��ʂ����
function closeWindow() {

    // ���t�K�C�h�����
    calGuide_closeGuideCalendar();

    // web�\����o�^��ʂ����
    if ( winWebRsv != null ) {
        if ( !winWebRsv.closed ) {
            winWebRsv.close();
        }
    }

    winWebRsv = null;
}
//-->
</SCRIPT>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="">
<BLOCKQUOTE>
<INPUT TYPE="hidden" NAME="act" VALUE="1">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="700">
    <TR>
        <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000">web�\��̌���</FONT></B></TD>
    </TR>
</TABLE>
<%
    '�G���[���b�Z�[�W�̕ҏW
    EditMessage strArrMessage, MESSAGETYPE_WARNING
%>
<BR>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
    <TR>
        <TD NOWRAP>��f��</TD>
        <TD>�F</TD>
        <TD COLSPAN="3">
            <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
                <TR>
                    <TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
                    <TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, lngStrCslYear, False) %></TD>
                    <TD>�N</TD>
                    <TD><%= EditNumberList("strCslMonth", 1, 12, lngStrCslMonth, False) %></TD>
                    <TD>��</TD>
                    <TD><%= EditNumberList("strCslDay", 1, 31, lngStrCslDay, False) %></TD>
                    <TD>��</TD>
                    <TD>�`</TD>
                    <TD><A HREF="javascript:calGuide_showGuideCalendar('endCslYear', 'endCslMonth', 'endCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
                    <TD><%= EditNumberList("endCslYear", YEARRANGE_MIN, YEARRANGE_MAX, lngEndCslYear, False) %></TD>
                    <TD>�N</TD>
                    <TD><%= EditNumberList("endCslMonth", 1, 12, lngEndCslMonth, False) %></TD>
                    <TD>��</TD>
                    <TD><%= EditNumberList("endCslDay", 1, 31, lngEndCslDay, False) %></TD>
                    <TD>��</TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
    <TR>
        <TD NOWRAP>�����L�[</TD>
        <TD>�F</TD>
        <TD COLSPAN="3"><INPUT TYPE="text" NAME="key" SIZE="45" VALUE="<%= strKey %>"></TD>
    </TR>
    <TR>
        <TD NOWRAP>������</TD>
        <TD>�F</TD>
        <TD COLSPAN="3">
            <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
                <TR>
                    <TD><A HREF="javascript:calGuide_showGuideCalendar('strOpYear', 'strOpMonth', 'strOpDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
                    <TD><A HREF="javascript:calGuide_clearDate('strOpYear', 'strOpMonth', 'strOpDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
                    <TD><%= EditNumberList("strOpYear", YEARRANGE_MIN, YEARRANGE_MAX, lngStrOpYear, True) %></TD>
                    <TD>�N</TD>
                    <TD><%= EditNumberList("strOpMonth", 1, 12, lngStrOpMonth, True) %></TD>
                    <TD>��</TD>
                    <TD><%= EditNumberList("strOpDay", 1, 31, lngStrOpDay, True) %></TD>
                    <TD>��</TD>
                    <TD>�`</TD>
                    <TD><A HREF="javascript:calGuide_showGuideCalendar('endOpYear', 'endOpMonth', 'endOpDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
                    <TD><A HREF="javascript:calGuide_clearDate('endOpYear', 'endOpMonth', 'endOpDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
                    <TD><%= EditNumberList("endOpYear", YEARRANGE_MIN, YEARRANGE_MAX, lngEndOpYear, True) %></TD>
                    <TD>�N</TD>
                    <TD><%= EditNumberList("endOpMonth", 1, 12, lngEndOpMonth, True) %></TD>
                    <TD>��</TD>
                    <TD><%= EditNumberList("endOpDay", 1, 31, lngEndOpDay, True) %></TD>
                    <TD>��</TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
    <TR>
        <TD COLSPAN="2"></TD>
        <TD COLSPAN="3">
            <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
                <TR>
                    <TD><INPUT TYPE="radio" NAME="opMode" VALUE="1"<%= IIf(lngOpMode <> 2, " CHECKED", "") %>></TD>
                    <TD NOWRAP>�\�����Ō���</TD>
                    <TD><INPUT TYPE="radio" NAME="opMode" VALUE="2"<%= IIf(lngOpMode  = 2, " CHECKED", "") %>></TD>
                    <TD NOWRAP>�\�񏈗����Ō���</TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
    <TR>
        <TD NOWRAP>���</TD>
        <TD>�F</TD>
        <TD COLSPAN="2">
            <SELECT NAME="regFlg">
                <OPTION VALUE="0"<%= IIf(lngRegFlg <> 0 And lngRegFlg <> 1, " SELECTED", "") %>>�w��Ȃ�
                <OPTION VALUE="1"<%= IIf(lngRegFlg = 1, " SELECTED", "") %>>���o�^��
                <OPTION VALUE="2"<%= IIf(lngRegFlg = 2, " SELECTED", "") %>>�ҏW�ςݎ�f��
            </SELECT>
        </TD>
<!-- '#### 2010.06.15 SL-UI-Y0101-107 MOD START ####' -->
<!--
        <TD ROWSPAN="2" VALIGN="bottom"><INPUT TYPE="image" SRC="/webHains/images/findrsv.gif" WIDTH="77" HEIGHT="24" ALT="�w������Ō���"></TD>
-->
    </TR>
    <TR>
        <TD NOWRAP>�\���敪</TD>
        <TD>�F</TD>
        <TD WIDTH="460">
            <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
                <TR>
<!--�@#### 2010.08.07 SL-UI-Y0101-107 MOD START ####'
                    <# lngMosFlg = 1 #>     �f�t�H���g��V�K��ɂ���B-->
<!--
                    <TD><INPUT TYPE="radio" NAME="mousi" VALUE="1"<#= IIf(lngMosFlg = 0, " CHECKED", "") #>></TD>
                    <TD NOWRAP>���ׂ�</TD>
                    <TD><INPUT TYPE="radio" NAME="mousi" VALUE="2"<#= IIf(lngMosFlg = 1, " CHECKED", "") #>></TD>
                    <TD NOWRAP>�V�K</TD>
                    <TD><INPUT TYPE="radio" NAME="mousi" VALUE="3"<#= IIf(lngMosFlg = 2, " CHECKED", "") #>></TD>
                    <TD NOWRAP>�L�����Z��</TD>
-->
                    <TD><INPUT TYPE="radio" NAME="mousi" VALUE="0" <%= IIf(lngMosFlg = 0, " CHECKED", "") %>></TD>
                    <TD NOWRAP>���ׂ�</TD>
                    <TD><INPUT TYPE="radio" NAME="mousi" VALUE="1" <%= IIf(lngMosFlg = 1, " CHECKED", "") %>></TD>
                    <TD NOWRAP>�V�K</TD>
                    <TD><INPUT TYPE="radio" NAME="mousi" VALUE="2" <%= IIf(lngMosFlg = 2, " CHECKED", "") %>></TD>
                    <TD NOWRAP>�L�����Z��</TD>
<!--�@#### 2010.08.07 SL-UI-Y0101-107 MOD END ####' -->
                </TR>
            </TABLE>
        </TD>
        <TD ROWSPAN="2" VALIGN="bottom"><INPUT TYPE="image" SRC="/webHains/images/findrsv.gif" WIDTH="77" HEIGHT="24" ALT="�w������Ō���"></TD>
<!--'#### 2010.06.15 SL-UI-Y0101-107 MOD END ####'-->
    </TR>
    <TR>
        <TD NOWRAP>�o�͏�</TD>
        <TD>�F</TD>
        <TD WIDTH="460">
            <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
                <TR>
                    <TD><INPUT TYPE="radio" NAME="order" VALUE="1"<%= IIf(lngOrder <> 2, " CHECKED", "") %>></TD>
                    <TD NOWRAP>��f����</TD>
                    <TD><INPUT TYPE="radio" NAME="order" VALUE="2"<%= IIf(lngOrder  = 2, " CHECKED", "") %>></TD>
                    <TD NOWRAP>�l�h�c��</TD>
                </TR>
            </TABLE>
        </TD>
        <TD>
            <SELECT NAME="getCount">
                <OPTION VALUE="20"<%= IIf(lngGetCount <> 0 And lngGetCount <> 50, " SELECTED", "") %>>20������
                <OPTION VALUE="50"<%= IIf(lngGetCount = 50, " SELECTED", "") %>>50������
                <OPTION VALUE="0"<%= IIf(lngGetCount = 0, " SELECTED", "") %>>���ׂ�
            </SELECT>
        </TD>
    </TR>
</TABLE>
</BLOCKQUOTE>
</FORM>
<%
Do

    '�����{�^���������ȊO�͉������Ȃ�
    If Not blnSearch Then
        Exit Do
    End If

    '�G���[���͉������Ȃ�
    If Not IsEmpty(strArrMessage) Then
        Exit Do
    End If

    '���R�[�h�����݂��Ȃ��ꍇ
    If lngCount <= 0 Then
%>
        <BLOCKQUOTE>���������𖞂�����f���͑��݂��܂���B</BLOCKQUOTE>
<%
        Exit Do
    End If

    Set objCommon = Server.CreateObject("HainsCommon.Common")
%>
    <BLOCKQUOTE>
    �u<FONT COLOR="#ff6600"><B><%= objCommon.FormatString(dtmStrCslDate, "yyyy�Nm��d��") %>�`<%= objCommon.FormatString(dtmEndCslDate, "yyyy�Nm��d��") %></B></FONT>�v��web�\��҈ꗗ��\�����Ă��܂��B<BR>
    <FONT COLOR="#ff6600"><B><%= lngCount %></B></FONT>���̗\���񂪂���܂��B<BR><BR>
    <FONT COLOR="#cc9999">��</FONT>������I������ƁA�Y������web�\����̓o�^��ʂ��\������܂��B<BR>
    <FONT COLOR="#cc9999">��</FONT>���łɕҏW�ς݂̗\����ɂ��ẮA�u��f���ցv��I������Ǝ�f���ڍ׉�ʂ��\������܂��B<BR><BR>

    <TABLE ID="webRsv" BORDER="0" CELLPADDING="2" CELLSPACING="2">
        <TR BGCOLOR="#cccccc">
            <TD NOWRAP>��f��]��</TD>
            <TD NOWRAP>��f��]����</TD>
            <TD NOWRAP>�l�h�c</TD>
            <TD NOWRAP>����</TD>
            <TD NOWRAP>����</TD>
            <TD NOWRAP>���N����</TD>
            <TD NOWRAP>�_��c�̖�</TD>
            <TD NOWRAP>�\����</TD>
<!-- '#### 2010.06.15 SL-UI-Y0101-107 MOD START ####' -->
            <TD NOWRAP>�\�������</TD>
<!-- '#### 2010.06.15 SL-UI-Y0101-107 MOD END ####' -->
            <TD NOWRAP>������</TD>
            <TD NOWRAP>���</TD>
            <TD NOWRAP>����</TD>
        </TR>
<%
        'web�\��ꗗ��񂪑��݂���ꍇ
        If IsArray(strCslDate) Then

            '�ꗗ�̗L���̃t���O������
            blnExists = True

            '�ꗗ�̕ҏW
            For i = 0 To UBound(strCslDate)
%>
                <TR BGCOLOR="#<%= IIf(i Mod 2 = 0, "ffffff", "eeeeee") %>">
                    <TD NOWRAP><%= strCslDate(i) %></TD>
                    <TD NOWRAP><%= strRsvGrpName(i) %></TD>
                    <TD NOWRAP><%= strPerId(i) %></TD>
<%
                    '�����ɂ��ẮA�lID���ݎ��͌l��񂩂�A�����Ȃ���web�\���񂩂�擾
                    strName = ""

                    If strPerId(i) <> "" Then
                        strName = Trim(strLastName(i) & "�@" & strFirstName(i))
                    End If

                    If strName = "" Then
                        strName = strFullName(i)
                    End If
%>
<!-- '#### 2010.06.15 SL-UI-Y0101-107 MOD START ####' -->
<!--                <TD NOWRAP><A HREF="javascript:callWebRsvWindow('<%= strCslDate(i) %>','<%= strWebNo(i) %>')"><%= strName %></A></TD>
-->
<!-- '#### 2010.11.12 SL-UI-Y0101-107 MOD START ####' -->

<!--
<%
                    If strCanDate(i) <> "" Then
%>
                        <TD NOWRAP><%= strName %></A></TD>
<%
                    Else
%>
                        <TD NOWRAP><A HREF="javascript:callWebRsvWindow('<%= strCslDate(i) %>','<%= strWebNo(i) %>')"><%= strName %></A></TD>
<%
                    End If
%>
-->
                    <TD NOWRAP><A HREF="javascript:callWebRsvWindow('<%= strCslDate(i) %>','<%= strWebNo(i) %>')"><%= strName %></A></TD>
<!-- '#### 2010.11.12 SL-UI-Y0101-107 MOD END ####' -->
<!-- '#### 2010.06.15 SL-UI-Y0101-107 MOD END ####' -->

<!-- '#### 2010.09.03 SL-UI-Y0101-107 ADD START ####' -->
<%
                    strEditDisp = ""
                    strCancelFlg = Empty
                    If strCanDate(i) <> "" And strRsvNo(i)<> "" Then
                        
                        '�I�u�W�F�N�g�̃C���X�^���X�쐬
                        Set objConsult = Server.CreateObject("HainsConsult.Consult")
                        '��f���ǂݍ���
                         objConsult.SelectConsult CLng(strRsvNo(i)), strCancelFlg 

                    End If

                    If strRegFlg(i) = "1" Then
                        strEditDisp = "���ҏW"
                    Else

'#### 2010.11.12 SL-UI-Y0101-107 MOD START ####' 
'                        If strCancelFlg = "0" Or strCancelFlg = "" Then
'                            strEditDisp = "�ҏW�ς�"
'                        Else
'                            strEditDisp = "����ς�"
'                        End If
                        If strCanDate(i) <> "" Then
                            If strCancelFlg = "0" Or strCancelFlg = "" Then
                                If strRsvNo(i) <> "" Then
                                    strEditDisp = "�ҏW�ς�"
                                Else
                                    strEditDisp = "�폜�ς�"
                                End If
                            Else
                                strEditDisp = "����ς�"
                            End If
                        Else
                            'If strCancelFlg = "0" Or strCancelFlg = "" Then
                                strEditDisp = "�ҏW�ς�"
                            'Else
                            '    strEditDisp = "����ς�"
                            'End If
                        End If
'#### 2010.11.12 SL-UI-Y0101-107 MOD END ####'
                    End If

%>
<!-- '#### 2010.09.03 SL-UI-Y0101-107 ADD END ####' -->


                    <TD ALIGN="center"><%= IIf(CLng(strGender(i)) = GENDER_MALE, "�j��", "����") %></TD>
                    <TD NOWRAP><%= objCommon.FormatString(CDate(strBirth(i)), "gee.mm.dd") %></TD>
                    <TD NOWRAP><%= strOrgName(i) %></TD>
                    <TD NOWRAP><%= strInsDate(i) %></TD>
<!-- '#### 2010.06.15 SL-UI-Y0101-107 ADD START ####' -->
                    <TD ALIGN="center" NOWRAP><%= strCanDate(i) %></TD>
<!-- '#### 2010.06.15 SL-UI-Y0101-107 ADD END ####' -->
                    <TD NOWRAP><%= strUpdDate(i) %></TD>

<!-- '#### 2010.09.03 SL-UI-Y0101-107 MOD START ####' -->
<!--
                    <TD NOWRAP><%= IIf(strRegFlg(i) = "1", "���ҏW", "�ҏW�ς�") %></TD>
-->
                    <TD NOWRAP><%= strEditDisp %></TD>
<!-- '#### 2010.09.03 SL-UI-Y0101-107 MOD END ####' -->
<%
                    If strRsvNo(i) <> "" Then

                        '��f���ڍ׉�ʂ�URL�ҏW
                        strURL = "/webHains/contents/reserve/rsvMain.asp"
                        strURL = strURL & "?rsvNo=" & strRsvNo(i)
%>
                        <TD NOWRAP><A HREF="<%= strURL %>" TARGET="_blank">��f����</A></TD>
<%
                    Else
%>
                        <TD></TD>
<%
                    End If
%>
                </TR>
<%
            Next

        End If
%>
    </TABLE>
<%

    Set objCommon = Nothing

    '�S���������ȊO��
       If lngGetCount > 0 Then

        'URL�̕ҏW
        strURL = Request.ServerVariables("SCRIPT_NAME")
        strURL = strURL & "?strCslYear="  & lngStrCslYear
        strURL = strURL & "&strCslMonth=" & lngStrCslMonth
        strURL = strURL & "&strCslDay="   & lngStrCslDay
        strURL = strURL & "&endCslYear="  & lngEndCslYear
        strURL = strURL & "&endCslMonth=" & lngEndCslMonth
        strURL = strURL & "&endCslDay="   & lngEndCslDay
        strURL = strURL & "&key="         & strKey
        strURL = strURL & "&strOpYear="   & lngStrOpYear
        strURL = strURL & "&strOpMonth="  & lngStrOpMonth
        strURL = strURL & "&strOpDay="    & lngStrOpDay
        strURL = strURL & "&endOpYear="   & lngEndOpYear
        strURL = strURL & "&endOpMonth="  & lngEndOpMonth
        strURL = strURL & "&endOpDay="    & lngEndOpDay
        strURL = strURL & "&opMode="      & lngOpMode
        strURL = strURL & "&regFlg="      & lngRegFlg
        strURL = strURL & "&order="       & lngOrder
        strURL = strURL & "&act="         & "1"
'#### 2010.10.28 SL-UI-Y0101-107 MOD START ####'
        strURL = strURL & "&mousi="     & lngMosFlg
'#### 2010.10.28 SL-UI-Y0101-107 MOD END ####'

        '�y�[�W���O�i�r�Q�[�^�̕ҏW
%>
        <%= EditPageNavi(strURL, lngCount, lngStartPos, lngGetCount) %>
<%
    End If
%>
    </BLOCKQUOTE>
<%
    Exit Do
Loop
%>
<%
'�ꗗ�����݂���ꍇ�A����������JavaScript�̕ϐ��Ƃ��ĕێ�����(web�\����o�^��ʂ��J���ۂ̈����Ƃ��Ďg�p)
If blnExists Then
%>
<SCRIPT TYPE="text/javascript">
<!--
strCslDate = '<%= dtmStrCslDate %>';
endCslDate = '<%= dtmEndCslDate %>';
strOpDate  = '<%= dtmStrOpDate  %>';
endOpDate  = '<%= dtmEndOpDate  %>';
//-->
</SCRIPT>
<%
End If
%>
</BODY>
</HTML>
