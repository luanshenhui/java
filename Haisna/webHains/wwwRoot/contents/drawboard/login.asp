<%@ LANGUAGE="VBScript" %>
<%
Option Explicit
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>テストログイン</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
function login() {
	var TargetURL
	var myForm = document.frmLogin;	// 自画面のフォームエレメント
	
	TargetURL = "drawboard.asp" 
	TargetURL += "?MEDICALDEPARTMENTNAME=" + myForm.MEDICALDEPARTMENTNAME.value
	TargetURL += "&PART=" + myForm.PART.value
	TargetURL += "&PATIENTNO=" + myForm.PATIENTNO.value
	TargetURL += "&PICTUREDISCERNMENT=" + myForm.PICTUREDISCERNMENT.value

	newWin = open (TargetURL,"DrawBoard","toolbar=no,directories=no,menubar=no,resizable=yes,width=630,height=520" ,"replace =false" );

}
//-->
</SCRIPT>
</HEAD>

<BODY>
<FORM NAME="frmLogin" action="#">
<CENTER>
<H1>テストログイン</H1>
<HR ALIGN=center>
<TABLE>
<TR>
	<TD>診療科名:</TD>
	<TD>
		<INPUT TYPE='text' NAME='MEDICALDEPARTMENTNAME' MAXLENGTH='8' VALUE='CNS' SIZE='16' >
<!--
		<INPUT TYPE='radio' NAME='MEDICALDEPARTMENTNAME' VALUE='CNS' CHECKED >脳神経外科
-->
	</TD>
</TR>
<TR>
	<TD>部位:</TD>
	<TD>
		<INPUT TYPE='text' NAME='PART' MAXLENGTH='8' VALUE='HTCS1' SIZE='16' >
<!--
		<INPUT TYPE='radio' NAME='PART' VALUE='HTCS1' CHECKED >頭部横断面図
-->
	</TD>
</TR>
<TR>
	<TD>患者番号:</TD>
	<TD>
		<INPUT TYPE='text' NAME='PATIENTNO' MAXLENGTH='8' VALUE='00000001' SIZE='16' >
	</TD>
</TR>
<TR>
	<TD>画像識別子:</TD>
	<TD>
		<INPUT TYPE='text' NAME='PICTUREDISCERNMENT' MAXLENGTH='10' VALUE='2001-04-04' SIZE='16' >
	</TD>
</TR>
</TABLE>
<A HREF="http://172.16.2.101/drawboard_0_61/drawboard.asp?MEDICALDEPARTMENTNAME=CNS&PART=HTCS1&PATIENTNO=00000001&PICTUREDISCERNMENT=2001-04-04">HLINK</A>
<BR><BR>
<A HREF="JavaScript:login()"><IMG SRC="./login.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="ログイン"></A>
<HR ALIGN=center>

</CENTER>
</FORM>
</BODY>
</HTML>
