<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       �t�H���[�A�b�v���C�� (Ver0.0.1)
'       AUTHER  : 
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/interviewHeader.inc" -->
<!-- #include virtual = "/webHains/includes/editCsGrp.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g

'�O��ʂ��瑗�M�����p�����[�^�l
Dim strWinMode          '�E�B���h�E���[�h
Dim strPubNoteDivCd     '
Dim strDispMode         '
Dim strDispKbn          '
Dim strCmtMode          '
Dim strCsCd             '�R�[�X�R�[�h
Dim strStrYear          '
Dim strStrMonth         '
Dim strStrDay           '
Dim strEndYear          '
Dim strEndMonth         '
Dim strEndDay           '
Dim lngRsvNo            '�\��ԍ��i���񕪁j
Dim strGrpCd            '�O���[�v�R�[�h
Dim lngPageKey          '��������
Dim lngJudClKey         '���������ȕ���
Dim strMotoRsvNo        '�����\���\��ԍ�
Dim strJudFlg           '���茋�ʂ��o�^����Ă��Ȃ��������ڕ\���L��

Dim strAct              '�������
Dim strUrlPara          '�t���[���ւ̃p�����[�^
Dim strUrlPara2         '�t���[���ւ̃p�����[�^

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
strAct              = Request("action")
strWinMode          = Request("winmode")
strPubNoteDivCd     = Request("PubNoteDivCd")
strDispMode         = Request("DispMode")
strDispKbn          = Request("DispKbn")
strCmtMode          = Request("cmtMode")
strCscd             = Request("cscd")
strStrYear          = Request("strYear")
strStrMonth         = Request("strMonth")
strStrDay           = Request("strDay")
strEndYear          = Request("endYear")
strEndMonth         = Request("endMonth")
strEndDay           = Request("endDay")
lngRsvNo            = Request("rsvno")
strGrpCd            = Request("grpcd")
strSelCsGrp         = Request("csgrp")
strMotoRsvNo        = Request("motoRsvNo")
strJudFlg           = Request("judFlg")

'�t���[���ւ̃p�����[�^�ݒ�
strUrlPara = "?winmode=" & strWinMode 
strUrlPara = strUrlPara & "&rsvno=" & lngRsvNo
strUrlPara = strUrlPara & "&grpcd=" & strGrpCd
strUrlPara = strUrlPara & "&cscd=" & strCsCd
strUrlPara = strUrlPara & "&csgrp=" & strSelCsGrp
strUrlPara = strUrlPara & "&PubNoteDivCd=" & strPubNoteDivCd
strUrlPara = strUrlPara & "&DispMode=2"
strUrlPara = strUrlPara & "&DispKbn=1"
strUrlPara = strUrlPara & "&cmtMode=1,1,0,0"
strUrlPara = strUrlPara & "&strYear=" & strStrYear
strUrlPara = strUrlPara & "&strMonth=" & strStrMonth
strUrlPara = strUrlPara & "&strDay=" & strStrDay
strUrlPara = strUrlPara & "&endYear=" & strEndYear
strUrlPara = strUrlPara & "&endMonth=" & strEndMonth
strUrlPara = strUrlPara & "&endDay=" & strEndDay
strUrlPara = strUrlPara & "&motoRsvNo=" & strMotoRsvNo
strUrlPara = strUrlPara & "&judFlg=" & strJudFlg

strUrlPara2 = "/WebHains/contents/comment/commentMainFlame.asp"
strUrlPara2 = strUrlPara2 & "?winmode=0"
strUrlPara2 = strUrlPara2 & "&PubNoteDivCd=" & strPubNoteDivCd
strUrlPara2 = strUrlPara2 & "&DispMode=2"
strUrlPara2 = strUrlPara2 & "&DispKbn=1"
strUrlPara2 = strUrlPara2 & "&cmtMode=1,1,0,0"
strUrlPara2 = strUrlPara2 & "&cscd=" & strCsCd
strUrlPara2 = strUrlPara2 & "&strYear=" & strStrYear
strUrlPara2 = strUrlPara2 & "&strMonth=" & strStrMonth
strUrlPara2 = strUrlPara2 & "&strDay=" & strStrDay
strUrlPara2 = strUrlPara2 & "&endYear=" & strEndYear
strUrlPara2 = strUrlPara2 & "&endMonth=" & strEndMonth
strUrlPara2 = strUrlPara2 & "&endDay=" & strEndDay
strUrlPara2 = strUrlPara2 & "&rsvno=" & lngRsvNo

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>�t�H���[�A�b�v</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
    var winComment;

    // ���̓`�F�b�N
    function checkValue( mode ) {

        var mainForm = main.document.entryFollowInfo;    // ���C����ʂ̃t�H�[���G�������g
        var titleForm  = header.document.titleForm; // �w�b�_��ʂ̃t�H�[���G�������g

        for ( var ret = false; ; ) {

            // �\����f���̕K�{�`�F�b�N
            if ( titleForm.rsvHistory.value == '' ) {
                alert( '�\����f�����w�肵�ĉ������B' );
                break;
            }
            ret = true;
            break;
        }

        return ret;

    }

    // submit����
    function submitForm( mode ) {

        // �������[�h��ݒ肷��
        var mainForm = main.document.entryFollowInfo;    // ���C����ʂ̃t�H�[���G�������g
        var titleForm  = header.document.titleForm; // �w�b�_��ʂ̃t�H�[���G�������g
        mainForm.action.value = mode;
        mainForm.rsvno.value = titleForm.rsvno.value;

        // ���C����ʂ�submit
        mainForm.submit();
    <%  If strWinMode = "1" Then  %>
        //opener.submitForm('search');
        opener.replaceForm();
    <%  End If %>
    }

    //�ĕ\��
    function preView() {
        var url;                    // URL������
        var titleForm  = header.document.titleForm;     // �w�b�_��ʂ̃t�H�[���G�������g
        var mainForm = main.document.entryFollowInfo;   // ���C����ʂ̃t�H�[���G�������g

        url = '/webHains/contents/follow/followInfoTop.asp?';
        url = url + 'winmode=' + '1';
        url = url + '&rsvno=' + titleForm.rsvno.value;
        url = url + '&grpcd=' + '<%= strGrpCd %>';
        url = url + '&PubNoteDivCd=' + '<%= strPubNoteDivCd %>';
        url = url + '&DispMode=' + '<%= strDispMode %>';
        url = url + '&DispKbn=' + '<%= strDispKbn %>';
        url = url + '&cmtMode=' + '<%= strCmtMode %>';
        url = url + '&cscd=' + '<%= strCsCd %>';
        url = url + '&strYear=' + '<%= strStrYear %>';
        url = url + '&strMonth=' + '<%= strStrMonth %>';
        url = url + '&strDay=' + '<%= strStrDay %>';
        url = url + '&endYear=' + '<%= strStrYear %>';
        url = url + '&endMonth=' + '<%= strStrMonth %>';
        url = url + '&endDay=' + '<%= strStrDay %>';
        url = url + '&csgrp=' + '<%= strSelCsGrp %>';
        url = url + '&judFlg=' + '<%= strJudFlg %>';

    //  parent.location.href(url);
    }

    //�R�����g�ꗗ�i�`���[�g���j�Ăяo��
    function callCommentList() {
        var url;                        // URL������
        var opened = false;             // ��ʂ��J����Ă��邩
        var dialogWidth = 1000, dialogHeight = 600;
        var dialogTop, dialogLeft;

        url = '/WebHains/contents/comment/commentMainFlame.asp?';
        url = url + 'winmode=' + '1';
        url = url + '&rsvno=' + '<%= lngRsvNo %>';
        url = url + '&grpcd=' + '<%= strGrpCd %>';
        url = url + '&PubNoteDivCd=500';
        url = url + '&DispMode=2';
        url = url + '&DispKbn=1';
        url = url + '&cmtMode=1,1,0,0';
        url = url + '&cscd=' + '<%= strCsCd %>';
        url = url + '&strYear=' + '<%= strStrYear %>';
        url = url + '&strMonth=' + '<%= strStrMonth %>';
        url = url + '&strDay=' + '<%= strStrDay %>';
        url = url + '&endYear=' + '<%= strStrYear %>';
        url = url + '&endMonth=' + '<%= strStrMonth %>';
        url = url + '&endDay=' + '<%= strStrDay %>';

        //parent.location.href(url);

        // ���łɃK�C�h���J����Ă��邩�`�F�b�N
        if ( winComment ) {
            if ( !winComment.closed ) {
                opened = true;
            }
        }

        // ��ʂ𒆉��ɕ\�����邽�߂̌v�Z
        dialogTop  = (screen.height/2)-300;
        dialogLeft = (screen.width/2)-480;

        // �J����Ă���ꍇ�͉�ʂ�REPLACE���A�����Ȃ��ΐV�K��ʂ��J��
        if ( opened ) {
            winComment.focus();
            winComment.location.replace( url );
        } else {
            winComment = window.open( url, '', 'width=' + dialogWidth + ',height=' + dialogHeight + ',top=' + dialogTop + ',left=' + dialogLeft + ',status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
        }

    }


//-->
</SCRIPT>
<script type="text/javascript">
var params = {
    action:       "<%= strAct %>",
    PubNoteDivCd: "<%= strPubNoteDivCd %>",
    DispMode:     "<%= strDispMode %>",
    DispKbn:      "<%= strDispKbn %>",
    cmtMode:      "<%= strCmtMode %>",
    cscd:         "<%= strCscd %>",
    strYear:      "<%= strStrYear %>",
    strMonth:     "<%= strStrMonth %>",
    strDay:       "<%= strStrDay %>",
    endYear:      "<%= strEndYear %>",
    endMonth:     "<%= strEndMonth %>",
    endDay:       "<%= strEndDay %>",
    rsvno:        "<%= lngRsvNo %>",
    winmode:      "<%= strWinMode %>",
    grpcd:        "<%= strGrpCd %>",
    csgrp:        "<%= strSelCsGrp %>",
    motoRsvNo:    "<%=strMotoRsvNo%>",
    judFlg:       "<%=strJudFlg%>"
}
</script>
</HEAD>
<FRAMESET ROWS="<%=IIf(strWinMode=1,185,130) & ",*" %> BORDER="0" FRAMESPACING="0" FRAMEBORDER="no">
    <FRAME NAME="header"    SRC="followInfoHeader.asp<%=strUrlPara%>">
    <FRAME NAME="main"      SRC="followInfoBody.asp<%=strUrlPara%>">
</FRAMESET>
</HTML>
