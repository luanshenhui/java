<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		���ƕ������K�C�h(�e��ʂւ̎��ƕ����ҏW) (Ver0.0.1)
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
Dim objOrgBsd		'���ƕ����A�N�Z�X�p

'�c�́E���ƕ����
Dim strOrgCd1		'�c�̃R�[�h1
Dim strOrgCd2		'�c�̃R�[�h2
Dim strOrgBsdCd		'���ƕ��R�[�h
Dim strOrgBsdKName	'���ƕ��J�i����
Dim strOrgBsdName	'���ƕ�����
Dim strOrgName		'�c�̖���
Dim strOrgSName		'����
Dim strOrgKName		'�c�̃J�i����

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objOrgBsd = Server.CreateObject("HainsOrgBsd.OrgBsd")

'�����l�̎擾
strOrgCd1   = Request("orgCd1")
strOrgCd2   = Request("orgCd2")
strOrgBsdCd = Request("orgBsdCd")

'�c�́E���ƕ��R�[�h�����݂���ꍇ
If strOrgCd1 <> "" And strOrgCd2 <> "" And strOrgBsdCd <> "" Then

	'���ƕ����ǂݍ���
	objOrgBsd.SelectOrgBsd strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgBsdKName, strOrgBsdName, strOrgKName, strOrgName, strOrgSName

End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>���ƕ��̌���</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// ���ƕ��R�[�h�E���̂̃Z�b�g
function selectOrgBsd() {

	// �Ăь��E�B���h�E�����݂���ꍇ
	if ( opener != null ) {

		// �e��ʂ̒c�̕ҏW�֐��Ăяo��
		if ( opener.orgGuide_setOrgInfo ) {
			opener.orgGuide_setOrgInfo('<%= strOrgCd1 %>', '<%= strOrgCd2 %>', '<%= strOrgName %>', '<%= strOrgSName %>', '<%= strOrgKName %>');
		}

		// �e��ʂ̊֐��Ăяo��
		if ( opener.orgGuide_CalledFunction != null ) {
			opener.orgGuide_CalledFunction();
		}

		// �e��ʂ̎��ƕ��ҏW�֐��Ăяo��
		if ( opener.orgPostGuide_setOrgBsdInfo ) {
			opener.orgPostGuide_setOrgBsdInfo('<%= strOrgBsdCd %>', '<%= strOrgBsdName %>');
		}

		opener.winGuideOrg = null;
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
<BODY ONLOAD="JavaScript:selectOrgBsd()">
</BODY>
</HTML>
