<%@ LANGUAGE="VBScript" %>
<%
Option Explicit

'�Z�b�V�����ؒf��ԂƂ��ă��O�C����ʂ�\������
Session.Abandon
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>�e�X�g���O�C��</TITLE>
<LINK REL=STYLESHEET TYPE="text/css" HREF="/webhains/contents/css/MentalHealth.css" TITLE="MentalHealth">
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
function login() {

	var myForm = document.frmLogin;	// ����ʂ̃t�H�[���G�������g
	
	//submit
	myForm.submit();
}
//-->
</SCRIPT>
</HEAD>

<BODY>
<FORM NAME="frmLogin" ACTION="mhControl.asp" METHOD="post">
<CENTER>
<H1>�e�X�g���O�C��</H1>
<HR ALIGN=center>
<TABLE CLASS='tableNomal'>
<TR>
	<TD CLASS='question'>���O�C���敪:</TD>
	<TD CLASS='question'>
		<INPUT TYPE='radio' NAME='LOGINKBN' VALUE='0' >Client
		<INPUT TYPE='radio' NAME='LOGINKBN' VALUE='1' >Doctor
	</TD>
</TR>
<TR>
	<TD CLASS='question'>�h�c:</TD>
	<TD CLASS='question'><INPUT TYPE='text' NAME='DAYID' MAXLENGTH='4' VALUE='' SIZE='4' ></TD>
</TR>
<TR>
	<TD CLASS='question'>�Ǘ��ԍ�:</TD>
	<TD CLASS='question'>
		<INPUT TYPE='text' NAME='CNTLNO' MAXLENGTH='10' VALUE='' SIZE='16' >
	</TD>
</TR>
<TR>
	<TD CLASS='question'>��f��:</TD>
	<TD CLASS='question'>
		<INPUT TYPE='text' NAME='CSLDATE' MAXLENGTH='10' VALUE='' SIZE='16' >
	</TD>
</TR>
<TR>
	<TD CLASS='question'>�\��ԍ�:</TD>
	<TD CLASS='question'>
		<INPUT TYPE='text' NAME='RSVNO' MAXLENGTH='10' VALUE='' SIZE='16' >
	</TD>
</TR>
</TABLE>
<BR><BR>
<A HREF="JavaScript:login()"><IMG SRC="/webhains/images/mental/login.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="���O�C��"></A>
<HR ALIGN=center>

</CENTER>
</FORM>
</BODY>
</HTML>
