<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		���茒�f�ʐڎx�����C�� (Ver0.0.1)
'		AUTHER  : 
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/interviewHeader.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g

'�O��ʂ��瑗�M�����p�����[�^�l
Dim lngRsvNo        '�\��ԍ�

Dim strURL          'URL������
Dim mainURL         'URL������

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
lngRsvNo    = Request("rsvNo")

'�����\����URL�Z�b�g
mainURL = "specialJudView.asp?rsvNo=" & lngRsvNo
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML lang="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Adobe GoLive 6">
<TITLE>�ʐڎx��</TITLE>
</HEAD>
<FRAMESET ROWS="125,*" BORDER="0" FRAMESPACING="0" FRAMEBORDER="no">
<%
    strURL = "specialJudHeader.asp"
    strURL = strURL & "?rsvNo=" & lngRsvNo
%>
    <FRAME SRC="<%= strURL %>" NAME="header" NORESIZE>
    <FRAME SRC="<%= mainURL %>" NAME="main" NORESIZE>
</FRAMESET>
</HTML>
