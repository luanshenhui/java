<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       ����K�C�h (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"     -->
<!-- #include virtual = "/webHains/includes/common.inc"           -->
<!-- #include virtual = "/webHains/includes/EditJudClassList.inc" -->
<!-- #include virtual = "/webHains/includes/EditPageNavi.inc"     -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objJud		'����A�N�Z�X�p

Dim strJudCd	'����R�[�h
Dim strJudSName	'���藪��
Dim strJudRName	'�񍐏��p���薼        
Dim lngCount	'���萔
Dim i			'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objJud = Server.CreateObject("HainsJud.Jud")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>����K�C�h</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// ����R�����g�R�[�h�E����R�����g���͂̃Z�b�g
function selectJud( judCd, judSName, judRName ) {

	// �Ăь��E�B���h�E�����݂��Ȃ���Ή������Ȃ�
	if ( opener == null ) {
		close();
		return;
	}

	// ������ҏW
	opener.judGuide_setJudInfo( judCd, judSName, judRName );

	// ��ʂ����
	opener.judGuide_closeGuideJud();

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 15px 0 0 15px; }
</style>
</HEAD>
<BODY>
�����I�����ĉ������B<BR><BR>
<%
Do
	'�S�����ǂݍ���
	lngCount = objJud.SelectJudList(strJudCd, strJudSName, strJudRName)
	If lngCount = 0 Then
		Exit Do
	End If
%>
	<TABLE BORDER="0" CELLPADDING="3" CELLSPACING="0">
<%
		For i = 0 To lngCount - 1
%>
			<TR>
				<TD><A HREF="javascript:selectJud('<%= strJudCd(i) %>','<%= strJudSName(i) %>','<%= strJudRName(i) %>' )"><%= strJudCd(i) %></TD>
				<TD><A HREF="javascript:selectJud('<%= strJudCd(i) %>','<%= strJudSName(i) %>','<%= strJudRName(i) %>' )"><%= strJudSName(i) %></TD>
			</TR>
<%
		Next
%>
	</TABLE>
<%
	Exit Do
Loop
%>
<BR>
<A HREF="JavaScript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z������"></A>
</BODY>
</HTML>
