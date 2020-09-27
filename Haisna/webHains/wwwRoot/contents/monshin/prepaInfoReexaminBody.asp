<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   健診前準備（問診）前回総合コメント  (Ver0.0.1)
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


'再検査項目
Dim vntItemName			'検査項目名
Dim vntResult			'検査結果

Dim lngCount			'行数


Dim strColor			'背景色

Dim Ret					'復帰値
Dim i, j				'カウンター

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objInterview    = Server.CreateObject("HainsInterview.Interview")

'引数値の取得
lngRsvNo			= Request("rsvno")


Do


	'再検査項目取得
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
<TITLE>再検査項目_2</TITLE>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: 0 0 0 5px; }
</style>
</head>
<BODY>
		<TABLE WIDTH="188" BORDER="0" CELLSPACING="1" CELLPADDING="0">
<%
		For i = 0 To lngCount - 1
			If i mod 2 = 0 Then
				strColor = ""
			Else
				strColor = "#e0ffff"
			End If
%>
			<TR HEIGHT="17">
				<TD ALIGN="left" NOWRAP BGCOLOR="<%= strColor %>" WIDTH="120" HEIGHT="17"><%= vntItemName(i) %></TD>
				<TD ALIGN="left" NOWRAP BGCOLOR="<%= strColor %>" WIDTH="180" HEIGHT="17"><%= vntResult(i) %></TD>
			</TR>
<%
		Next
%>
		</TABLE>
	</BODY>
</HTML>