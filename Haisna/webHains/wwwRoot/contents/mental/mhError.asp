<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�����^���w���X�@�G���[��ʕ\������(Ver0.0.1)
'		AUTHER  : S.Sugie@C's
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!--#INCLUDE VIRTUAL="/webhains/includes/mental/mhCommon.inc"-->
<%
'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">

<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>�y�[�W��\���ł��܂���</TITLE>
<LINK REL=STYLESHEET TYPE="text/css" HREF=<%=MH_StyleSheet%> TITLE="MentalHealth">
</HEAD>

<BODY>
<CENTER>
<FORM NAME="Error" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<HR ALIGN=center>
<DIV CLASS='title' NOWRAP>�G���[���������܂���</DIV>
<HR ALIGN=center>
<BR>
<TABLE>
<TR><TD CLASS='error' NOWRAP><%=Session("ErrorMsg1")%></TD></TR>
<TR><TD CLASS='error' NOWRAP><%=Session("ErrorMsg2")%></TD></TR>
</TABLE>

<BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR>
<BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR>
<HR ALIGN=center>
<A HREF="JavaScript:close()"><IMG SRC=<%=MH_ImagePath & "end.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="�I��"></A>
</FORM>
</CENTER>
<HR ALIGN=center>
<BR>
</BODY>
</HTML>
