<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'      OCR���͌��ʊm�F�i�w�b�_�[�j  (Ver0.0.1)
'      AUTHER  : 
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
'Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'### 2016.01.28 �� �l���ǉ��ׁ̈A�C�� STR ##############################################
Const OPT_DSP = 8                           '�I�v�V���������\���̐܂�Ԃ���
Const BASEINFO_GRPCD = "X039"               '�g�̏��@�������ڃO���[�v�R�[�h
Const IMGFILE_PATH = "../../images/"        '�C���[�W�t�@�C����PATH��
Const IMGFILE_SPECIAL = "physical10.gif"    '����ی��w��
'### 2016.01.28 �� �l���ǉ��ׁ̈A�C�� END ##############################################

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon           '���ʃN���X
Dim objConsult          '��f�N���X
Dim objRslOcrSp         'OCR���͌��ʃA�N�Z�X�p

'### 2016.01.27 �� �l���ǉ��ׁ̈A�C�� STR ##############################################
Dim objPerResult            '�l�������ʏ��A�N�Z�X�p
Dim objFree                 '�ėp���A�N�Z�X�p
Dim objSpecialInterview     '���茒�f���A�N�Z�X�p
Dim objInterview            '�ʐڃN���X
'### 2016.01.27 �� �l���ǉ��ׁ̈A�C�� END ##############################################

'### �p�����[�^
Dim strWinMode          '�E�B���h�E���[�h
Dim lngRsvNo            '�\��ԍ��i���񕪁j
Dim strGrpNo            '�O���[�vNo
Dim strCsCd             '�R�[�X�R�[�h

Dim strUrlPara          '�t���[���ւ̃p�����[�^

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'### �I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objConsult      = Server.CreateObject("HainsConsult.Consult")
Set objRslOcrSp     = Server.CreateObject("HainsRslOcrSp.OcrNyuryokuSp")

'### 2016.01.28 �� �l���ǉ��ׁ̈A�C�� STR ##############################################
Set objInterview        = Server.CreateObject("HainsInterview.Interview")
Set objPerResult        = Server.CreateObject("HainsPerResult.PerResult")
Set objSpecialInterview = Server.CreateObject("HainsSpecialInterview.SpecialInterview")
'### 2016.01.28 �� �l���ǉ��ׁ̈A�C�� END ##############################################

'### �����l�̎擾
lngRsvNo            = Request("rsvno")

'### ��f���p�ϐ�
Dim strPerId            '�lID

'### 2016.01.28 �� �l���ǉ��ׁ̈A�C�� STR ##############################################
'Dim lngAge              '�N��
'Dim lngGender           '����

Dim strCslDate              '��f��
Dim strCsName               '�R�[�X��
Dim strLastName             '��
Dim strFirstName            '��
Dim strLastKName            '�J�i��
Dim strFirstKName           '�J�i��
Dim strBirth                '���N����
Dim strAge                  '�N��
Dim strGender               '����
Dim strGenderName           '���ʖ���
Dim strDayId                '����ID
Dim strOrgName              '�c�̖���

'�I�v�V�����������
Dim strOptCd                '�I�v�V�����R�[�h
Dim strOptBranchNo          '�I�v�V�����}��
Dim strOptName              '�I�v�V��������

'�l�������ڏ��p�ϐ�
Dim vntItemCd               '�������ڃR�[�h
Dim vntSuffix               '�T�t�B�b�N�X
Dim vntItemName             '�������ږ�
Dim vntResult               '��������
Dim vntResultType           '���ʃ^�C�v
Dim vntItemType             '���ڃ^�C�v
Dim vntStcItemCd            '���͎Q�Ɨp���ڃR�[�h
Dim vntStcCd                '���̓R�[�h
Dim vntShortStc             '���͗���
Dim vntIspDate              '������
Dim vntImageFileName        '�C���[�W�t�@�C����
Dim lngPerRslCount          '�l�������ڏ��

Dim strEraBirth             '���N����(�a��)
Dim strRealAge              '���N��

Dim lngOptCount             '�I�v�V�������
Dim lngConsCount            '��f��
Dim lngHealthCount          '�g�̏��
Dim lngSpCheck              '����ی��w���Ώۂ��`�F�b�N

Dim lngCnt

'### 2016.01.28 �� �l���ǉ��ׁ̈A�C�� END ##############################################


Dim vntEditOcrDate      'OCR���e�m�F�C������

'### �������`�F�b�N���X�g�̕ۑ��m�F
Dim vntGFCheckList      '�������`�F�b�N���X�g�̏��

Dim Ret                 '���A�l
Dim i, j                '�J�E���^�[

'### �t���[���ւ̃p�����[�^�ݒ�
strUrlPara = "?rsvno=" & lngRsvNo

Do
    '### ��f��񌟍��i�\��ԍ����l���擾�j
'### 2016.01.28 �� �l���ǉ��ׁ̈A�C�� STR ##############################################
'    Ret = objConsult.SelectConsult(lngRsvNo, _
'                                    , , _
'                                    strPerId, _
'                                    , , , , , , , _
'                                    lngAge, _
'                                    , , , , , , , , , , , , , , , _
'                                    0, , , , , , , , , , , , , , , _
'                                    , , , , , _
'                                    lngGender _
'                                    )

    Ret = objConsult.SelectConsult(lngRsvNo, _
                                    , _
                                    strCslDate, _
                                    strPerId, _
                                    strCsCd, _
                                    strCsName, _
                                    , , _
                                    strOrgName, _
                                    , , _
                                    strAge, _
                                    , , , , , , , , , , , , _
                                    strDayId, _
                                    , , 0, , , , , , , , , , , , , , , _
                                    strLastName, _
                                    strFirstName, _
                                    strLastKName, _
                                    strFirstKName, _
                                    strBirth, _
                                    strGender, _
                                    , , , , , , lngConsCount )
'### 2016.01.28 �� �l���ǉ��ׁ̈A�C�� END ##############################################


    '### ��f��񂪑��݂��Ȃ��ꍇ�̓G���[�Ƃ��� ###
    If Ret = False Then
        Err.Raise 1000, , "��f��񂪑��݂��܂���B�i�\��ԍ�= " & lngRsvNo & " )"
    End If

'### 2016.01.28 �� �l���ǉ��ׁ̈A�C�� STR ##############################################

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

    '�I�v�V�����������̓ǂݍ���
    lngOptCount = objInterview.SelectInteviewOptItem( lngRsvNo, strOptName )

    '����ی��w���Ώێ҃`�F�b�N
    lngSpCheck = objSpecialInterview.CheckSpecialTarget(lngRsvNo)


    '�l�������ʏ��擾
    lngPerRslCount = objPerResult.SelectPerResultGrpList( strPerID, _
                                                        BASEINFO_GRPCD, _
                                                        2, 0, _
                                                        vntItemCd, _
                                                        vntSuffix, _
                                                        vntItemName, _
                                                        vntResult, _
                                                        vntResultType, _
                                                        vntItemType, _
                                                        vntStcItemCd, _
                                                        vntShortStc, _
                                                        vntIspDate, _
                                                        vntImageFileName _
                                                        )
    If lngPerRslCount < 0 Then
        Err.Raise 1000, , "�l�������ʏ�񂪑��݂��܂���B�i�lID= " & strPerID & " )"
    End If

'### 2016.01.28 �� �l���ǉ��ׁ̈A�C�� END ##############################################

    '### OCR���e�m�F�C���������擾���� ###
    Ret = objRslOcrSp.SelectEditOcrDate( _
                                        lngRsvNo, _
                                        vntEditOcrDate _
                                        )
    If Ret = False Then
        Err.Raise 1000, , "OCR���e�m�F�C���������擾�ł��܂���B�i�\��ԍ� = " & lngRsvNo & ")"
    End If

    '### �������`�F�b�N���X�g�̏�Ԏ擾 ###
    Ret = objRslOcrSp.CheckGF( _
                            lngRsvNo, _
                            vntGFCheckList _
                            )
    If Ret < 0 Then
        Err.Raise 1000, , "�������`�F�b�N���X�g�̏�Ԃ��擾�ł��܂���B�i�\��ԍ� = " & lngRsvNo & ")"
    End If

    '### �I�u�W�F�N�g�̃C���X�^���X�폜 ###
    Set objConsult = Nothing
    Set objRslOcrSp = Nothing

'### 2016.01.28 �� �l���ǉ��ׁ̈A�C�� STR ##############################################
    Set objInterview = Nothing
    Set objSpecialInterview = Nothing
    Set objPerResult = Nothing
'### 2016.01.28 �� �l���ǉ��ׁ̈A�C�� END ##############################################

    Exit Do
Loop

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>OCR���͌��ʊm�F�i�V�j</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// �W�����v
function jumpOcrNyuryoku( index ) {
    var     strAnchor

    switch ( index ) {
        case 1:
            strAnchor = "Anchor-DiseaseHistory";
            break;
        case 2:
            strAnchor = "Anchor-LifeHabit1";
            break;
        case 3:
            strAnchor = "Anchor-LifeHabit2";
            break;
        case 4:
            strAnchor = "Anchor-Fujinka";
            break;
        case 5:
            strAnchor = "Anchor-Syokusyukan";
            break;
        case 6:
            strAnchor = "Anchor-Morning";
            break;
        case 7:
            strAnchor = "Anchor-Lunch";
            break;
        case 8:
            strAnchor = "Anchor-Dinner";
            break;
        case 9:
            strAnchor = "Anchor-Special";
            break;
        default:
            return;
    }

    parent.list.document.entryForm.anchor.value = strAnchor;
    parent.list.JumpAnchor();

    return;
}

var winMonshinChangeOption;     // �E�B���h�E�n���h��
var winNaishikyou;              // �E�B���h�E�n���h��

/** ��f�������ڕύX��ʌĂяo�� **/
function callMonshinChangeOption() {
    var url;            // URL������
    var opened = false; // ��ʂ����łɊJ����Ă��邩�`�F�b�N

    var i;

    /** ���łɃK�C�h���J����Ă��邩�`�F�b�N **/
    if ( winMonshinChangeOption != null ) {
        if ( !winMonshinChangeOption.closed ) {
            opened = true;
        }
    }

    url = 'changeOption.asp';
    url = url + '?rsvno=' + '<%= lngRsvNo %>';

    /** �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J�� **/
    if ( opened ) {
        winMonshinChangeOption.focus();
        winMonshinChangeOption.location.replace( url );
    } else {
        /** 2016.02.01 �� �����Z�b�g�ύX��ʃT�C�Y�ύX **/
        //winMonshinChangeOption = window.open( url, '', 'width=800,height=550,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
        winMonshinChangeOption = window.open( url, '', 'width=800,height=550,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
    }

}

/** �������`�F�b�N���X�g���͉�ʌĂяo�� **/
function callNaishikyou() {
    var url;            // URL������
    var opened = false; // ��ʂ����łɊJ����Ă��邩�`�F�b�N

    var i;

    /** ���łɃK�C�h���J����Ă��邩�`�F�b�N **/
    if ( winNaishikyou != null ) {
        if ( !winNaishikyou.closed ) {
            opened = true;
        }
    }

    url = '/WebHains/contents/interview/NaishikyouCheck.asp';
    url = url + '?rsvno=' + '<%= lngRsvNo %>';

    /** �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J�� **/
    if ( opened ) {
        winNaishikyou.focus();
        winNaishikyou.location.replace( url );
    } else {
        winNaishikyou = window.open( url, '', 'width=650,height=650,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
    }

}

/** �E�B���h�E����� **/
function windowClose() {

    /** �n�b�q���ʕۑ��m�F **/
    if( top.params.nomsg != 1 ) {
        if( '<%= vntEditOcrDate %>' == '' ) {
            alert("�n�b�q���ʂ��i�[����Ă��܂���B�G���[���e���m�F���A�ۑ�������K�����s���Ă��������B");
        }
    }
    /** �������`�F�b�N���X�g�̕ۑ��m�F **/
    if( document.entryForm.GFCheckList.value == '0' ) {
        alert("�f�e�R�[�X��f�̏ꍇ�́A�������`�F�b�N���X�g�̕ۑ�������K�����s���Ă��������B");
    }

    /** ��f�������ڕύX��ʂ���� **/
    if ( winMonshinChangeOption != null ) {
        if ( !winMonshinChangeOption.closed ) {
            winMonshinChangeOption.close();
        }
    }

    winMonshinChangeOption = null;

    /** �������`�F�b�N���X�g���͉�ʂ���� **/
    if ( winNaishikyou != null ) {
        if ( !winNaishikyou.closed ) {
            winNaishikyou.close();
        }
    }

    winNaishikyou = null;
}

//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 10px 0 0 10px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:windowClose()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<!-- �����l -->
    <INPUT TYPE="hidden" NAME="rsvno"   VALUE="<%= lngRsvNo %>">
<!--### �������`�F�b�N���X�g�̕ۑ��m�F�p ###-->
    <INPUT TYPE="hidden" NAME="GFCheckList"   VALUE="<%= vntGFCheckList %>">

    <!-- �^�C�g���̕\�� -->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
        <TR HEIGHT="14">
            <TD NOWRAP HEIGHT="14" BGCOLOR="#ffffff"><B><SPAN CLASS="demand">��</SPAN><FONT COLOR="#000000">OCR���͌��ʊm�F�i�V�j</B></FONT></TD>
            <TD NOWRAP BGCOLOR="#ffffff" WIDTH="250">

<!-- �n�b�q���ʕۑ���ԕ\�� -->
<%
If vntEditOcrDate = "" Then
%>
                <FONT SIZE="-1" COLOR="red">OCR���ʖ��o�^�ł��B</FONT>
<%
Else
%>
                <FONT SIZE="-1">OCR���ʓo�^�ς�:(<%= vntEditOcrDate %>)</FONT>
<%
End If
%>
            </TD>
        </TR>
    </TABLE>


<%'### 2016.01.27 �� �l���ǉ��ׁ̈A�C�� STR ############################################## %>

    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
        <TR>
            <TD HEIGHT="3"></TD>
        </TR>
        <TR>
            <TD NOWRAP>��f���F</TD>
            <TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCslDate %></B></FONT></TD>
            <TD NOWRAP>&nbsp;&nbsp;�R�[�X�F</TD>
            <TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCsName %></B></FONT></TD>
            <TD NOWRAP>&nbsp;&nbsp;�����h�c�F</TD>
            <TD NOWRAP><FONT COLOR="#ff6600"><B><%= objCommon.FormatString(strDayID, "0000") %></B></FONT></TD>
            <TD NOWRAP>&nbsp;&nbsp;�c�́F</TD>
            <TD NOWRAP><%= strOrgName %></TD>
            <TD NOWRAP><IMG SRC="../../images/spacer.gif" WIDTH="80" HEIGHT="1" ALT=""></TD>
            <TD NOWRAP>
<%
            If lngSpCheck > 0 Then 
%>
                <IMG SRC="../../images/physical10.gif"  HEIGHT="22" WIDTH="22" BORDER="0" ALT="����ی��w���Ώ�"><IMG SRC="../../images/spacer.gif" WIDTH="10" HEIGHT="1" ALT="">
<%
            End If
%>
            </TD>
<%
            lngCnt = 0
            For i=0 To lngOptCount - 1
                lngCnt = i + 1
                If lngCnt > OPT_DSP Then
                    lngCnt = lngCnt - 1
                    Exit For
                End If
%>
                <TD NOWRAP><%= strOptName(i) %></TD>
                <TD NOWRAP><IMG SRC="../../images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
<%
            Next
%>
        </TR>
<%
        For i=1 To (Int(Abs(lngOptCount/OPT_DSP) * -1 ) * -1) 
            If lngCnt > lngOptCount Then Exit For
%>
        <TR>
            <TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD><TD></TD>
<%
            For j=0 To OPT_DSP - 1
                lngCnt = lngCnt + 1
                If lngCnt > lngOptCount Then Exit For
%>
                <TD NOWRAP><%= strOptName(lngCnt-1) %></TD>
                <TD NOWRAP><IMG SRC="../../images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
<%
            Next
%>
        </TR>
<%
        Next
%>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
        <TR>
            <TD HEIGHT="3"></TD>
        </TR>
        <TR>
            <TD NOWRAP><B><%= strPerId %></B>&nbsp;&nbsp;</TD>
            <TD NOWRAP><B><%= strLastName & " " & strFirstName %></B> �i<FONT SIZE="-1"><%= strLastKname & "�@" & strFirstKName %></FONT>�j&nbsp;&nbsp;</TD>
            <TD NOWRAP><%= FormatDateTime(strBirth, 1) %>���@<%= strRealAge %>�΁i<%= Int(strAge) %>�΁j&nbsp;&nbsp;<%= IIf(strGender = "1", "�j��", "����") %></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP>&nbsp;&nbsp;��f�񐔁F</TD>
            <TD NOWRAP><FONT COLOR="#ff6600"><B><%= lngConsCount %></B></FONT>&nbsp;&nbsp;</TD>
            <TD NOWRAP><IMG SRC="../../images/spacer.gif"></TD>
            <TD NOWRAP ALIGN="RIGHT">&nbsp;&nbsp;�g�̏��F</TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="3" CELLPADDING="0">
                    <TR>

<%
    For i=0 To lngPerRslCount-1
        If vntImageFileName(i) <> "" Then
%>
                        <TD><IMG SRC="<%= IMGFILE_PATH & vntImageFileName(i) %>" ALT="<%= vntItemName(i) %>" HEIGHT="22" WIDTH="22" BORDER="0"></TD>
<%
        End If
    Next
%>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>

<%'### 2016.01.27 �� �l���ǉ��ׁ̈A�C�� END ############################################## %>

    <!-- �A���J�[�̕\�� -->
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%">
        <TR>
            <TD HEIGHT="5"></TD>
        </TR>
        <TR>
<% 
    '### ������f�҂̏ꍇ ###

'### 2016.01.27 �� �l���ǉ���ƂŏC�� STR ###
'    If lngGender = 2 Then
    If strGender = "2" Then
'### 2016.01.27 �� �l���ǉ���ƂŏC�� END ###

%>
            <TD ALIGN="LEFT">
                <IMG SRC="../../images/specialNavi2.gif" ALT="" BORDER="0" USEMAP="#queNavi2">
                <MAP NAME="queNavi2">
                <AREA SHAPE="RECT" COORDS="0,   0,104,28" HREF="JavaScript:jumpOcrNyuryoku(1)" ALT="���a��������">
                <AREA SHAPE="RECT" COORDS="107, 0,194,28" HREF="JavaScript:jumpOcrNyuryoku(2)" ALT="�����K����f�P">
                <AREA SHAPE="RECT" COORDS="199, 0,284,28" HREF="JavaScript:jumpOcrNyuryoku(3)" ALT="�����K����f�Q">
                <AREA SHAPE="RECT" COORDS="288, 0,348,28" HREF="JavaScript:jumpOcrNyuryoku(4)" ALT="�w�l�Ȗ�f">
                <AREA SHAPE="RECT" COORDS="351, 0,411,28" HREF="JavaScript:jumpOcrNyuryoku(5)" ALT="�H�K����f">
                <AREA SHAPE="RECT" COORDS="413, 0,460,28" HREF="JavaScript:jumpOcrNyuryoku(6)" ALT="���H">
                <AREA SHAPE="RECT" COORDS="461, 0,509,28" HREF="JavaScript:jumpOcrNyuryoku(7)" ALT="���H">
                <AREA SHAPE="RECT" COORDS="513, 0,562,28" HREF="JavaScript:jumpOcrNyuryoku(8)" ALT="�[�H">
                <AREA SHAPE="RECT" COORDS="565, 0,630,28" HREF="JavaScript:jumpOcrNyuryoku(9)" ALT="���茒�f">
                </MAP>
            </TD>
<%
    '### �j����f�҂̏ꍇ ###
    Else
%>
            <TD ALIGN="LEFT">
                <IMG SRC="../../images/specialNavi.gif" ALT="" BORDER="0" USEMAP="#queNavi">
                <MAP NAME="queNavi">
                <AREA SHAPE="RECT" COORDS="8,   0,106,28" HREF="JavaScript:jumpOcrNyuryoku(1)" ALT="���a��������">
                <AREA SHAPE="RECT" COORDS="114, 0,196,28" HREF="JavaScript:jumpOcrNyuryoku(2)" ALT="�����K����f�P">
                <AREA SHAPE="RECT" COORDS="206, 0,285,28" HREF="JavaScript:jumpOcrNyuryoku(3)" ALT="�����K����f�Q">
                <AREA SHAPE="RECT" COORDS="292, 0,349,28" HREF="JavaScript:jumpOcrNyuryoku(5)" ALT="�H�K����f">
                <AREA SHAPE="RECT" COORDS="353, 0,401,28" HREF="JavaScript:jumpOcrNyuryoku(6)" ALT="���H">
                <AREA SHAPE="RECT" COORDS="403, 0,448,28" HREF="JavaScript:jumpOcrNyuryoku(7)" ALT="���H">
                <AREA SHAPE="RECT" COORDS="452, 0,501,28" HREF="JavaScript:jumpOcrNyuryoku(8)" ALT="�[�H">
                <AREA SHAPE="RECT" COORDS="506, 0,567,28" HREF="JavaScript:jumpOcrNyuryoku(9)" ALT="���茒�f">
                </MAP>
            </TD>
<%
    End If
%>
            <TD ALIGN="RIGHT">
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                    <TR>
                        <TD NOWRAP><IMG SRC="../../images/spacer.gif" WIDTH="20" HEIGHT="1" ALT="" BORDER="0"></TD>
                        <TD NOWRAP><A HREF="JavaScript:callMonshinChangeOption()"><IMG SRC="../../images/chgInspect.gif" WIDTH="110" HEIGHT="24" ALT="��f�������ڂ̏�Ԃ�ύX���܂�" BORDER="0"></A></TD>
                        <TD NOWRAP><A HREF="JavaScript:callNaishikyou()"><IMG SRC="../../images/cameraCheck.gif" WIDTH="110" HEIGHT="24" ALT="�������`�F�b�N���X�g��o�^���܂�" BORDER="0"></A></TD>
                        
                        <TD NOWRAP>
                        <!--������ �v���O�������o�^�y�у��[�U�[�O���[�v�ʌ����o�^�㐳��Ƀ`�F�b�N ������-->
                        <!--### ���[�U�[�O���[�v�ʑ��쌠���`�F�b�N Start ###-->
                        <% ' if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                            <A HREF="JavaScript:function voi(){};voi()"><IMG SRC="../../images/saveLong.gif" WIDTH="110" HEIGHT="24" ALT="OCR���͓��e��ۑ����܂�" BORDER="0" ONCLICK="JavaScript:parent.list.saveOcrNyuryoku()"></A>
                        <%'  else    %>
                             &nbsp;
                        <%'  end if  %>
                        <!--### ���[�U�[�O���[�v�ʑ��쌠���`�F�b�N End   ###-->
                        </TD>

                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
</FORM>
</BODY>
</HTML>
