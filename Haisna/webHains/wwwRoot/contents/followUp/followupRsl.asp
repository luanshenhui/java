<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       �t�H���[�A�b�v���ʓo�^���C�� (Ver0.0.1)
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
'�p�����[�^
Dim strWinMode          '�E�B���h�E���[�h
Dim lngRsvNo            '�\��ԍ��i���񕪁j
Dim lngJudClassCd       '���蕪�ރR�[�h

Dim strAct              '�������
Dim strUrlPara          '�t���[���ւ̃p�����[�^

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
strWinMode          = Request("winmode")
lngRsvNo            = Request("rsvno")
lngJudClassCd       = Request("judclasscd")

'�t���[���ւ̃p�����[�^�ݒ�
strUrlPara = "?winmode=" & strWinMode 
strUrlPara = strUrlPara & "&rsvno=" & lngRsvNo
strUrlPara = strUrlPara & "&judclasscd=" & lngJudClassCd

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�t�H���[�A�b�v���ʓo�^</TITLE>
<SCRIPT TYPE="text/javascript">
<!--

    // submit����
    function submitForm( mode ) {

        // �������[�h��ݒ肷��
//        var mainForm = main.document.resultList;    // ���C����ʂ̃t�H�[���G�������g
//        var titleForm  = header.document.titleForm; // �w�b�_��ʂ̃t�H�[���G�������g
//        mainForm.action.value = mode;
//        mainForm.followUpFlg.value = (titleForm.followUpFlg.checked) ? titleForm.followUpFlg.value:'0';
//        mainForm.followCardFlg.value = (titleForm.followCardFlg.checked) ? titleForm.followCardFlg.value:'0';
//        mainForm.rsvno.value = titleForm.rsvno.value;
//
//        // ���C����ʂ�submit
//        mainForm.submit();

    }

var params = {
    winmode:    "<%= strWinMode %>",
    rsvno:      "<%= lngRsvNo %>",
    judclasscd: "<%= lngJudClassCd %>"
};
//-->
</SCRIPT>

</HEAD>
<FRAMESET ROWS="<%=IIf(strWinMode=1,174,80) & ",*" %> BORDER="0" FRAMESPACING="0" FRAMEBORDER="no">
    <FRAME NAME="header"    SRC="followupRslHeader.asp<%=strUrlPara%>">
    <FRAME NAME="main"      SRC="followupRslEditBody.asp<%=strUrlPara%>">
</FRAMESET>
</HTML>
