<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�ʐڎx�����C�� (Ver0.0.1)
'		AUTHER  : H.Kamata@ffcs.co.jp
'-----------------------------------------------------------------------------
'========================================
'�Ǘ��ԍ��FSL-SN-Y0101-305
'�C����  �F2011.07.01
'�S����  �FORB)YAGUCHI
'�C�����e�F�w�b�_�[���̃��C�A�E�g������
'========================================
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
Dim lngRsvNo		'�\��ԍ�
Dim lngIndex		'�C���f�b�N�X�i��ʑI���R���{�j

Dim strURL			'URL������
Dim mainURL			'URL������

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
lngRsvNo    = Request("rsvNo")
lngIndex    = Request("index")

'�����\����URL�Z�b�g
strURL = "totalJudView.asp?grpno=0"
strURL = strURL & "&rsvNo=" & lngRsvNo
strURL = strURL & "&winmode=0"

mainURL = IIf( Request("urlname") <> "", Request("urlname"), strURL)

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML lang="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="x-ua-compatible" content="IE=10" >
<TITLE>�ʐڎx��</TITLE>
</HEAD>
<%'#### 2011.07.01 SL-SN-Y0101-305 ADD START ####%>
<!--<FRAMESET ROWS="125,*" BORDER="0" FRAMESPACING="0" FRAMEBORDER="no">-->
<FRAMESET ROWS="120,*" BORDER="0" FRAMESPACING="0" FRAMEBORDER="no">
<%'#### 2011.07.01 SL-SN-Y0101-305 ADD END ####%>
<%
	strURL = "interviewHeader.asp"
	strURL = strURL & "?rsvNo=" & lngRsvNo
	strURL = strURL & "&Index=" & lngIndex
%>
	<FRAME SRC="<%= strURL %>" NAME="header" NORESIZE>
	<FRAME SRC="<%= mainURL %>" NAME="main" NORESIZE>
</FRAMESET>
</HTML>
