<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		���������K�C�h(�e��ʂւ̎������ҏW) (Ver0.0.1)
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
Dim objOrgRoom		'�������A�N�Z�X�p

'�������
Dim strOrgCd1		'�c�̃R�[�h1
Dim strOrgCd2		'�c�̃R�[�h2
Dim strOrgBsdCd		'���ƕ��R�[�h
Dim strOrgRoomCd	'�����R�[�h
Dim strOrgRoomName	'��������
Dim strOrgRoomKName	'�����J�i����
Dim strOrgKName		'�c�̃J�i����
Dim strOrgName		'�c�̖���
Dim strOrgSName		'����
Dim strOrgBsdKName	'���ƕ��J�i����
Dim strOrgBsdName	'���ƕ�����

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objOrgRoom = Server.CreateObject("HainsOrgRoom.OrgRoom")

'�����l�̎擾
strOrgCd1    = Request("orgCd1")
strOrgCd2    = Request("orgCd2")
strOrgBsdCd  = Request("orgBsdCd")
strOrgRoomCd = Request("orgRoomCd")

'�c�́E���ƕ��E�����R�[�h�����݂���ꍇ
If strOrgCd1 <> "" And strOrgCd2 <> "" And strOrgBsdCd <> "" And strOrgRoomCd <> "" Then

	'�������ǂݍ���
	objOrgRoom.SelectOrgRoom strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgRoomName, strOrgRoomKName, strOrgKName, strOrgName, strOrgSName, strOrgBsdKName, strOrgBsdName

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
function selectOrgRoom() {

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
<BODY ONLOAD="javascript:selectOrgRoom()">
</BODY>
</HTML>
