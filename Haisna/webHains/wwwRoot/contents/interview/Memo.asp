<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   メモ入力 (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Dim lnglineno			'行番号
Dim strItemCd			'検査項目コード
Dim strSuffix			'サフィックス
Dim lngItemType			'項目タイプ
Dim strItemName			'検査項目名称
Dim strResult			'検査結果

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
lnglineno			= Request("lineno")
strItemCd			= Request("itemcd")
strSuffix			= Request("suffix")
lngItemType			= Request("itemtype")
strItemName			= Request("itemname")
strResult			= Request("result")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>メモ入力</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">

<!--
// メモ入力画面の確定
function MemoOk() {
	var		myForm = document.entryForm;	// フォームエレメント

	// 呼び元ウィンドウが存在しなければ何もしない
	if ( opener == null ) {
		return;
	}

	opener.setSentenceInfo( <%= lnglineno %>, myForm.Memo.value, myForm.Memo.value );
	opener.winMemo = null;
	close();

	return;
}
//-->
</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: 10px 0 0 10px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="" METHOD="get">
	<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
		<TR>
			<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">メモ入力</FONT></B></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="2" WIDTH="100%">
		<TR>
			<TD NOWRAP HEIGHT="40">検査項目：</TD>
			<TD NOWRAP><FONT COLOR="#ff6600"><B><%=strItemName%></B></FONT></TD>
			<TD NOWRAP WIDTH="100%" ALIGN="right"><A HREF="JavaScript:MemoOk()"><IMG SRC="../../images/ok.gif" HEIGHT="24" WIDTH="77" ALT="この内容で確定する"></TD>
			<TD NOWRAP><A HREF="JavaScript:close()"><IMG SRC="../../images/cancel.gif" HEIGHT="24" WIDTH="77" ALT="キャンセルする"></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="2" WIDTH="100%">
		<TR>
			<TD><TEXTAREA NAME="Memo" ROWS="10" COLS="40"><%= strResult %></TEXTAREA></TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>
