<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		面接支援ヘッダ表示 (Ver0.0.1)
'		AUTHER  : H.Kamata@FFCS
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'前画面から送信されるパラメータ値
Dim strRsvNo		'予約番号
Dim lngIndex		'インデックス（画面選択コンボ）

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
strRsvNo    = Request("rsvno")
lngIndex    = Request("index")

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="x-ua-compatible" content="IE=10" >
<TITLE>面接支援ヘッダ</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<STYLE TYPE="text/css">
td.prttab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY>
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<!-- #include virtual = "/webHains/includes/interviewHeader.inc" -->
<%
	'面接支援ヘッダーインクルードを呼ぶ
	Call interviewHeader(strRsvNo, 1)
%>
<SCRIPT TYPE="text/javascript">
<!--
	var myForm =	document.headerForm;
	myForm.selecturl.selectedIndex = '<%= lngIndex %>';
//-->
</SCRIPT>
</BODY>
</HTML>
