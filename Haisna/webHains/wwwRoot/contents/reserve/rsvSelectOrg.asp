<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		��f�c�̂̐ݒ� (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"  -->
<%
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objOrgPost		'�������A�N�Z�X�p

'�����l
Dim strMode			'�������[�h
Dim strPerId		'�l�h�c
Dim strOrgCd1		'�c�̃R�[�h�P
Dim strOrgCd2		'�c�̃R�[�h�Q
Dim strOrgBsdCd		'���ƕ��R�[�h
Dim strOrgRoomCd	'�����R�[�h
Dim strOrgPostCd	'�����R�[�h
Dim strIsrSign		'���ۋL��
Dim strIsrNo		'���۔ԍ�

'�������
Dim strOrgName		'�c�̖���
Dim strOrgSName		'�c�̗���
Dim strOrgBsdName	'���ƕ�����
Dim strOrgRoomName	'��������
Dim strOrgPostName	'��������

Dim strMessage		'���b�Z�[�W
Dim strHTML			'HTML������

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
strIsrSign   = Request("isrSign")
strIsrNo     = Request("isrNo")

'�������ǂݍ���
objOrgPost.SelectOrgPost strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgPostCd, strOrgPostName, , , , strOrgSName, , strOrgBsdName, strOrgRoomName
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>��f�c�̂̐ݒ�</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// �c�̏��̐ݒ�
function setOrgInfo() {

	// �e��ʂ����݂��Ȃ��ꍇ�͉�ʂ����
	if ( !opener ) {
		close();
		return;
	}

	// �e��ʂ̒c�̏��ݒ�֐��Ăяo��
	with ( document.entryForm ) {
		opener.setOrgInfo( orgCd1.value, orgCd2.value, orgSName.value, orgBsdCd.value, orgBsdName.value, orgRoomCd.value, orgRoomName.value, orgPostCd.value, orgPostName.value, isrSign.value, isrNo.value );
	}

	// ��ʂ����
	opener.closeChangeWindow();
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="javascript:setOrgInfo()">
<FORM NAME="entryForm" action="#">
	<INPUT TYPE="hidden" NAME="orgCd1"      VALUE="<%= strOrgCd1      %>">
	<INPUT TYPE="hidden" NAME="orgCd2"      VALUE="<%= strOrgCd2      %>">
	<INPUT TYPE="hidden" NAME="orgSName"    VALUE="<%= strOrgSName    %>">
	<INPUT TYPE="hidden" NAME="orgBsdCd"    VALUE="<%= strOrgBsdCd    %>">
	<INPUT TYPE="hidden" NAME="orgBsdName"  VALUE="<%= strOrgBsdName  %>">
	<INPUT TYPE="hidden" NAME="orgRoomCd"   VALUE="<%= strOrgRoomCd   %>">
	<INPUT TYPE="hidden" NAME="orgRoomName" VALUE="<%= strOrgRoomName %>">
	<INPUT TYPE="hidden" NAME="orgPostCd"   VALUE="<%= strOrgPostCd   %>">
	<INPUT TYPE="hidden" NAME="orgPostName" VALUE="<%= strOrgPostName %>">
	<INPUT TYPE="hidden" NAME="isrSign"     VALUE="<%= strIsrSign     %>">
	<INPUT TYPE="hidden" NAME="isrNo"       VALUE="<%= strIsrNo       %>">
</FORM>
</BODY>
</HTML>
