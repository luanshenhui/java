<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   健診前準備（問診） 再検査項目 ヘッダー  (Ver0.0.1)
'	   AUTHER  : K.Fujii@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
'Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'パラメータ

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>再検査項目_1</TITLE>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: 0 0 0 5px; }
</style>
</HEAD>
<BODY>
	<FORM NAME="entryForm" action="#">
		<TABLE WIDTH="100%" BO="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
			<TR>
				<TD NOWRAP BGCOLOR="#eeeeee" HEIGHT="15"><B><FONT COLOR="#333333">再検査項目</FONT></B></TD>
			</TR>
		</TABLE>
		<TABLE WIDTH="183" BORDER="0" CELLSPACING="1" CELLPADDING="0">
			<TR HEIGHT="16">
				<TD ALIGN="center" NOWRAP BGCOLOR="#dcdcdc" WIDTH="120" HEIGHT="16">健診項目名</TD>
				<TD ALIGN="center" NOWRAP BGCOLOR="#dcdcdc" WIDTH="180" HEIGHT="16">健診結果</TD>
			</TR>
		</TABLE>
	</FORM>
</BODY>