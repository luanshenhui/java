<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   生活習慣ヘッダ  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'パラメータ
Dim	strWinMode			'ウィンドウモード
Dim lngRsvNo			'予約番号（今回分）

Dim strAct				'処理状態
Dim strUrlPara			'フレームへのパラメータ

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
strAct              = Request("action")
strWinMode			= Request("winmode")
lngRsvNo			= Request("rsvno")



'フレームへのパラメータ設定
strUrlPara = "?winmode=" & strWinMode 
strUrlPara = strUrlPara & "&rsvno=" & lngRsvNo
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>問診入力</TITLE>
<script type="text/javascript">
var params = {
    action:  "<%= strAct %>",
    rsvno:   "<%= lngRsvNo %>",
    winmode: "<%= strWinMode %>"
};
</script>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
</HEAD>
<FRAMESET BORDER="0" FRAMESPACING="0" FRAMEBORDER="no" ROWS="<%=IIf(strWinMode=1,130,65)%>,*">
	<FRAME NAME="header" SRC="MonshinNyuryokuHeader.asp<%=strUrlPara%>">
	<FRAME NAME="bodyview"  SRC="MonshinNyuryokuBody.asp<%=strUrlPara%>">
</FRAMESET>
</HTML>
