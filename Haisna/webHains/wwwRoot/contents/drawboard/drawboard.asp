<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		シェーマ起動処理(Ver0.0.1)
'		AUTHER  : S.Sugie@C's
'-----------------------------------------------------------------------------
Option Explicit 
'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'受け取りパラメータ
Dim strMedicalDepartmentName	'診療科名
Dim strPart						'部位
Dim strPatientNo				'患者番号
Dim strPictureDiscernment		'画像識別子

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'パラメータの取得
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
<A HREF="JavaScript:close()"><IMG SRC=<%="./end.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="終了"></A>
</CENTER>

<!--
strMedicalDepartmentName = '<%=strMedicalDepartmentName%>'<BR>
strPart = '<%=strPart%>'<BR>
strPatientNo = '<%=strPatientNo%>'<BR>
strPictureDiscernment = '<%=strPictureDiscernment%>'<BR>
-->
</BODY>
</HTML>
