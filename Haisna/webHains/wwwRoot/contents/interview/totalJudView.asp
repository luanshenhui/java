<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �������ʕ\���^�C�v�R�`�Q�ƃ��[�h  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
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
Dim	strWinMode			'�E�B���h�E���[�h
Dim lngRsvNo			'�\��ԍ��i���񕪁j
Dim strGrpCd			'�O���[�v�R�[�h
Dim strCsCd				'�R�[�X�R�[�h

Dim strAct				'�������
Dim strUrlPara			'�t���[���ւ̃p�����[�^

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
strAct              = Request("action")
strWinMode			= Request("winmode")
lngRsvNo			= Request("rsvno")
strGrpCd			= Request("grpcd")
strCsCd				= Request("cscd")
strSelCsGrp			= Request("csgrp")

'### 2004/01/07 K.Kagawa �R�[�X���΂�̃f�t�H���g�l�𔻒f����
If strSelCsGrp = "" Then
	Dim objInterView	'�ʐڏ��A�N�Z�X�p
	Dim lngCsGrpCnt		'�R�[�X�O���[�v��
	Dim vntCsGrpCd		'�R�[�X�O���[�v�R�[�h

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

'�t���[���ւ̃p�����[�^�ݒ�
strUrlPara = "?winmode=" & strWinMode 
strUrlPara = strUrlPara & "&rsvno=" & lngRsvNo
strUrlPara = strUrlPara & "&grpcd=" & strGrpCd
strUrlPara = strUrlPara & "&cscd=" & strCsCd
strUrlPara = strUrlPara & "&csgrp=" & strSelCsGrp
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="x-ua-compatible" content="IE=10" >
<TITLE>�����������</TITLE>
<script type="text/javascript">
var params = {
    action:  "<%= strAct %>",
    rsvno:   "<%= lngRsvNo %>",
    cscd:    "<%= strCsCd %>",
    winmode: "<%= strWinMode %>",
    grpcd:   "<%= strGrpCd %>",
    csgrp:   "<%= strSelCsGrp %>"
};
</script>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
</HEAD>
<FRAMESET BORDER="0" FRAMESPACING="0" FRAMEBORDER="no" ROWS="<%=IIf(strWinMode=1,150,65)%>,*">
	<FRAME NAME="header" SRC="totalJudHeader.asp<%=strUrlPara%>">
	<FRAME NAME="bodyview"  SRC="totalJudViewBody.asp<%=strUrlPara%>">
</FRAMESET>
</HTML>
