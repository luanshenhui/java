<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   ���ʓ��͂Q�y�O���[�v�w��Łz (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const ACTMODE_SAVEEND  = "saveend"	'���샂�[�h(�ۑ�����)

'�O��ʂ��瑗�M�����p�����[�^�l
Dim strActMode		'���샂�[�h
Dim strDispMode		'�\�����(���͕\����:"1"�A���͔�\����:"2")
Dim strRsvNo		'�\��ԍ�
Dim strCode			'���͑ΏۃR�[�h
Dim lngCslYear		'��f��(�N)
Dim lngCslMonth		'��f��(��)
Dim lngCslDay		'��f��(��)
Dim strCsCd			'�R�[�X
Dim strCntlNo		'�Ǘ��ԍ�
Dim strDayId		'����ID
Dim strURL			'URL������

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�����l�̎擾
strActMode    = Request("actMode")
strDispMode   = Request("dispMode")
strRsvNo      = Request("rsvNo")
strCode       = Request("code")
lngCslYear    = CLng("0" & Request("cslYear") )
lngCslMonth   = CLng("0" & Request("cslMonth"))
lngCslDay     = CLng("0" & Request("cslDay")  )
strCsCd       = Request("csCd")
strCntlNo     = Request("cntlNo")
strDayId      = Request("dayId")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>���ʓ���</TITLE>
</HEAD>
	<FRAMESET BORDER="1" FRAMESPACING="0" FRAMEBORDER="yes">
<%
		'���ʓ���URL�̕ҏW
		strURL = "rslDetail2.asp"
		strURL = strURL & "?actMode="    & strActMode
		strURL = strURL & "&dispMode="   & strDispMode
		strURL = strURL & "&rsvNo="      & strRsvNo
		strURL = strURL & "&code="       & strCode
		strURL = strURL & "&cslYear="    & lngCslYear
		strURL = strURL & "&cslMonth="   & lngCslMonth
		strURL = strURL & "&cslDay="     & lngCslDay
		strURL = strURL & "&cntlNo="     & strCntlNo
		strURL = strURL & "&dayId="      & strDayId
'## 2004.02.12 Add By H.Ishihara@FSIT ����t��Ԃł����ʓ��͂ł��郂�[�h�ǉ��i��]��t���́j
		strURL = strURL & "&NoReceipt="  & Request("noReceipt")
'## 2004.02.12 Add End
%>
		<FRAME SRC="<%= strURL %>" name="result">
	</FRAMESET>
</HTML>
