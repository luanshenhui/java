<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�ʐڎx���w�b�_�\�� (Ver0.0.1)
'		AUTHER  : H.Kamata@FFCS
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�O��ʂ��瑗�M�����p�����[�^�l
Dim strRsvNo		'�\��ԍ�
Dim lngIndex		'�C���f�b�N�X�i��ʑI���R���{�j

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
strRsvNo    = Request("rsvno")
lngIndex    = Request("index")

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="x-ua-compatible" content="IE=10" >
<TITLE>�ʐڎx���w�b�_</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<STYLE TYPE="text/css">
td.prttab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY>
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<!-- #include virtual = "/webHains/includes/interviewHeader.inc" -->
<%
	'�ʐڎx���w�b�_�[�C���N���[�h���Ă�
	Call interviewHeader(strRsvNo, 1)
%>
<SCRIPT TYPE="text/javascript">
<!--
	var myForm =	document.headerForm;
	myForm.selecturl.selectedIndex = '<%= lngIndex %>';
//-->
</SCRIPT>
</BODY>
</HTML>
