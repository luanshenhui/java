<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�J������K�C�h(�e��ʂւ̘J��������ҏW) (Ver0.0.1)
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
Dim objOrgPost			'�������A�N�Z�X�p

'�J��������
Dim strOrgWkPostSeq		'�J������r�d�p
Dim strOrgWkPostCd		'�J������R�[�h
Dim strOrgWkPostName	'�J���������

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objOrgPost = Server.CreateObject("HainsOrgPost.OrgPost")

'�����l�̎擾
strOrgWkPostSeq = Request("orgWkPostSeq")

'�J������r�d�p�����݂���ꍇ
If strOrgWkPostSeq <> "" Then

	'�J��������ǂݍ���
	objOrgPost.SelectOrgWkPostFromSeq strOrgWkPostSeq, strOrgWkPostCd, strOrgWkPostName

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
// �J��������̃Z�b�g
function selectOrgWkPost() {

	// �Ăь��E�B���h�E�����݂���ꍇ
	if ( opener != null ) {

		// �e��ʂ̒c�̕ҏW�֐��Ăяo��
		if ( opener.orgWkPostGuide_setOrgWkPostInfo ) {
			opener.orgWkPostGuide_setOrgWkPostInfo( '<%= strOrgWkPostSeq %>', '<%= strOrgWkPostName %>' );
		}

		opener.winGuideOrgWkPost = null;
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
<BODY ONLOAD="javascript:selectOrgWkPost()">
</BODY>
</HTML>
