<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       �t�H���[�A�b�v���C�� (Ver0.0.1)
'       AUTHER  : T.Yaguchi@orbsys.co.jp
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
lngPageKey          = IIF(Request("pageKey")="",0,Request("pageKey"))
'#### 2008.12.04 �� �t�H���[�A�b�v�o�^��������Ȃƕw�l�Ȃɕ����ĊǗ��ł���悤�Ɍ��������ǉ��j####
lngJudClKey         = IIF(Request("judClKey")="",1,Request("judClKey"))
strMotoRsvNo        = Request("motoRsvNo")

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
strUrlPara = strUrlPara & "&pageKey=" & lngPageKey
'#### 2008.12.04 �� �t�H���[�A�b�v�o�^��������Ȃƕw�l�Ȃɕ����ĊǗ��ł���悤�Ɍ��������ǉ��j####
strUrlPara = strUrlPara & "&judClKey=" & lngJudClKey
strUrlPara = strUrlPara & "&motoRsvNo=" & strMotoRsvNo

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
strUrlPara2 = strUrlPara2 & "&pageKey=" & lngPageKey

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�t�H���[�A�b�v</TITLE>
<SCRIPT TYPE="text/javascript">
<!--

// ���̓`�F�b�N
function checkValue( mode ) {

    var mainForm = main.document.resultList;    // ���C����ʂ̃t�H�[���G�������g
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
    var mainForm = main.document.resultList;    // ���C����ʂ̃t�H�[���G�������g
    var titleForm  = header.document.titleForm; // �w�b�_��ʂ̃t�H�[���G�������g
    mainForm.action.value = mode;
    mainForm.followUpFlg.value = (titleForm.followUpFlg.checked) ? titleForm.followUpFlg.value:'0';
    mainForm.followCardFlg.value = (titleForm.followCardFlg.checked) ? titleForm.followCardFlg.value:'0';
    mainForm.rsvno.value = titleForm.rsvno.value;

    // ���C����ʂ�submit
    mainForm.submit();

}
// �X�V�ҕ\������
function updUserSet(updUserName, updDateName) {

    header.document.getElementById('updUserName').innerHTML = updUserName;
    header.document.getElementById('updDateName').innerHTML = (updDateName == '') ? '': '(' + updDateName + ')';

}

//�ĕ\��
function preView() {
    var url;                    // URL������
    var titleForm  = header.document.titleForm; // �w�b�_��ʂ̃t�H�[���G�������g
    var mainForm = main.document.resultList;    // ���C����ʂ̃t�H�[���G�������g

    url = '/webHains/contents/followUp/followupTop.asp?';
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
    url = url + '&pageKey=' + titleForm.pageKey.value;
    url = url + '&judClKey=' + titleForm.judClKey.value;

//  parent.location.href(url);
}

//�R�����g�ꗗ�i�`���[�g���j�Ăяo��
function callCommentList() {
    var url;                        // URL������

    url = '/WebHains/contents/comment/commentMainFlame.asp?';
//  url = url + 'winmode=' + '<%= strWinMode %>';
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

    parent.location.href(url);

}

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
    pageKey:      "<%= lngPageKey %>",
    judClKey:     "<%= lngJudClKey %>",
    motoRsvNo:    "<%=strMotoRsvNo%>"
}
//-->
</SCRIPT>
</HEAD>
<FRAMESET ROWS="<%=IIf(strWinMode=1,174,80) & ",*" %> BORDER="0" FRAMESPACING="0" FRAMEBORDER="no">
    <FRAME NAME="header"    SRC="followupHeader.asp<%=strUrlPara%>">
    <FRAME NAME="main"      SRC="followupEditBody.asp<%=strUrlPara%>">
</FRAMESET>
</HTML>
