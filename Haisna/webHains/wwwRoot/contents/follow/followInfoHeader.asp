<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'      �t�H���[�A�b�v���� (Ver0.0.1)
'      AUTHER  :
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editPageNavi.inc"    -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const MODE_SAVE       = "save"      '�������[�h(�ۑ�)
Const CHART_NOTEDIV   = "500"       '�`���[�g���m�[�g���ރR�[�h
Const PUBNOTE_DISPKBN = 1           '�\���敪�����
Const PUBNOTE_SELINFO = 0           '������񁁌l�{��f���

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon               '���ʃN���X
Dim objConsult              '��f���A�N�Z�X�p
Dim objPubNote              '�m�[�g�N���X
Dim objFollow               '�t�H���[�A�b�v�A�N�Z�X�p

Dim strWinMode              '�E�B���h�E���[�h
Dim lngRsvNo                '�\��ԍ�
Dim strMotoRsvNo            '�����\���\��ԍ�
Dim strJudFlg               '���茋�ʂ��o�^����Ă��Ȃ��������ڕ\���L��

Dim strMode                 '�������[�h(�����F"search"�A�}��:"insert"�A�X�V:"update")
Dim strAction               '�������(�ۑ��{�^��������:"save"�A�ۑ�������:"saveend")
Dim strMessage              '�G���[���b�Z�[�W

Dim strKey                  '�����L�[
Dim strArrKey               '�����L�[(�󔒂ŕ�����̃L�[�j
Dim strStartCslDate         '����������f�N�����i�J�n�j
Dim strStartYear            '����������f�N�i�J�n�j
Dim strStartMonth           '����������f���i�J�n�j
Dim strStartDay             '����������f���i�J�n�j
Dim strEndCslDate           '����������f�N�����i�I���j
Dim strEndYear              '����������f�N�i�I���j
Dim strEndMonth             '����������f���i�I���j
Dim strEndDay               '����������f���i�I���j
Dim lngRsvHistory           '�\����f��
Dim strUpdUser              '�X�V��

Dim vntItemCd               '�t�H���[�Ώی������ڃR�[�h
Dim vntItemName             '�t�H���[�Ώی������ږ���

Dim strPerId                '�lID
Dim strCslDate              '��f��
Dim vntArrHistoryRsvno      '��f���̗\��ԍ��̔z��
Dim vntArrHistoryCslDate    '��f���̎�f���̔z��

Dim lngItemCount            '�t�H���[�Ώی������ڐ�
Dim lngAllCount
Dim lngCount
Dim i                       '�J�E���^
Dim j

Dim lngStartPos             '�\���J�n�ʒu
Dim lngPageKey              '��������
Dim lngArrPageKey()         '���������̔z��
Dim strArrPageKeyName()     '�����������̔z��

Dim lngArrSendMode()        '�������m�F��Ԃ̔z��
Dim strArrSendModeName()    '�������m�F��Ԗ��̔z��

Dim Ret                     '�֐��߂�l
Dim strURL                  '�W�����v���URL

'�m�[�g��񌏐��l���p
Dim vntNoteSeq              'seq
Dim vntPubNoteDivCd         '��f���m�[�g���ރR�[�h
Dim vntPubNoteDivName       '��f���m�[�g���ޖ���
Dim vntDefaultDispKbn       '�\���Ώۋ敪�����l
Dim vntOnlyDispKbn          '�\���Ώۋ敪���΂�
Dim vntDispKbn              '�\���Ώۋ敪
Dim vntUpdDate              '�o�^����
Dim vntNoteUpdUser          '�o�^��
Dim vntUserName             '�o�^�Җ�
Dim vntBoldFlg              '�����敪
Dim vntPubNote              '�m�[�g
Dim vntDispColor            '�\���F
Dim lngChartCnt             '�`���[�g��񌏐�

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objConsult      = Server.CreateObject("HainsConsult.Consult")
Set objPubNote      = Server.CreateObject("HainsPubNote.PubNote")
Set objFollow       = Server.CreateObject("HainsFollow.Follow")

'�����l�̎擾
strMode             = Request("mode")
strAction           = Request("action")
strJudFlg           = Request("judFlg")

strWinMode          = Request("winmode")
lngRsvNo            = Request("rsvno")
strMotoRsvNo        = Request("motoRsvNo")
lngRsvHistory       = Request("rsvHistory")
lngPageKey          = Request("pageKey")
strUpdUser          = Session.Contents("userId")


'�t�H���[�Ώی������ځi���蕪�ށj���擾
lngItemCount = objFollow.SelectFollowItem(vntItemCd, vntItemName )

'�\��ԍ����w�肳��Ă���ꍇ
If lngRsvNo <> "" Then

    '��f���ǂݍ���
    Ret = objConsult.SelectConsult(lngRsvNo, , strCslDate, strPerId)

    '��x���\�����Ă��Ȃ��ꍇ�͗\��ԍ���ޔ�����
    If strMotoRsvNo = "" Then
        strMotoRsvNo = lngRsvNo
    End If
    '��f�����ǂݍ���
    lngCount = objFollow.SelectFollowHistory(strPerId, strMotoRsvNo, vntArrHistoryRsvno, vntArrHistoryCslDate)

    '��f�����Ȃ��ꍇ�͈����̗\��ԍ��A��f����\������
    If lngCount = 0 Then
        vntArrHistoryRsvno   = Array()
        vntArrHistoryCslDate = Array()
        Redim Preserve vntArrHistoryRsvno(0)
        Redim Preserve vntArrHistoryCslDate(0)
        vntArrHistoryRsvno(0)   = lngRsvNo
        vntArrHistoryCslDate(0) = strCslDate
    End If

    '�`���[�g���̌����擾
    lngChartCnt = objPubNote.SelectPubNote(PUBNOTE_SELINFO,  _
                                        0, "", "",           _
                                        lngRsvNo,            _
                                        "", "", "", "", 0,   _
                                        CHART_NOTEDIV,       _
                                        PUBNOTE_DISPKBN,     _
                                        strUpdUser,          _
                                        vntNoteSeq,          _
                                        vntPubNoteDivCd,     _
                                        vntPubNoteDivName,   _
                                        vntDefaultDispKbn,   _
                                        vntOnlyDispKbn,      _
                                        vntDispKbn,          _
                                        vntUpdDate,          _
                                        vntNoteUpdUser,      _
                                        vntUserName,         _
                                        vntBoldFlg,          _
                                        vntPubNote,          _
                                        vntDispColor )

End If


Set objConsult = Nothing
Set objPubNote = Nothing
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<HTML LANG="ja">

<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>�t�H���[�A�b�v����</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
    var winGuideFollow;     //�t�H���[�A�b�v��ʃn���h��
    var winMenResult;       // �h�b�N���ʎQ�ƃE�B���h�E�n���h��
    var winRslFol;          // �t�H���[���ʓo�^�E�B���h�E�n���h��

    /** ���������ɂ���ʃ��t���b�V�� **/
    function preView() {
        var myForm = document.titleForm;
        var historyCsldate;

        if (document.titleForm.rsvHistory.value >= 0) {

            historyCsldate = myForm.rsvHistory.options[myForm.rsvHistory.selectedIndex].text;
            if(historyCsldate.length == 10){
                parent.params.strYear     = historyCsldate.substr(0,4);
                parent.params.strMonth    = historyCsldate.substr(5,2);
                parent.params.strDay      = historyCsldate.substr(8,2);
                parent.params.endYear     = historyCsldate.substr(0,4);
                parent.params.endMonth    = historyCsldate.substr(5,2);
                parent.params.endDay      = historyCsldate.substr(8,2);
            }

            myForm.rsvno.value = myForm.rsvHistory.value;
            parent.params.rsvno = myForm.rsvno.value;
            parent.params.motoRsvNo = myForm.motoRsvNo.value;
            parent.params.judFlg = myForm.judFlg.value;
            common.submitCreatingForm(parent.location.pathname, 'post', '_parent', parent.params);
        }
    }

    function clickCheck(obj) {
        if(obj.checked==true){
            obj.value="1";
        }else{
            obj.value="";
        }
    }

    /** �t�H���[�o�^���� **/
    function saveFollow() {

        // ���͍��ڃ`�F�b�N
        if ( !parent.checkValue( 0 ) ) return;

        // �m�F���b�Z�[�W�̕\��
        if ( !confirm('���̓��e�ŕۑ����܂��B��낵���ł����H') ) return;

        parent.submitForm('<%= MODE_SAVE %>');
    }


    /** �R�����g�ꗗ�i�`���[�g���j�Ăяo�� **/
    function callCommentList() {
        //alert("�`���[�g���\�����");
        parent.callCommentList();
    }

    var winfolUpdateHistory;        // �E�B���h�E�n���h��
    function callfolUpdateHistory() {
        var url;                    // URL������
        var opened = false;         // ��ʂ��J����Ă��邩

        url = '/WebHains/contents/follow/folUpdateHistory.asp?grpno=20';
        url = url + '&winmode=' + '1';
        url = url + '&rsvno=' + '<%= lngRsvNo %>';

        // ���łɃK�C�h���J����Ă��邩�`�F�b�N
        if ( winfolUpdateHistory ) {
            if ( !winfolUpdateHistory.closed ) {
                opened = true;
            }
        }

        // �J����Ă���ꍇ�͉�ʂ�REPLACE���A�����Ȃ��ΐV�K��ʂ��J��
        if ( opened ) {
            winfolUpdateHistory.focus();
            winfolUpdateHistory.location.replace( url );
        } else {
            winfolUpdateHistory = window.open( url, '', 'width=1010,height=600,status=no,directories=no,menubar=no,resizable=yes,toolbar=no' );
        }

    }

    var winfolReqHistory;
    function callfolReqHistory() {

        var opened = false; // ��ʂ��J����Ă��邩
        var url;            // URL������

        // �˗�������������ʂ�\�����邽��
        url = '/WebHains/contents/follow/followReqHistory.asp?rsvno='+'<%= lngRsvNo %>';
        // ���łɉ�ʂ��J����Ă��邩�`�F�b�N
        if ( winfolReqHistory != null ) {
            if ( !winfolReqHistory.closed ) {
                opened = true;
            }
        }

        // �J����Ă���ꍇ�͉�ʂ�REPLACE���A�����Ȃ��ΐV�K��ʂ��J��
        if ( opened ) {
            winfolReqHistory.focus();
            winfolReqHistory.location.replace(url);
        } else {
            winfolReqHistory = window.open( url, '', 'width=1010,height=600,status=no,directories=no,menubar=no,resizable=no,toolbar=no, scrollbars=yes');
        }
    }

    /** �|�b�v�A�b�v��ʃA�����[�h���̏��� **/
    function closeGuideWindow() {

        //���t�K�C�h�����
        calGuide_closeGuideCalendar();

        if ( winGuideFollow != null ) {
            if ( !winGuideFollow.closed ) {
                winGuideFollow.close();
            }
        }
        winGuideFollow = null;

        if ( winMenResult != null ) {
            if ( !winMenResult.closed ) {
                winMenResult.close();
            }
        }
        winMenResult = null;

        if ( winRslFol != null ) {
            if ( !winRslFol.closed ) {
                winRslFol.close();
            }
        }
        winRslFol = null;

        // �ύX������ʂ����
        if ( winfolUpdateHistory != null ) {
            if ( !winfolUpdateHistory.closed ) {
                winfolUpdateHistory.close();
            }
        }
        winfolUpdateHistory = null;

        // �˗��󗚗���ʂ����
        if ( winfolReqHistory != null ) {
            if ( !winfolReqHistory.closed ) {
                winfolReqHistory.close();
            }
        }
        winfolReqHistory = null;

        return false;
    }


//-->
</SCRIPT>
<script type="text/javascript" src="/webHains/js/common.js"></script>
<style type="text/css">
	body { margin: <%= IIF(strWinMode = 1,"12","0") %>px 0 0 20px; }
</style>
<style>
.follow-midashi {background-color:#CCCCCC;}
</style>
</HEAD>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<BODY ONUNLOAD="JavaScript:closeGuideWindow()">
<!--TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="0"-->
<TABLE WIDTH="95%" BORDER="0" CELLSPACING="0" CELLPADDING="0">
    <TR>
        <TD WIDTH="100%">
            <TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
                <TR>
                    <TD NOWRAP BGCOLOR="#ffffff" WIDTH="100%" HEIGHT="15"><B><SPAN CLASS="demand">��</SPAN><FONT COLOR="#000000">�t�H���[�A�b�v�Ɖ�</FONT></B></TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
</TABLE>
<%
    '�u�ʃE�B���h�E�ŕ\���v�̏ꍇ�A�w�b�_�[�����\��
    If strWinMode = 1 Then
%>
<!-- #include virtual = "/webHains/includes/followupHeader.inc" -->
<%
        Call followupHeader(lngRsvNo)
    End If
%>
<BR>
<FORM NAME="titleForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<INPUT TYPE="hidden" NAME="winmode"     VALUE="<%= strWinMode %>">
<INPUT TYPE="hidden" NAME="rsvno"       VALUE="<%= lngRsvNo %>">
<INPUT TYPE="hidden" NAME="motoRsvNo"   VALUE="<%=strMotoRsvNo%>">
<INPUT TYPE="hidden" NAME="action"      VALUE=""> 
<p>
<span class="follow-midashi">���t�H���[�Ώی�������:</span>
        <%
                '## �ėp�}�X�^�[�ɓo�^����Ă���t�H���[�Ώی��N���ځi���蕪�ށj�\��
                If lngItemCount > 0 Then

                    For i = 0 To UBound(vntItemName)
                        IF i = 0 Then
        %>
                            <%= vntItemName(i)%>
        <%
                        Else
        %>
                            �A<%= vntItemName(i)%>
        <%
                        End if
                    Next
                Else
        %>
                &nbsp;
        <%
                End If
        %>
</p>


<BR>
<TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="0">
    <TR>
<%
    '�`���[�g��񂠂�H
    If lngChartCnt > 0 Then
%>
        <TD ALIGN="left" BGCOLOR="ffffff"><A HREF="javascript:callCommentList()"><IMG SRC="/webHains/images/chartinfo_up.gif" ALT="�`���[�g����\�����܂�" BORDER="0"></A></TD>
<%
    Else
%>
        <TD ALIGN="left" BGCOLOR="ffffff"><A HREF="javascript:callCommentList()"><IMG SRC="/webHains/images/chartinfo.gif" ALT="�`���[�g����\�����܂�" BORDER="0"></A></TD>
<%
    End If
%>
        <TD WIDTH="100" ALIGN="right">�\����f��</TD>
        <TD WIDTH="100" ALIGN="right"><%= EditDropDownListFromArray("rsvHistory", vntArrHistoryRsvno, vntArrHistoryCslDate, lngRsvNo, NON_SELECTED_DEL) %></TD>
        <TD WIDTH="170" ALIGN="right">
            <A HREF="javascript:preView()"><IMG SRC="../../images/b_search.gif" ALT="���̏����Ō���" HEIGHT="24" WIDTH="77" BORDER="0"></A>
            <% If Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" Then %>
                <A HREF="javascript:saveFollow()"><IMG SRC="../../images/save.gif" ALT="�t�H���[�ۑ�" HEIGHT="24" WIDTH="77" BORDER="0"></A>
            <% End If %>

        </TD>
        <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="240">
            <A HREF="javascript:callfolUpdateHistory()"><IMG SRC="../../images/updatehistory.gif" ALT="�ύX������ʂ�\�����܂�" HEIGHT="24" WIDTH="100" BORDER="0"></A>
            <A HREF="javaScript:callfolReqHistory()"><IMG SRC="../../images/printhistory.gif" ALT="���������\�����܂��B"HEIGHT="24" WIDTH="100" BORDER="0"></A>
        </TD>
    </TR>
</TABLE>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
    <TR>
        <TD><INPUT TYPE="checkbox" NAME="judFlg" VALUE="<%= strJudFlg %>"  <%= IIf(strJudFlg = "1", "CHECKED", "") %> onClick="javascript:clickCheck(this)"></TD>
        <TD NOWRAP>���茋�ʂ��o�^����Ă��Ȃ��������ڂ��\��</TD>
    </TR>
</TABLE>
</FORM>
</BODY>
</HTML>