<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   ���ʓ��� (Ver0.0.1)
'	   AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
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
Dim strMode			'���͑Ώۃ��[�h
Dim strCode			'���͑ΏۃR�[�h
Dim lngCslYear		'��f��(�N)
Dim lngCslMonth		'��f��(��)
Dim lngCslDay		'��f��(��)
Dim strCsCd			'�R�[�X
Dim strSortKey		'�\����
Dim strCntlNo		'�Ǘ��ԍ�
Dim strDayId		'����ID
Dim strNoPrevNext	'�O���f�҂ւ̑J�ڂ��s��Ȃ�
Dim strEcho			'�L�����҂͎����Œ����g�����\���o�͂���ꍇ��"1"

Dim strURL			'URL������

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�����l�̎擾
strActMode    = Request("actMode")
strDispMode   = Request("dispMode")
strRsvNo      = Request("rsvNo")
strMode       = Request("mode")
strCode       = Request("code")
lngCslYear    = CLng("0" & Request("cslYear") )
lngCslMonth   = CLng("0" & Request("cslMonth"))
lngCslDay     = CLng("0" & Request("cslDay")  )
strCsCd       = Request("csCd")
strSortKey    = Request("sortKey")
strCntlNo     = Request("cntlNo")
strDayId      = Request("dayId")
strNoPrevNext = Request("noPrevNext")
strEcho       = Request("echo")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>���ʓ���</TITLE>
</HEAD>
<%
'�O����f�ґJ�ڃ��[�h�̏ꍇ�̓t���[��������s��
If strNoPrevNext = "" Then
%>
	<FRAMESET ROWS="30,*" BORDER="1" FRAMESPACING="0" FRAMEBORDER="yes">
		<FRAME SRC="rslNavibar.asp" name="header">
		<FRAMESET COLS="300,*" BORDER="1" FRAMESPACING="0" FRAMEBORDER="yes">
<%
			'��f�҈ꗗURL�̕ҏW
			strURL = "rslDailyList.asp"
			strURL = strURL & "?actMode="  & strActMode
			strURL = strURL & "&cslYear="  & lngCslYear
			strURL = strURL & "&cslMonth=" & lngCslMonth
			strURL = strURL & "&cslDay="   & lngCslDay
			strURL = strURL & "&csCd="     & strCsCd
			strURL = strURL & "&sortKey="  & strSortKey
			strURL = strURL & "&cntlNo="   & strCntlNo
%>
			<FRAME SRC="<%= strURL %>" name="list">
<%
			strURL = ""

			'�ۑ��������̂݁A���ʓ��̓t���[���̏����\�����s��
			If strActMode = ACTMODE_SAVEEND Then

				'���ʓ���URL�̕ҏW
				strURL = "rslDetail.asp"
				strURL = strURL & "?actMode="  & strActMode
				strURL = strURL & "&dispMode=" & strDispMode
				strURL = strURL & "&rsvNo="    & strRsvNo
				strURL = strURL & "&mode="     & strMode
				strURL = strURL & "&code="     & strCode
				strURL = strURL & "&cslYear="  & lngCslYear
				strURL = strURL & "&cslMonth=" & lngCslMonth
				strURL = strURL & "&cslDay="   & lngCslDay
				strURL = strURL & "&csCd="     & strCsCd
				strURL = strURL & "&sortKey="  & strSortKey
				strURL = strURL & "&cntlNo="   & strCntlNo
				strURL = strURL & "&dayId="    & strDayId
				strURL = strURL & "&echo="     & strEcho

			End If
%>
			<FRAME SRC="<%= strURL %>" name="result">
		</FRAMESET>
	</FRAMESET>
<%
'�O����f�Ҕ�J�ڃ��[�h�̏ꍇ�̓t���[��������s��Ȃ�
'(���ۂ͗��𐧌�̂��߁A��ʑS�̂��P�̎q�t���[���Ő�߂�)
Else
%>
	<FRAMESET BORDER="1" FRAMESPACING="0" FRAMEBORDER="yes">
<%
		'���ʓ���URL�̕ҏW
		strURL = "rslDetail.asp"
		strURL = strURL & "?actMode="    & strActMode
		strURL = strURL & "&dispMode="   & strDispMode
		strURL = strURL & "&rsvNo="      & strRsvNo
		strURL = strURL & "&mode="       & strMode
		strURL = strURL & "&code="       & strCode
		strURL = strURL & "&cslYear="    & lngCslYear
		strURL = strURL & "&cslMonth="   & lngCslMonth
		strURL = strURL & "&cslDay="     & lngCslDay
		strURL = strURL & "&cntlNo="     & strCntlNo
		strURL = strURL & "&dayId="      & strDayId
		strURL = strURL & "&noPrevNext=" & strNoPrevNext
		strURL = strURL & "&echo="       & strEcho
%>
		<FRAME SRC="<%= strURL %>" name="result">
	</FRAMESET>
<%
End If
%>
</HTML>
