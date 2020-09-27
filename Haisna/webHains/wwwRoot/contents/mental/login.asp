<%@ LANGUAGE="VBScript" %>
<%
Option Explicit

'セッション切断状態としてログイン画面を表示する
Session.Abandon
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>テストログイン</TITLE>
<LINK REL=STYLESHEET TYPE="text/css" HREF="/webhains/contents/css/MentalHealth.css" TITLE="MentalHealth">
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
function login() {

	var myForm = document.frmLogin;	// 自画面のフォームエレメント
	
	//submit
	myForm.submit();
}
//-->
</SCRIPT>
</HEAD>

<BODY>
<FORM NAME="frmLogin" ACTION="mhControl.asp" METHOD="post">
<CENTER>
<H1>テストログイン</H1>
<HR ALIGN=center>
<TABLE CLASS='tableNomal'>
<TR>
	<TD CLASS='question'>ログイン区分:</TD>
	<TD CLASS='question'>
		<INPUT TYPE='radio' NAME='LOGINKBN' VALUE='0' >Client
		<INPUT TYPE='radio' NAME='LOGINKBN' VALUE='1' >Doctor
	</TD>
</TR>
<TR>
	<TD CLASS='question'>ＩＤ:</TD>
	<TD CLASS='question'><INPUT TYPE='text' NAME='DAYID' MAXLENGTH='4' VALUE='' SIZE='4' ></TD>
</TR>
<TR>
	<TD CLASS='question'>管理番号:</TD>
	<TD CLASS='question'>
		<INPUT TYPE='text' NAME='CNTLNO' MAXLENGTH='10' VALUE='' SIZE='16' >
	</TD>
</TR>
<TR>
	<TD CLASS='question'>受診日:</TD>
	<TD CLASS='question'>
		<INPUT TYPE='text' NAME='CSLDATE' MAXLENGTH='10' VALUE='' SIZE='16' >
	</TD>
</TR>
<TR>
	<TD CLASS='question'>予約番号:</TD>
	<TD CLASS='question'>
		<INPUT TYPE='text' NAME='RSVNO' MAXLENGTH='10' VALUE='' SIZE='16' >
	</TD>
</TR>
</TABLE>
<BR><BR>
<A HREF="JavaScript:login()"><IMG SRC="/webhains/images/mental/login.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="ログイン"></A>
<HR ALIGN=center>

</CENTER>
</FORM>
</BODY>
</HTML>
