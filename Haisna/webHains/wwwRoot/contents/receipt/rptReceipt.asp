<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		受付処理 (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const MODE_SAVE = "save"	'処理モード(保存)

'引数値
Dim strCslYear		'受診年
Dim strCslMonth 	'受診月
Dim strCslDay		'受診日
Dim lngReceiptMode	'受付処理モード
Dim lngDayId		'当日ＩＤ

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'引数値の取得
strCslYear     = Request("cslYear")
strCslMonth    = Request("cslMonth")
strCslDay      = Request("cslDay")
lngReceiptMode = CLng("0" & Request("receiptMode"))
lngDayId       = CLng("0" & Request("dayId"))
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>受付</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
function receipt() {

	with ( opener.top.main.document.entryForm ) {
		cslYear.value     = '<%= strCslYear     %>';
		cslMonth.value    = '<%= strCslMonth    %>';
		cslDay.value      = '<%= strCslDay      %>';
		receiptMode.value = '<%= lngReceiptMode %>';
		dayId.value       = '<%= lngDayId       %>';
	}

	// 予約情報詳細画面のsubmit処理
	opener.top.submitForm('<%= MODE_SAVE %>');

}
//-->
</SCRIPT>
</HEAD>
<BODY BGCOLOR="#ffffff" ONLOAD="javascript:receipt()">
</BODY>
</HTML>
