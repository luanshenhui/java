<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�a�������K�C�h(�e��ʂւ̕a�����ҏW) (Ver0.0.1)
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
Dim objDisease		'�a�����A�N�Z�X�p

'�a�����
Dim strDisCd		'�a���R�[�h1
Dim strDisName		'�a��
Dim strSearchChar	'�K�C�h�����p������
Dim strDisDivCd		'�a�ރR�[�h
Dim strDisDivName	'�a�ޖ�

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objDisease = Server.CreateObject("HainsDisease.Disease")

'�����l�̎擾
strDisCd = Request("disCd")
strDisDivCd = Request("disDivCd")

'�a���R�[�h�����݂���ꍇ
If( strDisCd <> "" ) Then

	'�a�����ǂݍ���
	objDisease.SelectDisease strDisCd, strDisName, strSearchChar, strDisDivCd, strDisDivName 

End If

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>���a�̌���</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// �a���R�[�h�E���̂̃Z�b�g
function selectOrg() {

	// �Ăь��E�B���h�E�����݂���ꍇ
	if ( opener != null ) {

		// �e��ʂ̒c�̕ҏW�֐��Ăяo��
		if ( opener.disGuide_setDiseaseInfo ) {
			opener.disGuide_setDiseaseInfo('<%= strDisCd %>', '<%= strDisName %>', '<%= strSearchChar %>', '<%= strDisDivCd %>', '<%= strDisDivName %>');
		}

		// �e��ʂ̊֐��Ăяo��
		if ( opener.disGuide_CalledFunction != null ) {
			opener.disGuide_CalledFunction();
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
<BODY ONLOAD="JavaScript:selectOrg()">
</BODY>
</HTML>
