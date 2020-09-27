<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		項目ガイド(文字列検索部) (Ver0.0.1)
'		AUTHER  : Toyonobu Manabe@takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
Dim i
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>項目ガイド</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// 先頭文字列情報の制御。頭文字のONCLICKイベントから呼び出される。
function controlSearchChar( searchChar ) {

	// メイン部の検索条件保持用変数にキー値をセット
	top.gdeSearchChar = searchChar;

	// リスト部の再検索関数呼び出し
	top.setParamToList();

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 10px 0 0 10px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryform" ACTION="">
<!--
	<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1" STYLE="font-size:13px;">
		<TR BGCOLOR="#eeeeee" ALIGN="center">
			<TD BGCOLOR="#ffffff" NOWRAP>名前で検索：</TD>
<%
			For i = Asc("A") To Asc("O")
%>
				<TD WIDTH="14"><B><A HREF="javascript:controlSearchChar('<%= Chr(i) %>')" CLASS="guideItem"><%= Chr(i) %></A></B></TD>
<%
			Next
%>
		</TR>
		<TR BGCOLOR="#eeeeee" ALIGN="center">
			<TD BGCOLOR="#ffffff"></TD>
<%
			For i = Asc("P") To Asc("Z")
%>
				<TD WIDTH="14"><B><A HREF="javascript:controlSearchChar('<%= Chr(i) %>')" CLASS="guideItem"><%= Chr(i) %></A></B></TD>
<%
			Next
%>
			<TD BGCOLOR="#ffffff"></TD>
			<TD COLSPAN="3"><B><A HREF="javascript:controlSearchChar('*')" CLASS="guideItem">その他</A></B></TD>
		</TR>
		<TR>
			<TD HEIGHT="8"></TD>
		</TR>
		<TR BGCOLOR="#eeeeee" ALIGN="center">
			<TD BGCOLOR="#ffffff"></TD>
			<TD WIDTH="14"><B><A HREF="javascript:controlSearchChar('あ')" CLASS="guideItem">あ</A></B></TD>
			<TD WIDTH="14"><B><A HREF="javascript:controlSearchChar('か')" CLASS="guideItem">か</A></B></TD>
			<TD WIDTH="14"><B><A HREF="javascript:controlSearchChar('さ')" CLASS="guideItem">さ</A></B></TD>
			<TD WIDTH="14"><B><A HREF="javascript:controlSearchChar('た')" CLASS="guideItem">た</A></B></TD>
			<TD WIDTH="14"><B><A HREF="javascript:controlSearchChar('な')" CLASS="guideItem">な</A></B></TD>
			<TD WIDTH="14"><B><A HREF="javascript:controlSearchChar('は')" CLASS="guideItem">は</A></B></TD>
			<TD WIDTH="14"><B><A HREF="javascript:controlSearchChar('ま')" CLASS="guideItem">ま</A></B></TD>
			<TD WIDTH="14"><B><A HREF="javascript:controlSearchChar('や')" CLASS="guideItem">や</A></B></TD>
			<TD WIDTH="14"><B><A HREF="javascript:controlSearchChar('ら')" CLASS="guideItem">ら</A></B></TD>
			<TD WIDTH="14"><B><A HREF="javascript:controlSearchChar('わ')" CLASS="guideItem">わ</A></B></TD>
		</TR>
		<TR>
			<TD HEIGHT="8"></TD>
		</TR>
		<TR BGCOLOR="#eeeeee" ALIGN="center">
			<TD BGCOLOR="#ffffff"></TD>
<%
			For i = Asc("0") To Asc("9")
%>
				<TD WIDTH="14"><B><A HREF="javascript:controlSearchChar('<%= Chr(i) %>')" CLASS="guideItem"><%= Chr(i) %></A></B></TD>
<%
			Next
%>
			<TD COLSPAN="2" BGCOLOR="#ffffff"></TD>
			<TD COLSPAN="3"><B><A HREF="javascript:controlSearchChar('')" CLASS="guideItem">すべて</A></B></TD>
		</TR>
	</TABLE>
-->
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" ALIGN="right">
		<TR>
			<TD><A HREF="javascript:top.selectList()"><IMG SRC="/webHains/images/ok.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="選択した検査項目で確定"></A></TD>
			<TD WIDTH="5"></TD>
			<TD><A HREF="javascript:top.close()"><IMG SRC="/webHains/images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="キャンセルする"></A></TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>
