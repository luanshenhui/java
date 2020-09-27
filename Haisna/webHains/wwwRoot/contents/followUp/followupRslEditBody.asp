<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'       �t�H���[�K�C�h (Ver0.0.1)
'       AUTHER  :
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objFollowUp     '�t�H���[�A�b�v�A�N�Z�X�p
Dim objJud          '������A�N�Z�X�p
Dim objSentence     '���͏��A�N�Z�X�p

'�p�����[�^
Dim lngFollowKbn        '�t�H���[�{�݋敪
Dim lngRsvNo            '�\��ԍ�
Dim lngJudClassCd       '����R�[�h
Dim strJudClassName     '���f����
Dim strJudCd            '����
Dim strSecCslDate       '�񎟌�����
Dim strComeFlg          '��
Dim strSecItemCd        '��������
Dim strRsvInfoCd        '�\����
Dim strJudCd2           '����
Dim strQuestionCd       '�A���P�[�g
Dim strfolNote          '���l

Dim strSecCslYear       '�񎟌������i�N�j
Dim strSecCslMonth      '�񎟌������i���j
Dim strSecCslDay        '�񎟌������i���j

Dim lngUS               '���̓R�[�h
Dim lngCT               '���̓R�[�h
Dim lngMRI              '���̓R�[�h
Dim lngEF               '���̓R�[�h
Dim lngBE               '���̓R�[�h
Dim lngTM               '���̓R�[�h
Dim lngETC              '���̓R�[�h
Dim strETC              '���̓R�[�h

Dim strStcCd1           '���̓R�[�h
Dim strShortstc1        '����
Dim strStcCd2           '���̓R�[�h
Dim strShortstc2        '����
Dim strStcCd3           '���̓R�[�h
Dim strShortstc3        '����
Dim strStcCd4           '���̓R�[�h
Dim strShortstc4        '����
Dim strStcCd5           '���̓R�[�h
Dim strShortstc5        '����
Dim strRsvInfoName      '�\����
Dim strQuestionName     '�A���P�[�g��

'����R���{�{�b�N�X
Dim strArrJudCdSeq      '����A��
Dim strArrJudCd         '����R�[�h
Dim strArrWeight        '����p�d��
Dim lngJudListCnt       '���茏��

Dim lngCount            '���R�[�h����

Dim i                   '�C���f�b�N�X
Dim Ret                 '���A�l
Dim rslCnt              '���ʓ��͗��C���f�b�N�X

Dim vntArrSecItemCd     '
Dim vntArrSecItemCd2    '

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objFollowUp     = Server.CreateObject("HainsFollowUp.FollowUp")
Set objJud          = Server.CreateObject("HainsJud.Jud")
Set objSentence     = Server.CreateObject("HainsSentence.Sentence")

'�p�����[�^�l�̎擾
lngJudClassCd   = Request("judClassCd")
strJudClassName = Request("judClassName")
strJudCd        = Request("judCd")
strSecCslDate   = Request("secCslDate")
If strSecCslDate <> "" Then
    strSecCslYear   = Year(strSecCslDate)
    strSecCslMonth  = Month(strSecCslDate)
    strSecCslDay    = Day(strSecCslDate)
End If
rslCnt          = Request("rslCnt")
'if rslCnt = 0 Then
'   rslCnt = 1
'End If


strComeFlg          = Request("comeFlg")
strSecItemCd        = Request("secItemCd")
vntArrSecItemCd     = Split(strSecItemCd,"Z")
vntArrSecItemCd2    = Array()
Redim Preserve vntArrSecItemCd2(5)
i = 0
Do Until i > Ubound(vntArrSecItemCd)
    vntArrSecItemCd2(i) = Trim(vntArrSecItemCd(i))
    i = i +1
Loop
strStcCd1       = vntArrSecItemCd2(0)
strStcCd2       = vntArrSecItemCd2(1)
strStcCd3       = vntArrSecItemCd2(2)
strStcCd4       = vntArrSecItemCd2(3)
strStcCd5       = vntArrSecItemCd2(4)
Ret         = objSentence.SelectSentence("89001", 0, strStcCd1, strShortstc1)
Ret         = objSentence.SelectSentence("89001", 0, strStcCd2, strShortstc2)
Ret         = objSentence.SelectSentence("89001", 0, strStcCd3, strShortstc3)
Ret         = objSentence.SelectSentence("89001", 0, strStcCd4, strShortstc4)
Ret         = objSentence.SelectSentence("89001", 0, strStcCd5, strShortstc5)
strRsvInfoCd    = Request("rsvInfoCd")
Ret         = objSentence.SelectSentence("89002", 0, strRsvInfoCd, strRsvInfoName)
strJudCd2   = Request("judCd2")
strQuestionCd   = Request("questionCd")
Ret         = objSentence.SelectSentence("89003", 0, strQuestionCd, strQuestionName)
strFolNote  = Request("folNote")
'����擾
Call EditJudListInfo

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ����̔z��쐬
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub EditJudListInfo()

    '����ꗗ�擾
    lngJudListCnt = objJud.SelectJudList(strArrJudCd, , , strArrWeight )

    strArrJudCdSeq = Array()
    Redim Preserve strArrJudCdSeq(lngJudListCnt-1)
    For i = 0 To lngJudListCnt-1
        strArrJudCdSeq(i) = i
    Next


End Sub

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�񎟌��f���ʓo�^</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!-- #include virtual = "/webHains/includes/stcGuide.inc"    -->
<!--
    var lngSelectedIndex1;  // �K�C�h�\�����ɑI�����ꂽ�G�������g�̃C���f�b�N�X
    var curYear, curMonth, curDay;  // ���t�K�C�h�Ăяo�����O�̓��t�ޔ�p�ϐ�

    // ���t�K�C�h�܂��̓J�����_�[������ʌĂяo��
    function callCalGuide(index) {

        var myForm = document.folList;  // ����ʂ̃t�H�[���G�������g

        // �K�C�h�Ăяo�����O�̓��t��ޔ�
        curYear  = eval(myForm.secCslYear + index).value;
        curMonth = eval(myForm.secCslMonth + index).value;
        curDay   = eval(myForm.secCslDay + index).value;

        // ���t�K�C�h�\��
        calGuide_showGuideCalendar( 'secCslYear'+index, 'secCslMonth'+index, 'secCslday'+index, dateSelected );

    }

    function dateSelected() {

    }

    // ���̓K�C�h�Ăяo��
    function callStcGuide( index ) {

        var myForm = document.folList;

        // �I�����ꂽ�G�������g�̃C���f�b�N�X��ޔ�(���̓R�[�h�E�����͂̃Z�b�g�p�֐��ɂĎg�p����)
        lngSelectedIndex1 = index;

        // �K�C�h��ʂ̘A����Ɍ������ڃR�[�h��ݒ肷��
        if ( index == 1 ) {
            stcGuide_ItemCd ='89001';
        }
        if ( index == 2 ) {
            stcGuide_ItemCd ='89001';
        }
        if ( index == 3 ) {
            stcGuide_ItemCd ='89001';
        }
        if ( index == 4 ) {
            stcGuide_ItemCd ='89001';
        }
        if ( index == 5 ) {
            stcGuide_ItemCd ='89001';
        }
        if ( index == 6 ) {
            stcGuide_ItemCd ='89002';
        }
        if ( index == 7 ) {
            stcGuide_ItemCd ='89003';
        }

        // �K�C�h��ʂ̘A����ɍ��ڃ^�C�v�i�W���j��ݒ肷��
        stcGuide_ItemType = '0';

        // �K�C�h��ʂ̘A����ɃK�C�h��ʂ���Ăяo����鎩��ʂ̊֐���ݒ肷��
        stcGuide_CalledFunction = setStcInfo;

        // ���̓K�C�h�\��
        showGuideStc();
    }

    // ���̓R�[�h�E�����͂̃Z�b�g
    function setStcInfo() {

        setStc( lngSelectedIndex1, stcGuide_StcCd, stcGuide_ShortStc );

    }

    // ���͂̕ҏW
    function setStc( index, stcCd, shortStc ) {

        var myForm = document.folList;      // ����ʂ̃t�H�[���G�������g
        var objStcCd, objShortStc;          // ���ʁE���͂̃G�������g
        var stcNameElement;                 // ���͂̃G�������g

        // �ҏW�G�������g�̐ݒ�
        if ( index == 1 ) {
            objStcCd        = myForm.stcCd1;
            objShortStc     = myForm.shortStc1;
        }
        if ( index == 2 ) {
            objStcCd        = myForm.stcCd2;
            objShortStc     = myForm.shortStc2;
        }
        if ( index == 3 ) {
            objStcCd        = myForm.stcCd3;
            objShortStc     = myForm.shortStc3;
        }
        if ( index == 4 ) {
            objStcCd        = myForm.stcCd4;
            objShortStc     = myForm.shortStc4;
        }
        if ( index == 5 ) {
            objStcCd        = myForm.stcCd5;
            objShortStc     = myForm.shortStc5;
        }
        if ( index == 6 ) {
            objStcCd        = myForm.rsvInfoCd;
            objShortStc     = myForm.rsvInfoName;
        }
        if ( index == 7 ) {
            objStcCd        = myForm.questionCd;
            objShortStc     = myForm.questionName;
        }

        stcNameElement = 'stcName' + index;

        // �l�̕ҏW
        objStcCd.value   = stcCd;
        objShortStc.value = shortStc;

        if ( document.getElementById(stcNameElement) ) {
            document.getElementById(stcNameElement).innerHTML = shortStc;
        }

    }

    // ���͂̃N���A
    function callStcClr( index ) {

        var myForm = document.folList;      // ����ʂ̃t�H�[���G�������g
        var objStcCd, objShortStc;          // ���ʁE���͂̃G�������g
        var stcNameElement;                 // ���͂̃G�������g

        // �ҏW�G�������g�̐ݒ�
        if ( index == 1 ) {
            objStcCd        = myForm.stcCd1;
            objShortStc     = myForm.shortStc1;
        }
        if ( index == 2 ) {
            objStcCd        = myForm.stcCd2;
            objShortStc     = myForm.shortStc2;
        }
        if ( index == 3 ) {
            objStcCd        = myForm.stcCd3;
            objShortStc     = myForm.shortStc3;
        }
        if ( index == 4 ) {
            objStcCd        = myForm.stcCd4;
            objShortStc     = myForm.shortStc4;
        }
        if ( index == 5 ) {
            objStcCd        = myForm.stcCd5;
            objShortStc     = myForm.shortStc5;
        }
        if ( index == 6 ) {
            objStcCd        = myForm.rsvInfoCd;
            objShortStc     = myForm.rsvInfoName;
        }
        if ( index == 7 ) {
            objStcCd        = myForm.questionCd;
            objShortStc     = myForm.questionName;
        }
        stcNameElement = 'stcName' + index;

        // �l�̕ҏW
        objStcCd.value   = '';
        objShortStc.value = '';

        if ( document.getElementById(stcNameElement) ) {
            document.getElementById(stcNameElement).innerHTML = '';
        }

    }


    // ���͗̈�f�[�^�̃Z�b�g
    function selectList() {

        window.close();

    }


    function saveFollowRsl(){
    }


    function showFollowRsl(rslCnt){
        var myForm = document.folList;      // ����ʂ̃t�H�[���G�������g
        myForm.rslCnt.value = rslCnt;
        myForm.submit();
    }

//-->
</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
</HEAD>
<BODY BGCOLOR="#ffffff">

<!-- #include virtual = "/webHains/includes/followupHeader.inc" -->
<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
    <TR>
        <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">�t�H���[�A�b�v���ʓo�^</FONT></B></TD>
    </TR>
</TABLE>
<TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="500">
    <TR>
        <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
    </TR>
</TABLE>
<%
        Call followupHeader(lngRsvNo)
%>
    <!--BR-->
<FORM NAME="folList" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
    <INPUT TYPE="hidden" NAME="rsvno"           VALUE="<%= lngRsvNo %>">
    <INPUT TYPE="hidden" NAME="judClassCd"      VALUE="<%= lngJudClassCd %>">
    <INPUT TYPE="hidden" NAME="judClassCd"      VALUE="<%= lngJudClassCd %>">
    <INPUT TYPE="hidden" NAME="judClassName"    VALUE="<%= strJudClassName %>">
    <INPUT TYPE="hidden" NAME="judCd"           VALUE="<%= strJudCd %>">
    <INPUT TYPE="hidden" NAME="rslCnt"          VALUE="<%= rslCnt %>">

    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
        <TR ALIGN="left">
            <TD width="*">
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                    <TR align="center">
                        <TD BGCOLOR="#cccccc" width="120">���f����</TD>
                        <TD BGCOLOR="#eeeeee" width="120"><%= strJudClassName %></TD>
                        <TD width="20">&nbsp;</TD>
                        <TD BGCOLOR="#cccccc" width="120">����</TD>
                        <TD BGCOLOR="#eeeeee" width="120"><%= strJudCd %></TD>
                    </TR>
                </TABLE>
            </TD>
            <TD width="400" align="right">
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                    <TR align="right">
                        <TD ALIGN="right">&nbsp;<A HREF="javascript:function voi(){};voi()" ONCLICK="return saveFollowRsl()"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="�񎟌������ʏ��ۑ�"></A>
                        <A HREF="javascript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z��"></A>
                        </TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="2" WIDTH="100%">
        <TR>
            <TD NOWRAP BGCOLOR="#cccccc" ALIGN="center">��Î{��</TD>
            <TD NOWRAP>
                <INPUT TYPE="radio" NAME="followKbn" VALUE="<%= lngFollowKbn %>" <%= IIf(lngFollowKbn = "0", " CHECKED", "") %> ONCLICK="javascript:checkDispKbnAct(0)"  BORDER="0">�񎟌����ꏊ����&nbsp;&nbsp;
                <INPUT TYPE="radio" NAME="followKbn" VALUE="<%= lngFollowKbn %>" <%= IIf(lngFollowKbn = "1", " CHECKED", "") %> ONCLICK="javascript:checkDispKbnAct(1)"  BORDER="0">���Z���^�[&nbsp;&nbsp;
                <INPUT TYPE="radio" NAME="followKbn" VALUE="<%= lngFollowKbn %>" <%= IIf(lngFollowKbn = "2", " CHECKED", "") %> ONCLICK="javascript:checkDispKbnAct(2)"  BORDER="0">�{�@&nbsp;&nbsp;
                <INPUT TYPE="radio" NAME="followKbn" VALUE="<%= lngFollowKbn %>" <%= IIf(lngFollowKbn = "3", " CHECKED", "") %> ONCLICK="javascript:checkDispKbnAct(3)"  BORDER="0">���@
            </TD>
        </TR>
    </TABLE>
    <BR>
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">��������</FONT></B></TD>
        </TR>
    </TABLE>
    <BR>

    
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" BGCOLOR="#999999" WIDTH="100%">
<%
    For i = 0 To rslCnt
%>
        <TR>
            <TD BGCOLOR="#ffffff" WIDTH="100%">
                <TABLE>
                <TR>
                    <TD NOWRAP BGCOLOR=<%= IIf( i mod 2 = 0, "#cccccc", "#eeeeee") %> WIDTH="120">�����N����&nbsp;<%= IIf( rslCnt >= 1, i+1, "") %></TD>
                    <TD>
                        <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                            <TR>
                                <TD NOWRAP ID="gdeDate"><A HREF="javascript:callCalGuide(<%=i%>)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\�����܂�"></A></TD>
                                <TD NOWRAP><A HREF="javascript:calGuide_clearDate('secCslYear', 'secCslMonth', 'secCslDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
                                <TD COLSPAN="4">
                                    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="100%">
                                        <TR>
                                            <TD><%= EditNumberList("secCslYear"&i, YEARRANGE_MIN, YEARRANGE_MAX, strSecCslYear, True) %></TD>
                                            <TD>�N</TD>
                                            <TD><%= EditNumberList("secCslMonth"&i, 1, 12, strSecCslMonth, True) %></TD>
                                            <TD>��</TD>
                                            <TD><%= EditNumberList("secCslDay"&i, 1, 31, strSecCslDay, True) %></TD>
                                            <TD>��</TD>
                                        </TR>
                                    </TABLE>
                                </TD>
                            </TR>
                        </TABLE>
                    </TD>
                </TR>
                <TR>
                    <TD NOWRAP BGCOLOR=<%= IIf( i mod 2 = 0, "#cccccc", "#eeeeee") %>>�������@&nbsp;<%= IIf( rslCnt >= 1, i+1, "") %></TD>
                    <TD>
                        <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                            <TR>
                                <TD NOWRAP>
                                    <INPUT TYPE="checkbox" NAME="chkUS" VALUE="1" <%= IIf( lngUS = "1", "CHECKED", "") %>>US&nbsp;&nbsp;
                                    <INPUT TYPE="checkbox" NAME="chkCT" VALUE="1" <%= IIf( lngCT = "1", "CHECKED", "") %>>CT&nbsp;&nbsp;
                                    <INPUT TYPE="checkbox" NAME="chkMRI" VALUE="1" <%= IIf( lngMRI = "1", "CHECKED", "") %>>MRI&nbsp;&nbsp;
                                    <INPUT TYPE="checkbox" NAME="chkEF" VALUE="1" <%= IIf( lngEF = "1", "CHECKED", "") %>>������&nbsp;&nbsp;
                                    <INPUT TYPE="checkbox" NAME="chkBE" VALUE="1" <%= IIf( lngEF = "1", "CHECKED", "") %>>����&nbsp;&nbsp;
                                    <INPUT TYPE="checkbox" NAME="chkTM" VALUE="1" <%= IIf( lngEF = "1", "CHECKED", "") %>>��ᇃ}�[�J�[&nbsp;&nbsp;
                                    <INPUT TYPE="checkbox" NAME="chkETC" VALUE="1" <%= IIf( lngETC = "1", "CHECKED", "") %>>���̑�&nbsp;
                                    <INPUT TYPE="text" NAME="txtETC" SIZE="50" MAXLENGTH="50" VALUE="<%=strEtc%>" STYLE="ime-mode:active;">
                                </TD>
                            </TR>
                        </TABLE>
                    </TD>
                </TR>
                <TR>
                    <TD NOWRAP BGCOLOR=<%= IIf( i mod 2 = 0, "#cccccc", "#eeeeee") %>>�f�f��&nbsp;<%= IIf( rslCnt >= 1, i+1, "") %></TD>
                    <TD>
                        <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                            <TR>
                                <TD NOWRAP>
                                    ���햼�F&nbsp;
                                    <SELECT NAME="secArea">
                                        <OPTION VALUE="">���I��</OPTION>
                                    </SELECT>&nbsp;&nbsp;&nbsp;&nbsp;
                                    �������F&nbsp;
                                    <SELECT NAME="secDisease">
                                        <OPTION VALUE="">���I��</OPTION>
                                    </SELECT>&nbsp;&nbsp;&nbsp;&nbsp;
                                    ���̑��F&nbsp;
                                    <INPUT TYPE="text" NAME="txtShindan" SIZE="50" MAXLENGTH="50" VALUE="" STYLE="ime-mode:active;">
                                </TD>
                            </TR>
                        </TABLE>
                    </TD>
                </TR>
                <TR>
                    <TD NOWRAP BGCOLOR=<%= IIf( i mod 2 = 0, "#cccccc", "#eeeeee") %>>���Õ��j&nbsp;<%= IIf( rslCnt >= 1, i+1, "") %></TD>
                    <TD>
                        <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                            <TR>
                                <TD NOWRAP>
                                    <INPUT TYPE="radio" NAME="reloadMode" VALUE="1" BORDER="0">�����ʉ@��&nbsp;&nbsp;
                                    <INPUT TYPE="radio" NAME="reloadMode" VALUE="2" BORDER="0">���u�s�v&nbsp;&nbsp;<br>
                                    <INPUT TYPE="radio" NAME="reloadMode" VALUE="3" BORDER="0">�o�ߊώ@&nbsp;&nbsp;
                                    <INPUT TYPE="radio" NAME="reloadMode" VALUE="4" BORDER="0">1�N�㌒�f&nbsp;&nbsp;
                                    <INPUT TYPE="radio" NAME="reloadMode" VALUE="5" BORDER="0">���@�Љ�&nbsp;&nbsp;<br>
                                    <INPUT TYPE="radio" NAME="care"       VALUE="1" BORDER="0">�M�@&nbsp;&nbsp;
                                    <INPUT TYPE="radio" NAME="care"       VALUE="2" BORDER="0">���@&nbsp;&nbsp;�i&nbsp;&nbsp;
                                    <INPUT TYPE="radio" NAME="reloadMode" VALUE="6" BORDER="0">�ʉ@����&nbsp;&nbsp;
                                    <INPUT TYPE="radio" NAME="reloadMode" VALUE="7" BORDER="0">���@����&nbsp;&nbsp;
                                    <INPUT TYPE="radio" NAME="reloadMode" VALUE="8" BORDER="0">�O�Ȏ���&nbsp;&nbsp;
                                    <INPUT TYPE="radio" NAME="reloadMode" VALUE="9" BORDER="0">�������I����&nbsp;&nbsp;�j<br>
                                    <INPUT TYPE="radio" NAME="reloadMode" VALUE="99" BORDER="0">���̑�&nbsp;&nbsp;
                                    <INPUT TYPE="text" NAME="txtReload" SIZE="50" MAXLENGTH="50" VALUE="" STYLE="ime-mode:active;">
                                </TD>
                            </TR>
                        </TABLE>
                    </TD>
                </TR>
                </TABLE>
            </TD>
        </TR>

<%
    Next
%>
    
    </TABLE>

    <TABLE CELLSPACING="2" CELLPADDING="0" BORDER="0" WIDTH="500">
        <TR>
            <TD><INPUT TYPE="button" NAME="rslAdd" VALUE="�����̒ǉ�" size="50" onClick="javascript:showFollowRsl(<%=rslCnt+1%>)"></TD>
        </TR>
    </TABLE>
    
    
    
    <BR>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD BGCOLOR="#ffffff" WIDTH="100%">
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                    <TR>
                        <TD NOWRAP BGCOLOR="#cccccc">�X�e�[�^�X</TD>
                        <TD>
                            <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                                <TR>
                                    <TD NOWRAP>
                                        <INPUT TYPE="radio" NAME="followStatus" VALUE="" BORDER="0">�ُ�Ȃ�&nbsp;&nbsp;&nbsp;&nbsp;
                                        <INPUT TYPE="radio" NAME="followStatus" VALUE="" BORDER="0">�ُ킠��i�t�H���[�Ȃ��j&nbsp;&nbsp;&nbsp;&nbsp;
                                        <INPUT TYPE="radio" NAME="followStatus" VALUE="" BORDER="0">�ُ킠��i�p���t�H���[�j&nbsp;&nbsp;&nbsp;&nbsp;
                                        <INPUT TYPE="radio" NAME="followStatus" VALUE="" BORDER="0">���̑��I���i�A���Ƃꂸ�j
                                    </TD>
                                </TR>
                            </TABLE>
                        </TD>
                    </TR>
                    <TR>
                        <TD NOWRAP WIDTH="120" BGCOLOR="#cccccc">���l</TD>
                        <TD COLSPAN="7"><TEXTAREA NAME="folNote" style="ime-mode:active"  COLS="70" ROWS="4"><%= strfolNote %></TEXTAREA></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
    <BR>
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">��Ë@��</FONT></B></TD>
        </TR>
    </TABLE>
    <BR>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD BGCOLOR="#ffffff" WIDTH="100%">
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                    <TR>
                        <TD NOWRAP BGCOLOR="#cccccc">�a��@��</TD>
                        <TD><INPUT TYPE="text" NAME="followHospital" SIZE="70" MAXLENGTH="70" VALUE="" STYLE="ime-mode:active;"></TD>
                    </TR>
                    <TR>
                        <TD NOWRAP WIDTH="120" BGCOLOR="#cccccc">�S����t</TD>
                        <TD><INPUT TYPE="text" NAME="followDoctor" SIZE="50" MAXLENGTH="50" VALUE="" STYLE="ime-mode:active;"></TD>
                    </TR>
                    <TR>
                        <TD NOWRAP WIDTH="120" BGCOLOR="#cccccc">�Z��</TD>
                        <TD><INPUT TYPE="text" NAME="followAddr" SIZE="100" MAXLENGTH="100" VALUE="" STYLE="ime-mode:active;"></TD>
                    </TR>
                    <TR>
                        <TD NOWRAP WIDTH="120" BGCOLOR="#cccccc">�d�b�ԍ�</TD>
                        <TD><INPUT TYPE="text" NAME="followTel" SIZE="50" MAXLENGTH="50" VALUE="" STYLE="ime-mode:active;"></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>

</FORM>
</BODY>
</HTML>
