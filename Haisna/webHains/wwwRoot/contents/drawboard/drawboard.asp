<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�V�F�[�}�N������(Ver0.0.1)
'		AUTHER  : S.Sugie@C's
'-----------------------------------------------------------------------------
Option Explicit 
'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�󂯎��p�����[�^
Dim strMedicalDepartmentName	'�f�ÉȖ�
Dim strPart						'����
Dim strPatientNo				'���Ҕԍ�
Dim strPictureDiscernment		'�摜���ʎq

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�p�����[�^�̎擾
strMedicalDepartmentName = Request("MEDICALDEPARTMENTNAME")
strPart = Request("PART")
strPatientNo = Request("PATIENTNO")
strPictureDiscernment = Request("PICTUREDISCERNMENT")
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
	<TITLE>DrawBoard</TITLE>
</HEAD>

<BODY BGCOLOR="#666666" TEXT="#DCDCDC" LINK="#C0FFF2" ALINK="#C0FFF2" VLINK="#C0FFF2">
<TABLE WIDTH=600>
<TR><TD>
<APPLET ARCHIVE="drawboard.jar" CODE="drawboard/Main.class" WIDTH=600 HEIGHT=450 >

<!--<PARAM NAME="port" VALUE="">-->

<PARAM NAME="MedicalDepartmentName" VALUE="<%=strMedicalDepartmentName%>">
<PARAM NAME="Part" VALUE="<%=strPart%>">
<PARAM NAME="PatientNo" VALUE="<%=strPatientNo%>">
<PARAM NAME="PictureDiscernment" VALUE="<%=strPictureDiscernment%>">

Unfortunatelly, your browser doesn't support Java applets. You have to
use another one.
</APPLET>
</TD></TR></TABLE>
<!--
<BR>
-->
<CENTER>
<A HREF="JavaScript:close()"><IMG SRC=<%="./end.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="�I��"></A>
</CENTER>

<!--
strMedicalDepartmentName = '<%=strMedicalDepartmentName%>'<BR>
strPart = '<%=strPart%>'<BR>
strPatientNo = '<%=strPatientNo%>'<BR>
strPictureDiscernment = '<%=strPictureDiscernment%>'<BR>
-->
</BODY>
</HTML>
