<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		ナビゲーションバー (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@FSIT
'-----------------------------------------------------------------------------
Option Explicit

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim strMode	'選択タブモード

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'引数値の取得
strMode = Request("mode")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>ナビゲーションバー</TITLE>
<%
	'モードの変更（タブを選択状態にする）
	Select Case strMode
		Case "rsv"	'予約タブ
			Response.Write "<STYLE TYPE=""text/css""><!-- td.rsvtab  { background-color:#FFFFFF } --> </STYLE>"
		Case "rsl"	'結果タブ
			Response.Write "<STYLE TYPE=""text/css""><!-- td.rsltab  { background-color:#FFFFFF } --> </STYLE>"
		Case "jud"	'判定タブ
			Response.Write "<STYLE TYPE=""text/css""><!-- td.judtab  { background-color:#FFFFFF } --> </STYLE>"
		Case "inq"	'結果参照タブ
			Response.Write "<STYLE TYPE=""text/css""><!-- td.inqtab  { background-color:#FFFFFF } --> </STYLE>"
		Case "prt"	'印刷タブ
			Response.Write "<STYLE TYPE=""text/css""><!-- td.prttab  { background-color:#FFFFFF } --> </STYLE>"
		Case "dmd"	'請求タブ
			Response.Write "<STYLE TYPE=""text/css""><!-- td.dmdtab  { background-color:#FFFFFF } --> </STYLE>"
		Case "data"	'データタブ
			Response.Write "<STYLE TYPE=""text/css""><!-- td.datatab { background-color:#FFFFFF } --> </STYLE>"
		Case "mnt"	'メンテナンスタブ
			Response.Write "<STYLE TYPE=""text/css""><!-- td.mnttab  { background-color:#FFFFFF } --> </STYLE>"
		Case "flw"	' フォローアップタブ
			Response.Write "<STYLE TYPE=""text/css""><!-- td.flwtab  { background-color:#FFFFFF } --> </STYLE>"
 		Case Else	'指定なし
	End Select
%>
<style>
body {background-color: #eee;}
</style>
</HEAD>
<BODY>
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
</BODY>
</HTML>
