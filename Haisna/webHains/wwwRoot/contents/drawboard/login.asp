<%@ LANGUAGE="VBScript" %>
<%
Option Explicit
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>�e�X�g���O�C��</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
function login() {
	var TargetURL
	var myForm = document.frmLogin;	// ����ʂ̃t�H�[���G�������g
	
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
<H1>�e�X�g���O�C��</H1>
<HR ALIGN=center>
<TABLE>
<TR>
	<TD>�f�ÉȖ�:</TD>
	<TD>
		<INPUT TYPE='text' NAME='MEDICALDEPARTMENTNAME' MAXLENGTH='8' VALUE='CNS' SIZE='16' >
<!--
		<INPUT TYPE='radio' NAME='MEDICALDEPARTMENTNAME' VALUE='CNS' CHECKED >�]�_�o�O��
-->
	</TD>
</TR>
<TR>
	<TD>����:</TD>
	<TD>
		<INPUT TYPE='text' NAME='PART' MAXLENGTH='8' VALUE='HTCS1' SIZE='16' >
<!--
		<INPUT TYPE='radio' NAME='PART' VALUE='HTCS1' CHECKED >�������f�ʐ}
-->
	</TD>
</TR>
<TR>
	<TD>���Ҕԍ�:</TD>
	<TD>
		<INPUT TYPE='text' NAME='PATIENTNO' MAXLENGTH='8' VALUE='00000001' SIZE='16' >
	</TD>
</TR>
<TR>
	<TD>�摜���ʎq:</TD>
	<TD>
		<INPUT TYPE='text' NAME='PICTUREDISCERNMENT' MAXLENGTH='10' VALUE='2001-04-04' SIZE='16' >
	</TD>
</TR>
</TABLE>
<A HREF="http://172.16.2.101/drawboard_0_61/drawboard.asp?MEDICALDEPARTMENTNAME=CNS&PART=HTCS1&PATIENTNO=00000001&PICTUREDISCERNMENT=2001-04-04">HLINK</A>
<BR><BR>
<A HREF="JavaScript:login()"><IMG SRC="./login.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="���O�C��"></A>
<HR ALIGN=center>

</CENTER>
</FORM>
</BODY>
</HTML>
