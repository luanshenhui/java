<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�ʐڕ��������K�C�h(�e��ʂւ̖ʐڕ������ҏW) (Ver0.0.1)
'		AUTHER  : Eiichi Yamamoto
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
Dim objAfterCare			'�A�t�^�[�P�A���A�N�Z�X�p

'�ʐڕ��͏��
Dim strGuidanceDiv			'�w�����e�敪
Dim strStdContactStcCd		'��^�ʐڕ��̓R�[�h
Dim strArrGuidanceDiv		'�w�����̓R�[�h
Dim strArrStdContactStcCd	'��^�ʐڕ��̓R�[�h
Dim strArrContactStc		'�ʐڕ���

strStdContactStcCd = Array("")

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objAfterCare = Server.CreateObject("HainsAfterCare.AfterCare")

'�����l�̎擾
strGuidanceDiv 			= Request("guidanceDiv")
strStdContactStcCd(0)	= Request("stdContactStcCd")

'�R�[�h�����݂���ꍇ
If( strGuidanceDiv <> "" And strStdContactStcCd(0) <> "" ) Then

	'��^�ʐڕ��͏��̓ǂݍ���
	objAfterCare.SelectStdContactStc strStdContactStcCd, _
									 strGuidanceDiv, _
									 1, _
									 1, _
									 strArrGuidanceDiv, _
									 strArrStdContactStcCd, _
									 strArrContactStc

End If

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�c�̂̌���</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// �a���R�[�h�E���̂̃Z�b�g
function selectContactStc() {

	// �Ăь��E�B���h�E�����݂���ꍇ
	if ( opener != null ) {

		// �e��ʂ̒c�̕ҏW�֐��Ăяo��
		if ( opener.contactStcGuide_setContactStcInfo ) {
			opener.contactStcGuide_setContactStcInfo('<%= strArrGuidanceDiv(0) %>', '<%= strArrStdContactStcCd(0) %>', '<%= strArrContactStc(0) %>' );
		}

		// �e��ʂ̊֐��Ăяo��
		if ( opener.contactStcGuide_CalledFunction != null ) {
			opener.contactStcGuide_CalledFunction();
		}

		opener.winGuideDisease = null;
	}

	// ����ʂ����
	close();
}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 10px 0 0 0; }
</style>
</HEAD>
<BODY ONLOAD="JavaScript:selectContactStc()">
</BODY>
</HTML>
