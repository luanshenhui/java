<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		���茒�f�ʐڎx���w�b�_�\�� (Ver0.0.1)
'		AUTHER  : 
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
Dim strRsvNo        '�\��ԍ�

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
strRsvNo    = Request("rsvno")

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�ʐڎx���w�b�_</TITLE>
<STYLE TYPE="text/css">
td.prttab  { background-color:#ffffff }
</STYLE>
</HEAD>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<!-- #include virtual = "/webHains/includes/specialJudHeader.inc" -->
<BODY>
<FORM NAME="headerForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
<INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= strRsvNo %>">

<%
    '�ʐڎx���w�b�_�[�C���N���[�h���Ă�
    Call specialJudHeader(strRsvNo)
%>
</FORM>
</BODY>
</HTML>
