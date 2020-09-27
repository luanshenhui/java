<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'       �t�H���[�A�b�v�w�b�_�\�� (Ver0.0.1)
'       AUTHER  : T.Yaguchi@ORB
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const MODE_SAVE       = "save"      '�������[�h(�ۑ�)
Const MODE_CANCEL     = "cancel"    '�������[�h(��t������)
Const MODE_DELETE     = "delete"    '�������[�h(�폜)
Const CHART_NOTEDIV   = "500"       '�`���[�g���m�[�g���ރR�[�h
Const PUBNOTE_DISPKBN = 1           '�\���敪�����
Const PUBNOTE_SELINFO = 0           '������񁁌l�{��f���

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objConsult          '��f���A�N�Z�X�p
Dim objPubNote          '�m�[�g�N���X
Dim objFollowUp         '�t�H���[�A�b�v�A�N�Z�X�p

'�O��ʂ��瑗�M�����p�����[�^�l
Dim	strWinMode          '�E�B���h�E���[�h
Dim lngRsvNo            '�\��ԍ�
Dim strMotoRsvNo        '�����\���\��ԍ�
Dim lngIndex            '�C���f�b�N�X�i��ʑI���R���{�j

Dim lngStrYear          '��f��(��)(�N)
Dim lngStrMonth         '��f��(��)(��)
Dim lngStrDay           '��f��(��)(��)
Dim strFollowUpFlg      '�t�H���[�Ώێ҃t���O
Dim strFollowCardFlg    '�͂����o�̓t���O
Dim strUpdDate          '�X�V����
Dim strUpdUserName      '�X�V�Җ�
Dim lngRsvHistory       '�\����f��
Dim strUpdUser          '�X�V��

'�m�[�g��񌏐��l���p
Dim vntNoteSeq          'seq
Dim vntPubNoteDivCd     '��f���m�[�g���ރR�[�h
Dim vntPubNoteDivName   '��f���m�[�g���ޖ���
Dim vntDefaultDispKbn   '�\���Ώۋ敪�����l
Dim vntOnlyDispKbn      '�\���Ώۋ敪���΂�
Dim vntDispKbn          '�\���Ώۋ敪
Dim vntUpdDate          '�o�^����
Dim vntNoteUpdUser      '�o�^��
Dim vntUserName         '�o�^�Җ�
Dim vntBoldFlg          '�����敪
Dim vntPubNote          '�m�[�g
Dim vntDispColor        '�\���F
Dim lngChartCnt         '�`���[�g��񌏐�

Dim Ret                 '�߂�l
Dim FolRet              '�߂�l
Dim strPerId            '�lID
Dim strCslDate          '��f��
Dim vntArrHistoryRsvno  '��f���̗\��ԍ��̔z��
Dim vntArrHistoryCslDate    '��f���̎�f���̔z��

Dim vntArrSeq               '�t�H���[�o�͊Ǘ��̂r�d�p�̔z��
Dim vntArrPosCardPrintDate  '�t�H���[�o�͊Ǘ��̏o�͓����̔z��
Dim vntArrPosCardUser       '�t�H���[�o�͊Ǘ��̓o�^�҂̔z��
Dim strPosCardPrintDate     '�t�H���[�o�͊Ǘ��̏o�͓���

Dim lngPageKey          '��������
Dim lngArrPageKey()     '���������̔z��
Dim strArrPageKeyName() '�����������̔z��

'#### 2008.12.04 �� �t�H���[�A�b�v�o�^��������Ȃƕw�l�Ȃɕ����ĊǗ��ł���悤�Ɍ��������ǉ��jStart ####
Dim lngJudClKey             '�����������蕪��
Dim lngArrJudClKey()        '�����������蕪�ނ̔z��
Dim strArrJudClKeyName()    '�����������蕪�ޖ��̔z��
'#### 2008.12.04 �� �t�H���[�A�b�v�o�^��������Ȃƕw�l�Ȃɕ����ĊǗ��ł���悤�Ɍ��������ǉ��jEnd   ####

Dim lngCount            '
Dim lngAllCount         '

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objConsult  = Server.CreateObject("HainsConsult.Consult")
Set objPubNote  = Server.CreateObject("HainsPubNote.PubNote")
Set objFollowUp = Server.CreateObject("HainsFollowUp.FollowUp")

'�����l�̎擾
strWinMode          = Request("winmode")
lngRsvNo            = Request("rsvno")
strMotoRsvNo        = Request("motoRsvNo")
lngIndex            = Request("index")
strFollowCardFlg    = Request("followCardFlg")
strFollowUpFlg      = Request("followUpFlg")
lngRsvHistory       = Request("rsvHistory")
lngPageKey          = Request("pageKey")
strUpdUser          = Session.Contents("userId")
'#### 2008.12.04 �� �t�H���[�A�b�v�o�^��������Ȃƕw�l�Ȃɕ����ĊǗ��ł���悤�Ɍ��������ǉ��j####
lngJudClKey         = Request("judClKey")

Call CreatePageKeyInfo()
'#### 2008.12.04 �� �t�H���[�A�b�v�o�^��������Ȃƕw�l�Ȃɕ����ĊǗ��ł���悤�Ɍ��������ǉ��j####
Call CreateJudClKeyInfo()

'�\��ԍ����w�肳��Ă���ꍇ
If lngRsvNo <> "" Then

    Set objConsult      = Server.CreateObject("HainsConsult.Consult")
    Set objFollowUp     = Server.CreateObject("HainsFollowUp.FollowUp")

    '��f���ǂݍ���
    Ret = objConsult.SelectConsult(lngRsvNo, , strCslDate, strPerId)

    '��f���ǂݍ���
    FolRet = objFollowUp.SelectFollow(lngRsvNo, strFollowUpFlg, strFollowCardFlg, strUpdDate, , strUpdUserName)
    If FolRet = False Then
        strUpdDate     = ""
        strUpdUserName = ""
    End If

'   If Ret = False Then
'       Err.Raise 1000, ,"��f��񂪑��݂��܂���B"
'   End If

    '��x���\�����Ă��Ȃ��ꍇ�͗\��ԍ���ޔ�����
    If strMotoRsvNo = "" Then
        strMotoRsvNo = lngRsvNo
    End If
    '��f�����ǂݍ���
    lngCount = objFollowUp.SelectFollowHistory(strPerId, strMotoRsvNo, vntArrHistoryRsvno, vntArrHistoryCslDate)

    '��f�����Ȃ��ꍇ�͈����̗\��ԍ��A��f����\������
    If lngCount = 0 Then
        vntArrHistoryRsvno   = Array()
        vntArrHistoryCslDate = Array()
        Redim Preserve vntArrHistoryRsvno(0)
        Redim Preserve vntArrHistoryCslDate(0)
        vntArrHistoryRsvno(0)   = lngRsvNo
        vntArrHistoryCslDate(0) = strCslDate
    End If

    '�͂���������ǂݍ���
    lngCount = objFollowUp.SelectFollow_CardPrint(lngRsvNo, _
                                                  vntArrSeq, vntArrPosCardPrintDate, _
                                                  vntArrPosCardUser _
                                                 )
    '�͂��������񂪂Ȃ��ꍇ�͖��o�͂ƕ\������
    If lngCount = 0 Then
        vntArrPosCardPrintDate   = Array()
        Redim Preserve vntArrPosCardPrintDate(0)
        vntArrPosCardPrintDate(0)   = "���o��"
        strPosCardPrintDate         = vntArrPosCardPrintDate(0)
    End If

    Set objConsult = Nothing

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

    '�t�H���[�ΏێҊǗ�����Ǎ���
    If FolRet = True Then
        '��x�ۑ����Ă���ꍇ�̓t�H���[�󋵊Ǘ����璊�o����B
        lngAllCount = objFollowUp.SelectFollow_I(lngRsvNo)

        If lngPageKey = 1 Then
            '���������ɏ]�����茋�ʈꗗ�𒊏o����
            lngCount = objFollowUp.SelectJudHistoryRslList(lngRsvNo)
            lngAllCount = lngAllCount + lngCount
        End If

    Else
    '��x���ۑ����Ă��Ȃ��ꍇ�͔��茋�ʂ��画��̏d�����̂𒊏o����B
        '���������ɏ]�����茋�ʈꗗ�𒊏o����
        lngAllCount = objFollowUp.SelectJudHistoryRslList(lngRsvNo)
    End If

    Set objFollowUp     = Nothing

End If

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �\�������̔z��쐬
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub CreatePageKeyInfo()


    Redim Preserve lngArrPageKey(1)
    Redim Preserve strArrPageKeyName(1)

    lngArrPageKey(0) = 0:strArrPageKeyName(0) = "�ۑ��f�[�^"
    lngArrPageKey(1) = 1:strArrPageKeyName(1) = "�b�ȏ�S��"

End Sub


'#### 2008.12.04 �� �t�H���[�A�b�v�o�^��������Ȃƕw�l�Ȃɕ����ĊǗ��ł���悤�Ɍ��������ǉ��jStart ####
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �\���������蕪�ށi���ȁE�w�l�ȁj�̔z��쐬
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub CreateJudClKeyInfo()

    Redim Preserve lngArrJudClKey(2)
    Redim Preserve strArrJudClKeyName(2)

    lngArrJudClKey(0) = 1:strArrJudClKeyName(0) = "����"
    lngArrJudClKey(1) = 2:strArrJudClKeyName(1) = "�w�l��"
    lngArrJudClKey(2) = 0:strArrJudClKeyName(2) = "���ׂ�"

End Sub
'#### 2008.12.04 �� �t�H���[�A�b�v�o�^��������Ȃƕw�l�Ȃɕ����ĊǗ��ł���悤�Ɍ��������ǉ��jEnd   ####

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�ʐڎx���w�b�_</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
    // �ۑ�����
    function saveFollow() {

        // ���̓`�F�b�N
    //  if ( !top.checkValue( 0 ) ) return;
        if ( !parent.checkValue( 0 ) ) return;

        // �m�F���b�Z�[�W�̕\��
        if ( !confirm('���̓��e�ŕۑ����܂��B��낵���ł����H') ) return;

        // submit����
    //  top.submitForm('<%= MODE_SAVE %>');
        parent.submitForm('<%= MODE_SAVE %>');
    }
    // �`���[�g���\������
    function chartShow() {

    //  top.callCommentList();
        parent.callCommentList();

    }
    var winfolUpdateHistory;        // �E�B���h�E�n���h��
    //�ύX������ʌĂяo��
    function callfolUpdateHistory() {
        var url;                    // URL������
        var opened = false;         // ��ʂ��J����Ă��邩

        url = '/WebHains/contents/followUp/folUpdateHistory.asp?grpno=20';
    //  url = url + '&winmode=' + '<%= strWinMode %>';
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
            winfolUpdateHistory = window.open( url, '', 'width=1000,height=600,status=no,directories=no,menubar=no,resizable=no,toolbar=no' );
        }

    //  parent.location.href(url);

    }

    // �ĕ\������
    function preView() {

        var myForm = document.titleForm;

        if (document.titleForm.rsvHistory.value >= 0) {
            myForm.rsvno.value = myForm.rsvHistory.value;
    //      parent.preView();
            parent.params.rsvno = myForm.rsvno.value;
            parent.params.pageKey = myForm.pageKey.value;

            /** 2008.12.04 �� �t�H���[�A�b�v�o�^��������Ȃƕw�l�Ȃɕ����ĊǗ��ł���悤�Ɍ��������ǉ��jStart **/
            parent.params.judClKey = myForm.judClKey.value;
            /** 2008.12.04 �� �t�H���[�A�b�v�o�^��������Ȃƕw�l�Ȃɕ����ĊǗ��ł���悤�Ɍ��������ǉ��jEnd   **/

            parent.params.motoRsvNo = myForm.motoRsvNo.value;
            common.submitCreatingForm(parent.location.pathname, 'post', '_parent', parent.params);
        }

    }
    // �X�V�ҕ\������
    function updUserSet(updUserName, updDateName) {
        // �������[�h��ݒ肷��
        document.getElementById('updUserName').innerHTML = updUserName;
        document.getElementById('updDateName').innerHTML = updDateName;

    }
    // �q�E�B���h�E�����
    function closeWindow() {

        // �ύX������ʂ����
        if ( winfolUpdateHistory != null ) {
            if ( !winfolUpdateHistory.closed ) {
                winfolUpdateHistory.close();
            }
        }
        winfolUpdateHistory = null;
    }

//-->
</SCRIPT>
<script type="text/javascript" src="/webHains/js/common.js"></script>
<style type="text/css">
	body { margin: <%= IIF(strWinMode = 1,"12","0") %>px 0 0 <%= IIF(strWinMode = 1,"20","5") %>px; }
</style>
<STYLE TYPE="text/css">
td.prttab  { background-color:#ffffff }
</STYLE>
</HEAD>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<BODY ONUNLOAD="javascript:closeWindow()">
<%
    '�u�ʃE�B���h�E�ŕ\���v�̏ꍇ�A�w�b�_�[�����\��
    If strWinMode = 1 Then
%>
<!-- #include virtual = "/webHains/includes/interviewHeader.inc" -->
<%
        Call interviewHeader(lngRsvNo, 0)
    End If
%>

<FORM NAME="titleForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
<INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">
<INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">
<TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="0">
    <TR>
<%
        '�u�ʃE�B���h�E�ŕ\���v�̏ꍇ�̓X�y�[�X�͗v��Ȃ�
        If strWinMode <> 1 Then
%>
            <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="1"></TD>
<%
        End If
%>
        <TD WIDTH="100%">
            <TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
                <TR>
<!--                    <TD NOWRAP BGCOLOR="#ffffff" width="<%= IIF(strWinMode = 1,"65%","795")%>" HEIGHT="15"><B><SPAN CLASS="follow">��</SPAN><FONT COLOR="#000000">�t�H���[�A�b�v�Ɖ�</FONT></B></TD>-->
                    <TD NOWRAP BGCOLOR="#ffffff" width="<%= IIF(strWinMode = 1,"65%","730")%>" HEIGHT="15"><B><SPAN CLASS="follow">��</SPAN><FONT COLOR="#000000">�t�H���[�A�b�v�Ɖ�</FONT></B></TD>
                    <TD NOWRAP BGCOLOR="#ffffff" width="250" HEIGHT="15"><FONT COLOR="#000000">�ŏI�X�V�����F<SPAN ID="updDateName"><%=IIf(strUpdDate="" Or FolRet = False, "" , "(" & strUpdDate & ")")%></SPAN></FONT></TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
</TABLE>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
    <INPUT TYPE="hidden" NAME="motoRsvNo" VALUE="<%=strMotoRsvNo%>">
    <TR>
        <TD HEIGHT="3"></TD>
    </TR>
    <TR>
        <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
            <TR>
<%
                '�u�ʃE�B���h�E�ŕ\���v�̏ꍇ�̓X�y�[�X�͗v��Ȃ�
                If strWinMode <> 1 Then
%>
                    <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="1"></TD>
<%
                End If
%>
<%
                '�`���[�g��񂠂�H
                If lngChartCnt > 0 Then
%>
                    <TD ALIGN="center" BGCOLOR="ffffff" WIDTH="100"><A HREF="javascript:chartShow()"><FONT  SIZE="-1" COLOR="FF00FF">�`���[�g���</FONT></A></TD>
<%
                Else
%>
                    <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="100"><A HREF="javascript:chartShow()"><IMAGE SRC="/webHains/images/chartinfo.gif" ALT="�`���[�g����\�����܂�" HEIGHT="24" WIDTH="100" BORDER="0"></A></TD>
<%
                End If
%>
                <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="1"></TD>
<%
                '�t�H���[��񂠂�H�i�C���j
                If FolRet = False Then
%>
                    <TD NOWRAP WIDTH="35"><B><FONT COLOR="FF00FF">�V�K</FONT></B></TD>
<%
                Else
%>
                    <TD NOWRAP><IMG SRC="/webHains/images/spacer.gif" WIDTH="35" HEIGHT="1"></TD>
<%
                End If
%>
                <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="1"></TD>
                <TD><INPUT TYPE="checkbox" NAME="followCardFlg" VALUE="1" <%= IIf(strFollowCardFlg = "1", " CHECKED","") %>></TD>
                <TD NOWRAP>�t�H���[�A�b�v�͂����o��</TD>
                <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="1"></TD>
                <TD><INPUT TYPE="checkbox" NAME="followUpFlg" VALUE="1" <%= IIf(strFollowUpFlg = "1", " CHECKED","") %>></TD>
                <TD NOWRAP>�t�H���[�A�b�v�Ώێ�</TD>
                <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="<%= IIF(strWinMode = 1,"100","305")%>" HEIGHT="1"></TD>
<%
                If lngAllCount > 0 Then
                    if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then
%>
                        <TD><A HREF="javascript:saveFollow()"><IMG SRC="/webHains/images/save.gif" WIDTH="80" HEIGHT="21" ALT="�ύX�������e��ۑ����܂�"></A></TD>
<%
                    end if
                Else
%>
                <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="80" HEIGHT="1"></TD>
<%
                End If
%>
                <!--<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="1"></TD>-->
                <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="120"><A HREF="javascript:callfolUpdateHistory()"><IMAGE SRC="/webHains/images/updatehistory.gif" ALT="�ύX������ʂ�\�����܂�" HEIGHT="21" WIDTH="100" BORDER="0"></A></TD>
            </TR>
        </TABLE>
    </TR>
    <TR>
        <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
            <TR>
<%
                '�u�ʃE�B���h�E�ŕ\���v�̏ꍇ�̓X�y�[�X�͗v��Ȃ�
                If strWinMode <> 1 Then
%>
                    <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="1"></TD>
<%
                End If
%>
                <TD>����&nbsp;�F&nbsp;</TD>
                <TD COLSPAN=2><%= EditDropDownListFromArray("judClKey", lngArrJudClKey, strArrJudClKeyName, lngJudClKey, NON_SELECTED_DEL) %></TD>
                <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1"></TD>
                <TD COLSPAN=2><%= EditDropDownListFromArray("pageKey", lngArrPageKey, strArrPageKeyName, lngPageKey, NON_SELECTED_DEL) %></TD>
                <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="60" HEIGHT="1"></TD>
                <!--TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="96" HEIGHT="1"></TD-->
                <TD>�͂����o�͓�</TD>
                <TD COLSPAN=2><%= EditDropDownListFromArray("posCardPrintDate", vntArrPosCardPrintDate, vntArrPosCardPrintDate, strPosCardPrintDate, NON_SELECTED_DEL) %></TD>
                <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="1"></TD>
                <TD>�\����f��</TD>
                <TD COLSPAN=2><%= EditDropDownListFromArray("rsvHistory", vntArrHistoryRsvno, vntArrHistoryCslDate, lngRsvNo, NON_SELECTED_DEL) %></TD>
<!--                <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="<%= IIF(strWinMode = 1,IIF(vntArrPosCardPrintDate(0) = "���o��","82","2"),IIF(vntArrPosCardPrintDate(0) = "���o��","287","205"))%>" HEIGHT="1"></TD>-->
                <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="<%= IIF(strWinMode = 1,IIF(vntArrPosCardPrintDate(0) = "���o��","82","2"),IIF(vntArrPosCardPrintDate(0) = "���o��","100","50"))%>" HEIGHT="1"></TD>
                <TD><A HREF="javascript:preView()"><IMG SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="�w������ŕ\��"></A></TD>
                <TD NOWRAP ALIGN="right" BGCOLOR="#ffffff" width="150" HEIGHT="15"><FONT COLOR="#000000">�ŏI�X�V�ҁF<SPAN ID="updUserName"><%=strUpdUserName%></SPAN></FONT></TD>
            </TR>
        </TABLE>
    </TR>
</TABLE>


</FORM>
<SCRIPT TYPE="text/javascript">
<!--
    var myForm =    document.headerForm;

//  myForm.selecturl.selectedIndex = '<%= lngIndex %>';
//-->
</SCRIPT>
</BODY>
</HTML>
