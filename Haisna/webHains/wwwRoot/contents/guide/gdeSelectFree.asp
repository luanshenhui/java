<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�ėp�����K�C�h(�e��ʂւ̔ėp���ҏW) (Ver0.0.1)
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
Const lngMode = 0		'�������[�h�i0:��ӌ����j
Const blnLock = False	'���R�[�h���b�N(False:���b�N�����j

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objFree				'�ėp���A�N�Z�X�p

Dim strFreeCdKey

'�ėp���
Dim strFreeCd
Dim strFreeClassCd
Dim strFreeName
Dim strFreeDate
Dim strFreeFeild1
Dim strFreeFeild2
Dim strFreeFeild3
Dim strFreeFeild4
Dim strFreeFeild5 

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objFree = Server.CreateObject("HainsFree.Free")

'�����l�̎擾
strFreeCdKey	 			= Request("freeCd")

'�R�[�h�����݂���ꍇ
If( strFreeCdKey <> "" ) Then

	'�ėp���̓ǂݍ���
	objFree.SelectFree	lngMode, _
						strFreeCdKey, _
						strFreeCd, _
						strFreeName, _
						strFreeDate, _
						strFreeFeild1, _
						strFreeFeild2, _
						strFreeFeild3, _
						strFreeFeild4, _
						strFreeFeild5, _
						False, _
						strFreeClassCd

End If

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�ėp���̌���</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// �ėp�R�[�h�E���̂̃Z�b�g
function selectContactStc() {

	// �Ăь��E�B���h�E�����݂���ꍇ
	if ( opener != null ) {

		// �e��ʂ̒c�̕ҏW�֐��Ăяo��
		if ( opener.freeGuide_setFreeInfo ) {
			opener.freeGuide_setFreeInfo('<%= strFreeCd %>', '<%= strFreeClassCd %>', '<%= strFreeName %>', '<%= strFreeDate %>', '<%= strFreeFeild1 %>', '<%= strFreeFeild2 %>', '<%= strFreeFeild3 %>', '<%= strFreeFeild4 %>', '<%= strFreeFeild5 %>' );
		}

		// �e��ʂ̊֐��Ăяo��
		if ( opener.freeGuide_CalledFunction ) {
			opener.freeGuide_CalledFunction();
		}

		opener.winGuideFree = null;
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
