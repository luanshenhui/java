<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		���ʎQ�� (Ver0.0.1)
'		AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Dim strPerID		'�l�h�c
'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
strPerID = Request("PerID")
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="x-ua-compatible" content="IE=10">
<TITLE>���ʎQ��</TITLE>
</HEAD>

<FRAMESET ROWS="27,*" BORDER="0" FRAMESPACING="0" FRAMEBORDER="0">
	<FRAME SRC="/webHains/contents/inquiry/inqNavibar.asp" NAME="NaviBar" SCROLLING="NO" NORESIZE>
	<FRAMESET cols="320,*">
		<FRAMESET rows="380,*">
			<FRAME src="inqHistory.asp?perID=<%= strPerID %>" name="header" marginwidth="5" marginheight="10" scrolling="auto" noresize>
			<frame src="/webHains/contents/inquiry/inqPerInspection.asp?perID=<%= strPerID %>&mode=1" name="pinfo">
		</FRAMESET>
		<FRAME src="/webHains/contents/common/Blank.htm" name="detail" scrolling="auto">
	</FRAMESET>
</FRAMESET>

</HTML>