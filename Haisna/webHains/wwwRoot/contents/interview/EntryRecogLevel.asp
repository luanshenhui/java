<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   認識レベルの登録  (Ver0.0.1)
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
Dim strGrpNo			'グループNo
Dim lngRsvNo			'予約番号（今回分）
Dim strCsCd				'コースコード

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
strWinMode			= Request("winmode")
strGrpNo			= Request("grpno")
lngRsvNo			= Request("rsvno")
strCsCd				= Request("cscd")

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML lang="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>認識レベルの登録</TITLE>
</HEAD>
<FRAMESET BORDER="0" FRAMESPACING="0" FRAMEBORDER="no" ROWS="<%=IIf(strWinMode=1,150,65)%>,*">
	<FRAME NAME="header" SRC="EntryRecogLevelHeader.asp?<%= Request.ServerVariables("QUERY_STRING") %>">
	<FRAME NAME="list"   SRC="EntryRecogLevelBody.asp?<%= Request.ServerVariables("QUERY_STRING") %>">
</FRAMESET>
</HTML>
