<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		����R�����g�K�C�h(�e��ʂւ̔���R�����g���ҏW) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objJudCmtStc	'����R�����g���A�N�Z�X�p

'����R�����g���
Dim strJudCmtCd		'����R�����g�R�[�h
Dim strJudCmtStc	'����R�����g����
Dim strJudClassCd	'���蕪�ރR�[�h
Dim strGuidanceCd	'�w�����e�R�[�h
Dim strGuidanceStc	'�w�����e
Dim strJudCd		'����R�[�h
Dim strJudSName		'���藪��

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objJudCmtStc = Server.CreateObject("HainsJudCmtStc.JudCmtStc")

'�����l�̎擾
strJudCmtCd = Request("judCmtCd")

'����R�����g�R�[�h�����݂���ꍇ
If strJudCmtCd <> "" Then

	'����R�����g���ǂݍ���
	objJudCmtStc.SelectJudCmtStc strJudCmtCd, strJudCmtStc, strJudClassCd, strGuidanceCd, strGuidanceStc, strJudCd, strJudSName

End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>����R�����g�̌���</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// ����R�����g���̃Z�b�g
function selectJudCmt() {

	// �Ăь��E�B���h�E�����݂���ꍇ
	if ( opener != null ) {

		// �e��ʂ̒c�̕ҏW�֐��Ăяo��
		if ( opener.jcmGuide_setJudCmtInfo ) {
			opener.jcmGuide_setJudCmtInfo('<%= strJudCmtCd %>','<%= strJudCmtStc %>','<%= strGuidanceCd %>','<%= strGuidanceStc %>','<%= strJudCd %>','<%= strJudSName %>');
		}

		opener.jcmGuide_closeGuideJcm();

	} else {
		close();
	}

}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 10px 0 0 0; }
</style>
</HEAD>
<BODY ONLOAD="JavaScript:selectJudCmt()">
</BODY>
</HTML>
