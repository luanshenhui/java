<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �����K���w�b�_  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�p�����[�^
Dim	strWinMode			'�E�B���h�E���[�h
Dim lngRsvNo			'�\��ԍ��i���񕪁j

Dim strAct				'�������
Dim strUrlPara			'�t���[���ւ̃p�����[�^

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
strAct              = Request("action")
strWinMode			= Request("winmode")
lngRsvNo			= Request("rsvno")



'�t���[���ւ̃p�����[�^�ݒ�
strUrlPara = "?winmode=" & strWinMode 
strUrlPara = strUrlPara & "&rsvno=" & lngRsvNo
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>��f����</TITLE>
<script type="text/javascript">
var params = {
    action:  "<%= strAct %>",
    rsvno:   "<%= lngRsvNo %>",
    winmode: "<%= strWinMode %>"
};
</script>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
</HEAD>
<FRAMESET BORDER="0" FRAMESPACING="0" FRAMEBORDER="no" ROWS="<%=IIf(strWinMode=1,130,65)%>,*">
	<FRAME NAME="header" SRC="MonshinNyuryokuHeader.asp<%=strUrlPara%>">
	<FRAME NAME="bodyview"  SRC="MonshinNyuryokuBody.asp<%=strUrlPara%>">
</FRAMESET>
</HTML>
