<%
'-----------------------------------------------------------------------------
'		結果一括入力(入力完了) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
If Request.ServerVariables("HTTP_REFERER") = "" Then
	Response.End
End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>入力完了</TITLE>
<STYLE TYPE="text/css">
td.rsltab { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="step4" ACTION="/webHains/contents/resultAllSet/rslAllSetStep5.asp" METHOD="post">
	<BLOCKQUOTE>

	<!-- 前画面(Step3)からの引継ぎ情報 -->

	<INPUT TYPE="hidden" NAME="date"  VALUE="<%= mstrCslDate %>">
	<INPUT TYPE="hidden" NAME="grpCd" VALUE="<%= mstrGrpCd %>">
	<INPUT TYPE="hidden" NAME="count" VALUE="<%= mlngOutCount %>">
<%
	For mlngIndex1 = 0 To mlngOutCount - 1
%>
		<INPUT TYPE="hidden" NAME="rsvNo" VALUE="<%= mstrOutRsvNo(mlngIndex1) %>">
<%
	Next
%>
	<!-- 表題 -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">入力完了</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'更新完了メッセージの編集
	If mlngUpdCount > 0 Then
		Call EditMessage("更新が完了しました。", MESSAGETYPE_NORMAL)
	End If
%>
	<BR>
<%
	'例外者選択時のアンカー編集
	If mlngOutCount > 0 Then
%>
		<A HREF="javascript:function voi(){};voi()" ONCLICK="document.step4.submit();return false">例外者結果入力へ</A><BR><BR>
<%
	End If
%>
	<A HREF="/webHains/contents/result/rslMenu.asp">メニューへ</A>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
