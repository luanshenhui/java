<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   健診前準備（問診）二次健診・受診歴・入院歴  (Ver0.0.1)
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
Dim objCommon			'共通クラス
Dim objInterview		'面接情報アクセス用

'パラメータ
Dim lngRsvNo			'予約番号


'二次健診・受診歴・入院歴
Dim vntCslDate			'受診日
Dim vntHistory			'内容

Dim lngCount			'行数


Dim strColor			'背景色

Dim Ret					'復帰値
Dim i, j				'カウンター

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objInterview    = Server.CreateObject("HainsInterview.Interview")

'引数値の取得
lngRsvNo			= Request("rsvno")


Do

	'二次健診・受診歴・入院歴取得
	lngCount = 0

	Exit Do
Loop

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>二次健診・受診歴・入院歴</TITLE>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: 0 0 0 15px; }
</style>
</HEAD>
<BODY>
<TABLE WIDTH="250" BORDER="0" CELLSPACING="1" CELLPADDING="0">
<%
For i = 0 To lngCount - 1
	If i mod 2 = 0 Then
		strColor = ""
	Else
		strColor = "#e0ffff"
	End If
%>
	<TR HEIGHT="17">
		<TD ALIGN="left" NOWRAP BGCOLOR="<%= strColor %>" WIDTH="90" HEIGHT="17"><%= vntCslDate %></TD>
		<TD ALIGN="left" NOWRAP BGCOLOR="<%= strColor %>" WIDTH="160" HEIGHT="17"><%= vntHistory(i) %></TD>
	</TR>
<%
Next
%>
</TABLE>
</BODY>
</HTML>