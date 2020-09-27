<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'      �������ʕ\���`�Q�ƃ��[�h  (Ver0.0.1)
'      AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editCsGrp.inc" -->
<!-- #include virtual = "/webHains/includes/interviewResult.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�p�����[�^
Dim strWinMode          '�E�B���h�E���[�h
Dim lngRsvNo            '�\��ԍ��i���񕪁j
Dim strGrpNo            '�O���[�vNo
Dim strCsCd             '�R�[�X�R�[�h

Dim strUrlPara          '�t���[���ւ̃p�����[�^

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
strWinMode          = Request("winmode")
strGrpNo            = Request("grpno")
lngRsvNo            = Request("rsvno")
strCsCd             = Request("cscd")
strSelCsGrp         = Request("csgrp")

'### 2004/01/07 K.Kagawa �R�[�X���΂�̃f�t�H���g�l�𔻒f����
If strSelCsGrp = "" Then
    Dim objInterView    '�ʐڏ��A�N�Z�X�p
    Dim lngCsGrpCnt     '�R�[�X�O���[�v��
    Dim vntCsGrpCd      '�R�[�X�O���[�v�R�[�h

    '�R�[�X�O���[�v�擾
    Set objInterView = Server.CreateObject("HainsInterView.InterView")
    lngCsGrpCnt = objInterview.SelectCsGrp( lngRsvNo, vntCsGrpCd )
    If lngCsGrpCnt > 0 Then
        strSelCsGrp = vntCsGrpCd(0)
    Else
        strSelCsGrp = "0"
    End If
    Set objInterView = Nothing
End If

lngEntryMode        = Request("entrymode")
lngEntryMode        = IIf(lngEntryMode="", INTERVIEWRESULT_REFER, lngEntryMode)
'��\���t���O�͎Q�ƃ��[�h�̂Ƃ��L��
If CStr(lngEntryMode) = CStr(INTERVIEWRESULT_REFER) Then
    lngHideFlg = Request("hideflg")
Else
    lngHideFlg = "0"
End If

'�O���[�v���擾
Call GetMenResultGrpInfo(strGrpNo)

'�t���[���ւ̃p�����[�^�ݒ�
strUrlPara = "?winmode=" & strWinMode 
strUrlPara = strUrlPara & "&rsvno=" & lngRsvNo
strUrlPara = strUrlPara & "&grpno=" & strGrpNo
strUrlPara = strUrlPara & "&cscd=" & strCsCd
strUrlPara = strUrlPara & "&csgrp=" & strSelCsGrp
strUrlPara = strUrlPara & "&entrymode=" & lngEntryMode
strUrlPara = strUrlPara & "&hideflg=" & lngHideFlg
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE><%= strMenResultTitle %>�@�������ʕ\��</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<SCRIPT TYPE="text/javascript" language="javascript">
<!--
        /*** 2006.03.08 �� �g���Ă��郂�j�^�[�T�C�Y�ɏ]���ĉ�ʃT�C�Y���� ***/
        //self.moveTo(0,0);
        //if(screen.availWidth == 1024){
        //    self.resizeTo(screen.availWidth-30,screen.availHeight);
        if(screen.availWidth == 1680){
            self.resizeTo(screen.availWidth-230, screen.availHeight-30);
        }else{
        //    self.resizeTo(screen.availWidth-150,screen.availHeight);
            self.resizeTo(screen.availWidth-350,screen.availHeight-150);
        }

var params = {
    winmode:   "<%= strWinMode %>",
    grpno:     "<%= strGrpNo %>",
    rsvno:     "<%= lngRsvNo %>",
    cscd:      "<%= strCsCd %>",
    csgrp:     "<%= strSelCsGrp %>",
    entrymode: "<%= lngEntryMode %>",
    hideflg:   "<%= lngHideFlg %>"
};
//-->

</SCRIPT>
</HEAD>
<%
    Select Case lngMenResultTypeNo
    Case INTERVIEWRESULT_TYPE1
%>
    <FRAMESET BORDER="0" FRAMESPACING="0" FRAMEBORDER="no" ROWS="<%= IIf(strWinMode=1,150,65) %>,*">
        <FRAME NAME="header" SRC="MenResultHeader.asp<%= strUrlPara %>">
        <FRAME NAME="body1"  SRC="MenResultBody1.asp<%= strUrlPara %>">
    </FRAMESET>
<%
    Case INTERVIEWRESULT_TYPE2
%>
    <FRAMESET BORDER="0" FRAMESPACING="0" FRAMEBORDER="no" ROWS="<%= IIf(strWinMode=1,150,65) %>,*,5,*">
        <FRAME NAME="header" SRC="MenResultHeader.asp<%= strUrlPara %>">
        <FRAME NAME="body3"  SRC="<%= IIf(lngEntryMode=INTERVIEWRESULT_REFER,"MenResultBody3.asp","MenResultBody3Entry.asp") %><%= strUrlPara %>">
        <FRAME NAME="blank"  SRC="../common/blank.html">
        <FRAME NAME="body1"  SRC="MenResultBody1.asp<%=strUrlPara%>">
    </FRAMESET>
<%
    Case INTERVIEWRESULT_TYPE3
%>
    <FRAMESET BORDER="0" FRAMESPACING="0" FRAMEBORDER="no" ROWS="<%= IIf(strWinMode=1,150,65) %>,*">
        <FRAME NAME="header" SRC="MenResultHeader.asp<%= strUrlPara %>">
        <FRAME NAME="body3"  SRC="<%= IIf(lngEntryMode=INTERVIEWRESULT_REFER,"MenResultBody3.asp","MenResultBody3Entry.asp") %><%= strUrlPara %>">
    </FRAMESET>
<%
    End Select
%>
</HTML>
