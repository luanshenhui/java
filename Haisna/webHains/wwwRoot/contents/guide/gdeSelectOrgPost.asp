<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		���������K�C�h(�e��ʂւ̏������ҏW) (Ver0.0.1)
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
Dim objOrgPost		'�������A�N�Z�X�p

'�������
Dim strOrgCd1		'�c�̃R�[�h�P
Dim strOrgCd2		'�c�̃R�[�h�Q
Dim strOrgBsdCd		'���ƕ��R�[�h
Dim strOrgRoomCd	'�����R�[�h
Dim strOrgPostCd	'�����R�[�h
Dim strOrgPostName	'��������
Dim strOrgPostKName	'�����J�i����
Dim strOrgKName		'�c�̃J�i����
Dim strOrgName		'�c�̖���
Dim strOrgSName		'����
Dim strOrgBsdKName	'���ƕ��J�i����
Dim strOrgBsdName	'���ƕ�����
Dim strOrgRoomName	'��������
Dim strOrgRoomKName	'�����J�i����

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objOrgPost = Server.CreateObject("HainsOrgPost.OrgPost")

'�����l�̎擾
strOrgCd1    = Request("orgCd1")
strOrgCd2    = Request("orgCd2")
strOrgBsdCd  = Request("orgBsdCd")
strOrgRoomCd = Request("orgRoomCd")
strOrgPostCd = Request("orgPostCd")

'�c�́E���ƕ��E�����E�����R�[�h�����݂���ꍇ
If strOrgCd1 <> "" And strOrgCd2 <> "" And strOrgBsdCd <> "" And strOrgRoomCd <> "" And strOrgPostCd <> "" Then

	'�������ǂݍ���
	objOrgPost.SelectOrgPost strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgPostCd, strOrgPostName, strOrgPostKName, strOrgKName, strOrgName, strOrgSName, strOrgBsdKName, strOrgBsdName, strOrgRoomName, strOrgRoomKName

End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�����̌���</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// �����R�[�h�E���̂̃Z�b�g
function selectOrgPost() {

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

		// �e��ʂ̎����ҏW�֐��Ăяo��
		if ( opener.orgPostGuide_setOrgRoomInfo ) {
			opener.orgPostGuide_setOrgRoomInfo('<%= strOrgRoomCd %>', '<%= strOrgRoomName %>');
		}

		// �e��ʂ̏����ҏW�֐��Ăяo��
		if ( opener.orgPostGuide_setOrgPostInfo ) {
			opener.orgPostGuide_setOrgPostInfo('<%= strOrgPostCd %>', '<%= strOrgPostName %>');
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
<BODY ONLOAD="javascript:selectOrgPost()">
</BODY>
</HTML>
