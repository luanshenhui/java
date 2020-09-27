<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		定性結果ガイド (Ver0.0.1)
'		AUTHER  : Chikaishi Yumi@takumatec.co.jp
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
Dim strResultType	'結果タイプ

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
strResultType = Request("resulttype")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>定性結果ガイド</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
function selectList(index) {

		// 呼び元ウィンドウが存在しなければ何もしない
	if ( opener == null ) {
		return false;
	}


	//定性結果名
	if ( opener.tseGuide_Result != null ) {
		if ( opener.tseGuide_ResultType == 1 ){
			if (index ==  0 ) {
				opener.tseGuide_Result = '-';

			}
	    	if (index == 1 ){
				opener.tseGuide_Result = '+-';

			}
			if (index == 2 ) {
				opener.tseGuide_Result = '+';

			}
	    	
		}
		else{
			if (index ==  0 ) {
				opener.tseGuide_Result = '-';

			}
	    	if (index == 1 ){
				opener.tseGuide_Result = '+-';

			}
			if (index == 2 ){
				opener.tseGuide_Result = '+';

			}
	    	if (index == 3 ){
				opener.tseGuide_Result = '2+';

			}
			if (index == 4 ) {
				opener.tseGuide_Result = '3+';

			}
	    	if (index == 5 ){
				opener.tseGuide_Result = '4+';

			}
			if (index == 6 ) {
				opener.tseGuide_Result = '5+';

			}
	    	if (index == 7 ){
				opener.tseGuide_Result = '6+';
	
			}
			if (index == 8 ) {
				opener.tseGuide_Result = '7+';

			}
	   	 	if (index == 9 ){
				opener.tseGuide_Result = '8+';
			
			}
			if (index == 10 ) {
				opener.tseGuide_Result = '9+';
			
			}
        }

	}

	// 連絡域に設定されてある親画面の関数呼び出し
	if ( opener.tseGuide_CalledFunction != null ) {
		opener.tseGuide_CalledFunction();
	}

	opener.winGuideTse = null;
	close();

	return false;

}
//-->
</SCRIPT>
</HEAD>

<BODY BGCOLOR="#FFFFFF">

<!-- <STYLE TYPE="text/css">
	A:hover   { color: #000000; background-color:#99CCFF; }
</STYLE> -->
<FORM NAME="conditon" ACTION="ctrOrgList.asp">

	定性結果を選択してください。<BR><BR>

	<IMG ALIGN="left" SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1">

	<TABLE CELLSPACING="0" CELLPADDING="1" BORDER="0">
<% If strResultType = "1" Then %>
		<TR>
			<TD><A HREF="JavaScript:selectList(0)" CLASS="guideItem"><B>-&nbsp;&nbsp;&nbsp;</B></A></TD>
		</TR>
		<TR>
			<TD><A HREF="JavaScript:selectList(1)" CLASS="guideItem"><B>+-&nbsp;&nbsp;</B></A></TD>
		</TR>
		<TR>
			<TD><A HREF="JavaScript:selectList(2)" CLASS="guideItem"><B>+&nbsp;&nbsp;</B></A></TD>
		</TR>
<% End If %>
<% If strResultType = "2" Then %>
		<TR>
			<TD><A HREF="JavaScript:selectList(0)" CLASS="guideItem"><B>-&nbsp;&nbsp;&nbsp;</B></A></TD>
		</TR>
		<TR>
			<TD><A HREF="JavaScript:selectList(1)" CLASS="guideItem"><B>+-&nbsp;&nbsp;</B></A></TD>
		</TR>
		<TR>
			<TD><A HREF="JavaScript:selectList(2)" CLASS="guideItem"><B>+&nbsp;&nbsp;</B></A></TD>
		</TR>
		<TR>
			<TD><A HREF="JavaScript:selectList(3)" CLASS="guideItem"><B>2+&nbsp;&nbsp;</B></A></TD>
		</TR>
		<TR>
			<TD><A HREF="JavaScript:selectList(4)" CLASS="guideItem"><B>3+&nbsp;&nbsp;</B></A></TD>
		</TR>
		<TR>
			<TD><A HREF="JavaScript:selectList(5)" CLASS="guideItem"><B>4+&nbsp;&nbsp;</B></A></TD>
		</TR>
		<TR>
			<TD><A HREF="JavaScript:selectList(6)" CLASS="guideItem"><B>5+&nbsp;&nbsp;</B></A></TD>
		</TR>
		<TR>
			<TD><A HREF="JavaScript:selectList(7)" CLASS="guideItem"><B>6+&nbsp;&nbsp;</B></A></TD>
		</TR>
		<TR>
			<TD><A HREF="JavaScript:selectList(8)" CLASS="guideItem"><B>7+&nbsp;&nbsp;</B></A></TD>
		</TR>
		<TR>
			<TD><A HREF="JavaScript:selectList(9)" CLASS="guideItem"><B>8+&nbsp;&nbsp;</B></A></TD>
		</TR>
		<TR>
			<TD><A HREF="JavaScript:selectList(10)" CLASS="guideItem"><B>9+&nbsp;&nbsp;</B></A></TD>
		</TR>
<% End If%>
	</TABLE>	
	<BR>
	<A HREF="JavaScript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセルする"></A>
</FORM>
</BODY>
</HTML>