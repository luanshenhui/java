<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �b�t�o�N�ω� (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editCsGrp.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�p�����[�^
Dim	strWinMode			'�E�B���h�E���[�h
Dim lngRsvNo			'�\��ԍ��i���񕪁j
Dim strGrpNo			'�O���[�vNo
Dim strCsCd				'�R�[�X�R�[�h
Dim strArrItemCd		'�������ڃR�[�h
Dim strArrSuffix		'�T�t�B�b�N�X

Dim strUrlPara			'�t���[���ւ̃p�����[�^

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
strWinMode			= Request("winmode")
strGrpNo			= Request("grpno")
lngRsvNo			= Request("rsvno")
strCsCd				= Request("cscd")
strSelCsGrp			= Request("csgrp")
strArrItemCd		= Request("itemcd")
strArrSuffix		= Request("suffix")

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
strUrlPara = strUrlPara & "&grpno=" & strGrpNo
strUrlPara = strUrlPara & "&cscd=" & strCsCd
strUrlPara = strUrlPara & "&csgrp=" & strSelCsGrp
strUrlPara = strUrlPara & "&itemcd=" & strArrItemCd
strUrlPara = strUrlPara & "&suffix=" & strArrSuffix
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML lang="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="x-ua-compatible" content="IE=10" >
<TITLE>�b�t�o�N�ω�</TITLE>
<script type="text/javascript">
var params = {
    winmode: "<%= strWinMode %>",
    grpno:   "<%= strGrpNo %>",
    rsvno:   "<%= lngRsvNo %>",
    cscd:    "<%= strCsCd %>",
    csgrp:   "<%= strSelCsGrp %>",
    itemcd:  "<%= strArrItemCd %>",
    suffix:  "<%= strArrSuffix %>"
};
</script>
</HEAD>
<FRAMESET BORDER="0" FRAMESPACING="0" FRAMEBORDER="no" ROWS="<%=IIf(strWinMode=1,430,365)%>,*">
	<FRAME NAME="graph"  SRC="CUMainGraph.asp<%=strUrlPara%>">
	<FRAME NAME="result" SRC="CUResult.asp<%=strUrlPara%>">
</FRAMESET>
</HTML>
