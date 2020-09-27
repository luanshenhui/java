<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		メンタルヘルス　エラー画面表示処理(Ver0.0.1)
'		AUTHER  : S.Sugie@C's
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!--#INCLUDE VIRTUAL="/webhains/includes/mental/mhCommon.inc"-->
<%
'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">

<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>ページを表示できません</TITLE>
<LINK REL=STYLESHEET TYPE="text/css" HREF=<%=MH_StyleSheet%> TITLE="MentalHealth">
</HEAD>

<BODY>
<CENTER>
<FORM NAME="Error" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<HR ALIGN=center>
<DIV CLASS='title' NOWRAP>エラーが発生しました</DIV>
<HR ALIGN=center>
<BR>
<TABLE>
<TR><TD CLASS='error' NOWRAP><%=Session("ErrorMsg1")%></TD></TR>
<TR><TD CLASS='error' NOWRAP><%=Session("ErrorMsg2")%></TD></TR>
</TABLE>

<BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR>
<BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR>
<HR ALIGN=center>
<A HREF="JavaScript:close()"><IMG SRC=<%=MH_ImagePath & "end.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="終了"></A>
</FORM>
</CENTER>
<HR ALIGN=center>
<BR>
</BODY>
</HTML>
